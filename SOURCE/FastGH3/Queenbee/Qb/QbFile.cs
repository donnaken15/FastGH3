using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Reflection;

/*
 * This is the entry class to the Qb parser.
 * 
 * Simply instantiate it with the filename of a Qb file.
 * 
 * This parser will parse every byte of the Qb file in to an organised structure.
 * Full exception handling has been added to ensure every section of the Qb file
 * is recognised (even if not understood) with all pointers being read and tested
 * against the structures they are pointing to.
 * 
 * All Items are ultimately derived from QbItemBase which provides some common
 * funtionality:
 * 
 *   Items - A collection of any chil items
 *   Length - Will always return the size of the item in bytes (including any children)
 *            This item is tested to be accurate when saving a file (helps heep thing correct)
 *   
 */

namespace Nanook.QueenBee.Parser
{

	public enum IsValidReturnType
	{
		Okay,
		ItemMustHave0Items,
		ItemMustHave1Item,
		ItemMustHave0OrMoreItems,
		ItemMustHave1OrMoreItems,
		ArrayItemsMustBeSameType
	}



	public class QbFile
	{
		static QbFile()
		{
			_supportedChildItems = new Dictionary<QbItemType,List<QbItemType>>();

			List<QbItemType> root = new List<QbItemType>();
			List<QbItemType> noComplexChildren = new List<QbItemType>();
			List<QbItemType> structChildren = new List<QbItemType>();
			List<QbItemType> arrayChildren = new List<QbItemType>();
			List<QbItemType> structArrayChildren = new List<QbItemType>();
			List<QbItemType> floats = new List<QbItemType>();

			root.Add(QbItemType.SectionArray);
			root.Add(QbItemType.SectionFloat);
			root.Add(QbItemType.SectionFloatsX2);
			root.Add(QbItemType.SectionFloatsX3);
			root.Add(QbItemType.SectionInteger);
			root.Add(QbItemType.SectionQbKey);
			root.Add(QbItemType.SectionScript);
			root.Add(QbItemType.SectionString);
			root.Add(QbItemType.SectionStringW);
			root.Add(QbItemType.SectionQbKeyString);
			root.Add(QbItemType.SectionStringPointer);
			root.Add(QbItemType.SectionQbKeyStringQs); //GH:GH
			root.Add(QbItemType.SectionStruct);

			structChildren.Add(QbItemType.StructItemArray);
			structChildren.Add(QbItemType.StructItemFloat);
			structChildren.Add(QbItemType.StructItemFloatsX2);
			structChildren.Add(QbItemType.StructItemFloatsX3);
			structChildren.Add(QbItemType.StructItemInteger);
			structChildren.Add(QbItemType.StructItemQbKey);
			structChildren.Add(QbItemType.StructItemQbKeyString);
			structChildren.Add(QbItemType.StructItemString);
			structChildren.Add(QbItemType.StructItemStringW);
			structChildren.Add(QbItemType.StructItemStringPointer);
			structChildren.Add(QbItemType.StructItemQbKeyStringQs);
			structChildren.Add(QbItemType.StructItemStruct);


			arrayChildren.Add(QbItemType.ArrayArray);
			arrayChildren.Add(QbItemType.ArrayFloat);
			arrayChildren.Add(QbItemType.ArrayFloatsX2);
			arrayChildren.Add(QbItemType.ArrayFloatsX3);
			arrayChildren.Add(QbItemType.ArrayInteger);
			arrayChildren.Add(QbItemType.ArrayQbKey);
			arrayChildren.Add(QbItemType.ArrayQbKeyString);
			arrayChildren.Add(QbItemType.ArrayStringPointer); //GH:GH
			arrayChildren.Add(QbItemType.ArrayQbKeyStringQs); //GH:GH
			arrayChildren.Add(QbItemType.ArrayString);
			arrayChildren.Add(QbItemType.ArrayStringW);
			arrayChildren.Add(QbItemType.ArrayStruct);
			arrayChildren.Add(QbItemType.Floats);

			structArrayChildren.Add(QbItemType.StructHeader);

			floats.Add(QbItemType.Floats);

			_supportedChildItems.Add(QbItemType.Root, root);

			_supportedChildItems.Add(QbItemType.SectionArray, arrayChildren);
			_supportedChildItems.Add(QbItemType.SectionFloatsX2, floats);
			_supportedChildItems.Add(QbItemType.SectionFloatsX3, floats);
			_supportedChildItems.Add(QbItemType.SectionString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionStringW, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionStruct, structChildren);
			_supportedChildItems.Add(QbItemType.SectionScript, noComplexChildren);

			_supportedChildItems.Add(QbItemType.SectionInteger, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionFloat, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionQbKey, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionQbKeyString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionStringPointer, noComplexChildren);
			_supportedChildItems.Add(QbItemType.SectionQbKeyStringQs, noComplexChildren); //GH:GH

			_supportedChildItems.Add(QbItemType.StructItemArray, arrayChildren);
			_supportedChildItems.Add(QbItemType.StructItemFloatsX2, floats);
			_supportedChildItems.Add(QbItemType.StructItemFloatsX3, floats);
			_supportedChildItems.Add(QbItemType.StructItemString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemStringW, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemStruct, structChildren);

			_supportedChildItems.Add(QbItemType.StructItemQbKeyString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemStringPointer, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemQbKeyStringQs, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemQbKey, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemInteger, noComplexChildren);
			_supportedChildItems.Add(QbItemType.StructItemFloat, noComplexChildren);

			_supportedChildItems.Add(QbItemType.ArrayArray, arrayChildren);
			_supportedChildItems.Add(QbItemType.ArrayString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.ArrayStringW, noComplexChildren);
			_supportedChildItems.Add(QbItemType.ArrayStruct, structArrayChildren);
			_supportedChildItems.Add(QbItemType.ArrayFloatsX2, floats);
			_supportedChildItems.Add(QbItemType.ArrayFloatsX3, floats);

			_supportedChildItems.Add(QbItemType.ArrayQbKey, noComplexChildren);
			_supportedChildItems.Add(QbItemType.ArrayInteger, noComplexChildren);
			_supportedChildItems.Add(QbItemType.ArrayFloat, floats);
			_supportedChildItems.Add(QbItemType.ArrayQbKeyString, noComplexChildren);
			_supportedChildItems.Add(QbItemType.ArrayStringPointer, noComplexChildren); //GH:GH
			_supportedChildItems.Add(QbItemType.ArrayQbKeyStringQs, noComplexChildren); //GH:GH

			_supportedChildItems.Add(QbItemType.StructHeader, structChildren); //when struct array item

			_supportedChildItems.Add(QbItemType.Floats, noComplexChildren);

			_supportedChildItems.Add(QbItemType.Unknown, noComplexChildren);

			DebugNames = new Dictionary<uint, string>();
		}

		/// <summary>
		/// Create a blank QbFile
		/// </summary>
		internal QbFile(string qbFilename, PakFormat pakFormat, uint magic, byte[] unknownData)
		{
			_pakFormat = pakFormat;
			_filename = qbFilename;
			_magic = magic;
			_items = new List<QbItemBase>();

			_items.Add(new QbItemUnknown(unknownData, 0, this));
		}

		public QbFile(string filename, PakFormat pakFormat) : this(filename, "", pakFormat)
		{
		}

		public QbFile(string filename, string debugFilename, PakFormat pakFormat)
		{
			_pakFormat = pakFormat;
			_filename = filename;
			
			using (FileStream fs = File.Open(_filename, FileMode.Open, FileAccess.Read))
				parse(fs);

		}

		/// <summary>
		/// Open using a stream, filename is just for reference. The stream must start with the file (the position is depended on)
		/// </summary>
		/// <param name="filename"></param>
		/// <param name="stream"></param>
		public QbFile(string filename, string debugFileContents, Stream stream, PakFormat pakFormat)
		{
			_pakFormat = pakFormat;
			_filename = filename;
			parse(stream);
		}

		/// Open using a stream.
		public QbFile(Stream stream, string debugFileContents, PakFormat pakFormat) : this("", debugFileContents, stream, pakFormat)
		{
		}

		/// Open using a stream.
		public QbFile(Stream stream, PakFormat pakFormat) : this("", "", stream, pakFormat)
		{
		}

		/// <summary>
		/// Creates an array item based on the data type of the parent.
		/// </summary>
		/// <param name="parent">Must be a simple array type</param>
		/// <returns></returns>
		public static GenericQbItem CreateGenericArrayItem(QbItemBase parent)
		{
			if (parent.Format == QbFormat.ArrayPointer || parent.Format == QbFormat.ArrayValue)
			{
				//creates an item with 1 entry, bit of a hack but it looks clean from the outside
				//this is hard to acheive because the information in the generic item is from attributes on the QB class.
				QbItemBase qb = CreateQbItemType(parent.Root, parent.QbItemType);
				return GetGenericItems(qb)[0];
			}
			return null;
		}

		public static QbItemBase CreateQbItemType(QbFile qbFile, QbItemType type)
		{
			return createQbItemType(qbFile, type, (QbFormat)(-1), false);
		}

		public static QbItemBase CreateQbItemType(QbFile qbFile, QbItemType type, QbFormat qbFormat)
		{
			return createQbItemType(qbFile, type, qbFormat, true);
		}

		private static QbItemBase createQbItemType(QbFile qbFile, QbItemType type, QbFormat qbFormat, bool hasQbFormat)
		{
			QbItemBase qib = null;

			if (qbFile.PakFormat.GetQbItemValue(type, qbFile) == 0xFFFFFFFF)
				throw new ApplicationException(string.Format("'{0}' data value not known for {1}", type.ToString(), qbFile.PakFormat.FriendlyName));

			switch (type)
			{
				//case QbItemType.Unknown:
				//    break;

				case QbItemType.SectionString:
				case QbItemType.SectionStringW:
				case QbItemType.ArrayString:
				case QbItemType.ArrayStringW:
				case QbItemType.StructItemString:
				case QbItemType.StructItemStringW:
					qib = new QbItemString(qbFile);
					break;
				case QbItemType.SectionArray:
				case QbItemType.ArrayArray:
				case QbItemType.StructItemArray:
					qib = new QbItemArray(qbFile);
					break;
				case QbItemType.SectionStruct:
				case QbItemType.StructItemStruct:
				case QbItemType.StructHeader:
					qib = new QbItemStruct(qbFile);
					break;
				case QbItemType.SectionScript:
					qib = new QbItemScript(qbFile);
					break;
				case QbItemType.SectionFloat:
				case QbItemType.ArrayFloat:
				case QbItemType.StructItemFloat:
					qib = new QbItemFloat(qbFile);
					break;
				case QbItemType.SectionFloatsX2:
				case QbItemType.SectionFloatsX3:
				case QbItemType.ArrayFloatsX2:
				case QbItemType.ArrayFloatsX3:
				case QbItemType.StructItemFloatsX2:
				case QbItemType.StructItemFloatsX3:
					qib = new QbItemFloatsArray(qbFile);
					break;
				case QbItemType.SectionInteger:
				case QbItemType.SectionStringPointer:
				case QbItemType.ArrayInteger:
				case QbItemType.ArrayStringPointer: //GH:GH
				case QbItemType.StructItemStringPointer:
				case QbItemType.StructItemInteger:
					qib = new QbItemInteger(qbFile);
					break;
				case QbItemType.SectionQbKey:
				case QbItemType.SectionQbKeyString:
				case QbItemType.SectionQbKeyStringQs: //GH:GH
				case QbItemType.ArrayQbKey:
				case QbItemType.ArrayQbKeyString:
				case QbItemType.ArrayQbKeyStringQs: //GH:GH
				case QbItemType.StructItemQbKey:
				case QbItemType.StructItemQbKeyString:
				case QbItemType.StructItemQbKeyStringQs:
					qib = new QbItemQbKey(qbFile);
					break;
				case QbItemType.Floats:
					qib = new QbItemFloats(qbFile);
					break;
				case QbItemType.ArrayStruct:
					qib = new QbItemStructArray(qbFile);
					break;

				default:
					throw new ApplicationException(string.Format("'{0}' is not recognised by CreateQbItemType.", type.ToString()));
			}
			if (qib != null)
				qib.Create(type);

			return qib;
		}


		public void AlignPointers()
		{
			uint pos = (2 * 4); //magic and filesize
			foreach (QbItemBase qib in _items)
				pos = qib.AlignPointers(pos);

			//2 passes ensures that some tricky issues are dealt with.
			//namely that nested sizes are calculated so parent sizes are accurate
			pos = (2 * 4); //magic and filesize
			foreach (QbItemBase qib in _items)
				pos = qib.AlignPointers(pos);

			//this.FileSize = this.Length;
			this.FileSize = pos; //this should work as long as all the calculations are correct

		}

		public QbItemBase FindItem(QbKey key, bool recursive)
		{
			return SearchItems(this, _items, recursive, delegate(QbItemBase item)
				{
					return (item.ItemQbKey != null && item.ItemQbKey.Crc == key.Crc);
				});
		}

		public QbItemBase FindItem(QbItemType type, bool recursive)
		{
			return SearchItems(this, _items, recursive, delegate(QbItemBase item)
			{
				return (item.QbItemType == type);
			});
		}

		public QbItemBase FindItem(bool recursive, Predicate<QbItemBase> match)
		{
			return SearchItems(this, _items, recursive, match);
		}

		internal QbItemBase SearchItems(QbFile qbFile, List<QbItemBase> qibs, bool recursive, Predicate<QbItemBase> match)
		{
			QbItemBase ret = null;
			foreach (QbItemBase qib in qibs)
			{
				if (match(qib))
					return qib;
				if (recursive && qib.Items.Count != 0)
				{
					ret = SearchItems(qbFile, qib.Items, recursive, match);
					if (ret != null)
						return ret;
				}
			}
			return ret;
		}

		public QbItemBase IsValid()
		{
			QbItemBase qb;
			foreach (QbItemBase qib in _items)
			{
				qb = recurseIsValid(qib);
				if (qb != null)
					return qb;
			}
			return null;
		}

		private QbItemBase recurseIsValid(QbItemBase item)
		{
			QbItemBase res;

			if (item.IsValid != IsValidReturnType.Okay)
				return item;

			if (item.Items.Count != 0)
			{
				foreach (QbItemBase qib in item.Items)
				{
					res = recurseIsValid(qib);
					if (res != null)
						return res;
				}
			}
			return null;
		}

		internal static void PopulateDebugNames(string debugFileContents)
		{
			string[] d = debugFileContents.Replace("\r", "").Split('\n');

			bool b = false;
			int pos = 10;
			foreach (string s in d)
			{
				if (b)
				{
					if (s.Trim().Length > 2)
					{
						if (s[pos] == ' ')
						{
							var key = uint.Parse(s.Substring(2, pos - 2), System.Globalization.NumberStyles.HexNumber);
							var value = s.Substring(pos + 1);
							// Don't store paths as debug names
							if (!DebugNames.ContainsKey(key) && !value.Contains("\\")) DebugNames.Add(key, s.Substring(pos + 1));
							if (!DebugNames.ContainsKey(key) && !value.Contains("\\")) moddiag.DebugNames.Add(key, s.Substring(pos + 1));
						}
						else
						{
							throw new ApplicationException(
								string.Format(
									"Bad Entry in checksum in debug file, char[{0}] id not a space",
									pos.ToString()));
						}
					}

				}
				else
				{
					if (s == "[Checksums]")
						b = true;
				}
			}
		}

		public static string GetDebugName(uint debugCrc)
		{
			string ret = null;
			DebugNames.TryGetValue(debugCrc, out ret);
			return ret;
		}

		internal string LookupDebugName(uint debugCrc)
		{
			return LookupDebugName(debugCrc, true);
		}

		internal string LookupDebugName(uint debugCrc, bool allowUserQbkeyLookup)
		{
			if (DebugNames != null && DebugNames.ContainsKey(debugCrc))
				return DebugNames[debugCrc];

			if (allowUserQbkeyLookup)
			{
				QbKey qbKey = _pakFormat.GetNonDebugQbKey(debugCrc, _filename);
				if (qbKey != null)
					return qbKey.Text;
			}

			return string.Empty;
		}

		/// <summary>
		/// Subtracts the start offset of the stream from current position
		/// </summary>
		/// <param name="stream"></param>
		/// <returns></returns>
		internal uint StreamPos(Stream stream)
		{
			return (uint)(stream.Position - (long)_streamStartPosition);
		}

		private void parse(Stream stream)
		{
			_streamStartPosition = stream.Position;

			_items = new List<QbItemBase>();

			//if (stream.Position != 0)
			//    throw new ApplicationException("The stream must start at position 0 as this parser uses the position to validate pointers.");

			using (BinaryEndianReader br = new BinaryEndianReader(stream))
			{
				_magic = br.ReadUInt32(this.PakFormat.EndianType);
				_fileSize = br.ReadUInt32(this.PakFormat.EndianType);

				uint sectionValue;

				QbItemBase qib = new QbItemUnknown(20, this);
				qib.Construct(br, QbItemType.Unknown);
				AddItem(qib);

				while (this.StreamPos(br.BaseStream) < _fileSize)
				{
					sectionValue = br.ReadUInt32(this.PakFormat.EndianType);
					QbItemType sectionType = this.PakFormat.GetQbItemType(sectionValue);

					switch (sectionType)
					{
						case QbItemType.SectionString:
						case QbItemType.SectionStringW:
							qib = new QbItemString(this);
							break;
						case QbItemType.SectionArray:
							qib = new QbItemArray(this);
							break;
						case QbItemType.SectionStruct:
							qib = new QbItemStruct(this);
							break;
						case QbItemType.SectionScript:
							qib = new QbItemScript(this);
							break;
						case QbItemType.SectionFloat:
							qib = new QbItemFloat(this);
							break;
						case QbItemType.SectionFloatsX2:
						case QbItemType.SectionFloatsX3:
							qib = new QbItemFloatsArray(this);
							break;
						case QbItemType.SectionInteger:
						case QbItemType.SectionStringPointer:
							qib = new QbItemInteger(this);
							break;
						case QbItemType.SectionQbKey:
						case QbItemType.SectionQbKeyString:
						case QbItemType.SectionQbKeyStringQs: //GH:GH
							qib = new QbItemQbKey(this);
							break;
						default:
							throw new ApplicationException(string.Format("Location 0x{0}: Unknown section type 0x{1}", (this.StreamPos(br.BaseStream) - 4).ToString("X").PadLeft(8, '0'), sectionValue.ToString("X").PadLeft(8, '0')));
					}
					qib.Construct(br, sectionType);

					AddItem(qib);
				}
			}

			uint f = this.FileId; //gettin this sets the file id
		}

		public List<QbItemBase> Items
		{
			get { return _items; }
		}

		public void AddItem(QbItemBase item)
		{
			_items.Add(item);
		}

		/// <summary>
		/// Insert a new item before or after the sibling item.
		/// </summary>
		/// <param name="item">Item to insert.</param>
		/// <param name="relatedItem">Sibling item, child of this item</param>
		/// <param name="beforeAfter">Insert before=True or after=False</param>
		public void InsertItem(QbItemBase item, QbItemBase sibling, bool beforeAfter)
		{
			for (int i = 0; i < this.Items.Count; i++)
			{
				if (this.Items[i] == sibling)
				{
					if (beforeAfter)
						this.Items.Insert(i, item);
					else
					{
						if (i + 1 < this.Items.Count)
							this.Items.Insert(i + 1, item);
						else
							this.Items.Add(item);
					}
					return;
				}
			}
		}

		/// <summary>
		/// Remove the specified item from this items children
		/// </summary>
		/// <param name="item">Item to remove</param>
		public void RemoveItem(QbItemBase item)
		{
			_items.Remove(item);
		}

		public uint Magic
		{
			get { return _magic; }
			set { _magic = value; }
		}

		public uint FileSize
		{
			get { return _fileSize; }
			set { _fileSize = value; }
		}

		public string Filename
		{
			get { return _filename; }
			set { _filename = value; }
		}

		/// <summary>
		/// The FileId is based on the filename, this will recalculate it, GH3 has a bug where the first character is missing from the path.
		/// The FileId doesn't appear to affect the game, it may just need to be unique
		/// </summary>
		public void SetNewFileId()
		{
			uint fileId = QbKey.Create(this.Filename).Crc;

			foreach (QbItemBase qbi in this.Items)
			{
				if (qbi.QbItemType != QbItemType.Unknown)
					qbi.FileId = fileId;
			}
		}

		public uint FileId
		{
			get
			{
				if (_fileId == 0)
				{
					foreach (QbItemBase qib in this.Items)
					{
						if (qib.FileId != 0)
						{
							_fileId = qib.FileId;
							break;
						}
					}
					if (_fileId == 0)
						_fileId = QbKey.Create(this.Filename).Crc; //just create one
				}

				return _fileId;
			}
		}

		public uint Length
		{
			get
			{
				uint len = (2 * 4);
				foreach (QbItemBase qib in _items)
					len += qib.Length;
				return len;
			}
		}

		public void Write(string filename)
		{
			using (FileStream fs = File.Create(filename))
			{
				Write(fs);
			}
		}

		public void Write(Stream s)
		{
			BinaryEndianWriter bw = new BinaryEndianWriter(s);
			//using (BinaryEndianWriter bw = new BinaryEndianWriter(s))
			//{
				this.startLengthCheck(bw);

				bw.Write(_magic, this.PakFormat.EndianType);
				bw.Write(_fileSize, this.PakFormat.EndianType);

				foreach (QbItemBase qib in _items)
					qib.Write(bw);


				ApplicationException ex = this.testLengthCheck(this, bw);
				if (ex != null) throw ex;
			//}

		}

		public static void SetGenericItems(QbItemBase item, List<GenericQbItem> gItems)
		{
			MemberInfo[] ms = item.GetType().FindMembers(MemberTypes.Property,
				/*BindingFlags.DeclaredOnly |*/ BindingFlags.Instance | BindingFlags.Public,
				Type.FilterName, "*");

			int i = 0;
			GenericQbItem gi;
			List<GenericQbItem> list = null;

			if (gItems.Count == 0)
			{
				//test if this is an array item
				GenericQbItem gqi = QbFile.CreateGenericArrayItem(item);

				//null if not an array type
				if (gqi != null)
				{
					//use this item to identify the array to set to 0 items
					MemberInfo m = Array.Find(ms, delegate(MemberInfo mi)
					{
						return (mi.Name == gqi.SourceProperty);
					});
					if (m != null)
					{
						Type t = ((PropertyInfo)m).GetValue(item, null).GetType();
						if (t == typeof(QbKey[]))
							((PropertyInfo)m).SetValue(item, new QbKey[0], null);
						else if (t == typeof(float[]))
							((PropertyInfo)m).SetValue(item, new float[0], null);
						else if (t == typeof(uint[]))
							((PropertyInfo)m).SetValue(item, new uint[0], null);
						else if (t == typeof(int[]))
							((PropertyInfo)m).SetValue(item, new int[0], null);
						else if (t == typeof(string[]))
							((PropertyInfo)m).SetValue(item, new string[0], null);
					}
				}
			}


			while (i < gItems.Count)
			{
				gi = gItems[i++];

				if (gi.ReadOnly)
					continue;

				//list = null;

				list = new List<GenericQbItem>();
				list.Add(gi);
				while (i < gItems.Count && gi.SourceProperty == gItems[i].SourceProperty)
					list.Add(gItems[i++]);

				MemberInfo m = Array.Find(ms, delegate(MemberInfo mi)
				{
					return (mi.Name == gi.SourceProperty);
				});

				if (m != null)
				{
					Type t = ((PropertyInfo)m).GetValue(item, null).GetType();
					if (t == typeof(QbKey[]))
					{
						QbKey[] qb = new QbKey[list.Count];
						QbKey q;
						string qS;

						for (int c = 0; c < list.Count; c++)
						{
							q = list[c].ToQbKey();
							qS = item.Root.LookupDebugName(q.Crc);
							if (qS.Length != 0)
								q = QbKey.Create(q.Crc, qS);
							qb[c] = q;
						}
						((PropertyInfo)m).SetValue(item, qb, null);
					}
					else if (t == typeof(float[]))
					{
						float[] f = new float[list.Count];
						for (int c = 0; c < list.Count; c++)
							f[c] = list[c].ToSingle();
						((PropertyInfo)m).SetValue(item, f, null);
					}
					else if (t == typeof(uint[]))
					{
						uint[] ui = new uint[list.Count];
						for (int c = 0; c < list.Count; c++)
							ui[c] = list[c].ToUInt32();
						((PropertyInfo)m).SetValue(item, ui, null);
					}
					else if (t == typeof(int[]))
					{
						int[] si = new int[list.Count];
						for (int c = 0; c < list.Count; c++)
							si[c] = list[c].ToInt32();
						((PropertyInfo)m).SetValue(item, si, null);
					}
					else if (t == typeof(string[]))
					{
						string[] s = new string[list.Count];
						for (int c = 0; c < list.Count; c++)
							s[c] = list[c].ToString();
						((PropertyInfo)m).SetValue(item, s, null);
					}
					else if (t == typeof(QbKey))
					{
						QbKey q = gi.ToQbKey();
						string qS = item.Root.LookupDebugName(q.Crc);
						if (qS.Length != 0)
							q = QbKey.Create(q.Crc, qS);
						((PropertyInfo)m).SetValue(item, q, null);
					}
					else if (t == typeof(float))
						((PropertyInfo)m).SetValue(item, gi.ToSingle(), null);
					else if (t == typeof(uint))
						((PropertyInfo)m).SetValue(item, gi.ToUInt32(), null);
					else if (t == typeof(int))
						((PropertyInfo)m).SetValue(item, gi.ToInt32(), null);
					else if (t == typeof(string))
						((PropertyInfo)m).SetValue(item, gi.ToString(), null);
					else if (t == typeof(byte[]))
						((PropertyInfo)m).SetValue(item, gi.ToByteArray(), null);
					else
					{
						throw new ApplicationException(string.Format("DataType {0} not supported.", t.Name));
					}
				}
			}
		}

		/// <summary>
		/// Analyse the attributes on the item and return the editable items
		/// </summary>
		/// <param name="item"></param>
		/// <returns></returns>
		public static List<GenericQbItem> GetGenericItems(QbItemBase item)
		{
			List<GenericQbItem> items = new List<GenericQbItem>();
			GenericQbItem itm = null;

			MemberInfo[] ms = item.GetType().FindMembers(MemberTypes.Property,
				/*BindingFlags.DeclaredOnly |*/ BindingFlags.Instance | BindingFlags.Public,
				Type.FilterName, "*");

			foreach (MemberInfo m in ms)
			{
				GenericEditableAttribute a = Attribute.GetCustomAttribute(m, typeof(GenericEditableAttribute)) as GenericEditableAttribute;
				if (a != null)
				{

					//return attribute value and pass in to generic items and return
					object o = ((PropertyInfo)m).GetValue(item, null);
					if (o == null)
						continue;
					if (o is byte[]) //hex
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (byte[])o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else if (o is string[])
					{
						foreach (string s in ((string[])o))
						{
							itm = new GenericQbItem(a.DefaultDisplayName, s, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
							items.Add(itm);
						}
					}
					else if (o is string)
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (string)o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else if (o is uint[])
					{
						foreach (uint s in ((uint[])o))
						{
							itm = new GenericQbItem(a.DefaultDisplayName, s, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
							items.Add(itm);
						}
					}
					else if (o is uint)
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (uint)o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else if (o is int[])
					{
						foreach (int s in ((int[])o))
						{
							itm = new GenericQbItem(a.DefaultDisplayName, s, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
							items.Add(itm);
						}
					}
					else if (o is int)
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (int)o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else if (o is float[])
					{
						foreach (float s in ((float[])o))
						{
							itm = new GenericQbItem(a.DefaultDisplayName, s, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
							items.Add(itm);
						}
					}
					else if (o is float)
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (float)o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else if (o is QbKey[])
					{
						foreach (QbKey s in ((QbKey[])o))
						{
							itm = new GenericQbItem(a.DefaultDisplayName, s, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
							items.Add(itm);
						}
					}
					else if (o is QbKey)
					{
						itm = new GenericQbItem(a.DefaultDisplayName, (QbKey)o, a.EditType, a.ReadOnly, a.UseQbItemType, item.QbItemType, m.Name);
						items.Add(itm);
					}
					else
						throw new ApplicationException(string.Format("Unknown generic data type item '{0}'", o.GetType().Name));
				}
			}
			return items;
		}

		private void startLengthCheck(BinaryEndianWriter bw)
		{
			_lengthCheckStart = this.StreamPos(bw.BaseStream);
		}

		private ApplicationException testLengthCheck(object sender, BinaryEndianWriter bw)
		{
			uint len = this.Length;
			if (this.StreamPos(bw.BaseStream) - _lengthCheckStart != len)
			{
				return new ApplicationException(QbFile.FormatWriteLengthExceptionMessage(sender, _lengthCheckStart, this.StreamPos(bw.BaseStream), len));
			}
			else
				return null;
		}

		public static string FormatBadPointerExceptionMessage(object sender, uint streamPos, uint pointer)
		{
			return string.Format("Location 0x{0}: {1} pointer error, current read location does not match pointer 0x{2}", streamPos.ToString("X").PadLeft(8, '0'), sender.GetType().Name, pointer.ToString("X").PadLeft(8, '0'));
		}

		public static string FormatWriteLengthExceptionMessage(object sender, uint start, uint end, uint length)
		{
			return string.Format("Location 0x{0}: Length check failed when writing {1}, written length: {2} (0x{3}), calculated length: {4} (0x{5})", start.ToString("X").PadLeft(8, '0'), sender.GetType().Name, (end - start).ToString(), (end - start).ToString("X").PadLeft(8, '0'), length.ToString(), length.ToString("X").PadLeft(8, '0'));
		}

		public static string FormatIsValidErrorMessage(QbItemBase item, IsValidReturnType errorType)
		{
			switch (errorType)
			{
				case IsValidReturnType.ItemMustHave0Items:
					return string.Format("The Selected '{0}' item is invalid, it must have 0 values", item.QbItemType.ToString());
				case IsValidReturnType.ItemMustHave1Item:
					return string.Format("The Selected item is invalid, it must have 1 value", item.QbItemType.ToString());
				case IsValidReturnType.ItemMustHave0OrMoreItems:
					return string.Format("The Selected item is invalid, it must have 0 or more values", item.QbItemType.ToString());
				case IsValidReturnType.ItemMustHave1OrMoreItems:
					return string.Format("The Selected item is invalid, it must have 1 or more values", item.QbItemType.ToString());
				case IsValidReturnType.ArrayItemsMustBeSameType:
					return string.Format("The Selected item is invalid, array items must all be the same type", item.QbItemType.ToString());
				default:
					return string.Empty;
			}
		}

		public PakFormat PakFormat
		{
			get { return _pakFormat; }
			set { _pakFormat = value; }
		}

		public static string AllowedScriptStringChars
		{
			get { return _allowedScriptStringChars; }
			set { _allowedScriptStringChars = value; }
		}

		public static bool SupportsChild(QbItemType parent, QbItemType child)
		{
			return _supportedChildItems[parent].Exists(delegate (QbItemType t)
			{
				return (t == child);
			});
		}

		public static QbItemType[] SupportedChildTypes(QbItemType parent)
		{
			return _supportedChildItems[parent].ToArray();
		}

		private PakFormat _pakFormat;

		private long _streamStartPosition;

		private static string _allowedScriptStringChars;

		private uint _lengthCheckStart;
		private uint _magic;
		private uint _fileSize;
		private string _filename; 
		private List<QbItemBase> _items;
		private uint _fileId;

		private static Dictionary<QbItemType, List<QbItemType>> _supportedChildItems;

		public static Dictionary<uint, string> DebugNames;
	}

}
