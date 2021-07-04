using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
    /// <summary>
    /// Added to cater for GH having the same QbItemTypes under different headers (arrays directly under structs for example)
    /// </summary>
    public enum QbFormat
    {
        SectionPointer,
        SectionValue,
        StructItemPointer,
        StructItemValue,
        ArrayPointer,
        ArrayValue,
        StructHeader,
        Floats,
        Unknown
    }

    public enum QbItemType : uint
    {
        Unknown = 0,
        SectionInteger,
        SectionFloat,
        SectionString,
        SectionStringW, //unicode on PC, not on Wii
        SectionFloatsX2,
        SectionFloatsX3,
        SectionScript,
        SectionStruct,
        SectionArray,
        SectionQbKey, //items match debug file

        SectionQbKeyString,   //Pointer for TH:DHJ QbKey for GH
        SectionStringPointer, //pointer in to the languages file  
        SectionQbKeyStringQs, //GH:GH  //pointer in to a qs file

        ArrayInteger,
        ArrayFloat,
        ArrayString, //tightly packed only last item is padded with 0 to % 4.
        ArrayStringW, //unicode on PC, not on Wii
        ArrayFloatsX2,
        ArrayFloatsX3,
        ArrayStruct,
        ArrayArray, //Array of arrays, lucky this was one of the last types found (complicated otherwise)
        ArrayQbKey, //items match debug file

        ArrayQbKeyString, //Array of crc that match items in the debug file?  //Pointer for TH:DHJ QbKey for GH
        ArrayStringPointer,
        ArrayQbKeyStringQs, //Array if QbKeys??

        StructItemInteger,
        StructItemFloat,
        StructItemString,
        StructItemStringW, //unicode on PC, not on Wii
        StructItemFloatsX2, //the guitar.hud.qb.ngc file has this as "pos" holding a Floats type
        StructItemFloatsX3, //contains a 0x00010000 datatype with a 3 values instead of the regular 2 (not nice :-( )
        StructItemStruct,
        StructItemArray, //the guitar.hud.qb.ngc file has this holding 2 Crc Ids for "center" and "top", or integers
        StructItemQbKey,

        StructItemQbKeyString,   //Pointer for TH:DHJ QbKey for GH
        StructItemStringPointer,
        StructItemQbKeyStringQs,

        Floats, //this isn't really an array, just a simple type
        StructHeader,
        Root
    }
}
