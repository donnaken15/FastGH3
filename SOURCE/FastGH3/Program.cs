using System;
using System.IO;
using System.Diagnostics;
using System.Windows.Forms;
using Nanook.QueenBee.Parser;
using System.Net;
using Ionic.Zip;
using System.Runtime.InteropServices;
using ChartEdit;
using System.Collections.Generic;

namespace FastGH3
{
    class Program
    {
        [DllImport("USER32.DLL")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("USER32.DLL", CharSet = CharSet.Unicode)]
        public static extern IntPtr FindWindow(string lpClassName,
        string lpWindowName);

        [DllImport("user32.dll")]
        static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        public static string folder, dataf = "\\DATA\\", pak = dataf + "PAK\\",
            music = dataf + "MUSIC\\", song = "song", reg = "reg", title = "FastGH3";
        public static string[] unusedKeys =
        { "212262DF", "7F2FC9BC", "32BDB4A9", "44819DD0", "CB09D855", "2E7DDC38",
            "71AA8EF7", "347C8050", "195F3B95", "7E1B28BC", "9D0C5D0C", "AF1E8BC1",
            "F51E3E9F", "5CD97CE0", "CCB6F94A", "9CF00B70" };
        static bool verboselog;
        public static OpenFileDialog openchart = new OpenFileDialog() {
            AddExtension = true,
            CheckFileExists = true,
            CheckPathExists = true,
            Filter = "Any supported files|*.chart;*.mid;*.fsp;*.zip;*.pak.xen|All chart types|*.chart;*.mid|FastGH3 Song Package|*.fsp;*.zip|Any type|*.*",
            RestoreDirectory = true,
            Title = "Select chart"
        };
        public static IniFile settings = new IniFile(), cache = new IniFile();
        public static Random random = new Random();
        public static DateTime starttime = DateTime.Today;
        public static Chart chart = new Chart();
        public static byte[] paknew = new byte[0x1960], paknewP1 =
        {
            0xA7, 0xF5, 0x05, 0xC4, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x1C,
            0x00, 0x00, 0x00, 0x00, 0xE1, 0x53, 0x10, 0xCD, 0x4C, 0x1E, 0x75, 0x69,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2C, 0xB3, 0xEF, 0x3B,
            0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00,
            0x89, 0x7A, 0xBB, 0x4A, 0x6A, 0xF9, 0x8E, 0xD1
        }, qbnew = {
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1C, 0x1C, 0x08, 0x02, 0x04,
            0x10, 0x04, 0x08, 0x0C, 0x0C, 0x08, 0x02, 0x04, 0x14, 0x02, 0x04, 0x0C,
            0x10, 0x10, 0x0C, 0x00
        };

        static string Reverse(string s)
        {
            verboseline("Reversing string...");
            char[] charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }

        static object choose(params object[] choices)
        {
            verbose("Choosing items: ");
            for (int i = 0; i < choices.Length; i++)
            {
                verbose(choices[i].ToString());
                if (i < choices.Length - 1)
                    verbose(", ");
            }
            verboseline(null);
            return choices[random.Next(0, choices.Length)];
        }

        static void disallowGameStartup()
        {
            try
            {
                foreach (Process proc in Process.GetProcessesByName("game"))
                    proc.Kill();
            }
            catch (Exception ex)
            {
                Console.Write("ERROR! :(\n" + ex.Message);
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

        public static void verbose(object text)
        {
            if (verboselog)
            {
                Console.Write(text);
            }
        }

        public static void verboseline(object text)
        {
            if (verboselog)
            {
                Console.Write(timems);
                Console.WriteLine(text);
            }
        }

        static bool cacheEnabled = true;

        static string sox2ndparam(byte i)
        {
            return ' ' + folder + music + "audio\\" + i.ToString().Replace("0", "song").Replace("1", "guitar").Replace("2", "rhythm") + ".ogg rate 44.1k";
        }

        static string[] cacheList;

        // Ask for filename just because external data is being handled.
        static bool isCached(string fname)
        {
            if (cacheEnabled)
            {
                ulong hash = WZK64.Create(File.ReadAllBytes(fname));
                return isCached(hash);
            }
            return false;
        }

        static bool isCached(ulong hash)
        {
            if (cacheEnabled)
            {
                string id = hash.ToString("X16");
                foreach (string f in cacheList)
                    if (f == id)
                        return true;
            }
            return false;
        }

        [STAThread]
        static void Main(string[] args)
        {
            Process[] multiinstcheck = Process.GetProcessesByName("fastgh3");
            //MessageBox.Show(multiinstcheck.Length.ToString());
            int multiinstcheckn = 0;
            if (multiinstcheck.Length > 1)
                foreach (Process fgh3 in multiinstcheck)
                {
                    //MessageBox.Show(fgh3.MainModule.FileName);
                    if (fgh3.MainModule.FileName == Application.ExecutablePath)
                    {
                        multiinstcheckn++;
                        if (multiinstcheckn > 1)
                        {
                            MessageBox.Show("FastGH3 Launcher is already running!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            Environment.Exit(0x4DF); // ERROR_ALREADY_INITIALIZED
                            break;
                        }
                    }
                }
            Console.Title = title;
            folder = Path.GetDirectoryName(Application.ExecutablePath) + '\\';//Environment.GetCommandLineArgs()[0].Replace("\\FastGH3.exe", "");
            if (File.Exists(folder + "settings.ini"))
                settings.Load(folder + "settings.ini");
            string chartext = ".chart", midext = ".mid",
                paksongmid = folder + pak + song + midext,
                paksongchart = folder + pak + song + chartext,
                songchartini = paksongchart + ".ini";
            verboselog = settings.GetKeyValue("Misc", "VerboseLog", "0") == "1";
            verboseline("Initializing...");
            cacheEnabled = settings.GetKeyValue("Misc", "SongCaching", "1") == "1";
            if (cacheEnabled)
            {
                Directory.CreateDirectory(folder + dataf + "CACHE");
                if (File.Exists(folder + dataf + "CACHE\\.db.ini"))
                    cache.Load(folder + dataf + "CACHE\\.db.ini");
            }
            if (args.Length == 0)
            {
                if (settings.GetKeyValue("Misc", "NoStartupMsg", "0") == "0")
                {
                    Console.Clear();
                    Console.WriteLine(@"
 Welcome to " + title + @" v1.0

 " + title + @" is an advanced mod of
 Guitar Hero 3 designed to be played
 as fast as possible. With this mod, you
 can play customs without any technical
 setup, and even associate chart or mid
 files with the game so you can access
 your charts quickly.

 To access the options, use
 the -settings parameter or
 open settings.bat.

 Press any key to load a chart.");
                    Console.ReadKey();
                }
                if (openchart.ShowDialog() == DialogResult.OK)
                {
                    Process.Start(Application.ExecutablePath, SubstringExtensions.EncloseWithQuoteMarks(openchart.FileName));
                }
                Application.Exit();
            }
            if (args.Length > 0)
            {
                if (args[0] == "-settings")
                {
                    Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
                    new settings().ShowDialog();
                }
                else if (args[0] == "dl" && (args[1] != "" || args[1] != null))
                {
                    Console.WriteLine(title + " by donnaken15");
                    Console.WriteLine("Downloading song package...");
                    try
                    {
                        Uri fsplink = new Uri(args[1].Replace("fastgh3://", "http://"));
                        string urlCache = cache.GetKeyValue("URL" + WZK64.Create(fsplink.AbsolutePath).ToString("X16"), "File", "");
                        string tmpFn = "null";
                        if (urlCache != "")
                        {
                            Console.WriteLine("Found already downloaded file.");
                            tmpFn = urlCache;
                            goto skipToGame;
                        }
                        WebClient fsp = new WebClient();
                        fsp.Proxy = null;
                        fsp.Headers.Add("user-agent", "Anything");
                        ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00); // why .NET 4
                        tmpFn = Path.GetTempFileName();
                        string tmpFl = Path.GetTempPath();
                        fsp.OpenRead(fsplink);
                        if (Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]) > (1024 * 1024) * 9)
                        {
                            if (MessageBox.Show("This song package is a larger file than usual. Do you want to continue?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                                Application.Exit();
                        }
                        //if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                        //settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                        fsp.DownloadFile(fsplink, tmpFn);
                        File.Move(tmpFn, tmpFn + ".fsp");
                        //Directory.CreateDirectory(tmpFl + "\\Z.TMP.FGH3$WEB");
                        tmpFn += ".fsp";
                        Console.WriteLine("Writing link to cache...");
                        cache.SetKeyValue("URL"+WZK64.Create(fsplink.AbsolutePath).ToString("X16"), "File"/*WZK64.Create(File.ReadAllBytes(tmpFn)).ToString("X16")*/, tmpFn.ToString());
                        cache.Save(folder + dataf + "CACHE\\.db.ini");
                        skipToGame:
                        Process.Start(Application.ExecutablePath, SubstringExtensions.EncloseWithQuoteMarks(tmpFn));
                    }
                    catch (Exception ex)
                    {
                        Console.Write("ERROR! :(\n" + ex.Message);
                        Console.ReadKey();
                    }
                }
                else if (File.Exists(args[0]))
                {
                    Console.WriteLine(title + " by donnaken15");
                    if (Path.GetFileName(args[0]).EndsWith(chartext) || Path.GetFileName(args[0]).EndsWith(midext))
                    {
                        bool ischart = false;
                        verboseline("File is: " + args[0]);
                        //File.Delete(paksongmid);
                        Process mid2chart = new Process();
                        mid2chart.StartInfo = new ProcessStartInfo()
                        {
                            FileName = folder + "\\mid2chart.exe",
                            Arguments = paksongmid.EncloseWithQuoteMarks() + " -k -u"
                        };
                        Console.WriteLine(verboselog);
                        // Why won't this work
                        if (!verboselog)
                        {
                            mid2chart.StartInfo.CreateNoWindow = true;
                            mid2chart.StartInfo.UseShellExecute = true;
                            mid2chart.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        }
                        else
                        {
                            mid2chart.StartInfo.UseShellExecute = false;
                            mid2chart.StartInfo.RedirectStandardError = true;
                            mid2chart.StartInfo.RedirectStandardOutput = true;
                            mid2chart.ErrorDataReceived += (sendingProcess, errorLine) => Console.WriteLine(errorLine.Data);
                            mid2chart.OutputDataReceived += (sendingProcess, dataLine) => Console.WriteLine(dataLine.Data);
                        }
                        if (Path.GetFileName(args[0]).EndsWith(chartext))
                        {
                            verboseline("Detected chart file. ");
                            ischart = true;
                        }
                        else if (Path.GetFileName(args[0]).EndsWith(midext) ||
                            Path.GetFileName(args[0]).EndsWith(midext + 'i'))
                        {
                            verboseline("Detected midi file.");
                            // why isnt this working
                            //mid2chart.ChartWriter.writeChart(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])), folder + pak + "tmp.chart", false, false);
                            //Console.WriteLine(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])).sections[0].name);
                            //Console.ReadKey();
                            File.Copy(args[0], paksongmid, true);
                            mid2chart.Start();
                            mid2chart.WaitForExit();
                            //Console.WriteLine(folder + "\\mid2chart.exe " + paksongmid.EncloseWithQuoteMarks() + " -k");
                            //Console.WriteLine(mid2chart.ExitCode);
                            //Console.ReadKey();
                        }
                        Console.WriteLine("Reading file.");
                        if (cacheEnabled)
                        {
                            cacheList = Directory.GetFiles(folder + "DATA\\CACHE");
                            for (int i = 0; i < cacheList.Length; i++)
                            {
                                cacheList[i] = Path.GetFileNameWithoutExtension(cacheList[i]);
                            }
                        }
                        if (ischart)
                        {
                            chart.Load(args[0]);
                        }
                        else chart.Load(folder + pak + "song.chart");
                        File.Delete(folder + pak + "song.mid");
                        File.Delete(folder + pak + "song.chart");
                        File.Delete(folder + pak + "song (Dummy).chart");
                        bool relfile = false;
                        try
                        {
                            Directory.SetCurrentDirectory(Path.GetDirectoryName(args[0]));
                        }
                        catch
                        {
                            relfile = true;
                            Directory.SetCurrentDirectory(Path.GetPathRoot(args[0]));
                            //Console.WriteLine(Path.GetPathRoot(args[0]));
                        }
                        #region ENCODE SONGS
                        Console.WriteLine("Encoding song.");
                        verboseline("Getting song, guitar, and rhythm files.");
                        string[] audiostreams = { "", "", "" };
                        string audtmpstr = "", chartfolder = /*Path.GetDirectoryName(args[0]) + '\\';
                        if (relfile) chartfolder =*/ Directory.GetCurrentDirectory() + '\\';
                        // optimize this maybe
                        foreach (SongSectionEntry chartinfo in chart.Song)
                        {
                            switch (chartinfo.Key)
                            {
                                case "MusicStream":
                                    try
                                    {
                                        audiostreams[0] = Path.GetFullPath(chartinfo.Value); // why does march madness mess this up
                                    }
                                    catch
                                    {
                                        try
                                        {
                                            audiostreams[0] = chartfolder + chartinfo.Value;
                                        }
                                        catch
                                        {
                                            audiostreams[0] = chartinfo.Value;
                                        }
                                    }
                                    if (File.Exists(audiostreams[0]))
                                        verboseline(chartinfo.Key + " file found");
                                    break;
                                case "GuitarStream":
                                    try
                                    {
                                        audiostreams[1] = Path.GetFullPath(chartinfo.Value);
                                    }
                                    catch
                                    {
                                        try
                                        {
                                            audiostreams[1] = chartfolder + chartinfo.Value;
                                        }
                                        catch
                                        {
                                            audiostreams[1] = chartinfo.Value;
                                        }
                                    }
                                    if (File.Exists(audiostreams[1]))
                                        verboseline(chartinfo.Key + " file found");
                                    break;
                                case "BassStream":
                                    try
                                    {
                                        audiostreams[2] = Path.GetFullPath(chartinfo.Value);
                                    }
                                    catch
                                    {
                                        try
                                        {
                                            audiostreams[2] = chartfolder + chartinfo.Value;
                                        }
                                        catch
                                        {
                                            audiostreams[2] = chartinfo.Value;
                                        }
                                    }
                                    if (File.Exists(audiostreams[2]))
                                        verboseline(chartinfo.Key + " file found");
                                    break;
                            }
                        }
                        string[] audstnames = { "song", "guitar", "rhythm" },
                            audextnames = { "ogg", "mp3", "wav" };
                        //bool grandlb = false;
                        for (int i = 0; i < 3; i++)
                        {
                            if (!File.Exists(audiostreams[0]))
                            {
                                audtmpstr = chartfolder + Path.GetFileNameWithoutExtension(args[0]) + '.' + audextnames[i];
                                if (File.Exists(audtmpstr))
                                {
                                    verboseline("Found audio with the chart name");
                                    audiostreams[0] = audtmpstr;
                                    break;
                                }
                            }
                        }
                        for (int i = 0; i < 3; i++)
                        {
                            if (!File.Exists(audiostreams[i]))
                                for (int j = 0; j < 3; j++)
                                {
                                    audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                    if (File.Exists(audtmpstr))
                                    {
                                        verboseline("Found FOF structure files / " + audstnames[i]);
                                        audiostreams[i] = audtmpstr;
                                        break;
                                    }
                                }
                        }
                        // TODO: allow NJ3T routine even when song.ogg exists
                        audstnames = new string[] { "lead", "bass" };
                        for (int i = 0; i < 2; i++)
                        {
                            if (!File.Exists(audiostreams[i + 1]))
                                for (int j = 0; j < 3; j++)
                                {
                                    audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                    if (File.Exists(audtmpstr))
                                    {
                                        verboseline("Found FOF structure files / " + audstnames[i]);
                                        audiostreams[i + 1] = audtmpstr;
                                        break;
                                    }
                                }
                        }
                        bool notjust3trax = false; // nj3ts.Count smh
                        List<string> nj3ts = new List<string>();
                        verboseline("Checking if extra audio exists");
                        for (int j = 0; j < 3; j++)
                        {
                            for (int i = 1; i < 9; i++)
                            {
                                audtmpstr = chartfolder + "drums_" + i + '.' + audextnames[j];
                                if (File.Exists(audtmpstr))
                                {
                                    verboseline("Found isolated drums audio (" + i + ')');
                                    notjust3trax = true;
                                    nj3ts.Add(audtmpstr);
                                }
                            }
                            audtmpstr = chartfolder + "vocals." + audextnames[j];
                            if (File.Exists(audtmpstr))
                            {
                                verboseline("Found isolated vocals audio");
                                notjust3trax = true;
                                nj3ts.Add(audtmpstr);
                                break;
                            }
                        }
                        audstnames = new string[] { "drums", "vocals", "keys", "song" };
                        for (int i = 0; i < 4; i++)
                        {
                            for (int j = 0; j < 3; j++)
                            {
                                audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                if (File.Exists(audtmpstr))
                                {
                                    verboseline("Found FOF structure files / " + audstnames[i]);
                                    if (i != 3)
                                    {
                                        notjust3trax = true;
                                    }
                                    nj3ts.Add(audtmpstr);
                                    break;
                                }
                            }
                        }
                        //if (nj3ts.Count > 0)
                            //notjust3trax = true;
                        verboseline("Current selected audio streams are:");
                        foreach (string a in audiostreams)
                            verboseline(a);
                        //nj3ts += '"' + folder + music + "\\TOOLS\\mergetmp.ogg" + '"';
                        if (!File.Exists(audiostreams[0]) && !notjust3trax)
                        {
                            verboseline("Failed to get main song file, asking user what the game should do");
                            DialogResult audiolost, playsilent = DialogResult.No, searchaudioresult = DialogResult.Cancel;
                            OpenFileDialog searchaudio = new OpenFileDialog()
                            {
                                CheckFileExists = true,
                                CheckPathExists = true,
                                InitialDirectory = Path.GetDirectoryName(args[0]),
                                Filter = "Audio files|*.mp3;*.wav;*.ogg|Any type|*.*"
                            };
                            do
                            {
                                audiolost = MessageBox.Show("No song audio can be found.\nDo you want to search for it?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
                                if (audiolost == DialogResult.Yes)
                                {
                                    searchaudioresult = searchaudio.ShowDialog();
                                    if (searchaudioresult == DialogResult.OK)
                                    {
                                        verboseline("User responded with " + SubstringExtensions.EncloseWithQuoteMarks(searchaudio.FileName));
                                        audiostreams[0] = searchaudio.FileName;
                                        playsilent = DialogResult.OK;
                                        if (!File.Exists(audiostreams[1]))
                                        {
                                            DialogResult audiolosthasguitartrack = MessageBox.Show("Is there a guitar track too?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
                                            if (audiolosthasguitartrack == DialogResult.Yes)
                                            {
                                                searchaudio.FileName = "";
                                                searchaudio.ShowDialog();
                                                if (searchaudio.FileName != string.Empty)
                                                {
                                                    audiostreams[1] = searchaudio.FileName;
                                                }
                                            }
                                        }
                                        if (!File.Exists(audiostreams[2]))
                                        {
                                            if (MessageBox.Show("Is there a rhythm track too?", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) == DialogResult.Yes)
                                            {
                                                searchaudio.FileName = "";
                                                searchaudio.ShowDialog();
                                                if (searchaudio.FileName != string.Empty)
                                                {
                                                    audiostreams[2] = searchaudio.FileName;
                                                }
                                            }
                                        }
                                    }
                                }
                                if (audiolost == DialogResult.No || searchaudioresult == DialogResult.Cancel || !File.Exists(searchaudio.FileName))
                                {
                                    playsilent = MessageBox.Show("Want to play without audio?\nThis is not compatible with practice mode.", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                                    if (playsilent == DialogResult.Yes)
                                    {
                                        verboseline("Using blank music file");
                                        audiostreams[0] = folder + music + "\\TOOLS\\blank.mp3";
                                    }
                                }
                            }
                            while (playsilent == DialogResult.No);
                        }
                        for (int i = 0; i < 3; i++)
                            if (!File.Exists(audiostreams[i]))
                            {
                                audiostreams[i] = folder + music + "\\TOOLS\\blank.mp3";
                            }
                        //im stupid
                        //this cache stuff is a mess
                        ulong charthash = WZK64.Create(
                             File.ReadAllBytes(args[0])
                        );
                        ulong audhash = 0;
                        bool chartCache = false;
                        bool audCache = false;
                        if (cacheEnabled)
                        {
                            Console.WriteLine("Checking cache.");
                            chartCache = isCached(charthash);
                            for (int i = 0; i < 3; i++)
                            {
                                //if ((!notjust3trax) || (notjust3trax && i != 0))
                                    audhash ^= WZK64.Create(
                                            File.ReadAllBytes(audiostreams[i])
                                    );
                            }
                            if (notjust3trax)
                                for (int i = 0; i < nj3ts.Count; i++)
                                {
                                    audhash ^= WZK64.Create(
                                            File.ReadAllBytes(nj3ts[i])
                                    );
                                }
                            foreach (string f in cacheList)
                            {
                                if (f == audhash.ToString("X16"))
                                {
                                    audCache = true;
                                    break;
                                }
                            }
                        }
                        Process addaud = new Process();
                        Process fsbbuild = new Process();
                        Process[] fsbbuild2 = new Process[3];
                        Process fsbbuild3 = new Process();
                        bool MTFSB = true;
                        //if (cacheEnabled)
                        if (!audCache)
                        {
                            Console.WriteLine("Audio is not cached.");
                            if (notjust3trax)
                            {
                                Console.WriteLine("Found more than three audio tracks, merging.");
                                addaud.StartInfo.FileName = folder + music + "\\TOOLS\\sox.exe";
                                if (!verboselog)
                                {
                                    addaud.StartInfo.CreateNoWindow = true;
                                    addaud.StartInfo.UseShellExecute = true;
                                    addaud.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                                }
                                else
                                {
                                    addaud.StartInfo.UseShellExecute = false;
                                    addaud.StartInfo.RedirectStandardError = true;
                                    addaud.StartInfo.RedirectStandardOutput = true;
                                    addaud.ErrorDataReceived += (sendingProcess, errorLine) => Console.WriteLine(errorLine.Data);
                                    addaud.OutputDataReceived += (sendingProcess, dataLine) => Console.WriteLine(dataLine.Data);
                                }
                                addaud.StartInfo.Arguments = "-m";
                                foreach (string a in nj3ts)
                                {
                                    addaud.StartInfo.Arguments += " \"" + a + '"';
                                }
                                //addaud.StartInfo.Arguments += " \"" + audiostreams[0] + '"';
                                addaud.StartInfo.Arguments += " \"" + folder + music + "\\TOOLS\\mergetmp.wav\" -S --multi-threaded --norm=-0.1";// -c 2 -r 44100 -C 128
                                //verboseline(addaud.StartInfo.Arguments);
                                addaud.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                                addaud.Start();
                                if (verboselog)
                                {
                                    addaud.BeginErrorReadLine();
                                    addaud.BeginOutputReadLine();
                                }
                                if (!addaud.HasExited) // <-- lol
                                {
                                    //Console.WriteLine("Waiting for extra track merging to finish.");
                                    addaud.WaitForExit();
                                }
                                audiostreams[0] = folder + music + "\\TOOLS\\mergetmp.wav";
                                //fsbbuild.StartInfo.FileName += '2';
                            }
                            verboseline("Creating encoder process...");
                            if (!MTFSB)
                            {
                                fsbbuild.StartInfo.FileName = folder + music + "\\TOOLS\\fsbbuild.bat";
                                if (!verboselog)
                                {
                                    fsbbuild.StartInfo.CreateNoWindow = true;
                                    fsbbuild.StartInfo.UseShellExecute = true;
                                    fsbbuild.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                                }
                                else
                                {
                                    fsbbuild.StartInfo.UseShellExecute = false;
                                    fsbbuild.StartInfo.RedirectStandardError = true;
                                    fsbbuild.StartInfo.RedirectStandardOutput = true;
                                    fsbbuild.ErrorDataReceived += (sendingProcess, errorLine) => Console.WriteLine(errorLine.Data);
                                    fsbbuild.OutputDataReceived += (sendingProcess, dataLine) => Console.WriteLine(dataLine.Data);
                                }
                                fsbbuild.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                            }
                            else
                            {
                                Directory.CreateDirectory(folder + music + "\\TOOLS\\fsbtmp");
                                File.Copy(folder + music + "\\TOOLS\\blank.mp3", folder + music + "\\TOOLS\\fsbtmp\\fastgh3_preview.mp3", true);
                                string[] fsbnames = { "song", "guitar", "rhythm" };
                                for (int i = 0; i < fsbbuild2.Length; i++)
                                {
                                    fsbbuild2[i] = new Process();
                                    fsbbuild2[i].StartInfo = new ProcessStartInfo()
                                    {
                                        FileName = folder + music + "\\TOOLS\\c128ks.bat",
                                        Arguments = audiostreams[i].EncloseWithQuoteMarks() + " \"" + folder + music + "\\TOOLS\\fsbtmp\\fastgh3_" + fsbnames[i] + ".mp3\"",
                                        CreateNoWindow = true,
                                        UseShellExecute = true,
                                        WindowStyle = ProcessWindowStyle.Hidden
                                    };
                                    if (verboselog)
                                    {
                                        fsbbuild2[i].StartInfo.UseShellExecute = false;
                                        fsbbuild2[i].StartInfo.RedirectStandardError = true;
                                        fsbbuild2[i].StartInfo.RedirectStandardOutput = true;
                                        fsbbuild2[i].ErrorDataReceived += (sendingProcess, errorLine) => Console.WriteLine(errorLine.Data);
                                        fsbbuild2[i].OutputDataReceived += (sendingProcess, dataLine) => Console.WriteLine(dataLine.Data);
                                    }
                                }
                                fsbbuild3.StartInfo.FileName = folder + music + "\\TOOLS\\fsbbuildnoenc.bat";
                                if (!verboselog)
                                {
                                    fsbbuild3.StartInfo.CreateNoWindow = true;
                                    fsbbuild3.StartInfo.UseShellExecute = true;
                                    fsbbuild3.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                                }
                                else
                                {
                                    fsbbuild3.StartInfo.UseShellExecute = false;
                                    fsbbuild3.StartInfo.RedirectStandardError = true;
                                    fsbbuild3.StartInfo.RedirectStandardOutput = true;
                                    fsbbuild3.ErrorDataReceived += (sendingProcess, errorLine) => Console.WriteLine(errorLine.Data);
                                    fsbbuild3.OutputDataReceived += (sendingProcess, dataLine) => Console.WriteLine(dataLine.Data);
                                }
                                fsbbuild3.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                            }
                            verboseline("Starting FSB building...");
                            if (!MTFSB)
                            {
                                fsbbuild.StartInfo.Arguments =
                                audiostreams[0].EncloseWithQuoteMarks() + ' ' + audiostreams[1].EncloseWithQuoteMarks() + ' ' + audiostreams[2].EncloseWithQuoteMarks() + ' ' +
                                (folder + music + "\\TOOLS\\blank.mp3").EncloseWithQuoteMarks() + ' ' + (folder + music + "\\fastgh3.fsb.xen").EncloseWithQuoteMarks();
                                //verboseline(fsbbuild.StartInfo.Arguments);
                                fsbbuild.Start();
                                if (verboselog)
                                {
                                    fsbbuild.BeginErrorReadLine();
                                    fsbbuild.BeginOutputReadLine();
                                }
                            }
                            else
                            {
                                for (int i = 0; i < fsbbuild2.Length; i++)
                                {
                                    fsbbuild2[i].Start();
                                    if (verboselog)
                                    {
                                        fsbbuild2[i].BeginErrorReadLine();
                                        fsbbuild2[i].BeginOutputReadLine();
                                    }
                                }
                                fsbbuild3.StartInfo.Arguments =
                                    (folder + music + "\\fastgh3.fsb.xen").EncloseWithQuoteMarks();
                            }
                        }
                        else
                        {
                            Console.WriteLine("Cached audio found.");
                            File.Copy(
                                folder + "\\DATA\\CACHE\\" + audhash.ToString("X16"),
                                folder + "\\DATA\\MUSIC\\fastgh3.fsb.xen", true);
                        }
                        #endregion
                        disallowGameStartup();
                        if (!chartCache)
                        {
                            if (cacheEnabled)
                                Console.WriteLine("Chart is not cached.");
                            Console.WriteLine("Generating QB template.");
                            verboseline("Creating new QB files...");
                            disallowGameStartup();
                            Array.Copy(paknewP1, 0, paknew, 0, paknewP1.Length);
                            Array.Copy(qbnew, 0, paknew, 0x1000, qbnew.Length);
                            for (int i = 0x1020; i < 4; i++)
                            {
                                paknew[i] = 0xAB;
                            }
                            for (int i = 0x1030; i < paknew.Length; i++)
                            {
                                paknew[i] = 0xAB;
                            }
                            File.WriteAllBytes(folder + pak + "song.pak.xen", paknew);
                            verboseline("Creating PakFormat and PakEditor from song.pak");
                            Console.WriteLine("Opening song pak.");
                            PakFormat pakformat = new PakFormat(folder + pak + "song.pak.xen", "", "", PakFormatType.PC);
                            PakEditor buildsong;
                            try {
                                buildsong = new PakEditor(pakformat, false);
                            }
                            catch
                            {
                                verboseline("dbg.pak.xen can go kill itself");
                            }
                            Console.WriteLine("Compiling chart.");
                            verboseline("Creating QbFile using PakFormat");
                            File.WriteAllBytes(folder + pak + "song.qb", qbnew);
                            File.SetAttributes(folder + pak + "song.qb", FileAttributes.Normal);
                            QbFile songdata = new QbFile(folder + pak + "song.qb", pakformat);
                            #region BUILD ENTIRE QB FILE
                            #region GUITAR VALUES
                            verboseline("Creating note arrays...");
                            QbItemBase array_easy = new QbItemArray(songdata);
                            QbItemBase array_medium = new QbItemArray(songdata);
                            QbItemBase array_hard = new QbItemArray(songdata);
                            QbItemBase array_expert = new QbItemArray(songdata);
                            array_easy.Create(QbItemType.SectionArray);
                            array_medium.Create(QbItemType.SectionArray);
                            array_hard.Create(QbItemType.SectionArray);
                            array_expert.Create(QbItemType.SectionArray);
                            QbItemInteger notes_easy = new QbItemInteger(songdata);
                            QbItemInteger notes_medium = new QbItemInteger(songdata);
                            QbItemInteger notes_hard = new QbItemInteger(songdata);
                            QbItemInteger notes_expert = new QbItemInteger(songdata);
                            array_easy.ItemQbKey = QbKey.Create(0xE9BB103D);
                            array_medium.ItemQbKey = QbKey.Create(0xDE2FC9CC);
                            array_hard.ItemQbKey = QbKey.Create(0x61CC9578);
                            array_expert.ItemQbKey = QbKey.Create(0x57471F39);
                            OffsetTransformer OT = new OffsetTransformer(chart);
                            List<Note> spTmp = new List<Note>();
                            Note spLast = new Note(), noteLast = new Note();
                            int spTmp3 = 0, spTmp2 = 0;
                            List<int> spPnc = new List<int>();
                            foreach (Note a in chart.NoteTracks["ExpertSingle"])
                            {
                                if (a.Type == NoteType.Regular && spLast != null)
                                {
                                    //Console.WriteLine(spTmp3);
                                    noteLast = a;
                                    spTmp3 = noteLast.Offset;
                                    if (spTmp3 >= spLast.Offset && spTmp3 < spLast.OffsetEnd)
                                    {
                                        //Console.WriteLine(spTmp3 + " >= " + spLast.Offset + " && " + spTmp3 + " < " + spLast.OffsetEnd);
                                        //Console.WriteLine(a.OffsetMilliseconds(OT));
                                        spTmp2++;
                                    }
                                    else
                                    {
                                        if (spTmp2 > 0)
                                        {
                                            spPnc.Add(spTmp2);
                                            spTmp2 = 0;
                                        }
                                    }
                                }
                                if (a.Type == NoteType.Special && a.SpecialFlag == 2)
                                {
                                    spTmp.Add(a);
                                    spLast = a;
                                    spTmp3 = noteLast.Offset;
                                    if (spTmp3 >= spLast.Offset && spTmp3 < spLast.OffsetEnd)
                                    {
                                        spTmp2++;
                                    }
                                }
                            }
                            //for (int i = 0; i < spPnc.Count; i++)
                                //Console.WriteLine(spPnc[i]);
                            int test;
                            int delay = Convert.ToInt32(float.Parse(chart.Song["Offset"].Value) * 1000);
                            QbcNoteTrack tmp;
                            try
                            {
                                tmp = new QbcNoteTrack(chart.NoteTracks["EasySingle"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_easy.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_easy.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_easy.Values[(i * 3) + 1] = tmp[i].Length;
                                    notes_easy.Values[(i * 3) + 2] = tmp[i].FretMask;
                                }
                            }
                            catch
                            {
                                notes_easy.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_easy.Values[i] = 0;
                            }

                            try
                            {

                                tmp = new QbcNoteTrack(chart.NoteTracks["MediumSingle"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_medium.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_medium.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_medium.Values[(i * 3) + 1] = tmp[i].Length;
                                    notes_medium.Values[(i * 3) + 2] = tmp[i].FretMask;
                                }
                            }
                            catch
                            {
                                notes_medium.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_medium.Values[i] = 0;
                            }

                            try
                            {

                                tmp = new QbcNoteTrack(chart.NoteTracks["HardSingle"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_hard.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_hard.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_hard.Values[(i * 3) + 1] = tmp[i].Length;
                                    notes_hard.Values[(i * 3) + 2] = tmp[i].FretMask;
                                }
                            }
                            catch
                            {
                                notes_hard.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_hard.Values[i] = 0;
                            }


                            tmp = new QbcNoteTrack(chart.NoteTracks["ExpertSingle"], OT);
                            if (tmp.Count > 0)
                                test = tmp.Count;
                            else test = 3;
                            notes_expert.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                            for (int i = 0; i < tmp.Count; i++)
                            {
                                notes_expert.Values[(i * 3)] = tmp[i].Offset + delay;
                                notes_expert.Values[(i * 3) + 1] = tmp[i].Length;
                                notes_expert.Values[(i * 3) + 2] = tmp[i].FretMask;
                            }
                            verboseline("Adding note arrays to QB.");
                            songdata.AddItem(array_easy);
                            songdata.AddItem(array_medium);
                            songdata.AddItem(array_hard);
                            songdata.AddItem(array_expert);
                            array_easy.AddItem(notes_easy);
                            array_medium.AddItem(notes_medium);
                            array_hard.AddItem(notes_hard);
                            array_expert.AddItem(notes_expert);
                            verboseline("Creating and adding starpower arrays...");
                            QbItemBase array_easy_star = new QbItemArray(songdata);
                            QbItemBase array_medium_star = new QbItemArray(songdata);
                            QbItemBase array_hard_star = new QbItemArray(songdata);
                            QbItemBase array_expert_star = new QbItemArray(songdata);
                            array_easy_star.Create(QbItemType.SectionArray);
                            array_medium_star.Create(QbItemType.SectionArray);
                            array_hard_star.Create(QbItemType.SectionArray);
                            array_expert_star.Create(QbItemType.SectionArray);
                            QbItemBase array_easy_array = new QbItemArray(songdata);
                            QbItemBase array_medium_array = new QbItemArray(songdata);
                            QbItemBase array_hard_array = new QbItemArray(songdata);
                            QbItemBase array_expert_array = new QbItemArray(songdata);
                            array_easy_array.Create(QbItemType.ArrayArray);
                            array_medium_array.Create(QbItemType.ArrayArray);
                            array_hard_array.Create(QbItemType.ArrayArray);
                            array_expert_array.Create(QbItemType.ArrayArray);
                            array_easy_star.ItemQbKey = QbKey.Create(0x9C876792);
                            array_medium_star.ItemQbKey = QbKey.Create(0x4FE36D34);
                            array_hard_star.ItemQbKey = QbKey.Create(0x74F79A34);
                            array_expert_star.ItemQbKey = QbKey.Create(0x608DEDC6);
                            QbItemInteger star_easy = new QbItemInteger(songdata);
                            QbItemInteger star_medium = new QbItemInteger(songdata);
                            QbItemInteger star_hard = new QbItemInteger(songdata);
                            star_easy.Create(QbItemType.ArrayInteger, 1);
                            star_medium.Create(QbItemType.ArrayInteger, 1);
                            star_hard.Create(QbItemType.ArrayInteger, 1);
                            songdata.AddItem(array_easy_star);
                            songdata.AddItem(array_medium_star);
                            songdata.AddItem(array_hard_star);
                            array_easy_star.AddItem(array_easy_array);
                            array_medium_star.AddItem(array_medium_array);
                            array_hard_star.AddItem(array_hard_array);
                            array_expert_star.AddItem(array_expert_array);
                            QbItemInteger star_expert;
                            int spPnc2 = 0;
                            if (spTmp.Count != 0)
                                foreach (Note a in spTmp)
                                {
                                    star_expert = new QbItemInteger(songdata);
                                    star_expert.Create(QbItemType.ArrayInteger, 3);
                                    star_expert.Values[0] = (int)Math.Round(OT.GetTime(a.Offset) * 1000) + delay;
                                    star_expert.Values[1] = (int)Math.Round(OT.GetTime(a.Length) * 1000);
                                    star_expert.Values[2] = spPnc[spPnc2];
                                    array_expert_array.AddItem(star_expert);
                                    spPnc2++;
                                }
                            else
                            {
                                star_expert = new QbItemInteger(songdata);
                                star_expert.Create(QbItemType.ArrayInteger, 1);
                                array_expert_array.AddItem(star_expert);
                            }
                            // STILL MAKE THIS IN LOOPS 2ND REMINDER AJE(IQE)(JQARGYJ)(!#{?P>:$!>":!$^
                            songdata.AddItem(array_expert_star);
                            verboseline("Creating powerup arrays...");
                            QbItemBase array_easy_battle = new QbItemArray(songdata);
                            QbItemBase array_medium_battle = new QbItemArray(songdata);
                            QbItemBase array_hard_battle = new QbItemArray(songdata);
                            QbItemBase array_expert_battle = new QbItemArray(songdata);
                            array_easy_battle.Create(QbItemType.SectionArray);
                            array_medium_battle.Create(QbItemType.SectionArray);
                            array_hard_battle.Create(QbItemType.SectionArray);
                            array_expert_battle.Create(QbItemType.SectionArray);
                            QbItemBase array_easy_battle_array = new QbItemArray(songdata);
                            QbItemBase array_medium_battle_array = new QbItemArray(songdata);
                            QbItemBase array_hard_battle_array = new QbItemArray(songdata);
                            QbItemBase array_expert_battle_array = new QbItemArray(songdata);
                            array_easy_battle_array.Create(QbItemType.ArrayArray);
                            array_medium_battle_array.Create(QbItemType.ArrayArray);
                            array_hard_battle_array.Create(QbItemType.ArrayArray);
                            array_expert_battle_array.Create(QbItemType.ArrayArray);
                            array_easy_battle.ItemQbKey = QbKey.Create(0xBA97A161);
                            array_medium_battle.ItemQbKey = QbKey.Create(0x4575E6F0);
                            array_hard_battle.ItemQbKey = QbKey.Create(0xE57786DA);
                            array_expert_battle.ItemQbKey = QbKey.Create(0xCB0D41E7);
                            QbItemInteger battle_easy = new QbItemInteger(songdata);
                            QbItemInteger battle_medium = new QbItemInteger(songdata);
                            QbItemInteger battle_hard = new QbItemInteger(songdata);
                            QbItemInteger battle_expert = new QbItemInteger(songdata);
                            battle_easy.Create(QbItemType.ArrayInteger, 1);
                            battle_medium.Create(QbItemType.ArrayInteger, 1);
                            battle_hard.Create(QbItemType.ArrayInteger, 1);
                            //battle_expert.Create(QbItemType.ArrayInteger, 1);
                            verboseline("Adding powerup arrays to QB...");
                            songdata.AddItem(array_easy_battle);
                            songdata.AddItem(array_medium_battle);
                            songdata.AddItem(array_hard_battle);
                            songdata.AddItem(array_expert_battle);
                            array_easy_battle.AddItem(array_easy_battle_array);
                            array_medium_battle.AddItem(array_medium_battle_array);
                            array_hard_battle.AddItem(array_hard_battle_array);
                            array_expert_battle.AddItem(array_expert_battle_array);
                            List<Note> bpTmp = new List<Note>();
                            foreach (Note a in chart.NoteTracks["ExpertSingle"])
                                if (a.Type == NoteType.Special && a.SpecialFlag == 3)
                                    spTmp.Add(a);
                            if (spTmp.Count != 0)
                                foreach (Note a in spTmp)
                                {
                                    //battle_expert = new QbItemInteger(songdata);
                                    battle_expert.Create(QbItemType.ArrayInteger, 3);
                                    battle_expert.Values[0] = (int)Math.Round(OT.GetTime(a.Offset) * 1000) + delay;
                                    battle_expert.Values[1] = (int)Math.Round(OT.GetTime(a.Length) * 1000);
                                    battle_expert.Values[2] = 10;
                                    //array_expert_battle_array.AddItem(battle_expert);
                                }
                            else
                            {
                                //battle_expert = new QbItemInteger(songdata);
                                battle_expert.Create(QbItemType.ArrayInteger, 1);
                                //array_expert_battle_array.AddItem(battle_expert);
                            }
                            array_easy_battle_array.AddItem(battle_easy);
                            array_medium_battle_array.AddItem(battle_medium);
                            array_hard_battle_array.AddItem(battle_hard);
                            array_expert_battle_array.AddItem(battle_expert);
                            #endregion
                            #region RHYTHM VALUES
                            verboseline("Creating rhythm arrays...");
                            QbItemBase array_easy_rhythm = new QbItemArray(songdata);
                            QbItemBase array_medium_rhythm = new QbItemArray(songdata);
                            QbItemBase array_hard_rhythm = new QbItemArray(songdata);
                            QbItemBase array_expert_rhythm = new QbItemArray(songdata);
                            array_easy_rhythm.Create(QbItemType.SectionArray);
                            array_medium_rhythm.Create(QbItemType.SectionArray);
                            array_hard_rhythm.Create(QbItemType.SectionArray);
                            array_expert_rhythm.Create(QbItemType.SectionArray);
                            QbItemInteger notes_easy_rhythm = new QbItemInteger(songdata);
                            QbItemInteger notes_medium_rhythm = new QbItemInteger(songdata);
                            QbItemInteger notes_hard_rhythm = new QbItemInteger(songdata);
                            QbItemInteger notes_expert_rhythm = new QbItemInteger(songdata);
                            array_easy_rhythm.ItemQbKey = QbKey.Create(0xADA797E4);
                            array_medium_rhythm.ItemQbKey = QbKey.Create(0xFD09E505);
                            array_hard_rhythm.ItemQbKey = QbKey.Create(0x25D012A1);
                            array_expert_rhythm.ItemQbKey = QbKey.Create(0x746133F0);
                            try
                            {
                                tmp = new QbcNoteTrack(chart.NoteTracks["EasyDoubleBass"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_easy_rhythm.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_easy_rhythm.Values[(i * 3)] = (tmp[i].Offset + delay);
                                    notes_easy_rhythm.Values[(i * 3) + 1] = (tmp[i].Length);
                                    notes_easy_rhythm.Values[(i * 3) + 2] = (tmp[i].FretMask);
                                }
                            }
                            catch
                            {
                                notes_easy_rhythm.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_easy_rhythm.Values[i] = 0;
                            }

                            try
                            {
                                tmp = new QbcNoteTrack(chart.NoteTracks["MediumDoubleBass"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_medium_rhythm.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_medium_rhythm.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_medium_rhythm.Values[(i * 3) + 1] = (tmp[i].Length);
                                    notes_medium_rhythm.Values[(i * 3) + 2] = (tmp[i].FretMask);
                                }
                            }
                            catch
                            {
                                notes_medium_rhythm.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_medium_rhythm.Values[i] = 0;
                            }

                            try
                            {

                                tmp = new QbcNoteTrack(chart.NoteTracks["HardDoubleBass"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_hard_rhythm.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_hard_rhythm.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_hard_rhythm.Values[(i * 3) + 1] = (tmp[i].Length);
                                    notes_hard_rhythm.Values[(i * 3) + 2] = (tmp[i].FretMask);
                                }
                            }
                            catch
                            {
                                notes_hard_rhythm.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_hard_rhythm.Values[i] = 0;
                            }

                            try
                            {

                                tmp = new QbcNoteTrack(chart.NoteTracks["ExpertDoubleBass"], OT);
                                if (tmp.Count > 0)
                                    test = tmp.Count;
                                else test = 3;
                                notes_expert_rhythm.Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                for (int i = 0; i < tmp.Count; i++)
                                {
                                    notes_expert_rhythm.Values[(i * 3)] = tmp[i].Offset + delay;
                                    notes_expert_rhythm.Values[(i * 3) + 1] = (tmp[i].Length);
                                    notes_expert_rhythm.Values[(i * 3) + 2] = (tmp[i].FretMask);
                                }
                            }
                            catch
                            {
                                notes_expert_rhythm.Create(QbItemType.ArrayInteger, 3);
                                for (int i = 0; i < 3; i++)
                                    notes_expert_rhythm.Values[i] = 0;
                            }
                            verboseline("Adding rhythm arrays to QB.");
                            songdata.AddItem(array_easy_rhythm);
                            songdata.AddItem(array_medium_rhythm);
                            songdata.AddItem(array_hard_rhythm);
                            songdata.AddItem(array_expert_rhythm);
                            array_easy_rhythm.AddItem(notes_easy_rhythm);
                            array_medium_rhythm.AddItem(notes_medium_rhythm);
                            array_hard_rhythm.AddItem(notes_hard_rhythm);
                            array_expert_rhythm.AddItem(notes_expert_rhythm);
                            verboseline("Creating rhythm starpower arrays...");
                            QbItemBase array_easy_star_rhythm = new QbItemArray(songdata);
                            QbItemBase array_medium_star_rhythm = new QbItemArray(songdata);
                            QbItemBase array_hard_star_rhythm = new QbItemArray(songdata);
                            QbItemBase array_expert_star_rhythm = new QbItemArray(songdata);
                            array_easy_star_rhythm.Create(QbItemType.SectionArray);
                            array_medium_star_rhythm.Create(QbItemType.SectionArray);
                            array_hard_star_rhythm.Create(QbItemType.SectionArray);
                            array_expert_star_rhythm.Create(QbItemType.SectionArray);
                            QbItemBase array_easy_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_medium_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_hard_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_expert_array_rhythm = new QbItemArray(songdata);
                            array_easy_array_rhythm.Create(QbItemType.ArrayArray);
                            array_medium_array_rhythm.Create(QbItemType.ArrayArray);
                            array_hard_array_rhythm.Create(QbItemType.ArrayArray);
                            array_expert_array_rhythm.Create(QbItemType.ArrayArray);
                            array_easy_star_rhythm.ItemQbKey = QbKey.Create(0x4664E500);
                            array_medium_star_rhythm.ItemQbKey = QbKey.Create(0x0F22BD43);
                            array_hard_star_rhythm.ItemQbKey = QbKey.Create(0xAE1418A6);
                            array_expert_star_rhythm.ItemQbKey = QbKey.Create(0x204C3DB1);
                            QbItemInteger star_easy_rhythm = new QbItemInteger(songdata);
                            QbItemInteger star_medium_rhythm = new QbItemInteger(songdata);
                            QbItemInteger star_hard_rhythm = new QbItemInteger(songdata);
                            QbItemInteger star_expert_rhythm = new QbItemInteger(songdata);
                            star_easy_rhythm.Create(QbItemType.ArrayInteger, 1);
                            star_medium_rhythm.Create(QbItemType.ArrayInteger, 1);
                            star_hard_rhythm.Create(QbItemType.ArrayInteger, 1);
                            star_expert_rhythm.Create(QbItemType.ArrayInteger, 1);
                            verboseline("Creating rhythm powerup arrays...");
                            QbItemBase array_easy_battle_rhythm = new QbItemArray(songdata);
                            QbItemBase array_medium_battle_rhythm = new QbItemArray(songdata);
                            QbItemBase array_hard_battle_rhythm = new QbItemArray(songdata);
                            QbItemBase array_expert_battle_rhythm = new QbItemArray(songdata);
                            array_easy_battle_rhythm.Create(QbItemType.SectionArray);
                            array_medium_battle_rhythm.Create(QbItemType.SectionArray);
                            array_hard_battle_rhythm.Create(QbItemType.SectionArray);
                            array_expert_battle_rhythm.Create(QbItemType.SectionArray);
                            QbItemBase array_easy_battle_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_medium_battle_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_hard_battle_array_rhythm = new QbItemArray(songdata);
                            QbItemBase array_expert_battle_array_rhythm = new QbItemArray(songdata);
                            array_easy_battle_array_rhythm.Create(QbItemType.ArrayArray);
                            array_medium_battle_array_rhythm.Create(QbItemType.ArrayArray);
                            array_hard_battle_array_rhythm.Create(QbItemType.ArrayArray);
                            array_expert_battle_array_rhythm.Create(QbItemType.ArrayArray);
                            array_easy_battle_rhythm.ItemQbKey = QbKey.Create(0x3586AFF5);
                            array_medium_battle_rhythm.ItemQbKey = QbKey.Create(0xB7E00BF8);
                            array_hard_battle_rhythm.ItemQbKey = QbKey.Create(0x6A66884E);
                            array_expert_battle_rhythm.ItemQbKey = QbKey.Create(0x3998ACEF);
                            QbItemInteger battle_easy_rhythm = new QbItemInteger(songdata);
                            QbItemInteger battle_medium_rhythm = new QbItemInteger(songdata);
                            QbItemInteger battle_hard_rhythm = new QbItemInteger(songdata);
                            QbItemInteger battle_expert_rhythm = new QbItemInteger(songdata);
                            battle_easy_rhythm.Create(QbItemType.ArrayInteger, 1);
                            battle_medium_rhythm.Create(QbItemType.ArrayInteger, 1);
                            battle_hard_rhythm.Create(QbItemType.ArrayInteger, 1);
                            battle_expert_rhythm.Create(QbItemType.ArrayInteger, 1);
                            verboseline("Adding rhythm starpower arrays to QB...");
                            songdata.AddItem(array_easy_star_rhythm);
                            songdata.AddItem(array_medium_star_rhythm);
                            songdata.AddItem(array_hard_star_rhythm);
                            songdata.AddItem(array_expert_star_rhythm);
                            array_easy_star_rhythm.AddItem(array_easy_array_rhythm);
                            array_medium_star_rhythm.AddItem(array_medium_array_rhythm);
                            array_hard_star_rhythm.AddItem(array_hard_array_rhythm);
                            array_expert_star_rhythm.AddItem(array_expert_array_rhythm);
                            array_easy_array_rhythm.AddItem(star_easy_rhythm);
                            array_medium_array_rhythm.AddItem(star_medium_rhythm);
                            array_hard_array_rhythm.AddItem(star_hard_rhythm);
                            array_expert_array_rhythm.AddItem(star_expert_rhythm);
                            verboseline("Adding rhythm powerup arrays to QB...");
                            songdata.AddItem(array_easy_battle_rhythm);
                            songdata.AddItem(array_medium_battle_rhythm);
                            songdata.AddItem(array_hard_battle_rhythm);
                            songdata.AddItem(array_expert_battle_rhythm);
                            array_easy_battle_rhythm.AddItem(array_easy_battle_array_rhythm);
                            array_medium_battle_rhythm.AddItem(array_medium_battle_array_rhythm);
                            array_hard_battle_rhythm.AddItem(array_hard_battle_array_rhythm);
                            array_expert_battle_rhythm.AddItem(array_expert_battle_array_rhythm);
                            array_easy_battle_array_rhythm.AddItem(battle_easy_rhythm);
                            array_medium_battle_array_rhythm.AddItem(battle_medium_rhythm);
                            array_hard_battle_array_rhythm.AddItem(battle_hard_rhythm);
                            array_expert_battle_array_rhythm.AddItem(battle_expert_rhythm);
                            #endregion
                            #region END TIME
                            verboseline("Getting end time...");
                            int endtime = Math.Max(
                                Math.Max(
                                Math.Max(
                                notes_easy.Values[notes_easy.Values.Length - 3] + notes_easy.Values[notes_easy.Values.Length - 2],
                                notes_medium.Values[notes_medium.Values.Length - 3] + notes_medium.Values[notes_medium.Values.Length - 2]),
                                Math.Max(
                                notes_hard.Values[notes_hard.Values.Length - 3] + notes_hard.Values[notes_hard.Values.Length - 2],
                                notes_expert.Values[notes_expert.Values.Length - 3] + notes_expert.Values[notes_expert.Values.Length - 2])),
                                Math.Max(
                                Math.Max(
                                notes_easy_rhythm.Values[notes_easy_rhythm.Values.Length - 3] + notes_easy_rhythm.Values[notes_easy_rhythm.Values.Length - 2],
                                notes_medium_rhythm.Values[notes_medium_rhythm.Values.Length - 3] + notes_medium_rhythm.Values[notes_medium_rhythm.Values.Length - 2]),
                                Math.Max(
                                notes_hard_rhythm.Values[notes_hard_rhythm.Values.Length - 3] + notes_hard_rhythm.Values[notes_hard_rhythm.Values.Length - 2],
                                notes_expert_rhythm.Values[notes_expert_rhythm.Values.Length - 3] + notes_expert_rhythm.Values[notes_expert_rhythm.Values.Length - 2]
                                )));
                            verboseline("End time is " + endtime);
                            #endregion
                            #region CO-OP VALUES
                            verboseline("Creating co-op guitar arrays...");
                            QbItemBase array_easy_lead = new QbItemArray(songdata);
                            QbItemBase array_medium_lead = new QbItemArray(songdata);
                            QbItemBase array_hard_lead = new QbItemArray(songdata);
                            QbItemBase array_expert_lead = new QbItemArray(songdata);
                            array_easy_lead.Create(QbItemType.SectionArray);
                            array_medium_lead.Create(QbItemType.SectionArray);
                            array_hard_lead.Create(QbItemType.SectionArray);
                            array_expert_lead.Create(QbItemType.SectionArray);
                            QbItemFloats notes_easy_lead = new QbItemFloats(songdata);
                            QbItemFloats notes_medium_lead = new QbItemFloats(songdata);
                            QbItemFloats notes_hard_lead = new QbItemFloats(songdata);
                            QbItemFloats notes_expert_lead = new QbItemFloats(songdata);
                            array_easy_lead.ItemQbKey = QbKey.Create(0xFEEB1B7A);
                            array_medium_lead.ItemQbKey = QbKey.Create(0xF6C5DED6);
                            array_hard_lead.ItemQbKey = QbKey.Create(0x769C9E3F);
                            array_expert_lead.ItemQbKey = QbKey.Create(0x7FAD0823);
                            notes_easy_lead.Create(QbItemType.Floats);
                            notes_medium_lead.Create(QbItemType.Floats);
                            notes_hard_lead.Create(QbItemType.Floats);
                            notes_expert_lead.Create(QbItemType.Floats);
                            verboseline("Adding co-op guitar arrays to QB.");
                            songdata.AddItem(array_easy_lead);
                            songdata.AddItem(array_medium_lead);
                            songdata.AddItem(array_hard_lead);
                            songdata.AddItem(array_expert_lead);
                            array_easy_lead.AddItem(notes_easy_lead);
                            array_medium_lead.AddItem(notes_medium_lead);
                            array_hard_lead.AddItem(notes_hard_lead);
                            array_expert_lead.AddItem(notes_expert_lead);
                            verboseline("Creating co-op guitar starpower arrays...");
                            QbItemBase array_easy_star_lead = new QbItemArray(songdata);
                            QbItemBase array_medium_star_lead = new QbItemArray(songdata);
                            QbItemBase array_hard_star_lead = new QbItemArray(songdata);
                            QbItemBase array_expert_star_lead = new QbItemArray(songdata);
                            array_easy_star_lead.Create(QbItemType.SectionArray);
                            array_medium_star_lead.Create(QbItemType.SectionArray);
                            array_hard_star_lead.Create(QbItemType.SectionArray);
                            array_expert_star_lead.Create(QbItemType.SectionArray);
                            array_easy_star_lead.ItemQbKey = QbKey.Create(0xCA915FBE);
                            array_medium_star_lead.ItemQbKey = QbKey.Create(0x5ED0E812);
                            array_hard_star_lead.ItemQbKey = QbKey.Create(0x22E1A218);
                            array_expert_star_lead.ItemQbKey = QbKey.Create(0x71BE68E0);
                            QbItemFloats star_easy_lead = new QbItemFloats(songdata);
                            QbItemFloats star_medium_lead = new QbItemFloats(songdata);
                            QbItemFloats star_hard_lead = new QbItemFloats(songdata);
                            QbItemFloats star_expert_lead = new QbItemFloats(songdata);
                            star_easy_lead.Create(QbItemType.Floats);
                            star_medium_lead.Create(QbItemType.Floats);
                            star_hard_lead.Create(QbItemType.Floats);
                            star_expert_lead.Create(QbItemType.Floats);
                            verboseline("Creating co-op guitar powerup arrays...");
                            QbItemBase array_easy_battle_lead = new QbItemArray(songdata);
                            QbItemBase array_medium_battle_lead = new QbItemArray(songdata);
                            QbItemBase array_hard_battle_lead = new QbItemArray(songdata);
                            QbItemBase array_expert_battle_lead = new QbItemArray(songdata);
                            array_easy_battle_lead.Create(QbItemType.SectionArray);
                            array_medium_battle_lead.Create(QbItemType.SectionArray);
                            array_hard_battle_lead.Create(QbItemType.SectionArray);
                            array_expert_battle_lead.Create(QbItemType.SectionArray);
                            array_easy_battle_lead.ItemQbKey = QbKey.Create(0x80CEC4D4);
                            array_medium_battle_lead.ItemQbKey = QbKey.Create(0xE11F1383);
                            array_hard_battle_lead.ItemQbKey = QbKey.Create(0xDF2EE36F);
                            array_expert_battle_lead.ItemQbKey = QbKey.Create(0x6F67B494);
                            QbItemFloats battle_easy_lead = new QbItemFloats(songdata);
                            QbItemFloats battle_medium_lead = new QbItemFloats(songdata);
                            QbItemFloats battle_hard_lead = new QbItemFloats(songdata);
                            QbItemFloats battle_expert_lead = new QbItemFloats(songdata);
                            battle_easy_lead.Create(QbItemType.Floats);
                            battle_medium_lead.Create(QbItemType.Floats);
                            battle_hard_lead.Create(QbItemType.Floats);
                            battle_expert_lead.Create(QbItemType.Floats);
                            verboseline("Adding co-op guitar starpower arrays to QB...");
                            songdata.AddItem(array_easy_star_lead);
                            songdata.AddItem(array_medium_star_lead);
                            songdata.AddItem(array_hard_star_lead);
                            songdata.AddItem(array_expert_star_lead);
                            array_easy_star_lead.AddItem(star_easy_lead);
                            array_medium_star_lead.AddItem(star_medium_lead);
                            array_hard_star_lead.AddItem(star_hard_lead);
                            array_expert_star_lead.AddItem(star_expert_lead);
                            verboseline("Adding co-op guitar powerup arrays to QB...");
                            songdata.AddItem(array_easy_battle_lead);
                            songdata.AddItem(array_medium_battle_lead);
                            songdata.AddItem(array_hard_battle_lead);
                            songdata.AddItem(array_expert_battle_lead);
                            array_easy_battle_lead.AddItem(battle_easy_lead);
                            array_medium_battle_lead.AddItem(battle_medium_lead);
                            array_hard_battle_lead.AddItem(battle_hard_lead);
                            array_expert_battle_lead.AddItem(battle_expert_lead);
                            verboseline("Creating co-op rhythm arrays...");
                            QbItemBase array_easy_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_medium_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_hard_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_expert_rhythm_coop = new QbItemArray(songdata);
                            array_easy_rhythm_coop.Create(QbItemType.SectionArray);
                            array_medium_rhythm_coop.Create(QbItemType.SectionArray);
                            array_hard_rhythm_coop.Create(QbItemType.SectionArray);
                            array_expert_rhythm_coop.Create(QbItemType.SectionArray);
                            QbItemFloats notes_easy_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats notes_medium_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats notes_hard_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats notes_expert_rhythm_coop = new QbItemFloats(songdata);
                            array_easy_rhythm_coop.ItemQbKey = QbKey.Create(0x41A934B3);
                            array_medium_rhythm_coop.ItemQbKey = QbKey.Create(0x472C30CA);
                            array_hard_rhythm_coop.ItemQbKey = QbKey.Create(0xC9DEB1F6);
                            array_expert_rhythm_coop.ItemQbKey = QbKey.Create(0xCE44E63F);
                            notes_easy_rhythm_coop.Create(QbItemType.Floats);
                            notes_medium_rhythm_coop.Create(QbItemType.Floats);
                            notes_hard_rhythm_coop.Create(QbItemType.Floats);
                            notes_expert_rhythm_coop.Create(QbItemType.Floats);
                            verboseline("Adding co-op rhythm arrays to QB.");
                            songdata.AddItem(array_easy_rhythm_coop);
                            songdata.AddItem(array_medium_rhythm_coop);
                            songdata.AddItem(array_hard_rhythm_coop);
                            songdata.AddItem(array_expert_rhythm_coop);
                            array_easy_rhythm_coop.AddItem(notes_easy_rhythm_coop);
                            array_medium_rhythm_coop.AddItem(notes_medium_rhythm_coop);
                            array_hard_rhythm_coop.AddItem(notes_hard_rhythm_coop);
                            array_expert_rhythm_coop.AddItem(notes_expert_rhythm_coop);
                            verboseline("Creating co-op rhythm starpower arrays...");
                            QbItemBase array_easy_star_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_medium_star_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_hard_star_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_expert_star_rhythm_coop = new QbItemArray(songdata);
                            array_easy_star_rhythm_coop.Create(QbItemType.SectionArray);
                            array_medium_star_rhythm_coop.Create(QbItemType.SectionArray);
                            array_hard_star_rhythm_coop.Create(QbItemType.SectionArray);
                            array_expert_star_rhythm_coop.Create(QbItemType.SectionArray);
                            array_easy_star_rhythm_coop.ItemQbKey = QbKey.Create(0xC68681A5);
                            array_medium_star_rhythm_coop.ItemQbKey = QbKey.Create(0x968DD04C);
                            array_hard_star_rhythm_coop.ItemQbKey = QbKey.Create(0x2EF67C03);
                            array_expert_star_rhythm_coop.ItemQbKey = QbKey.Create(0xB9E350BE);
                            QbItemFloats star_easy_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats star_medium_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats star_hard_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats star_expert_rhythm_coop = new QbItemFloats(songdata);
                            star_easy_rhythm_coop.Create(QbItemType.Floats);
                            star_medium_rhythm_coop.Create(QbItemType.Floats);
                            star_hard_rhythm_coop.Create(QbItemType.Floats);
                            star_expert_rhythm_coop.Create(QbItemType.Floats);
                            verboseline("Creating co-op rhythm powerup arrays...");
                            QbItemBase array_easy_battle_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_medium_battle_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_hard_battle_rhythm_coop = new QbItemArray(songdata);
                            QbItemBase array_expert_battle_rhythm_coop = new QbItemArray(songdata);
                            array_easy_battle_rhythm_coop.Create(QbItemType.SectionArray);
                            array_medium_battle_rhythm_coop.Create(QbItemType.SectionArray);
                            array_hard_battle_rhythm_coop.Create(QbItemType.SectionArray);
                            array_expert_battle_rhythm_coop.Create(QbItemType.SectionArray);
                            array_easy_battle_rhythm_coop.ItemQbKey = QbKey.Create(0x329B7626);
                            array_medium_battle_rhythm_coop.ItemQbKey = QbKey.Create(0xE2FAF049);
                            array_hard_battle_rhythm_coop.ItemQbKey = QbKey.Create(0x6D7B519D);
                            array_expert_battle_rhythm_coop.ItemQbKey = QbKey.Create(0x6C82575E);
                            QbItemFloats battle_easy_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats battle_medium_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats battle_hard_rhythm_coop = new QbItemFloats(songdata);
                            QbItemFloats battle_expert_rhythm_coop = new QbItemFloats(songdata);
                            battle_easy_rhythm_coop.Create(QbItemType.Floats);
                            battle_medium_rhythm_coop.Create(QbItemType.Floats);
                            battle_hard_rhythm_coop.Create(QbItemType.Floats);
                            battle_expert_rhythm_coop.Create(QbItemType.Floats);
                            verboseline("Adding co-op rhythm starpower arrays to QB...");
                            songdata.AddItem(array_easy_star_rhythm_coop);
                            songdata.AddItem(array_medium_star_rhythm_coop);
                            songdata.AddItem(array_hard_star_rhythm_coop);
                            songdata.AddItem(array_expert_star_rhythm_coop);
                            array_easy_star_rhythm_coop.AddItem(star_easy_rhythm_coop);
                            array_medium_star_rhythm_coop.AddItem(star_medium_rhythm_coop);
                            array_hard_star_rhythm_coop.AddItem(star_hard_rhythm_coop);
                            array_expert_star_rhythm_coop.AddItem(star_expert_rhythm_coop);
                            verboseline("Adding co-op rhythm powerup arrays to QB...");
                            songdata.AddItem(array_easy_battle_rhythm_coop);
                            songdata.AddItem(array_medium_battle_rhythm_coop);
                            songdata.AddItem(array_hard_battle_rhythm_coop);
                            songdata.AddItem(array_expert_battle_rhythm_coop);
                            array_easy_battle_rhythm_coop.AddItem(battle_easy_rhythm_coop);
                            array_medium_battle_rhythm_coop.AddItem(battle_medium_rhythm_coop);
                            array_hard_battle_rhythm_coop.AddItem(battle_hard_rhythm_coop);
                            array_expert_battle_rhythm_coop.AddItem(battle_expert_rhythm_coop);
                            #endregion
                            #region FACE-OFF/BATTLE VALUES
                            verboseline("Creating face-off arrays...");
                            QbItemBase array_faceoff_p1 = new QbItemArray(songdata);
                            QbItemBase array_faceoff_p2 = new QbItemArray(songdata);
                            array_faceoff_p1.Create(QbItemType.SectionArray);
                            array_faceoff_p2.Create(QbItemType.SectionArray);
                            QbItemBase array_faceoff_p1_array = new QbItemArray(songdata);
                            QbItemBase array_faceoff_p2_array = new QbItemArray(songdata);
                            array_faceoff_p1_array.Create(QbItemType.ArrayArray);
                            array_faceoff_p2_array.Create(QbItemType.ArrayArray);
                            array_faceoff_p1.ItemQbKey = QbKey.Create(0xD3885E76);
                            array_faceoff_p2.ItemQbKey = QbKey.Create(0x4A810FCC);
                            QbItemInteger faceoff_p1 = new QbItemInteger(songdata);
                            QbItemInteger faceoff_p2 = new QbItemInteger(songdata);
                            faceoff_p1.Create(QbItemType.ArrayInteger, 2);
                            faceoff_p2.Create(QbItemType.ArrayInteger, 2);
                            verboseline("Adding face-off arrays to QB...");
                            songdata.AddItem(array_faceoff_p1);
                            songdata.AddItem(array_faceoff_p2);
                            array_faceoff_p1.AddItem(array_faceoff_p1_array);
                            array_faceoff_p2.AddItem(array_faceoff_p2_array);
                            array_faceoff_p1_array.AddItem(faceoff_p1);
                            array_faceoff_p2_array.AddItem(faceoff_p2);
                            verboseline("Creating battle arrays...");
                            QbItemBase array_battle_p1 = new QbItemArray(songdata);
                            QbItemBase array_battle_p2 = new QbItemArray(songdata);
                            array_battle_p1.Create(QbItemType.SectionArray);
                            array_battle_p2.Create(QbItemType.SectionArray);
                            QbItemFloats array_battle_p1_array = new QbItemFloats(songdata);
                            QbItemFloats array_battle_p2_array = new QbItemFloats(songdata);
                            array_battle_p1.ItemQbKey = QbKey.Create(0xD2854CE4);
                            array_battle_p2.ItemQbKey = QbKey.Create(0x4B8C1D5E);
                            array_battle_p1_array.Create(QbItemType.Floats);
                            array_battle_p2_array.Create(QbItemType.Floats);
                            verboseline("Adding battle arrays to QB.");
                            songdata.AddItem(array_battle_p1);
                            songdata.AddItem(array_battle_p2);
                            array_battle_p1.AddItem(array_battle_p1_array);
                            array_battle_p2.AddItem(array_battle_p2_array);
                            #endregion
                            #region MEASURE VALUES
                            verboseline("Creating time signature arrays...");
                            QbItemBase array_timesig = new QbItemArray(songdata);
                            array_timesig.Create(QbItemType.SectionArray);
                            QbItemBase array_timesig_array = new QbItemArray(songdata);
                            array_timesig_array.Create(QbItemType.ArrayArray);
                            array_timesig.ItemQbKey = QbKey.Create(0x32F59FAE);
                            verboseline("Reading TS values from file...");
                            List<SyncTrackEntry> ts = new List<SyncTrackEntry>();
                            for (int i = 0; i < chart.SyncTrack.Count; i++)
                            {
                                if (chart.SyncTrack[i].Type == SyncType.TimeSignature)
                                {
                                    ts.Add(chart.SyncTrack[i]);
                                }
                            }
                            int timesigcount = ts.Count;
                            QbItemInteger[] timesig = new QbItemInteger[timesigcount];
                            for (int i = 0; i < timesigcount; i++)
                            {
                                verboseline("Creating time signature #" + i.ToString() + "...");
                                timesig[i] = new QbItemInteger(songdata);
                                timesig[i].Create(QbItemType.ArrayInteger, 3);
                            }
                            for (int i = 0; i < timesigcount; i++)
                            {
                                verboseline("Setting TS #" + (i).ToString() + " values (1/3) (" + Convert.ToInt32(Math.Round(OT.GetTime(ts[i].Offset) * 1000) + delay) + ")...");
                                timesig[i].Values[0] = Convert.ToInt32(Math.Round(OT.GetTime(ts[i].Offset) * 1000) + delay);
                                verboseline("Setting TS #" + (i).ToString() + " values (2/3) (" + Convert.ToInt32(ts[i].TimeSignature) + ")...");
                                timesig[i].Values[1] = Convert.ToInt32(ts[i].TimeSignature);
                                verboseline("Setting TS #" + (i).ToString() + " values (3/3) (" + 4 + ")...");
                                timesig[i].Values[2] = 4;
                            }
                            verboseline("Adding time signature arrays to QB...");
                            songdata.AddItem(array_timesig);
                            array_timesig.AddItem(array_timesig_array);
                            for (int i = 0; i < timesigcount; i++)
                                array_timesig_array.AddItem(timesig[i]);
                            verboseline("Creating fretbar arrays...");
                            QbItemBase array_fretbars = new QbItemArray(songdata);
                            array_fretbars.Create(QbItemType.SectionArray);
                            array_fretbars.ItemQbKey = QbKey.Create(0xC3C71E9D);
                            QbItemInteger fretbars = new QbItemInteger(songdata);
                            List<int> msrs = new List<int>();
                            for (int i = 0; OT.GetTime(i) < OT.songLength + chart.Resolution; i += chart.Resolution)
                            {
                                msrs.Add(Convert.ToInt32(OT.GetTime(i) * 1000));
                            }
                            {
                                fretbars.Create(QbItemType.ArrayInteger, msrs.Count);
                                for (int i = 0; i < msrs.Count; i++)
                                    fretbars.Values[i] = Convert.ToInt32(msrs[i] + delay);
                            }
                            verboseline("Adding time signature arrays to QB...");
                            songdata.AddItem(array_fretbars);
                            array_fretbars.AddItem(fretbars);
                            #endregion
                            verboseline("Collecting garbage...");
                            GC.Collect();
                            #region MARKER VALUES
                            verboseline("Creating marker arrays...");
                            QbItemArray array_markers = new QbItemArray(songdata);
                            array_markers.Create(QbItemType.SectionArray);
                            QbItemStructArray array_markers_array = new QbItemStructArray(songdata);
                            array_markers.ItemQbKey = QbKey.Create(0x85C8739B);
                            array_markers_array.Create(QbItemType.ArrayStruct);
                            List<EventsSectionEntry> mrkrs = new List<EventsSectionEntry>();
                            foreach (EventsSectionEntry eventEntry in chart.Events)
                            {
                                if (eventEntry.TextValue.StartsWith("section "))
                                {
                                    mrkrs.Add(eventEntry);
                                }
                            }
                            int markercount = mrkrs.Count;
                            QbItemStruct[] markers = new QbItemStruct[markercount];
                            QbItemInteger[] markertimes = new QbItemInteger[markercount];
                            QbItemString[] markernames = new QbItemString[markercount];
                            for (int i = 0; i < markercount; i++)
                            {
                                verbose("Creating marker #" + i.ToString());
                                markers[i] = new QbItemStruct(songdata);
                                markers[i].Create(QbItemType.StructHeader);
                                verbose(": time = ");
                                markertimes[i] = new QbItemInteger(songdata);
                                markertimes[i].Create(QbItemType.StructItemInteger, 1);
                                markertimes[i].ItemQbKey = QbKey.Create(0x906B67BA);
                                verbose(mrkrs[i].Offset + delay);
                                markertimes[i].Values[0] = Convert.ToInt32(Math.Round(OT.GetTime(mrkrs[i].Offset) * 1000) + delay);
                                verbose(", name = ");
                                markernames[i] = new QbItemString(songdata);
                                markernames[i].Create(QbItemType.StructItemString);
                                markernames[i].ItemQbKey = QbKey.Create(0x7D30DF01);
                                verbose(SubstringExtensions.EncloseWithQuoteMarks(mrkrs[i].TextValue) + "\n");
                                markernames[i].Strings[0] = mrkrs[i].TextValue.Substring(8);//markerstr[i * 2 + 1];
                            }
                            verboseline("Adding marker arrays to QB.");
                            songdata.AddItem(array_markers);
                            array_markers.AddItem(array_markers_array);
                            for (int i = 0; i < markercount; i++)
                            {
                                array_markers_array.AddItem(markers[i]);
                                markers[i].AddItem(markertimes[i]);
                                markers[i].AddItem(markernames[i]);
                            }
                            #endregion
                            #region MISC VALUES
                            verboseline("Creating and adding other things...");
                            QbItemBase[] misc = new QbItemArray[16];
                            for (int i = 0; i < 16; i++)
                            {
                                misc[i] = new QbItemArray(songdata);
                                misc[i].Create(QbItemType.SectionArray);
                                misc[i].ItemQbKey = QbKey.Create(unusedKeys[i]);
                            }
                            QbItemFloats[] misc2 = new QbItemFloats[16];
                            for (int i = 0; i < 16; i++)
                            {
                                misc2[i] = new QbItemFloats(songdata);
                                misc2[i].Create(QbItemType.Floats);
                            }
                            for (int i = 0; i < 16; i++)
                            {
                                songdata.AddItem(misc[i]);
                                misc[i].AddItem(misc2[i]);
                            }
                            IniFile songini = new IniFile();
                            if (File.Exists("song.ini"))
                                songini.Load("song.ini");
                            QbItemBase songmeta = new QbItemStruct(songdata);
                            songmeta.Create(QbItemType.SectionStruct);
                            songmeta.ItemQbKey = QbKey.Create("fastgh3_meta");
                            QbItemString songtitle = new QbItemString(songdata);
                            songtitle.Create(QbItemType.StructItemString);
                            songtitle.ItemQbKey = QbKey.Create("title");
                            QbItemString songauthr = new QbItemString(songdata);
                            songauthr.Create(QbItemType.StructItemString);
                            songauthr.ItemQbKey = QbKey.Create("author");
                            QbItemString songalbum = new QbItemString(songdata);
                            songalbum.Create(QbItemType.StructItemString);
                            songalbum.ItemQbKey = QbKey.Create("album");
                            QbItemString songyear = new QbItemString(songdata);
                            songyear.Create(QbItemType.StructItemString);
                            songyear.ItemQbKey = QbKey.Create("year");
                            songtitle.Strings[0] = songini.GetKeyValue("song", "name", "Untitled").Trim();
                            songauthr.Strings[0] = songini.GetKeyValue("song", "artist", "Unknown").Trim();
                            songalbum.Strings[0] = songini.GetKeyValue("song", "album", "Unknown").Trim();
                            songyear.Strings[0] = songini.GetKeyValue("song", "year", "2021").Trim();
                            foreach (SongSectionEntry s in chart.Song)
                            {
                                if (s.Key == "Name" && (s.Value.Trim() != ""))
                                    songtitle.Strings[0] = chart.Song["Name"].Value.Trim();
                                if (s.Key == "Artist" && (s.Value.Trim() != ""))
                                    songauthr.Strings[0] = chart.Song["Artist"].Value.Trim();
                            };
                            songdata.AddItem(songmeta);
                            songmeta.AddItem(songtitle);
                            songmeta.AddItem(songauthr);
                            songmeta.AddItem(songalbum);
                            songmeta.AddItem(songyear);
                            File.WriteAllText(folder + "currentsong.txt",
                                songauthr.Strings[0] + " - " + songtitle.Strings[0]);
                            #endregion
                            #endregion
                            verboseline("Aligning pointers...");
                            songdata.AlignPointers();
                            verboseline("Writing song.qb...");
                            //songdata.Write(folder + pak + "song.qb");
                            Console.WriteLine("Compiling PAK.");
                            try {
                                buildsong.ReplaceFile("songs\fastgh3.mid.qb", songdata);// folder + pak + "song.qb"); // songs\fastgh3.mid.qb
                            }
                            catch
                            {
                                buildsong.AddFile(songdata, "songs\fastgh3.mid.qb", QbKey.Create(".qb"), false);
                            }
                            File.Delete(folder + pak + "song.qb");
                            if (cacheEnabled)
                            {
                                Console.WriteLine("Writing PAK to cache.");
                                File.Copy(
                                    folder + "\\DATA\\PAK\\song.pak.xen",
                                    folder + "\\DATA\\CACHE\\" + charthash.ToString("X16"), true);
                                cache.SetKeyValue(charthash.ToString("X16"), "Title", songtitle.Strings[0]);
                                cache.SetKeyValue(charthash.ToString("X16"), "Author", songauthr.Strings[0]);
                                cache.SetKeyValue(charthash.ToString("X16"), "Length", ((endtime / 1000) / 60).ToString("00") + ':' + (((endtime / 1000) % 60)).ToString("00"));
                                cache.Save(folder + dataf + "CACHE\\.db.ini");
                            }
                        }
                        else
                        {
                            Console.WriteLine("Cached chart found.");
                            File.Copy(
                                folder + "\\DATA\\CACHE\\" + charthash.ToString("X16"),
                                folder + "\\DATA\\PAK\\song.pak.xen", true);
                        }
                        if (!audCache)
                        {
                            if (!MTFSB)
                            {
                                if (!fsbbuild.HasExited)
                                {
                                    Console.WriteLine("Waiting for song encoding to finish.");
                                    fsbbuild.WaitForExit();
                                    if (cacheEnabled)
                                    {
                                        Console.WriteLine("Writing audio to cache.");
                                        File.Copy(
                                            folder + "\\DATA\\MUSIC\\fastgh3.fsb.xen",
                                            folder + "\\DATA\\CACHE\\" + audhash.ToString("X16"), true);
                                        cache.SetKeyValue(charthash.ToString("X16"), "Audio", audhash.ToString("X16"));
                                        cache.Save(folder + dataf + "CACHE\\.db.ini");
                                    }
                                }
                            }
                            else
                            {
                                Console.WriteLine("Waiting for song encoding to finish.");
                                for (int i = 0; i < fsbbuild2.Length; i++)
                                    if (!fsbbuild2[i].HasExited)
                                        fsbbuild2[i].WaitForExit();
                                /*if (!addaud.HasExited)
                                {
                                    Console.WriteLine("Waiting for extra track merging to finish.");
                                    addaud.WaitForExit();
                                }*/
                                fsbbuild3.Start();
                                fsbbuild3.WaitForExit();
                                {
                                    if (cacheEnabled)
                                    {
                                        Console.WriteLine("Writing audio to cache.");
                                        File.Copy(
                                            folder + "\\DATA\\MUSIC\\fastgh3.fsb.xen",
                                            folder + "\\DATA\\CACHE\\" + audhash.ToString("X16"), true);
                                        cache.SetKeyValue(charthash.ToString("X16"), "Audio", audhash.ToString("X16"));
                                        cache.Save(folder + dataf + "CACHE\\.db.ini");
                                    }
                                }
                            }
                            if (File.Exists(folder + "\\DATA\\MUSIC\\TOOLS\\mergetmp.wav"))
                                File.Delete(folder + "\\DATA\\MUSIC\\TOOLS\\mergetmp.wav");
                        }
                        //verboseline("Cleaning up...");
                        disallowGameStartup();
                        Console.WriteLine("Speeding up.");
                        verboseline("Creating GH3 process...");
                        Process gh3 = new Process();
                        gh3.StartInfo.WorkingDirectory = folder;
                        gh3.StartInfo.FileName = folder + "\\game.exe";
                        if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                        {
                            verboseline("Getting max notes...");
                            int maxnotes = 0, maxtmp = 0;
                            // wth is this
                            foreach (NoteTrack track in chart.NoteTracks)
                            {
                                maxtmp = 0;
                                foreach (Note note in track)
                                {
                                    if (note.Type == NoteType.Regular)
                                        maxtmp++;
                                }
                                maxnotes = Math.Max(maxnotes, maxtmp);
                            }
                            verboseline("Got " + maxnotes + " max notes");
                            settings.SetKeyValue("Player", "MaxNotes", maxnotes.ToString());
                            settings.Save(folder + "settings.ini");
                        }
                        Console.WriteLine("Ready, go!");
                        gh3.Start();
                        if (settings.GetKeyValue("Misc", "PreserveLog", "0") == "1")
                        {
                            Console.WriteLine("Press any key to exit");
                            Console.ReadKey();
                        }
                    }
                    else if (File.Exists(args[0]) && (args[0].EndsWith(".fsp") || args[0].EndsWith(".zip")))
                    {
                        //Console.WriteLine("FastGH3 by donnaken15");
                        Console.WriteLine("Detected song package.");
                        string tmpf = Path.GetTempPath() + "\\Z.TMP.FGH3$" + new Random().Next(0x100000, 0xFFFFFF).ToString("X5") + '\\',
                            selectedtorun = "";
                        Directory.CreateDirectory(tmpf);
                        bool compiled = false;
                        List<string> multichartcheck = new List<string>();
                        using (ZipFile file = ZipFile.Read(args[0]))
                        {
                            file.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
                            foreach (ZipEntry data in file)
                            {
                                if (data.FileName.EndsWith(".pak") ||
                                    data.FileName.EndsWith(".pak.xen"))
                                {
                                    data.Extract(tmpf);
                                    // do something with this moving when multiple files exist or whatever
                                    File.Delete(folder + pak + "song.pak.xen");
                                    File.Move(tmpf + data.FileName, folder + pak + "song.pak.xen");
                                    multichartcheck.Add(data.FileName);
                                    compiled = true;
                                }
                                if (data.FileName.EndsWith(".fsb") ||
                                    data.FileName.EndsWith(".fsb.xen"))
                                {
                                    data.Extract(tmpf);
                                    File.Delete(folder + music + "fastgh3.fsb.xen");
                                    File.Move(tmpf + data.FileName, folder + music + "fastgh3.fsb.xen");
                                }
                                if (data.FileName.EndsWith(".chart") ||
                                    data.FileName.EndsWith(".mid"))
                                {
                                    data.Extract(tmpf);
                                    // replace this
                                    multichartcheck.Add(data.FileName);
                                    selectedtorun = tmpf + data.FileName;
                                }
                                if (data.FileName.EndsWith(".ogg") ||
                                    data.FileName.EndsWith(".mp3") ||
                                    data.FileName.EndsWith(".wav"))
                                {
                                    data.Extract(tmpf);
                                }
                            }
                        }
                        bool cancel = false;
                        fspmultichart askchoose = new fspmultichart(multichartcheck.ToArray());
                        if (multichartcheck.Count > 1)
                        {
                            askchoose.ShowDialog();
                            if (File.Exists(tmpf + askchoose.chosen) && askchoose.DialogResult == DialogResult.OK)
                            {
                                selectedtorun = tmpf + askchoose.chosen;
                                compiled = !Path.GetFileName(askchoose.chosen).EndsWith(".chart") &&
                                            !Path.GetFileName(askchoose.chosen).EndsWith(".mid");
                            }
                            cancel = askchoose.DialogResult == DialogResult.Cancel;
                        }
                        if (!cancel)
                            if (compiled)
                            {
                                Console.WriteLine("Speeding up.");
                                verboseline("Creating GH3 process...");
                                Process gh3 = new Process();
                                gh3.StartInfo.WorkingDirectory = folder;
                                gh3.StartInfo.FileName = folder + "\\game.exe";
                                // dont do this lol
                                if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                                    settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                                settings.Save(folder + "settings.ini");
                                Console.WriteLine("Ready, go!");
                                gh3.Start();
                            }
                            else
                            {
                                Process.Start(Application.ExecutablePath, selectedtorun.EncloseWithQuoteMarks());
                            }
                    }
                    else if ((args[0].EndsWith(".pak") || args[0].EndsWith(".pak.xen")))
                    {
                        //Console.WriteLine("FastGH3 by donnaken15");
                        Console.WriteLine("Detected song PAK.");
                        PakFormat fmt = new PakFormat(args[0], "", "", PakFormatType.PC);
                        PakEditor pak = new PakEditor(fmt);
                        QbFile qb = pak.ReadQbFile(pak.QbFilenames[0]); //auto guess song paks have 1 qb file, except official ones.....
                        if (qb.Items[1].QbItemType == QbItemType.SectionArray)
                        {
                            if (qb.Items[1].Items[0].QbItemType == QbItemType.ArrayInteger)
                            {
                                string[] sectdiffs = {
                                    "_easy",
                                    "_medium",
                                    "_hard",
                                    "_expert",
                                };
                                string[] sectlines = {
                                    "_star",
                                    "_starbattlemode",
                                    "_hard",
                                    "_expert",
                                };
                                string[] sectparts = {
                                    "",
                                    "_rhythm",
                                    "_guitarcoop",
                                    "_rhythmcoop",
                                };
                                string[] sectmisc = {
                                    "_faceoffp1",
                                    "_faceoffp2",
                                    "_bossbattlep1",
                                    "_bossbattlep2",
                                    "_timesig",
                                    "_fretbars",
                                    "_markers",
                                };
                                string[] sectmisc2 = {
                                    "_scripts",
                                    "_anim",
                                    "_triggers",
                                    "_cameras",
                                    "_lightshow",
                                    "_crowd",
                                    "_drums",
                                    "_performance",
                                };
                                string songprefix = "_song";
                                string notesuffix = "_notes";
                                int currentItem = 0;
                                qb.Items[1].ItemQbKey = QbKey.Create("fastgh3_easy");
                                qb.Items[2].ItemQbKey = QbKey.Create("fastgh3_medium");
                                qb.Items[3].ItemQbKey = QbKey.Create("fastgh3_hard");
                                qb.Items[4].ItemQbKey = QbKey.Create("fastgh3_easy");
                                Console.WriteLine("Speeding up.");
                                verboseline("Creating GH3 process...");
                                Process gh3 = new Process();
                                gh3.StartInfo.WorkingDirectory = folder;
                                gh3.StartInfo.FileName = folder + "\\game.exe";
                                // dont do this lol
                                if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                                    settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                                settings.Save(folder + "settings.ini");
                                Console.WriteLine("Ready, go!");
                                //gh3.Start();
                            }
                        }
                    }
                }
                else Console.WriteLine("That file does not exist.");
                GC.Collect();
            }
        }
    }
}