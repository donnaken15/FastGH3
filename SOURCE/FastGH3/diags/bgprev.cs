using System.Drawing;
using System.Windows.Forms;

public partial class bgprev : Form
{
	static Size size = new Size(548, 411);
	PictureBox game = new PictureBox()
	{
		BackColor = Color.Black,
		BackgroundImageLayout = ImageLayout.Stretch,
		Dock = DockStyle.Fill,
		ImageLocation = Launcher.T[138],
		Location = new Point(0, 0),
		Size = size,
		SizeMode = PictureBoxSizeMode.Zoom
	};
	public bgprev(Image i)
	{
		ClientSize = size;
		Controls.Add(game);
		ShowIcon = false;
		StartPosition = FormStartPosition.CenterParent;
		Text = Launcher.TT[0];
		game.BackgroundImage = i;
	}
}
