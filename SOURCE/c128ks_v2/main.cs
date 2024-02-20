
using System;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;

class Encoder
{
	static int brs(int i)
	{
		if (i < 1) return 0;
		if (i < 15)
			return (32 + ((--i & 3) << 3) << (i >> 2)); // version 1 layer 3
		return -1; // bad
	}

	void DT()
	{
		if (C)
			return;
		byte[] buf = new byte[BS];
		int c = 0;
		int i = 0;
		int ret = 0;
		Stream OUT = dec.StandardOutput.BaseStream;
		while (true)
		{
			if (C)
				return;
			ret = OUT.Read(buf, c, BS - c);
			c += ret;
			if (ret > 0) {
				if (c == BS)
				{
					QB.Add((byte[])buf.Clone());
					cb[0] = i++;
					c = 0;
				}
			} else {
				byte[] remaining = new byte[c];
				Array.Copy(buf, remaining, c);
				QB.Add(remaining);
				cb[0] = i++;
				break;
			}
		}
		if (info && !logging)
			done_text(false);
		done[0] = true;
		if (dec.HasExited)
			xc[0] = dec.ExitCode;
	}
	void ET()
	{
		while (QB.Count == 0)
		{
			if (done[0])
				return;
			Thread.Sleep(1);
		}
		int i = 0;
		Stream IN = enc.StandardInput.BaseStream;
		while (true)
		{
			while (i >= QB.Count)
			{
				if (C)
					return;
				if (done[0])
				{
					if (info && !logging)
						done_text(true);
					done[1] = true;
					return;
				}
				Thread.Sleep(1);
			}
			if (C)
				return;
			if (enc.HasExited)
			{
				xc[1] = enc.ExitCode;
				return;
			}
			// TODO: remove block(s) from list once written
			// don't know how to do it right now
			// where it doesn't interfere with the
			// async adding by the decoder thread
			byte[] block = QB[i];
			IN.Write(block, 0, block.Length);
			QB[i] = null;
			cb[1] = ++i;
			// because pre-increment looks cool right?
		}
	}
	string done_text(bool enc)
	{
		// \ncoder done
		return string.Format(T[3]+T[4],T[enc?5:6]);
	}
	Process dec, enc;
	Thread dt, et;
	List<byte[]> QB;
	const int BS = 1 << 17; // decoder reading doesn't surpass this (128k) in a singular call, typically reads ~1800 bytes
	public int[] cb = { 0, 0 };
	public int[] xc = { 0, 0 };
	bool[] done = { false, false };
	bool C = false;

	bool ff;

	public bool FC = false, S = false;
	public byte mode = 1;
	private ushort br = 96;
	public ushort sr = 32000;
	public bool var = false, forcerate = false;
	public bool logging = true, info = false;
	public string I, O;

	public Encoder(string i) : this(i, null) { }
	public Encoder(string i, string o)
	{
		if (o == null)
			o = i + T[0];
		ff = ffpath != null;
		this.I = i;
		this.O = o;
		dec = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = !ff ? bin + T[1] : ffpath,
				// the only instance I can see string.Format being useful here
				RedirectStandardOutput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		enc = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = bin + T[2],
				RedirectStandardInput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		dt = new Thread(DT);
		et = new Thread(ET);
	}

	DateTime start_time;
	public TimeSpan encoding_time = new TimeSpan(0);

	public void Start()
	{
		if (!File.Exists(I))
			throw new FileNotFoundException(T[7]);
		dec.StartInfo.Arguments = string.Format(T[19]+
			(FC ? T[20] : " ")+
			(forcerate ? T[21] : ""),
			/* 0 */ I,
			/* 1 */ ff ? "a" : "" /* audio switch labels */,
			/* 2 */ T[ff ? 8 : 9] /* program specific switches */,
			/* 3 */ sr,
			/* 4 */ S ? 2 : 1) + T[27] + (ff ? 'f' : 't') + T[10];
		enc.StartInfo.Arguments = T[23] + O + T[11] + ((int)mode)+T[24]+br.ToString();
		dec.StartInfo.RedirectStandardError =
			enc.StartInfo.RedirectStandardError = !logging;
		QB = new List<byte[]>();
		if (info)
		{
			// print process args
			Console.WriteLine(T[12],
				T[5], T[6], T[3]+' ', T[13], T[14],
				dec.StartInfo.FileName, dec.StartInfo.Arguments,
				enc.StartInfo.FileName, enc.StartInfo.Arguments);
			// Reading/writing %dkb per block, blocks processed:
			Console.WriteLine(T[15] + (BS >> 10).ToString() + T[16]);
		}
		start_time = DateTime.Now;
		dec.Start();
		enc.Start();
		// for maximized CPU time, save bytes from decoder
		// and asynchronously write the bytes at the
		// separate speed that encoder can do
		dt.Start();
		et.Start();
		if (info && !logging)
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
		Stop(false);
	}

	public void Stop()
	{
		Stop(true);
	}
	public void Stop(bool C)
	{
		if (C)
			if (dt.ThreadState != System.Threading.ThreadState.Running &&
				et.ThreadState != System.Threading.ThreadState.Running)
				return;
		this.C = C;
		dt.Join();
		et.Join();
		for (int i = 0; i < 1; i++)
			if (xc[i] != 0)
				throw new Exception(T[i==1?5:6] + T[3] +
					T[17] + xc[i].ToString());
		if (C)
		{
			if (!dec.HasExited)
				dec.Kill();
			if (!enc.HasExited)
				enc.Kill();
			this.C = false;
		}
		encoding_time = DateTime.Now - start_time;
		QB = null;
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
24:  -B
25: ffmpeg.exe
26: Aborting...
27:  -
28: PATH
*/
	static string[] T = Encoding.ASCII.GetString(Encoding.Unicode.GetBytes(
		"挮㈱欸⹳灭┳潳⹸硥╥敨楬⹸硥╥潣敤╲搠湯╥湅䐥╥湉異⁴畡楤⁯慣湮瑯戠⁥潦湵⹤ⴥ楨敤扟湡" +
		"敮⁲椭ⴥ㍖ⴠ洭汵楴琭牨慥敤╤眠癡ⴠ∥ⴠじⴠ㉕ⴠ煑極正ⴠㅁⴠ⁄䴭笥細㉻筽紳›㕻੽" +
		"ほ筽紲㑻㩽笠紶笊紱㉻筽紳›㝻੽ㅻ筽紲㑻㩽笠紸攥數畣慴汢╥牡畧敭瑮⁳別慥楤杮" +
		"眯楲楴杮┠扫瀠牥戠潬正‬汢捯獫瀠潲散獳摥┺瀠潲散獳爠瑥牵敮⁤楷桴愠渠湯稭牥⁯牥潲⁲潣敤" +
		"›䤥癮污摩愠杲浵湥㩴┠㉻⁽笢細┢ⴠㅻ捽笠紴┠笭紱⁲㍻╽⽤㩥┠‭┢ⴠ╂晦灭来攮數䄥潢瑲湩⹧⸮‥┭䅐䡔"
	)).Split('%');
	static string bin = Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + '\\';
	static string ffpath = where(T[25]);

	// PROGRAM

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
			{
				foreach (string v in (Environment.GetEnvironmentVariable(T[28]) ?? "").Split(';'))
				{
					string p = v.Trim();
					if (!string.IsNullOrEmpty(p) && File.Exists(p = Path.Combine(p, e)))
						return Path.GetFullPath(p);
				}
			}
			return null;
			//throw new FileNotFoundException(new FileNotFoundException().Message, exe);
		}
		return Path.GetFullPath(e);
	}

	// desperate
	public static string RS(string _)
	{
		return Encoding.ASCII.GetString(Encoding.Unicode.GetBytes(_));
	}

	public static int Main(string[] args)
	{
		//c128ks - Encode constant rate audio files from custom songs
		Console.WriteLine(RS("ㅣ㠲獫ⴠ䔠据摯⁥潣獮慴瑮爠瑡⁥畡楤⁯楦敬⁳牦浯挠獵潴⁭潳杮s"));
		if (args.Length < 1)
		{
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
			return 1;
		}
		Encoder e = new Encoder(args[0], args.Length >= 2 ? args[1] : null);
		if (args.Length > 2)
		{
			bool flag = true;
			char switch_name = '\0';
			for (int i = 2; i < args.Length; i++)
			{
				if (flag)
				{
					if (args[i].Length != 2 ||
						args[i][0] != '-')
					{
						throw new ArgumentException(T[18] + args[i]);
						//return;
					}
					char arg_name = args[i][1];
					switch (arg_name)
					{
						case 'q':
							e.logging = false;
							break;
						case 'p':
							e.info = true;
							break;
						case 'v':
							e.var = true;
							break;
						case 'c':
						case 'b':
						case 'r':
							if (i >= args.Length - 1)
								throw new ArgumentNullException(args[i]);
							flag = false;
							switch_name = arg_name;
							break;
						default:
							throw new ArgumentException(T[18] + args[i]);
					}
				}
				else
				{
					// only integer arguments right now
					ushort value = ushort.Parse(args[i], System.Globalization.CultureInfo.InvariantCulture);
					switch (switch_name)
					{
						case 'c':
							e.FC = true;
							e.mode = (byte)((e.S = (value != 1)) ? 1 : 3);
							break;
						case 'b':
							e.br = Math.Min(Math.Max(value, (ushort)48), (ushort)320);
							break;
						case 'r':
							e.forcerate = true;
							e.sr = value;
							break;
						default:
							throw new ArgumentException(T[18]+args[i]);
					}
					flag = true;
				}
			}
		}
		Console.CancelKeyPress += (s, d) => {
			if (d.SpecialKey != ConsoleSpecialKey.ControlC)
				return;
			Console.WriteLine(T[26]);
			d.Cancel = true;
			e.Stop();
		};
		e.Start();
		Console.WriteLine(e.encoding_time);
		return 0;
	}
}

