using System.Windows.Forms;
using System.Drawing;

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
	Unknown1, // pauses game
	Down,
	Up,
	Unknown2,
	Whammy,
	Unbound
}
public enum KeyID
{
	Escape = 999,
	None = 998, // KeyboardBinds array prefilled out with this before runtime
	F1 = 237,
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	PrScr = 321,
	ScrLck = 314,
	Pause = 298,
	Tilda = 253,
	D1 = 201,
	D2,
	D3,
	D4,
	D5,
	D6,
	D7,
	D8,
	D9,
	D0 = 200,
	Sign = 273,
	Equal = 234,
	Back = 219,
	Ins = 257,
	Home = 255,
	PgUp = 303,
	NumLock = 281,
	NumSls = 230,
	NumAst = 274,
	NumDas = 320,
	Tab = 323,
	Q = 304,
	W = 331,
	E = 232,
	R = 305,
	T = 322,
	Y = 341,
	U = 324,
	I = 256,
	O = 295,
	P = 297,
	BrackL = 263,
	BrackR = 306,
	BkSlash = 220,
	Delete = 229,
	End = 233,
	PgDn = 278,
	Num7 = 289,
	Num8 = 290,
	Num9 = 291,
	NumPlus = 213,
	Caps = 223,
	A = 210,
	S = 313,
	D = 227,
	F = 236,
	G = 252,
	H = 254,
	J = 258,
	K = 259,
	L = 262,
	SColon = 345,
	DQuote = 214,
	Enter = 308,
	Num4 = 286,
	Num5,
	Num6,
	LShift = 267,
	Z = 343,
	X = 340,
	C = 221,
	V = 328,
	B = 218,
	N = 277,
	M = 269,
	Comma = 225,
	Period = 299,
	QMark = 316,
	RShift = 311,
	Num1 = 283,
	Num2,
	Num3,
	NumEnt = 293,
	LCtrl = 264,
	LAlt = 266,
	Space = 318,
	RAlt = 310,
	RCtrl = 307,
	Left = 265,
	Up = 401, // same id as mouse buttons, what are the arrow keys?
	Down = 400,
	Right = 309,
	Num0 = 282,
	NumDel = 228,
	Mouse0 = 400,
	Mouse1 = 401,
	Mouse2 = 402,
}

public struct KeyLayout
{
	public Point pos;
	public Size size;
	public Keys key;
	public KeyID control;
	public string name;
}

public partial class keyEdit : Form
{
	public int[] keyBinds = new int[] {
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
	};

	ControlID currentControl = ControlID.Unbound;
	private void beginBind(object sender, System.EventArgs e)
	{
		selectedButtonTxt.Visible = true;
		currentButtonTxt.Text = controlNames[(int)(sender as Button).Tag];
		currentButtonTxt.Visible = true;
		currentControl = (ControlID)(sender as Button).Tag;
	}
	private void endBind(object sender, System.EventArgs e)
	{
		if (currentControl != ControlID.Unbound)
		{
			selectedButtonTxt.Visible = false;
			currentButtonTxt.Visible = false;
			Button btn = sender as Button;
			keyBinds[(int)currentControl] = (int)keytable[(int)btn.Tag].control;
			updateKeys();
			currentControl = ControlID.Unbound;
		}
	}

	const int defaultButtonWidth = 22;
	const int defaultButtonHeight = 22;
	static int[] buttonRows = new int[] {
		3,
		29,
		55,
		81,
		107,
		133
	};
	static Size defaultButtonSize = new Size(defaultButtonWidth, defaultButtonHeight);
	#region keytable
	static KeyLayout[] keytable = new KeyLayout[]
	{
		new KeyLayout() {
			pos = new Point(3, buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.Escape,
			control = KeyID.Escape,
			name = "Es"
		}, new KeyLayout() {
			pos = new Point(3+(23*2), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F1,
			control = KeyID.F1,
			name = "F1"
		}, new KeyLayout() {
			pos = new Point(3+(23*3), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F2,
			control = KeyID.F2,
			name = "F2"
		}, new KeyLayout() {
			pos = new Point(3+(23*4), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F3,
			control = KeyID.F3,
			name = "F3"
		}, new KeyLayout() {
			pos = new Point(3+(23*5), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F4,
			control = KeyID.F4,
			name = "F4"
		}, new KeyLayout() {
			pos = new Point(3+(23*7), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F5,
			control = KeyID.F5,
			name = "F5"
		}, new KeyLayout() {
			pos = new Point(3+(23*8), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F6,
			control = KeyID.F6,
			name = "F6"
		}, new KeyLayout() {
			pos = new Point(3+(23*9), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F7,
			control = KeyID.F7,
			name = "F7"
		}, new KeyLayout() {
			pos = new Point(3+(23*10), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F8,
			control = KeyID.F8,
			name = "F8"
		}, new KeyLayout() {
			pos = new Point(3+(23*12), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.F9,
			control = KeyID.F9,
			name = "F9"
		}, /*new KeyLayout() {
			pos = new Point(3+(23*13), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.LButton,
			control = KeyID.Escape,
			name = "10"
		}, new KeyLayout() {
			pos = new Point(3+(23*14), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.LButton,
			control = KeyID.Escape,
			name = "11"
		}, new KeyLayout() {
			pos = new Point(3+(23*15), buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.LButton,
			control = KeyID.Escape,
			name = "12"
		},*/ new KeyLayout() {
			pos = new Point(376, buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.PrintScreen,
			control = KeyID.PrScr,
			name = "Pr"
		}, new KeyLayout() {
			pos = new Point(399, buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.Scroll,
			control = KeyID.ScrLck,
			name = "Sc"
		}, new KeyLayout() {
			pos = new Point(422, buttonRows[0]),
			size = defaultButtonSize,
			key = Keys.Pause,
			control = KeyID.Pause,
			name = "Br"
		}, new KeyLayout() {
			pos = new Point(3, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.Oemtilde,
			control = KeyID.Tilda,
			name = "~"
		}, new KeyLayout() {
			pos = new Point(3+(23*1), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D1,
			control = KeyID.D1,
			name = "1"
		}, new KeyLayout() {
			pos = new Point(3+(23*2), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D2,
			control = KeyID.D2,
			name = "2"
		}, new KeyLayout() {
			pos = new Point(3+(23*3), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D3,
			control = KeyID.D3,
			name = "3"
		}, new KeyLayout() {
			pos = new Point(3+(23*4), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D4,
			control = KeyID.D4,
			name = "4"
		}, new KeyLayout() {
			pos = new Point(3+(23*5), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D5,
			control = KeyID.D5,
			name = "5"
		}, new KeyLayout() {
			pos = new Point(3+(23*6), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D6,
			control = KeyID.D6,
			name = "6"
		}, new KeyLayout() {
			pos = new Point(3+(23*7), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D7,
			control = KeyID.D7,
			name = "7"
		}, new KeyLayout() {
			pos = new Point(3+(23*8), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D8,
			control = KeyID.D8,
			name = "8"
		}, new KeyLayout() {
			pos = new Point(3+(23*9), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D9,
			control = KeyID.D9,
			name = "9"
		}, new KeyLayout() {
			pos = new Point(3+(23*10), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.D0,
			control = KeyID.D0,
			name = "0"
		}, new KeyLayout() {
			pos = new Point(3+(23*11), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.OemMinus,
			control = KeyID.Sign,
			name = "_"
		}, new KeyLayout() {
			pos = new Point(3+(23*12), buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.Oemplus,
			control = KeyID.Equal,
			name = "+"
		}, new KeyLayout() {
			pos = new Point(3+(23*13), buttonRows[1]),
			size = new Size(68, defaultButtonHeight),
			key = Keys.Back,
			control = KeyID.Back,
			name = "Backspace"
		}, new KeyLayout() {
			pos = new Point(376, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.Insert,
			control = KeyID.Ins,
			name = "In"
		}, new KeyLayout() {
			pos = new Point(399, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.Home,
			control = KeyID.Home,
			name = "H"
		}, new KeyLayout() {
			pos = new Point(422, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.PageUp,
			control = KeyID.PgUp,
			name = "U"
		}, new KeyLayout() {
			pos = new Point(376, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.Delete,
			control = KeyID.Delete,
			name = "Dl"
		}, new KeyLayout() {
			pos = new Point(399, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.End,
			control = KeyID.End,
			name = "E"
		}, new KeyLayout() {
			pos = new Point(422, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.PageDown,
			control = KeyID.PgDn,
			name = "D"
		}, new KeyLayout() {
			pos = new Point(3, buttonRows[2]),
			size = new Size(37, defaultButtonHeight),
			key = Keys.Tab,
			control = KeyID.Tab,
			name = "Tab"
		}, new KeyLayout() {
			pos = new Point(43, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.Q,
			control = KeyID.Q,
			name = "Q"
		}, new KeyLayout() {
			pos = new Point(66, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.W,
			control = KeyID.W,
			name = "W"
		}, new KeyLayout() {
			pos = new Point(89, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.E,
			control = KeyID.E,
			name = "E"
		}, new KeyLayout() {
			pos = new Point(112, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.R,
			control = KeyID.R,
			name = "R"
		}, new KeyLayout() {
			pos = new Point(135, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.T,
			control = KeyID.T,
			name = "T"
		}, new KeyLayout() {
			pos = new Point(158, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.Y,
			control = KeyID.Y,
			name = "Y"
		}, new KeyLayout() {
			pos = new Point(181, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.U,
			control = KeyID.U,
			name = "U"
		}, new KeyLayout() {
			pos = new Point(204, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.I,
			control = KeyID.I,
			name = "I"
		}, new KeyLayout() {
			pos = new Point(227, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.O,
			control = KeyID.O,
			name = "O"
		}, new KeyLayout() {
			pos = new Point(250, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.P,
			control = KeyID.P,
			name = "P"
		}, new KeyLayout() {
			pos = new Point(273, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.OemOpenBrackets,
			control = KeyID.BrackL,
			name = "["
		}, new KeyLayout() {
			pos = new Point(296, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.OemCloseBrackets,
			control = KeyID.BrackR,
			name = "]"
		}, new KeyLayout() {
			pos = new Point(320, buttonRows[2]),
			size = new Size(50, defaultButtonHeight),
			key = Keys.OemBackslash,
			control = KeyID.BkSlash,
			name = "\\"
		}, new KeyLayout() {
			pos = new Point(3, buttonRows[3]),
			size = new Size(44, defaultButtonHeight),
			key = Keys.CapsLock,
			control = KeyID.Caps,
			name = "CapsLk"
		}, new KeyLayout() {
			pos = new Point(50, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.A,
			control = KeyID.A,
			name = "A"
		}, new KeyLayout() {
			pos = new Point(73, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.S,
			control = KeyID.S,
			name = "S"
		}, new KeyLayout() {
			pos = new Point(96, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.D,
			control = KeyID.D,
			name = "D"
		}, new KeyLayout() {
			pos = new Point(119, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.F,
			control = KeyID.F,
			name = "F"
		}, new KeyLayout() {
			pos = new Point(142, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.G,
			control = KeyID.G,
			name = "G"
		}, new KeyLayout() {
			pos = new Point(165, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.H,
			control = KeyID.H,
			name = "H"
		}, new KeyLayout() {
			pos = new Point(188, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.J,
			control = KeyID.J,
			name = "J"
		}, new KeyLayout() {
			pos = new Point(211, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.K,
			control = KeyID.K,
			name = "K"
		}, new KeyLayout() {
			pos = new Point(234, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.L,
			control = KeyID.L,
			name = "L"
		}, new KeyLayout() {
			pos = new Point(257, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.OemSemicolon,
			control = KeyID.SColon,
			name = ":"
		}, new KeyLayout() {
			pos = new Point(280, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.OemQuotes,
			control = KeyID.DQuote,
			name = "\""
		}, new KeyLayout() {
			pos = new Point(304, buttonRows[3]),
			size = new Size(66, defaultButtonHeight),
			key = Keys.Enter,
			control = KeyID.Enter,
			name = "Enter"
		}, new KeyLayout() {
			pos = new Point(3, buttonRows[4]),
			size = new Size(61, defaultButtonHeight),
			key = Keys.LShiftKey,
			control = KeyID.LShift,
			name = "Shift"
		}, new KeyLayout() {
			pos = new Point(66, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.Z,
			control = KeyID.Z,
			name = "Z"
		}, new KeyLayout() {
			pos = new Point(89, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.X,
			control = KeyID.X,
			name = "X"
		}, new KeyLayout() {
			pos = new Point(112, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.C,
			control = KeyID.C,
			name = "C"
		}, new KeyLayout() {
			pos = new Point(135, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.V,
			control = KeyID.V,
			name = "V"
		}, new KeyLayout() {
			pos = new Point(158, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.B,
			control = KeyID.B,
			name = "B"
		}, new KeyLayout() {
			pos = new Point(181, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.N,
			control = KeyID.N,
			name = "N"
		}, new KeyLayout() {
			pos = new Point(204, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.M,
			control = KeyID.M,
			name = "M"
		}, new KeyLayout() {
			pos = new Point(227, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.Oemcomma,
			control = KeyID.Comma,
			name = "<"
		}, new KeyLayout() {
			pos = new Point(250, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.OemPeriod,
			control = KeyID.Period,
			name = ">"
		}, new KeyLayout() {
			pos = new Point(273, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.OemQuestion,
			control = KeyID.QMark,
			name = "?"
		}, new KeyLayout() {
			pos = new Point(297, buttonRows[4]),
			size = new Size(73, defaultButtonHeight),
			key = Keys.RShiftKey,
			control = KeyID.RShift,
			name = "Shift"
		}, new KeyLayout() {
			pos = new Point(3, buttonRows[5]),
			size = new Size(29, defaultButtonHeight),
			key = Keys.LControlKey,
			control = KeyID.LCtrl,
			name = "Ctrl"
		}, /*new KeyLayout() {
			pos = new Point(66, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.LWin,
			control = KeyID.Win,
			name = "Win"
		},*/ new KeyLayout() {
			pos = new Point(66, buttonRows[5]),
			size = new Size(29, defaultButtonHeight),
			key = Keys.LMenu,
			control = KeyID.LAlt,
			name = "Alt"
		}, new KeyLayout() {
			pos = new Point(97, buttonRows[5]),
			size = new Size(139, defaultButtonHeight),
			key = Keys.Space,
			control = KeyID.Space,
			name = ""
		}, new KeyLayout() {
			pos = new Point(239, buttonRows[5]),
			size = new Size(29, defaultButtonHeight),
			key = Keys.RMenu,
			control = KeyID.RAlt,
			name = "Alt"
		}, /*new KeyLayout() {
			pos = new Point(271, buttonRows[4]),
			size = new Size(29, defaultButtonHeight),
			key = Keys.B,
			control = KeyID.B,
			name = "B"
		}, new KeyLayout() {
			pos = new Point(303, buttonRows[4]),
			size = new Size(35, defaultButtonHeight),
			key = Keys.Menu,
			control = KeyID.Menu,
			name = "N"
		},*/ new KeyLayout() {
			pos = new Point(341, buttonRows[5]),
			size = new Size(29, defaultButtonHeight),
			key = Keys.RControlKey,
			control = KeyID.RCtrl,
			name = "Ctrl"
		}, new KeyLayout() {
			pos = new Point(399, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.Up,
			control = KeyID.Up,
			name = "↑"
		}, new KeyLayout() {
			pos = new Point(376, buttonRows[5]),
			size = defaultButtonSize,
			key = Keys.Left,
			control = KeyID.Left,
			name = "←"
		}, new KeyLayout() {
			pos = new Point(399, buttonRows[5]),
			size = defaultButtonSize,
			key = Keys.Down,
			control = KeyID.Down,
			name = "↓"
		}, new KeyLayout() {
			pos = new Point(422, buttonRows[5]),
			size = defaultButtonSize,
			key = Keys.Right,
			control = KeyID.Right,
			name = "→"
		}, new KeyLayout() {
			pos = new Point(449, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.NumLock,
			control = KeyID.NumLock,
			name = "nL"
		},/* new KeyLayout() {
			pos = new Point(449, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.Oem, // WHAT KEY IS THIS
			control = KeyID.NumSls,
			name = "nL"
		}, new KeyLayout() {
			pos = new Point(495, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.oem,
			control = KeyID.NumAst,
			name = "nL"
		},*/ new KeyLayout() {
			pos = new Point(449, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.NumPad7,
			control = KeyID.Num7,
			name = "7"
		}, new KeyLayout() {
			pos = new Point(472, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.NumPad8,
			control = KeyID.Num8,
			name = "8"
		}, new KeyLayout() {
			pos = new Point(495, buttonRows[2]),
			size = defaultButtonSize,
			key = Keys.NumPad9,
			control = KeyID.Num9,
			name = "9"
		}, new KeyLayout() {
			pos = new Point(449, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.NumPad4,
			control = KeyID.Num4,
			name = "4"
		}, new KeyLayout() {
			pos = new Point(472, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.NumPad5,
			control = KeyID.Num5,
			name = "5"
		}, new KeyLayout() {
			pos = new Point(495, buttonRows[3]),
			size = defaultButtonSize,
			key = Keys.NumPad6,
			control = KeyID.Num6,
			name = "6"
		}, new KeyLayout() {
			pos = new Point(449, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.NumPad1,
			control = KeyID.Num1,
			name = "1"
		}, new KeyLayout() {
			pos = new Point(472, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.NumPad2,
			control = KeyID.Num2,
			name = "2"
		}, new KeyLayout() {
			pos = new Point(495, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.NumPad3,
			control = KeyID.Num3,
			name = "3"
		}, new KeyLayout() {
			pos = new Point(449, buttonRows[5]),
			size = new Size(44, defaultButtonHeight),
			key = Keys.NumPad0,
			control = KeyID.Num0,
			name = "0"
		},
	};
	#endregion
	Button[] keyButtons = new Button[keytable.Length];

	public static Color[] keyColors = new Color[] {
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
	public static string[] controlNames = new string[] {
		"Green",
		"Red",
		"Yellow",
		"Blue",
		"Orange",
		"Select",
		"Cancel",
		"Start",
		"Unknown",
		"Down",
		"Up",
		"Unknown",
		"Whammy",
	};

	public void updateKeys()
	{
		this.SuspendLayout();
		for (int i = 0; i < keyButtons.Length; i++)
		{
			Color newColor = SystemColors.Control;
			for (int j = 0; j < keyBinds.Length; j++)
			{
				if (keytable[i].control == (KeyID)keyBinds[j])
				{
					newColor = keyColors[j];
					continue;
				}
			}
			Color textColor = Color.Black;
			// SO 25426819
			if (newColor.R * 0.2126 +
				newColor.G * 0.7152 +
				newColor.B * 0.0722 < 255 / 2)
			{
				textColor = Color.White;
			}
			keyButtons[i].BackColor = newColor;
			keyButtons[i].ForeColor = textColor;
		}
		this.ResumeLayout(false);
		this.PerformLayout();
	}

	public keyEdit(int[] binds)
	{
		if (binds != null)
			keyBinds = binds;
		InitializeComponent();
		this.SuspendLayout();
		Font fnt = new Font("Arial", 6.75f);
		for (int i = 0; i < keytable.Length; i++)
		{
			keyButtons[i] = new Button()
			{
				Location = keytable[i].pos,
				Size = keytable[i].size,
				Text = keytable[i].name,
				Tag = i,
				Font = fnt,
				Margin = new Padding(0),
				Padding = new Padding(0),
				//FlatStyle = FlatStyle.System,
			};
			keyButtons[i].Click += endBind;
			keylayout.Controls.Add(keyButtons[i]);
		}
		this.ResumeLayout(false);
		this.PerformLayout();
		updateKeys();
	}
}
