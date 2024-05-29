using System.Collections.Generic;
using System.Linq;

namespace ChartEdit
{
    public class NoteTrack : List<Note>
	{
		public NoteTrack()
		{
			this.noteList = new List<List<Note>>();
			this.SpecialList = new List<Note>();
			this.EventList = new List<Note>();
		}
        
		public NoteTrack(string name)
		{
			this.noteList = new List<List<Note>>();
			this.SpecialList = new List<Note>();
			this.EventList = new List<Note>();
			this.Name = name;
			this.SetDetails(name);
		}
        
		public void AssignProperty(int fret)
		{
			bool isANote = true;
			bool flipsHOPO = false;
			bool forcesHOPO = false;
			bool forcesStrum = false;
			bool forcesTapping = false;
			int pointValue = 50;
			foreach (Note note in this)
			{
				if (note.Fret == fret)
				{
					note.IsANote = isANote;
					note.FlipsHOPO = flipsHOPO;
					note.ForcesHOPO = forcesHOPO;
					note.ForcesStrum = forcesStrum;
					note.ForcesTapping = forcesTapping;
					note.PointValue = pointValue;
				}
			}
		}
        
		public new int Count(int fret)
		{
			int result;
			if (fret > this.noteList.Count - 1)
			{
				result = 0;
			}
			else
			{
				result = this.noteList[fret].Count();
			}
			return result;
		}
        
		public void Evaluate(Chart chart)
		{
			this.SetHopoLogic();
			this.EvaluateNoteness();
			this.EvaluateChords();
			this.EvaluateHOPO(chart.Resolution / 3, 1, this.Count());
			this.EvaluateFlipping();
			this.EvaluateTapping();
			this.EvaluateSP();
		}
        
		public void Evaluate(Chart chart, int start, int start2, int end)
		{
			while (end < this.Count() - 1)
			{
				if (!base[end].IsChord)
				{
					break;
				}
				end++;
			}
			this.SetHopoLogic();
			this.EvaluateNoteness(start, end);
			this.EvaluateChords(start2, end);
			this.EvaluateHOPO(chart.Resolution / 3, start2, end);
			this.EvaluateFlipping(start, end);
			this.EvaluateTapping(start, end);
			this.EvaluateSP(start, end);
		}
        
		public void EvaluateChords()
		{
			this.EvaluateChords(1, this.Count());
		}
        
		public void EvaluateChords(int start, int end)
		{
			for (int i = start; i < end; i++)
			{
				if (base[i].IsANote)
				{
					for (int j = i - 1; j > 0; j--)
					{
						if (base[j].IsANote)
						{
							if (base[j].Offset == base[i].Offset)
							{
								base[i].IsChord = true;
								base[j].IsChord = true;
							}
							else
							{
								base[i].IsChord = false;
							}
							break;
						}
					}
				}
				else
				{
					base[i].IsChord = false;
				}
			}
		}
        
		public void EvaluateFlipping()
		{
			this.EvaluateFlipping(0, this.Count());
		}
        
		public void EvaluateFlipping(int start, int end)
		{
			for (int i = start; i < end; i++)
			{
				if (base[i].FlipsHOPO)
				{
					for (int j = i - 1; j > 0; j--)
					{
						if (base[j].Offset != base[i].Offset)
						{
							break;
						}
						base[j].IsHopo = !base[j].IsHopo;
					}
					for (int k = i + 1; k < this.Count(); k++)
					{
						if (base[k].Offset != base[i].Offset)
						{
							break;
						}
						base[k].IsHopo = !base[k].IsHopo;
					}
				}
				if (base[i].ForcesHOPO)
				{
					for (int l = i - 1; l > 0; l--)
					{
						if (base[l].Offset != base[i].Offset)
						{
							break;
						}
						base[l].IsHopo = true;
					}
					for (int m = i + 1; m < this.Count(); m++)
					{
						if (base[m].Offset != base[i].Offset)
						{
							break;
						}
						base[m].IsHopo = true;
					}
				}
				if (base[i].ForcesStrum)
				{
					for (int n = i - 1; n > 0; n--)
					{
						if (base[n].Offset != base[i].Offset)
						{
							break;
						}
						base[n].IsHopo = false;
					}
					for (int num = i + 1; num < this.Count(); num++)
					{
						if (base[num].Offset != base[i].Offset)
						{
							break;
						}
						base[num].IsHopo = false;
					}
				}
			}
		}

		public void EvaluateHOPO()
		{
			this.EvaluateHOPO(64, 1, this.Count());
		}

		public void EvaluateHOPO(int threshold, int start, int end)
		{
			for (int i = start; i < end; i++)
			{
				if (base[i].IsChord)
				{
					base[i].IsHopo = false;
				}
				else
				{
					int num = i - 1;
					while (!base[num].IsANote | base[num].Offset == base[i].Offset)
					{
						if (num == 0)
						{
							break;
						}
						num--;
					}
					if (base[i].Offset - base[num].Offset > threshold)
					{
						base[i].IsHopo = false;
					}
					else
					{
						string hopoLogic = this.HopoLogic;
						if (hopoLogic != null)
						{
							if (hopoLogic == "gh1" || hopoLogic == "gh2" || hopoLogic == "rockband" || hopoLogic == "rockband2")
							{
								int j = num;
								while (j > 0)
								{
									if (base[num].Offset == base[j].Offset)
									{
										if (base[i].Fret != base[j].Fret)
										{
											base[i].IsHopo = true;
											j--;
											continue;
										}
										base[i].IsHopo = false;
									}
									else
									{
										base[i].IsHopo = true;
									}
									break;
								}
								goto IL_201;
							}
							if (hopoLogic == "none")
							{
								base[i].IsHopo = false;
								goto IL_201;
							}
						}
						if (base[i].Fret != base[num].Fret || base[num].IsChord)
						{
							base[i].IsHopo = true;
						}
						else
						{
							base[i].IsHopo = false;
						}
					}
				}
				IL_201:;
			}
		}

		public void EvaluateNoteness()
		{
			this.EvaluateNoteness(0, this.Count());
		}

		public void EvaluateNoteness(int start, int end)
		{
			for (int i = start; i < end; i++)
			{
				if (base[i].Type != NoteType.Regular)
				{
					base[i].IsANote = false;
				}
			}
		}

		public void EvaluateSP()
		{
			int num = 0;
			List<int> list = new List<int>();
			int num2 = 0;
			for (int i = 0; i < this.Count(); i++)
			{
				if (base[i].Offset != num2)
				{
					list.Clear();
					num2 = base[i].Offset;
				}
				list.Add(i);
				if (base[i].Type == NoteType.Special & base[i].SpecialFlag == 2)
				{
					num = base[i].OffsetEnd;
					foreach (int index in list)
					{
						base[index].IsInSP = true;
					}
					list.Clear();
				}
				else if (base[i].Offset < num)
				{
					base[i].IsInSP = true;
				}
				else
				{
					base[i].IsInSP = false;
				}
			}
		}

		public void EvaluateSP(int start, int end)
		{
			int num = -1;
			for (int i = num + 1; i < this.SpecialList.Count(); i++)
			{
				if (this.SpecialList[i].SpecialFlag == 2 && this.SpecialList[i].OffsetEnd > base[start].Offset)
				{
					num = i;
					break;
				}
			}
			if (num == -1)
			{
				for (int j = start; j < end; j++)
				{
					base[j].IsInSP = false;
				}
			}
			else
			{
				for (int k = start; k < end; k++)
				{
					if (base[k].Offset >= this.SpecialList[num].Offset)
					{
						if (base[k].Offset < this.SpecialList[num].OffsetEnd)
						{
							base[k].IsInSP = true;
						}
						else
						{
							base[k].IsInSP = false;
							for (int l = num + 1; l < this.SpecialList.Count(); l++)
							{
								if (this.SpecialList[l].SpecialFlag == 2 && this.SpecialList[l].OffsetEnd > base[k].Offset)
								{
									num = l;
									break;
								}
							}
						}
					}
					else
					{
						base[k].IsInSP = false;
					}
				}
			}
		}

		public void EvaluateTapping()
		{
			this.EvaluateTapping(0, this.Count());
		}

		public void EvaluateTapping(int start, int end)
		{
			for (int i = start; i < end; i++)
			{
				if (base[i].ForcesTapping)
				{
					for (int j = i - 1; j > 0; j--)
					{
						if (base[j].Offset != base[i].Offset)
						{
							break;
						}
						base[j].IsTapping = true;
					}
					for (int k = i + 1; k < this.Count(); k++)
					{
						if (base[k].Offset != base[i].Offset)
						{
							break;
						}
						base[k].IsTapping = true;
					}
				}
			}
		}

		public void FillNoteList(int fret)
		{
			while (this.HighestFret <= fret)
			{
				this.HighestFret++;
				this.noteList.Add(new List<Note>());
				this.noteList.Last().Clear();
			}
		}

		public void GenerateFretList()
		{
			this.noteList.Clear();
			this.SpecialList.Clear();
			this.EventList.Clear();
			this.HighestFret = this.highestFret() + 1;
			for (int i = 0; i < this.HighestFret; i++)
			{
				this.noteList.Add(new List<Note>());
			}
			foreach (Note note in this)
			{
				switch (note.Type)
				{
				case NoteType.Regular:
					this.noteList[note.Fret].Add(note);
					break;
				case NoteType.Special:
					this.SpecialList.Add(note);
					break;
				case NoteType.Event:
					this.EventList.Add(note);
					break;
				}
			}
		}

		private int highestFret()
		{
			int num = 0;
			foreach (Note note in this)
			{
				if (note.Fret > num)
				{
					num = note.Fret;
				}
			}
			return num;
		}

		public List<Note> NoteList(int fret)
		{
			List<Note> result;
			if (fret >= this.noteList.Count())
			{
				result = null;
			}
			else
			{
				result = this.noteList[fret];
			}
			return result;
		}

		private void SetDetails(string entry)
		{
			int num = 0;
			for (int i = 1; i < entry.Length; i++)
			{
				if (char.IsUpper(entry[i]))
				{
					num = i;
					break;
				}
			}
			this.Difficulty = entry.Substring(0, num);
			this.Instrument = entry.Substring(num, entry.Length - num);
		}

		public void SetHopoLogic()
		{
			this.HopoLogic = Globals.Instance.GameProperties[0].TrackProperties[this.stripDifficulty(this.Name)].HopoLogic;
		}

		public void SetProperties(bool isANote, bool flipsHOPO, bool forcesHOPO, bool forcesStrum, int pointValue)
		{
			foreach (Note note in this)
			{
				note.IsANote = isANote;
				note.FlipsHOPO = flipsHOPO;
				note.ForcesHOPO = forcesHOPO;
				note.ForcesStrum = forcesStrum;
				note.PointValue = pointValue;
			}
		}

		private string stripDifficulty(string entry)
		{
			int startIndex = 0;
			for (int i = 1; i < entry.Length; i++)
			{
				if (char.IsUpper(entry[i]))
				{
					startIndex = i;
					break;
				}
			}
			return entry.Substring(startIndex);
		}

		public string Difficulty { get; set; }

		public string Instrument { get; set; }

		public Note this[int index, int fret]
		{
			get
			{
				Note result;
				if (fret > this.HighestFret - 1)
				{
					result = null;
				}
				else if (this.noteList[fret].Count() <= index)
				{
					result = null;
				}
				else
				{
					result = this.noteList[fret][index];
				}
				return result;
			}
		}

		public string Name { get; set; }

		//private OffsetTransformer _ot;

		public List<Note> EventList;

		public int HighestFret;

		public string HopoLogic;

		public List<List<Note>> noteList;

		public List<Note> SpecialList;
	}
}
