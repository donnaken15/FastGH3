using System;
using System.IO;
using System.Windows.Forms;

namespace FastGH3
{
    public partial class songcache : Form
    {
        public songcache()
        {
            InitializeComponent();
            foreach (FileInfo file in new DirectoryInfo(Environment.CurrentDirectory + "\\DATA\\CACHE\\").GetFiles("*.pak", SearchOption.AllDirectories))
            {
                cache.Rows.Add(file.Name.Replace(".pak", ""), "", "DSX", calcSizeUnit(new FileInfo(file.FullName).Length + new FileInfo(file.FullName.Replace(".pak", ".fsb")).Length), File.ReadAllText(Environment.CurrentDirectory + "\\DATA\\CACHE\\.db.txt").IndexOf(file.ToString().Replace(".pak", "")));
                Height += 22;
            }
        }

        string calcSizeUnit(long size)
        {
            if (size > 1073741824)
                return Math.Round(size / (float)1073741824, 2).ToString() + "GB";
            if (size > 1048576)
                return Math.Round(size / (float)1048576, 2).ToString() + "MB";
            if (size > 1024)
                return Math.Round(size / (float)1024, 2).ToString() + "KB";
            return size.ToString() + "B";
        }
    }
}
