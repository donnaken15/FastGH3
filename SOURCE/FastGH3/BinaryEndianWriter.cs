using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{

    public class BinaryEndianWriter : BinaryWriter
    {
        public BinaryEndianWriter(Stream input)
            : base(input)
        {
        }
        
        public void Write(UInt32 value, EndianType endianType)
        {
            if ((BitConverter.IsLittleEndian && endianType != EndianType.Little) || (!BitConverter.IsLittleEndian && endianType != EndianType.Big))
            {
                byte[] b = BitConverter.GetBytes(value);
                Array.Reverse(b);
                base.Write(b, 0, 4);
            }
            else
                base.Write(value);
        }

        public void Write(Int32 value, EndianType endianType)
        {
            if ((BitConverter.IsLittleEndian && endianType != EndianType.Little) || (!BitConverter.IsLittleEndian && endianType != EndianType.Big))
            {
                byte[] b = BitConverter.GetBytes(value);
                Array.Reverse(b);
                base.Write(b, 0, 4);
            }
            else
                base.Write(value);
        }

        public void Write(UInt16 value, EndianType endianType)
        {
            if ((BitConverter.IsLittleEndian && endianType != EndianType.Little) || (!BitConverter.IsLittleEndian && endianType != EndianType.Big))
            {
                byte[] b = BitConverter.GetBytes(value);
                Array.Reverse(b);
                base.Write(b, 0, 2);
            }
            else
                base.Write(value);
        }

        public void Write(Int16 value, EndianType endianType)
        {
            if ((BitConverter.IsLittleEndian && endianType != EndianType.Little) || (!BitConverter.IsLittleEndian && endianType != EndianType.Big))
            {
                byte[] b = BitConverter.GetBytes(value);
                Array.Reverse(b);
                base.Write(b, 0, 2);
            }
            else
                base.Write(value);
        }

        public void Write(Single value, EndianType endianType)
        {
            if ((BitConverter.IsLittleEndian && endianType != EndianType.Little) || (!BitConverter.IsLittleEndian && endianType != EndianType.Big))
            {
                byte[] b = BitConverter.GetBytes(value);
                Array.Reverse(b);
                base.Write(b, 0, 4);
            }
            else
                base.Write(value);
        }
    }
}
