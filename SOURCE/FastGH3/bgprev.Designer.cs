partial class bgprev
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
        System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(bgprev));
        this.game = new System.Windows.Forms.PictureBox();
        ((System.ComponentModel.ISupportInitialize)(this.game)).BeginInit();
        this.SuspendLayout();
        // 
        // game
        // 
        this.game.BackColor = System.Drawing.Color.Transparent;
        this.game.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
        this.game.Dock = System.Windows.Forms.DockStyle.Fill;
        this.game.ImageLocation = "https://donnaken15.tk/fastgh3/gameBlank.png";
        this.game.Location = new System.Drawing.Point(0, 0);
        this.game.Name = "game";
        this.game.Size = new System.Drawing.Size(548, 411);
        this.game.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
        this.game.TabIndex = 1;
        this.game.TabStop = false;
        // 
        // bgprev
        // 
        this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.ClientSize = new System.Drawing.Size(548, 411);
        this.Controls.Add(this.game);
        this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
        this.Name = "bgprev";
        this.ShowIcon = false;
        this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
        this.Text = "FASTGH3 BACKGROUND PREVIEW™©®";
        ((System.ComponentModel.ISupportInitialize)(this.game)).EndInit();
        this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.PictureBox game;
}