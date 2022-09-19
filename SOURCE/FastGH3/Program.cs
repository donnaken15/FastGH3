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
using Microsoft.Win32;

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
        static bool verboselog, writefile = true;
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
        public static byte[] paknew = new byte[0xB0], paknewP1 =
        {
            0xA7, 0xF5, 0x05, 0xC4, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x1C,
            0x00, 0x00, 0x00, 0x00, 0xE1, 0x53, 0x10, 0xCD, 0x4C, 0x1E, 0x75, 0x69,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2C, 0xB3, 0xEF, 0x3B,
            0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00,
            0x89, 0x7A, 0xBB, 0x4A, 0x6A, 0xF9, 0x8E, 0xD1
        }, qbnew = {
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1C, 0x1C, 0x08, 0x02, 0x04,
            0x10, 0x04, 0x08, 0x0C, 0x0C, 0x08, 0x02, 0x04, 0x14, 0x02, 0x04, 0x0C,
            0x10, 0x10, 0x0C, 0x00
        };
        public static StreamWriter launcherlog = null;

        // from stackoverflow 1266674
        public static string NormalizePath(string path)
        {
            return Path.GetFullPath(new Uri(path).LocalPath)
                       .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
                       .ToUpperInvariant();
        }

        public static string GH3EXEPath;

        static void disallowGameStartup()
        {
            try
            {
                foreach (Process proc in Process.GetProcessesByName("game"))
                {
                    if (NormalizePath(proc.MainModule.FileName) == GH3EXEPath)
                        proc.Kill();
                }
            }
            catch (Exception ex)
            {
                //print("ERROR! :(\n" + ex.Message);
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
                Console.Write(text);
            if (writefile && launcherlog != null)
                launcherlog.Write(text);
        }

        public static void verboseline(object text)
        {
            if (verboselog)
            {
                Console.Write(timems);
                Console.WriteLine(text);
            }
            if (writefile && launcherlog != null)
            {
                launcherlog.Write(timems);
                launcherlog.WriteLine(text);
            }
        }

        public static void print(object text)
        {
            if (writefile && launcherlog != null)
                launcherlog.WriteLine(text);
            Console.WriteLine(text);
        }

        static bool cacheEnabled = true;

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

        //http://csharptest.net/526/how-to-search-the-environments-path-for-an-exe-or-dll/index.html
        /// <summary>
        /// Expands environment variables and, if unqualified, locates the exe in the working directory
        /// or the evironment's path.
        /// </summary>
        /// <param name="exe">The name of the executable file</param>
        /// <returns>The fully-qualified path to the file</returns>
        /// <exception cref="System.IO.FileNotFoundException">Raised when the exe was not found</exception>
        public static string FindExePath(string exe)
        {
            exe = Environment.ExpandEnvironmentVariables(exe);
            if (!File.Exists(exe))
            {
                if (Path.GetDirectoryName(exe) == String.Empty)
                {
                    foreach (string test in (Environment.GetEnvironmentVariable("PATH") ?? "").Split(';'))
                    {
                        string path = test.Trim();
                        if (!String.IsNullOrEmpty(path) && File.Exists(path = Path.Combine(path, exe)))
                            return Path.GetFullPath(path);
                    }
                }
                return "";
                //throw new FileNotFoundException(new FileNotFoundException().Message, exe);
            }
            return Path.GetFullPath(exe);
        }


        //                   lol
        public static string FormatText(string input, string[] songParams)
        {
            string formatted = input;
            for (int i = 0; i < formatted.Length; i++)
            {
                if (formatted[i] == '%' && i + 1 < formatted.Length)
                {
                    string insert = "%";
                    switch (formatted[i + 1])
                    {
                        // how to avoid 3 % when putting "%%%%"?
                        case 'a':
                            insert = songParams[0];
                            break;
                        case 't':
                            insert = songParams[1];
                            break;
                        case 'b':
                            insert = songParams[2];
                            break;
                        case 'c':
                            insert = songParams[3];
                            break;
                        case 'y':
                            insert = songParams[4];
                            break;
                        case 'l':
                            insert = songParams[5];
                            break;
                        case 'g':
                            insert = songParams[6];
                            break;
                        default:
                            insert = formatted[i + 1].ToString();
                            break;
                    }
                    formatted = formatted.Remove(i, 2);
                    formatted = formatted.Insert(i, insert);
                    i++;
                }
            }
            return formatted;
        }

        static bool colorSpecificActions = true;

        static ConsoleColor cacheColor = ConsoleColor.Cyan,
            chartConvColor = ConsoleColor.White,
            FSBcolor = ConsoleColor.DarkYellow,
            FSPcolor = ConsoleColor.Magenta;

        public static void verbose(object text, ConsoleColor col)
        {
            ConsoleColor oldcol = Console.ForegroundColor;
            if (colorSpecificActions)
                Console.ForegroundColor = col;
            if (verboselog)
                Console.Write(text);
            if (colorSpecificActions)
                Console.ForegroundColor = oldcol;
            if (writefile && launcherlog != null)
                launcherlog.Write(text);
        }

        public static void verboseline(object text, ConsoleColor col)
        {
            ConsoleColor oldcol = Console.ForegroundColor;
            if (colorSpecificActions)
                Console.ForegroundColor = col;
            if (verboselog)
            {
                Console.Write(timems);
                Console.WriteLine(text);
            }
            if (colorSpecificActions)
                Console.ForegroundColor = oldcol;
            if (writefile && launcherlog != null)
            {
                launcherlog.Write(timems);
                launcherlog.WriteLine(text);
            }
        }

        public static void print(object text, ConsoleColor col)
        {
            if (writefile && launcherlog != null)
                launcherlog.WriteLine(text);
            ConsoleColor oldcol = Console.ForegroundColor;
            if (colorSpecificActions)
                Console.ForegroundColor = col;
            Console.WriteLine(text);
            if (colorSpecificActions)
                Console.ForegroundColor = oldcol;
        }

        [STAThread]
        static void Main(string[] args)
        {
            try
            {
                bool multiinstcheck_ = true;
                if (multiinstcheck_)
                {
                    Process[] multiinstcheck = Process.GetProcessesByName(Path.GetFileNameWithoutExtension(Application.ExecutablePath));
                    //MessageBox.Show(multiinstcheck.Length.ToString());
                    int multiinstcheckn = 0;
                    //int multiinstcheckn2 = 0;
                    if (multiinstcheck.Length > 1)
                        foreach (Process fgh3 in multiinstcheck)
                        {
                            if (NormalizePath(fgh3.MainModule.FileName) ==
                                NormalizePath(Application.ExecutablePath))
                            {
                                // can't check process arguments >:(
                                // without some complicated WMI thing
                                // unless (as i thought of using) i
                                // use an MMF to indicate that a
                                // song converting launcher is active
                                multiinstcheckn++;
                                // 1 or [0] = probably this process
                                if (multiinstcheckn > 1)
                                {
                                    MessageBox.Show("FastGH3 Launcher is already running!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                    Environment.Exit(0x4DF); // ERROR_ALREADY_INITIALIZED
                                    break;
                                }
                            }
                        }
                }
                Console.Title = title;
                folder = Path.GetDirectoryName(Application.ExecutablePath) + '\\';//Environment.GetCommandLineArgs()[0].Replace("\\FastGH3.exe", "");
                GH3EXEPath = NormalizePath(folder + "\\game.exe");
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
                #region NO ARGS ROUTINE
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
                        // TODO?: process start and redirect output to this EXE
                        // when MMF is figured out for multi instances
                        Process.Start(Application.ExecutablePath, SubstringExtensions.EncloseWithQuoteMarks(openchart.FileName));
                    }
                    Environment.Exit(0);
                }
                #endregion
                if (args.Length > 0)
                {
                    // combine logs from any of 3 processes to easily look for errors from all of them
                    bool newfile = settings.GetKeyValue("Misc", "FinishedLog", "1") == "1";
                    if (args[0] != "-settings")
                        if (writefile)
                        {
                            if (newfile)
                            {
                                File.Delete(folder + "launcher.txt");
                            }
                            launcherlog = new StreamWriter(folder + "launcher.txt", !newfile);
                            if (newfile)
                            {
                                launcherlog.WriteLine("FastGH3 Launcher LogTM(C)(R)Allrightsreserved\n--------------------------------");
                                newfile = false;
                                settings.SetKeyValue("Misc", "FinishedLog", "0");
                                settings.Save(folder + "settings.ini");
                            }
                        }
                    if (args[0] == "-settings")
                    {
                        // muh classic theme
                        Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
                        new settings().ShowDialog();
                    }
                    else if (args[0] == "-gfxswap")
                    {
                        // TODO: replace SCN with one that has the name of the .tex
                        if (args.Length > 2)
                        {
                            if (File.Exists(args[1]) && File.Exists(args[2]))
                            {
                                if (args[2].EndsWith(".pak.xen"))
                                {
                                    PakFormat pakFormat = new PakFormat(args[2], args[2].Replace(".pak.xen", ".pab.xen"), "", PakFormatType.PC);
                                    PakEditor pakEditor = new PakEditor(pakFormat, false);
                                    pakEditor.ReplaceFile("406D171F", args[1]);
                                }
                                else
                                {
                                    Console.WriteLine("global.pak isn't named correctly.");
                                    Console.ReadKey();
                                    Environment.Exit(1);
                                }
                            }
                            else
                            {
                                Console.WriteLine("One of the entered files don't exist.");
                                Console.ReadKey();
                                Environment.Exit(1);
                            }
                        }
                        else
                        {
                            Console.WriteLine("Insufficient arguments.");
                            Console.ReadKey();
                            Environment.Exit(1);
                        }
                    }
                    #region DOWNLOAD SONG
                    else if (args[0] == "dl" && (args[1] != "" || args[1] != null))
                    {
                        Console.WriteLine(title + " by donnaken15");
                        launcherlog.WriteLine("\n######### DOWNLOAD SONG PHASE #########\n");
                        print("Downloading song package...", FSPcolor);
                        try
                        {
                            bool datecheck = true;
                            Uri fsplink = new Uri(args[1].Replace("fastgh3://", "http://"));
                            string cacheSect = ""; // ...
                            string urlCache = "";
                            string tmpFn = "null";
                            verboseline(fsplink.AbsoluteUri, FSPcolor);
                            if (cacheEnabled)
                            {
                                cacheSect = "URL" + WZK64.Create(fsplink.AbsoluteUri).ToString("X16");
                                urlCache = cache.GetKeyValue(cacheSect, "File", "");
                                if (urlCache != "")
                                {
                                    print("Found already downloaded file.", FSPcolor);
                                    verboseline(cacheSect);
                                    verboseline(urlCache);
                                    tmpFn = urlCache;
                                    if (!datecheck)
                                        goto skipToGame;
                                }
                                if (datecheck)
                                    print("Unique file date checking enabled.", FSPcolor);
                            }
                            WebClient fsp = new WebClient();
                            fsp.Proxy = null;
                            fsp.Headers.Add("user-agent", "Anything");
                            ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00); // why .NET 4
                            fsp.OpenRead(fsplink);
                            DateTime lastmod = new DateTime(), lastmod_cached;
                            //verboseline("1");
                            if (datecheck && cacheEnabled)
                            {
                                if (cache.GetKeyValue(cacheSect, "Date", "0") != "") // STUPID
                                    lastmod_cached = new DateTime(Convert.ToInt64(cache.GetKeyValue(cacheSect, "Date", "0")));
                                else
                                    lastmod_cached = new DateTime(0);
                                if (lastmod_cached.Ticks == 0)
                                    verboseline("Date not cached", cacheColor);
                                else
                                    verboseline("Cached date: " + lastmod_cached.ToUniversalTime(), cacheColor);
                                if (fsp.ResponseHeaders["Last-Modified"] != null)
                                {
                                    //verboseline(fsp.ResponseHeaders["Last-Modified"]);
                                    lastmod = DateTime.Parse(fsp.ResponseHeaders["Last-Modified"]);
                                    verboseline("Got file date: " + lastmod.ToUniversalTime(), cacheColor);
                                    if (lastmod.Ticks == lastmod_cached.Ticks && lastmod_cached.Ticks != 0)
                                    {
                                        verboseline("Unchanged file date. Using already downloaded file.", cacheColor);
                                        goto skipToGame;
                                    }
                                    else
                                    {
                                        if (lastmod.Ticks == 0)
                                            print("Different file date. Redownloading...", cacheColor);
                                    }
                                }
                                else
                                {
                                    print("No file date found.", cacheColor);
                                    if (urlCache != "")
                                    {
                                        print("Using already downloaded file.", cacheColor);
                                        goto skipToGame;
                                    }
                                }
                            }
                            if (Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]) > Math.Pow(1024, 2) * 24)
                            {
                                if (MessageBox.Show("This song package is a larger file than usual. Do you want to continue?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                                {
                                    if (writefile && launcherlog != null)
                                        launcherlog.Close();
                                    settings.SetKeyValue("Misc", "FinishedLog", "1");
                                    settings.Save(folder + "settings.ini");
                                    Environment.Exit(0);
                                }
                            }
                            //if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                            //settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                            if (File.Exists(tmpFn)) // do this?
                                File.Delete(tmpFn);
                            tmpFn = Path.GetTempFileName();
                            string tmpFl = Path.GetTempPath();
                            fsp.DownloadFile(fsplink, tmpFn);
                            File.Move(tmpFn, tmpFn + ".fsp");
                            //Directory.CreateDirectory(tmpFl + "\\Z.TMP.FGH3$WEB");
                            tmpFn += ".fsp";
                            if (cacheEnabled)
                            {
                                print("Writing link to cache...", cacheColor);
                                cache.SetKeyValue(cacheSect, "File", tmpFn.ToString());
                                if (datecheck)
                                {
                                    print("Writing date to cache...", cacheColor);
                                    cache.SetKeyValue(cacheSect, "Date", lastmod.Ticks.ToString());
                                }
                                cache.Save(folder + dataf + "CACHE\\.db.ini");
                            }
                            skipToGame:
                            // download FSP --> open and extract FSP --> convert song --> game
                            // FastGH3.exe  --> FastGH3.exe          --> FastGH3.exe  --> game.exe
                            // :P
                            GC.Collect();
                            Process.Start(Application.ExecutablePath, SubstringExtensions.EncloseWithQuoteMarks(tmpFn));
                            if (writefile && launcherlog != null)
                                launcherlog.Close();
                            // "already running" >:(
                            Environment.Exit(0);
                        }
                        catch (Exception ex)
                        {
                            print("ERROR! :(\n" + ex.Message);
                            settings.SetKeyValue("Misc", "FinishedLog", "1");
                            settings.Save(folder + "settings.ini");
                            Console.ReadKey();
                        }
                    }
                    #endregion
                    else if (File.Exists(args[0]))
                    {
                        #region STANDARD ROUTINE
                        Console.WriteLine(title + " by donnaken15");
                        if (Path.GetFileName(args[0]).EndsWith(chartext) || Path.GetFileName(args[0]).EndsWith(midext))
                        {
                            bool ischart = false;
                            launcherlog.WriteLine("\n######### MAIN LAUNCHER PHASE #########\n");
                            verboseline("File is: " + args[0]);
                            Process mid2chart = new Process();
                            mid2chart.StartInfo = new ProcessStartInfo()
                            {
                                FileName = folder + "\\mid2chart.exe",
                                Arguments = paksongmid.EncloseWithQuoteMarks() + " -k -u -p -m"
                            };
                            // Why won't this work
                            if (!verboselog && !writefile)
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
                                mid2chart.ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, chartConvColor);
                                mid2chart.OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, chartConvColor);
                            }
                            if (Path.GetFileName(args[0]).EndsWith(chartext))
                            {
                                verboseline("Detected chart file.", chartConvColor);
                                ischart = true;
                            }
                            else if (Path.GetFileName(args[0]).EndsWith(midext) ||
                                Path.GetFileName(args[0]).EndsWith(midext + 'i'))
                            {
                                verboseline("Detected midi file.", chartConvColor);
                                verboseline("Converting to chart...", chartConvColor);
                                // why isnt this working
                                //mid2chart.ChartWriter.writeChart(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])), folder + pak + "tmp.chart", false, false);
                                //Console.WriteLine(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])).sections[0].name);
                                //Console.ReadKey();
                                File.Copy(args[0], paksongmid, true);
                                mid2chart.Start();
                                mid2chart.WaitForExit();
                                // doesnt happen when throwing :(
                                /*if (mid2chart.ExitCode != 0)
                                {
                                    Console.WriteLine("An error occured when converting midi to chart. Aborting.");
                                    Environment.Exit(1);
                                }*/
                            }
                            print("Reading file.", chartConvColor);
                            if (cacheEnabled)
                            {
                                verboseline("Indexing cache...", cacheColor);
                                cacheList = Directory.GetFiles(folder + "DATA\\CACHE");
                                for (int i = 0; i < cacheList.Length; i++)
                                {
                                    //verboseline("\r(" + i + "/" + cacheList.Length + ")...");
                                    // forgot how to rewrite a line
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
                            if (writefile && launcherlog != null)
                            {
                                string songName = "";
                                foreach (SongSectionEntry chartinfo in chart.Song)
                                {
                                    switch (chartinfo.Key)
                                    {
                                        case "Name":
                                        case "Artist":
                                        case "Charter":
                                            songName += chartinfo.Value + ",";
                                            break;
                                    }
                                }
                                launcherlog.WriteLine(songName);
                            }
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
                            print("Encoding song.", FSBcolor);
                            verboseline("Getting song, guitar, and rhythm files.", FSBcolor);
                            string[] audiostreams = { "", "", "" };
                            string audtmpstr = "", chartfolder = Directory.GetCurrentDirectory() + '\\';
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
                                            verboseline(chartinfo.Key + " file found", FSBcolor);
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
                                            verboseline(chartinfo.Key + " file found", FSBcolor);
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
                                            verboseline(chartinfo.Key + " file found", FSBcolor);
                                        break;
                                }
                            }
                            string[] audstnames = { "song", "guitar", "rhythm" },
                                audextnames = { "ogg", "mp3", "wav", "opus" };
                            for (int i = 0; i < 4; i++)
                            {
                                if (!File.Exists(audiostreams[0]))
                                {
                                    audtmpstr = chartfolder + Path.GetFileNameWithoutExtension(args[0]) + '.' + audextnames[i];
                                    if (File.Exists(audtmpstr))
                                    {
                                        verboseline("Found audio with the chart name", FSBcolor);
                                        audiostreams[0] = audtmpstr;
                                        break;
                                    }
                                }
                            }
                            for (int i = 0; i < audstnames.Length; i++)
                            {
                                if (!File.Exists(audiostreams[i]))
                                    for (int j = 0; j < 4; j++)
                                    {
                                        audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                        if (File.Exists(audtmpstr))
                                        {
                                            verboseline("Found FOF structure files / " + audstnames[i], FSBcolor);
                                            audiostreams[i] = audtmpstr;
                                            break;
                                        }
                                    }
                            }
                            // TODO: allow NJ3T routine even when song.ogg exists
                            audstnames = new string[] { "lead", "bass" };
                            for (int i = 0; i < audstnames.Length; i++)
                            {
                                if (!File.Exists(audiostreams[i + 1]))
                                    for (int j = 0; j < 4; j++)
                                    {
                                        audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                        if (File.Exists(audtmpstr))
                                        {
                                            verboseline("Found FOF structure files / " + audstnames[i], FSBcolor);
                                            audiostreams[i + 1] = audtmpstr;
                                            break;
                                        }
                                    }
                            }
                            bool notjust3trax = false; // nj3ts.Count smh // "3 Count!"
                            List<string> nj3ts = new List<string>();
                            verboseline("Checking if extra audio exists", FSBcolor);
                            for (int j = 0; j < 4; j++)
                            {
                                for (int i = 1; i < 9; i++)
                                {
                                    audtmpstr = chartfolder + "drums_" + i + '.' + audextnames[j];
                                    if (File.Exists(audtmpstr))
                                    {
                                        verboseline("Found isolated drums audio (" + i + ')', FSBcolor);
                                        notjust3trax = true;
                                        nj3ts.Add(audtmpstr);
                                    }
                                }
                            }
                            // also maybe ignore drums.ogg if numbered files exist
                            for (int j = 0; j < 4; j++)
                            {
                                audtmpstr = chartfolder + "vocals." + audextnames[j];
                                if (File.Exists(audtmpstr))
                                {
                                    verboseline("Found isolated vocals audio", FSBcolor);
                                    notjust3trax = true;
                                    nj3ts.Add(audtmpstr);
                                    break;
                                }
                            }
                            audstnames = new string[] { "drums", /*"vocals",*/ "keys", "song" };
                            for (int i = 0; i < audstnames.Length; i++)
                            {
                                for (int j = 0; j < 4; j++)
                                {
                                    audtmpstr = chartfolder + audstnames[i] + '.' + audextnames[j];
                                    if (File.Exists(audtmpstr))
                                    {
                                        verboseline("Found FOF structure files / " + audstnames[i], FSBcolor);
                                        if (i != 3 && audstnames[i] != "song")
                                        {
                                            notjust3trax = true;
                                        }
                                        nj3ts.Add(audtmpstr);
                                        break;
                                    }
                                }
                            }
                            verboseline("Current selected audio streams are:", FSBcolor);
                            foreach (string a in audiostreams)
                                verboseline(a, FSBcolor);
                            if (!File.Exists(audiostreams[0]) && !notjust3trax)
                            {
                                verboseline("Failed to get main song file, asking user what the game should do", FSBcolor);
                                DialogResult audiolost, playsilent = DialogResult.No, searchaudioresult = DialogResult.Cancel;
                                OpenFileDialog searchaudio = new OpenFileDialog()
                                {
                                    CheckFileExists = true,
                                    CheckPathExists = true,
                                    InitialDirectory = Path.GetDirectoryName(args[0]),
                                    Filter = "Audio files|*.mp3;*.wav;*.ogg;*.opus|Any type|*.*"
                                };
                                do
                                {
                                    audiolost = MessageBox.Show("No song audio can be found.\nDo you want to search for it?", "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
                                    if (audiolost == DialogResult.Cancel)
                                    {
                                        if (writefile && launcherlog != null)
                                            launcherlog.Close();
                                        settings.SetKeyValue("Misc", "FinishedLog", "1");
                                        settings.Save(folder + "settings.ini");
                                        Environment.Exit(0);
                                    }
                                    if (audiolost == DialogResult.Yes)
                                    {
                                        searchaudioresult = searchaudio.ShowDialog();
                                        if (searchaudioresult == DialogResult.OK)
                                        {
                                            verboseline("User responded with " + SubstringExtensions.EncloseWithQuoteMarks(searchaudio.FileName), FSBcolor);
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
                                            verboseline("Using blank music file", FSBcolor);
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
                                print("Checking cache.", cacheColor);
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
                            bool MTFSB = true; // enable asynchronous audio track encoding
                                               //if (cacheEnabled)
                            if (!audCache)
                            {
                                print("Audio is not cached.", cacheColor);
                                if (notjust3trax)
                                {
                                    print("Found more than three audio tracks, merging.", FSBcolor);
                                    addaud.StartInfo = new ProcessStartInfo()
                                    {
                                        FileName = "cmd",
                                        Arguments = ((folder + music + "\\TOOLS\\nj3t.bat").EncloseWithQuoteMarks())
                                    };
                                    if (!verboselog && !writefile)
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
                                        addaud.ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, FSBcolor);
                                        addaud.OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, FSBcolor);
                                    }
                                    foreach (string a in nj3ts)
                                    {
                                        addaud.StartInfo.Arguments += " \"" + a + '"';
                                    }
                                    addaud.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                                    addaud.StartInfo.Arguments = "/c " + addaud.StartInfo.Arguments.EncloseWithQuoteMarks();
                                    addaud.Start();
                                    if (verboselog || writefile)
                                    {
                                        addaud.BeginErrorReadLine();
                                        addaud.BeginOutputReadLine();
                                    }
                                    verboseline("merge args: sox " + addaud.StartInfo.Arguments, FSBcolor);
                                    audiostreams[0] = folder + music + "\\TOOLS\\fsbtmp\\fastgh3_song.mp3";
                                    //fsbbuild.StartInfo.FileName += '2';
                                    if (!MTFSB)
                                    {
                                        if (!addaud.HasExited)
                                            addaud.WaitForExit();
                                    }
                                }
                                verboseline("Creating encoder process...", FSBcolor);
                                if (!MTFSB)
                                {
                                    fsbbuild.StartInfo.FileName = "cmd";
                                    if (!verboselog && !writefile)
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
                                        fsbbuild.ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, FSBcolor);
                                        fsbbuild.OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, FSBcolor);
                                    }
                                    fsbbuild.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                                    verbose("S", FSBcolor); // lol
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
                                            FileName = "cmd",
                                            Arguments = "/c " + ((folder + music + "\\TOOLS\\c128ks.bat").EncloseWithQuoteMarks() + " " + audiostreams[i].EncloseWithQuoteMarks() + " \"" + folder + music + "\\TOOLS\\fsbtmp\\fastgh3_" + fsbnames[i] + ".mp3\"").EncloseWithQuoteMarks(),
                                            CreateNoWindow = true,
                                            UseShellExecute = true,
                                            WindowStyle = ProcessWindowStyle.Hidden
                                        };
                                        if (verboselog || writefile)
                                        {
                                            fsbbuild2[i].StartInfo.UseShellExecute = false;
                                            fsbbuild2[i].StartInfo.RedirectStandardError = true;
                                            fsbbuild2[i].StartInfo.RedirectStandardOutput = true;
                                            fsbbuild2[i].ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, FSBcolor);
                                            fsbbuild2[i].OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, FSBcolor);
                                        }
                                        verboseline("MP3 args: c128ks " + fsbbuild2[i].StartInfo.Arguments, FSBcolor);
                                    }
                                    fsbbuild3.StartInfo.FileName = "cmd";
                                    fsbbuild3.StartInfo.Arguments = "/c " + ((folder + music + "\\TOOLS\\fsbbuild.bat").EncloseWithQuoteMarks());
                                    if (!verboselog && !writefile)
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
                                        fsbbuild3.ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, FSBcolor);
                                        fsbbuild3.OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, FSBcolor);
                                    }
                                    fsbbuild3.StartInfo.WorkingDirectory = folder + music + "\\TOOLS\\";
                                    verbose("As", FSBcolor);
                                }
                                verbose("ynchronous mode set\n", FSBcolor);
                                verboseline("Starting FSB building...", FSBcolor);
                                if (!MTFSB)
                                {
                                    fsbbuild.StartInfo.Arguments = "/c " + ((folder + music + "\\TOOLS\\fsbbuild.bat").EncloseWithQuoteMarks() + ' ' +
                                    audiostreams[0].EncloseWithQuoteMarks() + ' ' + audiostreams[1].EncloseWithQuoteMarks() + ' ' + audiostreams[2].EncloseWithQuoteMarks() + ' ' +
                                    (folder + music + "\\TOOLS\\blank.mp3").EncloseWithQuoteMarks() + ' ' + (folder + music + "\\fastgh3.fsb.xen").EncloseWithQuoteMarks()).EncloseWithQuoteMarks();
                                    verboseline("MP3 args: c128ks " + fsbbuild.StartInfo.Arguments, FSBcolor);
                                    fsbbuild.Start();
                                    if (verboselog || writefile)
                                    {
                                        fsbbuild.BeginErrorReadLine();
                                        fsbbuild.BeginOutputReadLine();
                                    }
                                }
                                else
                                {
                                    for (int i = 0; i < fsbbuild2.Length; i++)
                                    {
                                        if (!notjust3trax || (notjust3trax && i != 0)) // weird
                                        {
                                            fsbbuild2[i].Start();
                                            if (verboselog || writefile)
                                            {
                                                fsbbuild2[i].BeginErrorReadLine();
                                                fsbbuild2[i].BeginOutputReadLine();
                                            }
                                        }
                                    }
                                    fsbbuild3.StartInfo.Arguments = "/c " + ((folder + music + "\\TOOLS\\fsbbuildnoenc.bat").EncloseWithQuoteMarks() + ' ' +
                                        (folder + music + "\\fastgh3.fsb.xen").EncloseWithQuoteMarks()).EncloseWithQuoteMarks();
                                }
                            }
                            else
                            {
                                print("Cached audio found.", FSBcolor);
                                File.Copy(
                                    folder + "\\DATA\\CACHE\\" + audhash.ToString("X16"),
                                    folder + "\\DATA\\MUSIC\\fastgh3.fsb.xen", true);
                            }
                            #endregion
                            disallowGameStartup();
                            if (!chartCache)
                            {
                                if (cacheEnabled)
                                    print("Chart is not cached.", cacheColor);
                                print("Generating QB template.", chartConvColor);
                                verboseline("Creating new QB files...", chartConvColor);
                                disallowGameStartup();
                                Array.Copy(paknewP1, 0, paknew, 0, paknewP1.Length);
                                Array.Copy(qbnew, 0, paknew, 0x80, qbnew.Length);
                                File.WriteAllBytes(folder + pak + "song.pak.xen", paknew);
                                verboseline("Creating PakFormat and PakEditor from song.pak", chartConvColor);
                                print("Opening song pak.", chartConvColor);
                                PakFormat pakformat = new PakFormat(folder + pak + "song.pak.xen", "", "", PakFormatType.PC);
                                PakEditor buildsong;
                                try
                                {
                                    buildsong = new PakEditor(pakformat, false);
                                }
                                catch
                                {
                                    try
                                    {
                                        verboseline("dbg.pak.xen can go kill itself", ConsoleColor.Red);
                                        buildsong = new PakEditor(pakformat, false);
                                    }
                                    catch
                                    {
                                        verboseline("i'm %#@!?ng done", ConsoleColor.Red);
                                        File.Move(folder + pak + "dbg.pak.xen", folder + pak + "dbg.pak.xen.bak");
                                        buildsong = new PakEditor(pakformat, false);
                                    }
                                }
                                print("Compiling chart.", chartConvColor);
                                verboseline("Creating QbFile using PakFormat", chartConvColor);
                                File.WriteAllBytes(folder + pak + "song.qb", qbnew);
                                File.SetAttributes(folder + pak + "song.qb", FileAttributes.Normal);
                                QbFile songdata = new QbFile(folder + pak + "song.qb", pakformat);
                                #region BUILD ENTIRE QB FILE
                                #region GUITAR VALUES

                                verboseline("Creating note arrays...", chartConvColor);
                                string[] diffs = { "easy", "medium", "hard", "expert" };
                                string[] insts = { "", "_rhythm", "_guitarcoop", "_rhythmcoop" };
                                // song.inst[i].diff[d]
                                QbItemBase[][] song_notes_container = new QbItemBase[insts.Length][];//[diffs.Length];
                                QbItemInteger[][] song_notes = new QbItemInteger[insts.Length][];//[diffs.Length];
                                for (int i = 0; i < song_notes_container.Length; i++)
                                {
                                    song_notes_container[i] = new QbItemBase[diffs.Length];
                                    song_notes[i] = new QbItemInteger[diffs.Length];
                                    for (int d = 0; d < song_notes_container[i].Length; d++)
                                    {
                                        song_notes[i][d] = new QbItemInteger(songdata);
                                        song_notes_container[i][d] = new QbItemArray(songdata);
                                        song_notes_container[i][d].Create(QbItemType.SectionArray);
                                        song_notes_container[i][d].ItemQbKey =
                                            QbKey.Create("fastgh3_song" + insts[i] + '_' + diffs[d]);
                                    }
                                }
                                OffsetTransformer OT = new OffsetTransformer(chart);
                                string[] TrackDiffs = { "Easy", "Medium", "Hard", "Expert" };
                                string[] TrackInsts = { "Single", "DoubleBass", "DoubleGuitar", "DoubleBass" };
                                // doublebass would exist both on rhythm and rhythmcoop? lol?
                                // depend on enhanced bass for singleplayer rhythm kek

                                bool atleast1track = false;

                                int test;
                                int delay = Convert.ToInt32(float.Parse(chart.Song["Offset"].Value) * 1000);
                                QbcNoteTrack tmp;

                                int dd = 0;
                                int ii = 0;

                                int boss_death_time = -1;

                                QbItemArray array_scripts = new QbItemArray(songdata);
                                array_scripts.Create(QbItemType.SectionArray);
                                QbItemStructArray array_scripts_array = new QbItemStructArray(songdata);
                                array_scripts.ItemQbKey = QbKey.Create("fastgh3_scripts");
                                array_scripts_array.Create(QbItemType.ArrayStruct);
                                List<QbItemStruct> scripts = new List<QbItemStruct>();
                                foreach (EventsSectionEntry e in chart.Events)
                                {
                                    if (e.TextValue.StartsWith("section ") ||
                                        // looks a little redundant but also capitalization
                                        // WELL JUST USE TOLOWER
                                        QbKey.Create(e.TextValue) == QbKey.Create("end") ||
                                        QbKey.Create(e.TextValue) == QbKey.Create("h") ||
                                        QbKey.Create(e.TextValue) == QbKey.Create("*"))
                                        continue;
                                    verboseline("Found event: " + e.TextValue, chartConvColor);
                                    QbItemStruct newScript = new QbItemStruct(songdata);
                                    newScript.Create(QbItemType.StructHeader);
                                    QbItemInteger time = new QbItemInteger(songdata);
                                    time.Create(QbItemType.StructItemInteger, 1);
                                    QbItemQbKey scr = new QbItemQbKey(songdata);
                                    scr.Create(QbItemType.StructItemQbKey);
                                    time.ItemQbKey = QbKey.Create("time");
                                    time.Values[0] = (int)Math.Floor(OT.GetTime(e.Offset) * 1000);
                                    scr.ItemQbKey = QbKey.Create("scr");
                                    if (scr.ItemQbKey == QbKey.Create("boss_battle_begin_deathlick"))
                                        boss_death_time = time.Values[0];
                                    scr.Values[0] = QbKey.Create(e.TextValue);
                                    QbItemStruct _params = new QbItemStruct(songdata);
                                    _params.Create(QbItemType.StructItemStruct);
                                    _params.ItemQbKey = QbKey.Create("params");
                                    newScript.AddItem(time);
                                    newScript.AddItem(scr);
                                    newScript.AddItem(_params);
                                    scripts.Add(newScript);
                                    //array_scripts_array.AddItem(newScript);
                                }
                                // TODO: stringpointer for lower difficulties to redirect to
                                // least difficult chart if they aren't authored
                                //
                                // so like if an easy chart doesn't exist but hard
                                // and expert charts do, easy redirects to the hard chart
                                // and so space is saved from having dupe note tracks
                                //
                                // maybe also for arrays that don't have anything
                                string[] partNames = { "guitar", "rhythm", "guitarcoop", "rhythmcoop" };
                                foreach (string i in TrackInsts)
                                {
                                    dd = 0;
                                    foreach (string d in TrackDiffs)
                                    {
                                        verboseline("Checking " + d + i, chartConvColor);
                                        if (chart.NoteTracks[d + i] != null)
                                        {
                                            atleast1track = true;
                                            verboseline("Parsing " + d + i, chartConvColor);
                                            try
                                            {
                                                tmp = new QbcNoteTrack(chart.NoteTracks[d + i], OT);
                                                if (tmp.Count > 0)
                                                    test = tmp.Count;
                                                else test = 3;
                                                song_notes[ii][dd].Create(QbItemType.ArrayInteger, tmp.Count * 3);
                                                // is ItemCount what i need instead of Create(type, arraysize)
                                                // so i implemented that parameter for nothing?
                                                for (int j = 0; j < tmp.Count; j++)
                                                {
                                                    song_notes[ii][dd].Values[(j * 3)] = tmp[j].Offset + delay;
                                                    song_notes[ii][dd].Values[(j * 3) + 1] = tmp[j].Length;
                                                    song_notes[ii][dd].Values[(j * 3) + 2] = tmp[j].FretMask;
                                                }
                                            }
                                            catch
                                            {
                                                verboseline("Error in parsing notes for " + d + i, chartConvColor);
                                                song_notes[ii][dd].Create(QbItemType.ArrayInteger, 3);
                                                for (int j = 0; j < 3; j++)
                                                    song_notes[ii][dd].Values[j] = 0;
                                            }
                                            try
                                            {
                                                foreach (Note e in chart.NoteTracks[d + i])
                                                {
                                                    if (e.Type != NoteType.Event ||
                                                        QbKey.Create(e.EventName) == QbKey.Create("H") ||/* <--\ */
                                                        QbKey.Create(e.EventName) == QbKey.Create("*") ||/*a note to self for forcing*/
                                                        e.EventName == "" && dd != 3 /*bad*/)
                                                        // ALSO * IN A QBKEY LOL
                                                        continue;
                                                    verboseline("Found event: " + e.EventName, chartConvColor);
                                                    QbItemStruct newScript = new QbItemStruct(songdata);
                                                    newScript.Create(QbItemType.StructHeader);
                                                    QbItemInteger time = new QbItemInteger(songdata);
                                                    time.Create(QbItemType.StructItemInteger, 1);
                                                    QbItemQbKey scr = new QbItemQbKey(songdata);
                                                    scr.Create(QbItemType.StructItemQbKey);
                                                    time.ItemQbKey = QbKey.Create("time");
                                                    time.Values[0] = (int)Math.Floor(OT.GetTime(e.Offset) * 1000);
                                                    scr.ItemQbKey = QbKey.Create("scr");
                                                    scr.Values[0] = QbKey.Create(e.EventName);
                                                    QbItemStruct _params = new QbItemStruct(songdata);
                                                    _params.Create(QbItemType.StructItemStruct);
                                                    _params.ItemQbKey = QbKey.Create("params");
                                                    if ((QbKey.Create(e.EventName) == QbKey.Create("solo") ||
                                                        QbKey.Create(e.EventName) == QbKey.Create("soloend")) && ii != 0)
                                                    {
                                                        QbItemQbKey part = new QbItemQbKey(songdata);
                                                        part.Create(QbItemType.StructItemQbKey);
                                                        part.ItemQbKey = QbKey.Create("part");
                                                        part.Values[0] = QbKey.Create(partNames[ii]);
                                                        _params.AddItem(part);
                                                        // is guitarcoop actually a valid (player_status) part?
                                                    }
                                                    newScript.AddItem(time);
                                                    newScript.AddItem(scr);
                                                    newScript.AddItem(_params);
                                                    scripts.Add(newScript);
                                                    //array_scripts_array.AddItem(newScript);
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                verboseline("Error in parsing solos for " + d + i, ConsoleColor.Yellow);
                                                verboseline(ex, ConsoleColor.Yellow);
                                            }
                                        }
                                        else
                                        {
                                            song_notes[ii][dd].Create(QbItemType.ArrayInteger, 3);
                                            for (int j = 0; j < 3; j++)
                                                song_notes[ii][dd].Values[j] = 0;
                                        }
                                        dd++;
                                    }
                                    ii++;
                                }
                                if (!atleast1track)
                                {
                                    File.Delete(folder + pak + "song.qb");
                                    if (!MTFSB)
                                    {
                                        if (!fsbbuild.HasExited)
                                            fsbbuild.Kill();
                                    }
                                    else
                                    {
                                        for (int i = 0; i < fsbbuild2.Length; i++)
                                            if (!fsbbuild2[i].HasExited)
                                                fsbbuild2[i].Kill();
                                    } // doesn't work because killing this only kills the parent EXE and doesn't stop the script >:(
                                    MessageBox.Show("No guitar/rhythm tracks can be found. Exiting...", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                    if (writefile && launcherlog != null)
                                        launcherlog.Close();
                                    settings.SetKeyValue("Misc", "FinishedLog", "1");
                                    settings.Save(folder + "settings.ini");
                                    Environment.Exit(0);
                                }
                                // sort scripts by time
                                scripts.Sort(delegate (QbItemStruct c1, QbItemStruct c2)
                                {
                                    //     autismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautism
                                    return (c1.FindItem(QbKey.Create("time"), false) as QbItemInteger).Values[0].CompareTo((c2.FindItem(QbKey.Create("time"), false) as QbItemInteger).Values[0]);
                                });
                                verboseline("Adding note arrays to QB.", chartConvColor);
                                /*for (int d = 0; d < song_notes_container.Length; d++)
                                {
                                    songdata.AddItem(song_notes_container[0][d]);
                                    song_notes_container[0][d].AddItem(song_notes[0][d]);
                                }*/
                                // use this for organized QBs ^
                                // as pleasing[definition needed] as the below looks to do
                                // without having multiple loops, idk man
                                for (int i = 0; i < song_notes_container.Length; i++)
                                {
                                    for (int d = 0; d < song_notes_container[i].Length; d++)
                                    {
                                        songdata.AddItem(song_notes_container[i][d]);
                                        song_notes_container[i][d].AddItem(song_notes[i][d]);
                                    }
                                }
                                verboseline("Creating and adding starpower arrays...", chartConvColor);
                                QbItemBase[][] song_stars_array_container = new QbItemBase[insts.Length][];//[diffs.Length];
                                QbItemBase[][] song_stars_container = new QbItemBase[insts.Length][];//[diffs.Length];
                                QbItemInteger[][] song_stars = new QbItemInteger[insts.Length][];//[diffs.Length];
                                QbItemInteger starTmp;
                                for (int i = 0; i < song_stars_container.Length; i++)
                                {
                                    song_stars_array_container[i] = new QbItemBase[diffs.Length];
                                    song_stars_container[i] = new QbItemArray[diffs.Length];
                                    //song_stars[i] = new QbItemInteger[diffs.Length];
                                    for (int d = 0; d < song_stars_container[i].Length; d++)
                                    {
                                        //song_stars[i][d] = new QbItemInteger(songdata);
                                        song_stars_array_container[i][d] = new QbItemArray(songdata);
                                        song_stars_array_container[i][d].Create(QbItemType.SectionArray);
                                        song_stars_array_container[i][d].ItemQbKey =
                                            QbKey.Create("fastgh3" + insts[i] + '_' + diffs[d] + "_star");
                                        song_stars_container[i][d] = new QbItemArray(songdata);
                                        song_stars_container[i][d].Create(QbItemType.ArrayArray);
                                    }
                                }
                                for (int i = 0; i < song_stars_array_container.Length; i++)
                                {
                                    for (int d = 0; d < song_stars_array_container[i].Length; d++)
                                    {
                                        songdata.AddItem(song_stars_array_container[i][d]);
                                        song_stars_array_container[i][d].AddItem(song_stars_container[i][d]);
                                    }
                                }
                                ii = 0;
                                foreach (string i in TrackInsts)
                                {
                                    dd = 0;
                                    foreach (string d in TrackDiffs)
                                    {
                                        if (chart.NoteTracks[d + i] != null)
                                        {
                                            // count notes in starpower phrases
                                            // weird setup
                                            // Thanks Neversoft

                                            // i forgot how this even works
                                            List<Note> spTmp = new List<Note>();
                                            Note spLast = new Note(), noteLast = new Note();
                                            int spTmp3 = 0, spTmp2 = 0;
                                            List<int> spPnc = new List<int>();
                                            foreach (Note a in chart.NoteTracks[d + i])
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
                                                if (a.Type == NoteType.Special &&
                                                    a.SpecialFlag == 2)
                                                // 3, allow adding
                                                // battle notes here too
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
                                            int spPnc2 = 0;
                                            if (spTmp.Count != 0)
                                                foreach (Note a in spTmp)
                                                {
                                                    try
                                                    {
                                                        starTmp = new QbItemInteger(songdata);
                                                        starTmp.Create(QbItemType.ArrayInteger, 3);
                                                        starTmp.Values[0] = (int)Math.Floor(OT.GetTime(a.Offset) * 1000) + delay;
                                                        starTmp.Values[1] = (int)Math.Floor((OT.GetTime(a.Offset + a.Length) * 1000)) - starTmp.Values[0];
                                                        starTmp.Values[2] = spPnc[spPnc2];
                                                        song_stars_container[ii][dd].AddItem(starTmp);
                                                        spPnc2++;
                                                    }
                                                    catch (Exception e)
                                                    {
                                                        print("/!\\ Error adding a starpower phrase. If this message appears more than once, there may be a problem", ConsoleColor.Yellow);
                                                        //Console.WriteLine(e);
                                                    }
                                                }
                                            else
                                            {
                                                starTmp = new QbItemInteger(songdata);
                                                starTmp.Create(QbItemType.ArrayInteger, 3);
                                                song_stars_container[ii][dd].AddItem(starTmp);
                                            }
                                        }
                                        else
                                        {
                                            starTmp = new QbItemInteger(songdata);
                                            starTmp.Create(QbItemType.ArrayInteger, 3);
                                            song_stars_container[ii][dd].AddItem(starTmp);
                                        }
                                        dd++;
                                    }
                                    ii++;
                                }
                                // KAY OU GOT ONE PART DONE, DOOOOO THE REST, SUHLLLAAAVVVEEE!!!!!!!!!!!
                                verboseline("Creating powerup arrays...", chartConvColor);
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
                                battle_expert.Create(QbItemType.ArrayInteger, 1);
                                verboseline("Adding powerup arrays to QB...", chartConvColor);
                                songdata.AddItem(array_easy_battle);
                                songdata.AddItem(array_medium_battle);
                                songdata.AddItem(array_hard_battle);
                                songdata.AddItem(array_expert_battle);
                                array_easy_battle.AddItem(array_easy_battle_array);
                                array_medium_battle.AddItem(array_medium_battle_array);
                                array_hard_battle.AddItem(array_hard_battle_array);
                                array_expert_battle.AddItem(array_expert_battle_array);
                                /*List<Note> bpTmp = new List<Note>();
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
                                }*/
                                //battle_expert.Create(QbItemType.ArrayInteger, 1);
                                array_easy_battle_array.AddItem(battle_easy);
                                array_medium_battle_array.AddItem(battle_medium);
                                array_hard_battle_array.AddItem(battle_hard);
                                array_expert_battle_array.AddItem(battle_expert);
                                #endregion

                                verboseline("Creating rhythm powerup arrays...", chartConvColor);
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
                                verboseline("Adding rhythm powerup arrays to QB...", chartConvColor);
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

                                verboseline("Creating co-op guitar powerup arrays...", chartConvColor);
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
                                verboseline("Adding co-op guitar powerup arrays to QB...", chartConvColor);
                                songdata.AddItem(array_easy_battle_lead);
                                songdata.AddItem(array_medium_battle_lead);
                                songdata.AddItem(array_hard_battle_lead);
                                songdata.AddItem(array_expert_battle_lead);
                                array_easy_battle_lead.AddItem(battle_easy_lead);
                                array_medium_battle_lead.AddItem(battle_medium_lead);
                                array_hard_battle_lead.AddItem(battle_hard_lead);
                                array_expert_battle_lead.AddItem(battle_expert_lead);

                                verboseline("Creating co-op rhythm powerup arrays...", chartConvColor);
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
                                verboseline("Adding co-op rhythm powerup arrays to QB...", chartConvColor);
                                songdata.AddItem(array_easy_battle_rhythm_coop);
                                songdata.AddItem(array_medium_battle_rhythm_coop);
                                songdata.AddItem(array_hard_battle_rhythm_coop);
                                songdata.AddItem(array_expert_battle_rhythm_coop);
                                array_easy_battle_rhythm_coop.AddItem(battle_easy_rhythm_coop);
                                array_medium_battle_rhythm_coop.AddItem(battle_medium_rhythm_coop);
                                array_hard_battle_rhythm_coop.AddItem(battle_hard_rhythm_coop);
                                array_expert_battle_rhythm_coop.AddItem(battle_expert_rhythm_coop);

                                #region END TIME
                                verboseline("Getting end time...", chartConvColor);
                                int endtime = 0;
                                //           blehe  v
                                for (int i = 0; i < 4; i++)
                                {
                                    for (int d = 0; d < 4; d++)
                                    {
                                        endtime = Math.Max(endtime,
                                            song_notes[i][d].Values[song_notes[i][d].Values.Length - 3] +
                                            song_notes[i][d].Values[song_notes[i][d].Values.Length - 2]
                                            );
                                        verboseline("Calculating: end time so far: " + endtime, chartConvColor);
                                    }
                                }
                                verboseline("End time is " + endtime, chartConvColor);
                                #endregion
                                #region FACE-OFF/BATTLE VALUES
                                verboseline("Creating face-off arrays...", chartConvColor);
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
                                verboseline("Adding face-off arrays to QB...", chartConvColor);
                                songdata.AddItem(array_faceoff_p1);
                                songdata.AddItem(array_faceoff_p2);
                                array_faceoff_p1.AddItem(array_faceoff_p1_array);
                                array_faceoff_p2.AddItem(array_faceoff_p2_array);
                                array_faceoff_p1_array.AddItem(faceoff_p1);
                                array_faceoff_p2_array.AddItem(faceoff_p2);
                                verboseline("Creating battle arrays...", chartConvColor);
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
                                verboseline("Adding battle arrays to QB.", chartConvColor);
                                songdata.AddItem(array_battle_p1);
                                songdata.AddItem(array_battle_p2);
                                array_battle_p1.AddItem(array_battle_p1_array);
                                array_battle_p2.AddItem(array_battle_p2_array);
                                #endregion
                                #region MEASURE VALUES
                                verboseline("Creating time signature arrays...", chartConvColor);
                                QbItemBase array_timesig = new QbItemArray(songdata);
                                array_timesig.Create(QbItemType.SectionArray);
                                QbItemBase array_timesig_array = new QbItemArray(songdata);
                                array_timesig_array.Create(QbItemType.ArrayArray);
                                array_timesig.ItemQbKey = QbKey.Create(0x32F59FAE);
                                verboseline("Reading TS values from file...", chartConvColor);
                                List<SyncTrackEntry> ts = new List<SyncTrackEntry>();
                                for (int i = 0; i < chart.SyncTrack.Count; i++)
                                {
                                    if (chart.SyncTrack[i].Type == SyncType.TimeSignature)
                                    {
                                        ts.Add(chart.SyncTrack[i]);
                                    }
                                }
                                if (ts.Count == 0) // bruh
                                                   // legitimately happens on some charts for some reason
                                                   // causes infinite starpower
                                {
                                    verboseline("No time sigs?", ConsoleColor.Yellow);
                                    verboseline("https://i.kym-cdn.com/photos/images/original/002/297/355/cb3");
                                    SyncTrackEntry tsfault = new SyncTrackEntry();
                                    if (chart.SyncTrack.Count != 0)
                                        foreach (SyncTrackEntry st in chart.SyncTrack)
                                        {
                                            if (st.Type == SyncType.BPM)
                                            {
                                                tsfault.Offset = st.Offset;
                                            }
                                        }
                                    tsfault.Type = SyncType.TimeSignature;
                                    tsfault.TimeSignature = 4;
                                    ts.Add(tsfault);
                                }
                                int timesigcount = ts.Count;
                                QbItemInteger[] timesig = new QbItemInteger[timesigcount];
                                for (int i = 0; i < timesigcount; i++)
                                {
                                    verboseline("Creating time signature #" + i.ToString() + "...", chartConvColor);
                                    timesig[i] = new QbItemInteger(songdata);
                                    timesig[i].Create(QbItemType.ArrayInteger, 3);
                                }
                                for (int i = 0; i < timesigcount; i++)
                                {
                                    verboseline("Setting TS #" + (i).ToString() + " values (1/3) (" + (int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay) + ")...", chartConvColor);
                                    timesig[i].Values[0] = (int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay);
                                    verboseline("Setting TS #" + (i).ToString() + " values (2/3) (" + Convert.ToInt32(ts[i].TimeSignature) + ")...", chartConvColor);
                                    timesig[i].Values[1] = Convert.ToInt32(ts[i].TimeSignature);
                                    verboseline("Setting TS #" + (i).ToString() + " values (3/3) (" + 4 + ")...", chartConvColor);
                                    timesig[i].Values[2] = 4;
                                }
                                verboseline("Adding time signature arrays to QB...", chartConvColor);
                                songdata.AddItem(array_timesig);
                                array_timesig.AddItem(array_timesig_array);
                                for (int i = 0; i < timesigcount; i++)
                                    array_timesig_array.AddItem(timesig[i]);
                                verboseline("Creating fretbar arrays...", chartConvColor);
                                QbItemBase array_fretbars = new QbItemArray(songdata);
                                array_fretbars.Create(QbItemType.SectionArray);
                                array_fretbars.ItemQbKey = QbKey.Create(0xC3C71E9D);
                                QbItemInteger fretbars = new QbItemInteger(songdata);
                                List<int> msrs = new List<int>();
                                for (int i = 0; OT.GetTime(i - chart.Resolution) < ((float)(endtime) / 1000); i += chart.Resolution)
                                {
                                    msrs.Add(Convert.ToInt32(Math.Floor(OT.GetTime(i) * 1000)));
                                }
                                {
                                    fretbars.Create(QbItemType.ArrayInteger, msrs.Count);
                                    for (int i = 0; i < msrs.Count; i++)
                                        fretbars.Values[i] = Convert.ToInt32(msrs[i] + delay);
                                }
                                verboseline("Adding time signature arrays to QB...", chartConvColor);
                                songdata.AddItem(array_fretbars);
                                array_fretbars.AddItem(fretbars);
                                #endregion
                                verboseline("Collecting garbage...");
                                GC.Collect();
                                #region MARKER VALUES
                                verboseline("Creating marker arrays...", chartConvColor);
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
                                    verbose("Creating marker #" + i.ToString(), chartConvColor);
                                    markers[i] = new QbItemStruct(songdata);
                                    markers[i].Create(QbItemType.StructHeader);
                                    verbose(": time = ", chartConvColor);
                                    markertimes[i] = new QbItemInteger(songdata);
                                    markertimes[i].Create(QbItemType.StructItemInteger, 1);
                                    markertimes[i].ItemQbKey = QbKey.Create(0x906B67BA);
                                    verbose(mrkrs[i].Offset + delay, chartConvColor);
                                    markertimes[i].Values[0] = (int)(Math.Floor(OT.GetTime(mrkrs[i].Offset) * 1000) + delay);
                                    verbose(", name = ", chartConvColor);
                                    markernames[i] = new QbItemString(songdata);
                                    markernames[i].Create(QbItemType.StructItemString);
                                    markernames[i].ItemQbKey = QbKey.Create(0x7D30DF01);
                                    verbose(SubstringExtensions.EncloseWithQuoteMarks(mrkrs[i].TextValue) + "\n", chartConvColor);
                                    markernames[i].Strings[0] = mrkrs[i].TextValue.Substring(8);//markerstr[i * 2 + 1];
                                }
                                verboseline("Adding marker arrays to QB.", chartConvColor);
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
                                verboseline("Creating and adding other things...", chartConvColor);
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
                                verboseline("Adding scripts array to QB.", chartConvColor);
                                songdata.AddItem(array_scripts);
                                array_scripts.AddItem(array_scripts_array);
                                for (int i = 0; i < scripts.Count; i++)
                                {
                                    array_scripts_array.AddItem(scripts[i]);
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
                                QbItemString songchrtr = new QbItemString(songdata);
                                songchrtr.Create(QbItemType.StructItemString);
                                songchrtr.ItemQbKey = QbKey.Create("charter");
                                songtitle.Strings[0] = songini.GetKeyValue("song", "name", "Untitled").Trim();
                                songauthr.Strings[0] = songini.GetKeyValue("song", "artist", "Unknown").Trim();
                                songalbum.Strings[0] = songini.GetKeyValue("song", "album", "Unknown").Trim();
                                songyear.Strings[0] = songini.GetKeyValue("song", "year", "Unknown").Trim();
                                songchrtr.Strings[0] = songini.GetKeyValue("song", "charter", "Unknown").Trim();
                                string genre = songini.GetKeyValue("song", "genre", "Unknown").Trim();
                                foreach (SongSectionEntry s in chart.Song)
                                {
                                    if (s.Key == "Name" && (s.Value.Trim() != ""))
                                        songtitle.Strings[0] = chart.Song["Name"].Value.Trim();
                                    if (s.Key == "Artist" && (s.Value.Trim() != ""))
                                        songauthr.Strings[0] = chart.Song["Artist"].Value.Trim();
                                    if (s.Key == "Charter" && (s.Value.Trim() != ""))
                                        songchrtr.Strings[0] = chart.Song["Charter"].Value.Trim();
                                };
                                songdata.AddItem(songmeta);
                                songmeta.AddItem(songtitle);
                                songmeta.AddItem(songauthr);
                                songmeta.AddItem(songalbum);
                                songmeta.AddItem(songyear);
                                songmeta.AddItem(songchrtr);
                                string timeString = ((endtime / 1000) / 60).ToString("00") + ':' + (((endtime / 1000) % 60)).ToString("00");
                                string[] songParams = new string[] {
                                songauthr.Strings[0],
                                songtitle.Strings[0],
                                songalbum.Strings[0],
                                songchrtr.Strings[0],
                                songyear.Strings[0],
                                timeString,
                                genre
                            };
                                File.WriteAllText(folder + "currentsong.txt",
                                    FormatText(
                                        settings.GetKeyValue("Misc", "SongtextFormat", "%a - %t")
                                        .Replace("\\n", Environment.NewLine),
                                    songParams));
                                #endregion
                                #endregion
                                verboseline("Aligning pointers...", chartConvColor);
                                songdata.AlignPointers();
                                verboseline("Writing song.qb...", chartConvColor);
                                //songdata.Write(folder + pak + "song.qb");
                                print("Compiling PAK.", chartConvColor);
                                // somehow songs\fastgh3.mid.qb =/= E15310CD here
                                // wtf is the name of 993B9724
                                // though i think name wouldnt actually
                                // matter here because of how the game
                                // loads paks, which doesnt care about
                                // whatever the files are called,
                                // as long as its data gets loaded
                                try
                                {
                                    buildsong.ReplaceFile("E15310CD", songdata);// folder + pak + "song.qb"); // songs\fastgh3.mid.qb
                                }
                                catch
                                {
                                    buildsong.AddFile(songdata, "E15310CD", QbKey.Create(".qb"), false);
                                }
                                File.Delete(folder + pak + "song.qb");
                                if (cacheEnabled)
                                {
                                    print("Writing PAK to cache.", cacheColor);
                                    File.Copy(
                                        folder + "\\DATA\\PAK\\song.pak.xen",
                                        folder + "\\DATA\\CACHE\\" + charthash.ToString("X16"), true);
                                    cache.SetKeyValue(charthash.ToString("X16"), "Title", songtitle.Strings[0]);
                                    cache.SetKeyValue(charthash.ToString("X16"), "Author", songauthr.Strings[0]);
                                    cache.SetKeyValue(charthash.ToString("X16"), "Length", timeString);
                                    cache.Save(folder + dataf + "CACHE\\.db.ini");
                                }
                                verboseline("DID EVERYTHING WORK?!");
                            }
                            else
                            {
                                string cacheidStr = charthash.ToString("X16");
                                print("Cached chart found.", cacheColor);
                                File.Copy(
                                    folder + "\\DATA\\CACHE\\" + cacheidStr,
                                    folder + "\\DATA\\PAK\\song.pak.xen", true);
                                File.Copy(args[0], paksongmid, true);
                                mid2chart.Start();
                                mid2chart.WaitForExit();
                                if (ischart)
                                {
                                    chart.Load(args[0]);
                                }
                                else chart.Load(folder + pak + "song.chart");
                                string unknown = "Unknown";
                                string title = "Untitled", author = unknown,
                                    year = unknown, timestr = unknown,
                                    album = unknown, charter = unknown,
                                    genre = unknown;
                                title = cache.GetKeyValue(cacheidStr, "Title", "Untitled");
                                author = cache.GetKeyValue(cacheidStr, "Author", unknown);
                                timestr = cache.GetKeyValue(cacheidStr, "Length", "Undefined");
                                IniFile songini = new IniFile();
                                if (File.Exists("song.ini"))
                                {
                                    songini.Load("song.ini");
                                    title = songini.GetKeyValue("song", "name", "Untitled").Trim();
                                    author = songini.GetKeyValue("song", "artist", unknown).Trim();
                                    album = songini.GetKeyValue("song", "album", unknown).Trim();
                                    year = songini.GetKeyValue("song", "year", unknown).Trim();
                                    charter = songini.GetKeyValue("song", "charter", unknown).Trim();
                                    genre = songini.GetKeyValue("song", "genre", unknown).Trim();
                                    float duration = int.Parse(songini.GetKeyValue("song", "song_length", "0"));
                                    timestr = ((duration / 1000) / 60).ToString("00") + ':' + (((duration / 1000) % 60)).ToString("00");
                                    // MAKE THIS A FUNCTION ^
                                }
                                foreach (SongSectionEntry s in chart.Song)
                                {
                                    // also optimize this with switch and have Value != "" wrap around it
                                    if (s.Key == "Name" && (s.Value.Trim() != ""))
                                        title = chart.Song["Name"].Value.Trim();
                                    if (s.Key == "Artist" && (s.Value.Trim() != ""))
                                        author = chart.Song["Artist"].Value.Trim();
                                    if (s.Key == "Charter" && (s.Value.Trim() != ""))
                                        charter = chart.Song["Charter"].Value.Trim();
                                };
                                string[] songParams = new string[] {
                                author,
                                title,
                                album,
                                charter,
                                year,
                                timestr,
                                genre
                            };
                                File.WriteAllText(folder + "currentsong.txt",
                                    FormatText(
                                        settings.GetKeyValue("Misc", "SongtextFormat", "%a - %t")
                                        .Replace("\\n", Environment.NewLine),
                                    songParams));
                                File.Delete(paksongmid);
                                File.Delete(paksongchart);
                            }
                            #region COMPILE AUDIO TO FSB
                            if (!audCache)
                            {
                                if (!MTFSB)
                                {
                                    if (!fsbbuild.HasExited)
                                    {
                                        print("Waiting for song encoding to finish.", FSBcolor);
                                        fsbbuild.WaitForExit();
                                        if (cacheEnabled)
                                        {
                                            print("Writing audio to cache.", FSBcolor);
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
                                    print("Waiting for song encoding to finish.", FSBcolor);
                                    for (int i = 0; i < fsbbuild2.Length; i++)
                                        if (!notjust3trax || (notjust3trax && i != 0))
                                            if (!fsbbuild2[i].HasExited)
                                                fsbbuild2[i].WaitForExit();
                                    if (notjust3trax)
                                    {
                                        if (!addaud.HasExited)
                                        {
                                            Console.WriteLine("Waiting for extra track merging to finish.", FSBcolor);
                                            addaud.WaitForExit();
                                        }
                                    }
                                    fsbbuild3.Start();
                                    if (!fsbbuild3.HasExited)
                                        fsbbuild3.WaitForExit();
                                    {
                                        if (cacheEnabled)
                                        {
                                            print("Writing audio to cache.", cacheColor);
                                            File.Copy(
                                                folder + "\\DATA\\MUSIC\\fastgh3.fsb.xen",
                                                folder + "\\DATA\\CACHE\\" + audhash.ToString("X16"), true);
                                            cache.SetKeyValue(charthash.ToString("X16"), "Audio", audhash.ToString("X16"));
                                            cache.Save(folder + dataf + "CACHE\\.db.ini");
                                        }
                                    }
                                }
                            }
                            #endregion
                            disallowGameStartup();
                            Console.ResetColor();
                            print("Speeding up.");
                            verboseline("Creating GH3 process...");
                            Process gh3 = new Process();
                            gh3.StartInfo.WorkingDirectory = folder;
                            gh3.StartInfo.FileName = GH3EXEPath;
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
                            print("Ready, go!");
                            gh3.Start();
                            settings.SetKeyValue("Misc", "FinishedLog", "1");
                            settings.Save(folder + "settings.ini");
                            if (settings.GetKeyValue("Misc", "PreserveLog", "0") == "1")
                            {
                                print("Press any key to exit");
                                Console.ReadKey();
                            }
                        }
                        #endregion
                        #region FSP EXTRACT
                        else if (File.Exists(args[0]) &&
                            (args[0].EndsWith(".fsp") || args[0].EndsWith(".zip") ||
                            args[0].EndsWith(".7z") || args[0].EndsWith(".rar")))
                        {
                            launcherlog.WriteLine("\n######### FSP EXTRACT PHASE #########\n");
                            print("Detected song package.", cacheColor);
                            ulong fsphash = WZK64.Create(File.ReadAllBytes(args[0]));
                            string fsphashStr = fsphash.ToString("X16");
                            bool fspcache = false;
                            if (cacheEnabled)
                            {
                                print("Checking cache.", cacheColor);
                                if (cache.GetSection("ZIP" + fsphashStr) != null)
                                {
                                    verboseline("Found cached ID.", cacheColor);
                                    fspcache = true;
                                }
                            }
                            bool compiled = false;
                            List<string> multichartcheck = new List<string>();
                            string tmpf = folder + dataf + "\\CACHE\\" + fsphashStr + '\\', selectedtorun = "";
                            if (!cacheEnabled)
                            {
                                tmpf = Path.GetTempPath() + "Z.FGH3.TMP\\";
                                if (Directory.Exists(tmpf))
                                    Directory.Delete(tmpf, true);
                                else
                                    Directory.CreateDirectory(tmpf);
                            }
                            if (!fspcache && cacheEnabled)
                                print("ZIP not cached.", cacheColor);
                            else
                            {
                                if (fspcache && Directory.Exists(tmpf) && cacheEnabled)
                                    print("Found cached FSP.", cacheColor);
                                else if (!Directory.Exists(tmpf))
                                    print("Error: Cached FSP does not exist. Extracting.", cacheColor);
                            }
                            if (fspcache && Directory.Exists(tmpf) && cacheEnabled)
                            {
                                // freaking copy and paste
                                foreach (string f in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
                                {
                                    if (f.EndsWith(".pak") ||
                                        f.EndsWith(".pak.xen"))
                                    {
                                        verboseline("Found .pak", FSPcolor);
                                        File.Delete(folder + pak + "song.pak.xen");
                                        File.Copy(f, folder + pak + "song.pak.xen", true);
                                        multichartcheck.Add(f);
                                        compiled = true;
                                    }
                                    if (f.EndsWith(".fsb") ||
                                        f.EndsWith(".fsb.xen"))
                                    {
                                        verboseline("Found .fsb", FSPcolor);
                                        File.Delete(folder + music + "fastgh3.fsb.xen");
                                        File.Copy(f, folder + music + "fastgh3.fsb.xen", true);
                                    }
                                    if (f.EndsWith(".chart") ||
                                        f.EndsWith(".mid"))
                                    {
                                        verboseline("Found .chart/.mid", FSPcolor);
                                        // replace this
                                        multichartcheck.Add(f);
                                        selectedtorun = f;
                                    } // should this be run after detecting a PAK
                                      // though then the multichart routine will run regardless
                                    if (f == "song.ini")
                                    {
                                        verboseline("Found song.ini", FSPcolor);
                                    }
                                    if (f.EndsWith(".ogg") ||
                                        f.EndsWith(".mp3") ||
                                        f.EndsWith(".wav") ||
                                        f.EndsWith(".opus"))
                                    {
                                        verboseline("Found audio", FSPcolor);
                                    }
                                }
                            }
                            else
                            {
                                Directory.CreateDirectory(tmpf);
                                bool zipReadBlatantfail = false; // cheap just to get around
                                                                 // ambiguous zip type when downloading (a 7Z) from drive
                                try
                                {
                                    ZipFile.Read(args[0]);
                                }
                                catch
                                {
                                    zipReadBlatantfail = true;
                                }
                                if ((args[0].EndsWith(".zip") || args[0].EndsWith(".fsp" /* :( */)) && !zipReadBlatantfail)
                                {
                                    try
                                    {
                                        using (ZipFile file = ZipFile.Read(args[0]))
                                        {
                                            file.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
                                            foreach (ZipEntry data in file)
                                            {
                                                if (data.FileName.EndsWith(".pak") ||
                                                    data.FileName.EndsWith(".pak.xen"))
                                                {
                                                    verboseline("Found .pak, extracting...", FSPcolor);
                                                    data.Extract(tmpf);
                                                    // do something with this moving when multiple files exist or whatever
                                                    File.Delete(folder + pak + "song.pak.xen");
                                                    File.Copy(tmpf + data.FileName, folder + pak + "song.pak.xen", true);
                                                    multichartcheck.Add(data.FileName);
                                                    compiled = true;
                                                }
                                                if (data.FileName.EndsWith(".fsb") ||
                                                    data.FileName.EndsWith(".fsb.xen"))
                                                {
                                                    verboseline("Found .fsb, extracting...", FSPcolor);
                                                    data.Extract(tmpf);
                                                    File.Delete(folder + music + "fastgh3.fsb.xen");
                                                    File.Copy(tmpf + data.FileName, folder + music + "fastgh3.fsb.xen", true);
                                                }
                                                if (data.FileName.EndsWith(".chart") ||
                                                    data.FileName.EndsWith(".mid"))
                                                {
                                                    verboseline("Found .chart/.mid, extracting...", FSPcolor);
                                                    data.Extract(tmpf);
                                                    // replace this
                                                    multichartcheck.Add(data.FileName);
                                                    selectedtorun = tmpf + data.FileName;
                                                } // should this be run after detecting a PAK
                                                  // though then the multichart routine will run regardless
                                                if (data.FileName == "song.ini")
                                                {
                                                    verboseline("Found song.ini, extracting...", FSPcolor);
                                                    data.Extract(tmpf);
                                                }
                                                if (data.FileName.EndsWith(".ogg") ||
                                                    data.FileName.EndsWith(".mp3") ||
                                                    data.FileName.EndsWith(".wav") ||
                                                    data.FileName.EndsWith(".opus"))
                                                {
                                                    verboseline("Found audio, extracting...", FSPcolor);
                                                    data.Extract(tmpf);
                                                }
                                            }
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        print("ERROR! :(\n" + ex.Message, ConsoleColor.Red);
                                        Console.ReadKey();
                                    }
                                }
                                else
                                // extract using 7-zip or WinRAR if installed
                                {
                                    verboseline("OH NO, THE SEVENS AND THE ROARS!", FSPcolor); // lol
                                    bool got7Z = false, gotWRAR = false;
                                    verboseline("Looking for command line accessible 7Zip.", FSPcolor);
                                    string z7path = FindExePath("7z.exe"); // do i have to specify .exe
                                    got7Z = z7path != "";
                                    if (!got7Z)
                                    {
                                        z7path = FindExePath("7za.exe");
                                        got7Z = z7path != "";
                                    }
                                    // todo?: check associated program for 7z/rar??
                                    // but then that will lead to getting the EXE for the GUI
                                    // of the program, if not the CLI unless it's a specific
                                    // program where the CLI is the main EXE
                                    string rarpath = "";
                                    if (!got7Z)
                                    {
                                        // or look in registry
                                        verboseline("Looking for 7Zip in registry.", FSPcolor);
                                        RegistryKey z7key;
                                        // also check HKLM hive?
                                        z7key = Registry.CurrentUser.OpenSubKey("SOFTWARE\\7-Zip");
                                        if (z7key != null)
                                        {
                                            z7path = (string)z7key.GetValue("Path");
                                            if (z7path == null)
                                            {
                                                z7path = (string)z7key.GetValue("Path64");
                                                if (z7path != null)
                                                    got7Z = true;
                                            }
                                            else
                                                got7Z = true;
                                            if (got7Z)
                                                z7path += "\\7z.exe";
                                            if (!File.Exists(z7path) && got7Z)
                                            {
                                                verboseline("Wait WTF, THE PROGRAM ISN'T THERE!! HOW!", FSPcolor);
                                                got7Z = false;
                                            }
                                        }
                                        z7key.Close();
                                    }
                                    else
                                        verboseline("Found 7Zip", FSPcolor);
                                    if (got7Z)
                                    {
                                        verboseline("7Zip is installed. Using that...", FSPcolor);
                                        //verboseline(z7path);
                                    }
                                    else
                                    {
                                        verboseline("7Zip could not be found.", FSPcolor);
                                        verboseline("Looking for command line accessible WinRAR or UnRar.exe", FSPcolor);
                                        rarpath = FindExePath("UnRar.exe");
                                        gotWRAR = rarpath != "";
                                        if (gotWRAR)
                                        {
                                            if (!args[0].EndsWith(".rar"))
                                            {
                                                MessageBox.Show("7Z is not supported by UnRAR, unless you have 7-Zip installed, or manually extract the 7Z using the WinRAR interface.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                                if (writefile && launcherlog != null)
                                                    launcherlog.Close();
                                                settings.SetKeyValue("Misc", "FinishedLog", "1");
                                                settings.Save(folder + "settings.ini");
                                                Environment.Exit(1);
                                            }
                                            verboseline("Found UnRAR. Using that...", FSPcolor);
                                        }
                                        else
                                            verboseline("UnRAR could not be found.", FSPcolor);
                                    }
                                    Process Xtract = new Process();
                                    if (!verboselog && !writefile)
                                    {
                                        Xtract.StartInfo.CreateNoWindow = true;
                                        Xtract.StartInfo.UseShellExecute = true;
                                        Xtract.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                                    }
                                    else
                                    {
                                        Xtract.StartInfo.UseShellExecute = false;
                                        Xtract.StartInfo.RedirectStandardError = true;
                                        Xtract.StartInfo.RedirectStandardOutput = true;
                                        Xtract.ErrorDataReceived += (sendingProcess, errorLine) => print(errorLine.Data, FSPcolor);
                                        Xtract.OutputDataReceived += (sendingProcess, dataLine) => print(dataLine.Data, FSPcolor);
                                    }

                                    if (got7Z)
                                    {
                                        Xtract.StartInfo.FileName = z7path;
                                        Xtract.StartInfo.Arguments = "x " + args[0].EncloseWithQuoteMarks() + " -o" + tmpf.EncloseWithQuoteMarks();
                                    }
                                    else if (gotWRAR)
                                    {
                                        Xtract.StartInfo.FileName = rarpath;
                                        Xtract.StartInfo.Arguments = "x -o+ " + Path.GetFullPath(args[0]).EncloseWithQuoteMarks() + " " + tmpf.EncloseWithQuoteMarks();
                                    }
                                    else
                                    {
                                        verboseline("Unsupported archive type", FSPcolor);
                                        MessageBox.Show("Unsupported archive type, unless you have 7-Zip or WinRAR installed.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                        if (writefile && launcherlog != null)
                                            launcherlog.Close();
                                        settings.SetKeyValue("Misc", "FinishedLog", "1");
                                        settings.Save(folder + "settings.ini");
                                        Environment.Exit(1);
                                    }
                                    if (got7Z || gotWRAR)
                                    {
                                        verboseline("Executing " + Xtract.StartInfo.FileName.EncloseWithQuoteMarks() + " " + Xtract.StartInfo.Arguments, FSPcolor);
                                        Xtract.Start();
                                        Xtract.WaitForExit();
                                        verboseline("Exit code: " + Xtract.ExitCode, FSPcolor);
                                        if (Xtract.ExitCode != 0)
                                        {
                                            MessageBox.Show("The extractor returned a non-zero error code. This could mean that the extraction has failed.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                            Environment.Exit(1);
                                        }
                                        foreach (string f in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
                                        {
                                            if (f.EndsWith(".pak") ||
                                                f.EndsWith(".pak.xen"))
                                            {
                                                verboseline("Found .pak", FSPcolor);
                                                // do something with this moving when multiple files exist or whatever
                                                File.Delete(folder + pak + "song.pak.xen");
                                                File.Move(f, folder + pak + "song.pak.xen");
                                                multichartcheck.Add(f);
                                                compiled = true;
                                            }
                                            if (f.EndsWith(".fsb") ||
                                                f.EndsWith(".fsb.xen"))
                                            {
                                                verboseline("Found .fsb", FSPcolor);
                                                File.Delete(folder + music + "fastgh3.fsb.xen");
                                                File.Move(f, folder + music + "fastgh3.fsb.xen");
                                            }
                                            if (f.EndsWith(".chart") ||
                                                f.EndsWith(".mid"))
                                            {
                                                verboseline("Found .chart/.mid", FSPcolor);
                                                // replace this
                                                multichartcheck.Add(f);
                                                selectedtorun = f;
                                            } // should this be run after detecting a PAK
                                              // though then the multichart routine will run regardless
                                            if (f == "song.ini")
                                            {
                                                verboseline("Found song.ini", FSPcolor);
                                            }
                                            if (f.EndsWith(".ogg") ||
                                                f.EndsWith(".mp3") ||
                                                f.EndsWith(".wav") ||
                                                f.EndsWith(".opus"))
                                            {
                                                verboseline("Found audio", FSPcolor);
                                            }
                                        }
                                    }
                                }
                            }
                            if (cacheEnabled && !fspcache)
                            {
                                print("Writing path to cache...", cacheColor);
                                cache.SetKeyValue("ZIP" + fsphashStr, "Path", tmpf);
                                cache.Save(folder + dataf + "CACHE\\.db.ini");
                            }
                            if (multichartcheck.Count == 0)
                            {
                                verboseline("There's nothing in here!", ConsoleColor.Red);
                                // ♫ There's nothing for me here ♫
                                MessageBox.Show("No chart found", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                if (writefile && launcherlog != null)
                                    launcherlog.Close();
                                settings.SetKeyValue("Misc", "FinishedLog", "1");
                                settings.Save(folder + "settings.ini");
                                Environment.Exit(1);
                            }
                            bool cancel = false;
                            if (multichartcheck.Count > 1)
                            {
                                fspmultichart askchoose = new fspmultichart(multichartcheck.ToArray());
                                askchoose.ShowDialog();
                                if (File.Exists(askchoose.chosen) && askchoose.DialogResult == DialogResult.OK)
                                {
                                    selectedtorun = askchoose.chosen;
                                    compiled = !Path.GetFileName(askchoose.chosen).EndsWith(".chart") &&
                                                !Path.GetFileName(askchoose.chosen).EndsWith(".mid");
                                }
                                cancel = askchoose.DialogResult == DialogResult.Cancel;
                            }
                            if (!cancel)
                                if (compiled)
                                {
                                    Console.ResetColor();
                                    print("Speeding up.");
                                    verboseline("Creating GH3 process...");
                                    Process gh3 = new Process();
                                    gh3.StartInfo.WorkingDirectory = folder;
                                    gh3.StartInfo.FileName = GH3EXEPath;
                                    // dont do this lol
                                    if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                                        settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                                    settings.Save(folder + "settings.ini");
                                    print("Ready, go!");
                                    gh3.Start();
                                    settings.SetKeyValue("Misc", "FinishedLog", "1");
                                    settings.Save(folder + "settings.ini");
                                }
                                else
                                {
                                    if (writefile && launcherlog != null)
                                        launcherlog.Close();
                                    Process.Start(Application.ExecutablePath, selectedtorun.EncloseWithQuoteMarks());
                                    Environment.Exit(0);
                                }
                        }
                        else if ((args[0].EndsWith(".pak") || args[0].EndsWith(".pak.xen")))
                        {
                            Console.WriteLine("FastGH3 by donnaken15");
                            print("Detected song PAK.", FSPcolor);
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
                                    Console.ResetColor();
                                    print("Speeding up.");
                                    verboseline("Creating GH3 process...");
                                    Process gh3 = new Process();
                                    gh3.StartInfo.WorkingDirectory = folder;
                                    gh3.StartInfo.FileName = folder + GH3EXEPath;
                                    // dont do this lol
                                    if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
                                        settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
                                    settings.Save(folder + "settings.ini");
                                    print("Ready, go!");
                                    //gh3.Start();
                                    if (settings.GetKeyValue("Misc", "PreserveLog", "0") == "1")
                                    {
                                        print("Press any key to exit");
                                        Console.ReadKey();
                                    }
                                    settings.SetKeyValue("Misc", "FinishedLog", "1");
                                    settings.Save(folder + "settings.ini");
                                }
                            }
                        }
                        #endregion
                    }
                    else print("That file does not exist. Aborting", ConsoleColor.Red);
                }
            }
            catch (Exception ex)
            {
                ConsoleColor oldcolor = Console.ForegroundColor;
                Console.ForegroundColor = ConsoleColor.Red;
                print("ERROR! :(");
                print(ex);
                // what instance would this fit v
                /*Exception exx = ex.InnerException;
                while (exx != null)
                {
                    print("Exception spawned from:");
                    exx = exx.InnerException;
                }*/
                Console.ForegroundColor = oldcolor;
                Console.ResetColor(); // NOT WORKING
                print("Press any key to exit");
                Console.ReadKey();
            }
            GC.Collect();
            if (writefile && launcherlog != null)
                launcherlog.Close();
        }
    }
}