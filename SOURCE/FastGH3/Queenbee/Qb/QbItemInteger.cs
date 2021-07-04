using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
    public class QbItemInteger : QbItemBase
    {
        public QbItemInteger(QbFile root) : base(root)
        {
        }

        public void Create(QbItemType type, int length)
        {
            if (type != QbItemType.SectionInteger && type != QbItemType.SectionStringPointer &&
                type != QbItemType.ArrayInteger && type != QbItemType.ArrayStringPointer &&
                type != QbItemType.StructItemInteger && type != QbItemType.StructItemStringPointer)
                throw new ApplicationException(string.Format("type '{0}' is not an integer item type", type.ToString()));

            base.Create(type);

            Values = new int[length]; //sets item count
            _values[0] = 0;
        }
        
        public override QbItemBase Clone()
        {
            QbItemInteger qi = new QbItemInteger(this.Root);
            qi.Create(this.QbItemType);

            if (this.ItemQbKey != null)
                qi.ItemQbKey = this.ItemQbKey.Clone();

            int[] ii = new int[this.Values.Length];
            for (int i = 0; i < ii.Length; i++)
                ii[i] = Values[i];

            qi.Values = ii;
            qi.ItemCount = this.ItemCount;

            return qi;
        }

        public override void Construct(BinaryEndianReader br, QbItemType type)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            base.Construct(br, type);

            this.Values = new int[base.ItemCount];

            for (int i = 0; i < base.ItemCount; i++)
                _values[i] = br.ReadInt32(base.Root.PakFormat.EndianType);

            base.ConstructEnd(br);
        }

        public override uint AlignPointers(uint pos)
        {
            base.AlignPointers(pos);

            uint next = pos + this.Length;

            return next;
        }

        protected override int CalcItemCount()
        {
            if (_values != null)
                return _values.Length;
            else
                return 0;
        }

        public override uint Length
        {
            get
            {
                return base.Length + ((uint)(_values.Length) * 4);
            }
        }

        [GenericEditable("Number", typeof(int), true, false)]
        public int[] Values
        {
            get { return _values; }
            set
            {
                _values = value;
                base.ItemCount = (uint)_values.Length;
            }
        }

        internal override void Write(BinaryEndianWriter bw)
        {
            base.StartLengthCheck(bw);

            base.Write(bw);

            foreach (uint i in _values)
                bw.Write(i, base.Root.PakFormat.EndianType);

            base.WriteEnd(bw);

            ApplicationException ex = base.TestLengthCheck(this, bw);
            if (ex != null) throw ex;
        }

        private int[] _values;
    }
}
