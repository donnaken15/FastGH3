using System;
using System.Collections.Generic;
using System.Text;

namespace ChartEdit
{
	internal class QbcNoteTrack : List<QbcNote>
	{
		public QbcNoteTrack(NoteTrack track, OffsetTransformer ot)
		{
			this._ot = ot;
			foreach (Note note in track)
			{
				if (note.Type == NoteType.Regular)
				{
					this.AddNote(note);
				}
			}
		}

		public void AddNote(Note note)
		{
			if (note.OffsetMilliseconds(this._ot) != this.LastOffset())
			{
				QbcNote item = new QbcNote
				{
					Offset = note.OffsetMilliseconds(this._ot)
				};
				base.Add(item);
			}
			int num = 1 << note.Fret;
			int num2 = note.LengthMilliseconds(this._ot);
			if (base[base.Count - 1].Length < num2)
			{
				base[base.Count - 1].Length = num2;
			}
			QbcNote qbcNote = base[base.Count - 1];
			qbcNote.FretMask |= num;
		}

		/*public StringBuilder AsString()
		{
			StringBuilder stringBuilder = new StringBuilder(base.Count * 11);
			foreach (QbcNote qbcNote in this)
			{
				stringBuilder.Append(qbcNote.Offset);
				stringBuilder.Append("\r\n");
				stringBuilder.Append(qbcNote.Length);
				stringBuilder.Append("\r\n");
				stringBuilder.Append(qbcNote.FretMask);
				stringBuilder.Append("\r\n");
			}
			return stringBuilder;
		}*/

		private int LastOffset()
		{
			int result;
			if (base.Count == 0)
			{
				result = -1;
			}
			else
			{
				result = base[base.Count - 1].Offset;
			}
			return result;
		}

		private OffsetTransformer _ot;
	}
}
