using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Nanook.QueenBee.Parser
{
	public class GenericQbItem
	{
		static GenericQbItem()
		{
			_supportedTypes = new Dictionary<Type, string>();
			_supportedTypes.Add(typeof(float), "Float");
			_supportedTypes.Add(typeof(int), "Int");
			_supportedTypes.Add(typeof(uint), "UInt");
			_supportedTypes.Add(typeof(string), "String");
			_supportedTypes.Add(typeof(byte[]), "Hex");
			_supportedTypes.Add(typeof(QbKey), "QBKey");

		}

		private GenericQbItem(string name, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
		{
			_name = name;
			_readOnly = readOnly;
			_useQbItemType = useQbItemType;
			_qbType = qbType;
			_sourceProperty = sourceProperty;
			_typeNumeric = false;
			_currType = null;
		}

		public GenericQbItem(string name, QbKey value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			_value = value.ToString();
			_type = value.GetType();

			_typeNumeric = true;
			_qbKey = value;
			this.ConvertTo(editType);
		}

		public GenericQbItem(string name, float value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			_typeNumeric = true;
			_value = value.ToString();
			_type = value.GetType();
			this.ConvertTo(editType);
		}

		public GenericQbItem(string name, int value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			_typeNumeric = true;
			_value = value.ToString();
			_type = value.GetType();
			this.ConvertTo(editType);
		}

		public GenericQbItem(string name, uint value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			_typeNumeric = true;
			_value = value.ToString();
			_type = value.GetType();
			this.ConvertTo(editType);
		}

		public GenericQbItem(string name, byte[] value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			StringBuilder sb = new StringBuilder();
			foreach (byte b in value)
				sb.Append(b.ToString("X").PadLeft(2, '0'));

			_value = sb.ToString();
			_type = value.GetType();
			this.ConvertTo(editType);
		}

		public GenericQbItem(string name, string value, Type editType, bool readOnly, bool useQbItemType, QbItemType qbType, string sourceProperty)
			: this(name, editType, readOnly, useQbItemType, qbType, sourceProperty)
		{
			_value = value;
			_type = value.GetType();
			this.ConvertTo(editType);
		}

		public string Name
		{
			get { return _name; }
			//set { _name = value; }
		}

		public string Value
		{
			get { return _value; } 
			set { _value = value; } 
		}

		public string SourceProperty
		{
			get { return _sourceProperty; }
			//set { _sourceProperty = value; }
		}

		public Type Type
		{
			get { return _type; }
			//set { _type = value; }
		}

		public Type EditType
		{
			get { return _currType; }
			//set { _currType = value; }
		}

		public bool ReadOnly
		{
			get { return _readOnly; }
			//set { _readOnly = value; }
		}

		public bool TypeIsNumeric
		{
			get { return _typeNumeric; }
		}

		public QbItemType QbType
		{
			get { return _qbType; }
			//set { _qbType = value; }
		}

		public bool UseQbItemType
		{
			get { return _useQbItemType; }
			//set { _useQbItemType = value; }
		}

		////public string ConvertType()
		////{
		////    return convert(_value, 
		////}

		private byte[] convert(string text, Type toType)
		{
			byte[] b = null;
			float f;
			uint u;
			int i;
			text = convert(toType);

			//get the data into a byte array
			if (toType == typeof(float))
			{
				if (float.TryParse(text, out f))
					return BitConverter.GetBytes(f);
			}
			else if (toType == typeof(uint))
			{
				if (uint.TryParse(text, out u))
					return BitConverter.GetBytes(u);
			}
			else if (toType == typeof(int))
			{
				if (int.TryParse(text, out i))
					return BitConverter.GetBytes(i);
			}
			else if (toType == typeof(byte[]))
			{
				if (text.Length > 2)
				{
					b = new byte[text.Length / 2];
					for (int c = 0; c < text.Length; c += 2)
						b[c / 2] = byte.Parse(text.Substring(c, 2), System.Globalization.NumberStyles.HexNumber);
					return b;
				}
			}
			else if (toType == typeof(string))
			{
				return Encoding.Default.GetBytes(text);
			}
			else if (toType == typeof(QbKey))
			{
				return Encoding.Default.GetBytes(text);
			}


			//else
			//    throw new ArgumentOutOfRangeException(string.Format("{0} is not supported", fromType.FullName));

			return null;
		}

		private string getToError(Type orig, Type to)
		{
			return string.Format("Type '{0}' does not match '{1}' that used to construct this EditItem.", to.Name, orig.Name);
		}

		public bool CanConvertTo(Type toType)
		{
			if (toType == typeof(float))
				return _type != typeof(QbKey) && _typeNumeric && (_currType == typeof(int) || _currType == typeof(uint) || _currType == typeof(byte[]));
			else if (toType == typeof(int))
				return _type != typeof(QbKey) && _typeNumeric && (_currType == typeof(float) || _currType == typeof(uint) || _currType == typeof(byte[]));
			else if (toType == typeof(uint))
				return _type != typeof(QbKey) && _typeNumeric && (_currType == typeof(int) || _currType == typeof(float) || _currType == typeof(byte[]));
			else if (toType == typeof(byte[]))
				return (_type == typeof(QbKey) && _currType != typeof(byte[])) || (_currType != typeof(byte[]));
			else if (toType == typeof(string))
				return (_type == typeof(QbKey) && _currType == typeof(byte[])) || (!_typeNumeric && (_currType == typeof(byte[])));
			else
				return false;
		}

		public string ConvertTo(Type toType)
		{
			_value = convert(toType);
			_currType = toType;
			return _value;
		}


		/// <summary>
		/// Convert text representations
		/// </summary>
		/// <param name="text"></param>
		/// <param name="toType">Type to convert to</param>
		/// <returns></returns>
		private string convert(Type toType)
		{
			byte[] b = null;
			float f;
			uint u;
			int i;
			string result = _value;

			if (_currType == null)
				_currType = _type;

			if (_currType == toType)
				return _value;

			if (!this.CanConvertTo(toType))
				return _value;

			//if QBKey then swap between Hex and String
			if (_type == typeof(QbKey))
			{
				QbKey qb = QbKey.Create(_value);
				if (_currType == typeof(byte[]) && toType == typeof(string))
				{
					if (_qbKey == qb)
						return _qbKey.ToString();
					else
						return qb.ToString();
				}
				else if (_currType == typeof(string) && toType == typeof(byte[]))
				{
					if (_value.Trim().Length != 0)
						_qbKey = QbKey.Create(_value);
					return _qbKey.Crc.ToString("X").PadLeft(8, '0');
				}
				else
					return _value;
			}


			//get the data into a byte array
			if (_currType == typeof(float))
			{
				if (float.TryParse(_value, out f))
					b = BitConverter.GetBytes(f);
			}
			else if (_currType == typeof(uint))
			{
				if (uint.TryParse(_value, out u))
					b = BitConverter.GetBytes(u);
			}
			else if (_currType == typeof(int))
			{
				if (int.TryParse(_value, out i))
					b = BitConverter.GetBytes(i);
			}
			else if (_currType == typeof(byte[]))
			{
				if (_value.Length > 2)
				{
					b = new byte[_value.Length / 2];
					for (int c = 0; c < _value.Length; c += 2)
						b[c / 2] = byte.Parse(_value.Substring(c, 2), System.Globalization.NumberStyles.HexNumber);
					if (_typeNumeric && BitConverter.IsLittleEndian)
						Array.Reverse(b);
				}
			}
			else if (_currType == typeof(string))
			{
				b = Encoding.Default.GetBytes(_value);
			}


			//else
			//    throw new ArgumentOutOfRangeException(string.Format("{0} is not supported", _currType.FullName));

			if (b != null)
			{
				//convert the data to the new type
				if (toType == typeof(float))
				{
					f = BitConverter.ToSingle(b, 0);
					result = f.ToString();
				}
				else if (toType == typeof(uint))
				{
					u = BitConverter.ToUInt32(b, 0);
					result = u.ToString();
				}
				else if (toType == typeof(int))
				{
					i = BitConverter.ToInt32(b, 0);
					result = i.ToString();
				}
				else if (toType == typeof(byte[]))
				{
					StringBuilder sb = new StringBuilder();
					if (_typeNumeric && BitConverter.IsLittleEndian)
						Array.Reverse(b);
					foreach (byte x in b)
						sb.Append(x.ToString("X").PadLeft(2, '0'));
					result = sb.ToString();
				}
				else if (toType == typeof(string))
				{
					result = Encoding.Default.GetString(b);
				}

				//else
				//    throw new ArgumentOutOfRangeException(string.Format("{0} is not supported", toType.FullName));
			}
			return result;
		}

		public Type CurrentEditType
		{
			get { return _currType; }
		}

		public float ToSingle()
		{
			Type t = typeof(float);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return BitConverter.ToSingle(convert(_value, t), 0);
		}

		public int ToInt32()
		{
			Type t = typeof(int);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return BitConverter.ToInt32(convert(_value, t), 0);
		}

		public uint ToUInt32()
		{
			Type t = typeof(uint);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return BitConverter.ToUInt32(convert(_value, t), 0);
		}

		public override string ToString()
		{
			Type t = typeof(string);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return Encoding.Default.GetString(convert(_value, t));
		}

		public byte[] ToByteArray()
		{
			Type t = typeof(byte[]);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return convert(_value, t);
		}

		public QbKey ToQbKey()
		{
			Type t = typeof(QbKey);
			if (t != _type)
				throw new ApplicationException(getToError(_type, t));
			return QbKey.Create(_value);
		}
		
		public static string GetTypeName(Type t)
		{
			return _supportedTypes[t];
		}

		public static bool IsTypeSupported(Type t)
		{
			return _supportedTypes.ContainsKey(t);
		}

		public static string ValidateText(Type t, Type editType, string text)
		{
			float f;
			uint u;
			int i;
			if (editType == typeof(string) && t == typeof(QbKey))
			{
				if (!Regex.IsMatch(text, @"^[.a-zA-Z0-9_ /\\]{1,}$"))
					return "Invalid QBKey string, use characters a to z, 0 to 9 and _ (accepted but not recommended are A to Z, space, ., /, \\)";
			}
			else if (editType == typeof(float))
			{
				if (!float.TryParse(text, out f))
					return "Invalid float, a valid example is 0.1234";
			}
			else if (editType == typeof(uint))
			{
				if (!uint.TryParse(text, out u))
					return "Invalid uint, a valid example is 1234";
			}
			else if (editType == typeof(int))
			{
				if (!int.TryParse(text, out i))
					return "Invalid int, a valid example is 1234 or -1234";
			}
			else if (editType == typeof(byte[]))
			{
				if (!Regex.IsMatch(text, "^([A-F0-9]{2})+$"))
					return "Invalid hex, must be an even amount of characters, a valid example is 1A4F98AF";
			}
			//else if (editType == typeof(string))

			return string.Empty;
		}

		private string _name;
		private string _value;
		private Type _type;
		private Type _currType;
		private bool _readOnly;
		private bool _useQbItemType;
		private QbItemType _qbType;
		private string _sourceProperty;

		private bool _typeNumeric; //true if int, uint, float
		private QbKey _qbKey; //special case to remember the text

		private static Dictionary<Type, string> _supportedTypes;
	}
}
