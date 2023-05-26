using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
	public class QbItemStruct : QbItemBase
	{
		public QbItemStruct(QbFile root) : base(root)
		{
		}

		public override void Create(QbItemType type)
		{
			if (type != QbItemType.SectionStruct && type != QbItemType.StructItemStruct && type != QbItemType.StructHeader)
				throw new ApplicationException(string.Format("type '{0}' is not a struct item type", type.ToString()));

			base.Create(type);

			if (type != QbItemType.StructHeader)
			{
				_headerType = QbItemType.StructHeader;
				_headerValue = this.Root.PakFormat.GetQbItemValue(_headerType, this.Root);
			}

		}

		/// <summary>
		/// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
		/// </summary>
		/// <returns></returns>
		public override QbItemBase Clone()
		{
			QbItemStruct s = new QbItemStruct(this.Root);
			s.Create(this.QbItemType);

			if (this.ItemQbKey != null)
				s.ItemQbKey = this.ItemQbKey.Clone();

			foreach (QbItemBase qib in this.Items)
				s.Items.Add(qib.Clone());

			s.ItemCount = this.ItemCount;

			return s;
		}

		public override void Construct(BinaryEndianReader br, QbItemType type)
		{
			//System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

			base.Construct(br, type);

			uint pointer;

			if (type != QbItemType.StructHeader)
				_headerValue = br.ReadUInt32(base.Root.PakFormat.EndianType);
			else
				_headerValue = base.Root.PakFormat.GetQbItemValue(type, this.Root);

			 _headerType = base.Root.PakFormat.GetQbItemType(_headerValue);

			QbItemBase qib = null;
			QbItemType structType;
			uint structValue;

			if (_headerType == QbItemType.StructHeader)
			{
				pointer = br.ReadUInt32(base.Root.PakFormat.EndianType); //Should be the current stream position after reading

				_iniNextItemPointer = pointer;

				if (pointer != 0 && base.StreamPos(br) != pointer) //pointer test
					throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, base.StreamPos(br), pointer));

				while (pointer != 0)
				{
					structValue = br.ReadUInt32(this.Root.PakFormat.EndianType);
					structType = this.Root.PakFormat.GetQbItemType(structValue);

					switch (structType)
					{
						case QbItemType.StructItemStruct:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemStruct(this.Root);
							break;
						case QbItemType.StructItemStringPointer:
						case QbItemType.StructItemInteger:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemInteger(this.Root);
							break;
						case QbItemType.StructItemQbKeyString:
						case QbItemType.StructItemQbKeyStringQs:
						case QbItemType.StructItemQbKey:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemQbKey(this.Root);
							break;
						case QbItemType.StructItemString:
						case QbItemType.StructItemStringW:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemString(this.Root);
							break;
						case QbItemType.StructItemFloat:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemFloat(this.Root);
							break;
						case QbItemType.StructItemFloatsX2:
						case QbItemType.StructItemFloatsX3:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemFloatsArray(this.Root);
							break;
						case QbItemType.StructItemArray:
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.StructItems;
							qib = new QbItemArray(this.Root);
							break;

						//Convert array types to structitems to fit in with this parser (if QbFile.HasStructItems is false then internal type will be swapped back to array)
						case QbItemType.ArrayStruct:
							structType = QbItemType.StructItemStruct;
							qib = new QbItemArray(this.Root);
							break;
						case QbItemType.ArrayInteger:
							structType = QbItemType.StructItemInteger;
							qib = new QbItemInteger(this.Root);
							break;
						case QbItemType.ArrayQbKeyString:
							structType = QbItemType.StructItemQbKeyString;
							qib = new QbItemQbKey(this.Root);
							break;
						case QbItemType.ArrayStringPointer:
							structType = QbItemType.StructItemStringPointer;
							qib = new QbItemInteger(this.Root);
							break;
						case QbItemType.ArrayQbKeyStringQs:
							structType = QbItemType.StructItemQbKeyStringQs;
							qib = new QbItemQbKey(this.Root);
							break;
						case QbItemType.ArrayQbKey:
							structType = QbItemType.StructItemQbKey;
							qib = new QbItemQbKey(this.Root);
							break;
						case QbItemType.ArrayString:
							structType = QbItemType.StructItemString;
							qib = new QbItemString(this.Root);
							break;
						case QbItemType.ArrayStringW:
							structType = QbItemType.StructItemStringW;
							qib = new QbItemString(this.Root);
							break;
						case QbItemType.ArrayFloat:
							structType = QbItemType.StructItemFloat;
							qib = new QbItemFloat(this.Root);
							break;
						case QbItemType.ArrayFloatsX2:
							structType = QbItemType.StructItemFloatsX2;
							qib = new QbItemFloatsArray(this.Root);
							break;
						case QbItemType.ArrayFloatsX3:
							structType = QbItemType.StructItemFloatsX3;
							qib = new QbItemFloatsArray(this.Root);
							break;
						case QbItemType.ArrayArray:
							structType = QbItemType.StructItemArray;
							qib = new QbItemArray(this.Root);
							break;
						default:
							qib = null;
							break;
					}

					if (qib != null)
					{
						if (this.Root.PakFormat.StructItemChildrenType == StructItemChildrenType.NotSet) //will have been set to structItem if qib is not null)
							this.Root.PakFormat.StructItemChildrenType = StructItemChildrenType.ArrayItems;

						qib.Construct(br, structType);
						AddItem(qib);
						pointer = qib.NextItemPointer;
					}
					else
						throw new ApplicationException(string.Format("Location 0x{0}: Unknown item type 0x{1} in struct ", (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0'), structValue.ToString("X").PadLeft(8, '0')));

				}
			}
			else
				throw new ApplicationException(string.Format("Location 0x{0}: Struct without header type", (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

			base.ConstructEnd(br);
		}

		public override uint AlignPointers(uint pos)
		{
			uint next = pos + this.Length;

			pos = base.AlignPointers(pos);

			if (base.QbItemType != QbItemType.StructHeader)
				pos += (1 * 4); //skip header
			_iniNextItemPointer = (pos += (1 * 4)); //skip header and pointer

			foreach (QbItemBase qib in this.Items)
				pos = qib.AlignPointers(pos);
			if (this.Items.Count != 0)
				this.Items[this.Items.Count - 1].NextItemPointer = 0;
			else
				_iniNextItemPointer = 0; //no next item

			return next;
		}

		public override uint Length
		{
			get
			{
				return base.Length + base.ChildrenLength + (1 * 4) + (uint)(base.QbItemType != QbItemType.StructHeader ? 1 * 4 : 0 * 4);
			}
		}

		public uint InitNextItemPointer
		{
			get { return _iniNextItemPointer; }
			set { _iniNextItemPointer = value; }
		}

		internal override void Write(BinaryEndianWriter bw)
		{
			base.StartLengthCheck(bw);

			base.Write(bw);

			if (base.QbItemType != QbItemType.StructHeader)
				bw.Write(_headerValue, base.Root.PakFormat.EndianType);
			bw.Write(_iniNextItemPointer, base.Root.PakFormat.EndianType);

			foreach (QbItemBase qib in base.Items)
				qib.Write(bw);

			base.WriteEnd(bw);

			ApplicationException ex = base.TestLengthCheck(this, bw);
			if (ex != null) throw ex;
		}

		private QbItemType _headerType;
		private uint _headerValue;
		private uint _iniNextItemPointer;
	}
}
