using System;
using System.IO;
using System.Windows.Forms;

public partial class dllman : Form
{
	static string folder = Environment.CurrentDirectory;
	// ill put as many backslashes as i want
	// not gonna get path errors lol
	static string plugins = "\\PLUGINS\\";
	static string disabled = "\\disabled\\";
	static string disabled_ = folder + plugins + disabled;

	public dllman()
	{
		InitializeComponent();
		Height += new DirectoryInfo(folder + plugins).GetFiles("*.dll", SearchOption.AllDirectories).Length * 9;
		dllrefresh();
	}

	private void dllfile(object sender, EventArgs e)
	{
		dllopen.ShowDialog();
	}

	private void dlldel(object sender, EventArgs e)
	{
		foreach (object dll in dlllist.SelectedItems)
			if (dll.ToString().ToLower() != "core.dll")
				File.Delete(folder + plugins + dll.ToString().Replace("(*)",disabled));
		dllrefresh();
		if (dlllist.SelectedIndex == -1)
		{
			dllrem.Enabled = false;
			dlloff.Enabled = false;
		}
	}

	private void dllselected(object sender, System.ComponentModel.CancelEventArgs e)
	{
		foreach (string file in dllopen.FileNames)
			if (Path.GetPathRoot(file) != folder + plugins)
				File.Copy(file, folder + plugins + Path.GetFileName(file), true);
		dllrefresh();
	}

	private void dllredolist(object sender, EventArgs e)
	{
		dllrefresh();
	}

	void dllrefresh()
	{
		dlloff.Enabled = false;
		dlllist.Items.Clear();
		foreach (FileInfo file in new DirectoryInfo(disabled_).GetFiles("*.dll", SearchOption.TopDirectoryOnly))
			dlllist.Items.Add(file);
		try
		{
			foreach (FileInfo file in new DirectoryInfo(disabled_).GetFiles("*.dll"))
				dlllist.Items.Add("(*)"+file);
		}
		catch { }
		if (File.Exists(folder + plugins + "_log.txt"))
			gh3plog.Text = File.ReadAllText(folder + plugins + "_log.txt").Replace("Loaded: plugins\\","");
	}

	private void dllselectlist(object sender, EventArgs e)
	{
		try
		{
			if (dlllist.SelectedItem.ToString().Contains("(*)"))
				dlloff.Checked = true;
			else
				dlloff.Checked = false;
			if (dlllist.SelectedItem.ToString() != "core.dll")
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

	private void dllopenhelp(object sender, EventArgs e)
	{
		MessageBox.Show("Select a DLL plugin that is made for GH3+", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
	}

	private void dlltoggle(object sender, EventArgs e)
	{
		foreach (object dll in dlllist.SelectedItems)
		{
			if (dll.ToString() != "core.dll")
			{
				string dllS = dll.ToString();
				if (dllS.Contains("(*)"))
					File.Move(disabled_ + dllS.Replace("(*)", ""), folder + plugins + dllS.Replace("(*)", ""));
				else
					File.Move(disabled_ + dllS, disabled_ + dllS);
			}
		}
		dllrefresh();
	}
}
