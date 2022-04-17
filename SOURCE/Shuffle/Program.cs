using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace Shuffle
{
    class Program
    {
        static IniFile ini;
        static string folder;
        const string inipath = "settings.ini";
        static List<string> paths, files;
        static IniFile.IniSection shuffleCfg;
        static Random rand = new Random((int)DateTime.Now.Ticks);

        [STAThread]
        static void Main()
        {
            Console.WriteLine(

                @"
___     ___\
   \   /   /
    \ /
     X
    / \
___/   \___\
           /
");
            ini = new IniFile();
            folder = Path.GetDirectoryName(Application.ExecutablePath) + '\\';
            if (!File.Exists(folder + inipath))
            {
                MessageBox.Show("settings.ini cannot be found");
                Environment.Exit(1);
            }
            ini.Load(folder + inipath);
            if (ini.GetSection("Shuffle") == null)
            {
                MessageBox.Show("Shuffle settings section cannot be found");
                Environment.Exit(1);
            }
            shuffleCfg = ini.GetSection("Shuffle");
            paths = new List<string>();
            string curpath;
            foreach (IniFile.IniSection.IniKey key in shuffleCfg.Keys)
                if (key.Name.StartsWith("Path"))
                {
                    curpath = key.Value;
                    if (Directory.Exists(curpath) && paths.IndexOf(curpath) == -1)
                        paths.Add(curpath);
                    //Console.WriteLine(curpath);
                }
            string randpath = paths[rand.Next(paths.Count)];
            files = new List<string>();
            files.AddRange(Directory.GetFiles(randpath, "*.chart", SearchOption.AllDirectories));
            files.AddRange(Directory.GetFiles(randpath, "*.mid", SearchOption.AllDirectories));
            files.AddRange(Directory.GetFiles(randpath, "*.fsp", SearchOption.AllDirectories));
            //Console.WriteLine(files.Count);
            int choose = rand.Next(files.Count);
            Console.WriteLine("Choosing: " + files[choose]);
            Process.Start(folder + "FastGH3.exe", "\"" + files[choose] + "\"");
            //Console.ReadKey();
        }
    }
}
