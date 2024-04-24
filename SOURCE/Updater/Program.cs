using System;
using System.IO;
using System.Net;
using System.Text;
using System.Runtime.InteropServices;
using Ionic.Zip;
using SimpleJSON;
using System.Windows.Forms;

// VS is a slow POS

static class SubstringExtensions
{
	public static string EncloseWithQuoteMarks(this string value)
	{
		return '"' + value + '"';
	}

	public static string Between(this string value, string a, string b)
	{
		int posA = value.IndexOf(a);
		int posB = value.LastIndexOf(b);
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
		return value.Substring(adjustedPosA, posB - adjustedPosA);
	}

	/// <summary>
	/// Get string value after [first] a.
	/// </summary>
	public static string Before(this string value, string a)
	{
		int posA = value.IndexOf(a);
		if (posA == -1)
		{
			return "";
		}
		return value.Substring(0, posA);
	}

	/// <summary>
	/// Get string value after [last] a.
	/// </summary>
	public static string After(this string value, string a)
	{
		int posA = value.LastIndexOf(a);
		if (posA == -1)
		{
			return "";
		}
		int adjustedPosA = posA + a.Length;
		if (adjustedPosA >= value.Length)
		{
			return "";
		}
		return value.Substring(adjustedPosA);
	}
}
class Program
{
	[DllImport("kernel32.dll", EntryPoint = "GetPrivateProfileInt", CharSet = CharSet.Unicode)]
	public static extern int GI(string a, string k, int d, string f);
	static string inif;

	static byte[] logoBits = {
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0x11, 0x11,
		0x00, 0x11, 0x11, 0x11, 0x00, 0x11, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00,
		0x00, 0x11, 0x00, 0x00, 0x00, 0x11, 0x11, 0x11, 0x00, 0x11, 0x11, 0x11,
		0x00, 0x11, 0x00, 0x10, 0x00, 0x11, 0x00, 0x10, 0x00, 0x11, 0x00, 0x11,
		0x00, 0x11, 0x00, 0x11, 0x00, 0x11, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x11, 0x00, 0x10, 0x01, 0x11, 0x00, 0x11, 0x01, 0x00, 0x10, 0x11, 0x21,
		0x00, 0x11, 0x10, 0x21, 0x10, 0x01, 0x10, 0x21, 0x11, 0x11, 0x11, 0x01,
		0x11, 0x11, 0x11, 0x01, 0x01, 0x00, 0x10, 0x01, 0x01, 0x00, 0x10, 0x21,
		0x00, 0x00, 0x10, 0x21, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10, 0x01,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22,
		0x22, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00,
		0x22, 0x22, 0x02, 0x00, 0x20, 0x22, 0x22, 0x00, 0x00, 0x00, 0x22, 0x02,
		0x02, 0x00, 0x20, 0x02, 0x22, 0x00, 0x22, 0x02, 0x22, 0x22, 0x22, 0x00,
		0x20, 0x22, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x02, 0x30,
		0x22, 0x22, 0x02, 0x33, 0x22, 0x00, 0x30, 0x33, 0x22, 0x00, 0x33, 0x03,
		0x22, 0x00, 0x33, 0x00, 0x22, 0x00, 0x33, 0x00, 0x22, 0x00, 0x33, 0x00,
		0x22, 0x00, 0x33, 0x00, 0x22, 0x00, 0x33, 0x03, 0x22, 0x00, 0x30, 0x33,
		0x22, 0x00, 0x00, 0x33, 0x22, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x33, 0x33, 0x00, 0x44, 0x33, 0x33, 0x03, 0x44, 0x00, 0x30, 0x33, 0x44,
		0x00, 0x00, 0x33, 0x44, 0x00, 0x00, 0x00, 0x44, 0x30, 0x33, 0x33, 0x44,
		0x30, 0x33, 0x33, 0x44, 0x00, 0x00, 0x33, 0x44, 0x00, 0x00, 0x33, 0x44,
		0x00, 0x30, 0x33, 0x44, 0x33, 0x33, 0x03, 0x44, 0x33, 0x33, 0x00, 0x44,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x55, 0x00, 0x00, 0x44, 0x55,
		0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x44, 0x00,
		0x44, 0x44, 0x44, 0x00, 0x44, 0x44, 0x44, 0x00, 0x00, 0x00, 0x44, 0x00,
		0x00, 0x00, 0x44, 0x55, 0x00, 0x00, 0x44, 0x55, 0x00, 0x00, 0x44, 0x50,
		0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x55, 0x55, 0x55, 0x00,
		0x55, 0x55, 0x55, 0x00, 0x00, 0x00, 0x55, 0x00, 0x00, 0x50, 0x55, 0x00,
		0x00, 0x55, 0x05, 0x00, 0x50, 0x55, 0x00, 0x00, 0x00, 0x50, 0x05, 0x00,
		0x00, 0x00, 0x55, 0x00, 0x00, 0x00, 0x55, 0x00, 0x05, 0x50, 0x55, 0x00,
		0x55, 0x55, 0x05, 0x00, 0x55, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	};

	/*
	 * 
	 * ████████   ██  ████████████  █████  ██    ██████████
	 * ████████  ███ █████████████ ███████ ██    ██████████
	 * ██       ███████      ██   ███   █████    ██      ██
	 * ██      ██ ████       ██  ███     ████    ██     ███
	 * ██     ██  █████      ██  ██        ██    ██    ███ 
	 * █████████████ █████   ██  ██   █████████████   ███  
	 * █████████████  █████  ██  ██   █████████████     ██ 
	 * ██   ██    ██     ███ ██  ██      ████    ██      ██
	 * ██   ██    ████    ██ ██  ███     ████    ████    ██
	 * ██  ██     █████  ███ ██   ███   █████    █████  ███
	 * ██  ██     ██ ██████  ██    ███████ ██    ██ ██████ 
	 * ██  ██     ██  ████   ██     █████  ██    ██  ████  
	 * 
	 */

	static uint Eswap(uint value)
	{
		return ((value & 0xFF) << 24) |
				((value & 0xFF00) << 8) |
				((value & 0xFF0000) >> 8) |
				((value & 0xFF000000) >> 24);
	}
	static uint Eswap(int value)
	{
		return Eswap((uint)value);
	}
	static ushort Eswap(ushort value)
	{
		return (ushort)((value << 8) | (value >> 8));
	}
	
	static void Main(string[] args)
	{
		Console.WriteLine();
		// i probably spent more time on this banner code and exporting to byte array than writing the actual update code
		for (int k = 2; k < 14; k++)
		{
			//string bits = "";
			Console.CursorLeft = 2;
			for (int i = 2; i < (8*7)-2; i++)
			{
				// autism
				int bit = (logoBits[(((i&7)>>1)+(k<<2)+((i>>3)<<6))] >> ((i & 1) << 2) & 7);
				char block = bit == 0 ? ' ' : '█';
				Console.ResetColor();
				switch (bit)
				{
					case 1:
						bit = 0xA;
						break;
					case 2:
						bit = 0xC;
						break;
					case 3:
						bit = 0xE;
						break;
					case 4:
						bit = 0x9;
						break;
					case 5:
						bit = 0xE;
						Console.BackgroundColor = ConsoleColor.Red;
						block = '▒';
						break;
				}
				Console.ForegroundColor = (ConsoleColor)(bit);
				Console.Write(block);
				//Console.Write(block); // double width
				// more often people will just have consolas
				// or whatever as the default font, so
				// don't bother with it here probably
				
				//bits += block;
				// can't use if i want custom colors
			}
			Console.ResetColor();
			Console.Write((char)160); //prevent red from 3 bleeding out to the right when resizing window
			Console.WriteLine();
		}
		Console.ResetColor();
		Console.WriteLine();
		Console.ForegroundColor = ConsoleColor.White;
		Console.WriteLine("  1.0\n");
		Console.ResetColor();
		Console.WriteLine("  UPDATER\n");
		
		bool testing = false;
		string dir = Path.GetDirectoryName(Application.ExecutablePath);
		Directory.SetCurrentDirectory(dir); // make path ensuring less redundant like in the launcher
		inif = dir + "\\settings.ini";

		// is this even in the right place
		string[] requiredFiles = new string[] {
			"AWL.dll",
			"binkw32.dll",
			"FastGH3.exe",
			"fmodex.dll",
			"game.exe",
			"mid2chart.exe",
		};
		foreach (string i in requiredFiles)
		{
			if (!File.Exists(dir+'\\'+i)) // EXCEPT HERE SOMEHOW
			{
				Console.WriteLine("No familiar files can be found, exiting...");
				return;
			}
		}

		DateTime buildtime  = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
		DateTime latesttime = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
		string buildname = null;
		string latestname = null;
		string vfilespath = "DATA\\MUSIC\\TOOLS\\";
		string vbin = "v.bin";
		string btbin = "bt.bin";
		if (File.Exists(vfilespath+vbin))
		{
			buildname = Encoding.UTF8.GetString(Convert.FromBase64String(File.ReadAllText(vfilespath+vbin)));
		}
		else
		{
			Console.WriteLine("Build name not found, exiting...");
			Console.ReadKey();
			return;
		}
		if (File.Exists(vfilespath+btbin))
		{
			buildtime = buildtime.AddSeconds(Eswap(BitConverter.ToInt32(File.ReadAllBytes(vfilespath+btbin),0))).ToLocalTime();
		}
		else
        {
			Console.WriteLine("Build time not found, exiting...");
			Console.ReadKey();
			return;
        }

		Console.WriteLine("Downloading version info...");
		uint latestTimestamp = 0;
		uint latestVerTime = 0;
		JSONNode devVers, buildList;
		WebClient fetcher = new WebClient();
		try
		{
			fetcher.Proxy = null;
			fetcher.Headers.Add("user-agent", "Anything");
			ServicePointManager.SecurityProtocol = (SecurityProtocolType)(0xc0 | 0x300 | 0xc00);
			latestTimestamp = Eswap(BitConverter.ToUInt32(fetcher.DownloadData("https://raw.githubusercontent.com/donnaken15/FastGH3/main/DATA/MUSIC/TOOLS/bt.bin"),0));
			latesttime = latesttime.AddSeconds(latestTimestamp).ToLocalTime();
			Console.WriteLine("Build timestamp: " + buildtime.ToString());
			Console.WriteLine("Got latest timestamp: " + latesttime.ToString());
			devVers = JSON.Parse(fetcher.DownloadString("https://donnaken15.com/fastgh3/devvers.json"));
			buildList = JSON.Parse(fetcher.DownloadString("https://donnaken15.com/fastgh3/vl.json"));
			latestname = Encoding.UTF8.GetString(Convert.FromBase64String(fetcher.DownloadString("https://donnaken15.com/fastgh3/v")));
			//latestVerTime = Convert.ToUInt32(Convert.FromBase64String(fetcher.DownloadString("https://raw.githubusercontent.com/donnaken15/FastGH3/main/DATA/MUSIC/TOOLS/v.bin")));
		}
		catch (Exception ex)
		{
			Console.WriteLine("Encountered an error when downloading version info.");
			Console.WriteLine(ex);
			Console.ReadKey();
			return;
		}
		Console.WriteLine("Current build: " + buildList[buildname]);
		Console.WriteLine("Latest build: " + buildList[latestname]);
		//Console.WriteLine(devVers[0]["date"].Value);

		bool bleeding = GI("Updater","BleedingEdge",0,
			Path.IsPathRooted(inif) ? inif : Directory.GetCurrentDirectory() + '\\' + inif) == 1;
		// set default to 1 on repo and 0 on builds??

		// should i put devlog in JSON and display here

		// also TODO: downgrading maybe for checking errors and for when they started to appear
		// as a consequence of me making this mod the most user friendly for charts

		// and probably download blacklist instead so i dont have to change this program directly
		// where it doesnt get replaced until its reinstalled
		string[] blacklist = new string[] {
			"aspyrconfig.bat",
			"data\\user.pak.xen",
			"data\\bkgd.pak.xen",
			"data\\bkgd.img.xen",
			"data\\hway.pak.xen",
			"data\\hway2.pak.xen",
			"data\\movies\\bik\\backgrnd_video.bik.xen",
			"data\\music\\fastgh3.fsb.xen",
			"data\\pak\\dbg.pak.xen",
			"data\\pak\\player.pak.xen",
			"data\\pak\\song.pak.xen",
			"data\\pak\\global.pab.xen",
			"data\\pak\\global.pak.xen",
			"data\\pak\\global_sfx.pak.xen",
			"game!.exe",
			"ionic.zip.dll",
			"settings.ini",
			"updater.exe",
			".gitignore",
			".gitmodules",
			// TODO: check for if this is the default PAK
			// in case of a later occurence of being
			// able to remove more unneeded stuff like the
			// thousands of blank textures and new menu
			// no longer using older textures
		};
		
		ZipFile buildZip;
		//string zipPath = Path.GetTempPath()+"\\FGH3_UPD.ZIP";
		string zipURL = "https://github.com/donnaken15/FastGH3/releases/latest/download/FastGH3_1.0.zip";

		// TODO: display changes since
		// TODO: also update updater.exe to update this
		// update the updater :^)
		if (bleeding)
		{
			if (latesttime > buildtime)
			{
				Console.WriteLine("Found a new dev build!");
				zipURL = "https://github.com/donnaken15/FastGH3/archive/refs/heads/main.zip";
			}
			else
            {
				Console.WriteLine("There is no new dev build.");
				Console.ReadKey();
				return;
			}
			int nearestTimestamp = 0;
			//for (int i = 0; )
			//https://raw.githubusercontent.com/donnaken15/FastGH3/0c0ff7092a1f4c482a523cf6f5da2518562bc833/DATA/MUSIC/TOOLS/bt.bin
		}
		else
		{
			if (Convert.ToUInt64(latestname) > Convert.ToUInt64(buildname))
			{
				Console.WriteLine("Found a new build!");
			}
			else
			{
				Console.WriteLine("There is no new release build.");
				Console.ReadKey();
				return;
			}
		}
		byte[] zip = fetcher.DownloadData(new Uri(zipURL));
		buildZip = ZipFile.Read(new MemoryStream(zip));
		foreach (ZipEntry f in buildZip)
		{
			try {
				if (f.IsDirectory) continue;
				bool ugh = false;
				string truename = f.FileName.ToLower();
				if (bleeding)
				{
					truename = truename.After("fastgh3-main/");
				}
				if (truename.StartsWith("source/")) continue;
				if (truename.StartsWith(".github/")) continue;
				truename = truename.Replace("/","\\");
				foreach (string g in blacklist)
				{
					if (truename == g)
					{
						ugh = true;
						break;
					}
				}
				if (ugh) continue;
				MemoryStream ms = new MemoryStream();
				f.Extract(ms);
				File.WriteAllBytes(truename, ms.ToArray());
				/*if (bleeding)
				{
					File.Copy("FastGH3-main\\"+truename,truename,true);
					File.Delete("FastGH3-main\\"+truename);
					// NET is the worst thing ever
					// READ THESE REMARKS, THESE DEVS ARE INSANE!!!!
					// https://learn.microsoft.com/en-us/dotnet/api/system.io.file.move?view=netframework-4.0#system-io-file-move(system-string-system-string-system-boolean)
				}*/
			}
			catch (Exception ex)
			{
				Console.WriteLine("Error occured from extracting "+f.FileName);
				Console.WriteLine(ex);
			}
		}
		/*if (bleeding)
		{
			Directory.Delete("FastGH3-main\\",true);
		}*/
		buildZip.Dispose();
		//File.Delete(zipPath);
		Console.WriteLine("Done.");
		Console.ReadKey();
	}
}
