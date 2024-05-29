using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using Nanook.QueenBee.Parser;
#if !USE_SZL
using Ionic.Zip;
#else
using ICSharpCode.SharpZipLib.Zip;
#endif

public partial class moddiag : Form
{
	static string folder = Environment.CurrentDirectory;
	// ill put as many backslashes as i want
	// not gonna get path errors lol
	static string modf = "\\DATA\\MODS\\";
	static string d = Launcher.T[140];
	static string df = folder + modf + d;
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
				if ((_item as QbItemArray).ItemCount < 1) return _item; // wtf
				QbItemBase array = (_item as QbItemArray).Items[0];
				//Console.WriteLine(array.ItemCount);
				switch (array.QbItemType)
				{
					case QbItemType.ArrayInteger:
						return (array as QbItemInteger).Values;
					case QbItemType.ArrayFloat:
						return (array as QbItemFloat).Values;
					case QbItemType.ArrayQbKey:
					case QbItemType.ArrayQbKeyString:
						return (array as QbItemQbKey).Values;
					case QbItemType.ArrayString:
					case QbItemType.ArrayStringW:
						return (array as QbItemString).Strings;
					case QbItemType.ArrayStruct:
						return (array as QbItemStruct);
					case QbItemType.Floats:
						return (array as QbItemFloats).Values;
					case QbItemType.ArrayFloatsX2:
						return (array as QbItemFloatsArray).Items;
					case QbItemType.ArrayArray:
						return (array as QbItemArray).Items;
				}
				throw new InvalidDataException(Launcher.T[180] + (_item as QbItemBase).ItemQbKey);
			//return (_item as QbItemArray);
			default:
				return _item;
		}
	}
	class QbMod
	{
		QbFile qb;
		QbItemStruct modinfo;
		public string filename;
		public bool unique;
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
						warnings.Add(Launcher.T[181] + key.ToString() + ')');
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
			{
				unique = false;
				modinfo = (QbItemStruct)getItem(QbKey.Create("mod_info"));
			}
			else
				unique = true;
			if (modinfo == null) // bruh
			{
				warnings.Add(string.Format(Launcher.T[182], filename));
				return;
			}
			else
			{
				// why
				QbItemArray array = (QbItemArray)modinfo.FindItem(QbKey.Create("params"), false);
				if (array != null)
					config_defaults = (QbItemStructArray)array.Items[0];
				/*else
				{
					config_defaults = new QbItemStructArray(qb);
					config_defaults.Create(QbItemType.ArrayStruct);
				}*/
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
		OFD.Filter = Launcher.T[185];
		//Height += new DirectoryInfo(folder + modf).GetFiles("*.qb.xen", SearchOption.AllDirectories).Length * 9;
		if (!Directory.Exists(df))
			Directory.CreateDirectory(df);
		modrefresh(null, null);
	}

	bool disableEvents = false;
	private void togglemod(object sender, EventArgs e)
	{
		if (disableEvents) return;
		foreach (object mod in modslist.SelectedItems)
		{
			string modS = mod.ToString().Replace(Launcher.T[143], "");
			string addpath, addpath2;
			if (mod.ToString().StartsWith(Launcher.T[143]))
			{
				File.Move(df + modS, folder + modf + modS);
				addpath = "";
				addpath2 = d;
			}
			else
			{
				File.Move(folder + modf + modS, df + modS);
				addpath = d;
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
			foreach (FileInfo file in new DirectoryInfo(df).GetFiles("*.qb.xen"))
				modslist.Items.Add(Launcher.T[143] + file);
		}
		catch (Exception ex) { Console.WriteLine(ex); }
	}

	private void selectmod(object sender, EventArgs e)
	{
		try
		{
			string path = folder + modf + modslist.SelectedItem.ToString();
			disableEvents = true;
			if (path.Contains(Launcher.T[143]))
				togglecbx.Checked = true;
			else
				togglecbx.Checked = false;
			path = path.Replace(Launcher.T[143], d);
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
					warnings.Text += a + Launcher.T[183];
			modovers.Text = "Overrides...(" + selectedmod.overrides.Count + ')';
			modovers.Enabled = selectedmod.overrides.Count > 0;
			modcfgbtn.Enabled = selectedmod.config_defaults != null;
		}
		catch (Exception ex) { Console.WriteLine(ex); }
	}

	private void remmod(object sender, EventArgs e)
	{
		foreach (object mod in modslist.SelectedItems)
		{
			string path = folder + modf + mod.ToString().Replace(Launcher.T[143], d);
			QbMod test = new QbMod(path);
			string addpath, addpath2;
			if (mod.ToString().StartsWith(Launcher.T[143]))
				addpath2 = d;
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
			if (Launcher.NP(Path.GetPathRoot(file)) != Launcher.NP(folder + modf))
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
#if !USE_SZL
					ZipFile zip = ZipFile.Read(file);
#else
					ZipFile zip = new ZipFile(file);
#endif
					//MemoryStream qb_in_mem = null;
					bool gotqb = false;
					List<string> required = new List<string>();
					List<ZipEntry> required_maybe = new List<ZipEntry>();
					foreach (ZipEntry zfile in zip)
					{
						//Console.WriteLine(zfile.FileName);
#if !USE_SZL
						string f = zfile.FileName.ToLower();
#else
						string f = zfile.Name.ToLower();
#endif
						if (f.EndsWith(".qb.xen") || f.EndsWith(".qb"))
						{
							gotqb = true;
							//Console.WriteLine("found");
							//qb_in_mem = new MemoryStream();
							//zfile.Extract(qb_in_mem);
#if !USE_SZL
							zfile.Extract(folder + modf);
#else
							Stream i = zip.GetInputStream(zfile);
							Stream o = File.Open(folder + modf + file, FileMode.Create);
							i.CopyTo(o);
							i.Dispose();
							o.Dispose();
#endif
							//QbFile zqb = new QbFile(qb_in_mem,nullPF);
							//mod = new QbMod(zqb);
							//mod = new QbMod(Path.GetTempPath() + zfile.FileName);
							mod = new QbMod(folder + modf + zfile.
#if !USE_SZL
								FileName
#else
								Name
#endif
							);
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
							if (f.
#if !USE_SZL
								FileName
#else
								Name
#endif
								.ToUpper() == a.ToUpper())
#if !USE_SZL
								f.Extract(folder + modf);
#else
							{
								Stream i = zip.GetInputStream(f);
								Stream o = File.Open(folder + modf + file, FileMode.Create);
								i.CopyTo(o);
								i.Dispose();
								o.Dispose();
							}
#endif
						}
					}
					//if (qb_in_mem == null)
					if (!gotqb)
					{
						MessageBox.Show(Launcher.T[184], "Error",
							MessageBoxButtons.OK, MessageBoxIcon.Error);
						//continue;
					}
#if !USE_SZL
					zip.Dispose();
#else
					zip.Close();
#endif
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
		string nonuniqueprefix = "";
		if (!selectedmod.unique)
			nonuniqueprefix = selectedmod.filename + ".qb_";
		//Program.print(nonuniqueprefix);
		new modcfg(selectedmod.config_defaults, nonuniqueprefix).ShowDialog();
	}
}
