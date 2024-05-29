using System;
using System.IO;
using System.Text;

namespace ChartEdit
{
    /*internal class QbArrayWriter : IChartWriter
	{
        public void Save(Chart chart)
        {
            _ot = new OffsetTransformer(chart);
            foreach (NoteTrack noteTrack in chart.NoteTracks)
            {
                using (StreamWriter streamWriter = new StreamWriter(noteTrack.Name))
                {
                    StringBuilder value = new QbcNoteTrack(noteTrack, this._ot).AsString();
                    streamWriter.Write(value);
                }
            }
            using (StreamWriter streamWriter = new StreamWriter("NoteTrackList"))
            {
                foreach (NoteTrack notetrack in chart.NoteTracks)
                {
                    streamWriter.Write(notetrack.Name + Environment.NewLine);
                }
            }
            using (StreamWriter streamWriter = new StreamWriter("Resolution"))
            {
                streamWriter.Write(_ot.GetTime(chart.Resolution).ToString());
            }
            using (StreamWriter streamWriter = new StreamWriter("Tempos"))
            {
                foreach (SyncTrackEntry syncTrack in chart.SyncTrack)
                {
                    if (syncTrack.Type == SyncType.BPM)
                    {
                        streamWriter.Write(_ot.GetTime(syncTrack.Offset).ToString() + Environment.NewLine + syncTrack.FloatBPM.ToString() + Environment.NewLine);
                    }
                }
            }
            using (StreamWriter streamWriter = new StreamWriter("TimeSig"))
            {
                foreach (SyncTrackEntry syncTrack in chart.SyncTrack)
                {
                    if (syncTrack.Type == SyncType.TimeSignature)
                        streamWriter.Write(Math.Round(_ot.GetTime(syncTrack.Offset) * 1000).ToString() + Environment.NewLine + syncTrack.TimeSignature.ToString() + Environment.NewLine + "4\n");
                }
            }
            using (StreamWriter streamWriter = new StreamWriter("Markers"))
            {
                foreach (EventsSectionEntry eventEntry in chart.Events)
                { 
                    if (eventEntry.TextValue.StartsWith("section "))
                        streamWriter.Write(Math.Round(_ot.GetTime(eventEntry.Offset) * 1000).ToString() + Environment.NewLine + eventEntry.TextValue.Substring(8) + Environment.NewLine);
                }
            }
            using (StreamWriter streamWriter = new StreamWriter("Measures"))
            {
                for (int i = 0; _ot.GetTime(i) < _ot.songLength; i += chart.Resolution)
                {
                    streamWriter.WriteLine(Convert.ToInt32(_ot.GetTime(i)*1000));
                }
                //foreach (float time in _ot.timeOffset)
                //streamWriter.WriteLine(time);
            }
        }
        
        private OffsetTransformer _ot;
    }*/
}
