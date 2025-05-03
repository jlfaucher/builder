Adaptation
==========

This directory contains adaptations of

- ooRexx (old branches, old releases)

    # oorexx/official/main/branches/4.2
    # oorexx/official/main/releases/3.1.2
    # oorexx/official/main/releases/3.2.0
    # oorexx/official/main/releases/4.0.0
    # oorexx/official/main/releases/4.0.1
    # oorexx/official/main/releases/4.1.0
    # oorexx/official/main/releases/4.1.1
    # oorexx/official/main/releases/4.2.0
    # oorexx/official/test/branches/4.2.0

to let build with the builder.

The files in the subdirectories are either new files or existing files that have
been adaptated for some reasons.

You can copy manually these files or you can execute the script create_links which
will create hard links (you may need to adapt the paths at the beginning of the script).  
This script can be re-executed as much as you want.

- create_links.bat  (for Windows)
- create_links      (for Linux/MacOs)

By default, the actions are not executed.  
Use the option -doit to really execute the actions.

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
