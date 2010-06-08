#ifndef _DEFINED_uniqueheadername  //---------------1---------------+
#define _DEFINED_uniqueheadername  //---------------1---------------+
                                                                 // |
  #if _MSC_VER > 1000  //--------------2---------------+            |
    #pragma once                                    // |            |
  #endif //----------------------------2---------------+            |
                                                                 // |
  #ifdef __cplusplus  //---------------3---------------+            |
  extern "C" {                                      // |            |
  #endif // __cplusplus  //------------3---------------+            |
                                                                 // |
  #ifdef _COMPILING_uniqueheadername  //-----------4-----------+    |
    #define LIBSPEC __declspec(dllexport)                   // |    |
  #else                                                     // |    |
    #define LIBSPEC __declspec(dllimport)                   // |    |
  #endif // _COMPILING_uniqueheadername  //--------4-----------+    |
                                                            // |    |
  LIBSPEC linkagetype resulttype name(parameters);          // |    |
  // ... more declarations as needed                        // |    |
  #undef LIBSPEC   //------------------------------4-----------+    |
                                                                 // |
  #ifdef __cplusplus    //----------------5---------------+         |
  }                                                    // |         |
  #endif // __cplusplus  //---------------5---------------+         |
#endif // _DEFINED_uniqueheadername //-----------------1------------+