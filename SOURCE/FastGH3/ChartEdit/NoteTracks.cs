using System;
using System.Collections.Generic;

namespace ChartEdit
{
	public class NoteTracks : List<NoteTrack>
	{
		public bool ContainsTrack(string name)
		{
			foreach (NoteTrack noteTrack in this)
			{
				if (noteTrack.Name == name)
				{
					return true;
				}
			}
			return false;
		}
        
		public NoteTrack this[string name]
		{
			get
			{
				foreach (NoteTrack noteTrack in this)
				{
					if (noteTrack.Name == name)
					{
						return noteTrack;
					}
				}
				return null;
			}
		}
	}
}
