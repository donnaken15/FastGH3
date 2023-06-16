using System.Windows.Forms;
using System.IO;
using System;
using System.Drawing;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using Nanook.QueenBee.Parser;
using System.Xml;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Text.RegularExpressions;

public partial class settings : Form
{
	[DllImport("user32.dll", EntryPoint = "SetForegroundWindow")]
	public static extern bool SFW(IntPtr hWnd);

	[StructLayout(LayoutKind.Sequential)]
	public struct P
	{
		[MarshalAs(UnmanagedType.I4)]
		public int x;
		[MarshalAs(UnmanagedType.I4)]
		public int y;
	}
	[StructLayout(LayoutKind.Sequential,
	CharSet = CharSet.Ansi)]
	public struct DM
	{
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
		public string a;
		[MarshalAs(UnmanagedType.U2)]
		public UInt16 b;
		[MarshalAs(UnmanagedType.U2)]
		public UInt16 c;
		[MarshalAs(UnmanagedType.U2)]
		public UInt16 _;
		[MarshalAs(UnmanagedType.U2)]
		public UInt16 d;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 e;
		public P f;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 g;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 _h;
		[MarshalAs(UnmanagedType.I2)]
		public Int16 i;
		[MarshalAs(UnmanagedType.I2)]
		public Int16 j;
		[MarshalAs(UnmanagedType.I2)]
		public Int16 k;
		[MarshalAs(UnmanagedType.I2)]
		public Int16 l;
		[MarshalAs(UnmanagedType.I2)]
		public Int16 m;
		[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
		public string n;
		[MarshalAs(UnmanagedType.U2)]
		public UInt16 o;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 p;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 w;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 h;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 q;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 r;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 _s;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 t;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 u;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 v;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 _w;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 x;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 y;
		[MarshalAs(UnmanagedType.U4)]
		public UInt32 z;
	}

	[DllImport("user32.dll", EntryPoint = "EnumDisplaySettings")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern Boolean EDS(
			[param: MarshalAs(UnmanagedType.LPTStr)]
			string a,
			[param: MarshalAs(UnmanagedType.U4)]
			int b,
			[In, Out]
			ref DM c);

	private static string xmlpath = Environment.GetEnvironmentVariable("USERPROFILE") + "\\AppData\\Local\\Aspyr\\FastGH3\\AspyrConfig.xml",
		xmlDefault = Resources.ResourceManager.GetString("xmlDefault");
	public XmlDocument xml = new XmlDocument();
	public XmlNode xmlCfg;
	public XmlNode xmlW, xmlH, xmlK;

	private static bool disableEvents = false;

	private static QbFile userqb;
	private static QbKey[] diffCRCs = {
		QbKey.Create(0xB69D6568), QbKey.Create(0x398CBA48),
		QbKey.Create(0x3EEAE02D), QbKey.Create(0xB0E46CBD)
	}, partCRCs = {
		QbKey.Create(0xBDC53CF2), QbKey.Create(0x7A7D1DCA)
	};
	private static string[] diffStr = { "Easy", "Medium", "Hard", "Expert" };
	private static List<Size> resz = new List<Size>();
	//private static PakFormat pakformat;
	//private static PakEditor qbedit;
	private static Size oldres;

	private static string folder = Program.folder;//Path.GetDirectoryName(Application.ExecutablePath) + '\\';

	void cRes(string width, string height)
	{
		if (!disableEvents)
		{
			xmlW.InnerText = width;
			xmlH.InnerText = height;
			xml.Save(xmlpath);
			// am i doing this right
		}
	}

	bool vl2;

	private static void svQB()
	{
		userqb.AlignPointers();
		//qbedit.ReplaceFile("config.qb", userqb);
		userqb.Write(Program.dataf + "config.qb.xen");
	}

	static uint Eswap(uint value)
	{
		return ((value & 0xFF) << 24) |
				((value & 0xFF00) << 8) |
				((value & 0xFF0000) >> 8) |
				((value & 0xFF000000) >> 24);
	}

	/*static ushort Eswap(ushort value)
	{
		return (ushort)(((value & 0xFF) << 8) | ((value & 0xFF00) >> 8));
	}*/

	static byte LOBYTE(ushort value)
	{
		return (byte)(value & 0xFF);
	}

	static byte HIBYTE(ushort value)
	{
		return (byte)(value >> 8);
	}

	// https://www.c-sharpcorner.com/UploadFile/ishbandhu2009/resize-an-image-in-C-Sharp/
	private static Image rsI(Image imgToResize, Size size)
	{
		int destWidth = size.Width;
		int destHeight = size.Height;
		Bitmap b = new Bitmap(destWidth, destHeight);
		Graphics g = Graphics.FromImage(b);
		g.DrawImage(imgToResize, 0, 0, destWidth, destHeight);
		g.Dispose();
		return b;
	}

	private static PakFormat bkgdPF;
	private static PakEditor bkgdPE;
	public static Image bgImg;
	Image getBGIMG()
	{
		//if (globalPE == null)
			//return null;
		byte[] tmp = bkgdPE.ExtractFileToBytes("24535078");
		//uint imgoff = 0x28;
		//int imglen = tmp.Length - imgoff;
		uint imgoff = Eswap(BitConverter.ToUInt32(tmp, 0x1C));
		uint imglen = Eswap(BitConverter.ToUInt32(tmp, 0x20));
		byte[] imgbytes = new byte[imglen];
		Array.Copy(tmp,imgoff,imgbytes,0,imglen);
		try
		{
			//Console.WriteLine(BitConverter.ToString(imgbytes, 0, 0x28));
			//if (BitConverter.ToUInt32(imgbytes, 0) != 0x20534444)
			return Image.FromStream(new MemoryStream(imgbytes), true);
			//else
			//return DDS.DDSImage.Load(imgbytes).Images[0];
		}
		catch
		{
			Program.vl("Failed to get background image!");
			return null;
		}
	}
	static void setBGIMG(Image i, bool reconvert)
	{
		var ms = new MemoryStream();
		ms.Write(
			new byte[] {
				0x0A, 0x28, 0x11, 0x00,
				0x00, 0x00, 0x00, 0x00,
			}, 0, 8);
		byte[] dims = new byte[] {
			HIBYTE((ushort)i.Width), LOBYTE((ushort)i.Width),
			HIBYTE((ushort)i.Height), LOBYTE((ushort)i.Height),
		};
		ms.Write(dims, 0, 4);
		ms.WriteByte(0x00);
		ms.WriteByte(0x01);
		ms.Write(dims, 0, 4);
		ms.Write(
			new byte[] {
				0x00, 0x01, 0x01, 0x08, 0x05, 0x00
			}, 0, 6);
		ms.Write(
			new byte[] {
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x28,
			}, 0, 8);
		long lenptr = ms.Position;
		ms.Write(
			new byte[] {
				0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00,
			}, 0, 8);
		ImageFormat fmt = i.RawFormat;
		if (reconvert)
			fmt = ImageFormat.Jpeg;
		i.Save(ms, fmt);
		long strsize = ms.Position - 0x28;
		ms.Position = lenptr;
		ms.Write(BitConverter.GetBytes(Eswap((uint)strsize)),0,4);
		bkgdPE.ReplaceFile("24535078", ms.ToArray());
		//File.WriteAllBytes("DATA\\test22.img.xen",ms.ToArray());
	}

	ushort[] keyBinds = new ushort[] {
		201,
		202,
		203,
		204,
		205,
		311,
		999,
		219,
		235,
		400,
		401,
		220,
		307,
	};

	public enum t
	{
		SongCaching,
		VerboseLog,
		PreserveLog,
		DisableVsync,
		NoStartupMsg,
		ExitOnSongEnd,
		DebugMenu,
		KeyboardMode,
		Windowed,
		Borderless,
		NoIntro,
		NoParticles,
		NoFail,
		NoHUD,
		FCMode,
		EasyExpert,
		Precision,
		Performance,
		NoShake,
		//Lefty,
		BkgdVideo,
		KillHitGems,
		EarlySustains,
		NoStreakDisp
	}
	static string tStr(int i)
	{
		return ((t)i).ToString(); // ez INI section name thing
	}

	public enum mods
	{
		AllStrums,
		AllDoubles,
		AllTaps,
		Hopos2Taps,
		Mirror,
		ColorShuffle
	}
	const int modc = 6;
	static string modN(int i)
	{
		return ((mods)i).ToString();
	}

	const bool FFQ = true; // framerate from QB, set accordingly in the FastGH3 plugin

	public const int mxn_d = 0x100000;

	public settings()
	{
		Console.SetWindowSize(80, 32);
		vl2 = Program.cfg(Program.l, t.VerboseLog.ToString(), 0) == 1;
		Program.vl("Loading QBs...");
		//pakformat = new PakFormat(Program.dataf + "user.pak.xen", Program.dataf + "user.pak.xen", "", PakFormatType.PC, false);
		//qbedit = new PakEditor(pakformat, false);
		//userqb = qbedit.ReadQbFile("config.qb");
		userqb = new QbFile(Program.dataf + "config.qb.xen", new PakFormat("", "", "", PakFormatType.PC));
		disableEvents = true;
		if (File.Exists(xmlpath))
		{
			File.Open(xmlpath, FileMode.OpenOrCreate).Close();
			//xml = File.ReadAllText(xmlpath);
			xml.Load(xmlpath);
		}
		else
			xml.LoadXml(xmlDefault);
		//Application.VisualStyleState = System.Windows.Forms.VisualStyles.VisualStyleState.NoneEnabled;
		//DialogResult = DialogResult.OK;
		InitializeComponent();
		vlbl.Text = "Version      : "+Program.version;
		// kill me
		tt.SetToolTip(maxFPS, Program.vstr[102]);
		tt.SetToolTip(MaxN, Program.vstr[103]);
		tt.SetToolTip(res, Program.vstr[104]);
		tt.SetToolTip(ctmpb, Program.vstr[105]);
		tt.SetToolTip(aqlvl, Program.vstr[106]);
		tt.SetToolTip(dCtrl, Program.vstr[107]);
		tt.SetToolTip(hypers, Program.vstr[108]);
		tt.SetToolTip(diff, Program.vstr[109]);
		tt.SetToolTip(crLink, Program.vstr[110]);
		tt.SetToolTip(speed, Program.vstr[111]);
		tt.SetToolTip(part, Program.vstr[112]);
		tt.SetToolTip(replay, Program.vstr[113]);
		tt.SetToolTip(gh3pm, Program.vstr[114]);
		tt.SetToolTip(sCa, Program.vstr[115]);
		tt.SetToolTip(sFmT, Program.vstr[116]);
		tt.SetToolTip(RTnoi, Program.vstr[117]);
		tt.SetToolTip(kBnds, Program.vstr[118]);
		tt.SetToolTip(p2partt, Program.vstr[119]);
		tt.SetToolTip(setbgimg, Program.vstr[120]);
		tt.SetToolTip(bImg, Program.vstr[121]);
		this.spL.Text = Program.vstr[122];
		bkgdPF = new PakFormat(
			Program.dataf + "bkgd.pak.xen",
			Program.dataf + "bkgd.pab.xen", "",
			PakFormatType.PC, false);
		bkgdPE = new PakEditor(bkgdPF, false);
		bImg.Image = getBGIMG();
		//setBGIMG(pbxBg.Image, false);

		SFW(Handle);
		Program.vl("Reading settings...");
		dCtrl.Value = Program.cfg("Player1", "Device", 0);
		RTnoi.Value = Program.cfg("Player", "NoIntroReadyTime", 400); // nointro_ready_time
#pragma warning disable CS0162
		// people wanted unlimited FPS, but
		// then autoplay will hit too early sometimes
		maxFPS.Value = Program.cfg("Player", "MaxFPS", 1000);
#pragma warning restore CS0162
		hypers.Value = Program.cfg("Player", "Hyperspeed", 3); // Cheat_Hyperspeed
		{
			int disable_particles = Program.cfg("GFX", "NoParticles", 0); // disable_particles
			CheckState state = CheckState.Unchecked;
			switch (disable_particles)
			{
				case 0:
					state = CheckState.Unchecked;
					break;
				case 1:
					state = CheckState.Indeterminate;
					break;
				default:
					state = CheckState.Checked;
					break;
			}
			tLb.SetItemCheckState((int)t.NoParticles, state);
		}
		tLb.SetItemChecked((int)t.KeyboardMode, Program.cfg("Player", "Autostart", 1) == 0); // autolaunch_startnow
		tLb.SetItemChecked((int)t.Performance, Program.cfg("Player", t.Performance.ToString(), 0) == 1); // Cheat_PerformanceMode
		tLb.SetItemChecked((int)t.NoIntro, Program.cfg("Player", t.NoIntro.ToString(), 0) == 1); // disable_intro
		tLb.SetItemChecked((int)t.NoFail, Program.cfg("Player", t.NoFail.ToString(), 0) == 1); // Cheat_NoFail
		tLb.SetItemChecked((int)t.NoHUD, Program.cfg("Player", t.NoHUD.ToString(), 0) == 1); // hudless
		tLb.SetItemChecked((int)t.FCMode, Program.cfg("Player", t.FCMode.ToString(), 0) == 1); // FC_MODE
		tLb.SetItemChecked((int)t.EasyExpert, Program.cfg("Player", t.EasyExpert.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.Precision, Program.cfg("Player", t.Precision.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.DebugMenu, Program.cfg("Misc", "Debug", 0) == 1);
		tLb.SetItemChecked((int)t.ExitOnSongEnd, Program.cfg("Player", t.ExitOnSongEnd.ToString(), 0) == 1); // exit_on_song_end
		tLb.SetItemChecked((int)t.BkgdVideo, Program.cfg("Player", "BGVideo", 0) == 1); // enable_video
		tLb.SetItemChecked((int)t.KillHitGems, Program.cfg("GFX", "KillHitGems", 0) == 1); // kill_gems_on_hit
		tLb.SetItemChecked((int)t.EarlySustains, Program.cfg("Player", t.EarlySustains.ToString(), 0) == 1); // anytime_sustain_activation
		tLb.SetItemChecked((int)t.DisableVsync, Program.cfg("GFX", "VSync", 1) == 0);
		tLb.SetItemChecked((int)t.SongCaching, Program.cfg(Program.l, t.SongCaching.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.NoStartupMsg, Program.cfg(Program.l, t.NoStartupMsg.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.PreserveLog, Program.cfg(Program.l, t.PreserveLog.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.Windowed, Program.cfg("GFX", t.Windowed.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.Borderless, Program.cfg("GFX", t.Borderless.ToString(), 1) == 1);
		if (tLb.GetItemChecked((int)t.NoIntro))
		{
			RTnoi.Enabled = true;
			RTlbl.Enabled = true;
			RTms.Enabled = true;
		}
		speed.Value = (decimal/*wtf*/)Convert.ToSingle(Program.cfg("Player", "Speed", "1.0")) * 100; // current_speedfactor
		tLb.SetItemChecked((int)t.VerboseLog, vl2);
		tLb.SetItemChecked((int)t.NoShake, Program.cfg("GFX", t.NoShake.ToString(), 0) == 1);
		for (int i = 0; i < modc; i++)
		{
			modList.SetItemChecked(i, Program.cfg("Modifiers", modN(i), 0) == 1);
		}
		//<s id="6f1d2b61d5a011cfbfc7444553540000">201 202 203 204 205 311 999 219 235 400 401 999 307 </s>
		xmlCfg = xml.GetElementsByTagName("r")[0];
		string keyboardID = Program.vstr[123];
		foreach (XmlNode s in xmlCfg.ChildNodes)
		{
			switch (s.Attributes["id"].Value)
			{
				case "Video.Width":
					oldres.Width = Convert.ToInt32(s.InnerText);
					xmlW = s;
					break;
				case "Video.Height":
					oldres.Height = Convert.ToInt32(s.InnerText);
					xmlH = s;
					break;
				/*case keyboardID:
					string[] keybindsStr = s.InnerText.Split(" ".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
					xmlK = s;
					for (int i = 0; i < keyBinds.Length; i++)
					{
						keyBinds[i] = Convert.ToInt32(keybindsStr[i]);
					}
					break;*/
			}
			// kill me
			if (s.Attributes["id"].Value == keyboardID)
			{
				string[] keybindsStr = s.InnerText.Split(" ".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
				xmlK = s;
				for (int i = 0; i < keyBinds.Length; i++)
				{
					keyBinds[i] = Convert.ToUInt16(keybindsStr[i]);
				}
			}
		}
		if (xmlW == null)
		{
			xmlW = xml.CreateElement("s");
			oldres.Width = 1024;
			xmlW.InnerText = "1024";
			XmlAttribute stupid2 = xml.CreateAttribute("id");
			stupid2.Value = "Video.Width";
			xmlW.Attributes.Append(stupid2);
			xmlCfg.AppendChild(xmlW);
		}
		if (xmlH == null)
		{
			xmlH = xml.CreateElement("s");
			oldres.Height = 768;
			xmlH.InnerText = "768";
			XmlAttribute stupid2 = xml.CreateAttribute("id");
			stupid2.Value = "Video.Height";
			xmlH.Attributes.Append(stupid2);
			xmlCfg.AppendChild(xmlH);
		}
		if (xmlK == null)
		{
			xmlK = xml.CreateElement("s");
			xmlK.InnerText = Program.vstr[124];
			XmlAttribute stupid2 = xml.CreateAttribute("id");
			stupid2.Value = keyboardID;
			xmlK.Attributes.Append(stupid2);
			xmlCfg.AppendChild(xmlK);
		}
		DM mode = new DM();
		mode._ = (ushort)Marshal.SizeOf(mode);
		int d = 0;
		Size[] unlistedres = { // unlisted but working (i hope) (it did for me)
			new Size(960, 720),
			new Size(1440, 1080),
		};
		Size[] cantwork = { // why
			new Size(640, 480),
			new Size(720, 480),
			new Size(720, 576),
		};
		while (EDS(null, d++, ref mode) == true) // Succeeded  
		{
			Size newSz = new Size((int)mode.w, (int)mode.h);
			bool diff = true;
			foreach (Size res_ in resz)
			{
				if (res_ == newSz)
				{
					diff = false;
					break;
				}
			}
			foreach (Size res_ in cantwork)
			{
				if (res_ == newSz)
				{
					diff = false;
					break;
				}
			}
			if (diff)
				resz.Add(newSz);
		}
		foreach (Size sz in resz)
			res.Items.Add(sz.Width.ToString() + "x" + sz.Height.ToString());
		foreach (Size sz in unlistedres)
		{
			res.Items.Add(sz.Width.ToString() + "x" + sz.Height.ToString());
			resz.Add(sz);
		}
		res.Text = oldres.Width.ToString() + "x" + oldres.Height.ToString();
		//if (ini.GetSection("Player") == null)
		{
			if (Program.cfg("Player", "MaxNotesAuto", "0") == "0")
				MaxN.Value = int.Parse(Program.cfg("Player", "MaxNotes", mxn_d.ToString()));
			else
				MaxN.Value = -1;
		}
		diff.Text = diffStr[Program.cfg("Player1", "Diff", 3)];
		part.SelectedIndex = Program.cfg("Player1", "Part", 0);
		if (Program.cfg("Player2", "Part", 1) == 1)
			p2partt.Checked = false;
		else
			p2partt.Checked = true;
		aqlvl.Value = Convert.ToInt32(Program.cfg(Program.l, "AB", "128"));

		{
			Program.vl("Loading scripts for override checks...");
			moddiag.built_in_items = new List<moddiag.OverrideItem>();
			string dbgf = Program.pakf + "dbg.pak.xen";
			if (!File.Exists(dbgf))
				dbgf = "";
			PakFormat O_PF = new PakFormat(
				Program.pakf + "qb.pak.xen", Program.pakf + "qb.pab.xen", dbgf, PakFormatType.PC, false);
			if (dbgf != "")
			{
				PakFormat D_PF = new PakFormat(dbgf, dbgf, "", PakFormatType.PC, false);
				PakEditor D_PE = new PakEditor(D_PF, false);
				foreach (PakHeaderItem f in D_PE.Headers.Values)
				{
					switch (f.FileType.Crc)
					{
						case 0x559566CC: // .dbg
							try
							{
								QbFile.PopulateDebugNames(D_PE.ExtractFileToString(f.Filename));
							}
							catch (Exception ex) {}
							break;
						default:
							continue;
					}
				}
			}
			if (false)
			{
				PakEditor O_PE = new PakEditor(O_PF, false);
				foreach (PakHeaderItem f in O_PE.Headers.Values)
				{
					switch (f.FileType.Crc)
					{
						// cringe C# "constant value expected" STFU I DO WHAT I WANT
						case 0xA7F505C4: // .qb
							try
							{
								QbFile qb = O_PE.ReadQbFile(f.Filename);
								moddiag.Overrides_AddDefaultItems(qb);
								break;
							}
							catch (Exception ex)
							{
								Program.vl("Failed to load " + f.Filename);
								Program.vl(ex);
								continue;
							}
						default:
							continue;
					}
				}
			}
			else
			{
				PakFormat nullPF = new PakFormat("", "", "", PakFormatType.PC);
				foreach (string fn in Directory.GetFiles(Program.dataf + "SCRIPTS\\", "*.qb.xen", SearchOption.AllDirectories))
				{
					//Program.vl(fn);
					try
					{
						QbFile qb = new QbFile(fn, nullPF);
						moddiag.Overrides_AddDefaultItems(qb);
					}
					catch (Exception ex)
					{
						string test = Program.NP(fn);
						Program.vl("Failed to load " + test.Substring(test.IndexOf(Program.NP(Program.dataf))));
						Program.vl(ex);
					}
				}
			}
			Program.vl("done");
		}

		disableEvents = false;
	}

	void cDiff(int d)
	{
		if (disableEvents)
			return;
		Program.cfgW("Player1","Diff",d);
	}
		
	private void resC(object sender, EventArgs e)
	{
		cRes(resz[res.SelectedIndex].Width.ToString(), resz[res.SelectedIndex].Height.ToString());
	}

	private void diffC(object sender, EventArgs e)
	{
		cDiff(diff.SelectedIndex);
	}

	private void crlink(object sender, LinkLabelLinkClickedEventArgs e)
	{
		Console.Clear();
		Console.WriteLine(Resources.ResourceManager.GetString("credits"));
	}

	private void hyVC(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		{
			Program.cfgW("Player", "Hyperspeed", Convert.ToInt32(hypers.Value));
		}
	}

	private void ctmp(object sender, EventArgs e)
	{
		string[] tmpds;
		//string[] tmpds = Directory.GetDirectories(tmpf, "*", SearchOption.TopDirectoryOnly);
		string[] tmpfs = Directory.GetFiles(Path.GetTempPath(), "*.tmp.fsp", SearchOption.TopDirectoryOnly);
		/*foreach (string folder in tmpds)
		{
			//string[] whycs = Directory.GetFiles(folder, "*.*", SearchOption.AllDirectories);
			//foreach (string whycs2 in whycs)
			//{
				//File.Delete(whycs2);
			//}
			Directory.Delete(folder, true);
		}*/
		foreach (string file in tmpfs)
			File.Delete(file);

		tmpds = Directory.GetDirectories(Path.GetTempPath(), "Aspyr* FastGH3", SearchOption.TopDirectoryOnly);
		foreach (string folder in tmpds)
			Directory.Delete(folder, true);

		tmpfs = Directory.GetFiles(Path.GetTempPath(), "libSoX.tmp.*", SearchOption.TopDirectoryOnly);
		foreach (string file in tmpfs)
			File.Delete(file);
		if (File.Exists(Program.cf + ".db.ini"))
		{
			int sectCount = 0;
			string[] k = Program.sn(Program.cachf);
			foreach (string s in k)
			{
				if (s.StartsWith("URL") || s.StartsWith("ZIP"))
				{
					k[sectCount] = s;
					sectCount++;
				}
			}
			for (int i = 0; i < sectCount; i++)
			{
				Program.WSec(k[i], null, Program.cachf);
			}
		}
	}

	// this wont work after focusing control
	private void kde(object sender, KeyEventArgs e)
	{
		//base.OnKeyDown(e);

		if (e.KeyCode == Keys.Escape)
		{
			Application.Exit();
		}
	}

	private void pmo(object sender, EventArgs e)
	{
		new dllman().ShowDialog();
	}

	private void vscc(object sender, EventArgs e)
	{
		Directory.CreateDirectory(Program.cf);
		new songcache().ShowDialog();
	}

	void TI(string sect, string key, bool toggle)
	{
		Program.cfgW(sect, key, (toggle ? 1 : 0));
	}

	string m = "Misc";

	private void stfO(object sender, EventArgs e)
	{
		// formatInterface
		songtxtfmt FI = new songtxtfmt(Regex.Unescape(Program.cfg(Program.l, Program.stf, "%a - %t")).Replace("\n","\r\n"));
		FI.ShowDialog();
		if (FI.DialogResult == DialogResult.OK)
		{
			Program.cfgW(Program.l, Program.stf, Regex.Escape(FI.f.Replace("\r", "")));
		}
	}

	private void cRT(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Program.cfgW("GFX", "NoIntroReadyTime", (int)RTnoi.Value);
	}

	private void mxFPSc(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Program.cfgW("GFX", "MaxFPS", maxFPS.Value.ToString());
	}

	private void sBGi(object sender, EventArgs e)
	{
		new bgprev(getBGIMG()).ShowDialog();
	}

	private void sBGc(object sender, EventArgs e)
	{
		selImg.ShowDialog();
	}

	// https://math.stackexchange.com/a/3381750
	int nP2(int x)
	{
		// 2^round(log2(x))
		return (int)Math.Pow(2,Math.Round(Math.Log(x, 2)));
	}
	bool isP2(int x)
	{
		return (x & (x - 1)) == 0;
	}
	private void confirmImageReplace(object sender, System.ComponentModel.CancelEventArgs e)
	{
		Image i = Image.FromFile(selImg.FileName);
		bool nR = false;
		int nW = i.Width;
		int nH = i.Height;
		if (!isP2(i.Width))
		{
			nR = true;
			nW = nP2(i.Width);
		}
		if (!isP2(i.Height))
		{
			nR = true;
			nH = nP2(i.Height);
		}
		if (nR)
		{
			i = rsI(i, new Size(nW, nH));
		}
		bImg.Image = i;
		setBGIMG(i,nR);
		// i hate myself
		//QbItemInteger backcolrgb = (QbItemInteger)userqb.FindItem(QbKey.Create("BGCol"), false).Items[0];
		//userqb.RemoveItem(backcolrgb);
	}

	private void cAQ(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Program.cfgW(Program.l, "AB", aqlvl.Value.ToString());
	}

	private void mU(object sender, ItemCheckEventArgs e)
	{
		if (disableEvents)
			return;
		TI("Modifiers", modN(e.Index), e.NewValue == CheckState.Checked);
	}

	private void oKb(object sender, EventArgs e)
	{
		keyEdit keyChange = new keyEdit(keyBinds);
		//foreach (int a in keyBinds)
			//MessageBox.Show(a.ToString());
		if (keyChange.ShowDialog() == DialogResult.OK)
		{
			keyBinds = keyChange.kBinds;
			string keystring = "";
			foreach (int k in keyBinds)
			{
				keystring += k.ToString() + " ";
			}
			xmlK.InnerText = keystring;
			xml.Save(xmlpath);
		}
	}

	private void tU(object sender, ItemCheckEventArgs e)
	{
		if (disableEvents)
			return;
		switch ((t)e.Index)
		{
			case t.SongCaching:
			case t.VerboseLog:
			case t.PreserveLog:
			case t.NoStartupMsg:
				TI(Program.l, tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.Windowed:
			case t.Borderless:
			case t.BkgdVideo: // enable_video
			case t.NoHUD: // hudless
			case t.KillHitGems: // kill_gems_on_hit
			case t.NoStreakDisp: // disable_notestreak_notif
			case t.NoShake: // disable_shake
			case t.Performance: // Cheat_PerformanceMode
				TI("GFX", tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.DisableVsync: // im stupid
				TI("GFX", "VSync", e.NewValue == CheckState.Unchecked);
				break;
			// try replacing these with like changeConfig(index)
			// and a string/key array accessed with index
			// and funnel these cases into it
			case t.NoIntro:
				RTnoi.Enabled = e.NewValue == CheckState.Checked;
				RTlbl.Enabled = e.NewValue == CheckState.Checked;
				RTms.Enabled = e.NewValue == CheckState.Checked;
				// "control cannot fall into another case" WHY
				TI("GFX", tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.DebugMenu: // enable_button_cheats
				TI("Misc", tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.ExitOnSongEnd: // exit_on_song_end
			case t.FCMode: // FC_MODE
			case t.EasyExpert: // Cheat_EasyExpert
			case t.Precision: // Cheat_PrecisionMode
			case t.EarlySustains: // anytime_sustain_activation
			case t.NoFail: // Cheat_NoFail
				TI("Player", tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.KeyboardMode:
				TI("Player", "Autostart", e.NewValue == CheckState.Unchecked); // autolaunch_startnow
				break;
			case t.NoParticles:
				int disable_particles = 0;
				switch (e.CurrentValue)
				{
					// set to...
					case CheckState.Unchecked:
						e.NewValue = CheckState.Indeterminate;
						disable_particles = 1;
						// minimal particles
						// no hit sparks or stars
						break;
					case CheckState.Indeterminate:
						e.NewValue = CheckState.Checked;
						disable_particles = 2;
						// disabled particles
						// above with flames and lightning off
						break;
					case CheckState.Checked:
						e.NewValue = CheckState.Unchecked;
						disable_particles = 0;
						// all particles
						break;
						// HEY LOOK IT'S MINECRAFT!!11!!!1!
				}
				Program.cfgW("GFX", "NoParticles", disable_particles);
				break;
			//case t.Lefty:
				//setQBConfig(QbKey.Create(0xBBABFA47), e.NewValue == CheckState.Checked ? 1 : 0); // p1_lefty
				//break;
		}
	}

	public static object gQC(QbKey key, object def)
	{
		// find matching item's value or use a default
		// we're only accessing global/root items with this
		object _item = (userqb.FindItem(key, false));
		if (_item != null)
		{
			switch ((_item as QbItemBase).QbItemType)
			{
				case QbItemType.SectionInteger:
					return (_item as QbItemInteger).Values[0];
				case QbItemType.SectionFloat:
					return (_item as QbItemFloat).Values[0];
				case QbItemType.SectionString:
					return (_item as QbItemString).Strings[0];
				case QbItemType.SectionQbKey:
					return (_item as QbItemQbKey).Values[0];
			}
		}
		return def;
	}

	public static void sQC(QbKey key, object value)
	{
		// find or create value
		object _item = (userqb.FindItem(key, false));
		if (value == null) return;
		Type type = value.GetType();
		if (_item == null)
		{
			switch (Type.GetTypeCode(type))
			{
				case TypeCode.Int32:
					{
						QbItemInteger item = new QbItemInteger(userqb);
						item.Create(QbItemType.SectionInteger);
						item.ItemQbKey = key;
						userqb.AddItem(item);
					}
					break;
				case TypeCode.Single:
				case TypeCode.Double:
					{
						QbItemFloat item = new QbItemFloat(userqb);
						item.Create(QbItemType.SectionFloat); // *
						item.ItemQbKey = key;
						userqb.AddItem(item);
					}
					break;
				case TypeCode.String:
					{
						QbItemString item = new QbItemString(userqb);
						item.Create(QbItemType.SectionString); // *
						item.ItemQbKey = key;
						userqb.AddItem(item);
					}
					break;
			}
			if (value is QbKey)
			{
				QbItemQbKey item = new QbItemQbKey(userqb);
				item.Create(QbItemType.SectionQbKey); // *
				item.ItemQbKey = key;
				userqb.AddItem(item);
			}
		}
		_item = userqb.FindItem(key, false); // weird
		try
		{
			switch (Type.GetTypeCode(type))
			{
				case TypeCode.Int32:
					(_item as QbItemInteger).Values[0] = (int)value;
					break;
				case TypeCode.Single:
				case TypeCode.Double:
					(_item as QbItemFloat).Values[0] = (float)value;
					break;
				case TypeCode.String:
					(_item as QbItemString).Strings[0] = (string)value;
					break;
			}
			if (value is QbKey)
			{
				(_item as QbItemQbKey).Values[0] = (QbKey)value;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine("Failed to set user QB value.");
			Console.WriteLine(ex);
		}
		svQB();
	}

	private void mxnVC(object sender, EventArgs e)
	{
		if (disableEvents == false)
		{
			if (MaxN.Value == 0)
			{
				MaxN.Value = mxn_d;
				Program.cfgW("Player", "MaxNotes", MaxN.Value.ToString());
			}
			if (MaxN.Value == -1)
				Program.cfgW("Player", "MaxNotesAuto", "1");
			else
			{
				Program.cfgW("Player", "MaxNotesAuto", "0");
				Program.cfgW("Player", "MaxNotes", MaxN.Value.ToString());
			}
		}
	}

	private void dCtrlUpd(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Program.cfgW("Player1", "Device", (int)dCtrl.Value);
	}

	private void showmods(object sender, EventArgs e)
	{
		new moddiag().ShowDialog();
	}

	private void spVC(object sender, EventArgs e)
	{
		Program.cfgW("Player", "Speed", speed.Value / 100);
	}

	private void rGc(object sender, EventArgs e)
	{
		Process gh3 = new Process();
		gh3.StartInfo.WorkingDirectory = folder;
		gh3.StartInfo.FileName = folder + "\\game.exe";
		gh3.Start();
	}

	private void pVC(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		sQC(QbKey.Create("p1_part"), partCRCs[part.SelectedIndex]);
	}

	private void p2pT(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		int part = 1;
		if (p2partt.Checked)
			part = 0;
		sQC(QbKey.Create(0x1541A1CC), partCRCs[part]);
	}
}
