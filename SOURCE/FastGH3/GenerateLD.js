
// smaller (maybe) alternative to
// resources because .NET is absurd
// abusing the soy compilation rule
// of all strings being UTF 16 LE

const fs = require('fs');

const classname = "Launcher";
const reslist = {
	T: {	// launcher strings
		// next step in autism, compress with LZSS and huffman
		// maybe pointless if i'm already using mpress
		binary: false,
		ascii: true,
		escaped: true,
		splitter: '\n',
		source: "lt.txt"
	},
	cr: {	// credits text, for those who even care
		binary: false,
		ascii: true,
		escaped: false,
		source: "credits.txt"
	},
	kl: {	// keybind list
		binary: true,
		source: "kl.bin"
	},
	qn: {	// new qb
		binary: true,
		source: "qn.bin"
	},
	pn: {	// new pak
		binary: true,
		source: "pn.bin"
	},
	xmlDefault: {
		ascii: true,
		string: `<?xml version="1.0" encoding="utf-8"?>
<r>
<s id="Video.Width">1024</s>
<s id="Video.Height">768</s>
<s id="Sound.SongSkew">-0.1</s>
</r>`
	},
	splashText: {
		ascii: true,
		string: `
 Welcome to FastGH3 v1.0

 FastGH3 is an advanced mod of
 Guitar Hero 3. With this mod, you
 can play customs without any technical
 setup, and even associate chart or mid
 files with the game so you can access
 your charts quickly.

 To access the options, use
 the -settings parameter or
 open settings.bat.

 Press any key to load a chart.`
	},
	TT: {
		ascii: false,
		splitter: '\n',
		string:
			"FASTGH3 BACKGROUND PREVIEW™©®\n" +
			""
	}
};
const escs = {'n': '\n', 'r': '\r', 't': '\t'};
function parse_esc(part)
{
	var i = 0;
	var res = "";
	if (part.length == 3)
		res = part[i++];
	var repl = escs[part[++i]];
	res += (repl === undefined ? part[i] : repl);
	return res;
}
// this thing only exists in C# (brow raise emoji)

var output = // header
`\ufeff// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// THIS FILE IS AUTOGENERATED BY GenerateLD.js
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
using System;
using System.Text;
static partial class Launcher
{
	static Encoding A = Encoding.ASCII;
	static Encoding U = Encoding.Unicode;
`;
for (var R in reslist) {
	const res = reslist[R];
	var direct_string = res.hasOwnProperty("string");
	var buf = !direct_string ? fs.readFileSync('Resources/'+res.source) : res.string;
	if (buf.length % 2 === 1)
		if (direct_string)
			buf += '\0';
		else
			buf = Buffer.concat([buf, Buffer(1)]);
	var string;
	var data_type;
	var raw_string = null;
	var string_array = res.binary !== true && res.splitter !== undefined;
	// don't know if this === undefined can also return condition as false
	if (res.binary === true && !direct_string)
	{
		//console.log(res.source);
		string = buf.toString('utf16le');
		//fs.writeFileSync('test.txt', string, {encoding: 'utf8'});
		//console.log(string);
		data_type = "byte[]";
	}
	else
	{
		string = buf.toString();
		data_type = "string";
		if (string_array)
		{
			string = string.replaceAll(res.splitter, '^');
			data_type += "[]";
		}
		if (res.escaped)
		//	string = string.replaceAll('\\\\\\n', '\\\n') // hate
		//					.replaceAll('\\\\n', '\\\n')
		//					.replaceAll('\\n', '\n')
		//					.replaceAll('\\\\\\', '\\\\')
		//					.replaceAll('\\\\', '\\');
			string = string.replaceAll(/([^\\\n])?\\./g, parse_esc);
		if (string_array)
			raw_string = string.split('^');
		else
			raw_string = string;
		//fs.writeFileSync('test.txt',
		//	Buffer(string+'\0\0').toString(res.ascii ? 'utf16le' : 'utf8'),
		//	{encoding: 'utf16le'});
		string = Buffer(string).toString(res.ascii === true ? 'utf16le' : 'utf8');
		//fs.writeFileSync('test.txt', string, {encoding: 'utf8'});
	}
	string = string
		.replaceAll('\n','n')
		.replaceAll('\r','r')
		.replaceAll('\u2029','\\u2029')
		.replaceAll('"','\\"')
		.replaceAll('','\\u0085') // wtf is this, causes newline
		.replaceAll('\\','\\\\');
		//.replaceAll(/[\x80-\x8F]/g,());
	output += '\tpublic static readonly '+(data_type)+" "+R+" = ";
	// MESSSSSSSSSSSSSSSSSSSSSS
	var dontConvert = !(res.binary === true || (res.ascii === true && res.binary !== true));
	if (res.binary === true || res.ascii === true || direct_string)
	{
		if (res.ascii === true)
			output += "A.GetString(\n\t\t";
		//console.log(res);
		if (!dontConvert)
			output += "U.GetBytes(";
		if (raw_string !== null)
		{
			if (!string_array)
			{
				output += "\n\t\t// " +
					raw_string.replaceAll('\r','').replaceAll('\n','\n\t\t// ') + '\n\t\t#region';
			}
			else
			{
				output += '\n';
				for (var i = 0; i < raw_string.length; i++)
				{
					if (i > 0)
						output += '\n';
					output += "\t\t// ["+i+"]\n\t\t// " +
						raw_string[i].replaceAll('\r','').replaceAll('\n','\n\t\t// ');
				}
				output += '\n\t\t#region';
			}
			output += '\n\t\t"'+string.replaceAll('\\\\u0085','\\u0085')+'"\n';
		}
		else
		{
			output += '\n\t\t#region\n\t\t"'+string.replaceAll('\\\\u0085','\\u0085')+'"';
		}
		if (res.ascii !== true)
			output += '\n';
		output += '\t\t#endregion';
		//if (res.ascii !== true)
			output += '\n';
		if (res.ascii === true)
			output += "\t\t)\n";
		output += '\t';
		if (!dontConvert)
			output += ')';
		if (string_array)
			output += '.Split(new char[] {\'^\'}, StringSplitOptions.RemoveEmptyEntries)';
		output += ';\n';
	}
}
output += '}';
fs.writeFileSync('LD.cs', output, {encoding: 'utf8'});
