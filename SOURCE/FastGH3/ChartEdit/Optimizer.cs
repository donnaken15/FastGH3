
using System.Linq;

namespace ChartEdit
{
    public class Optimizer
	{
		public Optimizer(NoteTrack nt)
		{
			foreach (Note note in nt)
			{
				if (note.IsANote)
				{
					this.addNote(note);
				}
			}
		}

		private void addNote(Note n)
		{
			if (this.notes.Count<Note>() == 0)
			{
				this.count++;
				Note note = new Note();
				this.copyNote(note, n);
				this.notes.Add(note);
			}
			else if (n.Offset == this.notes.Last<Note>().Offset)
			{
				Note note2 = this.notes.Last<Note>();
				note2.PointValue += n.PointValue * this.mult(this.count);
			}
			else
			{
				this.count++;
				Note note3 = new Note();
				this.copyNote(note3, n);
				note3.PointValue *= this.mult(this.count);
				note3.TickValue *= this.mult(this.count);
				this.notes.Add(note3);
			}
		}

        private int calculateBaseScore()
		{
			int num = 0;
			foreach (Note note in this.notes)
			{
				num += note.PointValue;
				num += note.TickValue;
			}
			return num;
		}

		private void copyNote(Note newnote, Note n)
		{
			newnote.Length = n.Length;
			newnote.Offset = n.Offset;
			newnote.OffsetEnd = n.OffsetEnd;
			newnote.PointValue = n.PointValue;
			newnote.TickValue = 25 * n.Length / 192;
		}

		private int mult(int c)
		{
			int result;
			if (c >= 30)
			{
				result = 4;
			}
			else if (c >= 20)
			{
				result = 3;
			}
			else if (c >= 10)
			{
				result = 2;
			}
			else
			{
				result = 1;
			}
			return result;
		}

		private int count = 0;

		private NoteTrack notes = new NoteTrack();

		//private NoteTrack spNotes;
	}
}
