
using System;
using System.IO;
using System.Collections.Generic;
using F = System.IO.File;

// this is absurd
// deciding to write the class from documentation myself just because
public struct Sng
{
	public uint version;
	public byte[] xorMask;
	public Dictionary<string, string> meta;
	public List<File> files;
	public struct File
	{
		public string name;
		public byte[] data;
	}

	static string readstr(BinaryReader br)
	{
		return new string(br.ReadChars((int)br.ReadUInt32()));
	}
	public static Sng Load(string fname)
	{
		Stream f = F.OpenRead(fname);
		BinaryReader br = new BinaryReader(f, System.Text.Encoding.UTF8);
		Sng sng = new Sng();
		string magic = new string(br.ReadChars(6));
		if (magic != "SNGPKG")
		{
			throw new Exception(Launcher.T[202] + magic);
		}
		sng.version = br.ReadUInt32();
		sng.xorMask = br.ReadBytes(16); // because why
		ulong metasize = br.ReadUInt64();
		long test = f.Position;
		ulong metacount = br.ReadUInt64();
		sng.meta = new Dictionary<string, string>();
		for (ulong i = 0; i < metacount; i++)
			sng.meta.Add(readstr(br), readstr(br));
		if ((ulong)(f.Position - test) != metasize)
			Console.WriteLine(Launcher.T[203]);
		ulong idxsize = br.ReadUInt64();
		test = f.Position;
		ulong fcount = br.ReadUInt64();
		sng.files = new List<File>();
		for (ulong i = 0; i < fcount; i++)
		{
			byte fnamelen = br.ReadByte();
			string name = new string(br.ReadChars(fnamelen));
			ulong fsize = br.ReadUInt64();
			ulong index = br.ReadUInt64();
			long oldpos = f.Position;
			f.Position = (long)index;
			byte[] data = br.ReadBytes((int)fsize);
			for (int x = 0; x < (int)fsize; x++)
				data[x] ^= (byte)(sng.xorMask[x & 0xF] ^ ((byte)x));
			f.Position = oldpos;
			sng.files.Add(new File() {
				data = data,
				name = name
			});
		}
		if ((ulong)(f.Position - test) != idxsize)
			Console.WriteLine(Launcher.T[203]);
		ulong concatsize = br.ReadUInt64();
		if ((ulong)(f.Length - f.Position) != concatsize)
			Console.WriteLine(Launcher.T[204]);
		f.Close();
		br.Dispose();
		return sng;
	}

	// yes, I will have charts that are bigger than 2GB
	// and have more than 2 billion metadata values
	//
	// really thought out chart file format
	// where the only things that should matter
	// are: note tracks, simple text info, and audio
	// and video if possible, but anything goes apparently (even chinese)

	// stream cursor when using this
	// should point to a data block
	// starting on its byte length
	/*static byte[] ReadSeg(Stream inp)
	{
		BinaryReader r = new BinaryReader(inp);
		ulong len = r.ReadUInt64();
		byte[] data = r.ReadBytes((int)len);
		// can't even use ulong to read more than 2 billion bytes anyway
		// ?????????????????????????????????????????????????????
		// inb4 for (uint i = 0; i < l >> 32; i++)
		// BUT THEN FILE NAME LENGTHS USE A BYTE
		return data;
	}
	static void WriteSeg(Stream inp, byte[] data)
	{
		BinaryWriter w = new BinaryWriter(inp);
		w.Write((ulong)data.Length);
		w.Write(data);
	}*/
}
