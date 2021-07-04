using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    internal class PakDbgQbKey
    {
        public PakDbgQbKey(uint pakQbkey, uint dbgQbKey, string filename)
        {
            PakQbKey = pakQbkey;
            DebugQbKey = dbgQbKey;
            Filename = filename;
        }

        public readonly uint PakQbKey;
        public readonly uint DebugQbKey;
        public readonly string Filename;
    }
}
