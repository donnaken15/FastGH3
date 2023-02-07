using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
    public class QbItemString : QbItemBase
    {
        public QbItemString(QbFile root) : base(root)
        {
        }

        public override void Create(QbItemType type)
        {
            if (type != QbItemType.SectionString && type != QbItemType.ArrayString && type != QbItemType.StructItemString &&
                type != QbItemType.SectionStringW && type != QbItemType.ArrayStringW && type != QbItemType.StructItemStringW)
                throw new ApplicationException(string.Format("type '{0}' is not a string item type", type.ToString()));
            
            base.Create(type);


            _isUnicode = ((type == QbItemType.SectionStringW || type == QbItemType.ArrayStringW || type == QbItemType.StructItemStringW) &&
                (base.Root.PakFormat.PakFormatType == PakFormatType.PC));

            _charWidth = !_isUnicode ? 1 : 2;

            this.Strings = new string[1]; //sets item count
            _strings[0] = "";
        }

        /// <summary>
        /// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
        /// </summary>
        /// <returns></returns>
        public override QbItemBase Clone()
        {
            QbItemString s = new QbItemString(this.Root);
            s.Create(this.QbItemType);

            if (this.ItemQbKey != null)
                s.ItemQbKey = this.ItemQbKey.Clone();

            string[] si = new string[this.Strings.Length];
            for (int i = 0; i < si.Length; i++)
                si[i] = this.Strings[i];

            s.Strings = si;
            s.ItemCount = this.ItemCount;

            return s;
        }

        public override void Construct(BinaryEndianReader br, QbItemType type)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            _isUnicode = ((type == QbItemType.SectionStringW || type == QbItemType.ArrayStringW || type == QbItemType.StructItemStringW) &&
                (base.Root.PakFormat.PakFormatType == PakFormatType.PC));

            byte[] bytes;

            base.Construct(br, type);

            this.Strings = new string[base.ItemCount];

            _charWidth = !_isUnicode ? 1 : 2;

            if (base.ItemCount != 0)
            {
                //use pointers to read quickly
                if (base.ItemCount > 1)
                {

                    for (int i = 0; i < base.ItemCount - 1; i++)
                    {
                        if (base.StreamPos(br) != base.Pointers[i]) //pointer test
                            throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, base.StreamPos(br), base.Pointers[i]));

                        bytes = br.ReadBytes((int)((base.Pointers[i + 1] - _charWidth) - base.StreamPos(br)));

                        _strings[i] = bytesToString(bytes); //handles unicode

                        if (!_isUnicode ? (br.ReadByte() != 0) : (br.ReadByte() != 0 || br.ReadByte() != 0))
                            throw new ApplicationException(string.Format("Null byte expected reading string array at 0x{0}", (base.StreamPos(br) - _charWidth).ToString("X").PadLeft(8, '0')));
                    }

                    if (base.StreamPos(br) != base.Pointers[base.ItemCount - 1]) //pointer test
                        throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, base.StreamPos(br), base.Pointers[base.ItemCount - 1]));
                }


                //use the slow method read the last string
                StringBuilder sb = new StringBuilder();
                //if we have come from an array we must align our position to %4
                int byteAmount = (int)(4 - (base.StreamPos(br) % 4));

                do
                {
                    bytes = br.ReadBytes(byteAmount);
                    sb.Append(bytesToString(bytes));
                    byteAmount = 4;
                }
                while (!_isUnicode ? (bytes[bytes.Length - 1] != '\0') : (bytes[bytes.Length - 1] != '\0' || bytes[bytes.Length - 2] != '\0'));


                //get text and remove any trailing null bytes
                _strings[base.ItemCount - 1] = sb.ToString().TrimEnd(new char[] { '\0' });
            }
            base.ConstructEnd(br);
        }

        private string bytesToString(byte[] bytes)
        {
            if (!_isUnicode)
                return Encoding.Default.GetString(bytes);
            else
            {
                if (BitConverter.IsLittleEndian && base.Root.PakFormat.EndianType != EndianType.Little)
                    bytes = Encoding.Convert(Encoding.BigEndianUnicode, Encoding.Unicode, bytes);
                else if (!BitConverter.IsLittleEndian && base.Root.PakFormat.EndianType != EndianType.Big)
                    bytes = Encoding.Convert(Encoding.Unicode, Encoding.BigEndianUnicode, bytes);

                return Encoding.Unicode.GetString(bytes);
            }
        }

        private byte[] stringToBytes(string s)
        {

            if (!_isUnicode)
                return Encoding.Default.GetBytes(s);
            else
            {
                byte[] bytes = Encoding.Unicode.GetBytes(s);
                if (BitConverter.IsLittleEndian && base.Root.PakFormat.EndianType != EndianType.Little)
                    bytes = Encoding.Convert(Encoding.Unicode, Encoding.BigEndianUnicode, bytes);
                else if (!BitConverter.IsLittleEndian && base.Root.PakFormat.EndianType != EndianType.Big)
                    bytes = Encoding.Convert(Encoding.BigEndianUnicode, Encoding.Unicode, bytes);

                return bytes;
            }
        }

        public override uint AlignPointers(uint pos)
        {
            //cater for new items being added

            base.Pointers = new uint[_strings.Length];

            uint pos2 = base.AlignPointers(pos);
            uint next = pos + this.Length;

            pos = pos2;

            if (_strings.Length == 1)
                base.Pointers[0] = base.Pointer; //point to first and only item
            else
            {
                for (int i = 0; i < _strings.Length; i++)
                {
                    base.Pointers[i] = pos;
                    pos += ((uint)_strings[i].Length * (uint)_charWidth) + (uint)_charWidth; //+ 1 = null terminated when saved
                }
            }

            return next;
        }

        protected override int CalcItemCount()
        {
            if (_strings != null)
                return _strings.Length;
            else
                return 0;
        }

        public override uint Length
        {
            get
            {
                uint len = base.Length;

                foreach (string s in _strings)
                    len += (uint)(s.Length * (uint)_charWidth) + (uint)_charWidth; //add 1 for null terminator
                if (len % 4 != 0)
                    len += 4 - (len % 4);

//                if (_strings.Length > 1)
//                    len += (4 * (uint)_strings.Length); //add 4 bytes per pointer

                return len; //we know the string started on a 4 byte boundry so this will be safe
            }
        }

        internal override void Write(BinaryEndianWriter bw)
        {
            base.StartLengthCheck(bw);

            base.Write(bw);

            foreach (string s in _strings)
            {
                bw.Write(stringToBytes(s));
                bw.Write((byte)0);
                if (_isUnicode)
                    bw.Write((byte)0);
            }

            while (base.StreamPos(bw) % 4 != 0)
                bw.Write((byte)0);

            base.WriteEnd(bw);

            ApplicationException ex = base.TestLengthCheck(this, bw);
            if (ex != null) throw ex;
        }

        [GenericEditable("Text", typeof(string), true, false)]
        public string[] Strings
        {
            get { return _strings; }
            set
            {
                _strings = value;
                base.ItemCount = (uint)_strings.Length;
            }
        }

        private string[] _strings;
        private int _charWidth;
        private bool _isUnicode;
    }
}
