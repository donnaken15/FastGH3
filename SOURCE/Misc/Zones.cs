using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.IO;
using System.ComponentModel;
using System.ComponentModel.Design;
using Bit = System.BitConverter;
using System.Drawing.Imaging;

public struct Zones
{
	// TODO?: when this code is made universally, try adding conditionals to disable or
	// enable PAK manipulation or other features because I'm not using that here

	public static uint Eswap(uint value) // =>
	{
		return ((value & 0xFF) << 24) |
				((value & 0xFF00) << 8) |
				((value & 0xFF0000) >> 8) |
				((value & 0xFF000000) >> 24);
	}
	public static int Eswap(int value) // =>
	{
		return unchecked((int)
				(((uint)(value & 0xFF) << 24) |
				((uint)(value & 0xFF00) << 8) |
				((uint)(value & 0xFF0000) >> 8) |
				((uint)(value & 0xFF000000) >> 24)));
	}
	public static ushort Eswap(ushort value) // =>
	{
		return (ushort)(((value & 0xFF) << 8) | ((value & 0xFF00) >> 8));
	}
	
	public class RawImg : IDisposable
	{
		private const int _magic = 0x0A281100;
		public void Dispose()
		{
			Image.Dispose();
			rawimg = null;
		}
		private struct Head
		{
			public uint magic;
			public uint key; // null on .imgs, named on .tex
			public ushort w_scale, h_scale; // one of these scales the texture
			public ushort unk0; // 00 01
			public ushort w_clip, h_clip; // and one crops it by the looks of it
			public ushort unk1; // 00 01
			public byte mipmaps, bpp, dxt, unk2;
			public uint unk3;
			public uint off_start, size;
			// i dont remember
			// if these did anything either
			// but just be consistent anyway,
			// like with imggen
			public uint unk4;
		}
		private Head head;
		public byte flags // ...
		{
			get { return (byte)(head.magic & 0xFF); }
			set { head.magic = (head.magic & 0xFFFFFF00) | value; }
		}
		public ushort widthScale
		{
			get { return head.w_scale; }
			set { head.w_scale = value; }
		}
		public ushort widthClip
		{
			get { return head.w_clip; }
			set { head.w_clip = value; }
		}
		public ushort heightScale
		{
			get { return head.h_scale; }
			set { head.h_scale = value; }
		}
		public ushort heightClip
		{
			get { return head.h_clip; }
			set { head.h_clip = value; }
		}
		private byte[] rawimg;
		private uint magic
		{
			get { return Eswap(Bit.ToUInt32(rawimg, 0)); }
		}
		private bool isDDS
		{
			get { return magic == 0x44445320; }
		}
		[DisplayName("Type"), Category("Data")]
		public string ext
		{
			get
			{
				if (isDDS)
					return "dds";
				else
				{
					if ((magic & 0xFFFF0000) == 0x424d0000)
						return "bmp"; // because why
					switch (magic)
					{
						case 0x89504e47:
							return "png";
						case 0xffd8ffe0:
							return "jpg";
						default:
							return "";
					}
				}
			}
		}
		[Category("Data"), ReadOnly(true)]
		public Image Image
		{
			get
			{
				if (isDDS)
					return DDSImage.Load(rawimg).Images[0];
				return Image.FromStream(new MemoryStream(rawimg), true);
			}
			set
			{
				setHead();
				head.w_scale = (ushort)value.Width;
				head.h_scale = (ushort)value.Height;
				head.w_clip = (ushort)value.Width;
				head.h_clip = (ushort)value.Height;
				//ImageFormat fmt = img.RawFormat;
				try
				{
					value.Save(new MemoryStream(rawimg), value.RawFormat);
				}
				catch
				{
					// why
					value.Save(new MemoryStream(rawimg), ImageFormat.Png);
				}
				head.size = (uint)rawimg.Length;
			}
		}
		public uint Name = 0;
		private void setHead()
		{
			head.magic = _magic;
			head.unk0 = 1;
			head.unk1 = 1;
			head.mipmaps = 1;
			head.bpp = 8;
			head.dxt = 5;
			head.off_start = 0x28;
		}
		public byte[] Save()
		{
			byte[] exported = new byte[0x28 + rawimg.Length];
			MemoryStream ms = new MemoryStream();
			BinaryWriter bw = new BinaryWriter(ms);
			bw.Write(Eswap(_magic));
			bw.Write(0);
			bw.Write(Eswap(head.w_scale));
			bw.Write(Eswap(head.h_scale));
			bw.Write(Eswap(head.unk0));
			bw.Write(Eswap(head.w_clip));
			bw.Write(Eswap(head.h_clip));
			bw.Write(Eswap(head.unk1));
			bw.Write(head.mipmaps);
			bw.Write(head.bpp);
			bw.Write(head.dxt);
			bw.Write(head.unk2);
			bw.Write(Eswap(head.unk3));
			bw.Write(Eswap(head.off_start));
			bw.Write(Eswap(head.size));
			bw.Write(Eswap(head.unk4));
			//bw.Write(rawimg);
			bw.Close();
			Array.Copy(ms.ToArray(), exported, 0x28);
			ms.Close();
			Array.Copy(rawimg, 0, exported, 0x28, rawimg.Length);
			return exported;
		}
		public RawImg(Image img)
		{
			setHead();
			head.w_scale = (ushort)img.Width;
			head.h_scale = (ushort)img.Height;
			head.w_clip = (ushort)img.Width;
			head.h_clip = (ushort)img.Height;
			//ImageFormat fmt = img.RawFormat;
			MemoryStream ms = new MemoryStream();
			img.Save(ms, img.RawFormat);
			rawimg = ms.ToArray();
			head.size = (uint)rawimg.Length;
		}
		public RawImg(DDSImage dds, byte[] data)
		{
			setHead();
			Image img = dds.Images[0];
			head.w_scale = (ushort)img.Width;
			head.h_scale = (ushort)img.Height;
			head.w_clip = (ushort)img.Width;
			head.h_clip = (ushort)img.Height;
			rawimg = data;
			head.size = (uint)data.Length;
		}
		/*public RawImg(DDSImage dds)
		{
			setHead();
			Image img = dds.Images[0];
			head.w_scale = (ushort)img.Width;
			head.h_scale = (ushort)img.Height;
			head.w_clip = (ushort)img.Width;
			head.h_clip = (ushort)img.Height;
			MemoryStream ms = new MemoryStream();
			DDSImage.Save(dds, ms, DDSImage.CMP.RGB32); // reconverted l:(
			// CAN'T COMPRESS
			rawimg = ms.ToArray();
			head.size = (uint)rawimg.Length;
		}*/
		public RawImg(byte[] img) // lazy copy again lol
		{
			if (Eswap(Bit.ToUInt32(img,0)) != _magic &&
				Eswap(Bit.ToUInt32(img,0)) != 0x0A281102 && // appears on fonts
				Eswap(Bit.ToUInt32(img,0)) != 0x0A280200) // kill me
			{
				Console.WriteLine("fail "+Eswap(Bit.ToUInt32(img,0)).ToString("X8") + ", expected "+_magic.ToString("X8"));
				head.magic = 0xBAADF00D; // indicate that this isn't usable
				// JUST SKIP THE FILE IF IT DOESN'T HAVE THIS MAGIC
				// FROM THE ZONES CONSTRUCTOR
				return;
			}
			head.key = Eswap(Bit.ToUInt32(img, 4));
			head.w_scale = Eswap(Bit.ToUInt16(img, 0x8));
			head.h_scale = Eswap(Bit.ToUInt16(img, 0xA));
			head.unk0 = Eswap(Bit.ToUInt16(img, 0xC));
			head.w_clip = Eswap(Bit.ToUInt16(img, 0xE));
			head.h_clip = Eswap(Bit.ToUInt16(img, 0x10));
			head.unk1 = Eswap(Bit.ToUInt16(img, 0x12));
			head.mipmaps = img[0x14];
			head.bpp = img[0x15];
			head.dxt = img[0x16];
			head.unk2 = img[0x17];
			head.unk3 = Eswap(Bit.ToUInt32(img, 0x18));
			head.off_start = Eswap(Bit.ToUInt32(img, 0x1C));
			head.size = Eswap(Bit.ToUInt32(img, 0x20));
			if (head.size + 0x1C != img.Length)
				head.size = (uint)img.Length - 0x28; // i must die
			head.unk4 = Eswap(Bit.ToUInt32(img, 0x24));
			// what system is gonna run this with little endian
			rawimg = new byte[head.size];
			Array.Copy(img, head.off_start, rawimg, 0, head.size);
			/*string ext = ".dds";
			uint magic = Eswap(Bit.ToUInt32(img, 0));
			uint[] magics = new uint[4]
			{
				0x44445320,
				0x89504E47,
				0xFFD8FFE1,
				0x424D3616,
			};
			string[] exts = { ".dds", ".png", ".jpg", ".bmp" };
			for (int i = 0; i < magics.Length; i++)
			{
				if (magic == magics[i])
				{
					ext = exts[i];
					break;
				}
			}*/
		}
		public static RawImg MakeFromRaw(string fname)
		{
			byte[] raw = File.ReadAllBytes(fname);
			if (Bit.ToUInt32(raw, 0) == 0x20534444)
			{
				// stupid
				return new RawImg(DDSImage.Load(raw), raw);
			}
			else if (Bit.ToUInt32(raw, 0) == Eswap(_magic))
			{
				return new RawImg(raw);
			}
			else
				return new RawImg(Image.FromFile(fname));
		}
		public void Export(string fname)
		{
			string a = Path.GetExtension(fname).Substring(1);
			if (a == ext)
				File.WriteAllBytes(fname, rawimg);
			else
			{
				// reconvert if extension is not the same
				ImageFormat fmt = ImageFormat.Png; // stupid C#
				switch (a)
				{
					case "dds":
						if (!isDDS)
							throw new Exception("Conversion to DXT is not supported. Thanks Shendare.");
						File.WriteAllBytes(fname, rawimg);
						break;
					case "jpg":
					case "jpeg":
						fmt = ImageFormat.Jpeg;
						break;
					case "bmp":
						fmt = ImageFormat.Bmp;
						break;
					case "tif":
					case "tiff":
						fmt = ImageFormat.Tiff;
						break;
					case "png":
					default:
						fmt = ImageFormat.Png;
						break;
				}
				Image.Save(fname, fmt);
			}
		}
	}

	public class Font
	{
		public uint Name;
		public int baseline;
		public int shifter;
		public int spacing;
		public float height;
		//glyphsPointer
		public ushort[] glyph_ptrs;
		public float space_width;
		public struct Glyph
		{
			public float x, y, x2, y2, pxW, pxH, vShift, hShift, unk_d;
		}
		public List<Glyph> glyphs;
		public RawImg texture;
		public const uint glyphcount = 65535; // because why

		private float Float(BinaryReader b)
		{
			return Bit.ToSingle(Bit.GetBytes(Eswap(b.ReadUInt32())), 0);
		}
		public Glyph this[char i]
		{
			get { return glyphs[glyph_ptrs[i]]; }
			set { glyphs[glyph_ptrs[i]] = value; }
		}
		public RectangleF glyphRect(char glyph)
		{
			Glyph g = this[glyph];
			int w = texture.Image.Width, h = texture.Image.Height;
			return RectangleF.FromLTRB(
				(g.x * w), (g.y * h),
				(g.x2 * w), (g.y2 * h)
			);
		}
		public Font()
		{

		}
		public Font(byte[] a)
		{
			MemoryStream c = new MemoryStream(a);
			BinaryReader b = new BinaryReader(c);
			int glyphcount = 1;
			// if there's 0 glyphs in your font, wtf are you doing
			baseline = Eswap(b.ReadInt32());
			shifter = Eswap(b.ReadInt32());
			spacing = Eswap(b.ReadInt32());
			height = Float(b);
			b.ReadInt32();
			// Thanks Neversoft
			glyph_ptrs = new ushort[0x10000];
			for (int i = 0; i < 0x10000; i++)
			{
				glyph_ptrs[i] = (char)Eswap(b.ReadUInt16());
				if (glyph_ptrs[i] != 0)
					glyphcount++;
			}
			c.Seek(72, SeekOrigin.Current);
			space_width = Float(b);
			c.Seek(0x44, SeekOrigin.Current);
			int imgptr = Eswap(b.ReadInt32());
			b.ReadInt32(); // wtf
			glyphs = new List<Glyph>();
			for (int i = 0; i < glyphcount; i++)
			{
				glyphs.Add(new Glyph() {
					x = Float(b),
					y = Float(b),
					x2 = Float(b),
					y2 = Float(b),
					pxW = Float(b),
					pxH = Float(b),
					vShift = Float(b),
					hShift = Float(b),
					unk_d = Float(b),
				});
			}
			byte[] entry = b.ReadBytes(0x28);
			int size = (int)Eswap(Bit.ToUInt32(entry, 0x20));
			int size_auto = a.Length - imgptr - 0x28;
			// mismatch
			// kill me for not changing length when i hacked these
			// also thanks aspyr for just letting that happen
			if (size != size_auto)
				size = size_auto;
			Array.Copy(Bit.GetBytes(0x28000000), 0, entry, 0x1C, 4);
			Array.Resize(ref entry, 0x28 + size);
			Array.Copy(a, imgptr + 0x28, entry, 0x28, size);
			texture = new RawImg(entry);
		}
		public static Font BMF2FNT(BMF bmf)
		{
			Font fnt = new Font();
			fnt.baseline = (int)Math.Max(0, bmf.LineHeight - bmf.Baseline);
			fnt.shifter = -2;
			fnt.spacing = -2;
			fnt.height = bmf.LineHeight;
			//fnt.constA = 2; // ???, just looks like a pointer to the glyphs
			//fnt.constB = 164;
			fnt.space_width = 15; // TODO: get space glyph's width on its own
			fnt.texture = bmf.Page;
			fnt.glyph_ptrs = new ushort[0x10000];
			fnt.glyphs = new List<Glyph>();
			//int max_height = 0;
			//int space_index = -1;
			//for (int i = 0; i < bmf.Glyphs.Length; i++)
			//{
			//	BMF.Glyph g = bmf.Glyphs[i];
				//max_height = Math.Max(g.Area.Height, max_height);
			//	if (g.Symbol == ' ')
			//	{
			//		fnt.space_width = g.Area.Width;
			//		space_index = i;
			//	}
			//}
			foreach (BMF.Glyph g in bmf.Glyphs)
			{
				Glyph newglyph = new Glyph()
				{
					x = (float)g.Area.X / (float)bmf.Page.Image.Width,
					y = (float)g.Area.Y / (float)bmf.Page.Image.Height,
					x2 = (float)g.Area.Width / (float)bmf.Page.Image.Width,
					y2 = (float)g.Area.Height / (float)bmf.Page.Image.Height,
					pxW = g.Area.Width,
					pxH = g.Area.Height
				};
				newglyph.x2 += newglyph.x;
				newglyph.y2 += newglyph.y;
				//if (g.Symbol == 'g' || g.Symbol == 'A')
				//	newglyph.vShift = (g.Pad.Y / 2f);
				//newglyph.vShift = 0;
				//newglyph.hShift = 0;// doesnt work
				int j = 0;
				for (; j < fnt.glyphs.Count; j++)
				{
					// just if for some reason dupe glyph rects exist
					// or are manually edited to have dupes
					if (fnt.glyphs[j].Equals(newglyph))
					{
						fnt.glyph_ptrs[g.Symbol] = (ushort)j;
						goto skipsym;
					}
				}
				fnt.glyph_ptrs[g.Symbol] = (ushort)fnt.glyphs.Count;
				fnt.glyphs.Add(newglyph);
				skipsym:;
			}
			return fnt;
		}
	}
}
