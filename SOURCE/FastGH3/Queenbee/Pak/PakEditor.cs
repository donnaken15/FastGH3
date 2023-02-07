using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.IO.Compression;

namespace Nanook.QueenBee.Parser
{
	public class PakEditor
	{
		private delegate void WriteDataToStream(Stream stream);

		public PakEditor(PakFormat pakFormat) : this(pakFormat, false)
		{
		}

		public PakEditor(PakFormat pakFormat, bool debugFile)
		{

			if (pakFormat.PakFilename == null || pakFormat.PakFilename == string.Empty)
				throw new ArgumentException("There is no PakFileName in the pakFormat argument");



			parsePak(pakFormat, debugFile);
		}

		public StructItemChildrenType StructItemChildrenType
		{
			get
			{
				if (_pakFormat.StructItemChildrenType == Nanook.QueenBee.Parser.StructItemChildrenType.NotSet)
				{
					foreach (PakHeaderItem phi in _pakHeaders.Values)
					{
						if (phi.PakFileType == PakItemType.Qb || phi.PakFileType == PakItemType.Sqb || phi.PakFileType == PakItemType.Midi)
						{
							QbFile qbf = this.ReadQbFile(phi.Filename); //set the _pakformat.StructItemChildrenType item
							if (_pakFormat.StructItemChildrenType != Nanook.QueenBee.Parser.StructItemChildrenType.NotSet)
								return _pakFormat.StructItemChildrenType;
						}
					}
					return Nanook.QueenBee.Parser.StructItemChildrenType.NotSet;
				}
				else
					return _pakFormat.StructItemChildrenType;
			}
		}

		private void parsePak(PakFormat pakFormat, bool debugFile)
		{
			_debugFile = debugFile;
			_pakFormat = pakFormat;
			_pakFilename = (!_debugFile ? _pakFormat.FullPakFilename : _pakFormat.FullDebugFilename);

			Dictionary<uint, PakDbgQbKey> qbKeyFilenames = new Dictionary<uint, PakDbgQbKey>();

			//if PC or xbox then we need to look up the filename from the debug file
			//create a PakEditor and load the debug pak, then load all internal debug files, add the first line to our filenames dictionary
			if (!debugFile) // && (_pakFormat.PakFormatType == PakFormatType.PC || _pakFormat.PakFormatType == PakFormatType.XBox))
			{
				try
				{
					_pakFormat.Decompress();
					_pakFilename = _pakFormat.FullPakFilename;
				}
				catch (Exception ex)
				{
					throw new Exception("Decompression Error", ex);
				}


				if (_pakFormat.DebugFileExists)
				{
					string debugFileContents;
					string filename;
					uint crc;
					PakEditor pakDebug = new PakEditor(new PakFormat(_pakFormat.FullDebugFilename, "", _pakFormat.FullDebugFilename, _pakFormat.PakFormatType), true);
					foreach (PakHeaderItem dphi in pakDebug.Headers.Values)
					{
						debugFileContents = string.Empty;
						filename = string.Empty;
						crc = 0;
						if (dphi.FullFilenameQbKey != 0)
							crc = dphi.FullFilenameQbKey;
						else if (dphi.PakFullFileNameQbKey != 0)
							crc = dphi.PakFullFileNameQbKey;
						else if (dphi.NameOnlyCrc != 0)
							crc = dphi.NameOnlyCrc;

						if (crc != 0)
						{
							filename = crc.ToString("X").PadLeft(8, '0');
							if (pakDebug.Headers.ContainsKey(filename.ToLower()))
							{
								debugFileContents = pakDebug.ExtractFileToString(filename);

								if (debugFileContents.Length != 0)
								{
									addDebugFilename(debugFileContents, qbKeyFilenames, crc);
									QbFile.PopulateDebugNames(debugFileContents);
								}
							}
						}
					}
				}

			}

			long minOffset = uint.MaxValue;
			long maxOffset = 0;

			_pakHeaders = new Dictionary<string, PakHeaderItem>();

			using (Stream st = File.Open(_pakFilename, FileMode.Open, FileAccess.Read))
			{
				_pakFileLength = st.Length;

				using (BinaryEndianReader br = new BinaryEndianReader(st))
				{
					PakHeaderItem phi = null;

					QbKey lastQbKey = QbKey.Create("last");
					QbKey dotLastQbKey = QbKey.Create(".last");

					do
					{
						phi = new PakHeaderItem();

						phi.HeaderStart = (uint)st.Position;
						phi.IsStoredInPak = true;

						phi.FileType = QbKey.Create(br.ReadUInt32(_pakFormat.EndianType));

						//if the entry has the file type of last then we're done
						if (phi.FileType == lastQbKey || phi.FileType == dotLastQbKey)
							break;

						phi.FileOffset = br.ReadUInt32(_pakFormat.EndianType);
						phi.FileLength = br.ReadUInt32(_pakFormat.EndianType);
						phi.PakFullFileNameQbKey = br.ReadUInt32(_pakFormat.EndianType);
						phi.FullFilenameQbKey = br.ReadUInt32(_pakFormat.EndianType);
						phi.NameOnlyCrc = br.ReadUInt32(_pakFormat.EndianType);
						phi.Unknown = br.ReadUInt32(_pakFormat.EndianType);
						phi.Flags = (PakHeaderFlags)br.ReadUInt32(_pakFormat.EndianType);

						if ((phi.Flags & PakHeaderFlags.Filename) != PakHeaderFlags.Filename)
						{
							uint crc = 0;

							//get any Crc
							if (phi.FullFilenameQbKey != 0)
								crc = phi.FullFilenameQbKey;
							else if (phi.PakFullFileNameQbKey != 0)
								crc = phi.PakFullFileNameQbKey;
							else if (phi.NameOnlyCrc != 0)
								crc = phi.NameOnlyCrc;

							if (!debugFile)
							{
								uint crc2 = 0;
								//get a crc that exists in the debug names
								if (qbKeyFilenames.ContainsKey(phi.FullFilenameQbKey))
									crc2 = phi.FullFilenameQbKey;
								else if (qbKeyFilenames.ContainsKey(phi.PakFullFileNameQbKey))
									crc2 = phi.PakFullFileNameQbKey;
								else if (qbKeyFilenames.ContainsKey(phi.NameOnlyCrc))
									crc2 = phi.NameOnlyCrc;

								//if 0 then get any crc
								if (crc2 != 0)
								{
									phi.Filename = qbKeyFilenames[crc2].Filename;
									phi.DebugQbKey = qbKeyFilenames[crc2].DebugQbKey;
									crc = crc2;
								}
							}

							if (phi.Filename == null)
							{
								if (crc != 0)
									phi.Filename = crc.ToString("X").PadLeft(8, '0');
								else
									phi.Filename = string.Format("Unknown={0}", phi.HeaderStart.ToString("X").PadLeft(8, '0'));
							}
						}
						else
							phi.Filename = UTF8Encoding.UTF8.GetString(br.ReadBytes(PakHeaderItem.FileNameMaxLength)).TrimEnd(new char[] { '\0' });

						try
						{
							_pakHeaders.Add(phi.Filename.ToLower(), phi);
						}
						catch (Exception ex)
						{
							throw new ApplicationException(string.Format("Error adding '{0}' to headers: {1}", phi.Filename, ex.Message));
						}

						if (phi.HeaderStart + phi.FileOffset < minOffset)
							minOffset = phi.HeaderStart + phi.FileOffset;

						if (phi.HeaderStart + phi.FileOffset > maxOffset)
							maxOffset = phi.HeaderStart + phi.FileOffset;


					}
					while (1 == 1); //minOffset > fs.Position + 0x100); //drop out if we reach the data



					//this is a simple hack/fix to cater for padding on PAK files,
					//it relies on the data starting at the top of the PAB file (which it always does, currently)
					_requiresPab = maxOffset >= st.Length;

					if (!debugFile) //only when loading pak
						_pakFormat.PakPabMinDataOffset = minOffset; //remember this value


					//detect GH5 PAB files
					if (_requiresPab)
					{
						foreach (PakHeaderItem ph in _pakHeaders.Values)
							ph.FileOffset += (uint)(_pakFileLength - _pakFormat.PakPabMinDataOffset) - (_pakFormat.PakPabMinDataOffset == 0 ? ph.HeaderStart : 0); //gh5 doesn't hold the offset in relation to the data.
						minOffset = _pakFileLength;
					}

				}
			}

			_qbFilenames = new string[_pakHeaders.Count];
			int i = 0;
			foreach (PakHeaderItem hi in _pakHeaders.Values)
				_qbFilenames[i++] = hi.Filename;

			StructItemChildrenType s;
			if (!debugFile)
				s = this.StructItemChildrenType;  //auto detect the structitemchildren type
		}

		private void addDebugFilename(string debugFileContents, Dictionary<uint, PakDbgQbKey> qbKeyFilenames, uint dbgQbKey)
		{
			if (debugFileContents == null)
				return;

			string[] d = debugFileContents.Replace("\r", "").Split(new char[] { '\n' });

			bool b = false;
			int pos = 10;
			uint qbKey;
			foreach (string s in d)
			{
				if (b)
				{
					if (s.Trim().Length > 2)
					{
						if (s[pos] == ' ')
						{
							if (s.IndexOf(':') == -1)
							{
								qbKey = uint.Parse(s.Substring(2, pos - 2), System.Globalization.NumberStyles.HexNumber);
								qbKeyFilenames.Add(qbKey, new PakDbgQbKey(qbKey, dbgQbKey, s.Substring(pos + 1).Trim()));
							}
							return;
						}
						else
							throw new ApplicationException(string.Format("Bad Entry in checksum in debug file, char[{0}] id not a space", pos.ToString()));
					}
				}
				else
				{
					if (s == "[Checksums]")
						b = true;
				}
			}
		}

		public string[] QbFilenames
		{
			get { return _qbFilenames; }
		}

		public QbFile ReadQbFile(string qbFilename)
		{
			return ReadQbFile(qbFilename, "");
		}

		public QbFile ReadQbFile(string qbFilename, string debugFileContents)
		{
			if (_pakHeaders.ContainsKey(qbFilename.ToLower()))
			{
				PakHeaderItem phi = _pakHeaders[qbFilename.ToLower()];
				//open input pak
				string fname;
				long offset;

				if (_debugFile)
				{
					fname = _pakFormat.FullDebugFilename;
					offset = phi.HeaderStart + phi.FileOffset;
				}
				else if (_requiresPab)
				{
					fname = _pakFormat.FullPabFilename;
					offset = (phi.HeaderStart + phi.FileOffset) - (new FileInfo(_pakFormat.FullPakFilename)).Length;
				}
				else
				{
					fname = _pakFormat.FullPakFilename;
					offset = phi.HeaderStart + phi.FileOffset;
				}

				using (FileStream fsPak = File.Open(fname, FileMode.Open, FileAccess.Read))
				{
					if ((offset + phi.FileLength) - 1 > fsPak.Length)
						throw new ApplicationException(string.Format("End of file '{0}' is located at 0x{1} which is beyond the PAK/PAB size 0x{2}", qbFilename, (offset + phi.FileLength).ToString("X").PadLeft(8, '0'), fsPak.Length.ToString("X").PadLeft(8, '0')));

					fsPak.Seek(offset, SeekOrigin.Begin);
					return new QbFile(qbFilename, debugFileContents, fsPak, _pakFormat); //doesn't matter if debug file is empty

				}
			}
			else
				throw new ApplicationException(string.Format("'{0}' does not exist in '{1}'", qbFilename, _pakFilename));
		}

		public string ExtractFileToString(string pakFilename)
		{
			return Encoding.Default.GetString(ExtractFileToBytes(pakFilename));
		}

		public byte[] ExtractFileToBytes(string qbFilename)
		{
			if (_pakHeaders.ContainsKey(qbFilename.ToLower()))
			{
				byte[] b = new byte[_pakHeaders[qbFilename.ToLower()].FileLength];
				using (MemoryStream ms = new MemoryStream(b))
				{
					ExtractFile(qbFilename, ms);
					return b;
				}
			}
			else
				throw new ApplicationException(string.Format("'{0}' does not exist in '{1}'", qbFilename, _pakFilename));
		}

		public void ExtractFile(string qbFilename, string filename)
		{
			using (FileStream fs = File.Create(filename))
			{
				ExtractFile(qbFilename, fs);
			}
		}

		public void ExtractFile(string qbFilename, Stream stream)
		{
			//open input pak
			string fname;
			long offset;

			if (_pakHeaders.ContainsKey(qbFilename.ToLower()))
			{
				PakHeaderItem phi = _pakHeaders[qbFilename.ToLower()];
				//open output
				if (_debugFile)
				{
					fname = _pakFormat.FullDebugFilename;
					offset = phi.HeaderStart + phi.FileOffset;
				}
				else if (_requiresPab)
				{
					fname = _pakFormat.FullPabFilename;
					offset = (phi.HeaderStart + phi.FileOffset) - (new FileInfo(_pakFormat.FullPakFilename)).Length;
				}
				else
				{
					fname = _pakFormat.FullPakFilename;
					offset = phi.HeaderStart + phi.FileOffset;
				} 
				
				using (BinaryWriter bw = new BinaryWriter(stream))
				{
					//open input pak
					using (FileStream fsPak = File.Open(fname, FileMode.Open, FileAccess.ReadWrite))
					{
						if ((offset + phi.FileLength) - 1 > fsPak.Length)
							throw new ApplicationException(string.Format("End of file '{0}' is located at 0x{1} which is beyond the PAK/PAB size 0x{2}", qbFilename, (offset + phi.FileLength).ToString("X").PadLeft(8, '0'), fsPak.Length.ToString("X").PadLeft(8, '0')));

						using (BinaryReader brPak = new BinaryReader(fsPak))
						{
							fsPak.Seek(offset, SeekOrigin.Begin);
							copyData(fsPak, stream, (long)phi.FileLength);
						}
					}
				}
			}
			else
				throw new ApplicationException(string.Format("'{0}' does not exist in '{1}'", qbFilename, _pakFilename));
		}

		private PakHeaderItem createBlankFile(string newQbFilename, QbKey itemType, bool filenameInHeader)
		{
			//update the filename in the collection
			List<PakHeaderItem> hd = new List<PakHeaderItem>(_pakHeaders.Values);

			PakHeaderItem newHdr = new PakHeaderItem();
			newHdr.FileLength = 0; // (uint)(new FileInfo(localFilename)).Length;
			newHdr.FileOffset = hd[0].FileOffset + (uint)(filenameInHeader ? PakHeaderItem.FullHeaderLength : 0x20);
			newHdr.Flags = (PakHeaderFlags)(filenameInHeader ? PakHeaderFlags.Filename : 0);
			newHdr.HeaderStart = 0;
			newHdr.IsStoredInPak = true;
			newHdr.Filename = newQbFilename;
			newHdr.FileType = itemType;
			hd.Insert(0, newHdr);

			//update the filename in the collection
			bool pastNew = false;
			Dictionary<string, PakHeaderItem> p = new Dictionary<string, PakHeaderItem>(_pakHeaders.Count);

			bool hasFoundMatch = filenameInHeader;

			foreach (PakHeaderItem ph in hd)
			{
				//small hack to determine which items need to be filled - Find another header with 
				if (!hasFoundMatch && ((ph.Flags & PakHeaderFlags.Filename) != PakHeaderFlags.Filename) && ph != newHdr)
				{
					newHdr.SetFilename(newQbFilename, itemType, _pakFormat.FileExtension, ph);
					hasFoundMatch = true;
				}

				if (pastNew)
					ph.HeaderStart += (uint)(filenameInHeader ? PakHeaderItem.FullHeaderLength : 0x20);
				else if (ph != newHdr)
					ph.FileOffset += (uint)(filenameInHeader ? PakHeaderItem.FullHeaderLength : 0x20);
				else // (ph == newHdr)
					pastNew = true;

				p.Add(ph.Filename.ToLower(), ph);
			}

			if (!hasFoundMatch)
				newHdr.SetFilename(newQbFilename, itemType, _pakFormat.FileExtension, null);

			_pakFileLength += (uint)(filenameInHeader ? PakHeaderItem.FullHeaderLength : PakHeaderItem.FullHeaderLength - PakHeaderItem.FileNameMaxLength);

			_pakHeaders = p;

			string newPakFilename = string.Format("{0}_{1}", _pakFilename, Guid.NewGuid().ToString("N"));
			using (FileStream fsO = File.Open(newPakFilename, FileMode.CreateNew))
			{
				using (BinaryEndianWriter bw = new BinaryEndianWriter(fsO))
				{
					writeHeaderItem(bw, newHdr);
					using (FileStream fsI = File.OpenRead(_pakFilename))
						copyData(fsI, fsO, new FileInfo(_pakFilename).Length);
				}
			}

			File.Delete(_pakFilename);
			File.Move(newPakFilename, _pakFilename);

			return newHdr;
		}

		public void NewFile(string newQbFilename, QbKey itemType, bool filenameInHeader, uint magic, byte[] unknownData)
		{
			createBlankFile(newQbFilename, itemType, filenameInHeader);
			QbFile blank = new QbFile(newQbFilename, _pakFormat, magic, unknownData);
			this.ReplaceFile(newQbFilename, blank);
		}

		/// <summary>
		/// Add a new file in to the PAK, currently just inserts it at the start.
		/// </summary>
		/// <param name="newFullQbFilename">Full QB filename</param>
		/// <param name="fileType">.qb or .sqb=QB, .mqb=mid, .img=img .dbg=dbg  etc</param>
		/// <param name="extension">.qb.ngc for Wii for example</param>
		public void AddFile(string localFilename, string newQbFilename, QbKey itemType, bool filenameInHeader)
		{
			createBlankFile(newQbFilename, itemType, filenameInHeader);

			this.ReplaceFile(newQbFilename, localFilename);
		}


		/// <summary>
		/// Add a new file in to the PAK, currently just inserts it at the start.
		/// </summary>
		/// <param name="newFullQbFilename">Full QB filename</param>
		/// <param name="fileType">.qb or .sqb=QB, .mqb=mid, .img=img .dbg=dbg  etc</param>
		/// <param name="extension">.qb.ngc for Wii for example</param>
		public void AddFile(QbFile newQbFile, string newQbFilename, QbKey itemType, bool filenameInHeader)
		{
			createBlankFile(newQbFilename, itemType, filenameInHeader);

			this.ReplaceFile(newQbFilename, newQbFile);

		}

		public void RemoveFile(string qbFilename)
		{

			//open input pak, write the new file to the output pak file
			replaceFile(qbFilename, 0, true, delegate(Stream stream)
			{
				//Write the new file into the pak file 
				//nothing...
			});

		}

		/// <summary>
		/// Rename the filename, this does not set the fileid for all the qb types
		/// </summary>
		/// <param name="qbFilename">Source full filename.</param>
		/// <param name="newFullQbFilename">Full QB filename</param>
		/// <param name="fileType">.qb or .sqb=QB, .mqb=mid, .img=img .dbg=dbg  etc</param>
		/// <param name="extension">.qb.ngc for Wii for example</param>
		public void RenameFile(string qbFilename, string newQbFilename, QbKey itemType)
		{
			PakHeaderItem phi = _pakHeaders[qbFilename.ToLower()];

			phi.SetFilename(newQbFilename, itemType, _pakFormat.FileExtension, phi);

			using (BinaryEndianWriter bw = new BinaryEndianWriter(File.OpenWrite(_pakFormat.FullPakFilename)))
			{
				bw.BaseStream.Seek(phi.HeaderStart, SeekOrigin.Begin);
				writeHeaderItem(bw, phi);
			}

			//update the filename in the collection
			Dictionary<string, PakHeaderItem> p = new Dictionary<string,PakHeaderItem>(_pakHeaders.Count);
			foreach (PakHeaderItem ph in _pakHeaders.Values)
				p.Add(ph.Filename.ToLower(), ph);

			_pakHeaders = p;

			if (phi.PakFileType == PakItemType.Qb || phi.PakFileType == PakItemType.Sqb || phi.PakFileType == PakItemType.Midi)
			{
				try
				{
					QbFile qbf = ReadQbFile(newQbFilename);
					qbf.SetNewFileId();
					ReplaceFile(newQbFilename, qbf);
				}
				catch
				{
				}
			}
		}

		public void ReplaceFile(string qbFilename, string withfilename)
		{
			//open input pak, write the new file to the output pak file
			using (FileStream fs = File.Open(withfilename, FileMode.Open, FileAccess.ReadWrite))
			{
				replaceFile(qbFilename, fs.Length, false, delegate(Stream stream)
				{
					//Write the new file into the pak file 
					copyData(fs, stream, fs.Length);
				});
			}

		}

		// copied and edited by wesley
		// why is this not a thing
		public void ReplaceFile(string qbFilename, byte[] filebytes)
		{
			using (Stream ms = new MemoryStream(filebytes))
			{
				replaceFile(qbFilename, ms.Length, false, delegate(Stream stream)
				{
					copyData(ms, stream, ms.Length);
				});
			}

		}

		public void ReplaceFile(string qbFilename, QbFile withQbFile)
		{
			replaceFile(qbFilename, withQbFile.Length, false, delegate(Stream stream)
			{
				withQbFile.Write(stream);
			});

		}

		private void replaceFile(string qbFilename, long newLength, bool remove, WriteDataToStream callback)
		{
			int filePad = _pakFormat.FilePadSize;

			PakHeaderItem phi = null;
			if (_pakHeaders.ContainsKey(qbFilename.ToLower()))
				phi = _pakHeaders[qbFilename.ToLower()];
			else
			{
				string fqk = QbKey.Create(qbFilename).Crc.ToString("X").PadLeft(8, '0').ToLower();

				if (_pakHeaders.ContainsKey(fqk))
					phi = _pakHeaders[fqk];

			}

			if (phi != null)
			{
				long pad = filePad - (newLength % filePad);
				if (pad == filePad)
					pad = 0;

				string newPakFilename = string.Format("{0}_{1}", _pakFormat.FullPakFilename, Guid.NewGuid().ToString("N"));
				string newPabFilename = string.Format("{0}_{1}", _pakFormat.FullPabFilename, Guid.NewGuid().ToString("N"));

				uint minOffset = uint.MaxValue;
				bool itemFound = false;
				uint nextOffset = 0;

				foreach (PakHeaderItem ph in _pakHeaders.Values)
				{
					if (itemFound)
					{
						nextOffset = ph.FileOffset + ph.HeaderStart;
						itemFound = false; //don't enter this if again
					}

					if (object.ReferenceEquals(phi, ph))
						itemFound = true;

					if (ph.HeaderStart + ph.FileOffset < minOffset)
						minOffset = ph.HeaderStart + ph.FileOffset;
				}

				uint lastItemPad = 0;
				int repPad = filePad - ((int)phi.FileLength % filePad);
				if (repPad == filePad)
					repPad = 0;

				//previously badly padded or last file
				if (nextOffset != 0 && (nextOffset - (phi.FileOffset + phi.HeaderStart)) % filePad != 0)
					repPad = (int)((nextOffset - (phi.FileOffset + phi.HeaderStart)) - phi.FileLength);


				//position of the LAST header item
				long lastHeaderPos = 0;
				//the length of all the headers (like pak when there's a pab) with padding
				long allHeadersLen = minOffset;
				//position in the input file where our file is to be replaced (not including header pos)
				long fileReplacePos = (phi.HeaderStart + phi.FileOffset) - allHeadersLen;
				//position in the input file after the file that is to be replaced
				long fileAfterReplacePos = fileReplacePos + phi.FileLength + repPad; //item size before modifying header

				//open input pak
				using (FileStream fsPakI = File.Open(_pakFilename, FileMode.Open, FileAccess.Read))
				{
					using (BinaryEndianReader brPakI = new BinaryEndianReader(fsPakI))
					{
						//open output pak temp file
						using (FileStream fsPakO = File.Create(newPakFilename))
						{
							using (BinaryEndianWriter bwPakO = new BinaryEndianWriter(fsPakO))
							{
								long diffLen = 0;

								//do not compensate for missing header when using zlib compression as the header is padded
								if (remove && _pakFormat.CompressionType != CompressionType.ZLibChunk) //we need to cater for the header being removed on all items before it.
								{
									diffLen = PakHeaderItem.FullHeaderLength;
									if ((phi.Flags & PakHeaderFlags.Filename) != PakHeaderFlags.Filename)
										diffLen -= PakHeaderItem.FileNameMaxLength;
								}


								//write out the headers
								foreach (PakHeaderItem ph in _pakHeaders.Values)
								{
									//apply offset change before finding file to be replaced
									//this will prevents the offset of the replaced file being changed
									ph.FileOffset = (uint)(ph.FileOffset - (long)diffLen);
									if (object.ReferenceEquals(phi, ph))
									{
										if (remove)
										{
											long remPad = filePad - (phi.FileLength % filePad);
											if (remPad == filePad)
												remPad = 0;

											diffLen = phi.FileLength + remPad; //now cater for the difference in file size
										}
										else
										{
											diffLen = (long)((ph.FileLength + repPad) - (newLength + pad));
											ph.FileLength = (uint)newLength; //0 for remove
										}
									}

									lastHeaderPos += PakHeaderItem.FullHeaderLength;

									if (!(remove && object.ReferenceEquals(phi, ph)))
										writeHeaderItem(bwPakO, ph);


									if ((ph.Flags & PakHeaderFlags.Filename) != PakHeaderFlags.Filename)
										lastHeaderPos -= PakHeaderItem.FileNameMaxLength;
								}

								//Move to the "last" header
								fsPakI.Seek(lastHeaderPos, SeekOrigin.Begin);

								//write out "last" HeaderType
								bwPakO.Write(brPakI.ReadBytes(4));

								//Modify and write the offset of the "last" header's data
								uint lastOffset = brPakI.ReadUInt32(_pakFormat.EndianType);
								lastOffset = (uint)(lastOffset - (long)diffLen);

								//fix bad padding on last file
								if (nextOffset == 0 && ((lastOffset - (phi.FileOffset + phi.HeaderStart) % filePad) % filePad) != 0)
								{
									lastItemPad = (uint)filePad - (uint)(lastOffset % filePad);
									lastOffset += lastItemPad;
								}

								bwPakO.Write(lastOffset, _pakFormat.EndianType);

								//write out the end of the last header
								copyData(fsPakI, fsPakO, allHeadersLen - fsPakI.Position);

							}
						}
					}
				}

				//open input pak
				using (FileStream fsPakI = File.Open(_requiresPab ? _pakFormat.FullPabFilename : _pakFilename, FileMode.Open, FileAccess.Read))
				{
					using (BinaryEndianReader brPakI = new BinaryEndianReader(fsPakI))
					{
						//open output pak temp file
						using (FileStream fsPakO = _requiresPab ? File.Open(newPabFilename, FileMode.Create) : File.Open(newPakFilename, FileMode.Append))
						{
							using (BinaryEndianWriter bwPakO = new BinaryEndianWriter(fsPakO))
							{
								if (!_requiresPab)
									fsPakI.Seek(allHeadersLen, SeekOrigin.Begin);

								//Write out the data starting from the last header to the start of the file to be replaced (minus the length of the type and offset)
								copyData(fsPakI, fsPakO, fileReplacePos);

								//Write the new file into the pak file 
								int pos = (int)fsPakO.Position;
								callback(fsPakO);
								if (pad != 0)
									fsPakO.Write(new byte[pad], 0, (int)pad);

								if (!_requiresPab)
									fileAfterReplacePos += allHeadersLen;

								if (lastItemPad != 0)
									fileAfterReplacePos -= lastItemPad; // a bit of a hack as this was not applied when this var was set as we didn't know the values

								//write the remainder of source the pak file
								fsPakI.Seek(fileAfterReplacePos, SeekOrigin.Begin);
								copyData(fsPakI, fsPakO, fsPakI.Length - fileAfterReplacePos);

								fsPakO.Flush();
							}
						}
					}
				}

				fixUncompressedFileLengths(newPakFilename, newPabFilename);
			   

				File.Delete(_pakFilename);
				File.Move(newPakFilename, _pakFilename);
				if (_requiresPab)
				{
					File.Delete(_pakFormat.FullPabFilename);
					File.Move(newPabFilename, _pakFormat.FullPabFilename);
				}


				_pakFormat.Compress();
			}
			else
				throw new ApplicationException(string.Format("'{0}' does not exist in '{1}'", qbFilename, _pakFilename));

		}

		private long removePadding(string filename, byte padVal, long minSize)
		{
			//remove all padding
			bool isPadVal = true;
			byte[] padData = new byte[(int)_pakFormat.ZlibBlockPad];

			long pos;
			long ret;
			int read;

			using (FileStream fs = new FileStream(filename, FileMode.Open, FileAccess.ReadWrite))
			{
				while (isPadVal && fs.Length > _pakFormat.ZlibBlockPad && (minSize == 0 || fs.Length > minSize))
				{
					if (fs.Length - _pakFormat.ZlibBlockPad < minSize)
						fs.Seek(minSize, SeekOrigin.Begin);
					else
						fs.Seek(fs.Length - _pakFormat.ZlibBlockPad, SeekOrigin.Begin);
					pos = fs.Position;
					read = fs.Read(padData, 0, padData.Length);
					int i;
					for (i = 0; i < read; i++)
					{
						if (!(isPadVal = (padData[read - (i + 1)] == padVal)))
							break;
					}

					if (i != 0)
						fs.SetLength(pos + (long)(read - i));
					if (i != read)
						break;
				}
				ret = fs.Length;
			}

			return ret;
		}


		private void fixUncompressedFileLengths(string newPakFilename, string newPabFilename)
		{

			byte[] padData = new byte[(int)_pakFormat.ZlibFilePad];

			if (_pakFormat.PakFormatType != PakFormatType.PC)
				throw new Exception("Unsupported PAK format.");
			/*if (_pakFormat.PakFormatType == PakFormatType.XBox && _pakFormat.CompressionType == CompressionType.ZLibChunk) //pak might not be compressed (GHWT etc)
			{
				long newSize = removePadding(newPakFilename, 0, _pakFormat.UnCompressedPakFilesize);


				//PAK
				using (FileStream fs = new FileStream(newPakFilename, FileMode.Open, FileAccess.ReadWrite))
				{
					//correct padding on raw files
					bool is0 = true;
					if (newSize > _pakFormat.UnCompressedPakFilesize)
					{
						//check end is all 00's
						fs.Seek(_pakFormat.UnCompressedPakFilesize, SeekOrigin.Begin);
						byte[] end = new byte[newSize - _pakFormat.UnCompressedPakFilesize];
						fs.Read(end, 0, end.Length);

						foreach (byte b in end)
						{
							if (!(is0 = (b == 0)))
								break;
						}

						if (is0)
							fs.SetLength(_pakFormat.UnCompressedPakFilesize); //truncate file
					}


					//don't pad if not compressing
					if (_pakFormat.FullCompressedPakFilename.ToLower() != _pakFormat.FullPakFilename.ToLower())
					{
						if (_pakFormat.UnCompressedPakFilesize > newSize || !is0)
						{
							fs.Seek(0, SeekOrigin.End);

							//pad file to next 0x800
							int pad = (int)(fs.Position % _pakFormat.ZlibBlockPad);
							if (pad != 0 && fs.Position != 0)
								fs.Write(padData, 0, (int)_pakFormat.ZlibBlockPad - pad);

						}
					}
				}


				newSize = removePadding(newPabFilename, 0xAB, 0);

				//PAB
				using (FileStream fs = new FileStream(newPabFilename, FileMode.Open, FileAccess.ReadWrite))
				{
					//correct padding on raw files
					bool isAB = true;
					if (newSize > _pakFormat.UnCompressedPabFilesize)
					{
						//check end is all 00's
						fs.Seek(_pakFormat.UnCompressedPabFilesize, SeekOrigin.Begin);
						byte[] end = new byte[newSize - _pakFormat.UnCompressedPabFilesize];
						fs.Read(end, 0, end.Length);

						foreach (byte b in end)
						{
							if (!(isAB = (b == 0xAB)))
								break;
						}

						if (isAB)
							fs.SetLength(_pakFormat.UnCompressedPabFilesize); //truncate file
					}


					//don't pad if not compressing
					if (_pakFormat.FullCompressedPabFilename.ToLower() != _pakFormat.FullPabFilename.ToLower())
					{
						if (_pakFormat.UnCompressedPabFilesize > newSize || !isAB)
						{
							for (int i = 0; i < padData.Length; i++)
								padData[i] = 0xAB;

							fs.Seek(0, SeekOrigin.End);


							//pad file to next 0x800
							int pad = (int)(fs.Position % _pakFormat.ZlibFilePadGH5);  //ZlibFilePadGH5  ZlibBlockPad
							if (pad != 0 && fs.Position != 0)
								fs.Write(padData, 0, (int)_pakFormat.ZlibFilePadGH5 - pad);  //ZlibFilePadGH5  ZlibBlockPad

						}
					}
				}
			}*/
		}

		private void writeHeaderItem(BinaryEndianWriter bwPakO, PakHeaderItem ph)
		{
			bwPakO.Write(ph.FileType.Crc, _pakFormat.EndianType);

			uint offset = ph.FileOffset;
			if (_requiresPab)
				offset = (uint)_pakFormat.PakPabMinDataOffset + ((_pakFormat.PakPabMinDataOffset == 0 ? ph.HeaderStart : 0) + ph.FileOffset) - (uint)_pakFileLength;

			bwPakO.Write(offset, _pakFormat.EndianType);
			bwPakO.Write(ph.FileLength, _pakFormat.EndianType);
			bwPakO.Write(ph.PakFullFileNameQbKey, _pakFormat.EndianType);
			bwPakO.Write(ph.FullFilenameQbKey, _pakFormat.EndianType);
			bwPakO.Write(ph.NameOnlyCrc, _pakFormat.EndianType);
			bwPakO.Write(ph.Unknown, _pakFormat.EndianType);
			bwPakO.Write((uint)ph.Flags, _pakFormat.EndianType);

			if ((ph.Flags & PakHeaderFlags.Filename) == PakHeaderFlags.Filename)
				bwPakO.Write(Encoding.UTF8.GetBytes(ph.PaddedFileName), 0, PakHeaderItem.FileNameMaxLength);
		}


		/// <summary>
		/// Copy Data from one stream to the other with out using lots of memory
		/// </summary>
		/// <param name="br"></param>
		/// <param name="bw"></param>
		/// <param name="length"></param>
		private void copyData(Stream sr, Stream sw, long length)
		{
			BinaryReader br = new BinaryReader(sr);
			BinaryWriter bw = new BinaryWriter(sw);
			long chunk = 1000000;
			while (length > 0)
			{
				if (length > chunk)
				{
					bw.Write(br.ReadBytes((int)chunk));
					length -= chunk;
				}
				else
				{
					bw.Write(br.ReadBytes((int)length));
					length = 0;
				}

			}
		}

		public Dictionary<string, PakHeaderItem> Headers
		{
			get { return _pakHeaders; }
		}

		public string Filename
		{
			get { return _pakFilename; }
		}

		public long FileLength
		{
			get { return _pakFileLength; }
		}

		public PakFormat PakFormat
		{
			get { return _pakFormat; }
		}

		public bool RequiresPab
		{
			get { return _requiresPab; }
		}

		private bool _requiresPab; //PAB required
		private bool _debugFile;
		private Dictionary<string, PakHeaderItem> _pakHeaders;
		private string[] _qbFilenames;
		private string _pakFilename;
		private long _pakFileLength;
		private PakFormat _pakFormat;
	}
}
