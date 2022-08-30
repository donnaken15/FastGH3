using System.IO;
using System.Windows.Forms;

namespace FastGH3
{
    partial class settings
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

        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.ok = new System.Windows.Forms.Button();
            this.reslabel = new System.Windows.Forms.Label();
            this.hypers = new System.Windows.Forms.NumericUpDown();
            this.hyperlabel = new System.Windows.Forms.Label();
            this.diff = new System.Windows.Forms.ComboBox();
            this.difflabel = new System.Windows.Forms.Label();
            this.importonly = new System.Windows.Forms.CheckBox();
            this.creditlink = new System.Windows.Forms.LinkLabel();
            this.tooltip = new System.Windows.Forms.ToolTip(this.components);
            this.setbgcolor = new System.Windows.Forms.Button();
            this.colorpanel = new System.Windows.Forms.Panel();
            this.speed = new System.Windows.Forms.NumericUpDown();
            this.maxnotes = new System.Windows.Forms.NumericUpDown();
            this.part = new System.Windows.Forms.ComboBox();
            this.replaygame = new System.Windows.Forms.Button();
            this.pluginmanage = new System.Windows.Forms.Button();
            this.viewsongcache = new System.Windows.Forms.Button();
            this.ctmpb = new System.Windows.Forms.Button();
            this.tweaksbtn = new System.Windows.Forms.Button();
            this.songtxtfmt_ = new System.Windows.Forms.Button();
            this.res = new System.Windows.Forms.ComboBox();
            this.backgroundcolordiag = new System.Windows.Forms.ColorDialog();
            this.speedlabel = new System.Windows.Forms.Label();
            this.maxnoteslbl = new System.Windows.Forms.Label();
            this.instlabel = new System.Windows.Forms.Label();
            this.tweaksList = new System.Windows.Forms.CheckedListBox();
            ((System.ComponentModel.ISupportInitialize)(this.hypers)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.speed)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxnotes)).BeginInit();
            this.SuspendLayout();
            // 
            // ok
            // 
            this.ok.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.ok.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.ok.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.ok.Location = new System.Drawing.Point(244, 270);
            this.ok.Name = "ok";
            this.ok.Size = new System.Drawing.Size(29, 23);
            this.ok.TabIndex = 0;
            this.ok.Text = "OK";
            this.tooltip.SetToolTip(this.ok, "Exit dialog.");
            this.ok.UseVisualStyleBackColor = true;
            this.ok.Click += new System.EventHandler(this.ok_Click);
            // 
            // reslabel
            // 
            this.reslabel.AutoSize = true;
            this.reslabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.reslabel.Location = new System.Drawing.Point(4, 6);
            this.reslabel.Name = "reslabel";
            this.reslabel.Size = new System.Drawing.Size(60, 13);
            this.reslabel.TabIndex = 1;
            this.reslabel.Text = "Resolution:";
            // 
            // hypers
            // 
            this.hypers.Location = new System.Drawing.Point(118, 27);
            this.hypers.Maximum = new decimal(new int[] {
            5,
            0,
            0,
            0});
            this.hypers.Name = "hypers";
            this.hypers.Size = new System.Drawing.Size(32, 20);
            this.hypers.TabIndex = 3;
            this.tooltip.SetToolTip(this.hypers, "Useful if you don\'t want to goto cheats\r\neverytime to change the hyperspeed.");
            this.hypers.ValueChanged += new System.EventHandler(this.hypers_ValueChanged);
            // 
            // hyperlabel
            // 
            this.hyperlabel.AutoSize = true;
            this.hyperlabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.hyperlabel.Location = new System.Drawing.Point(4, 30);
            this.hyperlabel.Name = "hyperlabel";
            this.hyperlabel.Size = new System.Drawing.Size(104, 13);
            this.hyperlabel.TabIndex = 4;
            this.hyperlabel.Text = "Default Hyperspeed:";
            // 
            // diff
            // 
            this.diff.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.diff.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.diff.FormattingEnabled = true;
            this.diff.Items.AddRange(new object[] {
            "Easy",
            "Medium",
            "Hard",
            "Expert"});
            this.diff.Location = new System.Drawing.Point(91, 53);
            this.diff.Name = "diff";
            this.diff.Size = new System.Drawing.Size(59, 21);
            this.diff.TabIndex = 5;
            this.tooltip.SetToolTip(this.diff, "Useful if you don\'t want to goto options\r\nand select a different difficulty every" +
        "time.\r\nThis applies for both player difficulties.");
            this.diff.SelectedIndexChanged += new System.EventHandler(this.diff_SelectedIndexChanged);
            // 
            // difflabel
            // 
            this.difflabel.AutoSize = true;
            this.difflabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.difflabel.Location = new System.Drawing.Point(4, 56);
            this.difflabel.Name = "difflabel";
            this.difflabel.Size = new System.Drawing.Size(87, 13);
            this.difflabel.TabIndex = 6;
            this.difflabel.Text = "Default Difficulty:";
            // 
            // importonly
            // 
            this.importonly.AutoSize = true;
            this.importonly.Enabled = false;
            this.importonly.Location = new System.Drawing.Point(177, 217);
            this.importonly.Name = "importonly";
            this.importonly.Size = new System.Drawing.Size(103, 17);
            this.importonly.TabIndex = 7;
            this.importonly.Text = "Import song only";
            this.tooltip.SetToolTip(this.importonly, "This will make it so that the launcher only\r\nimports the song rather than startin" +
        "g up the\r\ngame after import is successful.");
            this.importonly.UseVisualStyleBackColor = true;
            this.importonly.Visible = false;
            // 
            // creditlink
            // 
            this.creditlink.ActiveLinkColor = System.Drawing.Color.Black;
            this.creditlink.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.creditlink.AutoSize = true;
            this.creditlink.LinkBehavior = System.Windows.Forms.LinkBehavior.NeverUnderline;
            this.creditlink.LinkColor = System.Drawing.Color.Black;
            this.creditlink.Location = new System.Drawing.Point(12, 283);
            this.creditlink.Name = "creditlink";
            this.creditlink.Size = new System.Drawing.Size(39, 13);
            this.creditlink.TabIndex = 8;
            this.creditlink.TabStop = true;
            this.creditlink.Text = "Credits";
            this.tooltip.SetToolTip(this.creditlink, "Credits will be displayed in console.");
            this.creditlink.VisitedLinkColor = System.Drawing.Color.White;
            this.creditlink.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.creditlink_LinkClicked);
            // 
            // tooltip
            // 
            this.tooltip.AutomaticDelay = 0;
            this.tooltip.AutoPopDelay = 9999999;
            this.tooltip.InitialDelay = 1;
            this.tooltip.IsBalloon = true;
            this.tooltip.ReshowDelay = 0;
            this.tooltip.ShowAlways = true;
            this.tooltip.ToolTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.tooltip.ToolTipTitle = "About this setting";
            this.tooltip.UseAnimation = false;
            this.tooltip.UseFading = false;
            this.tooltip.Popup += new System.Windows.Forms.PopupEventHandler(this.tooltip_Popup);
            // 
            // setbgcolor
            // 
            this.setbgcolor.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.setbgcolor.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F);
            this.setbgcolor.ImageAlign = System.Drawing.ContentAlignment.TopLeft;
            this.setbgcolor.Location = new System.Drawing.Point(4, 80);
            this.setbgcolor.Name = "setbgcolor";
            this.setbgcolor.Size = new System.Drawing.Size(117, 23);
            this.setbgcolor.TabIndex = 11;
            this.setbgcolor.Text = "Set background color";
            this.tooltip.SetToolTip(this.setbgcolor, "Set current background color when playing a song.");
            this.setbgcolor.UseVisualStyleBackColor = true;
            this.setbgcolor.Click += new System.EventHandler(this.setbgcolor_Click);
            // 
            // colorpanel
            // 
            this.colorpanel.BackColor = System.Drawing.Color.Black;
            this.colorpanel.Cursor = System.Windows.Forms.Cursors.Help;
            this.colorpanel.Location = new System.Drawing.Point(127, 80);
            this.colorpanel.Name = "colorpanel";
            this.colorpanel.Size = new System.Drawing.Size(23, 23);
            this.colorpanel.TabIndex = 12;
            this.tooltip.SetToolTip(this.colorpanel, "Background color that\'s going to be shown in the game.\r\nDouble click to see a lar" +
        "ger preview of how it will look.");
            this.colorpanel.DoubleClick += new System.EventHandler(this.colorpanel_Click);
            // 
            // speed
            // 
            this.speed.DecimalPlaces = 3;
            this.speed.Location = new System.Drawing.Point(189, 3);
            this.speed.Maximum = new decimal(new int[] {
            -1981284353,
            -1966660860,
            0,
            0});
            this.speed.Minimum = new decimal(new int[] {
            1661992959,
            1808227885,
            5,
            -2147483648});
            this.speed.Name = "speed";
            this.speed.Size = new System.Drawing.Size(82, 20);
            this.speed.TabIndex = 13;
            this.speed.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.tooltip.SetToolTip(this.speed, "Enter percentage of song speed.");
            this.speed.Value = new decimal(new int[] {
            100,
            0,
            0,
            0});
            this.speed.ValueChanged += new System.EventHandler(this.speed_ValueChanged);
            // 
            // maxnotes
            // 
            this.maxnotes.Location = new System.Drawing.Point(208, 27);
            this.maxnotes.Maximum = new decimal(new int[] {
            2147483647,
            0,
            0,
            0});
            this.maxnotes.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.maxnotes.Name = "maxnotes";
            this.maxnotes.Size = new System.Drawing.Size(72, 20);
            this.maxnotes.TabIndex = 18;
            this.tooltip.SetToolTip(this.maxnotes, "Override the note limit. Set to -1 to make\r\nthe program determine how many notes\r" +
        "\nthere are in the chart opened.\r\nRAM usage may vary.");
            this.maxnotes.ValueChanged += new System.EventHandler(this.maxnotes_ValueChanged);
            // 
            // part
            // 
            this.part.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.part.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.part.FormattingEnabled = true;
            this.part.Items.AddRange(new object[] {
            "Guitar",
            "Bass"});
            this.part.Location = new System.Drawing.Point(210, 52);
            this.part.Name = "part";
            this.part.Size = new System.Drawing.Size(70, 21);
            this.part.TabIndex = 22;
            this.tooltip.SetToolTip(this.part, "Change instrument or track to be played in game.");
            this.part.SelectedIndexChanged += new System.EventHandler(this.part_SelectedIndexChanged);
            // 
            // replaygame
            // 
            this.replaygame.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.replaygame.Location = new System.Drawing.Point(156, 79);
            this.replaygame.Name = "replaygame";
            this.replaygame.Size = new System.Drawing.Size(124, 24);
            this.replaygame.TabIndex = 20;
            this.replaygame.Text = "Replay Last Song";
            this.tooltip.SetToolTip(this.replaygame, "Relaunch FastGH3 with the previous song in-place.");
            this.replaygame.UseVisualStyleBackColor = true;
            this.replaygame.Click += new System.EventHandler(this.replaygame_Click);
            // 
            // pluginmanage
            // 
            this.pluginmanage.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.pluginmanage.Location = new System.Drawing.Point(4, 109);
            this.pluginmanage.Name = "pluginmanage";
            this.pluginmanage.Size = new System.Drawing.Size(87, 23);
            this.pluginmanage.TabIndex = 23;
            this.pluginmanage.Text = "Manage Plugins";
            this.tooltip.SetToolTip(this.pluginmanage, "Select what plugins should be loaded or disabled.");
            this.pluginmanage.UseVisualStyleBackColor = true;
            this.pluginmanage.Click += new System.EventHandler(this.pluginmanage_Click);
            // 
            // viewsongcache
            // 
            this.viewsongcache.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.viewsongcache.Location = new System.Drawing.Point(97, 109);
            this.viewsongcache.Name = "viewsongcache";
            this.viewsongcache.Size = new System.Drawing.Size(78, 23);
            this.viewsongcache.TabIndex = 25;
            this.viewsongcache.Text = "Song Cache";
            this.tooltip.SetToolTip(this.viewsongcache, "View song cache files.");
            this.viewsongcache.UseVisualStyleBackColor = true;
            this.viewsongcache.Click += new System.EventHandler(this.viewsongcache_Click);
            // 
            // ctmpb
            // 
            this.ctmpb.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.ctmpb.Location = new System.Drawing.Point(181, 109);
            this.ctmpb.Name = "ctmpb";
            this.ctmpb.Size = new System.Drawing.Size(99, 23);
            this.ctmpb.TabIndex = 31;
            this.ctmpb.Text = "Clean Temp Files";
            this.tooltip.SetToolTip(this.ctmpb, "Clean files from downloading and extracting Song Packages.\r\nWarning: Reuse of the" +
        "se files will require downloading and\r\nextracting them again, some of which can " +
        "take a bit of time.");
            this.ctmpb.UseVisualStyleBackColor = true;
            this.ctmpb.Click += new System.EventHandler(this.ctmpb_Click);
            // 
            // tweaksbtn
            // 
            this.tweaksbtn.Location = new System.Drawing.Point(187, 231);
            this.tweaksbtn.Name = "tweaksbtn";
            this.tweaksbtn.Size = new System.Drawing.Size(99, 23);
            this.tweaksbtn.TabIndex = 32;
            this.tweaksbtn.Text = "Game Tweaks";
            this.tooltip.SetToolTip(this.tweaksbtn, "More settings!");
            this.tweaksbtn.UseVisualStyleBackColor = true;
            this.tweaksbtn.Visible = false;
            // 
            // songtxtfmt_
            // 
            this.songtxtfmt_.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.songtxtfmt_.Location = new System.Drawing.Point(181, 138);
            this.songtxtfmt_.Name = "songtxtfmt_";
            this.songtxtfmt_.Size = new System.Drawing.Size(99, 23);
            this.songtxtfmt_.TabIndex = 33;
            this.songtxtfmt_.Text = "Song Text Format";
            this.tooltip.SetToolTip(this.songtxtfmt_, "Change the format of currentsong.txt. Can be useful for streaming.");
            this.songtxtfmt_.UseVisualStyleBackColor = true;
            this.songtxtfmt_.Click += new System.EventHandler(this.songtxtfmt__Click);
            // 
            // res
            // 
            this.res.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.res.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.res.FormattingEnabled = true;
            this.res.Location = new System.Drawing.Point(66, 3);
            this.res.Name = "res";
            this.res.Size = new System.Drawing.Size(84, 21);
            this.res.TabIndex = 2;
            this.tooltip.SetToolTip(this.res, "This allows you to change the window size of the game.");
            this.res.SelectedIndexChanged += new System.EventHandler(this.res_SelectedIndexChanged);
            // 
            // backgroundcolordiag
            // 
            this.backgroundcolordiag.AnyColor = true;
            this.backgroundcolordiag.FullOpen = true;
            // 
            // speedlabel
            // 
            this.speedlabel.AutoSize = true;
            this.speedlabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.speedlabel.Location = new System.Drawing.Point(153, 6);
            this.speedlabel.Name = "speedlabel";
            this.speedlabel.Size = new System.Drawing.Size(133, 13);
            this.speedlabel.TabIndex = 14;
            this.speedlabel.Text = "Speed:                            %";
            // 
            // maxnoteslbl
            // 
            this.maxnoteslbl.AutoSize = true;
            this.maxnoteslbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.maxnoteslbl.Location = new System.Drawing.Point(153, 30);
            this.maxnoteslbl.Name = "maxnoteslbl";
            this.maxnoteslbl.Size = new System.Drawing.Size(62, 13);
            this.maxnoteslbl.TabIndex = 17;
            this.maxnoteslbl.Text = "Max notes: ";
            // 
            // instlabel
            // 
            this.instlabel.AutoSize = true;
            this.instlabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.instlabel.Location = new System.Drawing.Point(153, 56);
            this.instlabel.Name = "instlabel";
            this.instlabel.Size = new System.Drawing.Size(59, 13);
            this.instlabel.TabIndex = 21;
            this.instlabel.Text = "Instrument:";
            // 
            // tweaksList
            // 
            this.tweaksList.CheckOnClick = true;
            this.tweaksList.FormattingEnabled = true;
            this.tweaksList.IntegralHeight = false;
            this.tweaksList.Items.AddRange(new object[] {
            "Song caching",
            "Verbose logging",
            "Preserve log",
            "Disable Vsync",
            "No startup message",
            "Exit on song end",
            "Keyboard mode",
            "Debug menu",
            "No intro",
            "No particles",
            "No fail",
            "Background video"});
            this.tweaksList.Location = new System.Drawing.Point(4, 138);
            this.tweaksList.Name = "tweaksList";
            this.tweaksList.Size = new System.Drawing.Size(171, 135);
            this.tweaksList.TabIndex = 30;
            this.tweaksList.ThreeDCheckBoxes = true;
            this.tweaksList.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.inputChanged);
            this.tweaksList.SelectedIndexChanged += new System.EventHandler(this.updateTweakBoxes);
            // 
            // settings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(285, 305);
            this.Controls.Add(this.songtxtfmt_);
            this.Controls.Add(this.tweaksbtn);
            this.Controls.Add(this.ctmpb);
            this.Controls.Add(this.tweaksList);
            this.Controls.Add(this.viewsongcache);
            this.Controls.Add(this.pluginmanage);
            this.Controls.Add(this.part);
            this.Controls.Add(this.instlabel);
            this.Controls.Add(this.replaygame);
            this.Controls.Add(this.maxnotes);
            this.Controls.Add(this.maxnoteslbl);
            this.Controls.Add(this.speed);
            this.Controls.Add(this.speedlabel);
            this.Controls.Add(this.colorpanel);
            this.Controls.Add(this.setbgcolor);
            this.Controls.Add(this.creditlink);
            this.Controls.Add(this.importonly);
            this.Controls.Add(this.diff);
            this.Controls.Add(this.difflabel);
            this.Controls.Add(this.hyperlabel);
            this.Controls.Add(this.hypers);
            this.Controls.Add(this.res);
            this.Controls.Add(this.reslabel);
            this.Controls.Add(this.ok);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "settings";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FastGH3 settings";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.settings_FormClosing);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.keydownreacts);
            ((System.ComponentModel.ISupportInitialize)(this.hypers)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.speed)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxnotes)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private void Colorpanel_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            throw new System.NotImplementedException();
        }

        #endregion

        private Button ok;
        private Label reslabel;
        private NumericUpDown hypers;
        private Label hyperlabel;
        private ComboBox diff;
        private Label difflabel;
        private CheckBox importonly;
        private LinkLabel creditlink;
        private ToolTip tooltip;
        private ColorDialog backgroundcolordiag;
        private Button setbgcolor;
        private Panel colorpanel;
        private NumericUpDown speed;
        private Label speedlabel;
        private Label maxnoteslbl;
        private NumericUpDown maxnotes;
        private Button replaygame;
        private Label instlabel;
        private ComboBox part;
        private Button pluginmanage;
        private Button viewsongcache;
        private CheckedListBox tweaksList;
        private Button ctmpb;
        private Button tweaksbtn;
        private Button songtxtfmt_;
        private ComboBox res;
    }
}