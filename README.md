Builder
=======

Scripts to manage builds for multiple branches, configurations and architectures (32 or 64 bits).  
Works only with `bash` (MacOS & Linux) or `cmd` (Windows).

Usage:

    cd <sources_root>                            # will define $builder_shared_dir
    . <builder_path>/scripts/setenv <build_path> # will define $builder_config_dir

where  
`<sources_root>` is the root directory of the sources.  
`<build_path>` is `<[path]target[.branch]/d1/d2/.../system-arch/compiler/config>`  

For real examples, see:

- [Build Executor][build_executor] (instructions to build Executor from scratch)
- [Build ooRexx][build_oorexx] (the infrastructure I use for Official trunk/releases/branches, Executor)
- [Build Regina][build_regina]

To build older branches or versions of ooRexx (e.g., 4.2.0), some [adaptations][adaptations]
must be applied.


Builder scripts
---------------

Each directory in the `<build_path>` value can have a corresponding script.  
The script `<builder_path>/scripts/setenv` traverses each directory, from the parent of the current directory to the root.

- If a script named `setenv-<directory>` exists in the directory of public scripts then execute it.
- If a script named `setenv-<directory>-<system-arch>-<computername>` exists in the directory of private scripts then execute it.
- If a script named `setenv-<directory>-<computername>` exists in the directory of private scripts then execute it.

Illustration with ooRexx for Ubuntu ARM 64-bit:
```
    /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-aarch64/gcc/release/build
    |  setenv                   (launched manually from the build directory)
    |  setenv-release
    |  setenv-gcc
    |  setenv-ubuntu-aarch64
    |  setenv-build
    |  setenv-oorexx            private: setenv-oorexx-ubuntu-aarch64-jlfaucher-mbp2021-winvm
    V  setenv-rexxlocal
```

Public scripts currently defined:
```
    setenv
    setenv-debug OR -profiling OR -reldbg[-O2] OR -release[-O2] OR -detect_UB
    setenv-cl OR -clang OR -gcc
    setenv-macos-arm64 OR -macos-x86_64 OR -ubuntu-aarch64 OR -ubuntu-x86_64 OR -windows-arm32.bat OR -windows-arm64.bat OR -windows-x86_32.bat OR -windows-x86_64.bat
    setenv-executor.master
    setenv-build
    setenv-gnuCobol OR -oorexx OR -regina
    setenv-cobol OR -rexx OR -rexxlocal
```

[Private scripts][private_scripts] are, by design, private to a specific computer.  
These files will not be used on your computer, as their names contain my computer's name.  
It is up to you to define your own private scripts, if necessary.


List of defined variables
-------------------------

Variables defined by <builder_path>/scripts/setenv (values for Linux):
    
    Variables defined for general use:
    builder_arch                x86_64
    builder_bitness             64
    builder_branch
    builder_build_dir           /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-x86_64/gcc/release/build
    builder_compiler            gcc
    builder_config              release
    builder_config_dir          /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-x86_64/gcc/release
    builder_delivery_dir        /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-x86_64/gcc/release/deliver
    builder_dir                 /local/rexx/builder
    builder_hostname            < output of hostname -s > or < output of hostname > or < value of %COMPUTERNAME% >
    builder_local_build_dir     /local/rexxlocal/oorexx/build
    builder_local_dir           /local/rexxlocal/oorexx
    builder_scripts_dir         /local/builder/scripts
    builder_shared_dir          /local/rexx/oorexx
    builder_src_dir             /local/rexx/oorexx/main/trunk
    builder_src_relative_path   main/trunk
    builder_system              ubuntu
    builder_system_arch         ubuntu-x86_64
    builder_target              official
    builder_target_branch       official

    Variables that can be set in setenv-detect_UB:
    builder_detect_UB=1
    builder_sanitize=0
    builder_LTO=0
    See setenv-clang for the impact of these variables.
    setenv-gcc and setenv-cl not yet adapted to support these variables.

    Variables defined for building with cmake:
    CMAKE_BUILD_TYPE            Debug or RelWithDebInfo or Release
    CMAKE_C_COMPILER            gcc or clang or cl
    CMAKE_CXX_COMPILER          g++ or clang++ or cl
    CMAKE_GENERATOR             "Unix Makefiles" or "NMake Makefiles"

    Variables defined for building with configure:
    CONFIGURE_C_COMPILER        gcc or clang
    CONFIGURE_CXX_COMPILER      g++ or clang++

    Variables defined for building with gcc or clang:
    C_INCLUDE_PATH              List of directories in which to look for header files when preprocessing C files
    CPLUS_INCLUDE_PATH          List of directories in which to look for header files when preprocessing C++ files
    LIBRARY_PATH                List of directories in which to look for libraries when linking

    Variables defined for default make rules (see the output of make -p):
    CXXFLAGS                    Flags for the C++ compiler
    CFLAGS                      Flags for the C compiler
    CPPFLAGS                    Flags for the preprocessor
    LDFLAGS                     Flags for the linker

    Variables defined for building with cl (Visual C++):
    INCLUDE                     List of directories in which to look for header files when preprocessing files
    LIB                         List of directories in which to look for libraries when linking

    Variables defined for default nmake rules (see the output of nmake /p):
    CXXFLAGS                    Flags used when compiling .cxx files
    CFLAGS                      Flags used when compiling .c or .cc files
    CPPFLAGS                    Flags used when compiling .cpp files

    Variables defined for execution:
    DYLD_LIBRARY_PATH           MacOsX
    LD_LIBRARY_PATH             Linux
    PATH                        Linux, MacOsX, Windows


Supported architectures 
-----------------------

    macOS ARM
                    macos-arm64     macos-x86_64
                    clang           clang
    executor        ok              ok (dual)
    ooRexx 4.2      ok              ok
    ooRexx 5        ok              ok (dual)
    Regina          ok              ok


    Windows 11 ARM WSL
                    ubuntu-aarch64  ubuntu-aarch64  ubuntu-x86_64
                    gcc             clang           gcc / clang
    executor        ko (1)          ok              todo
    ooRexx 4.2      ko (2)          ko (2)          todo
    ooRexx 5        ok              ok              todo
    Regina          ok              ko (3)          todo


    Windows 11 ARM
                    windows-arm64   windows-arm32   windows-x86_64  windows-x86_32
    executor        ok              ko (4)          ok              ok
    ooRexx 4.2      ok              ko (4)          ok              ok
    ooRexx 5        ok              ko (4)          ok              ok
    Regina          ko (5)          ko (4)          ko (6)          ok


    Other platforms: not tested.


    (1) rexximage
        Segmentation fault
    (2) bootstrap
        autom4te: error: setting mode of ./dGZf_vUF2Q: Operation not permitted
        Workaround: run ./bootstrap from macOS (shared sources)
    (2) make
        /usr/include/c++/11/bits/stl_iterator.h:2480:26: error: ‘remove_const_t’ does not name a type
        /usr/include/c++/11/bits/stl_iterator.h:2492:10: error: ‘add_const_t’ was not declared in this scope
        /usr/include/c++/11/bits/stl_iterator.h:2492:22: error: ‘__iter_key_t’ was not declared in this scope; did you mean ‘__iter_val_t’?
    (3) make
        cc: error: unrecognized command-line option ‘-m64’
    (4) nmake
        LINK: fatal error LNK1104: cannot open file 'LIBCMT.lib'
    (5) nmake
        LINK: fatal error LNK1104: cannot open file 'Y:\local\rexx\regina\official\interpreter\trunk\regina_arm64_dll.def'
        mt_winarm64.ts.obj: error LNK2005: tsds already defined in mt_win64.ts.obj
        mt_winarm64.ts.obj: error LNK2005: __regina_ReginaSetMutex already defined in mt_win64.ts.obj
    (6) rexx
        build done, but runtime error "Side by side configuration is incorrect"


Examples of builds
------------------

### Cobol
```
    <sources_root>, $builder_shared_dir
    local/cobol/gnuCobol
    
    <build_path>, $builder_build_dir
    local/cobol/gnuCobol/build/official/trunk/macos-arm64/clang/release/build
    
    $builder_src_dir
    local/cobol/gnuCobol/official/trunk
```

### ooRexx family
```
    <sources_root>, $builder_shared_dir
    local/rexx/oorexx
```

#### Executor
```
    <build_path>, $builder_build_dir
    ---
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-arm64/clang/debug/build
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-arm64/clang/reldbg/build
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-arm64/clang/release/build
    ---
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-x86_64/clang/debug/build
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-x86_64/clang/reldbg/build
    local/rexx/oorexx/build/executor.master/sandbox/jlf/trunk/macos-x86_64/clang/release/build
    
    $builder_src_dir
    local/rexx/oorexx/executor/sandbox/jlf/trunk
```

#### ooRexx 4.2
```    
    <build_path>, $builder_build_dir
    ---
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-arm64/clang/debug/build
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-arm64/clang/reldbg/build
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-arm64/clang/release/build
    ---
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-x86_64/clang/debug/build
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-x86_64/clang/reldbg/build
    local/rexx/oorexx/build/official/main/releases/4.2.0/trunk/macos-x86_64/clang/release/build
    
    $builder_src_dir
    local/rexx/oorexx/official/main/releases/4.2.0/trunk
```

#### ooRexx
``` 
    <build_path>, $builder_build_dir
    ---
    local/rexx/oorexx/build/official/main/trunk/macos-arm64/clang/debug/build
    local/rexx/oorexx/build/official/main/trunk/macos-arm64/clang/reldbg/build
    local/rexx/oorexx/build/official/main/trunk/macos-arm64/clang/release/build
    ---
    local/rexx/oorexx/build/official/main/trunk/macos-x86_64/clang/debug/build
    local/rexx/oorexx/build/official/main/trunk/macos-x86_64/clang/reldbg/build
    local/rexx/oorexx/build/official/main/trunk/macos-x86_64/clang/release/build
    ---
    local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-aarch64/gcc/release
    local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-aarch64/gcc/release-O2
    local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-aarch64/clang/release
    local/rexxlocal/oorexx/build/official/main/trunk/ubuntu-aarch64/clang/release-O2
    ---
    local\rexxlocal\oorexx\build\official\main\trunk\windows-arm64\cl\debug\build
    local\rexxlocal\oorexx\build\official\main\trunk\windows-arm64\cl\release\build
    ---
    local\rexxlocal\oorexx\build\official\main\trunk\windows-x86_32\cl\debug\build
    local\rexxlocal\oorexx\build\official\main\trunk\windows-x86_32\cl\release\build
    ---
    local\rexxlocal\oorexx\build\official\main\trunk\windows-x86_64\cl\debug\build
    local\rexxlocal\oorexx\build\official\main\trunk\windows-x86_64\cl\release\build

    $builder_src_dir
    local/rexx/oorexx/official/main/trunk
```

### Regina
```
    <sources_root>, $builder_shared_dir
    local/rexx/regina
    
    <build_path>, $builder_build_dir
    ---
    local/rexx/regina/build/official/interpreter/trunk/macos-arm64/clang/debug/build
    local/rexx/regina/build/official/interpreter/trunk/macos-arm64/clang/release/build
    ---
    local/rexx/regina/build/official/interpreter/trunk/macos-x86_64/clang/debug/build
    local/rexx/regina/build/official/interpreter/trunk/macos-x86_64/clang/release/build
    
    $builder_src_dir
    local/rexx/regina/official/interpreter/trunk
```

[adaptations]: adaptations "adaptations"
[build_executor]: build-executor.txt "Build Executor"
[build_oorexx]: build-oorexx.txt "Build ooRexx"
[build_regina]: build-regina.txt "Build Regina"
[private_scripts]: scripts.private
