using System.Windows.Forms;
using System.IO;
using System;
using System.Drawing;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using Nanook.QueenBee.Parser;
using System.Xml;
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

    private static string xmlpath = Environment.GetEnvironmentVariable("USERPROFILE") + "\\AppData\\Local\\Aspyr\\FastGH3\\AspyrConfig.xml",
        xmlDefault = FastGH3.Properties.Resources.xmlDefault,
        pak = "\\DATA\\PAK\\";
    public XmlDocument xml = new XmlDocument();
    public XmlNode xmlCfg;
    public XmlNode xmlW, xmlH, xmlK;

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

    void changeRes(string width, string height)
    {
        if (!disableEvents)
        {
            xmlW.InnerText = width;
            xmlH.InnerText = height;
            xml.Save(xmlpath);
            // am i doing this right
        }
    }

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

    static uint Eswap(uint value)
    {
        return ((value & 0xFF) << 24) |
                ((value & 0xFF00) << 8) |
                ((value & 0xFF0000) >> 8) |
                ((value & 0xFF000000) >> 24);
    }

    static ushort Eswap(ushort value)
    {
        return (ushort)(((value & 0xFF) << 8) | ((value & 0xFF00) >> 8));
    }

    static byte LOBYTE(ushort value)
    {
        return (byte)(value & 0xFF);
    }

    static byte HIBYTE(ushort value)
    {
        return (byte)(value >> 8);
    }

    // https://www.c-sharpcorner.com/UploadFile/ishbandhu2009/resize-an-image-in-C-Sharp/
    private static Image resizeImage(Image imgToResize, Size size)
    {
        int destWidth = size.Width;
        int destHeight = size.Height;
        Bitmap b = new Bitmap(destWidth, destHeight);
        Graphics g = Graphics.FromImage(b);
        g.DrawImage(imgToResize, 0, 0, destWidth, destHeight);
        g.Dispose();
        return b;
    }

    private static PakFormat globalPF;
    private static PakEditor globalPE;
    public static Image bgImg;
    Image getBGIMG()
    {
        //if (globalPE == null)
            //return null;
        byte[] tmp = globalPE.ExtractFileToBytes("24535078");
        //uint imgoff = 0x28;
        //int imglen = tmp.Length - imgoff;
        uint imgoff = Eswap(BitConverter.ToUInt32(tmp, 0x1C));
        uint imglen = Eswap(BitConverter.ToUInt32(tmp, 0x20));
        byte[] imgbytes = new byte[imglen];
        Array.Copy(tmp,imgoff,imgbytes,0,imglen);
        //Console.WriteLine(BitConverter.ToString(imgbytes, 0, 0x28));
        if (BitConverter.ToUInt32(imgbytes, 0) != 0x20534444)
            return Image.FromStream(new MemoryStream(imgbytes), true);
        else
            return DDS.DDSImage.Load(imgbytes).Images[0];
    }
    void setBGIMG(Image i, bool reconvert)
    {
        var ms = new MemoryStream();
        ms.Write(
            new byte[] {
                0x0A, 0x28, 0x11, 0x00,
                0x00, 0x00, 0x00, 0x00,
            }, 0, 8);
        byte[] dims = new byte[] {
            HIBYTE((ushort)i.Width), LOBYTE((ushort)i.Width),
            HIBYTE((ushort)i.Height), LOBYTE((ushort)i.Height),
        };
        ms.Write(dims, 0, 4);
        ms.WriteByte(0x00);
        ms.WriteByte(0x01);
        ms.Write(dims, 0, 4);
        ms.Write(
            new byte[] {
                0x00, 0x01, 0x01, 0x08, 0x05, 0x00
            }, 0, 6);
        ms.Write(
            new byte[] {
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x28,
            }, 0, 8);
        long lenptr = ms.Position;
        ms.Write(
            new byte[] {
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00,
            }, 0, 8);
        System.Drawing.Imaging.ImageFormat fmt = i.RawFormat;
        if (reconvert)
            fmt = System.Drawing.Imaging.ImageFormat.Jpeg;
        i.Save(ms, fmt);
        long strsize = ms.Position - 0x28;
        ms.Position = lenptr;
        ms.Write(BitConverter.GetBytes(Eswap((uint)strsize)),0,4);
        globalPE.ReplaceFile("24535078", ms.ToArray());
        //File.WriteAllBytes("DATA\\test22.img.xen",ms.ToArray());
    }

    int[] keyBinds = new int[] {
        (int)KeyID.D1,
        (int)KeyID.D2,
        (int)KeyID.D3,
        (int)KeyID.D4,
        (int)KeyID.D5,
        (int)KeyID.RShift,
        (int)KeyID.Escape,
        (int)KeyID.Back,
        235,
        (int)KeyID.Down,
        (int)KeyID.Up,
        (int)KeyID.Escape,
        (int)KeyID.RCtrl,
    };

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
        pakformat = new PakFormat(folder + "\\DATA\\user.pak.xen", folder + "\\DATA\\user.pak.xen", "", PakFormatType.PC, false);
        qbedit = new PakEditor(pakformat, false);
        userqb = qbedit.ReadQbFile("config.qb");
        disableEvents = true;
        if (File.Exists(xmlpath))
        {
            File.Open(xmlpath, FileMode.OpenOrCreate).Close();
            //xml = File.ReadAllText(xmlpath);
            xml.Load(xmlpath);
        }
        else
            xml.LoadXml(xmlDefault);
        //Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
        backcolrgb = (QbItemInteger)
        userqb.FindItem(QbKey.Create("BGCol"), false).Items[0];
        backcolor = Color.FromArgb(255,
            backcolrgb.Values[0],
            backcolrgb.Values[1],
            backcolrgb.Values[2]);
        DialogResult = DialogResult.OK;
        InitializeComponent();

        globalPF = new PakFormat(folder + "\\DATA\\ZONES\\global.pak.xen", folder + "\\DATA\\ZONES\\global.pab.xen", "", PakFormatType.PC, false);
        globalPE = new PakEditor(globalPF, false);
        pbxBg.Image = getBGIMG();
        //setBGIMG(pbxBg.Image, false);

        SetForegroundWindow(Handle);
        verboseline("Reading settings...");
        tweaksList.SetItemChecked((int)Tweaks.KeyboardMode, (int)getQBConfig(QbKey.Create(0x32025D94), 1) == 0); // autolaunch_startnow
        readytimeNoIntro.Value = (int)getQBConfig(QbKey.Create(0x5FB765A2), 400); // nointro_ready_time
#pragma warning disable CS0162
        if (FRAMERATE_FROM_QB)
            maxFPS.Value = (int)getQBConfig(QbKey.Create(0xCEFC2AEF), 500); // fps_max
        else
            maxFPS.Value = Convert.ToInt32(ini.GetKeyValue("Player", "MaxFPS", "500"));
#pragma warning restore CS0162
        hypers.Value = (int)getQBConfig(QbKey.Create(0xFD6B13B4), 0); // Cheat_Hyperspeed
        tweaksList.SetItemChecked((int)Tweaks.NoIntro, (int)getQBConfig(QbKey.Create(0xDF7FF31B), 0) == 1); // disable_intro
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
            tweaksList.SetItemCheckState((int)Tweaks.NoParticles, state);
        }
        tweaksList.SetItemChecked((int)Tweaks.NoFail, (int)getQBConfig(QbKey.Create(0x3E5FD611), 0) == 1); // Cheat_NoFail
        if (tweaksList.GetItemChecked((int)Tweaks.NoIntro))
        {
            readytimeNoIntro.Enabled = true;
            readytimelbl.Enabled = true;
            readytimems.Enabled = true;
        }
        tweaksList.SetItemChecked((int)Tweaks.DebugMenu, (int)getQBConfig(QbKey.Create(0x2AF92804), 0) == 1); // enable_button_cheats
        speed.Value = (decimal/*wtf*/)(float)getQBConfig(QbKey.Create(0x16D91BC1), 1.0f) * 100; // current_speedfactor
        tweaksList.SetItemChecked((int)Tweaks.VerboseLog, verboselog2);
        backgroundcolordiag.Color = backcolor;
        colorpanel.BackColor = backcolor;
        tweaksList.SetItemChecked((int)Tweaks.ExitOnSongEnd, (int)getQBConfig(QbKey.Create(0x045713D3), 0) == 1); // exit_on_song_end
        tweaksList.SetItemChecked((int)Tweaks.DisableVsync, ini.GetKeyValue("Misc", "VSync", "1") == "0");
        tweaksList.SetItemChecked((int)Tweaks.SongCaching, ini.GetKeyValue("Misc", "SongCaching", "1") == "1");
        tweaksList.SetItemChecked((int)Tweaks.NoStartupMsg, ini.GetKeyValue("Misc", "NoStartupMsg", "0") == "1");
        tweaksList.SetItemChecked((int)Tweaks.PreserveLog, ini.GetKeyValue("Misc", "PreserveLog", "0") == "1");
        tweaksList.SetItemChecked((int)Tweaks.BkgdVideo, (int)getQBConfig(QbKey.Create(0x633E187F), 0) == 1); // enable_video
        tweaksList.SetItemChecked((int)Tweaks.Windowed, ini.GetKeyValue("Misc", "Windowed", "1") == "1");
        tweaksList.SetItemChecked((int)Tweaks.Borderless, ini.GetKeyValue("Misc", "Borderless", "1") == "1");
        tweaksList.SetItemChecked((int)Tweaks.KillHitGems, (int)getQBConfig(QbKey.Create(0xC50E4995), 0) == 1); // kill_gems_on_hit
        tweaksList.SetItemChecked((int)Tweaks.EarlySustains, (int)getQBConfig(QbKey.Create(0xF88A8D5D), 0) == 1); // anytime_sustain_activation
        //tweaksList.SetItemChecked((int)Tweaks.NoShake, (int)getQBConfig(QbKey.Create("disable_shake"), 0) == 1);
        for (int i = 0; i < modNames.Length; i++)
        {
            modifiersList.SetItemChecked(i, ini.GetKeyValue("Modifiers", modNames[i], "0") == "1");
        }
        //<s id="6f1d2b61d5a011cfbfc7444553540000">201 202 203 204 205 311 999 219 235 400 401 999 307 </s>
        xmlCfg = xml.GetElementsByTagName("r")[0];
        foreach (XmlNode s in xmlCfg.ChildNodes)
        {
            switch (s.Attributes["id"].Value)
            {
                case "Video.Width":
                    oldres.Width = Convert.ToInt32(s.InnerText);
                    xmlW = s;
                    break;
                case "Video.Height":
                    oldres.Height = Convert.ToInt32(s.InnerText);
                    xmlH = s;
                    break;
                case "6f1d2b61d5a011cfbfc7444553540000":
                    string[] keybindsStr = s.InnerText.Split(" ".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                    xmlK = s;
                    for (int i = 0; i < keyBinds.Length; i++)
                    {
                        keyBinds[i] = Convert.ToInt32(keybindsStr[i]);
                    }
                    break;
            }
        }
        if (xmlW == null)
        {
            xmlW = xml.CreateElement("s");
            oldres.Width = 1024;
            xmlW.InnerText = "1024";
            XmlAttribute stupid2 = xml.CreateAttribute("id");
            stupid2.Value = "Video.Width";
            xmlW.Attributes.Append(stupid2);
            xmlCfg.AppendChild(xmlW);
        }
        if (xmlH == null)
        {
            xmlH = xml.CreateElement("s");
            oldres.Height = 768;
            xmlH.InnerText = "768";
            XmlAttribute stupid2 = xml.CreateAttribute("id");
            stupid2.Value = "Video.Height";
            xmlH.Attributes.Append(stupid2);
            xmlCfg.AppendChild(xmlH);
        }
        if (xmlK == null)
        {
            xmlK = xml.CreateElement("s");
            xmlK.InnerText = "201 202 203 204 205 311 999 219 235 400 401 999 307 ";
            XmlAttribute stupid2 = xml.CreateAttribute("id");
            stupid2.Value = "6f1d2b61d5a011cfbfc7444553540000";
            xmlK.Attributes.Append(stupid2);
            xmlCfg.AppendChild(xmlK);
        }
        DEVMODE mode = new DEVMODE();
        mode.dmSize = (ushort)Marshal.SizeOf(mode);
        int d = 0;
        while (EnumDisplaySettings(null, d++, ref mode) == true) // Succeeded  
        {
            Size newSz = new Size((int)mode.dmPelsWidth, (int)mode.dmPelsHeight);
            bool diff = true;
            Size[] cantwork = { // why
                new Size(640, 480),
                new Size(720, 480),
                new Size(720, 576),
            };
            foreach (Size res_ in resz)
            {
                if (res_ == newSz)
                {
                    diff = false;
                    break;
                }
            }
            foreach (Size res_ in cantwork)
            {
                if (res_ == newSz)
                {
                    diff = false;
                    break;
                }
            }
            if (diff)
                resz.Add(newSz);
        }
        foreach (Size sz in resz)
        {
            res.Items.Add(sz.Width.ToString() + "x" + sz.Height.ToString());
        }
        res.Text = oldres.Width.ToString() + "x" + oldres.Height.ToString();
        //if (ini.GetSection("Player") == null)
        {
            if (ini.GetKeyValue("Player", "MaxNotesAuto", "0") == "0")
                maxnotes.Value = int.Parse(ini.GetKeyValue("Player", "MaxNotes", "1048576"));
            else
                maxnotes.Value = -1;
        }
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
        
    private void res_SelectedIndexChanged(object sender, EventArgs e)
    {
        changeRes(resz[res.SelectedIndex].Width.ToString(), resz[res.SelectedIndex].Height.ToString());
    }

    private void diff_SelectedIndexChanged(object sender, EventArgs e)
    {
        changeDiff(diff.SelectedIndex);
    }

    private void creditlink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
    {
        Console.Clear();
        Console.WriteLine(FastGH3.Properties.Resources.credits);
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
        string tmpf = folder + "\\DATA\\CACHE";
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
        if (File.Exists(folder + "\\DATA\\CACHE\\.db.ini"))
        {
            IniFile cache = new IniFile();
            cache.Load(folder + "\\DATA\\CACHE\\.db.ini");
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
                cache.Save(folder + "\\DATA\\CACHE\\.db.ini");
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

    private void pluginmanage_Click(object sender, EventArgs e)
    {
        new dllman().ShowDialog();
    }

    private void viewsongcache_Click(object sender, EventArgs e)
    {
        Directory.CreateDirectory(folder + "\\DATA\\CACHE");
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
        DisableVsync,
        NoStartupMsg,
        ExitOnSongEnd,
        DebugMenu,
        KeyboardMode,
        Windowed,
        Borderless,
        NoIntro,
        NoParticles,
        NoFail,
        //NoShake,
        //Lefty,
        BkgdVideo,
        KillHitGems,
        EarlySustains
    }

    private void changereadytime(object sender, EventArgs e)
    {
        setQBConfig(QbKey.Create("nointro_ready_time"), (int)readytimeNoIntro.Value);
    }

    private void maxFPSchange(object sender, EventArgs e)
    {
#pragma warning disable CS0162 // Unreachable code detected
        if (FRAMERATE_FROM_QB)
            setQBConfig(QbKey.Create("fps_max"), (int)maxFPS.Value);
        else
        {
            ini.SetKeyValue("Player", "MaxFPS", maxFPS.Value.ToString());
            ini.Save("settings.ini");
        }
#pragma warning restore CS0162 // Unreachable code detected
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

    private void showBgImg(object sender, EventArgs e)
    {
        new bgprev(getBGIMG()).ShowDialog();
    }

    private void setbgimg_Click(object sender, EventArgs e)
    {
        selectImage0.ShowDialog();
    }

    // https://math.stackexchange.com/a/3381750
    int nearestPowOf2(int x)
    {
        // 2^round(log2(x))
        return (int)Math.Pow(2,Math.Round(Math.Log(x, 2)));
    }
    bool IsPowerOfTwo(int x)
    {
        return (x & (x - 1)) == 0;
    }
    private void confirmImageReplace(object sender, System.ComponentModel.CancelEventArgs e)
    {
        Image img = Image.FromFile(selectImage0.FileName);
        bool needResizing = false;
        int newWidth = img.Width;
        int newHeight = img.Height;
        if (!IsPowerOfTwo(img.Width))
        {
            needResizing = true;
            newWidth = nearestPowOf2(img.Width);
        }
        if (!IsPowerOfTwo(img.Height))
        {
            needResizing = true;
            newHeight = nearestPowOf2(img.Height);
        }
        if (needResizing)
        {
            img = resizeImage(img, new Size(newWidth, newHeight));
        }
        //img.Save("DATA\\test33.png");
        pbxBg.Image = img;
        setBGIMG(img,needResizing);
    }

    private void resetbgcol(object sender, EventArgs e)
    {
        backcolrgb.Values[0] = 255;
        backcolrgb.Values[1] = 255;
        backcolrgb.Values[2] = 255;
        saveQb();
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

    private void openKeybinds(object sender, EventArgs e)
    {
        keyEdit keyChange = new keyEdit(keyBinds);
        //foreach (int a in keyBinds)
            //MessageBox.Show(a.ToString());
        if (keyChange.ShowDialog() == DialogResult.OK)
        {
            keyBinds = keyChange.keyBinds;
            string keystring = "";
            foreach (int k in keyBinds)
            {
                keystring += k.ToString() + " ";
            }
            xmlK.InnerText = keystring;
            xml.Save(xmlpath);
        }
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
            case Tweaks.Windowed:
                ToggleINIItem(miscSection, "Windowed", e.NewValue == CheckState.Checked);
                break;
            case Tweaks.Borderless:
                ToggleINIItem(miscSection, "Borderless", e.NewValue == CheckState.Checked);
                break;
            case Tweaks.DisableVsync:
                ToggleINIItem(miscSection, "VSync", e.NewValue == CheckState.Unchecked);
                break;
            // try replacing these with like changeConfig(index)
            // and a string/key array accessed with index
            // and funnel these cases into it
            case Tweaks.NoIntro:
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
            case Tweaks.BkgdVideo:
                setQBConfig(QbKey.Create(0x633E187F), e.NewValue == CheckState.Checked ? 1 : 0); // enable_video
                break;
            /*case Tweaks.NoShake:
                setQBConfig(QbKey.Create("disable_shake"), e.NewValue == CheckState.Checked ? 0 : 1);
                break;*/
            case Tweaks.KillHitGems:
                setQBConfig(QbKey.Create(0xC50E4995), e.NewValue == CheckState.Checked ? 1 : 0); // kill_gems_on_hit
                break;
            case Tweaks.EarlySustains:
                setQBConfig(QbKey.Create(0xF88A8D5D), e.NewValue == CheckState.Checked ? 1 : 0); // anytime_sustain_activation
                break;
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

    private void maxnotes_ValueChanged(object sender, EventArgs e)
    {
        if (disableEvents == false)
        {
            if (maxnotes.Value == 0)
            {
                ini.SetKeyValue("Player", "MaxNotes", "4000");
                maxnotes.Value = 4000;
            }
            if (maxnotes.Value == -1)
                ini.SetKeyValue("Player", "MaxNotesAuto", "1");
            else
            {
                ini.SetKeyValue("Player", "MaxNotesAuto", "0");
                ini.SetKeyValue("Player", "MaxNotes", maxnotes.Value.ToString());
            }
            ini.Save("settings.ini");
        }
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
        gh3.StartInfo.FileName = folder + "\\game.exe";
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
