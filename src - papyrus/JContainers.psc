
;/  Various utility methods
/;
ScriptName JContainers
;/  NOT part of public API
/;
bool function __isInstalled() global native

;/  Version information.
    It's a good practice to validate installed JContainers version with the following code:
        bool isJCValid = JContainers.APIVersion() == AV && JContainers.featureVersion() >= FV
    where AV and FV are hardcoded API and feature version numbers.
    Current API version is 3
    Current feature version is 3
/;
int function APIVersion() global native
int function featureVersion() global native

;/  Returns true if file at a specified path exists
/;
bool function fileExistsAtPath(string path) global native

;/  Deletes the file or directory identified by a given path
/;
function removeFileAtPath(string path) global native

;/  A path to user-specific directory - My Games/Skyrim/JCUser/
/;
string function userDirectory() global native

;/  DEPRECATE. Returns last occured error (error code):
    0 - JError_NoError
    1 - JError_ArrayOutOfBoundAccess
/;
int function lastError() global native

;/  DEPRECATE. Returns string that describes last error
/;
string function lastErrorString() global native

; Returns true if JContainers plugin installed properly
bool function isInstalled() global
    return __isInstalled() && 3 == APIVersion() && 3 == featureVersion()
endfunction

