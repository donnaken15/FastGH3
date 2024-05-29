using System;
using System.IO;
using System.Text;

// ISO-1 compatible, yoloswag
class _
{
	static string[] T = null;
	public static byte[] STH(string _)
	{
		if ((_.Length & 1) == 1)
			throw new ArgumentException(T[4]+_);
		byte[] test = new byte[_.Length >> 1];
		for (int i = 0; i < test.Length; i++)
			test[i] = byte.Parse(_.Substring(i << 1, 2), System.Globalization.NumberStyles.HexNumber);
		return test;
	}
	public static uint[] ct = new uint[256];
	public static uint k(string t)
    {
        t = t.Replace('/', '\\').ToLower();
        if (t.Length == 8)
			try {
				byte[] alreadykey = STH(t);
				Array.Reverse(alreadykey);
				return BitConverter.ToUInt32(alreadykey, 0);
			}
			catch { }
		uint crc = 0xFFFFFFFF;
		for (int i = 0; i < t.Length; i++)
			crc = crc >> 8 & 0x00FFFFFF ^ ct[(crc ^ t[i]) & 0xFF];
		return crc;
	}
	static string[] exts = null;
	static int iOZ(string[] a, string p)
	{
		int ii = -1;
		for (int i = 0; i < exts.Length; i++)
			if ((ii = Array.IndexOf(a, p + exts[i])) != -1)
				return ii;
		return ii;
	}
	static string ext(bool b)
	{
		return ".pa" + (b ? 'b' : 'k');
	}
	static uint align(uint a, uint b)
	{
		b = (uint)unchecked(1<<(int)b);
		a = a&(uint)(b-1);
		return (a!=0) ? (b-a) : 0;
	}
	// main data boundary is 4096 = 1 << 12 (no problems encountered not aligning with this, so, not using it)
	// file data aligns to 16 = 1 << 4
	static void af(BinaryWriter w, uint b, byte f)
	{
		b = (uint)unchecked(1<<(int)b);
		uint a = (uint)w.BaseStream.Position&(uint)(b-1);
		if (a != 0)
		{
			byte[] pad = new byte[b-a];
			if (f != 0)
				for (int i = 0; i < b-a; i++)
					pad[i] = f;
			w.Write(pad);
		}
	}
	static void af(BinaryWriter w, uint b)
	{
		af(w, b, 0);
	}
	static void w(BinaryWriter w, uint _) // big endian
	{
		w.Write(
			((_ & 0xFF) << 24) |
			((_ & 0xFF00) << 8) |
			((_ & 0xFF0000) >> 8) |
			((_ & 0xFF000000) >> 24)
		);
	}
	public static int Main(string[] args)
	{
		Encoding A = Encoding.ASCII;
		Encoding U = Encoding.Unicode;
		if (args.Length < 1 || args.Length > 3)
		{
			//Console.WriteLine("GH3 PAK BUILDER");
			Console.WriteLine(
				A.GetString(U.GetBytes(
					"獵条㩥瀠歡楤⁲楛灮瑵映汯敤嵲嬠畯灴"+
					"瑵渠浡嵥嬠戭⵼嵺 ⴠ⁢⁼灳楬⁴畯灴瑵"+
					"琠⁯䅐⽋䅐ੂ†稭簠戠極摬稠湯獥‬敲畱物獥"+
					"吠塅匯乃愠摮椠灭楬獥ⴠb"
				))
			);
			return 2;
		}
		T = A.GetString(U.GetBytes(
			"湉異⁴潦摬牥渠瑯映畯摮›稥湯獥杜潬慢屬汧扯污束硦䤥癮污摩猠楷捴⁨瑳楲杮›䴥瑡档湩⁧䕔⽘䍓⁎慣湮⁥"+
			"瑯戠潦湵⹤䤠⁴獩爠煥極敲⁤潦⁲畢汩楤杮稠湯⁥䅐獋┮湕癥湥栠硥猠牴湩㩧┠⸻數㭮瀮㍳⸻獰㬲渮捧⸥捳╮琮硥"
		)).Split('%');
		
		bool c_pab = false, c_zone = false;
		string zstr = T[1];
		if (args.Length == 3)
		{
			string _switch = args[2];
			if (_switch.Length != 2 || _switch[0] != '-')
			{
				// WHY CAN'T I GOTO
				Console.WriteLine(T[2]+_switch);
				return 1;
			}
			switch (_switch[1])
			{
				case 's':
					c_pab = true;
					break;
				case 'z':
					c_zone = true;
					break;
				default:
					Console.WriteLine(T[2]+_switch);
					return 1;
			}
		}

		if (!Directory.Exists(args[0]))
		{
			Console.WriteLine(T[0] + Directory.GetCurrentDirectory() + '\\' + args[0]);
			return 1;
		}
		string output = Path.GetFullPath(args[args.Length == 1 ? 0 : 1]);
		Directory.SetCurrentDirectory(args[0]);

		uint crc, poly = 0xEDB88320;
		for (ushort i = 0; i < 256; i++)
		{
			crc = i;
			for (byte j = 0; j < 8; j++)
				crc = (((crc&1)==1) ? (crc >> 1 ^ poly) : (crc >> 1));
			ct[i] = crc;
		}
		string[] dir = Directory.GetFiles(".", "*", SearchOption.AllDirectories);
		uint filecount = (uint)dir.Length;
		uint wadoff = (filecount + 2) * 0x20;
		wadoff += align(wadoff, 4);
		exts = T[5].Split(';');
		
		int scn = -1, tex = -1;
		if (c_zone)
		{
			scn = iOZ(dir, ".\\" + zstr + T[6]);
			tex = iOZ(dir, ".\\" + zstr + T[7]);
			if (scn < 0 || tex < 0)
			{
				Console.WriteLine(T[3]);
				return 1;
			}
			if (scn != 1 && tex != 1)
			{
				if (tex > scn)
				{
					string swapval = dir[tex];
					dir[tex] = dir[scn];
					dir[scn] = swapval;
				}
				// apparently TEX has to come first
			}
		}
		
		Stream pak = File.Create(output + ext(false)), pab = null;
		if (c_zone)
			c_pab = true;
		if (c_pab)
			pab = File.Create(output + ext(true));
		BinaryWriter hed = new BinaryWriter(pak), wad = new BinaryWriter(c_pab ? pab : pak);
		
		for (uint i = 0; i < filecount; i++)
		{
			string name = dir[i].Substring(2);
			string subf = Path.GetDirectoryName(name);
			FileInfo f = new FileInfo(name);
			bool platext = Array.IndexOf(exts, Path.GetExtension(name)) > 0;
			string name_noplat = Path.GetFileNameWithoutExtension(name);
			string _ext = platext ?
				Path.GetExtension(name_noplat) : f.Extension;
			string fn = platext ? name_noplat : f.Name;
			if (!(_ext == T[6] || _ext == T[7])) // wtf
				fn = Path.GetFileNameWithoutExtension(fn);
			string realpath = (subf != "" ? (subf + '\\') : "") + fn;
			uint[] wr = new uint[]
			{
				/* 0x00-0x10 */ k(_ext), wadoff, (uint)f.Length, 0,
				/* 0x10-0x14 */ k(realpath), k(Path.GetFileNameWithoutExtension(fn)),
				/* 0x18 */ (c_zone && i == tex) ? k(zstr + T[7]) : 0,
				/* 0x1C */ (uint)((i == tex || i == scn) ? 4 : 0)
			};
			for (byte j = 0; j < wr.Length; j++)
				w(hed, wr[j]);
			wadoff += (uint)f.Length + align((uint)f.Length, 4) - 0x20;
		}
		/*
		w(hed, new uint[]
		{
			0x2CB3EF3B, // k(".last")
			wadoff,
			4,
			0,
			0x897ABB4A, // 0x897ABB4A
			0x6AF98ED1 // 0x6AF98ED1
		});
		*/
		w(hed, 0x2CB3EF3B); // k(".last")
		w(hed, wadoff);
		w(hed, 4);
		w(hed, 0);
		w(hed, 0x897ABB4A); // 0x897ABB4A
		w(hed, 0x6AF98ED1); // 0x6AF98ED1
		//hed.Write(0);
		//hed.Write(0);
		for (byte i = 0; i < 8 + 2; i++)
			hed.Write(0);
		af(hed, 4);
		for (uint i = 0; i < filecount; i++)
		{
			wad.Write(File.ReadAllBytes(dir[i]));
			af(wad, 4);
		}
		wad.Write(0xABABABAB);
		af(wad, 4);
		//af(wad, 4, 0xAB);
		return 0;
	}
}
