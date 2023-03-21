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

	private void svQB()
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
		EasyExpert,
		Precision,
		//Performance,
		//NoShake,
		//Lefty,
		BkgdVideo,
		KillHitGems,
		EarlySustains
	}
	static string tStr(int i)
	{
		return ((t)i).ToString();
	}
	/*static string[] tStr = new string[]
	{
		"SongCaching",
		"VerboseLog",
		"PreserveLog",
		"DisableVsync",
		"NoStartupMsg",
		"",
		"",
		"",
		"Windowed",
		"Borderless",
		"",
		"",
		"",
		"",
		"",
		//"Performance",
		//"NoShake",
		//"Lefty",
		"",
		"",
		""
	};*/

	public QbKey[] tK = new QbKey[]
	{
		QbKey.Create(0),
		QbKey.Create(0),
		QbKey.Create(0),
		QbKey.Create(0),
		QbKey.Create(0),
		QbKey.Create(0x045713D3),
		QbKey.Create(0x2AF92804),
		QbKey.Create(0x32025D94),
		QbKey.Create(0),
		QbKey.Create(0),
		QbKey.Create(0xDF7FF31B),
		QbKey.Create(0xD403A7A7),
		QbKey.Create(0x3E5FD611),
		QbKey.Create(0x404B1EF4),
		QbKey.Create(0x3CA38921),
		//QbKey.Create(0x392E3940), // perf
		//NoShake,
		//Lefty,
		QbKey.Create(0x633E187F),
		QbKey.Create(0xC50E4995),
		QbKey.Create(0xF88A8D5D),
	};

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
		return ((t)i).ToString();
	}

	const bool FFQ = true; // framerate from QB, set accordingly in the FastGH3 plugin

	public const int mxn_d = 0x100000;

	public settings()
	{
		Console.SetWindowSize(80, 32);
		vl2 = Program.cfg("Misc", t.VerboseLog.ToString(), 0) == 1;
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
		DialogResult = DialogResult.OK;

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
		dCtrl.Value = (int)gQC(QbKey.Create(0xD8F8D2DE), 0);
		RTnoi.Value = (int)gQC(QbKey.Create(0x5FB765A2), 400); // nointro_ready_time
#pragma warning disable CS0162
		// people wanted unlimited FPS, but
		// then autoplay will hit too early sometimes
		if (FFQ)
			maxFPS.Value = (int)gQC(QbKey.Create(0xCEFC2AEF), 1000); // fps_max
		else
			maxFPS.Value = Convert.ToInt32(Program.cfg("Player", "MaxFPS", 1000));
#pragma warning restore CS0162
		hypers.Value = (int)gQC(QbKey.Create(0xFD6B13B4), 0); // Cheat_Hyperspeed
		{
			int disable_particles = (int)gQC(tK[(int)t.NoParticles], 0); // disable_particles
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
		for (int i = 0; i < tK.Length; i++)
			if (tK[i].Crc != 0 && i != (int)t.KeyboardMode && i != (int)t.NoParticles)
			tLb.SetItemChecked(i, (int)gQC(tK[i], 0) == 1);
		tLb.SetItemChecked((int)t.KeyboardMode, (int)gQC(QbKey.Create(0x32025D94), 1) == 0); // autolaunch_startnow
		/*tLb.SetItemChecked((int)t.NoIntro, (int)gQC(tK[(int)t.NoIntro], 0) == 1); // disable_intro
		tLb.SetItemChecked((int)t.NoFail, (int)gQC(tK[(int)t.NoFail], 0) == 1); // Cheat_NoFail
		tLb.SetItemChecked((int)t.EasyExpert, (int)gQC(tK[(int)t.EasyExpert], 0) == 1);
		tLb.SetItemChecked((int)t.Precision, (int)gQC(tK[(int)t.Precision], 0) == 1);
		tLb.SetItemChecked((int)t.DebugMenu, (int)gQC(tK[(int)t.DebugMenu], 0) == 1);
		tLb.SetItemChecked((int)t.ExitOnSongEnd, (int)gQC(tK[(int)t.ExitOnSongEnd], 0) == 1); // exit_on_song_end
		tLb.SetItemChecked((int)t.EasyExpert, (int)gQC(tK[(int)t.EasyExpert], 0) == 1); // enable_video
		tLb.SetItemChecked((int)t.Precision, (int)gQC(tK[(int)t.Precision], 0) == 1); // enable_video
		tLb.SetItemChecked((int)t.BkgdVideo, (int)gQC(tK[(int)t.BkgdVideo], 0) == 1); // enable_video
		tLb.SetItemChecked((int)t.KillHitGems, (int)gQC(tK[(int)t.KillHitGems], 0) == 1); // kill_gems_on_hit
		tLb.SetItemChecked((int)t.EarlySustains, (int)gQC(tK[(int)t.EarlySustains], 0) == 1);*/ // anytime_sustain_activation
		tLb.SetItemChecked((int)t.DisableVsync, Program.cfg("Misc", "VSync", 1) == 0);
		tLb.SetItemChecked((int)t.SongCaching, Program.cfg("Misc", t.SongCaching.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.NoStartupMsg, Program.cfg("Misc", t.NoStartupMsg.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.PreserveLog, Program.cfg("Misc", t.PreserveLog.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.Windowed, Program.cfg("Misc", t.Windowed.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.Borderless, Program.cfg("Misc", t.Borderless.ToString(), 1) == 1);
		if (tLb.GetItemChecked((int)t.NoIntro))
		{
			RTnoi.Enabled = true;
			RTlbl.Enabled = true;
			RTms.Enabled = true;
		}
		speed.Value = (decimal/*wtf*/)(float)gQC(QbKey.Create(0x16D91BC1), 1.0f) * 100; // current_speedfactor
		tLb.SetItemChecked((int)t.VerboseLog, vl2);
		//tweaksList.SetItemChecked((int)Tweaks.NoShake, (int)getQBConfig(QbKey.Create("disable_shake"), 0) == 1);
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
		//p1diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_diff"), false);
		//p2diff = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_diff"), false);
		//p1part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p1_part"), false);
		//p2part = (QbItemQbKey)userqb.FindItem(QbKey.Create("p2_part"), false);
		// WTF C#
		if ((QbKey)gQC(QbKey.Create(0x9FAAE40F), diffCRCs[3]) == diffCRCs[0].Crc)
			diff.Text = "Easy";
		else if ((QbKey)gQC(QbKey.Create(0x9FAAE40F), diffCRCs[3]) == diffCRCs[1].Crc)
			diff.Text = "Medium";
		else if ((QbKey)gQC(QbKey.Create(0x9FAAE40F), diffCRCs[3]) == diffCRCs[2].Crc)
			diff.Text = "Hard";
		else if ((QbKey)gQC(QbKey.Create(0x9FAAE40F), diffCRCs[3]) == diffCRCs[3].Crc)
			diff.Text = "Expert";
		if ((QbKey)gQC(QbKey.Create(0x93D5D362), QbKey.Create(0xBDC53CF2)) == partCRCs[0].Crc)
			part.SelectedIndex = 0;
		else// if (p1part.Values[0].Crc == partCRCs[1].Crc)
			part.SelectedIndex = 1;
		if ((QbKey)gQC(QbKey.Create(0x1541A1CC), QbKey.Create(0x7A7D1DCA)) == partCRCs[1].Crc)
			p2partt.Checked = false;
		else
			p2partt.Checked = true;
		// A CONSTANT VALUE IS EXPECTED STFU!!!!!!!!!
		/*switch (p1diff.Values[0].Crc)
		{
			case diffCRCs[0].Crc:
				break;
			case diffCRCs[1].Crc:
				break;
			case diffCRCs[2].Crc:
				break;
			case diffCRCs[3].Crc:
				break;
		// also looks redundant when i could use a loop maybe
		}*/
		aqlvl.Value = Convert.ToInt32(Program.cfg("Misc", "AB", "128"));
		disableEvents = false;
	}

	void cDiff(int difficulty)
	{
		if (disableEvents)
			return;
		sQC(QbKey.Create(0x9FAAE40F), diffCRCs[difficulty]);
		sQC(QbKey.Create(0x193E96A1), diffCRCs[difficulty]);
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
			sQC(QbKey.Create("Cheat_Hyperspeed"), Convert.ToInt32(hypers.Value));
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
		songtxtfmt FI = new songtxtfmt(Regex.Unescape(Program.cfg(m, Program.stf, "%a - %t")).Replace("\n","\r\n"));
		FI.ShowDialog();
		if (FI.DialogResult == DialogResult.OK)
		{
			Program.cfgW(m, Program.stf, Regex.Escape(FI.f.Replace("\r", "")));
		}
	}

	private void cRT(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		sQC(QbKey.Create(0x5FB765A2), (int)RTnoi.Value);
	}

	private void mxFPSc(object sender, EventArgs e)
	{
#pragma warning disable CS0162 // Unreachable code detected
		if (FFQ)
			sQC(QbKey.Create(0xCEFC2AEF), (int)maxFPS.Value);
		else
		{
			Program.cfgW("Player", "MaxFPS", maxFPS.Value.ToString());
		}
#pragma warning restore CS0162 // Unreachable code detected
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
		Program.cfgW("Misc","AB",aqlvl.Value.ToString());
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
			case t.Windowed:
			case t.Borderless:
				TI(m, tStr(e.Index), e.NewValue == CheckState.Checked);
				break;
			case t.DisableVsync: // im stupid
				TI(m, "VSync", e.NewValue == CheckState.Unchecked);
				break;
			// try replacing these with like changeConfig(index)
			// and a string/key array accessed with index
			// and funnel these cases into it
			case t.NoIntro:
				RTnoi.Enabled = e.NewValue == CheckState.Checked;
				RTlbl.Enabled = e.NewValue == CheckState.Checked;
				RTms.Enabled = e.NewValue == CheckState.Checked;
				// "control cannot fall into another case" WHY
				sQC(tK[(int)t.NoIntro], // disable_intro
							(e.NewValue == CheckState.Checked) ? 1 : 0);
				break;
			case t.ExitOnSongEnd: // exit_on_song_end
			case t.DebugMenu: // enable_button_cheats
			case t.EasyExpert: // Cheat_EasyExpert
			case t.Precision: // Cheat_PrecisionMode
			case t.BkgdVideo: // enable_video
			case t.KillHitGems: // kill_gems_on_hit
			case t.EarlySustains: // anytime_sustain_activation
				sQC(tK[e.Index],
							(e.NewValue == CheckState.Checked) ? 1 : 0);
				break;
			case t.KeyboardMode:
				sQC(tK[(int)t.KeyboardMode], // autolaunch_startnow
							(e.NewValue == CheckState.Checked ? 0 : 1));
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
				sQC(tK[(int)t.NoParticles], disable_particles);
				break;
			case t.NoFail: // Cheat_NoFail
				sQC(tK[(int)t.NoFail], e.NewValue == CheckState.Checked ? 1 : 0);
				int[] zoffs = { 20, 21 };
				int _invert = (e.NewValue == CheckState.Checked ? 1 : -1);
				/*QbItemInteger thiscodesucks =
				(QbItemInteger)
					(userqb.FindItem(QbKey.Create(0x67CF1F5D), false));
				QbItemInteger thiscodesucks2 =
				(QbItemInteger)
					(userqb.FindItem(QbKey.Create(0xDD6AB3D6), false));*/
				sQC(QbKey.Create(0x67CF1F5D), zoffs[0] * _invert);
				sQC(QbKey.Create(0xDD6AB3D6), zoffs[0] * _invert);
				//thiscodesucks.Values[0] = zoffs[0] * _invert;
				//thiscodesucks2.Values[0] = zoffs[1] * _invert;
				//svQB();
				break;
			//case Tweaks.Performance:
				//setQBConfig(QbKey.Create(0x392E3940), e.NewValue == CheckState.Checked ? 1 : 0); // Cheat_PerformanceMode
				//break;
			//case Tweaks.Lefty:
				//setQBConfig(QbKey.Create(0xBBABFA47), e.NewValue == CheckState.Checked ? 1 : 0); // p1_lefty
				//break;
			/*case Tweaks.NoShake:
				setQBConfig(QbKey.Create("disable_shake"), e.NewValue == CheckState.Checked ? 0 : 1);
				break;*/
		}
	}

	object gQC(QbKey key, object def)
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

	void sQC(QbKey key, object value)
	{
		// find or create value
		object _item = (userqb.FindItem(key, false));
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
		sQC(QbKey.Create(0xD8F8D2DE), Convert.ToInt32(dCtrl.Value));
	}

	private void spVC(object sender, EventArgs e)
	{
		sQC(QbKey.Create(0x16D91BC1), float.Parse((speed.Value / 100).ToString()));
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
