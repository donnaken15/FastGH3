
// c128ks_v2
// replacement to the batch script which has inefficient I/O speed

using System;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;

class _
{
	static int brs(int _)
	{
		if (_ < 1) return 0;
		if (_ < 15)
			return (32 + ((--_ & 3) << 3) << (_ >> 2)); // version 1 layer 3
		return -1; // bad
	}
	string td(bool enc) // done text
	{
		// \ncoder done
		return string.Format(T[3]+T[4],T[enc?5:6]);
	}
	Process d, e; // sox/ffmpeg, helix
	Thread dt, et; // decoder thread, encoder thread
	List<byte[]> Q; // queued blocks
	const int BS = 1 << 17; // decoder reading doesn't surpass this (128k) in a singular call, typically reads ~1800 bytes
	public int[] cb = new int[2]; // current block
	public int[] xc = new int[2]; // process exit codes
	bool[] done = new bool[2]; // decoder and encoder statuses
	bool C = false; // cancel task

	bool ff; // has ffmpeg

	public bool FC = false, S = false; // force channel parameter, is stereo
	public byte m = 1; // mode (0 = stereo, 1 = joint, 2 = dual, 3 = single)
	private ushort br = 96; // bitrate
	public ushort r = 32000; // sample rate
	public bool v = false, fr = false; // variable bitrate (don't use), force rate
	public bool l = true, i = false; // log processes, verbose thread info
	public string I, O; // file names

	//public _(string i) : this(i, null) { }
	public _(string I, string O)
	{
		if (O == null)
			O = I + T[0];
		ff = ffp != null;
		this.I = I;
		this.O = O;
		// create processes for sox/ffmpeg and helix
		d = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = !ff ? b + T[1] : ffp,
				// the only instance I can see string.Format being useful here
				RedirectStandardOutput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		e = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = b + T[2],
				RedirectStandardInput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		// thread to asynchronously read bytes from decoder
		dt = new Thread(() => {
			if (C)
				return;
			byte[] buf = new byte[BS];
			int c = 0;
			int i = 0;
			int ret = 0;
			Stream OUT = d.StandardOutput.BaseStream;
			while (true)
			{
				if (C)
					return;
				ret = OUT.Read(buf, c, BS - c);
				c += ret;
				if (ret > 0)
				{
					if (c == BS)
					{
						Q.Add((byte[])buf.Clone());
						cb[0] = i++;
						c = 0;
					}
				}
				else
				{
					byte[] remaining = new byte[c];
					Array.Copy(buf, remaining, c);
					Q.Add(remaining);
					cb[0] = i++;
					break;
				}
			}
			if (this.i && !l)
				td(false);
			done[0] = true;
			if (d.HasExited)
				xc[0] = d.ExitCode;
		});
		// thread to asynchronously encode data queued by above thread
		et = new Thread(() => {
			while (Q.Count == 0)
			{
				if (done[0])
					return;
				Thread.Sleep(1);
			}
			int i = 0;
			Stream IN = e.StandardInput.BaseStream;
			while (true)
			{
				while (i >= Q.Count)
				{
					if (C)
						return;
					if (done[0])
					{
						if (this.i && !l)
							td(true);
						done[1] = true;
						return;
					}
					Thread.Sleep(1);
				}
				if (C)
					return;
				if (e.HasExited)
				{
					xc[1] = e.ExitCode;
					return;
				}
				// TODO: remove block(s) from list once written
				// don't know how to do it right now
				// where it doesn't interfere with the
				// async adding by the decoder thread
				byte[] block = Q[i];
				IN.Write(block, 0, block.Length);
				Q[i] = null;
				cb[1] = i++;
			}
		});
	}

	DateTime st;
	public TimeSpan t = new TimeSpan(0);

	public void ST()
	{
		if (!File.Exists(I))
			throw new /*FileNotFound*/Exception(T[7]);
		e.StartInfo.Arguments = T[23] + O + T[11] + ((int)m) + T[26] + (v ? 'V' : 'B') + br.ToString();
		d.StartInfo.Arguments = string.Format(T[19]+
			(FC ? T[20] : " ")+
			(fr ? T[21] : ""),
			/* 0 */ I,
			/* 1 */ ff ? "a" : "" /* audio switch labels */,
			/* 2 */ T[ff ? 8 : 9] /* program specific switches */,
			/* 3 */ r,
			/* 4 */ S ? 2 : 1) + T[26] + (ff ? 'f' : 't') + T[10];
		d.StartInfo.RedirectStandardError =
			e.StartInfo.RedirectStandardError = !l;
		Q = new List<byte[]>();
		if (i)
		{
			// print process args
			Console.WriteLine(T[12],
				T[5], T[6], T[3]+' ', T[13], T[14],
				d.StartInfo.FileName, d.StartInfo.Arguments,
				e.StartInfo.FileName, e.StartInfo.Arguments);
			// Reading/writing %dkb per block, blocks processed:
			Console.WriteLine(T[15] + (BS >> 10).ToString() + T[16]);
		}
		st = DateTime.Now;
		d.Start();
		e.Start();
		// for maximized CPU time, save bytes from decoder
		// and asynchronously write the bytes at the
		// separate speed that encoder can do
		dt.Start();
		et.Start();
		if (i && !l)
		{
			while (!done[0] || !done[1])
			{
				Console.Write(
					T[22]
						+(cb[0]).ToString().PadLeft(6)+'/'
						+(cb[1]).ToString().PadLeft(6)+'\r');
				Thread.Sleep(4);
			}
			Console.WriteLine();
		}
		CT(false);
	}

	//public void CT()
	//{
	//	CT(true);
	//}
	public void CT(bool _)
	{
		if (_)
			if (dt.ThreadState != 0 &&
				et.ThreadState != 0)
				return;
		this.C = _;
		dt.Join();
		et.Join();
		for (int i = 0; i < 1; i++)
			if (xc[i] != 0)
				throw new Exception(T[i==1?5:6] + T[3] +
					T[17] + xc[i].ToString());
		if (_)
		{
			if (!d.HasExited)
				d.Kill();
			if (!e.HasExited)
				e.Kill();
			this.C = false;
		}
		t = DateTime.Now - st;
		Q = null;
		GC.Collect();
	}
	/*
 0: .c128ks.mp3%
 1: sox.exe%
 2: helix.exe%
 3: coder%
 4:  done%
 5: En%
 6: De%
 7: Input audio cannot be found.%
 8: -hide_banner -i %
 9: -V3 --multi-threaded %
10:  -f wav -%
11: " -X0 -U2 -Qquick -A1 -D -M%
12: {0}{2}{3}: {5}
{0}{2}{4}: {6}
{1}{2}{3}: {7}
{1}{2}{4}: {8}%
13: executable%
14: arguments %
15: Reading/writing %
16: kb per block, blocks processed:%
17:  process returned with a non-zero error code: 
18: Invalid argument: 
19: {2} "{0}"
20:  -{1}c {4} 
21: -{1}r {3}
22: d/e: 
23: - "
24: ffmpeg.exe
25: Aborting...
26:  -
27: PATH
*/
	static string[] T = Encoding.ASCII.GetString(Encoding.Unicode.GetBytes(
		"挮㈱欸⹳灭┳潳⹸硥╥敨楬⹸硥╥潣敤╲搠湯╥湅䐥╥湉異⁴畡楤⁯慣湮瑯戠⁥潦湵⹤ⴥ楨敤扟湡敮⁲"+
		"椭ⴥ㍖ⴠ洭汵楴琭牨慥敤╤眠癡ⴠ∥ⴠじⴠ㉕ⴠ煑極正ⴠㅁⴠ⁄䴭笥細㉻筽紳›㕻੽ほ筽紲㑻"+
		"㩽笠紶笊紱㉻筽紳›㝻੽ㅻ筽紲㑻㩽笠紸攥數畣慴汢╥牡畧敭瑮⁳別慥楤杮眯楲楴杮┠扫瀠牥"+
		"戠潬正‬汢捯獫瀠潲散獳摥┺瀠潲散獳爠瑥牵敮⁤楷桴愠渠湯稭牥⁯牥潲⁲潣敤›䤥癮污摩愠杲浵"+
		"湥㩴┠㉻⁽笢細┢ⴠㅻ捽笠紴┠笭紱⁲㍻╽⽤㩥┠‭┢晦灭来攮數䄥潢瑲湩⹧⸮‥┭䅐䡔"
	)).Split('%');
	static string b = Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + '\\';
	static string ffp = w(T[24]);

	// PROGRAM

	//http://csharptest.net/526/how-to-search-the-environments-path-for-an-exe-or-dll/index.html
	/// <summary>
	/// Expands environment variables and, if unqualified, locates the exe in the working directory
	/// or the evironment's path.
	/// </summary>
	/// <param name="exe">The name of the executable file</param>
	/// <returns>The fully-qualified path to the file</returns>
	// <exception cref="System.IO.FileNotFoundException">Raised when the exe was not found</exception>
	public static string w(string _)
	{
		_ = Environment.ExpandEnvironmentVariables(_);
		if (!File.Exists(_))
		{
			if (Path.GetDirectoryName(_) == string.Empty)
			{
				string PATH = Environment.GetEnvironmentVariable(T[27]);
				if (PATH != null)
				{
					foreach (char c in Path.GetInvalidPathChars())
						PATH = PATH.Replace(c.ToString(), "");
					//foreach (string v in (System.Text.RegularExpressions.Regex.Replace(
					//	Environment.GetEnvironmentVariable(T[27]),
					//		'[' + new string(Path.GetInvalidPathChars()) + ']', "") ?? "").Split(';'))
					foreach (string v in PATH.Split(';'))
					{
						try
						{
							string p = v.Trim();
							if (!string.IsNullOrEmpty(p) && File.Exists(p = Path.Combine(p, _)))
								return Path.GetFullPath(p);
						}
						catch
						{

						}
					}
				}
			}
			return null;
			//throw new FileNotFoundException(new FileNotFoundException().Message, exe);
		}
		return Path.GetFullPath(_);
	}

	// desperate
	public static string RS(string _)
	{
		return Encoding.ASCII.GetString(Encoding.Unicode.GetBytes(_));
	}

	public static int Main(string[] _)
	{
		//c128ks - Encode constant rate audio files from custom songs
		//Console.WriteLine(RS("ㅣ㠲獫ⴠ䔠据摯⁥潣獮慴瑮爠瑡⁥畡楤⁯楦敬⁳牦浯挠獵潴⁭潳杮s"));
		if (_.Length < 1)
		{
#if false // BLOOOAAT STILLL
			Console.WriteLine(
				/*
				usage: c128ks [input] [output] [options]+
				flags:
				  -q             - silence processes
				  -p             - print more information (not compatible with -q)
				  -v             - convert using variable bitrate
								   (use with caution as it will break seeking in game)
				switches:
				  -c [channels]  - force conversion to stereo or mono
				  -b [bitrate]   - set target bitrate
				  -r [samprate]  - set target sample rate

				if a switch above isn't entered, the output audio
				will retain the parameter from the source audio

				press Ctrl-C to cancel conversion
				*/
				RS(
					"獵条㩥挠㈱欸⁳楛灮瑵⁝潛瑵異嵴嬠灯楴湯嵳ਫ汦条㩳 ⴠⁱ††††††‭楳敬据⁥牰捯獥敳ੳ†瀭††††††ⴠ瀠楲瑮"+
					"洠牯⁥湩潦浲瑡潩⁮渨瑯挠浯慰楴汢⁥楷桴ⴠ⥱ ⴠ⁶††††††‭潣癮牥⁴獵湩⁧慶楲扡敬戠瑩慲整"+
					" †††††††††用敳眠瑩⁨慣瑵潩⁮獡椠⁴楷汬戠敲歡猠敥楫杮椠⁮慧敭਩睳瑩档獥਺†挭嬠档湡敮獬⁝ⴠ"+
					"映牯散挠湯敶獲潩⁮潴猠整敲⁯牯洠湯੯†戭嬠楢牴瑡嵥†ⴠ猠瑥琠牡敧⁴楢牴瑡੥†爭嬠慳灭慲整⁝"+
					"ⴠ猠瑥琠牡敧⁴慳灭敬爠瑡੥椊⁦⁡睳瑩档愠潢敶椠湳琧攠瑮牥摥‬桴⁥畯灴瑵愠摵潩眊汩⁬"+
					"敲慴湩琠敨瀠牡浡瑥牥映潲⁭桴⁥潳牵散愠摵潩ਊ牰獥⁳瑃汲䌭琠⁯慣据汥挠湯敶獲潩n")
			);
#endif
			return 1;
		}
		_ e = new _(_[0], _.Length >= 2 ? _[1] : null);
		if (_.Length > 2)
		{
			bool flag = true;
			char switch_name = '\0';
			for (int i = 2; i < _.Length; i++)
			{
				if (flag)
				{
					if (_[i].Length != 2 ||
						_[i][0] != '-')
					{
						throw new /*Argument*/Exception(T[18] + _[i]);
						//return;
					}
					char arg_name = _[i][1];
					switch (arg_name)
					{
						case 'q':
							e.l = false;
							break;
						case 'p':
							e.i = true;
							break;
						case 'v':
							e.v = true;
							break;
						case 'c':
						case 'b':
						case 'r':
							if (i >= _.Length - 1)
								throw new /*ArgumentNull*/Exception(_[i]);
							flag = false;
							switch_name = arg_name;
							break;
						default:
							throw new /*Argument*/Exception(T[18] + _[i]);
					}
				}
				else
				{
					// only integer arguments right now
					ushort value = ushort.Parse(_[i], System.Globalization.CultureInfo.InvariantCulture);
					switch (switch_name)
					{
						case 'c':
							e.FC = true;
							e.m = (byte)((e.S = (value != 1)) ? 1 : 3);
							break;
						case 'b':
							e.br = ((value > 48 ? value : 48) < 320 ? value : (ushort)320);
							break;
						case 'r':
							e.fr = true;
							e.r = value;
							break;
						default:
							throw new /*Argument*/Exception(T[18]+_[i]);
					}
					flag = true;
				}
			}
		}
		Console.CancelKeyPress += (s, d) => {
			if (d.SpecialKey != ConsoleSpecialKey.ControlC)
				return;
			Console.WriteLine(T[25]);
			d.Cancel = true;
			e.CT(true);
		};
		e.ST();
		Console.WriteLine(e.t);
		return 0;
	}
}

