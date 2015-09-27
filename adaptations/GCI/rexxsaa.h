// GCI depends on rexxsaa.h : redirect to ooRexx API
// This file must be here (above the source directory) because Makefile.vc
// defines REXX_INCLUDE_PATH=..

// cl compiler:
// set INCLUDE=%builder_build_dir%\api;%INCLUDE%
// set LIB=%uilder_build_dir%\api;%LIB%

// gcc compiler:
// CPLUS_INCLUDE_PATH=$builder_delivery_dir/include:$CPLUS_INCLUDE_PATH
// LIBRARY_PATH=$builder_delivery_dir/lib:$LIBRARY_PATH

#include "rexx.h"

// Added to let compile under MacOsX
#if !defined(APIENTRY)
#define APIENTRY
#endif

#ifndef CONST
#define CONST const
#endif

#ifndef UCHAR_TYPEDEFED
typedef unsigned char UCHAR ;
#define UCHAR_TYPEDEFED
#endif

#ifndef ULONG_TYPEDEFED
typedef unsigned long ULONG ;
#define ULONG_TYPEDEFED
#endif

// Added to let compile under Windows
typedef void* PVOID ;
#define APIRET ULONG
typedef CONST char *PCSZ ;
