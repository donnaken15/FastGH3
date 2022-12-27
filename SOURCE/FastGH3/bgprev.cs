using System.Drawing;
using System.Windows.Forms;

public partial class bgprev : Form
{
	public bgprev(Image i)
	{
		InitializeComponent();
		game.BackgroundImage = i;
	}
}
