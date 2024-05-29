using System;
using System.Text.RegularExpressions;

namespace ChartEdit
{
	public class SyncTrackEntry
	{
		public static SyncTrackEntry Parse(string entryStr)
		{
			Match match = SyncTrackEntry.SyncTrackRegex.Match(entryStr);
			SyncTrackEntry result;
			if (!match.Success)
			{
				result = null;
			}
			else
			{
				SyncTrackEntry syncTrackEntry = new SyncTrackEntry();
				int offset = int.Parse(match.Groups["offset"].Value.Trim());
				string text = match.Groups["type"].Value.Trim();
				int num;
				try
				{
					num = int.Parse(match.Groups["value"].Value.Trim());
				}
				catch (OverflowException)
				{
					num = int.MaxValue;
				}
				syncTrackEntry.TimeSignature2 = -1;
				syncTrackEntry.Offset = offset;
				string text2 = text;
				if (text2 != null)
				{
					if (!(text2 == "A"))
					{
						if (text2 == "TS")
						{
							syncTrackEntry.TimeSignature = num;
							var ts2 = match.Groups["ts2"];
							if (ts2.Success)
								syncTrackEntry.TimeSignature2 = int.Parse(ts2.Value.Trim());
							syncTrackEntry.Type = SyncType.TimeSignature;
							return syncTrackEntry;
						}
						if (text2 == "B")
						{
							syncTrackEntry.BPM = num;
							syncTrackEntry.FloatBPM = (float)num / 1000f;
							syncTrackEntry.Type = SyncType.BPM;
						}
						return syncTrackEntry;
					}
					else
					{
						syncTrackEntry.Anchor = num;
						syncTrackEntry.Type = SyncType.Anchor;
					}
				}
				result = syncTrackEntry;
			}
			return result;
		}

		public int Anchor { get; set; }

		public int BPM { get; set; }

		public float FloatBPM { get; set; }

		public int Offset { get; set; }

		public int TimeSignature { get; set; }
		public int TimeSignature2 { get; set; }

		public SyncType Type { get; set; }

		private static readonly Regex SyncTrackRegex = new Regex("(?<offset>\\d+)\\s*\\=\\s*(?<type>.*?)\\s*(?<value>\\d+)(\\s(?<ts2>\\d+))?", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);
	}
}
