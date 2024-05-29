using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class SyncTrackSection : List<SyncTrackEntry>
	{
		public bool ContainsOffset(int offset)
		{
			foreach (SyncTrackEntry syncTrackEntry in this)
			{
				if (syncTrackEntry.Offset == offset)
				{
					return true;
				}
			}
			return false;
		}

		public SyncTrackEntry GetByIndex(int index)
		{
			return base[index];
		}

		public SyncTrackEntry GetByOffset(int offset)
		{
			foreach (SyncTrackEntry syncTrackEntry in this)
			{
				if (syncTrackEntry.Offset == offset)
				{
					return syncTrackEntry;
				}
			}
			return null;
		}

		public const string SectionName = "SyncTrack";
	}
}
