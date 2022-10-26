using System;
using System.IO;
using System.Windows.Forms;

public partial class dllman : Form
{
    string folder = Environment.CurrentDirectory;

    public dllman()
    {
        InitializeComponent();
        Height += new DirectoryInfo(folder + "\\PLUGINS").GetFiles("*.dll", SearchOption.AllDirectories).Length * 9;
        dllrefresh();
    }

    private void dllfile(object sender, EventArgs e)
    {
        dllopen.ShowDialog();
    }

    private void dlldel(object sender, EventArgs e)
    {
        foreach (object dll in dlllist.SelectedItems)
            if (dll.ToString() != "core.dll")
                File.Delete(folder + "\\PLUGINS\\" + dll.ToString().Replace("(*)","disabled\\"));
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
            if (Path.GetPathRoot(file) != folder + "\\PLUGINS")
                File.Copy(file, folder + "\\PLUGINS\\" + Path.GetFileName(file), true);
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
        foreach (FileInfo file in new DirectoryInfo(folder + "\\PLUGINS").GetFiles("*.dll", SearchOption.TopDirectoryOnly))
            dlllist.Items.Add(file);
        try
        {
            foreach (FileInfo file in new DirectoryInfo(folder + "\\PLUGINS\\disabled").GetFiles("*.dll"))
                dlllist.Items.Add("(*)"+file);
        }
        catch { }
        if (File.Exists(folder + "\\PLUGINS\\_log.txt"))
            gh3plog.Text = File.ReadAllText(folder + "\\PLUGINS\\_log.txt").Replace("Loaded: plugins\\","");
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
        MessageBox.Show("Select a plugin DLL that is made for GH3+", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
    }

    private void dlltoggle(object sender, EventArgs e)
    {
        foreach (object dll in dlllist.SelectedItems)
        {
            if (dll.ToString() != "core.dll")
            {
                string dllS = dll.ToString();
                if (dllS.Contains("(*)"))
                    File.Move(folder + "\\PLUGINS\\disabled\\" + dllS.Replace("(*)", ""), folder + "\\PLUGINS\\" + dllS.Replace("(*)", ""));
                else
                    File.Move(folder + "\\PLUGINS\\" + dllS, folder + "\\PLUGINS\\disabled\\" + dllS);
            }
        }
        dllrefresh();
    }
}
