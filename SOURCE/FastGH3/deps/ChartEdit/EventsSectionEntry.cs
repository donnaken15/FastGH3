using System;
using System.Text.RegularExpressions;

namespace ChartEdit
{
	public class EventsSectionEntry
	{
		public static EventsSectionEntry Parse(string entryStr)
		{
			Match match = EventsSectionEntry.EventTextRegex.Match(entryStr);
			EventsSectionEntry eventsSectionEntry = new EventsSectionEntry();
			EventsSectionEntry result;
			if (!match.Success)
			{
				match = EventsSectionEntry.EventEffectRegex.Match(entryStr);
				if (!match.Success)
				{
					result = null;
				}
				else
				{
					int offset = int.Parse(match.Groups["offset"].Value.Trim());
					int effectType = int.Parse(match.Groups["type"].Value.Trim());
					int effectLength = int.Parse(match.Groups["len"].Value.Trim());
					eventsSectionEntry.Type = EventType.Effect;
					eventsSectionEntry.Offset = offset;
					eventsSectionEntry.EffectLength = effectLength;
					eventsSectionEntry.EffectType = effectType;
					result = eventsSectionEntry;
				}
			}
			else
			{
				int offset2 = int.Parse(match.Groups["offset"].Value.Trim());
				string textValue = match.Groups["value"].Value.Trim();
				eventsSectionEntry.Type = EventType.Text;
				eventsSectionEntry.Offset = offset2;
				eventsSectionEntry.TextValue = textValue;
				result = eventsSectionEntry;
			}
			return result;
		}

		public int EffectLength { get; set; }

		public int EffectType { get; set; }

		public int Offset { get; set; }

		public string TextValue { get; set; }

		public EventType Type { get; set; }

		private static readonly Regex EventEffectRegex = new Regex("\\s*(?<offset>\\d+)\\s*\\=\\s*H\\s*(?<type>\\d+)\\s*(?<len>\\d+)", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);

		private static readonly Regex EventTextRegex = new Regex("(?<offset>\\d+)\\s*\\=\\s*E\\s*\\\"(?<value>.*)\\\"", RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);
	}
}
