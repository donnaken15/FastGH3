script() {

FormatText(checksumName=scr,'%s',s=(*textinput_username));
if (ScriptExists(%scr))
{
	SpawnScriptNow(%scr);
}

}