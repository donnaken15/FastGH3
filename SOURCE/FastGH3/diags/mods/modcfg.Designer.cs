partial class modcfg
{
	/// <summary>
	/// Required designer variable.
	/// </summary>
	private System.ComponentModel.IContainer components = null;

	/// <summary>
	/// Clean up any resources being used.
	/// </summary>
	/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
	protected override void Dispose(bool disposing)
	{
		if (disposing && (components != null))
		{
			components.Dispose();
		}
		base.Dispose(disposing);
	}

	#region Windows Form Designer generated code

	/// <summary>
	/// Required method for Designer support - do not modify
	/// the contents of this method with the code editor.
	/// </summary>
	private void InitializeComponent()
	{
            this.components = new System.ComponentModel.Container();
            this.tooltip = new System.Windows.Forms.ToolTip(this.components);
            this.coldiag = new System.Windows.Forms.ColorDialog();
            this.SuspendLayout();
            // 
            // tooltip
            // 
            this.tooltip.AutomaticDelay = 200;
            this.tooltip.AutoPopDelay = 60000;
            this.tooltip.InitialDelay = 200;
            this.tooltip.IsBalloon = true;
            this.tooltip.ReshowDelay = 40;
            this.tooltip.ToolTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.tooltip.ToolTipTitle = "About this parameter";
            this.tooltip.UseFading = false;
            // 
            // coldiag
            // 
            this.coldiag.AnyColor = true;
            this.coldiag.FullOpen = true;
            // 
            // modcfg
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(318, 390);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "modcfg";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Mod Settings";
            this.ResumeLayout(false);

	}

	#endregion
    private System.Windows.Forms.ToolTip tooltip;
    private System.Windows.Forms.ColorDialog coldiag;
}