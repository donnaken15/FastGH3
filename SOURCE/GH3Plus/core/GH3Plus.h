#pragma once

#ifdef GH3P_EXPORTS
	#define GH3P_API __declspec(dllexport) 
#else
	#define GH3P_API __declspec(dllimport) 
#endif