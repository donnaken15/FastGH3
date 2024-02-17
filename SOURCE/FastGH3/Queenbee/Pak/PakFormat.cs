using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.IO.Compression;
//using Rebex.IO.Compression;


namespace Nanook.QueenBee.Parser
{
	public enum StructItemChildrenType
	{
		StructItems,
		ArrayItems,
		NotSet
	}

	public enum CompressionType
	{
		None,
		ZLib,
		ZLibChunk
	}

	public class PakFormat
	{
		private class NonDebugQbKey
		{
			public NonDebugQbKey(QbKey qbKey, string qbFilename)
			{
				this.QbKey = qbKey;
				this.QbFilename = qbFilename;
			}

			public QbKey QbKey { get; set; }
			public string QbFilename { get; set; }
		}

		static PakFormat()
		{

			//types must be in the same order as the enum
			_types = new uint[,] {
				   // PC
					{ 0x00000000 }, //Unknown                 
					{ 0x00200100 }, //SectionInteger          
					{ 0x00200200 }, //SectionFloat            
					{ 0x00200300 }, //SectionString           
					{ 0x00200400 }, //SectionStringW          
					{ 0x00200500 }, //SectionFloatsX2         
					{ 0x00200600 }, //SectionFloatsX3         
					{ 0x00200700 }, //SectionScript           
					{ 0x00200A00 }, //SectionStruct           
					{ 0x00200C00 }, //SectionArray            
					{ 0x00200D00 }, //SectionQbKey            
					{ 0x00201A00 }, //SectionQbKeyString    
					{ 0x00201B00 }, //SectionStringPointer   
					{ 0x00201C00 }, //SectionQbKeyStringQs   
					{ 0x00010100 }, //ArrayInteger            
					{ 0x00010200 }, //ArrayFloat              
					{ 0x00010300 }, //ArrayString             
					{ 0x00010400 }, //ArrayStringW            
					{ 0x00010500 }, //ArrayFloatsX2           
					{ 0x00010600 }, //ArrayFloatsX3           
					{ 0x00010A00 }, //ArrayStruct             
					{ 0x00010C00 }, //ArrayArray              
					{ 0x00010D00 }, //ArrayQbKey              
					{ 0x00011A00 }, //ArrayQbKeyString        
					{ 0x00011B00 }, //ArrayStringPointer        
					{ 0x00011C00 }, //ArrayQbKeyStringQs       
					{ 0x00810000 }, //StructItemInteger       
					{ 0x00820000 }, //StructItemFloat         
					{ 0x00830000 }, //StructItemString        
					{ 0x00840000 }, //StructItemStringW       
					{ 0x00850000 }, //StructItemFloatsX2      
					{ 0x00860000 }, //StructItemFloatsX3      
					{ 0x008A0000 }, //StructItemStruct        
					{ 0x008C0000 }, //StructItemArray         
					{ 0x008D0000 }, //StructItemQbKey         
					{ 0x009A0000 }, //StructItemQbKeyString   
					{ 0x009B0000 }, //StructItemStringPointer 
					{ 0x009C0000 }, //StructItemQbKeyStringQs
					{ 0x00010000 }, //Floats                  
					{ 0x00000100 }  //StructHeader            
			};

		}


		public PakFormat(string pakFile, string pabFile, string dbgFile, PakFormatType type) : this(pakFile, pabFile, dbgFile, type, true)
		{
		}

		public PakFormat(string pakFile, string pabFile, string dbgFile, PakFormatType type, bool autoDetectFiles)
		{
			_structItemChildrenType = Nanook.QueenBee.Parser.StructItemChildrenType.NotSet;

			bool debugFile = false;

			PakFormatType = type;

			switch (type)
			{
				case PakFormatType.PC:
					FriendlyName = "PC";
					EndianType = EndianType.Big;
					FileExtension = "xen";
					QbDebugExtension = "dbg";
					LastHeaderLength = 48;
					IsCompressed = false;
					FilePadSize = 0x20;
					break;
				/*case PakFormatType.Wii:
					FriendlyName = "Wii";
					EndianType = EndianType.Big;
					FileExtension = "ngc";
					QbDebugExtension = "dbg";
					LastHeaderLength = 64;
					IsCompressed = false;
					FilePadSize = 0x20;
					break;
				case PakFormatType.XBox:
					FriendlyName = "XBox";
					EndianType = EndianType.Big;
					FileExtension = "xen";
					QbDebugExtension = "dbg";
					LastHeaderLength = 48;
					IsCompressed = true;
					FilePadSize = 0x20;
					break;
				case PakFormatType.XBox_XBX:
					FriendlyName = "XBOX XBX";
					EndianType = EndianType.Little;
					FileExtension = "xbx";
					QbDebugExtension = "dbg";
					LastHeaderLength = 48;
					IsCompressed = false;
					FilePadSize = 0x80;
					break;
				case PakFormatType.PS2:
					FriendlyName = "PS2";
					EndianType = EndianType.Little;
					FileExtension = "ps2";
					QbDebugExtension = "dbg";
					LastHeaderLength = 48;
					IsCompressed = false;
					FilePadSize = 0x10;
					break;
				case PakFormatType.PC_WPC:
					FriendlyName = "PC WPC";
					EndianType = EndianType.Little;
					FileExtension = "wpc";
					QbDebugExtension = "dbg";
					LastHeaderLength = 48;
					IsCompressed = false;
					FilePadSize = 0x20;
					break;*/
				default:
					break;
			}

			if (!File.Exists(pakFile))
				return;

			this.CompressionType = CompressionType.None;

			FileInfo fi = new FileInfo(pakFile);
			PakPath = fi.Directory.FullName;
			FullPakFilename = fi.FullName;
			PakFilename = fi.Name;

			NonDebugQbKeyFilename = string.Empty;
			FullNonDebugQbKeyFilename = string.Empty;

			if (PakFilename.StartsWith(string.Format(@"dbg.pak.{0}", FileExtension)))
			{
				debugFile = true;
				//SupportsPabFile = false;
			}

			bool exists = false;
			if (!debugFile)
			{
				//if (SupportsPabFile)
				//{
					FullPabFilename = pabFile;
					if (autoDetectFiles && FullPabFilename.Length == 0)
						FullPabFilename = FullPakFilename.Replace(@".pak.", ".pab.");
					if (File.Exists(FullPabFilename))
					{
						fi = new FileInfo(FullPabFilename);
						PabFilename = fi.Name;
						exists = true;
					}
				//}

				NonDebugQbKeyFilename = string.Format("{0}.UserDbg", fi.Name);
				FullNonDebugQbKeyFilename = string.Format("{0}.UserDbg", fi.FullName);
				loadNonDebugQbKey();
			}
			if (!exists)
			{
				FullPabFilename = string.Empty;
				PabFilename = string.Empty;
			}

			exists = false;
			FullDebugFilename = dbgFile;
			if (autoDetectFiles && FullDebugFilename.Length == 0)
			{
				FullDebugFilename = string.Format(@"{0}\dbg.pak.{1}", PakPath.TrimEnd('\\'), FileExtension);
				if (FullDebugFilename.ToLower() == FullPakFilename.ToLower())
					FullDebugFilename = "";
			}
			if (File.Exists(FullDebugFilename))
			{
				fi = new FileInfo(FullDebugFilename);
				DebugFilename = fi.Name;
				exists = true;
			}
			if (!exists)
			{
				FullDebugFilename = string.Empty;
				DebugFilename = string.Empty;
			}

			//allow debug file as pak when has real extension and not .decompressed
#if false
			if ((!debugFile || (debugFile && PakFilename.EndsWith(FileExtension))) && PakFormatType == PakFormatType.XBox)
			{
				if (PakFileExists)
				{
					CompressedPakFilename = PakFilename;
					PakFilename = string.Format("{0}.decompressed", PakFilename);
					FullCompressedPakFilename = FullPakFilename;
					FullPakFilename = string.Format("{0}.decompressed", FullPakFilename);
					CompressedPakFilesize = (new FileInfo(FullCompressedPakFilename)).Length;
				}
				if (PabFileExists)
				{
					CompressedPabFilename = PabFilename;
					PabFilename = string.Format("{0}.decompressed", PabFilename);
					FullCompressedPabFilename = FullPabFilename;
					FullPabFilename = string.Format("{0}.decompressed", FullPabFilename);
					CompressedPabFilesize = (new FileInfo(FullCompressedPabFilename)).Length;
				}
				if (DebugFileExists)
				{
					CompressedDebugFilename = DebugFilename;
					DebugFilename = string.Format("{0}.decompressed", DebugFilename);
					FullCompressedDebugFilename = FullDebugFilename;
					FullDebugFilename = string.Format("{0}.decompressed", FullDebugFilename);
				}
			}
			else
			{
				CompressedDebugFilename = string.Empty;
				FullCompressedPakFilename = string.Empty;
				CompressedPabFilename = string.Empty;
				FullCompressedPabFilename = string.Empty;
				CompressedDebugFilename = string.Empty;
				FullCompressedDebugFilename = string.Empty;

			}
#endif



		}

#region Properties

		public StructItemChildrenType StructItemChildrenType
		{
			get { return _structItemChildrenType; }
			set
			{
				//set if not set or value is struct items and new setting is array items
				if (_structItemChildrenType == StructItemChildrenType.NotSet || (_structItemChildrenType == StructItemChildrenType.StructItems && value == StructItemChildrenType.ArrayItems))
					_structItemChildrenType = value;
			}
		}


		public bool PakFileExists
		{
			get { return fileExists(FullPakFilename); }
		}

		public bool PabFileExists
		{
			get { return fileExists(FullPabFilename); }
		}

		public bool DebugFileExists
		{
			get { return fileExists(FullDebugFilename); }
		}

		public bool CompressedPakFileExists
		{
			get { return fileExists(FullCompressedPakFilename); }
		}

		public bool CompressedPabFileExists
		{
			get { return fileExists(FullCompressedPabFilename); }
		}

		public bool CompressedDebugFileExists
		{
			get { return fileExists(FullCompressedDebugFilename); }
		}

		private Boolean fileExists(string filename)
		{
			try
			{
				return File.Exists(filename);
			}
			catch
			{
				return false;
			}
		}
#endregion

		public QbItemType GetInternalType(QbItemType type, QbFile qbFile)
		{
			QbItemType qt = type;

			if (qbFile.PakFormat.StructItemChildrenType == StructItemChildrenType.ArrayItems)
			{
				if (type == QbItemType.StructItemArray)
					qt = QbItemType.ArrayArray;
				else if (type == QbItemType.StructItemFloat)
					qt = QbItemType.ArrayFloat;
				else if (type == QbItemType.StructItemFloatsX2)
					qt = QbItemType.ArrayFloatsX2;
				else if (type == QbItemType.StructItemFloatsX3)
					qt = QbItemType.ArrayFloatsX3;
				else if (type == QbItemType.StructItemInteger)
					qt = QbItemType.ArrayInteger;
				else if (type == QbItemType.StructItemQbKey)
					qt = QbItemType.ArrayQbKey;
				else if (type == QbItemType.StructItemQbKeyString)
					qt = QbItemType.ArrayQbKeyString;
				else if (type == QbItemType.StructItemStringPointer)
					qt = QbItemType.ArrayStringPointer;
				else if (type == QbItemType.StructItemQbKeyStringQs)
					qt = QbItemType.ArrayQbKeyStringQs;
				else if (type == QbItemType.StructItemString)
					qt = QbItemType.ArrayString;
				else if (type == QbItemType.ArrayStringW)
					qt = QbItemType.ArrayStringW;
				else if (type == QbItemType.StructItemStruct)
					qt = QbItemType.ArrayStruct;
			}

			return qt;
		}

		public uint GetQbItemValue(QbItemType type, QbFile qbFile)
		{
			return _types[(int)this.GetInternalType(type, qbFile), (int)PakFormatType];
		}

		public QbItemType GetQbItemType(uint type)
		{
			for (int i = 0; i < _types.GetUpperBound(0) + 1; i++)
			{
				if (_types[i, (int)PakFormatType] == type)
					return (QbItemType)i;
			}
			return 0;
		}


#region NonDebugQbKey items

		private void loadNonDebugQbKey()
		{
			if (File.Exists(FullNonDebugQbKeyFilename))
			{
				string[] f;
				foreach (string s in File.ReadAllLines(FullNonDebugQbKeyFilename))
				{
					f = s.Split('|');
					AddNonDebugQbKey(QbKey.Create(uint.Parse(f[0].Substring(2), System.Globalization.NumberStyles.HexNumber), f[1]), f[2], null);
				}
			}
		}

		/// <summary>
		/// Save user defined QbKeys
		/// </summary>
		/// <param name="qbFile">Used to ensure no duplicates are saved. Can be null if not known.</param>
		public void SaveDebugQbKey()
		{
			List<string> s = new List<string>();
			if (_qbKeys != null)
			{
				foreach(NonDebugQbKey n in _qbKeys)
				{
					if (n.QbKey.HasText)
						s.Add(string.Format("0x{0}|{1}|{2}", n.QbKey.Crc.ToString("X").PadLeft(8, '0'), n.QbKey.Text, n.QbFilename));
				}

				if (s.Count != 0)
				{
					if (File.Exists(FullNonDebugQbKeyFilename))
						File.Delete(FullNonDebugQbKeyFilename);
					File.WriteAllLines(FullNonDebugQbKeyFilename, s.ToArray());
				}

			}
		}

		/// <summary>
		/// Add the non debug item to the user defined list if it's not already there
		/// </summary>
		/// <param name="qbKey"></param>
		/// <param name="qbFilename"></param>
		/// <param name="qbfile"></param>
		/// <returns>True if crc already exists with different text.</returns>
		public string AddNonDebugQbKey(QbKey qbKey, string qbFilename, QbFile qbfile)
		{

			//check that it's not already in the real debug file
			if (qbKey.HasText)
			{
				string t = string.Empty;
				if (qbfile != null)
					t = qbfile.LookupDebugName(qbKey.Crc, false);

				//it's in the debug file
				if (t.Length != 0)
				{
					if (t != qbKey.Text)
						return t;
				}
				else
				{
					//check that it's not in the user debug file
					if ( GetNonDebugQbKey(qbKey.Crc, qbFilename) == null)
					{
						if (_qbKeys == null)
							_qbKeys = new List<NonDebugQbKey>();
						_qbKeys.Add(new NonDebugQbKey(qbKey, qbFilename));
					}
				}
			}
			return string.Empty;
		}

		public QbKey GetNonDebugQbKey(uint crc, string qbFilename)
		{
			if (_qbKeys == null)
				return null;

			foreach (NonDebugQbKey qbKey in _qbKeys)
			{
				if (qbKey.QbKey.Crc == crc && qbKey.QbFilename == qbFilename)
					return qbKey.QbKey;
			}
			return null;
		}

#endregion

		private void copyStream(System.IO.Stream input, System.IO.Stream output)
		{
			byte[] buffer = new byte[2000];
			int len;
			while ((len = input.Read(buffer, 0, 2000)) > 0)
			{
				output.Write(buffer, 0, len);
			}
			output.Flush();
		}

		private void copyStream(System.IO.Stream input, System.IO.Stream output, int length)
		{
			//2000 byte buffer causes problems with decompression

			int l = length < 1024 * 10 ? length : 1024 * 10;
			byte[] buffer = new byte[l];
			int len;
			int total = 0;

			while ((len = input.Read(buffer, 0, l)) > 0)
			{
				output.Write(buffer, 0, len);
				total += len;
				if (total >= length)
					break;
				if (l + total > length)
					l = length - total;
			}
			output.Flush();
		}


		public void Compress()
		{
			if (this.IsCompressed)
			{
				if (PakFormatType != PakFormatType.PC)
					throw new Exception("Unsupported PAK format.");
				/*if (this.PakFormatType == PakFormatType.XBox)
				{
					throw new Exception("Xbox is not supported.");
					this.xBoxCompress(this.FullPakFilename, this.FullCompressedPakFilename);
					this.CompressedPakFilesize = (new FileInfo(this.FullCompressedPakFilename)).Length;
					if (this.PakFileExists)
					{
						this.xBoxCompress(this.FullPabFilename, this.FullCompressedPabFilename);
						this.CompressedPabFilesize = (new FileInfo(this.FullCompressedPabFilename)).Length;
					}
				}*/
			}
		}


		public void Decompress()
		{
			//try
			//{
				//CompressionType ct = CompressionType.None;

			if (PakFormatType != PakFormatType.PC)
			throw new Exception("Unsupported PAK format.");
			/*if (this.PakFormatType == PakFormatType.XBox)
			{
				if ((ct = this.xBoxUncompress(this.FullCompressedPakFilename, this.FullPakFilename)) != CompressionType.None)
					this.CompressionType = ct;
				else
				{
					if (File.Exists(FullPakFilename))
						File.Delete(FullPakFilename); //delete the .decompressed file
					//none compressed pak
					this.FullPakFilename = this.FullCompressedPakFilename;
					this.PakFilename = this.CompressedPakFilename;
				}
				if (this.CompressedPabFileExists)
				{
					if ((ct = this.xBoxUncompress(this.FullCompressedPabFilename, this.FullPabFilename)) != CompressionType.None)
						this.CompressionType = ct;
				}
				if (this.CompressedDebugFileExists)
				{
					if ((ct = this.xBoxUncompress(this.FullCompressedDebugFilename, this.FullDebugFilename)) != CompressionType.None)
						this.CompressionType = ct;
				}

				this.UnCompressedPakFilesize = ((new FileInfo(this.FullPakFilename)).Length);
				if (this.FullPabFilename.Length != 0 && File.Exists(this.FullPabFilename))
					this.UnCompressedPabFilesize = ((new FileInfo(this.FullPabFilename)).Length);
			}*/
			//}
			//catch (Exception ex)
			//{
			//    throw n
			//    showException("Decompress Error", ex);
			//    clearInterface();
			//    return;
			//}
		}

		/*private CompressionType xBoxUncompress(string compFilename, string uncompFilename)
		{
			if (uncompFilename.ToLower() == compFilename.ToLower()) //nothing to do
				return CompressionType.None;

			if (File.Exists(uncompFilename))
				File.Delete(uncompFilename);

			CompressionType ct = CompressionType.None;

			try
			{
				using (FileStream inFileStream = new FileStream(compFilename, FileMode.Open, FileAccess.Read))
				{
					using (BinaryEndianReader br = new BinaryEndianReader(inFileStream))
					{
						uint chunkLen = 0;

						while (chunkLen != 0xffffffff)
						{
							using (FileStream outFileStream = new FileStream(uncompFilename, chunkLen == 0 ? FileMode.Create : FileMode.Append))
							{
								using (ZlibOutputStream outZStream = new ZlibOutputStream(outFileStream, Rebex.IO.Compression.CompressionMode.Decompress))
								{
									//test for newer GHWT+ compression
									long pos = inFileStream.Position;

									if (Encoding.ASCII.GetString(br.ReadBytes(4)) == "CHNK")
									{
										ct = CompressionType.ZLibChunk;

										EndianType et = this.EndianType;

										//Decompress each section
										uint headerLen = br.ReadUInt32(et);
										uint blockLen = br.ReadUInt32(et);
										chunkLen = br.ReadUInt32(et);
										uint nextchunkLen = br.ReadUInt32(et);
										uint uncompressedLen = br.ReadUInt32(et);
										uint uncompressedPos = br.ReadUInt32(et);

										_zLibHeaderLen = headerLen;
										if (uncompressedLen > this._zLibChunkSize)
											this._zLibChunkSize = uncompressedLen;

										inFileStream.Seek(headerLen - (inFileStream.Position - pos), SeekOrigin.Current);
										outZStream.WriteByte(0x58);  //Search deflate.cs for "Nanook" for the mod to stop it being written out
										outZStream.WriteByte(0x85);  //this is the header MS uses, thie zlib deflate uses 78DA ??

										copyStream(inFileStream, outZStream, (int)blockLen);

										if (chunkLen != 0xffffffff)
											inFileStream.Seek((chunkLen - blockLen) - headerLen, SeekOrigin.Current);

									}
									else
									{
										try
										{
											inFileStream.Seek(pos, SeekOrigin.Begin);

											outZStream.WriteByte(0x58);
											outZStream.WriteByte(0x85);
											copyStream(inFileStream, outZStream);
											ct = CompressionType.ZLib;
											break;
										}
										catch
										{
											break;  //no compression???
										}
									}

									outZStream.Flush();
									outFileStream.Flush();
									//outZStream.Close();
								}
							}
						}
					}
				}
			}
			catch (Exception ex)
			{
				throw new ApplicationException(string.Format("Uncompress Failed: {0}", ex));
			}

			//using (DeflateStream ds = new DeflateStream(File.Open(compFilename, FileMode.Open), CompressionMode.Decompress))
			//{
			//    using (BinaryReader br = new BinaryReader(ds))
			//    {
			//        using (FileStream ms = File.Create(uncompFilename))
			//        {
			//            using (BinaryWriter bw = new BinaryWriter(ms))
			//            {
			//                long l;
			//                do
			//                {
			//                    l = ms.Length;
			//                    bw.Write(br.ReadBytes(10000));
			//                }
			//                while (l != ms.Length);
			//            }
			//        }
			//    }
			//}

			return ct;
		}

		private void xBoxCompress(string uncompFilename, string compFilename)
		{
			if (uncompFilename.ToLower() == compFilename.ToLower()) //nothing to do
				return;

			if (File.Exists(compFilename))
				File.Delete(compFilename);

			try
			{
				if (this.CompressionType == CompressionType.ZLib)
				{
					using (FileStream outFileStream = new FileStream(compFilename, FileMode.Create))
					{
						using (ZlibOutputStream outZStream = new ZlibOutputStream(outFileStream, true, JZlib.Z_BEST_COMPRESSION))
						{
							using (FileStream inFileStream = new FileStream(uncompFilename, FileMode.Open, FileAccess.Read))
							{
								copyStream(inFileStream, outZStream);
							}
						}
					}
				}
				else if (this.CompressionType == CompressionType.ZLibChunk)
				{
					List<uint> sizes = new List<uint>();
					List<uint> offsets = new List<uint>();
					byte[] header = new byte[ZlibFilePad];

					int pad = 0;
					long lastUncompressedChunk;
					long endPos;

					EndianType et = this.EndianType;

					int part = 0;

					using (FileStream inFileStream = new FileStream(uncompFilename, FileMode.Open, FileAccess.Read))
					{
						long pos;
						do
						{
							using (FileStream outFileStream = new FileStream(compFilename, inFileStream.Position == 0 ? FileMode.Create : FileMode.Append))
							{
								part++;

								pad = (int)(outFileStream.Position % ZlibBlockPad);
								if (pad != 0 && outFileStream.Position != 0)
									outFileStream.Write(header, 0, (int)ZlibBlockPad - pad);

								pos = outFileStream.Position;

								outFileStream.Write(Encoding.ASCII.GetBytes("CHNK"), 0, 4);
								outFileStream.Write(header, 0, (int)_zLibHeaderLen - 4);

								lastUncompressedChunk = (long)_zLibChunkSize;
								if (inFileStream.Position + lastUncompressedChunk > inFileStream.Length)
									lastUncompressedChunk = inFileStream.Length - inFileStream.Position;

								using (ZlibOutputStream outZStream = new ZlibOutputStream(outFileStream, true, JZlib.Z_BEST_COMPRESSION))
								{
									copyStream(inFileStream, outZStream, (int)lastUncompressedChunk);

									offsets.Add((uint)pos);
									sizes.Add((uint)(outFileStream.Position - pos) - _zLibHeaderLen);
								}

							}


						} while (inFileStream.Position < inFileStream.Length);

						using (FileStream outFileStream = new FileStream(compFilename, inFileStream.Position == 0 ? FileMode.Create : FileMode.Append))
						{
							//find the end of the last file.
							endPos = (int)(outFileStream.Position % ZlibBlockPad);
							if (endPos != 0)
								endPos = ZlibBlockPad - endPos;
							endPos += outFileStream.Position;

							//pad the compressed file
							pad = (int)(outFileStream.Position % ZlibFilePad);
							if (pad != 0 && outFileStream.Position != 0)
								outFileStream.Write(header, 0, (int)ZlibFilePad - pad);
						}

						using (FileStream outFileStream = new FileStream(compFilename, FileMode.Open))
						{
							using (BinaryEndianWriter bw = new BinaryEndianWriter(outFileStream))
							{
								long uncompressedTotal = 0;
								EndianType e = this.EndianType;

								for (int i = 0; i < offsets.Count; i++)
								{
									outFileStream.Seek(offsets[i] + 4, SeekOrigin.Begin);
									bw.Write((uint)_zLibHeaderLen, e); //headerlen
									bw.Write((uint)sizes[i], e); //blocklen
									bw.Write((uint)(i != offsets.Count - 1 ? offsets[i + 1] - offsets[i] : 0xffffffff), e); //chunklen ffs if last item

									//next blocklen 00's if last block
									if (i == offsets.Count - 1)  //last item
										bw.Write((uint)0x00000000, e);
									else if (i + 1 == offsets.Count - 1) //secondlast item
										bw.Write((uint)(endPos - offsets[i + 1]), e);
									else
										bw.Write((uint)offsets[i + 2] - offsets[i + 1], e);

									bw.Write((uint)(i != offsets.Count - 1 ? _zLibChunkSize : lastUncompressedChunk), e); //uncompressed size
									bw.Write((uint)uncompressedTotal, e);
									uncompressedTotal += (i != offsets.Count - 1 ? _zLibChunkSize : lastUncompressedChunk);
								}
							}
						}

					}
				}
			}
			catch (Exception ex)
			{
				throw new ApplicationException(string.Format("Compress Failed: {0}", ex));
			}

			//using (FileStream sf = File.OpenRead(uncompFilename))
			//{
			//    using (FileStream df = File.Create(compFilename))
			//    {
			//        using (DeflateStream ds = new DeflateStream(df, CompressionMode.Compress))
			//        {
			//            byte[] b = new byte[10000];
			//            int c = 0;
			//            do
			//            {
			//                c = sf.Read(b, 0, b.Length);
			//                ds.Write(b, 0, c);
			//            }
			//            while (c == b.Length);
			//        }
			//    }
			//}

		}*/

		private List<NonDebugQbKey> _qbKeys = null;

		public readonly PakFormatType PakFormatType;
		private StructItemChildrenType _structItemChildrenType;
		public readonly string FriendlyName;
		public readonly EndianType EndianType;
		public readonly string FileExtension;
		public readonly string QbDebugExtension;
		public readonly int FilePadSize;
		//public readonly bool SupportsPabFile;

		public string PakFilename;
		public string DebugFilename;
		public string PabFilename;
		public string NonDebugQbKeyFilename;

		public string FullPakFilename;
		public string FullDebugFilename;
		public string FullPabFilename;
		public string FullNonDebugQbKeyFilename;

		public string CompressedPakFilename;
		public string CompressedPabFilename;
		public string CompressedDebugFilename;
		public string FullCompressedPakFilename;
		public string FullCompressedPabFilename;
		public string FullCompressedDebugFilename;

		public long CompressedPakFilesize;
		public long CompressedPabFilesize;

		public long UnCompressedPakFilesize;
		public long UnCompressedPabFilesize;

		public CompressionType CompressionType;

		public readonly bool IsCompressed;

		public readonly string PakPath;

		public readonly uint LastHeaderLength;

		private static uint[,] _types;

		public long PakPabMinDataOffset;

		//private uint _zLibChunkSize;
		//private uint _zLibHeaderLen;
		public uint ZlibBlockPad = 0x400; //2k  //0x800
		//public uint ZlibFilePadGH5 = 0x4000; //16k
		public uint ZlibFilePad = 0x8000; //32k

	}
}
