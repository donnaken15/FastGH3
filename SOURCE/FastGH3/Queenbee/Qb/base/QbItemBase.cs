using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{


	public abstract class QbItemBase
	{

		public QbItemBase(QbFile root)
		{
			_qbFormatSet = false;
			_root = root;
			_lengthCheckStart = 0;
			_items = new List<QbItemBase>();
		}

		/// <summary>
		/// Load type data from binary reader
		/// </summary>
		public virtual void Create(QbItemType type)
		{
			setQbFormat(type);

			_qbItemType = type;
			_qbItemValue = this.Root.PakFormat.GetQbItemValue(type, this.Root);
			_position = 0; //unknown

			#region switch
			switch (_qbFormat)
			{
				case QbFormat.SectionPointer:
					//Complex section type:
					//  ItemId, FileId, Pointer, Reserved

					_itemQbKey = QbKey.Create(0);
					_fileId = this.Root.FileId;
					_pointer = 0;
					_reserved = 0;

					_length = (5 * 4);

					_itemCount = 1;

					_pointers = new uint[1];
					_pointers[0] = 0;
					break;

				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId, Value, Reserved

					_itemQbKey = QbKey.Create(0);
					_fileId = this.Root.FileId;

					_itemCount = 1;

					_length = (4 * 4);
					break;

				case QbFormat.StructItemPointer:
					//Complex struct type:
					//  ItemId, Pointer, NextItemPointer

					_itemQbKey = QbKey.Create(0);
					_pointer = 0;
					_nextItemPointer = 0;

					_itemCount = 1;
					_pointers = new uint[1];
					_pointers[0] = _pointer;

					_length = (4 * 4);
					break;

				case QbFormat.StructItemValue:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer

					_itemQbKey = QbKey.Create(0);  //always null?
					_itemCount = 1;

					_length = (3 * 4);
					break;

				case QbFormat.ArrayPointer:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)

					_itemCount = 0;
					_pointer = 0;
					_itemQbKey = null;

					_length = (3 * 4);

					_pointers = new uint[_itemCount];
					break;

				case QbFormat.ArrayValue:
					//Simple array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)

					_itemQbKey = null;
					_itemCount = 0;
					_length = (2 * 4);
					break;

				case QbFormat.StructHeader: //when struct array item
					_length = (1 * 4);
					break;

				case QbFormat.Floats:
					_itemCount = 2;
					_length = (1 * 4);
					break;

				case QbFormat.Unknown:
					_position += 4; //there is no header so re add the previously removed 4
					_length = (0 * 4);
					break;

				default:
					break;
			}
			#endregion

			setChildMode();
			_itemCount = (uint)this.CalcItemCount();
		}
		
		/// <summary>
		/// Call after derived class has read its data in Construct()
		/// </summary>
		/// <param name="br"></param>
		public virtual void ConstructEnd(BinaryEndianReader br)
		{
			#region switch
			switch (_qbFormat)
			{
				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId, Value, Reserved
					_reserved = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_length += (1 * 4);
					break;

				case QbFormat.StructItemPointer:
					if (_nextItemPointer != 0 && this.StreamPos(br) != _nextItemPointer) //pointer test
						throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _nextItemPointer));
					break;

				case QbFormat.StructItemValue:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
					_nextItemPointer = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_length += (1 * 4);

					if (_nextItemPointer != 0 && this.StreamPos(br) != _nextItemPointer) //pointer test
						throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _nextItemPointer));
					break;

				case QbFormat.ArrayPointer:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					for (int i = 0; i < _items.Count; i++) //_items.Count is 0 for strings (it checks it's own)
					{
						if (_pointers[i] != _items[i].Position)
							throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, _items[i].Position, _pointers[i]));
					}
					break;

				default:
					break;
			}
			#endregion

			setChildMode();
			//_itemCount = (uint)this.CalcItemCount();
		}

		/// <summary>
		/// Load type data from binary reader
		/// </summary>
		public virtual void Construct(BinaryEndianReader br, QbItemType type)
		{
			setQbFormat(type);
			_qbItemType = type;
			_qbItemValue = this.Root.PakFormat.GetQbItemValue(type, this.Root);
			_position = this.StreamPos(br) - (1 * 4); //subtract the already read header
			uint itemQbKeyCrc = 0;

			#region switch
			switch (_qbFormat)
			{
				case QbFormat.SectionPointer:
					//Complex section type:
					//  ItemId, FileId, Pointer, Reserved
					_hasQbKey = true;

					itemQbKeyCrc = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_fileId = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_pointer = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_reserved = br.ReadUInt32(this.Root.PakFormat.EndianType);

					_length = (5*4);

					if (type == QbItemType.SectionScript)
						_itemCount = 0;
					else
						_itemCount = 1;
					_pointers = new uint[1];
					_pointers[0] = _pointer;

					if (this.StreamPos(br) != _pointer) //pointer test
						throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _pointer));
					break;

				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId, Value, Reserved
					_hasQbKey = true;

					itemQbKeyCrc = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_fileId = br.ReadUInt32(this.Root.PakFormat.EndianType);

					_itemCount = 1;

					_length = (3*4);
					break;

				case QbFormat.StructItemPointer:
					//Complex struct type:
					//  ItemId, Pointer, NextItemPointer
					_hasQbKey = true;

					itemQbKeyCrc = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_pointer = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_nextItemPointer = br.ReadUInt32(this.Root.PakFormat.EndianType);

					if (this.StreamPos(br) != _pointer) //pointer test
						throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _pointer));

					_itemCount = 1;
					_pointers = new uint[1];
					_pointers[0] = _pointer;

					_length = (4*4);
					break;

				case QbFormat.StructItemValue:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
					_hasQbKey = true;

					itemQbKeyCrc = br.ReadUInt32(this.Root.PakFormat.EndianType);

					//always null?
					if (_itemQbKey == 0 && _qbItemType == QbItemType.StructItemQbKeyString)
						_itemQbKey = null;

					_itemCount = 1;

					_length = (2*4);
					break;

				case QbFormat.ArrayPointer:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					_hasQbKey = false;

					_itemCount = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_pointer = br.ReadUInt32(this.Root.PakFormat.EndianType);
					itemQbKeyCrc = 0;

					_length = (3 * 4);

					if (_pointer != 0 && this.StreamPos(br) != _pointer) //pointer test
						throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _pointer));

					_pointers = new uint[_itemCount];

					if (_itemCount == 1)
						_pointers[0] = _pointer;
					else if (_itemCount > 1)
					{
						for (int i = 0; i < _itemCount; i++)
							_pointers[i] = br.ReadUInt32(this.Root.PakFormat.EndianType);

						_length += (_itemCount * 4);
					}
					break;

				case QbFormat.ArrayValue:
					//Simple array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					_hasQbKey = false;

					itemQbKeyCrc = 0;
					_itemCount = br.ReadUInt32(this.Root.PakFormat.EndianType);
					_length = (2*4);
					if (_itemCount > 1)
					{
						_pointer = br.ReadUInt32(this.Root.PakFormat.EndianType);
						if (this.StreamPos(br) != _pointer) //pointer test
							throw new ApplicationException(QbFile.FormatBadPointerExceptionMessage(this, this.StreamPos(br), _pointer));
						_length += (1 * 4);
					}
					break;

				case QbFormat.StructHeader: //when struct array item
					_hasQbKey = false;
					_length = (1 * 4);
					break;

				case QbFormat.Floats:
					_hasQbKey = false;
					_length = (1 * 4);
					break;

				case QbFormat.Unknown:
					_hasQbKey = false;
					_position += 4; //there is no header so re add the previously removed 4
					_length = (0*4);
					break;

				default:
					break;
			}
			#endregion

			if (!_hasQbKey)
				_itemQbKey = null;
			else
			{
				string debugName = Root.LookupDebugName(itemQbKeyCrc);
				if (debugName.Length != 0)
					_itemQbKey = QbKey.Create(itemQbKeyCrc, debugName);
				else
					_itemQbKey = QbKey.Create(itemQbKeyCrc);
			}

		}

		public abstract QbItemBase Clone();

		/// <summary>
		/// Add an item to the child collection
		/// </summary>
		/// <param name="item"></param>
		public void AddItem(QbItemBase item)
		{
			_items.Add(item);
		}

		/// <summary>
		/// Insert a new item before or after the sibling item.
		/// </summary>
		/// <param name="item">Item to insert.</param>
		/// <param name="relatedItem">Sibling item, child of this item</param>
		/// <param name="beforeAfter">Insert before=True or after=False</param>
		public void InsertItem(QbItemBase item, QbItemBase sibling, bool beforeAfter)
		{
			for (int i = 0; i < this.Items.Count; i++)
			{
				if (this.Items[i] == sibling)
				{
					if (beforeAfter)
						this.Items.Insert(i, item);
					else
					{
						if (i + 1 < this.Items.Count)
							this.Items.Insert(i + 1, item);
						else
							this.Items.Add(item);
					}
					return;
				}
			}
		}

		/// <summary>
		/// Remove the specified item from this items children
		/// </summary>
		/// <param name="item">Item to remove</param>
		public void RemoveItem(QbItemBase item)
		{
			_items.Remove(item);
		}

		/// <summary>
		/// Return the child items (Adding it's to this collection may corrupt the file)
		/// </summary>
		public List<QbItemBase> Items
		{
			get { return _items; }
		}

		/// <summary>
		/// Each item must be able to return it's length so that pointers can be correctly calculated
		/// </summary>
		public virtual uint Length
		{
			get
			{
				#region switch
				switch (_qbFormat)
				{
					case QbFormat.ArrayValue:
						if (_itemCount > 1)
							_length = (3 * 4);
						else
							_length = (2 * 4);
						break;
				}
				#endregion

				return _length;
			}
		}

		/// <summary>
		/// Align the pointers to account for any editing, return the position after the current item
		/// </summary>
		public virtual uint AlignPointers(uint pos)
		{
			_position = pos;
			_itemCount = (uint)CalcItemCount();

			#region switch
			switch (_qbFormat)
			{
				case QbFormat.SectionPointer:
					//Complex section type:
					//  ItemId, FileId, Pointer, Reserved
					_pointer = (pos += (5 * 4));
					break;

				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId, Value, Reserved
					pos += _length;
					break;

				case QbFormat.StructItemPointer:
					//Complex struct type:
					//  ItemId, Pointer, NextItemPointer
					_nextItemPointer = pos + this.Length;
					_pointer = (pos += (4 * 4));
					break;

				case QbFormat.StructItemValue:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
					_nextItemPointer = pos + this.Length;
					pos += _length;
					break;

				case QbFormat.ArrayPointer:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					_pointer = (pos += (3 * 4));

					if (_qbItemType != QbItemType.ArrayString && _qbItemType != QbItemType.ArrayStringW) //string sets this itself
						_itemCount = (uint)_items.Count;
					_pointers = new uint[_itemCount];

					_length = 3 * 4;
					if (_itemCount == 0)
						_pointer = 0; //don't point anywhere
					else if (_itemCount == 1)
						_pointers[0] = _pointer;
					else if (_itemCount > 1)
					{
						_pointers = new uint[_itemCount];
						_length += _itemCount * 4;
						uint pos2 = (pos = _pointer + (_itemCount * 4));
						int i = 0;
						//no pointers will be stored for the string array
						foreach (QbItemBase qib in _items)
						{
							_pointers[i++] = pos2;
							pos2 += qib.Length;
						}
					}
					//exit with pos pointing to the position after the pointers
					break;

				case QbFormat.ArrayValue:
					//Simple array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)

					pos += 2 * 4;
					_pointer = 0;
					_length = (2 * 4);

					if (_itemCount > 1)
					{
						_pointer = (pos += (1 * 4));
						_length += (1 * 4);
					}
					break;


				case QbFormat.StructHeader: //when struct array item
					pos += (1 * 4);
					break;
				case QbFormat.Floats:
					pos += (1 * 4);
					break;
				case QbFormat.Unknown:
					pos += (0 * 4);
					break;
				default:
					break;
			}
			#endregion

			return pos;
		}

		/// <summary>
		/// Override this when the _items list does not contain the child items
		/// </summary>
		/// <returns></returns>
		protected virtual int CalcItemCount()
		{
			return _items.Count;
		}

		/// <summary>
		/// Calculate the combined length of all this item's children
		/// </summary>
		protected uint ChildrenLength
		{
			get
			{
				uint len = 0;
				foreach (QbItemBase qib in _items)
					len += qib.Length;
				return len;
			}
		}

		public QbFile Root
		{
			get { return _root; }
		}

		public QbFormat Format
		{
			get { return _qbFormat; }
		}

		public uint Position
		{
			get { return _position; }
			set { _position = value; }
		}

		public string DebugName
		{
			get
			{
				if (_itemQbKey != null && _itemQbKey.HasText)
					return _itemQbKey.Text;
				else
					return string.Empty;
			}
		}
		public string SafeName
		{
			get
			{
				if (_itemQbKey != null)
				{
					if (_itemQbKey.HasText)
						return _itemQbKey.Text;
					else
						return _itemQbKey.Crc.ToString("X8");
				}
				else
					return string.Empty;
			}
		}

		protected uint StreamPos(BinaryEndianReader br)
		{
			return Root.StreamPos(br.BaseStream);
		}

		protected uint StreamPos(BinaryEndianWriter bw)
		{
			return Root.StreamPos(bw.BaseStream);
		}

		protected void StartLengthCheck(BinaryEndianWriter bw)
		{
			_lengthCheckStart = this.StreamPos(bw);
		}

		protected ApplicationException TestLengthCheck(object sender, BinaryEndianWriter bw)
		{
			uint len = this.Length;
			if (this.StreamPos(bw) - _lengthCheckStart != len)
			{
				return new ApplicationException(QbFile.FormatWriteLengthExceptionMessage(sender, _lengthCheckStart, this.StreamPos(bw), len));
			}
			else
				return null;
		}

		public virtual IsValidReturnType IsValid
		{
			get
			{
				_itemCount = (uint)CalcItemCount();

				if (_childMode == 0)
				{
					if (this.ItemCount != 0)
						return IsValidReturnType.ItemMustHave0Items;
				}
				else if (_childMode == 1)
				{
					if (this.ItemCount != 1)
						return IsValidReturnType.ItemMustHave1Item;
				}
				else if (_childMode == 2)
				{
					if (this.ItemCount < 0)
						return IsValidReturnType.ItemMustHave0OrMoreItems;
				}
				else if (_childMode == 3)
				{
					if (this.ItemCount < 1)
						return IsValidReturnType.ItemMustHave1OrMoreItems;
				}

				//if (QbItemType == QbItemType.ArrayArray)
				//{
				//    QbItemType? qb = null;
				//    foreach (QbItemBase qib in this.Items)
				//    {
				//        if (qb == null)
				//            qb = qib.QbItemType;
				//        else if (qib.QbItemType != qb)
				//            return IsValidReturnType.ArrayItemsMustBeSameType;
				//    }
				//}

				return IsValidReturnType.Okay;
			}
		}


		public virtual GenericQbItem[] GetItems()
		{
			return new GenericQbItem[0];
		}

		[GenericEditable("Item QB Key", typeof(string), false, false)]
		public QbKey ItemQbKey
		{
			get { return _itemQbKey; }
			set { _itemQbKey = value; }
		}

		public QbItemType QbItemType
		{
			get { return _qbItemType; }
		}

		public uint QbItemValue
		{
			get { return _qbItemValue; }
		}

		public int ChildMode
		{
			get { return _childMode; }
		}

		public uint FileId
		{
			get { return _fileId; }
			set { _fileId = value; }
		}

		public uint Pointer
		{
			get { return _pointer; }
			set { _pointer = value; }
		}

		public uint[] Pointers
		{
			get { return _pointers; }
			set { _pointers = value; }
		}

		public uint NextItemPointer
		{
			get { return _nextItemPointer; }
			set { _nextItemPointer = value; }
		}

		public uint ItemCount
		{
			get { return _itemCount; }
			protected set { _itemCount = value; }
		}

		public uint Reserved
		{
			get { return _reserved; }
			set { _reserved = value; }
		}

		/// <summary>
		/// Call after derived class has written its data in Write()
		/// </summary>
		/// <param name="br"></param>
		public virtual void WriteEnd(BinaryEndianWriter bw)
		{
			#region switch
			switch (_qbFormat)
			{
				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId, Value, Reserved
					bw.Write(_reserved, this.Root.PakFormat.EndianType);
					break;

				case QbFormat.StructItemValue:
					//case QbItemType.StructItemQbKeyString:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
						bw.Write(_nextItemPointer, this.Root.PakFormat.EndianType);
					break;

				default:
					break;
			}
			#endregion

		}

		/// <summary>
		/// Write the item to the Binary Writer
		/// </summary>
		/// <param name="bw"></param>
		internal virtual void Write(BinaryEndianWriter bw)
		{
			bw.Write(_qbItemValue, this.Root.PakFormat.EndianType);

			#region switch

			uint qbKeyCrc = (_itemQbKey == null ? 0 : _itemQbKey.Crc);

			switch (_qbFormat)
			{
				case QbFormat.SectionPointer:
					//Complex section type:
					//  ItemId, FileId, Pointer, Reserved
					bw.Write(qbKeyCrc, this.Root.PakFormat.EndianType);
					bw.Write(_fileId, this.Root.PakFormat.EndianType);
					bw.Write(_pointer, this.Root.PakFormat.EndianType);
					bw.Write(_reserved, this.Root.PakFormat.EndianType);
					break;

				case QbFormat.SectionValue:
					//Simple section type:
					//  ItemId, FileId
					bw.Write(qbKeyCrc, this.Root.PakFormat.EndianType);
					bw.Write(_fileId, this.Root.PakFormat.EndianType);
					break;

				case QbFormat.StructItemPointer:
					//Complex struct type:
					//  ItemId, Pointer, NextItemPointer
					bw.Write(qbKeyCrc, this.Root.PakFormat.EndianType);
					bw.Write(_pointer, this.Root.PakFormat.EndianType);
					bw.Write(_nextItemPointer, this.Root.PakFormat.EndianType);
					break;

				case QbFormat.StructItemValue:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
					bw.Write(qbKeyCrc, this.Root.PakFormat.EndianType);
					break;

				case QbFormat.ArrayPointer:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					bw.Write(_itemCount, this.Root.PakFormat.EndianType);
					if (_itemCount == 0)
						bw.Write(0, this.Root.PakFormat.EndianType);
					else if (_itemCount > 1)
						bw.Write(_pointer, this.Root.PakFormat.EndianType);
					for (int i = 0; i < _itemCount; i++)
						bw.Write(_pointers[i], this.Root.PakFormat.EndianType);
					break;

				case QbFormat.ArrayValue:
					//Simple array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					bw.Write(_itemCount, this.Root.PakFormat.EndianType);
					if (_itemCount > 1)
						bw.Write(_pointer, this.Root.PakFormat.EndianType);
					break;


				case QbFormat.StructHeader:
					break;
				case QbFormat.Floats:
					break;
				case QbFormat.Unknown:
					break;
				default:
					break;
			}
			#endregion
		}

		public virtual void setQbFormat(QbItemType type)
		{
			if (_qbFormatSet)
				return;

			#region switch
			switch (type)
			{
				case QbItemType.SectionArray:
				case QbItemType.SectionFloatsX2:
				case QbItemType.SectionFloatsX3:
				case QbItemType.SectionString:
				case QbItemType.SectionStringW:
				case QbItemType.SectionStruct:
				case QbItemType.SectionScript:
					//Complex section type:
					//  ItemId, FileId, Pointer, Reserved
					_qbFormat = QbFormat.SectionPointer;
					break;

				case QbItemType.SectionInteger:
				case QbItemType.SectionFloat:
				case QbItemType.SectionQbKey:
				case QbItemType.SectionQbKeyString:
				case QbItemType.SectionStringPointer:
				case QbItemType.SectionQbKeyStringQs: //GH:GH
					//Simple section type:
					//  ItemId, FileId, Value, Reserved
					_qbFormat = QbFormat.SectionValue;
					break;

				case QbItemType.StructItemArray:
				case QbItemType.StructItemFloatsX2:
				case QbItemType.StructItemFloatsX3:
				case QbItemType.StructItemString:
				case QbItemType.StructItemStringW:
				case QbItemType.StructItemStruct:
					//Complex struct type:
					//  ItemId, Pointer, NextItemPointer
					_qbFormat = QbFormat.StructItemPointer;
					break;

				case QbItemType.StructItemQbKeyString:
				case QbItemType.StructItemStringPointer:
				case QbItemType.StructItemQbKeyStringQs:
				case QbItemType.StructItemQbKey:
				case QbItemType.StructItemInteger:
				case QbItemType.StructItemFloat:
					//Simple struct type:
					//  ItemId, Value (4 byte), NextItemPointer
					_qbFormat = QbFormat.StructItemValue;
					break;

				case QbItemType.ArrayArray:
				case QbItemType.ArrayString:
				case QbItemType.ArrayStringW:
				case QbItemType.ArrayStruct:
				case QbItemType.ArrayFloatsX2:
				case QbItemType.ArrayFloatsX3:
					//Complex array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					_qbFormat = QbFormat.ArrayPointer;
					break;

				case QbItemType.ArrayQbKey:
				case QbItemType.ArrayInteger:
				case QbItemType.ArrayFloat:
				case QbItemType.ArrayQbKeyString:
				case QbItemType.ArrayStringPointer: //GH:GH
				case QbItemType.ArrayQbKeyStringQs: //GH:GH
					//Simple array type:
					//  ItemCount, Pointer, Pointers -  (if length is 1 then pointer points to first item and Pointers are abscent)
					_qbFormat = QbFormat.ArrayValue;
					break;

				case QbItemType.StructHeader: //when struct array item
					_qbFormat = QbFormat.StructHeader;
					break;

				case QbItemType.Floats:
					_qbFormat = QbFormat.Floats;
					break;

				case QbItemType.Unknown:
					_qbFormat = QbFormat.Unknown;
					break;

				default:
					break;
			}
			#endregion

			_qbFormatSet = true;
		}

		private void setChildMode()
		{
			switch (QbItemType)
			{
				case QbItemType.Unknown:
				case QbItemType.SectionScript:
					_childMode = 0;
					break;
				case QbItemType.SectionArray:
				case QbItemType.SectionFloatsX2:
				case QbItemType.SectionFloatsX3:
				case QbItemType.SectionInteger:
				case QbItemType.SectionFloat:
				case QbItemType.SectionString:
				case QbItemType.SectionStringW:
				case QbItemType.SectionQbKey:
				case QbItemType.SectionQbKeyString:
				case QbItemType.SectionStringPointer:
				case QbItemType.SectionQbKeyStringQs: //GH:GH
				case QbItemType.StructItemInteger:
				case QbItemType.StructItemFloat:
				case QbItemType.StructItemString:
				case QbItemType.StructItemStringW:
				case QbItemType.StructItemFloatsX2:
				case QbItemType.StructItemFloatsX3:
				case QbItemType.StructItemQbKey:
				case QbItemType.StructItemQbKeyString:
				case QbItemType.StructItemStringPointer:
				case QbItemType.StructItemQbKeyStringQs:
				case QbItemType.StructItemArray:
					_childMode = 1;
					break;
				case QbItemType.ArrayInteger:
				case QbItemType.ArrayFloat:
				case QbItemType.ArrayString:
				case QbItemType.ArrayStringW:
				case QbItemType.ArrayQbKey:
				case QbItemType.ArrayQbKeyString:
				case QbItemType.ArrayStringPointer: //GH:GH
				case QbItemType.ArrayQbKeyStringQs: //GH:GH
				case QbItemType.SectionStruct:
				case QbItemType.StructItemStruct:
				case QbItemType.StructHeader:
					_childMode = 2;
					break;

				case QbItemType.ArrayFloatsX2:
				case QbItemType.ArrayFloatsX3:
				case QbItemType.ArrayStruct:
				case QbItemType.ArrayArray:
				case QbItemType.Floats: //must be 2 or 3, but this is a good enough check
					_childMode = 3;
					break;
				//default:
					//break;
			}
		}

		public QbItemBase FindItem(QbKey key, bool recursive)
		{
			return this.Root.SearchItems(this.Root, _items, recursive, delegate(QbItemBase item)
			{
				return (item.ItemQbKey != 0 && item.ItemQbKey.Crc == key.Crc);
			});
		}

		public QbItemBase FindItem(QbItemType type, bool recursive)
		{
			return this.Root.SearchItems(this.Root, _items, recursive, delegate(QbItemBase item)
			{
				return (item.QbItemType == type);
			});
		}

		public QbItemBase FindItem(bool recursive, Predicate<QbItemBase> match)
		{
			return this.Root.SearchItems(this.Root, _items, recursive, match);
		}


		private QbItemType _qbItemType;
		private uint _qbItemValue;
		private uint _pointer;
		private bool _hasQbKey;
		private QbKey _itemQbKey;
		private uint _fileId;
		private uint _reserved;
		private uint _itemCount;
		private uint _nextItemPointer;
		private uint[] _pointers;

		private uint _length;

		private int _childMode; //0=nochildren, 1=Must have 1 Child, 2=Zero or more, 3=One or more

		private uint _lengthCheckStart;
		private uint _position;
		private QbFile _root;
		private List<QbItemBase> _items;

		private QbFormat _qbFormat;
		private bool _qbFormatSet;
	}
}
