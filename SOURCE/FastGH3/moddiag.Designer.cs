partial class moddiag
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
            this.modslist = new System.Windows.Forms.ListBox();
            this.splitter1 = new System.Windows.Forms.SplitContainer();
            this.refbtn = new System.Windows.Forms.Button();
            this.togglecbx = new System.Windows.Forms.CheckBox();
            this.rembtn = new System.Windows.Forms.Button();
            this.addbtn = new System.Windows.Forms.Button();
            this.modcfgbtn = new System.Windows.Forms.Button();
            this.warnings = new System.Windows.Forms.TextBox();
            this.warningslbl = new System.Windows.Forms.Label();
            this.modovers = new System.Windows.Forms.Button();
            this.modlu = new System.Windows.Forms.Label();
            this.modver = new System.Windows.Forms.Label();
            this.descbox = new System.Windows.Forms.TextBox();
            this.moddesc = new System.Windows.Forms.Label();
            this.modauth = new System.Windows.Forms.Label();
            this.modname = new System.Windows.Forms.Label();
            this.OFD = new System.Windows.Forms.OpenFileDialog();
            ((System.ComponentModel.ISupportInitialize)(this.splitter1)).BeginInit();
            this.splitter1.Panel1.SuspendLayout();
            this.splitter1.Panel2.SuspendLayout();
            this.splitter1.SuspendLayout();
            this.SuspendLayout();
            // 
            // modslist
            // 
            this.modslist.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.modslist.FormattingEnabled = true;
            this.modslist.IntegralHeight = false;
            this.modslist.Location = new System.Drawing.Point(3, 6);
            this.modslist.Name = "modslist";
            this.modslist.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended;
            this.modslist.Size = new System.Drawing.Size(158, 292);
            this.modslist.TabIndex = 0;
            this.modslist.SelectedIndexChanged += new System.EventHandler(this.selectmod);
            // 
            // splitter1
            // 
            this.splitter1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitter1.Location = new System.Drawing.Point(0, 0);
            this.splitter1.Name = "splitter1";
            // 
            // splitter1.Panel1
            // 
            this.splitter1.Panel1.Controls.Add(this.refbtn);
            this.splitter1.Panel1.Controls.Add(this.togglecbx);
            this.splitter1.Panel1.Controls.Add(this.rembtn);
            this.splitter1.Panel1.Controls.Add(this.addbtn);
            this.splitter1.Panel1.Controls.Add(this.modslist);
            this.splitter1.Panel1.Padding = new System.Windows.Forms.Padding(10);
            // 
            // splitter1.Panel2
            // 
            this.splitter1.Panel2.Controls.Add(this.modcfgbtn);
            this.splitter1.Panel2.Controls.Add(this.warnings);
            this.splitter1.Panel2.Controls.Add(this.warningslbl);
            this.splitter1.Panel2.Controls.Add(this.modovers);
            this.splitter1.Panel2.Controls.Add(this.modlu);
            this.splitter1.Panel2.Controls.Add(this.modver);
            this.splitter1.Panel2.Controls.Add(this.descbox);
            this.splitter1.Panel2.Controls.Add(this.moddesc);
            this.splitter1.Panel2.Controls.Add(this.modauth);
            this.splitter1.Panel2.Controls.Add(this.modname);
            this.splitter1.Panel2.Padding = new System.Windows.Forms.Padding(2);
            this.splitter1.Size = new System.Drawing.Size(416, 332);
            this.splitter1.SplitterDistance = 163;
            this.splitter1.SplitterWidth = 3;
            this.splitter1.TabIndex = 1;
            // 
            // refbtn
            // 
            this.refbtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.refbtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.refbtn.Font = new System.Drawing.Font("MS PGothic", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.refbtn.Location = new System.Drawing.Point(141, 303);
            this.refbtn.Name = "refbtn";
            this.refbtn.Size = new System.Drawing.Size(20, 23);
            this.refbtn.TabIndex = 3;
            this.refbtn.Text = "↺";
            this.refbtn.UseVisualStyleBackColor = true;
            this.refbtn.Click += new System.EventHandler(this.modrefresh);
            // 
            // togglecbx
            // 
            this.togglecbx.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.togglecbx.Enabled = false;
            this.togglecbx.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.togglecbx.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.togglecbx.Location = new System.Drawing.Point(53, 304);
            this.togglecbx.Name = "togglecbx";
            this.togglecbx.Size = new System.Drawing.Size(85, 24);
            this.togglecbx.TabIndex = 4;
            this.togglecbx.Text = "Disable (*)";
            this.togglecbx.UseVisualStyleBackColor = true;
            this.togglecbx.CheckedChanged += new System.EventHandler(this.togglemod);
            // 
            // rembtn
            // 
            this.rembtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.rembtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.rembtn.Location = new System.Drawing.Point(26, 303);
            this.rembtn.Name = "rembtn";
            this.rembtn.Size = new System.Drawing.Size(20, 23);
            this.rembtn.TabIndex = 2;
            this.rembtn.Text = "-";
            this.rembtn.UseVisualStyleBackColor = true;
            this.rembtn.Click += new System.EventHandler(this.remmod);
            // 
            // addbtn
            // 
            this.addbtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.addbtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.addbtn.Location = new System.Drawing.Point(3, 303);
            this.addbtn.Name = "addbtn";
            this.addbtn.Size = new System.Drawing.Size(20, 23);
            this.addbtn.TabIndex = 1;
            this.addbtn.Text = "+";
            this.addbtn.UseVisualStyleBackColor = true;
            this.addbtn.Click += new System.EventHandler(this.addmod_diag);
            // 
            // modcfgbtn
            // 
            this.modcfgbtn.Enabled = false;
            this.modcfgbtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modcfgbtn.Location = new System.Drawing.Point(100, 169);
            this.modcfgbtn.Name = "modcfgbtn";
            this.modcfgbtn.Size = new System.Drawing.Size(75, 23);
            this.modcfgbtn.TabIndex = 9;
            this.modcfgbtn.Text = "User Settings";
            this.modcfgbtn.UseVisualStyleBackColor = true;
            this.modcfgbtn.Click += new System.EventHandler(this.openmodcfg);
            // 
            // warnings
            // 
            this.warnings.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.warnings.Location = new System.Drawing.Point(2, 214);
            this.warnings.Multiline = true;
            this.warnings.Name = "warnings";
            this.warnings.ReadOnly = true;
            this.warnings.Size = new System.Drawing.Size(243, 113);
            this.warnings.TabIndex = 8;
            // 
            // warningslbl
            // 
            this.warningslbl.AutoSize = true;
            this.warningslbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.warningslbl.Location = new System.Drawing.Point(3, 197);
            this.warningslbl.Name = "warningslbl";
            this.warningslbl.Size = new System.Drawing.Size(55, 13);
            this.warningslbl.TabIndex = 7;
            this.warningslbl.Text = "Warnings:";
            // 
            // modovers
            // 
            this.modovers.Enabled = false;
            this.modovers.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modovers.Location = new System.Drawing.Point(2, 169);
            this.modovers.Name = "modovers";
            this.modovers.Size = new System.Drawing.Size(91, 23);
            this.modovers.TabIndex = 6;
            this.modovers.Text = "Overrides...";
            this.modovers.UseVisualStyleBackColor = true;
            this.modovers.Click += new System.EventHandler(this.showOvrds);
            // 
            // modlu
            // 
            this.modlu.AutoSize = true;
            this.modlu.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modlu.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.modlu.Location = new System.Drawing.Point(2, 147);
            this.modlu.Name = "modlu";
            this.modlu.Size = new System.Drawing.Size(91, 16);
            this.modlu.TabIndex = 5;
            this.modlu.Text = "Last Updated:";
            // 
            // modver
            // 
            this.modver.AutoSize = true;
            this.modver.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modver.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.modver.Location = new System.Drawing.Point(2, 129);
            this.modver.Name = "modver";
            this.modver.Size = new System.Drawing.Size(56, 16);
            this.modver.TabIndex = 4;
            this.modver.Text = "Version:";
            // 
            // descbox
            // 
            this.descbox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.descbox.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.descbox.Location = new System.Drawing.Point(3, 64);
            this.descbox.Multiline = true;
            this.descbox.Name = "descbox";
            this.descbox.ReadOnly = true;
            this.descbox.Size = new System.Drawing.Size(245, 62);
            this.descbox.TabIndex = 3;
            // 
            // moddesc
            // 
            this.moddesc.AutoSize = true;
            this.moddesc.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.moddesc.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.moddesc.Location = new System.Drawing.Point(3, 42);
            this.moddesc.Name = "moddesc";
            this.moddesc.Size = new System.Drawing.Size(87, 18);
            this.moddesc.TabIndex = 2;
            this.moddesc.Text = "Description:";
            // 
            // modauth
            // 
            this.modauth.AutoSize = true;
            this.modauth.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modauth.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.modauth.Location = new System.Drawing.Point(3, 22);
            this.modauth.Name = "modauth";
            this.modauth.Size = new System.Drawing.Size(55, 18);
            this.modauth.TabIndex = 1;
            this.modauth.Text = "Author:";
            // 
            // modname
            // 
            this.modname.AutoSize = true;
            this.modname.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modname.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.modname.Location = new System.Drawing.Point(3, 2);
            this.modname.Name = "modname";
            this.modname.Size = new System.Drawing.Size(52, 18);
            this.modname.TabIndex = 0;
            this.modname.Text = "Name:";
            // 
            // OFD
            // 
            this.OFD.DefaultExt = "*.qb.xen";
            this.OFD.Filter = "QB file|*.qb.xen;*.qb|Zipped QB|*.zip";
            this.OFD.Multiselect = true;
            this.OFD.RestoreDirectory = true;
            this.OFD.SupportMultiDottedExtensions = true;
            this.OFD.Title = "Add a QB mod";
            this.OFD.FileOk += new System.ComponentModel.CancelEventHandler(this.openedQB);
            // 
            // moddiag
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(416, 332);
            this.Controls.Add(this.splitter1);
            this.Name = "moddiag";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "FastGH3 Mods";
            this.splitter1.Panel1.ResumeLayout(false);
            this.splitter1.Panel2.ResumeLayout(false);
            this.splitter1.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitter1)).EndInit();
            this.splitter1.ResumeLayout(false);
            this.ResumeLayout(false);

	}

	#endregion

	private System.Windows.Forms.ListBox modslist;
	private System.Windows.Forms.SplitContainer splitter1;
	private System.Windows.Forms.Button rembtn;
	private System.Windows.Forms.Button addbtn;
	private System.Windows.Forms.Label modauth;
	private System.Windows.Forms.Label modname;
	private System.Windows.Forms.TextBox warnings;
	private System.Windows.Forms.Label warningslbl;
	private System.Windows.Forms.Button modovers;
	private System.Windows.Forms.Label modlu;
	private System.Windows.Forms.Label modver;
	private System.Windows.Forms.TextBox descbox;
	private System.Windows.Forms.Label moddesc;
	private System.Windows.Forms.Button refbtn;
	private System.Windows.Forms.CheckBox togglecbx;
    private System.Windows.Forms.OpenFileDialog OFD;
    private System.Windows.Forms.Button modcfgbtn;
}