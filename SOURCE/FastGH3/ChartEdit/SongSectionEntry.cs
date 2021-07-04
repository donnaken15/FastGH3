using System;
using System.Text.RegularExpressions;

namespace ChartEdit
{
	public class SongSectionEntry
	{
		public static SongSectionEntry Parse(string entryStr)
		{
			Match match = SongSectionEntry.SongRegex.Match(entryStr);
			SongSectionEntry result;
			if (!match.Success)
			{
				result = null;
			}
			else
			{
				SongSectionEntry songSectionEntry = new SongSectionEntry();
				string key = match.Groups["key"].Value.Trim();
				string value = match.Groups["value"].Value.Trim().Trim("\"".ToCharArray());
				songSectionEntry.Key = key;
				songSectionEntry.Value = value;
				result = songSectionEntry;
			}
			return result;
		}

        public string Key { get; set; }

		public string Value { get; set; }

		private static readonly Regex SongRegex = new Regex("(?<key>.+)\\s*\\=\\s*(?<value>.+)", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);
	}
}
