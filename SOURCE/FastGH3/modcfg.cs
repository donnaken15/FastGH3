using Nanook.QueenBee.Parser;
using System.Windows.Forms;
using System.Drawing;
using System.Collections.Generic;
using System;

public partial class modcfg : Form
{
	static object getItem(QbItemStruct s, QbKey key)
	{
		object _item = (s.FindItem(key, false));
		return moddiag.getItemObject(_item);
	}
	static string structString(QbItemStruct s, QbKey key, string def)
	{
		object item = getItem(s, key);
		if (item == null)
		{
			if (def == null)
				return "";
			else
				return def;
		}
		// :/
		// realized this is the value, not the item
		//if (((QbItemBase)item).QbItemType != QbItemType.StructItemString &&
			//((QbItemBase)item).QbItemType != QbItemType.StructItemStringW) return "";
		// that's the WRONG TYPE OOOOOOOOOOOOO
		return (string)item;
	}
	string structString(QbItemStruct s, QbKey key)
	{
		return structString(s, key, null);
	}
	static int structInt(QbItemStruct s, QbKey key)
	{
		object test = getItem(s, key);
		if (test != null)
		{
			//if (((QbItemBase)test).QbItemType != QbItemType.StructItemInteger) return 0;
			return (int)test;
		}
		else
			return 0;
	}
	static float structFloat(QbItemStruct s, QbKey key)
	{
		object test = getItem(s, key);
		if (test != null)
		{
			//if (((QbItemBase)test).QbItemType != QbItemType.StructItemFloat) return 0;
			return (float)test;
		}
		else
			return 0;
	}

	void resetParam(object sender, EventArgs e)
	{

	}
	void setParamValue(object sender, EventArgs e)
	{
		string name = ((Control)sender).Name;
	}

	public modcfg(QbItemStructArray _params)
	{
		InitializeComponent();
		Font font = new Font("Microsoft Sans Serif", 11.25f, GraphicsUnit.Point);
		int j = 0;
		foreach (QbItemStruct i in _params.Items)
		{
			Panel newParam = new Panel() {
				Size = new Size(306, 44),
				Location = new Point(6, 4 + (j++ * 48)),
				Anchor = (AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top),
				Tag = i,
				//BackColor = Color.Gray
			};
			if (getItem(i, QbKey.Create("desc")) != null)
				tooltip.SetToolTip(newParam, structString(i, QbKey.Create("desc")));
			//i.FindItem(QbKey.Create("name"), false);
			string paramTitle = structString(i, QbKey.Create("name"));
			Label paramName = new Label() {
				Font = font,
				Location = new Point(2,0),
				FlatStyle = FlatStyle.System,
				Text = paramTitle,
				AutoSize = true
			};
			Button paramReset = new Button() {
				Location = new Point(264, 2),
				Size = new Size(40, 18),
				Anchor = AnchorStyles.Top | AnchorStyles.Right,
				FlatStyle = FlatStyle.System,
				Text = "Reset"
			};
			Control paramCtrl;
			uint ctrlType = 0;
			if (getItem(i, QbKey.Create("type")) != null)
				ctrlType = ((QbKey)getItem(i, QbKey.Create("type"))).Crc;
			QbItemBase defaultItem = (i.FindItem(QbKey.Create("default"), false));
			object def = moddiag.getItemObject(defaultItem);
			switch (ctrlType)
			{
				// uses int
				case 0xAA7EC96D: // bool
				case 0x8C79023A: // bool3
					if (def == null) def = 0;
					/*if (defaultItem.QbItemType != QbItemType.StructItemInteger ||
						((defaultItem.QbItemType != QbItemType.StructItemQbKey &&
						(((QbKey)def).Crc != 0x0203B372) && (((QbKey)def).Crc != 0xD43297CF))))
						throw new InvalidCastException("Default value's type does not support the control type.");*/
					paramCtrl = new CheckBox()
					{
						Location = new Point(2, 20),
						Anchor = AnchorStyles.Top | AnchorStyles.Right,
						FlatStyle = FlatStyle.System,
						ThreeState = ctrlType == 0x8C79023A,
						Text = "Toggle",
						CheckState = (CheckState)def,
						Name = paramTitle
					};
					(paramCtrl as CheckBox).CheckStateChanged += new EventHandler(setParamValue);
					newParam.Height -= 4;
					break;
				case 0x3038EFF8: // slider
					if (def == null) def = 0;
					paramCtrl = new TrackBar()
					{
						Location = new Point(2, 20),
						Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right,
						Width = 220,
						Value = (int)def,
						Maximum = structInt(i, QbKey.Create("max")),
						Minimum = structInt(i, QbKey.Create("min")),
						Name = paramTitle
					};
					(paramCtrl as TrackBar).ValueChanged += new EventHandler(setParamValue);
					Label trackbarText = new Label()
					{
						Font = font,
						Location = new Point(paramCtrl.Width + 5, 23),
						FlatStyle = FlatStyle.System,
						Text = structInt(i, QbKey.Create("default")).ToString(),
						AutoSize = true,
						Name = paramTitle+"_disp"
					};
					newParam.Controls.Add(trackbarText);
					break;
				default:
					if (defaultItem == null)
						paramCtrl = new Label()
						{
							Location = new Point(2, 24),
							FlatStyle = FlatStyle.System,
							Text = "Invalid parameter"
						};
					else
					{
						switch (defaultItem.QbItemType)
						{
							case QbItemType.StructItemString:
							case QbItemType.StructItemStringW:
								paramCtrl = new TextBox()
								{
									Location = new Point(2, 23),
									Size = new Size(302, 0),
									Text = (string)def,
									Name = paramTitle
								};
								(paramCtrl as TextBox).TextChanged += new EventHandler(setParamValue);
								break;
							case QbItemType.StructItemInteger:
								paramCtrl = new NumericUpDown()
								{
									Location = new Point(2, 23),
									Width = 302,
									Value = (int)def,
									Maximum = structInt(i, QbKey.Create("max")),
									Minimum = structInt(i, QbKey.Create("min")),
									Name = paramTitle
								};
								(paramCtrl as NumericUpDown).ValueChanged += new EventHandler(setParamValue);
								break;
							case QbItemType.StructItemFloat:
								paramCtrl = new NumericUpDown()
								{
									Location = new Point(2, 23),
									Width = 302,
									Value = Convert.ToDecimal((float)def),
									DecimalPlaces = 4,
									Maximum = Convert.ToDecimal(getItem(i, QbKey.Create("max"))), // to accept int/float ranges
									Minimum = Convert.ToDecimal(getItem(i, QbKey.Create("min"))), // in case of not explicit decimal
									Name = paramTitle
								};
								(paramCtrl as NumericUpDown).ValueChanged += new EventHandler(setParamValue);
								break;
							default:
								paramCtrl = new Label()
								{
									Location = new Point(2, 24),
									FlatStyle = FlatStyle.System,
									Text = "Invalid type ("+defaultItem.QbItemType+")"
								};
								break;
						}
					}
					break;
			}
			newParam.Controls.Add(paramName);
			newParam.Controls.Add(paramReset);
			newParam.Controls.Add(paramCtrl);
			Controls.Add(newParam);
		}
	}
}
