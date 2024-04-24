using System;
using System.IO;
using Font = Zones.Font;

struct _ // LOL!!
{
	static uint rawfloat(float _)
	{
		return BitConverter.ToUInt32(BitConverter.GetBytes(_), 0);
	}
	static uint Eswap(uint _)
	{
		return Zones.Eswap(_);
	}
	static int Eswap(int _)
	{
		return Zones.Eswap(_);
	}
	static ushort Eswap(ushort _)
	{
		return Zones.Eswap(_);
	}
	//static void BatchWrite(BinaryWriter w, params object[] list)
	//{
	//	_BatchWrite(w, list);
	//}
	static void BatchWrite(BinaryWriter w, object[] list)
	{
		#region long and stupid
		for (int i = 0; i < list.Length; i++)
		{
			object o = list[i];
			switch (Type.GetTypeCode(o.GetType()))
			{
				// big cringe
				case TypeCode.Boolean:
					w.Write((bool)o);
					break;
				case TypeCode.Byte:
					w.Write((byte)o);
					break;
				case TypeCode.Char:
					w.Write((char)o);
					break;
				case TypeCode.Decimal:
					w.Write((decimal)o);
					break;
				case TypeCode.Double:
					w.Write((double)o);
					break;
				case TypeCode.Int16:
					w.Write((short)o);
					break;
				case TypeCode.Int32:
					w.Write((int)o);
					break;
				case TypeCode.Int64:
					w.Write((long)o);
					break;
				case TypeCode.Object:
					//w.Write((bool)o);
					throw new NotImplementedException("Cannot find a suitable function to write " + o.GetType().FullName + " data to the stream.");
					break;
				case TypeCode.SByte:
					w.Write((sbyte)o);
					break;
				case TypeCode.Single:
					w.Write((float)o);
					break;
				case TypeCode.String:
					w.Write((string)o);
					break;
				case TypeCode.UInt16:
					w.Write((ushort)o);
					break;
				case TypeCode.UInt32:
					w.Write((uint)o);
					break;
				case TypeCode.UInt64:
					w.Write((ulong)o);
					break;
			}
		}
		#endregion
	}
	static void Main(string[] args)
	{
		foreach (string f in Directory.GetFiles(Directory.GetCurrentDirectory(), "*.fnt"))
		{
			FileStream fs = File.Open(f, FileMode.Open);
			BMF font = BMF.Load(fs);
			fs.Close();
			Font fnt = Font.BMF2FNT(font);
			FileStream gen = File.Open(f+".xen", FileMode.Create);
			BinaryWriter w = new BinaryWriter(gen);
			BatchWrite(w, new object[] {
				Eswap(fnt.baseline), Eswap(fnt.shifter),
				Eswap(fnt.spacing), Eswap(rawfloat(fnt.height)),
				Eswap((ushort)2), Eswap((ushort)164)
			});
			//newfnt.glyph_ptrs[0xFFFF] = 1234;
			for (int i = 0; i < 0x10000; i++)
				w.Write(Eswap(fnt.glyph_ptrs[i]));
			for (byte i = 0; i < 31; i++) // kms plz
				w.Write(Eswap((ushort)0)); // kms plz// kms plz// kms plz// kms plz// kms plz// kms plz// kms plz
			BatchWrite(w, new object[] {
				0x01000000, (ushort)0xADDE,
				0xFFFFFFFF, Eswap(rawfloat(fnt.space_width))
			});
			for (ushort i = 0; i < 16; i++)
				w.Write(0);
			w.Write(Eswap((int)w.BaseStream.Position + fnt.glyphs.Count * 0x24 + 4)); // wtf
			for (int i = 0; i < fnt.glyphs.Count; i++)
			{
				Font.Glyph glyph = fnt.glyphs[i];
				float[] absurd = {
					glyph.x, glyph.y, glyph.x2, glyph.y2,
					glyph.pxW, glyph.pxH, glyph.vShift
				};
				for (int j = 0; j < absurd.Length; j++)
					w.Write(Eswap(rawfloat(absurd[j])));
				w.Write(Eswap(glyph.hShift));
				w.Write(Eswap(rawfloat(glyph.unk_d)));
			}
			uint imgptr = (uint)gen.Position + 0x28;
			/*w.Write(Eswap(0x0A281100 | fnt.texture.flags));
			w.Write(0);
			w.Write(Eswap(fnt.texture.widthScale));
			w.Write(Eswap(fnt.texture.heightScale));
			w.Write(Eswap((ushort)1));
			w.Write(Eswap(fnt.texture.widthClip));
			w.Write(Eswap(fnt.texture.heightClip));
			w.Write(Eswap((ushort)1));
			w.Write((byte)1);
			w.Write((byte)8);
			w.Write((byte)5);
			w.Write((byte)0);
			w.Write(0);
			w.Write(Eswap(imgptr));*/
			w.Write(fnt.texture.Save());
			gen.Seek(imgptr + 0x1C, SeekOrigin.Begin);
			w.Write(Eswap(imgptr));
			w.Close();
		}
	}
}
