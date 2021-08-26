Helper scripts to initialize a build environment for
- Executor release
- Executor debug
- Executor5 release
- Executor5 debug
- Official ooRexx release
- Official ooRexx debug


Must be called from the oorexx directory.
Example:
cd /local/rexx/oorexx
. ../builder/setenv/macos/executor_release


The scripts for macos and win contains relative paths.

The scripts for ubuntuVM and winVM contains absolute paths because the build directory is inside the VM.
