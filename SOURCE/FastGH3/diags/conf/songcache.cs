using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

public partial class songcache : Form
{
	// should I specify file path/name in the INI when caching a song?

	string folder = Launcher.cf;
	string i;

	public songcache()
	{
		InitializeComponent();
		{
			i = folder + ".db.ini";
			DataGridViewRow newRow;
			foreach (string s in Launcher.sn(i))
			{
				if (File.Exists(folder + s) &&
					File.Exists(folder + Launcher.ini(s, "Audio", 0.ToString("X16"), 32, i).Substring(0, 16)))
				{
					newRow = new DataGridViewRow();
					newRow.CreateCells(c,
						s, // icon
						Launcher.ini(s, "Author", "Unknown", 64, i),
						Launcher.ini(s, "Title", "Untitled", 64, i),
						fs(new FileInfo(folder + s).Length +
							new FileInfo(folder +
							//                                         why
							Launcher.ini(s, "Audio", 0.ToString("X16"), 32, i)).Length),
						Launcher.ini(s, "Length", "00:00", 10, i),
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
		Launcher.killgame();
		string cs = (string)c.Rows[e.RowIndex].Cells[0].Value.ToString().Substring(0, 16);
		string au = Launcher.ini(cs, "Audio", null, 32, i).Substring(0, 16);
		string t = Launcher.ini(cs, "Title", null, 64, i);
		string a = Launcher.ini(cs, "Author", null, 64, i);
		string l = Launcher.ini(cs, "Length", "00:00", 8, i);
		string[] tmp = { "qb", "pak" };
		for (int i = 0; i < 2; i++)
		{
			string s;
			if (File.Exists(s = Launcher.pakf + "song." + tmp[i] + ".xen"))
				File.Delete(s);
		}
		File.Copy(folder + cs,
			Launcher.pakf + "song." + (Launcher.ini(cs, "QB", 0, i) == 0 ? "pak" : "qb") + ".xen", true);
		File.Copy(folder + au, Launcher.music + "fastgh3.fsb.xen", true);
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
			Launcher.FormatText(
				System.Text.RegularExpressions.Regex.Unescape(Launcher.cfg(Launcher.m, Launcher.stf, "%a - %t")),
			songParams));
		Launcher.unkillgame();
		Directory.SetCurrentDirectory(folder + "..\\..\\");
		Process.Start(folder + "..\\..\\game.exe");
		Directory.SetCurrentDirectory(Launcher.cf);
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
		if (e.RowIndex < 0)
			return;
		r(e);
	}

	private void cdel(object sender, EventArgs e)
	{
		foreach (DataGridViewRow d in c.SelectedRows)
		{
			string s = (string)d.Cells[0].Value;
			File.Delete(folder + s);
			File.Delete(folder + Launcher.ini(s, "Audio", null, 32, i));
			Launcher.WSec(s, null, i);
			c.Rows.Remove(d);
		}
	}

	private void crcl(object sender, System.ComponentModel.CancelEventArgs e)
	{
		deleteTool.Enabled = c.SelectedRows.Count > 0;
	}
}
