using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace ChartEdit
{
	// Token: 0x0200001C RID: 28
	public class Chart
	{
		public Chart()
		{
			this.Song = new SongSection();
			this.SyncTrack = new SyncTrackSection();
			this.Events = new EventsSection();
			this.NoteTracks = new NoteTracks();
		}
        
        public Chart(string fileName)
        {
            this.Song = new SongSection();
            this.SyncTrack = new SyncTrackSection();
            this.Events = new EventsSection();
            this.NoteTracks = new NoteTracks();
            /*string[] RawFile = File.ReadAllText(fileName).Split('\n');
            bool temp = false;
            for (int i = 0; i < RawFile.Length; i++)
            {
                if (temp)
                {

                }
                else if (!temp && (RawFile[i].Contains("Single") || RawFile[i].Contains("Bass")))
                {

                }
            }
            this.StarPowerTracks = new int[][] { new int[] { 0 },
                                                 new int[] { 0 },
                                                 new int[] { 0 },
                                                 new int[] { 0 } };*/
            this.Load(fileName);
		}
        
		public void GetResolution()
		{
			if (this.Song.ContainsKey("Resolution"))
			{
				this.Resolution = int.Parse(this.Song["Resolution"].Value);
			}
			else
			{
				this.Resolution = 192;
			}
		}
        
		private bool HandleEvents(string entry)
		{
			EventsSectionEntry eventsSectionEntry = EventsSectionEntry.Parse(entry);
			bool result;
			if (eventsSectionEntry == null)
			{
				result = false;
			}
			else
			{
				if (eventsSectionEntry.Offset > this.LastIndex)
				{
					this.LastIndex = eventsSectionEntry.Offset;
				}
				this.Events.Add(eventsSectionEntry);
				result = true;
			}
			return result;
		}
        
		private bool HandleKeyValue(string title, string entry)
		{
			bool result;
			if (title == "Song")
			{
				result = this.HandleSong(entry);
			}
			else if (title == "SyncTrack")
			{
				result = this.HandleSyncTrack(entry);
			}
			else if (title == "Events")
			{
				result = this.HandleEvents(entry);
			}
			else
			{
				result = this.HandleNote(title, entry);
			}
			return result;
		}
        
		private bool HandleNote(string title, string entry)
		{
			Note note = Note.Parse(entry);
			bool result;
			if (note == null)
			{
				result = false;
			}
			else
			{
				if (!this.NoteTracks.ContainsTrack(title))
				{
					this.NoteTracks.Add(new NoteTrack(title));
				}
				NoteTrack noteTrack = this.NoteTracks[title];
				if (note.Offset > this.LastIndex)
				{
					this.LastIndex = note.Offset;
				}
				noteTrack.Add(note);
				result = true;
			}
			return result;
		}
        
		private bool HandleSong(string entry)
		{
			SongSectionEntry songSectionEntry = SongSectionEntry.Parse(entry);
			bool result;
			if (songSectionEntry == null)
			{
				result = false;
			}
			else
			{
				this.Song.Add(songSectionEntry);
				result = true;
			}
			return result;
		}
        
		private bool HandleSyncTrack(string entry)
		{
			SyncTrackEntry syncTrackEntry = SyncTrackEntry.Parse(entry);
			bool result;
			if (syncTrackEntry == null)
			{
				result = false;
			}
			else
			{
				if (syncTrackEntry.Offset > this.LastIndex)
				{
					this.LastIndex = syncTrackEntry.Offset;
				}
				this.SyncTrack.Add(syncTrackEntry);
				result = true;
			}
			return result;
		}
        
		public void Load(string fileName)
		{
			if (!File.Exists(fileName))
			{
				throw new FileNotFoundException(fileName + " was not found.");
			}
			string text = File.ReadAllText(fileName);
			if (string.IsNullOrEmpty(text))
			{
				throw new IOException("Unable to load chart file.");
			}
			FileInfo fileInfo = new FileInfo(fileName);
			this.LoadPath = fileInfo.Directory.FullName;
			this.ParseChartData(text);
			this.GetResolution();
			this._ot = new OffsetTransformer(this);
		}
        
		private void ParseChartData(string chartData)
		{
			foreach (object obj in Chart.TrackRegex.Matches(chartData))
			{
				Match match = (Match)obj;
				Group group = match.Groups["title"];
				Group group2 = match.Groups["entry"];
				string title = group.Value.Trim();
				foreach (object obj2 in group2.Captures)
				{
					Capture capture = (Capture)obj2;
					this.HandleKeyValue(title, capture.Value);
				}
			}
		}
        
		public void Save(string fileName)
		{
			StringBuilder stringBuilder = new StringBuilder();
			this.WriteSongData(stringBuilder);
			this.WriteSyncTrackData(stringBuilder);
			this.WriteEventData(stringBuilder);
			foreach (NoteTrack noteTrack in this.NoteTracks)
			{
				this.WriteNoteTrackData(stringBuilder, noteTrack);
			}
			File.WriteAllText(fileName, stringBuilder.ToString());
		}
        
		private void WriteEventData(StringBuilder chartData)
		{
			chartData.Append("[Events]\r\n");
			chartData.Append("{\r\n");
			foreach (EventsSectionEntry eventsSectionEntry in this.Events)
			{
				chartData.Append("\t" + eventsSectionEntry.Offset + " = ");
				switch (eventsSectionEntry.Type)
				{
				case EventType.Text:
					chartData.Append("E \"" + eventsSectionEntry.TextValue + "\"");
					break;
				case EventType.Effect:
					chartData.Append(string.Concat(new object[]
					{
						"H ",
						eventsSectionEntry.EffectType,
						" ",
						eventsSectionEntry.EffectLength
					}));
					break;
				}
				chartData.Append("\r\n");
			}
			chartData.Append("}\r\n");
		}
        
		private void WriteNoteTrackData(StringBuilder chartData, NoteTrack noteTrack)
		{
			chartData.Append("[" + noteTrack.Name + "]\r\n");
			chartData.Append("{\r\n");
			foreach (Note note in noteTrack)
			{
				chartData.Append("\t" + note.Offset + " = ");
				switch (note.Type)
				{
				case NoteType.Regular:
					chartData.Append(string.Concat(new object[]
					{
						"N ",
						note.Fret,
						" ",
						note.Length * 192 / 480
					}));
					break;
				case NoteType.Special:
					chartData.Append(string.Concat(new object[]
					{
						"S ",
						note.SpecialFlag,
						" ",
						note.Length
					}));
					break;
				case NoteType.Event:
					chartData.Append("E " + note.EventName);
					break;
				}
				chartData.Append("\r\n");
			}
			chartData.Append("}\r\n");
		}
        
		private void WriteSongData(StringBuilder chartData)
		{
			chartData.Append("[Song]\r\n");
			chartData.Append("{\r\n");
			foreach (SongSectionEntry songSectionEntry in this.Song)
			{
				chartData.Append(string.Concat(new string[]
				{
					"\t",
					songSectionEntry.Key,
					" = ",
					songSectionEntry.Value,
					"\r\n"
				}));
			}
			chartData.Append("}\r\n");
		}
        
		private void WriteSyncTrackData(StringBuilder chartData)
		{
			chartData.Append("[SyncTrack]\r\n");
			chartData.Append("{\r\n");
			foreach (SyncTrackEntry syncTrackEntry in this.SyncTrack)
			{
				chartData.Append("\t" + syncTrackEntry.Offset + " = ");
				switch (syncTrackEntry.Type)
				{
				case SyncType.BPM:
					chartData.Append("B " + syncTrackEntry.BPM);
					break;
				case SyncType.TimeSignature:
					chartData.Append("TS " + syncTrackEntry.TimeSignature);
					break;
				case SyncType.Anchor:
					chartData.Append("A " + syncTrackEntry.Anchor);
					break;
				}
				chartData.Append("\r\n");
			}
			chartData.Append("}\r\n");
		}
        
		public int EighthResolution
		{
			get
			{
				return this.eRes;
			}
		}

        public int[][] StarPowerTracks;
        
		public EventsSection Events { get; set; }
        
		public int HalfResolution
		{
			get
			{
				return this.hRes;
			}
		}
        
		public int LastIndex { get; set; }
        
		public string LoadPath { get; set; }
        
		public string Name { get; set; }
        
		public NoteTracks NoteTracks { get; set; }
        
		public int QuarterResolution
		{
			get
			{
				return this.qRes;
			}
		}

		public int Resolution
		{
			get
			{
				return this.res;
			}
			set
			{
				this.res = value;
				this.hRes = value / 2;
				this.qRes = value / 4;
				this.eRes = value / 8;
				this.sRes = value / 16;
				this.tRes = value / 32;
			}
		}

		public int SixteenthResolution
		{
			get
			{
				return this.sRes;
			}
		}

		public SongSection Song { get; set; }

		public float SongLength { get; set; }

		public SyncTrackSection SyncTrack { get; set; }

		public int ThirtysecondResolution
		{
			get
			{
				return this.tRes;
			}
		}

		private OffsetTransformer _ot;

		private int eRes;

		private int hRes;

		private int qRes;

		private int res;

		private int sRes;

		// Token: 0x0400008E RID: 142
		private static readonly Regex TrackRegex = new Regex("\\[(?<title>[a-zA-Z]+)\\]\\r\\n\\{\\r\\n(\\s(?<entry>.+?)\\r\\n)+\\}", RegexOptions.Multiline | RegexOptions.ExplicitCapture | RegexOptions.Compiled | RegexOptions.IgnorePatternWhitespace);

		// Token: 0x0400008F RID: 143
		private int tRes;
	}
}
