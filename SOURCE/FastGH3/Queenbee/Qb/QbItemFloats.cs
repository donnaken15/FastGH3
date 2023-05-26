using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
	public class QbItemFloats : QbItemBase
	{
		public QbItemFloats(QbFile root) : this(root, false)
		{
		}

		public QbItemFloats(QbFile root, bool isX3) : base(root)
		{
			this.Values = new float[isX3 ? 3 : 2];
		}

		public override void Create(QbItemType type)
		{
			if (type != QbItemType.Floats)
				throw new ApplicationException(string.Format("type '{0}' is not a floats item type", type.ToString()));

			base.Create(type);

			this.Values = new float[2]; //sets item count
			_values[0] = 0; //default to 2 items, if more are required, simply set Values externally.
			_values[1] = 0;
		}

		/// <summary>
		/// Deep clones this item and all children.  Positions and lengths are not cloned.  When inserted in to another item they should be calculated.
		/// </summary>
		/// <returns></returns>
		public override QbItemBase Clone()
		{
			QbItemFloats qi = new QbItemFloats(this.Root);
			qi.Create(this.QbItemType);

			if (this.ItemQbKey != null)
				qi.ItemQbKey = this.ItemQbKey.Clone();

			float[] fi = new float[this.Values.Length];
			for (int i = 0; i < fi.Length; i++)
				fi[i] = this.Values[i];

			qi.Values = fi;
			qi.ItemCount = this.ItemCount;

			return qi;
		}

		public override void Construct(BinaryEndianReader br, QbItemType type)
		{
			//System.Diagnostics.Debug.WriteLine(string.Format("{0} - 0x{1}", type.ToString(), (base.StreamPos(br) - 4).ToString("X").PadLeft(8, '0')));

			base.Construct(br, type);

			_values[0] = br.ReadSingle(base.Root.PakFormat.EndianType);
			_values[1] = br.ReadSingle(base.Root.PakFormat.EndianType);
			if (_values.Length > 2)
				_values[2] = br.ReadSingle(base.Root.PakFormat.EndianType);

			base.ConstructEnd(br);
		}

		protected override int CalcItemCount()
		{
			return _values.Length;
		}
		
		public override uint AlignPointers(uint pos)
		{
			uint next = pos + this.Length;
			//yey no pointers
			base.AlignPointers(pos);
			return next;
		}

		public override uint Length
		{
			get
			{
				return base.Length + ((uint)_values.Length * 4);
			}
		}

		[GenericEditable("Decimal", typeof(float), true, false)]
		public float[] Values
		{
			get { return _values; }
			set { _values = value; }
		}

		internal override void Write(BinaryEndianWriter bw)
		{
			base.StartLengthCheck(bw);

			base.Write(bw);

			foreach (float f in _values)
				bw.Write(f, base.Root.PakFormat.EndianType);

			base.WriteEnd(bw);

			ApplicationException ex = base.TestLengthCheck(this, bw);
			if (ex != null) throw ex;

		}

		private float[] _values;

	}
}
