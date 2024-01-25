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
#region name bloat
/*public enum KeyID
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
	Up = 327, // thank you IMF for these numbers
	Down = 231,
	Right = 309,
	Num0 = 282,
	NumDel = 228,
	Mouse0 = 400,
	Mouse1 = 401,
	Mouse2 = 402,
}*/
#endregion

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
	public ushort[] kBinds = new ushort[] {
		201,
		202,
		203,
		204,
		205,
		311,
		999,
		219,
		235,
		400,
		401,
		220,
		307,
	};
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

	/**const int dbw = 22; // default button sizes
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
	#region keytable (bloat)
	/**static Key[] kt = new Key[]
	{
		new Key() {
			pos = new Point(3, rows[0]),
			size = dB,
			key = Keys.Escape,
			ctrl = KeyID.Escape,
			name = "Es"
		}, new Key() {
			pos = new Point(3+(23*2), rows[0]),
			size = dB,
			key = Keys.F1,
			ctrl = KeyID.F1,
			name = "F1"
		}, new Key() {
			pos = new Point(3+(23*3), rows[0]),
			size = dB,
			key = Keys.F2,
			ctrl = KeyID.F2,
			name = "F2"
		}, new Key() {
			pos = new Point(3+(23*4), rows[0]),
			size = dB,
			key = Keys.F3,
			ctrl = KeyID.F3,
			name = "F3"
		}, new Key() {
			pos = new Point(3+(23*5), rows[0]),
			size = dB,
			key = Keys.F4,
			ctrl = KeyID.F4,
			name = "F4"
		}, new Key() {
			pos = new Point(3+(23*7), rows[0]),
			size = dB,
			key = Keys.F5,
			ctrl = KeyID.F5,
			name = "F5"
		}, new Key() {
			pos = new Point(3+(23*8), rows[0]),
			size = dB,
			key = Keys.F6,
			ctrl = KeyID.F6,
			name = "F6"
		}, new Key() {
			pos = new Point(3+(23*9), rows[0]),
			size = dB,
			key = Keys.F7,
			ctrl = KeyID.F7,
			name = "F7"
		}, new Key() {
			pos = new Point(3+(23*10), rows[0]),
			size = dB,
			key = Keys.F8,
			ctrl = KeyID.F8,
			name = "F8"
		}, new Key() {
			pos = new Point(3+(23*12), rows[0]),
			size = dB,
			key = Keys.F9,
			ctrl = KeyID.F9,
			name = "F9"
		}, new Key() {
			pos = new Point(376, rows[0]),
			size = dB,
			key = Keys.PrintScreen,
			ctrl = KeyID.PrScr,
			name = "Pr"
		}, new Key() {
			pos = new Point(399, rows[0]),
			size = dB,
			key = Keys.Scroll,
			ctrl = KeyID.ScrLck,
			name = "Sc"
		}, new Key() {
			pos = new Point(422, rows[0]),
			size = dB,
			key = Keys.Pause,
			ctrl = KeyID.Pause,
			name = "Br"
		}, new Key() {
			pos = new Point(472, rows[0]),
			size = dB,
			key = Keys.LButton,
			ctrl = KeyID.Mouse0,
			name = "L"
		}, new Key() {
			pos = new Point(472+23+23, rows[0]),
			size = dB,
			key = Keys.RButton,
			ctrl = KeyID.Mouse1,
			name = "R"
		}, new Key() {
			pos = new Point(472+23, rows[0]),
			size = dB,
			key = Keys.MButton,
			ctrl = KeyID.Mouse2,
			name = "M"
		}, new Key() {
			pos = new Point(3, rows[1]),
			size = dB,
			key = Keys.Oemtilde,
			ctrl = KeyID.Tilda,
			name = "~"
		}, new Key() {
			pos = new Point(3+(23*1), rows[1]),
			size = dB,
			key = Keys.D1,
			ctrl = KeyID.D1,
			name = "1"
		}, new Key() {
			pos = new Point(3+(23*2), rows[1]),
			size = dB,
			key = Keys.D2,
			ctrl = KeyID.D2,
			name = "2"
		}, new Key() {
			pos = new Point(3+(23*3), rows[1]),
			size = dB,
			key = Keys.D3,
			ctrl = KeyID.D3,
			name = "3"
		}, new Key() {
			pos = new Point(3+(23*4), rows[1]),
			size = dB,
			key = Keys.D4,
			ctrl = KeyID.D4,
			name = "4"
		}, new Key() {
			pos = new Point(3+(23*5), rows[1]),
			size = dB,
			key = Keys.D5,
			ctrl = KeyID.D5,
			name = "5"
		}, new Key() {
			pos = new Point(3+(23*6), rows[1]),
			size = dB,
			key = Keys.D6,
			ctrl = KeyID.D6,
			name = "6"
		}, new Key() {
			pos = new Point(3+(23*7), rows[1]),
			size = dB,
			key = Keys.D7,
			ctrl = KeyID.D7,
			name = "7"
		}, new Key() {
			pos = new Point(3+(23*8), rows[1]),
			size = dB,
			key = Keys.D8,
			ctrl = KeyID.D8,
			name = "8"
		}, new Key() {
			pos = new Point(3+(23*9), rows[1]),
			size = dB,
			key = Keys.D9,
			ctrl = KeyID.D9,
			name = "9"
		}, new Key() {
			pos = new Point(3+(23*10), rows[1]),
			size = dB,
			key = Keys.D0,
			ctrl = KeyID.D0,
			name = "0"
		}, new Key() {
			pos = new Point(3+(23*11), rows[1]),
			size = dB,
			key = Keys.OemMinus,
			ctrl = KeyID.Sign,
			name = "_"
		}, new Key() {
			pos = new Point(3+(23*12), rows[1]),
			size = dB,
			key = Keys.Oemplus,
			ctrl = KeyID.Equal,
			name = "+"
		}, new Key() {
			pos = new Point(3+(23*13), rows[1]),
			size = new Size(68, dbh),
			key = Keys.Back,
			ctrl = KeyID.Back,
			name = "Backspace"
		}, new Key() {
			pos = new Point(376, rows[1]),
			size = dB,
			key = Keys.Insert,
			ctrl = KeyID.Ins,
			name = "In"
		}, new Key() {
			pos = new Point(399, rows[1]),
			size = dB,
			key = Keys.Home,
			ctrl = KeyID.Home,
			name = "H"
		}, new Key() {
			pos = new Point(422, rows[1]),
			size = dB,
			key = Keys.PageUp,
			ctrl = KeyID.PgUp,
			name = "U"
		}, new Key() {
			pos = new Point(376, rows[2]),
			size = dB,
			key = Keys.Delete,
			ctrl = KeyID.Delete,
			name = "Dl"
		}, new Key() {
			pos = new Point(399, rows[2]),
			size = dB,
			key = Keys.End,
			ctrl = KeyID.End,
			name = "E"
		}, new Key() {
			pos = new Point(422, rows[2]),
			size = dB,
			key = Keys.PageDown,
			ctrl = KeyID.PgDn,
			name = "D"
		}, new Key() {
			pos = new Point(3, rows[2]),
			size = new Size(37, dbh),
			key = Keys.Tab,
			ctrl = KeyID.Tab,
			name = "Tab"
		}, new Key() {
			pos = new Point(43, rows[2]),
			size = dB,
			key = Keys.Q,
			ctrl = KeyID.Q,
			name = "Q"
		}, new Key() {
			pos = new Point(66, rows[2]),
			size = dB,
			key = Keys.W,
			ctrl = KeyID.W,
			name = "W"
		}, new Key() {
			pos = new Point(89, rows[2]),
			size = dB,
			key = Keys.E,
			ctrl = KeyID.E,
			name = "E"
		}, new Key() {
			pos = new Point(112, rows[2]),
			size = dB,
			key = Keys.R,
			ctrl = KeyID.R,
			name = "R"
		}, new Key() {
			pos = new Point(135, rows[2]),
			size = dB,
			key = Keys.T,
			ctrl = KeyID.T,
			name = "T"
		}, new Key() {
			pos = new Point(158, rows[2]),
			size = dB,
			key = Keys.Y,
			ctrl = KeyID.Y,
			name = "Y"
		}, new Key() {
			pos = new Point(181, rows[2]),
			size = dB,
			key = Keys.U,
			ctrl = KeyID.U,
			name = "U"
		}, new Key() {
			pos = new Point(204, rows[2]),
			size = dB,
			key = Keys.I,
			ctrl = KeyID.I,
			name = "I"
		}, new Key() {
			pos = new Point(227, rows[2]),
			size = dB,
			key = Keys.O,
			ctrl = KeyID.O,
			name = "O"
		}, new Key() {
			pos = new Point(250, rows[2]),
			size = dB,
			key = Keys.P,
			ctrl = KeyID.P,
			name = "P"
		}, new Key() {
			pos = new Point(273, rows[2]),
			size = dB,
			key = Keys.OemOpenBrackets,
			ctrl = KeyID.BrackL,
			name = "["
		}, new Key() {
			pos = new Point(296, rows[2]),
			size = dB,
			key = Keys.OemCloseBrackets,
			ctrl = KeyID.BrackR,
			name = "]"
		}, new Key() {
			pos = new Point(320, rows[2]),
			size = new Size(50, dbh),
			key = Keys.OemBackslash,
			ctrl = KeyID.BkSlash,
			name = "\\"
		}, new Key() {
			pos = new Point(3, rows[3]),
			size = new Size(44, dbh),
			key = Keys.CapsLock,
			ctrl = KeyID.Caps,
			name = "CapsLk"
		}, new Key() {
			pos = new Point(50, rows[3]),
			size = dB,
			key = Keys.A,
			ctrl = KeyID.A,
			name = "A"
		}, new Key() {
			pos = new Point(73, rows[3]),
			size = dB,
			key = Keys.S,
			ctrl = KeyID.S,
			name = "S"
		}, new Key() {
			pos = new Point(96, rows[3]),
			size = dB,
			key = Keys.D,
			ctrl = KeyID.D,
			name = "D"
		}, new Key() {
			pos = new Point(119, rows[3]),
			size = dB,
			key = Keys.F,
			ctrl = KeyID.F,
			name = "F"
		}, new Key() {
			pos = new Point(142, rows[3]),
			size = dB,
			key = Keys.G,
			ctrl = KeyID.G,
			name = "G"
		}, new Key() {
			pos = new Point(165, rows[3]),
			size = dB,
			key = Keys.H,
			ctrl = KeyID.H,
			name = "H"
		}, new Key() {
			pos = new Point(188, rows[3]),
			size = dB,
			key = Keys.J,
			ctrl = KeyID.J,
			name = "J"
		}, new Key() {
			pos = new Point(211, rows[3]),
			size = dB,
			key = Keys.K,
			ctrl = KeyID.K,
			name = "K"
		}, new Key() {
			pos = new Point(234, rows[3]),
			size = dB,
			key = Keys.L,
			ctrl = KeyID.L,
			name = "L"
		}, new Key() {
			pos = new Point(257, rows[3]),
			size = dB,
			key = Keys.OemSemicolon,
			ctrl = KeyID.SColon,
			name = ":"
		}, new Key() {
			pos = new Point(280, rows[3]),
			size = dB,
			key = Keys.OemQuotes,
			ctrl = KeyID.DQuote,
			name = "\""
		}, new Key() {
			pos = new Point(304, rows[3]),
			size = new Size(66, dbh),
			key = Keys.Enter,
			ctrl = KeyID.Enter,
			name = "Enter"
		}, new Key() {
			pos = new Point(3, rows[4]),
			size = new Size(61, dbh),
			key = Keys.LShiftKey,
			ctrl = KeyID.LShift,
			name = "Shift"
		}, new Key() {
			pos = new Point(66, rows[4]),
			size = dB,
			key = Keys.Z,
			ctrl = KeyID.Z,
			name = "Z"
		}, new Key() {
			pos = new Point(89, rows[4]),
			size = dB,
			key = Keys.X,
			ctrl = KeyID.X,
			name = "X"
		}, new Key() {
			pos = new Point(112, rows[4]),
			size = dB,
			key = Keys.C,
			ctrl = KeyID.C,
			name = "C"
		}, new Key() {
			pos = new Point(135, rows[4]),
			size = dB,
			key = Keys.V,
			ctrl = KeyID.V,
			name = "V"
		}, new Key() {
			pos = new Point(158, rows[4]),
			size = dB,
			key = Keys.B,
			ctrl = KeyID.B,
			name = "B"
		}, new Key() {
			pos = new Point(181, rows[4]),
			size = dB,
			key = Keys.N,
			ctrl = KeyID.N,
			name = "N"
		}, new Key() {
			pos = new Point(204, rows[4]),
			size = dB,
			key = Keys.M,
			ctrl = KeyID.M,
			name = "M"
		}, new Key() {
			pos = new Point(227, rows[4]),
			size = dB,
			key = Keys.Oemcomma,
			ctrl = KeyID.Comma,
			name = "<"
		}, new Key() {
			pos = new Point(250, rows[4]),
			size = dB,
			key = Keys.OemPeriod,
			ctrl = KeyID.Period,
			name = ">"
		}, new Key() {
			pos = new Point(273, rows[4]),
			size = dB,
			key = Keys.OemQuestion,
			ctrl = KeyID.QMark,
			name = "?"
		}, new Key() {
			pos = new Point(297, rows[4]),
			size = new Size(73, dbh),
			key = Keys.RShiftKey,
			ctrl = KeyID.RShift,
			name = "Shift"
		}, new Key() {
			pos = new Point(3, rows[5]),
			size = new Size(29, dbh),
			key = Keys.LControlKey,
			ctrl = KeyID.LCtrl,
			name = "Ctrl"
		}, new Key() {
			pos = new Point(66, rows[5]),
			size = new Size(29, dbh),
			key = Keys.LMenu,
			ctrl = KeyID.LAlt,
			name = "Alt"
		}, new Key() {
			pos = new Point(97, rows[5]),
			size = new Size(139, dbh),
			key = Keys.Space,
			ctrl = KeyID.Space,
			name = ""
		}, new Key() {
			pos = new Point(239, rows[5]),
			size = new Size(29, dbh),
			key = Keys.RMenu,
			ctrl = KeyID.RAlt,
			name = "Alt"
		}, new Key() {
			pos = new Point(341, rows[5]),
			size = new Size(29, dbh),
			key = Keys.RControlKey,
			ctrl = KeyID.RCtrl,
			name = "Ctrl"
		}, new Key() {
			pos = new Point(399, rows[4]),
			size = dB,
			key = Keys.Up,
			ctrl = KeyID.Up,
			name = "U"//"↑"
		}, new Key() {
			pos = new Point(376, rows[5]),
			size = dB,
			key = Keys.Left,
			ctrl = KeyID.Left,
			name = "L"//"←"
		}, new Key() {
			pos = new Point(399, rows[5]),
			size = dB,
			key = Keys.Down,
			ctrl = KeyID.Down,
			name = "D"//"↓"
		}, new Key() {
			pos = new Point(422, rows[5]),
			size = dB,
			key = Keys.Right,
			ctrl = KeyID.Right,
			name = "R"//"→"
		}, new Key() {
			pos = new Point(449, rows[1]),
			size = dB,
			key = Keys.NumLock,
			ctrl = KeyID.NumLock,
			name = "nL"
		}, new Key() {
			pos = new Point(449, rows[2]),
			size = dB,
			key = Keys.NumPad7,
			ctrl = KeyID.Num7,
			name = "7"
		}, new Key() {
			pos = new Point(495, rows[5]),
			size = dB,
			key = Keys.OemPeriod,
			ctrl = KeyID.NumDel,
			name = "."
		}, new Key() {
			pos = new Point(472, rows[2]),
			size = dB,
			key = Keys.NumPad8,
			ctrl = KeyID.Num8,
			name = "8"
		}, new Key() {
			pos = new Point(495, rows[2]),
			size = dB,
			key = Keys.NumPad9,
			ctrl = KeyID.Num9,
			name = "9"
		}, new Key() {
			pos = new Point(449, rows[3]),
			size = dB,
			key = Keys.NumPad4,
			ctrl = KeyID.Num4,
			name = "4"
		}, new Key() {
			pos = new Point(472, rows[3]),
			size = dB,
			key = Keys.NumPad5,
			ctrl = KeyID.Num5,
			name = "5"
		}, new Key() {
			pos = new Point(495, rows[3]),
			size = dB,
			key = Keys.NumPad6,
			ctrl = KeyID.Num6,
			name = "6"
		}, new Key() {
			pos = new Point(449, rows[4]),
			size = dB,
			key = Keys.NumPad1,
			ctrl = KeyID.Num1,
			name = "1"
		}, new Key() {
			pos = new Point(472, rows[4]),
			size = dB,
			key = Keys.NumPad2,
			ctrl = KeyID.Num2,
			name = "2"
		}, new Key() {
			pos = new Point(495, rows[4]),
			size = dB,
			key = Keys.NumPad3,
			ctrl = KeyID.Num3,
			name = "3"
		}, new Key() {
			pos = new Point(449, rows[5]),
			size = new Size(44, dbh),
			key = Keys.NumPad0,
			ctrl = KeyID.Num0,
			name = "0"
		},
	};/**/
	#endregion
	#region keytable (old)
	/* = new Key[]
	{
		new Key() {
			pos = new Point(3, rows[0]),
			size = dB,
			key = Keys.Escape,
			ctrl = KeyID.Escape,
			name = "Es"
		}, new Key() {
			pos = new Point(3+(23*2), rows[0]),
			size = dB,
			key = Keys.F1,
			ctrl = KeyID.F1,
			name = "F1"
		}, new Key() {
			pos = new Point(3+(23*3), rows[0]),
			size = dB,
			key = Keys.F2,
			ctrl = KeyID.F2,
			name = "F2"
		}, new Key() {
			pos = new Point(3+(23*4), rows[0]),
			size = dB,
			key = Keys.F3,
			ctrl = KeyID.F3,
			name = "F3"
		}, new Key() {
			pos = new Point(3+(23*5), rows[0]),
			size = dB,
			key = Keys.F4,
			ctrl = KeyID.F4,
			name = "F4"
		}, new Key() {
			pos = new Point(3+(23*7), rows[0]),
			size = dB,
			key = Keys.F5,
			ctrl = KeyID.F5,
			name = "F5"
		}, new Key() {
			pos = new Point(3+(23*8), rows[0]),
			size = dB,
			key = Keys.F6,
			ctrl = KeyID.F6,
			name = "F6"
		}, new Key() {
			pos = new Point(3+(23*9), rows[0]),
			size = dB,
			key = Keys.F7,
			ctrl = KeyID.F7,
			name = "F7"
		}, new Key() {
			pos = new Point(3+(23*10), rows[0]),
			size = dB,
			key = Keys.F8,
			ctrl = KeyID.F8,
			name = "F8"
		}, new Key() {
			pos = new Point(3+(23*12), rows[0]),
			size = dB,
			key = Keys.F9,
			ctrl = KeyID.F9,
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
		},* new Key() {
			pos = new Point(376, rows[0]),
			size = dB,
			key = Keys.PrintScreen,
			ctrl = KeyID.PrScr,
			name = "Pr"
		}, new Key() {
			pos = new Point(399, rows[0]),
			size = dB,
			key = Keys.Scroll,
			ctrl = KeyID.ScrLck,
			name = "Sc"
		}, new Key() {
			pos = new Point(422, rows[0]),
			size = dB,
			key = Keys.Pause,
			ctrl = KeyID.Pause,
			name = "Br"
		}, new Key() {
			pos = new Point(3, rows[1]),
			size = dB,
			key = Keys.Oemtilde,
			ctrl = KeyID.Tilda,
			name = "~"
		}, new Key() {
			pos = new Point(3+(23*1), rows[1]),
			size = dB,
			key = Keys.D1,
			ctrl = KeyID.D1,
			name = "1"
		}, new Key() {
			pos = new Point(3+(23*2), rows[1]),
			size = dB,
			key = Keys.D2,
			ctrl = KeyID.D2,
			name = "2"
		}, new Key() {
			pos = new Point(3+(23*3), rows[1]),
			size = dB,
			key = Keys.D3,
			ctrl = KeyID.D3,
			name = "3"
		}, new Key() {
			pos = new Point(3+(23*4), rows[1]),
			size = dB,
			key = Keys.D4,
			ctrl = KeyID.D4,
			name = "4"
		}, new Key() {
			pos = new Point(3+(23*5), rows[1]),
			size = dB,
			key = Keys.D5,
			ctrl = KeyID.D5,
			name = "5"
		}, new Key() {
			pos = new Point(3+(23*6), rows[1]),
			size = dB,
			key = Keys.D6,
			ctrl = KeyID.D6,
			name = "6"
		}, new Key() {
			pos = new Point(3+(23*7), rows[1]),
			size = dB,
			key = Keys.D7,
			ctrl = KeyID.D7,
			name = "7"
		}, new Key() {
			pos = new Point(3+(23*8), rows[1]),
			size = dB,
			key = Keys.D8,
			ctrl = KeyID.D8,
			name = "8"
		}, new Key() {
			pos = new Point(3+(23*9), rows[1]),
			size = dB,
			key = Keys.D9,
			ctrl = KeyID.D9,
			name = "9"
		}, new Key() {
			pos = new Point(3+(23*10), rows[1]),
			size = dB,
			key = Keys.D0,
			ctrl = KeyID.D0,
			name = "0"
		}, new Key() {
			pos = new Point(3+(23*11), rows[1]),
			size = dB,
			key = Keys.OemMinus,
			ctrl = KeyID.Sign,
			name = "_"
		}, new Key() {
			pos = new Point(3+(23*12), rows[1]),
			size = dB,
			key = Keys.Oemplus,
			ctrl = KeyID.Equal,
			name = "+"
		}, new Key() {
			pos = new Point(3+(23*13), rows[1]),
			size = new Size(68, dbh),
			key = Keys.Back,
			ctrl = KeyID.Back,
			name = "Backspace"
		}, new Key() {
			pos = new Point(376, rows[1]),
			size = dB,
			key = Keys.Insert,
			ctrl = KeyID.Ins,
			name = "In"
		}, new Key() {
			pos = new Point(399, rows[1]),
			size = dB,
			key = Keys.Home,
			ctrl = KeyID.Home,
			name = "H"
		}, new Key() {
			pos = new Point(422, rows[1]),
			size = dB,
			key = Keys.PageUp,
			ctrl = KeyID.PgUp,
			name = "U"
		}, new Key() {
			pos = new Point(376, rows[2]),
			size = dB,
			key = Keys.Delete,
			ctrl = KeyID.Delete,
			name = "Dl"
		}, new Key() {
			pos = new Point(399, rows[2]),
			size = dB,
			key = Keys.End,
			ctrl = KeyID.End,
			name = "E"
		}, new Key() {
			pos = new Point(422, rows[2]),
			size = dB,
			key = Keys.PageDown,
			ctrl = KeyID.PgDn,
			name = "D"
		}, new Key() {
			pos = new Point(3, rows[2]),
			size = new Size(37, dbh),
			key = Keys.Tab,
			ctrl = KeyID.Tab,
			name = "Tab"
		}, new Key() {
			pos = new Point(43, rows[2]),
			size = dB,
			key = Keys.Q,
			ctrl = KeyID.Q,
			name = "Q"
		}, new Key() {
			pos = new Point(66, rows[2]),
			size = dB,
			key = Keys.W,
			ctrl = KeyID.W,
			name = "W"
		}, new Key() {
			pos = new Point(89, rows[2]),
			size = dB,
			key = Keys.E,
			ctrl = KeyID.E,
			name = "E"
		}, new Key() {
			pos = new Point(112, rows[2]),
			size = dB,
			key = Keys.R,
			ctrl = KeyID.R,
			name = "R"
		}, new Key() {
			pos = new Point(135, rows[2]),
			size = dB,
			key = Keys.T,
			ctrl = KeyID.T,
			name = "T"
		}, new Key() {
			pos = new Point(158, rows[2]),
			size = dB,
			key = Keys.Y,
			ctrl = KeyID.Y,
			name = "Y"
		}, new Key() {
			pos = new Point(181, rows[2]),
			size = dB,
			key = Keys.U,
			ctrl = KeyID.U,
			name = "U"
		}, new Key() {
			pos = new Point(204, rows[2]),
			size = dB,
			key = Keys.I,
			ctrl = KeyID.I,
			name = "I"
		}, new Key() {
			pos = new Point(227, rows[2]),
			size = dB,
			key = Keys.O,
			ctrl = KeyID.O,
			name = "O"
		}, new Key() {
			pos = new Point(250, rows[2]),
			size = dB,
			key = Keys.P,
			ctrl = KeyID.P,
			name = "P"
		}, new Key() {
			pos = new Point(273, rows[2]),
			size = dB,
			key = Keys.OemOpenBrackets,
			ctrl = KeyID.BrackL,
			name = "["
		}, new Key() {
			pos = new Point(296, rows[2]),
			size = dB,
			key = Keys.OemCloseBrackets,
			ctrl = KeyID.BrackR,
			name = "]"
		}, new Key() {
			pos = new Point(320, rows[2]),
			size = new Size(50, dbh),
			key = Keys.OemBackslash,
			ctrl = KeyID.BkSlash,
			name = "\\"
		}, new Key() {
			pos = new Point(3, rows[3]),
			size = new Size(44, dbh),
			key = Keys.CapsLock,
			ctrl = KeyID.Caps,
			name = "CapsLk"
		}, new Key() {
			pos = new Point(50, rows[3]),
			size = dB,
			key = Keys.A,
			ctrl = KeyID.A,
			name = "A"
		}, new Key() {
			pos = new Point(73, rows[3]),
			size = dB,
			key = Keys.S,
			ctrl = KeyID.S,
			name = "S"
		}, new Key() {
			pos = new Point(96, rows[3]),
			size = dB,
			key = Keys.D,
			ctrl = KeyID.D,
			name = "D"
		}, new Key() {
			pos = new Point(119, rows[3]),
			size = dB,
			key = Keys.F,
			ctrl = KeyID.F,
			name = "F"
		}, new Key() {
			pos = new Point(142, rows[3]),
			size = dB,
			key = Keys.G,
			ctrl = KeyID.G,
			name = "G"
		}, new Key() {
			pos = new Point(165, rows[3]),
			size = dB,
			key = Keys.H,
			ctrl = KeyID.H,
			name = "H"
		}, new Key() {
			pos = new Point(188, rows[3]),
			size = dB,
			key = Keys.J,
			ctrl = KeyID.J,
			name = "J"
		}, new Key() {
			pos = new Point(211, rows[3]),
			size = dB,
			key = Keys.K,
			ctrl = KeyID.K,
			name = "K"
		}, new Key() {
			pos = new Point(234, rows[3]),
			size = dB,
			key = Keys.L,
			ctrl = KeyID.L,
			name = "L"
		}, new Key() {
			pos = new Point(257, rows[3]),
			size = dB,
			key = Keys.OemSemicolon,
			ctrl = KeyID.SColon,
			name = ":"
		}, new Key() {
			pos = new Point(280, rows[3]),
			size = dB,
			key = Keys.OemQuotes,
			ctrl = KeyID.DQuote,
			name = "\""
		}, new Key() {
			pos = new Point(304, rows[3]),
			size = new Size(66, dbh),
			key = Keys.Enter,
			ctrl = KeyID.Enter,
			name = "Enter"
		}, new Key() {
			pos = new Point(3, rows[4]),
			size = new Size(61, dbh),
			key = Keys.LShiftKey,
			ctrl = KeyID.LShift,
			name = "Shift"
		}, new Key() {
			pos = new Point(66, rows[4]),
			size = dB,
			key = Keys.Z,
			ctrl = KeyID.Z,
			name = "Z"
		}, new Key() {
			pos = new Point(89, rows[4]),
			size = dB,
			key = Keys.X,
			ctrl = KeyID.X,
			name = "X"
		}, new Key() {
			pos = new Point(112, rows[4]),
			size = dB,
			key = Keys.C,
			ctrl = KeyID.C,
			name = "C"
		}, new Key() {
			pos = new Point(135, rows[4]),
			size = dB,
			key = Keys.V,
			ctrl = KeyID.V,
			name = "V"
		}, new Key() {
			pos = new Point(158, rows[4]),
			size = dB,
			key = Keys.B,
			ctrl = KeyID.B,
			name = "B"
		}, new Key() {
			pos = new Point(181, rows[4]),
			size = dB,
			key = Keys.N,
			ctrl = KeyID.N,
			name = "N"
		}, new Key() {
			pos = new Point(204, rows[4]),
			size = dB,
			key = Keys.M,
			ctrl = KeyID.M,
			name = "M"
		}, new Key() {
			pos = new Point(227, rows[4]),
			size = dB,
			key = Keys.Oemcomma,
			ctrl = KeyID.Comma,
			name = "<"
		}, new Key() {
			pos = new Point(250, rows[4]),
			size = dB,
			key = Keys.OemPeriod,
			ctrl = KeyID.Period,
			name = ">"
		}, new Key() {
			pos = new Point(273, rows[4]),
			size = dB,
			key = Keys.OemQuestion,
			ctrl = KeyID.QMark,
			name = "?"
		}, new Key() {
			pos = new Point(297, rows[4]),
			size = new Size(73, dbh),
			key = Keys.RShiftKey,
			ctrl = KeyID.RShift,
			name = "Shift"
		}, new Key() {
			pos = new Point(3, rows[5]),
			size = new Size(29, dbh),
			key = Keys.LControlKey,
			ctrl = KeyID.LCtrl,
			name = "Ctrl"
		}, /*new KeyLayout() {
			pos = new Point(66, buttonRows[4]),
			size = defaultButtonSize,
			key = Keys.LWin,
			control = KeyID.Win,
			name = "Win"
		},* new Key() {
			pos = new Point(66, rows[5]),
			size = new Size(29, dbh),
			key = Keys.LMenu,
			ctrl = KeyID.LAlt,
			name = "Alt"
		}, new Key() {
			pos = new Point(97, rows[5]),
			size = new Size(139, dbh),
			key = Keys.Space,
			ctrl = KeyID.Space,
			name = ""
		}, new Key() {
			pos = new Point(239, rows[5]),
			size = new Size(29, dbh),
			key = Keys.RMenu,
			ctrl = KeyID.RAlt,
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
		},* new Key() {
			pos = new Point(341, rows[5]),
			size = new Size(29, dbh),
			key = Keys.RControlKey,
			ctrl = KeyID.RCtrl,
			name = "Ctrl"
		}, new Key() {
			pos = new Point(399, rows[4]),
			size = dB,
			key = Keys.Up,
			ctrl = KeyID.Up,
			name = "↑"
		}, new Key() {
			pos = new Point(376, rows[5]),
			size = dB,
			key = Keys.Left,
			ctrl = KeyID.Left,
			name = "←"
		}, new Key() {
			pos = new Point(399, rows[5]),
			size = dB,
			key = Keys.Down,
			ctrl = KeyID.Down,
			name = "↓"
		}, new Key() {
			pos = new Point(422, rows[5]),
			size = dB,
			key = Keys.Right,
			ctrl = KeyID.Right,
			name = "→"
		}, new Key() {
			pos = new Point(449, rows[1]),
			size = dB,
			key = Keys.NumLock,
			ctrl = KeyID.NumLock,
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
		},* new Key() {
			pos = new Point(449, rows[2]),
			size = dB,
			key = Keys.NumPad7,
			ctrl = KeyID.Num7,
			name = "7"
		}, /*new KeyLayout() {
			pos = new Point(518, buttonRows[2]),
			size = new Size(21, 48),
			key = Keys.Oemplus,
			control = KeyID.NumPlus,
			name = "+"
		}, new KeyLayout() {
			pos = new Point(518, buttonRows[4]),
			size = new Size(21, 48),
			key = Keys.oem,
			control = KeyID.NumEnt,
			name = "E"
		}, new KeyLayout() {
			pos = new Point(518, buttonRows[1]),
			size = defaultButtonSize,
			key = Keys.OemMinus,
			control = KeyID.Num,
			name = "-"
		},* new Key() {
			pos = new Point(495, rows[5]),
			size = dB,
			key = Keys.OemPeriod,
			ctrl = KeyID.NumDel,
			name = "."
		}, new Key() {
			pos = new Point(472, rows[2]),
			size = dB,
			key = Keys.NumPad8,
			ctrl = KeyID.Num8,
			name = "8"
		}, new Key() {
			pos = new Point(495, rows[2]),
			size = dB,
			key = Keys.NumPad9,
			ctrl = KeyID.Num9,
			name = "9"
		}, new Key() {
			pos = new Point(449, rows[3]),
			size = dB,
			key = Keys.NumPad4,
			ctrl = KeyID.Num4,
			name = "4"
		}, new Key() {
			pos = new Point(472, rows[3]),
			size = dB,
			key = Keys.NumPad5,
			ctrl = KeyID.Num5,
			name = "5"
		}, new Key() {
			pos = new Point(495, rows[3]),
			size = dB,
			key = Keys.NumPad6,
			ctrl = KeyID.Num6,
			name = "6"
		}, new Key() {
			pos = new Point(449, rows[4]),
			size = dB,
			key = Keys.NumPad1,
			ctrl = KeyID.Num1,
			name = "1"
		}, new Key() {
			pos = new Point(472, rows[4]),
			size = dB,
			key = Keys.NumPad2,
			ctrl = KeyID.Num2,
			name = "2"
		}, new Key() {
			pos = new Point(495, rows[4]),
			size = dB,
			key = Keys.NumPad3,
			ctrl = KeyID.Num3,
			name = "3"
		}, new Key() {
			pos = new Point(449, rows[5]),
			size = new Size(44, dbh),
			key = Keys.NumPad0,
			ctrl = KeyID.Num0,
			name = "0"
		},
	};*/
	#endregion
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
		this.SuspendLayout();
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
			if (newColor.R * 0.2126 +
				newColor.G * 0.7152 +
				newColor.B * 0.0722 < 255 / 2)
			{
				textColor = Color.White;
			}
			kBt[i].BackColor = newColor;
			kBt[i].ForeColor = textColor;
		}
		this.ResumeLayout(false);
		this.PerformLayout();
	}

	public keyEdit(ushort[] binds)
	{
		InitializeComponent();
		SuspendLayout();
		selBtnL.Text = Launcher.T[155];
		Text = Launcher.T[154];
		guitarPic.ImageLocation = Launcher.T[162];
		hintTxt.Text = Launcher.T[163];
#pragma warning disable CS0162 // Unreachable code detected
		if (false) // dump key list for optimization
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
#pragma warning restore CS0162 // Unreachable code detected
		//if (true)
		if (kt == null)
		{
			MemoryStream ks = new MemoryStream(Launcher.kl);
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
