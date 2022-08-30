namespace FastGH3
{
    partial class songtxtfmt
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(songtxtfmt));
            this.inputBox = new System.Windows.Forms.TextBox();
            this.usageTxt = new System.Windows.Forms.Label();
            this.exampleTxt = new System.Windows.Forms.Label();
            this.confirm = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // inputBox
            // 
            this.inputBox.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.inputBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.inputBox.Location = new System.Drawing.Point(0, 0);
            this.inputBox.Multiline = true;
            this.inputBox.Name = "inputBox";
            this.inputBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.inputBox.Size = new System.Drawing.Size(332, 112);
            this.inputBox.TabIndex = 0;
            this.inputBox.Text = "%a - %t";
            this.inputBox.TextChanged += new System.EventHandler(this.inputChanged);
            // 
            // usageTxt
            // 
            this.usageTxt.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.usageTxt.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.usageTxt.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.usageTxt.Location = new System.Drawing.Point(0, 115);
            this.usageTxt.Name = "usageTxt";
            this.usageTxt.Size = new System.Drawing.Size(288, 38);
            this.usageTxt.TabIndex = 1;
            this.usageTxt.Text = "%a - Author, %t - Title, %b - Album, %% - Percent,\r\n%c - Charter, %y - year, %l -" +
    " Duration, %g - Genre";
            // 
            // exampleTxt
            // 
            this.exampleTxt.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.exampleTxt.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.exampleTxt.Location = new System.Drawing.Point(0, 156);
            this.exampleTxt.Name = "exampleTxt";
            this.exampleTxt.Size = new System.Drawing.Size(332, 129);
            this.exampleTxt.TabIndex = 2;
            this.exampleTxt.Text = "Example:";
            // 
            // confirm
            // 
            this.confirm.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.confirm.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.confirm.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.confirm.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.confirm.Location = new System.Drawing.Point(294, 115);
            this.confirm.Name = "confirm";
            this.confirm.Size = new System.Drawing.Size(38, 38);
            this.confirm.TabIndex = 3;
            this.confirm.Text = "Set";
            this.confirm.UseVisualStyleBackColor = true;
            // 
            // songtxtfmt
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(332, 284);
            this.Controls.Add(this.confirm);
            this.Controls.Add(this.exampleTxt);
            this.Controls.Add(this.usageTxt);
            this.Controls.Add(this.inputBox);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimumSize = new System.Drawing.Size(340, 320);
            this.Name = "songtxtfmt";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Set currentsong.txt format";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox inputBox;
        private System.Windows.Forms.Label usageTxt;
        private System.Windows.Forms.Label exampleTxt;
        private System.Windows.Forms.Button confirm;
    }
}