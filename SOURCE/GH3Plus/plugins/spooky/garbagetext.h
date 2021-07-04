#pragma once

#include <string>

static const wchar_t defaultGarbageText[] = L"ZGRBG000GENERICZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
//const std::size_t defaultGarbageTextLength = wcslen()

class GarbageText
{
private:
	std::wstring str_;
	std::wstring spookyStr_;
	GarbageText();
	static GarbageText &Instance();
public:
	const static wchar_t * GetString(std::size_t offset);
	const static wchar_t * GetSpookyString(std::size_t offset);

};