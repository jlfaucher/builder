/*
 * This is an example for using GCI. Enjoy, copy and paste!
 * We have three different execution paths for Unix, Win32 and OS/2.
 * For some interpreters, most notable the builtin interpreter of OS/2, you
 * have to rename this file to gci-try.cmd
 */
parse version version
say "Your REXX interpreter is" version

/******************************************************************************
 * Try to detect the system to show several things.
 */
parse var version "REXX-"ipret"_".
IsRegina = 0
if ipret = "Regina" then do
   IsRegina = 1
   options NOEXT_COMMANDS_AS_FUNCS
   end

parse source system . source
system = translate(system)

/* Problem with Regina :
   Under MacOs, system=="UNIX", not "MACOSX" or "DARWIN"
   Under Ubuntu, system=="UNIX", not "LINUX"*/
if system == "UNIX" then do
   "test `uname -s` = 'Darwin'"
   if RC = 0 then system = "MACOSX"
   else do
       "test `uname -s` = 'Linux'"
       if RC = 0 then system = "LINUX"
   end
end

if left(system, 3) = "WIN" then do
   library = "GCI.DLL"
   CLib = "MSVCRT"
   system = "WIN"
   end
else if system = "OS/2" then do
   library = "GCI.DLL"
   system = "OS/2"
   end
else if system = "MACOSX" then do
   /* If DYLD_FALLBACK_LIBRARY_PATH is defined and dlopen can't load libSystem.dylib
      then add these directories (default value, see man dlopen) :
      $HOME/lib:/usr/local/lib:/usr/lib */
   library = "libgci.dylib"
   CLib = "c" -- "System"
   MathLib = "m" -- "System"
   end
else do
   library = "libgci.so"
   tr = trace()
   trace o
   "test `uname -s` = 'SunOS'"
   if RC = 0 then
      CLib = "libc.so.1"
   else
      CLib = "libc.so.6"
      MathLib = "m" --"libm.so.6"
      DlLib = "libdl.so.2"
   trace value tr
   end

/*
 * Check for a builtin RxFuncDefine. Call it with errorneous arguments and
 * expect a simple error if installed and a syntax signal if unknown.
 */
InternalGCI = 0
signal on syntax name NotInstalled
x = "X"
x. = "X"
h = RxFuncDefine(x,x,x,x)
if h \= 0 & h \= 10005 & DataType(h, "NUM") then
   InternalGCI = 1
NotInstalled:
drop GCI_RC

signal on syntax
if \InternalGCI then do
   /*
    * The DLL may have been loaded already. Prevent bugs at this stage.
    */
   call RxFuncDrop RxFuncDefine
   call RxFuncDrop GciPrefixChar
   call RxFuncDrop GciFuncDrop
   if RxFuncadd(RxFuncDefine, "gci", "RxFuncDefine") \= 0 then do
      msg = "Can't load RxFuncDefine of" library
      if IsRegina then
         msg = msg || ":" RxFuncErrMsg()
      say msg
      return 1
      end
   if RxFuncadd(GciFuncDrop, "gci", "GciFuncDrop") \= 0 then do
      msg = "Can't load GciFuncDrop of" library
      if IsRegina then
         msg = msg || ":" RxFuncErrMsg()
      say msg
      return 1
      end
   call RxFuncadd GciPrefixChar, "gci", "GciPrefixChar"
   call RxFuncadd GciBitness, "gci", "GciBitness"
   bitness = GciBitness()
   say "Your interpreter has no internal support of GCI"
   end
else
   bitness = 32 -- not (yet) supported
   say "Your interpreter has internal support of GCI"

say ""

/******************************************************************************
 * After the prelimnaries try to use the GCI.
 */
if system = "OS/2" then signal useOS2

say "Trying to copy string 'hello' to a string 'world' using the C library"
stem.calltype = cdecl
stem.0 = 2
stem.1.name = "Target"
stem.1.type = indirect string 80
stem.2.name = "Source"
stem.2.type = indirect string 80
stem.return.type = ""           /* We are not interested in the return value */

call funcDefine strcpy, CLib, "strcpy", stem

stem.1.name = "Target"
stem.1.value = "world"
stem.2.name = "Source"
stem.2.value = "hello"
call strcpy stem
say stem.1.name"="stem.1.value stem.2.name"="stem.2.value

call funcDrop strcpy
say ""
/******************************************************************************
 * Check if v1.1 GciPrefixChar works.
 */

version = 1.0
signal on syntax name v1.0
say "Trying to detect and use v1.1 features (same result as above expected)"
oldChar = GciPrefixChar('!')
signal on syntax
stem.!calltype = cdecl
stem.0 = 2
stem.1.!name = "Target"
stem.1.!type = indirect string 80
stem.2.!name = "Source"
stem.2.!type = indirect string 80
stem.!return.!type = ""

call funcDefine strcpy, CLib, "strcpy", stem

stem.1.!name = "Target"
stem.1.!value = "world"
stem.2.!name = "Source"
stem.2.!value = "hello"
call strcpy stem
say stem.1.!name"="stem.1.!value stem.2.name"="stem.2.!value

call funcDrop strcpy
say ""
call GciPrefixChar oldChar
drop oldChar c1 c2
version = 1.1
v1.0:
/******************************************************************************
 * Use the "as function" feature
 */
say "Trying to find the last occurcance of '.' in 'James F. Cooper' using the C"
say "library using the 'as function' feature"
stem.calltype = cdecl as function
stem.0 = 2
stem.1.name = "String"
stem.1.type = indirect string 80
stem.2.name = "Character"
stem.2.type = char
stem.return.type = indirect string 80

call funcDefine strrchr, CLib, "strrchr", stem

stem.1.name = "Target"
stem.1.value = "James F. Cooper"
stem.2.name = "Character"
stem.2.value = .
say "The last dot starts at '" || strrchr( stem ) || "'"
say ""
say "Trying to find the last occurcance of '.' in 'James Cooper' using the C lib"
say "We expect a NULL pointer which leads to a dropped value which becomes ''"
say "for a return value."

stem.1.name = "Target"
stem.1.value = "James Cooper"
say "The last dot starts at '" || strrchr( stem ) || "'"

call funcDrop strrchr
say ""
/******************************************************************************
 * Use the "with parameters as function" feature.
 * Note that you must omit "as function" if the return value doesn't exist.
 * We use separate functions for Windows and unix.
 */
if system = "WIN" then signal useWindows

say "Trying to use the math library to compute some natural logarithms"
stem.calltype = cdecl with parameters as function
stem.0 = 1
stem.1.name = "X"
stem.1.type = float 128
stem.return.type = float 128
say "Trying logl float 128"
call RxFuncDefine logl, MathLib, "logl", stem
if RESULT \= 0 then do
   stem.1.type = float 96
   stem.return.type = float 96
   say "Trying logl float 96"
   call RxFuncDefine logl, MathLib, "logl", stem
   end
if RESULT \= 0 then do
   stem.1.type = float 64
   stem.return.type = float 64
   say "Trying log float 64"
   call RxFuncDefine logl, MathLib, "log", stem
   end
if RESULT \= 0 then do
   if IsRegina & InternalGCI then
      say "Error, code" RESULT || ":" RxFuncErrMsg()
   else
      say "Error, code" RESULT || ":" GCI_RC
   return 1
   end

signal on syntax name ignore_log_error
say "some logarithms"
do i = 1 to 5
   say "log("i")="logl(i)
   end
ignore_log_error:
signal on syntax

call funcDrop logl
say ""
/*******************************/
say "Using a structure and checking the file system's size."
say "You may look into the source."
/*
 * This examples has removed all unnecessary stuff.
 */

/*
statvfs, statvfs64
http://people.redhat.com/berrange/notes/largefile.html
http://linux.die.net/man/2/statvfs
*/

/*
MacOs:
/usr/include/sys/_types/_types.h
typedef unsigned int	__darwin_fsblkcnt_t;	/* Used by statvfs and fstatvfs */

/usr/include/sys/_types/_fsblkcnt_t.h
typedef __darwin_fsblkcnt_t		fsblkcnt_t;         // JLF : 32-bit (unsigned int)

/usr/include/sys/statvfs.h
#include <sys/_types/_fsblkcnt_t.h>
struct statvfs {
	unsigned long	f_bsize;	/* File system block size */
	unsigned long	f_frsize;	/* Fundamental file system block size */
	fsblkcnt_t	f_blocks;	/* Blocks on FS in units of f_frsize */
	fsblkcnt_t	f_bfree;	/* Free blocks */
	fsblkcnt_t	f_bavail;	/* Blocks available to non-root */
	fsfilcnt_t	f_files;	/* Total inodes */
	fsfilcnt_t	f_ffree;	/* Free inodes */
	fsfilcnt_t	f_favail;	/* Free inodes for non-root */
	unsigned long	f_fsid;		/* Filesystem ID */
	unsigned long	f_flag;		/* Bit mask of values */
	unsigned long	f_namemax;	/* Max file name length */
};
*/

/*
Ubuntu:
/usr/include/bits/typesizes.h
/* X32 kernel interface is 64-bit.  */
#if defined __x86_64__ && defined __ILP32__
# define __SYSCALL_ULONG_TYPE	__UQUAD_TYPE        // JLF: 64-bit even if WORDSIZE==32
#else
# define __SYSCALL_ULONG_TYPE	__ULONGWORD_TYPE    // JLF: 64-bit
#endif
#define __FSBLKCNT_T_TYPE	__SYSCALL_ULONG_TYPE

/usr/include/bits/types.h
/* quad_t is also 64 bits.  */
#if __WORDSIZE == 64
typedef unsigned long int __u_quad_t;
#else
__extension__ typedef unsigned long long int __u_quad_t;
#endif
#define __ULONGWORD_TYPE	unsigned long int
/* We want __extension__ before typedef's that use nonstandard base types
   such as `long long' in C89 mode.  */
# define __STD_TYPE		__extension__ typedef
#if __WORDSIZE == 32
# define __UQUAD_TYPE		__u_quad_t
#elif __WORDSIZE == 64
# define __UQUAD_TYPE		unsigned long int
#include <bits/typesizes.h>	/* Defines __*_T_TYPE macros.  */
__STD_TYPE __FSBLKCNT_T_TYPE __fsblkcnt_t;
__STD_TYPE __SYSCALL_ULONG_TYPE __syscall_ulong_t;

/usr/include/sys/statvfs.h -> ../x86_64-linux-gnu/sys/statvfs.h
struct statvfs
  {
    unsigned long int f_bsize;
    unsigned long int f_frsize;
#ifndef __USE_FILE_OFFSET64
    __fsblkcnt_t f_blocks;      // JLF: 64-bit
    __fsblkcnt_t f_bfree;
    __fsblkcnt_t f_bavail;
    __fsfilcnt_t f_files;
    __fsfilcnt_t f_ffree;
    __fsfilcnt_t f_favail;
#else
    __fsblkcnt64_t f_blocks;    // JLF: 64-bit
    __fsblkcnt64_t f_bfree;
    __fsblkcnt64_t f_bavail;
    __fsfilcnt64_t f_files;
    __fsfilcnt64_t f_ffree;
    __fsfilcnt64_t f_favail;
#endif
    unsigned long int f_fsid;
#ifdef _STATVFSBUF_F_UNUSED
    int __f_unused;         // JLF defined when -m32
#endif
    unsigned long int f_flag;
    unsigned long int f_namemax;
    int __f_spare[6];
  };

#ifdef __USE_LARGEFILE64
struct statvfs64
  {
    unsigned long int f_bsize;
    unsigned long int f_frsize;
    __fsblkcnt64_t f_blocks;    // JLF: 64-bit
    __fsblkcnt64_t f_bfree;
    __fsblkcnt64_t f_bavail;
    __fsfilcnt64_t f_files;
    __fsfilcnt64_t f_ffree;
    __fsfilcnt64_t f_favail;
    unsigned long int f_fsid;
#ifdef _STATVFSBUF_F_UNUSED
    int __f_unused;
#endif
    unsigned long int f_flag;
    unsigned long int f_namemax;
    int __f_spare[6];
  };
#endif
*/

stem.calltype = cdecl as function
stem.0 = 2
stem.1.type = indirect string 256
stem.2.type = indirect container
stem.2.1.type    = ulong                      /* bsize */
stem.2.2.type    = ulong                      /* frsize */
stem.2.3.type    = unsigned 64                /* blocks */
stem.2.4.type    = unsigned 64                /* bfree */
stem.2.5.type    = unsigned 64                /* bavail */
stem.2.6.type    = unsigned 64                /* files */
stem.2.7.type    = unsigned 64                /* ffree */
stem.2.8.type    = unsigned 64                /* favail */
stem.2.9.type    = ulong                      /* fsid */
index = 10
if bitness == 32 then do
    stem.2.index.type = integer               /* unused */
    index = index + 1
end
stem.2.index.type   = ulong                   /* flag */
index = index + 1
stem.2.index.type   = ulong                   /* namemax */
index = index + 1
stem.2.index.type   = array                   /* spare[6] */
stem.2.index.0      = 6
stem.2.index.1.type = integer
stem.2.0 = index
stem.return.type = integer
say "Trying statvfs64"
call RxFuncDefine statvfs, CLib, "statvfs64", stem /* available under Ubuntu 14.04 */
if RESULT \= 0 then do
    stem.calltype = cdecl as function
    stem.0 = 2
    stem.1.type = indirect string256
    stem.2.type = indirect container
    stem.2.0 = 11
    stem.2.1.type    = ulong                  /* bsize */    /*mac,linux: unsigned long*/
    stem.2.2.type    = ulong                  /* frsize */   /*mac,linux: unsigned long*/
    stem.2.3.type    = unsigned               /* blocks */   /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.4.type    = unsigned               /* bfree */    /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.5.type    = unsigned               /* bavail */   /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.6.type    = unsigned               /* files */    /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.7.type    = unsigned               /* ffree */    /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.8.type    = unsigned               /* favail */   /*mac: unsigned int, ubuntu: unsigned long int*/
    stem.2.9.type    = ulong                  /* fsid */     /*mac,linux: unsigned long*/
    stem.2.10.type   = ulong                  /* flag */     /*mac,linux: unsigned long*/
    stem.2.11.type   = ulong                  /* namemax */  /*mac,linux: unsigned long*/
    index = 11
    stem.return.type = integer
    say "Trying statvfs"
    call funcDefine statvfs, CLib, "statvfs", stem /* available under MacOs & Linux */
end

args. = 0
args.1.value = source
args.2.value = index    /* otherwise the argument becomes NULL */
if statvfs( args ) \= -1 then do
   say "statvfs-info of" source
   say "File system block size (bsize) =" args.2.1.value "byte"
   say "Fundamental file system block size (frsize) =" args.2.2.value "byte"
   say "Blocks on FS in units of frsize (blocks)=" args.2.3.value
   say "Free blocks (bfree)=" args.2.4.value
   say "Blocks available to non-root (bavail)=" args.2.5.value
   size = trunc(args.2.3.value * args.2.2.value / (1024 * 1024))
   avail = trunc(args.2.5.value * args.2.2.value / (1024 * 1024))
   say "file system size =" size"MB, available =" avail"MB"
   say "file nodes =" args.2.6.value "available =" args.2.8.value
   say "sid =" args.2.9.value
   end
else
   say "Sorry, '"source"' not found."

call funcDrop statvfs
say ""
/*******************************/
say "We use qsort of the C library for sorting some strings using arrays."
/*
 * This examples has removed all unnecessary stuff.
 * We need a sorting routine. Without callbacks we have to use one of a
 * library. "strcmp" is a good example. We have to play with the dynamic
 * link loader.
 * The strategy is:
 * Load the loader functions (dlopen, dlsym, dlclose)
 * Load the compare routine (strcmp) using the loader functions
 * Load the sorting routine (qsort) and do the sort
 * Additional sort operations may have to redefine qsort only.
 */
stem.calltype = cdecl with parameters as function
stem.0 = 2
stem.1.type = indirect string 256
stem.2.type = integer
stem.return.type = pointer
call funcDefine dlopen, DlLib, "dlopen", stem

stem.calltype = cdecl with parameters as function
stem.0 = 2
stem.1.type = pointer            /* handle */
stem.2.type = indirect string 256
stem.return.type = pointer
call funcDefine dlsym, DlLib, "dlsym", stem

stem.calltype = cdecl with parameters as function
stem.0 = 1
stem.1.type = pointer            /* handle */
stem.return.type = integer
call funcDefine dlclose, DlLib, "dlclose", stem

CLibHandle = dlopen( CLib, 1 /* RTLD_LAZY */ )
if CLibHandle = 0 then do
   say "dlopen() can't load" CLib
   return 1
   end

strcmp = dlsym( CLibHandle, "strcmp" )
if strcmp = 0 then do
   say "dlsym() can't relocate strcmp()"
   return 1
   end

stem.calltype = cdecl
stem.0 = 4
stem.1.type = indirect array
stem.1.0 = 3
stem.1.1.type = string 95   /* JLF: it's not indirect ! so not a pointer */
stem.2.type = size_t
stem.3.type = size_t
stem.4.type = pointer
stem.return.type = ""
call funcDefine qsort10, CLib, "qsort", stem

args.0 = 4
args.1.value = 3
args.1.1.value = "Ann"
args.1.2.value = "Charles"
args.1.3.value = "Betty"
args.2.value = 3            /* JLF: 3 elements in the array */
args.3.value = 96           /* JLF: an element is a string of 95 characters + the final 0 */
args.4.value = strcmp
say "Sorting (" args.1.1.value args.1.2.value args.1.3.value ") ..."
call qsort10 args
say "Sorted values are (" args.1.1.value args.1.2.value args.1.3.value ")"

call dlclose CLibHandle
call funcDrop qsort
call funcDrop dlclose
call funcDrop dlsym
call funcDrop dlopen
say ""
call accessStructTm
return 0


/***************************************************/
useWindows:
stem.calltype = stdcall with parameters as function
stem.0 = 4
stem.1.name = "HWND"
stem.1.type = unsigned
stem.2.name = "Text"
stem.2.type = indirect string 1024
stem.3.name = "Caption"
stem.3.type = indirect string 1024
stem.4.name = "Type"
stem.4.type = unsigned
stem.return.type = integer

call funcDefine messagebox, "user32", "MessageBoxA", stem

MB_YESNO_INFO = x2d(44)
if messagebox( 0, "Do you love this rocking GCI?", "GCI", MB_YESNO_INFO ) = 6 then
   say "Yes, you're right, GCI is cool."
else
   say "No, you're kidding! GCI is cool."

call funcDrop messagebox
say ""
/*******************************/
say "We operate on containers and check this file's date."
say "You may look into the source."
/*
 * This examples has removed all unnecessary stuff.
 */
stem.calltype = stdcall as function
stem.0 = 2
stem.1.type = indirect string 256
stem.2.type = indirect container
stem.2.0 = 8                                 /* WIN32_FIND_DATA */
stem.2.1.type = unsigned                     /* FileAttributes */
stem.2.2.type = unsigned 64                   /* Creation */
stem.2.3.type = unsigned 64                   /* Access */
stem.2.4.type = unsigned 64                   /* Write */
stem.2.5.type = unsigned 64                   /* Size */
stem.2.6.type = unsigned 64                   /* Reserved */
stem.2.7.type = string 259                    /* FileName */
stem.2.8.type = string 13                     /* AlternateFileName */
stem.return.type = integer

stem2.calltype = stdcall with parameters
stem2.0 = 1
stem2.1.type = integer
stem2.return.type = ""

call funcDefine findfirstfile, "kernel32", "FindFirstFileA", stem

call funcDefine findclose, "kernel32", "FindClose", stem2

args. = 0
args.1.value = source
args.2.value = 8    /* otherwise the argument becomes NULL */
handle = findfirstfile( args )
if handle \= -1 then do
   say "argument's name="source
   say "filename="args.2.7.value
   say "8.3-name="args.2.8.value
   numeric digits 40
   filetime = args.2.4.value
   d = /*second*/ 1000*1000*10   *   /*seconds per day*/ 60*60*24
   daypart = trunc(filetime / d)
   date = date( 'N', daypart + date('B', 16010101, 'S'), 'B')
   ns = filetime - daypart * d
   secs = ns % (10*1000*1000)
   fract = ns // (10*1000*1000)
   time = time('N', secs, 'S') || "." || right(fract, 7, '0')
   say "ns from 1.1.1601="filetime "= GMT," date || "," time
   numeric digits 9
   call findclose handle
   end
else
   say "Sorry, '"source"' not found."

call funcDrop findfirstfile
call funcDrop findclose
say ""
call accessStructTm

return 0

/***************************************************/
accessStructTm: procedure expose IsRegina InternalGCI CLib version
if version < 1.1 then
   return
say "Finally, we use the LIKE keyword and check the number of the week."
say "You may look into the source, we use a PROCEDURE and v1.1 specific code."
/*
 * This examples has removed all unnecessary stuff.
 */
tm.0 = 10
tm.1.type = integer /* tm_sec */
tm.2.type = integer /* tm_min */
tm.3.type = integer /* tm_hour */
tm.4.type = integer /* tm_mday */
tm.5.type = integer /* tm_mon */
tm.6.type = integer /* tm_year */
tm.7.type = integer /* tm_wday */
tm.8.type = integer /* tm_yday */
tm.9.type = integer /* tm_isdst */
tm.10.type = string 32 /* reserved stuff sometimes used by the OS */

time_t.0 = 1
time_t.1.type = integer 64 /* SURPRISE! some systems may use 64 bit data types
                           * already. We don't have problems with this,
                           * because we use double buffering.
                           */

stem.calltype = cdecl
stem.0 = 1
stem.1.type = indirect container like time_t
stem.return.type = ""
call funcDefine _time, CLib, "time", stem

stem.calltype = cdecl
stem.0 = 1
stem.1.type = indirect container like time_t
stem.return.type = indirect container like tm
call funcDefine localtime, CLib, "localtime", stem

stem.calltype = cdecl
stem.0 = 4
stem.1.type = indirect string 256  /* dest */
stem.2.type = unsigned            /* size(dest) */
stem.3.type = indirect string 256  /* template */
stem.4.type = indirect container like tm
stem.return.type = unsigned
call funcDefine strftime, CLib, "strftime", stem

time_val.1.value = 1
time_val.1.1.value = 1
call _time time_val

lct.1.value = 1
lct.1.1.value = time_val.1.1.value
call localtime lct

strf.1.value = ""
strf.2.value = 256
strf.3.value = "%A"
strf.4.value = lct.return.value
do i = 1 to 10
   strf.4.i.value = lct.return.i.value
   end
call strftime strf
dayname = strf.1.value

strf.3.value = "%B"
call strftime strf
monthname = strf.1.value

strf.3.value = "%U"
call strftime strf
week!Sun = strf.1.value

strf.3.value = "%W"
call strftime strf
week!Mon = strf.1.value

if week!Mon = week!Sun then
   add = "."
else
   add = " if you count Monday as the first day of the week. Otherwise it " ||,
         "is the" week!Sun || ". week."
say "Today is a" dayname "in" monthname || ". We have the" week!Mon || ". week" || add
say
call funcDrop strftime
call funcDrop localtime
call funcDrop _time

return

/***************************************************/
useOS2:
say "Checking the high precision system timer."
stem.calltype = stdcall
stem.0 = 1
stem.1.name = "Frequency"
stem.1.type = indirect unsigned
stem.return.type = "unsigned"

call funcDefine DosTmrQueryFreq, "doscalls", "#362", stem

stem.1.name = "Frequency"
stem.1.value = 0        /* don't raise NOVALUE */

call DosTmrQueryFreq stem
if stem.return.value \= 0 then
   say "Error" stem.return.value "while using DosTmrQueryFreq."
else
   say "The timer has a frequency of" stem.1.value "Hz"

call funcDrop DosTmrQueryFreq
say ""
/*******************************/
say "You should hear your beeper."
/*
 * Use the "with parameters" feature.
 */
stem.calltype = stdcall with parameters
stem.0 = 2
stem.1.name = "Frequency"
stem.1.type = unsigned
stem.2.name = "Duration"
stem.2.type = unsigned
stem.return.type = ""           /* We are not interested in the return value */

call funcDefine DosBeep, "doscalls", "#286", stem

do i = 500 to 3000 by 100
   call DosBeep i, 10
   end

call funcDrop DosBeep
say ""
/*******************************/
say "Checking the installed codepages."
/*
 * Use the "as function" feature.
 */
stem.calltype = stdcall as function
stem.0 = 3
stem.1.name = "cb"
stem.1.type = unsigned
stem.2.name = "arCP"
stem.2.type = indirect array
stem.2.0 = 25
stem.2.1.type = unsigned
stem.3.name = "pcCP"
stem.3.type = indirect unsigned
stem.return.type = "unsigned"

call funcDefine DosQueryCp, "doscalls", "#291", stem

drop stem.
stem. = 0 /* NOVALUE should not happen */
stem.0 = 3
stem.1.name = "cb"
stem.1.value = 100
stem.2.name = "arCP"
stem.2.value = 25
stem.3.name = "pcCP"
if DosQueryCp( stem ) = 0 then do
   say "current codepage:" stem.2.1.value
   do i = 2 to stem.3.value / 4
      say "prepared codepage:" stem.2.i.value
      end
   end
else
   say "Error calling DosQueryCp."

call funcDrop DosQueryCp
say ""
/*******************************/
say "Examining the file system on" left( source, 2 )
/*
 * Use the "as function" feature.
 */
stem.calltype = stdcall as function
stem.0 = 4
stem.1.name = "disknum"
stem.1.type = unsigned
stem.2.name = "infolevel"
stem.2.type = unsigned
stem.3.name = "pBuf"
stem.3.type = indirect container
stem.3.0 = 5
stem.3.1.name = "idFileSystem"
stem.3.1.type = unsigned
stem.3.2.name = "cSectorUnit"
stem.3.2.type = unsigned
stem.3.3.name = "cUnit"
stem.3.3.type = unsigned
stem.3.4.name = "cUnitAvail"
stem.3.4.type = unsigned
stem.3.5.name = "cbSector"
stem.3.5.type = unsigned 16
stem.4.name = "cbBuf"
stem.4.type = unsigned
stem.return.type = "unsigned"

call funcDefine DosQueryFSInfo, "doscalls", "#278", stem

drop stem.
stem. = 0 /* NOVALUE should not happen */
stem.0 = 3
stem.1.name = "disknum"
stem.1.value = c2d( translate( left( source, 1 ) ) ) - c2d( 'A' ) + 1
stem.2.name = "infolevel"
stem.2.value = 1
stem.3.name = "pBuf"
stem.3.value = 5
stem.4.name = "cbBuf"
stem.4.value = 18
if DosQueryFSInfo( stem ) = 0 then do
   cluster = stem.3.2.value * stem.3.5.value
   say "Total size:" showFileSize( cluster*stem.3.3.value )
   say "Free  size:" showFileSize( cluster*stem.3.4.value )
   end
else
   say "Error calling DosQueryFSInfo."

call funcDrop DosQueryFSInfo
say ""
return 0

/*****/
showFileSize: procedure
   suffix = "byte"
   size = arg(1)
   suffixes = "KB MB GB TB"
   do i = 1 to words( suffixes )
      if size < 1024 then
         leave
      suffix = word( suffixes, i )
      size = size / 1024
      end
   if size >= 100 then
      size = format( size, , 0 )
   else if size >= 10 then
      size = format( size, , 1 )
   else
      size = format( size, , 2 )
   return size suffix

/*****************************************************************************/
syntax:
   /*
    * Not all interpreters are ANSI compatible.
    */
   code = .MN
   if code = '.MN' then
      code = RC
   if datatype( SIGL_FUNCDEFINE, "W" ) then
      SIGL = SIGL_FUNCDEFINE
   say "Error" code "in line" SIGL || ":" condition('D')
   say "GCI_RC=" || GCI_RC
   exit 0

/*****************************************************************************/
funcDrop:
   /*
    * Drops one defined function depending on whether is is defined in the
    * lightweight library or in the interpreter's kernel.
    */
   if InternalGCI then
      call RxFuncDrop arg(1)
   else
      call GciFuncDrop arg(1)
   return

/*****************************************************************************/
funcDefine:
   /*
    * Defines a new subroutine as RxFuncDefine does, additionally it undefines
    * (drops) the subroutine in front and it shows the error messages.
    * Finally it terminates the process is an error occurs.
    */
   _SIGL_FUNCDEFINE = SIGL
   call funcDrop arg(1)
   drop GCI_RC
   SIGL_FUNCDEFINE = _SIGL_FUNCDEFINE
   call RxFuncDefine arg(1), arg(2), arg(3), arg(4)
   drop SIGL_FUNCDEFINE _SIGL_FUNCDEFINE
   if RESULT = 0 then
      return
   if IsRegina & InternalGCI then
      errAdd = ":" RxFuncErrMsg()
   else do
      if GCI_RC \= "GCI_RC" then
         errAdd = ":" GCI_RC
      else
         errAdd = ""
      end
   say "Error defining '" || arg(1) || "', code" RESULT || errAdd

   exit 1

