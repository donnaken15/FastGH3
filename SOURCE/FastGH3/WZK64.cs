﻿
using System;
using System.Text;

// (not) try at implementing some
// basic hash generation like CRC32 // NOT EVEN CLOSE!!

static class WZK64
{
	public static ulong Create(char[] data)
	{
		return Create(Encoding.ASCII.GetBytes(data));
	}

	public static ulong Create(string data)
	{
		return Create(Encoding.ASCII.GetBytes(data));
	}

	public static ulong Create(byte[] data)
	{
		ulong hash = 0x5745534C45593634; // "WESLEY64"
		for (int i = 0; i < data.Length; i++)
		{
			hash ^= (((ulong)((ulong)data[i] << 56) >> ((i%8)*8)));
		}
		hash ^= ((ulong)data.Length * 0x343659454C534557); // backwards baseval
		return hash;
	}
}
