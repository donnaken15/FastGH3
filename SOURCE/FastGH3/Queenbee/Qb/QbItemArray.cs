using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
	public class QbItemArray : QbItemBase
	{
		public QbItemArray(QbFile root) : base(root)
		{
		}

		public override void Create(QbItemType type)
		{
			if (type != QbItemType.SectionArray && type != QbItemType.ArrayArray && type != QbItemType.StructItemArray && type != QbItemType.StructItemStruct)
				throw new ApplicationException(string.Format("type '{0}' is not an array item type", type.ToString()));

			base.Create(type);
		}

		/// <summary>
		/// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
		/// </summary>
		/// <returns></returns>
		public override QbItemBase Clone()
		{
			QbItemArray a = new QbItemArray(this.Root);
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

			QbItemBase qib = null;
			QbItemType arrayType;
			uint arrayValue;

			for (int i = 0; i < base.ItemCount; i++)
			{
				arrayValue = br.ReadUInt32(this.Root.PakFormat.EndianType);
				arrayType = this.Root.PakFormat.GetQbItemType(arrayValue);

				switch (arrayType)
				{
					case QbItemType.Floats:
						qib = new QbItemFloats(this.Root);
						break;
					case QbItemType.ArrayStruct:
						qib = new QbItemStructArray(this.Root);
						break;
					case QbItemType.ArrayFloat:
						qib = new QbItemFloat(this.Root);
						break;
					case QbItemType.ArrayString:
					case QbItemType.ArrayStringW:
						qib = new QbItemString(this.Root);
						break;
					case QbItemType.ArrayFloatsX2:
					case QbItemType.ArrayFloatsX3:
						qib = new QbItemFloatsArray(this.Root);
						break;
					case QbItemType.ArrayStringPointer:
					case QbItemType.ArrayInteger:
						qib = new QbItemInteger(this.Root);
						break;
					case QbItemType.ArrayArray:
						qib = new QbItemArray(this.Root);
						break;
					case QbItemType.ArrayQbKey:
					case QbItemType.ArrayQbKeyString:
					case QbItemType.ArrayQbKeyStringQs: //GH:GH
						qib = new QbItemQbKey(this.Root);
						break;
					case QbItemType.StructHeader:
						qib = new QbItemStruct(this.Root);
						break;
					default:
						throw new ApplicationException(string.Format("Location 0x{0}: Unknown array type 0x{1}", (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0'), arrayValue.ToString("X").PadLeft(8, '0')));
				}
				qib.Construct(br, arrayType);
				AddItem(qib);

			}
			base.ConstructEnd(br);
		}

		public override uint AlignPointers(uint pos)
		{
			uint next = pos + this.Length;
			pos = base.AlignPointers(pos);

			foreach (QbItemBase qib in this.Items)
				pos = qib.AlignPointers(pos);

			//if items exist then null the last item's pointer
			if (this.Items.Count != 0)
				this.Items[this.Items.Count - 1].NextItemPointer = 0;

			return next;
		}

		public override uint Length
		{
			get
			{
				return base.Length + base.ChildrenLength;
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
