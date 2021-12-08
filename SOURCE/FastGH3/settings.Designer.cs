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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(settings));
            this.ok = new System.Windows.Forms.Button();
            this.reslabel = new System.Windows.Forms.Label();
            this.res = new System.Windows.Forms.ComboBox();
            this.hypers = new System.Windows.Forms.NumericUpDown();
            this.hyperlabel = new System.Windows.Forms.Label();
            this.diff = new System.Windows.Forms.ComboBox();
            this.difflabel = new System.Windows.Forms.Label();
            this.importonly = new System.Windows.Forms.CheckBox();
            this.creditlink = new System.Windows.Forms.LinkLabel();
            this.tooltip = new System.Windows.Forms.ToolTip(this.components);
            this.scrshmode = new System.Windows.Forms.CheckBox();
            this.nostatsonend = new System.Windows.Forms.CheckBox();
            this.setbgcolor = new System.Windows.Forms.Button();
            this.colorpanel = new System.Windows.Forms.Panel();
            this.speed = new System.Windows.Forms.NumericUpDown();
            this.nofailviewer = new System.Windows.Forms.CheckBox();
            this.vsyncswitch = new System.Windows.Forms.CheckBox();
            this.maxnotes = new System.Windows.Forms.NumericUpDown();
            this.part = new System.Windows.Forms.ComboBox();
            this.replaygame = new System.Windows.Forms.Button();
            this.pluginmanage = new System.Windows.Forms.Button();
            this.songcaching = new System.Windows.Forms.CheckBox();
            this.viewsongcache = new System.Windows.Forms.Button();
            this.verboselog = new System.Windows.Forms.CheckBox();
            this.nostartupmsg = new System.Windows.Forms.CheckBox();
            this.preserveLog = new System.Windows.Forms.CheckBox();
            this.dbgmnu = new System.Windows.Forms.CheckBox();
            this.keymode = new System.Windows.Forms.CheckBox();
            this.ctmpb = new System.Windows.Forms.Button();
            this.backgroundcolordiag = new System.Windows.Forms.ColorDialog();
            this.speedlabel = new System.Windows.Forms.Label();
            this.maxnoteslbl = new System.Windows.Forms.Label();
            this.instlabel = new System.Windows.Forms.Label();
            this.miscsettings = new System.Windows.Forms.CheckedListBox();
            this.nofailcb = new System.Windows.Forms.CheckBox();
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
            this.ok.Location = new System.Drawing.Point(241, 255);
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
            this.importonly.Location = new System.Drawing.Point(12, 314);
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
            this.creditlink.Location = new System.Drawing.Point(12, 268);
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
            // scrshmode
            // 
            this.scrshmode.AutoSize = true;
            this.scrshmode.Enabled = false;
            this.scrshmode.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.scrshmode.Location = new System.Drawing.Point(12, 361);
            this.scrshmode.Name = "scrshmode";
            this.scrshmode.Size = new System.Drawing.Size(115, 18);
            this.scrshmode.TabIndex = 9;
            this.scrshmode.Text = "Screenshot mode";
            this.tooltip.SetToolTip(this.scrshmode, resources.GetString("scrshmode.ToolTip"));
            this.scrshmode.UseVisualStyleBackColor = true;
            this.scrshmode.Visible = false;
            this.scrshmode.CheckedChanged += new System.EventHandler(this.scrshmode_CheckedChanged);
            // 
            // nostatsonend
            // 
            this.nostatsonend.AutoSize = true;
            this.nostatsonend.Enabled = false;
            this.nostatsonend.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.nostatsonend.Location = new System.Drawing.Point(15, 299);
            this.nostatsonend.Name = "nostatsonend";
            this.nostatsonend.Size = new System.Drawing.Size(107, 18);
            this.nostatsonend.TabIndex = 10;
            this.nostatsonend.Text = "No stats on end";
            this.tooltip.SetToolTip(this.nostatsonend, "Won\'t display score after song is over.\r\nIt will instead close out the game.\r\nThi" +
        "s won\'t be applied for Practice mode.");
            this.nostatsonend.UseVisualStyleBackColor = true;
            this.nostatsonend.Visible = false;
            this.nostatsonend.CheckedChanged += new System.EventHandler(this.nostatsonend_CheckedChanged);
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
            // nofailviewer
            // 
            this.nofailviewer.AutoSize = true;
            this.nofailviewer.Enabled = false;
            this.nofailviewer.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.nofailviewer.Location = new System.Drawing.Point(8, 337);
            this.nofailviewer.Name = "nofailviewer";
            this.nofailviewer.Size = new System.Drawing.Size(122, 18);
            this.nofailviewer.TabIndex = 16;
            this.nofailviewer.Text = "No fail (viewercam)";
            this.tooltip.SetToolTip(this.nofailviewer, "Alternative no fail mode. However, the \r\nRock Meter can go down but at the lowest" +
        "\r\nhealth, the needle will stop and not change\r\nfor the rest of the song.");
            this.nofailviewer.UseVisualStyleBackColor = true;
            this.nofailviewer.Visible = false;
            this.nofailviewer.CheckedChanged += new System.EventHandler(this.nofailviewer_CheckedChanged);
            // 
            // vsyncswitch
            // 
            this.vsyncswitch.AutoSize = true;
            this.vsyncswitch.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.vsyncswitch.Location = new System.Drawing.Point(4, 162);
            this.vsyncswitch.Name = "vsyncswitch";
            this.vsyncswitch.Size = new System.Drawing.Size(99, 18);
            this.vsyncswitch.TabIndex = 15;
            this.vsyncswitch.Text = "Disable Vsync";
            this.tooltip.SetToolTip(this.vsyncswitch, "Get unlimited FPS.");
            this.vsyncswitch.UseVisualStyleBackColor = true;
            this.vsyncswitch.CheckedChanged += new System.EventHandler(this.vsyncswitch_CheckedChanged);
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
            this.pluginmanage.Location = new System.Drawing.Point(156, 138);
            this.pluginmanage.Name = "pluginmanage";
            this.pluginmanage.Size = new System.Drawing.Size(124, 23);
            this.pluginmanage.TabIndex = 23;
            this.pluginmanage.Text = "Manage Plugins";
            this.tooltip.SetToolTip(this.pluginmanage, "Select what plugins should be loaded or disabled.");
            this.pluginmanage.UseVisualStyleBackColor = true;
            this.pluginmanage.Click += new System.EventHandler(this.pluginmanage_Click);
            // 
            // songcaching
            // 
            this.songcaching.AutoSize = true;
            this.songcaching.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.songcaching.Location = new System.Drawing.Point(4, 109);
            this.songcaching.Name = "songcaching";
            this.songcaching.Size = new System.Drawing.Size(99, 18);
            this.songcaching.TabIndex = 24;
            this.songcaching.Text = "Song Caching";
            this.tooltip.SetToolTip(this.songcaching, "Toggle song caching. If enabled, any song that will be selected is cached for lat" +
        "er play.");
            this.songcaching.UseVisualStyleBackColor = true;
            this.songcaching.CheckedChanged += new System.EventHandler(this.songcaching_CheckedChanged);
            // 
            // viewsongcache
            // 
            this.viewsongcache.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.viewsongcache.Location = new System.Drawing.Point(156, 109);
            this.viewsongcache.Name = "viewsongcache";
            this.viewsongcache.Size = new System.Drawing.Size(124, 23);
            this.viewsongcache.TabIndex = 25;
            this.viewsongcache.Text = "Song Cache";
            this.tooltip.SetToolTip(this.viewsongcache, "View song cache files.");
            this.viewsongcache.UseVisualStyleBackColor = true;
            this.viewsongcache.Click += new System.EventHandler(this.viewsongcache_Click);
            // 
            // verboselog
            // 
            this.verboselog.AutoSize = true;
            this.verboselog.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.verboselog.Location = new System.Drawing.Point(4, 127);
            this.verboselog.Name = "verboselog";
            this.verboselog.Size = new System.Drawing.Size(112, 18);
            this.verboselog.TabIndex = 26;
            this.verboselog.Text = "Verbose Logging";
            this.tooltip.SetToolTip(this.verboselog, "Display EVERYTHING that happens during execution.");
            this.verboselog.UseVisualStyleBackColor = true;
            this.verboselog.CheckedChanged += new System.EventHandler(this.verboselog_CheckedChanged);
            // 
            // nostartupmsg
            // 
            this.nostartupmsg.AutoSize = true;
            this.nostartupmsg.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.nostartupmsg.Location = new System.Drawing.Point(4, 144);
            this.nostartupmsg.Name = "nostartupmsg";
            this.nostartupmsg.Size = new System.Drawing.Size(126, 18);
            this.nostartupmsg.TabIndex = 16;
            this.nostartupmsg.Text = "No startup message";
            this.tooltip.SetToolTip(this.nostartupmsg, "If turned on when opening the application by itself, the program will immediately" +
        " ask for a file.");
            this.nostartupmsg.UseVisualStyleBackColor = true;
            this.nostartupmsg.CheckedChanged += new System.EventHandler(this.nostartupmsg_CheckedChanged);
            // 
            // preserveLog
            // 
            this.preserveLog.AutoSize = true;
            this.preserveLog.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.preserveLog.Location = new System.Drawing.Point(4, 180);
            this.preserveLog.Name = "preserveLog";
            this.preserveLog.Size = new System.Drawing.Size(91, 18);
            this.preserveLog.TabIndex = 10;
            this.preserveLog.Text = "Preserve log";
            this.tooltip.SetToolTip(this.preserveLog, "If enabled, the program will wait for a keypress to exit.");
            this.preserveLog.UseVisualStyleBackColor = true;
            this.preserveLog.CheckedChanged += new System.EventHandler(this.preservelog_CheckedChanged);
            // 
            // dbgmnu
            // 
            this.dbgmnu.AutoSize = true;
            this.dbgmnu.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.dbgmnu.Location = new System.Drawing.Point(4, 198);
            this.dbgmnu.Name = "dbgmnu";
            this.dbgmnu.Size = new System.Drawing.Size(93, 18);
            this.dbgmnu.TabIndex = 10;
            this.dbgmnu.Text = "Debug menu";
            this.tooltip.SetToolTip(this.dbgmnu, "Enable built-in debug menu.\r\nWARNING: Don\'t use venue-type functions.");
            this.dbgmnu.UseVisualStyleBackColor = true;
            this.dbgmnu.CheckedChanged += new System.EventHandler(this.dbgmnu_CheckedChanged);
            // 
            // keymode
            // 
            this.keymode.AutoSize = true;
            this.keymode.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.keymode.Location = new System.Drawing.Point(4, 217);
            this.keymode.Name = "keymode";
            this.keymode.Size = new System.Drawing.Size(106, 18);
            this.keymode.TabIndex = 10;
            this.keymode.Text = "Keyboard mode";
            this.tooltip.SetToolTip(this.keymode, "Enable to fix key input not working without going through certain menus, or detec" +
        "ting a controller you don\'t want it to.\r\nMay require pressing green twice.");
            this.keymode.UseVisualStyleBackColor = true;
            this.keymode.CheckedChanged += new System.EventHandler(this.keymode_CheckedChanged);
            // 
            // ctmpb
            // 
            this.ctmpb.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.ctmpb.Location = new System.Drawing.Point(156, 167);
            this.ctmpb.Name = "ctmpb";
            this.ctmpb.Size = new System.Drawing.Size(124, 23);
            this.ctmpb.TabIndex = 31;
            this.ctmpb.Text = "Clean Temp Files";
            this.tooltip.SetToolTip(this.ctmpb, "Clean files from downloading and extracting Song Packages.\r\nWarning: Reuse of the" +
        "se files will require downloading and\r\nextracting them again, some of which can " +
        "take a bit of time.");
            this.ctmpb.UseVisualStyleBackColor = true;
            this.ctmpb.Click += new System.EventHandler(this.ctmpb_Click);
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
            // miscsettings
            // 
            this.miscsettings.Enabled = false;
            this.miscsettings.FormattingEnabled = true;
            this.miscsettings.Items.AddRange(new object[] {
            "Song caching",
            "No stats on end",
            "Disable Vsync",
            "Verbose logging",
            "No startup message",
            "Press start to play",
            "Lefty flip"});
            this.miscsettings.Location = new System.Drawing.Point(156, 270);
            this.miscsettings.Name = "miscsettings";
            this.miscsettings.Size = new System.Drawing.Size(127, 109);
            this.miscsettings.TabIndex = 30;
            this.miscsettings.Visible = false;
            // 
            // nofailcb
            // 
            this.nofailcb.AutoSize = true;
            this.nofailcb.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.nofailcb.Location = new System.Drawing.Point(4, 237);
            this.nofailcb.Name = "nofailcb";
            this.nofailcb.Size = new System.Drawing.Size(62, 18);
            this.nofailcb.TabIndex = 10;
            this.nofailcb.Text = "No fail";
            this.nofailcb.UseVisualStyleBackColor = true;
            this.nofailcb.CheckedChanged += new System.EventHandler(this.nofail_CheckedChanged);
            // 
            // settings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(282, 290);
            this.Controls.Add(this.ctmpb);
            this.Controls.Add(this.miscsettings);
            this.Controls.Add(this.verboselog);
            this.Controls.Add(this.viewsongcache);
            this.Controls.Add(this.songcaching);
            this.Controls.Add(this.pluginmanage);
            this.Controls.Add(this.part);
            this.Controls.Add(this.instlabel);
            this.Controls.Add(this.replaygame);
            this.Controls.Add(this.maxnotes);
            this.Controls.Add(this.maxnoteslbl);
            this.Controls.Add(this.nostartupmsg);
            this.Controls.Add(this.nofailviewer);
            this.Controls.Add(this.vsyncswitch);
            this.Controls.Add(this.speed);
            this.Controls.Add(this.speedlabel);
            this.Controls.Add(this.colorpanel);
            this.Controls.Add(this.setbgcolor);
            this.Controls.Add(this.nofailcb);
            this.Controls.Add(this.keymode);
            this.Controls.Add(this.dbgmnu);
            this.Controls.Add(this.preserveLog);
            this.Controls.Add(this.nostatsonend);
            this.Controls.Add(this.scrshmode);
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
        private ComboBox res;
        private NumericUpDown hypers;
        private Label hyperlabel;
        private ComboBox diff;
        private Label difflabel;
        private CheckBox importonly;
        private LinkLabel creditlink;
        private ToolTip tooltip;
        private CheckBox scrshmode;
        private CheckBox nostatsonend;
        private ColorDialog backgroundcolordiag;
        private Button setbgcolor;
        private Panel colorpanel;
        private NumericUpDown speed;
        private Label speedlabel;
        private CheckBox vsyncswitch;
        private CheckBox nofailviewer;
        private Label maxnoteslbl;
        private NumericUpDown maxnotes;
        private Button replaygame;
        private Label instlabel;
        private ComboBox part;
        private Button pluginmanage;
        private CheckBox songcaching;
        private Button viewsongcache;
        private CheckBox verboselog;
        private CheckedListBox miscsettings;
        private CheckBox nostartupmsg;
        private CheckBox preserveLog;
        private CheckBox dbgmnu;
        private CheckBox keymode;
        private CheckBox nofailcb;
        private Button ctmpb;
    }
}