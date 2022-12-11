using System;
using System.Windows.Forms;

public partial class songtxtfmt : Form
{
    public songtxtfmt(string originalSetting)
    {
        InitializeComponent();
        format = originalSetting;
        inputBox.Text = format;
        inputChanged(null, null);
    }
        
    string[] songParams = new string[] {
        "Hiroaki Sano",
        "Circus Game",
        "8BIT MUSIC POWER",
        "donnaken15",
        "2016",
        "2:22",
        "Chiptune"
    };
    public string format;

    private void inputChanged(object sender, EventArgs e)
    {
        exampleTxt.Text = "Example:\n" + Program.FormatText(inputBox.Text, songParams);
        format = inputBox.Text;
    }
}
