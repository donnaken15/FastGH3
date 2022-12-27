partial class dllman
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
		System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(dllman));
		this.dlllist = new System.Windows.Forms.ListBox();
		this.dlladd = new System.Windows.Forms.Button();
		this.dllrem = new System.Windows.Forms.Button();
		this.dlloff = new System.Windows.Forms.CheckBox();
		this.dllref = new System.Windows.Forms.Button();
		this.dllopen = new System.Windows.Forms.OpenFileDialog();
		this.gh3plog = new System.Windows.Forms.TextBox();
		this.gh3ploglabel = new System.Windows.Forms.Label();
		this.SuspendLayout();
		// 
		// dlllist
		// 
		this.dlllist.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
		| System.Windows.Forms.AnchorStyles.Left)));
		this.dlllist.Font = new System.Drawing.Font("Courier New", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
		this.dlllist.FormattingEnabled = true;
		this.dlllist.IntegralHeight = false;
		this.dlllist.ItemHeight = 15;
		this.dlllist.Location = new System.Drawing.Point(13, 13);
		this.dlllist.Name = "dlllist";
		this.dlllist.ScrollAlwaysVisible = true;
		this.dlllist.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended;
		this.dlllist.Size = new System.Drawing.Size(181, 93);
		this.dlllist.TabIndex = 0;
		this.dlllist.SelectedIndexChanged += new System.EventHandler(this.dllselectlist);
		// 
		// dlladd
		// 
		this.dlladd.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
		this.dlladd.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.dlladd.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
		this.dlladd.Location = new System.Drawing.Point(13, 112);
		this.dlladd.Name = "dlladd";
		this.dlladd.Size = new System.Drawing.Size(22, 23);
		this.dlladd.TabIndex = 1;
		this.dlladd.Text = "+";
		this.dlladd.UseVisualStyleBackColor = true;
		this.dlladd.Click += new System.EventHandler(this.dllfile);
		// 
		// dllrem
		// 
		this.dllrem.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
		this.dllrem.Enabled = false;
		this.dllrem.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.dllrem.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
		this.dllrem.Location = new System.Drawing.Point(41, 112);
		this.dllrem.Name = "dllrem";
		this.dllrem.Size = new System.Drawing.Size(22, 23);
		this.dllrem.TabIndex = 2;
		this.dllrem.Text = "-";
		this.dllrem.UseVisualStyleBackColor = true;
		this.dllrem.Click += new System.EventHandler(this.dlldel);
		// 
		// dlloff
		// 
		this.dlloff.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
		this.dlloff.AutoSize = true;
		this.dlloff.Enabled = false;
		this.dlloff.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.dlloff.Location = new System.Drawing.Point(69, 115);
		this.dlloff.Name = "dlloff";
		this.dlloff.Size = new System.Drawing.Size(80, 18);
		this.dlloff.TabIndex = 3;
		this.dlloff.Text = "Disable (*)";
		this.dlloff.UseVisualStyleBackColor = true;
		this.dlloff.Click += new System.EventHandler(this.dlltoggle);
		// 
		// dllref
		// 
		this.dllref.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
		this.dllref.FlatStyle = System.Windows.Forms.FlatStyle.System;
		this.dllref.Font = new System.Drawing.Font("MS Gothic", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
		this.dllref.Location = new System.Drawing.Point(170, 112);
		this.dllref.Name = "dllref";
		this.dllref.Size = new System.Drawing.Size(24, 23);
		this.dllref.TabIndex = 4;
		this.dllref.Text = "↺";
		this.dllref.UseVisualStyleBackColor = true;
		this.dllref.Click += new System.EventHandler(this.dllredolist);
		// 
		// dllopen
		// 
		this.dllopen.AutoUpgradeEnabled = false;
		this.dllopen.Filter = "GH3+ Plugin / Dynamic Link Library (*.dll)|*.dll";
		this.dllopen.Multiselect = true;
		this.dllopen.RestoreDirectory = true;
		this.dllopen.FileOk += new System.ComponentModel.CancelEventHandler(this.dllselected);
		// 
		// gh3plog
		// 
		this.gh3plog.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
		| System.Windows.Forms.AnchorStyles.Left) 
		| System.Windows.Forms.AnchorStyles.Right)));
		this.gh3plog.BackColor = System.Drawing.SystemColors.Window;
		this.gh3plog.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
		this.gh3plog.Location = new System.Drawing.Point(200, 28);
		this.gh3plog.Multiline = true;
		this.gh3plog.Name = "gh3plog";
		this.gh3plog.ReadOnly = true;
		this.gh3plog.ScrollBars = System.Windows.Forms.ScrollBars.Both;
		this.gh3plog.Size = new System.Drawing.Size(229, 78);
		this.gh3plog.TabIndex = 5;
		this.gh3plog.WordWrap = false;
		// 
		// gh3ploglabel
		// 
		this.gh3ploglabel.AutoSize = true;
		this.gh3ploglabel.Location = new System.Drawing.Point(201, 13);
		this.gh3ploglabel.Name = "gh3ploglabel";
		this.gh3ploglabel.Size = new System.Drawing.Size(166, 13);
		this.gh3ploglabel.TabIndex = 6;
		this.gh3ploglabel.Text = "Guitar Hero III+ Log: (last session)";
		// 
		// dllman
		// 
		this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
		this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
		this.ClientSize = new System.Drawing.Size(441, 147);
		this.Controls.Add(this.gh3plog);
		this.Controls.Add(this.gh3ploglabel);
		this.Controls.Add(this.dllref);
		this.Controls.Add(this.dlloff);
		this.Controls.Add(this.dllrem);
		this.Controls.Add(this.dlladd);
		this.Controls.Add(this.dlllist);
		this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
		this.Name = "dllman";
		this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
		this.Text = "Plugin Manager";
		this.ResumeLayout(false);
		this.PerformLayout();

	}

	#endregion

	private System.Windows.Forms.ListBox dlllist;
	private System.Windows.Forms.Button dlladd;
	private System.Windows.Forms.Button dllrem;
	private System.Windows.Forms.CheckBox dlloff;
	private System.Windows.Forms.Button dllref;
	private System.Windows.Forms.OpenFileDialog dllopen;
	private System.Windows.Forms.TextBox gh3plog;
	private System.Windows.Forms.Label gh3ploglabel;
}