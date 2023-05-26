using System.Windows.Forms;
using System.Collections.Generic;
using Nanook.QueenBee.Parser;

public partial class modovrddiag : Form
{
	public modovrddiag(string fname, List<moddiag.OverrideItem> ii)
	{
		InitializeComponent();
		foreach (moddiag.OverrideItem i in ii)
		{
			ListViewItem li = new ListViewItem(
				new string[] { i.name.ToString(), i.defval.ToString(), i.newval.ToString() });
			ovlist.Items.Add(li);
		}
	}
}
