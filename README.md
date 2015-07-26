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
    builder_bitness:            64
    builder_branch:
    builder_build_dir           /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/build
    builder_compiler:           gcc
    builder_config:             release
    builder_config_dir:         /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64
    builder_delivery_dir:       /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/deliver
    builder_local_build_dir:    /local/rexxlocal/oorexx/build
    builder_local_dir:          /local/rexxlocal/oorexx
    builder_scripts_dir:        /local/builder/scripts
    builder_shared_dir:         /local/rexx/oorexx
    builder_src_relative_path:  main/trunk
    builder_system:             ubuntu
    builder_target:             official
    builder_target_branch:      official
