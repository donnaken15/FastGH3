using ChartEdit;
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
using System.Security.Cryptography;
using System.Threading;
#if !SHARPDEV
using Shell32;
#endif
#if !USE_SZL
using Ionic.Zip;
using Ionic.Zlib;
#else
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.GZip;
#endif
using FormKV = System.Tuple<object, string>;

// SubstrExt.cs, ancient functions from dotnetperls or csharp-corner
static class SubstrExt
{
	public static string Quotes(this string v) {
		return '"' + v + '"';
	}
	public static string Parentheses(this string v) {
		return '(' + v + ')';
	}
	public static bool Quoted(this string v) {
		return v.StartsWith("\"") && v.EndsWith("\"");
	}
	//public static bool HasParentheses(this string v) {
	//	return v.StartsWith("(") && v.EndsWith(")");
	//}

	public static string Between(this string v, string a, string b)
	{
		int posA = v.IndexOf(a);
		int posB = v.LastIndexOf(b);
		if (posA == -1)
		{
			return "";
		}
		if (posB == -1)
		{
			return "";
		}
		int adjustedPosA = posA + a.Length;
		if (adjustedPosA >= posB)
		{
			return "";
		}
		return v.Substring(adjustedPosA, posB - adjustedPosA);
	}

	/// <summary>
	/// Get string value after [first] a.
	/// </summary>
	public static string Before(this string v, string a)
	{
		int posA = v.IndexOf(a);
		if (posA == -1)
		{
			return "";
		}
		return v.Substring(0, posA);
	}

	/// <summary>
	/// Get string value after [last] a.
	/// </summary>
	public static string After(this string v, string a)
	{
		int posA = v.LastIndexOf(a);
		if (posA == -1)
		{
			return "";
		}
		int adjustedPosA = posA + a.Length;
		if (adjustedPosA >= v.Length)
		{
			return "";
		}
		return v.Substring(adjustedPosA);
	}

#if false
	// new stuff
	// wrote this entirely before compiling and winged it, gadang yoloswag 420 blaze it
	// inb4 5 more errors
	static string filt_flat = "(\"(?<q>[^\"]+)\"|(?<f>[^;]+))($|;)";
	static Regex filt_whole = new Regex("^("+filt_flat+")+$", RegexOptions.Singleline | RegexOptions.Compiled);
	static Regex filt_part = new Regex(filt_flat, RegexOptions.Singleline | RegexOptions.Compiled);
	static char[] inv_chars = Path.GetInvalidPathChars(); // assuming this includes double quote
	public static bool testPath(string path) {
		return !(string.IsNullOrWhiteSpace(path) || string.IsNullOrEmpty(path) || path.IndexOfAny(inv_chars) >= 0);
	}
	public static string[] xf(string filt) {
		if (!filt_whole.IsMatch(filt))
			throw new Exception("Invalid filter list: "+filt);
		MatchCollection items = filt_part.Matches(filt);
		string[] filts = new string[items.Count];
		int i = 0;
		foreach (Match m in items) {
			string item = "";
			if (m.Groups["q"].Success)
				item = m.Groups["q"].Value;
			else if (m.Groups["f"].Success)
				item = m.Groups["f"].Value;
			else
				throw new Exception("Failed to get capture from match: " + m.Value);
			if (!testPath(item))
				throw new Exception("Invalid filter part: (( "+item+" ))");
			filts[i++] = item;
		}
		return filts;
	}
	// this was done afterwards, not in one go :(
	// since im writing all this convoluted condensed crap
	// probably took 5 T&E builds, because im dumb
	public static Regex[] xw(string[] filts) { // array from xf, or plain string with valid chars including asterisk for wildcard
		return filts.Map(f=>(f.Split('*').Map<string>(p=>Regex.Escape(p)))).Map(ps => { // my god
			foreach (string part in ps)
				if (part.IndexOfAny(inv_chars) >= 0)
					throw new Exception("Invalid character(s) in part of path filter: " + part + ", full: (( " + string.Join(" <|> ", ps) + " ))");
			return new Regex(string.Join(".*", ps), RegexOptions.Singleline);
		});
	}
	public static Regex[] xw(string filt) {
		return xw(new string[] { filt });
	}
	public static Regex[] xm(string filt) {
		return xw(xf(filt));
	}
	// example text: `*.txt;*.mp3;"why;this*.txt";"test test test"`
	
	public static string argify(string[] args) {
		return string.Join(" ", args.Map<string>(s => (s.Contains(" ") && !s.Quoted()) ? s.Quotes() : s)); // awful
	}

#region UGH
	public static T[] ReplaceWith<T>(this Array v, T replace, T with) {
		T[] n = ((T[])v.Clone());
		for (var i = 0; i < v.Length; i++)
		{
			if (!n[i].Equals(replace))
				continue;
			n[i] = with;
		}
		return n;
	}
	public static T[] Spread<T>(this T[] v, T[] i, int w, bool rplI) {
		int r = (rplI ? 1 : 0);
		T[] n = new T[v.Length + i.Length - r];
		Array.Copy(v, n, w - r);
		Array.Copy(v, 0, n, w - r, v.Length - w);
		return n;
	}
	public static object[] Map(this object[] v, Func<object, object> tfunc) {
		return v.Map<object>((e,i,a)=>tfunc(e));
	}
	public static object[] Map(this object[] v, Func<object, int, Array, object> tfunc) {
		return v.Map<object>(tfunc);
	}
	public static ST[] Map<ST>(this ST[] v, Func<ST, ST> tfunc) {
		return v.Map<ST,ST>((e,i,a) => tfunc(e));
	}
	public static ST[] Map<ST>(this ST[] v, Func<ST, int, Array, ST> tfunc) {
		return v.Map<ST,ST>(tfunc);
	}
	public static T2[] Map<T1,T2>(this T1[] v, Func<T1, T2> tfunc) {
		return v.Map<T1,T2>((e,i,a) => tfunc(e));
	}
	public static T2[] Map<T1,T2>(this T1[] v, Func<T1, int, Array, T2> tfunc) {
		T2[] n = new T2[v.Length]; // for T1 --> T1 ((T2[])v.Clone());
		for (var i = 0; i < v.Length; i++)
			n[i] = tfunc(v[i], i, v); // absolutely javascript brained
		return n;
	}
#endregion
#endif
}
#if false
public interface IExtractor {
	string[] List();
	string[] List(string filt);
	void Extract(string outdir, params string[] files);
	byte[] Extract(string file);
	// make for SZL/DNZ, SNG, 7z, unrar, unzip, bsdtar, FS
}
public class ExtExt : IExtractor {
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	// WINTAR ONLY ACCEPTS FORWARD SLASHES, UNRAR ONLY ACCEPTS BACKWARD SLASHES
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	// -------------------------------------------------------------------------------------
	string exe; string[] tA, xA, pA; // view/extract args
	string i; // input
	public string[] List()
	{
		return List("*");
	}
	public string[] List(string filt)
	{
		//List<string> files = new List<string>();
		string[] filts = SubstrExt.xf(filt);
		Process t = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = exe,
				RedirectStandardOutput = true,
				RedirectStandardError = true,
				Arguments = SubstrExt.argify(insertFilts(tA,filts))
			}
		};
		Launcher.vl(t.StartInfo.FileName);
		Launcher.vl(t.StartInfo.Arguments);
		t.Start();
		t.BeginErrorReadLine();
		string[] list = t.StandardOutput.ReadToEnd().Replace("\r", "").Split(new char[] { '\n' }, StringSplitOptions.RemoveEmptyEntries);//.Map<string>(s => s.Substring(53));
		t.WaitForExit();
		if (t.HasExited)
			if (t.ExitCode != 0)
				return null;
		return list;
	}
	static ProcessStartInfo SITemp(string exe, string args) {
		return new ProcessStartInfo() {
			FileName = exe, Arguments = args,
			RedirectStandardOutput = true,
			RedirectStandardError = true,
			UseShellExecute = false,
			CreateNoWindow = false,
		};
	}
	public void Extract(string outdir, params string[] files)
	{
		Process x = new Process() {
			StartInfo = SITemp(exe, SubstrExt.argify(insertFilts(xA, files)))
		};
		Launcher.vl(x.StartInfo.FileName);
		Launcher.vl(x.StartInfo.Arguments);
		x.Start();
		x.BeginErrorReadLine();
		x.BeginOutputReadLine();
		x.WaitForExit();
	}
	public byte[] Extract(string file) {
		Process x = new Process() {
			StartInfo = SITemp(exe, SubstrExt.argify(pA.ReplaceWith("<f>", file.Quotes())))
		};
		Launcher.vl(x.StartInfo.FileName);
		Launcher.vl(x.StartInfo.Arguments);
		x.Start();
		x.BeginErrorReadLine();
		MemoryStream ms = new MemoryStream();
		x.StandardOutput.BaseStream.CopyTo(ms);
		x.WaitForExit();
		if (x.HasExited)
			if (x.ExitCode != 0)
				return null;
		return ms.ToArray();
	}
	static string[] insertFilts(string[] a, string[] b) {
		return a.Spread(b, Array.IndexOf(a, "<f>"), true);
	}
	public ExtExt(string input, string exe, string[] tA, string[] xA, string[] pA) {
		i = Path.GetFullPath(input); this.exe = exe;
		this.tA = tA.ReplaceWith("<a>", i); this.xA = xA.ReplaceWith("<a>", i); this.pA = pA.ReplaceWith("<a>", i);
	}
	public static readonly string[]
		z7_tA = new string[] { "l", "--", "<a>", "<f>" },
		z7_xA = new string[] { "x", "-oao", "--", "<a>", "<f>" },
		z7_pA = new string[] { "x",  "-so", "--", "<a>", "<f>" },
		bt_tA = new string[] {  "-tf", "<a>", "--", "<f>" },
		bt_xA = new string[] { "-xvf", "<a>", "--", "<f>" },
		bt_pA = new string[] { "-xOf", "<a>", "--", "<f>" }, // i was having an aneurysm because cygwin and gnuwin32 are placed in front of system32 where i cant use windows tar, and i was using literal bsdtar.exe, kill me
		ur_tA = new string[] {   "lb", "--", "<a>", "<f>" },
		ur_xA = new string[] { "-xvf", "--", "<a>", "<f>" },
		ur_pA = new string[] {    "p", "-c-", "-ierr", "--", "<a>", "<f>" } // euuuuuughhhhhh //,
		//uz_tA = new string[] {  }, // zipinfo?, why even // because crazy
		//uz_xA = new string[] {  },
		//uz_pA = new string[] {  }
		;
}
public class ZipExt : IExtractor {
	ZipFile zip = null; // input
	public string[] List() {
		return List("*");
	}
	public string[] List(string filt)
	{
		List<string> files = new List<string>();
		ForEach(SubstrExt.xf(filt), fn => {
			files.Add(fn.Name);
			return 0; // god help // bleeeuuuughgh help me jesus :L
		});
		return files.ToArray();
	}
	public void ForEach(string[] filt, Func<ZipEntry, int/* cant do void... >:(   dont care to know anymore about delegates right now */> cb)
	{
		Regex[] filts = SubstrExt.xw(filt);
		foreach (ZipEntry f in zip)
		{
			foreach (Regex fi in filts)
				if (fi.IsMatch(f.Name))
				{
					cb(f);
					break;
				}
		}
	}
	public void Extract(string outdir, string[] files)
	{
		ForEach(files, fn => {
			string isol = Path.Combine(outdir, Path.GetDirectoryName(fn.Name));
			Directory.CreateDirectory(isol);
			Stream s = zip.GetInputStream(fn), o = File.Open(Path.Combine(isol, Path.GetFileName(fn.Name)), FileMode.Create);
			s.CopyTo(o);
			o.Dispose();
			s.Dispose();
			return 0;
		});
	}
	public byte[] Extract(string file)
	{
		Stream s = zip.GetInputStream(zip.GetEntry(file.Replace('/', '\\'/*concerned about this*/)));
		MemoryStream o = new MemoryStream(); s.CopyTo(o); s.Dispose(); return o.ToArray();
	}
	static string[] passwords = Launcher.T[208].Split(';');
	public ZipExt(string input) {
		zip =
#if !USE_SZL
			ZipFile.Read(input)
#else
			new ZipFile(input)
#endif
		;
		Launcher.vl("log.zip: "+input);
		bool unlocked = false;
		string pass = "";
#if !USE_SZL
		// DO LATER, DNZ SOURCE ISN'T LOADING IN RIGHT NOW FOR SOME REASON
#else
		bool locked = !(unlocked = !zip[0].IsCrypted);
		if (locked) {
			Launcher.vl("Password protected, testing GHTCP passwords");
			for (int i = 0; i < 4; i++)
			{
				try
				{
					zip.Password = passwords[i];
					Stream dummy = zip.GetInputStream(0);
					// guessing index zero is the first file available :/
					// and that it throws if password is incorrect
					dummy.Close();
					unlocked = true;
					pass = passwords[i];
					break; // breaking through try, perturbing... // LOL banger comment - t. future me
				}
				catch { }
			}
			if (!unlocked)
			{
				throw new Exception("Couldn't unlock zip using GHTCP passwords");
				// TODO: password dialog
			}
		}
		else
			Launcher.vl("No password");
		if (unlocked)
#endif
		{
#if !USE_SZL
#else
			
#endif
		}
	}
}
#endif

public static partial class Launcher
{
#region INI stuff
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileInt", CharSet = CharSet.Unicode)]
	public static extern int GI(string a, string k, int d, string f);
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern int GStr(
		string a, string k,
		string d, [In, Out] byte[] s,
		int n, string f);
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileSectionNames", CharSet = CharSet.Unicode)]
	public static extern int GSN(char[] s, int n, string f);
	[DllImport("kernel32.dll", EntryPoint = "WritePrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern bool WSec(string a, string s, string f);
	[DllImport("kernel32.dll", EntryPoint = "WritePrivateProfileString", CharSet = CharSet.Unicode)]
	public static extern bool WStr(string a, string k, string s, string f);
	//https://www.pinvoke.net/default.aspx/kernel32.GetPrivateProfileSectionNames
	public static string[] sn(string i)
	{
		char[] buf = new char[0x20000];
		// being generous for people playing 6500 songs
		// deusdeceptor's brain damage will not take kindly to this
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
	public static string ini(string a, string k, string d, int i, string f)
	{
		byte[] _ = new byte[i];
		int len = GStr(a, k, d, _, i, IF(f));
		Array.Resize(ref _, len * 2);
		return Encoding.Unicode.GetString(_);
	}
	public static int ini(string a, string k, int d, string f) { return GI(a, k, d, IF(f)); }
	public static int cfg(string a, string k, int d) { return GI(a, k, d, inif); }
	public static string ini(string s, string k, string d, string f){ return ini(s, k, d, 0x200, f); } // for being lazy
	public static string cfg(string s, string k, string d, int i)	{ return ini(s, k, d, i, inif); }
	public static string cfg(string s, string k, string d)			{ return ini(s, k, d, 0x200, inif); } // for being lazy
	public static void iniw(string s, string k, object d, string f)	{ WStr(s, k, d.ToString(), f); }
	public static void cfgW(string s, string k, object d)			{ iniw(s, k, d, inif); }

	// must always be mod directory, current directory will always be the
	// chart location, even when using absolute chart paths all the time
	public static string folder = Path.GetDirectoryName(Application.ExecutablePath) + '\\';
	public static string[] ikeys = T[194].Split('%');
	public static string m = ikeys[0];
	public static string l = ikeys[2];
	public static string ks = ikeys[5];
	public static string fl = ikeys[4];
	public static string sv = ikeys[6];
	public static string lshv = ikeys[7];
	public static string stf = ikeys[3];
	public static string IF(string f) // ini path fix
	{
		return Path.IsPathRooted(f) ? f : (Directory.GetCurrentDirectory() + '\\' + f);
	}
#endregion

	public static string
		dataf = folder + "DATA\\",
		pakf = dataf + "PAK\\",
		music = dataf + "MUSIC\\",
		vid = dataf + "MOVIES\\BIK\\",
		mt = music + "TOOLS\\",
		cf = dataf + "CACHE\\",
		title = "FastGH3";

	static bool vb, wl = true;
	public static string inif;
	public static string cachf;
	static StreamWriter log = null;
	static string GH3EXEPath;

	// from https://stackoverflow.com/questions/1266674
	public static string NP(string path)
	{
		return Path.GetFullPath(new Uri(path).LocalPath)
					.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
					.ToUpperInvariant();
	}

#region little functions
	public static void killgame()	{ cfgW("Temp", ks, 1); }
	public static void unkillgame()	{ cfgW("Temp", ks, 0); }
	// copy song video
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
			string lv = vid + "lastvid";
			string target = vid + T[164];
			try
			{
				if (File.Exists(bik))
				{
					vl(T[99]);
					//vl("Found (Bink) background video");
					if (cfg(m, lshv, 0) == 0)
					{
						vl(T[132]);
							// save last background video
						if (File.Exists(target))
							File.Copy(target, lv, true);
						cfgW(m, lshv, 1);
					}
					File.Copy(bik, target, true);
				}
				else
				{
					vl(T[100]);
					//vl("No (Bink) background video found");
					if (cfg(m, lshv, 0) == 1)
					{
						vl(T[133]);
						// restore user video after playing a song with a background video
						// and now playing a song without one
						if (File.Exists(lv))
						{
							File.Copy(lv, target, true);
							File.Delete(lv);
						}
						else
							if (File.Exists(target))
								File.Delete(target);
						// if there's no previous video, just delete the current one
						cfgW(m, lshv, 0);
					}
				}
			}
			catch (Exception e)
			{
				print(T[165]);
				vl(e);
			}
		}
#endregion
	}
	static void killEncoders()
	{
		// TODO: send Ctrl-C to encoder process
	}

	static void die()
	{
		Process.GetCurrentProcess().Kill();
	}
	static uint Eswap(uint v)
	{
		return ((v & 0xFF) << 24) |
				((v & 0xFF00) << 8) |
				((v & 0xFF0000) >> 8) |
				((v & 0xFF000000) >> 24);
	}

	static TimeSpan time {
		get { // =>
			return DateTime.UtcNow - Process.GetCurrentProcess().StartTime.ToUniversalTime();
		}
	}
	static string ms {
		get { // =>
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

	// print base
	public static void _l(object t, bool v)
	{
		if (!wl || log == null)
			return;
		if (v) log.Write(ms);
		log.WriteLine(t);
		log.Flush();
	}
	public static void v(object t)
	{
		if (vb)
			Console.Write(t);
		if (!wl || log == null)
			return;
		log.Write(t);
		log.Flush();
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
		_l(t, true);
		if (!vb)
			return;
		try
		{
			Console.Write(ms);
			Console.WriteLine(t);
		} catch { }
	}
	public static void vl(object t, ConsoleColor c)
	{
		ConsoleColor oldcol = Console.ForegroundColor;
		if (coll)
			Console.ForegroundColor = c;
		vl(t);
		if (coll)
			Console.ForegroundColor = oldcol;
	}
	public static void print(object t)
	{
		try
		{
			Console.WriteLine(t); // impossible
		} catch { }
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
#endregion

#region process functions, functions for part of conversion, misc
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
			if (Path.GetDirectoryName(e) == string.Empty)
				foreach (string v in (
					Regex.Replace( // hate, nothing but hate, just hate, a lot of it, hate, hatred, many feelings, all unifying hate
						Environment.GetEnvironmentVariable("PATH") ?? "",
							'['+new string(Path.GetInvalidPathChars())+']', "")).Split(';'))
				{
					string p = v.Trim();
					if (!String.IsNullOrEmpty(p) && File.Exists(p = Path.Combine(p, e)))
						return Path.GetFullPath(p);
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
		return Regex.Unescape(f);
	}

	const bool coll = true; // color log

	enum SF { FO1, FO2, SP, Pow }
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
			if (a.Type == NoteType.Special && a.SpecialFlag == (int)s)
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
	// progress bars
	static short[] pbl; // lines to write to
	static void pb(float p, byte l) // update progress bar at that line
	{
		//Console.WriteLine(p);
		//Console.WriteLine(l);
		if (p < 0 || pbl[l] < 0)
			return;
		try
		{
			short lx, ly;
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
			//vl("Progress bar fail");
		}
	}
	static void ___(object p, DataReceivedEventArgs a)
	{
		if (a.Data != null)
		{
			if (a.Data.Trim().Length == 0) return;
			vl(a.Data);
		}
	}
	public static Process cmd(string fn, string a) //new headless process
	{
		Process n = new Process();
		n.StartInfo = new ProcessStartInfo()
		{
			FileName = fn, Arguments = a,
			UseShellExecute = false,
			RedirectStandardError = true,
			RedirectStandardOutput = true,
		};
		n.ErrorDataReceived += ___;
		n.OutputDataReceived += ___;
		return n;
	}
	public static string soxi(string f, string param)
	{
		try {
			string args = "--i " + param + " " + f.Quotes();
			//vl("soxi args: " + args);
			Process c = cmd(mt + "sox.exe", args);
			c.OutputDataReceived -= ___;
			//c.OutputDataReceived += (p, d) => __(d.Data, i);
			c.Start();
			c.BeginErrorReadLine();
			return c.StandardOutput.ReadToEnd();
			//if (!c.HasExited) // uhh
			//	c.WaitForExit();
		} catch { return null ; }
	}
	public static float alen(string f)
	{
		//try {
			return Convert.ToSingle(soxi(f, "-D") ?? "-1");
		//} catch { return -1f; }
	}
	public static int ach(string f)
	{
		//try {
			return Convert.ToInt32(soxi(f, "-c") ?? "2");
		//} catch { return 2; }
	}

	public static void ec(ref Process p, ushort ab, bool fr, ushort ar, bool fc, bool s, bool var)
	{
		ProcessStartInfo pi = p.StartInfo;
		string _ = " -b " + (ab << 1 /*ugh*/).ToString();
		if (fr)
			_ += " -r " + ar.ToString();
		if (fc)
			_ += " -c " + (s ? '2' : '1');
		if (var)
			_ += " -v ";
		pi.Arguments += _;
	}
	public static string ffmpeg = "";

	static void killtmpf(string path)
	{
		string tmpf = Path.GetTempPath() + "Z.FGH3.TMP\\";
		vl(path);
		if (NP(Path.GetDirectoryName(IF(path))) == NP(tmpf))
		{
			Directory.SetCurrentDirectory(folder);
			if (Directory.Exists(tmpf))
				Directory.Delete(tmpf, true);
		}
	}
	static void killtmpfsp(string path)
	{
		Match m = Regex.Match(Path.GetFileName(path), T[199], RegexOptions.IgnoreCase);
		if (m.Success)
			if (File.Exists(path))
				File.Delete(path);
	}
	// <s>subprocess</s>
	// entry point calling itself, because i'm lazy and my code is super hacky
	// and i refuse to move Main elsewhere or split the code up
	// into their own functions
	// can't believe i didn't realize to do this instead of spawning a new
	// process, but also i didn't realize to make main return int until recently
	static int sub(string arg)
	{
		return Main(new string[] { arg });
	}
	static int sub(string[] args)
	{
		return Main(args);
	}
#endregion

#region other helper things
	static DateTime unixstart = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
	static DateTime FromUnixTime(uint seconds)
	{
		return unixstart.AddSeconds(seconds);
	}
	static uint ToUnixTime(DateTime ts)
	{
		return (uint)(ts - unixstart).TotalSeconds;
	}

	public struct DAT
	{
		public uint streamCount;
		public uint fileSize; // doesn't matter (when it can be 0xFFFFFFFF)
		public struct DATEntry
		{
			public QbKey name;
			public uint index;
			// 3 padded ints
		}
		public DATEntry[] streams;
	}
	public static DAT LoadDAT(string f)
	{
		MemoryStream ms = new MemoryStream(File.ReadAllBytes(f));
		BinaryEndianReader br = new BinaryEndianReader(ms);
		DAT dat = new DAT();
		dat.streamCount = br.ReadUInt32(EndianType.Big);
		dat.fileSize = br.ReadUInt32(EndianType.Big);
		dat.streams = new DAT.DATEntry[dat.streamCount];
		for (int i = 0; i < dat.streamCount; i++)
		{
			dat.streams[i].name = QbKey.Create(br.ReadUInt32(EndianType.Big));
			dat.streams[i].index = br.ReadUInt32(EndianType.Big);
			ms.Position += 4*3;
		}
		br.Dispose();
		ms.Dispose();
		return dat;
	}
	/// <summary>
	/// Replace case insensitive occurrences.
	/// </summary>
	public static string ReplaceCI(this string v, string a, string b)
	{
		return Regex.Replace(v, Regex.Escape(a), b, RegexOptions.IgnoreCase);
	}
	/// <summary>
	/// Expand compact file dialog filter string
	/// </summary>
	public static string uf(string l, bool ga)
	{
		List<string> supportedtypes = new List<string>();
		string sb = "", idk = T[214].Substring(9, 3);
		bool first = true;
		foreach (string g in l.Split(';'))
		{
			string[] s = g.Split(':'), t = s[1].Split(',');
			supportedtypes.AddRange(t);
			if (!first || ga)
				sb += '|';
			if (first)
				first = false;
			sb += s[0] + idk + string.Join(";*.", t);
		}
		sb += T[214];
		if (ga)
			sb = T[213] + idk + string.Join(";*.", supportedtypes.ToArray()) + sb;
		return sb;
	}
	public static bool isTTY = false;
	static void pt(byte i)
	{
		log.WriteLine(T[15], T[7].Substring(i*13, 13));
	}

	[DllImport("kernel32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool AllocConsole();
	[DllImport("kernel32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool FreeConsole();

#if false
	// really ugly
	public static QbItemBase newItem(QbFile f, QbItemBase p, QbKey k, object v)
	{
		Type t = v.GetType();
		Type type_key = typeof(QbKey); // QbKey.Create(0x00000000);
		//Type type_key_array = type_key.MakeArrayType(); // (new QbKey[1] { empty }).GetType();
		Type type_itembase = typeof(QbItemBase);
		bool root = p == null;
		bool array = t.IsArray;
		bool valType = t.IsValueType;
		QbItemBase item = new QbItemQbKey(f);
		QbItemType type, array_type = root ? QbItemType.SectionArray : QbItemType.StructItemArray;
		item.ItemQbKey = k;
		if (array)
		{
			t = t.GetElementType();
			if (t.IsArray)
				throw new Exception(T[225]);
		}
		TypeCode tc = Type.GetTypeCode(t);
		if (t == type_key)
		{
			type = array ? QbItemType.ArrayQbKey : (root ? QbItemType.SectionQbKey : QbItemType.StructItemQbKey);
		}
		else
		{
			switch (tc)
			{
				case TypeCode.Boolean:
				case TypeCode.Byte:
				case TypeCode.Int16:
				case TypeCode.Int32:
				case TypeCode.UInt16:
				case TypeCode.UInt32:
				case TypeCode.SByte:
					type = array ? QbItemType.ArrayInteger : (root ? QbItemType.SectionInteger : QbItemType.StructItemInteger);
					break;
				case TypeCode.Single:
				case TypeCode.Double:
				case TypeCode.Decimal:
					type = array ? QbItemType.ArrayFloat : (root ? QbItemType.SectionFloat : QbItemType.StructItemFloat);
					break;
				case TypeCode.String:
				case TypeCode.Char:
					type = array ? QbItemType.ArrayString : (root ? QbItemType.SectionString : QbItemType.StructItemString);
					break;
				default:
					throw new Exception(T[224]);
			}
		}
		item.Create(type);
		switch (type)
		{
			case QbItemType.SectionQbKey:
			case QbItemType.SectionQbKeyString:
			case QbItemType.SectionQbKeyStringQs:
			case QbItemType.StructItemQbKey:
			case QbItemType.StructItemQbKeyString:
			case QbItemType.StructItemQbKeyStringQs:
				(item as QbItemQbKey).Values[0] = (QbKey)v;
				break;
			case QbItemType.SectionInteger:
			case QbItemType.StructItemInteger:
				(item as QbItemInteger).Values[0] = unchecked((int)v);
				break;
			case QbItemType.SectionFloat:
			case QbItemType.StructItemFloat:
				(item as QbItemFloat).Values[0] = (float)v;
				break;
			case QbItemType.SectionString:
			case QbItemType.StructItemString:
			case QbItemType.SectionStringW:
			case QbItemType.StructItemStringW:
				(item as QbItemString).Strings[0] = (string)v;
				break;
		}
		if (root)
			f.AddItem(item);
		else
			p.AddItem(item);
		return item;
	}
#endif
#endregion

	static bool outputPAK = false;
	static bool newinstance = false;
	static bool initlog = false;
	public static string version = "1.1-999011043";
	public static string branch = "main";
	public static DateTime builddate;
	[STAThread]
	public static int Main(string[] args)
	{
		// 36 KB
		try
		{
			inif = folder + "settings.ini";
#region NO ARGS ROUTINE
			try
			{
				isTTY =
					!(Console.WindowWidth <= 0 || Console.WindowHeight <= 0) &&
					!(Console.CursorLeft == 0 && Console.CursorTop == 0);
			}
			catch
			{
				isTTY = false;
			}
			if (args.Length == 0)
			{
				if (cfg(l, settings.t.NoStartupMsg.ToString(), 0) == 0)
				{
					//Console.Clear();
					Console.WriteLine(splashText);
					Console.ReadKey();
				}
				if (!isTTY)
					FreeConsole();
				OpenFileDialog openchart = new OpenFileDialog()
				{
					AddExtension = true,
					CheckFileExists = true,
					CheckPathExists = true,
					Filter = uf(T[130], true),
					RestoreDirectory = true,
					Title = T[196]
				};
				if (openchart.ShowDialog() == DialogResult.OK)
				{
					if (!isTTY)
						AllocConsole();
					// TODO?: process start and redirect output to this
					// EXE when MMF is figured out for multi instances
					return sub(openchart.FileName);
				}
				else
					return unchecked(0x11111111);
			}
#endregion
			Console.Title = title;
			// System.Reflection.Emit wat dis
			bool mic_ = cfg(l, "DisableMultiInstCheck", 0) == 0;
			// multi instance check
			// not working for one user
			// maybe admin related
			string exe = Application.ExecutablePath;
#region MULTI INSTANCE CHECK
			if (mic_)
			{
				Process[] mic = Process.GetProcessesByName(Path.GetFileNameWithoutExtension(exe));
				// who's going to rename this program
				//MessageBox.Show(mic.Length.ToString());
				if (mic.Length > 1)
					foreach (Process fgh3 in mic)
					{
						if (NP(fgh3.MainModule.FileName) ==
							NP(exe) &&
							fgh3.Id != Process.GetCurrentProcess().Id)
						{
							// can't check process arguments >:(
							// without some complicated WMI thing
							// unless (as i thought of using) i
							// use an MMF to indicate that a
							// song converting launcher is active
							// 1 or [0] = probably this process
							//if (micn > 1)
							int pid = cfg("Temp", "ConvPID", -1);
								if (pid > -1 && (File.Exists(args[0]) || args[0] == "dl"))
								{
									try
									{
										if (NP(Process.GetProcessById(pid).MainModule.FileName) == NP(exe))
										{
											MessageBox.Show(T[189], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
											return 0x4DF; // ERROR_ALREADY_INITIALIZED
										}
									}
									catch { }
									break;
								}
						}
					}
				else
					cfgW("Temp", "ConvPID", -1);
			}
			else
				print(T[190]);
#endregion
			retryExe:
			GH3EXEPath = NP(folder + "game" + (!File.Exists(GH3EXEPath) ? "!" : "") + ".exe");
			if (!File.Exists(GH3EXEPath))
			{
				if (MessageBox.Show(T[209], "Error",
					MessageBoxButtons.RetryCancel, MessageBoxIcon.Error,
					MessageBoxDefaultButton.Button1) == DialogResult.Retry)
					goto retryExe;
				return 1;
			}
			outputPAK = cfg(l, "OutputQB", 1) == 0; // where possible
			vb = cfg(l, settings.t.VerboseLog.ToString(), 0) == 1;

			// guessing people just don't migrate their
			// config/user files when updating to a later version?
			// or don't use the updater at all???? (it kind of sucks anyway)

			vl(T[0]);
			caching = cfg(l, settings.t.SongCaching.ToString(), 1) == 1;
			if (caching)
			{
				Directory.CreateDirectory(cf);
				cachf = cf + ".db.ini";
			}
			if (args.Length < 1)
				throw new Exception(string.Format(T[219], args.Length));
			// combine logs from any of 3 processes to easily look for errors from all of them
			try
			{
				builddate = FromUnixTime(Eswap(BitConverter.ToUInt32(File.ReadAllBytes(mt + "bt.bin"), 0)));
				// a person legitimately had this file missing, how is that even possible >:(
			}
			catch { builddate = DateTime.MinValue; }
			bool newfile = cfg("Temp", fl, 1) == 1;
			string arg0 = args[0];
			if (!Regex.IsMatch(arg0.ToLower(), T[220], RegexOptions.IgnoreCase | RegexOptions.Singleline))
				if (wl && log == null)
				{
					// half kb?
					if (newfile)
					{
						if (File.Exists(folder + "launcher.txt"))
							File.Delete(folder + "launcher.txt");
					}
					log = new StreamWriter(folder + "launcher.txt", !newfile);
					log.NewLine = "\n"; // \r causing inconsistencies with multiline strings
					initlog = true;
					if (newfile)
					{
						log.WriteLine(T[1]+new string('-',32));
						log.WriteLine("version " + version + " / build time: " + builddate + " / branch: " + branch);
						newfile = false;
						cfgW("Temp", fl, 0);
					}
				}
			//throw new Exception("dummy");
			string chartext = ".chart", midext = ".mid",
				paksongmid = pakf + "song" + midext,
				paksongchart = pakf + "song" + chartext,
				songpak = pakf + "song.pak.xen",
				songqb = pakf + "song.qb.xen",
				fsb = music + "fastgh3.fsb.xen",
				dat = music + "fastgh3.dat.xen";
			ConsoleColor cacheColor = ConsoleColor.Cyan,
				chartConvColor = ConsoleColor.Green,
				bossColor = ConsoleColor.Blue,
				FSBcolor = ConsoleColor.Yellow,
				FSPcolor = ConsoleColor.Magenta;
			if (arg0.StartsWith("-")) // non main routines
			{
				switch (arg0.Substring(1).ToLower())
				{
					case "settings":
						// muh classic theme
						//Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
						if (!isTTY && !vb)
							FreeConsole();
						Directory.SetCurrentDirectory(folder);
						new settings().ShowDialog();
						// settings file 31kb
						return 0;
					case "shuffle":
						// 0.5-1 kb
						Console.WriteLine(T[101]);
						List<string> paths, files;
						paths = new List<string>();
						string curpath;
						int j = 0;
						string p;
						while ((p = cfg("Shuffle", "path" + (++j).ToString(), "")) != "")
						{
							curpath = NP(p);
							if (Directory.Exists(curpath) && paths.IndexOf(curpath) == -1)
								paths.Add(curpath);
							else if (!Directory.Exists(curpath))
								vl(T[166] + p);
						}
						if (paths.Count == 0)
						{
							MessageBox.Show(T[2], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
							exit();
							return 1;
						}
						vl("added paths (" + paths.Count + ')');
						Random rand = new Random((int)DateTime.Now.Ticks);
						string randpath = paths[rand.Next(paths.Count - 1)];
						files = new List<string>();
						files.AddRange(Directory.GetFiles(randpath, "*.chart", SearchOption.AllDirectories));
						files.AddRange(Directory.GetFiles(randpath, "*.mid", SearchOption.AllDirectories));
						files.AddRange(Directory.GetFiles(randpath, "*.fsp", SearchOption.AllDirectories));
						vl("added files");
						if (files.Count == 0)
						{
							MessageBox.Show(T[3], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
							exit();
							return 1;
						}
						int choose = rand.Next(files.Count);
						print("Choosing: " + files[choose]);
						return sub(files[choose]);
						//die();
					case "gfxswap":
						// 0.5-1 kb?
						// TODO: replace SCN with one that has the name of the .tex
						if (args.Length < 3)
						{
							Console.WriteLine(T[221]);
							Console.ReadKey();
							return 1;
						}
						bool[] tests = new bool[] {
							!File.Exists(args[1]) || !File.Exists(args[2]),
							!args[2].EndsWith(".pak.xen")
						};
						for (var i = 0; i < tests.Length; i++)
							if (tests[i])
							{
								Console.WriteLine(T[221+1+i]);
								Console.ReadKey();
								return 1;
							}
						//string defaultscn = dataf + "zones\\default.scn.xen";
						PakFormat pf = new PakFormat(args[2], args[2].ReplaceCI(".pak.xen", ".pab.xen"), "", PakFormatType.PC);
						PakEditor pe = new PakEditor(pf, false);
						if (args[1].EndsWith(".zip"))
						{
							ZipFile zip =
#if !USE_SZL
								ZipFile.Read(args[1])
#else
								new ZipFile(args[1])
#endif
							;
							MemoryStream gfx = null, scn = null;
							// expecting .gfx and .scn in these
							foreach (ZipEntry file in zip)
							{
#if !USE_SZL
								string fn = file.FileName.ToLower();
								int sz = (int)file.UncompressedSize;
#else
								if (!file.IsFile)
									continue;
								string fn = file.Name.ToLower();
								long sz = file.Size;
								var s = zip.GetInputStream(file);
#endif
								//Console.WriteLine(file.FileName);
								if ((fn.EndsWith(".gfx.xen") ||
									fn.EndsWith(".tex.xen") ||
									fn.EndsWith(".gfx") ||
									fn.EndsWith(".tex")) &&
									gfx == null)
								{
									Console.WriteLine("found");
									gfx = new MemoryStream((int)sz);
#if !USE_SZL
									file.Extract(gfx);
#else
									s.CopyTo(gfx);
#endif
								}
								if ((fn.EndsWith(".scn.xen") ||
									fn.EndsWith(".scn")) &&
									scn == null)
								{
									Console.WriteLine("found");
									scn = new MemoryStream((int)sz);
#if !USE_SZL
									file.Extract(scn);
#else
									s.CopyTo(scn);
#endif
								}
#if USE_SZL
								s.Dispose();
#endif
							}
							if (gfx == null)
							{
								// "Cannot find a file indicating of containing highway GFX."
								MessageBox.Show(T[222], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
								return 1;
							}
							// someone actually tried dragging default.scn into this
							// maybe should prevent that here, idk
							pe.ReplaceFile(string.Format(T[205], ".tex"), gfx.ToArray());
							if (scn != null)
							{
								pe.ReplaceFile(string.Format(T[205], ".scn"), scn.ToArray());
							}
							else
								pe.ReplaceFile(string.Format(T[205], ".scn"), defscn);
#if USE_SZL
							zip.Close();
#endif
						}
						else
						{
							pe.ReplaceFile(string.Format(T[205], ".tex"), args[1]);
							string target = args[1].ReplaceCI(".tex", ".scn").ReplaceCI(".gfx", ".scn");
							if (File.Exists(target))
							{
								pe.ReplaceFile(string.Format(T[205], ".scn"), target);
							}
							else
								pe.ReplaceFile(string.Format(T[205], ".scn"), defscn);
						}
						return 0;
					default:
						MessageBox.Show("Unknown option: "+arg0, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
						return 1;
				}
			}
#region DOWNLOAD SONG
			if (arg0 == "dl" && (args[1] != "" || args[1] != null))
			{
				cfgW("Temp", "ConvPID", Process.GetCurrentProcess().Id);
				// 2kb
				if (Environment.GetEnvironmentVariable("FASTGH3_BANNER") != "1")
				{
					Console.WriteLine(title + " by donnaken15");
					newinstance = true;
				}
				Environment.SetEnvironmentVariable("FASTGH3_BANNER", "1");
				pt(1); // "\n######### DOWNLOAD SONG PHASE #########\n"
				print(T[8], FSPcolor); // "Downloading song package..."
				vl("URL: " + args[1], FSPcolor);
				bool datecheck = true;
				Uri fsplink = new Uri(args[1].ReplaceCI("fastgh3://", "http://"));
				string cs = ""; // ...
				string uC = "";
				string tF = "null";
				string adf = T[9]; // "already downloaded file." // desperate
				string fdp = " file date. ";
				vl(fsplink.AbsoluteUri, FSPcolor);
				if (caching)
				{
					cs = "URL" + WZK64.Create(fsplink.AbsoluteUri).ToString("X16");
					uC = ini(cs, "File", "", 65, cachf);
					if (uC != "")
					{
						print("Found " + adf, FSPcolor);
						vl(cs);
						vl(uC);
						tF = uC;
						if (!datecheck)
							goto skipToGame;
					}
					if (datecheck)
						print(T[10], FSPcolor);
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
						lastmod_cached = new DateTime(Convert.ToInt64(ini(cs, "Date", "0", cachf)));
					else
						lastmod_cached = new DateTime(0);
					if (lastmod_cached.Ticks == 0)
						vl(T[11], cacheColor); // "Date not cached"
					else
						vl("Cached date: " + lastmod_cached.ToUniversalTime(), cacheColor);
					if (fsp.ResponseHeaders["Last-Modified"] != null)
					{
						//verboseline(fsp.ResponseHeaders["Last-Modified"]);
						lastmod = DateTime.Parse(fsp.ResponseHeaders["Last-Modified"]);
						vl("Got file date: " + lastmod.ToUniversalTime(), cacheColor);
						if (lastmod.Ticks == lastmod_cached.Ticks && lastmod_cached.Ticks != 0)
						{
							vl("Unchanged" + fdp + "Using " + adf, cacheColor);
							tF = ini(cs, "File", "null", cachf);
							goto skipToGame;
						}
						else
						{
							if (lastmod.Ticks == 0)
								print("Different" + fdp + "Redownloading...", cacheColor);
						}
					}
					else
					{
						print("No file date found.", cacheColor);
						if (uC != "")
						{
							print("Using " + adf, cacheColor);
							goto skipToGame;
						}
					}
				}
				if (Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]) > 1024 * 1024 * 24)
				{
					// i dare use Format once for optimized strings "This song package is a larger file than usual. ({0} MB) Do you want to continue?"
					if (MessageBox.Show(string.Format(T[12],
						Math.Round((Convert.ToSingle(Convert.ToUInt64(fsp.ResponseHeaders["Content-Length"]))) / 1024 / 1024), 2),
						"Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
					{
						exit();
						return 2;
					}
				}
				//if (settings.GetKeyValue("Player", "MaxNotesAuto", "0") == "1")
				//settings.SetKeyValue("Player", "MaxNotes", 0x100000.ToString());
				if (File.Exists(tF)) // do this?
					File.Delete(tF);
				tF = Path.GetTempFileName();
				string tmpFl = Path.GetTempPath();
				fsp.DownloadFile(fsplink, tF);
				{
					Stream testmagic = File.OpenRead(tF);
					BinaryReader br = new BinaryReader(testmagic, Encoding.ASCII);
					string magic = new string(br.ReadChars(6));
					testmagic.Close();
					br.Dispose();
					File.Move(tF, tF += (magic == "SNGPKG" ? ".sng" : ".fsp"));
				}
				//Directory.CreateDirectory(tmpFl + "\\Z.TMP.FGH3$WEB");
				if (caching)
				{
					print(T[13], cacheColor); // "Writing link to cache..."
					iniw(cs, "File", tF.ToString(), cachf);
					if (datecheck)
					{
						print(T[14], cacheColor); // "Writing date to cache..."
						iniw(cs, "Date", lastmod.Ticks.ToString(), cachf);
					}
				}
				skipToGame:
				// download FSP --> open and extract FSP --> convert song --> game
				// FastGH3.exe  --> FastGH3.exe          --> FastGH3.exe  --> game.exe
				// :P
				//GC.Collect();
				// "already running" >:(
				return sub(tF);
				//die();
			}
#endregion
#region GOT LOCAL FILE
			else if (File.Exists(arg0))
			{
				if (Path.GetDirectoryName(arg0) == "")
					arg0 = Directory.GetCurrentDirectory() + '\\' + arg0;
				cfgW("Temp", "ConvPID", Process.GetCurrentProcess().Id);
				//bool relfile = false;
				try
				{
					Directory.SetCurrentDirectory(Path.GetDirectoryName(arg0));
				}
				catch
				{
					//relfile = true;
					try
					{
						Directory.SetCurrentDirectory(Path.GetPathRoot(arg0));
					}
					catch
					{

					}
					//Console.WriteLine(Path.GetPathRoot(arg0));
				}
				try
				{
#if !SHARPDEV // can't use on #develop
					Shell sh = new Shell();
					Folder dir = sh.NameSpace(Path.GetDirectoryName(arg0));
					FolderItem fI = dir.ParseName(Path.GetFileName(arg0));
					if (fI != null)
					{
						if (fI.IsLink)
						{
							ShellLinkObject lnk = (ShellLinkObject)fI.GetLink;
							arg0 = lnk.Path;
						}
					}
#endif
				}
				catch (Exception ex) { vl(ex); }
#region STANDARD ROUTINE
				string ext = Path.GetExtension(arg0).ToLower();
				if (Environment.GetEnvironmentVariable("FASTGH3_BANNER") != "1")
				{
					Console.WriteLine(title + " by donnaken15");
					newinstance = true;
				}
				Environment.SetEnvironmentVariable("FASTGH3_BANNER", "1");
				if (ext == chartext || ext == midext)
				{
					bool ischart = false;
					pt(0); // "\n######### MAIN LAUNCHER PHASE #########\n"
					vl("File is: " + arg0);
					string[] m2cA = new string[]
					{
						paksongmid, "-k", "-u", "-p", "-m"
					};
					print(T[16], chartConvColor); // "Reading file."
					if (ext == chartext)
					{
						vl(T[17], chartConvColor); // "Detected chart file."
						ischart = true;
					}
					else if (ext == midext || ext == (midext + 'i'))
					{
						vl(T[18], chartConvColor); // "Detected midi file."
						vl(T[19], chartConvColor); // "Converting to chart..."
						// why isnt this working
						//mid2chart.ChartWriter.writeChart(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])), folder + pak + "tmp.chart", false, false);
						//Console.WriteLine(mid2chart.MidReader.ReadMidi(Path.GetFullPath(args[0])).sections[0].name);
						//Console.ReadKey();
						File.Copy(arg0, paksongmid, true);
						vl(T[135]);
						mid2chart.Program.Main(m2cA);
						// im suffering so hard
						//if (!File.Exists(paksongchart))
						{
							//throw m2cE;
							//throw new Exception("Cannot find chart after converting from MIDI. Something must've went wrong with mid2chart. Aborting.");
						}
					}
					if (caching)
					{
						vl(T[21], cacheColor);
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
						chart.Load(arg0);
					}
					else chart.Load(paksongchart);
					if (File.Exists(paksongmid))
						File.Delete(paksongmid);
					if (File.Exists(paksongchart))
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
#region ENCODE SONGS
					print(T[22], FSBcolor);
					//print("Encoding song.", FSBcolor);
					vl(T[23], FSBcolor);
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
					int type_count = audextnames.Length;
					// if Stream values above can't be found, check if audio name matching chart exists
					for (int i = 0; i < type_count; i++)
					{
						if (!File.Exists(audiostreams[0]))
						{
							audtmpstr = chf + Path.GetFileNameWithoutExtension(arg0) + '.' + audextnames[i];
							if (File.Exists(audtmpstr))
							{
								vl(T[24], FSBcolor); //vl("Found audio with the chart name", FSBcolor);
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
							for (int j = 0; j < type_count; j++)
							{
								audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
								if (File.Exists(audtmpstr))
								{
									vl(T[25] + audstnames[i], FSBcolor); //vl("Found FOF structure files / " + audstnames[i], FSBcolor);
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
							for (int j = 0; j < type_count; j++)
							{
								audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
								if (File.Exists(audtmpstr))
								{
									vl(T[25] + audstnames[i], FSBcolor); //vl("Found FOF structure files / " + audstnames[i], FSBcolor);
									audiostreams[i + 1] = audtmpstr;
									break;
								}
							}
					}
					// TODO: allow NJ3T routine even when song.ogg exists
					bool nj3t = false; // nj3ts.Count smh // "3 Count!"
					List<string> nj3ts = new List<string>();
					vl(T[26], FSBcolor); //vl("Checking if extra audio exists", FSBcolor);
					// numbered drum streams
					for (int j = 0; j < type_count; j++)
					{
						for (int i = 1; i < 9; i++)
						{
							audtmpstr = chf + "drums_" + i + '.' + audextnames[j];
							if (File.Exists(audtmpstr))
							{
								vl(T[27] + i + ')', FSBcolor); //vl("Found isolated drums audio (" + i + ')', FSBcolor);
								nj3t = true;
								nj3ts.Add(audtmpstr);
							}
						}
					}
					// also maybe ignore drums.ogg if numbered files exist
					// numbered vocal streams
					for (int j = 0; j < type_count; j++)
					{
						audtmpstr = chf + "vocals." + audextnames[j];
						if (File.Exists(audtmpstr))
						{
							vl(T[28], FSBcolor); //vl("Found isolated vocals audio", FSBcolor);
							nj3t = true;
							nj3ts.Add(audtmpstr);
							break;
						}
					}
					audstnames = new string[] { "drums", /*"vocals",*/ "keys", "song" };
					for (int i = 0; i < audstnames.Length; i++)
					{
						for (int j = 0; j < type_count; j++)
						{
							audtmpstr = chf + audstnames[i] + '.' + audextnames[j];
							if (File.Exists(audtmpstr))
							{
								vl(T[25] + audstnames[i], FSBcolor);
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
					string blankmp3 = mt + "blank.mp3";
					if (!nj3t)
					{
						// CH sucks
						if (!File.Exists(audiostreams[0]) ||
							Path.GetFileName(NP(audiostreams[0])).ToLower() == "guitar.ogg")
						{
							for (int i = 0; i < type_count; i++)
							{
								audtmpstr = chf + "guitar" + '.' + audextnames[i];
								//vl(audtmpstr);
								if (File.Exists(audtmpstr))
								{
									vl("Found cringe compatibility", FSBcolor);
									audiostreams[0] = audtmpstr;
									audiostreams[1] = blankmp3;
									break;
								}
							}
						}
					}
					vl(T[29], FSBcolor); //vl("Current selected audio streams are:", FSBcolor);
					foreach (string a in audiostreams)
						vl(a, FSBcolor);
					if (!File.Exists(audiostreams[0]) && !nj3t)
					{
						//vl("Failed to get main song file, asking user what the game should do", FSBcolor);
						DialogResult audiolost, playsilent = DialogResult.No, searchaudioresult = DialogResult.Cancel;
						OpenFileDialog searchaudio = new OpenFileDialog()
						{
							// support online URLs in input text box?
							CheckFileExists = true,
							CheckPathExists = true,
							InitialDirectory = Path.GetDirectoryName(arg0),
							Filter = uf(T[167], false)
						};
						do
						{
							audiolost = MessageBox.Show(T[30], "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
							//audiolost = MessageBox.Show("No song audio can be found.\nDo you want to search for it?", "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
							if (audiolost == DialogResult.Cancel)
							{
								exit();
								return 0;
							}
							if (audiolost == DialogResult.Yes)
							{
								searchaudioresult = searchaudio.ShowDialog();
								if (searchaudioresult == DialogResult.OK)
								{
									// TODO: OPTIMIZE!!!!!
									//vl("User responded with " + SubstringExtensions.EncloseWithQuoteMarks(searchaudio.FileName), FSBcolor);
									audiostreams[0] = searchaudio.FileName;
									playsilent = DialogResult.OK;
									if (!File.Exists(audiostreams[1]))
									{
										retryguitaraud:
										DialogResult audiolosthasguitartrack = MessageBox.Show(T[168], "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
										if (audiolosthasguitartrack == DialogResult.Yes)
										{
											searchaudio.FileName = "";
											searchaudio.ShowDialog();
											if (searchaudio.FileName != string.Empty)
											{
												audiostreams[1] = searchaudio.FileName;
											}
											else
												goto retryguitaraud;
										}
										else
											audiostreams[1] = blankmp3;
									}
									if (!File.Exists(audiostreams[2]))
									{
										retrybassaud:
										if (MessageBox.Show(T[169], "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1) == DialogResult.Yes)
										{
											searchaudio.FileName = "";
											searchaudio.ShowDialog();
											if (searchaudio.FileName != string.Empty)
											{
												audiostreams[2] = searchaudio.FileName;
											}
											else
												goto retrybassaud;
										}
										else
											audiostreams[1] = blankmp3;
									}
								}
							}
							if (audiolost == DialogResult.No || searchaudioresult == DialogResult.Cancel || !File.Exists(searchaudio.FileName))
							{
								playsilent = MessageBox.Show(T[31], "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
								//playsilent = MessageBox.Show("Want to play without audio?\nThis is not compatible with practice mode.", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
								if (playsilent == DialogResult.Yes)
								{
									vl(T[170], FSBcolor);
									audiostreams[0] = blankmp3;
								}
							}
						}
						while (playsilent == DialogResult.No);
					}
					for (int i = 0; i < 3; i++)
						if (!File.Exists(audiostreams[i]))
						{
							audiostreams[i] = blankmp3;
						}
					//im stupid
					//this cache stuff is a mess
					ulong charthash = WZK64.Create(File.ReadAllBytes(arg0));
					if (File.Exists("boss.ini"))
					{
						charthash ^= WZK64.Create(File.ReadAllBytes("boss.ini"));
					}

					// hate me*
					bool isBoss = false,
						gotBossScr = false,
						boss_useSP = true,
						boss_defProps = true;

					string bini = "boss.ini";
					isBoss = ini("boss", "enable", 0, bini) == 1; // not letting you off easy with a blank ini lol

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
#if STFSB
					Process fsbbuild = new Process();
#else
					Process[] fsbbuild2 = new Process[3]; // 3 async encoders
					Process fsbbuild3 = new Process(); // makefsb part
#endif
					//const bool MTFSB = true; // enable asynchronous audio track encoding
					//if (cacheEnabled)
					pbl = new short[3] { -1, -1, -1 };
					float[] al = new float[3] { -1, -1, -1 };
					killgame();
					string CMDpath = where("cmd.exe");
					if (CMDpath == "") // somehow someone got an error of a process starting
						CMDpath = "C:\\windows\\system32\\cmd.exe"; // assuming its one of these building scripts
					try
					{
						if (Directory.Exists(mt + "fsbtmp"))
							Directory.Delete(mt + "fsbtmp", true);
					}
					catch (Exception e)
					{
						vl(T[32]);
						//print("Failed to delete the temp FSB folder!");
						vl(e);
					}
					TimeSpan audioConv_start = time, audioConv_end = time;
					ushort AB_param = 64, AR_param = 32000;
					bool stereo = true;
					bool forcestereoopt = false;
					bool[] is_stereo = { false, false, false };
					if (!audCache)
					{
						ffmpeg = where("ffmpeg.exe");
						AB_param = (ushort)(cfg("Audio", "AB", 128) >> 1/*thx helix*/);
						AR_param = Math.Max(Math.Min(
							(ushort)cfg("Audio", "SampRate", AB_param),
							(ushort)48000
						), (ushort)32000);
						{
							int forcech = (cfg("Audio", "ForceChannels", 0));
							if (forcech > 0)
								forcestereoopt = true;
							if (forcestereoopt)
								stereo = (forcech > 1);
						}
						if (AB_param == 0) AB_param = 64; // i hate myself
						AB_param = Math.Max(AB_param, (ushort)24); // AB > 48 ? AB : 48
						bool VBR = (cfg("Audio", "VBR", 0) != 0);
						audioConv_start = time;
						if (caching)
							print(T[136], cacheColor);
						if (nj3t)
						{
							print(T[33], FSBcolor);
							//print("Found more than three audio tracks, merging.", FSBcolor);
							addaud = cmd(CMDpath, (mt + "nj3t.bat").Quotes());
							float maxl = 0;
							foreach (string a in nj3ts)
							{
								addaud.StartInfo.Arguments += " \"" + a + '"';
								maxl = Math.Max(maxl, alen(a));
								if (ach(a) > 1)
									is_stereo[0] = true;
							}
							al[0] = maxl;
							addaud.StartInfo.EnvironmentVariables["ff"] = ffmpeg;
							addaud.StartInfo.EnvironmentVariables["ab"] = (AB_param << 1 /*why*/).ToString();
							addaud.StartInfo.EnvironmentVariables["ar"] = AR_param.ToString();
							addaud.StartInfo.EnvironmentVariables["ac"] = is_stereo[0] ? "2" : "1";
							addaud.StartInfo.EnvironmentVariables["bm"] = VBR ? "V" : "B";
							addaud.StartInfo.WorkingDirectory = mt;
							addaud.StartInfo.Arguments = "/c " + addaud.StartInfo.Arguments.Quotes();
							addaud.Start();
							if (vb || wl)
							{
								addaud.BeginErrorReadLine();
								addaud.BeginOutputReadLine();
							}
							vl("merge args: sox " + addaud.StartInfo.Arguments, FSBcolor);
							audiostreams[0] = mt + string.Format(T[171], "song");
							//fsbbuild.StartInfo.FileName += '2';
#if STFSB
							if (!addaud.HasExited)
								addaud.WaitForExit();
#endif
						}
						vl(T[34], FSBcolor);
						//vl("Creating encoder process...", FSBcolor);
#if STFSB
						fsbbuild = cmd(CMDpath, null);
						fsbbuild.StartInfo.WorkingDirectory = mt;
#else
						Directory.CreateDirectory(mt + "fsbtmp");
						File.Copy(blankmp3, mt + string.Format(T[171], "preview"), true);
						string[] fsbnames = { "song", "guitar", "rhythm" };
						for (int i = 0; i < fsbbuild2.Length; i++)
						{
							string a_s = audiostreams[i];
							if ((i != 0 && nj3t) || i > 0 || (i == 0 && !nj3t)) // wtf
							{
								al[i] = alen(a_s);
								is_stereo[i] = ach(a_s) > 1;
							}
							fsbbuild2[i] = cmd((mt + "c128ks.exe"), a_s.Quotes() +
									' ' + (mt + string.Format(T[171], fsbnames[i])).Quotes() + " -p");
							fsbbuild2[i].StartInfo.WorkingDirectory = mt;
							if (forcestereoopt)
								is_stereo[i] = stereo;
							ec(ref fsbbuild2[i], AB_param, true, AR_param, forcestereoopt, is_stereo[i], VBR);
							vl("MP3 args: c128ks " + fsbbuild2[i].StartInfo.Arguments, FSBcolor);
						}
						fsbbuild3 = cmd(CMDpath, "/c " + ((mt + "fsbbuild.bat").Quotes()));
						fsbbuild3.StartInfo.WorkingDirectory = mt;
#endif
						//vl((MTFSB ? "As" : "S") + T[35], FSBcolor);
						vl(T[36], FSBcolor);
						//v("ynchronous mode set\n", FSBcolor);
						//vl("Starting FSB building...", FSBcolor);
						if (!nj3t)
							audioConv_start = time;
#if STFSB
						fsbbuild.StartInfo.WorkingDirectory = mt;
						ec(ref fsbbuild, AB_param, true, AR_param, true, true, VBR);
						fsbbuild.StartInfo.Arguments =
							"/c " + ((mt + "fsbbuild.bat").Quotes() + ' ' +
							audiostreams[0].Quotes() + ' ' +
							audiostreams[1].Quotes() + ' ' +
							audiostreams[2].Quotes() + ' ' +
							(blankmp3).Quotes() + ' ' + fsb.Quotes()).Quotes();
						vl("MP3 args: c128ks " + fsbbuild.StartInfo.Arguments, FSBcolor);
						// random TODO i just thought: create a function
						// based on string[] that converts it to a
						// singular string for arguments and check spaces
						fsbbuild.Start();
						if (vb || wl)
						{
							fsbbuild.BeginErrorReadLine();
							fsbbuild.BeginOutputReadLine();
						}
#else
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
#endif
					}
					else
					{
						print(T[37], FSBcolor);
						//print("Cached audio found.", FSBcolor);
						try
						{
							File.Copy(cf + audhash.ToString("X16"), fsb, true);
							File.WriteAllBytes(dat, fsbdat);
							// shows i need to severely rewrite how FSB is created
						}
						catch (IOException e)
						{
							print(T[38]);
							//print("Failed to copy cached FSB. WHY?!!!");
							print(e);
							vl(T[172]);
							uint i = 0;
							foreach (Process p in Process.GetProcessesByName(Path.GetFileNameWithoutExtension(exe)))
							{
								vl(NP(exe) + " == " + NP(p.MainModule.FileName));
								i++;
							}
							if (i < 1)
							{
								vl("Found no other processes");
							}
							//print("Attempting to kill game if \"it is used by another process\" somehow.");
							//disallowGameStartup();
							print(T[39]);
							//print("Deleting the currently loaded FSB in case.");
							if (File.Exists(fsb))
								File.Delete(fsb);
							File.Copy(cf + audhash.ToString("X16"), fsb, true);
							File.WriteAllBytes(dat, fsbdat);
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
							print(T[40], cacheColor);
						//print("Chart is not cached.", cacheColor);
						//print("Generating QB template.", chartConvColor);
						//vl("Creating new QB files...", chartConvColor);
						killgame();
						byte[] __ = new byte[0xB0], pn = Launcher.pn, qn = Launcher.qn;
						if (File.Exists(songqb))
							File.Delete(songqb);
						if (outputPAK)
						{
							Array.Copy(pn, 0, __, 0, pn.Length);
							Array.Copy(qn, 0, __, 0x80, qn.Length);
							File.WriteAllBytes(songpak, __);
						}
						//vl("Creating pak editor...", chartConvColor);
						print(T[41], chartConvColor);
						//print("Opening song pak.", chartConvColor);
						PakFormat PF = new PakFormat(outputPAK ? songpak : "", "", "", PakFormatType.PC);
						PakEditor build = null;
						if (outputPAK)
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
									vl(T[42], ConsoleColor.Red);
									build = new PakEditor(PF, false);
								}
								catch
								{
									vl(T[43], ConsoleColor.Red);
									File.Move(pakf + "dbg.pak.xen", pakf + "dbg.pak.xen.bak");
									build = new PakEditor(PF, false);
									// if even after this it fails, look for god
								}
							}
						print(T[44], chartConvColor);
						//print("Compiling chart.", chartConvColor);
						//vl("Creating QbFile using PakFormat", chartConvColor);
						Stream newqb = new MemoryStream(qn);
						QbFile mid = new QbFile(newqb, PF);
#region BUILD ENTIRE QB FILE
#region GUITAR VALUES

						OffsetTransformer OT = new OffsetTransformer(chart);
						string[] td = { "Easy", "Medium", "Hard", "Expert" };
						string[] ti = { "Single", "DoubleBass", "DoubleGuitar", "Double"+(isBoss?"Bass":"Rhythm") }; // *

						vl(T[45], chartConvColor);
						//vl("Creating note arrays...", chartConvColor);
						string[] diffs = { "easy", "medium", "hard", "expert" };
						string[] insts = { "", "_rhythm", "_guitarcoop", "_rhythmcoop" };
						string[] tracknames = { "guitar", "rhythm", "guitarcoop", "rhythmcoop" };
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

						bool atleast1track = false;

						int delay = 0;
						try
						{
							if (chart.Song["Offset"] != null) // ugh
								delay = Convert.ToInt32(float.Parse(chart.Song["Offset"].Value) * 1000);
						}
						catch
						{
							// guessing this is fixed now???
						}
						QbcNoteTrack tmp;

						QbItemArray scrs = new QbItemArray(mid);
						scrs.Create(QbItemType.SectionArray);
						QbItemStructArray scr_arr = new QbItemStructArray(mid);
						scrs.ItemQbKey = QbKey.Create(0x195F3B95); // fastgh3_scripts
						scr_arr.Create(QbItemType.ArrayStruct);
						List<QbItemStruct> scripts = new List<QbItemStruct>();
						bool[] hasCoopTracks = { false, false };


						QbKey[] global_events = {
							QbKey.Create(0xFF03CC4E), // end
							QbKey.Create(0x2DE8C60E), // printf
							QbKey.Create(0xBE304E86), // printstruct
							QbKey.Create(0xF0CF92C0) // boss_battle_begin_deathlick
						};
						QbKey[] track_events = {
							QbKey.Create(0xF0FFFBEE), // solo
							QbKey.Create(0x868BC002), // soloend
							QbKey.Create(0x2DE8C60E), // printf
							QbKey.Create(0xBE304E86), // printstruct
						};

						int dd = 0;
						int ii = 0;
						// TODO: use stringpointer for lower difficulties to redirect to
						// least difficult authored note track if lower ones aren't authored
						//
						// so like if an easy chart doesn't exist but hard
						// and expert charts do, easy redirects to the hard chart
						// and so space is saved from having dupe note tracks, and not
						// have the awkardness of a blank difficulty track
						foreach (string i in ti)
						{
							dd = 0;
							foreach (string d in td)
							{
								vl("Checking " + d + i, chartConvColor);
								if (chart.NoteTracks[d + i] != null)
								{
									atleast1track = true;
									if (i == "DoubleGuitar")
										hasCoopTracks[0] = true;
									if (i == "DoubleBass")
										hasCoopTracks[1] = true;
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
										vl(T[46] + d + i, ConsoleColor.Yellow);
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
											if (Array.IndexOf(track_events, eventKey) < 0)
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
											newScript.AddItem(t);
											newScript.AddItem(s);
											if (ii != 0 || dd != 0)
											{
												QbItemStruct p = new QbItemStruct(mid);
												p.Create(QbItemType.StructItemStruct);
												p.ItemQbKey = QbKey.Create(0x7031F10C);
												// i'm getting desperate at shortening these names for tipping over the 512 byte difference
												// and for the fact that WHY DO THESE THINGS NEED NAMES IN THE EXE WHEN IT SHOULD BE OPTIMIZED
												// NB: C# does not do this for localized vars

												// wish there was a simpler way to make these objects WHY DON'T I CODE A FUNCTION FOR IT!!
												if (ii != 0)
												{
													QbItemQbKey pp = new QbItemQbKey(mid);
													pp.Create(QbItemType.StructItemQbKey);
													pp.ItemQbKey = QbKey.Create(0xB6F08F39);
													pp.Values[0] = QbKey.Create(tracknames[ii]);
													p.AddItem(pp);
												}
												if (dd != 0)
												{
													QbItemQbKey di = new QbItemQbKey(mid);
													di.Create(QbItemType.StructItemQbKey);
													di.ItemQbKey = QbKey.Create(0xBA8FB854);
													di.Values[0] = QbKey.Create(diffs[dd]);
													p.AddItem(di);
												}
												newScript.AddItem(p);
											}
											/*
											example struct

											event = {
												name = solo,
												time = 4000,
												params = {
													part = guitar, // redundant when default is expert guitar
													diff = expert
												}
											}
											*/
											scripts.Add(newScript);
										}
									}
									catch (Exception ex)
									{
										vl(T[47] + d + i, ConsoleColor.Yellow);
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
#if STFSB
							if (!fsbbuild.HasExited)
								fsbbuild.Kill();
#else
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
							return 1;
#endif
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
						vl(T[48], chartConvColor);
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
												print(T[129], ConsoleColor.Yellow);
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
						vl(T[49], chartConvColor);
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
									vl(T[50] + i + "][" + d + "]");
									//vl("Unable to get the end time for a note track ["+i+"]["+d+"]");
								}
								vl(T[51] + et, chartConvColor);
								//vl("Calculating: end time so far: " + et, chartConvColor);
							}
						}
						vl(T[52] + et, chartConvColor);
						//vl("End time is " + et, chartConvColor);
#endregion


#region BOSS PROPS
						vl(T[53], bossColor);
						//vl("Reading boss props...");

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
							QbKey.Create(0xFE41960D), // uhhhh
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
							vl(T[54], bossColor);
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
							if (e == null) { vl(T[173]); continue; } // wtf
							if (e.TextValue == null) { vl(T[174]); continue; } // wtf
							QbKey eventKey = QbKey.Create(e.TextValue);
							if (e.TextValue.ToLower().StartsWith("section "))
								continue;
							if (Array.IndexOf(global_events, eventKey) < 0)
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
									vl(T[55]);
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

								string[] selectedPowers = ini("boss", "items", T[131], bini).Split(',');
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
										print(T[56] + selectedPowers[i] + "!! Not using.", ConsoleColor.Red);
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
								// MAKE INTO OBJECT[] AND STRUCT TO ITERATE OVER v

								QB_bossRKgain_s.Create(QbItemType.StructItemStruct);
								QB_bossRKgain_s.ItemQbKey = QbKey.Create(0x3FA9FFF5); // GainPerNote
								QB_bossRKloss_s.Create(QbItemType.StructItemStruct);
								QB_bossRKloss_s.ItemQbKey = QbKey.Create(0xDC11A417); // LossPerNote
								QB_bossATKmiss_s.Create(QbItemType.StructItemStruct);
								QB_bossATKmiss_s.ItemQbKey = QbKey.Create(0x19BBFD30); // PowerUpMissedNote
								QB_bossWrepair_s.Create(QbItemType.StructItemStruct);
								QB_bossWrepair_s.ItemQbKey = QbKey.Create(0x8EEF15AD); // WhammySpeed
								QB_bossSrepair_s.Create(QbItemType.StructItemStruct);
								QB_bossSrepair_s.ItemQbKey = QbKey.Create(0x400CFB72); // BrokenStringSpeed
								QB_bossSTRmiss_s.Create(QbItemType.StructItemStruct);
								QB_bossSTRmiss_s.ItemQbKey = QbKey.Create(0x400CFB72); // BrokenStringMissedNote
								int ddd = 0;
								foreach (string d in diffs)
								{
									if (ini("rockgain", d, "", bini) != "")
										boss_rockGain[ddd] = Convert.ToSingle(ini("rockgain", d, "", bini));
									if (ini("rockloss", d, "", bini) != "")
										boss_rockLoss[ddd] = Convert.ToSingle(ini("rockloss", d, "", bini));
									if (ini("attackmiss", d, "", bini) != "")
										boss_atkmiss[ddd] = Convert.ToSingle(ini("attackmiss", d, "", bini));
									if (ini("whammyrepair", d, "", bini) != "")
										boss_Wrepair[ddd] = Convert.ToInt32(ini("whammyrepair", d, "", bini));
									if (ini("stringrepair", d, "", bini) != "")
										boss_Srepair[ddd] = Convert.ToInt32(ini("stringrepair", d, "", bini));
									if (ini("stringmiss", d, "", bini) != "")
										boss_strmiss[ddd] = Convert.ToSingle(ini("stringmiss", d, "", bini));

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

						vl(T[57], chartConvColor);
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
												print(T[129], ConsoleColor.Yellow);
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

						vl(T[58], chartConvColor);
						//vl("Sorting scripts by time.", chartConvColor);
						var time = QbKey.Create(0x906B67BA);
						scripts.Sort(delegate (QbItemStruct c1, QbItemStruct c2)
						{
							//     autismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautismautism
							return (c1.FindItem(time, false) as QbItemInteger).Values[0].CompareTo((c2.FindItem(time, false) as QbItemInteger).Values[0]);
						});

#region FACE-OFF/BATTLE VALUES
						vl(T[59], chartConvColor);
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
						bool gotfont = false;
						for (int j = 0; j < 4; j++)
						{
							for (int i = 3; i >= 0; i--)
							{
								font = chart.NoteTracks[td[i] + ti[j]]; // ugh
								if (font != null)
								{
									gotfont = true;
									break;
								}
							}
							if (gotfont)
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
									vl("Got face-off marker: " + faceoff_bit.Values[0] + "," + faceoff_bit.Values[1]);
									if (a.SpecialFlag == 0)
										fop1a.AddItem(faceoff_bit);
									else
										fop2a.AddItem(faceoff_bit);
								}
							}
						//if (!gotfo[0] && !gotfo[1])
						//	vl("No face-off markers found");
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
						vl(T[60], chartConvColor);
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
						if (ts.Count == 0)
						// bruh
						// legitimately happens on some charts for some reason
						// causes infinite starpower
						{
							vl(T[61], ConsoleColor.Yellow); // megamind
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
						{
							SyncTrackEntry WHY = new SyncTrackEntry();
							WHY.Type = SyncType.TimeSignature;
							WHY.TimeSignature = 1;
							WHY.TimeSignature2 = 4;
							WHY.Offset = ts[0].Offset;
							ts.Insert(0,WHY);
						}
						int timesigcount = ts.Count;
						QbItemInteger[] ts_q = new QbItemInteger[timesigcount];
						for (int i = 0; i < timesigcount; i++)
						{
							//verboseline("Creating time signature #" + i.ToString() + "...", chartConvColor);
							ts_q[i] = new QbItemInteger(mid);
							ts_q[i].Create(QbItemType.ArrayInteger);
							ts_q[i].Values = new int[3] {
								(int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay),
								Convert.ToInt32(ts[i].TimeSignature),
								Convert.ToInt32(ts[i].TimeSignature2 == -1 ? 4 : ts[i].TimeSignature2)
							};
							//verboseline("Setting TS #" + (i).ToString() + " values (1/3) (" + (int)(Math.Floor(OT.GetTime(ts[i].Offset) * 1000) + delay) + ")...", chartConvColor);
							//verboseline("Setting TS #" + (i).ToString() + " values (2/3) (" + Convert.ToInt32(ts[i].TimeSignature) + ")...", chartConvColor);
							//verboseline("Setting TS #" + (i).ToString() + " values (3/3) (" + 4 + ")...", chartConvColor);
							// what does changing # in */# even do in general
						}
						ts_q[1].Values[0] = 2; // existentally aggrevating
						//vl("Adding time signature arrays to QB...", chartConvColor);
						mid.AddItem(tsig);
						tsig.AddItem(tsig_arr);
						for (int i = 0; i < timesigcount; i++)
							tsig_arr.AddItem(ts_q[i]);
						vl(T[62], chartConvColor);
						//vl("Creating fretbar arrays...", chartConvColor);
						QbItemBase bars_arr = new QbItemArray(mid);
						bars_arr.Create(QbItemType.SectionArray);
						bars_arr.ItemQbKey = QbKey.Create(0xC3C71E9D);
						QbItemInteger bars = new QbItemInteger(mid);
						List<int> msrs = new List<int>();
						// probably TODO: beat enumerator thing or something that uses callback
						// to reduce operations from constantly calling GetTime
						for (int i = 0; OT.GetTime(i - chart.Resolution) < ((float)(et) / 1000); i += chart.Resolution)
						{
							int t = Convert.ToInt32(Math.Floor(OT.GetTime(i) * 1000));
							// ehhhhhhhhhh
							//if (msrs.Count > 1)
							//	if (msrs[msrs.Count - 1] == t)
							//		continue; // don't place beats on the same millisecond, because integers...
							msrs.Add(t);
							if (msrs.Count == 1)
								msrs.Add(t+(2*(t<0?-1:1))); // TEMP FIX, need a webpage to elaborate on this
							// refer to firstBeatLength in the IDB
							// double <2ms beats cause the frets to pop up twice because length calculation appears to go over
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
						vl(T[63]);
						//vl("Collecting garbage...");
						GC.Collect();
#region MARKER VALUES
						vl(T[64], chartConvColor);
						//vl("Creating marker arrays...", chartConvColor);
						QbItemArray sects = new QbItemArray(mid);
						sects.Create(QbItemType.SectionArray);
						QbItemStructArray sects_arr = new QbItemStructArray(mid);
						sects.ItemQbKey = QbKey.Create(0x85C8739B);
						sects_arr.Create(QbItemType.ArrayStruct);
						List<EventsSectionEntry> mrkrs = new List<EventsSectionEntry>();
						foreach (EventsSectionEntry e in chart.Events)
						{
							if (e == null) { vl("Got null event!!!!!!!!!"); continue; } // wtf
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
							mrk_n[i].Create(QbItemType.StructItemStringW);
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
						songtitle.Create(QbItemType.StructItemStringW);
						songtitle.ItemQbKey = QbKey.Create("title");
						QbItemString songauthr = new QbItemString(mid);
						songauthr.Create(QbItemType.StructItemStringW);
						songauthr.ItemQbKey = QbKey.Create("author");
						QbItemString songalbum = new QbItemString(mid);
						songalbum.Create(QbItemType.StructItemStringW);
						songalbum.ItemQbKey = QbKey.Create("album");
						QbItemString songyear = new QbItemString(mid);
						songyear.Create(QbItemType.StructItemStringW);
						songyear.ItemQbKey = QbKey.Create("year");
						QbItemString songchrtr = new QbItemString(mid);
						songchrtr.Create(QbItemType.StructItemStringW);
						songchrtr.ItemQbKey = QbKey.Create("charter");
						songtitle.Strings[0] = ini("song", "name", "Unknown", sini).Trim();
						songauthr.Strings[0] = ini("song", "artist", "Unknown", sini).Trim();
						songalbum.Strings[0] = ini("song", "album", "Unknown", sini).Trim();
						songyear.Strings[0] = ini("song", "year", "Unknown", sini).Trim();
						songchrtr.Strings[0] = ini("song", "charter", "Unknown", sini).Trim();
						string genre = ini("song", "genre", "Unknown", sini).Trim();
						foreach (SongSectionEntry s in chart.Song)
						{
							string v = s.Value.Trim();
							if (v != "")
							{
								switch (s.Key)
								{
									case "Name":
										if (v != "Untilted Song")
											songtitle.Strings[0] = v;
										break;
									case "Artist":
										if (v != "Unknown Artist")
											songauthr.Strings[0] = v;
										break;
									case "Charter":
										if (v != "Unknown Charter")
											songchrtr.Strings[0] = v;
										break;
									case "Genre":
										if (v != "rock")
											genre = v;
										break;
								}
							}
						}
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
#region CO-OP THINGS / BOSS PROPS (2) (?????)
						if (isBoss || (hasCoopTracks[0] && hasCoopTracks[1]))
							mid.AddItem(fastgh3_extra);
						if (hasCoopTracks[0] && hasCoopTracks[1])
						{
							QbItemQbKey s = new QbItemQbKey(mid);
							s.Create(QbItemType.StructItemQbKey);
							s.ItemQbKey = QbKey.Create(0x00000000);
							s.Values[0] = QbKey.Create("use_coop_notetracks");
							fastgh3_extra.AddItem(s);
							vl("Has both Co-op tracks");
						}
						if (isBoss)
						{
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
#endregion
						vl(T[65], chartConvColor);
						//vl("Aligning pointers...", chartConvColor);
						mid.AlignPointers();
						//vl("Writing song.qb...", chartConvColor);
						//songdata.Write(folder + pak + "song.qb");
						print(T[66], chartConvColor);
						//print("Compiling PAK.", chartConvColor);
						// somehow songs\fastgh3.mid.qb =/= E15310CD here
						// wtf is the name of 993B9724
						// though i think name wouldnt actually
						// matter here because of how the game
						// loads paks, which doesnt care about
						// whatever the files are called,
						// as long as its data gets loaded unless
						// that's just PC because there was script
						// code for manually loading assets
						string qb_name = "songs\\fastgh3.mid.qb";
						if (outputPAK)
							try
							{
								build.ReplaceFile(qb_name, mid);// folder + pak + "song.qb"); // songs\fastgh3.mid.qb
							}
							catch
							{
								build.AddFile(mid, qb_name, QbKey.Create(".qb"), false);
							}
						else
						{
							mid.Write(songqb);
						}
						if (File.Exists(outputPAK ? songqb : songpak))
							File.Delete(outputPAK ? songqb : songpak);
						//File.Delete(pakf + "song.qb");
						if (caching)
						{
							print(T[67], cacheColor);
							//print("Writing PAK to cache.", cacheColor);
							File.Copy(outputPAK ? songpak : songqb, cf + charthash.ToString("X16"), true);
							iniw(charthash.ToString("X16"), "Title", songtitle.Strings[0], cachf);
							iniw(charthash.ToString("X16"), "Author", songauthr.Strings[0], cachf);
							iniw(charthash.ToString("X16"), "Length", timeString, cachf);
							if (audCache)
								iniw(charthash.ToString("X16"), "Audio", audhash.ToString("X16"), cachf);
							if (!outputPAK)
								iniw(charthash.ToString("X16"), "QB", 1, cachf);
						}
						vl(T[68]);
						//vl("DID EVERYTHING WORK?!");
					}
					else
					{
						string cacheidStr = charthash.ToString("X16");
						print(T[69], cacheColor);
						//print("Cached chart found.", cacheColor);
						bool isQB = ini(cacheidStr, "QB", 0, cachf) == 1;
						if (File.Exists(isQB ? songpak : songqb))
							File.Delete(isQB ? songpak : songqb);
						File.Copy(cf + cacheidStr, isQB ? songqb : songpak, true);
						// should use ternary "song." + (a ? "qb" : "pak") + ".xen"
						File.Copy(arg0, paksongmid, true);
						if (ext == midext ||
							ext == (midext + 'i'))
						{
							mid2chart.Program.Main(m2cA);
						}
						if (ischart)
						{
							chart.Load(arg0);
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
							string v = s.Value.Trim();
							if (v != "")
							{
								switch (s.Key)
								{
									case "Name":
										if (v != "Untilted Song")
											_title = v;
										break;
									case "Artist":
										if (v != "Unknown Artist")
											author = v;
										break;
									case "Charter":
										if (v != "Unknown Charter")
											charter = v;
										break;
								}
							}
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
						if (File.Exists(paksongmid))
							File.Delete(paksongmid);
						if (File.Exists(paksongchart))
							File.Delete(paksongchart);
					}
#region COMPILE AUDIO TO FSB
					vl(T[74]);
					//vl("Creating GH3 process...");
					Process gh3 = new Process();
					gh3.StartInfo.WorkingDirectory = folder;
					gh3.StartInfo.FileName = GH3EXEPath;
					vl("Launching game early");
					gh3.Start();
					unkillgame();
					if (!audCache)
					{
#if STFSB
						if (!fsbbuild.HasExited)
						{
							vl("Launching game early");
							print(T[70], FSBcolor);
							//print("Waiting for song encoding to finish.", FSBcolor);
							fsbbuild.WaitForExit();
							File.WriteAllBytes(dat, fsbdat);
							audioConv_end = time;
							if (caching)
							{
								print(T[71], cacheColor);
								//print("Writing audio to cache.", FSBcolor);
								File.Copy(fsb, cf + audhash.ToString("X16"), true);
								iniw(charthash.ToString("X16"), "Audio", audhash.ToString("X16"), cachf);
							}
						}
#else
						print(T[70], FSBcolor);
						string[] fsbnames = { "song", "guitar", "rhythm" };
						Console.CancelKeyPress += (s, d) => {
							if (d.SpecialKey != ConsoleSpecialKey.ControlC)
								return;
							for (int i = 0; i < fsbbuild2.Length; i++)
							{
								if (fsbbuild2[i] == null)
									continue;
								if (fsbbuild2[i].Id < 1)
									continue;
								if (fsbbuild2[i].HasExited)
									continue;
								try { fsbbuild2[i].Kill(); }
								catch { }
							}
							try { fsbbuild3.Kill(); }
							catch { }
							try { gh3.Kill(); }
							catch { }
							//killgame(); // wouldn't be long enough for the game to see this maybe
							unkillgame();
							try
							{
								if (Directory.Exists(mt + "fsbtmp"))
									Directory.Delete(mt + "fsbtmp", true);
								File.Delete(fsb);
							}
							catch { }
							exit();
							die();
						};
						try
						{
							Console.WriteLine("Encoding progress:");
							for (int i = 0; i < 3; i++)
							{
								if (audiostreams[i].ToLower() == (blankmp3).ToLower())
									continue;
								pbl[i] = (short)(Console.CursorTop);
								Console.WriteLine(fsbnames[i].PadRight(6) + ":   0% (" + ")".PadLeft(33)); // leet optimization
							}
							if (nj3t)
								if (!addaud.HasExited)
									print(T[72], FSBcolor);
							// we're using CBR (for now) so don't have to worry about
							// more inconsistent file sizes
							// DESPITE PROGRESS BARS NOW OVERFLOWING SOMETIMES (2024)
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
							Thread.Sleep(20);
							for (byte i = 0; i < 3; i++)
								if (!locks[i])
									if (File.Exists(mt + "fsbtmp\\fastgh3_" + fsbnames[i] + ".mp3"))
										pb(new FileInfo(mt + "fsbtmp\\fastgh3_" +
											fsbnames[i] + ".mp3").Length / 1000 /
												(al[i] * (AB_param >> (is_stereo[i] ? 1 : 2))), i);
							for (byte i = 0; i < fsbbuild2.Length; i++)
								if (!nj3t || (nj3t && i != 0))
									if (!locks[i])
										if (fsbbuild2[i].HasExited)
											locks[i] = true;
							if (nj3t && !locks[0])
								if (addaud.HasExited)
									locks[0] = true;
						}
						audioConv_end = time;
						fsbbuild3.Start();
						if (vb | wl)
						{
							fsbbuild3.BeginErrorReadLine();
							fsbbuild3.BeginOutputReadLine();
						}
						if (!fsbbuild3.HasExited)
							fsbbuild3.WaitForExit();
						File.WriteAllBytes(dat, fsbdat);
						{
							if (caching)
							{
								print(T[71], cacheColor);
								//print("Writing audio to cache.", cacheColor);
								File.Copy(fsb, cf + audhash.ToString("X16"), true);
								iniw(charthash.ToString("X16"), "Audio", audhash.ToString("X16"), cachf);
							}
						}
#endif
					}
					cfgW("Temp", "LoadingLock", 0);
#endregion
					string test = Path.GetFileNameWithoutExtension(arg0)+".bik";
					if (File.Exists(test))
						cSV(test);
					else
						cSV("background.bik");
					unkillgame();
					if (!audCache)
					{
						double audioConv_time = audioConv_end.TotalMilliseconds - audioConv_start.TotalMilliseconds;
						print(T[73] + (audioConv_time / 1000).ToString("0.00") + " seconds", FSBcolor);
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
					print(T[75]);
					//print("Ready, go!");
					cfgW("Temp", fl, 1);
					if (nj3t)
					{
						// why is program sending this log when it's successful
						// and this is in its own try catch block
						//vl(T[76]);
						//vl("Cleaning up SoX temp files FOR SOME REASON!!!");
						// stupid SoX
						// didn't happen on the previous version from 2010
						// so WHY DOES IT CREATE THESE
						// happens with the NJ3T encoding
						//foreach (var f in new DirectoryInfo(Path.GetTempPath()).EnumerateFiles("libSox.tmp.*"))
						//	try { f.Delete(); } catch { }
						//foreach (var f in new DirectoryInfo(tmpf).EnumerateFiles())
						//	try { f.Delete(); } catch { }
						//foreach (var f in new DirectoryInfo(tmpf).EnumerateDirectories())
						//	try { f.Delete(true); } catch { }
					}
					killtmpf(arg0);
					exit();
					if (cfg(l, settings.t.PreserveLog.ToString(), "0") == "1")
					{
						print(T[98]);
						//print("Press any key to exit");
						Console.ReadKey();
					}
				}
#endregion
#region FSP EXTRACT
				else if ((ext == ".fsp" || ext == ".zip" ||
					ext == ".7z" || ext == ".rar")
					|| ext == ".sng"
					|| ext == ".sgh"
					|| ext == ".tgh")
				{
					// TODO: DON'T KEEP EXTRACTED FILES
					// 7kb
					pt(2);
					//log.WriteLine("\n######### FSP EXTRACT PHASE #########\n");
					print(T[78], cacheColor);
					//print("Detected song package.", cacheColor);
					ulong fsphash = WZK64.Create(File.ReadAllBytes(arg0));
					string fsphashStr = fsphash.ToString("X16");
					bool fspcache = false;
					if (caching)
					{
						print(T[21], cacheColor);
						if (Array.IndexOf(sn(cachf), "ZIP" + fsphashStr) != -1)
						{
							vl(T[79], cacheColor);
							fspcache = true;
						}
					}
					//bool compiled = false;
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
							vl("Deleting old FSP temp folder");
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
						print(T[80], cacheColor);
					else
					{
						if (fspcache && Directory.Exists(tmpf) && caching)
							print(T[81], cacheColor);
						else if (!Directory.Exists(tmpf))
							print(T[82], cacheColor);
					}
					if (fspcache && Directory.Exists(tmpf) && caching)
					{
						vl("Is cached FSP");
						// freaking copy and paste
						foreach (string ff in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
						{
							string f = ff.ToLower();
							string foundtext = string.Format(T[195], f);
							if (f.EndsWith(".pak") ||
								f.EndsWith(".pak.xen") ||
								f.EndsWith(".pak.ps3") ||
								f.EndsWith(chartext) ||
								f.EndsWith(midext) ||
								f.EndsWith(".sng"))
							{
								vl(foundtext, FSPcolor);
								killgame();
								multichartcheck.Add(f);
								selectedtorun = f;
							}
							if (f.EndsWith(".fsb") ||
								f.EndsWith(".fsb.xen") ||
								f.EndsWith(".fsb.ps3") ||
								f.EndsWith(".dat") ||
								f.EndsWith(".dat.xen") ||
								f.EndsWith(".dat.ps3"))
							{
								vl(foundtext, FSPcolor);
								killgame();
							}
							if (f == "song.ini" ||
								f == "boss.ini" ||
								f == "background.bik")
							{
								vl(foundtext, FSPcolor);
							}
							if (f.EndsWith(".ogg") ||
								f.EndsWith(".mp3") ||
								f.EndsWith(".wav") ||
								f.EndsWith(".opus"))
							{
								vl(string.Format(T[195], "audio"), FSPcolor);
							}
						}
					}
					else
					{
						if (!Directory.Exists(tmpf))
							Directory.CreateDirectory(tmpf);
						if (ext == ".sng")
						{
							vl("Is SNG");
							Sng test = Sng.Load(arg0);
							Stream sini = File.OpenWrite(tmpf + "\\song.ini");
							StreamWriter tw = new StreamWriter(sini);
							tw.WriteLine("[song]");
							foreach (string key in test.meta.Keys)
							{
								tw.WriteLine(key + '=' + test.meta[key]);
							}
							//sini.Close();
							tw.Dispose();
							foreach (Sng.File ff in test.files)
							{
								string f = ff.name.ToLower();
								string foundtext = string.Format(T[195], f);
								if (f.EndsWith(chartext) ||
									f.EndsWith(midext))
								{
									vl(foundtext, FSPcolor);
									killgame();
									multichartcheck.Add(f);
									selectedtorun = tmpf + f;
									File.WriteAllBytes(tmpf + ff.name, ff.data);
								}
								if (//f == "song.ini" || // haven't found, and it's stored in meta
									//f == "background.bik" ||
									f == "boss.ini")
								{
									vl(foundtext, FSPcolor);
									File.WriteAllBytes(tmpf + ff.name, ff.data);
								}
								if (f.EndsWith(".ogg") ||
									f.EndsWith(".mp3") ||
									f.EndsWith(".wav") ||
									f.EndsWith(".opus"))
								{
									vl(string.Format(T[195], "audio"), FSPcolor);
									File.WriteAllBytes(tmpf + ff.name, ff.data);
								}
							}
						}
						else
						{
							vl("Zip check");
							// passwords for GHTCP and GHPCED songs
							// idgaf lol
							// 0: SGH
							// 1: TGH
							// 2: GHC chart zip
							// 3: GHT, for built in tracks, contains OGGs
							// 4: GHP, ???? // DANNY JOHNSON CONFIRMED!!1//1?/!1?!1!//!/??!!/!?!!!1111
							// (non-zip)
							// 5: GHX
							// 6: GHZ
							string[] passwords = T[208].Split(';');
							bool zipReadBlatantfail = false;
							// cheap just to get around
							// ambiguous zip type when downloading (a 7Z or RAR) from drive
#if USE_SZL
							ZipFile file = null;
#endif
							try
							{
#if !USE_SZL
								ZipFile.Read(arg0);
#else
								file = new ZipFile(arg0);
#endif
							}
							catch
							{
								zipReadBlatantfail = true;
							}
							if (!Directory.Exists(tmpf))
								Directory.CreateDirectory(tmpf);
							vl("Extension: " + ext);
							if ((ext == ".zip" || ext == ".fsp" || // :(
								ext == ".sgh" || ext == ".tgh") && !zipReadBlatantfail)
							{
								vl("Is ZIP");
#if !USE_SZL
								vl("Using DotNetZip");
#else
								vl("Using SharpZipLib");
#endif
								bool unlocked = false;
#if !USE_SZL
								string pass = "";
								if (!ZipFile.CheckZipPassword(arg0, ""))
								{
									for (int i = 0; i < 4; i++)
									{
										if (ZipFile.CheckZipPassword(arg0, passwords[i]))
										{
											pass = passwords[i];
											vl("Unlocked ZIP with "+pass);
											break;
										}
									}
								}
								using (ZipFile file = ZipFile.Read(arg0))
#else
								string pass = null;
								//if (file.Count < 1)
								//	goto zeroCount;
								bool locked = !(unlocked = !file[0].IsCrypted);
								if (locked)
								{
									vl("Password protected, testing GHTCP passwords");
									for (int i = 0; i < 4; i++)
									{
										try
										{
											file.Password = passwords[i];
											Stream dummy = file.GetInputStream(0);
											// guessing index zero is the first file available :/
											// and that it throws if password is incorrect
											dummy.Close();
											unlocked = true;
											pass = passwords[i];
											break; // breaking through try, perturbing
										}
										catch
										{

										}
									}
									if (!unlocked)
									{
										// TODO: password dialog
									}
								}
								else
									vl("No password");
								if (unlocked)
#endif
								{
#if !USE_SZL
									file.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
#endif
									// should replace this all with a central class routing to these functions
									foreach (ZipEntry data in file)
									{
#if USE_SZL
										file.GetInputStream(data);
#endif
										try
										{
#if !USE_SZL
											string f = data.FileName.ToLower();
											data.ExtractExistingFile = ExtractExistingFileAction.OverwriteSilently;
#else
											string f = Path.GetFileName(data.Name).ToLower();
											Stream s = file.GetInputStream(data);
#endif
											string foundtext = string.Format(T[195], f);
											if (f.EndsWith(".pak") ||
												f.EndsWith(".pak.xen") ||
												f.EndsWith(".pak.ps3") ||
												f.EndsWith(chartext) ||
												f.EndsWith(midext) ||
												f.EndsWith(".sng"))
											{
												killgame();
												vl(foundtext, FSPcolor);
#if !USE_SZL
												data.ExtractWithPassword(tmpf, pass);
#else
												Stream ff = File.Open(tmpf + f, FileMode.Create); // ugh
												s.CopyTo(ff);
												ff.Dispose();
#endif
												multichartcheck.Add(f);
												selectedtorun = tmpf + f;
											}
											if (f.EndsWith(".fsb") ||
												f.EndsWith(".fsb.xen") ||
												f.EndsWith(".fsb.ps3") ||
												f.EndsWith(".dat") ||
												f.EndsWith(".dat.xen") ||
												f.EndsWith(".dat.ps3"))
											{
												killgame();
												vl(foundtext, FSPcolor);
#if !USE_SZL
												data.ExtractWithPassword(tmpf, pass);
#else
												Stream ff = File.Open(tmpf + f, FileMode.Create); // ugh
												s.CopyTo(ff);
												ff.Dispose();
#endif
											}
											if (f == "song.ini" ||
												f == "boss.ini" ||
												f == "background.bik")
											{
												vl(foundtext, FSPcolor);
#if !USE_SZL
												data.ExtractWithPassword(tmpf, pass);
#else
												Stream ff = File.Open(tmpf + f, FileMode.Create); // ugh
												s.CopyTo(ff);
												ff.Dispose();
#endif
											}
											if (f.EndsWith(".ogg") ||
												f.EndsWith(".mp3") ||
												f.EndsWith(".wav") ||
												f.EndsWith(".opus"))
											// TODO: filter to files that would
											// actually be used by the chart
											{
												vl(string.Format(T[195], "audio"), FSPcolor);
#if !USE_SZL
												data.ExtractWithPassword(tmpf, pass);
#else
												Stream ff = File.Open(tmpf + f, FileMode.Create); // ugh
												s.CopyTo(ff);
												ff.Dispose();
#endif
											}
#if USE_SZL
											s.Dispose();
#endif
										}
										catch (Exception e)
										{
											vl(T[83] + data.
#if USE_SZL
											Name
#else
											FileName
#endif
											+ '\n' + e, ConsoleColor.Yellow);
											//vl("Error extracting a file: " + data.FileName + '\n' + e, ConsoleColor.Yellow);
										}
									}
								}
#if USE_SZL
								file.Close();
#endif
							}
							else
							// extract using 7-zip or WinRAR if installed
							{
								//vl("OH NO, THE SEVENS AND THE ROARS!", FSPcolor); // lol
								bool got7Z = false, gotWRAR = false;
								vl(T[84], FSPcolor);
								//vl("Looking for command line accessible 7Zip.", FSPcolor);
								string p = where("7z.exe"); // do i have to specify .exe
								got7Z = p != "";
								// todo?: check associated program for 7z/rar??
								// but then that will lead to getting the EXE for the GUI
								// of the program, if not the CLI unless it's a specific
								// program where the CLI is the main EXE
								string rarpath = "";
								if (!got7Z)
								{
									// or look in registry
									vl(T[85], FSPcolor);
									//vl("Looking for 7Zip in registry.", FSPcolor);
									RegistryKey k;
									// also check HKLM hive?
									try
									{
										k = Registry.CurrentUser.OpenSubKey("SOFTWARE\\7-Zip");
										if (k != null)
										{
											if ((p = (string)k.GetValue("Path")) == null)
											{
												if ((p = (string)k.GetValue("Path64")) != null)
													got7Z = true;
											}
											else
												got7Z = true;
											if (got7Z)
												p += "\\7z.exe";
											if (!File.Exists(p) && got7Z)
											{
												vl(T[86], FSPcolor);
												//vl("Wait WTF, THE PROGRAM ISN'T THERE!! HOW!", FSPcolor);
												got7Z = false;
											}
											k.Close();
										}
										else
											print(T[87]);
										//print("Could not find 7-Zip path in registry. Is it installed?");
									}
									catch
									{
										got7Z = false;
										vl(T[88]);
										//vl("Somehow looking for 7-Zip failed. Is it installed?");
									}
								}
								if (!got7Z)
								// prioritize finding installation over 7za.exe because 7za does not support RARs
								{
									if (got7Z = (p = where("7za.exe")) != "" && ext == ".rar")
									{
										exit();
										vl(T[218]);
										MessageBox.Show(T[217], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
										return 1;
									}
								}
								if (got7Z)
									vl("Found 7Zip", FSPcolor);
								if (got7Z)
								{
									vl(T[89], FSPcolor);
									vl(p);
								}
								else
								{
									vl(T[90], FSPcolor);
									//vl("7Zip could not be found.", FSPcolor);
									vl(T[91], FSPcolor);
									//vl("Looking for command line accessible WinRAR or UnRar.exe", FSPcolor);
									rarpath = where("UnRar.exe");
									if (gotWRAR = rarpath != "")
									{
										/*if (!arg0.EndsWith(".rar"))
										{
											exit();
											MessageBox.Show(T[126], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
											return 1;
										}*/
										vl(T[92], FSPcolor);
										//vl("Found UnRAR. Using that...", FSPcolor);
									}
									else
										vl(T[93], FSPcolor);
									//vl("UnRAR could not be found.", FSPcolor);
								}
								string xf, xa;

								if (got7Z)
								{
									xf = p;
									xa = "x " + arg0.Quotes() + " -aoa -o" + tmpf.Quotes();
								}
								else if (gotWRAR)
								{
									xf = rarpath;
									xa = "x -o+ " + Path.GetFullPath(arg0).Quotes() + " " + tmpf.Quotes();
								}
								else
								{
									exit();
									vl(T[94], FSPcolor);
									//vl("Unsupported archive type", FSPcolor);
									MessageBox.Show(T[126], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
									return 1;
								}
								int currentPassword = -1;
								int passwordsToTest = 4;
								Process x = cmd(xf, xa + " -p" + (gotWRAR ? "-" : ""));
								//if (got7Z || gotWRAR)
								{
									vl("Executing " + x.StartInfo.FileName.Quotes() + " " + x.StartInfo.Arguments, FSPcolor);
									vl("log:");
									retryPass7Z:
									x.Start();
									if (vb || wl)
									{
										x.BeginErrorReadLine();
										x.BeginOutputReadLine();
									}
									x.WaitForExit();
									if (vb || wl)
									{
										x.CancelErrorRead();
										x.CancelOutputRead();
									}
									vl("Exit code: " + x.ExitCode, FSPcolor);
									if ((x.ExitCode == 2 && got7Z) || (x.ExitCode == 11 && gotWRAR))
									{
										if (currentPassword == -1)
											vl("Possibly password protected, retrying");
										if (++currentPassword < passwordsToTest)
										{
											string pass = passwords[currentPassword];
											x.StartInfo.Arguments = xa + " -p" + pass;
											print("Testing "+pass);
											goto retryPass7Z;
										}
									}
									// TODO: password dialog
									if (x.ExitCode != 0)
									{
										exit();
										MessageBox.Show(T[127], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
										return 1;
									}
									foreach (string ff in Directory.GetFiles(tmpf, "*.*", SearchOption.AllDirectories))
									{
										string f = ff.ToLower();
										string foundtext = string.Format(T[195], f);
										if (f.EndsWith(".pak") ||
											f.EndsWith(".pak.xen") ||
											f.EndsWith(".pak.ps3") ||
											f.EndsWith(chartext) ||
											f.EndsWith(midext) ||
											f.EndsWith(".sng"))
										{
											vl(foundtext, FSPcolor);
											killgame();
											multichartcheck.Add(f);
											selectedtorun = f;
										}
										if (f.EndsWith(".fsb") ||
											f.EndsWith(".fsb.xen") ||
											f.EndsWith(".fsb.ps3") ||
											f.EndsWith(".dat") ||
											f.EndsWith(".dat.xen") ||
											f.EndsWith(".dat.ps3"))
										{
											vl(foundtext, FSPcolor);
											killgame();
										}
										if (f == "song.ini" ||
											f == "boss.ini" ||
											f == "background.bik")
										{
											vl(foundtext, FSPcolor);
										}
										if (f.EndsWith(".ogg") ||
											f.EndsWith(".mp3") ||
											f.EndsWith(".wav") ||
											f.EndsWith(".opus"))
										{
											vl(string.Format(T[195], "audio"), FSPcolor);
										}
									}
								}
							}
						}
					}
					if (caching && !fspcache)
					{
						print(T[95], cacheColor);
						//print("Writing path to cache...", cacheColor);
						iniw("ZIP" + fsphashStr, "Path", tmpf, cachf);
					}
					if (multichartcheck.Count == 0)
					{
						exit();
						//vl("There's nothing in here!", ConsoleColor.Red);
						// ♫ There's nothing for me here ♫
						MessageBox.Show("No chart found in this archive file.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
						return 1;
					}
					bool cancel = false;
					if (multichartcheck.Count > 1)
					{
						fspmultichart askchoose = new fspmultichart(multichartcheck.ToArray());
						askchoose.ShowDialog();
						if (File.Exists(askchoose.chosen) && askchoose.DialogResult == DialogResult.OK)
						{
							selectedtorun = askchoose.chosen;
							//compiled = !Path.GetFileName(askchoose.chosen).EndsWith(".chart") &&
							//			!Path.GetFileName(askchoose.chosen).EndsWith(".mid");
						}
						cancel = askchoose.DialogResult == DialogResult.Cancel;
					}
					if (!cancel)
#if false
						if (compiled)
						{
							unkillgame();
							Console.ResetColor();
							//print("Speeding up.");
							vl(T[74]);
							Process gh3 = new Process();
							gh3.StartInfo.WorkingDirectory = folder;
							gh3.StartInfo.FileName = GH3EXEPath;
							// dont do this lol
							if (cfg("Player", "MaxNotesAuto", "0") == "1")
								cfgW("Player", "MaxNotes", 0x100000.ToString());
							print(T[75]);
							gh3.Start();
							cfgW("Temp", fl, 1);
						}
						else
#endif
					{
						return sub(selectedtorun);
						//die();
					}
				}
#endregion
#region PRECOMPILED PAK
				else if ((ext == (".pak") ||
					arg0.ToLower().EndsWith(".pak.xen") ||
					//ext == (".pak.ngc") ||
					arg0.ToLower().EndsWith(".pak.ps3")))
				{
					print("Detected song PAK.", FSPcolor);
					PakEditor pak = new PakEditor(new PakFormat(arg0, "", "", PakFormatType.PC));
					vl("loaded");
					bool gotname = false;
					string id = "";
					// Raining Blood has the note tracks as the first file on all platforms
					QbKey EXT_QB = QbKey.Create(0xA7F505C4), EXT_MQB = QbKey.Create(0x4BC1E85E);
					vl("Start reading headers");
					QbFile songdata = null;
					string[] user_keys = cfg(l, "KnownSongIDs", "").
						Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
					string[] test_keys = new string[gsn.Length + user_keys.Length];
					Array.Copy(gsn, test_keys, gsn.Length);
					if (user_keys.Length > 0)
						Array.Copy(user_keys, 0, test_keys, gsn.Length, user_keys.Length);
					bool manual_test = false;
					bool cancel = false;
					unkname setp = new unkname();
					{
						Match m = Regex.Match(Path.GetFileName(arg0), T[201], RegexOptions.IgnoreCase);
						if (m.Success)
						{
							Group name = m.Groups["name"];
							if (name.Success)
							{
								id = name.Value;
								test_keys[2] = id;
								vl(id);
							}
						}
					}
					retry:
					if (!gotname)
						foreach (PakHeaderItem f in pak.Headers.Values)
						{
							if (f.FileType.Crc == EXT_QB.Crc || f.FileType == EXT_MQB.Crc)
							{
								if (f.Flags.HasFlag(PakHeaderFlags.Filename))
								{
									print("Got raw filename: " + f.Filename, chartConvColor);
									// extract song name from raw filename if possible
									Match m = Regex.Match(f.Filename, T[200], RegexOptions.IgnoreCase);
									// (VV) Wii/PS2 format, raw : data/songs/***.mid.qb.(platform) // magically doesn't cut off first char unlike 'cripts'
									// PC/360/PS3 format, hashed: songs\***.mid.qb
									if (m.Success)
									{
										Group name = m.Groups["name"];
										if (name.Success)
										{
											songdata = pak.ReadQbFile(f.Filename);
											vl("done");
											gotname = true;
											break;
										}
									}
								}
								else
								{
									//Console.WriteLine(f.FullFilenameQbKey);
									//f.FullFilenameQbKey
									foreach (string s in test_keys)
									{
										string fmt = string.Format("songs/{0}.mid.qb", s);
										if (manual_test)
											vl("testing " + fmt);
										if (QbKey.Create(fmt).Crc == f.FullFilenameQbKey)
										{
											songdata = pak.ReadQbFile(f.Filename);
											print("Matched song ID: " + s, chartConvColor);
											id = s;
											vl("done");
											gotname = true;
											if (manual_test)
												cfgW(l, "KnownSongIDs", s + ',' + cfg(l, "KnownSongIDs", ""));
											break;
										}
									}
									if (!gotname)
									{
										vl("read QB " + f.Filename);
										QbFile qb = pak.ReadQbFile(f.Filename);
										foreach (string s in test_keys)
										{
											if (manual_test)
												vl("testing " + s);
											QbItemBase test = qb.FindItem(QbKey.Create(s + "_song_expert"), false);
											if (test != null)
											{
												songdata = qb;
												print("Matched song ID: " + s, chartConvColor);
												id = s;
												vl("done");
												gotname = true;
												if (manual_test)
													cfgW(l, "KnownSongIDs", s + ',' + cfg(l, "KnownSongIDs", ""));
												break;
											}
										}
									}
								}
							}
							if (gotname)
								break;
						}
					if (manual_test)
					{
						if (!gotname)
							cancel = MessageBox.Show("Could not match song PAK's data with the input ID.",
								"Error", MessageBoxButtons.RetryCancel, MessageBoxIcon.Error)
									== DialogResult.Cancel;
					}
					if (!cancel)
					{
						//songdata.Items[0].Clone();
						if (!gotname)
						{
							if (setp.ShowDialog() == DialogResult.OK)
							{
								manual_test = true;
								test_keys = new string[] { setp.inp };
								goto retry;
							}
						}
						if (gotname)
						{
							string source_fsb = arg0.ReplaceCI("_song.pak", ".fsb").ReplaceCI(".pak", ".fsb");
							string source_dat = source_fsb.ReplaceCI(".fsb", ".dat");
							string source_basename = null;
							string idkwhattonamethis = "";
							for (int i = 0; i < 2; i++)
							{
								if (!File.Exists(source_fsb))
								{
									source_basename = Path.GetDirectoryName(arg0) + '\\' + idkwhattonamethis + id;
									source_fsb = source_basename + ".fsb";
									source_dat = source_basename + ".dat";
									if (File.Exists(source_fsb + ".xen"))
									{
										source_fsb += ".xen";
										source_dat += ".xen";
									}
									else if (File.Exists(source_fsb + ".ps3"))
									{
										source_fsb += ".ps3";
										source_dat += ".ps3";
									}
								}
								idkwhattonamethis = "..\\MUSIC\\";
							}
							bool cant_find_fsb = !(File.Exists(source_fsb) && File.Exists(source_dat));
							bool no_dat = false;
							//bool _0_7c = false; // compatibility just because
							if (id.ToLower() == "fastgh3")
							{
								cant_find_fsb = false;
								no_dat = true;
								File.WriteAllBytes(dat, fsbdat);
							}
							if (id.ToLower() == "song")
							{
								//_0_7c = true;
								vl(T[212] + new string('!', 60));
								cant_find_fsb = false;
								no_dat = true;
								File.WriteAllBytes(dat, fsbdat07);
							}
							// uhhhh, forgot the code for encoding non-FSB isn't here
							no_dat = !File.Exists(source_dat);
							if (!no_dat)
							{
								//string[] stnames = { "", "", "" };
								//uint[] stidx = { 0, 0, 0 };
								int[] found_streams = { -1, -1, -1 };
								DAT hed = LoadDAT(source_dat);
								// MESS!!!!!!!!!!!!!!!!!!!!
								string[] audstnames = { "song", "guitar", "rhythm" };
								for (int x = 0; x < 2; x++)
								{
									for (uint i = 0; i < hed.streamCount; i++)
									{
										for (uint s = 0; s < audstnames.Length; s++)
										{
											QbKey stream = QbKey.Create(id + '_' + audstnames[s]);
											if (hed.streams[i].name.Equals(stream))
											{
												//stnames[i] = audstnames[s];
												//stidx[i] = dat.streams[i].index;
												found_streams[s] = (int)i;
												vl("Found stream for " + audstnames[s]);
												break;
											}
										}
									}
									audstnames[1] = "lead";
									audstnames[2] = "bass";
								}
								for (uint i = 0; i < found_streams.Length; i++)
								{
									if (found_streams[i] == -1)
										vl("Cannot find stream " + i.ToString());
								}
								// wtf is this key 147D7BD4, comes from respawn
								// 2F9FA8C2 == respawn_song
								cant_find_fsb = !cant_find_fsb && found_streams[0] == -1;
							}
							// dismissed TODO: overwrite MP3 filenames to match fastgh3 // IT'S NOT THAT SIMPLE!!
								
							if (!cant_find_fsb)
							{
								File.Copy(source_fsb, fsb, true);
								if (!no_dat)
									File.Copy(source_dat, dat, true);
							}
							else
							{
								vl("Could not find main audio stream of the chart PAK");
								DialogResult audiolost, playsilent = DialogResult.No, searchaudioresult = DialogResult.Cancel;
								OpenFileDialog searchaudio = new OpenFileDialog()
								{
									// support online URLs in input text box?
									CheckFileExists = true,
									CheckPathExists = true,
									InitialDirectory = Path.GetDirectoryName(arg0),
									Filter = uf(T[124], false)
								};
								do
								{
									audiolost = MessageBox.Show(T[30], "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
									//audiolost = MessageBox.Show("No song audio can be found.\nDo you want to search for it?", "Warning", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1);
									if (audiolost == DialogResult.Cancel)
									{
										exit();
										killtmpf(arg0);
										return 0;
									}
									if (audiolost == DialogResult.Yes)
									{

										searchaudioresult = searchaudio.ShowDialog();
										if (searchaudioresult == DialogResult.OK)
										{
											source_fsb = searchaudio.FileName;
											playsilent = DialogResult.OK;
										}
									}
									if (audiolost == DialogResult.No || searchaudioresult == DialogResult.Cancel || !File.Exists(searchaudio.FileName))
									{
										playsilent = MessageBox.Show(T[31], "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
										//playsilent = MessageBox.Show("Want to play without audio?\nThis is not compatible with practice mode.", "Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
										if (playsilent == DialogResult.Yes)
										{
											vl(T[170], FSBcolor);
											source_fsb = "";
											File.Delete(fsb);
											// apparently now game can run without the FSB just fine
										}
									}
								}
								while (playsilent == DialogResult.No);
							}

							killgame();

							// note arrays are always first
							string[][] ts = // track_suffixes
							{
								new string[] {
									"_easy",
									"_medium",
									"_hard",
									"_expert",
								},
								new string[] {
									"",
									"_rhythm",
									"_guitarcoop",
									"_rhythmcoop",
								},
							};
							string[] phrase_suffixes = {
								"_star",
								"_starbattlemode",
							};
							string[] sectmisc = {
								"_faceoffp1",
								"_faceoffp2",
								"_bossbattlep1",
								"_bossbattlep2",
								"_timesig",
								"_fretbars",
								"_markers",
								"_scripts",
								//"_anim",
								//"_triggers",
								//"_cameras",
								//"_lightshow",
								//"_crowd",
								//"_drums",
								//"_performance",
							};
							string songprefix = "_song";
							//string notesuffix = "_notes";
							//int currentItem = 0;

							byte[] __ = new byte[0xB0];
							Array.Copy(pn, 0, __, 0, pn.Length);
							Array.Copy(qn, 0, __, 0x80, qn.Length);
							string output = songpak;
							if (File.Exists(songqb))
								File.Delete(songqb);
							File.WriteAllBytes(output, __);
							PakFormat PF = new PakFormat(output, "", "", PakFormatType.PC);
							PakEditor PE = new PakEditor(PF);
							QbFile renamed_qb = new QbFile(new MemoryStream(qn), PF);

							int maxnotes = 0;
								
							string ii;
							QbKey k;
							QbItemArray item;
							bool incompat = false;
							for (int i = 0; i < ts[0].Length; i++)
							{
								for (int j = 0; j < ts[1].Length; j++)
								{
									ii = songprefix + ts[1][j] + ts[0][i];
									k = QbKey.Create(id + ii);
									item = (QbItemArray)songdata.FindItem(k, false);
									if (item != null)
									{
										// if you have less than two integers in a note track array,
										// even in a song PAK made for WT--, you might have serious life problems
										if (item.Items[0].QbItemType == QbItemType.ArrayInteger)
										{
											QbItemInteger array = ((QbItemInteger)item.Items[0]);
											maxnotes = Math.Max(maxnotes, array.Values.Length / 3);
											int test = array.Values[1];
											if ((test & 0x0F800000) != 0)
											{
												incompat = true;
												vl(T[192] + test.ToString("X8"));
												vl(T[191]);
												break;
											}
											item.ItemQbKey = QbKey.Create("fastgh3" + ii);
											renamed_qb.AddItem(item.Clone());
										}
									}
									for (int ll = 0; ll < phrase_suffixes.Length; ll++)
									{
										ii = ts[1][j] + ts[0][i] + phrase_suffixes[ll];
										k = QbKey.Create(id + ii);
										item = (QbItemArray)songdata.FindItem(k, false);
										if (item != null)
										{
											item.ItemQbKey = QbKey.Create("fastgh3" + ii);
											renamed_qb.AddItem(item.Clone());
										}
									}
								}
								if (incompat)
									break;
							}
							if (!incompat)
							{
								for (int i = 0; i < sectmisc.Length; i++)
								{
									k = QbKey.Create(id + sectmisc[i]);
									item = (QbItemArray)songdata.FindItem(k, false);
									if (item != null)
									{
										item.ItemQbKey = QbKey.Create("fastgh3" + sectmisc[i]);
										renamed_qb.AddItem(item.Clone());
									}
								}
								item = (QbItemArray)songdata.FindItem(QbKey.Create("fastgh3" + sectmisc[6]), false);
								if (item != null)
								{
									if (item.Items[0].QbItemType == QbItemType.ArrayStruct)
									{
										var markers = ((QbItemStructArray)item.Items[0]);
										foreach (QbItemStruct qs in markers.Items)
										{
											var time = (QbItemInteger)qs.FindItem(QbKey.Create("time"), false);
											var marker = qs.FindItem(QbKey.Create("marker"), false);
											if (marker.QbItemType == QbItemType.StructItemQbKeyString)
											{
												var key = ((QbItemQbKey)marker).Values[0];
												foreach (string sect in sctn)
												{
													QbKey test = QbKey.Create(id + "_markers_text_" + QbKey.Create(sect).Crc.ToString("X8"));
													if (key.Crc != test.Crc)
														continue;
													vl(T[211] + test.Text + " (" + time.Values[0] + ')');
													QbItemString str = new QbItemString(renamed_qb);
													str.Create(QbItemType.SectionString);
													str.ItemQbKey = test;
													str.Strings[0] = sect;
													renamed_qb.AddItem(str);
													// couldn't inject or remove items in the struct for some reason
													// unless i'm missing something
													break;
												}
											}
										}
									}
								}
								QbItemStruct fastgh3_extra = new QbItemStruct(renamed_qb);
								fastgh3_extra.Create(QbItemType.SectionStruct);
								fastgh3_extra.ItemQbKey = QbKey.Create("fastgh3_extra");

								// poor
								renamed_qb.AddItem(fastgh3_extra);
								QbItemQbKey s = new QbItemQbKey(renamed_qb);
								s.Create(QbItemType.StructItemQbKey);
								s.ItemQbKey = QbKey.Create("original_stream_name");
								s.Values[0] = QbKey.Create(id);
								fastgh3_extra.AddItem(s);

								int endtime = -1;
								string bossName = "";
								bool isBoss = false;
								switch (id.ToLower())
								{
									case "bosstom":
										isBoss = true;
										bossName = "TomMorello";
										endtime = 197733;
										break;
									case "bossslash":
										isBoss = true;
										bossName = "slash";
										endtime = 226504;
										break;
									case "bossdevil":
										isBoss = true;
										bossName = "devil";
										endtime = 321466;
										break;
									case "bossjoe":
										isBoss = true;
										bossName = "slash";
										endtime = 236950;
										break;
								}

								if (isBoss)
								{
									QbKey key_boss_props = QbKey.Create("Boss_"+bossName+"_Props");
									QbItemQbKey QB_bossenable = new QbItemQbKey(renamed_qb);
									QB_bossenable.Create(QbItemType.StructItemQbKey);
									QB_bossenable.ItemQbKey = QbKey.Create("boss");
									QB_bossenable.Values[0] = key_boss_props; // why do i exist
									fastgh3_extra.AddItem(QB_bossenable);

									QbItemQbKey QB_bossitems = new QbItemQbKey(renamed_qb);
									QB_bossitems.Create(QbItemType.SectionQbKey);
									QB_bossitems.ItemQbKey = QbKey.Create("Boss_Props");
									QB_bossitems.Values[0] = key_boss_props;
									renamed_qb.AddItem(QB_bossitems);

									QbItemInteger QB_bossend = new QbItemInteger(renamed_qb);
									QB_bossend.Create(QbItemType.SectionInteger);
									QB_bossend.ItemQbKey = QbKey.Create(0x7DDBFF91);
									QB_bossend.Values[0] = endtime;
									renamed_qb.AddItem(QB_bossend);
								}

								renamed_qb.AlignPointers();
								string qb_name = "songs\\fastgh3.mid.qb";
								try
								{
									PE.ReplaceFile(qb_name, renamed_qb);// folder + pak + "song.qb"); // songs\fastgh3.mid.qb
								}
								catch
								{
									PE.AddFile(renamed_qb, qb_name, QbKey.Create(".qb"), false);
								}

								unkillgame();
								killtmpf(arg0);
								Console.ResetColor();
								print("Speeding up.");
								vl("Creating GH3 process...");
								Process gh3 = new Process();
								gh3.StartInfo.WorkingDirectory = folder;
								gh3.StartInfo.FileName = GH3EXEPath;

								if (cfg("Player", "MaxNotesAuto", "0") == "1")
								{
									vl("Got " + maxnotes + " max notes");
									cfgW("Player", "MaxNotes", maxnotes.ToString());
								}
								print("Ready, go!");
								gh3.Start();
								if (cfg(m, "PreserveLog", 0) == 1)
								{
									print("Press any key to exit");
									Console.ReadKey();
								}
								cfgW(m, "FinishedLog", 1);
							}
							else
							{
								MessageBox.Show(T[193], "Error (" + arg0 + ')', MessageBoxButtons.OK, MessageBoxIcon.Error);
							}
						}
					}
				}
				else
				{
					MessageBox.Show(T[210], "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				}
#endregion
			}
#endregion
			else
			{
				cfgW("Temp", fl, 1);
				print(T[96], ConsoleColor.Red);
				exit();
				MessageBox.Show(T[175] + arg0, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}
		catch (Exception ex)
		{
			// almost 3kb
			ConsoleColor oldcolor = Console.ForegroundColor;
			Console.ForegroundColor = ConsoleColor.Red;
			print(string.Format(T[215], ex.GetType().FullName, ex.Message, ex.StackTrace.ReplaceCI(T[77], "")));
			Console.WriteLine(T[216], version, builddate.ToString(), branch);
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
			Launcher.log = null;
			if (!File.Exists(folder + "launcher.txt"))
			{
				print(T[176]);
				return 1;
			}
#if true
			string log = File.ReadAllText(folder + "launcher.txt");
			if (initlog && cfg("Launcher","ErrorReporting",1)==1 && log.Length < 0x20000) // max 128 KB to upload
			{
				try {
					print("Uploading log.");

					ServicePointManager.Expect100Continue = true;
					ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00);
					ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
					
					var request = (HttpWebRequest)WebRequest.Create(
						T[197]
						// QUERY ISN'T APPEARING IN _POST BUT IT'S STILL IN REQUEST_URI
						// PARAMS HAVE TO BE PUT IN MULTIFORM, CRINGE
					);
					string boundary = new string('-', 24) + DateTime.Now.Ticks.ToString("x");
					request.ContentType = T[179] + boundary;
					request.Method = "POST";
					request.ServicePoint.Expect100Continue = true;

					// if possible, upload chart in case of error with the file
					// should check specifically when it's a chart problem so
					// it's not uploaded every single time if it's not related to the issue
					string chartgz = null;
					try
					{
						if (initlog)
						{
#if !USE_SZL
							chartgz = Convert.ToBase64String(GZipStream.CompressBuffer(File.ReadAllBytes(args[0])));
#else
							using (Stream
								i = File.OpenRead(args[0]),
								ms = new MemoryStream(),
								o = new GZipOutputStream(ms))
							{
								i.CopyTo(o);
								o.Close();
								chartgz = Convert.ToBase64String(((MemoryStream)ms).ToArray());
							}
#endif
						}
					}
					catch (Exception e)
					{
						vl(e);
					}
					string a = "";
					SHA256 _ = SHA256.Create();
					using (FileStream e = File.OpenRead(Application.ExecutablePath))
						a = BitConverter.ToString(_.ComputeHash(e)).Replace("-", "");
					// brain drain
					string body = "\r\n--" + boundary + "--";
					FormKV[] form = {
						new FormKV(log, T[206]),
						new FormKV(branch, "@b"),
						new FormKV(version, "@ver"),
						new FormKV(ToUnixTime(builddate), "@bt"),
						new FormKV(ex.GetType().FullName, "@ex"),
						new FormKV(ex.StackTrace, "@stk"),
						new FormKV(ex.Message, "@msg"),
						new FormKV(a, "@xh"),
						new FormKV(chartgz, T[207]),
					};
					for (int i = 0; i < form.Length - (chartgz == null ? 1 : 0); i++)
					{
						string itemname = form[i].Item2;
						if (itemname.StartsWith("@"))
							itemname = "name=\"" + itemname.Substring(1) + '"';
						body = string.Format(T[177], boundary, form[i].Item1, itemname) + body;
					}
					byte[] tempBuffer = Encoding.ASCII.GetBytes(body);
					request.ContentLength = tempBuffer.Length;
					using (Stream requestStream = request.GetRequestStream())
						requestStream.Write(tempBuffer, 0, tempBuffer.Length);
					try
					{
						WebResponse response = request.GetResponse();
						Stream stream2 = response.GetResponseStream();
						StreamReader reader2 = new StreamReader(stream2);
						reader2.ReadToEnd();
						// printed to check variables in PHP, outputting nothing
						// now that this is figured out (for the most part)
						print("Log saved to launcher.txt");
					}
					catch (WebException eex)
					{
						Stream stream2 = eex.Response.GetResponseStream();
						StreamReader reader2 = new StreamReader(stream2);
						print(reader2.ReadToEnd());
					}
				}
				catch (Exception eex)
				{
					print(eex);
					print(T[137]);
				}
			}
#endif

			if (newinstance)
			{
				print(T[98]);
				Console.ReadKey();
			}
			return 1;
		}
		//GC.Collect();
		exit();
		return 0;
	}
}