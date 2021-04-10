Adaptation
==========

This directory contains adaptations of

- BSF4OORexx
- GCI
- ooRexx (old branches, old releases)

to let build with the builder.

The files in the subdirectories are either new files or existing files that have
been adaptated for some reasons.

You can copy manually these files or you can execute the script create_links which
will create hard links (you may need to adapt the paths at the beginning of the script).  
This script can be re-executed as much as you want.

- create_links.bat  (for Windows)
- create_links.sh   (for Linux/MacOs)

By default, the actions are not executed.  
Use the option -doit to really execute the actions.

GCI New functionalities
-----------------------

Added support for 64-bit.

Added support for type aliases.
Each alias defines a type and a size, no size accepted after these aliases.

- long (signed long)
- llong (signed long long)
- pointer (opaque, no dereferencement, unlike GCI_indirect)
- size_t (unsigned)
- ssize_t (signed)
- ulong (unsigned long)
- ullong (unsigned long long)

The file gci-try.rexx has been updated to support MacOs.

The demo with statvfs in gci-try.rexx has been documented to bring all the
details about the types used in the structure.  
This function is a good illustration of the need of type aliases in GCI.

The structure statvfs64 depends on the bitness.  
Since the rexx interpreters do not provide a portable way to test their bitness, a new function has been added to GCI:

    GciBitness
    
which returns 32 or 64.

Notes about the script create_links
-----------------------------------

Careful:
SVN does not manage correctly the symbolic links.  
It does not see the file referenced by the link.  
Instead, SVN sees something like that (a text file of 1 line) whose status is "~" (obstructed):  

    link /local/builder/adaptations/oorexx/official/main/trunk/CMakeLists.txt

When the corresponding file in the SVN repository is modified, then SVN compares
this new version with the pseudo file of 1 line, and there is systematically a conflict.  
That's why the script creates HARD links.

Careful:  
SVN does not manage correctly the hard links.  
[https://stackoverflow.com/questions/12456501/svn-with-hard-links](https://stackoverflow.com/questions/12456501/svn-with-hard-links)  
After svn update, some hard links may become independent files (the link count
becomes 1) if the corresponding file was updated in the repository.

Procedure to keep the adaptations in sync:

    create_links -diff

If some diffs are found, then you have some files that lost their hard link.

    create_links -diffview

Analyze the differences and merge into the adaptations.  
After the merge, you can create the links:

    create_links -doit

Remember:
You can see the number of hard links with ls -l (second column):

    -rw-r--r--@  2 jlfaucher  admin  109081 31 jul 08:39 CMakeLists.txt
    -rw-r--r--   1 jlfaucher  admin     340 18 jui 09:39 CONTRIBUTORS
