using System.IO;
using System.Windows.Forms;

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
            this.resL = new System.Windows.Forms.Label();
            this.hypers = new System.Windows.Forms.NumericUpDown();
            this.hLabel = new System.Windows.Forms.Label();
            this.diff = new System.Windows.Forms.ComboBox();
            this.dfLabel = new System.Windows.Forms.Label();
            this.crLink = new System.Windows.Forms.LinkLabel();
            this.tt = new System.Windows.Forms.ToolTip(this.components);
            this.speed = new System.Windows.Forms.NumericUpDown();
            this.part = new System.Windows.Forms.ComboBox();
            this.replay = new System.Windows.Forms.Button();
            this.gh3pm = new System.Windows.Forms.Button();
            this.sCa = new System.Windows.Forms.Button();
            this.sFmT = new System.Windows.Forms.Button();
            this.RTnoi = new System.Windows.Forms.NumericUpDown();
            this.kBnds = new System.Windows.Forms.Button();
            this.p2partt = new System.Windows.Forms.CheckBox();
            this.setbgimg = new System.Windows.Forms.Button();
            this.bImg = new System.Windows.Forms.PictureBox();
            this.dCtrl = new System.Windows.Forms.NumericUpDown();
            this.aqlvl = new System.Windows.Forms.NumericUpDown();
            this.ctmpb = new System.Windows.Forms.Button();
            this.res = new System.Windows.Forms.ComboBox();
            this.MaxN = new System.Windows.Forms.NumericUpDown();
            this.maxFPS = new System.Windows.Forms.NumericUpDown();
            this.spL = new System.Windows.Forms.Label();
            this.mXnL = new System.Windows.Forms.Label();
            this.iL = new System.Windows.Forms.Label();
            this.tLb = new System.Windows.Forms.CheckedListBox();
            this.RTlbl = new System.Windows.Forms.Label();
            this.RTms = new System.Windows.Forms.Label();
            this.mFPSl = new System.Windows.Forms.Label();
            this.FPSl = new System.Windows.Forms.Label();
            this.tPanel = new System.Windows.Forms.Panel();
            this.kbpslbl = new System.Windows.Forms.Label();
            this.aqlbl = new System.Windows.Forms.Label();
            this.modList = new System.Windows.Forms.CheckedListBox();
            this.modl = new System.Windows.Forms.Label();
            this.tLabel = new System.Windows.Forms.Label();
            this.selImg = new System.Windows.Forms.OpenFileDialog();
            this.vlbl = new System.Windows.Forms.Label();
            this.dCtrlLBL = new System.Windows.Forms.Label();
            this.modelbl = new System.Windows.Forms.Label();
            this.mode = new System.Windows.Forms.ComboBox();
            this.modsbtn = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.hypers)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.speed)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.RTnoi)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.bImg)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dCtrl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.aqlvl)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.MaxN)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxFPS)).BeginInit();
            this.tPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // ok
            // 
            this.ok.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.ok.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.ok.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.ok.Font = new System.Drawing.Font("Microsoft Sans Serif", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ok.Location = new System.Drawing.Point(242, 446);
            this.ok.Name = "ok";
            this.ok.Size = new System.Drawing.Size(34, 25);
            this.ok.TabIndex = 0;
            this.ok.Text = "OK";
            this.tt.SetToolTip(this.ok, "Exit dialog.");
            this.ok.UseVisualStyleBackColor = true;
            // 
            // resL
            // 
            this.resL.AutoSize = true;
            this.resL.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.resL.Location = new System.Drawing.Point(4, 6);
            this.resL.Name = "resL";
            this.resL.Size = new System.Drawing.Size(60, 13);
            this.resL.TabIndex = 1;
            this.resL.Text = "Resolution:";
            // 
            // hypers
            // 
            this.hypers.Location = new System.Drawing.Point(106, 26);
            this.hypers.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.hypers.Minimum = new decimal(new int[] {
            10,
            0,
            0,
            -2147483648});
            this.hypers.Name = "hypers";
            this.hypers.Size = new System.Drawing.Size(42, 20);
            this.hypers.TabIndex = 3;
            this.hypers.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.hypers.ValueChanged += new System.EventHandler(this.hyVC);
            // 
            // hLabel
            // 
            this.hLabel.AutoSize = true;
            this.hLabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.hLabel.Location = new System.Drawing.Point(4, 30);
            this.hLabel.Name = "hLabel";
            this.hLabel.Size = new System.Drawing.Size(104, 13);
            this.hLabel.TabIndex = 4;
            this.hLabel.Text = "Default Hyperspeed:";
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
            this.diff.Location = new System.Drawing.Point(90, 52);
            this.diff.Name = "diff";
            this.diff.Size = new System.Drawing.Size(58, 21);
            this.diff.TabIndex = 5;
            this.diff.SelectedIndexChanged += new System.EventHandler(this.diffC);
            // 
            // dfLabel
            // 
            this.dfLabel.AutoSize = true;
            this.dfLabel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.dfLabel.Location = new System.Drawing.Point(4, 55);
            this.dfLabel.Name = "dfLabel";
            this.dfLabel.Size = new System.Drawing.Size(87, 13);
            this.dfLabel.TabIndex = 6;
            this.dfLabel.Text = "Default Difficulty:";
            // 
            // crLink
            // 
            this.crLink.ActiveLinkColor = System.Drawing.Color.Black;
            this.crLink.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.crLink.AutoSize = true;
            this.crLink.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.crLink.LinkBehavior = System.Windows.Forms.LinkBehavior.NeverUnderline;
            this.crLink.LinkColor = System.Drawing.Color.Black;
            this.crLink.Location = new System.Drawing.Point(177, 448);
            this.crLink.Name = "crLink";
            this.crLink.Size = new System.Drawing.Size(59, 20);
            this.crLink.TabIndex = 8;
            this.crLink.TabStop = true;
            this.crLink.Text = "Credits";
            this.crLink.VisitedLinkColor = System.Drawing.Color.White;
            this.crLink.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.crlink);
            // 
            // tt
            // 
            this.tt.AutomaticDelay = 0;
            this.tt.AutoPopDelay = 9999999;
            this.tt.InitialDelay = 500;
            this.tt.IsBalloon = true;
            this.tt.ReshowDelay = 0;
            this.tt.ShowAlways = true;
            this.tt.ToolTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.tt.ToolTipTitle = "About this setting";
            this.tt.UseAnimation = false;
            this.tt.UseFading = false;
            // 
            // speed
            // 
            this.speed.DecimalPlaces = 3;
            this.speed.Location = new System.Drawing.Point(185, 3);
            this.speed.Maximum = new decimal(new int[] {
            -1981284353,
            -1966660860,
            0,
            0});
            this.speed.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.speed.Name = "speed";
            this.speed.Size = new System.Drawing.Size(82, 20);
            this.speed.TabIndex = 13;
            this.speed.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.speed.Value = new decimal(new int[] {
            100,
            0,
            0,
            0});
            this.speed.ValueChanged += new System.EventHandler(this.spVC);
            // 
            // part
            // 
            this.part.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.part.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.part.FormattingEnabled = true;
            this.part.Items.AddRange(new object[] {
            "Guitar",
            "Rhythm"});
            this.part.Location = new System.Drawing.Point(204, 52);
            this.part.Name = "part";
            this.part.Size = new System.Drawing.Size(72, 21);
            this.part.TabIndex = 22;
            this.part.SelectedIndexChanged += new System.EventHandler(this.pVC);
            // 
            // replay
            // 
            this.replay.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.replay.Location = new System.Drawing.Point(150, 77);
            this.replay.Name = "replay";
            this.replay.Size = new System.Drawing.Size(126, 19);
            this.replay.TabIndex = 20;
            this.replay.Text = "Replay Last Song";
            this.replay.UseVisualStyleBackColor = true;
            this.replay.Click += new System.EventHandler(this.rGc);
            // 
            // gh3pm
            // 
            this.gh3pm.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.gh3pm.Location = new System.Drawing.Point(150, 100);
            this.gh3pm.Name = "gh3pm";
            this.gh3pm.Size = new System.Drawing.Size(52, 19);
            this.gh3pm.TabIndex = 23;
            this.gh3pm.Text = "Plugins";
            this.gh3pm.UseVisualStyleBackColor = true;
            this.gh3pm.Click += new System.EventHandler(this.pmo);
            // 
            // sCa
            // 
            this.sCa.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.sCa.Location = new System.Drawing.Point(205, 123);
            this.sCa.Name = "sCa";
            this.sCa.Size = new System.Drawing.Size(71, 19);
            this.sCa.TabIndex = 25;
            this.sCa.Text = "Song Cache";
            this.sCa.UseVisualStyleBackColor = true;
            this.sCa.Click += new System.EventHandler(this.vscc);
            // 
            // sFmT
            // 
            this.sFmT.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.sFmT.Location = new System.Drawing.Point(105, 123);
            this.sFmT.Name = "sFmT";
            this.sFmT.Size = new System.Drawing.Size(97, 19);
            this.sFmT.TabIndex = 33;
            this.sFmT.Text = "Song Text Format";
            this.sFmT.UseVisualStyleBackColor = true;
            this.sFmT.Click += new System.EventHandler(this.stfO);
            // 
            // RTnoi
            // 
            this.RTnoi.Enabled = false;
            this.RTnoi.Location = new System.Drawing.Point(5, 96);
            this.RTnoi.Maximum = new decimal(new int[] {
            999999,
            0,
            0,
            0});
            this.RTnoi.Name = "RTnoi";
            this.RTnoi.Size = new System.Drawing.Size(59, 20);
            this.RTnoi.TabIndex = 34;
            this.RTnoi.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.RTnoi.ValueChanged += new System.EventHandler(this.cRT);
            // 
            // kBnds
            // 
            this.kBnds.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.kBnds.Location = new System.Drawing.Point(205, 100);
            this.kBnds.Name = "kBnds";
            this.kBnds.Size = new System.Drawing.Size(71, 19);
            this.kBnds.TabIndex = 42;
            this.kBnds.Text = "Keybinds";
            this.kBnds.UseVisualStyleBackColor = true;
            this.kBnds.Click += new System.EventHandler(this.oKb);
            // 
            // p2partt
            // 
            this.p2partt.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.p2partt.Location = new System.Drawing.Point(6, 234);
            this.p2partt.Name = "p2partt";
            this.p2partt.Size = new System.Drawing.Size(90, 18);
            this.p2partt.TabIndex = 42;
            this.p2partt.Text = "Player 2 guitar";
            this.p2partt.UseVisualStyleBackColor = true;
            this.p2partt.Click += new System.EventHandler(this.p2pT);
            // 
            // setbgimg
            // 
            this.setbgimg.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.setbgimg.Location = new System.Drawing.Point(5, 100);
            this.setbgimg.Name = "setbgimg";
            this.setbgimg.Size = new System.Drawing.Size(110, 19);
            this.setbgimg.TabIndex = 43;
            this.setbgimg.Text = "Set backdrop image";
            this.setbgimg.UseVisualStyleBackColor = true;
            this.setbgimg.Click += new System.EventHandler(this.sBGc);
            // 
            // bImg
            // 
            this.bImg.BackColor = System.Drawing.SystemColors.Control;
            this.bImg.Cursor = System.Windows.Forms.Cursors.Help;
            this.bImg.Location = new System.Drawing.Point(119, 100);
            this.bImg.Name = "bImg";
            this.bImg.Size = new System.Drawing.Size(28, 19);
            this.bImg.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.bImg.TabIndex = 44;
            this.bImg.TabStop = false;
            this.bImg.DoubleClick += new System.EventHandler(this.sBGi);
            // 
            // dCtrl
            // 
            this.dCtrl.Location = new System.Drawing.Point(111, 77);
            this.dCtrl.Maximum = new decimal(new int[] {
            8,
            0,
            0,
            0});
            this.dCtrl.Name = "dCtrl";
            this.dCtrl.Size = new System.Drawing.Size(37, 20);
            this.dCtrl.TabIndex = 47;
            this.dCtrl.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.dCtrl.ValueChanged += new System.EventHandler(this.dCtrlUpd);
            // 
            // aqlvl
            // 
            this.aqlvl.Increment = new decimal(new int[] {
            8,
            0,
            0,
            0});
            this.aqlvl.Location = new System.Drawing.Point(5, 57);
            this.aqlvl.Maximum = new decimal(new int[] {
            256,
            0,
            0,
            0});
            this.aqlvl.Minimum = new decimal(new int[] {
            96,
            0,
            0,
            0});
            this.aqlvl.Name = "aqlvl";
            this.aqlvl.Size = new System.Drawing.Size(59, 20);
            this.aqlvl.TabIndex = 44;
            this.aqlvl.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.aqlvl.Value = new decimal(new int[] {
            128,
            0,
            0,
            0});
            this.aqlvl.ValueChanged += new System.EventHandler(this.cAQ);
            // 
            // ctmpb
            // 
            this.ctmpb.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.ctmpb.Location = new System.Drawing.Point(5, 123);
            this.ctmpb.Name = "ctmpb";
            this.ctmpb.Size = new System.Drawing.Size(97, 19);
            this.ctmpb.TabIndex = 31;
            this.ctmpb.Text = "Clean Temp Files";
            this.ctmpb.UseVisualStyleBackColor = true;
            this.ctmpb.Click += new System.EventHandler(this.ctmp);
            // 
            // res
            // 
            this.res.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.res.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.res.FormattingEnabled = true;
            this.res.Location = new System.Drawing.Point(70, 2);
            this.res.Name = "res";
            this.res.Size = new System.Drawing.Size(78, 21);
            this.res.TabIndex = 2;
            this.res.SelectedIndexChanged += new System.EventHandler(this.resC);
            // 
            // MaxN
            // 
            this.MaxN.Location = new System.Drawing.Point(204, 27);
            this.MaxN.Maximum = new decimal(new int[] {
            2147483647,
            0,
            0,
            0});
            this.MaxN.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.MaxN.Name = "MaxN";
            this.MaxN.Size = new System.Drawing.Size(72, 20);
            this.MaxN.TabIndex = 18;
            this.MaxN.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.MaxN.ValueChanged += new System.EventHandler(this.mxnVC);
            // 
            // maxFPS
            // 
            this.maxFPS.Location = new System.Drawing.Point(5, 18);
            this.maxFPS.Maximum = new decimal(new int[] {
            268435455,
            1042612833,
            542101086,
            0});
            this.maxFPS.Name = "maxFPS";
            this.maxFPS.Size = new System.Drawing.Size(60, 20);
            this.maxFPS.TabIndex = 38;
            this.maxFPS.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.maxFPS.ValueChanged += new System.EventHandler(this.mxFPSc);
            // 
            // spL
            // 
            this.spL.AutoSize = true;
            this.spL.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.spL.Location = new System.Drawing.Point(149, 6);
            this.spL.Name = "spL";
            this.spL.Size = new System.Drawing.Size(0, 13);
            this.spL.TabIndex = 14;
            // 
            // mXnL
            // 
            this.mXnL.AutoSize = true;
            this.mXnL.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.mXnL.Location = new System.Drawing.Point(149, 30);
            this.mXnL.Name = "mXnL";
            this.mXnL.Size = new System.Drawing.Size(62, 13);
            this.mXnL.TabIndex = 17;
            this.mXnL.Text = "Max notes: ";
            // 
            // iL
            // 
            this.iL.AutoSize = true;
            this.iL.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.iL.Location = new System.Drawing.Point(149, 55);
            this.iL.Name = "iL";
            this.iL.Size = new System.Drawing.Size(59, 13);
            this.iL.TabIndex = 21;
            this.iL.Text = "Instrument:";
            // 
            // tLb
            // 
            this.tLb.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.tLb.CheckOnClick = true;
            this.tLb.FormattingEnabled = true;
            this.tLb.IntegralHeight = false;
            this.tLb.Items.AddRange(new object[] {
            "Song caching",
            "Verbose logging",
            "Preserve log",
            "Disable Vsync",
            "No startup message",
            "Exit on song end",
            "Debug menu",
            "Keyboard mode",
            "Windowed",
            "Borderless",
            "No intro",
            "No particles",
            "No fail",
            "No HUD",
            "FC mode",
            "Easy expert",
            "Precision",
            "Performance",
            "Disable shake",
            "Background video",
            "Hide hit gems",
            "Early sustain activation",
            "No note streak notif"});
            this.tLb.Location = new System.Drawing.Point(7, 167);
            this.tLb.Name = "tLb";
            this.tLb.Size = new System.Drawing.Size(149, 275);
            this.tLb.TabIndex = 30;
            this.tLb.ThreeDCheckBoxes = true;
            this.tLb.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.tU);
            // 
            // RTlbl
            // 
            this.RTlbl.Enabled = false;
            this.RTlbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.RTlbl.Location = new System.Drawing.Point(3, 80);
            this.RTlbl.Name = "RTlbl";
            this.RTlbl.Size = new System.Drawing.Size(92, 13);
            this.RTlbl.TabIndex = 35;
            this.RTlbl.Text = "No intro ready time:";
            // 
            // RTms
            // 
            this.RTms.AutoSize = true;
            this.RTms.Enabled = false;
            this.RTms.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.RTms.Location = new System.Drawing.Point(66, 101);
            this.RTms.Name = "RTms";
            this.RTms.Size = new System.Drawing.Size(20, 13);
            this.RTms.TabIndex = 36;
            this.RTms.Text = "ms";
            // 
            // mFPSl
            // 
            this.mFPSl.AutoSize = true;
            this.mFPSl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.mFPSl.Location = new System.Drawing.Point(3, 2);
            this.mFPSl.Name = "mFPSl";
            this.mFPSl.Size = new System.Drawing.Size(77, 13);
            this.mFPSl.TabIndex = 37;
            this.mFPSl.Text = "Max framerate:";
            // 
            // FPSl
            // 
            this.FPSl.AutoSize = true;
            this.FPSl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.FPSl.Location = new System.Drawing.Point(66, 23);
            this.FPSl.Name = "FPSl";
            this.FPSl.Size = new System.Drawing.Size(27, 13);
            this.FPSl.TabIndex = 39;
            this.FPSl.Text = "FPS";
            // 
            // tPanel
            // 
            this.tPanel.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.tPanel.AutoScroll = true;
            this.tPanel.BackColor = System.Drawing.SystemColors.Window;
            this.tPanel.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.tPanel.Controls.Add(this.kbpslbl);
            this.tPanel.Controls.Add(this.aqlvl);
            this.tPanel.Controls.Add(this.aqlbl);
            this.tPanel.Controls.Add(this.p2partt);
            this.tPanel.Controls.Add(this.modList);
            this.tPanel.Controls.Add(this.modl);
            this.tPanel.Controls.Add(this.FPSl);
            this.tPanel.Controls.Add(this.RTms);
            this.tPanel.Controls.Add(this.maxFPS);
            this.tPanel.Controls.Add(this.mFPSl);
            this.tPanel.Controls.Add(this.RTnoi);
            this.tPanel.Controls.Add(this.RTlbl);
            this.tPanel.Location = new System.Drawing.Point(157, 167);
            this.tPanel.Name = "tPanel";
            this.tPanel.Size = new System.Drawing.Size(119, 275);
            this.tPanel.TabIndex = 40;
            // 
            // kbpslbl
            // 
            this.kbpslbl.AutoSize = true;
            this.kbpslbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.kbpslbl.Location = new System.Drawing.Point(66, 61);
            this.kbpslbl.Name = "kbpslbl";
            this.kbpslbl.Size = new System.Drawing.Size(30, 13);
            this.kbpslbl.TabIndex = 45;
            this.kbpslbl.Text = "kbps";
            // 
            // aqlbl
            // 
            this.aqlbl.AutoSize = true;
            this.aqlbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.aqlbl.Location = new System.Drawing.Point(4, 41);
            this.aqlbl.Name = "aqlbl";
            this.aqlbl.Size = new System.Drawing.Size(70, 13);
            this.aqlbl.TabIndex = 43;
            this.aqlbl.Text = "Audio quality:";
            // 
            // modList
            // 
            this.modList.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.modList.CheckOnClick = true;
            this.modList.FormattingEnabled = true;
            this.modList.IntegralHeight = false;
            this.modList.Items.AddRange(new object[] {
            "All strums",
            "All doubles",
            "All taps",
            "Hopos to taps",
            "Mirror mode",
            "Color shuffle"});
            this.modList.Location = new System.Drawing.Point(5, 137);
            this.modList.Name = "modList";
            this.modList.Size = new System.Drawing.Size(88, 91);
            this.modList.TabIndex = 41;
            this.modList.ThreeDCheckBoxes = true;
            this.modList.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.mU);
            // 
            // modl
            // 
            this.modl.AutoSize = true;
            this.modl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modl.Location = new System.Drawing.Point(3, 121);
            this.modl.Name = "modl";
            this.modl.Size = new System.Drawing.Size(52, 13);
            this.modl.TabIndex = 40;
            this.modl.Text = "Modifiers:";
            // 
            // tLabel
            // 
            this.tLabel.AutoSize = true;
            this.tLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tLabel.Location = new System.Drawing.Point(3, 146);
            this.tLabel.Name = "tLabel";
            this.tLabel.Size = new System.Drawing.Size(58, 16);
            this.tLabel.TabIndex = 41;
            this.tLabel.Text = "Tweaks:";
            // 
            // selImg
            // 
            this.selImg.Filter = "Supported image formats|*.png;*.jpg;*.bmp;*.dds|Portable Network Graphics|*.png|J" +
    "PEG|*.jpeg|Bitmap|*.bmp|DirectDraw Surface|*.dds|Any type|*.*";
            this.selImg.Title = "Select background image";
            this.selImg.FileOk += new System.ComponentModel.CancelEventHandler(this.confirmImageReplace);
            // 
            // vlbl
            // 
            this.vlbl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.vlbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.vlbl.Location = new System.Drawing.Point(8, 445);
            this.vlbl.Name = "vlbl";
            this.vlbl.Size = new System.Drawing.Size(163, 28);
            this.vlbl.TabIndex = 45;
            this.vlbl.Text = "VER";
            // 
            // dCtrlLBL
            // 
            this.dCtrlLBL.AutoSize = true;
            this.dCtrlLBL.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.dCtrlLBL.Location = new System.Drawing.Point(4, 79);
            this.dCtrlLBL.Name = "dCtrlLBL";
            this.dCtrlLBL.Size = new System.Drawing.Size(111, 13);
            this.dCtrlLBL.TabIndex = 46;
            this.dCtrlLBL.Text = "Default Controller (ID):";
            // 
            // modelbl
            // 
            this.modelbl.AutoSize = true;
            this.modelbl.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modelbl.Location = new System.Drawing.Point(168, 473);
            this.modelbl.Name = "modelbl";
            this.modelbl.Size = new System.Drawing.Size(37, 13);
            this.modelbl.TabIndex = 48;
            this.modelbl.Text = "Mode:";
            this.modelbl.Visible = false;
            // 
            // mode
            // 
            this.mode.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.mode.FormattingEnabled = true;
            this.mode.Items.AddRange(new object[] {
            "Quickplay",
            "Co-op",
            "Face-off",
            "Pro Face-off",
            "Battle"});
            this.mode.Location = new System.Drawing.Point(204, 471);
            this.mode.Name = "mode";
            this.mode.Size = new System.Drawing.Size(91, 21);
            this.mode.TabIndex = 49;
            this.mode.Text = "Quickplay";
            this.mode.Visible = false;
            // 
            // modsbtn
            // 
            this.modsbtn.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.modsbtn.Location = new System.Drawing.Point(205, 145);
            this.modsbtn.Name = "modsbtn";
            this.modsbtn.Size = new System.Drawing.Size(71, 19);
            this.modsbtn.TabIndex = 50;
            this.modsbtn.Text = "QB Mods";
            this.modsbtn.UseVisualStyleBackColor = true;
            this.modsbtn.Click += new System.EventHandler(this.showmods);
            // 
            // settings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(280, 476);
            this.Controls.Add(this.modsbtn);
            this.Controls.Add(this.vlbl);
            this.Controls.Add(this.mode);
            this.Controls.Add(this.modelbl);
            this.Controls.Add(this.dCtrl);
            this.Controls.Add(this.dCtrlLBL);
            this.Controls.Add(this.hypers);
            this.Controls.Add(this.bImg);
            this.Controls.Add(this.setbgimg);
            this.Controls.Add(this.kBnds);
            this.Controls.Add(this.tPanel);
            this.Controls.Add(this.ctmpb);
            this.Controls.Add(this.tLb);
            this.Controls.Add(this.sCa);
            this.Controls.Add(this.sFmT);
            this.Controls.Add(this.gh3pm);
            this.Controls.Add(this.part);
            this.Controls.Add(this.iL);
            this.Controls.Add(this.replay);
            this.Controls.Add(this.MaxN);
            this.Controls.Add(this.mXnL);
            this.Controls.Add(this.speed);
            this.Controls.Add(this.spL);
            this.Controls.Add(this.crLink);
            this.Controls.Add(this.diff);
            this.Controls.Add(this.dfLabel);
            this.Controls.Add(this.hLabel);
            this.Controls.Add(this.res);
            this.Controls.Add(this.resL);
            this.Controls.Add(this.ok);
            this.Controls.Add(this.tLabel);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "settings";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "FastGH3 settings";
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.kde);
            ((System.ComponentModel.ISupportInitialize)(this.hypers)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.speed)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.RTnoi)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.bImg)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dCtrl)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.aqlvl)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.MaxN)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.maxFPS)).EndInit();
            this.tPanel.ResumeLayout(false);
            this.tPanel.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

	}

	private void Colorpanel_MouseDoubleClick(object sender, MouseEventArgs e)
	{
		throw new System.NotImplementedException();
	}

	#endregion

	private Button ok;
	private Label resL;
	private NumericUpDown hypers;
	private Label hLabel;
	private ComboBox diff;
	private Label dfLabel;
	private LinkLabel crLink;
	private ToolTip tt;
	private NumericUpDown speed;
	private Label spL;
	private Label mXnL;
	private NumericUpDown MaxN;
	private Button replay;
	private Label iL;
	private ComboBox part;
	private Button gh3pm;
	private Button sCa;
	private CheckedListBox tLb;
	private Button ctmpb;
	private Button sFmT;
	private ComboBox res;
	private NumericUpDown RTnoi;
	private Label RTlbl;
	private Label RTms;
	private Label mFPSl;
	private NumericUpDown maxFPS;
	private Label FPSl;
	private Panel tPanel;
	private Label tLabel;
	private CheckedListBox modList;
	private Label modl;
	private Button kBnds;
	private CheckBox p2partt;
	private Button setbgimg;
	private PictureBox bImg;
	private OpenFileDialog selImg;
	private Label kbpslbl;
	private NumericUpDown aqlvl;
	private Label aqlbl;
	private Label vlbl;
	private Label dCtrlLBL;
	private NumericUpDown dCtrl;
	private Label modelbl;
	private ComboBox mode;
    private Button modsbtn;
}