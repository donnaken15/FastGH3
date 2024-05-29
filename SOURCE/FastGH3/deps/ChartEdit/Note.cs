using System;
using System.Text.RegularExpressions;

namespace ChartEdit
{
	public class Note
	{
		public Note()
		{
		}

		public Note(NoteProp noteProp)
		{
			this.Type = NoteType.Regular;
			this.IsANote = noteProp.IsNote;
			this.FlipsHOPO = noteProp.FlipsHOPO;
			this.ForcesHOPO = noteProp.ForcesHOPO;
			this.ForcesStrum = noteProp.ForcesStrum;
			this.ForcesTapping = noteProp.ForcesTapping;
			this.PointValue = noteProp.PointValue;
			this.Fret = noteProp.Fret;
		}

		public int LengthMilliseconds(OffsetTransformer ot)
		{
			return (int)Math.Round(1000.0 * (double)(this.TimeEndOffset(ot) - this.TimeOffset(ot)));
		}

		public int OffsetMilliseconds(OffsetTransformer ot)
		{
			return (int)Math.Round(1000.0 * (double)this.TimeOffset(ot));
		}

		public static Note Parse(string entry)
		{
			Match match = Note.NoteRegex.Match(entry);
			Note note = new Note();
			Note result;
			if (!match.Success)
			{
				match = Note.NoteEventRegex.Match(entry);
				if (!match.Success)
				{
					result = null;
				}
				else
				{
					int offset = int.Parse(match.Groups["offset"].Value.Trim());
					string eventName = match.Groups["name"].Value.Trim();
					note.Offset = offset;
					note.Type = NoteType.Event;
					note.EventName = eventName;
					result = note;
				}
			}
			else
			{
				int offset2 = int.Parse(match.Groups["offset"].Value.Trim());
				string text = match.Groups["type"].Value.Trim();
				int num = int.Parse(match.Groups["fret"].Value.Trim());
				int length = int.Parse(match.Groups["length"].Value.Trim());
				note.Offset = offset2;
				string text2 = text;
				if (text2 != null)
				{
					if (!(text2 == "N"))
					{
						if (text2 == "S")
						{
							note.Type = NoteType.Special;
							note.SpecialFlag = num;
						}
					}
					else
					{
						note.Type = NoteType.Regular;
						note.Fret = num;
					}
				}
				note.Length = length;
				result = note;
			}
			return result;
		}

		public float TimeEndOffset(OffsetTransformer ot)
		{
			return ot.GetTime(this.OffsetEnd);
		}

		public float TimeOffset(OffsetTransformer ot)
		{
			return ot.GetTime(this.Offset);
		}

		public bool ArmoredNote { get; set; }

		public string EventName { get; set; }

		public bool FlipsHOPO { get; set; }

		public bool ForcesHOPO { get; set; }

		public bool ForcesStrum { get; set; }

		public bool ForcesTapping { get; set; }

		public int Fret { get; set; }

		public bool IsANote { get; set; }

		public bool IsArmored { get; set; }

		public bool IsChord { get; set; }

		public bool IsHopo { get; set; }

		public bool IsInSlide { get; set; }

		public bool IsInSP { get; set; }

		public bool IsTapping { get; set; }

		public int Length { get; set; }

		public int Mult { get; set; }

		public int Offset { get; set; }

		public int OffsetEnd
		{
			get
			{
				return this.Offset + this.Length;
			}
			set
			{
				this.Length = value - this.Offset;
			}
		}

		public int PointValue { get; set; }

        public int SpecialFlag { get; set; }

		public int TickValue { get; set; }

		public NoteType Type { get; set; }

		private static readonly Regex NoteEventRegex = new Regex("(?<offset>\\d+)\\s*\\=\\s*E\\s*(?<name>.*)", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);

		private static readonly Regex NoteRegex = new Regex("(?<offset>\\d+)\\s*\\=\\s*(?<type>.*?)\\s*(?<fret>\\d+)\\s*(?<length>\\d+)", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);
	}
}
