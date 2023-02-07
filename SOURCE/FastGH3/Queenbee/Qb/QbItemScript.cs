using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;

namespace Nanook.QueenBee.Parser
{
    public partial class QbItemScript : QbItemBase
    {
        public QbItemScript(QbFile root) : base(root)
        {
            _strings = null;

            if (QbFile.AllowedScriptStringChars == null || QbFile.AllowedScriptStringChars.Length == 0)
                _allowedStringChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890\/?!""£$%^&*()-+{}[]'#@~?><,. =®©_=:";
            else
                _allowedStringChars = QbFile.AllowedScriptStringChars;
        }

        public override void Create(QbItemType type)
        {
            if (type != QbItemType.SectionScript)
                throw new ApplicationException(string.Format("type '{0}' is not a script item type", type.ToString()));

            base.Create(type);

            _unknown = 0;
            _scriptData = new byte[2];
            _scriptData[0] = 1;
            _scriptData[1] = 36;


        }

        /// <summary>
        /// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
        /// </summary>
        /// <returns></returns>
        public override QbItemBase Clone()
        {
            QbItemScript sc = new QbItemScript(this.Root);
            sc.Create(this.QbItemType);

            if (this.ItemQbKey != null)
                sc.ItemQbKey = this.ItemQbKey.Clone();

            byte[] bi = new byte[this.ScriptData.Length];
            for (int i = 0; i < bi.Length; i++)
                bi[i] = this.ScriptData[i];

            sc.ScriptData = bi;
            sc.ItemCount = this.ItemCount;
            sc.Unknown = this.Unknown;

            return sc;
        }

        public override void Construct(BinaryEndianReader br, QbItemType type)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            base.Construct(br, type);

            _unknown = br.ReadUInt32(base.Root.PakFormat.EndianType);
            uint decompressedSize = br.ReadUInt32(base.Root.PakFormat.EndianType);
            uint compressedSize = br.ReadUInt32(base.Root.PakFormat.EndianType);

            // Get script data
            Lzss lz = new Lzss();
            _scriptData = br.ReadBytes((int)compressedSize);
            if (compressedSize < decompressedSize)
                _scriptData = lz.Decompress(_scriptData);

            if (_scriptData.Length != decompressedSize)
                throw new ApplicationException(string.Format("Location 0x{0}: Script decompressed to {1} bytes not {2}", (base.StreamPos(br) - compressedSize).ToString("X").PadLeft(8, '0'), _scriptData.Length.ToString(), decompressedSize.ToString()));

            // Padding...
            if ((base.StreamPos(br) % 4) != 0)
                br.BaseStream.Seek(4 - (base.StreamPos(br) % 4), SeekOrigin.Current);

            base.ConstructEnd(br);
        }

        public override uint AlignPointers(uint pos)
        {
            uint next = pos + this.Length;

            pos = base.AlignPointers(pos);

            return next;
        }

        public override uint Length
        {
            get
            {
                Lzss lz = new Lzss();
                int comp = lz.Compress(_scriptData).Length;

                uint len = base.Length + (3 * 4) + (uint)(comp < _scriptData.Length ? comp : _scriptData.Length);
                if (len % 4 != 0)
                    len += 4 - (len % 4);
                return len;
            }
        }

        [GenericEditable("Script Data", typeof(float), true, false)]
        public byte[] ScriptData
        {
            get { return _scriptData; }
            set
            {
                _scriptData = value;
                _strings = null;
            }
        }

        [GenericEditable("Unknown", typeof(byte[]), false, false)]
        public uint Unknown
        {
            get { return _unknown; }
            set { _unknown = value; }
        }

        internal override void Write(BinaryEndianWriter bw)
        {
            base.StartLengthCheck(bw);

            base.Write(bw);
            bw.Write(_unknown, base.Root.PakFormat.EndianType);
            bw.Write((uint)_scriptData.Length, base.Root.PakFormat.EndianType);

            byte[] compScript;
            Lzss lz = new Lzss();
            compScript = lz.Compress(_scriptData);

            if (compScript.Length >= _scriptData.Length)
                compScript = _scriptData;

            bw.Write((uint)compScript.Length, base.Root.PakFormat.EndianType);
            bw.Write(compScript);

            if (compScript.Length % 4 != 0)
            {
                for (int i = 0; i < 4 - (compScript.Length % 4); i++)
                    bw.Write((byte)0);
            }

            base.WriteEnd(bw);

            ApplicationException ex = base.TestLengthCheck(this, bw);
            if (ex != null) throw ex;
        }

        public List<ScriptString> Strings
        {
            get
            {
                if (_strings == null)
                {
                    _strings = new List<ScriptString>();
                    parseScriptStrings();
                }

                return _strings;
            }
        }

        public void UpdateStrings()
        {
            byte[] b;
            foreach (ScriptString ss in _strings)
            {
                ss.Text = ss.Text.PadRight(ss.Length, ' ').Substring(0, ss.Length);
                b = stringToBytes(ss.Text, ss.IsUnicode);

                b.CopyTo(_scriptData, ss.Pos);
            }

            _strings = null;
        }


        private void parseScriptStrings()
        {

            int s = -1; //start of string, -1 == not in string
            char c; //current character
            bool u = false; //unicode
            bool au; //allow unicode
            bool ub = true; //unicode is bigendian

            bool end = false;

            au = (this.Root.PakFormat.PakFormatType == PakFormatType.PC);

            if (au)
                ub = (this.Root.PakFormat.EndianType == EndianType.Big);


            for (int i = 0; i < _scriptData.Length; i++)
            {

                c = (char)_scriptData[i];

                //have we found a null, is the char +2 also a null
                if (au && ub && s == -1 && c == '\0' && i + 2 < _scriptData.Length && (char)_scriptData[i + 2] == '\0')
                {
                    s = i;
                    u = true;
                    i++;
                    c = (char)_scriptData[i];
                }

                if (s != -1) //in a string
                {
                    if (!(_allowedStringChars.IndexOf(c) >= 0))
                        end = true;

                }
                else if (_allowedStringChars.IndexOf(c) >= 0)
                {
                    s = i;
                    //found first char, little endian unicode
                    if (au && !ub && i + 2 < _scriptData.Length && (char)_scriptData[i + 1] == '\0')
                        u = true;
                }

                if (u && !end)
                {
                    //we are in unicode mode, is the next char should be 0 (we don't cater for real unicode
                    if (!(u && i + 1 < _scriptData.Length && (char)_scriptData[i + 1] == '\0'))
                        end = true;
                    else
                        i++; //skip null
                }

                if (end || (s != -1 && i == _scriptData.Length - 1))
                {
                    if ((!u && i - s > 4) || (u && i - s > 8))
                    {
                        if (u && (i - s) % 2 != 0)
                            i--;

                        //if this is the last item then add 1 to include the last char (unless it's a $)
                        if (i == _scriptData.Length - 1 && c != '$')
                            i++;

                        addString(s, i, u);
                    }
                    u = false;
                    s = -1;
                    end = false;
                }
            }
        }

        private void addString(int start, int end, bool isUnicode)
        {
            //determine if it's valid and sort out unicode, add if valid

            byte[] b = new byte[end - start];
            Array.Copy(_scriptData, start, b, 0, end - start);

            string s = bytesToString(b, isUnicode);
            _strings.Add(new ScriptString(s, start, s.Length, isUnicode));
        }


        private string bytesToString(byte[] bytes, bool isUnicode)
        {
            if (!isUnicode)
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

        private byte[] stringToBytes(string s, bool isUnicode)
        {

            if (!isUnicode)
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

        private byte[] _scriptData;
        private uint _unknown;

        private string _allowedStringChars;

        private List<ScriptString> _strings;

    }
}
