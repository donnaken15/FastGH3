using System.Drawing;
using System.IO;

namespace FastGH3
{
    partial class colorpreview
    {
        private System.ComponentModel.IContainer components = null;
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        private static string folder = System.Environment.CurrentDirectory;

        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(colorpreview));
            this.game = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.game)).BeginInit();
            this.SuspendLayout();
            // 
            // game
            // 
            IniFile ini = new IniFile();
            ini.Load("settings.ini");
            string[] bgcol = (ini.GetKeyValue("Misc", "BGColor", "0,0,0").Split(",".ToCharArray()));
            this.game.BackColor = Color.FromArgb(255, int.Parse(bgcol[0]), int.Parse(bgcol[1]), int.Parse(bgcol[2]));
            this.game.Dock = System.Windows.Forms.DockStyle.Fill;
            this.game.Image = global::FastGH3.Properties.Resources.fastgh3_transparent;
            this.game.Location = new System.Drawing.Point(0, 0);
            this.game.Name = "game";
            this.game.Size = new System.Drawing.Size(805, 600);
            this.game.TabIndex = 0;
            this.game.TabStop = false;
            // 
            // colorpreview
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(805, 600);
            this.Controls.Add(this.game);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "colorpreview";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FASTGH3 COLOR PREVIEW™©®";
            ((System.ComponentModel.ISupportInitialize)(this.game)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.PictureBox game;
    }
}