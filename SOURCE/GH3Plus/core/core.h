#pragma once

#include <Windows.h>
#include <iostream>

bool lendswith(LPCWSTR str, LPCWSTR ending);
HANDLE LoadPlugin(LPCWSTR plugin, std::wofstream &log);
void LoadPlugins();