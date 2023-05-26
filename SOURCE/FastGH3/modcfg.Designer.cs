partial class modcfg
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
            this.paramTemplate = new System.Windows.Forms.Panel();
            this.param0_resetbtn = new System.Windows.Forms.Button();
            this.param0_lbl = new System.Windows.Forms.Label();
            this.tooltip = new System.Windows.Forms.ToolTip(this.components);
            this.paramTemplate.SuspendLayout();
            this.SuspendLayout();
            // 
            // paramTemplate
            // 
            this.paramTemplate.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.paramTemplate.Controls.Add(this.param0_resetbtn);
            this.paramTemplate.Controls.Add(this.param0_lbl);
            this.paramTemplate.Location = new System.Drawing.Point(5, 6);
            this.paramTemplate.Name = "paramTemplate";
            this.paramTemplate.Size = new System.Drawing.Size(307, 56);
            this.paramTemplate.TabIndex = 0;
            this.paramTemplate.Visible = false;
            // 
            // param0_resetbtn
            // 
            this.param0_resetbtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.param0_resetbtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.param0_resetbtn.Location = new System.Drawing.Point(255, 3);
            this.param0_resetbtn.Name = "param0_resetbtn";
            this.param0_resetbtn.Size = new System.Drawing.Size(49, 23);
            this.param0_resetbtn.TabIndex = 1;
            this.param0_resetbtn.Text = "Reset";
            this.param0_resetbtn.UseVisualStyleBackColor = true;
            // 
            // param0_lbl
            // 
            this.param0_lbl.AutoSize = true;
            this.param0_lbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.param0_lbl.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.param0_lbl.Location = new System.Drawing.Point(2, 2);
            this.param0_lbl.Name = "param0_lbl";
            this.param0_lbl.Size = new System.Drawing.Size(95, 18);
            this.param0_lbl.TabIndex = 0;
            this.param0_lbl.Text = "parameter_0:";
            // 
            // tooltip
            // 
            this.tooltip.AutomaticDelay = 200;
            this.tooltip.AutoPopDelay = 60000;
            this.tooltip.InitialDelay = 200;
            this.tooltip.IsBalloon = true;
            this.tooltip.ReshowDelay = 40;
            this.tooltip.ToolTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.tooltip.ToolTipTitle = "About this parameter";
            this.tooltip.UseFading = false;
            // 
            // modcfg
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(318, 390);
            this.Controls.Add(this.paramTemplate);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "modcfg";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Mod Settings";
            this.paramTemplate.ResumeLayout(false);
            this.paramTemplate.PerformLayout();
            this.ResumeLayout(false);

	}

	#endregion

	private System.Windows.Forms.Panel paramTemplate;
	private System.Windows.Forms.Label param0_lbl;
	private System.Windows.Forms.Button param0_resetbtn;
    private System.Windows.Forms.ToolTip tooltip;
}