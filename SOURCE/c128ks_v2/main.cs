
using System;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;

class Encoder
{
	public enum Mode
	{
		Stereo,
		Joint,
		Dual,
		Mono
	}
	static int bitrates(int i)
	{
		if (i < 1) return 0;
		if (i < 15)
			return (32 + ((--i & 3) << 3) << (i >> 2)); // version 1 layer 3
		return -1; // bad
	}
	public bool forcechannels = false, stereo = false;
	public Mode mode = Mode.Joint;
	public ushort bitrate = 64;
	public ushort samplerate = 32000;
	bool variable = false;

	public string input, output;
	Process dec, enc;
	Thread dt, et;
	bool ffmpeg;
	StreamReader STDOUT => dec.StandardOutput;
	StreamWriter STDIN => enc.StandardInput;
	List<byte[]> QueuedBlocks;
	const int BlockSize = 1 << 16; // decoder doesn't surpass this (65536), typically reads ~1800 bytes
	void DecoderThread()
	{
		if (cancel)
			return;
		byte[] buf = new byte[BlockSize];
		int c = 0;
		while ((c = STDOUT.BaseStream.Read(buf, 0, BlockSize)) > 0)
		{
			if (cancel)
				return;
			byte[] trim = new byte[c];
			Array.Copy(buf, trim, c);
			QueuedBlocks.Add(trim);
			current_blocks[0] = QueuedBlocks.Count;
		}
		Console.WriteLine("Decoder done");
		done[0] = true;
		if (dec.HasExited)
			exit_codes[0] = dec.ExitCode;
	}
	void EncoderThread()
	{
		while (QueuedBlocks.Count == 0)
		{
			if (done[0])
				return;
			Thread.Sleep(1);
		}
		int i = 0;
		while (true)
		{
			while (i >= QueuedBlocks.Count)
			{
				if (cancel)
					return;
				if (done[0])
				{
					Console.WriteLine("Encoder done");
					done[1] = true;
					return;
				}
				Thread.Sleep(1);
			}
			if (cancel)
				return;
			if (enc.HasExited)
			{
				exit_codes[1] = enc.ExitCode;
				return;
			}
			// TODO: remove block(s) from list once written
			// don't know how to do it right now
			// where it doesn't interfere with the
			// async adding by the decoder thread
			byte[] block = QueuedBlocks[i++];
			STDIN.BaseStream.Write(block, 0, block.Length);
			current_blocks[1] = i;
		}
	}
	bool cancel = false;
	int[] current_blocks = { 0, 0 };
	int[] exit_codes = { 0, 0 };
	bool[] done = { false, false };
	static string bin_path = Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + '\\';
	static string ffmpeg_path = Program.where("ffmpeg.exe");

	public Encoder(string input) : this(input, null) { }
	public Encoder(string input, string output)
	{
		if (output == null)
			output = input + ".c128ks.mp3";
		ffmpeg = ffmpeg_path != null;
		this.input = input;
		this.output = output;
		dec = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = !ffmpeg ? bin_path + "sox.exe" : ffmpeg_path,
				// the only instance I can see string.Format being useful here
				RedirectStandardOutput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		enc = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = bin_path + "helix.exe",
				RedirectStandardInput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		dt = new Thread(DecoderThread);
		et = new Thread(EncoderThread);
	}

	DateTime start_time;
	public TimeSpan encoding_time = new TimeSpan(0);

	public void Start()
	{
		if (!File.Exists(input))
			throw new FileNotFoundException("Input audio cannot be found.");
		dec.StartInfo.Arguments = string.Format("{2} \"{0}\" "+(forcechannels ? "-{1}c {4} " : " ")+" -{1}r {3}",
			/* 0 */ input,
			/* 1 */ ffmpeg ? "a" : "" /* audio switch labels */,
			/* 2 */ ffmpeg ? "-hide_banner -i" : "-V3 --multi-threaded" /* program specific switches */,
			/* 3 */ samplerate,
			/* 4 */ stereo ? 2 : 1) + " -f wav -";
		enc.StartInfo.Arguments = "- \"" + output + "\" -X0 -U2 -Qquick -A1 -D -M"+((int)mode)+" -B"+bitrate.ToString();
		QueuedBlocks = new List<byte[]>();
		//Console.WriteLine("Decoder executable: " + dec.StartInfo.FileName);
		//Console.WriteLine("Decoder arguments : " + dec.StartInfo.Arguments);
		//Console.WriteLine("Encoder executable: " + enc.StartInfo.FileName);
		//Console.WriteLine("Encoder arguments : " + enc.StartInfo.Arguments);
		start_time = DateTime.Now;
		dec.Start();
		enc.Start();
		// for maximized CPU time, save bytes from decoder
		// and asynchronously write the bytes at the
		// separate speed that encoder can do
		dt.Start();
		et.Start();
		//while (!done[0])
		//{
			//Console.WriteLine(
			//	"dec: "+(current_blocks[0]).ToString().PadLeft(6)+" / "+
			//	"enc: "+(current_blocks[1]).ToString().PadLeft(6));
			//Thread.Sleep(new TimeSpan(100));
		//}
		Stop(false);
	}
	
	public void Stop()
	{
		Stop(true);
	}
	public void Stop(bool cancel)
	{
		this.cancel = cancel;
		dt.Join();
		et.Join();
		for (int i = 0; i < 1; i++)
			if (exit_codes[i] != 0)
				throw new Exception((i == 1 ? "En" : "De")+
					"coder process returned with a non-zero error code: "+exit_codes[i].ToString());
		if (cancel)
		{
			if (!dec.HasExited)
				dec.Kill();
			if (!enc.HasExited)
				enc.Kill();
			this.cancel = false;
		}
		encoding_time = DateTime.Now - start_time;
		QueuedBlocks = null;
		GC.Collect();
	}
}

static class Program
{
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
				foreach (string v in (Environment.GetEnvironmentVariable("PATH") ?? "").Split(';'))
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

	public static void Main(string[] args)
	{
		Console.WriteLine("c128ks - Encode constant rate audio files from custom songs");
		if (args.Length < 1 || args.Length > 2)
		{
			Console.WriteLine("usage: c128ks [input] [output]");
			return;
		}
		Encoder e = new Encoder(args[0], args.Length == 2 ? args[1] : null);
		Console.CancelKeyPress += (s, d) => {
			if (d.SpecialKey != ConsoleSpecialKey.ControlC)
				return;
			d.Cancel = true;
			e.Stop();
		};
		e.Start();
		Console.WriteLine(e.encoding_time);
	}
}

