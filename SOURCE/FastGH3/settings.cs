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

        private static QbFile userqb;//, bootqb;
        //private static QbItemStruct player1;
        private static QbItemQbKey p1diff, p2diff, p1part, p2part;
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
            userqb.AlignPointers();
            qbedit.ReplaceFile("config.qb", userqb);
        }

        public settings()
        {
            if (File.Exists("settings.ini"))
                ini.Load("settings.ini");
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
                xml = File.ReadAllText(xmlpath);
            }
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
            hyperspeed = (QbItemInteger)userqb.FindItem(QbKey.Create(0xFD6B13B4), false);
            hypers.Value = hyperspeed.Values[0];
            nofailv = (QbItemInteger)userqb.FindItem(QbKey.Create(0x3E5FD611), false);
            nofailcb.Checked = nofailv.Values[0] == 1;
            btncheats = (QbItemInteger)userqb.FindItem(QbKey.Create(0x2AF92804), false);
            dbgmnu.Checked = btncheats.Values[0] == 1;
            autostart = (QbItemInteger)userqb.FindItem(QbKey.Create(0x32025D94), false);
            keymode.Checked = autostart.Values[0] == 0;
            speedf = (QbItemFloat)userqb.FindItem(QbKey.Create(0x16D91BC1), false);
            speed.Value = Convert.ToDecimal(speedf.Values[0] * 100);
            verboseline("Reading settings...");
            scrshmode.Checked = ini.GetKeyValue("Misc","ScrshMode","0") != "0";
            verboselog.Checked = verboselog2;
            backgroundcolordiag.Color = backcolor;
            colorpanel.BackColor = backcolor;
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
            //if (ini.GetSection("Player") == null)
            {
                if (ini.GetKeyValue("Player", "MaxNotesAuto", "0") == "0")
                    maxnotes.Value = int.Parse(ini.GetKeyValue("Player", "MaxNotes", "1048576"));
                else
                    maxnotes.Value = -1;
            }
            p1diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_diff"), false);
            p2diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_diff"), false);
            p1part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_part"), false);
            p2part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_part"), false);
            // WTF C#
            if (p1diff.Values[0].Crc == diffCRCs[0].Crc)
                diff.Text = "Easy";
            else if(p1diff.Values[0].Crc == diffCRCs[1].Crc)
                diff.Text = "Medium";
            else if (p1diff.Values[0].Crc == diffCRCs[2].Crc)
                diff.Text = "Hard";
            else if (p1diff.Values[0].Crc == diffCRCs[3].Crc)
                diff.Text = "Expert";
            if (p1part.Values[0].Crc == partCRCs[0].Crc)
                part.SelectedIndex = 0;
            else// if (p1part.Values[0].Crc == partCRCs[1].Crc)
                part.SelectedIndex = 1;
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
            }*/
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
                p1diff.Values[0] = diffCRCs[difficulty];
                p2diff.Values[0] = diffCRCs[difficulty];
                saveQb();
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
                hyperspeed.Values[0] = Convert.ToInt32(hypers.Value);
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
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
                backcolrgb.Values[0] = backgroundcolordiag.Color.R;
                backcolrgb.Values[1] = backgroundcolordiag.Color.G;
                backcolrgb.Values[2] = backgroundcolordiag.Color.B;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
                ini.Save("settings.ini");
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
                viewmode = (QbItemInteger)userqb.FindItem(QbKey.Create("Cheat_NoFail"), false);
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
            ini.SetKeyValue("Misc", "NoStatsOnEnd", (nostatsonend.Checked ? "1" : "0"));
            ini.Save("settings.ini");
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
        }

        private void nofailviewer_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "NofailViewer", (nofailviewer.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }

        private void nostartupmsg_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "NoStartupMsg", (nostartupmsg.Checked ? "1" : "0"));
            ini.Save("settings.ini");
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
                autostart.Values[0] = keymode.Checked ? 0 : 1;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
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
                nofailv.Values[0] = nofailcb.Checked ? 1 : 0;
                int[] zoffs = { 20, 21 };
                int _invert = nofailcb.Checked ? 1 : -1;
                QbItemInteger thiscodesucks =
                (QbItemInteger)
                    (userqb.FindItem(QbKey.Create("Nofailvis"), false));
                QbItemInteger thiscodesucks2 =
                (QbItemInteger)
                    (userqb.FindItem(QbKey.Create("Nofailvis2"), false));
                thiscodesucks.Values[0]  = zoffs[0] * _invert;
                thiscodesucks2.Values[0] = zoffs[1] * _invert;/**/
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
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
                btncheats.Values[0] = dbgmnu.Checked ? 1 : 0;
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
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
                speedf.Values[0] = float.Parse((speed.Value / 100).ToString());
                saveQb();
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
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
            ini.SetKeyValue("Misc", "SongCaching", (songcaching.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }

        private void verboselog_CheckedChanged(object sender, EventArgs e)
        {
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
                p1part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_part"), false);
                p1part.Values[0] = partCRCs[part.SelectedIndex];
                saveQb();
                filesafe = false;
                hypers.Enabled = true;
                diff.Enabled = true;
                setbgcolor.Enabled = true;
                scrshmode.Enabled = true;
                nostatsonend.Enabled = true;
                nofailcb.Enabled = true;
            }
        }
        
        void preservelog_CheckedChanged(object sender, EventArgs e)
        {
            ini.SetKeyValue("Misc", "PreserveLog", (preserveLog.Checked ? "1" : "0"));
            ini.Save("settings.ini");
        }
    }
}
