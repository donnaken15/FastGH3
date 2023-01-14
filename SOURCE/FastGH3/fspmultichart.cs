
using System.Windows.Forms;

public partial class fspmultichart : Form
{
	public string chosen;

	public fspmultichart(string[] fnames)
	{
		InitializeComponent();
		listfiles.Items.AddRange(fnames);
	}

	private void select(object sender, object e)
	{
		if (listfiles.SelectedIndex != -1)
		{
			DialogResult = DialogResult.OK;
			chosen = listfiles.Items[listfiles.SelectedIndex].ToString();
		}
	}
}