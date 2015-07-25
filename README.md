Builder
=======

Scripts to support builds for several branches, configurations, bitness

Directory hierarchy part 1 (overview)
-------------------------------------

Under MacOs, which is the main machine (host of the virtual machines):

    /local/rexx/oorexx/         (replace by your own path)
        build/                  where all the builds and deliveries are done.
        executor/               git sources (clone of official/sandbox/jlf)
        executor5/              git sources (clone of official/main/trunk)
        official                svn sources of ooRexx

Inside the virtual machines (one for Ubuntu, one for Windows), two main paths are used:

    /local/rexx/oorexx          Shared directory: NFS mount for Ubuntu, SMB mount for Windows (replace by your own path)
        executor/               git sources (clone of official/sandbox/jlf)
        executor5/              git sources (clone of official/main/trunk)
        official                svn sources of ooRexx
    /local/rexxlocal/oorexx     Local directory (replace by your own path)
        build/                  where all the builds and deliveries are done.

Because of bad access time to the shared drive when building from a VM, the build directory is put inside the VM.


Getting the svn sources of ooRexx (optional)
--------------------------------------------

To get everything (1,3Gb : trunk, all releases, doc, test, sandbox).

    cd /local/rexx/oorexx
    svn checkout svn://svn.code.sf.net/p/oorexx/code-0 official

You can checkout only subsets.  
In this case each subset will have its own .svn repository to manage separately.

To get only the main trunk of the interpreter sources (25Mb):

    cd /local/rexx/oorexx
    svn checkout svn://svn.code.sf.net/p/oorexx/code-0/main/trunk official/main/trunk
    svn checkout svn://svn.code.sf.net/p/oorexx/code-0/build-utilities official/build-utilities

To get only the main trunk of the documentation (24Mb):

    cd /local/rexx/oorexx
    svn checkout svn://svn.code.sf.net/p/oorexx/code-0/docs/trunk official/docs/trunk

To get only the test framework (7Mb):

    cd /local/rexx/oorexx
    svn checkout svn://svn.code.sf.net/p/oorexx/code-0/test/trunk official/test/trunk


Getting the git sources of executor (optional)
----------------------------------------------

    cd /local/rexx/oorexx
    git clone https://github.com/jlfaucher/executor.git


### MacOs & Linux

From the directory official/incubator, reference some subdirectories in executor:

    mv ooRexxShell ooRexxShell.svn
    ln -s ../../executor/incubator/ooRexxShell ooRexxShell
    mv DocMusings DocMusings.svn
    ln -s ../../executor/incubator/DocMusings DocMusings

Replace the directory official/sandbox/jlf by a symbolic link to executor/sandbox/jlf

    mv jlf jlf.svn
    ln -s ../../executor/sandbox/jlf jlf


### Windows

From the directory official\incubator, reference some subdirectories in executor:

    move ooRexxShell ooRexxShell.svn
    mklink /d ooRexxShell ..\..\executor\incubator\ooRexxShell
    move DocMusings DocMusings.svn
    mklink /d DocMusings ..\..\executor\incubator\DocMusings

Replace the directory official/sandbox/jlf by a symbolic link to executor/sandbox/jlf

    move jlf jlf.svn
    mklink /d jlf ..\..\executor\sandbox\jlf

Getting the git sources of executor5 (optional)
-----------------------------------------------

    cd /local/rexx/oorexx
    git clone https://github.com/jlfaucher/executor5.git executor5/main/trunk


Getting the git sources of the builder scripts
----------------------------------------------

Can be located anywhere

    cd /local
    git clone https://github.com/jlfaucher/builder.git


For convenience, a symbolic link to /local/builder/scripts can be created from each project which follows the build hiearchy described in this document.

    # ooRexx
    cd /local/rexx/oorex
    ln -s /local/builder/scripts .

    # Regina (not covered by this document)
    cd /local/rexx/regina
    ln -s /local/builder/scripts .


CHANGE THAT MUST BE APPLIED
---------------------------
To official/main/trunk/CMakeLists.txt

WITHOUT THIS CHANGE, IT'S IMPOSSIBLE TO MANAGE SEVERAL DELIVERIES IN DIFFERENT INSTALL DIRECTORIES (under MacOs & Linux).  
OTHER PROBLEM : UNDER MACOS, THE DETECTION OF THE LIB DIRECTORY DOES NOT WORK.

    Changes to apply to
    main/trunk/CMakeLists.txt

    --- CMakeLists.txt	(revision 10943)
    +++ CMakeLists.txt	(working copy)
    @@ -190,7 +190,10 @@
        ENDMACRO ()

     else ()
    -   set (CMAKE_INSTALL_PREFIX /usr)
    +   if (NOT DEFINED CMAKE_INSTALL_PREFIX)
    +      set (CMAKE_INSTALL_PREFIX "/usr")
    +   endif ()
    +
        set (catdir ${CMAKE_INSTALL_PREFIX}/bin)
        set (INSTALL_EXECUTABLE_DIR ${CMAKE_INSTALL_PREFIX}/bin)
        set (INSTALL_CLS_DIR ${CMAKE_INSTALL_PREFIX}/bin)
    @@ -198,6 +201,9 @@
        set (INSTALL_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include)
        set (INSTALL_SAMPLES_DIR ${CMAKE_INSTALL_PREFIX}/share/${CMAKE_PROJECT_NAME})
        find_path(INSTALL_LIB_DIR libc.so PATHS ${CMAKE_INSTALL_PREFIX}/lib/* ${CMAKE_INSTALL_PREFIX}/lib64)
    +   if (${INSTALL_LIB_DIR} STREQUAL "INSTALL_LIB_DIR-NOTFOUND")
    +      set (INSTALL_LIB_DIR ${CMAKE_INSTALL_PREFIX}/lib)
    +   endif ()
        set (INSTALL_MAN_DIR ${CMAKE_INSTALL_PREFIX}/share/man)
     endif ()


MacOs & Ubuntu build
--------------------

    # MacOs:  shared dir=/local/rexx/oorexx, local_dir=/local/rexx/oorexx
    # Ubuntu: shared_dir=/local/rexx/oorexx, local_dir=/local/rexxlocal/oorexx

### New build system (cmake)
Build the release configuration of ooRexx official/main/trunk:

    # MacOs
    cd /local/rexx/oorexx
    . scripts/setenv build/official/main/trunk/macos/clang/release/64/
    # Ubuntu
    cd /local/rexxlocal/oorexx
    . scripts/setenv /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/
    # MacOs & Ubuntu
    . scripts/setenv build/official/main/trunk/macos/clang/release/64/
    cdbuild
    cmake -DCMAKE_BUILD_TYPE=$DCMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$oorexx_delivery_dir $oorexx_src_dir
    make install


### Old build system (configure)
Build the release configuration of executor master branch:

    # MacOs
    cd /local/rexx/oorexx
    . scripts/setenv build/executor.master/sandbox/jlf/trunk/macos/clang/release/64/
    # Ubuntu
    cd /local/rexx/oorexx
    . scripts/setenv /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/
    # MacOs & Ubuntu
    . scripts/setenv build/executor.master/sandbox/jlf/trunk/macos/clang/release/64/
    cdbuild
    $oorexx_src_dir/configure --prefix=$oorexx_delivery_dir --disable-static
    make install


Windows build
-------------

### New build system (cmake)
Build the release configuration of ooRexx official/main/trunk:

    :: Local directory in the virtual machine for Windows
    e:
    cd \local\rexxlocal\oorexx
    :: Shared directory
    y:
    cd \local\rexx\oorexx
    call scripts\setenv e:build\official\main\trunk\win\cl\release\64
    cdbuild
    cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%builder_delivery_dir% -DDOC_SOURCE_DIR=%oorexx_doc_dir%\build\trunk %builder_src_dir%
    nmake install
    nmake nsis_template_installer


### Old build system (configure) + adaptations
Build the release configuration of executor master branch:

    :: Local directory in the virtual machine for Windows
    e:
    cd \local\rexxlocal\oorexx
    :: Shared directory
    y:
    cd \local\rexx\oorexx
    call scripts\setenv e:build\executor.master\sandbox\jlf\trunk\win\cl\release\64
    cdtrunk
    makeorx NODEBUG


Directory hierarchy part 2 (all targets)
----------------------------------------

### build/executor (git clone of official/sandbox/jlf)

5 git branches:

    build/executor.block_closure/sandbox/jlf/trunk
    build/executor.master/sandbox/jlf/trunk
    build/executor.merge_svn_main/sandbox/jlf/trunk
    build/executor.operators/sandbox/jlf/trunk
    build/executor.pipeline/sandbox/jlf/trunk


### build/executor5 (git clone of official/main/trunk)

1 git branch:

    build/executor5.master/main/trunk


### build/official (svn main/trunk)

8 svn branches :

    build/official/main/releases/3.1.2/trunk
    build/official/main/releases/3.2.0/trunk
    build/official/main/releases/4.0.0/trunk
    build/official/main/releases/4.0.1/trunk
    build/official/main/releases/4.1.0/trunk
    build/official/main/releases/4.1.1/trunk
    build/official/main/releases/4.2.0/trunk
    build/official/main/trunk

### Common structure of all builds under trunk : system/compiler/config/bitness

    macos/clang/debug/32
    macos/clang/debug/64
    macos/clang/reldbg/32
    macos/clang/reldbg/64
    macos/clang/release/32
    macos/clang/release/64

    ubuntu/gcc/debug/32
    ubuntu/gcc/debug/64
    ubuntu/gcc/profiling/32
    ubuntu/gcc/profiling/64
    ubuntu/gcc/reldbg/32
    ubuntu/gcc/reldbg/64
    ubuntu/gcc/release/32
    ubuntu/gcc/release/64

    win/cl/debug/32
    win/cl/debug/64
    win/cl/reldbg/32
    win/cl/reldbg/64
    win/cl/release/32
    win/cl/release/64


Builder scripts
---------------

Each directory in the build path can have a corresponding script.  
The scripts/setenv script iterates over each directory, from deeper to root.  
If a script named setenv-"directory" exists in the directory of scripts then execute it.  
If a script named setenv-"directory" exists in the directory of private scripts then execute it.  

Example:

    /local/rexxlocal/oorexx/build/official/main/trunk/ubuntu/gcc/release/64/
    Scripts currently defined :
    |  setenv-64
    |  setenv-release
    |  setenv-build
    V  setenv-oorexx


    Variables set by scripts/setenv (values for ubuntu):
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


Technical infos
---------------

### MacOs NFS share

    MacOs /etc/exports
    /Local -mapall=502          where 502 is the uid displayed by the command id.

    Ubuntu fstab: jlfaucher.local:/local	/host/local	nfs	defaults	0	0

### MacOs SMB share

    MacOs : menu System Preferences, then Sharing
    Options : activate SMB, deactivate AFP
    Activate file sharing and add /Local1 to the list

### Windows SMB client
(replace Y: by your letter drive)
(replace Z: by your letter drive)

    net use
     Y:        \\jlfaucher.local\Local1         Microsoft Windows Network
     Z:        \\vmware-host\Shared Folders     VMware Shared Folders

Must mount Local1 (exported by MacOs) which contains this symbolic link to have the directory 'Local' under Y:

    /Local
    /Local1
        Local@ -> /Local

See [Configure smbd to follow symbolic links][configure-smbd-to-follow-symbolic-links].  
Adding no-symlinks as a program argument in smbd's launchdaemon plist did the trick.  
The file sharing services do need a restart after changing the file.

    /System/Library/LaunchDaemons/com.apple.smbd.plist
    <array>
            <string>/usr/sbin/smbd</string>
            <string>-no-symlinks</string>
    </array>


[configure-smbd-to-follow-symbolic-links]: http://superuser.com/questions/555715/mac-os-x-10-8-configure-smbd-to-follow-symbolic-links "Configure smbd to follow symbolic links"
