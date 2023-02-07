using System.Drawing;
using System.Windows.Forms;

public partial class bgprev : Form
{
	static Size size = new Size(548, 411);
	PictureBox game = new PictureBox()
	{
		BackColor = Color.Transparent,
		BackgroundImageLayout = ImageLayout.Stretch,
		Dock = DockStyle.Fill,
		ImageLocation = "https://donnaken15.tk/fastgh3/gameBlank.png",
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
		Text = "FASTGH3 BACKGROUND PREVIEW™©®";
		game.BackgroundImage = i;
	}
}
