
;/  Manages form related information (entry).
    
/;
ScriptName JFormDB
;/  associates given form key and entry (container). set entry to zero to destroy association
/;
function setEntry(string storageName, form fKey, int entry) global native

;/  returns (or creates new if not found) JMap entry for given storage and form
/;
int function makeEntry(string storageName, form fKey) global native

;/  search for entry for given storage and form
/;
int function findEntry(string storageName, form fKey) global native

;/  attempts to get value associated with path.
/;
float function solveFlt(form fKey, string path, float default=0.0) global native
int function solveInt(form fKey, string path, int default=0) global native
string function solveStr(form fKey, string path, string default="") global native
int function solveObj(form fKey, string path, int default=0) global native
form function solveForm(form fKey, string path, form default=None) global native

;/  Attempts to assign value. Returns false if no such path
    With 'createMissingKeys=true' it creates any missing path elements: JFormDB.solveIntSetter(formKey, ".frostfall.keyB", 10, true) creates {frostfall: {keyB: 10}} structure
/;
bool function solveFltSetter(form fKey, string path, float value, bool createMissingKeys=false) global native
bool function solveIntSetter(form fKey, string path, int value, bool createMissingKeys=false) global native
bool function solveStrSetter(form fKey, string path, string value, bool createMissingKeys=false) global native
bool function solveObjSetter(form fKey, string path, int value, bool createMissingKeys=false) global native
bool function solveFormSetter(form fKey, string path, form value, bool createMissingKeys=false) global native

;/  returns true, if capable resolve given path, e.g. it able to execute solve* or solver*Setter functions successfully
/;
bool function hasPath(form fKey, string path) global native

;/  JMap-like interface functions:
    
    returns new array containing all keys
/;
int function allKeys(form fKey, string key) global native

;/  returns new array containing all values
/;
int function allValues(form fKey, string key) global native

;/  returns value associated with key
/;
int function getInt(form fKey, string key) global native
float function getFlt(form fKey, string key) global native
string function getStr(form fKey, string key) global native
int function getObj(form fKey, string key) global native
form function getForm(form fKey, string key) global native

;/  creates key-value association. replaces existing value if any
/;
function setInt(form fKey, string key, int value) global native
function setFlt(form fKey, string key, float value) global native
function setStr(form fKey, string key, string value) global native
function setObj(form fKey, string key, int container) global native
function setForm(form fKey, string key, form value) global native
