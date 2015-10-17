Adaptation
==========

This directory contains adaptations of

- BSF4OORexx
- GCI
- ooRexx

to let build with the builder and bring new functionalities.

The files under adaptation can be referenced from the packages being adapted,
using symbolic links. You can use a script to create those symbolic links
(you may have to update the paths):

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
details about the types used in the structure. This function is a good
illustration of the need of type aliases in GCI.

The structure statvfs64 depends on the bitness. Since the rexx interpreters
do not provide a portable way to test their bitness, a new function has been
added to GCI: GciBitness, which returns 32 or 64.
