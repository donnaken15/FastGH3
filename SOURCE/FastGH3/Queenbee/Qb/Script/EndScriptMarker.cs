using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nanook.QueenBee.Parser.Qb.Script
{
    class EndScriptMarker : Instruction
    {
        public override void Compile(BinaryEndianWriter bew) {
            bew.Write(0x2401);
        }

        public override string ToString()
        {
            return "";
        }
    }
}
