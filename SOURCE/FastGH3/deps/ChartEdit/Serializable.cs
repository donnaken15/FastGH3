using System;
using System.IO;
using System.Xml.Serialization;

namespace ChartEdit
{
	public class Serializable<T> where T : Serializable<T>
	{
		public static T Load(string fileName)
		{
			FileStream fileStream = null;
			T result = default(T);
			try
			{
				fileStream = File.Open(fileName, FileMode.Open, FileAccess.Read, FileShare.Read);
				//XmlSerializer xmlSerializer = new XmlSerializer(typeof(T));
				//result = (T)((object)xmlSerializer.Deserialize(fileStream));
				fileStream.Close();
			}
			catch (Exception)
			{
				return default(T);
			}
			finally
			{
				if (fileStream != null)
				{
					fileStream.Close();
				}
			}
			return result;
		}
        
		public bool Save(string fileName)
		{
			return Save(fileName, (T)((object)this));
		}
        
		public static bool Save(string fileName, T data)
		{
			FileStream fileStream = null;
			bool result;
			try
			{
				fileStream = File.Create(fileName);
				new XmlSerializer(typeof(T)).Serialize(fileStream, data);
				fileStream.Close();
				result = true;
			}
			catch (Exception)
			{
				result = false;
			}
			finally
			{
				if (fileStream != null)
				{
					fileStream.Close();
				}
			}
			return result;
		}
	}
}
