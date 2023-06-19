using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

public partial class songcache : Form
{
	// should I specify file path/name in the INI when caching a song?

	string folder = Program.cf;
	string i;

	public songcache()
	{
		InitializeComponent();
		{
			i = folder + ".db.ini";
			DataGridViewRow newRow;
			foreach (string s in Program.sn(i))
			{
				if (File.Exists(folder + s) &&
					File.Exists(folder + Program.ini(s, "Audio", 0.ToString("X16"), 32, i).Substring(0, 16)))
				{
					newRow = new DataGridViewRow();
					newRow.CreateCells(c,
						s, // icon
						Program.ini(s, "Author", "Unknown", 64, i),
						Program.ini(s, "Title", "Untitled", 64, i),
						fs(new FileInfo(folder + s).Length +
							new FileInfo(folder +
							//                                         why
							Program.ini(s, "Audio", 0.ToString("X16"), 32, i)).Length),
						Program.ini(s, "Length", "00:00", 10, i),
						"Play"
						);
					c.Rows.Add(newRow);
					if (Height < 700)
						Height += 22;
				}
			}
		}
	}

	static char[] bU = " KMGT".ToCharArray();
	static uint bT = 1024; // based *ibibytes

	public static string fs(long l)
	{
		float n = l;
		byte u = 0;
		while (n >= bT && u < bU.Length - 1)
		{
			u++;
			n /= bT;
		}
		if (u == 0)
			return n.ToString("0").PadLeft(4) + " bytes"; // why even
		else
			return n.ToString("0.00 ").PadLeft(7) + bU[u] + 'B';
	}

	private void r(DataGridViewCellEventArgs e)
	{
		Program.killgame();
		string cs = (string)c.Rows[e.RowIndex].Cells[0].Value.ToString().Substring(0, 16);
		string au = Program.ini(cs, "Audio", null, 32, i).Substring(0, 16);
		string t = Program.ini(cs, "Title", null, 64, i);
		string a = Program.ini(cs, "Author", null, 64, i);
		string l = Program.ini(cs, "Length", "00:00", 8, i);
		File.Copy(folder + cs, folder + "..\\PAK\\song.pak.xen", true);
		File.Copy(folder + au, folder + "..\\MUSIC\\fastgh3.fsb.xen", true);
		string[] songParams = new string[] {
			a,
			t,
			"Unknown",
			"Unknown",
			"Unknown",
			l,
			"Unknown"
		};
		File.WriteAllText(folder + "..\\..\\currentsong.txt",
			Program.FormatText(
				System.Text.RegularExpressions.Regex.Unescape(Program.cfg(Program.m, Program.stf, "%a - %t")),
			songParams));
		Program.unkillgame();
		Directory.SetCurrentDirectory(folder + "..\\..\\");
		Process.Start(folder + "..\\..\\game.exe");
		Directory.SetCurrentDirectory(Program.cf);
	}

	private void cc(object sender, DataGridViewCellEventArgs e)
	{
		switch (e.ColumnIndex)
		{
			case 5:
				r(e);
				break;
		}
	}

	private void cdblc(object sender, DataGridViewCellEventArgs e)
	{
		r(e);
	}

	private void cdel(object sender, EventArgs e)
	{
		foreach (DataGridViewRow d in c.SelectedRows)
		{
			string s = (string)d.Cells[0].Value;
			File.Delete(folder + s);
			File.Delete(folder + Program.ini(s, "Audio", null, 17, i));
			Program.WSec(s, null, i);
			c.Rows.Remove(d);
		}
	}

	private void crcl(object sender, System.ComponentModel.CancelEventArgs e)
	{
		deleteTool.Enabled = c.SelectedRows.Count > 0;
	}
}
