partial class songcache
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
        System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
        System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(songcache));
        this.cache = new System.Windows.Forms.DataGridView();
        this.tableContext = new System.Windows.Forms.ContextMenuStrip(this.components);
        this.deleteTool = new System.Windows.Forms.ToolStripMenuItem();
        this.ID = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.Artist = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.Title = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this._Size = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.Length = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.playBtn = new System.Windows.Forms.DataGridViewButtonColumn();
        ((System.ComponentModel.ISupportInitialize)(this.cache)).BeginInit();
        this.tableContext.SuspendLayout();
        this.SuspendLayout();
        // 
        // cache
        // 
        this.cache.AllowUserToAddRows = false;
        this.cache.AllowUserToDeleteRows = false;
        this.cache.AllowUserToOrderColumns = true;
        this.cache.AllowUserToResizeRows = false;
        this.cache.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
        this.cache.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        this.cache.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
        this.ID,
        this.Artist,
        this.Title,
        this._Size,
        this.Length,
        this.playBtn});
        this.cache.ContextMenuStrip = this.tableContext;
        this.cache.Dock = System.Windows.Forms.DockStyle.Fill;
        this.cache.EditMode = System.Windows.Forms.DataGridViewEditMode.EditProgrammatically;
        this.cache.EnableHeadersVisualStyles = false;
        this.cache.Location = new System.Drawing.Point(0, 0);
        this.cache.MultiSelect = false;
        this.cache.Name = "cache";
        this.cache.ReadOnly = true;
        this.cache.RowHeadersVisible = false;
        dataGridViewCellStyle1.Font = new System.Drawing.Font("MS Gothic", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
        this.cache.RowsDefaultCellStyle = dataGridViewCellStyle1;
        this.cache.RowTemplate.Resizable = System.Windows.Forms.DataGridViewTriState.False;
        this.cache.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
        this.cache.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
        this.cache.Size = new System.Drawing.Size(492, 22);
        this.cache.TabIndex = 0;
        this.cache.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.cacheClick0);
        this.cache.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.cacheDblClick);
        // 
        // tableContext
        // 
        this.tableContext.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.deleteTool});
        this.tableContext.Name = "tableContext";
        this.tableContext.Size = new System.Drawing.Size(106, 26);
        this.tableContext.Opening += new System.ComponentModel.CancelEventHandler(this.cacheRgtclick);
        // 
        // deleteTool
        // 
        this.deleteTool.Name = "deleteTool";
        this.deleteTool.Size = new System.Drawing.Size(105, 22);
        this.deleteTool.Text = "Delete";
        this.deleteTool.Click += new System.EventHandler(this.cacheDelete1);
        // 
        // ID
        // 
        this.ID.HeaderText = "ID";
        this.ID.MaxInputLength = 8;
        this.ID.Name = "ID";
        this.ID.ReadOnly = true;
        this.ID.ToolTipText = "Song cache identifier";
        this.ID.Width = 60;
        // 
        // Artist
        // 
        this.Artist.HeaderText = "Artist";
        this.Artist.MaxInputLength = 0;
        this.Artist.Name = "Artist";
        this.Artist.ReadOnly = true;
        this.Artist.Width = 120;
        // 
        // Title
        // 
        this.Title.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
        this.Title.HeaderText = "Title";
        this.Title.MaxInputLength = 0;
        this.Title.Name = "Title";
        this.Title.ReadOnly = true;
        // 
        // _Size
        // 
        this._Size.FillWeight = 76F;
        this._Size.HeaderText = "Size";
        this._Size.MaxInputLength = 0;
        this._Size.Name = "_Size";
        this._Size.ReadOnly = true;
        this._Size.Resizable = System.Windows.Forms.DataGridViewTriState.False;
        this._Size.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
        this._Size.Width = 76;
        // 
        // Length
        // 
        this.Length.FillWeight = 50F;
        this.Length.HeaderText = "Length";
        this.Length.MinimumWidth = 50;
        this.Length.Name = "Length";
        this.Length.ReadOnly = true;
        this.Length.Resizable = System.Windows.Forms.DataGridViewTriState.False;
        this.Length.Width = 50;
        // 
        // playBtn
        // 
        this.playBtn.FillWeight = 38F;
        this.playBtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
        this.playBtn.HeaderText = "Play";
        this.playBtn.MinimumWidth = 38;
        this.playBtn.Name = "playBtn";
        this.playBtn.ReadOnly = true;
        this.playBtn.Resizable = System.Windows.Forms.DataGridViewTriState.False;
        this.playBtn.Width = 38;
        // 
        // songcache
        // 
        this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.ClientSize = new System.Drawing.Size(492, 22);
        this.Controls.Add(this.cache);
        this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
        this.Name = "songcache";
        this.ShowIcon = false;
        this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
        this.Text = "Song Cache";
        ((System.ComponentModel.ISupportInitialize)(this.cache)).EndInit();
        this.tableContext.ResumeLayout(false);
        this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.DataGridView cache;
    private System.Windows.Forms.DataGridViewTextBoxColumn Filesize;
    private System.Windows.Forms.ContextMenuStrip tableContext;
    private System.Windows.Forms.ToolStripMenuItem deleteTool;
    private System.Windows.Forms.DataGridViewTextBoxColumn ID;
    private System.Windows.Forms.DataGridViewTextBoxColumn Artist;
    private System.Windows.Forms.DataGridViewTextBoxColumn Title;
    private System.Windows.Forms.DataGridViewTextBoxColumn _Size;
    private System.Windows.Forms.DataGridViewTextBoxColumn Length;
    private System.Windows.Forms.DataGridViewButtonColumn playBtn;
}