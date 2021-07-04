
//
//  Copyright (c) 2009, Rebex CR s.r.o. www.rebex.net, 
//  All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this file for any
//  purpose with or without fee is hereby granted
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
using System;
using System.Text;
using System.IO;

namespace Rebex.IO.Compression
{
	/// <summary>
	/// Specifies whether to perform compression or decompression.
	/// </summary>
	public enum CompressionMode
	{
		/// <summary>
		/// Decompression.
		/// </summary>
		Decompress = 0,

		/// <summary>
		/// Compression.
		/// </summary>
		Compress = 1,
	}

	/// <summary>
	/// Provides a writable stream that uses ZLIB algorithm to either compresses or decompresses data written to it
	/// and saves the resulting data blocks into an underlying stream. Unlike similar class present in .NET Framework 2.0,
	/// this one actually makes it possible to use Flush when compressing data to make sure all data written to the stream
	/// have been written into the underlying stream as well.
	/// </summary>
	public class ZlibOutputStream : Stream
	{
		private readonly Stream _output;
		private readonly bool _compress;
		private readonly ZStream _zstream;
		
		private readonly byte[] _block;

		/// <summary>
		/// Creates a new instance of <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="output">Underlying stream that will receive the processed data written to the <see cref="ZlibOutputStream"/> instance.</param>
		/// <param name="compress">True to compress, false to decompress data written to the stream.</param>
		/// <param name="level">Compression level. Only used when compressing data.</param>
		public ZlibOutputStream(Stream output, bool compress, int level)
			: this(output, compress ? CompressionMode.Compress : CompressionMode.Decompress, level)
		{
		}

		/// <summary>
		/// Creates a new instance of <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="output">Underlying stream that will receive the processed data written to the <see cref="ZlibOutputStream"/> instance.</param>
		/// <param name="mode">Specifies whether to compress or decompress data written to the stream.</param>
		public ZlibOutputStream(Stream output, CompressionMode mode)
			: this(output, mode, 5)
		{
		}

		/// <summary>
		/// Creates a new instance of <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="output">Underlying stream that will receive the processed data written to the <see cref="ZlibOutputStream"/> instance.</param>
		/// <param name="mode">Specifies whether to compress or decompress data written to the stream.</param>
		/// <param name="level">Compresion level. Only used when compressing data.</param>
		public ZlibOutputStream(Stream output, CompressionMode mode, int level)
		{
			if (output == null)
				throw new ArgumentNullException("input");

			level = Math.Max(0, Math.Min(9, level));

			_block = new byte[0x1000];
			_output = output;
			_compress = mode == CompressionMode.Compress;
			_zstream = new ZStream();
			if (_compress)
				_zstream.deflateInit(level, false);
			else
				_zstream.inflateInit();
		}

		/// <summary>
		/// Writes a sequence of bytes into the current stream. The sequence will be compressed or decompressed and the result written
		/// into the underlying stream.
		/// </summary>
		/// <param name="buffer">An array of bytes. This method writes count bytes from buffer to the current stream.</param>
		/// <param name="offset">The zero-based byte offset in buffer at which to begin writing bytes to the current stream.</param>
		/// <param name="count">The number of bytes to be written to the current stream.</param>
		public override void Write(byte[] buffer, int offset, int count)
		{
			if (buffer == null)
				throw new ArgumentNullException("buffer");

			if (offset < 0 || offset > buffer.Length)
				throw new ArgumentOutOfRangeException("offset", offset, "Offset is outside the bounds of an array.");
//#elif !DOTNET11
//				throw new ArgumentOutOfRangeException("offset", "Offset is outside the bounds of an array.");

			if (count < 0 || (offset + count) > buffer.Length)
				throw new ArgumentException("Count is outside the bounds of an array.", "count");

			if (count == 0)
				return;

			WriteInternal(buffer, offset, count, JZlib.Z_NO_FLUSH);
		}

		/// <summary>
		/// Causes any buffered data to be written to the underlying stream.
		/// </summary>
		public override void Flush()
		{
			if (_compress)
			{
				WriteInternal(_block, 0, 0, JZlib.Z_PARTIAL_FLUSH);
			}
		}

		/// <summary>
		/// Closes the current stream and the underlying stream.
		/// </summary>
		public override void Close()
		{
			if (_compress)
			{
				WriteInternal(_block, 0, 0, JZlib.Z_FINISH);
			}

			base.Close();
			_output.Close();
		}

		private void WriteInternal(byte[] buffer, int offset, int count, int flush)
		{
			_zstream.next_in = buffer;
			_zstream.next_in_index = offset;
			_zstream.avail_in = count;

			while (true)
			{
				_zstream.next_out = _block;
				_zstream.next_out_index = 0;
				_zstream.avail_out = _block.Length;

				int err;
				if (_compress)
					err = _zstream.deflate(flush);
				else
					err = _zstream.inflate(flush);

				if (err != JZlib.Z_OK && (flush == JZlib.Z_FINISH && err != JZlib.Z_STREAM_END))
					throw new InvalidOperationException(string.Format("Error while {0}flating - {1}.", (_compress ? "de" : "in"), _zstream.msg));

				_output.Write(_block, 0, _block.Length - _zstream.avail_out);

				if (_zstream.avail_out == 0)
					continue;

				if (_zstream.avail_in == 0)
					break;
			}
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports reading.
		/// </summary>
		/// <value>False because this stream does not support reading.</value>
		public override bool CanRead
		{
			get { return false; }
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports seeking.
		/// </summary>
		/// <value>False because this stream does not support seeking.</value>
		public override bool CanSeek
		{
			get { return false; }
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports writing.
		/// </summary>
		/// <value>True because this stream does support writing.</value>
		public override bool CanWrite
		{
			get { return true; }
		}

		/// <summary>
		/// This property is not supported by the <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <value>Length of the stream in bytes.</value>
		public override long Length
		{
			get { throw new NotSupportedException(); }
		}

		/// <summary>
		/// This property is not supported by the <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <value>The current position within the stream.</value>
		public override long Position
		{
			get { throw new NotSupportedException(); }
			set { throw new NotSupportedException(); }
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="buffer">An array of bytes. This method reads count bytes from buffer to the current stream.</param>
		/// <param name="offset">The zero-based byte offset in buffer at which to begin writing bytes to the current stream.</param>
		/// <param name="count">The number of bytes to be written to the current stream.</param>
		/// <returns>The total number of bytes read into the buffer.</returns>
		public override int Read(byte[] buffer, int offset, int count)
		{
			throw new NotSupportedException();
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="offset">A byte offset relative to the origin parameter.</param>
		/// <param name="origin">A value of type System.IO.SeekOrigin indicating the reference point used to obtain the new position.</param>
		/// <remarks>The new position within the current stream.</remarks>
		public override long Seek(long offset, SeekOrigin origin)
		{
			throw new NotSupportedException();
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibOutputStream"/> class.
		/// </summary>
		/// <param name="value">The desired length of the current stream in bytes.</param>
		public override void SetLength(long value)
		{
			throw new NotSupportedException();
		}
	}

	/// <summary>
	/// Provides a readable stream that uses ZLIB algorithm to either compresses or decompresses data read from an underlying stream.
	/// </summary>
	public class ZlibInputStream : Stream
	{
		private readonly Stream _input;
		private readonly bool _compress;
		private readonly ZStream _zstream;

		private readonly byte[] _buffer;
		private bool _inputEnded;
		private bool _outputEnded;

		/// <summary>
		/// Creates a new instance of <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="input">Underlying stream from which to read the data to process.</param>
		/// <param name="compress">True to compress, false to decompress data read from the stream.</param>
		/// <param name="level">Compression level. Only used when compressing data.</param>
		public ZlibInputStream(Stream input, bool compress, int level)
			: this(input, compress ? CompressionMode.Compress : CompressionMode.Decompress, level)
		{
		}

		/// <summary>
		/// Creates a new instance of <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="input">Underlying stream from which to read the data to process.</param>
		/// <param name="mode">Specifies whether to compress or decompress data read from the stream.</param>
		public ZlibInputStream(Stream input, CompressionMode mode)
			: this(input, mode, 5)
		{
		}

		/// <summary>
		/// Creates a new instance of <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="input">Underlying stream from which to read the data to process.</param>
		/// <param name="mode">Specifies whether to compress or decompress data read from the stream.</param>
		/// <param name="level">Compression level. Only used when compressing data.</param>
		public ZlibInputStream(Stream input, CompressionMode mode, int level)
		{
			if (input == null)
				throw new ArgumentNullException("input");

			level = Math.Max(0, Math.Min(9, level));

			_buffer = new byte[0x1000];
			_input = input;
			_compress = mode == CompressionMode.Compress;
			_zstream = new ZStream();
			if (_compress)
				_zstream.deflateInit(level, false);
			else
				_zstream.inflateInit();
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="buffer">An array of bytes. This method writes count bytes from buffer to the current stream.</param>
		/// <param name="offset">The zero-based byte offset in buffer at which to begin writing bytes to the current stream.</param>
		/// <param name="count">The number of bytes to be written to the current stream.</param>
		public override void Write(byte[] buffer, int offset, int count)
		{
			throw new NotSupportedException();
		}

		/// <summary>
		/// This <see cref="ZlibInputStream"/> class implementation of this method does nothing.
		/// </summary>
		public override void Flush()
		{
		}

		/// <summary>
		/// Reads data from the underlying stream, compressing or decompressing them during the process.
		/// </summary>
		/// <param name="buffer">An array of bytes. This method reads count bytes from the underlying stream and copies them into the buffer.</param>
		/// <param name="offset">The zero-based byte offset in buffer to which to copy bytes read from the current stream.</param>
		/// <param name="count">The maximum number of bytes to be read from the current stream.</param>
		/// <returns>
		/// The total number of bytes read into the buffer. This can be less than the number of bytes requested
		/// if that many bytes are not currently available, or zero (0) if the end of the stream has been reached.
		/// </returns>
		public override int Read(byte[] buffer, int offset, int count)
		{
			if (buffer == null)
				throw new ArgumentNullException("buffer");

			if (offset < 0 || offset > buffer.Length)
				throw new ArgumentOutOfRangeException("offset", offset, "Offset is outside the bounds of an array.");
//#elif !DOTNET11
//				throw new ArgumentOutOfRangeException("offset", "Offset is outside the bounds of an array.");

			if (count < 0 || (offset + count) > buffer.Length)
				throw new ArgumentException("Count is outside the bounds of an array.", "count");

			if (_outputEnded || count == 0)
				return 0;

			_zstream.next_out = buffer;
			_zstream.next_out_index = offset;
			_zstream.avail_out = count;
			while (_zstream.avail_out > 0)
			{
				if (_zstream.avail_in == 0 && !_inputEnded)
				{
					_zstream.next_in = _buffer;
					_zstream.next_in_index = 0;
					_zstream.avail_in = _input.Read(_buffer, 0, _buffer.Length);
					if (_zstream.avail_in == 0)
						_inputEnded = true;
				}

				int flush;
				if (_inputEnded)
					flush = JZlib.Z_FINISH;
				else
					flush = JZlib.Z_NO_FLUSH;

				int err;
				if (_compress)
					err = _zstream.deflate(flush);
				else
					err = _zstream.inflate(flush);

				switch (err)
				{
					case JZlib.Z_BUF_ERROR:
						if (_inputEnded)
							break;
						goto default;
					case JZlib.Z_OK:
						break;
					case JZlib.Z_STREAM_END:
						break;
					default:
						throw new InvalidOperationException(string.Format("Error while {0}flating - {1}.", (_compress ? "de" : "in"), _zstream.msg));
				}

				if (err != JZlib.Z_OK)
					break;
			}

			count -= _zstream.avail_out;
			if (count == 0)
				_outputEnded = true;

			return count;
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports reading.
		/// </summary>
		/// <value>True because this stream does support reading.</value>
		public override bool CanRead
		{
			get { return true; }
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports seeking.
		/// </summary>
		/// <value>False because this stream does not support seeking.</value>
		public override bool CanSeek
		{
			get { return false; }
		}

		/// <summary>
		/// Gets a value indicating whether the current stream supports writing.
		/// </summary>
		/// <value>False because this stream does not support writing.</value>
		public override bool CanWrite
		{
			get { return false; }
		}

		/// <summary>
		/// This property is not supported by the <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <value>Length of the stream in bytes.</value>
		public override long Length
		{
			get { throw new NotSupportedException(); }
		}

		/// <summary>
		/// This property is not supported by the <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <value>The current position within the stream.</value>
		public override long Position
		{
			get { throw new NotSupportedException(); }
			set { throw new NotSupportedException(); }
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="offset">A byte offset relative to the origin parameter.</param>
		/// <param name="origin">A value of type System.IO.SeekOrigin indicating the reference point used to obtain the new position.</param>
		/// <remarks>The new position within the current stream.</remarks>
		public override long Seek(long offset, SeekOrigin origin)
		{
			throw new NotSupportedException();
		}

		/// <summary>
		/// This method is not supported by the <see cref="ZlibInputStream"/> class.
		/// </summary>
		/// <param name="value">The desired length of the current stream in bytes.</param>
		public override void SetLength(long value)
		{
			throw new NotSupportedException();
		}
	}

}
