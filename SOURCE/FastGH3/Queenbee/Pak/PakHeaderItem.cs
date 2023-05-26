using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
	public class PakHeaderItem
	{
		public PakHeaderItem()
		{
			_pakItemType = PakItemType.Other;
		}

		static PakHeaderItem()
		{                             // qb,     qb,    debug,   image,  midi
			string[] s = new string[] { ".qb",  ".sqb", ".dbg",  ".img",  ".mqb", ".tex", ".skin", ".cam", ".col",  ".fam",  ".fnc",   ".fnt", ".fnv", ".gap",
										".hkc", ".imv", ".last", ".mcol", ".mdl", ".mdv", ".nav",  ".nqb", ".oba",  ".pfx",  ".pimg",  ".png", ".rag", ".rnb",
										".rnb_lvl", ".rnb_mdl",  ".scn",  ".scv", ".shd", ".ska",  ".ske", ".skiv", ".stex", ".table", ".tvx", ".wav", ".empty",
										 ".clt", ".jam",".note", ".nqb",  ".perf",".pimv",".qs",   ".qs.br" ,".qs.de",".qs.en",".qs.es",".qs.fr",".qs.it",
										 ".raw" ,".rgn",".trkobj",".xml"};

			_itemTypes = new QbKey[s.Length];
			for (int i = 0; i < s.Length; i++)
				_itemTypes[i] = QbKey.Create(s[i]);
		}

		/// <summary>
		/// Converts the enum to the qbkey
		/// </summary>
		/// <param name="itemType"></param>
		/// <returns>Null if type is not in the enum or is Other.</returns>
		public static QbKey PakItemTypeToFileType(PakItemType itemType)
		{
			switch (itemType)
			{
				case PakItemType.Qb:
					return _itemTypes[0];
				case PakItemType.Sqb:
					return _itemTypes[1];
				case PakItemType.Debug:
					return _itemTypes[2];
				case PakItemType.Image:
					return _itemTypes[3];
				case PakItemType.Midi:
					return _itemTypes[4];
				case PakItemType.Texture:
					return _itemTypes[5];
				case PakItemType.Skin:
					return _itemTypes[6];
				default:
					return null;
			}
		}

		/// <summary>
		/// Converts the qbkey to the enum
		/// </summary>
		/// <param name="fileType"></param>
		/// <returns>The enum item or Other if not in enum</returns>
		public static PakItemType FileTypeToPakItemType(QbKey fileType)
		{
			if (fileType == _itemTypes[0].Crc) //.qb
				return PakItemType.Qb;
			else if (fileType == _itemTypes[1].Crc) //.sqb
				return PakItemType.Sqb;
			else if (fileType == _itemTypes[2].Crc) //.dbg
				return PakItemType.Debug;
			else if (fileType == _itemTypes[3].Crc) //.img
				return PakItemType.Image;
			else if (fileType == _itemTypes[4].Crc) //.mqb
				return PakItemType.Midi;
			else if (fileType == _itemTypes[5].Crc) //.tex
				return PakItemType.Texture;
			else if (fileType == _itemTypes[6].Crc) //.skin
				return PakItemType.Skin;
			else
				return PakItemType.Other;

		}

		/// <summary>
		/// Attempts to take a qbkey key without any text and lookup a named file type
		/// </summary>
		/// <returns></returns>
		public static QbKey LookupFileType(QbKey fileType)
		{
			foreach (QbKey k in _itemTypes)
			{
				if (fileType.Crc == k.Crc)
					return k;
			}
			return fileType;
		}


		public static int FileNameMaxLength
		{
			get { return 0xA0; }
		}

		public static int FullHeaderLength
		{
			get { return 0xC0; }
		}

		/// <summary>
		/// Location that this header starts (Not saved in file)
		/// </summary>
		public uint HeaderStart
		{
			get { return _headerStart; }
			internal set { _headerStart = value; }
		}

		/// <summary>
		/// Affects the Checksums and filename (Not saved in file)
		/// </summary>
		public bool IsStoredInPak
		{
			get { return _isStoredInPak; }
			set
			{
				_isStoredInPak = value;

				if (_isStoredInPak)
				{
					_fullFilenameQbKey = 0;
				}
				else
				{
					_pakFullFileNameQbKey = 0;
					_filename = "";
				}
			}
		}

		/// <summary>
		/// 0x00	DWORD	file type (e.g. ".qb", "LAST", etc)
		/// </summary>
		public QbKey FileType
		{
			get { return _fileType; }
			set
			{
				_fileType = LookupFileType(value);
				_pakItemType = FileTypeToPakItemType(_fileType);
			}
		}

		/// <summary>
		/// 0x04	DWORD	file offset from start of this header
		/// </summary>
		public uint FileOffset
		{
			get { return _fileOffset; }
			set { _fileOffset = value; }
		}

		/// <summary>
		/// 0x08	DWORD	file length in bytes
		/// </summary>
		public uint FileLength
		{
			get { return _fileLength; }
			set { _fileLength = value; }
		}

		/// <summary>
		/// 0x0C	DWORD	CRC32 of file name + path stored in pak (0 if not stored), including missing characters at start (ie: if the pak has "cripts\blah" then the CRC will include the leading "s" of "scripts").
		/// </summary>
		public uint PakFullFileNameQbKey
		{
			get { return _pakFullFileNameQbKey; }
			internal set { _pakFullFileNameQbKey = value; }
		}

		/// <summary>
		/// 0x10	DWORD	CRC32 of full filename from dbg file (0 if name stored in pak)
		/// </summary>
		public uint FullFilenameQbKey
		{
			get { return _fullFilenameQbKey; }
			internal set { _fullFilenameQbKey = value; }
		}

		/// <summary>
		/// 0x14	DWORD	CRC32 of truncated filename (no path, no extension)
		/// </summary>
		public uint NameOnlyCrc
		{
			get { return _nameOnlyCrc; }
			internal set { _nameOnlyCrc = value; }
		}

		/// <summary>
		/// 0x18	DWORD	unknown (always zero?)
		/// </summary>
		public uint Unknown
		{
			get { return _unknown; }
			set { _unknown = value; }
		}

		/// <summary>
		/// 0x1C	DWORD	flags (00000020 = filename in pak, I've also seen 00000022)
		/// </summary>
		public PakHeaderFlags Flags
		{
			get { return _flags; }
			set { _flags = value; }
		}

		/// <summary>
		/// 0x20	0xA0	(optional) zero padded path and filename string, sometimes missing first letter	of filename.
		/// </summary>
		public string Filename
		{
			get { return _filename; }
			internal set { _filename = value; }
		}
		
		/// <summary>
		/// Pads the filename with zeros to the length required by the file format
		/// </summary>
		public string PaddedFullFileName
		{
			get { return _filename.PadRight(PakHeaderItem.FileNameMaxLength, '\0'); }
		}

		/// <summary>
		/// Pads the filename with zeros to the length required by the file format
		/// </summary>
		public string PaddedFileName
		{
			get { return _filename.PadRight(PakHeaderItem.FileNameMaxLength, '\0'); }
		}

		/// <summary>
		/// Links this PAK header to the debug header when there are no filesnames in the PAK
		/// </summary>
		public uint DebugQbKey
		{
			get { return _debugQbkey; }
			set { _debugQbkey = value; }
		}

		public PakItemType PakFileType
		{
			get { return _pakItemType; }
			set
			{
				_pakItemType = value;
				_fileType = PakItemTypeToFileType(_pakItemType);
			}
		}


		/// <summary>
		/// Rename the filename and set the data types
		/// </summary>
		/// <param name="newFullQbFilename">Full QB filename</param>
		/// <param name="fileType">.qb or .sqb=QB, .mqb=mid, .img=img .dbg=dbg  etc</param>
		/// <param name="extension">.ngc for Wii for example</param>
		/// <param name="baseOn">base the qbKeys that are present on the passed item</param>
		public void SetFilename(string newFullQbFilename, QbKey itemType, string extension, PakHeaderItem baseOn)
		{
			if (newFullQbFilename.Length > PakHeaderItem.FileNameMaxLength)
				throw new ApplicationException("newQbFilename is too long");

			if (!itemType.HasText || itemType.Text.Length == 0)
				throw new ApplicationException("fileType is not recognised");

			//filename is stored in the header
			if ((this.Flags & PakHeaderFlags.Filename) == PakHeaderFlags.Filename)
			{
				this.Filename = newFullQbFilename;
				this.FullFilenameQbKey = 0;
			}
			else
			{
				this.Filename = QbKey.Create(newFullQbFilename).Crc.ToString("X").PadLeft(8, '0').ToLower();

				if (baseOn == null || baseOn.FullFilenameQbKey != 0)
					this.FullFilenameQbKey = QbKey.Create(newFullQbFilename).Crc;
				else
					this.FullFilenameQbKey = 0;
			}

			string[] pts = newFullQbFilename.Split('.');

			string nameOnly = pts[0];

			if (baseOn == null || baseOn.FullFilenameQbKey != 0)
				this.NameOnlyCrc = QbKey.Create(nameOnly).Crc;
			else
				this.NameOnlyCrc = 0;


			this.FileType = itemType;

			if (baseOn == null || baseOn.PakFullFileNameQbKey != 0)
				this.PakFullFileNameQbKey = QbKey.Create(newFullQbFilename).Crc;
			else
				this.PakFullFileNameQbKey = 0;

		}

		private static QbKey[] _itemTypes;

		private PakItemType _pakItemType;

		private uint _debugQbkey;
		private uint _headerStart;
		private bool _isStoredInPak;
		private QbKey _fileType;
		private uint _fileOffset;
		private uint _fileLength;
		private uint _pakFullFileNameQbKey;
		private uint _fullFilenameQbKey;
		private uint _nameOnlyCrc;
		private uint _unknown;
		private PakHeaderFlags _flags;
		private string _filename;
	}

}
