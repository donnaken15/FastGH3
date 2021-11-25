using System.Drawing;
using System.Windows.Forms;

namespace FastGH3
{
    public partial class colorpreview : Form
    {
        public colorpreview(Color a)
        {
            InitializeComponent();
            game.BackColor = a;
        }
    }
}
