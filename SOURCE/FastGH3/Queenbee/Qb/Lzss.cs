using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Nanook.QueenBee.Parser
{
    internal class Lzss
    {
        public Lzss()
        {
            _text_buf = new byte[N + F - 1];
            _lson = new int[N + 1];
            _rson = new int[N + 257];
            _dad = new int[N + 1];

        }


        public byte[] Decompress(byte[] compressed)
        {
            int size;
            byte[] ret;
            using (MemoryStream input = new MemoryStream(compressed))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    size = Decompress(input, ms);
                    ms.Seek(0, SeekOrigin.Begin);
                    ret = new byte[size];
                    ms.Read(ret, 0, size);
                    StringBuilder sb = new StringBuilder(Encoding.UTF8.GetString(ret));
                }
            }
            return ret;
        }

        public int Decompress(Stream input, Stream output)
        {
            int i, j, k, r, c;
            uint flags;

            byte[] text_buf = new byte[N + F - 1];

            /* Fill buffer */
            for (i = 0; i < N - F; i++)
                text_buf[i] = 0x20;

            r = N - F;
            flags = 0;

            int decompressedSize = 0;
            while (input.Position < input.Length)
            {
                /* Get the "flags" for the next 8 bytes */
                if (((flags >>= 1) & 256) == 0)
                    flags = (uint)((input.ReadByte() & 0xFF) | 0xFF00);

                if ((flags & 1) == 1) /* Copy character directly */
                {
                    /* Get character */
                    c = (int)(input.ReadByte() & 0xFF);

                    /* Add character */
                    output.WriteByte((byte)c);
                    decompressedSize++;

                    /* Update buffer */
                    text_buf[r++] = (byte)c; /* Set buffer character */
                    r &= (N - 1); /* Ensure it's inside the limits */
                }
                else /* Copy a text from the buffer */
                {
                    /* Get buffer variables */
                    i = (int)(input.ReadByte() & 0xFF);
                    j = (int)(input.ReadByte() & 0xFF);

                    /* Decode variables */
                    i |= ((j & 0xF0) << 4); /* Position in the buffer (12 bits) */
                    j = (j & 0x0F) + THRESHOLD; /* Number of bytes (4 bits + threshold) */

                    /* Copy bytes */
                    for (k = 0; k <= j; k++)
                    {
                        /* Get character */
                        c = text_buf[(i + k) & (N - 1)];

                        /* Add character */
                        output.WriteByte((byte)c);
                        decompressedSize++;

                        /* Update buffer */
                        text_buf[r++] = (byte)c; /* Set buffer character */
                        r &= (N - 1); /* Ensure it's inside the limits */
                    }
                }
            }
            return decompressedSize;
        }

        public byte[] Compress(byte[] data)
        {
            int size;
            byte[] ret;
            using (MemoryStream input = new MemoryStream(data))
            {
                using (MemoryStream output = new MemoryStream())
                {
                    size = Compress(input, output);
                    output.Seek(0, SeekOrigin.Begin);
                    ret = new byte[size];
                    output.Read(ret, 0, size);
                }
            }
            return ret;
        }

        public int Compress(Stream input, Stream output)
        {
            int compressedSize = 0;

            /* Compression managers, buffers and trees */
            int i, len, r, s, last_match_length, code_buf_ptr;
            byte c;
            byte[] code_buf = new byte[17];
            byte mask;

            /* Initialize trees */
            InitTree();

            /* code_buf[1..16] saves eight units of code, and
             * code_buf[0] works as eight flags, "1" representing that the unit
	         * is an unencoded letter (1 byte), "0" a position-and-length pair
	         * (2 bytes).  Thus, eight units require at most 16 bytes of code. */
            code_buf[0] = 0;

            /* mask contains the LZSS flag for the "unencoded" bytes.
             * It's set to 1 initialy, and shifted one position to the right
             * in every iteratorion of the compression algorithm. Since it's a
             * 8-bit value, it will be 0 after 8 shiftings, in that case, the code
             * buffer will be written, and the mask set to 1 again */
            code_buf_ptr = mask = 1;
            s = 0;
            r = N - F;

            /* Clear the buffer with any
             * character that will appear often */
            for (i = s; i < r; i++)
                _text_buf[i] = 0x20;

            /* Read initial bytes */
            for (len = 0; len < F; len++)
            {
                /* Check if it's EOF */
                if (input.Position == input.Length)
                    break;

                /* Get byte */
                c = (byte)(input.ReadByte() & 0xFF);

                /* Read F bytes into the last F bytes of the buffer */
                _text_buf[r + len] = c;
            }

            /* Text of size 0? */
            if (len == 0)
                return 0;

            /* Insert the F strings, each of which begins with
             * one or more 'space' characters. Note the order in which these
             * strings are inserted. This way, degenerate trees will be less
             * likely to occur. */
            for (i = 1; i <= F; i++)
                InsertNode(r - i);

            /* Finally, insert the whole string just read. The
             * global variables match_length and match_position are set. */
            InsertNode(r);

            /* Compress the remaining part of the file */
            do
            {
                /* match_length may be spuriously long
                 * near the end of text. */
                if (_match_length > len)
                    _match_length = len;

                if (_match_length <= THRESHOLD) /* Not long enough match. Send one byte. */
                {
                    _match_length = 1;
                    code_buf[0] |= (byte)mask;  /* 'Send one byte' flag */
                    code_buf[code_buf_ptr++] = _text_buf[r];  /* Send uncoded. */
                }
                else /* Compression can be used */
                {
                    code_buf[code_buf_ptr++] = (byte)_match_position;
                    code_buf[code_buf_ptr++] = (byte)(((_match_position >> 4) & 0xF0) | (_match_length - (THRESHOLD + 1))); /* Send position and length pair. Note match_length > THRESHOLD. */
                }

                if ((mask <<= 1) == 0) /* Shift mask left one bit. */
                {
                    /* Time to send the bytes in the buffer to the file! */
                    for (i = 0; i < code_buf_ptr; i++)
                    {
                        /* Add byte */
                        output.WriteByte(code_buf[i]);
                        compressedSize++;
                    }

                    /* Reset values */
                    code_buf[0] = 0;
                    code_buf_ptr = mask = 1;
                }

                last_match_length = _match_length;

                for (i = 0; i < last_match_length; i++)
                {
                    /* Check if it's EOF */
                    if (input.Position == input.Length)
                        break;

                    /* Get byte */
                    c = (byte)(input.ReadByte() & 0xFF);

                    /* Delete old strings */
                    DeleteNode(s);

                    /* Read new bytes */
                    _text_buf[s] = (byte)c;

                    /* If the position is near the end of buffer,
                     * extend the buffer to make string comparison easier.*/
                    if (s < F - 1)
                        _text_buf[s + N] = (byte)c;

                    /* Since this is a ring buffer, increment the position modulo N. */
                    s = (s + 1) & (N - 1);
                    r = (r + 1) & (N - 1);

                    /* Register the string in text_buf[r..r+F-1] */
                    InsertNode(r);
                }

                /* After the end of text, no need to read, but buffer may not be empty */
                while (i++ < last_match_length)
                {
                    /* Delete old strings */
                    DeleteNode(s);

                    /* Since this is a ring buffer, increment the position modulo N. */
                    s = (s + 1) & (N - 1);
                    r = (r + 1) & (N - 1);

                    /* Register the string in text_buf[r..r+F-1] */
                    if (--len != 0)
                        InsertNode(r);
                }
            }
            while (len > 0);

            /* Write remaining bytes */
            if (code_buf_ptr > 1)
            {
                for (i = 0; i < code_buf_ptr; i++)
                {
                    /* Add byte */
                    output.WriteByte(code_buf[i]);
                    compressedSize++;
                }
            }

            return compressedSize;
        }

        private void InitTree()  /* initialize trees */
        {
            int i;

            /* For i = 0 to N - 1, rson[i] and lson[i] will be the right and
            left children of node i.  These nodes need not be initialized.
            Also, dad[i] is the parent of node i.  These are initialized to
            NIL (= N), which stands for 'not used.'
            For i = 0 to 255, rson[N + i + 1] is the root of the tree
            for strings that begin with character i.  These are initialized
            to NIL.  Note there are 256 trees. */

            for (i = N + 1; i <= N + 256; i++)
                _rson[i] = NIL;

            for (i = 0; i < N; i++)
                _dad[i] = NIL;
        }

        private void InsertNode(int r)
        {
            int i, p, cmp;
            int key;

            /* Inserts string of length F, text_buf[r..r+F-1], into one of the
            trees (text_buf[r]'th tree) and returns the longest-match position
            and length via the global variables match_position and match_length.
            If match_length = F, then removes the old node in favor of the new
            one, because the old one will be deleted sooner.
            Note r plays double role, as tree node and position in buffer. */

            cmp = 1;
            key = r;
            p = N + 1 + _text_buf[key];

            _rson[r] = _lson[r] = NIL;
            _match_length = 0;

            for (; ; )
            {
                if (cmp >= 0)
                {
                    if (_rson[p] != NIL)
                        p = _rson[p];
                    else
                    {
                        _rson[p] = r;
                        _dad[r] = p;
                        return;
                    }
                }
                else
                {
                    if (_lson[p] != NIL)
                        p = _lson[p];
                    else
                    {
                        _lson[p] = r;
                        _dad[r] = p;
                        return;
                    }
                }
                for (i = 1; i < F; i++)
                    if ((cmp = _text_buf[key + i] - _text_buf[p + i]) != 0)
                        break;

                if (i > _match_length)
                {
                    _match_position = p;
                    if ((_match_length = i) >= F)
                        break;
                }
            }

            _dad[r] = _dad[p];
            _lson[r] = _lson[p];
            _rson[r] = _rson[p];
            _dad[_lson[p]] = r;
            _dad[_rson[p]] = r;

            if (_rson[_dad[p]] == p)
                _rson[_dad[p]] = r;
            else
                _lson[_dad[p]] = r;

            /* Remove p */
            _dad[p] = NIL;
        }

        private void DeleteNode(int p)
        {
            int q;

            /* Not in tree */
            if (_dad[p] == NIL)
                return;

            if (_rson[p] == NIL)
                q = _lson[p];
            else if (_lson[p] == NIL)
                q = _rson[p];
            else
            {
                q = _lson[p];
                if (_rson[q] != NIL)
                {
                    do
                    {
                        q = _rson[q];
                    } while (_rson[q] != NIL);

                    _rson[_dad[q]] = _lson[q];
                    _dad[_lson[q]] = _dad[q];
                    _lson[q] = _lson[p];
                    _dad[_lson[p]] = q;
                }

                _rson[q] = _rson[p];
                _dad[_rson[p]] = q;
            }

            _dad[q] = _dad[p];

            if (_rson[_dad[p]] == p)
                _rson[_dad[p]] = q;
            else
                _lson[_dad[p]] = q;

            _dad[p] = NIL;
        }

        private byte[] _text_buf;
        private int _match_position;
        private int _match_length;
        private int[] _lson;
        private int[] _rson;
        private int[] _dad;

        private const int N = 4096;  /* Size of the ring buffer */
        private const int F = 18;  /* Upper limit for match_length (4 bits = 15 + threshold = 2) */
        private const int THRESHOLD = 2; /* Minimum to use buffer references instead of directly copying a character */
        private const int NIL = N; /* A "NULL" value, it can be N since the ring buffer can't reach that value */

    }
}
