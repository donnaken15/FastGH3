using System;
using System.Collections.Generic;
using System.Text;

namespace Nanook.QueenBee.Parser
{
	[AttributeUsage(AttributeTargets.Property, Inherited = false)]
	public sealed class GenericEditableAttribute : System.Attribute
	{
		public GenericEditableAttribute(string defaultDisplayName, Type editType, bool useQbItemType, bool readOnly)
		{
			_defaultDisplayName = defaultDisplayName;
			_editType = editType;
			_useQbItemType = useQbItemType;
			_readOnly = readOnly;
		}

		public string DefaultDisplayName
		{
			get { return _defaultDisplayName; }
		}

		public bool ReadOnly
		{
			get { return _readOnly; }
		}

		public Type EditType
		{
			get { return _editType; }
		}

		public bool UseQbItemType
		{
			get { return _useQbItemType; }
		}

		private string _defaultDisplayName;
		private Type _editType;
		private bool _readOnly;
		private bool _useQbItemType;
	}
}
