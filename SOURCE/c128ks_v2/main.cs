
using System;
using System.IO;
using System.Diagnostics;

class Encoder
{
	enum Mode
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
			return (32 + ((--i & 3) << 3) << (i >> 2));
		return -1; // bad
	}
	bool forcechannels = false, stereo = false;
	Mode mode = Mode.Joint;
	ushort bitrate = 64;
	ushort samplerate = 32000;
	bool variable = false;

	public string input, output;
	Process dec, enc;
	bool ffmpeg;
	StreamReader STDOUT
	{
		get
		{
			return dec.StandardOutput;
		}
	}
	StreamWriter STDIN
	{
		get
		{
			return enc.StandardInput;
		}
	}

	static string bin_path = Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + '\\';
	static string ffmpeg_path = Program.where("ffmpeg.exe");

	public Encoder(string input) : this(input, input + ".c128ks.mp3") { }
	public Encoder(string input, string output)
	{
		ffmpeg = ffmpeg_path != null;
		this.input = input;
		this.output = output;
		dec = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = !ffmpeg ? bin_path + "sox.exe" : ffmpeg_path,
				Arguments = (!ffmpeg ? "-V3 --multi-threaded \""+input+"\" -c 1 -r "+samplerate : "-hide_banner -i \""+input+"\" -ac 1 -ar " + samplerate) + " -f wav -",
				RedirectStandardOutput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
		enc = new Process() {
			StartInfo = new ProcessStartInfo() {
				FileName = bin_path + "helix.exe",
				Arguments = "- \"" + output + "\" -X0 -U2 -Qquick -A1 -D -EC -M3 -B"+bitrate.ToString(),
				RedirectStandardInput = true,
				//RedirectStandardError = true,
				CreateNoWindow = false,
				UseShellExecute = false
			}
		};
	}

	public TimeSpan encoding_time = new TimeSpan(0);

	static void nop(object sender, DataReceivedEventArgs e)
	{

	}

	public void Start()
	{
		//Console.WriteLine("Decoder executable: " + dec.StartInfo.FileName);
		//Console.WriteLine("Decoder arguments : " + dec.StartInfo.Arguments);
		//Console.WriteLine("Encoder executable: " + enc.StartInfo.FileName);
		//Console.WriteLine("Encoder arguments : " + enc.StartInfo.Arguments);
		DateTime start = DateTime.Now;
		//dec.ErrorDataReceived += nop;
		dec.Start();
		//dec.BeginErrorReadLine();
		//enc.ErrorDataReceived += nop;
		enc.Start();
		//enc.BeginErrorReadLine();
		// for maximized CPU time, save bytes from decoder
		// and asynchronously write the bytes at the
		// separate speed that encoder can do?
		STDOUT.BaseStream.CopyTo(STDIN.BaseStream);
		if (dec.HasExited)
			dec.WaitForExit();
		if (enc.HasExited)
			enc.WaitForExit();
		encoding_time = DateTime.Now - start;
		Console.WriteLine(encoding_time);
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
		Encoder e = new Encoder("song.ogg");
		e.Start();
	}
}

