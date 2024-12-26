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
	static extern bool SFW(IntPtr hWnd);

	[StructLayout(LayoutKind.Sequential)]
	struct P
	{
		[MarshalAs(UnmanagedType.I4)]
		public int x;
		[MarshalAs(UnmanagedType.I4)]
		public int y;
	}
	[StructLayout(LayoutKind.Sequential,
	CharSet = CharSet.Ansi)]
	struct DM
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
	static extern Boolean EDS(
			[param: MarshalAs(UnmanagedType.LPTStr)]
			string a,
			[param: MarshalAs(UnmanagedType.U4)]
			int b,
			[In, Out]
			ref DM c);

	static string[] T = Launcher.T;
	static string
		xmlpath = Environment.GetEnvironmentVariable(T[146]) + T[147],
		xmlDefault = Launcher.xmlDefault;
	XmlDocument xml = new XmlDocument();
	XmlNode xmlCfg;
	XmlNode xmlW, xmlH, xmlK;

	static bool disableEvents = false;

	static QbKey[] diffCRCs = {
		QbKey.Create(0xB69D6568), QbKey.Create(0x398CBA48),
		QbKey.Create(0x3EEAE02D), QbKey.Create(0xB0E46CBD)
	}, partCRCs = {
		QbKey.Create(0xBDC53CF2), QbKey.Create(0x7A7D1DCA)
	};
	static string[] diffStr = T[148].Split('%');
	static List<Size> resz = new List<Size>();
	static PakFormat pakformat;
	static PakEditor qbedit;
	static QbFile userqb;
	static Size oldres;
	static bool foundqconf = false;
	static bool userpak = false; // compatibility l:\

	private static string folder = Launcher.folder;//Path.GetDirectoryName(Application.ExecutablePath) + '\\';

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
		if (!foundqconf) { Launcher.print(T[149]); return; }
		userqb.AlignPointers();
		if (!userpak) userqb.Write(Launcher.dataf + "config.qb.xen");
		else qbedit.ReplaceFile("config.qb", userqb);
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

	//private static PakFormat bkgdPF;
	//private static PakEditor bkgdPE;
	public static Image bgImg;
	Image getBGIMG()
	{
		//if (globalPE == null)
		//return null;
		//byte[] tmp = bkgdPE.ExtractFileToBytes("24535078");
		if (!File.Exists(T[150]))
			return null;
			//return new Bitmap(4, 4);
		byte[] tmp = File.ReadAllBytes(T[150]);
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
			Launcher.vl(T[151]);
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
		//bkgdPE.ReplaceFile("24535078", ms.ToArray());
		File.WriteAllBytes(folder + T[150], ms.ToArray());
	}

	public static ushort[] keyBinds = new ushort[] {
		201, 202, 203, 204, 205, // GRYBO
		311, // starpower
		999, 219, // "cancel"/start
		235, // pauses game
		400, 401, // down/up
		220,
		307, // whammy
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
		ColorShuffle,
		Count
	}
	static string modN(int i)
	{
		return ((mods)i).ToString();
	}
	const int mxn_d = 0x100000;

	public settings()
	{
		vl2 = Launcher.cfg(Launcher.l, t.VerboseLog.ToString(), 0) == 1;
		//if (!vl2)
		//	Launcher.FreeConsole();
		Launcher.vl("Loading QBs...");
		try {
			userqb = new QbFile(Launcher.dataf + "config.qb.xen", new PakFormat("", "", "", PakFormatType.PC));
			foundqconf = true;
		} catch { }
		try {
			if (!foundqconf)
			{
				pakformat = new PakFormat(Launcher.dataf + "user.pak.xen", Launcher.dataf + "user.pak.xen", "", PakFormatType.PC, false);
				qbedit = new PakEditor(pakformat, false);
				userqb = qbedit.ReadQbFile("config.qb");
				userpak = true;
				foundqconf = true;
			}
		} catch { }
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
		vlbl.Text = "Version      : "+Launcher.version+"\nBuild date  : "+Launcher.builddate.ToLocalTime();
		// kill me
		Control[] ctrl_hints =
		{
			maxFPS, MaxN, res, ctmpb, aqlvl, dCtrl, hypers,
			diff, crLink, speed, part, replay, gh3pm, sCa,
			sFmT, RTnoi, kBnds, p2partt, setbgimg, bImg
		};
		for (int i = 0; i < ctrl_hints.Length; i++)
		{
			tt.SetToolTip(ctrl_hints[i], T[102 + i]);
		}
		spL.Text = T[122];
		selImg.Filter = Launcher.uf(T[187], true);
		//bkgdPF = new PakFormat(
		//	Program.dataf + "bkgd.pak.xen",
		//	Program.dataf + "bkgd.pab.xen", "",
		//	PakFormatType.PC, false);
		//bkgdPE = new PakEditor(bkgdPF, false);
		bImg.Image = getBGIMG();
		//setBGIMG(pbxBg.Image, false);

		SFW(Handle);
		Launcher.vl(T[152]);
		dCtrl.Value = Launcher.cfg("Player1", "Device", 0);
		RTnoi.Value = Launcher.cfg("Player", "NoIntroReadyTime", 400); // nointro_ready_time
		// people wanted unlimited FPS, but
		// then autoplay will hit too early sometimes
		maxFPS.Value = Launcher.cfg("GFX", "MaxFPS", 1000);
		hypers.Value = Launcher.cfg("Player", "Hyperspeed", 3); // Cheat_Hyperspeed
		{
			int disable_particles = Launcher.cfg("GFX", "NoParticles", 0); // disable_particles
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
		tLb.SetItemChecked((int)t.KeyboardMode, Launcher.cfg("Player", "Autostart", 1) == 0); // autolaunch_startnow
		tLb.SetItemChecked((int)t.Performance, Launcher.cfg("Player", t.Performance.ToString(), 0) == 1); // Cheat_PerformanceMode
		tLb.SetItemChecked((int)t.NoIntro, Launcher.cfg("Player", t.NoIntro.ToString(), 0) == 1); // disable_intro
		tLb.SetItemChecked((int)t.NoFail, Launcher.cfg("Player", t.NoFail.ToString(), 0) == 1); // Cheat_NoFail
		tLb.SetItemChecked((int)t.NoHUD, Launcher.cfg("Player", t.NoHUD.ToString(), 0) == 1); // hudless
		tLb.SetItemChecked((int)t.FCMode, Launcher.cfg("Player", t.FCMode.ToString(), 0) == 1); // FC_MODE
		tLb.SetItemChecked((int)t.EasyExpert, Launcher.cfg("Player", t.EasyExpert.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.Precision, Launcher.cfg("Player", t.Precision.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.DebugMenu, Launcher.cfg("Misc", "Debug", 0) == 1);
		tLb.SetItemChecked((int)t.ExitOnSongEnd, Launcher.cfg("Player", t.ExitOnSongEnd.ToString(), 0) == 1); // exit_on_song_end
		tLb.SetItemChecked((int)t.BkgdVideo, Launcher.cfg("Player", "BGVideo", 0) == 1); // enable_video
		tLb.SetItemChecked((int)t.KillHitGems, Launcher.cfg("GFX", "KillHitGems", 0) == 1); // kill_gems_on_hit
		tLb.SetItemChecked((int)t.EarlySustains, Launcher.cfg("Player", t.EarlySustains.ToString(), 0) == 1); // anytime_sustain_activation
		tLb.SetItemChecked((int)t.DisableVsync, Launcher.cfg("GFX", "VSync", 1) == 0);
		tLb.SetItemChecked((int)t.SongCaching, Launcher.cfg(Launcher.l, t.SongCaching.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.NoStartupMsg, Launcher.cfg(Launcher.l, t.NoStartupMsg.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.PreserveLog, Launcher.cfg(Launcher.l, t.PreserveLog.ToString(), 0) == 1);
		tLb.SetItemChecked((int)t.Windowed, Launcher.cfg("GFX", t.Windowed.ToString(), 1) == 1);
		tLb.SetItemChecked((int)t.Borderless, Launcher.cfg("GFX", t.Borderless.ToString(), 0) == 1);
		if (tLb.GetItemChecked((int)t.NoIntro))
		{
			RTnoi.Enabled = true;
			RTlbl.Enabled = true;
			RTms.Enabled = true;
		}
		float _ = Convert.ToSingle(Launcher.cfg("Player", "Speed", "1.0"), System.Globalization.CultureInfo.InvariantCulture) * 100;
		if (_ <= 0) { Console.WriteLine(T[153]); _ = 100; }
		speed.Value = (decimal/*wtf*/)_; // current_speedfactor
		tLb.SetItemChecked((int)t.VerboseLog, vl2);
		tLb.SetItemChecked((int)t.NoShake, Launcher.cfg("GFX", t.NoShake.ToString(), 0) == 1);
		for (int i = 0; i < (int)mods.Count; i++)
		{
			modList.SetItemChecked(i, Launcher.cfg("Modifiers", modN(i), 0) == 1);
		}
		//<s id="6f1d2b61d5a011cfbfc7444553540000">201 202 203 204 205 311 999 219 235 400 401 999 307 </s>
		xmlCfg = xml.GetElementsByTagName("r")[0];
		string keyboardID = T[123];
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
			xmlK.InnerText = string.Join(" ", keyBinds);
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
			bool diff_ = true;
			foreach (Size res_ in resz)
			{
				if (res_ == newSz)
				{
					diff_ = false;
					break;
				}
			}
			foreach (Size res_ in cantwork)
			{
				if (res_ == newSz)
				{
					diff_ = false;
					break;
				}
			}
			if (diff_)
				resz.Add(newSz);
		}
		foreach (Size sz in resz)
			res.Items.Add(sz.Width.ToString() + 'x' + sz.Height.ToString());
		foreach (Size sz in unlistedres)
		{
			res.Items.Add(sz.Width.ToString() + 'x' + sz.Height.ToString());
			resz.Add(sz);
		}
		res.Text = oldres.Width.ToString() + 'x' + oldres.Height.ToString();
		//if (ini.GetSection("Player") == null)
		{
			MaxN.Value = (Launcher.cfg("Player", "MaxNotesAuto", 0) == 0)
				? Launcher.cfg("Player", "MaxNotes", mxn_d) : -1;
		}
		diff.Text = diffStr[Launcher.cfg("Player1", "Diff", 3)];
		part.SelectedIndex = Launcher.cfg("Player1", "Part", 0);
		p2partt.Checked = (Launcher.cfg("Player2", "Part", 1) != 1);
		aqlvl.Text = Math.Max(48, Convert.ToInt32(Launcher.cfg("Audio", "AB", "128"))).ToString();

		{
			int fch = Launcher.cfg("Audio", "ForceChannels", 0);
			fChCbx.Checked = fCSCbx.Enabled = fCSLbl.Enabled = fch > 0;
			fCSCbx.Checked = (fch > 0) ? (fch > 1) : true;
		}

		{
			Launcher.vl(T[156]);
			moddiag.built_in_items = new List<moddiag.OverrideItem>();
			string dbgf = Launcher.pakf + "dbg.pak.xen";
			if (!File.Exists(dbgf))
				dbgf = "";
			PakFormat O_PF = new PakFormat(
				Launcher.pakf + "qb.pak.xen", Launcher.pakf + "qb.pab.xen", dbgf, PakFormatType.PC, false);
			if (dbgf != "")
			{
				PakFormat D_PF = new PakFormat(dbgf, dbgf, "", PakFormatType.PC, false);
				PakEditor D_PE = new PakEditor(D_PF, false);
				foreach (PakHeaderItem f in D_PE.Headers.Values)
				{
					switch (f.FileType.Crc)
					{
						case 0x559566CC: // .dbg
							try {
								QbFile.PopulateDebugNames(D_PE.ExtractFileToString(f.Filename));
							} catch {}
							break;
						default:
							continue;
					}
				}
			}
			if (Launcher.branch != "unpak")
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
								Launcher.vl("Failed to load " + f.Filename);
								Launcher.vl(ex);
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
				foreach (string fn in Directory.GetFiles(Launcher.dataf + "SCRIPTS\\", "*.qb.xen", SearchOption.AllDirectories))
				{
					//Program.vl(fn);
					try
					{
						QbFile qb = new QbFile(fn, nullPF);
						moddiag.Overrides_AddDefaultItems(qb);
					}
					catch (Exception ex)
					{
						string test = Launcher.NP(fn);
						Launcher.vl("Failed to load " + test.Substring(test.IndexOf(Launcher.NP(Launcher.dataf))));
						Launcher.vl(ex);
					}
				}
			}
			Launcher.vl("done");
		}

		disableEvents = false;
	}

	void cDiff(int d)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("Player1","Diff",d);
	}
		
	void resC(object sender, EventArgs e)
	{
		cRes(resz[res.SelectedIndex].Width.ToString(), resz[res.SelectedIndex].Height.ToString());
	}

	void diffC(object sender, EventArgs e)
	{
		cDiff(diff.SelectedIndex);
	}

	void crlink(object sender, LinkLabelLinkClickedEventArgs e)
	{
		Console.Clear();
		Console.WriteLine(Launcher.cr);
	}

	void hyVC(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("Player", "Hyperspeed", Convert.ToInt32(hypers.Value));
	}

	void ctmp(object sender, EventArgs e)
	{
		string[] tmpfs = Directory.GetFiles(Path.GetTempPath(), "*.tmp.fsp", SearchOption.TopDirectoryOnly);
		foreach (string file in tmpfs)
			File.Delete(file);

		tmpfs = Directory.GetDirectories(Path.GetTempPath(), "Aspyr* FastGH3", SearchOption.TopDirectoryOnly);
		foreach (string folder in tmpfs)
			Directory.Delete(folder, true);

		tmpfs = Directory.GetFiles(Path.GetTempPath(), "libSoX.tmp.*", SearchOption.TopDirectoryOnly);
		foreach (string file in tmpfs)
			File.Delete(file);
		if (File.Exists(Launcher.cf + ".db.ini"))
		{
			int sectCount = 0;
			string[] k = Launcher.sn(Launcher.cachf);
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
				Launcher.WSec(k[i], null, Launcher.cachf);
			}
		}
	}

	// this wont work after focusing control
	void kde(object sender, KeyEventArgs e)
	{
		//base.OnKeyDown(e);

		if (e.KeyCode == Keys.Escape)
		{
			Close();
		}
	}

	void pmo(object sender, EventArgs e)
	{
		new dllman().ShowDialog();
	}

	void vscc(object sender, EventArgs e)
	{
		if (!Directory.Exists(Launcher.cf))
			Directory.CreateDirectory(Launcher.cf);
		new songcache().ShowDialog();
	}

	void TI(string sect, string key, bool toggle)
	{
		Launcher.cfgW(sect, key, (toggle ? 1 : 0));
	}

	void stfO(object sender, EventArgs e)
	{
		// formatInterface
		songtxtfmt FI = new songtxtfmt(Regex.Unescape(Launcher.cfg(Launcher.l, Launcher.stf, "%a - %t")).Replace("\n","\r\n"));
		FI.ShowDialog();
		if (FI.DialogResult == DialogResult.OK)
		{
			Launcher.cfgW(Launcher.l, Launcher.stf, Regex.Escape(FI.f.Replace("\r", "")));
		}
	}

	void cRT(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("GFX", "NoIntroReadyTime", (int)RTnoi.Value);
	}

	void mxFPSc(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("GFX", "MaxFPS", maxFPS.Value.ToString());
	}

	void sBGi(object sender, EventArgs e)
	{
		new bgprev(getBGIMG()).ShowDialog();
	}

	void sBGc(object sender, EventArgs e)
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
	void confirmImageReplace(object sender, System.ComponentModel.CancelEventArgs e)
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

	void cAQ(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("Audio", "AB", aqlvl.Text);
	}

	void mU(object sender, ItemCheckEventArgs e)
	{
		if (disableEvents)
			return;
		TI("Modifiers", modN(e.Index), e.NewValue == CheckState.Checked);
	}

	void oKb(object sender, EventArgs e)
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

	void tU(object sender, ItemCheckEventArgs e)
	{
		if (disableEvents)
			return;
		switch ((t)e.Index)
		{
			case t.SongCaching:
			case t.VerboseLog:
			case t.PreserveLog:
			case t.NoStartupMsg:
				TI(Launcher.l, tStr(e.Index), e.NewValue == CheckState.Checked);
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
				Launcher.cfgW("GFX", "NoParticles", disable_particles);
				break;
		}
	}

	// still using these for qb mod configs
	public static object gQC(QbKey key, object def)
	{
		if (!foundqconf) { Launcher.print(T[160]); return def; }
		// find matching item's value or use a default
		// we're only accessing global/root items with this
		object _item = (userqb.FindItem(key, false));
		if (_item != null)
		{
			switch ((_item as QbItemBase).QbItemType)
			{
				case QbItemType.SectionInteger:
					return (_item as QbItemInteger).Values[0];
				case QbItemType.SectionArray:
					QbItemBase array = (_item as QbItemArray).Items[0];
					switch (array.QbItemType)
					{
						case QbItemType.ArrayInteger:
							return (array as QbItemInteger).Values;
						case QbItemType.ArrayFloat:
							return (array as QbItemFloat).Values;
						case QbItemType.ArrayQbKey:
							return (array as QbItemQbKey).Values;
						case QbItemType.ArrayString:
						case QbItemType.ArrayStringW:
							return (array as QbItemString).Strings;
					}
					throw new InvalidDataException("Unknown object type in array: "+key);
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
		if (!foundqconf) { Launcher.print(T[160]); return; }
		// find or create value
		object _item = (userqb.FindItem(key, false));
		if (value == null) return;
		Type type = value.GetType();
		if (_item == null)
		{
			if (!type.IsArray)
			{
				switch (Type.GetTypeCode(type))
				{
					case TypeCode.Int32:
						{
							QbItemInteger item = new QbItemInteger(userqb);
							item.Create(QbItemType.SectionInteger);
							userqb.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
					case TypeCode.Single:
					case TypeCode.Double:
						{
							QbItemFloat item = new QbItemFloat(userqb);
							item.Create(QbItemType.SectionFloat); // *
							userqb.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
					case TypeCode.String:
						{
							QbItemString item = new QbItemString(userqb);
							item.Create(QbItemType.SectionString); // *
							userqb.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
				}
				if (value is QbKey)
				{
					QbItemQbKey item = new QbItemQbKey(userqb);
					item.Create(QbItemType.SectionQbKey); // *
					userqb.AddItem(item);
					item.ItemQbKey = key;
				}
			}
			else
			{
				QbItemArray arraybase = new QbItemArray(userqb);
				arraybase.Create(QbItemType.SectionArray);
				arraybase.ItemQbKey = key;
				userqb.AddItem(arraybase);
				switch (Type.GetTypeCode(type.GetElementType()))
				{
					case TypeCode.Int32:
						{
							QbItemInteger item = new QbItemInteger(userqb);
							item.Create(QbItemType.ArrayInteger);
							arraybase.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
					case TypeCode.Single:
						{
							QbItemFloat item = new QbItemFloat(userqb);
							item.Create(QbItemType.ArrayFloat); // *
							arraybase.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
					case TypeCode.String:
						{
							QbItemString item = new QbItemString(userqb);
							item.Create(QbItemType.ArrayString); // *
							arraybase.AddItem(item);
							item.ItemQbKey = key;
						}
						break;
				}
				if (value is QbKey)
				{
					QbItemQbKey item = new QbItemQbKey(userqb);
					item.Create(QbItemType.ArrayQbKey); // *
					arraybase.AddItem(item);
					item.ItemQbKey = key;
				}
			}
		}
		_item = userqb.FindItem(key, false); // weird
		try
		{
			if (!type.IsArray)
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
					(_item as QbItemQbKey).Values[0] = (QbKey)value;
			}
			else
			{
				QbItemBase array = (_item as QbItemArray).Items[0];
				switch (Type.GetTypeCode(type.GetElementType()))
				{
					case TypeCode.Int32:
						(array as QbItemInteger).Values = (int[])value;
						break;
					case TypeCode.Single:
					case TypeCode.Double:
						(array as QbItemFloat).Values = (float[])value;
						break;
					case TypeCode.String:
						(array as QbItemString).Strings = (string[])value;
						break;
				}
				if (value is QbKey)
					(_item as QbItemQbKey).Values = (QbKey[])value;
			}
			svQB();
		}
		catch (Exception ex)
		{
			Console.WriteLine(T[157]);
			Console.WriteLine(ex);
		}
	}

	void mxnVC(object sender, EventArgs e)
	{
		if (disableEvents == false)
		{
			if (MaxN.Value == 0)
			{
				MaxN.Value = mxn_d;
				Launcher.cfgW("Player", "MaxNotes", MaxN.Value.ToString());
			}
			TI("Player", "MaxNotesAuto", MaxN.Value == -1);
			if (MaxN.Value != -1)
			{
				Launcher.cfgW("Player", "MaxNotes", MaxN.Value.ToString());
			}
		}
	}

	void dCtrlUpd(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("Player1", "Device", (int)dCtrl.Value);
	}

	void showmods(object sender, EventArgs e)
	{
		new moddiag().ShowDialog();
	}

	private void cFChL(object sender, EventArgs e)
	{
		fChCbx.Checked = !fChCbx.Checked;
	}

	private void cFSL(object sender, EventArgs e)
	{
		fCSCbx.Checked = !fCSCbx.Checked;
	}

	private void cFC(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		fCSCbx.Enabled = fCSLbl.Enabled = fChCbx.Checked;
		setForceChannels();
	}

	private void cFS(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		setForceChannels();
	}

	void setForceChannels()
	{
		Launcher.cfgW("Audio", "ForceChannels", (fChCbx.Checked ? (fCSCbx.Checked ? 2 : 1) : 0).ToString());
	}

	void spVC(object sender, EventArgs e)
	{
		Launcher.cfgW("Player", "Speed", speed.Value / 100);
	}

	void rGc(object sender, EventArgs e)
	{
		Process gh3 = new Process();
		gh3.StartInfo.WorkingDirectory = folder;
		gh3.StartInfo.FileName = folder + "\\game.exe";
		gh3.Start();
	}

	void pVC(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		Launcher.cfgW("Player1", "Part", part.SelectedIndex);
	}

	void p2pT(object sender, EventArgs e)
	{
		if (disableEvents)
			return;
		int part = p2partt.Checked ? 1 : 0;
		Launcher.cfgW("Player1", "Part", part);
	}
}
