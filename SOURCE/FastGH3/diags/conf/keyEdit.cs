using System.Windows.Forms;
using System.Drawing;

using System;
using System.IO;

public enum ControlID
{
	Green,
	Red,
	Yellow,
	Blue,
	Orange,
	Star,
	Cancel,
	Start,
	Unk1, // pauses game
	Down,
	Up,
	Unk2,
	Whammy,
	Unb
}
public struct Key
{
	public Point p;
	public Size s;
	public Keys k;
	//public KeyID ctrl;
	public ushort c;
	public string n;
}
public partial class keyEdit : Form
{
	public ushort[] kBinds = settings.keyBinds;
	/*public int[] kBinds = new int[] {
		(int)KeyID.D1,
		(int)KeyID.D2,
		(int)KeyID.D3,
		(int)KeyID.D4,
		(int)KeyID.D5,
		(int)KeyID.RShift,
		(int)KeyID.Escape,
		(int)KeyID.Back,
		235,
		(int)KeyID.Down,
		(int)KeyID.Up,
		(int)KeyID.BkSlash,
		(int)KeyID.RCtrl,
	};*/

	ControlID c = ControlID.Unb;
	private void bB(object sender, System.EventArgs e)
	{
		selBtnL.Visible = true;
		cBtnL.Text = cNames((int)(sender as Button).Tag);
		cBtnL.Visible = true;
		c = (ControlID)(sender as Button).Tag;
	}
	private void eB(object sender, System.EventArgs e)
	{
		if (c != ControlID.Unb)
		{
			selBtnL.Visible = false;
			cBtnL.Visible = false;
			Button btn = sender as Button;
			kBinds[(int)c] = kt[(int)btn.Tag].c;
			uK();
			c = ControlID.Unb;
		}
	}

	/* *const int dbw = 22; // default button sizes
	const int dbh = 22;
	static int[] rows = new int[] {
		3,
		29,
		55,
		81,
		107,
		133
	};
	static Size dB = new Size(dbw, dbh); // lol/**/
	static Key[] kt = null;
	Button[] kBt;

	public static Color[] kCol = new Color[] {
		Color.SpringGreen,
		Color.Red,
		Color.Yellow,
		Color.Blue,
		Color.Orange,
		Color.Cyan,
		Color.Silver,
		Color.DarkGray,
		Color.Black,
		Color.DimGray,
		Color.DimGray,
		Color.LightGray,
		Color.White,
	};
	public static string cNames(int i)
	{
		return ((ControlID)i).ToString();
	}

	public void uK()
	{
		SuspendLayout();
		for (int i = 0; i < kBt.Length; i++)
		{
			Color newColor = SystemColors.Control;
			for (int j = 0; j < kBinds.Length; j++)
			{
				if (kt[i].c == kBinds[j])
				{
					newColor = kCol[j];
					continue;
				}
			}
			Color textColor = Color.Black;
			// SO 25426819
			if (newColor.R * 0.2126 + newColor.G * 0.7152 + newColor.B * 0.0722 < 255 / 2)
			{
				textColor = Color.White;
			}
			kBt[i].BackColor = newColor;
			kBt[i].ForeColor = textColor;
		}
		ResumeLayout(false);
		PerformLayout();
	}

	public keyEdit(ushort[] binds)
	{
		InitializeComponent();
		SuspendLayout(); // is this even working
		selBtnL.Text = Launcher.T[155];
		Text = Launcher.T[154];
		guitarPic.ImageLocation = Launcher.T[162];
		hintTxt.Text = Launcher.T[163];
		#if false // dump key list for optimization
		{
			Stream kl = File.Create("kl.bin");
			kl.Write(BitConverter.GetBytes((byte)kt.Length), 0, 1);
			for (int i = 0; i < kt.Length; i++)
			{
				kl.Write(BitConverter.GetBytes((byte)kt[i].k), 0, 1);
				kl.Write(BitConverter.GetBytes(kt[i].c), 0, 2);
				kl.Write(BitConverter.GetBytes((ushort)kt[i].p.X), 0, 2);
				kl.Write(BitConverter.GetBytes((ushort)kt[i].p.Y), 0, 2);
				kl.Write(BitConverter.GetBytes((ushort)kt[i].s.Width), 0, 2);
				kl.Write(BitConverter.GetBytes((ushort)kt[i].s.Height), 0, 2);
				kl.Write(BitConverter.GetBytes((byte)kt[i].n.Length), 0, 1);
				kl.Write(System.Text.Encoding.ASCII.GetBytes(kt[i].n), 0, kt[i].n.Length);
			}
			kl.Close();
		}
		#endif
		//if (true)
		if (kt == null)
		{
			var ks = new MemoryStream(Launcher.kl);
			BinaryReader kr = new BinaryReader(ks);
			byte kc = kr.ReadByte();
			kt = new Key[kc];
			for (int i = 0; i < kc; i++)
			{
				kt[i].k = (Keys)kr.ReadByte();
				kt[i].c = kr.ReadUInt16();
				kt[i].p.X = kr.ReadUInt16();
				kt[i].p.Y = kr.ReadUInt16();
				kt[i].s.Width = kr.ReadUInt16();
				kt[i].s.Height = kr.ReadUInt16();
				byte strlen = kr.ReadByte();
				byte[] buf = new byte[strlen];
				kt[i].n = System.Text.Encoding.ASCII.GetString(kr.ReadBytes(strlen));
			}
		}
		if (binds != null)
			kBinds = binds;
		Font fnt = new Font("Arial", 6.75f);
		kBt = new Button[kt.Length];
		for (int i = 0; i < kt.Length; i++)
		{
			kBt[i] = new Button()
			{
				Location = kt[i].p,
				Size = kt[i].s,
				Text = kt[i].n,
				Tag = i,
				Font = fnt,
				Margin = new Padding(0),
				Padding = new Padding(0),
				//FlatStyle = FlatStyle.System,
			};
			kBt[i].Click += eB;
			keylayout.Controls.Add(kBt[i]);
		}
		ResumeLayout(false);
		PerformLayout();
		uK();
	}
}
