using System;
using System.IO;
using System.Drawing;
using System.Xml;
using System.Text;
using System.Text.RegularExpressions;

public struct BMF
{
	public string FaceName;
	public float StretchH;
	//bool Bold, Italic;
	public float LineHeight;
	public int Baseline;
	public int Shifter;
	public int Spacing;

	// Neversoft fonts are one page only
	public Zones.RawImg Page;
	public Glyph[] Glyphs;

	public struct Glyph
	{
		public char Symbol;
		public Rectangle Area;
		public Point Pad;
		public ushort Shift;
	}
	// no way is there kerning supported

	void LoadInternal(Stream inp)
	{
		BinaryReader br = new BinaryReader(inp, Encoding.UTF8);
		string magic = new string(br.ReadChars(3));
		inp.Seek(-3, SeekOrigin.Current);
		Shifter = -3;
		Spacing = 0;
		switch (magic)
		{
			case "BMF": // binary
				inp.Seek(5, SeekOrigin.Current);
				uint infoSize = br.ReadUInt32();
				inp.Seek(4, SeekOrigin.Current);
				StretchH = br.ReadUInt16();
				inp.Seek(1+4+2+1, SeekOrigin.Current);
				FaceName = Encoding.UTF8.GetString(br.ReadBytes((int)(infoSize) - 0xE));
				inp.Seek(5, SeekOrigin.Current);
				LineHeight = br.ReadUInt16();
				Baseline = br.ReadUInt16();
				inp.Seek(6+1+4+1, SeekOrigin.Current);
				uint pageSize = br.ReadUInt32();
				// don't know if unicode gets written to UTF8
				byte[] pages = br.ReadBytes((int)pageSize);
				int j = 0; // weird and stupid because NUL is excluded with GetString
				while (j < pages.Length)
				{
					if (pages[j++] == 0)
						break;
				}
				string page = Encoding.UTF8.GetString(pages, 0, --j);
				Page = Zones.RawImg.MakeFromRaw(page);
				inp.Seek(1, SeekOrigin.Current);
				ushort charsSize = br.ReadUInt16();
				inp.Seek(2, SeekOrigin.Current);
				int charCount = charsSize / 0x14;
				Glyphs = new Glyph[charCount];
				for (int i = 0; i < charCount; i++)
				{
					Glyphs[i] = new Glyph()
					{
						Symbol = (char)br.ReadUInt32(),
						Area = new Rectangle()
						{
							Location = new Point(br.ReadUInt16(), br.ReadUInt16()),
							Size = new Size(br.ReadUInt16(), br.ReadUInt16())
						},
						Pad = new Point(br.ReadUInt16(), br.ReadUInt16()),
						Shift = br.ReadUInt16()
					};
					inp.Seek(2, SeekOrigin.Current);
				}
				break;
			case "<?x": // XML
				{
					XmlDocument xml = new XmlDocument();
					xml.Load(inp);
					XmlNode f = xml.SelectSingleNode("/font");
#if false
					foreach (XmlAttribute a in f.SelectSingleNode("info").Attributes)
					{
						switch (a.Name)
						{
							case "face":
								FaceName = a.Value;
								break;
							case "stretchH":
								StretchH = float.Parse(a.Value);
								break;
						}
					}
					foreach (XmlAttribute a in f.SelectSingleNode("common").Attributes)
					{
						switch (a.Name)
						{
							case "lineHeight":
								LineHeight = float.Parse(a.Value);
								break;
							case "base":
								Baseline = float.Parse(a.Value);
								break;
						}
					}
					foreach (XmlAttribute a in f.SelectSingleNode("pages/page").Attributes)
					{
						switch (a.Name)
						{
							case "file":
								Page = Zones.RawImg.MakeFromRaw(a.Value);
								break;
						}
					}
#else
					XmlAttributeCollection a = f.SelectSingleNode("info").Attributes;
					FaceName = a["face"].Value;
					StretchH = ushort.Parse(a["stretchH"].Value);

					a = f.SelectSingleNode("common").Attributes;
					LineHeight = ushort.Parse(a["lineHeight"].Value);
					Baseline = ushort.Parse(a["base"].Value);
					try
					{
						Shifter = ushort.Parse(a["shifter"].Value);
					}
					catch { }
					try
					{
						Spacing = ushort.Parse(a["spacing"].Value);
					}
					catch { }

					a = f.SelectSingleNode("pages/page").Attributes;
					Page = Zones.RawImg.MakeFromRaw(a["file"].Value);
#endif
					XmlNodeList cl = f.SelectNodes("chars/char");
					Glyphs = new Glyph[cl.Count];
					for (ushort i = 0; i < cl.Count; i++)
					{
						XmlNode c = cl[i];
						a = c.Attributes;
						Glyphs[i] = new Glyph()
						{
							Area = new Rectangle(
								ushort.Parse(a["x"].Value), ushort.Parse(a["y"].Value),
								ushort.Parse(a["width"].Value), ushort.Parse(a["height"].Value)),
							Pad = new Point(short.Parse(a["xoffset"].Value), short.Parse(a["yoffset"].Value)),
							Shift = ushort.Parse(a["xadvance"].Value),
							Symbol = (char)(ushort.Parse(a["id"].Value))
						};
					}
				}
				break;
			case "inf":
				{
					StreamReader tr = new StreamReader(inp, Encoding.UTF8);
					Glyphs = null;
					int i = -1;
					while (!tr.EndOfStream)
					{
						// todo: try not relying on EOL?
						Match ln = Regex.Match(tr.ReadLine(), "^(\\w+)\\s*((\\w+)=(\"[^\"]*\"|[\\d\\w,]+)\\s*)+$");
						string h = ln.Groups[1].ToString();
						//MatchCollection ln = Regex.Matches(tr.ReadLine(), "^(?<sect>\\w+)\\s*((?<key>\\w+)=(?<value>\"[^\"]*\"|[\\d\\w,]+)\\s*)+$");
						foreach (Match m in Regex.Matches(ln.ToString(), "(\\w+)=(\"[^\"]*\"|[\\d\\w,]+)\\s*"))
						{
							string k = m.Groups[1].Value;
							string v = m.Groups[2].Value.Trim().Trim("\"".ToCharArray());
							switch (h)
							{
								case "info":
									switch (k)
									{
										case "face":
											FaceName = v;
											break;
										//case "size":
										//	Size		= ushort.Parse(v);
										//	break;
										case "stretchH":
											StretchH = ushort.Parse(v);
											break;
									}
									break;
								case "common":
									switch (k)
									{
										case "lineHeight":
											LineHeight = ushort.Parse(v);
											break;
										case "base":
											Baseline = ushort.Parse(v);
											break;
										case "shifter":
											try
											{
												Shifter = int.Parse(v);
											}
											catch { }
											break;
										case "spacing":
											try
											{
												Spacing = int.Parse(v);
											}
											catch { }
											break;
									}
									break;
								case "page":
									switch (k)
									{
										case "file":
											Page = Zones.RawImg.MakeFromRaw(v);
											break;
									}
									break;
								case "chars":
									switch (k)
									{
										case "count":
											Glyphs = new Glyph[ushort.Parse(v)];
											break;
									}
									break;
								case "char":
									switch (k)
									{
										// THERE HAS TO BE A FUNCTION TO
										// DO SOMETHING LIKE SETTING
										// OBJECT[PROPERTY] IN JAVASCRIPT
										// INSTEAD OF ALL THIS!!!
										case "id":
											i++;
											Glyphs[i].Symbol = (char)ushort.Parse(v);
											break;
										case "x":
											Glyphs[i].Area.X = ushort.Parse(v);
											break;
										case "y":
											Glyphs[i].Area.Y = ushort.Parse(v);
											break;
										case "width":
											Glyphs[i].Area.Width = ushort.Parse(v);
											break;
										case "height":
											Glyphs[i].Area.Height = ushort.Parse(v);
											break;
										case "xoffset":
											Glyphs[i].Pad.X = ushort.Parse(v);
											break;
										case "yoffset":
											Glyphs[i].Pad.Y = ushort.Parse(v);
											break;
										case "xadvance":
											Glyphs[i].Shift = ushort.Parse(v);
											break;
									}
									break;
							}
						}
					}
				}
				break;
			default:
				throw new FormatException("Unknown magic: "+magic);
		}
		Page.flags = 2;
	}
	public static BMF Load(Stream inp)
	{
		BMF bmf = new BMF();
		bmf.LoadInternal(inp);
		return bmf;
	}
}
