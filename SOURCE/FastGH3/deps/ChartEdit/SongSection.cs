using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class SongSection : List<SongSectionEntry>
	{
		public bool ContainsKey(string key)
		{
			return this[key] != null;
		}

		public SongSectionEntry this[string key]
		{
			get
			{
				foreach (SongSectionEntry songSectionEntry in this)
				{
					if (songSectionEntry.Key.ToLower() == key.ToLower())
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
