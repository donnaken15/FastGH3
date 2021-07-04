using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    [Flags]
    public enum PakHeaderFlags : uint
    {
        Filename = 0x00000020
    }
}
