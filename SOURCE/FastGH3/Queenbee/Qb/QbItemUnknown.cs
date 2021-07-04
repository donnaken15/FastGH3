using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    public class QbItemUnknown : QbItemBase
    {
        public QbItemUnknown(byte[] unknownData, uint position, QbFile root) : base(root)
        {
            _unknownData = unknownData;
            base.Position = position;
        }

        /// <summary>
        /// defaults the data to the only value that's been seen
        /// </summary>
        /// <param name="root"></param>
        public QbItemUnknown(QbFile root) : base(root)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            _length = 128;
        }

        public QbItemUnknown(int length, QbFile root) : base(root)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            _length = length;
        }

        /// <summary>
        /// Pass null for br if the data was passed as a byte array in the constructor
        /// </summary>
        /// <param name="br"></param>
        /// <param name="type"></param>
        public override void Construct(BinaryEndianReader br, QbItemType type)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x????????", this.GetType().ToString()));
            if (br != null)
            {
                base.Construct(br, type);

                //base.Position = (uint)base.StreamPos(br);
                _unknownData = br.ReadBytes(_length);

                base.ConstructEnd(br);
            }

        }

        /// <summary>
        /// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
        /// </summary>
        /// <returns></returns>
        public override QbItemBase Clone()
        {
            QbItemUnknown u = new QbItemUnknown((int)this.Length, this.Root);
            u.Create(this.QbItemType);

            if (this.ItemQbKey != null)
                u.ItemQbKey = this.ItemQbKey.Clone();

            byte[] bi = new byte[this.UnknownData.Length];
            for (int i = 0; i < bi.Length; i++)
                bi[i] = this.UnknownData[i];

            u.ItemCount = this.ItemCount;

            return u;
        }

        public override uint AlignPointers(uint pos)
        {
            uint next = pos + this.Length;
            //yey no pointers
            return next;
        }

        public override uint Length
        {
            get
            {
                return (uint)_unknownData.Length;
            }
        }

        [GenericEditable("Unknown", typeof(byte[]), true, true)]
        public byte[] UnknownData
        {
            get { return _unknownData; }
            set { _unknownData = value; }
        }

        internal override void Write(BinaryEndianWriter bw)
        {
            base.StartLengthCheck(bw);

            bw.Write(_unknownData);

            base.WriteEnd(bw);

            ApplicationException ex = base.TestLengthCheck(this, bw);
            if (ex != null) throw ex;
        }

        private byte[] _unknownData;
        private int _length;
    }
}
