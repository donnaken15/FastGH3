using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
//using System.Runtime.InteropServices;   

namespace Nanook.QueenBee.Parser
{
	public class QbKey
	{
		///<summary>   
		/// initCRC32 --> Make the CRC table    
		///</summary>   
		static QbKey()
		{
			uint crc, poly;
			int i, j;
			poly = ((uint)0xEDB88320L);
			for (i = 0; i < 256; (i)++)
			{
				crc = ((uint)i);
				for (j = 8; j > 0; (j)--)
				{
					if ((crc & 1) == 1)
						crc = crc >> 1 ^ poly;
					else
						crc >>= 1;
				}
				crc_tab[i] = crc;
			}
		}

		private QbKey(uint crc)
		{
			_crc = crc;
			_text = string.Empty;
		}

		private QbKey(uint crc, string text)
		{
			_crc = crc;
			_text = text;
			try
			{
				moddiag.DebugNames.Add(crc, text);
			}
			catch { }
		}

		public static string FormatText(string text)
		{
			return text.Replace('/', '\\').ToLower();
		}

		public QbKey Clone()
		{
			if (this.HasText)
				return QbKey.Create(this.Text);
			else
				return QbKey.Create(this.Crc);
		}

		///<summary>   
		/// Create a QbKey from a string, the string can be an ascii CRC
		///</summary>   
		public static QbKey Create(string text)
		{
			string str = FormatText(text);

			if (str == null)
				//throw new ArgumentNullException("text"); no one cares
				// treat like a blank string
				return new QbKey(0xFFFFFFFF);

			if (Regex.IsMatch(str, "^[0-9a-fA-F]{8}$"))
				return new QbKey(uint.Parse(str, System.Globalization.NumberStyles.HexNumber));

			//makeQBKey() -- make a QBKey (CRC32 ^ 0xFFFFFFFF (or CRC without final XOR) of a string)
			uint crc;
			int i;
			int length;
			length = str.Length;
			crc = ((uint)0xFFFFFFFF);
			for (i = 0; i < length; (i)++)
				crc = crc >> 8 & 0x00FFFFFF ^ crc_tab[(crc ^ str[i]) & 0xFF];
			return new QbKey(crc, text);
		}


		/// <summary>
		/// Create a QbKey that does not have known text
		/// </summary>
		/// <param name="crc">QBKey crc</param>
		/// <returns></returns>
		public static QbKey Create(uint crc)
		{
			return new QbKey(crc);
		}

		/// <summary>
		/// Create a QbKey that has an already known CRC and Text
		/// </summary>
		/// <param name="crc">QBKey crc</param>
		/// <param name="text">Text from debug file etc</param>
		/// <returns></returns>
		public static QbKey Create(uint crc, string text)
		{
			QbKey qb = Create(text);
			if (crc != qb.Crc)
				throw new ArgumentException(string.Format("The Crc 0x{0} does not match the Text '{1}'", crc.ToString("X").PadLeft(8, '0'), text));

			return qb;
		}


		public uint Crc
		{
			get { return _crc; }
		}

		public string Text
		{
			get { return _text; }
		}

		public override int GetHashCode()
		{
			return base.GetHashCode() & (int)this._crc; //Hmm
		}

		public bool HasText
		{
			get { return _text.Length != 0; }
		}

		public override string ToString()
		{
			if (HasText)
				return _text;
			if (moddiag.DebugNames.ContainsKey(_crc))
				return moddiag.DebugNames[_crc];
			return _crc.ToString("X").PadLeft(8, '0');
		}

		public override bool Equals(object obj)
		{
			if (obj is QbKey)
				return this.Crc == ((QbKey)obj).Crc;
			else if (obj is uint)
				return this.Crc == (uint)obj;
			return false;
		}

		public static bool operator ==(QbKey qb1, uint qb2)
		{
			return (!object.Equals(qb1, null) && qb1.Crc == qb2);
		}

		public static bool operator !=(QbKey qb1, uint qb2)
		{
			return (!(qb1 == qb2));
		}

		public static bool operator ==(uint qb1, QbKey qb2)
		{
			return (qb2 == qb1);
		}

		public static bool operator !=(uint qb1, QbKey qb2)
		{
			return (!(qb2 == qb1));
		}

		public static bool operator ==(QbKey qb1, QbKey qb2)
		{
			bool isNull1 = object.Equals(qb1, null);
			bool isNull2 = object.Equals(qb2, null);

			return ((isNull1 && isNull2) || (!isNull1 && !isNull2 && qb1.Crc == qb2.Crc));
		}

		public static bool operator !=(QbKey qb1, QbKey qb2)
		{
			return (!(qb1 == qb2));
		} 

		private uint _crc;
		private string _text;

		///<summary>   
		/// crc_tab[] -- Array with the CRC table    
		///</summary>   
		private static uint[] crc_tab = new uint[256];
	}   
}
