using System.Windows.Forms;
using System.IO;
using System;
using System.Drawing;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using Nanook.QueenBee.Parser;
using System.Security.Principal;

namespace FastGH3
{
    public partial class settings : Form
    {
        [DllImport("USER32.DLL")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        
        [DllImport("USER32.DLL", CharSet = CharSet.Unicode)]
        public static extern IntPtr FindWindow(string lpClassName,
                string lpWindowName);

        [DllImport("user32.dll")]
        public static extern UInt32 SendMessage
                (IntPtr hWnd, UInt32 msg, IntPtr wParam, IntPtr lParam);

        private static string xmlpath = Environment.GetEnvironmentVariable("USERPROFILE") + "\\AppData\\Local\\Aspyr\\FastGH3\\AspyrConfig.xml",
            xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<r>\n<s id=\"Video.Width\">1024</s>\n<s id=\"Video.Height\">768</s>\n<s id=\"Options.GraphicsQuality\">1</s>\n<s id=\"Options.Crowd\">0</s>\n<s id=\"Options.Physics\">0</s>\n<s id=\"Options.Flares\">0</s>\n<s id=\"Options.FrontRowCamera\">1</s>\n<s id=\"AudioLagReminderShown\">1</s>\n<s id=\"Sound.SongSkew\">-0.1</s>\n</r>\n", pak = "\\DATA\\PAK\\";

        private static string[] bgcol, diffs = { "Easy", "Medium", "Hard", "Expert" };
        private static Color backcolor;

        private static bool disableEvents = false, filesafe;

        private static QbFile guitarqb, hudqb, crowdqb;//, bootqb;
        private static QbItemStruct player1;
        private static QbItemQbKey curdiff, curdiff2, p1part;
        private static QbItemInteger hyperspeed, btncheats,
            backcolrgb, viewmode, autostart, nofailv;
        private static QbItemFloat speedf;
        private static QbKey[] diffCRCs = {
            QbKey.Create(0xB69D6568), QbKey.Create(0x398CBA48),
            QbKey.Create(0x3EEAE02D), QbKey.Create(0xB0E46CBD)
        }, partCRCs = {
            QbKey.Create(0xBDC53CF2), QbKey.Create(0x7A7D1DCA)
        };
        private static Size[] resz = {
                new Size( 800,  600),
                new Size(1024,  768),
                new Size(1152,  864),
                new Size(1176,  664),
                new Size(1280,  720),
                new Size(1280,  768),
                new Size(1280,  800),
                new Size(1280,  960),
                new Size(1280, 1024),
                new Size(1360,  768),
                new Size(1366,  768),
                new Size(1440,  900),
                new Size(1600,  900),
                new Size(1600, 1024),
                new Size(1600, 1200),
                new Size(1680, 1050),
                new Size(1768,  992),
                new Size(1920, 1080),
                new Size(1920, 1200),
                new Size(2048, 1536),
                new Size(2560, 1440),
                new Size(2560, 1600),
                new Size(3840, 2160),
            };
        private static PakFormat pakformat;
        private static PakEditor qbedit;
        private static Size oldres;

        private static string folder = Environment.CurrentDirectory;

        private static IniFile ini = new IniFile();

        void changeRes(string width, string height)
        {
            if (!disableEvents)
            {
                File.WriteAllText(xmlpath,
                    xml.Replace("<s id=\"Video.Width\">" + oldres.Width.ToString(), "<s id=\"Video.Width\">" + width)
                    .Replace("<s id=\"Video.Height\">" + oldres.Height.ToString(), "<s id=\"Video.Height\">" + height));
                //File.WriteAllText(xmlpath, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<r>\n\t<s id=\"Video.Width\">"+width+"</s>\n\t<s id=\"Video.Height\">"+height+"</s>\n\t<s id=\"Options.GraphicsQuality\">0</s>\n\t<s id=\"Options.Crowd\">0</s>\n\t<s id=\"Options.Physics\">0</s>\n\t<s id=\"Options.Flares\">0</s>\n\t<s id=\"Options.FrontRowCamera\">1</s>\n\t<s id=\"AutoLogin\">OFF</s>\n\t<s id=\"Username\"></s>\n\t<s id=\"MatchUsername\"></s>\n\t<s id=\"Password\"></s>\n\t<s id=\"6f1d2b61d5a011cfbfc7444553540000\">201 202 203 204 205 206 999 219 235 400 401 999 310 </s>\n\t<s id=\"AudioLagReminderShown\">1</s>\n</r>");
            }
        }

        static TimeSpan time
        {
            get
            {
                return DateTime.UtcNow - Process.GetCurrentProcess().StartTime.ToUniversalTime();
            }
        }

        static string timems
        {
            get
            {
                return "<" + (time.TotalMilliseconds / 1000).ToString("0.000") + ">";
            }
        }
        
        public static bool verboselog2;

        static void verbose(object text)
        {
            if (verboselog2)
            {
                Console.Write(text);
            }
        }

        static void verboseline(object text)
        {
            if (verboselog2)
            {
                Console.Write(timems);
                Console.WriteLine(text);
            }
        }

        private void saveQb()
        {
            guitarqb.AlignPointers();
            qbedit.ReplaceFile("scripts\\guitar\\guitar.qb", guitarqb);
        }

        public settings()
        {
            if (File.Exists("settings.ini"))
                ini.Load("settings.ini");
            verboselog2 = ini.GetKeyValue("Misc", "VerboseLog", "0") == "1";
            verboseline("Loading QBs...");
            pakformat = new PakFormat(folder + pak + "qb.pak.xen", folder + pak + "qb.pab.xen", "", PakFormatType.PC, false);
            qbedit = new PakEditor(pakformat, false);
            guitarqb = qbedit.ReadQbFile("E34DCB0C");//scripts\\guitar\\guitar.qb
            hudqb = qbedit.ReadQbFile("41A8CF91");
            crowdqb = qbedit.ReadQbFile("341A488B"); // scripts\guitar\guitar_crowd.qb
            //bootqb = qbedit.ReadQbFile("56628B8A");
            //new QbFile(folder + pak + "song.qb", pakformat);
            disableEvents = true;
            //qbpak = File.ReadAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen");
            if (File.Exists(xmlpath))
            {
                File.Open(xmlpath, FileMode.OpenOrCreate).Close();
                xml = File.ReadAllText(xmlpath);
            }
            Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
            //bgcol = (ini.GetKeyValue("Misc","BGColor","0,0,0").Split(",".ToCharArray()));
            //backcolor = Color.FromArgb(255, Convert.ToByte(bgcol[0]), Convert.ToByte(bgcol[1]), Convert.ToByte(bgcol[2]));
            backcolrgb = (QbItemInteger)
            hudqb.FindItem(QbKey.Create(0x32DBFA3E), false)
                .FindItem(QbKey.Create(0xBBB5F8A2), false)
                .Items[0].Items[1].FindItem(QbKey.Create(0x3F6BCDBA), false).Items[0];
            backcolor = Color.FromArgb(255,
                backcolrgb.Values[0],
                backcolrgb.Values[1],
                backcolrgb.Values[2]);
            //.FindItem(QbKey.Create("elements"), false).GetItems();
            //MessageBox.Show(backcolrgb.Values.Length.ToString());
            DialogResult = DialogResult.OK;
            InitializeComponent();
            SetForegroundWindow(Handle);
            //colorpanel.BackColor = backcolor;
            //hypers.Value = Convert.ToInt32(ini.GetKeyValue("Player","Hyperspeed","0"));
            hyperspeed = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0xFD6B13B4), false);
            hypers.Value = hyperspeed.Values[0];
            //341A488B
            nofailv = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0x3E5FD611), false);
            nofailcb.Checked = nofailv.Values[0] == 1;
            btncheats = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0x2AF92804), false);
            dbgmnu.Checked = btncheats.Values[0] == 1;
            autostart = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0x32025D94), false);
            keymode.Checked = autostart.Values[0] == 0;
            //speed.Value = Convert.ToDecimal(ini.GetKeyValue("Player","Speed","100"));
            speedf = (QbItemFloat)guitarqb.FindItem(QbKey.Create(0x16D91BC1), false);
            speed.Value = Convert.ToDecimal(speedf.Values[0] * 100);
            verboseline("Reading settings...");
            scrshmode.Checked = ini.GetKeyValue("Misc","ScrshMode","0") != "0";
            verboselog.Checked = verboselog2;
            backgroundcolordiag.Color = backcolor;
            colorpanel.BackColor = backcolor;
            //nofailcb.Checked = ini.GetKeyValue("Misc", "Nofail", "0") != "0";
            vsyncswitch.Checked = ini.GetKeyValue("Misc", "VSync", "1") == "0";
            songcaching.Checked = ini.GetKeyValue("Misc", "SongCaching", "1") == "1";
            nostartupmsg.Checked = ini.GetKeyValue("Misc", "NoStartupMsg", "0") == "1";
            preserveLog.Checked = ini.GetKeyValue("Misc", "PreserveLog", "0") == "1";
            foreach (Size sz in resz)
            {
                res.Items.Add(sz.Width.ToString() + "x" + sz.Height.ToString());
            }
            oldres.Width = int.Parse(xml.After("<s id=\"Video.Width\">").Before("</s>"));
            oldres.Height = int.Parse(xml.After("<s id=\"Video.Height\">").Before("</s>"));
            res.Text = oldres.Width.ToString() + "x" + oldres.Height.ToString();
            if (ini.GetKeyValue("Player", "MaxNotesAuto", "0") == "0")
                maxnotes.Value = int.Parse(ini.GetKeyValue("Player", "MaxNotes", "1048576"));
            else
                maxnotes.Value = -1;
            curdiff = (QbItemQbKey)guitarqb.FindItem(QbKey.Create(0x9B2F5962), false);
            curdiff2 = (QbItemQbKey)guitarqb.FindItem(QbKey.Create(0x6BF07EAD), false);
            // WTF C#
            if (curdiff.Values[0].Crc == diffCRCs[0].Crc)
                diff.Text = "Easy";
            else if(curdiff.Values[0].Crc == diffCRCs[1].Crc)
                diff.Text = "Medium";
            else if (curdiff.Values[0].Crc == diffCRCs[2].Crc)
                diff.Text = "Hard";
            else if (curdiff.Values[0].Crc == diffCRCs[3].Crc)
                diff.Text = "Expert";
            //diff.Text = diffs[int.Parse(ini.GetKeyValue("Player", "Difficulty", "3"))];
            part.SelectedIndex = int.Parse(ini.GetKeyValue("Player", "Part", "0"));
            player1 = (QbItemStruct)guitarqb.FindItem(QbKey.Create(0xD95930AC), false);
            disableEvents = false;
        }

        void changeDiff(int difficulty)
        {
            if (!disableEvents)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 0; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x20 &&
                        qbpak[i + 1] == 0x0D &&
                        qbpak[i + 2] == 0 &&
                        qbpak[i + 3] == 0x9B &&
                        qbpak[i + 4] == 0x2F &&
                        qbpak[i + 5] == 0x59 &&
                        qbpak[i + 6] == 0x62 &&
                        qbpak[i + 7] == 0xE3 &&
                        qbpak[i + 8] == 0x4D &&
                        qbpak[i + 9] == 0xCB &&
                        qbpak[i + 10] == 0x0C)
                    {
                        switch (difficulty)
                        {
                            case 0:
                                qbpak[i + 11] = 0xB6;
                                qbpak[i + 12] = 0x9D;
                                qbpak[i + 13] = 0x65;
                                qbpak[i + 14] = 0x68;
                                qbpak[i + 31] = 0xB6;
                                qbpak[i + 32] = 0x9D;
                                qbpak[i + 33] = 0x65;
                                qbpak[i + 34] = 0x68;
                                break;
                            case 1:
                                qbpak[i + 11] = 0x39;
                                qbpak[i + 12] = 0x8C;
                                qbpak[i + 13] = 0xBA;
                                qbpak[i + 14] = 0x48;
                                qbpak[i + 31] = 0x39;
                                qbpak[i + 32] = 0x8C;
                                qbpak[i + 33] = 0xBA;
                                qbpak[i + 34] = 0x48;
                                break;
                            case 2:
                                qbpak[i + 11] = 0x3E;
                                qbpak[i + 12] = 0xEA;
                                qbpak[i + 13] = 0xE0;
                                qbpak[i + 14] = 0x2D;
                                qbpak[i + 31] = 0x3E;
                                qbpak[i + 32] = 0xEA;
                                qbpak[i + 33] = 0xE0;
                                qbpak[i + 34] = 0x2D;
                                break;
                            case 3:
                                qbpak[i + 11] = 0xB0;
                                qbpak[i + 12] = 0xE4;
                                qbpak[i + 13] = 0x6C;
                                qbpak[i + 14] = 0xBD;
                                qbpak[i + 31] = 0xB0;
                                qbpak[i + 32] = 0xE4;
                                qbpak[i + 33] = 0x6C;
                                qbpak[i + 34] = 0xBD;
                                break;
                        }
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find difficulty QBKey.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            changeDiff(difficulty);
                            break;
                    }*/
                //filesafe = false;
                curdiff.Values[0] = diffCRCs[difficulty];
                curdiff2.Values[0] = diffCRCs[difficulty];
                saveQb();
                ini.SetKeyValue("Player", "Difficulty", difficulty.ToString());
                ini.Save("settings.ini");
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ResumeLayout();
            }
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
            Console.WriteLine(
@"adituv           - QbScript reverse engineering,
                   compiler/decompiler, vsync flame fix,
                   built in QB decompiler
ExileLord        - GH3+ and executable reverse engineering,
                   mods, GHTCP patching, IDA stuff, hacksawed
                   ChartEdit/Chart-to-PAK classes and conversion tools,
                   progress in IDA beyond Oct 2016 that he accidentally
                   shared in his videos and streams that might've benefitted
                   in finding more things
donnaken15       - other QbScript hacking, mod creation and setup,
                   game optimization, main program and automation,
                   logger plugin
maxkiller        - original GHTCP + texture explorer
Nanook           - QueenBee + Parser
raphaelgoulart   - mid2chart
GameZelda        - original modding and game data R.E.
aluigi           - FSBExt, and other cool off-project extraction tools
HATRED           - better No-CD/SecuROM fix than BATTERY
No1mann          \
Invo             \
Leff             \
ScoreHero forums
and many others  - Miscellaneous things / help
SoX  devs        - SoX, decoder
LAME devs        - LAME, faster encoder
Activision       \
RedOctane        \
Neversoft        \
Aspyr            - Original game, images, sounds, copyright");
        }

        private void hypers_ValueChanged(object sender, EventArgs e)
        {
            if (!disableEvents)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 0; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x20 &&
                        qbpak[i + 1] == 0x01 &&
                        qbpak[i + 2] == 0 &&
                        qbpak[i + 3] == 0xFD &&
                        qbpak[i + 4] == 0x6B &&
                        qbpak[i + 5] == 0x13 &&
                        qbpak[i + 6] == 0xB4 &&
                        qbpak[i + 7] == 0xE3 &&
                        qbpak[i + 8] == 0x4D &&
                        qbpak[i + 9] == 0xCB &&
                        qbpak[i + 10] == 0x0C)
                    {
                        qbpak[i + 14] = (byte)hypers.Value;
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find hyperspeed Integer.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            hypers.Value = hypers.Value;
                            break;
                    }*/
                hyperspeed.Values[0] = Convert.ToInt32(hypers.Value);
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //ini.SetKeyValue("Player", "Hyperspeed", hypers.Value.ToString());
                //ini.Save("settings.ini");
                //File.WriteAllText(folder + "\\CONFIGS\\hyperspeed", Convert.ToString(hypers.Value));
                ResumeLayout();
            }
        }

        private void setbgcolor_Click(object sender, EventArgs e)
        {
            if (backgroundcolordiag.ShowDialog() == DialogResult.OK)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x7D &&
                        qbpak[i + 1] == 0x99 &&
                        qbpak[i + 2] == 0xF2 &&
                        qbpak[i + 3] == 0x8D &&
                        qbpak[i + 4] == 0xC5 &&
                        qbpak[i + 5] == 0xA5 &&
                        qbpak[i + 6] == 0x49 &&
                        qbpak[i + 7] == 0x34 &&
                        qbpak[i + 8] == 0x00 &&
                        qbpak[i + 9] == 0x00 &&
                        qbpak[i + 10] == 0x16 &&
                        qbpak[i + 11] == 0x44 &&
                        qbpak[i + 12] == 0x00 &&
                        qbpak[i + 13] == 0x8C &&
                        qbpak[i + 14] == 0x00 &&
                        qbpak[i + 15] == 0x00 &&
                        qbpak[i + 16] == 0x3F &&
                        qbpak[i + 17] == 0x6B &&
                        qbpak[i + 18] == 0xCD &&
                        qbpak[i + 19] == 0xBA &&
                        qbpak[i + 20] == 0x00 &&
                        qbpak[i + 21] == 0x00 &&
                        qbpak[i + 22] == 0x16 &&
                        qbpak[i + 23] == 0x54 &&
                        qbpak[i + 24] == 0x00 &&
                        qbpak[i + 25] == 0x00 &&
                        qbpak[i + 26] == 0x16 &&
                        qbpak[i + 27] == 0x70 &&
                        qbpak[i + 28] == 0x00 &&
                        qbpak[i + 29] == 0x01 &&
                        qbpak[i + 30] == 0x01 &&
                        qbpak[i + 31] == 0x00 &&
                        qbpak[i + 32] == 0x00 &&
                        qbpak[i + 33] == 0x00 &&
                        qbpak[i + 34] == 0x00 &&
                        qbpak[i + 35] == 0x04 &&
                        qbpak[i + 36] == 0x00 &&
                        qbpak[i + 37] == 0x00 &&
                        qbpak[i + 38] == 0x16 &&
                        qbpak[i + 39] == 0x60)
                    {
                        qbpak[i + 43] = backgroundcolordiag.Color.R;
                        qbpak[i + 47] = backgroundcolordiag.Color.G;
                        qbpak[i + 51] = backgroundcolordiag.Color.B;
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find rgba array.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                    //.FindItem(QbKey.Create("elements"), false).GetItems();
                //MessageBox.Show(backcolrgb.Values.Length.ToString());
                backcolrgb.Values[0] = backgroundcolordiag.Color.R;
                backcolrgb.Values[1] = backgroundcolordiag.Color.G;
                backcolrgb.Values[2] = backgroundcolordiag.Color.B;
                //saveQb();
                hudqb.AlignPointers();
                qbedit.ReplaceFile("scripts\\guitar\\guitar_hud_2d_career.qb", hudqb);
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //ini.SetKeyValue("Misc", "BGColor", backgroundcolordiag.Color.R + "," +
                //    backgroundcolordiag.Color.G + "," + backgroundcolordiag.Color.B);
                ini.Save("settings.ini");
                ResumeLayout();
                colorpanel.BackColor = backgroundcolordiag.Color;
                //File.WriteAllText(folder + "\\CONFIGS\\bgcolor_r", backgroundcolordiag.Color.R.ToString());
                //File.WriteAllText(folder + "\\CONFIGS\\bgcolor_g", backgroundcolordiag.Color.G.ToString());
                //File.WriteAllText(folder + "\\CONFIGS\\bgcolor_b", backgroundcolordiag.Color.B.ToString());
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

        private void scrshmode_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x00 &&
                        qbpak[i + 1] == 0x20 &&
                        qbpak[i + 2] == 0x01 &&
                        qbpak[i + 3] == 0x00 &&
                        qbpak[i + 4] == 0x96 &&
                        qbpak[i + 5] == 0x8F &&
                        qbpak[i + 6] == 0x74 &&
                        qbpak[i + 7] == 0x08 &&
                        qbpak[i + 8] == 0x86 &&
                        qbpak[i + 9] == 0x02 &&
                        qbpak[i + 10] == 0xA9 &&
                        qbpak[i + 11] == 0xFB &&
                        qbpak[i + 12] == 0x00 &&
                        qbpak[i + 13] == 0x00 &&
                        qbpak[i + 14] == 0x00)
                    {
                        qbpak[i + 15] = Convert.ToByte(scrshmode.Checked);
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find screenshot mode value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                //hyperspeed = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0xFD6B13B4), false);
                //hyperspeed.Values[0] = Convert.ToInt32(hypers.Value);
                viewmode = (QbItemInteger)guitarqb.FindItem(QbKey.Create(0xFD6B13B4), false);
                viewmode.Values[0] = scrshmode.Checked ? 1 : 0;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ini.SetKeyValue("Misc", "ScrshMode", (scrshmode.Checked ? "1" : "0"));
                ini.Save("settings.ini");
                //File.WriteAllText(folder + "\\CONFIGS\\scrshmode", scrshmode.Checked.ToString());
                ResumeLayout();
            }
        }

        private void nostatsonend_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x01 &&
                        qbpak[i + 1] == 0xA4 &&
                        qbpak[i + 2] == 0x00 &&
                        qbpak[i + 3] == 0x8D &&
                        qbpak[i + 4] == 0x00 &&
                        qbpak[i + 5] == 0x00 &&
                        qbpak[i + 6] == 0xBD &&
                        qbpak[i + 7] == 0x09 &&
                        qbpak[i + 8] == 0x54 &&
                        qbpak[i + 9] == 0x4C)
                    {
                        if (!nostatsonend.Checked)
                        {
                            qbpak[i + 10] = 0x3C;
                            qbpak[i + 11] = 0x52;
                            qbpak[i + 12] = 0x19;
                            qbpak[i + 13] = 0x82;
                        }
                        else
                        {
                            qbpak[i + 10] = 0x98;
                            qbpak[i + 11] = 0x17;
                            qbpak[i + 12] = 0xD4;
                            qbpak[i + 13] = 0x5C;
                        }
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ini.SetKeyValue("Misc", "NoStatsOnEnd", (nostatsonend.Checked ? "1" : "0"));
                ini.Save("settings.ini");
                //File.WriteAllText(folder + "\\CONFIGS\\nostatsonend", nostatsonend.Checked.ToString());
                ResumeLayout();
            }
        }

        private void Colorpanel_MouseDoubleClick()
        {
            new colorpreview(colorpanel.BackColor).ShowDialog();
        }

        private void colorpanel_Click(object sender, EventArgs e)
        {
            new colorpreview(colorpanel.BackColor).ShowDialog();
        }

        private void vsyncswitch_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "VSync", (vsyncswitch.Checked ? "0" : "1"));
            ini.Save("settings.ini");
            //File.WriteAllText(folder + "\\CONFIGS\\vsync", vsyncswitch.Checked.ToString());
        }

        private void nofailviewer_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x13 &&
                        qbpak[i + 1] == 0xFD &&
                        qbpak[i + 2] == 0x2B &&
                        qbpak[i + 3] == 0x2A &&
                        qbpak[i + 4] == 0x34 &&
                        qbpak[i + 5] == 0x1A &&
                        qbpak[i + 6] == 0x48 &&
                        qbpak[i + 7] == 0x8B &&
                        qbpak[i + 8] == 0x00 &&
                        qbpak[i + 9] == 0x00 &&
                        qbpak[i + 10] == 0x00)
                    {
                        qbpak[i + 11] = Convert.ToByte(nofailviewer.Checked);
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ini.SetKeyValue("Misc", "NofailViewer", (nofailviewer.Checked ? "1" : "0"));
                ini.Save("settings.ini");
                //File.WriteAllText(folder + "\\CONFIGS\\nofailviewer", nofailviewer.Checked.ToString());
                ResumeLayout();
            }
        }

        private void nostartupmsg_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "NoStartupMsg", (nostartupmsg.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }

        private void ctmpb_Click(object sender, EventArgs e)
        {
            string tmpf = Path.GetTempPath();
            string[] tmpds = Directory.GetDirectories(tmpf, "Z.TMP.FGH3$*", SearchOption.TopDirectoryOnly);
            string[] tmpfs = Directory.GetFiles(tmpf, "*.tmp.fsp", SearchOption.TopDirectoryOnly);
            foreach (string folder in tmpds)
            {
                //string[] whycs = Directory.GetFiles(folder, "*.*", SearchOption.AllDirectories);
                //foreach (string whycs2 in whycs)
                //{
                    //File.Delete(whycs2);
                //}
                Directory.Delete(folder, true);
            }
            foreach (string file in tmpfs)
            {
                File.Delete(file);
            }
            if (File.Exists(folder + "\\DATA\\CACHE\\.db.ini"))
            {
                IniFile cache = new IniFile();
                cache.Load(folder + "\\DATA\\CACHE\\.db.ini");
                int sectCount = 0;
                string[] stupidEnumerasdaewrhygio = new string[cache.Sections.Count];
                foreach (IniFile.IniSection sect in cache.Sections)
                {
                    if (sect.Name.StartsWith("URL"))
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

        private void keymode_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x16 &&
                        qbpak[i + 1] == 0xD9 &&
                        qbpak[i + 2] == 0x1B &&
                        qbpak[i + 3] == 0xC1 &&
                        qbpak[i + 4] == 0xE3 &&
                        qbpak[i + 5] == 0x4D &&
                        qbpak[i + 6] == 0xCB &&
                        qbpak[i + 7] == 0x0C)
                    {
                        for (int j = 0; j < 4; j++)
                            qbpak[i + 8 + j] = BitConverter.GetBytes((float)speed.Value/100)[3-j];
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                autostart.Values[0] = keymode.Checked ? 0 : 1;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //File.WriteAllText(folder + "\\CONFIGS\\speed",speed.Value.ToString());
            }
        }

        private void nofail_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x16 &&
                        qbpak[i + 1] == 0xD9 &&
                        qbpak[i + 2] == 0x1B &&
                        qbpak[i + 3] == 0xC1 &&
                        qbpak[i + 4] == 0xE3 &&
                        qbpak[i + 5] == 0x4D &&
                        qbpak[i + 6] == 0xCB &&
                        qbpak[i + 7] == 0x0C)
                    {
                        for (int j = 0; j < 4; j++)
                            qbpak[i + 8 + j] = BitConverter.GetBytes((float)speed.Value/100)[3-j];
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                nofailv.Values[0] = nofailcb.Checked ? 1 : 0;
                //saveQb();
                int[] zoffs = { 20, 21 };
                int _invert = nofailcb.Checked ? 1 : -1;
                QbItemBase togglenofailgfx =
                hudqb.FindItem(QbKey.Create(0x32DBFA3E), false)
                    .FindItem(QbKey.Create(0xBBB5F8A2), false)
                    .Items[0];//.Items[23].FindItem(QbKey.Create("zoff"), false).Items[0];

                /*backcolrgb = (QbItemInteger)
                hudqb.FindItem(QbKey.Create(0x32DBFA3E), false)
                    .FindItem(QbKey.Create(0xBBB5F8A2), false)
                    .Items[0].Items[14].FindItem(QbKey.Create(0x3F6BCDBA), false).Items[0];*/
                QbItemInteger thiscodesucks =
                (QbItemInteger)
                    (togglenofailgfx.Items[13].FindItem(QbKey.Create(0x0EC4E44A), false));
                QbItemInteger thiscodesucks2 =
                (QbItemInteger)
                    (togglenofailgfx.Items[14].FindItem(QbKey.Create(0x0EC4E44A), false));
                thiscodesucks.Values[0]  = zoffs[0] * _invert;
                thiscodesucks2.Values[0] = zoffs[1] * _invert;/**/
                //.FindItem(QbKey.Create("elements"), false).GetItems();
                hudqb.AlignPointers();
                qbedit.ReplaceFile("scripts\\guitar\\guitar_hud_2d_career.qb", hudqb);
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //File.WriteAllText(folder + "\\CONFIGS\\speed",speed.Value.ToString());
            }
        }

        private void dbgmnu_CheckedChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x16 &&
                        qbpak[i + 1] == 0xD9 &&
                        qbpak[i + 2] == 0x1B &&
                        qbpak[i + 3] == 0xC1 &&
                        qbpak[i + 4] == 0xE3 &&
                        qbpak[i + 5] == 0x4D &&
                        qbpak[i + 6] == 0xCB &&
                        qbpak[i + 7] == 0x0C)
                    {
                        for (int j = 0; j < 4; j++)
                            qbpak[i + 8 + j] = BitConverter.GetBytes((float)speed.Value/100)[3-j];
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                btncheats.Values[0] = dbgmnu.Checked ? 1 : 0;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //File.WriteAllText(folder + "\\CONFIGS\\speed",speed.Value.ToString());
            }
        }

        private void speed_ValueChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 64; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x16 &&
                        qbpak[i + 1] == 0xD9 &&
                        qbpak[i + 2] == 0x1B &&
                        qbpak[i + 3] == 0xC1 &&
                        qbpak[i + 4] == 0xE3 &&
                        qbpak[i + 5] == 0x4D &&
                        qbpak[i + 6] == 0xCB &&
                        qbpak[i + 7] == 0x0C)
                    {
                        for (int j = 0; j < 4; j++)
                            qbpak[i + 8 + j] = BitConverter.GetBytes((float)speed.Value/100)[3-j];
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                        break;
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find nofail viewercam value.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            backgroundcolordiag.ShowDialog();
                            break;
                    }*/
                speedf.Values[0] = float.Parse((speed.Value / 100).ToString());
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                //File.WriteAllText(folder + "\\CONFIGS\\speed",speed.Value.ToString());
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

        private void songcaching_CheckedChanged(object sender, EventArgs e)
        {
            //File.WriteAllText(folder + "\\CONFIGS\\songcaching", songcaching.Checked.ToString());
            ini.SetKeyValue("Misc", "SongCaching", (songcaching.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }

        private void verboselog_CheckedChanged(object sender, EventArgs e)
        {
            //File.WriteAllText(folder + "\\CONFIGS\\verboselog", verboselog.Checked.ToString());
            ini.SetKeyValue("Misc", "VerboseLog", (verboselog.Checked ? "1" : "0"));
            ini.Save("settings.ini");
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
                //File.WriteAllText(folder + "\\CONFIGS\\maxnotes", maxnotes.Value.ToString());
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

        private void replaygame_Click(object sender, EventArgs e)
        {
            Process gh3 = new Process();
            gh3.StartInfo.WorkingDirectory = folder + "\\";
            gh3.StartInfo.FileName = folder + "\\game.exe";
            gh3.Start();
        }

        private void part_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (disableEvents == false)
            {
                SuspendLayout();
                hypers.Enabled = false;
                diff.Enabled = false;
                setbgcolor.Enabled = false;
                scrshmode.Enabled = false;
                nostatsonend.Enabled = false;
                nofailcb.Enabled = false;
                /*for (int i = 0; i < qbpak.Length; i++)
                    if (qbpak[i] == 0x00 &&
                        qbpak[i + 1] == 0x8D &&
                        qbpak[i + 2] == 0 &&
                        qbpak[i + 3] == 0 &&
                        qbpak[i + 4] == 0xB6 &&
                        qbpak[i + 5] == 0xF0 &&
                        qbpak[i + 6] == 0x8F &&
                        qbpak[i + 7] == 0x39)
                    {
                        if (part.SelectedIndex == 0)
                        {
                            qbpak[i + 8] = 0xBD;
                            qbpak[i + 9] = 0xC5;
                            qbpak[i + 10] = 0x3C;
                            qbpak[i + 11] = 0xF2;
                        }
                        else
                        {
                            qbpak[i + 8] = 0x7A;
                            qbpak[i + 9] = 0x7D;
                            qbpak[i + 10] = 0x1D;
                            qbpak[i + 11] = 0xCA;
                        }
                        filesafe = true;
                        File.WriteAllBytes(folder + "\\DATA\\PAK\\qb.pab.xen", qbpak);
                    }
                if (!filesafe)
                    switch (MessageBox.Show("Could not find difficulty QBKey.", "ERROR!", MessageBoxButtons.AbortRetryIgnore, MessageBoxIcon.Error, MessageBoxDefaultButton.Button2))
                    {
                        case DialogResult.Abort:
                            Application.Exit();
                            break;
                        case DialogResult.Retry:
                            int test = part.SelectedIndex;
                            part.SelectedIndex = 0;
                            part.SelectedIndex = 1;
                            part.SelectedIndex = test;
                            break;
                    }*/
                p1part = (QbItemQbKey)player1.FindItem(QbKey.Create(0xB6F08F39), false);
                p1part.Values[0] = partCRCs[part.SelectedIndex];
                saveQb();
                filesafe = false;
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ini.SetKeyValue("Player", "Part", part.SelectedIndex.ToString());
                ini.Save("settings.ini");
                //if (part.SelectedIndex == 0)
                    //File.WriteAllText(folder + "\\CONFIGS\\part", "guitar");
                //else
                    //File.WriteAllText(folder + "\\CONFIGS\\part", "bass");
            }
        }
        
        void preservelog_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "PreserveLog", (preserveLog.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }
    }
}
