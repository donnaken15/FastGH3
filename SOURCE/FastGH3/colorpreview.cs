using System.Drawing;
using System.Windows.Forms;

public partial class colorpreview : Form
{
	public colorpreview(Color a)
	{
		InitializeComponent();
		game.BackColor = a;
	}
}
