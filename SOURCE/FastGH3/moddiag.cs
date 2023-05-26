﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using Nanook.QueenBee.Parser;
using Ionic.Zip;

public partial class moddiag : Form
{
	static string folder = Environment.CurrentDirectory;
	// ill put as many backslashes as i want
	// not gonna get path errors lol
	static string modf = "\\DATA\\MODS\\";
	static string disabled = "\\disabled\\";
	static string disabled_ = folder + modf + disabled;
	public static PakFormat nullPF = new PakFormat("", "", "", PakFormatType.PC);

	public struct OverrideItem {
		public QbKey name;
		public QbItemType type;
		public object defval;
		public object newval;
	}
	public static List<OverrideItem> built_in_items;
	public static void Overrides_AddDefaultItems(QbFile qb)
	{
		foreach (QbItemBase i in qb.Items)
		{
			if (i.QbItemType == QbItemType.Unknown)
				continue;
			OverrideItem OI = new OverrideItem();
			OI.name = i.ItemQbKey;
			OI.type = i.QbItemType;
			OI.defval = getItemObject(qb.FindItem(OI.name, false));
			built_in_items.Add(OI);
			//Program.vl(i.SafeName + " : " + i.QbItemType);
		}
	}

	public static object getItemObject(object _item)
	{
		if (_item == null)
		{
			return null;
		}
		switch ((_item as QbItemBase).QbItemType)
		{
			case QbItemType.SectionInteger:
			case QbItemType.StructItemInteger:
				return (_item as QbItemInteger).Values[0];
			case QbItemType.SectionFloat:
			case QbItemType.StructItemFloat:
				return (_item as QbItemFloat).Values[0];
			case QbItemType.SectionString:
			case QbItemType.SectionStringW:
			case QbItemType.StructItemString:
			case QbItemType.StructItemStringW:
				return (_item as QbItemString).Strings[0];
			case QbItemType.SectionQbKey:
			case QbItemType.SectionQbKeyString:
			case QbItemType.SectionQbKeyStringQs:
			case QbItemType.StructItemQbKey:
			case QbItemType.StructItemQbKeyString:
			case QbItemType.StructItemQbKeyStringQs:
				return (_item as QbItemQbKey).Values[0];
			case QbItemType.SectionStruct:
			case QbItemType.StructItemStruct:
				return (_item as QbItemStruct);
			case QbItemType.SectionArray:
			case QbItemType.StructItemArray:
				return (_item as QbItemArray);
			default:
				return _item;
		}
	}
	class QbMod
	{
		QbFile qb;
		QbItemStruct modinfo;
		public string filename;
		object ModInfoItem(QbKey key)
		{
			if (modinfo == null)
				return null;
			object _item = (modinfo.FindItem(key, false));
			return getItemObject(_item);
		}
		object getItem(QbKey key)
		{
			object _item = (qb.FindItem(key, false));
			return getItemObject(_item);
		}
		public string ModInfoString(QbKey key, string def)
		{
			try
			{
				object item = ModInfoItem(key);
				if (item == null)
				{
					if (def == null)
					{
						warnings.Add("Mod info item is missing. (" + key.ToString() + ")");
						return "";
					}
					else
						return def;
				}
				return (string)item;
			}
			catch (Exception ex)
			{
				warnings.Add(ex.Message);
				return "";
			}
		}
		public string ModInfoString(QbKey key)
		{
			return ModInfoString(key, null);
		}
		public int ModInfoInt(QbKey key)
		{
			object test = ModInfoItem(key);
			if (test != null)
				return (int)test;
			else
				return 0;
		}
		public string name
		{
			get
			{
				if (modinfo == null)
					return filename;
				else
					return ModInfoString(QbKey.Create("name"));
			}
		}
		public string author
		{
			get { return ModInfoString(QbKey.Create("author"), "Unknown"); }
		}
		public string desc
		{
			get { return ModInfoString(QbKey.Create("desc"), ""); }
		}
		public string version
		{
			get { return ModInfoString(QbKey.Create("version"), "n/a"); }
		}
		public string[] requiredFiles
		{
			get
			{
				if (modinfo == null) return new string[0];
				object _item = (modinfo.FindItem(QbKey.Create("requires"), false));
				return _item != null ?
					((_item as QbItemArray).Items[0] as QbItemString).Strings :
					new string[0];
			}
		}
		/*public DateTime moddate
		{
			get {
				int ts = ModInfoInt(QbKey.Create("last_updated"));
				return new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc).AddSeconds(ts);
			}
		}*/
		public List<string> warnings;
		public List<OverrideItem> overrides;
		public QbItemStructArray config_defaults;
		/*List<Tuple<string, object>>*/
		private void Base()
		{
			warnings = new List<string>();
			overrides = new List<OverrideItem>();
			//config_defaults = new List<Tuple<string, object>>();
			foreach (QbItemBase i in qb.Items)
			{
				if (i.QbItemType == QbItemType.Unknown)
					continue;
				// probably a little inefficient
				foreach (OverrideItem oi in built_in_items)
				{
					if (i.ItemQbKey.Crc == oi.name.Crc)
					{
						OverrideItem OI = new OverrideItem();
						OI.name = keyWithDebug(i.ItemQbKey.Crc);
						OI.type = i.QbItemType;
						OI.defval = oi.defval;
						OI.newval = getItemObject(qb.FindItem(OI.name, false));
						overrides.Add(OI);
					}
				}
			}
			filename = filename.Substring(0, filename.LastIndexOf(".qb.xen"));
			modinfo = (QbItemStruct)getItem(QbKey.Create(filename + "_mod_info"));
			if (modinfo == null)
				modinfo = (QbItemStruct)getItem(QbKey.Create("mod_info"));
			if (modinfo == null) // bruh
			{
				warnings.Add("Can't find the mod info struct (" + filename + "_info) with a matching mod name or an ambiguously named mod info struct (mod_info). Is the file not properly named?");
				return;
			}
			else
			{
				// why
				config_defaults = ((QbItemStructArray)modinfo.FindItem(QbKey.Create("params"), false).Items[0]);
				//config_defaults = ModInfoItem(QbKey.Create("params")) as QbItemStructArray;
				//if (ModInfoItem(QbKey.Create("params")) != null)
					//config_defaults = (ModInfoItem(QbKey.Create("params")) as QbItemArray)
						//.Items.ConvertAll(new Converter<QbItemBase, QbItemStruct>(why));
			}
		}
		/*public QbItemStruct why(QbItemBase b)
		{
			return b as QbItemStruct;
		}*/
		public QbMod(string path)
		{
			qb = new QbFile(path, nullPF);
			filename = Path.GetFileName(path);
			Base();
		}
		public QbMod(QbFile qb)
		{
			this.qb = qb;
			filename = qb.Filename;
			Base();
		}
	}
	QbMod selectedmod;
	public static Dictionary<uint, string> DebugNames = new Dictionary<uint, string>();
	public static string GetDebugName(QbKey key)
	{
		return GetDebugName(key.Crc);
	}
	public static string GetDebugName(uint key)
	{
		try
		{
			return DebugNames[key];
		}
		catch
		{
			return key.ToString("X8");
		}
	}
	public static string GetDebugName(uint key, out bool success)
	{
		// success = got text
		try
		{
			string a = DebugNames[key];
			success = true;
			return a;
		}
		catch
		{
			success = false;
			return key.ToString("X8");
		}
	}
	public static QbKey keyWithDebug(uint key)
	{
		bool gottext = false;
		string dname = GetDebugName(key, out gottext);
		if (gottext)
			return QbKey.Create(key, dname);
		else
			return QbKey.Create(key);
	}

	public moddiag()
	{
		InitializeComponent();
		//Height += new DirectoryInfo(folder + modf).GetFiles("*.qb.xen", SearchOption.AllDirectories).Length * 9;
		if (!Directory.Exists(disabled_))
			Directory.CreateDirectory(disabled_);
		modrefresh(null, null);
	}

	bool disableEvents = false;
	private void togglemod(object sender, EventArgs e)
	{
		if (disableEvents) return;
		foreach (object mod in modslist.SelectedItems)
		{
			string modS = mod.ToString().Replace("(*)", "");
			string addpath, addpath2;
			if (mod.ToString().StartsWith("(*)"))
			{
				File.Move(disabled_ + modS, folder + modf + modS);
				addpath = "";
				addpath2 = "\\disabled\\";
			}
			else
			{
				File.Move(folder + modf + modS, disabled_ + modS);
				addpath = "\\disabled\\";
				addpath2 = "";
			}
			foreach (string a in selectedmod.requiredFiles)
				if (File.Exists(folder + modf + addpath2 + a)) // wtf
					File.Move(folder + modf + addpath2 + a, folder + modf + addpath + a);
		}
		modrefresh(null, null);
	}

	private void modrefresh(object sender, EventArgs e)
	{
		modname.Text = "Name:";
		modauth.Text = "Author:";
		descbox.Text = "";
		modver.Text = "Version:";
		modlu.Text = "Last updated:";
		warnings.Text = "";
		togglecbx.Enabled = false;
		rembtn.Enabled = false;
		modovers.Enabled = false;
		modcfgbtn.Enabled = false;
		modslist.Items.Clear();
		foreach (FileInfo file in new DirectoryInfo(folder + modf).GetFiles("*.qb.xen", SearchOption.TopDirectoryOnly))
			modslist.Items.Add(file);
		try
		{
			foreach (FileInfo file in new DirectoryInfo(disabled_).GetFiles("*.qb.xen"))
				modslist.Items.Add("(*)" + file);
		}
		catch (Exception ex) { Console.WriteLine(ex); }
	}

	private void selectmod(object sender, EventArgs e)
	{
		try
		{
			string path = folder + modf + modslist.SelectedItem.ToString();
			disableEvents = true;
			if (path.Contains("(*)"))
				togglecbx.Checked = true;
			else
				togglecbx.Checked = false;
			path = path.Replace("(*)", "\\disabled\\");
			disableEvents = false;
			rembtn.Enabled = true;
			togglecbx.Enabled = true;
			selectedmod = new QbMod(path);
			modname.Text = "Name: " + selectedmod.name;
			modauth.Text = "Author: " + selectedmod.author;
			descbox.Text = selectedmod.desc;
			modver.Text = "Version: " + selectedmod.version;
			modlu.Text = "Last updated: " + File.GetLastWriteTime(path);
			warnings.Text = "";
			foreach (string a in selectedmod.warnings)
				warnings.Text += a + "\r\n";
			foreach (string a in selectedmod.requiredFiles)
				if (!File.Exists(Path.GetDirectoryName(path) + '\\' + a))
					warnings.Text += a + " is a required file but does not exist.\r\n";
			modovers.Text = "Overrides...(" + selectedmod.overrides.Count + ")";
			modovers.Enabled = selectedmod.overrides.Count > 0;
			modcfgbtn.Enabled = true;// selectedmod.config_defaults != null;
		}
		catch (Exception ex) { Console.WriteLine(ex); }
	}

	private void remmod(object sender, EventArgs e)
	{
		foreach (object mod in modslist.SelectedItems)
		{
			string path = folder + modf + mod.ToString().Replace("(*)", disabled);
			QbMod test = new QbMod(path);
			string addpath, addpath2;
			if (mod.ToString().StartsWith("(*)"))
				addpath2 = "\\disabled\\";
			else
				addpath2 = "";
			foreach (string a in test.requiredFiles)
				if (File.Exists(folder + modf + addpath2 + a))
					File.Delete(folder + modf + addpath2 + a);
			File.Delete(path);
		}
		modrefresh(null,null);
		if (modslist.SelectedIndex == -1)
		{
			rembtn.Enabled = false;
			togglecbx.Enabled = false;
		}
	}

	// stupid but for if there's people
	// who make mods that have common file names
	public void SafeCopy(string src, string dest)
	{
		if (!File.Exists(dest))
			File.Copy(src, dest);
		else
		{
			int copynum = 0;
			string path = Path.GetDirectoryName(dest) + '\\' +
				Path.GetFileNameWithoutExtension(Path.GetFileNameWithoutExtension(dest)) +
				"(" + copynum.ToString() + ")" +
				Path.GetExtension(Path.GetFileNameWithoutExtension(dest)) +
				Path.GetExtension(dest);
			while (File.Exists(path))
			{
				copynum++;
			}
			File.Copy(src, path);
		}
	}

	private void openedQB(object sender, System.ComponentModel.CancelEventArgs e)
	{
		foreach (string file in OFD.FileNames)
			if (Program.NP(Path.GetPathRoot(file)) != Program.NP(folder + modf))
			{
				QbMod mod = null;
				if (file.EndsWith(".qb.xen") ||
					file.EndsWith(".qb"))
				{
					string path = folder + modf + Path.GetFileName(file);
					SafeCopy(file, path);
					mod = new QbMod(path);
					foreach (string a in mod.requiredFiles)
						SafeCopy(Path.GetDirectoryName(file) + '\\' + a, folder + modf + a);
				}
				else if (file.EndsWith(".zip"))
				{
					ZipFile zip = ZipFile.Read(file);
					//MemoryStream qb_in_mem = null;
					bool gotqb = false;
					List<string> required = new List<string>();
					List<ZipEntry> required_maybe = new List<ZipEntry>();
					foreach (ZipEntry zfile in zip)
					{
						//Console.WriteLine(zfile.FileName);
						if (zfile.FileName.ToLower().EndsWith(".qb.xen") ||
							zfile.FileName.ToLower().EndsWith(".qb"))
						{
							gotqb = true;
							//Console.WriteLine("found");
							//qb_in_mem = new MemoryStream();
							//zfile.Extract(qb_in_mem);
							zfile.Extract(folder + modf);
							//QbFile zqb = new QbFile(qb_in_mem,nullPF);
							//mod = new QbMod(zqb);
							//mod = new QbMod(Path.GetTempPath() + zfile.FileName);
							mod = new QbMod(folder + modf + zfile.FileName);
							required.AddRange(mod.requiredFiles);
							//File.Delete(Path.GetTempPath() + zfile.FileName);
						}
						else
							required_maybe.Add(zfile);
					}
					foreach (string a in required)
					{
						foreach (ZipEntry f in required_maybe) // uhhhh
						{
							//Console.WriteLine(f.FileName.ToUpper() + "==" + a.ToUpper());
							if (f.FileName.ToUpper() == a.ToUpper())
								f.Extract(folder + modf);
						}
					}
					//if (qb_in_mem == null)
					if (!gotqb)
					{
						MessageBox.Show("Cannot find a file indicating of a QB.", "Error",
							MessageBoxButtons.OK, MessageBoxIcon.Error);
						//continue;
					}
					zip.Dispose();
				}
			}
		modrefresh(null,null);
	}

	private void addmod_diag(object sender, EventArgs e)
	{
		OFD.ShowDialog();
	}

	private void showOvrds(object sender, EventArgs e)
	{
		new modovrddiag(selectedmod.name, selectedmod.overrides).ShowDialog();
	}

	private void openmodcfg(object sender, EventArgs e)
	{
		new modcfg(selectedmod.config_defaults).ShowDialog();
	}
}
