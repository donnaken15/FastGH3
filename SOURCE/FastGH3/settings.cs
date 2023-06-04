using System.Windows.Forms;
using System.IO;
using System;
using System.Drawing;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using Nanook.QueenBee.Parser;
using System.Security.Principal;
using System.Collections.Generic;

public partial class settings : Form
{
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINTL
    {
        [MarshalAs(UnmanagedType.I4)]
        public int x;
        [MarshalAs(UnmanagedType.I4)]
        public int y;
    }
    [StructLayout(LayoutKind.Sequential,
    CharSet = CharSet.Ansi)]
    public struct DEVMODE
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string dmDeviceName;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 dmSpecVersion;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 dmDriverVersion;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 dmSize;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 dmDriverExtra;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmFields;
        public POINTL dmPosition;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmDisplayOrientation;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmDisplayFixedOutput;
        [MarshalAs(UnmanagedType.I2)]
        public Int16 dmColor;
        [MarshalAs(UnmanagedType.I2)]
        public Int16 dmDuplex;
        [MarshalAs(UnmanagedType.I2)]
        public Int16 dmYResolution;
        [MarshalAs(UnmanagedType.I2)]
        public Int16 dmTTOption;
        [MarshalAs(UnmanagedType.I2)]
        public Int16 dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string dmFormName;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 dmLogPixels;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmBitsPerPel;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmPelsWidth;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmPelsHeight;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmDisplayFlags;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmDisplayFrequency;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmICMMethod;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmICMIntent;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmMediaType;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmDitherType;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmReserved1;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmReserved2;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmPanningWidth;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 dmPanningHeight;
    }

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern Boolean EnumDisplaySettings(
            [param: MarshalAs(UnmanagedType.LPTStr)]
            string lpszDeviceName,
            [param: MarshalAs(UnmanagedType.U4)]
            int iModeNum,
            [In, Out]
            ref DEVMODE lpDevMode);

    private static string[] bgcol, diffs = { "Easy", "Medium", "Hard", "Expert" };
    private static Color backcolor;

    private static bool disableEvents = false, filesafe;

    private static QbFile userqb;//, bootqb;
    //private static QbItemStruct player1;
    private static QbItemQbKey p1diff, p2diff, p1part, p2part;
    /*private static QbItemInteger hyperspeed, btncheats,
        backcolrgb, viewmode, nofailv;*/
    private static QbItemInteger backcolrgb, autostart;
    //private static QbItemFloat speedf;
    private static QbKey[] diffCRCs = {
        QbKey.Create(0xB69D6568), QbKey.Create(0x398CBA48),
        QbKey.Create(0x3EEAE02D), QbKey.Create(0xB0E46CBD)
    }, partCRCs = {
        QbKey.Create(0xBDC53CF2), QbKey.Create(0x7A7D1DCA)
    };
    private static List<Size> resz = new List<Size>();
    private static PakFormat pakformat;
    private static PakEditor qbedit;
    private static Size oldres;

    private static string folder = Environment.CurrentDirectory;

    private static IniFile ini = new IniFile();

    bool verboselog2;

    static void verbose(object text)
    {
        Program.verbose(text);
    }

    static void verboseline(object text)
    {
        Program.verboseline(text);
    }

    private void saveQb()
    {
        userqb.AlignPointers();
        qbedit.ReplaceFile("config.qb", userqb);
    }

    const bool FRAMERATE_FROM_QB = true; // set accordingly in the FastGH3 plugin

    public settings(IniFile _ini)
    {
        Console.SetWindowSize(80,32);
        ini = _ini;
        if (ini.GetSection("Player") == null)
        {
            ini.AddSection("Player");
        }
        if (ini.GetSection("Misc") == null)
        {
            ini.AddSection("Misc");
        }
        verboselog2 = ini.GetKeyValue("Misc", "VerboseLog", "0") == "1";
        verboseline("Loading QBs...");
        pakformat = new PakFormat(folder + "\\files\\user.pak.ngc", folder + "\\files\\user.pak.xen", "", PakFormatType.PC, false);
        qbedit = new PakEditor(pakformat, false);
        userqb = qbedit.ReadQbFile("config.qb");
        disableEvents = true;
        Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
        backcolrgb = (QbItemInteger)
        userqb.FindItem(QbKey.Create("BGCol"), false).Items[0];
        backcolor = Color.FromArgb(255,
            backcolrgb.Values[0],
            backcolrgb.Values[1],
            backcolrgb.Values[2]);
        DialogResult = DialogResult.OK;
        InitializeComponent();
        SetForegroundWindow(Handle);
        verboseline("Reading settings...");
        //tweaksList.SetItemChecked((int)Tweaks.KeyboardMode, (int)getQBConfig(QbKey.Create(0x32025D94), 1) == 0); // autolaunch_startnow
        readytimeNoIntro.Value = (int)getQBConfig(QbKey.Create(0x5FB765A2), 400); // nointro_ready_time
        hypers.Value = (int)getQBConfig(QbKey.Create(0xFD6B13B4), 0); // Cheat_Hyperspeed
        //tweaksList.SetItemChecked((int)Tweaks.NoIntro, (int)getQBConfig(QbKey.Create(0xDF7FF31B), 0) == 1); // disable_intro
        {
            int disable_particles = (int)getQBConfig(QbKey.Create(0xD403A7A7), 0); // disable_particles
            CheckState state = CheckState.Unchecked;
            switch (disable_particles)
            {
                case 0:
                    state = CheckState.Unchecked;
                    break;
                case 1:
                    state = CheckState.Indeterminate;
                    break;
                default:
                case 2:
                    state = CheckState.Checked;
                    break;
            }
            //tweaksList.SetItemCheckState((int)Tweaks.NoParticles, state);
        }
        /*tweaksList.SetItemChecked((int)Tweaks.NoFail, (int)getQBConfig(QbKey.Create(0x3E5FD611), 0) == 1); // Cheat_NoFail
        if (tweaksList.GetItemChecked((int)Tweaks.NoIntro))
        {
            readytimeNoIntro.Enabled = true;
            readytimelbl.Enabled = true;
            readytimems.Enabled = true;
        }
        tweaksList.SetItemChecked((int)Tweaks.DebugMenu, (int)getQBConfig(QbKey.Create(0x2AF92804), 0) == 1); // enable_button_cheats
        speed.Value = (decimal/*wtf*)(float)getQBConfig(QbKey.Create(0x16D91BC1), 1.0f) * 100; // current_speedfactor*/
        tweaksList.SetItemChecked((int)Tweaks.VerboseLog, verboselog2);
        /*backgroundcolordiag.Color = backcolor;
        colorpanel.BackColor = backcolor;
        tweaksList.SetItemChecked((int)Tweaks.ExitOnSongEnd, (int)getQBConfig(QbKey.Create(0x045713D3), 0) == 1); // exit_on_song_end
        tweaksList.SetItemChecked((int)Tweaks.DisableVsync, ini.GetKeyValue("Misc", "VSync", "1") == "0");*/
        tweaksList.SetItemChecked((int)Tweaks.SongCaching, ini.GetKeyValue("Misc", "SongCaching", "1") == "1");
        tweaksList.SetItemChecked((int)Tweaks.NoStartupMsg, ini.GetKeyValue("Misc", "NoStartupMsg", "0") == "1");
        tweaksList.SetItemChecked((int)Tweaks.PreserveLog, ini.GetKeyValue("Misc", "PreserveLog", "0") == "1");
        //tweaksList.SetItemChecked((int)Tweaks.BkgdVideo, (int)getQBConfig(QbKey.Create(0x633E187F), 0) == 1); // enable_video
        //tweaksList.SetItemChecked((int)Tweaks.Windowed, ini.GetKeyValue("Misc", "Windowed", "1") == "1");
        //tweaksList.SetItemChecked((int)Tweaks.Borderless, ini.GetKeyValue("Misc", "Borderless", "1") == "1");
        /*tweaksList.SetItemChecked((int)Tweaks.KillHitGems, (int)getQBConfig(QbKey.Create(0xC50E4995), 0) == 1); // kill_gems_on_hit
        tweaksList.SetItemChecked((int)Tweaks.EarlySustains, (int)getQBConfig(QbKey.Create(0xF88A8D5D), 0) == 1); // anytime_sustain_activation*/
        //tweaksList.SetItemChecked((int)Tweaks.NoShake, (int)getQBConfig(QbKey.Create("disable_shake"), 0) == 1);
        //p1diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_diff"), false);
        //p2diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_diff"), false);
        //p1part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_part"), false);
        //p2part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_part"), false);
        // WTF C#
        if ((QbKey)getQBConfig(QbKey.Create("p1_diff"), QbKey.Create("expert")) == diffCRCs[0].Crc)
            diff.Text = "Easy";
        else if((QbKey)getQBConfig(QbKey.Create("p1_diff"), QbKey.Create("expert")) == diffCRCs[1].Crc)
            diff.Text = "Medium";
        else if ((QbKey)getQBConfig(QbKey.Create("p1_diff"), QbKey.Create("expert")) == diffCRCs[2].Crc)
            diff.Text = "Hard";
        else if ((QbKey)getQBConfig(QbKey.Create("p1_diff"), QbKey.Create("expert")) == diffCRCs[3].Crc)
            diff.Text = "Expert";
        if ((QbKey)getQBConfig(QbKey.Create("p1_part"), QbKey.Create("guitar")) == partCRCs[0].Crc)
            part.SelectedIndex = 0;
        else// if (p1part.Values[0].Crc == partCRCs[1].Crc)
            part.SelectedIndex = 1;
        if ((QbKey)getQBConfig(QbKey.Create("p2_part"), QbKey.Create("rhythm")) == partCRCs[1].Crc)
            p2parttoggle.Checked = false;
        else
            p2parttoggle.Checked = true;
        // A CONSTANT VALUE IS EXPECTED STFU!!!!!!!!!
        /*switch (p1diff.Values[0].Crc)
        {
            case diffCRCs[0].Crc:
                break;
            case diffCRCs[1].Crc:
                break;
            case diffCRCs[2].Crc:
                break;
            case diffCRCs[3].Crc:
                break;
        // also looks redundant when i could use a loop maybe
        }*/
        disableEvents = false;
    }

    void changeDiff(int difficulty)
    {
        if (disableEvents)
            return;
        SuspendLayout();
        setQBConfig(QbKey.Create("p1_diff"), diffCRCs[difficulty]);
        setQBConfig(QbKey.Create("p2_diff"), diffCRCs[difficulty]);
        saveQb();
        ResumeLayout();
    }

    private void diff_SelectedIndexChanged(object sender, EventArgs e)
    {
        changeDiff(diff.SelectedIndex);
    }

    private void creditlink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
    {
        Console.Clear();
        Console.WriteLine(FastGHWii.Properties.Resources.credits);
    }

    private void hypers_ValueChanged(object sender, EventArgs e)
    {
        if (disableEvents)
            return;
        {
            SuspendLayout();
            setQBConfig(QbKey.Create("Cheat_Hyperspeed"), Convert.ToInt32(hypers.Value));
            saveQb();
            ResumeLayout();
        }
    }

    private void setbgcolor_Click(object sender, EventArgs e)
    {
        if (backgroundcolordiag.ShowDialog() == DialogResult.OK)
        {
            SuspendLayout();
            backcolrgb.Values[0] = backgroundcolordiag.Color.R;
            backcolrgb.Values[1] = backgroundcolordiag.Color.G;
            backcolrgb.Values[2] = backgroundcolordiag.Color.B;
            saveQb();
            ResumeLayout();
            colorpanel.BackColor = backgroundcolordiag.Color;
        }
    }

    private void tooltip_Popup(object sender, PopupEventArgs e)
    {

    }

    private void ok_Click(object sender, EventArgs e)
    {
        DialogResult = DialogResult.OK;
    }

    private void loadingtext_Click(object sender, EventArgs e)
    {

    }

    private void settings_FormClosing(object sender, FormClosingEventArgs e)
    {
    }

    private void Colorpanel_MouseDoubleClick()
    {
        new colorpreview(colorpanel.BackColor).ShowDialog();
    }

    private void colorpanel_Click(object sender, EventArgs e)
    {
        new colorpreview(colorpanel.BackColor).ShowDialog();
    }

    private void ctmpb_Click(object sender, EventArgs e)
    {
        string tmpf = folder + "\\files\\CACHE";
        string[] tmpds;
        //string[] tmpds = Directory.GetDirectories(tmpf, "*", SearchOption.TopDirectoryOnly);
        string[] tmpfs = Directory.GetFiles(Path.GetTempPath(), "*.tmp.fsp", SearchOption.TopDirectoryOnly);
        /*foreach (string folder in tmpds)
        {
            //string[] whycs = Directory.GetFiles(folder, "*.*", SearchOption.AllDirectories);
            //foreach (string whycs2 in whycs)
            //{
                //File.Delete(whycs2);
            //}
            Directory.Delete(folder, true);
        }*/
        foreach (string file in tmpfs)
            File.Delete(file);

        tmpds = Directory.GetDirectories(Path.GetTempPath(), "Aspyr* FastGH3", SearchOption.TopDirectoryOnly);
        foreach (string folder in tmpds)
            Directory.Delete(folder, true);

        tmpfs = Directory.GetFiles(Path.GetTempPath(), "libSoX.tmp.*", SearchOption.TopDirectoryOnly);
        foreach (string file in tmpfs)
            File.Delete(file);
        if (File.Exists(folder + "\\files\\CACHE\\.db.ini"))
        {
            IniFile cache = new IniFile();
            cache.Load(folder + "\\files\\CACHE\\.db.ini");
            int sectCount = 0;
            string[] stupidEnumerasdaewrhygio = new string[cache.Sections.Count];
            foreach (IniFile.IniSection sect in cache.Sections)
            {
                if (sect.Name.StartsWith("URL") || sect.Name.StartsWith("ZIP"))
                {
                    stupidEnumerasdaewrhygio[sectCount] = sect.Name;
                    sectCount++;
                }
            }
            for (int i = 0; i < sectCount; i++)
            {
                cache.RemoveSection(stupidEnumerasdaewrhygio[i]);
                cache.Save(folder + "\\files\\CACHE\\.db.ini");
            }
        }
    }

    // this wont work after focusing control
    private void keydownreacts(object sender, KeyEventArgs e)
    {
        //base.OnKeyDown(e);

        if (e.KeyCode == Keys.Escape)
        {
            Application.Exit();
        }
    }
    private void viewsongcache_Click(object sender, EventArgs e)
    {
        Directory.CreateDirectory(folder + "\\files\\CACHE");
        new songcache().ShowDialog();
    }

    void ToggleINIItem(string sect, string key, bool toggle)
    {
        ini.SetKeyValue(sect, key, (toggle ? "1" : "0"));
        ini.Save("settings.ini");
    }

    string miscSection = "Misc";

    private void songtxtfmt__Click(object sender, EventArgs e)
    {
        songtxtfmt formatInterface = new songtxtfmt(ini.GetKeyValue(miscSection, "SongtextFormat", "%a - %t").Replace("\\n", Environment.NewLine));
        formatInterface.ShowDialog();
        if (formatInterface.DialogResult == DialogResult.OK)
        {
            ini.SetKeyValue(miscSection, "SongtextFormat", formatInterface.format.Replace(Environment.NewLine, "\\n"));
            ini.Save("settings.ini");
        }
    }

    private void updateTweakBoxes(object sender, EventArgs e)
    {
    }

    public enum Tweaks
    {
        SongCaching,
        VerboseLog,
        PreserveLog,
        NoStartupMsg,
        //DebugMenu,
        //NoIntro,
        //NoParticles,
        //NoFail,
        ////NoShake,
        ////Lefty,
        //KillHitGems,
        //EarlySustains
    }

    private void changereadytime(object sender, EventArgs e)
    {
        setQBConfig(QbKey.Create("nointro_ready_time"), (int)readytimeNoIntro.Value);
    }
    public string[] modNames = new string[]
    {
        "AllStrums",
        "AllDoubles",
        "AllTaps",
        "Hopos2Taps",
        "Mirror",
        "ColorShuffle"
    };

    public enum Modifiers
    {
        AllStrums,
        AllDoubles,
        AllTaps,
        Hopos2Taps,
        Mirror,
        ColorShuffle
    }

    private void modifierUpdate(object sender, ItemCheckEventArgs e)
    {
        if (disableEvents)
            return;
        ToggleINIItem("Modifiers", modNames[e.Index], e.NewValue == CheckState.Checked);
        ini.Save("settings.ini");
    }

    private void updateModifiersList(object sender, EventArgs e)
    {

    }

    private void inputChanged(object sender, ItemCheckEventArgs e)
    {
        if (disableEvents)
            return;
        switch ((Tweaks)e.Index)
        {
            // stupid control won't let me do it more efficiently
            // im so suicidal
            case Tweaks.SongCaching:
                ToggleINIItem(miscSection, "SongCaching", e.NewValue == CheckState.Checked);
                break;
            case Tweaks.VerboseLog:
                ToggleINIItem(miscSection, "VerboseLog", e.NewValue == CheckState.Checked);
                break;
            case Tweaks.PreserveLog:
                ToggleINIItem(miscSection, "PreserveLog", e.NewValue == CheckState.Checked);
                break;
            case Tweaks.NoStartupMsg:
                ToggleINIItem(miscSection, "NoStartupMsg", e.NewValue == CheckState.Checked);
                break;
            // try replacing these with like changeConfig(index)
            // and a string/key array accessed with index
            // and funnel these cases into it
            /*case Tweaks.NoIntro:
                readytimeNoIntro.Enabled = e.NewValue == CheckState.Checked;
                readytimelbl.Enabled = e.NewValue == CheckState.Checked;
                readytimems.Enabled = e.NewValue == CheckState.Checked;
                // "control cannot fall into another case" WHY
                setQBConfig(QbKey.Create(0xDF7FF31B), // disable_intro
                            (e.NewValue == CheckState.Checked) ? 1 : 0);
                break;
            case Tweaks.ExitOnSongEnd:
                setQBConfig(QbKey.Create(0x045713D3), // exit_on_song_end
                            (e.NewValue == CheckState.Checked) ? 1 : 0);
                break;
            case Tweaks.DebugMenu:
                setQBConfig(QbKey.Create(0x2AF92804), // enable_button_cheats
                            (e.NewValue == CheckState.Checked) ? 1 : 0);
                // how do i invert the ternary with the bool array
                break;
            case Tweaks.KeyboardMode:
                setQBConfig(QbKey.Create(0x32025D94), // autolaunch_startnow
                            (e.NewValue == CheckState.Checked ? 0 : 1));
                break;
            case Tweaks.NoParticles:
                int disable_particles = 0;
                switch (e.CurrentValue)
                {
                    // set to...
                    case CheckState.Unchecked:
                        e.NewValue = CheckState.Indeterminate;
                        disable_particles = 1;
                        // minimal particles
                        // no hit sparks or stars
                        break;
                    case CheckState.Indeterminate:
                        e.NewValue = CheckState.Checked;
                        disable_particles = 2;
                        // disabled particles
                        // above with flames and lightning off
                        break;
                    case CheckState.Checked:
                        e.NewValue = CheckState.Unchecked;
                        disable_particles = 0;
                        // all particles
                        break;
                        // HEY LOOK IT'S MINECRAFT!!11!!!1!
                }
                setQBConfig(QbKey.Create(0xD403A7A7), disable_particles);
                break;
            case Tweaks.NoFail: // Cheat_NoFail
                setQBConfig(QbKey.Create(0x3E5FD611), e.NewValue == CheckState.Checked ? 1 : 0);
                int[] zoffs = { 20, 21 };
                int _invert = (e.NewValue == CheckState.Checked ? 1 : -1);
                QbItemInteger thiscodesucks =
                (QbItemInteger)
                    (userqb.FindItem(QbKey.Create("Nofailvis"), false));
                QbItemInteger thiscodesucks2 =
                (QbItemInteger)
                    (userqb.FindItem(QbKey.Create("Nofailvis2"), false));
                thiscodesucks.Values[0] = zoffs[0] * _invert;
                thiscodesucks2.Values[0] = zoffs[1] * _invert;
                saveQb();
                break;
            //case Tweaks.Lefty:
                //setQBConfig(QbKey.Create("p1_lefty"), e.NewValue == CheckState.Checked ? 1 : 0);
                //break;
            /*case Tweaks.NoShake:
                setQBConfig(QbKey.Create("disable_shake"), e.NewValue == CheckState.Checked ? 0 : 1);
                break;*
            case Tweaks.KillHitGems:
                setQBConfig(QbKey.Create(0xC50E4995), e.NewValue == CheckState.Checked ? 1 : 0); // kill_gems_on_hit
                break;
            case Tweaks.EarlySustains:
                setQBConfig(QbKey.Create(0xF88A8D5D), e.NewValue == CheckState.Checked ? 1 : 0); // anytime_sustain_activation
                break;*/
        }
    }

    object getQBConfig(QbKey key, object def)
    {
        // find matching item's value or use a default
        // we're only accessing global/root items with this
        object _item = (userqb.FindItem(key, false));
        if (_item != null)
        {
            switch ((_item as QbItemBase).QbItemType)
            {
                case QbItemType.SectionInteger:
                    return (_item as QbItemInteger).Values[0];
                case QbItemType.SectionFloat:
                    return (_item as QbItemFloat).Values[0];
                case QbItemType.SectionString:
                    return (_item as QbItemString).Strings[0];
                case QbItemType.SectionQbKey:
                    return (_item as QbItemQbKey).Values[0];
            }
        }
        return def;
    }

    void setQBConfig(QbKey key, object value)
    {
        // find or create value
        object _item = (userqb.FindItem(key, false));
        Type type = value.GetType();
        if (_item == null)
        {
            switch (Type.GetTypeCode(type))
            {
                case TypeCode.Int32:
                    {
                        QbItemInteger item = new QbItemInteger(userqb);
                        item.Create(QbItemType.SectionInteger);
                        item.ItemQbKey = key;
                        userqb.AddItem(item);
                    }
                    break;
                case TypeCode.Single:
                case TypeCode.Double:
                    {
                        QbItemFloat item = new QbItemFloat(userqb);
                        item.Create(QbItemType.SectionFloat); // *
                        item.ItemQbKey = key;
                        userqb.AddItem(item);
                    }
                    break;
                case TypeCode.String:
                    {
                        QbItemString item = new QbItemString(userqb);
                        item.Create(QbItemType.SectionString); // *
                        item.ItemQbKey = key;
                        userqb.AddItem(item);
                    }
                    break;
            }
            if (value is QbKey)
            {
                QbItemQbKey item = new QbItemQbKey(userqb);
                item.Create(QbItemType.SectionQbKey); // *
                item.ItemQbKey = key;
                userqb.AddItem(item);
            }
        }
        _item = userqb.FindItem(key, false); // weird
        try
        {
            switch (Type.GetTypeCode(type))
            {
                case TypeCode.Int32:
                    (_item as QbItemInteger).Values[0] = (int)value;
                    break;
                case TypeCode.Single:
                case TypeCode.Double:
                    (_item as QbItemFloat).Values[0] = (float)value;
                    break;
                case TypeCode.String:
                    (_item as QbItemString).Strings[0] = (string)value;
                    break;
            }
            if (value is QbKey)
            {
                (_item as QbItemQbKey).Values[0] = (QbKey)value;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Failed to set user QB value.");
            Console.WriteLine(ex);
        }
        saveQb();
    }

    private void speed_ValueChanged(object sender, EventArgs e)
    {
        SuspendLayout();
        setQBConfig(QbKey.Create("current_speedfactor"), float.Parse((speed.Value / 100).ToString()));
        ResumeLayout();
    }

    private void replaygame_Click(object sender, EventArgs e)
    {
        Process gh3 = new Process();
        gh3.StartInfo.WorkingDirectory = folder + "\\";
        gh3.StartInfo.FileName = folder + "\\play.bat";
        gh3.Start();
    }

    private void part_SelectedIndexChanged(object sender, EventArgs e)
    {
        SuspendLayout();
        setQBConfig(QbKey.Create("p1_part"), partCRCs[part.SelectedIndex]);
        saveQb();
        ResumeLayout();
    }

    private void p2parttoggle_Click(object sender, EventArgs e)
    {
        if (disableEvents)
            return;
        SuspendLayout();
        int part = 1;
        if (p2parttoggle.Checked)
            part = 0;
        setQBConfig(QbKey.Create("p2_part"), partCRCs[part]);
        saveQb();
        ResumeLayout();
    }
}
