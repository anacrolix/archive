#ifndef _DLL_H_
#define _DLL_H_

#if BUILDING_DLL
# define DLLIMPORT __declspec (dllexport)
#else /* Not BUILDING_DLL */
# define DLLIMPORT __declspec (dllimport)
#endif /* Not BUILDING_DLL */

extern "C" __declspec(dllexport) void __cdecl SetKey(char *rsakey);
extern "C" __declspec(dllexport) void __cdecl Encrypt(char *cData);


#endif /* _DLL_H_ */
