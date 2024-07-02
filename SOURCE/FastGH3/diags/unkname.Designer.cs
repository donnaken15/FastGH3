	partial class unkname
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
			this.infolbl = new System.Windows.Forms.Label();
			this.text = new System.Windows.Forms.TextBox();
			this.ok = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// infolbl
			// 
			this.infolbl.Dock = System.Windows.Forms.DockStyle.Fill;
			this.infolbl.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.infolbl.Location = new System.Drawing.Point(0, 0);
			this.infolbl.Name = "infolbl";
			this.infolbl.Size = new System.Drawing.Size(397, 83);
			this.infolbl.TabIndex = 0;
			this.infolbl.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// text
			// 
			this.text.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
			this.text.CharacterCasing = System.Windows.Forms.CharacterCasing.Lower;
			this.text.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.text.Location = new System.Drawing.Point(3, 36);
			this.text.Name = "text";
			this.text.Size = new System.Drawing.Size(324, 26);
			this.text.TabIndex = 1;
			// 
			// ok
			// 
			this.ok.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.ok.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.ok.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.ok.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.ok.Location = new System.Drawing.Point(333, 36);
			this.ok.Name = "ok";
			this.ok.Size = new System.Drawing.Size(61, 26);
			this.ok.TabIndex = 2;
			this.ok.Text = "OK";
			this.ok.UseVisualStyleBackColor = true;
			// 
			// unkname
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(397, 83);
			this.Controls.Add(this.ok);
			this.Controls.Add(this.text);
			this.Controls.Add(this.infolbl);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.Name = "unkname";
			this.ShowIcon = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Information";
			this.ResumeLayout(false);
			this.PerformLayout();

	}

	#endregion

	private System.Windows.Forms.Label infolbl;
	private System.Windows.Forms.TextBox text;
	private System.Windows.Forms.Button ok;
}
