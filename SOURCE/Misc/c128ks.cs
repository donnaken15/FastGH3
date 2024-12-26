
// c128ks_v2
// replacement to the batch script which has inefficient I/O speed

using System;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
partial class _
{
#if false
	static int brs(int _)
	{
		if (_ < 1) return 0;
		if (_ < 15)
			return (32 + ((--_ & 3) << 3) << (_ >> 2)); // version 1 layer 3
		return -1; // bad
	}
#endif
#if !desperate
	string td(bool enc) // done text
	{
		// \ncoder done
		return string.Format(T[3]+T[4],T[enc?5:6]);
	}
#endif
	Process d, e; // sox/ffmpeg, helix
	Thread D, E; // decoder thread, encoder thread
	List<byte[]> Q; // queued blocks
	const int BS = 1 << 17; // decoder reading doesn't surpass this (128k) in a singular call, typically reads ~1800 bytes
	public int[] B = new int[2]; // current block
	public int[] X = new int[2]; // process exit codes
	bool[] done = new bool[2]; // decoder and encoder statuses
	bool C = false; // cancel task

	bool ff; // has ffmpeg

	public bool FC = false, S = false; // force channel parameter, is stereo
	public byte m = 1; // mode (0 = stereo, 1 = joint, 2 = dual, 3 = single)
	private ushort br = 96; // bitrate
	public ushort r = 32000; // sample rate
	public bool v = false, fr = false; // variable bitrate (don't use), force rate
#if !desperate
	public bool l = true, i = false; // log processes, verbose thread info
#endif
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
		D = new Thread(() => {
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
						B[0] = i++;
						c = 0;
					}
				}
				else
				{
					byte[] remaining = new byte[c];
					Array.Copy(buf, remaining, c);
					Q.Add(remaining);
					B[0] = i++;
					break;
				}
			}
#if !desperate
			if (this.i && !l)
				Console.WriteLine(T[3]+T[4], T[6]);
#endif
			done[0] = true;
			if (d.HasExited)
				X[0] = d.ExitCode;
		});
		// thread to asynchronously encode data queued by above thread
		E = new Thread(() => {
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
#if !desperate
						if (this.i && !l)
							Console.WriteLine(T[3]+T[4], T[5]);
#endif
						done[1] = true;
						return;
					}
					Thread.Sleep(1);
				}
				if (C)
					return;
				if (e.HasExited)
				{
					X[1] = e.ExitCode;
					return;
				}
				// TODO: remove block(s) from list once written
				// don't know how to do it right now
				// where it doesn't interfere with the
				// async adding by the decoder thread
				byte[] block = Q[i];
				IN.Write(block, 0, block.Length);
				Q[i] = null;
				B[1] = i++;
			}
		});
	}

#if !desperate
	DateTime st;
	public TimeSpan t = new TimeSpan(0);
#endif

	public void ST()
	{
		if (!File.Exists(I))
			throw new /*FileNotFound*/Exception(
#if !desperate
				T[7]
#endif
			);
		e.StartInfo.Arguments = T[23] + O + T[11] + ((int)m) + T[26] + (v ? 'V' : 'B') + br.ToString();
		d.StartInfo.Arguments = string.Format(T[19]+
			(FC ? T[20] : " ")+(fr ? T[21] : ""),
			/* 0 */ I,
			/* 1 */ ff ? "a" : "" /* audio switch labels */,
			/* 2 */ T[ff ? 8 : 9] /* program specific switches */,
			/* 3 */ r,
			/* 4 */ S ? 2 : 1) + T[26] + (ff ? 'f' : 't') + T[10];
		Q = new List<byte[]>();
#if !desperate
		d.StartInfo.RedirectStandardError = e.StartInfo.RedirectStandardError = !l;
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
#endif
		d.Start(); e.Start();
		// for maximized CPU time, save bytes from decoder
		// and asynchronously write the bytes at the
		// separate speed that encoder can do
		D.Start(); E.Start();
#if !desperate
		if (i && !l)
		{
			while (!done[0] || !done[1])
			{
				Console.Write(T[22]
					+(cb[0]).ToString().PadLeft(6)+'/'
					+(cb[1]).ToString().PadLeft(6)+'\r');
				Thread.Sleep(4);
			}
			Console.WriteLine();
		}
#else
		while (!done[0] || !done[1])
			Thread.Sleep(4);
#endif
		CT(false);
	}

	//public void CT()
	//{
	//	CT(true);
	//}
	public void CT(bool _)
	{
		if (_)
			if (D.ThreadState != 0 &&
				E.ThreadState != 0)
				return;
		C = _;
		D.Join();
		E.Join();
		for (int i = 0; i < 1; i++)
			if (X[i] != 0)
				throw new Exception(
#if !desperate
					T[i==1?5:6] + T[3] + T[17] + xc[i].ToString()
#endif
				);
		if (_)
		{
			if (!d.HasExited)
				d.Kill();
			if (!e.HasExited)
				e.Kill();
			C = false;
		}
#if !desperate
		t = DateTime.Now - st;
#endif
		Q = null;
		GC.Collect();
	}
	static string b = Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + '\\';

#if C128KS_STANDALONE
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

#if false
	// desperate
	public static string RS(string _)
	{
		return Encoding.ASCII.GetString(Encoding.Unicode.GetBytes(_));
	}
#endif

	public static int Main(string[] _)
	{
		//c128ks - Encode constant rate audio files from custom songs
		//Console.WriteLine(RS("ㅣ㠲獫ⴠ䔠据摯⁥潣獮慴瑮爠瑡⁥畡楤⁯楦敬⁳牦浯挠獵潴⁭潳杮s"));
		if (_.Length < 1)
		{
#if false // BLOOOAAT STILLL
			Console.WriteLine(splash);
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
						throw new /*Argument*/Exception(
#if !desperate
							T[18]+_[i]
#endif
						);
						//return;
					}
					char arg_name = _[i][1];
					switch (arg_name)
					{
#if !desperate
						case 'q':
							e.l = false;
							break;
						case 'p':
							e.i = true;
							break;
#endif
						case 'v':
							e.v = true;
							break;
						case 'c':
						case 'b':
						case 'r':
							if (i >= _.Length - 1)
								throw new /*ArgumentNull*/Exception(
#if !desperate
									_[i]
#endif
								);
							flag = false;
							switch_name = arg_name;
							break;
#if !desperate
						default:
							throw new /*Argument*/Exception(
								T[18]+_[i]
							);
#endif
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
							throw new /*Argument*/Exception(
#if !desperate
								T[18]+_[i]
#endif
							);
					}
					flag = true;
				}
			}
		}
#if !desperate
		Console.CancelKeyPress += (s, d) => {
			// thinking if this is still controllable from the command prompt during launcher, because
			// if ctrl-c is hit, song conversion and overall execution should be cancelled, but also
			// now i have the game launching ahead of time
			if (d.SpecialKey != ConsoleSpecialKey.ControlC)
				return;
			Console.WriteLine(T[25]);
			d.Cancel = true;
			e.CT(true);
		};
#endif
		e.ST();
#if !desperate
		Console.WriteLine(e.t);
#endif
		return 0;
	}
#endif
	}

