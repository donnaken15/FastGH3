partial class fspmultichart
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
		this.lblmain = new System.Windows.Forms.Label();
		this.listfiles = new System.Windows.Forms.ListBox();
		this.choose = new System.Windows.Forms.Button();
		this.cancel = new System.Windows.Forms.Button();
		this.SuspendLayout();
		// 
		// lblmain
		// 
		this.lblmain.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
		| System.Windows.Forms.AnchorStyles.Right)));
		this.lblmain.AutoSize = true;
		this.lblmain.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.lblmain.Location = new System.Drawing.Point(12, 9);
		this.lblmain.Name = "lblmain";
		this.lblmain.Size = new System.Drawing.Size(239, 26);
		this.lblmain.TabIndex = 0;
		this.lblmain.Text = "There is more than one file in this Song Package.\r\nWhich one do you choose?";
		// 
		// listfiles
		// 
		this.listfiles.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
		| System.Windows.Forms.AnchorStyles.Left) 
		| System.Windows.Forms.AnchorStyles.Right)));
		this.listfiles.FormattingEnabled = true;
		this.listfiles.IntegralHeight = false;
		this.listfiles.Location = new System.Drawing.Point(13, 45);
		this.listfiles.Name = "listfiles";
		this.listfiles.Size = new System.Drawing.Size(252, 113);
		this.listfiles.TabIndex = 1;
		this.listfiles.DoubleClick += new System.EventHandler(this.select);
		this.listfiles.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.select);
		// 
		// choose
		// 
		this.choose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
		this.choose.DialogResult = System.Windows.Forms.DialogResult.OK;
		this.choose.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.choose.Location = new System.Drawing.Point(12, 166);
		this.choose.Name = "choose";
		this.choose.Size = new System.Drawing.Size(75, 23);
		this.choose.TabIndex = 2;
		this.choose.Text = "Play";
		this.choose.UseVisualStyleBackColor = true;
		this.choose.Click += new System.EventHandler(this.select);
		// 
		// cancel
		// 
		this.cancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
		this.cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
		this.cancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.cancel.Location = new System.Drawing.Point(190, 166);
		this.cancel.Name = "cancel";
		this.cancel.Size = new System.Drawing.Size(75, 23);
		this.cancel.TabIndex = 3;
		this.cancel.Text = "Cancel";
		this.cancel.UseVisualStyleBackColor = true;
		// 
		// fspmultichart
		// 
		this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
		this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
		this.ClientSize = new System.Drawing.Size(277, 201);
		this.Controls.Add(this.cancel);
		this.Controls.Add(this.choose);
		this.Controls.Add(this.listfiles);
		this.Controls.Add(this.lblmain);
		this.Name = "fspmultichart";
		this.ShowIcon = false;
		this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
		this.Text = "FastGH3 : Warning";
		this.ResumeLayout(false);
		this.PerformLayout();

	}

	#endregion

	private System.Windows.Forms.Label lblmain;
	private System.Windows.Forms.ListBox listfiles;
	private System.Windows.Forms.Button choose;
	private System.Windows.Forms.Button cancel;
}