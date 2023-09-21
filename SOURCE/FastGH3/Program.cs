using ChartEdit;
using Ionic.Zip;
using Microsoft.Win32;
using Nanook.QueenBee.Parser;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

#pragma warning disable CS0162 // Unreachable code detected NO ONE CARES

class Program
{
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileInt", CharSet = CharSet.Unicode)]
	public static extern int GI(
		string a, string k, int d, string f);
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern int GStr(
		string a, string k,
		string d, [In, Out] byte[] s,
		int n, string f);
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileSectionNames", CharSet = CharSet.Unicode)]
	public static extern int GSN(
		char[] s, int n, string f);
	[DllImport("kernel32.dll", EntryPoint = "WritePrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern bool WSec(
		string a, string s, string f);
	[DllImport("kernel32.dll", EntryPoint = "WritePrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern bool WStr(
		string a, string k, string s, string f);
	//https://www.pinvoke.net/default.aspx/kernel32.GetPrivateProfileSectionNames
	public static string[] sn(string i)
	{
		char[] buf = new char[0x20000];
		// being generous for people playing 6500 songs
		// (16+3+1)*(6553*1)
		//hash+
		//  prefix+
		//       nullterm
		//         *entrycount
		// TODO: clear cache when too many songs are cached?
		int retn = GSN(buf, buf.Length, i);
		if (retn == 0)
			return new string[0];
		string ret = new string(buf).Substring(0, retn);
		return ret.Substring(0, ret.Length - 1).Split('\0');
	}

	public static string folder, dataf = "DATA\\", pakf,
		music, vid, mt, cf, title = "FastGH3";

	static bool vb, wl = true;
	public static string inif;
	public static string cachf;
	static StreamWriter log = null;
	static string GH3EXEPath;

	// from stackoverflow 1266674
	public static string NP(string path)
	{
		return Path.GetFullPath(new Uri(path).LocalPath)
					.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
					.ToUpperInvariant();
	}

	public static string m = "Misc";
	public static string l = "Launcher";
	public static string ks = "Killswitch";
	public static string fl = "FinishedLog";
	public static string sv = "SongVideos";
	public static string lshv = "LastSongHadVideo";
	public static string stf = "SongtextFormat";
	public static string IF(string f) // ini path fix
	{
		return Path.IsPathRooted(f) ? f : Directory.GetCurrentDirectory() + '\\' + f;
	}
	public static string ini(string a, string k, string d, int i, string f)
	{
		byte[] _ = new byte[i];
		int len = GStr(a, k, d, _, i, IF(f));
		Array.Resize(ref _, len*2);
		return Encoding.Unicode.GetString(_);
	}
	public static int ini(string a, string k, int d, string f)
	{
		return GI(a, k, d, IF(f));
	}
	public static int cfg(string a, string k, int d)
	{
		return GI(a, k, d, inif);
	}
	public static string ini(string s, string k, string d, string f) // for being lazy
	{
		return ini(s, k, d, 0x200, f);
	}
	public static string cfg(string s, string k, string d, int i)
	{
		return ini(s, k, d, i, inif);
	}
	public static string cfg(string s, string k, string d) // for being lazy
	{
		return ini(s, k, d, 0x200, inif);
	}
	public static void iniw(string s, string k, object d, string f)
	{
		WStr(s, k, d.ToString(), f);
	}
	public static void cfgW(string s, string k, object d)
	{
		iniw(s, k, d, inif);
	}
	public static void killgame()
	{
		cfgW(m, ks, 1);
	}
	public static void unkillgame()
	{
		cfgW(m, ks, 0);
	}
	static void cSV(string bik)
	{
		#region EXTRA: DETECT BINK BACKGROUND VIDEO PACKED WITH CHART
		// definitely no one will use this
		if (cfg(l, sv, 0) == 1)
		{
			// low IQ:
			// detect if RAD Video Tools is installed
			// and convert the song's background video (MP4)
			// to Bink, and wait like 10 minutes for it
			// to finish encoding
			//vl("Song videos enabled");
			try
			{
				if (File.Exists(bik))
				{
					vl(vstr[99]);
					//vl("Found (Bink) background video");
					if (cfg(m, lshv, 0) == 0)
					{
						vl(vstr[132]);
						// save last background video
						File.Copy(
							vid + "backgrnd_video.bik.xen",
							vid + "lastvid", true);
						cfgW(m, lshv, 1);
					}
					File.Copy(bik,
						vid + "backgrnd_video.bik.xen", true);
				}
				else
				{
					vl(vstr[100]);
					//vl("No (Bink) background video found");
					if (cfg(m, lshv, 0) == 1)
					{
						vl(vstr[133]);
						// restore user video after playing a song a background video
						// and now playing a song without one
						if (File.Exists(vid + "lastvid"))
						{
							File.Copy(
								vid + "lastvid",
								vid + "backgrnd_video.bik.xen", true);
							File.Delete(vid + "lastvid");
						}
						else
							File.Delete(vid + "backgrnd_video.bik.xen");
						// if there's no previous video, just delete the current one
						cfgW(m, lshv, 0);
					}
				}
			}
			catch (Exception e)
			{
				print("Failed to copy song video.");
				vl(e);
			}
		}
		#endregion
	}
	// todo: send ctrl-c to fsbbuild scripts
	static void killEncoders()
	{
		try
		{
			foreach (Process proc in Process.GetProcessesByName("helix"))
			{
				if (NP(proc.MainModule.FileName) == NP(mt + "helix.exe"))
					proc.Kill();
			}
			foreach (Process proc in Process.GetProcessesByName("sox"))
			{
				if (NP(proc.MainModule.FileName) == NP(mt + "sox.exe"))
					proc.Kill();
			}
		}
		catch
		{
			print(vstr[134]);
		}
	}

	static void die()
	{
		// program dies too slow for it to not interfere with later process spawns
		// "THEN RESTART YOUR COMPUTER DARK HUMOR DEPRESSINGLY EDGY KID STUPI-"
		Process.GetCurrentProcess().Kill();
	}
	static uint Eswap(uint v)
	{
		return ((v & 0xFF) << 24) |
				((v & 0xFF00) << 8) |
				((v & 0xFF0000) >> 8) |
				((v & 0xFF000000) >> 24);
	}
	/*static uint Eswap(int v)
	{
		return Eswap((uint)v);
	}
	static ushort Eswap(ushort v)
	{
		return (ushort)((v << 8) | (v >> 8));
	}*/

	static TimeSpan time
	{
		get
		{
			return DateTime.UtcNow - Process.GetCurrentProcess().StartTime.ToUniversalTime();
		}
	}

	static string ms
	{
		get
		{
			return "<" + (time.TotalMilliseconds / 1000).ToString("0.000") + ">";
		}
	}

	// cancel conversion
	public static void exit()
	{
		cfgW("Temp", fl, 1);
		cfgW("Temp", "ConvPID", -1);
		cfgW("Temp", "LoadingLock", 0);
		if (wl && log != null)
		{
			log.Close();
			wl = false; // actually die i'm not kidding you deserve it life would be so much better if you did not exist take a bow
		}
	}
	public static void stupid(Process p)
	{
		if (!p.HasExited)
			p.Kill();
		/*try
		{
			foreach (Process proc in Process.GetProcessesByName("game"))
				if (NP(proc.MainModule.FileName) == NP(folder + "game.exe"))
					proc.Kill();
			foreach (Process proc in Process.GetProcessesByName("game!"))
				if (NP(proc.MainModule.FileName) == NP(folder + "game!.exe"))
					proc.Kill();
		}
		catch { }*/
	}

	// print base
	public static void _l(object t, bool v)
	{
		if (wl && log != null)
		{
			if (v) log.Write(ms);
			log.WriteLine(t);
			log.Flush();
		}
	}
	public static void v(object t)
	{
		if (vb)
			Console.Write(t);
		if (wl && log != null)
		{
			log.Write(t);
			log.Flush();
		}
	}
	public static void v(object t, ConsoleColor c)
	{
		ConsoleColor o = Console.ForegroundColor;
		if (coll)
			Console.ForegroundColor = c;
		v(t);
		if (coll)
			Console.ForegroundColor = o;
	}
	public static void vl(object t)
	{
		if (vb)
		{
			Console.Write(ms);
			Console.WriteLine(t);
		}
		_l(t, true);
	}
	public static void vl(object t, ConsoleColor c)
	{
		ConsoleColor o = Console.ForegroundColor;
		if (coll)
			Console.ForegroundColor = c;
		vl(t);
		if (coll)
			Console.ForegroundColor = o;
	}
	public static void print(object t)
	{
		Console.WriteLine(t);
		_l(t, true);
	}
	public static void print(object text, ConsoleColor col)
	{
		ConsoleColor oldcol = Console.ForegroundColor;
		if (coll)
			Console.ForegroundColor = col;
		print(text);
		if (coll)
			Console.ForegroundColor = oldcol;
	}

	static bool caching = true;
	static string[] cacheList;

	// Ask for filename just because external data is being handled.
	/*static bool isCached(string f) // not using this apparently
	{
		if (caching)
		{
			ulong h = WZK64.Create(File.ReadAllBytes(f));
			return isCached(h);
		}
		return false;
	}*/
	static bool isCached(ulong h)
	{
		if (caching)
		{
			string id = h.ToString("X16");
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
	// <exception cref="System.IO.FileNotFoundException">Raised when the exe was not found</exception>
	public static string where(string e)
	{
		e = Environment.ExpandEnvironmentVariables(e);
		if (!File.Exists(e))
		{
			if (Path.GetDirectoryName(e) == String.Empty)
			{
				foreach (string v in (Environment.GetEnvironmentVariable("PATH") ?? "").Split(';'))
				{
					string p = v.Trim();
					if (!String.IsNullOrEmpty(p) && File.Exists(p = Path.Combine(p, e)))
						return Path.GetFullPath(p);
				}
			}
			return "";
			//throw new FileNotFoundException(new FileNotFoundException().Message, exe);
		}
		return Path.GetFullPath(e);
	}

	static string fmtSyms = "atbcylg";
	//                   lol
	public static string FormatText(string inp, string[] p)
	{
		string f = inp;
		if (f == null)
			f = "%a - %t";
		for (int i = 0; i < f.Length; i++)
		{
			if (f[i] == '%' && i + 1 < f.Length)
			{
				char s = f[i + 1];
				f = f.Remove(i, 2);
				f = f.Insert(i, (fmtSyms.IndexOf(s) == -1)
					? s.ToString() : p[fmtSyms.IndexOf(s)]);
				// if following character isn't in fmtSyms array,
				// ignore replacing it with a string from p[]
				i++;
			}
		}
		return f;
	}

	static bool coll = true; // color log

	enum SF
	{
		FO1,
		FO2,
		SP,
		Pow
	}

	static Tuple<List<Note>,List<int>> S2P(NoteTrack t, SF s)
	{
		// count notes in starpower phrases
		// weird setup
		// Thanks Neversoft

		// i forgot how this even works
		List<Note> sT = new List<Note>();
		Note sL = new Note(), nL = new Note();
		int sT3 = 0, sT2 = 0;
		List<int> sNC = new List<int>();
		foreach (Note a in t)
		{
			if (a.Type == NoteType.Regular && sL != null)
			{
				nL = a;
				sT3 = nL.Offset;
				if (sT3 >= sL.Offset && sT3 < sL.OffsetEnd)
				{
					sT2++;
				}
				else
				{
					if (sT2 > 0)
					{
						sNC.Add(sT2);
						sT2 = 0;
					}
				}
			}
			if (a.Type == NoteType.Special &&
				a.SpecialFlag == (int)s)
			{
				sT.Add(a);
				sL = a;
				sT3 = nL.Offset;
				if (sT3 >= sL.Offset && sT3 < sL.OffsetEnd)
				{
					sT2++;
				}
			}
		}
		return Tuple.Create(sT, sNC);
	}

	static short lx, ly;
	// progress bars
	static short[] pbl; // lines to write to
	static void pb(float p, int l) // update progress bar at that line
	{
		if (p < 0 || pbl[l] < 0)
			return;
		try
		{
			//if (wl)
			//_l("track "+l.ToString()+": "+(p*100).ToString("0.0"), true);
			lx = (short)Console.CursorLeft;
			ly = (short)Console.CursorTop;
			Console.SetCursorPosition(8, pbl[l]);
			Console.Write((p * 100).ToString("0").PadLeft(3));
			Console.CursorLeft += 3;
			Console.Write(new string('-', (int)Math.Floor(p * 32)));
			Console.SetCursorPosition(lx, ly);
		}
		catch {
			vl("Progress bar fail");
		}
	}
	static void ___(object p, DataReceivedEventArgs a)
	{
		vl(a.Data);
	}
	public static Process cmd(string fn, string a) //new Headless process
	{
		Process n = new Process();
		n.StartInfo = new ProcessStartInfo()
		{
			FileName = fn,
			Arguments = a,
			UseShellExecute = false,
			RedirectStandardError = true,
			RedirectStandardOutput = true,
		};
		n.ErrorDataReceived += ___;
		n.OutputDataReceived += ___;
		return n;
	}
	public static float alen(string f)
	{
		try {
			vl("alen args: sox.exe --i -D " + f.Quotes());
			Process c = cmd(mt + "sox.exe", "--i -D " + f.Quotes());
			c.OutputDataReceived -= ___;
			//c.OutputDataReceived += (p, d) => __(d.Data, i);
			c.Start();
			c.BeginErrorReadLine();
			return Convert.ToSingle(c.StandardOutput.ReadToEnd());
			//if (!c.HasExited) // uhh
			//	c.WaitForExit();
		} catch { return -1f; }
	}
	public static string[] vstr;

	public static string version = "1.0-999010889";
	public static DateTime builddate;
	[STAThread]
	static void Main(string[] args)
	{
		// 36 KB
		try
		{
			Console.Title = title;
			folder = Path.GetDirectoryName(Application.ExecutablePath) + '\\';//Environment.GetCommandLineArgs()[0].Replace("\\FastGH3.exe", "");
			inif = folder + "settings.ini";
			// System.Reflection.Emit wat dis
			bool mic_ = cfg(l, "DisableMultiInstCheck", 0) == 0;
			// multi instance check
			// not working for one user
			// maybe admin related
			if (mic_)
			{
				Process[] mic = Process.GetProcessesByName(
					// who's going to rename this program
					Path.GetFileNameWithoutExtension(Application.ExecutablePath));
				//MessageBox.Show(mic.Length.ToString());
				if (mic.Length > 1)
					foreach (Process fgh3 in mic)
					{
						if (NP(fgh3.MainModule.FileName) ==
							NP(Application.ExecutablePath) &&
							fgh3.Id != Process.GetCurrentProcess().Id)
						{
							// can't check process arguments >:(
							// without some complicated WMI thing
							// unless (as i thought of using) i
							// use an MMF to indicate that a
							// song converting launcher is active
							// 1 or [0] = probably this process
							//if (micn > 1)
								if (cfg("Temp","ConvPID",-1) > -1 && (File.Exists(args[0]) || args[0] == "dl"))
								{
									MessageBox.Show("FastGH3 Launcher is already running!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
									Environment.Exit(0x4DF); // ERROR_ALREADY_INITIALIZED
									break;
								}
						}
					}
				else
					cfgW("Temp", "ConvPID", -1);
			}
			else
				print("Multi instance checking is off. Be careful!");
			GH3EXEPath = NP(folder + "game.exe");
			//if (File.Exists(folder + "settings.ini"))
				//ini.Load(folder + "settings.ini");
			vb = cfg(l, settings.t.VerboseLog.ToString(), 0) == 1;
			vstr = Resources.ResourceManager.GetString("vstr").Split('\n');
			dataf = folder + dataf;
			pakf = dataf + "PAK\\";
			music = dataf + "MUSIC\\";
			vid = dataf + "MOVIES\\BIK\\";
			mt = music + "TOOLS\\";
			cf = dataf + "CACHE\\";
			for (int i = 0; i < vstr.Length; i++)
			{
				vstr[i] = Regex.Unescape(vstr[i]);
			}

			// too many items in [Misc]
			// hate me
			// also finally INI CFunc
			if (cfg("Temp", "MigratedConfig2", 0) == 0)
			{
				cfgW(l, settings.t.SongCaching.ToString(), cfg(m, settings.t.Windowed.ToString(), 1));
				cfgW(l, settings.t.PreserveLog.ToString(), cfg(m, settings.t.PreserveLog.ToString(), 0));
				cfgW(l, settings.t.VerboseLog.ToString(), cfg(m, settings.t.VerboseLog.ToString(), 0));
				cfgW(l, settings.t.NoStartupMsg.ToString(), cfg(m, settings.t.NoStartupMsg.ToString(), 0));
				cfgW(l, settings.t.VerboseLog.ToString(), cfg(m, settings.t.VerboseLog.ToString(), 0));
				cfgW(l, "DisableMultiInstCheck", cfg(m, "DisableMultiInstCheck", 0));
				cfgW("Audio", "AB", cfg(m, "AB", 96));
				cfgW("Audio", "VBR", cfg(m, "VBR", 0));
				cfgW("Audio", "FixSeeking", cfg(m, "FixSeeking", 0));
				cfgW(l, stf, cfg(m, stf, ""));
				cfgW(l, sv, cfg(m, sv, 0));
				cfgW("GFX", "VSync", cfg(m, "VSync", 0));
				cfgW("GFX", settings.t.Borderless.ToString(), cfg(m, settings.t.Borderless.ToString(), 0));
				cfgW("GFX", settings.t.Windowed.ToString(), cfg(m, settings.t.Windowed.ToString(), 0));
				cfgW("Temp", "MigratedConfig2", 1);
			}

			vl(vstr[0]);// "Initializing..."
			caching = cfg(l, settings.t.SongCaching.ToString(), 1) == 1;
			if (caching)
			{
				Directory.CreateDirectory(cf);
				cachf = cf + ".db.ini";
			}
			#region NO ARGS ROUTINE
			if (args.Length == 0)
			{
				if (cfg(l, settings.t.NoStartupMsg.ToString(), 0) == 0)
				{
					Console.Clear();
					Console.WriteLine(Resources.ResourceManager.GetString("splashText"));
					Console.ReadKey();
				}
				OpenFileDialog openchart = new OpenFileDialog()
				{
					AddExtension = true,
					CheckFileExists = true,
					CheckPathExists = true,
					Filter = vstr[130],
					RestoreDirectory = true,
					Title = "Select chart"
				};
				if (openchart.ShowDialog() == DialogResult.OK)
				{
					// TODO?: process start and redirect output to this EXE
					// when MMF is figured out for multi instances
					Process.Start(Application.ExecutablePath, SubstringExtensions.Quotes(openchart.FileName));
				}
				Environment.Exit(unchecked(0x11111111));
			}
			#endregion
			if (args.Length > 0)
			{
				// combine logs from any of 3 processes to easily look for errors from all of them
				bool newfile = cfg("Temp", fl, 1) == 1;
				if (args[0] != "-settings" &&
					args[0] != "-gfxswap" &&
					args[0] != "-shuffle")
					if (wl)
					{
						// half kb?
						if (newfile)
						{
							File.Delete(folder + "launcher.txt");
						}
						log = new StreamWriter(folder + "launcher.txt", !newfile);
						if (newfile)
						{
							log.WriteLine(vstr[1]);
							try {
								builddate = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc).AddSeconds(Eswap(BitConverter.ToUInt32(File.ReadAllBytes(mt + "bt.bin"), 0)));
								// a person legitimately had this file missing, how is that even possible >:(
							} catch {
								builddate = DateTime.MinValue;
							}
							log.WriteLine("version " + version + " / build time: " + builddate);
							newfile = false;
							cfgW("Temp", fl, 0);
						}
					}
				string chartext = ".chart", midext = ".mid",
					paksongmid = pakf + "song" + midext,
					paksongchart = pakf + "song" + chartext,
					songpak = pakf + "song.pak.xen",
					fsb = music + "fastgh3.fsb.xen";
				ConsoleColor cacheColor = ConsoleColor.Cyan,
					chartConvColor = ConsoleColor.Green,
					bossColor = ConsoleColor.Blue,
					FSBcolor = ConsoleColor.Yellow,
					FSPcolor = ConsoleColor.Magenta;
				if (args[0] == "-settings")
				{
					builddate = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc).AddSeconds(Eswap(BitConverter.ToUInt32(File.ReadAllBytes(mt + "bt.bin"), 0)));
					// muh classic theme
					//Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
					Directory.SetCurrentDirectory(folder);
					new settings().ShowDialog();
					// settings file 31kb
				}
				#region SHUFFLE
				else if (args[0] == "-shuffle")
				{
					// 0.5-1 kb
					Console.WriteLine(vstr[101]);
					List<string> paths, files;
					/*IniFile.IniSection shuffleCfg;
					if (ini.GetSection("Shuffle") == null)
					{
						MessageBox.Show(vstr[2], "Error", // "Shuffle settings section cannot be found"
							MessageBoxButtons.OK, MessageBoxIcon.Error);
						Environment.Exit(1);
					}
					shuffleCfg = ini.GetSection("Shuffle");*/
					//vl("got shuffle section");
					paths = new List<string>();
					string curpath;
					int j = 0;
					string p;
					while ((p = cfg("Shuffle","path"+(++j).ToString(),"")) != "")
					{
						curpath = NP(p);
						if (Directory.Exists(curpath) && paths.IndexOf(curpath) == -1)
							paths.Add(curpath);
						else if (!Directory.Exists(curpath))
							vl("got invalid directory, skipping: "+p);
					}
					if (paths.Count == 0)
					{
						MessageBox.Show(vstr[2], "Error",
							MessageBoxButtons.OK, MessageBoxIcon.Error);
						Environment.Exit(1);
					}
					vl("added paths ("+paths.Count+")");
					Random rand = new Random((int)DateTime.Now.Ticks);
					string randpath = paths[rand.Next(paths.Count-1)];
					files = new List<string>();
					files.AddRange(Directory.GetFiles(randpath, "*.chart", SearchOption.AllDirectories));
					files.AddRange(Directory.GetFiles(randpath, "*.mid", SearchOption.AllDirectories));
					files.AddRange(Directory.GetFiles(randpath, "*.fsp", SearchOption.AllDirectories));
					vl("added files");
					if (files.Count == 0)
					{
						MessageBox.Show(vstr[3], "Error", // "Can't find any charts!"
							MessageBoxButtons.OK, MessageBoxIcon.Error);
						Environment.Exit(1);
					}
					int choose = rand.Next(files.Count);
					print("Choosing: " + files[choose]);
					Process.Start(folder + "FastGH3.exe", "\"" + files[choose] + "\"");
					die();
				}
				#endregion
				#region GFXSWAP
				else if (args[0] == "-gfxswap")
				{
					// 0.5-1 kb?
					// TODO: replace SCN with one that has the name of the .tex
					if (args.Length > 2)
					{
						if (File.Exists(args[1]) && File.Exists(args[2]))
						{
							string defaultscn = dataf + "zones\\__themes\\default.scn.xen";
							if (args[2].EndsWith(".pak.xen"))
							{
								PakFormat pf = new PakFormat(args[2], args[2].Replace(".pak.xen", ".pab.xen"), "", PakFormatType.PC);
								PakEditor pe = new PakEditor(pf, false);
								if (args[1].EndsWith(".zip"))
								{
									ZipFile zip = ZipFile.Read(args[1]);
									MemoryStream gfx = null, scn = null;
									// expecting .gfx and .scn in these
									foreach (ZipEntry file in zip)
									{
										//Console.WriteLine(file.FileName);
										if ((file.FileName.EndsWith(".gfx.xen") ||
											file.FileName.EndsWith(".tex.xen") ||
											file.FileName.EndsWith(".gfx") ||
											file.FileName.EndsWith(".tex")) &&
											gfx == null)
										{
											Console.WriteLine("found");
											gfx = new MemoryStream((int)file.UncompressedSize);
											file.Extract(gfx);
										}
										if ((file.FileName.EndsWith(".scn.xen") ||
											file.FileName.EndsWith(".scn")) &&
											scn == null)
										{
											Console.WriteLine("found");
											scn = new MemoryStream((int)file.UncompressedSize);
											file.Extract(scn);
										}
									}
									if (gfx == null)
									{
										// "Cannot find a file indicating of containing highway GFX."
										MessageBox.Show(vstr[4], "Error",
											MessageBoxButtons.OK, MessageBoxIcon.Error);
										Environment.Exit(1);
									}
									pe.ReplaceFile("zones\\global\\global_gfx"+".tex", gfx.ToArray());
									if (scn != null)
									{
										pe.ReplaceFile("zones\\global\\global_gfx"+".scn", scn.ToArray());
									}
									else
										pe.ReplaceFile("zones\\global\\global_gfx"+".scn", defaultscn);
								}
								else
								{
									pe.ReplaceFile("zones\\global\\global_gfx.tex", args[1]);
									if (File.Exists(args[1].Replace(".tex", ".scn").Replace(".gfx", ".scn")))
									{
										pe.ReplaceFile("zones\\global\\global_gfx.scn", args[1].Replace(".tex", ".scn").Replace(".gfx", ".scn"));
									}
									else
										pe.ReplaceFile("zones\\global\\global_gfx.scn", defaultscn);
								}
							}
							else
							{
								// "global.pak isn't named correctly."
								Console.WriteLine(vstr[5]);
								Console.ReadKey();
								Environment.Exit(1);
							}
						}
						else
						{
							// "One of the entered files don't exist."
							Console.WriteLine(vstr[6]);
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
				#endregion
				#region DOWNLOAD SONG
				else if (args[0] == "dl" && (args[1] != "" || args[1] != null))
				{
					cfgW("Temp", "ConvPID", Process.GetCurrentProcess().Id);
					// 2kb
					Console.WriteLine(title + " by donnaken15");
					log.WriteLine(vstr[7]); // "\n######### DOWNLOAD SONG PHASE #########\n"
					print(vstr[8], FSPcolor); // "Downloading song package..."
					vl("URL: " + args[1], FSPcolor);
					bool datecheck = true;
					Uri fsplink = new Uri(args[1].Replace("fastgh3://", "http://"));
					string cs = ""; // ...
					string uC = "";
					string tF = "null";
					string adf = vstr[9]; // "already downloaded file." // desperate
					string fdp = " file date. ";
					vl(fsplink.AbsoluteUri, FSPcolor);
					if (caching)
					{
						cs = "URL" + WZK64.Create(fsplink.AbsoluteUri).ToString("X16");
						uC = ini(cs, "File", "", 65, cachf);
						if (uC != "")
						{
							print("Found "+adf, FSPcolor);
							vl(cs);
							vl(uC);
							tF = uC;
							if (!datecheck)
								goto skipToGame;
						}
						if (datecheck)
							print(vstr[10], FSPcolor);
						// "Unique file date checking enabled."
					}
					WebClient fsp = new WebClient();
					fsp.Proxy = null;
					fsp.Headers.Add("user-agent", "Anything");
					ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00); // why .NET 4
					fsp.OpenRead(fsplink);
					DateTime lastmod = new DateTime(), lastmod_cached;
					//verboseline("1");
					if (datecheck && caching)
					{
						if (ini(cs, "Date", 0, cachf) != 0) // STUPID
							lastmod_cached = new DateTime(Convert.ToInt64(ini(cs, "Date", 0, cachf)));
						else
							lastmod_cached = new DateTime(0);
						if (lastmod_cached.Ticks == 0)
							vl(vstr[11], cacheColor); // "Date not cached"
						else
							vl("Cached date: " + lastmod_cached.ToUniversalTime(), cacheColor);
						if (fsp.ResponseHeaders["Last-Modified"] != null)
						{
							//verboseline(fsp.ResponseHeaders["Last-Modified"]);
							lastmod = DateTime.Parse(fsp.ResponseHeaders["Last-Modified"]);
							vl("Got file date: " + lastmod.ToUniversalTime(), cacheColor);
							if (lastmod.Ticks == lastmod_cached.Ticks && lastmod_cached.Ticks != 0)
							{
								vl("Unchanged"+fdp+"Using "+adf, cacheColor);
								goto skipToGame;
							}
							else
							{
								if (lastmod.Ticks == 0)
									print("Different"+fdp+"Redownloading...", cacheColor);
							}
						}
						else
						{
							print("No file date found.", cacheColor);
							if (uC != "")
							{
								print("Using "+adf, cacheColor);
								goto skipToGame;
							}
						}
					}
					if (Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]) > 1024*1024 * 24)
					{
						// i dare use Format once for optimized strings "This song package is a larger file than usual. ({0} MB) Do you want to continue?"
						if (MessageBox.Show(string.Format(vstr[12],
							Math.Round((Convert.ToSingle(Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]))) / 1024 / 1024), 2),
							"Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
						{
							exit();
							Environment.Exit(2);
						}
					}
					//if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
					//settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
					if (File.Exists(tF)) // do this?
						File.Delete(tF);
					tF = Path.GetTempFileName();
					string tmpFl = Path.GetTempPath();
					fsp.DownloadFile(fsplink, tF);
					File.Move(tF, tF + ".fsp");
					//Directory.CreateDirectory(tmpFl + "\\Z.TMP.FGH3$WEB");
					tF += ".fsp";
					if (caching)
					{
						print(vstr[13], cacheColor); // "Writing link to cache..."
						iniw(cs, "File", tF.ToString(), cachf);
						if (datecheck)
						{
							print(vstr[14], cacheColor); // "Writing date to cache..."
							iniw(cs, "Date", lastmod.Ticks.ToString(), cachf);
						}
					}
				skipToGame:
					// download FSP --> open and extract FSP --> convert song --> game
					// FastGH3.exe  --> FastGH3.exe          --> FastGH3.exe  --> game.exe
					// :P
					//GC.Collect();
					exit();
					cfgW("Temp", fl, 0);
					// "already running" >:(
					Process.Start(Application.ExecutablePath, SubstringExtensions.Quotes(tF));
					die();
				}
				#endregion
				else if (File.Exists(args[0]))
				{
					cfgW("Temp", "ConvPID", Process.GetCurrentProcess().Id);
					#region STANDARD ROUTINE
					Console.WriteLine(title + " by donnaken15");
					if (Path.GetFileName(args[0]).EndsWith(chartext) || Path.GetFileName(args[0]).EndsWith(midext))
					{
						bool ischart = false;
						log.WriteLine(vstr[15]); // "\n######### MAIN LAUNCHER PHASE #########\n"
						vl("File is: " + args[0]);
						Process mid2chart = cmd(folder + "mid2chart.exe",
							paksongmid.Quotes() + " -k -u -p -m");
						print(vstr[16], chartConvColor); // "Reading file."
						if (Path.GetFileName(args[0]).EndsWith(chartext))
						{
							vl(vstr[17], chartConvColor); // "Detected chart file."
							ischart = true;
						}
						else if (Path.GetFileName(args[0]).EndsWith(midext) ||
							Path.GetFileName(args[0]).EndsWith(midext + 'i'))
						{
							vl(vstr[18], chartConvColor); // "Detected midi file."
							vl(vstr[19], chartConvColor); // "Converting to chart..."
							// why isnt this working
							//mid2chart.ChartWriter.writeChart(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])), folder + pak + "tmp.chart", false, false);
							//Console.WriteLine(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])).sections[0].name);
							//Console.ReadKey();
							File.Copy(args[0], paksongmid, true);
							vl(vstr[135]);
							mid2chart.Start();
							if (vb || wl)
							{
								mid2chart.BeginErrorReadLine();
								mid2chart.BeginOutputReadLine();
							}
							mid2chart.WaitForExit();
							// im suffering so hard
							if (!File.Exists(paksongchart))
							{
								throw new Exception(vstr[20]);
								//throw new Exception("Cannot find chart after converting from MIDI. Something must've went wrong with mid2chart. Aborting.");
							}
						}
						if (caching)
						{
							vl(vstr[21], cacheColor);
							//vl("Indexing cache...", cacheColor);
							cacheList = Directory.GetFiles(cf);
							for (int i = 0; i < cacheList.Length; i++)
							{
								//verboseline("\r(" + i + "/" + cacheList.Length + ")...");
								// forgot how to rewrite a line
								cacheList[i] = Path.GetFileNameWithoutExtension(cacheList[i]);
							}
						}
						cfgW("Temp", "LoadingLock", 1);
						Chart chart = new Chart();
						if (ischart)
						{
							chart.Load(args[0]);
						}
						else chart.Load(paksongchart);
						File.Delete(paksongmid);
						File.Delete(paksongchart);
						if (wl && log != null)
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
							log.WriteLine(songName);
						}
						//bool relfile = false;
						try
						{
							Directory.SetCurrentDirectory(Path.GetDirectoryName(args[0]));
						}
						catch
						{
							//relfile = true;
							Directory.SetCurrentDirectory(Path.GetPathRoot(args[0]));
							//Console.WriteLine(Path.GetPathRoot(args[0]));
						}
						#region ENCODE SONGS
						print(vstr[22], FSBcolor);
						//print("Encoding song.", FSBcolor);
						vl(vstr[23], FSBcolor);
						//vl("Getting audio files...", FSBcolor);
						string[] audiostreams = { "", "", "" };
						string audtmpstr = "", chf = Directory.GetCurrentDirectory() + '\\';
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
											audiostreams[0] = chf + chartinfo.Value;
										}
										catch
										{
											audiostreams[0] = chartinfo.Value;
										}
									}
									if (File.Exists(audiostreams[0]))
										vl(chartinfo.Key + " file found", FSBcolor);
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
											audiostreams[1] = chf + chartinfo.Value;
										}
										catch
										{
											audiostreams[1] = chartinfo.Value;
										}
									}
									if (File.Exists(audiostreams[1]))
										vl(chartinfo.Key + " file found", FSBcolor);
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
											audiostreams[2] = chf + chartinfo.Value;
										}
										catch
										{
											audiostreams[2] = chartinfo.Value;
										}
									}
									if (File.Exists(audiostreams[2]))
										vl(chartinfo.Key + " file found", FSBcolor);
									break;
							}
						}
						string[] audstnames = { "song", "guitar", "rhythm" },
							audextnames = { "ogg", "mp3", "wav", "opus" };
						// if Stream values above can't be found, check if audio name matching chart exists
						for (int i = 0; i < 4; i++)
						{
							if (!File.Exists(audiostreams[0]))
							{
								audtmpstr = chf + Path.GetFileNameWithoutExtension(args[0]) + '.' + audextnames[i];
								if (File.Exists(audtmpstr))
								{
									vl(vstr[24], FSBcolor); //vl("Found audio with the chart name", FSBcolor);
									audiostreams[0] = audtmpstr;
									break;
								}
							}
						}
						//if that fails, use FOF named files
						// iterate over stream names
						for (int i = 0; i < audstnames.Length; i++)
						{
							// if current stream doesn't exist
							if (!File.Exists(audiostreams[i]))
								// check every extension under the stream name until a file is found
								for (int j = 0; j < 4; j++)
								{
									audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
									if (File.Exists(audtmpstr))
									{
										vl(vstr[25] + audstnames[i], FSBcolor); //vl("Found FOF structure files / " + audstnames[i], FSBcolor);
										audiostreams[i] = audtmpstr;
										break;
									}
								}
						}
						// alternate names for guitar/rhythm if above don't exist
						audstnames = new string[] { "lead", "bass" };
						for (int i = 0; i < audstnames.Length; i++)
						{
							if (!File.Exists(audiostreams[i + 1]))
								for (int j = 0; j < 4; j++)
								{
									audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
									if (File.Exists(audtmpstr))
									{
										vl(vstr[25] + audstnames[i], FSBcolor); //vl("Found FOF structure files / " + audstnames[i], FSBcolor);
										audiostreams[i + 1] = audtmpstr;
										break;
									}
								}
						}
						// TODO: allow NJ3T routine even when song.ogg exists
						bool nj3t = false; // nj3ts.Count smh // "3 Count!"
						List<string> nj3ts = new List<string>();
						vl(vstr[26], FSBcolor); //vl("Checking if extra audio exists", FSBcolor);
						// numbered drum streams
						for (int j = 0; j < 4; j++)
						{
							for (int i = 1; i < 9; i++)
							{
								audtmpstr = chf + "drums_" + i + '.' + audextnames[j];
								if (File.Exists(audtmpstr))
								{
									vl(vstr[27] + i + ')', FSBcolor); //vl("Found isolated drums audio (" + i + ')', FSBcolor);
									nj3t = true;
									nj3ts.Add(audtmpstr);
								}
							}
						}
						// also maybe ignore drums.ogg if numbered files exist
						// numbered vocal streams
						for (int j = 0; j < 4; j++)
						{
							audtmpstr = chf + "vocals." + audextnames[j];
							if (File.Exists(audtmpstr))
							{
								vl(vstr[28], FSBcolor); //vl("Found isolated vocals audio", FSBcolor);
								nj3t = true;
								nj3ts.Add(audtmpstr);
								break;
							}
						}
						audstnames = new string[] { "drums", /*"vocals",*/ "keys", "song" };
						for (int i = 0; i < audstnames.Length; i++)
						{
							for (int j = 0; j < 4; j++)
							{
								audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
								if (File.Exists(audtmpstr))
								{
									vl(vstr[25] + audstnames[i], FSBcolor);
									if (i != 3 && audstnames[i] != "song")
									{
										nj3t = true;
									}
									nj3ts.Add(audtmpstr);
									break;
								}
							}
						}
						if (nj3ts.Count == 1) // okay
						{
							audiostreams[0] = nj3ts[0];
							nj3t = false;
						}
						// CH sucks
						if (!File.Exists(audiostreams[0]))
						{
							for (int i = 0; i < 4; i++)
							{
								audtmpstr = chf + "guitar" + '.' + audextnames[i];
								Console.WriteLine(audtmpstr);
								if (File.Exists(audtmpstr))
								{
									vl("Found cringe compatibility", FSBcolor);
									audiostreams[0] = audtmpstr;
									audiostreams[1] = mt + "blank.mp3";
									break;
								}
							}
						}
						vl(vstr[29], FSBcolor); //vl("Current selected audio streams are:", FSBcolor);
						foreach (string a in audiostreams)
							vl(a, FSBcolor);
						if (!File.Exists(audiostreams[0]) && !nj3t)
						{
							//vl("Failed to get main song file, asking user what the game should do", FSBcolor);
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
								audiolost = MessageBox.Show(vstr[30], "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
								//audiolost = MessageBox.Show("No song audio can be found.\nDo you want to search for it?", "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
								if (audiolost == DialogResult.Cancel)
								{
									exit();
									Environment.Exit(0);
								}
								if (audiolost == DialogResult.Yes)
								{
									searchaudioresult = searchaudio.ShowDialog();
									if (searchaudioresult == DialogResult.OK)
									{
										//vl("User responded with " + SubstringExtensions.EncloseWithQuoteMarks(searchaudio.FileName), FSBcolor);
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
									playsilent = MessageBox.Show(vstr[31], "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
									//playsilent = MessageBox.Show("Want to play without audio?\nThis is not compatible with practice mode.", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
									if (playsilent == DialogResult.Yes)
									{
										vl("Using blank music file", FSBcolor);
										audiostreams[0] = mt + "blank.mp3";
									}
								}
							}
							while (playsilent == DialogResult.No);
						}
						for (int i = 0; i < 3; i++)
							if (!File.Exists(audiostreams[i]))
							{
								audiostreams[i] = mt + "blank.mp3";
							}
						//im stupid
						//this cache stuff is a mess
						ulong charthash = WZK64.Create(
								File.ReadAllBytes(args[0])
						);
						if (File.Exists("boss.ini"))
						{
							charthash ^= WZK64.Create(File.ReadAllBytes("boss.ini"));
						}
						ulong audhash = 0;
						bool chartCache = false;
						bool audCache = false;
						if (caching)
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
							if (nj3t)
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
						Process[] fsbbuild2 = new Process[3]; // 3 async encoders
						Process fsbbuild3 = new Process(); // makefsb part
						const bool MTFSB = true; // enable asynchronous audio track encoding
												 //if (cacheEnabled)
						pbl = new short[3] { -1, -1, -1 };
						float[] al = new float[3] { -1, -1, -1 };
						killgame();
						string CMDpath = where("cmd.exe");
						if (CMDpath == "") // somehow someone got an error of a process starting
							CMDpath = "cmd"; // assuming its one of these building scripts
						try
						{
							if (Directory.Exists(mt + "fsbtmp"))
								Directory.Delete(mt + "fsbtmp", true);
						}
						catch (Exception e)
						{
							vl(vstr[32]);
							//print("Failed to delete the temp FSB folder!");
							vl(e);
						}
						TimeSpan audioConv_start = time, audioConv_end = time;
						int AB_param = 64;
						if (!audCache)
						{
							AB_param =
								(cfg("Audio", "AB", 128) >> 1/*thx helix*/);
							if (AB_param == 0) AB_param = 64; // i hate myself
							AB_param = Math.Max(AB_param, 48);
							bool VBR = false;
							VBR = (cfg("Audio", "VBR", 0) == 1);
							string VBR_param = VBR ? "V" : "B";
							audioConv_start = time;
							if (caching)
								print(vstr[136], cacheColor);
							if (nj3t)
							{
								print(vstr[33], FSBcolor);
								//print("Found more than three audio tracks, merging.", FSBcolor);
								addaud = cmd(CMDpath, (mt + "nj3t.bat").Quotes());
								addaud.StartInfo.EnvironmentVariables["AB"] = AB_param.ToString();
								addaud.StartInfo.EnvironmentVariables["BM"] = VBR_param;
								float maxl = 0;
								foreach (string a in nj3ts)
								{
									addaud.StartInfo.Arguments += " \"" + a + '"';
									maxl = Math.Max(maxl, alen(a));
								}
								al[0] = maxl;
								addaud.StartInfo.WorkingDirectory = mt;
								addaud.StartInfo.Arguments = "/c " + addaud.StartInfo.Arguments.Quotes();
								addaud.Start();
								if (vb || wl)
								{
									addaud.BeginErrorReadLine();
									addaud.BeginOutputReadLine();
								}
								vl("merge args: sox " + addaud.StartInfo.Arguments, FSBcolor);
								audiostreams[0] = mt + "fsbtmp\\fastgh3_song.mp3";
								//fsbbuild.StartInfo.FileName += '2';
								if (!MTFSB)
								{
									if (!addaud.HasExited)
										addaud.WaitForExit();
								}
							}
							vl(vstr[34], FSBcolor);
							//vl("Creating encoder process...", FSBcolor);
							if (!MTFSB)
							{
								fsbbuild = cmd(CMDpath, null);
								fsbbuild.StartInfo.WorkingDirectory = mt;
								v("S", FSBcolor); // lol
							}
							else
							{
								Directory.CreateDirectory(mt + "fsbtmp");
								File.Copy(mt + "blank.mp3", mt + "fsbtmp\\fastgh3_preview.mp3", true);
								string[] fsbnames = { "song", "guitar", "rhythm" };
								for (int i = 0; i < fsbbuild2.Length; i++)
								{
									if ((i != 0 && nj3t) || i > 0)
										al[i] = alen(audiostreams[i]);
									fsbbuild2[i] = cmd(CMDpath, "/c " + ((mt + "c128ks.bat").Quotes() + " " + audiostreams[i].Quotes() + " \"" + mt + "fsbtmp\\fastgh3_" + fsbnames[i] + ".mp3\"").Quotes());
									fsbbuild2[i].StartInfo.WorkingDirectory = mt;
									fsbbuild2[i].StartInfo.EnvironmentVariables["AB"] = AB_param.ToString();
									fsbbuild2[i].StartInfo.EnvironmentVariables["BM"] = VBR_param;
									vl("MP3 args: c128ks " + fsbbuild2[i].StartInfo.Arguments, FSBcolor);
								}
								fsbbuild3 = cmd(CMDpath, "/c " + ((mt + "fsbbuild.bat").Quotes()));
								fsbbuild3.StartInfo.WorkingDirectory = mt;
								v("As", FSBcolor);
							}
							v(vstr[35], FSBcolor);
							vl(vstr[36], FSBcolor);
							//v("ynchronous mode set\n", FSBcolor);
							//vl("Starting FSB building...", FSBcolor);
							if (!nj3t)
								audioConv_start = time;
							if (!MTFSB)
							{
								fsbbuild.StartInfo.EnvironmentVariables["AB"] = AB_param.ToString();
								fsbbuild.StartInfo.WorkingDirectory = mt;
								fsbbuild.StartInfo.EnvironmentVariables["BM"] = VBR_param;
								fsbbuild.StartInfo.Arguments = "/c " + ((mt + "fsbbuild.bat").Quotes() + ' ' +
								audiostreams[0].Quotes() + ' ' + audiostreams[1].Quotes() + ' ' + audiostreams[2].Quotes() + ' ' +
								(mt + "blank.mp3").Quotes() + ' ' + fsb.Quotes()).Quotes();
								vl("MP3 args: c128ks " + fsbbuild.StartInfo.Arguments, FSBcolor);
								fsbbuild.Start();
								if (vb || wl)
								{
									fsbbuild.BeginErrorReadLine();
									fsbbuild.BeginOutputReadLine();
								}
							}
							else
							{
								for (int i = 0; i < fsbbuild2.Length; i++)
								{
									if (!nj3t || (nj3t && i != 0)) // weird
									{
										fsbbuild2[i].Start();
										if (vb || wl)
										{
											fsbbuild2[i].BeginErrorReadLine();
											fsbbuild2[i].BeginOutputReadLine();
										}
									}
								}
								fsbbuild3.StartInfo.Arguments = "/c " + ((mt + "fsbbuildnoenc.bat").Quotes() + ' ' +
									fsb.Quotes()).Quotes();
							}
						}
						else
						{
							print(vstr[37], FSBcolor);
							//print("Cached audio found.", FSBcolor);
							try
							{
								File.Copy(
									cf + audhash.ToString("X16"),
									fsb, true);
							}
							catch (IOException e)
							{
								print(vstr[38]);
								//print("Failed to copy cached FSB. WHY?!!!");
								print(e);
								//print("Attempting to kill game if \"it is used by another process\" somehow.");
								//disallowGameStartup();
								print(vstr[39]);
								//print("Deleting the currently loaded FSB in case.");
								File.Delete(fsb);
								File.Copy(
									cf + audhash.ToString("X16"),
									fsb, true);
							}
						}
						#endregion
						killgame();
						if (!chartCache)
						{
							// TODO: stringpointers for null arrays
							// *nullNoteArray
							// = {0,0,0}
							if (caching)
								print(vstr[40], cacheColor);
								//print("Chart is not cached.", cacheColor);
							//print("Generating QB template.", chartConvColor);
							//vl("Creating new QB files...", chartConvColor);
							killgame();
							byte[] __ = new byte[0xB0],
								pn = (byte[])Resources.ResourceManager.GetObject("paknew"),
								qn = (byte[])Resources.ResourceManager.GetObject("qbnew");
							Array.Copy(pn, 0, __, 0, pn.Length);
							Array.Copy(qn, 0, __, 0x80, qn.Length);
							File.WriteAllBytes(songpak, __);
							//vl("Creating pak editor...", chartConvColor);
							print(vstr[41], chartConvColor);
							//print("Opening song pak.", chartConvColor);
							PakFormat PF = new PakFormat(songpak, "", "", PakFormatType.PC);
							PakEditor build;
							try
							{
								build = new PakEditor(PF, false);
							}
							catch (Exception e)
							{
								vl("wtf:");
								vl(e);
								try
								{
									vl(vstr[42], ConsoleColor.Red);
									build = new PakEditor(PF, false);
								}
								catch
								{
									vl(vstr[43], ConsoleColor.Red);
									File.Move(pakf + "dbg.pak.xen", pakf + "dbg.pak.xen.bak");
									build = new PakEditor(PF, false);
									// if even after this it fails, look for god
								}
							}
							print(vstr[44], chartConvColor);
							//print("Compiling chart.", chartConvColor);
							//vl("Creating QbFile using PakFormat", chartConvColor);
							Stream newqb = new MemoryStream(qn);
							QbFile mid = new QbFile(newqb, PF);
							#region BUILD ENTIRE QB FILE
							#region GUITAR VALUES

							vl(vstr[45], chartConvColor);
							//vl("Creating note arrays...", chartConvColor);
							string[] diffs = { "easy", "medium", "hard", "expert" };
							string[] insts = { "", "_rhythm", "_guitarcoop", "_rhythmcoop" };
							// song.inst[i].diff[d]
							QbItemBase[][] notes_arr = new QbItemBase[insts.Length][];//[diffs.Length];
							QbItemInteger[][] notes = new QbItemInteger[insts.Length][];//[diffs.Length];
							for (int i = 0; i < notes_arr.Length; i++)
							{
								notes_arr[i] = new QbItemBase[diffs.Length];
								notes[i] = new QbItemInteger[diffs.Length];
								for (int d = 0; d < notes_arr[i].Length; d++)
								{
									notes[i][d] = new QbItemInteger(mid);
									notes_arr[i][d] = new QbItemArray(mid);
									notes_arr[i][d].Create(QbItemType.SectionArray);
									notes_arr[i][d].ItemQbKey =
										QbKey.Create("fastgh3_song" + insts[i] + '_' + diffs[d]);
								}
							}
							OffsetTransformer OT = new OffsetTransformer(chart);
							string[] td = { "Easy", "Medium", "Hard", "Expert" };
							string[] ti = { "Single", "DoubleBass", "DoubleGuitar", "DoubleBass" };
							// doublebass would exist both on rhythm and rhythmcoop? lol?
							// depend on enhanced bass for singleplayer rhythm kek

							bool atleast1track = false;

							int delay = 0;
							try
							{
								if (chart.Song["Offset"] != null) // ugh
									delay = Convert.ToInt32(float.Parse(chart.Song["Offset"].Value) * 1000);
							}
							catch
							{
								// WHY IS THIS STILL NOT WORKING
								// https://github.com/donnaken15/FastGH3/issues/7#issuecomment-1595513766
							}
							QbcNoteTrack tmp;

							QbItemArray scrs = new QbItemArray(mid);
							scrs.Create(QbItemType.SectionArray);
							QbItemStructArray scr_arr = new QbItemStructArray(mid);
							scrs.ItemQbKey = QbKey.Create(0x195F3B95); // fastgh3_scripts
							scr_arr.Create(QbItemType.ArrayStruct);
							List<QbItemStruct> scripts = new List<QbItemStruct>();

							int dd = 0;
							int ii = 0;
							// TODO: use stringpointer for lower difficulties to redirect to
							// least difficult chart if they aren't authored
							//
							// so like if an easy chart doesn't exist but hard
							// and expert charts do, easy redirects to the hard chart
							// and so space is saved from having dupe note tracks
							//
							// maybe also for arrays that don't have anything
							foreach (string i in ti)
							{
								dd = 0;
								foreach (string d in td)
								{
									vl("Checking " + d + i, chartConvColor);
									if (chart.NoteTracks[d + i] != null)
									{
										atleast1track = true;
										vl("Parsing " + d + i, chartConvColor);
										try
										{
											int nc;
											tmp = new QbcNoteTrack(chart.NoteTracks[d + i], OT);
											if (tmp.Count > 0)
												nc = tmp.Count;
											else nc = 1;
											notes[ii][dd].Create(QbItemType.ArrayInteger);
											notes[ii][dd].Values = new int[nc * 3];
											// is ItemCount what i need instead of Create(type, arraysize)
											// so i implemented that parameter for nothing?
											for (int j = 0; j < tmp.Count; j++)
											{
												notes[ii][dd].Values[(j * 3)] = tmp[j].Offset + delay;
												notes[ii][dd].Values[(j * 3) + 1] = tmp[j].Length;
												notes[ii][dd].Values[(j * 3) + 2] = tmp[j].FretMask;
											}
										}
										catch (Exception ex)
										{
											vl(vstr[46] + d + i, ConsoleColor.Yellow);
											//vl("Error in parsing notes for " + d + i, ConsoleColor.Yellow);
											vl(ex, ConsoleColor.Yellow);
											notes[ii][dd].Create(QbItemType.ArrayInteger);
											notes[ii][dd].Values = new int[3];
										}
										try
										{
											foreach (Note e in chart.NoteTracks[d + i])
											{
												if (e.Type != NoteType.Event ||
													e.EventName == "")
													continue;
												QbKey eventKey = QbKey.Create(e.EventName);
												//if (eventKey == QbKey.Create(0x6E94F918) ||/* <--\ */
												//eventKey == QbKey.Create(0xF646D9A4) ||/*a note to self for forcing*/
												//e.EventName == "")
												// ALSO * IN A QBKEY LOL
												//continue;
												if (eventKey != QbKey.Create(0xF0FFFBEE) && // solo
													eventKey != QbKey.Create(0x868BC002) && // soloend
													eventKey != QbKey.Create(0x2DE8C60E) && // printf
													eventKey != QbKey.Create(0xBE304E86) && // printf
													eventKey != QbKey.Create(0xBE304E86)) // printstruct
													continue;
												vl("Found event: " + e.EventName, chartConvColor);
												QbItemStruct newScript = new QbItemStruct(mid);
												newScript.Create(QbItemType.StructHeader);
												QbItemInteger t = new QbItemInteger(mid);
												t.Create(QbItemType.StructItemInteger);
												QbItemQbKey s = new QbItemQbKey(mid);
												s.Create(QbItemType.StructItemQbKey);
												t.ItemQbKey = QbKey.Create(0x906B67BA);
												t.Values[0] = (int)Math.Floor(OT.GetTime(e.Offset) * 1000) + delay;
												s.ItemQbKey = QbKey.Create(0xA6D2D890);
												s.Values[0] = QbKey.Create(e.EventName);
												QbItemStruct p = new QbItemStruct(mid);
												p.Create(QbItemType.StructItemStruct);
												p.ItemQbKey = QbKey.Create(0x7031F10C);
												// i'm getting desperate at shortening these names for tipping over the 512 byte difference
												// and for the fact that WHY DO THESE THINGS NEED NAMES IN THE EXE WHEN IT SHOULD BE OPTIMIZED

												// wish there was a simpler way to make these objects
												QbItemQbKey pp = new QbItemQbKey(mid);
												pp.Create(QbItemType.StructItemQbKey);
												pp.ItemQbKey = QbKey.Create(0xB6F08F39);
												pp.Values[0] = QbKey.Create(new string[] { "guitar", "rhythm", "guitarcoop", "rhythmcoop" }[ii]);
												QbItemQbKey di = new QbItemQbKey(mid);
												di.Create(QbItemType.StructItemQbKey);
												di.ItemQbKey = QbKey.Create(0xBA8FB854);
												di.Values[0] = QbKey.Create(diffs[dd]);
												p.AddItem(pp);
												p.AddItem(di);
												/*
												example struct

												event = {
													name = solo,
													time = 4000,
													params = {
														part = guitar,
														diff = expert
													}
												}
												*/

												newScript.AddItem(t);
												newScript.AddItem(s);
												newScript.AddItem(p);
												scripts.Add(newScript);
											}
										}
										catch (Exception ex)
										{
											vl(vstr[47] + d + i, ConsoleColor.Yellow);
											//vl("Error in parsing solos for " + d + i, ConsoleColor.Yellow);
											vl(ex, ConsoleColor.Yellow);
										}
									}
									else
									{
										notes[ii][dd].Create(QbItemType.ArrayInteger);
										notes[ii][dd].Values = new int[3];
									}
									dd++;
								}
								ii++;
							}
							if (!atleast1track)
							{
								if (!MTFSB)
								{
									if (!fsbbuild.HasExited)
										fsbbuild.Kill();
								}
								else
								{
									for (int i = 0; i < fsbbuild2.Length; i++)
										try
										{
											if (!fsbbuild2[i].HasExited)
												fsbbuild2[i].Kill();
										}
										catch { }
									// doesn't work because killing this only kills the parent EXE and doesn't stop the script >:(
									killEncoders();
									exit();
									MessageBox.Show("No guitar/rhythm tracks can be found. Exiting...", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
									Environment.Exit(1);
								}
							}
							////vl("Adding note arrays to QB.", chartConvColor);
							// use this for organized QBs ^
							// as pleasing[definition needed] as the below looks to do
							// without having multiple loops, idk man
							for (int i = 0; i < notes_arr.Length; i++)
							{
								for (int d = 0; d < notes_arr[i].Length; d++)
								{
									mid.AddItem(notes_arr[i][d]);
									notes_arr[i][d].AddItem(notes[i][d]);
								}
							}
							vl(vstr[48], chartConvColor);
							//vl("Creating and adding starpower arrays...", chartConvColor);
							QbItemBase[][] spp_arr = new QbItemBase[insts.Length][];//[diffs.Length];
							QbItemBase[][] spp = new QbItemBase[insts.Length][];//[diffs.Length];
							QbItemInteger sT;
							for (int i = 0; i < spp.Length; i++)
							{
								spp_arr[i] = new QbItemBase[diffs.Length];
								spp[i] = new QbItemArray[diffs.Length];
								for (int d = 0; d < spp[i].Length; d++)
								{
									spp_arr[i][d] = new QbItemArray(mid);
									spp_arr[i][d].Create(QbItemType.SectionArray);
									spp_arr[i][d].ItemQbKey =
										QbKey.Create("fastgh3" + insts[i] + '_' + diffs[d] + "_star");
									spp[i][d] = new QbItemArray(mid);
									spp[i][d].Create(QbItemType.ArrayArray);
								}
							}
							for (int i = 0; i < spp_arr.Length; i++)
							{
								for (int d = 0; d < spp_arr[i].Length; d++)
								{
									mid.AddItem(spp_arr[i][d]);
									spp_arr[i][d].AddItem(spp[i][d]);
								}
							}
							ii = 0;
							foreach (string i in ti)
							{
								dd = 0;
								foreach (string d in td)
								{
									bool b = false;
									if (chart.NoteTracks[d + i] != null)
									{
										Tuple<List<Note>, List<int>> special =
											S2P(chart.NoteTracks[d + i], SF.SP);
										List<Note> sT2 = special.Item1;
										List<int> sNC = special.Item2;
										int sNC2 = 0;
										if (sT2.Count != 0)
											foreach (Note a in sT2)
											{
												try
												{
													sT = new QbItemInteger(mid);
													sT.Create(QbItemType.ArrayInteger);
													sT.Values = new int[] {
														(int)Math.Floor(OT.GetTime(a.Offset) * 1000) + delay,
														0,
														sNC[sNC2]
													};
													sT.Values[1] = (int)Math.Floor((OT.GetTime(a.Offset + a.Length) * 1000)) - sT.Values[0];
													spp[ii][dd].AddItem(sT);
													sNC2++;
												}
												catch /*(Exception e)*/
												{
													print(vstr[129], ConsoleColor.Yellow);
													//Console.WriteLine(e);
												}
											}
										else
											b = true;
									}
									else
										b = true;
									if (b)
									{
										sT = new QbItemInteger(mid);
										sT.Create(QbItemType.ArrayInteger);
										sT.Values = new int[3];
										spp[ii][dd].AddItem(sT);
									}
									dd++;
								}
								ii++;
							}


							#region END TIME
							vl(vstr[49], chartConvColor);
							//vl("Getting end time...", chartConvColor);
							int et = 0;
							//           blehe  v
							for (int i = 0; i < 4; i++)
							{
								for (int d = 0; d < 4; d++)
								{
									try
									{
										et = Math.Max(et,
											notes[i][d].Values[notes[i][d].Values.Length - 3] +
											notes[i][d].Values[notes[i][d].Values.Length - 2]
											);
									}
									catch
									{
										vl(vstr[50] + i+"]["+d+"]");
										//vl("Unable to get the end time for a note track ["+i+"]["+d+"]");
									}
									vl(vstr[51] + et, chartConvColor);
									//vl("Calculating: end time so far: " + et, chartConvColor);
								}
							}
							vl(vstr[52] + et, chartConvColor);
							//vl("End time is " + et, chartConvColor);
							#endregion


							#region BOSS PROPS
							vl(vstr[53], bossColor);
							//vl("Reading boss props...");

							bool isBoss = false,
								gotBossScr = false,
								boss_useSP = true,
								boss_defProps = true;

							string bini = "boss.ini";
							isBoss = ini("boss", "enable", 0, bini) == 1; // not letting you off easy with a blank ini lol
							boss_defProps = ini("boss", "usedefault", 0, bini) == 1;
							boss_useSP = ini("boss", "usestarphrases", 1, bini) == 1;
							int boss_death_time = -1;

							QbKey[] defaultPowers = new QbKey[] {
								QbKey.Create(0x7EB6596F), // Lightning
								QbKey.Create(0xB880390E), // DifficultyUp
								QbKey.Create(0xAF753CE1), // DoubleNotes
								QbKey.Create(0x24EDE700), // LeftyNotes
								QbKey.Create(0x7429EADC), // BrokenString
								QbKey.Create(0x69FA8321), // WhammyAttack
								QbKey.Create(0x16FB37BA), // PowerUpSteal
								//QbKey.Create(0x3604998C), // DeathLick
							};
							QbKey[] existingPowers = new QbKey[] {
								QbKey.Create(0x7EB6596F),
								QbKey.Create(0xB880390E),
								QbKey.Create(0xAF753CE1),
								QbKey.Create(0x24EDE700),
								QbKey.Create(0x7429EADC),
								QbKey.Create(0x69FA8321),
								QbKey.Create(0x16FB37BA),
								QbKey.Create(0x3604998C),
							};

							QbKey key_boss_props = QbKey.Create("Boss_Props");
							QbItemQbKey QB_bossitems = new QbItemQbKey(mid);
							string boss_name = "Player 2";
							QbItemStruct fastgh3_extra = new QbItemStruct(mid);
							fastgh3_extra.Create(QbItemType.SectionStruct);
							fastgh3_extra.ItemQbKey = QbKey.Create("fastgh3_extra");
							QbItemQbKey QB_bossboss = new QbItemQbKey(mid);
							QbItemStruct QB_bossprops = new QbItemStruct(mid);
							QbItemInteger QB_bosstime = new QbItemInteger(mid);
							QbItemString QB_bossname = new QbItemString(mid);

							if (isBoss)
							{
								vl(vstr[54], bossColor);
								//vl("Song detected as boss", bossColor);
								boss_name = ini("boss", "name", boss_name, bini);
								vl("Boss name: " + boss_name, bossColor);
								if (ini("boss", "deathtime", -1, bini) != -1)
								{
									boss_death_time = Convert.ToInt32(ini("boss", "deathtime", -1, bini));
								}
								//vl("Default props: " + boss_defProps, bossColor);
								//vl("Use star phrases: " + boss_useSP, bossColor);
							}

							QbItemQbKey boss_items = new QbItemQbKey(mid);
							QbItemArray boss_items_arrays = new QbItemArray(mid);

							QbItemStruct QB_bossRKgain_s = new QbItemStruct(mid);
							QbItemStruct QB_bossRKloss_s = new QbItemStruct(mid);
							QbItemStruct QB_bossATKmiss_s = new QbItemStruct(mid);
							QbItemStruct QB_bossWrepair_s = new QbItemStruct(mid);
							QbItemStruct QB_bossSrepair_s = new QbItemStruct(mid);
							QbItemStruct QB_bossSTRmiss_s = new QbItemStruct(mid);

							foreach (EventsSectionEntry e in chart.Events)
							{
								if (e == null) { vl("Got null event!!!!!!!!!"); continue; } // wtf
								if (e.TextValue == null) { vl("Got null event text!!!!!!!!!"); continue; } // wtf
								QbKey eventKey = QbKey.Create(e.TextValue);
								if (e.TextValue.ToLower().StartsWith("section "))
									continue;
								if (eventKey != QbKey.Create(0xFF03CC4E) && // end
									eventKey != QbKey.Create(0x2DE8C60E) && // printf
									eventKey != QbKey.Create(0xBE304E86) && // printstruct
									eventKey != QbKey.Create(0xF0CF92C0)) // boss_battle_begin_deathlick
									continue;
								vl("Found event: " + e.TextValue, chartConvColor);
								QbItemStruct nS = new QbItemStruct(mid);
								nS.Create(QbItemType.StructHeader);
								QbItemInteger t = new QbItemInteger(mid);
								t.Create(QbItemType.StructItemInteger);
								QbItemQbKey s = new QbItemQbKey(mid);
								s.Create(QbItemType.StructItemQbKey);
								t.ItemQbKey = QbKey.Create(0x906B67BA); // time
								t.Values[0] = (int)Math.Floor(OT.GetTime(e.Offset) * 1000) + delay;
								s.ItemQbKey = QbKey.Create(0xA6D2D890); // scr
								s.Values[0] = QbKey.Create(e.TextValue);
								if (s.Values[0] == QbKey.Create(0xF0CF92C0))
								{
									if (!isBoss)
									{
										vl(vstr[55]);
										//vl("ignoring death lick script");
										continue; // if not boss, dont add this
									}
									else
									{
										gotBossScr = true;
										if (boss_death_time < 1)
											boss_death_time = t.Values[0];
									}
								}
								QbItemStruct p = new QbItemStruct(mid);
								p.Create(QbItemType.StructItemStruct);
								p.ItemQbKey = QbKey.Create(0x7031F10C); // params
								nS.AddItem(t);
								nS.AddItem(s);
								nS.AddItem(p);
								scripts.Add(nS);
							}
							if (isBoss)
							{
								// auto set death time if not specified at all
								if (boss_death_time < 1)
								{
									// fractional time, probably not good for extra long songs
									//boss_death_time = endtime * 0.92;

									// 13 seconds before the song ends
									// hahahahaha
									boss_death_time = et - 13000;
								}

								// if event is not put manually in chart
								if (!gotBossScr)
								{
									QbItemStruct d = new QbItemStruct(mid);
									d.Create(QbItemType.StructHeader);
									QbItemInteger t = new QbItemInteger(mid);
									t.Create(QbItemType.StructItemInteger);
									QbItemQbKey s = new QbItemQbKey(mid);
									s.Create(QbItemType.StructItemQbKey);
									t.ItemQbKey = QbKey.Create(0x906B67BA); // time
									t.Values[0] = boss_death_time;
									s.ItemQbKey = QbKey.Create(0xA6D2D890); // scr
									s.Values[0] = QbKey.Create(0xF0CF92C0); // deth
									QbItemStruct p = new QbItemStruct(mid);
									p.Create(QbItemType.StructItemStruct);
									p.ItemQbKey = QbKey.Create(0x7031F10C); // params
									d.AddItem(t);
									d.AddItem(s);
									d.AddItem(p);
									scripts.Add(d);
								}

								float[] boss_rockGain = {
									0.8f,
									0.7f,
									0.55f,
									0.4f
								};
								QbItemFloat[] QB_bossRKgain;
								float[] boss_rockLoss = {
									5f,
									2.75f,
									2.5f,
									2f
								};
								QbItemFloat[] QB_bossRKloss;
								float[] boss_atkmiss = {
									45f,
									42f,
									35f,
									30f
								};
								QbItemFloat[] QB_bossATKmiss;
								int[] boss_Wrepair = {
									1150,
									900,
									500,
									350
								};
								QbItemInteger[] QB_bossWrepair;
								int[] boss_Srepair = {
									1150,
									850,
									650,
									400
								};
								QbItemInteger[] QB_bossSrepair;
								float[] boss_strmiss = {
									24f,
									17f,
									14f,
									11.5f
								};
								QbItemFloat[] QB_bossSTRmiss;

								QB_bosstime.Create(QbItemType.SectionInteger);
								QB_bosstime.ItemQbKey = QbKey.Create(0x7DDBFF91);
								QB_bosstime.Values[0] = boss_death_time;

								QB_bossname.Create(QbItemType.SectionString);
								QB_bossname.ItemQbKey = QbKey.Create(0xF7BABCBD);
								QB_bossname.Strings[0] = boss_name;

								QB_bossboss.Create(QbItemType.StructItemQbKey);
								QB_bossboss.ItemQbKey = QbKey.Create(0xC10199C5);
								QB_bossboss.Values[0] = key_boss_props;

								if (!boss_defProps)
								{

									string[] selectedPowers = ini("boss", "items", vstr[131], bini).Split(',');
									// HOW DO I USE THIS https://stackoverflow.com/questions/4916838/is-there-a-string-type-with-8-bit-chars

									List<QbKey> allowedPowers = new List<QbKey>();
									bool pDE;
									for (int i = 0; i < selectedPowers.Length; i++)
									{
										pDE = true;
										foreach (QbKey j in defaultPowers)
										{
											if (QbKey.Create(selectedPowers[i]) == j)
											{
												pDE = false;
												break;
											}
										}
										if (pDE)
										{
											print(vstr[56] + selectedPowers[i] + "!! Not using.", ConsoleColor.Red);
											//print("Got non-existent powerup in boss.ini: " +
											continue;
										}
										allowedPowers.Add(QbKey.Create(selectedPowers[i]));
									}

									boss_items.Create(QbItemType.ArrayQbKey);
									boss_items.Values = allowedPowers.ToArray();
									boss_items_arrays.Create(QbItemType.StructItemArray);
									boss_items_arrays.ItemQbKey = QbKey.Create("PowerUps");

									QB_bossprops.Create(QbItemType.SectionStruct);
									QB_bossprops.ItemQbKey = key_boss_props;

									QB_bossRKgain = new QbItemFloat[4];
									QB_bossRKloss = new QbItemFloat[4];
									QB_bossATKmiss = new QbItemFloat[4];
									QB_bossWrepair = new QbItemInteger[4];
									QB_bossSrepair = new QbItemInteger[4];
									QB_bossSTRmiss = new QbItemFloat[4];

									QB_bossRKgain_s.Create(QbItemType.StructItemStruct);
									QB_bossRKgain_s.ItemQbKey = QbKey.Create("GainPerNote");
									QB_bossRKloss_s.Create(QbItemType.StructItemStruct);
									QB_bossRKloss_s.ItemQbKey = QbKey.Create("LossPerNote");
									QB_bossATKmiss_s.Create(QbItemType.StructItemStruct);
									QB_bossATKmiss_s.ItemQbKey = QbKey.Create("PowerUpMissedNote");
									QB_bossWrepair_s.Create(QbItemType.StructItemStruct);
									QB_bossWrepair_s.ItemQbKey = QbKey.Create("WhammySpeed");
									QB_bossSrepair_s.Create(QbItemType.StructItemStruct);
									QB_bossSrepair_s.ItemQbKey = QbKey.Create("BrokenStringSpeed");
									QB_bossSTRmiss_s.Create(QbItemType.StructItemStruct);
									QB_bossSTRmiss_s.ItemQbKey = QbKey.Create("BrokenStringMissedNote");
									int ddd = 0;
									foreach (string d in diffs)
									{
										if (ini("rockgain", d, "", bini) != "")
											boss_rockGain[ddd] = Convert.ToSingle(
												ini("rockgain", d, "", bini));
										if (ini("rockloss", d, "", bini) != "")
											boss_rockLoss[ddd] = Convert.ToSingle(
												ini("rockloss", d, "", bini));
										if (ini("attackmiss", d, "", bini) != "")
											boss_atkmiss[ddd] = Convert.ToSingle(
												ini("attackmiss", d, "", bini));
										if (ini("whammyrepair", d, "", bini) != "")
											boss_Wrepair[ddd] = Convert.ToInt32(
												ini("whammyrepair", d, "", bini));
										if (ini("stringrepair", d, "", bini) != "")
											boss_Srepair[ddd] = Convert.ToInt32(
												ini("stringrepair", d, "", bini));
										if (ini("stringmiss", d, "", bini) != "")
											boss_strmiss[ddd] = Convert.ToSingle(
												ini("stringmiss", d, "", bini));

										QbKey diffCRC = QbKey.Create(d);

										QB_bossRKgain[ddd] = new QbItemFloat(mid);
										QB_bossRKgain[ddd].Create(QbItemType.StructItemFloat);
										QB_bossRKgain[ddd].ItemQbKey = diffCRC;
										QB_bossRKgain[ddd].Values[0] = boss_rockGain[ddd];
										QB_bossRKgain_s.AddItem(QB_bossRKgain[ddd]);

										QB_bossRKloss[ddd] = new QbItemFloat(mid);
										QB_bossRKloss[ddd].Create(QbItemType.StructItemFloat);
										QB_bossRKloss[ddd].ItemQbKey = diffCRC;
										QB_bossRKloss[ddd].Values[0] = boss_rockLoss[ddd];
										QB_bossRKloss_s.AddItem(QB_bossRKloss[ddd]);

										QB_bossATKmiss[ddd] = new QbItemFloat(mid);
										QB_bossATKmiss[ddd].Create(QbItemType.StructItemFloat);
										QB_bossATKmiss[ddd].ItemQbKey = diffCRC;
										QB_bossATKmiss[ddd].Values[0] = boss_atkmiss[ddd];
										QB_bossATKmiss_s.AddItem(QB_bossATKmiss[ddd]);

										QB_bossWrepair[ddd] = new QbItemInteger(mid);
										QB_bossWrepair[ddd].Create(QbItemType.StructItemInteger);
										QB_bossWrepair[ddd].ItemQbKey = diffCRC;
										QB_bossWrepair[ddd].Values[0] = boss_Wrepair[ddd];
										QB_bossWrepair_s.AddItem(QB_bossWrepair[ddd]);

										QB_bossSrepair[ddd] = new QbItemInteger(mid);
										QB_bossSrepair[ddd].Create(QbItemType.StructItemInteger);
										QB_bossSrepair[ddd].ItemQbKey = diffCRC;
										QB_bossSrepair[ddd].Values[0] = boss_Srepair[ddd];
										QB_bossSrepair_s.AddItem(QB_bossSrepair[ddd]);

										QB_bossSTRmiss[ddd] = new QbItemFloat(mid);
										QB_bossSTRmiss[ddd].Create(QbItemType.StructItemFloat);
										QB_bossSTRmiss[ddd].ItemQbKey = diffCRC;
										QB_bossSTRmiss[ddd].Values[0] = boss_strmiss[ddd];
										QB_bossSTRmiss_s.AddItem(QB_bossSTRmiss[ddd]);

										/*verboseline(d + "; rock gain: " + boss_rockGain[ddd], bossColor);
										verboseline(d + "; rock loss: " + boss_rockLoss[ddd], bossColor);
										verboseline(d + "; attakmiss: " + boss_atkmiss[ddd], bossColor);
										verboseline(d + "; wh repair: " + boss_Wrepair[ddd], bossColor);
										verboseline(d + "; strrepair: " + boss_Srepair[ddd], bossColor);
										verboseline(d + "; str  miss: " + boss_strmiss[ddd], bossColor);*/
										ddd++;
									}
								}
							}
							#endregion

							vl(vstr[57], chartConvColor);
							//vl("Creating powerup arrays...", chartConvColor);
							QbItemBase[][] bp = new QbItemBase[insts.Length][];//[diffs.Length];
							QbItemBase[][] bp_arr = new QbItemBase[insts.Length][];//[diffs.Length];
							for (int i = 0; i < bp_arr.Length; i++)
							{
								bp[i] = new QbItemBase[diffs.Length];
								bp_arr[i] = new QbItemArray[diffs.Length];
								for (int d = 0; d < bp_arr[i].Length; d++)
								{
									bp[i][d] = new QbItemArray(mid);
									bp[i][d].Create(QbItemType.SectionArray);
									bp[i][d].ItemQbKey =
										QbKey.Create("fastgh3" + insts[i] + '_' + diffs[d] + "_starbattlemode");
									bp_arr[i][d] = new QbItemArray(mid);
									bp_arr[i][d].Create(QbItemType.ArrayArray);
								}
							}
							for (int i = 0; i < bp.Length; i++)
							{
								for (int d = 0; d < bp[i].Length; d++)
								{
									mid.AddItem(bp[i][d]);
									bp[i][d].AddItem(bp_arr[i][d]);
								}
							}
							ii = 0;
							foreach (string i in ti)
							{
								dd = 0;
								foreach (string d in td)
								{
									bool b = false;
									if (chart.NoteTracks[d + i] != null)
									{
										SF useSP = SF.Pow;
										//verboseline(d + i);
										if (boss_useSP)
											useSP = SF.SP;
										Tuple<List<Note>, List<int>> special =
											S2P(chart.NoteTracks[d + i], useSP);
										List<Note> sT2 = special.Item1;
										int sNC2 = 0;
										if (sT2.Count != 0)
											foreach (Note a in sT2)
											{
												try
												{
													sT = new QbItemInteger(mid);
													sT.Create(QbItemType.ArrayInteger);
													sT.Values = new int[] {
														(int)Math.Floor(OT.GetTime(a.Offset) * 1000) + delay,
														0,
														special.Item2[sNC2]
													};
													sT.Values[1] = (int)Math.Floor((OT.GetTime(a.Offset + a.Length) * 1000)) - sT.Values[0];
													bp_arr[ii][dd].AddItem(sT);
													sNC2++;
												}
												catch /*(Exception e)*/
												{
													print(vstr[129], ConsoleColor.Yellow);
													//Console.WriteLine(e);
												}
											}
										else
											b = true;
									}
									else
										b = true;
									if (b)
									{
										sT = new QbItemInteger(mid);
										sT.Create(QbItemType.ArrayInteger);
										sT.Values = new int[3];
										bp_arr[ii][dd].AddItem(sT);
									}
									dd++;
								}
								ii++;
							}
							#endregion

							vl(vstr[58], chartConvColor);
							//vl("Sorting scripts by time.", chartConvColor);
							scripts.Sort(delegate (QbItemStruct c1, QbItemStruct c2) {
								//     autismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautism
								return (c1.FindItem(QbKey.Create(0x906B67BA), false) as QbItemInteger).Values[0].CompareTo((c2.FindItem(QbKey.Create(0x906B67BA), false) as QbItemInteger).Values[0]);
							});

							#region FACE-OFF/BATTLE VALUES
							vl(vstr[59], chartConvColor);
							//vl("Creating face-off sections...", chartConvColor);
							QbItemBase fop1 = new QbItemArray(mid);
							QbItemBase fop2 = new QbItemArray(mid);
							QbItemBase fop1a = new QbItemArray(mid);
							QbItemBase fop2a = new QbItemArray(mid);
							//QbItemBase array_faceoff_p1_array_array = new QbItemArray(songdata);
							//QbItemBase array_faceoff_p2_array_array = new QbItemArray(songdata);
							fop1.Create(QbItemType.SectionArray);
							fop2.Create(QbItemType.SectionArray);
							fop1.ItemQbKey = QbKey.Create(0xD3885E76);
							fop2.ItemQbKey = QbKey.Create(0x4A810FCC);
							fop1a.Create(QbItemType.ArrayArray);
							fop2a.Create(QbItemType.ArrayArray);
							bool[] gotfo = new bool[2];
							// game only allows two face-off tracks for all difficulties
							// so, use expert track
							// TODO: if not in that track, use lower diff
							NoteTrack font = null; // lol
							for (int j = 0; j < 4; j++)
								for (int i = 3; i >= 0; i--)
								{
									font = chart.NoteTracks[td[i] + ti[j]]; // ugh
									if (font != null)
										break;
								}
							if (font != null)
								foreach (Note a in font)
								{
									if (a.Type == NoteType.Special &&
										(a.SpecialFlag == 0) || (a.SpecialFlag == 1))
									{
										gotfo[a.SpecialFlag] = true;
										QbItemInteger faceoff_bit = new QbItemInteger(mid);
										faceoff_bit.Create(QbItemType.ArrayInteger);
										faceoff_bit.Values = new int[] {
											(int)Math.Floor(OT.GetTime(a.Offset) * 1000),
											(int)Math.Floor(OT.GetTime(a.OffsetEnd - a.Offset) * 1000)
										};
										if (a.SpecialFlag == 0)
											fop1a.AddItem(faceoff_bit);
										else
											fop2a.AddItem(faceoff_bit);
									}
								}
							// if there isn't, put only one marker
							// so they're played like pro faceoff
							{
								QbItemInteger nullfo = new QbItemInteger(mid);
								nullfo.Create(QbItemType.ArrayInteger);
								nullfo.Values = new int[] { 0, int.MaxValue };
								if (!gotfo[0])
								{
									fop1a.AddItem(nullfo);
								}
								// use stringpointer when here?
								// got pointer error for using
								// same copy of item later
								// cringe scripting system
								nullfo = new QbItemInteger(mid);
								nullfo.Create(QbItemType.ArrayInteger);
								nullfo.Values = new int[] { 0, int.MaxValue };
								if (!gotfo[1])
								{
									fop2a.AddItem(nullfo);
								}
							}
							mid.AddItem(fop1);
							mid.AddItem(fop2);
							fop1.AddItem(fop1a);
							fop2.AddItem(fop2a);

							// unused
							QbItemBase abp1 = new QbItemArray(mid);
							QbItemBase abp2 = new QbItemArray(mid);
							abp1.Create(QbItemType.SectionArray);
							abp2.Create(QbItemType.SectionArray);
							QbItemFloats abp1a = new QbItemFloats(mid);
							QbItemFloats abp2a = new QbItemFloats(mid);
							abp1.ItemQbKey = QbKey.Create(0xD2854CE4);
							abp2.ItemQbKey = QbKey.Create(0x4B8C1D5E);
							abp1a.Create(QbItemType.Floats);
							abp2a.Create(QbItemType.Floats);
							mid.AddItem(abp1);
							mid.AddItem(abp2);
							abp1.AddItem(abp1a);
							abp2.AddItem(abp2a);
							#endregion
							#region MEASURE VALUES
							vl(vstr[60], chartConvColor);
							//vl("Creating time signature arrays...", chartConvColor);
							QbItemBase tsig = new QbItemArray(mid);
							tsig.Create(QbItemType.SectionArray);
							QbItemBase tsig_arr = new QbItemArray(mid);
							tsig_arr.Create(QbItemType.ArrayArray);
							tsig.ItemQbKey = QbKey.Create(0x32F59FAE);
							//vl("Reading TS values from file...", chartConvColor);
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
								vl(vstr[61], ConsoleColor.Yellow); // megamind
								SyncTrackEntry tsfault = new SyncTrackEntry();
								if (chart.SyncTrack.Count != 0)
									foreach (SyncTrackEntry st in chart.SyncTrack)
									{
										if (st.Type == SyncType.BPM)
										{
											tsfault.Offset = st.Offset;
											break;
										}
									}
								tsfault.Type = SyncType.TimeSignature;
								tsfault.TimeSignature = 4;
								ts.Add(tsfault);
							}
							int timesigcount = ts.Count;
							QbItemInteger[] ts_q = new QbItemInteger[timesigcount];
							for (int i = 0; i < timesigcount; i++)
							{
								//verboseline("Creating time signature #" + i.ToString() + "...", chartConvColor);
								ts_q[i] = new QbItemInteger(mid);
								ts_q[i].Create(QbItemType.ArrayInteger);
								ts_q[i].Values = new int[3];
							}
							for (int i = 0; i < timesigcount; i++)
							{
								//verboseline("Setting TS #" + (i).ToString() + " values (1/3) (" + (int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay) + ")...", chartConvColor);
								ts_q[i].Values[0] = (int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay);
								//verboseline("Setting TS #" + (i).ToString() + " values (2/3) (" + Convert.ToInt32(ts[i].TimeSignature) + ")...", chartConvColor);
								ts_q[i].Values[1] = Convert.ToInt32(ts[i].TimeSignature);
								//verboseline("Setting TS #" + (i).ToString() + " values (3/3) (" + 4 + ")...", chartConvColor);
								ts_q[i].Values[2] = 4; // what this part for
								// what does changing # in */# even do in general
							}
							//vl("Adding time signature arrays to QB...", chartConvColor);
							mid.AddItem(tsig);
							tsig.AddItem(tsig_arr);
							for (int i = 0; i < timesigcount; i++)
								tsig_arr.AddItem(ts_q[i]);
							vl(vstr[62], chartConvColor);
							//vl("Creating fretbar arrays...", chartConvColor);
							QbItemBase bars_arr = new QbItemArray(mid);
							bars_arr.Create(QbItemType.SectionArray);
							bars_arr.ItemQbKey = QbKey.Create(0xC3C71E9D);
							QbItemInteger bars = new QbItemInteger(mid);
							List<int> msrs = new List<int>();
							for (int i = 0; OT.GetTime(i - chart.Resolution) < ((float)(et) / 1000); i += chart.Resolution)
							{
								msrs.Add(Convert.ToInt32(Math.Floor(OT.GetTime(i) * 1000)));
							}
							{
								bars.Create(QbItemType.ArrayInteger);
								bars.Values = new int[msrs.Count];
								for (int i = 0; i < msrs.Count; i++)
									bars.Values[i] = Convert.ToInt32(msrs[i] + delay);
							}
							//vl("Adding time signature arrays to QB...", chartConvColor);
							mid.AddItem(bars_arr);
							bars_arr.AddItem(bars);
							#endregion
							vl(vstr[63]);
							//vl("Collecting garbage...");
							GC.Collect();
							#region MARKER VALUES
							vl(vstr[64], chartConvColor);
							//vl("Creating marker arrays...", chartConvColor);
							QbItemArray sects = new QbItemArray(mid);
							sects.Create(QbItemType.SectionArray);
							QbItemStructArray sects_arr = new QbItemStructArray(mid);
							sects.ItemQbKey = QbKey.Create(0x85C8739B);
							sects_arr.Create(QbItemType.ArrayStruct);
							List<EventsSectionEntry> mrkrs = new List<EventsSectionEntry>();
							foreach (EventsSectionEntry e in chart.Events)
							{
								if (e == null) { vl("Got null event!!!!!!!!!");  continue; } // wtf
								if (e.TextValue == null) { vl("Got null event text!!!!!!!!!"); continue; } // wtf
								if (e.TextValue.StartsWith("section "))
								{
									mrkrs.Add(e);
								}
							}
							int mrk_c = mrkrs.Count;
							QbItemStruct[] mrk_str = new QbItemStruct[mrk_c];
							QbItemInteger[] mrk_t = new QbItemInteger[mrk_c];
							QbItemString[] mrk_n = new QbItemString[mrk_c];
							for (int i = 0; i < mrk_c; i++)
							{
								//verbose("Creating marker #" + i.ToString(), chartConvColor);
								mrk_str[i] = new QbItemStruct(mid);
								mrk_str[i].Create(QbItemType.StructHeader);
								//verbose(": time = ", chartConvColor);
								mrk_t[i] = new QbItemInteger(mid);
								mrk_t[i].Create(QbItemType.StructItemInteger);
								mrk_t[i].ItemQbKey = QbKey.Create(0x906B67BA);
								//verbose(mrkrs[i].Offset + delay, chartConvColor);
								mrk_t[i].Values[0] = (int)(Math.Floor(OT.GetTime(mrkrs[i].Offset) * 1000) + delay);
								//verbose(", name = ", chartConvColor);
								mrk_n[i] = new QbItemString(mid);
								mrk_n[i].Create(QbItemType.StructItemString);
								mrk_n[i].ItemQbKey = QbKey.Create(0x7D30DF01);
								//verbose(SubstringExtensions.EncloseWithQuoteMarks(mrkrs[i].TextValue) + "\n", chartConvColor);
								mrk_n[i].Strings[0] = mrkrs[i].TextValue.Substring(8);//markerstr[i * 2 + 1];
							}
							//vl("Adding marker arrays to QB.", chartConvColor);
							mid.AddItem(sects);
							sects.AddItem(sects_arr);
							for (int i = 0; i < mrk_c; i++)
							{
								sects_arr.AddItem(mrk_str[i]);
								mrk_str[i].AddItem(mrk_t[i]);
								mrk_str[i].AddItem(mrk_n[i]);
							}
							#endregion
							#region MISC VALUES
							//vl("Creating and adding other things...", chartConvColor);
							//vl("Adding scripts array to QB.", chartConvColor);
							mid.AddItem(scrs);
							scrs.AddItem(scr_arr);
							for (int i = 0; i < scripts.Count; i++)
							{
								scr_arr.AddItem(scripts[i]);
							}
							string sini = "song.ini";
							QbItemBase songmeta = new QbItemStruct(mid);
							songmeta.Create(QbItemType.SectionStruct);
							songmeta.ItemQbKey = QbKey.Create("fastgh3_meta");
							QbItemString songtitle = new QbItemString(mid);
							songtitle.Create(QbItemType.StructItemString);
							songtitle.ItemQbKey = QbKey.Create("title");
							QbItemString songauthr = new QbItemString(mid);
							songauthr.Create(QbItemType.StructItemString);
							songauthr.ItemQbKey = QbKey.Create("author");
							QbItemString songalbum = new QbItemString(mid);
							songalbum.Create(QbItemType.StructItemString);
							songalbum.ItemQbKey = QbKey.Create("album");
							QbItemString songyear = new QbItemString(mid);
							songyear.Create(QbItemType.StructItemString);
							songyear.ItemQbKey = QbKey.Create("year");
							QbItemString songchrtr = new QbItemString(mid);
							songchrtr.Create(QbItemType.StructItemString);
							songchrtr.ItemQbKey = QbKey.Create("charter");
							songtitle.Strings[0] = ini("song", "name", "Untitled", sini).Trim();
							songauthr.Strings[0] = ini("song", "artist", "Unknown", sini).Trim();
							songalbum.Strings[0] = ini("song", "album", "Unknown", sini).Trim();
							songyear.Strings[0] = ini("song", "year", "Unknown", sini).Trim();
							songchrtr.Strings[0] = ini("song", "charter", "Unknown", sini).Trim();
							string genre = ini("song", "genre", "Unknown", sini).Trim();
							foreach (SongSectionEntry s in chart.Song)
							{
								if (s.Key == "Name" && (s.Value.Trim() != ""))
									songtitle.Strings[0] = chart.Song["Name"].Value.Trim();
								if (s.Key == "Artist" && (s.Value.Trim() != ""))
									songauthr.Strings[0] = chart.Song["Artist"].Value.Trim();
								if (s.Key == "Charter" && (s.Value.Trim() != ""))
									songchrtr.Strings[0] = chart.Song["Charter"].Value.Trim();
							};
							mid.AddItem(songmeta);
							songmeta.AddItem(songtitle);
							songmeta.AddItem(songauthr);
							songmeta.AddItem(songalbum);
							songmeta.AddItem(songyear);
							songmeta.AddItem(songchrtr);
							string timeString = ((et / 1000) / 60).ToString("00") + ':' + (et / 1000 % 60).ToString("00");
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
								FormatText(Regex.Unescape(cfg(l, stf, "%a - %t")),
								songParams));
							#endregion
							#endregion

							if (isBoss)
							{
								mid.AddItem(fastgh3_extra);
								fastgh3_extra.AddItem(QB_bossboss);
								mid.AddItem(QB_bosstime);
								mid.AddItem(QB_bossname);
								if (!boss_defProps)
								{
									QB_bossprops.AddItem(QB_bossRKgain_s);
									QB_bossprops.AddItem(QB_bossRKloss_s);
									QB_bossprops.AddItem(QB_bossATKmiss_s);
									QB_bossprops.AddItem(QB_bossWrepair_s);
									QB_bossprops.AddItem(QB_bossSrepair_s);
									QB_bossprops.AddItem(QB_bossSTRmiss_s);
									QB_bossprops.AddItem(boss_items_arrays);
									boss_items_arrays.AddItem(boss_items);

									QbItemQbKey prof = new QbItemQbKey(mid);
									prof.Create(QbItemType.StructItemQbKey);
									prof.ItemQbKey = QbKey.Create("character_profile");
									prof.Values[0] = QbKey.Create("axel");
									QB_bossprops.AddItem(prof);

									QbItemQbKey name = new QbItemQbKey(mid);
									name.Create(QbItemType.StructItemQbKeyString);
									name.ItemQbKey = QbKey.Create("character_name");
									name.Values[0] = QbKey.Create("boss_name");
									QB_bossprops.AddItem(name);

									mid.AddItem(QB_bossprops);
								}
								//QB_bossRKgain_s = new QbItemStruct(songdata);
								//QB_bossRKgain_s.Create(StructItemStruct);
								//QB_bossRKgain_s.ItemQbKey = QbKey.Create("GainPerNote");
							}
							vl(vstr[65], chartConvColor);
							//vl("Aligning pointers...", chartConvColor);
							mid.AlignPointers();
							//vl("Writing song.qb...", chartConvColor);
							//songdata.Write(folder + pak + "song.qb");
							print(vstr[66], chartConvColor);
							//print("Compiling PAK.", chartConvColor);
							// somehow songs\fastgh3.mid.qb =/= E15310CD here
							// wtf is the name of 993B9724
							// though i think name wouldnt actually
							// matter here because of how the game
							// loads paks, which doesnt care about
							// whatever the files are called,
							// as long as its data gets loaded
							string qb_name = "songs\\fastgh3.mid.qb";
							try
							{
								build.ReplaceFile(qb_name, mid);// folder + pak + "song.qb"); // songs\fastgh3.mid.qb
							}
							catch
							{
								build.AddFile(mid, qb_name, QbKey.Create(".qb"), false);
							}
							File.Delete(pakf + "song.qb");
							if (caching)
							{
								print(vstr[67], cacheColor);
								//print("Writing PAK to cache.", cacheColor);
								File.Copy(songpak, cf + charthash.ToString("X16"), true);
								iniw(charthash.ToString("X16"), "Title", songtitle.Strings[0], cachf);
								iniw(charthash.ToString("X16"), "Author", songauthr.Strings[0], cachf);
								iniw(charthash.ToString("X16"), "Length", timeString, cachf);
							}
							vl(vstr[68]);
							//vl("DID EVERYTHING WORK?!");
						}
						else
						{
							string cacheidStr = charthash.ToString("X16");
							print(vstr[69], cacheColor);
							//print("Cached chart found.", cacheColor);
							File.Copy(cf + cacheidStr,
								songpak, true);
							File.Copy(args[0], paksongmid, true);
							mid2chart.Start();
							try
							{
								// ugh
								if (vb || wl)
								{
									mid2chart.BeginErrorReadLine();
									mid2chart.BeginOutputReadLine();
								}
							}
							catch { }
							if (!mid2chart.HasExited)
								mid2chart.WaitForExit();
							if (ischart)
							{
								chart.Load(args[0]);
							}
							else chart.Load(pakf + "song.chart");
							string unknown = "Unknown";
							string _title = "Untitled", author = unknown,
								year = unknown, timestr = unknown,
								album = unknown, charter = unknown,
								genre = unknown;
							_title = ini(cacheidStr, "Title", "Untitled", cachf);
							author = ini(cacheidStr, "Author", unknown, cachf);
							timestr = ini(cacheidStr, "Length", "Undefined", cachf);
							string sini = "song.ini";
							if (File.Exists("song.ini"))
							{
								_title = ini("song", "name", "Untitled", sini).Trim();
								author = ini("song", "artist", unknown, sini).Trim();
								album = ini("song", "album", unknown, sini).Trim();
								year = ini("song", "year", unknown, sini).Trim();
								charter = ini("song", "charter", unknown, sini).Trim();
								genre = ini("song", "genre", unknown, sini).Trim();
								float duration = int.Parse(ini("song", "song_length", "0", sini));
								timestr = ((duration / 1000) / 60).ToString("00") + ':' + (((duration / 1000) % 60)).ToString("00");
								// MAKE THIS A FUNCTION ^
							}
							foreach (SongSectionEntry s in chart.Song)
							{
								// also optimize this with switch and have Value != "" wrap around it
								if (s.Key == "Name" && (s.Value.Trim() != ""))
									_title = chart.Song["Name"].Value.Trim();
								if (s.Key == "Artist" && (s.Value.Trim() != ""))
									author = chart.Song["Artist"].Value.Trim();
								if (s.Key == "Charter" && (s.Value.Trim() != ""))
									charter = chart.Song["Charter"].Value.Trim();
							};
							string[] songParams = new string[] {
								author,
								_title,
								album,
								charter,
								year,
								timestr,
								genre
							};
							File.WriteAllText(folder + "currentsong.txt",
								FormatText(Regex.Unescape(cfg(l, stf, "%a - %t")),
								songParams));
							File.Delete(paksongmid);
							File.Delete(paksongchart);
						}
						#region COMPILE AUDIO TO FSB
						vl(vstr[74]);
						//vl("Creating GH3 process...");
						Process gh3 = new Process();
						gh3.StartInfo.WorkingDirectory = folder;
						gh3.StartInfo.FileName = GH3EXEPath;
						gh3.Start();
						if (!audCache)
						{
							if (!MTFSB)
							{
								if (!fsbbuild.HasExited)
								{
									vl("Launching game early");
									print(vstr[70], FSBcolor);
									//print("Waiting for song encoding to finish.", FSBcolor);
									fsbbuild.WaitForExit();
									audioConv_end = time;
									if (caching)
									{
										print(vstr[71], cacheColor);
										//print("Writing audio to cache.", FSBcolor);
										File.Copy(fsb, cf + audhash.ToString("X16"), true);
										iniw(charthash.ToString("X16"), "Audio", audhash.ToString("X16"), cachf);
									}
								}
							}
							else
							{
								vl("Launching game early");
								print(vstr[70], FSBcolor);
								string[] fsbnames = { "song", "guitar", "rhythm" };
								try
								{
									Console.WriteLine("Encoding progress:");
									for (int i = 0; i < 3; i++)
									{
										if (audiostreams[i] == mt + "blank.mp3")
											continue;
										pbl[i] = (short)Console.CursorTop;
										Console.WriteLine(fsbnames[i].PadRight(6) + ":   0% (" + ")".PadLeft(33)); // leet optimization
									}
									if (nj3t)
										if (!addaud.HasExited)
											print(vstr[72], FSBcolor);
									// we're using CBR (for now) so don't have to worry about
									// more inconsistent file sizes
								}
								catch
								{
									/*
									<8.359>Waiting for song encoding to finish.
									<8.359>ERROR! :(
									<8.362>System.IO.IOException: The handle is invalid.
										at System.IO.__Error.WinIOError(Int32 errorCode, String maybeFullPath)
										at System.Console.GetBufferInfo(Boolean throwOnNoConsole, Boolean& succeeded)
										at System.Console.get_CursorTop()
										at Program.Main(String[] args)
									*/
									// how does this happen
									// besides for maybe small buffer
									// or something launching this
									// without a console window
									// in which case, how do i know
									// if there is
									print("Failed to create encoding progress bars.");
									pbl[0] = -1;
									pbl[1] = -1;
									pbl[2] = -1;
								}
								bool[] locks = { false, false, false };
								while (!locks[0] || !locks[1] || !locks[2])
								{
									// this whole part made out of
									// sox not immediately flushing text
									// as it's printing it
									System.Threading.Thread.Sleep(9);
									for (int i = 0; i < 3; i++)
										if (!locks[i])
											if (File.Exists(mt + "fsbtmp\\fastgh3_" + fsbnames[i] + ".mp3"))
												pb(new FileInfo(mt + "fsbtmp\\fastgh3_" +
													fsbnames[i] + ".mp3").Length / 1000 / (al[i] * (AB_param / 4)), i);
									for (int i = 0; i < fsbbuild2.Length; i++)
										if (!nj3t || (nj3t && i != 0))
											if (!locks[i])
												if (fsbbuild2[i].HasExited)
													locks[i] = true;
									if (nj3t && !locks[0])
										if (addaud.HasExited)
											locks[0] = true;
								}
								fsbbuild3.Start();
								if (vb | wl)
								{
									fsbbuild3.BeginErrorReadLine();
									fsbbuild3.BeginOutputReadLine();
								}
								if (!fsbbuild3.HasExited)
									fsbbuild3.WaitForExit();
								audioConv_end = time;
								{
									if (caching)
									{
										print(vstr[71], cacheColor);
										//print("Writing audio to cache.", cacheColor);
										File.Copy(fsb, cf + audhash.ToString("X16"), true);
										iniw(charthash.ToString("X16"), "Audio", audhash.ToString("X16"), cachf);
									}
								}
							}
						}
						cfgW("Temp", "LoadingLock", 0);
						#endregion
						cSV("background.bik");
						unkillgame();
						if (!audCache)
						{
							double audioConv_time = audioConv_end.TotalMilliseconds - audioConv_start.TotalMilliseconds;
							print(vstr[73] + (audioConv_time/1000).ToString("0.00")+" seconds", FSBcolor);
							//print("Elapsed audio encoding time: "+(audioConv_time/1000).ToString()+" seconds", FSBcolor);
						}
						Console.ResetColor();
						//print("Speeding up.");
						if (cfg("Player", "MaxNotesAuto", "0") == "1")
						{
							vl("Getting max notes...");
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
							vl("Got " + maxnotes + " max notes");
							cfgW("Player", "MaxNotes", maxnotes.ToString());
						}
						print(vstr[75]);
						//print("Ready, go!");
						cfgW("Temp", fl, 1);
						try
						{
							// why is program sending this log when it's successful
							// and this is in its own try catch block
							vl(vstr[76]);
							//vl("Cleaning up SoX temp files FOR SOME REASON!!!");
							// stupid SoX
							// didn't happen on the previous version from 2010
							// so WHY DOES IT CREATE THESE
							foreach (var f in new DirectoryInfo(Path.GetTempPath()).EnumerateFiles("libSox.tmp.*"))
							{
								try { f.Delete(); } catch { }
							}
							foreach (var f in new DirectoryInfo(Path.GetTempPath()+"Z.FGH3.TMP\\").EnumerateFiles())
							{
								try { f.Delete(); } catch { }
							}
							foreach (var f in new DirectoryInfo(Path.GetTempPath()+"Z.FGH3.TMP\\").EnumerateDirectories())
							{
								try { f.Delete(true); } catch { }
							}
							Directory.Delete(Path.GetTempPath()+"Z.FGH3.TMP\\",true);
						}
						catch
						{
							vl("fail");
						}
						exit();
						if (cfg(l, settings.t.PreserveLog.ToString(), "0") == "1")
						{
							print(vstr[98]);
							//print("Press any key to exit");
							Console.ReadKey();
						}
					}
					#endregion
					#region FSP EXTRACT
					else if (File.Exists(args[0]) &&
						(args[0].EndsWith(".fsp") || args[0].EndsWith(".zip") ||
						args[0].EndsWith(".7z") || args[0].EndsWith(".rar")))
					{
						// 7kb
						log.WriteLine(vstr[77]);
						//log.WriteLine("\n######### FSP EXTRACT PHASE #########\n");
						print(vstr[78], cacheColor);
						//print("Detected song package.", cacheColor);
						ulong fsphash = WZK64.Create(File.ReadAllBytes(args[0]));
						string fsphashStr = fsphash.ToString("X16");
						bool fspcache = false;
						if (caching)
						{
							print(vstr[21], cacheColor);
							if (Array.IndexOf(sn(cachf), "ZIP" + fsphashStr) != -1)
							{
								vl(vstr[79], cacheColor);
								fspcache = true;
							}
						}
						bool compiled = false;
						List<string> multichartcheck = new List<string>();
						string tmpf = cf + fsphashStr + '\\', selectedtorun = "";
						if (!caching)
						{
							tmpf = Path.GetTempPath() + "Z.FGH3.TMP\\";
							if (Directory.Exists(tmpf))
							// WHY ARE YOU PUTTING DESKTOP.INI IN YOUR CHART FOLDERS
							// *coming from someone who has hidden files shown
							// when it's not a default option on windows
							//Directory.Delete(tmpf, true);
							{
								foreach (string f in Directory.GetFiles(tmpf, "*.*", SearchOption.TopDirectoryOnly))
								{
									try
									{
										File.Delete(f);
									}
									catch
									{

									}
								}
							}
							else
								Directory.CreateDirectory(tmpf);
						}
						if (!fspcache && caching)
							print(vstr[80], cacheColor);
						else
						{
							if (fspcache && Directory.Exists(tmpf) && caching)
								print(vstr[81], cacheColor);
							else if (!Directory.Exists(tmpf))
								print(vstr[82], cacheColor);
						}
						if (fspcache && Directory.Exists(tmpf) && caching)
						{
							// freaking copy and paste
							foreach (string ff in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
							{
								string f = ff.ToLower();
								if (f.EndsWith(".pak") ||
									f.EndsWith(".pak.xen"))
								{
									vl("Found .pak", FSPcolor);
									killgame();
									File.Delete(songpak);
									File.Copy(f, songpak, true);
									multichartcheck.Add(f);
									compiled = true;
								}
								if (f.EndsWith(".fsb") ||
									f.EndsWith(".fsb.xen"))
								{
									vl("Found .fsb", FSPcolor);
									killgame();
									File.Delete(fsb);
									File.Copy(f, fsb, true);
								}
								if (f.EndsWith(".chart") ||
									f.EndsWith(".mid"))
								{
									vl("Found .chart/.mid", FSPcolor);
									// replace this
									multichartcheck.Add(f);
									selectedtorun = f;
								} // should this be run after detecting a PAK
								  // though then the multichart routine will run regardless
								if (f == "song.ini")
								{
									vl("Found song.ini", FSPcolor);
								}
								if (f == "boss.ini")
								{
									vl("Found boss.ini", FSPcolor);
								}
								if (f == "background.bik")
								{
									vl("Found background.bik", FSPcolor);
								}
								if (f.EndsWith(".ogg") ||
									f.EndsWith(".mp3") ||
									f.EndsWith(".wav") ||
									f.EndsWith(".opus"))
								{
									vl("Found audio", FSPcolor);
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
								using (ZipFile file = ZipFile.Read(args[0]))
								{
									file.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
									foreach (ZipEntry data in file)
									{
										try
										{
											string f = data.FileName.ToLower();
											data.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
											if (f.EndsWith(".pak") ||
												f.EndsWith(".pak.xen"))
											{
												killgame();
												vl("Found .pak, extracting...", FSPcolor);
												data.Extract(tmpf);
												// do something with this moving when multiple files exist or whatever
												File.Delete(songpak);
												File.Copy(tmpf + f, songpak, true);
												multichartcheck.Add(f);
												compiled = true;
											}
											if (f.EndsWith(".fsb") ||
												f.EndsWith(".fsb.xen"))
											{
												killgame();
												vl("Found .fsb, extracting...", FSPcolor);
												data.Extract(tmpf);
												File.Delete(fsb);
												File.Copy(tmpf + f, fsb, true);
											}
											if (f.EndsWith(".chart") ||
												f.EndsWith(".mid"))
											{
												vl("Found .chart/.mid, extracting...", FSPcolor);
												data.Extract(tmpf);
												// replace this
												multichartcheck.Add(f);
												selectedtorun = tmpf + f;
											} // should this be run after detecting a PAK
											  // though then the multichart routine will run regardless
											if (f == "song.ini")
											{
												vl("Found song.ini, extracting...", FSPcolor);
												data.Extract(tmpf);
											}
											if (f == "boss.ini")
											{
												vl("Found boss.ini, extracting...", FSPcolor);
												data.Extract(tmpf);
											}
											if (f == "background.bik")
											{
												vl("Found background.bik", FSPcolor);
												data.Extract(tmpf);
												//copySongVideo(tmpf + "\\background.bik");
											}
											if (f.EndsWith(".ogg") ||
												f.EndsWith(".mp3") ||
												f.EndsWith(".wav") ||
												f.EndsWith(".opus"))
											{
												vl("Found audio, extracting...", FSPcolor);
												data.Extract(tmpf);
											}
										}
										catch (Exception e)
										{
											vl(vstr[83] + data.FileName + '\n' + e, ConsoleColor.Yellow);
											//vl("Error extracting a file: " + data.FileName + '\n' + e, ConsoleColor.Yellow);
										}
									}
								}
							}
							else
							// extract using 7-zip or WinRAR if installed
							{
								//vl("OH NO, THE SEVENS AND THE ROARS!", FSPcolor); // lol
								bool got7Z = false, gotWRAR = false;
								vl(vstr[84], FSPcolor);
								//vl("Looking for command line accessible 7Zip.", FSPcolor);
								string p = where("7z.exe"); // do i have to specify .exe
								got7Z = p != "";
								if (!got7Z)
								{
									p = where("7za.exe");
									got7Z = p != "";
								}
								// todo?: check associated program for 7z/rar??
								// but then that will lead to getting the EXE for the GUI
								// of the program, if not the CLI unless it's a specific
								// program where the CLI is the main EXE
								string rarpath = "";
								if (!got7Z)
								{
									// or look in registry
									vl(vstr[85], FSPcolor);
									//vl("Looking for 7Zip in registry.", FSPcolor);
									RegistryKey k;
									// also check HKLM hive?
									try
									{
										k = Registry.CurrentUser.OpenSubKey("SOFTWARE\\7-Zip");
										if (k != null)
										{
											p = (string)k.GetValue("Path");
											if (p == null)
											{
												p = (string)k.GetValue("Path64");
												if (p != null)
													got7Z = true;
											}
											else
												got7Z = true;
											if (got7Z)
												p += "\\7z.exe";
											if (!File.Exists(p) && got7Z)
											{
												vl(vstr[86], FSPcolor);
												//vl("Wait WTF, THE PROGRAM ISN'T THERE!! HOW!", FSPcolor);
												got7Z = false;
											}
											k.Close();
										}
										else
											print(vstr[87]);
											//print("Could not find 7-Zip path in registry. Is it installed?");
									}
									catch
									{
										got7Z = false;
										vl(vstr[88]);
										//vl("Somehow looking for 7-Zip failed. Is it installed?");
									}
								}
								else
									vl("Found 7Zip", FSPcolor);
								if (got7Z)
								{
									vl(vstr[89], FSPcolor);
									//vl("7Zip is installed. Using that...", FSPcolor);
									//verboseline(z7path);
								}
								else
								{
									vl(vstr[90], FSPcolor);
									//vl("7Zip could not be found.", FSPcolor);
									vl(vstr[91], FSPcolor);
									//vl("Looking for command line accessible WinRAR or UnRar.exe", FSPcolor);
									rarpath = where("UnRar.exe");
									gotWRAR = rarpath != "";
									if (gotWRAR)
									{
										if (!args[0].EndsWith(".rar"))
										{
											exit();
											MessageBox.Show(vstr[125], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
											Environment.Exit(1);
										}
										vl(vstr[92], FSPcolor);
										//vl("Found UnRAR. Using that...", FSPcolor);
									}
									else
										vl(vstr[93], FSPcolor);
										//vl("UnRAR could not be found.", FSPcolor);
								}
								string xf, xa;

								if (got7Z)
								{
									xf = p;
									xa = "x " + args[0].Quotes() + " -aoa -o" + tmpf.Quotes();
								}
								else if (gotWRAR)
								{
									xf = rarpath;
									xa = "x -o+ " + Path.GetFullPath(args[0]).Quotes() + " " + tmpf.Quotes();
								}
								else
								{
									exit();
									vl(vstr[94], FSPcolor);
									//vl("Unsupported archive type", FSPcolor);
									MessageBox.Show(vstr[126], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
									Environment.Exit(1);
									return;
								}
								Process x = cmd(xf,xa);
								if (got7Z || gotWRAR)
								{
									vl("Executing " + x.StartInfo.FileName.Quotes() + " " + x.StartInfo.Arguments, FSPcolor);
									vl("log:");
									x.Start();
									if (vb || wl)
									{
										x.BeginErrorReadLine();
										x.BeginOutputReadLine();
									}
									x.WaitForExit();
									vl("Exit code: " + x.ExitCode, FSPcolor);
									if (x.ExitCode != 0)
									{
										exit();
										MessageBox.Show(vstr[127], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
										Environment.Exit(1);
									}
									foreach (string ff in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
									{
										string f = ff.ToLower();
										if (f.EndsWith(".pak") ||
											f.EndsWith(".pak.xen"))
										{
											killgame();
											vl("Found .pak", FSPcolor);
											// do something with this moving when multiple files exist or whatever
											File.Delete(songpak);
											File.Move(f, songpak);
											multichartcheck.Add(f);
											compiled = true;
										}
										if (f.EndsWith(".fsb") ||
											f.EndsWith(".fsb.xen"))
										{
											killgame();
											vl("Found .fsb", FSPcolor);
											File.Delete(fsb);
											File.Move(f, fsb);
										}
										if (f.EndsWith(".chart") ||
											f.EndsWith(".mid"))
										{
											vl("Found .chart/.mid", FSPcolor);
											// replace this
											multichartcheck.Add(f);
											selectedtorun = f;
										} // should this be run after detecting a PAK
										  // though then the multichart routine will run regardless
										if (f == "song.ini")
										{
											vl("Found song.ini", FSPcolor);
										}
										if (f == "boss.ini")
										{
											vl("Found boss.ini", FSPcolor);
										}
										if (f == "background.bik")
										{
											vl("Found background.bik", FSPcolor);
											//copySongVideo(tmpf + "\\background.bik");
										}
										if (f.EndsWith(".ogg") ||
											f.EndsWith(".mp3") ||
											f.EndsWith(".wav") ||
											f.EndsWith(".opus"))
										{
											vl("Found audio", FSPcolor);
										}
									}
								}
							}
						}
						if (caching && !fspcache)
						{
							print(vstr[95], cacheColor);
							//print("Writing path to cache...", cacheColor);
							iniw("ZIP" + fsphashStr, "Path", tmpf, cachf);
						}
						if (multichartcheck.Count == 0)
						{
							exit();
							//vl("There's nothing in here!", ConsoleColor.Red);
							// ♫ There's nothing for me here ♫
							MessageBox.Show("No chart found", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
								unkillgame();
								Console.ResetColor();
								//print("Speeding up.");
								vl(vstr[74]);
								Process gh3 = new Process();
								gh3.StartInfo.WorkingDirectory = folder;
								gh3.StartInfo.FileName = GH3EXEPath;
								// dont do this lol
								if (cfg("Player", "MaxNotesAuto", "0") == "1")
									cfgW("Player", "MaxNotes", 0x100000.ToString());
								print(vstr[75]);
								gh3.Start();
								cfgW("Temp", fl, 1);
							}
							else
							{
								exit();
								cfgW("Temp", fl, 0);
								Process.Start(Application.ExecutablePath, selectedtorun.Quotes());
								die();
							}
					}
					/*else if ((args[0].EndsWith(".pak") || args[0].EndsWith(".pak.xen")))
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
								if (settings.GetKeyValue(m, "PreserveLog", "0") == "1")
								{
									print("Press any key to exit");
									Console.ReadKey();
								}
								settings.SetKeyValue(m, "FinishedLog", "1");
								settings.Save(folder + "settings.ini");
							}
						}
					}*/
					#endregion
				}
				else
				{
					cfgW("Temp", fl, 1);
					print(vstr[96], ConsoleColor.Red);
					exit();
					MessageBox.Show("File cannot be found.\nPath: "+args[0], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
			}
		}
		catch (Exception ex)
		{
			// almost 3kb
			ConsoleColor oldcolor = Console.ForegroundColor;
			Console.ForegroundColor = ConsoleColor.Red;
			print("ERROR! :(");
			print(ex);
			// default value is 1, so why dont i just remove the key
			// but then i would have to write some advanced code
			// for that when using kernel funcs
			// what instance would this fit v
			/*Exception exx = ex.InnerException;
			while (exx != null)
			{
				print("Exception spawned from:");
				exx = exx.InnerException;
			}*/
			Console.ForegroundColor = oldcolor;
			Console.ResetColor(); // NOT WORKING

			// upload log for diagnostics
			exit();
			Program.log = null;
			if (!File.Exists(folder + "launcher.txt"))
			{
				print("Failed to load own launcher log.");
				return;
			}
			string log = File.ReadAllText(folder + "launcher.txt");
			if (cfg("Launcher","ErrorReporting",1)==1 && log.Length < 0x20000) // max 128 KB to upload
			{
				try {
					print("Uploading log.");

					ServicePointManager.Expect100Continue = true;
					ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00);
					ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };

					string host = "https://0x0.st/";
					var request = (HttpWebRequest)WebRequest.Create(host);
					string boundary = "------------------------" + DateTime.Now.Ticks.ToString("x");
					request.ContentType = "multipart/form-data; boundary=" + boundary;
					request.Method = "POST";
					request.ServicePoint.Expect100Continue = true;

					// brain drain
					// TODO?: put these strings in lt.txt
					byte[] tempBuffer = Encoding.ASCII.GetBytes(
						"\r\n--" + boundary + "\r\n" +
						"Content-Disposition: form-data; name=\"file\"; filename=\"launcher.txt\"\r\n" +
						"Content-Type: text/plain\r\n\r\n" +
						log + "\r\n--" + boundary + "--");
					request.ContentLength = tempBuffer.Length;

					using (Stream requestStream = request.GetRequestStream())
					{
						requestStream.Write(tempBuffer, 0, tempBuffer.Length);
					}

					var response = request.GetResponse();

					Stream stream2 = response.GetResponseStream();
					StreamReader reader2 = new StreamReader(stream2);
					string outlink = reader2.ReadToEnd().Trim('\n', '\r');
					char[] id = outlink.Between(host, ".txt").ToCharArray();

					// report to me
					char[] URLalphabet = vstr[97].ToCharArray();

					var report = (HttpWebRequest)WebRequest.Create("https://donnaken15.cf/fastgh3/diagno.php");
					report.ContentType = "application/octet-stream";
					report.Method = "POST";

					byte[] reportbytes = new byte[id.Length];
					for (int i = 0; i < id.Length; i++)
					{
						reportbytes[i] = (byte)Array.IndexOf(URLalphabet, id[i]);
					}
					report.ContentLength = reportbytes.Length;

					using (Stream reportStream = report.GetRequestStream())
					{
						reportStream.Write(reportbytes, 0, reportbytes.Length);
					}
					Stream stream3 = report.GetResponse().GetResponseStream();
					StreamReader reader3 = new StreamReader(stream3);
					reader3.ReadToEnd();
					// im not returning any data, so

					print("Log saved to " + outlink);
				} catch { print(vstr[137]); }
			}

			print(vstr[98]);
			Console.ReadKey();
			Environment.Exit(1);
		}
		//GC.Collect();
		exit();
	}
}