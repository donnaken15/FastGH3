using System;
using System.Collections.Generic;
using System.Linq;

namespace ChartEdit
{
	public class OffsetTransformer
	{
		public OffsetTransformer(Chart chart)
		{
			this.chart = chart;
			this.BPM.Clear();
			this.Offset.Clear();
			this.timeOffset.Clear();
			foreach (SyncTrackEntry syncTrackEntry in chart.SyncTrack)
			{
				if (syncTrackEntry.BPM != 0)
				{
					this.BPM.Add((float)syncTrackEntry.BPM / 1000f);
					this.Offset.Add(syncTrackEntry.Offset);
				}
			}
			this.CreateOffsets();
			this.songLength = this.GetTime(chart.LastIndex);
		}

		public void CreateOffsets()
		{
			this.timeOffset.Clear();
			this.timeOffset.Add(0f);
			for (int i = 0; i < this.Offset.Count - 1; i++)
			{
				this.timeOffset.Add(this.timeOffset[i] + (float)(this.Offset[i + 1] - this.Offset[i]) / (float)this.chart.Resolution / this.BPM[i] * 60f);
			}
		}

		public int GetOffset(float CrudeOffset)
		{
			return this.GetOffset(CrudeOffset, 0f);
		}

		public int GetOffset(float CrudeOffset, float extraSeconds)
		{
			float num = CrudeOffset + extraSeconds;
			int i;
			for (i = 0; i < this.Offset.Count; i++)
			{
				if (this.timeOffset[i] > num)
				{
					break;
				}
			}
			i--;
			if (i < 0)
			{
				i = 0;
			}
			return this.Offset[i] + (int)((num - this.timeOffset[i]) / 60f * this.BPM[i] * (float)this.chart.Resolution);
		}

		public float GetTime(int Offset)
		{
			int i;
			for (i = 0; i < this.Offset.Count; i++)
			{
				if (this.Offset[i] > Offset)
				{
					break;
				}
			}
			if (i > 0)
			{
				i--;
			}
			return this.timeOffset[i] + (float)(Offset - this.Offset[i]) / (float)this.chart.Resolution / this.BPM[i] * 60f;
		}

		public int nearNIndex(int Offset, List<Note> Notes)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int num = 0;
				int num2 = Notes.Count<Note>() - 1;
				switch (num2)
				{
				case -1:
				case 0:
					result = 0;
					break;
				case 1:
				{
					int num3 = Math.Abs(Notes[0].Offset - Offset);
					int num4 = Math.Abs(Notes[1].Offset - Offset);
					if (num3 >= num4)
					{
						result = 1;
					}
					else
					{
						result = 0;
					}
					break;
				}
				default:
				{
					int num5 = num2 / 2;
					while (Notes[num5].Offset != Offset)
					{
						num5 = (num + num2) / 2;
						if (Notes[num5].Offset > Offset)
						{
							num2 = num5;
						}
						else
						{
							num = num5;
						}
						if (num2 - num <= 1)
						{
							int num6 = Math.Abs(Notes[num5].Offset - Offset);
							int num7 = Math.Abs(Notes[num5 - 1].Offset - Offset);
							int num8 = Math.Abs(Notes[num5 + 1].Offset - Offset);
							if (num6 <= num7 && num6 <= num8)
							{
								return num5;
							}
							if (num7 <= num8)
							{
								return num5 - 1;
							}
							return num5 + 1;
						}
					}
					result = num5;
					break;
				}
				}
			}
			return result;
		}

		public int nearNIndex(int Offset, NoteTrack Notes)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int num = 0;
				int num2 = Notes.Count<Note>() - 1;
				switch (num2)
				{
				case -1:
				case 0:
					result = 0;
					break;
				case 1:
				{
					int num3 = Math.Abs(Notes[0].Offset - Offset);
					int num4 = Math.Abs(Notes[1].Offset - Offset);
					if (num3 >= num4)
					{
						result = 1;
					}
					else
					{
						result = 0;
					}
					break;
				}
				default:
				{
					int num5 = num2 / 2;
					while (Notes[num5].Offset != Offset)
					{
						num5 = (num + num2) / 2;
						if (Notes[num5].Offset > Offset)
						{
							num2 = num5;
						}
						else
						{
							num = num5;
						}
						if (num2 - num <= 1)
						{
							int num6 = Math.Abs(Notes[num5].Offset - Offset);
							int num7 = Math.Abs(Notes[num5 - 1].Offset - Offset);
							int num8 = Math.Abs(Notes[num5 + 1].Offset - Offset);
							if (num6 <= num7 && num6 <= num8)
							{
								return num5;
							}
							if (num7 <= num8)
							{
								return num5 - 1;
							}
							return num5 + 1;
						}
					}
					result = num5;
					break;
				}
				}
			}
			return result;
		}

		public int nearNIndex(int Offset, NoteTrack Notes, int fret)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int num = 0;
				int num2 = Notes.Count(fret) - 1;
				switch (num2)
				{
				case -1:
				case 0:
					result = 0;
					break;
				case 1:
				{
					int num3 = Math.Abs(Notes[0, fret].Offset - Offset);
					int num4 = Math.Abs(Notes[1, fret].Offset - Offset);
					if (num3 >= num4)
					{
						result = 1;
					}
					else
					{
						result = 0;
					}
					break;
				}
				default:
				{
					int num5 = num2 / 2;
					while (Notes[num5, fret].Offset != Offset)
					{
						num5 = (num + num2) / 2;
						if (Notes[num5, fret].Offset > Offset)
						{
							num2 = num5;
						}
						else
						{
							num = num5;
						}
						if (num2 - num <= 1)
						{
							int num6 = Math.Abs(Notes[num5].Offset - Offset);
							int num7 = Math.Abs(Notes[num5 - 1].Offset - Offset);
							int num8 = Math.Abs(Notes[num5 + 1].Offset - Offset);
							if (num6 <= num7 && num6 <= num8)
							{
								return num5;
							}
							if (num7 <= num8)
							{
								return num5 - 1;
							}
							return num5 + 1;
						}
					}
					result = num5;
					break;
				}
				}
			}
			return result;
		}

		public int nearNIndexEnd(int Offset, NoteTrack Notes)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int num = 0;
				int num2 = Notes.Count<Note>() - 1;
				switch (num2)
				{
				case -1:
				case 0:
					result = 0;
					break;
				case 1:
				{
					int num3 = Math.Abs(Notes[0].OffsetEnd - Offset);
					int num4 = Math.Abs(Notes[1].OffsetEnd - Offset);
					if (num3 >= num4)
					{
						result = 1;
					}
					else
					{
						result = 0;
					}
					break;
				}
				default:
				{
					int num5 = num2 / 2;
					while (Notes[num5].OffsetEnd != Offset)
					{
						num5 = (num + num2) / 2;
						if (Notes[num5].OffsetEnd > Offset)
						{
							num2 = num5;
						}
						else
						{
							num = num5;
						}
						if (num2 - num <= 1)
						{
							int num6 = Math.Abs(Notes[num5].OffsetEnd - Offset);
							int num7 = Math.Abs(Notes[num5 - 1].OffsetEnd - Offset);
							int num8 = Math.Abs(Notes[num5 + 1].OffsetEnd - Offset);
							if (num6 <= num7 && num6 <= num8)
							{
								return num5;
							}
							if (num7 <= num8)
							{
								return num5 - 1;
							}
							return num5 + 1;
						}
					}
					result = num5;
					break;
				}
				}
			}
			return result;
		}

		public int nearNIndexEnd(int Offset, NoteTrack Notes, int fret)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int num = 0;
				int num2 = Notes.Count(fret) - 1;
				switch (num2)
				{
				case -1:
				case 0:
					result = 0;
					break;
				case 1:
				{
					int num3 = Math.Abs(Notes[0, fret].OffsetEnd - Offset);
					int num4 = Math.Abs(Notes[1, fret].OffsetEnd - Offset);
					if (num3 >= num4)
					{
						result = 1;
					}
					else
					{
						result = 0;
					}
					break;
				}
				default:
				{
					int num5 = num2 / 2;
					while (Notes[num5, fret].OffsetEnd != Offset)
					{
						num5 = (num + num2) / 2;
						if (Notes[num5, fret].OffsetEnd > Offset)
						{
							num2 = num5;
						}
						else
						{
							num = num5;
						}
						if (num2 - num <= 1)
						{
							int num6 = Math.Abs(Notes[num5, fret].OffsetEnd - Offset);
							int num7 = Math.Abs(Notes[num5 - 1, fret].OffsetEnd - Offset);
							int num8 = Math.Abs(Notes[num5 + 1, fret].OffsetEnd - Offset);
							if (num6 <= num7 && num6 <= num8)
							{
								return num5;
							}
							if (num7 <= num8)
							{
								return num5 - 1;
							}
							return num5 + 1;
						}
					}
					result = num5;
					break;
				}
				}
			}
			return result;
		}

		public int NextBPMIndex(int offset)
		{
			int i;
			for (i = 0; i < this.Offset.Count; i++)
			{
				if (this.Offset[i] >= offset)
				{
					return i;
				}
			}
			return i;
		}

		public int nextNIndex(int Offset, NoteTrack Notes)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int i;
				for (i = this.nearNIndex(Offset, Notes); i < Notes.Count<Note>(); i++)
				{
					if (Notes[i].Offset > Offset)
					{
						return i;
					}
				}
				result = i - 1;
			}
			return result;
		}

		public int nextNIndex(int Offset, List<Note> Notes)
		{
			int result;
			if (Notes == null)
			{
				result = 0;
			}
			else
			{
				int i;
				for (i = this.nearNIndex(Offset, Notes); i < Notes.Count<Note>(); i++)
				{
					if (Notes[i].Offset > Offset)
					{
						return i;
					}
				}
				result = i - 1;
			}
			return result;
		}

		public int PrevBPMIndex(int offset)
		{
			int i;
			for (i = 0; i < this.Offset.Count; i++)
			{
				if (this.Offset[i] >= offset)
				{
					break;
				}
			}
			return i - 1;
		}

		public int prevNIndex(int Offset, NoteTrack Notes)
		{
			if (Notes != null)
			{
				for (int i = this.nearNIndex(Offset, Notes); i >= 0; i--)
				{
					if (Notes[i].Offset < Offset)
					{
						return i;
					}
				}
			}
			return 0;
		}

		public int prevNIndex(int Offset, List<Note> Notes)
		{
			if (Notes != null)
			{
				for (int i = this.nearNIndex(Offset, Notes); i >= 0; i--)
				{
					if (Notes[i].Offset < Offset)
					{
						return i;
					}
				}
			}
			return 0;
		}

		public List<float> BPM = new List<float>();

		private Chart chart;

		public List<int> Offset = new List<int>();

		public float songLength;

		public List<float> timeOffset = new List<float>();
	}
}
