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
[build_oorexx]: https://github.com/jlfaucher/builder/blob/master/build-oorexx.txt "Build ooRexx"
[build_regina]: https://github.com/jlfaucher/builder/blob/master/build-regina.txt "Build Regina"
