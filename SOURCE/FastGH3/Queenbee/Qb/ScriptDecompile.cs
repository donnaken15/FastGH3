using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    public partial class QbItemScript
    {
        public string Translate(Dictionary<uint, string> debugNames)
        {
            var sourceBuilder = new StringBuilder();
            using (var ms = new MemoryStream(this.ScriptData))
            using (var input = new BinaryReader(ms)) {
                int indent = 0;
                int length;
                int vald;
                uint valh;
                float valf, valf2, valf3;
                byte[] buf;
                string str;

                bool isStartOfLine = true;

                long streamLength = input.BaseStream.Length;
                long pos = input.BaseStream.Position;

                StringBuilder currentLine = new StringBuilder();
                while (pos < streamLength) {
                    byte opcode = input.ReadByte();

                    switch (opcode) {
                        case 0x01:
                            sourceBuilder.AppendLine(currentLine.ToString());
                            currentLine.Clear();
                            currentLine.AppendFormat("{0:X4}{1}", pos, new String('\t', indent < 0 ? 0 : indent));
                            break;
                        case 0x03:
                            currentLine.Append("(map) { ");
                            indent++;
                            break;
                        case 0x04:
                            currentLine.Append(" }");
                            indent--;
                            break;
                        case 0x05:
                            currentLine.Append("[");
                            break;
                        case 0x06:
                            currentLine.Append("]");
                            break;
                        case 0x07:
                            currentLine.Append(" = ");
                            break;
                        case 0x08:
                            currentLine.Append(".");
                            break;
                        case 0x09:
                            currentLine.Append(", ");
                            break;
                        case 0x0A:
                            currentLine.Append(" - ");
                            break;
                        case 0x0B:
                            currentLine.Append(" + ");
                            break;
                        case 0x0C:
                            currentLine.Append(" / ");
                            break;
                        case 0x0D:
                            currentLine.Append(" * ");
                            break;
                        case 0x0E:
                            isStartOfLine = true;
                            currentLine.Append("(");
                            break;
                        case 0x0F:
                            currentLine.Append(")");
                            break;
                        case 0x12:
                            currentLine.Append(" < ");
                            break;
                        case 0x13:
                            currentLine.Append(" <= ");
                            break;
                        case 0x14:
                            currentLine.Append(" > ");
                            break;
                        case 0x15:
                            currentLine.Append(" >= ");
                            break;
                        case 0x16:
                            uint checksum = input.ReadUInt32();
                            currentLine.Append(getKeyString(checksum, debugNames));
                            break;
                        case 0x17:
                            vald = input.ReadInt32();
                            currentLine.Append(vald);
                            break;
                        case 0x18:
                            valh = input.ReadUInt32();
                            currentLine.AppendFormat("0x{0:X}", valh);
                            break;
                        case 0x1A:
                            valf = input.ReadSingle();
                            currentLine.AppendFormat("{0:F}", valf);
                            break;
                        case 0x1B:
                            length = input.ReadInt32();
                            buf = input.ReadBytes(length);
                            str = Encoding.ASCII.GetString(buf).TrimEnd('\0');
                            currentLine.AppendFormat("'{0}'", str);
                            break;
                        case 0x1E:
                            valf = input.ReadSingle();
                            valf2 = input.ReadSingle();
                            valf3 = input.ReadSingle();
                            currentLine.AppendFormat("({0:F}, {1:F}, {2:F})", valf, valf2, valf3);
                            break;
                        case 0x1F:
                            valf = input.ReadSingle();
                            valf2 = input.ReadSingle();
                            currentLine.AppendFormat("({0:F}, {1:F})", valf, valf2);
                            break;
                        case 0x20:
                            currentLine.Append("begin");
                            indent++;
                            break;
                        case 0x21:
                            indent--;
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("repeat");
                            break;
                        case 0x22:
                            currentLine.Append("break");
                            break;
                        case 0x23:
                            currentLine.Append("script");
                            indent++;
                            break;
                        case 0x24:
                            indent--;
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("endscript");
                            break;
                        case 0x27:
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("elseif");
                            input.ReadBytes(4); // Skip two offset measurements
                            break;
                        case 0x28:
                            indent--;
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("endif");
                            break;
                        case 0x29:
                            currentLine.Append("return ");
                            break;
                        case 0x2C:
                            currentLine.Append("<...>");
                            break;
                        case 0x2D:
                            currentLine.Append("local ");
                            break;
                        case 0x2E:
                            currentLine.AppendFormat("goto {0:X4}", pos + input.ReadUInt32() + 5);
                            break;
                        case 0x2F:
                            currentLine.Append("random ");
                            getRandom(input, currentLine);
                            break;
                        case 0x30:
                            currentLine.Append("randomrange ");
                            break;
                        case 0x31:
                            currentLine.Append("@");
                            break;
                        case 0x32:
                            currentLine.Append(" || ");
                            break;
                        case 0x33:
                            currentLine.Append(" && ");
                            break;
                        case 0x34:
                            currentLine.Append(" ^ ");
                            break;
                        case 0x37:
                            currentLine.Append("random2 ");
                            break;
                        case 0x38:
                            currentLine.Append("randomrange2 ");
                            break;
                        case 0x39:
                            currentLine.Append("!");
                            break;
                        case 0x3C:
                            currentLine.Append("switch ");
                            indent += 2;
                            break;
                        case 0x3D:
                            indent -= 2;
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("endswitch");
                            break;
                        case 0x3E:
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("case ");
                            break;
                        case 0x3F:
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("default:");
                            break;
                        case 0x40:
                            currentLine.Append("randomnorepeat ");
                            break;
                        case 0x41:
                            currentLine.Append("randompermute ");
                            break;
                        case 0x42:
                            currentLine.Append(":");
                            break;
                        case 0x45:
                            currentLine.Append("useheap ");
                            break;
                        case 0x47:
                            input.ReadBytes(2); // Skip offset
                            currentLine.Append("if ");
                            indent++;
                            break;
                        case 0x48:
                            input.ReadBytes(2); // Skip offset
                            if (currentLine.Length > 0 && currentLine[4] == '\t') currentLine.Remove(4, 1);
                            currentLine.Append("else");
                            break;
                        case 0x49:
                            input.ReadBytes(2);
                            break;
                        case 0x4A:
                            byte b;
                            length = input.ReadInt16();
                            while ((b = input.ReadByte()) == 0)
                                ;
                            if (b == 1 && input.ReadByte() == 0) {
                                long structStartPos = ms.Position - 4;
                                currentLine.AppendFormat(getQbStruct(input, structStartPos, debugNames), new String('\t', indent));
                                ms.Seek(structStartPos + (long) length, SeekOrigin.Begin);
                            } else {
                                throw new Exception("Invalid qb struct; cannot continue decompilation.");
                            }
                            break;
                        case 0x4B:
                            currentLine.Append("*");
                            break;
                        case 0x4C:
                            length = input.ReadInt32();
                            buf = input.ReadBytes(length);
                            str = Encoding.BigEndianUnicode.GetString(buf).TrimEnd('\0');
                            currentLine.AppendFormat("\"{0}\"", str);
                            break;
                        case 0x4D:
                            currentLine.Append(" != ");
                            break;
                        default:
                            currentLine.AppendFormat("{{[UNKNOWN OPCODE {0:X}]}}", opcode);
                            break;
                    }
                    isStartOfLine = opcode == 0x01 || opcode == 0x0E || opcode == 0x42;
                    currentLine.Append(" ");
                    pos = input.BaseStream.Position;
                }
                sourceBuilder.AppendLine(currentLine.ToString());
            }
            return sourceBuilder.ToString().Trim(' ', '\n', '\r');
        }

        private static void getRandom(BinaryReader input, StringBuilder currentLine) {
            currentLine.Append("(");
            uint num_choices = input.ReadUInt32();
            uint[] weights = new uint[num_choices];
            long[] offsets = new long[num_choices];

            for (int i = 0; i < num_choices; i++) {
                weights[i] = input.ReadUInt16();
            }
            for (int i = 0; i < num_choices; i++) {
                offsets[i] = input.ReadUInt32() + input.BaseStream.Position;
            }
            currentLine.AppendFormat("{0:X4}#{1}", offsets[0], weights[0]);
            for (int i = 1; i < num_choices; i++) {
                currentLine.AppendFormat(", {0:X4}#{1}", offsets[i], weights[i]);
            }
            currentLine.Append(")");
        }

        private static string getKeyString(uint checksum, Dictionary<uint, string> debugNames) {
            if (debugNames != null && debugNames.ContainsKey(checksum)) {
                return debugNames[checksum];
            } else {
                return string.Format("${0:X8}", checksum);
            }
        }

        private static string getTypeString(StructType t) {
            switch (t) {
                case StructType.Integer:
                    return "int";
                case StructType.Float:
                    return "float";
                case StructType.String:
                    return "string";
                case StructType.WString:
                    return "wstring";
                case StructType.Vector2:
                    return "vector2";
                case StructType.Vector3:
                    return "vector3";
                case StructType.Struct:
                    return "struct";
                case StructType.Array:
                    return "array";
                case StructType.Key:
                    return "qbkey";
                case StructType.KeyRef:
                    return "qbkeyref";
                case StructType.StrPtr:
                    return "strptr";
                case StructType.StrQS:
                    return "strqs";
                default:
                    return "{{unk type " + ((uint) t).ToString("x8") + "}}";
            }
        }

        private static string getQbStruct(BinaryReader input, long structStartPos, Dictionary<uint, string> debugNames) {
            long nextPos = SwapEndianness(input.ReadUInt32());
            StringBuilder structString = new StringBuilder();
            structString.AppendLine("(QbStruct) {{");

            while (nextPos != 0) {
                input.BaseStream.Seek(structStartPos + nextPos, SeekOrigin.Begin);

                StructType type = (StructType)SwapEndianness(input.ReadUInt32());
                string typeString = getTypeString(type);
                uint key = SwapEndianness(input.ReadUInt32());
                string keyString = getKeyString(key, debugNames);
                string valstr = getQbValue(input, structStartPos, type, debugNames);
                input.BaseStream.Seek(structStartPos + nextPos + 12, SeekOrigin.Begin);
                nextPos = SwapEndianness(input.ReadUInt32());

                structString.AppendFormat("{{0}}\t{0} {1} = {2};\r\n", typeString, keyString, valstr);
            }

            structString.AppendLine("{0}}}");
            return structString.ToString();
        }

        private static string getQbValue(BinaryReader input, long structStartPos, StructType type, Dictionary<uint, string> debugNames) {
            uint dataAddr;
            string valstr;
            byte b, b2;
            byte[] bytes;
            List<byte> buf = new List<byte>();

            switch (type) {
                case StructType.Integer:
                    valstr = ((int) SwapEndianness(input.ReadUInt32())).ToString();
                    return valstr;
                case StructType.Float:
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr = BitConverter.ToSingle(bytes, 0).ToString("F");
                    return valstr;
                case StructType.Key:
                case StructType.KeyRef:
                case StructType.StrPtr:
                case StructType.StrQS:
                    var k = SwapEndianness(input.ReadUInt32());
                    valstr = getKeyString(k, debugNames);
                    return valstr;
                case StructType.String:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos, SeekOrigin.Begin);
                    while ((b = input.ReadByte()) != '\0') {
                        buf.Add(b);
                    }
                    valstr = String.Format("'{0}'", Encoding.ASCII.GetString(buf.ToArray()));
                    return valstr;
                case StructType.WString:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos, SeekOrigin.Begin);
                    do {
                        b = input.ReadByte();
                        b2 = input.ReadByte();
                        buf.Add(b);
                        buf.Add(b2);
                    }
                    while (b != 0 || b2 != 0);
                    valstr = String.Format("\"{0}\"", Encoding.BigEndianUnicode.GetString(buf.ToArray()).TrimEnd('\0'));
                    return valstr;
                case StructType.Vector2:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos + 4, SeekOrigin.Begin);
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr = "(";
                    valstr += BitConverter.ToSingle(bytes, 0).ToString("F") + ", ";
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr += BitConverter.ToSingle(bytes, 0).ToString("F") + ")";
                    return valstr;
                case StructType.Vector3:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos + 4, SeekOrigin.Begin);
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr = "(";
                    valstr += BitConverter.ToSingle(bytes, 0).ToString("F") + ", ";
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr += BitConverter.ToSingle(bytes, 0).ToString("F") + ", ";
                    bytes = BitConverter.GetBytes(SwapEndianness(input.ReadUInt32()));
                    valstr += BitConverter.ToSingle(bytes, 0).ToString("F") + ")";
                    return valstr;
                case StructType.Struct:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos, SeekOrigin.Begin);
                    valstr = (input.ReadUInt32() == 0x00010000) ? "" : "{0}{{warning: struct header not found}}";
                    valstr += getQbStruct(input, structStartPos, debugNames);
                    return valstr;
                case StructType.Array:
                    dataAddr = SwapEndianness(input.ReadUInt32());
                    input.BaseStream.Seek(dataAddr + structStartPos, SeekOrigin.Begin);
                    valstr = "[";
                    type = ConvertArrayType((ArrayType) SwapEndianness(input.ReadUInt32()));
                    if (type == 0) {
                        return "[{{unknown element type}}]";
                    }

                    long startPos = input.BaseStream.Position;
                    uint arrLength = SwapEndianness(input.ReadUInt32());
                    if (arrLength == 0) {
                        // do nothing
                    }
                    if (arrLength > 1) {
                        dataAddr = SwapEndianness(input.ReadUInt32());
                        startPos = input.BaseStream.Position;
                        input.BaseStream.Seek(dataAddr + structStartPos, SeekOrigin.Begin);
                    }
                    valstr += getQbValue(input, structStartPos, type, debugNames);
                    input.BaseStream.Seek(startPos, SeekOrigin.Begin);

                    for (int i = 1; i < arrLength; i++) {
                        valstr += ", " + getQbValue(input, structStartPos, type, debugNames);
                        input.BaseStream.Seek(startPos, SeekOrigin.Begin);
                        input.BaseStream.Seek(startPos + 4 * i, SeekOrigin.Begin);
                    }
                    valstr += "]";
                    return valstr;
                default:
                    return "{{unknown value: " + SwapEndianness(input.ReadUInt32()).ToString("x8") + "}}";
            }
        }

        private static uint SwapEndianness(uint val) {
            return ((val & 0xFF) << 24
                   | (val & 0xFF00) << 8
                   | (val & 0xFF0000) >> 8
                   | (val & 0xFF000000) >> 24
                   );
        }

        private static StructType ConvertArrayType(ArrayType t) {
            switch (t) {
                case ArrayType.Integer:
                    return StructType.Integer;
                case ArrayType.Float:
                    return StructType.Float;
                case ArrayType.String:
                    return StructType.String;
                case ArrayType.WString:
                    return StructType.WString;
                case ArrayType.Vector2:
                    return StructType.Vector2;
                case ArrayType.Vector3:
                    return StructType.Vector3;
                case ArrayType.Struct:
                    return StructType.Struct;
                case ArrayType.Key:
                    return StructType.Key;
                case ArrayType.KeyRef:
                    return StructType.KeyRef;
                case ArrayType.StrPtr:
                    return StructType.StrPtr;
                case ArrayType.StrQS:
                    return StructType.StrQS;
                default:
                    return 0;
            }
        }
    }

    enum StructType : uint
    {
        Integer = 0x00810000,
        Float = 0x00820000,
        String = 0x00830000,
        WString = 0x00840000,
        Vector2 = 0x00850000,
        Vector3 = 0x00860000,
        Struct = 0x008A0000,
        Array = 0x008C0000,
        Key = 0x008D0000,
        KeyRef = 0x009A0000,
        StrPtr = 0x009B0000,
        StrQS = 0x009C0000
    }

    enum ArrayType : uint
    {
        Integer = 0x00010100,
        Float = 0x00010200,
        String = 0x00010300,
        WString = 0x00010400,
        Vector2 = 0x00010500,
        Vector3 = 0x00010600,
        Struct = 0x00010A00,
        Array = 0x00010C00,
        Key = 0x00010D00,
        KeyRef = 0x00011A00,
        StrPtr = 0x00011B00,
        StrQS = 0x00011C00
    }
}
