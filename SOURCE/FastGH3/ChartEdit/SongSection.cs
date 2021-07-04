using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class SongSection : List<SongSectionEntry>
	{
		public bool ContainsKey(string key)
		{
			foreach (SongSectionEntry songSectionEntry in this)
			{
				if (songSectionEntry.Key == key)
				{
					return true;
				}
			}
			return false;
		}

		public SongSectionEntry this[string key]
		{
			get
			{
				foreach (SongSectionEntry songSectionEntry in this)
				{
					if (songSectionEntry.Key == key)
					{
						return songSectionEntry;
					}
				}
				return null;
			}
		}

		public const string SectionName = "Song";
	}
}
