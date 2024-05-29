partial class modovrddiag
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
            this.ovrlbl = new System.Windows.Forms.Label();
            this.ovlist = new System.Windows.Forms.ListView();
            this.Item = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Default = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Override = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.SuspendLayout();
            // 
            // ovrlbl
            // 
            this.ovrlbl.Dock = System.Windows.Forms.DockStyle.Top;
            this.ovrlbl.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ovrlbl.Location = new System.Drawing.Point(0, 0);
            this.ovrlbl.Name = "ovrlbl";
            this.ovrlbl.Size = new System.Drawing.Size(312, 24);
            this.ovrlbl.TabIndex = 0;
            this.ovrlbl.Text = Launcher.T[186];
            // 
            // ovlist
            // 
            this.ovlist.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.Item,
            this.Default,
            this.Override});
            this.ovlist.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ovlist.Font = new System.Drawing.Font("MS Gothic", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ovlist.HideSelection = false;
            this.ovlist.Location = new System.Drawing.Point(0, 24);
            this.ovlist.Name = "ovlist";
            this.ovlist.Size = new System.Drawing.Size(312, 401);
            this.ovlist.TabIndex = 1;
            this.ovlist.UseCompatibleStateImageBehavior = false;
            this.ovlist.View = System.Windows.Forms.View.Details;
            // 
            // Item
            // 
            this.Item.Text = "Item";
            this.Item.Width = 140;
            // 
            // Default
            // 
            this.Default.Text = "Default";
            this.Default.Width = 80;
            // 
            // Override
            // 
            this.Override.Text = "Override";
            this.Override.Width = 80;
            // 
            // modovrddiag
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(312, 425);
            this.Controls.Add(this.ovlist);
            this.Controls.Add(this.ovrlbl);
            this.MinimizeBox = false;
            this.Name = "modovrddiag";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Overrides";
            this.ResumeLayout(false);

	}

	#endregion

	private System.Windows.Forms.Label ovrlbl;
	private System.Windows.Forms.ListView ovlist;
	private System.Windows.Forms.ColumnHeader Item;
	private System.Windows.Forms.ColumnHeader Default;
	private System.Windows.Forms.ColumnHeader Override;
}