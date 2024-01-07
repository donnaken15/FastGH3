using System;
using System.IO;
using System.Windows.Forms;

public partial class dllman : Form
{
	static string folder = Environment.CurrentDirectory;
	// ill put as many backslashes as i want
	// not gonna get path errors lol
	static string[] T = Launcher.T;
	static string pl = T[139];
	static string d = T[140];
	static string df = folder + pl + d;
	static string f = T[141];
	static string c = T[142];
	static string di = T[143];

	public dllman()
	{
		InitializeComponent();
		Height += new DirectoryInfo(folder + pl).GetFiles(T[141], SearchOption.AllDirectories).Length * 9;
		if (!Directory.Exists(df))
			Directory.CreateDirectory(df);
		dllrefresh();
	}

	void dllfile(object sender, EventArgs e)
	{
		dllopen.ShowDialog();
	}

	void dlldel(object sender, EventArgs e)
	{
		foreach (object dll in dlllist.SelectedItems)
			if (dll.ToString().ToLower() != c)
				File.Delete(folder + pl + dll.ToString().Replace(di, d));
		dllrefresh();
		if (dlllist.SelectedIndex == -1)
		{
			dllrem.Enabled = false;
			dlloff.Enabled = false;
		}
	}

	void dllselected(object sender, System.ComponentModel.CancelEventArgs e)
	{
		foreach (string file in dllopen.FileNames)
			if (Launcher.NP(Path.GetPathRoot(file)) != Launcher.NP(folder + pl))
				File.Copy(file, folder + pl + Path.GetFileName(file), true);
		dllrefresh();
	}

	void dllredolist(object sender, EventArgs e)
	{
		dllrefresh();
	}

	void dllrefresh()
	{
		dlloff.Enabled = false;
		dlllist.Items.Clear();
		foreach (FileInfo file in new DirectoryInfo(folder + pl).GetFiles(T[141], SearchOption.TopDirectoryOnly))
			dlllist.Items.Add(file);
		try
		{
			foreach (FileInfo file in new DirectoryInfo(df).GetFiles(T[141]))
				dlllist.Items.Add(di+file);
		}
		catch { }
		if (File.Exists(folder + pl + T[144]))
			gh3plog.Text = File.ReadAllText(folder + pl + T[144]).Replace(T[145], "");
	}

	void dllselectlist(object sender, EventArgs e)
	{
		try
		{
			if (dlllist.SelectedItem.ToString().Contains(di))
				dlloff.Checked = true;
			else
				dlloff.Checked = false;
			if (dlllist.SelectedItem.ToString() != c)
			{
				dllrem.Enabled = true;
				dlloff.Enabled = true;
			}
			else
			{
				dllrem.Enabled = false;
				dlloff.Enabled = false;
			}
		}
		catch { }
	}

	private void dlltoggle(object sender, EventArgs e)
	{
		foreach (object dll in dlllist.SelectedItems)
		{
			if (dll.ToString() != c)
			{
				string dllS = dll.ToString();
				if (dllS.StartsWith(di))
					File.Move(df + dllS.Replace(di, ""), folder + pl + dllS.Replace(di, ""));
				else
					File.Move(folder + pl + dllS, df + dllS);
			}
		}
		dllrefresh();
	}
}
