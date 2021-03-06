using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace FastGH3
{
    public partial class songcache : Form
    {
        public string folder = Path.GetDirectoryName(Application.ExecutablePath) + "\\DATA\\CACHE\\";

        public IniFile i = new IniFile();

        public songcache()
        {
            InitializeComponent();
            i.Load(folder + ".db.ini");
            DataGridViewRow newRow;
            int pushinteger = 0;
            foreach (IniFile.IniSection s in i.Sections)
            {
                if (File.Exists(folder + s.Name) &&
                    File.Exists(folder + i.GetKeyValue(s.Name,
                        "Audio", new string('0', 16))))
                {
                    newRow = new DataGridViewRow();
                    newRow.CreateCells(cache,
                        s.Name, // icon
                        i.GetKeyValue(s.Name, "Author", "Unknown"),
                        i.GetKeyValue(s.Name, "Title", "Untitled"),
                        FileSize(new FileInfo(folder + s.Name).Length +
                                new FileInfo(folder + i.GetKeyValue(s.Name,
                                            "Audio", new string('0', 16))).Length),
                        i.GetKeyValue(s.Name, "Length", "00:00"),
                        "Play"
                        );
                    cache.Rows.Add(newRow);
                    if (Height < 500)
                        Height += 22;
                }
            }
        }

        char[] bUnits = " KMGT".ToCharArray();
        uint bThousand = 1024; // based *ibibytes

        public string FileSize(long length)
        {
            float newSize = length;
            byte bUnit = 0;
            while (newSize >= bThousand && bUnit < bUnits.Length - 1)
            {
                bUnit++;
                newSize /= bThousand;
            }
            if (bUnit == 0)
                return newSize.ToString("0").PadLeft(4) + " bytes";
            else
                return newSize.ToString("0.00 ").PadLeft(7) + bUnits[bUnit] + 'B';
        }

        private void runGameWithCache(DataGridViewCellEventArgs e)
        {
            IniFile.IniSection cs = i.GetSection((string)cache.Rows[e.RowIndex].Cells[0].Value);
            File.Copy(folder + cs.Name, folder + "..\\PAK\\song.pak.xen", true);
            File.Copy(folder + cs.GetKey("Audio").Value, folder + "..\\MUSIC\\fastgh3.fsb.xen", true);
            Process.Start(folder + "..\\..\\game.exe");
        }

        private void cacheClick0(object sender, DataGridViewCellEventArgs e)
        {
            switch (e.ColumnIndex)
            {
                case 5:
                    runGameWithCache(e);
                    break;
            }
        }

        private void cacheDblClick(object sender, DataGridViewCellEventArgs e)
        {
            runGameWithCache(e);
        }

        private void cacheDelete1(object sender, EventArgs e)
        {
            foreach (DataGridViewRow d in cache.SelectedRows)
            {
                IniFile.IniSection s = i.GetSection(d.Cells[0].Value.ToString());
                File.Delete(folder + s.Name);
                File.Delete(folder + s.GetKey("Audio").Value);
                i.RemoveSection(s.Name);
                i.Save(folder + ".db.ini");
                cache.Rows.Remove(d);
            }
        }

        private void cacheRgtclick(object sender, System.ComponentModel.CancelEventArgs e)
        {
            deleteTool.Enabled = cache.SelectedRows.Count > 0;
        }
    }
}
