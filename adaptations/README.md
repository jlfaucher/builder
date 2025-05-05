Adaptation
==========

This directory contains adaptations of

- ooRexx (old branches, old releases)

    - [oorexx/official/main/branches/4.2][adaptation_main_branches_42]
    - [oorexx/official/main/releases/3.1.2][adaptation_main_releases_312]
    - [oorexx/official/main/releases/3.2.0][adaptation_main_releases_320]
    - [oorexx/official/main/releases/4.0.0][adaptation_main_releases_400]
    - [oorexx/official/main/releases/4.0.1][adaptation_main_releases_401]
    - [oorexx/official/main/releases/4.1.0][adaptation_main_releases_410]
    - [oorexx/official/main/releases/4.1.1][adaptation_main_releases_411]
    - [oorexx/official/main/releases/4.2.0][adaptation_main_releases_420]
    - [oorexx/official/test/branches/4.2.0][adaptation_test_branches_420]

to let build with the builder.

The files in the subdirectories are either new files or existing files that have
been adaptated for some reasons.

You can copy manually these files or you can execute the script copy_files
(you may need to adapt the paths at the beginning of the script).  
This script can be re-executed as much as you want.  
A copy is done only if the source is different from the target.  
If a copy must be done and the target exists then a confirmation is asked.

- [copy_files.bat][copy_files_for_windows]  (for Windows)
- [copy_files][copy_files_for_linux_macos]      (for Linux/MacOs)

By default, the actions are not executed.  
Use the option -doit to really execute the actions.


Procedure to keep the adaptations in sync
-----------------------------------------

    copy_files -diff
    copy_files -diffview

Analyze the differences and merge into the adaptations if needed.  
After the merge, you can copy the adapted files:

    copy_files -doit


[adaptation_main_branches_42]: oorexx/official/main/branches/4.2/trunk "main branch 4.2"
[adaptation_main_releases_312]: oorexx/official/main/releases/3.1.2/trunk "main release 3.1.2"
[adaptation_main_releases_320]: oorexx/official/main/releases/3.2.0/trunk "main release 3.2.0"
[adaptation_main_releases_400]: oorexx/official/main/releases/4.0.0/trunk "main release 4.0.0"
[adaptation_main_releases_401]: oorexx/official/main/releases/4.0.1/trunk "main release 4.0.1"
[adaptation_main_releases_410]: oorexx/official/main/releases/4.1.0/trunk "main release 4.1.0"
[adaptation_main_releases_411]: oorexx/official/main/releases/4.1.1/trunk "main release 4.1.1"
[adaptation_main_releases_420]: oorexx/official/main/releases/4.2.0/trunk "main release 4.2.0"
[adaptation_test_branches_420]: oorexx/official/test/branches/4.2.0/trunk "test branch 4.2.0"
[copy_files_for_windows]: copy_files.bat "copy_files.bat"
[copy_files_for_linux_macos]: copy_files "copy_files"
