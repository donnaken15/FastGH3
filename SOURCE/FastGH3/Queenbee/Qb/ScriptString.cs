using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    /// <summary>
    /// A simple class to store strings found within scripts
    /// </summary>
    public class ScriptString
    {
        public ScriptString(string text, int pos, int length, bool isUnicode)
        {
            this.Text = text;
            this.Pos = pos;
            this.Length = length;
            this.IsUnicode = isUnicode;
        }

        public string Text { get; set; }
        public int Pos { get; set; }
        public int Length { get; set; }
        public bool IsUnicode { get; set; }
    }
}
