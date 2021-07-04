using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace ChartEdit
{
	public class Globals
	{
		public static void Initialize()
		{
			/*if (Globals.Instance == null)
			{
				Globals.Instance = Serializable<Globals>.Load("config/globals.xml");
			}*/
		}

		public string ReplaceKey(string key)
		{
			foreach (KeyValue keyValue in this.KeyVals)
			{
				if (keyValue.Key == key)
				{
					return keyValue.Value;
				}
			}
			return key;
		}

		public static Globals Instance
		{
			[CompilerGenerated]
			get
			{
				return Globals.Instance;
			}
			[CompilerGenerated]
			private set
			{
				Globals.Instance = value;
			}
		}

		public List<GameProps> GameProperties = new List<GameProps>();

		public List<KeyValue> KeyVals = new List<KeyValue>();
	}
}
