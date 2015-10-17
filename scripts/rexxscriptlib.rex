/******************************************************************************
*
* Library of ooRexx procedures/functions
*
******************************************************************************/

-------------------------------------------------------------------------------
::routine CreateDirectory public
    -- Under Windows, mkdir for multiple directories is not working on network drive.
    -- Creates the specified directory.
    -- Returns 0 if the directory already exists.
    -- Returns 1 if the directory has been created.
    -- Returns -1 if the creation failed because a file (not a directory) with the same name already exists.
    -- Returns -2 if the creation failed for any other reason.
    use strict arg path
    if path == "" then return 0
    if SysIsFileDirectory(path) then return 0
    if SysIsFile(path) then return -1
    parent = filespec("location", path)
    if parent == path then parent = filespec("location", path~substr(1, path~length - 1))
    parentStatus = CreateDirectory(parent)
    if parentStatus < 0 then return parentStatus
    if SysMkDir(path) <> 0 then return -2
    return 1


-------------------------------------------------------------------------------
::routine CreateDirectoryVerbose public
    -- Creates the specified directory.
    -- Displays an error message in case of trouble.
    -- Returns 0 if the directory already exists.
    -- Returns 1 if the directory has been created.
    -- Returns -1 if the creation failed because a file (not a directory) with the same name already exists.
    -- Returns -2 if the creation failed for any other reason.
    use strict arg path
    createDirectory = CreateDirectory(path)
    select
        when createDirectory == -1 then
            do
                .error~say("Can't create directory, a file with same name already exists:")
                .error~say(path)
            end
        when createDirectory < 0 then
            do
                .error~say("Unable to create directory:")
                .error~say(path)
            end
        otherwise nop
    end
    return createDirectory
