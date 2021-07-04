using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class EventsSection : List<EventsSectionEntry>
	{
		public EventsSectionEntry this[string s]
		{
			get
			{
				foreach (EventsSectionEntry eventsSectionEntry in this)
				{
					if (eventsSectionEntry.TextValue == s)
					{
						return eventsSectionEntry;
					}
				}
				return null;
			}
		}

		public const string SectionName = "Events";
	}
}
