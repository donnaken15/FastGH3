namespace FastGH3
{
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(songcache));
            this.cache = new System.Windows.Forms.DataGridView();
            this.ID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Title = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Artist = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Filesize = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Indexed = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.cache)).BeginInit();
            this.SuspendLayout();
            // 
            // cache
            // 
            this.cache.AllowUserToAddRows = false;
            this.cache.AllowUserToDeleteRows = false;
            this.cache.AllowUserToOrderColumns = true;
            this.cache.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.cache.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.cache.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.ID,
            this.Title,
            this.Artist,
            this.Filesize,
            this.Indexed});
            this.cache.Dock = System.Windows.Forms.DockStyle.Fill;
            this.cache.EditMode = System.Windows.Forms.DataGridViewEditMode.EditProgrammatically;
            this.cache.EnableHeadersVisualStyles = false;
            this.cache.Location = new System.Drawing.Point(0, 0);
            this.cache.MultiSelect = false;
            this.cache.Name = "cache";
            this.cache.ReadOnly = true;
            this.cache.RowHeadersVisible = false;
            this.cache.RowTemplate.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.cache.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.cache.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.cache.Size = new System.Drawing.Size(423, 18);
            this.cache.TabIndex = 0;
            // 
            // ID
            // 
            this.ID.HeaderText = "ID";
            this.ID.MaxInputLength = 8;
            this.ID.Name = "ID";
            this.ID.ReadOnly = true;
            this.ID.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.ID.ToolTipText = "Song cache identifier";
            this.ID.Width = 60;
            // 
            // Title
            // 
            this.Title.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Title.HeaderText = "Title";
            this.Title.MaxInputLength = 0;
            this.Title.Name = "Title";
            this.Title.ReadOnly = true;
            // 
            // Artist
            // 
            this.Artist.HeaderText = "Artist";
            this.Artist.MaxInputLength = 0;
            this.Artist.Name = "Artist";
            this.Artist.ReadOnly = true;
            // 
            // Size
            // 
            this.Filesize.HeaderText = "Size";
            this.Filesize.MaxInputLength = 0;
            this.Filesize.Name = "Size";
            this.Filesize.ReadOnly = true;
            this.Filesize.Width = 50;
            // 
            // Indexed
            // 
            this.Indexed.HeaderText = "Indexed";
            this.Indexed.MaxInputLength = 5;
            this.Indexed.Name = "Indexed";
            this.Indexed.ReadOnly = true;
            this.Indexed.ToolTipText = "Shows if song is included in database or not. If result is -1, that means that it" +
    " isn\'t.";
            this.Indexed.Width = 50;
            // 
            // songcache
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(423, 18);
            this.Controls.Add(this.cache);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "songcache";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Song Cache";
            ((System.ComponentModel.ISupportInitialize)(this.cache)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView cache;
        private System.Windows.Forms.DataGridViewTextBoxColumn ID;
        private System.Windows.Forms.DataGridViewTextBoxColumn Title;
        private System.Windows.Forms.DataGridViewTextBoxColumn Artist;
        private System.Windows.Forms.DataGridViewTextBoxColumn Filesize;
        private System.Windows.Forms.DataGridViewTextBoxColumn Indexed;
    }
}