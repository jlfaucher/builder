Builder
=======

Scripts to support builds for several branches, configurations, bitness.  
Works only with bash (MacOS & Linux) or cmd (Windows).

Usage :

    cd <sources root> # will define $builder_shared_dir
    . <builder path>scripts/setenv <build path>  # will define $builder_config_dir

where  
\<sources root\> is the root directory of the sources.  
\<build path\> is <[path]target[.branch]/d1/d2/.../system-arch/compiler/config>  

For real examples, see:

- [Build Executor][build_executor] (instructions to build Executor from scratch)
- [Build ooRexx][build_oorexx] (the infrastructure I use for Official trunk/releases/branches, Executor)
- [Build Regina][build_regina]


Builder scripts
---------------

Each directory in the build path can have a corresponding script.  
The scripts/setenv script iterates over each directory, from deeper to root.  
If a script named setenv-"directory" exists in the directory of scripts then execute it.  
If a script named setenv-"directory" exists in the directory of private scripts then execute it.  

    /local/rexxlocal/oorexx/build/official/main/trunk/linux-x86_64/gcc/release/
    Scripts currently defined :
    |  setenv-release
    |  setenv-build
    V  setenv-oorexx


    Examples of variables defined by scripts/setenv (values for linux):
    builder_arch                x86_64
    builder_bitness             64
    builder_branch
    builder_build_dir           /local/rexxlocal/oorexx/build/official/main/trunk/linux-x86_64/gcc/release/build
    builder_compiler            gcc
    builder_config              release
    builder_config_dir          /local/rexxlocal/oorexx/build/official/main/trunk/linux-x86_64/gcc/release
    builder_delivery_dir        /local/rexxlocal/oorexx/build/official/main/trunk/linux-x86_64/gcc/release/deliver
    builder_local_build_dir     /local/rexxlocal/oorexx/build
    builder_local_dir           /local/rexxlocal/oorexx
    builder_scripts_dir         /local/builder/scripts
    builder_shared_dir          /local/rexx/oorexx
    builder_src_relative_path   main/trunk
    builder_system              linux
    builder_system_arch         linux-x86_64
    builder_target              official
    builder_target_branch       official

    Variables defined for building with cmake:
    CMAKE_BUILD_TYPE            Debug or Reldbg or Release
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
    ooRexx 4.2      ko (5)          ko (4)          ko (6)          ko (6)
    ooRexx 5        ok              ko (4)          ok              ok
    Regina          ko (7)          ko (4)          ko (8)          ok


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
        LINK : fatal error LNK1104: cannot open file 'LIBCMT.lib'
    (5) nmake
        LNK1112: module machine type 'ARM64' conflicts with target machine type 'x64'
    (6) nmake
        interpreter\platform\windows\SysInterpreterInstance.cpp(116): error C2039: '_file': is not a member of '_iobuf'
    (7) nmake
        LINK : fatal error LNK1104: cannot open file 'Y:\local\rexx\regina\official\interpreter\trunk\regina_arm64_dll.def'
        mt_winarm64.ts.obj : error LNK2005: tsds already defined in mt_win64.ts.obj
        mt_winarm64.ts.obj : error LNK2005: __regina_ReginaSetMutex already defined in mt_win64.ts.obj
    (8) rexx
        build done, but runtime error "Side by side configuration is incorrect"


Adaptations
-----------

To build older branches or versions (e.g., 4.2.0), some [adaptations][adaptations]
must be applied.


[build_executor]: build-executor.txt "Build Executor"
[build_oorexx]: build-oorexx.txt "Build ooRexx"
[build_regina]: build-regina.txt "Build Regina"
[adaptations]: adaptations "adaptations"
