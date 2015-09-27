Builder
=======

Scripts to support builds for several branches, configurations, bitness.

Usage :

    cd <sources root> # will define $builder_shared_dir
    . <builder path>scripts/setenv <build path>  # will define $builder_config_dir

where  
\<sources root\> is the root directory of the sources.  
\<build path\> is <[path]target[.branch]/d1/d2/.../system/compiler/config/bitness>  

For real examples, see:

- [Build ooRexx][build_oorexx]
- [Build Regina][build_regina]


Builder scripts
---------------

Each directory in the build path can have a corresponding script.  
The scripts/setenv script iterates over each directory, from deeper to root.  
If a script named setenv-"directory" exists in the directory of scripts then execute it.  
If a script named setenv-"directory" exists in the directory of private scripts then execute it.  

    /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/
    Scripts currently defined :
    |  setenv-64
    |  setenv-release
    |  setenv-build
    V  setenv-oorexx


    Examples of variables set by scripts/setenv (values for ubuntu):
    builder_bitness             64
    builder_branch
    builder_build_dir           /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/build
    builder_compiler            gcc
    builder_config              release
    builder_config_dir          /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64
    builder_delivery_dir        /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/deliver
    builder_local_build_dir     /local/rexxlocal/oorexx/build
    builder_local_dir           /local/rexxlocal/oorexx
    builder_scripts_dir         /local/builder/scripts
    builder_shared_dir          /local/rexx/oorexx
    builder_src_relative_path   main/trunk
    builder_system              ubuntu
    builder_target              official
    builder_target_branch       official

    Variables set for building with cmake:
    CMAKE_BUILD_TYPE            Debug or Reldbg or Release

    Variables set for building with gcc or clang:
    C_INCLUDE_PATH              List of directories in which to look for header files when preprocessing C files
    CPLUS_INCLUDE_PATH          List of directories in which to look for header files when preprocessing C++ files
    CXXFLAGS                    Flags for the C++ compiler
    CFLAGS                      Flags for the C compiler
    CPPFLAGS                    Flags for the preprocessor
    LDFLAGS                     Flags for the linker
    LIBRARY_PATH                List of directories in which to look for libraries when linking

    Variables set for building with Visual C++:
    INCLUDE                     List of directories in which to look for header files when preprocessing files
    LIB                         List of directories in which to look for libraries when linking

    Variables set for execution:
    DYLD_LIBRARY_PATH           MacOsX
    LD_LIBRARY_PATH             Linux
    PATH                        Linux, MacOsX, Windows


[configure-smbd-to-follow-symbolic-links]: http://superuser.com/questions/555715/mac-os-x-10-8-configure-smbd-to-follow-symbolic-links "Configure smbd to follow symbolic links"
[build_oorexx]: https://github.com/jlfaucher/builder/blob/master/build-oorexx.txt "Build ooRexx"
[build_regina]: https://github.com/jlfaucher/builder/blob/master/build-regina.txt "Build Regina"
