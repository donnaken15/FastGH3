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


	public string nonunique;

	void resetParam(object sender, EventArgs e)
	{
		Control s = (Control)sender;
		QbItemStruct qs = (QbItemStruct)s.Parent.Tag;
		string name = (string)getItem(qs, QbKey.Create("name"));
		Control target = (s.Parent.Controls.Find(name, false)[0]);
		object value = getItem(qs, QbKey.Create("default"));
		uint ctrlType = 0;
		if (getItem(qs, QbKey.Create("type")) != null)
			ctrlType = ((QbKey)getItem(qs, QbKey.Create("type"))).Crc;
		switch (ctrlType)
			//there needs to be something simpler for all this
		{
			// uses int
			case 0xAA7EC96D: // bool
			case 0x8C79023A: // bool3
				(target as CheckBox).CheckState = (CheckState)value;
				break;
			case 0x3038EFF8: // slider
				(target as TrackBar).Value = (int)value;
				(target.Parent.Controls.Find(name + "_disp", false)[0] as Label).Text = value.ToString();
				break;
			case 0x99A9B716: // color
				(target as Panel).BackColor = ColorFromArray((int[])value);
				setParamValue(target, e);
				break;
			default:
				QbItemBase defaultItem = qs.FindItem(QbKey.Create("default"), false);
				object def = moddiag.getItemObject(defaultItem);
				if (defaultItem != null)
				{
					switch (defaultItem.QbItemType)
					{
						case QbItemType.StructItemString:
						case QbItemType.StructItemStringW:
							(target as TextBox).Text = (string)def;
							break;
						case QbItemType.StructItemInteger:
						case QbItemType.StructItemFloat:
							(target as NumericUpDown).Value = Convert.ToDecimal(def);
							break;
					}
				}
				break;
		}
	}
	void setParamValue(object sender, EventArgs e)
	{
		Control s = (Control)sender;
		string name = s.Name;
		QbItemStruct qs = (QbItemStruct)s.Parent.Tag;
		object value = null;
		uint ctrlType = 0;
		if (getItem(qs, QbKey.Create("type")) != null)
			ctrlType = ((QbKey)getItem(qs, QbKey.Create("type"))).Crc;
		switch (ctrlType)
		{
			// uses int
			case 0xAA7EC96D: // bool
			case 0x8C79023A: // bool3
				value = (int)(s as CheckBox).CheckState;
				break;
			case 0x3038EFF8: // slider
				value = (s as TrackBar).Value;
				(s.Parent.Controls.Find(name + "_disp", false)[0] as Label).Text = value.ToString();
				break;
			case 0x99A9B716: // color
				value = ColorToArray((s as Panel).BackColor);
				break;
			default:
				QbItemBase defaultItem = qs.FindItem(QbKey.Create("default"), false);
				if (defaultItem != null)
				{
					switch (defaultItem.QbItemType)
					{
						case QbItemType.StructItemString:
						case QbItemType.StructItemStringW:
							value = (s as TextBox).Text;
							break;
						case QbItemType.StructItemInteger:
							value = (int)(s as NumericUpDown).Value;
							break;
						case QbItemType.StructItemFloat:
							value = (float)(s as NumericUpDown).Value;
							break;
					}
				}
				break;
		}
		string[] ini_kv;
		if ((ini_kv = (string[])getItem(qs, QbKey.Create("ini"))) != null)
		{
			if (ini_kv.Length != 2) // forgot if root key/values are even allowed by winapi
				throw new TypeLoadException("INI section/key specifier is invalid in this current setting");
			Launcher.cfgW(ini_kv[0], ini_kv[1], value.ToString());
			return;
		}
		settings.sQC(QbKey.Create(nonunique+name), value);
	}
	void setConfColor(object s, EventArgs e)
	{
		coldiag.Color = (s as Panel).BackColor;
		if (coldiag.ShowDialog() == DialogResult.OK)
		{
			(s as Panel).BackColor = coldiag.Color;
			setParamValue(s, e);
		}
	}

	public modcfg(QbItemStructArray _params, string nonunique)
	{
		InitializeComponent();
		Font font = new Font("Microsoft Sans Serif", 11.25f, GraphicsUnit.Point);
		int j = 0;
		this.nonunique = nonunique;
		foreach (QbItemStruct i in _params.Items)
		{
			/*QbItemString nonuniqueprefix = new QbItemString(i.Root);
			nonuniqueprefix.ItemQbKey = QbKey.Create("ununique"); // :P
			nonuniqueprefix.Create(QbItemType.StructItemStringW);
			nonuniqueprefix.Strings = new string[] { nonunique };
			i.AddItem(nonuniqueprefix);*/
			Panel newParam = new Panel() {
				Size = new Size(306, 44),
				Location = new Point(6, 4 + (j++ * 48)),
				Anchor = (AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top),
				Tag = i,
				//BackColor = Color.Gray
			};
			//i.FindItem(QbKey.Create("name"), false);
			string paramTitle = structString(i, QbKey.Create("name"));
			string[] kv_test;
			bool iniVal = false;
			if (iniVal = ((kv_test = (string[])getItem(i, QbKey.Create("ini"))) != null))
				paramTitle = kv_test[1];
			//string qname = paramTitle;
			//if (nonunique != "")
			//qname = nonunique + qname;
			Label paramName = new Label() {
				Font = font,
				Location = new Point(2,0),
				FlatStyle = FlatStyle.System,
				Text = paramTitle,
				AutoSize = true
			};
			Label helpCtrl;
			QbKey desc = QbKey.Create("desc");
			if (getItem(i, desc) != null)
			{
				string desctext = structString(i, desc);
				if (desctext != "")
				{
					helpCtrl = new Label()
					{
						Font = font,
						Location = new Point(248, 1),
						FlatStyle = FlatStyle.System,
						Text = "?",
						AutoSize = true,
						Cursor = Cursors.Help
					};
					tooltip.SetToolTip(helpCtrl, desctext);
					newParam.Controls.Add(helpCtrl);
				}
			}
			Button paramReset = new Button() {
				Location = new Point(264, 2),
				Size = new Size(40, 18),
				Anchor = AnchorStyles.Top | AnchorStyles.Right,
				FlatStyle = FlatStyle.System,
				Text = "Reset"
			};
			paramReset.Click += new EventHandler(resetParam);
			Control paramCtrl;
			uint ctrlType = 0;
			if (getItem(i, QbKey.Create("type")) != null)
				ctrlType = ((QbKey)getItem(i, QbKey.Create("type"))).Crc;
			QbItemBase defaultItem = (i.FindItem(QbKey.Create("default"), false));
			object def = moddiag.getItemObject(defaultItem);
			object setordef;
			if (iniVal)
				setordef = settings.gQC(QbKey.Create(nonunique + paramTitle), def);
			else
			{
				setordef = Launcher.cfg(kv_test[0], kv_test[1], null);
				if (kv_test.Length != 2)
				{
					defaultItem = null;
					ctrlType = 0; // :(
				}
				if (string.IsNullOrEmpty((string)setordef)) // ^ i think null is getting treated as ""
					setordef = def;
			}
			switch (ctrlType)
			{
				// uses int
				case 0xAA7EC96D: // bool
				case 0x8C79023A: // bool3
					if (setordef == null)
						setordef = 0;
					if (iniVal)
						setordef = Convert.ToInt32(setordef);
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
						CheckState = (CheckState)Enum.Parse(typeof(CheckState), Convert.ToString(setordef)), // unironically die
						Name = paramTitle
					};
					(paramCtrl as CheckBox).CheckStateChanged += new EventHandler(setParamValue);
					newParam.Height -= 4;
					break;
				case 0x3038EFF8: // slider
					if (setordef == null)
						setordef = 0;
					if (iniVal)
						setordef = Convert.ToInt32(setordef);
					paramCtrl = new TrackBar()
					{
						Location = new Point(2, 20),
						Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right,
						Width = 220,
						Maximum = structInt(i, QbKey.Create("max")),
						Minimum = structInt(i, QbKey.Create("min")),
						Value = (int)setordef,
						Name = paramTitle
					};
					(paramCtrl as TrackBar).ValueChanged += new EventHandler(setParamValue);
					Label trackbarText = new Label()
					{
						Font = font,
						Location = new Point(paramCtrl.Width + 5, 23),
						FlatStyle = FlatStyle.System,
						Text = setordef.ToString(),
						AutoSize = true,
						Name = paramTitle+"_disp"
					};
					newParam.Controls.Add(trackbarText);
					break;
				case 0x99A9B716: // color
					if (setordef == null)
						setordef = ColorToArray(Color.White);
					if (iniVal)
						setordef = uint.Parse((string)setordef, System.Globalization.NumberStyles.HexNumber); // to look proper and a recognizable format
					paramCtrl = new Panel()
					{
						Location = new Point(2, 22),
						Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right,
						Size = new Size(80,20),
						BorderStyle = BorderStyle.FixedSingle,
						BackColor = ColorFromArray((int[])setordef),
						Cursor = Cursors.Hand,
						Name = paramTitle
					};
					(paramCtrl as Panel).Click += new EventHandler(setConfColor);
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
									Text = (string)setordef,
									Name = paramTitle
								};
								(paramCtrl as TextBox).TextChanged += new EventHandler(setParamValue);
								break;
							case QbItemType.StructItemInteger:
								if (iniVal)
									setordef = Convert.ToInt32(setordef);
								paramCtrl = new NumericUpDown()
								{
									Location = new Point(2, 23),
									Width = 302,
									Maximum = structInt(i, QbKey.Create("max")),
									Minimum = structInt(i, QbKey.Create("min")),
									Value = (int)setordef,
									Name = paramTitle
								};
								(paramCtrl as NumericUpDown).ValueChanged += new EventHandler(setParamValue);
								break;
							case QbItemType.StructItemFloat:
								if (iniVal)
									setordef = Convert.ToSingle(setordef);
								paramCtrl = new NumericUpDown()
								{
									Location = new Point(2, 23),
									Width = 302,
									DecimalPlaces = 4,
									Maximum = Convert.ToDecimal(getItem(i, QbKey.Create("max"))), // to accept int/float ranges
									Minimum = Convert.ToDecimal(getItem(i, QbKey.Create("min"))), // in case of not explicit decimal
									Value = Convert.ToDecimal((float)setordef),
									Name = paramTitle
								};
								(paramCtrl as NumericUpDown).ValueChanged += new EventHandler(setParamValue);
								break;
							default:
								paramCtrl = new Label()
								{
									Location = new Point(2, 24),
									FlatStyle = FlatStyle.System,
									Text = "Unsupported/invalid type ("+defaultItem.QbItemType+")"
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
	public static Color ColorFromArray(int[] value)
	{
		return Color.FromArgb((value[0] << 16) | (value[1] << 8) | (value[2]) | (value[3] << 24));
	}
	public static int[] ColorToArray(Color value)
	{
		return new int[] { value.R, value.G, value.B, value.A };
	}
}
