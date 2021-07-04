using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
    public class QbItemFloatsArray : QbItemBase
    {
        public QbItemFloatsArray(QbFile root) : base(root)
        {
        }

        public override void Create(QbItemType type)
        {
            if (type != QbItemType.SectionFloatsX2 && type != QbItemType.SectionFloatsX3 &&
                type != QbItemType.ArrayFloatsX2 && type != QbItemType.ArrayFloatsX3 &&
                type != QbItemType.StructItemFloatsX2 && type != QbItemType.StructItemFloatsX3)
                throw new ApplicationException(string.Format("type '{0}' is not a floats array item type", type.ToString()));

            base.Create(type);

        }

        /// <summary>
        /// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
        /// </summary>
        /// <returns></returns>
        public override QbItemBase Clone()
        {
            QbItemFloatsArray a = new QbItemFloatsArray(this.Root);
            a.Create(this.QbItemType);

            if (this.ItemQbKey != null)
                a.ItemQbKey = this.ItemQbKey.Clone();

            foreach (QbItemBase qib in this.Items)
                a.Items.Add(qib.Clone());

            a.ItemCount = this.ItemCount;

            return a;
        }


        public override void Construct(BinaryEndianReader br, QbItemType type)
        {
            //System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

            base.Construct(br, type);

            QbItemBase qib;
            QbItemType floatsType;
            uint floatsValue;
            bool is3d;
            for (int i = 0; i < base.ItemCount; i++)
            {
                if (base.StreamPos(br) != base.Pointers[i]) //pointer test
                    throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, base.StreamPos(br), base.Pointers[i]));

                floatsValue = br.ReadUInt32(this.Root.PakFormat.EndianType);
                floatsType = this.Root.PakFormat.GetQbItemType(floatsValue);
                
                is3d = (type == QbItemType.SectionFloatsX3 || type == QbItemType.StructItemFloatsX3 || type == QbItemType.ArrayFloatsX3);

                switch (floatsType)
                {
                    case QbItemType.Floats:
                        qib = new QbItemFloats(this.Root, is3d);
                        break;
                    default:
                        throw new ApplicationException(string.Format("Location 0x{0}: Not a float type 0x{1}", (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0'), floatsValue.ToString("X").PadLeft(8, '0')));
                }
                qib.Construct(br, floatsType);
                AddItem(qib);

                base.ConstructEnd(br);
            }
        }

        public override uint AlignPointers(uint pos)
        {
            uint next = pos + this.Length;

            pos = base.AlignPointers(pos);

            foreach (QbItemBase qib in this.Items)
                pos = qib.AlignPointers(pos);
            if (this.Items.Count != 0)
                this.Items[this.Items.Count - 1].NextItemPointer = 0;

            return next;
        }

        public override uint Length
        {
            get
            {
                return base.Length +  base.ChildrenLength;
            }
        }

        internal override void Write(BinaryEndianWriter bw)
        {
            base.StartLengthCheck(bw);

            base.Write(bw);

            foreach (QbItemBase qib in base.Items)
                qib.Write(bw);

            base.WriteEnd(bw);

            ApplicationException ex = base.TestLengthCheck(this, bw);
            if (ex != null) throw ex;
        }

    }
}
