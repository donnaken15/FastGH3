/*
 * 
 *	DDSImage.cs - DDS Texture File Reading (Uncompressed, DXT1/2/3/4/5, V8U8) and Writing (Uncompressed Only)
 *	
 *	By Shendare (Jon D. Jackson)
 * 
 *	Rebuilt from Microsoft DDS documentation with the help of the DDSImage.cs reading class from
 *	Lorenzo Consolaro, under the MIT License.  https://code.google.com/p/kprojects/ 
 * 
 *	Portions of this code not covered by another author's or entity's copyright are released under
 *	the Creative Commons Zero (CC0) public domain license.
 *	
 *	To the extent possible under law, Shendare (Jon D. Jackson) has waived all copyright and
 *	related or neighboring rights to this DDSImage class. This work is published from: The United States. 
 *	
 *	You may copy, modify, and distribute the work, even for commercial purposes, without asking permission.
 * 
 *	For more information, read the CC0 summary and full legal text here:
 *	
 *	https://creativecommons.org/publicdomain/zero/1.0/
 * 
 */

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace DDS
{
	class DDSImage
	{
		public enum CMP
		{
			Unknown = 0,
			DXT1 = 1,
			DXT2 = 2,
			DXT3 = 3,
			DXT4 = 4,
			DXT5 = 5,
			V8U8 = 7,
			DX10 = 10,
			A1R5G5B5 = 15,
			RGB15 = 15,
			R5G6B5 = 16,
			RGB16 = 16,
			RGB24 = 24,
			RGB32 = 32
		}

		public HEAD Header;

#pragma warning disable 0649
		public HEAD10 Header10;
#pragma warning restore 0649

		public PIXFMT PixFmt;

		public Bitmap[] Images;

		public int MipMapCount;

		public CMP Format;
		public string FormatName
		{
			get
			{
				switch (Format)
				{
					case CMP.A1R5G5B5:
						return "ARGB16";
					case CMP.R5G6B5:
						return "RGB16";
					default:
						return Format.ToString();
				}
			}
		}

		public DDSImage() { }

		public static DDSImage Load(string Filename) { using (FileStream _stream = File.OpenRead(Filename)) { return Load(_stream); } }
		public static DDSImage Load(byte[] data)
		{
			byte[] FileNoTXTR;
			if (data[0] == 4 && data[1] == 0 &&
				data[2] == 0 && data[3] == 0 &&
				data[4] == 3)
			{
				FileNoTXTR = new byte[data.Length - 0x1C];
				Array.Copy(data, 0x1C, FileNoTXTR, 0, data.Length - 0x1C);
			}
			else
				FileNoTXTR = data;
			using (MemoryStream _stream = new MemoryStream(FileNoTXTR))
			{
				return Load(_stream);
			}
		}
		public static DDSImage Load(Stream Source)
		{
			DDSImage _dds = new DDSImage();

			using (BinaryReader _data = new BinaryReader(Source))
			{
				if (_data.ReadInt32() != 0x20534444)
				{
					throw new InvalidDataException("DDSImage.Load() requires a .dds texture file stream");
				}

				_dds.Format = CMP.Unknown;

				_dds.Header.size = _data.ReadInt32();
				_dds.Header.flags = _data.ReadInt32();
				_dds.Header.h = _data.ReadInt32();
				_dds.Header.w = _data.ReadInt32();
				_dds.Header.PoLS = _data.ReadInt32();
				_dds.Header.depth = _data.ReadInt32();
				_dds.Header.mipmapc = _data.ReadInt32();

				// Unused Reserved1 Fields
				_data.ReadBytes(11 * sizeof(int));

				// Image Pixel Format
				_dds.PixFmt.size = _data.ReadUInt32();
				_dds.PixFmt.flags = _data.ReadUInt32();
				_dds.PixFmt._4CC = _data.ReadUInt32();
				_dds.PixFmt.RGBBC = _data.ReadUInt32();
				_dds.PixFmt.R = _data.ReadUInt32();
				_dds.PixFmt.G = _data.ReadUInt32();
				_dds.PixFmt.B = _data.ReadUInt32();
				_dds.PixFmt.A = _data.ReadUInt32();

				_dds.Header.rsv2 = _data.ReadInt32();
				_dds.Header.rsv3 = _data.ReadInt32();
				_dds.Header.rsv4 = _data.ReadInt32();
				_dds.Header.rsv5 = _data.ReadInt32();
				_dds.Header.rsv6 = _data.ReadInt32();

				if ((_dds.PixFmt.flags & 4) != 0)
				{
					switch (_dds.PixFmt._4CC)
					{
						case 0x30315844:
							_dds.Format = CMP.DX10;
							throw new InvalidDataException("DX10 textures not supported at this time.");
						case 0x31545844:
							_dds.Format = CMP.DXT1;
							break;
						case 0x32545844:
							_dds.Format = CMP.DXT2;
							break;
						case 0x33545844:
							_dds.Format = CMP.DXT3;
							break;
						case 0x34545844:
							_dds.Format = CMP.DXT4;
							break;
						case 0x35545844:
							_dds.Format = CMP.DXT5;
							break;
						default:
							switch (_dds.PixFmt._4CC)
							{
								default:
									break;
							}
							throw new InvalidDataException("Unsupported compression format");
					}
				}

				if ((_dds.PixFmt.flags & 4) == 0)
				{
					// Uncompressed. How many BPP?

					bool _supportedBpp = false;

					switch (_dds.PixFmt.RGBBC)
					{
						case 16:
							if (_dds.PixFmt.A == 0)
							{
								_dds.Format = CMP.R5G6B5;
							}
							else
							{
								_dds.Format = CMP.A1R5G5B5;
							}
							_supportedBpp = true;
							break;
						case 24:
							_dds.Format = CMP.RGB24;
							_supportedBpp = true;
							break;
						case 32:
							_dds.Format = CMP.RGB32;
							_supportedBpp = true;
							break;
					}

					if (!_supportedBpp)
					{
						throw new Exception("Only 16, 24, and 32-bit pixel formats are supported for uncompressed textures.");
					}
				}

				_dds.MipMapCount = 1;
				if ((_dds.Header.flags & 0x00020000) != 0)
				{
					_dds.MipMapCount = (_dds.Header.mipmapc == 0) ? 1 : _dds.Header.mipmapc;
				}

				_dds.Images = new Bitmap[_dds.MipMapCount];

				int _imageSize;
				int _w = (_dds.Header.w < 0) ? -_dds.Header.w : _dds.Header.w;
				int _h = (_dds.Header.h < 0) ? -_dds.Header.h : _dds.Header.h;

				// DDS Documentation recommends ignoring the dwLinearOrPitchSize value and calculating on your own.
				if ((_dds.PixFmt.flags & 0x40) != 0)
				{
					// Linear Size

					_imageSize = (_w * _h * ((int)_dds.PixFmt.RGBBC + 7) >> 3);
				}
				else
				{
					// Compressed

					_imageSize = ((_w + 3) >> 2) * (((_h + 3) >> 2));

					switch (_dds.PixFmt._4CC)
					{
						case 0x31545844:
							_imageSize <<= 3; // 64 bits color per block
							break;
						case 0x32545844:
						case 0x33545844:
							_imageSize <<= 4; // 64 bits alpha + 64 bits color per block
							break;
						case 0x34545844:
						case 0x35545844:
							_imageSize <<= 4; // 64 bits alpha + 64 bits color per block
							break;
					}
				}

				byte[] _imageBits;

				for (int _level = 0; _level < _dds.MipMapCount; _level++)
				{
					try
					{
						_imageBits = _data.ReadBytes(_imageSize >> (_level << 1));

						int _w2 = _w >> _level;
						int _h2 = _h >> _level;

						uint _compressionMode = _dds.PixFmt._4CC;

						if ((_dds.PixFmt.flags & 0x40) != 0)
						{
							_compressionMode = (uint)_dds.Format;
						}
						else if ((_dds.PixFmt.flags & 4) == 0 &&
								  _dds.PixFmt.RGBBC == 16 &&
								  _dds.PixFmt.R == 0x00FF &&
								  _dds.PixFmt.G == 0xFF00 &&
								  _dds.PixFmt.B == 0x0000 &&
								  _dds.PixFmt.A == 0x0000)
						{
							_dds.Format = CMP.V8U8;
							_compressionMode = 0X38553856;
						}

						_dds.Images[_level] = Decompress.Image(_imageBits, _w2, _h2, _compressionMode);
					}
					catch
					{
						// Unexpected end of file. Perhaps mipmapc weren't fully written to file.
						// We'll at least provide them with what we've extracted so far.

						_dds.MipMapCount = _level;

						if (_level == 0)
						{
							_dds.Images = null;

							throw new InvalidDataException("Unable to read pixel data.");
						}
						else
						{
							Array.Resize(ref _dds.Images, _level);
						}
					}
				}
			}

			return _dds;
		}

		private class Decompress
		{
			public static Bitmap Image(byte[] Data, int W, int H, uint CMP)
			{
				Bitmap _img = new Bitmap((W < 4) ? 4 : W, (H < 4) ? 4 : H);

				switch (CMP)
				{
					case 15:
					case 16:
					case 24:
					case 32:
						return Linear(Data, W, H, CMP);
				}

				// https://msdn.microsoft.com/en-us/library/bb147243%28v=vs.85%29.aspx

				// Gain direct access to the surface's bits
				BitmapData _bits = _img.LockBits(new Rectangle(0, 0, _img.Width, _img.Height), ImageLockMode.WriteOnly, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
				IntPtr _bitPtr = _bits.Scan0;

				// Convert byte[] data into 16-bit ushorts per Microsoft design/documentation
				ushort[] _bpp16 = new ushort[Data.Length >> 1];
				Buffer.BlockCopy(Data, 0, _bpp16, 0, Data.Length);

				// Checking for negative stride per documentation just to be safe, but I don't think bottom-up format is supported with DXT1.
				// Converting from bytes to ushorts for _bpp16
				Int32 _stride = (((_bits.Stride < 0) ? -_bits.Stride : _bits.Stride) >> 2);

				// Our actual pixel data as it is decompressed
				Int32[] _pixels = new Int32[_stride * _bits.Height];

				// Decompress the blocks
				switch (CMP)
				{
					case 0x31545844:
						DXT1(_bpp16, _pixels, W, H, _stride);
						break;

					case 0x32545844:
					case 0x33545844:
						DXT3(_bpp16, _pixels, W, H, _stride);
						break;

					case 0x34545844:
					case 0x35545844:
						DXT5(_bpp16, _pixels, W, H, _stride);
						break;

					case 0X38553856:
						V8U8(_bpp16, _pixels, W, H, _stride);
						break;

					default:
						_pixels = null;
						break;
				}

				// Copy our decompressed bits back into the surface
				if (_pixels != null)
				{
					System.Runtime.InteropServices.Marshal.Copy(_pixels, 0, _bitPtr, _stride * _bits.Height);
				}

				// We're done!
				_img.UnlockBits(_bits);

				if (_pixels == null)
				{
					throw new InvalidDataException(string.Format("DDS compression Mode '{0}{0}{0}{0}' not supported.",
						(char)(CMP & 0xFF),
						(char)((CMP >> 8) & 0xFF),
						(char)((CMP >> 16) & 0xFF),
						(char)((CMP >> 24) & 0xFF)));
				}

				return _img;
			}

			private static void DXT1(ushort[] Data, Int32[] Pixels, int W, int H, int Stride)
			{
				UInt32[] _color = new UInt32[4];
				int _pos = 0;
				int _stride2 = Stride - 4;

				for (int _y = 0; _y < H; _y += 4)
				{
					for (int _x = 0; _x < W; _x += 4)
					{
						ushort _c1 = Data[_pos++];
						ushort _c2 = Data[_pos++];

						bool _isAlpha = (_c1 < _c2);

						uint _r1 = (byte)((_c1 >> 11) & 0x1F);
						uint _g1 = (byte)((_c1 & 0x07E0) >> 5);
						uint _b1 = (byte)(_c1 & 0x001F);

						uint _r2 = (byte)((_c2 >> 11) & 0x1F);
						uint _g2 = (byte)((_c2 & 0x07E0) >> 5);
						uint _b2 = (byte)(_c2 & 0x001F);

						_r1 = (_r1 << 3) + (_r1 >> 2);
						_g1 = (_g1 << 2) + (_g1 >> 4);
						_b1 = (_b1 << 3) + (_b1 >> 2);

						_r2 = (_r2 << 3) + (_r2 >> 2);
						_g2 = (_g2 << 2) + (_g2 >> 4);
						_b2 = (_b2 << 3) + (_b2 >> 2);

						uint _a = unchecked((uint)(0xFF << 24));

						if (_isAlpha)
						{
							_color[0] = _a | _r1 << 16 | _g1 << 8 | _b1;
							_color[1] = _a | _r2 << 16 | _g2 << 8 | _b2;
							_color[2] = _a | (((_r1 + _r2) >> 1) << 16) | (((_g1 + _g2) >> 1) << 8) | ((_b1 + _b2) >> 1);
							_color[3] = 0x00000000; // Transparent pixel
						}
						else
						{
							_color[0] = _a | _r1 << 16 | _g1 << 8 | _b1;
							_color[1] = _a | _r2 << 16 | _g2 << 8 | _b2;
							_color[2] = _a | ((((_r2 * 3) + (_r1 * 6)) / 9) << 16) | ((((_g2 * 3) + (_g1 * 6)) / 9) << 8) | (((_b2 * 3) + (_b1 * 6)) / 9);
							_color[3] = _a | ((((_r1 * 3) + (_r2 * 6)) / 9) << 16) | ((((_g1 * 3) + (_g2 * 6)) / 9) << 8) | (((_b1 * 3) + (_b2 * 6)) / 9);
						}

						int _pixel = _y * Stride + _x;

						ushort _code = Data[_pos++];

						Pixels[_pixel++] = unchecked((int)_color[_code & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] = unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 14 & 0x03]);
						_pixel += _stride2;

						_code = Data[_pos++];

						Pixels[_pixel++] = unchecked((int)_color[_code & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] = unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] = unchecked((int)_color[_code >> 14 & 0x03]);
					}
				}
			}

			private static void DXT3(ushort[] Data, Int32[] Pixels, int W, int H, int Stride)
			{
				ushort[] _alpha = new ushort[4];
				int _pos = 0;
				int _stride2 = Stride - 4;

				for (int _y = 0; _y < H; _y += 4)
				{
					for (int _x = 0; _x < W; _x += 4)
					{
						for (int _i = 0; _i < 4; _i++)
						{
							_alpha[_i] = Data[_pos++];
						}

						int _pixel = _y * Stride + _x;

						for (int _i = 0; _i < 4; _i++)
						{
							Pixels[_pixel++] = (((_alpha[_i] >> 0) & 0x000F) * 255 / 15) << 24;
							Pixels[_pixel++] = (((_alpha[_i] >> 4) & 0x000F) * 255 / 15) << 24;
							Pixels[_pixel++] = (((_alpha[_i] >> 8) & 0x000F) * 255 / 15) << 24;
							Pixels[_pixel++] = (((_alpha[_i] >> 12) & 0x000F) * 255 / 15) << 24;

							_pixel += _stride2;
						}

						UInt32[] _color = new UInt32[4];

						ushort _c1 = Data[_pos++];
						ushort _c2 = Data[_pos++];

						uint _r1 = (byte)((_c1 >> 11) & 0x1F);
						uint _g1 = (byte)((_c1 & 0x07E0) >> 5);
						uint _b1 = (byte)(_c1 & 0x001F);

						uint _r2 = (byte)((_c2 >> 11) & 0x1F);
						uint _g2 = (byte)((_c2 & 0x07E0) >> 5);
						uint _b2 = (byte)(_c2 & 0x001F);

						_r1 = (_r1 << 3) + (_r1 >> 2);
						_g1 = (_g1 << 2) + (_g1 >> 4);
						_b1 = (_b1 << 3) + (_b1 >> 2);

						_r2 = (_r2 << 3) + (_r2 >> 2);
						_g2 = (_g2 << 2) + (_g2 >> 4);
						_b2 = (_b2 << 3) + (_b2 >> 2);

						_color[0] = _r1 << 16 | _g1 << 8 | _b1;
						_color[1] = _r2 << 16 | _g2 << 8 | _b2;
						_color[2] = ((((_r2 * 3) + (_r1 * 6)) / 9) << 16) | ((((_g2 * 3) + (_g1 * 6)) / 9) << 8) | (((_b2 * 3) + (_b1 * 6)) / 9);
						_color[3] = ((((_r1 * 3) + (_r2 * 6)) / 9) << 16) | ((((_g1 * 3) + (_g2 * 6)) / 9) << 8) | (((_b1 * 3) + (_b2 * 6)) / 9);

						_pixel = _y * Stride + _x;

						ushort _code = Data[_pos++];

						Pixels[_pixel++] |= unchecked((int)_color[_code & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 14 & 0x03]);
						_pixel += _stride2;

						_code = Data[_pos++];

						Pixels[_pixel++] |= unchecked((int)_color[_code & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 14 & 0x03]);
					}
				}
			}

			private static void DXT5(ushort[] Data, Int32[] Pixels, int W, int H, int Stride)
			{
				UInt32[] _color = new UInt32[4];
				ushort[] _alpha = new ushort[8];
				ushort[] _alphaBits = new ushort[3];
				ushort _alphaCode;
				int _pos = 0;
				int _stride2 = Stride - 4;
				ushort _code;

				for (int _y = 0; _y < H; _y += 4)
				{
					for (int _x = 0; _x < W; _x += 4)
					{
						_alpha[0] = (ushort)(Data[_pos] & 0xFF);
						_alpha[1] = (ushort)(Data[_pos++] >> 8);

						if (_alpha[0] > _alpha[1])
						{
							// 8 alpha block
							_alpha[2] = (ushort)((6 * _alpha[0] + 1 * _alpha[1] + 3) / 7);
							_alpha[3] = (ushort)((5 * _alpha[0] + 2 * _alpha[1] + 3) / 7);
							_alpha[4] = (ushort)((4 * _alpha[0] + 3 * _alpha[1] + 3) / 7);
							_alpha[5] = (ushort)((3 * _alpha[0] + 4 * _alpha[1] + 3) / 7);
							_alpha[6] = (ushort)((2 * _alpha[0] + 5 * _alpha[1] + 3) / 7);
							_alpha[7] = (ushort)((1 * _alpha[0] + 6 * _alpha[1] + 3) / 7);
						}
						else
						{
							// 6 alpha block
							_alpha[2] = (ushort)((4 * _alpha[0] + 1 * _alpha[1] + 2) / 5);
							_alpha[3] = (ushort)((3 * _alpha[0] + 2 * _alpha[1] + 2) / 5);
							_alpha[4] = (ushort)((2 * _alpha[0] + 3 * _alpha[1] + 2) / 5);
							_alpha[5] = (ushort)((1 * _alpha[0] + 4 * _alpha[1] + 2) / 5);
							_alpha[6] = 0;
							_alpha[7] = 0xFF;
						}

						for (int _i = 0; _i < 3; _i++)
						{
							_alphaBits[_i] = Data[_pos++];
						}

						int _pixel = _y * Stride + _x;

						_alphaCode = _alphaBits[0];
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24;
						_pixel += _stride2;

						_alphaCode = (ushort)((_alphaBits[0] >> 12) | (_alphaBits[1] << 4));
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24;
						_pixel += _stride2;

						_alphaCode = (ushort)((_alphaBits[1] >> 8) | (_alphaBits[2] << 8));
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24;
						_pixel += _stride2;

						_alphaCode = (ushort)(_alphaBits[2] >> 4);
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24; _alphaCode >>= 3;
						Pixels[_pixel++] = _alpha[_alphaCode & 0x0007] << 24;

						ushort _c1 = Data[_pos++];
						ushort _c2 = Data[_pos++];

						uint _r1 = (byte)((_c1 >> 11) & 0x1F);
						uint _g1 = (byte)((_c1 & 0x07E0) >> 5);
						uint _b1 = (byte)(_c1 & 0x001F);

						uint _r2 = (byte)((_c2 >> 11) & 0x1F);
						uint _g2 = (byte)((_c2 & 0x07E0) >> 5);
						uint _b2 = (byte)(_c2 & 0x001F);

						_r1 = (_r1 << 3) + (_r1 >> 2);
						_g1 = (_g1 << 2) + (_g1 >> 4);
						_b1 = (_b1 << 3) + (_b1 >> 2);

						_r2 = (_r2 << 3) + (_r2 >> 2);
						_g2 = (_g2 << 2) + (_g2 >> 4);
						_b2 = (_b2 << 3) + (_b2 >> 2);

						_color[0] = _r1 << 16 | _g1 << 8 | _b1;
						_color[1] = _r2 << 16 | _g2 << 8 | _b2;
						_color[2] = ((((_r2 * 1) + (_r1 * 2)) / 3) << 16) | ((((_g2 * 1) + (_g1 * 2)) / 3) << 8) | (((_b2 * 1) + (_b1 * 2)) / 3);
						_color[3] = ((((_r1 * 1) + (_r2 * 2)) / 3) << 16) | ((((_g1 * 1) + (_g2 * 2)) / 3) << 8) | (((_b1 * 1) + (_b2 * 2)) / 3);

						_pixel = _y * Stride + _x;

						_code = Data[_pos++];

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 0 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 14 & 0x03]);
						_pixel += _stride2;

						_code = Data[_pos++];

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 0 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 2 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 4 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 6 & 0x03]);
						_pixel += _stride2;

						Pixels[_pixel++] |= unchecked((int)_color[_code >> 8 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 10 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 12 & 0x03]);
						Pixels[_pixel++] |= unchecked((int)_color[_code >> 14 & 0x03]);
					}
				}
			}

			private static void V8U8(ushort[] Data, Int32[] Pixels, int W, int H, int Stride)
			{
				int _pos = 0;

				for (int _y = 0; _y < H; _y++)
				{
					int _pixel = _y * Stride;

					for (int _x = 0; _x < W; _x++)
					{
						Pixels[_pixel++] = unchecked((int)(Data[_pos++] ^ 0xFFFFFFFF));
					}
				}
			}

			private static Bitmap Linear(byte[] Data, int W, int H, uint bpp)
			{
				Bitmap _img = new Bitmap(W, H);

				int _a, _r, _g, _b, _c, _pos;

				BitmapData _bits = _img.LockBits(new Rectangle(0, 0, _img.Width, _img.Height), ImageLockMode.WriteOnly, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
				IntPtr _bitPtr = _bits.Scan0;

				Int32 _stride = (((_bits.Stride < 0) ? -_bits.Stride : _bits.Stride) >> 2);
				Int32[] _pixels = new Int32[_stride * _bits.Height];

				switch (bpp)
				{
					case 15: // CMP.A1R5G5B5:
						_pos = 0;
						for (int _y = 0; _y < H; _y++)
						{
							int _xy = _y * (_bits.Stride >> 2);

							for (int _x = 0; _x < W; _x++)
							{
								_c = Data[_pos++];
								_c |= Data[_pos++] << 8;

								_a = (_c & 0x8000) == 0 ? 0 : 0xFF;
								_r = ((_c & 0x7C00) >> 10) * 255 / 31;
								_g = ((_c & 0x03E0) >> 5) * 255 / 31;
								_b = (_c & 0x001F) * 255 / 31;

								_pixels[_xy++] = _a << 24 | _r << 16 | _g << 8 | _b;
							}
						}
						break;
					case 16: // CMP.R5G6B5:
						_pos = 0;
						_a = 0xFF << 24;

						for (int _y = 0; _y < H; _y++)
						{
							int _xy = _y * (_bits.Stride >> 2);

							for (int _x = 0; _x < W; _x++)
							{
								_c = Data[_pos++];
								_c |= Data[_pos++] << 8;

								_r = ((_c & 0xF800) >> 11) * 255 / 31;
								_g = ((_c & 0x07E0) >> 5) * 255 / 63;
								_b = (_c & 0x001F) * 255 / 31;

								_pixels[_xy++] = _a | _r << 16 | _g << 8 | _b;
							}
						}
						break;
					case 24: // R8G8B8
						_a = 0xFF << 24;

						using (BinaryReader _reader = new BinaryReader(new MemoryStream(Data)))
						{
							_reader.BaseStream.Seek(0, SeekOrigin.Begin);

							for (int _y = 0; _y < _img.Height; _y++)
							{
								int _xy = ((_bits.Stride < 0) ? (_img.Height - _y) : _y) * _stride;

								for (int _x = 0; _x < _img.Width; _x++)
								{
									_b = _reader.ReadByte();
									_g = _reader.ReadByte();
									_r = _reader.ReadByte();

									_pixels[_xy++] = _a | (_r << 16) | (_g << 8) | _b;
								}
							}
						}
						break;
					case 32: // A8R8G8B8
						Int32[] _bpp32 = new Int32[Data.Length >> 2];
						Buffer.BlockCopy(Data, 0, _bpp32, 0, Data.Length);

						if ((_stride == _img.Width) && (_bits.Stride > 0))
						{
							// Cohesive block of pixel data. No need to go row by row.

							Array.Copy(_bpp32, _pixels, _pixels.Length);
						}
						else
						{
							for (int _y = 0; _y < _img.Height; _y++)
							{
								// if Stride < 0, image is stored from the bottom up, so we have to invert our _y
								int _xy1 = ((_bits.Stride < 0) ? (_img.Height - _y) : _y) * _stride;
								int _xy2 = _y * W;

								Array.Copy(_bpp32, _xy2, _pixels, _xy1, _stride);
							}
						}
						break;
				}

				System.Runtime.InteropServices.Marshal.Copy(_pixels, 0, _bitPtr, _stride * _bits.Height);

				_img.UnlockBits(_bits);

				return _img;
			}
		}

		/*public static bool Save(DDSImage Image, string Filename, CMP Format)
		{
			try
			{
				return Save(Image.Images[0], Filename, Format);
			}
			catch
			{
				return false;
			}
		}
		public static bool Save(DDSImage Image, Stream Stream, CMP Format)
		{
			try
			{
				return Save(Image.Images[0], Stream, Format);
			}
			catch
			{
				return false;
			}
		}
		public static bool Save(Bitmap Picture, string Filename, CMP Format)
		{
			try
			{
				using (FileStream _stream = File.OpenWrite(Filename))
				{
					return Save(Picture, _stream, Format);
				}
			}
			catch
			{
				return false;
			}
		}
		public static bool Save(Bitmap Picture, Stream Stream, CMP Format)
		{
			if ((Picture == null) || (Stream == null))
			{
				return false;
			}

			switch (Format)
			{
				case CMP.A1R5G5B5:
					break;
				case CMP.R5G6B5:
					break;
				case CMP.RGB24:
					break;
				case CMP.RGB32:
					break;
				default:
					return false;
			}

			uint _bpp = (uint)Format;

			List<Bitmap> _mipMaps = new List<Bitmap>();
			_mipMaps.Add(Picture);

			try
			{
				while (true)
				{
					int _w = Picture.Width >> _mipMaps.Count;
					int _h = Picture.Height >> _mipMaps.Count;

					if ((_w < 4) || (_h < 4))
					{
						break;
					}

					Bitmap _map = new Bitmap(_w, _h);

					using (Graphics _blitter = Graphics.FromImage(_map))
					{
						_blitter.InterpolationMode = InterpolationMode.HighQualityBicubic;

						using (ImageAttributes _wrapMode = new System.Drawing.Imaging.ImageAttributes())
						{
							_wrapMode.SetWrapMode(WrapMode.TileFlipXY);

							_blitter.DrawImage(Picture, new Rectangle(0, 0, _w, _h), 0, 0, Picture.Width, Picture.Height, GraphicsUnit.Pixel, _wrapMode);
						}
					}

					_mipMaps.Add(_map);
				}

				HEAD _header;
				PIXFMT _format;

				using (BinaryWriter _stream = new BinaryWriter(Stream))
				{
					_stream.Write(0x20534444); // Magic Number ("DDS ")

					uint _hasAlpha = ((Picture.PixelFormat & System.Drawing.Imaging.PixelFormat.Alpha) != 0) ? 1u : 0u;

					_format.size = 32;
					_format.flags = 0x40 | (1 * _hasAlpha); // DDPF_ALPHAPIXELS
					_format._4CC = 0;
					switch (Format)
					{
						case CMP.R5G6B5:
							_format.RGBBC = 16;
							_format.A = 0x0000;
							_format.R = 0xF800;
							_format.G = 0x07E0;
							_format.B = 0x001F;
							break;
						case CMP.A1R5G5B5:
							_format.RGBBC = 16;
							_format.A = 0x8000;
							_format.R = 0x7C00;
							_format.G = 0x03E0;
							_format.B = 0x001F;
							break;
						case CMP.RGB24:
							_format.RGBBC = 24;
							_format.A = 0x00000000;
							_format.R = 0x00ff0000;
							_format.G = 0x0000ff00;
							_format.B = 0x000000ff;
							break;
						case CMP.RGB32:
						default:
							_format.RGBBC = 32;
							_format.A = 0xff000000 * _hasAlpha;
							_format.R = 0x00ff0000;
							_format.G = 0x0000ff00;
							_format.B = 0x000000ff;
							break;
					}

					_header.size = 124;
					_header.flags = 0x2100F;
					_header.h = Picture.Height;
					_header.w = Picture.Width;
					_header.PoLS = (int)(_header.w * _header.h * (_format.RGBBC >> 3));
					_header.depth = 0;
					_header.mipmapc = _mipMaps.Count;
					_header.rsv2 = 0x401008;
					_header.rsv3 = 0;
					_header.rsv4 = 0;
					_header.rsv5 = 0;
					_header.rsv6 = 0;

					_stream.Write(_header.size);
					_stream.Write(_header.flags);
					_stream.Write(_header.h);
					_stream.Write(_header.w);
					_stream.Write(_header.PoLS);
					_stream.Write(_header.depth);
					_stream.Write(_header.mipmapc);

					for (int _i = 0; _i < 11; _i++)
					{
						_stream.Write((uint)0);
					}

					_stream.Write(_format.size);
					_stream.Write(_format.flags);
					_stream.Write(_format._4CC);
					_stream.Write(_format.RGBBC);
					_stream.Write(_format.R);
					_stream.Write(_format.G);
					_stream.Write(_format.B);
					_stream.Write(_format.A);

					_stream.Write(_header.rsv2);
					_stream.Write(_header.rsv3);
					_stream.Write(_header.rsv4);
					_stream.Write(_header.rsv5);
					_stream.Write(_header.rsv6);

					foreach (Bitmap _surface in _mipMaps)
					{
						BitmapData _bits = _surface.LockBits(new Rectangle(0, 0, _surface.Width, _surface.Height), ImageLockMode.ReadOnly, System.Drawing.Imaging.PixelFormat.Format32bppArgb);
						IntPtr _bitPtr = _bits.Scan0;
						int _stride = _bits.Stride; // Not dividing by 4 this time because we're working with a byte array for the BinaryWriter's sake.
						byte[] _pixels = new byte[_stride * _bits.Height];
						System.Runtime.InteropServices.Marshal.Copy(_bitPtr, _pixels, 0, _stride * _bits.Height);
						_surface.UnlockBits(_bits);

						int _a, _r, _g, _b, _y, _x, _xy;

						switch (Format)
						{
							case CMP.A1R5G5B5:
								switch (_bits.PixelFormat)
								{
									case System.Drawing.Imaging.PixelFormat.Format24bppRgb: // R8G8B8 -> A1R5G5B5
										_a = 0x8000;
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = (_pixels[_xy++] + 4) * 31 / 255;
												_g = (_pixels[_xy++] + 4) * 31 / 255;
												_r = (_pixels[_xy++] + 4) * 31 / 255;

												_stream.Write((ushort)(_a | _r << 10 | _g << 5 | _b));
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppArgb: // A8R8G8B8 -> A1R5G5B5
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = (_pixels[_xy++] + 4) * 31 / 255;
												_g = (_pixels[_xy++] + 4) * 31 / 255;
												_r = (_pixels[_xy++] + 4) * 31 / 255;
												_a = (_pixels[_xy++] & 0x80) << 8;

												_stream.Write((ushort)(_a | _r << 10 | _g << 5 | _b));
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppRgb: // X8R8G8B8 -> A1R5G5B5
										_a = 0x8000;

										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = (_pixels[_xy++] + 4) * 31 / 255;
												_g = (_pixels[_xy++] + 4) * 31 / 255;
												_r = (_pixels[_xy++] + 4) * 31 / 255;
												_xy++;

												_stream.Write((ushort)(_a | _r << 10 | _g << 5 | _b));
											}
										}
										break;
								}
								break;
							case CMP.R5G6B5:
								switch (_bits.PixelFormat)
								{
									case System.Drawing.Imaging.PixelFormat.Format24bppRgb: // R8G8B8 -> R5G6B5
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = (_pixels[_xy++] + 4) * 31 / 255;
												_g = (_pixels[_xy++] + 2) * 63 / 255;
												_r = (_pixels[_xy++] + 4) * 31 / 255;

												_stream.Write((ushort)(_r << 11 | _g << 5 | _b));
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppArgb: // A8R8G8B8 -> R5G6B5
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{

												_b = _pixels[_xy++];
												_g = _pixels[_xy++];
												_r = _pixels[_xy++];

												if ((_pixels[_xy++] & 0x80) == 0)
												{
													_stream.Write((ushort)0);
												}
												else
												{
													_b = (_b + 4) * 31 / 255;
													_g = (_g + 2) * 63 / 255;
													_r = (_r + 4) * 31 / 255;

													_stream.Write((ushort)(_r << 11 | _g << 5 | _b));
												}
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppRgb: // X8R8G8B8 -> R5G6B5
										_a = 0x8000;

										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = (_pixels[_xy++] + 4) * 31 / 255;
												_g = (_pixels[_xy++] + 2) * 63 / 255;
												_r = (_pixels[_xy++] + 4) * 31 / 255;

												_xy++;

												_stream.Write((ushort)(_a | _r << 11 | _g << 5 | _b));
											}
										}
										break;
								}
								break;
							case CMP.RGB24:
								switch (_bits.PixelFormat)
								{
									case System.Drawing.Imaging.PixelFormat.Format24bppRgb: // R8G8B8
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppArgb: // A8R8G8B8 -> R8G8B8
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = _pixels[_xy++];
												_g = _pixels[_xy++];
												_r = _pixels[_xy++];

												if ((_pixels[_xy++] & 0x80) == 0)
												{
													_stream.Write((byte)0);
													_stream.Write((short)0);
												}
												else
												{
													_stream.Write((byte)_b);
													_stream.Write((byte)_g);
													_stream.Write((byte)_r);
												}
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppRgb: // X8R8G8B8 -> R8G8B8
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_b = _pixels[_xy++];
												_g = _pixels[_xy++];
												_r = _pixels[_xy++];
												_xy++;

												_stream.Write((byte)_b);
												_stream.Write((byte)_g);
												_stream.Write((byte)_r);
											}
										}
										break;
								}
								break;
							case CMP.RGB32:
								switch (_bits.PixelFormat)
								{
									case System.Drawing.Imaging.PixelFormat.Format24bppRgb: // R8G8B8 -> A8R8G8B8
										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
												_stream.Write((byte)0xFF);
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppArgb: // A8R8G8B8
										if ((_stride == (_surface.Width * 4)) && (_bits.Stride > 0))
										{
											// Cohesive block of pixel data, top to bottom. No need to go row by row.

											_stream.Write(_pixels);
										}
										else
										{
											for (_y = 0; _y < _surface.Height; _y++)
											{
												// if Stride < 0, image is stored from the bottom up, so we have to invert our _y
												int _xy1 = ((_bits.Stride < 0) ? (_surface.Height - _y) : _y) * _stride;

												_stream.Write(_pixels, _xy1, _stride);
											}
										}
										break;
									case System.Drawing.Imaging.PixelFormat.Format32bppRgb: // X8R8G8B8 -> A8R8G8B8
										_a = 0xFF << 24;

										for (_y = 0; _y < _surface.Height; _y++)
										{
											_xy = _y * _bits.Stride;

											for (_x = 0; _x < _surface.Width; _x++)
											{
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
												_stream.Write(_pixels[_xy++]);
												_stream.Write((byte)0xFF);
												_xy++;
											}
										}
										break;
								}
								break;
						}
					}
				}
			}
			catch
			{
				Stream.Close();

				return false;
			}

			Stream.Close();

			return true;
		}*/
	}

	public struct PIXFMT
	{
		public uint size;
		public uint flags;
		public uint _4CC;
		public uint RGBBC;
		public uint R;
		public uint G;
		public uint B;
		public uint A;
	}

	public struct HEAD
	{
		public int size;
		public int flags;
		public int h;
		public int w;
		public int PoLS;
		public int depth;
		public int mipmapc;
		public int[] rsvrd;
		public int rsv2;
		public int rsv3;
		public int rsv4;
		public int rsv5;
		public int rsv6;
	}

	#region DX10 - Not currently implemented.

	public struct HEAD10
	{
		public uint dxgiFormat;
		public uint resourceDimension;
		public uint miscFlag;
		public uint arraySize;
		public uint reserved;
	}

	#endregion
}
