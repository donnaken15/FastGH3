using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class TrackPropsList : List<TrackProps>
	{
		public TrackProps this[string key]
		{
			get
			{
				foreach (TrackProps trackProps in this)
				{
					if (trackProps.Name.IndexOf(key, StringComparison.OrdinalIgnoreCase) == 0 && trackProps.Name.Length == key.Length)
					{
						return trackProps;
					}
				}
				return base[0];
			}
		}
	}
}
