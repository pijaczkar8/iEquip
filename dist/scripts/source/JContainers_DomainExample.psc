ScriptName JContainers_DomainExample

; JArray

int function JArray_object() global native
int function JArray_objectWithSize(int size) global native
int function JArray_objectWithInts(int[] values) global native
int function JArray_objectWithStrings(string[] values) global native
int function JArray_objectWithFloats(float[] values) global native
int function JArray_objectWithBooleans(bool[] values) global native
int function JArray_objectWithForms(form[] values) global native
int function JArray_subArray(int object, int startIndex, int endIndex) global native
function JArray_addFromArray(int object, int source, int insertAtIndex=-1) global native
function JArray_addFromFormList(int object, FormList source, int insertAtIndex=-1) global native
int function JArray_getInt(int object, int index, int default=0) global native
float function JArray_getFlt(int object, int index, float default=0.0) global native
string function JArray_getStr(int object, int index, string default="") global native
int function JArray_getObj(int object, int index, int default=0) global native
form function JArray_getForm(int object, int index, form default=None) global native
int function JArray_findInt(int object, int value, int searchStartIndex=0) global native
int function JArray_findFlt(int object, float value, int searchStartIndex=0) global native
int function JArray_findStr(int object, string value, int searchStartIndex=0) global native
int function JArray_findObj(int object, int container, int searchStartIndex=0) global native
int function JArray_findForm(int object, form value, int searchStartIndex=0) global native
function JArray_setInt(int object, int index, int value) global native
function JArray_setFlt(int object, int index, float value) global native
function JArray_setStr(int object, int index, string value) global native
function JArray_setObj(int object, int index, int container) global native
function JArray_setForm(int object, int index, form value) global native
function JArray_addInt(int object, int value, int addToIndex=-1) global native
function JArray_addFlt(int object, float value, int addToIndex=-1) global native
function JArray_addStr(int object, string value, int addToIndex=-1) global native
function JArray_addObj(int object, int container, int addToIndex=-1) global native
function JArray_addForm(int object, form value, int addToIndex=-1) global native
int function JArray_count(int object) global native
function JArray_clear(int object) global native
function JArray_eraseIndex(int object, int index) global native
function JArray_eraseRange(int object, int first, int last) global native
int function JArray_valueType(int object, int index) global native
function JArray_swapItems(int object, int index1, int index2) global native
int function JArray_sort(int object) global native
int function JArray_unique(int object) global native
bool function JArray_writeToIntegerPArray(int object, int[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, int defaultRead=0) global native
bool function JArray_writeToFloatPArray(int object, float[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, float defaultRead=0.0) global native
bool function JArray_writeToFormPArray(int object, form[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, form defaultRead=None) global native
bool function JArray_writeToStringPArray(int object, string[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, string defaultRead="") global native

; JContainers


; JDB

float function JDB_solveFlt(string path, float default=0.0) global native
int function JDB_solveInt(string path, int default=0) global native
string function JDB_solveStr(string path, string default="") global native
int function JDB_solveObj(string path, int default=0) global native
form function JDB_solveForm(string path, form default=None) global native
bool function JDB_solveFltSetter(string path, float value, bool createMissingKeys=false) global native
bool function JDB_solveIntSetter(string path, int value, bool createMissingKeys=false) global native
bool function JDB_solveStrSetter(string path, string value, bool createMissingKeys=false) global native
bool function JDB_solveObjSetter(string path, int value, bool createMissingKeys=false) global native
bool function JDB_solveFormSetter(string path, form value, bool createMissingKeys=false) global native
function JDB_setObj(string key, int object) global native
bool function JDB_hasPath(string path) global native
int function JDB_allKeys() global native
int function JDB_allValues() global native
function JDB_writeToFile(string path) global native
function JDB_readFromFile(string path) global native

; JFormDB

function JFormDB_setEntry(string storageName, form fKey, int entry) global native
int function JFormDB_makeEntry(string storageName, form fKey) global native
int function JFormDB_findEntry(string storageName, form fKey) global native
float function JFormDB_solveFlt(form fKey, string path, float default=0.0) global native
int function JFormDB_solveInt(form fKey, string path, int default=0) global native
string function JFormDB_solveStr(form fKey, string path, string default="") global native
int function JFormDB_solveObj(form fKey, string path, int default=0) global native
form function JFormDB_solveForm(form fKey, string path, form default=None) global native
bool function JFormDB_solveFltSetter(form fKey, string path, float value, bool createMissingKeys=false) global native
bool function JFormDB_solveIntSetter(form fKey, string path, int value, bool createMissingKeys=false) global native
bool function JFormDB_solveStrSetter(form fKey, string path, string value, bool createMissingKeys=false) global native
bool function JFormDB_solveObjSetter(form fKey, string path, int value, bool createMissingKeys=false) global native
bool function JFormDB_solveFormSetter(form fKey, string path, form value, bool createMissingKeys=false) global native
bool function JFormDB_hasPath(form fKey, string path) global native
int function JFormDB_allKeys(form fKey, string key) global native
int function JFormDB_allValues(form fKey, string key) global native
int function JFormDB_getInt(form fKey, string key) global native
float function JFormDB_getFlt(form fKey, string key) global native
string function JFormDB_getStr(form fKey, string key) global native
int function JFormDB_getObj(form fKey, string key) global native
form function JFormDB_getForm(form fKey, string key) global native
function JFormDB_setInt(form fKey, string key, int value) global native
function JFormDB_setFlt(form fKey, string key, float value) global native
function JFormDB_setStr(form fKey, string key, string value) global native
function JFormDB_setObj(form fKey, string key, int container) global native
function JFormDB_setForm(form fKey, string key, form value) global native

; JFormMap

int function JFormMap_object() global native
int function JFormMap_getInt(int object, form key, int default=0) global native
float function JFormMap_getFlt(int object, form key, float default=0.0) global native
string function JFormMap_getStr(int object, form key, string default="") global native
int function JFormMap_getObj(int object, form key, int default=0) global native
form function JFormMap_getForm(int object, form key, form default=None) global native
function JFormMap_setInt(int object, form key, int value) global native
function JFormMap_setFlt(int object, form key, float value) global native
function JFormMap_setStr(int object, form key, string value) global native
function JFormMap_setObj(int object, form key, int container) global native
function JFormMap_setForm(int object, form key, form value) global native
bool function JFormMap_hasKey(int object, form key) global native
int function JFormMap_valueType(int object, form key) global native
int function JFormMap_allKeys(int object) global native
form[] function JFormMap_allKeysPArray(int object) global native
int function JFormMap_allValues(int object) global native
bool function JFormMap_removeKey(int object, form key) global native
int function JFormMap_count(int object) global native
function JFormMap_clear(int object) global native
function JFormMap_addPairs(int object, int source, bool overrideDuplicates) global native
form function JFormMap_nextKey(int object, form previousKey=None, form endKey=None) global native
form function JFormMap_getNthKey(int object, int keyIndex) global native

; JIntMap

int function JIntMap_object() global native
int function JIntMap_getInt(int object, int key, int default=0) global native
float function JIntMap_getFlt(int object, int key, float default=0.0) global native
string function JIntMap_getStr(int object, int key, string default="") global native
int function JIntMap_getObj(int object, int key, int default=0) global native
form function JIntMap_getForm(int object, int key, form default=None) global native
function JIntMap_setInt(int object, int key, int value) global native
function JIntMap_setFlt(int object, int key, float value) global native
function JIntMap_setStr(int object, int key, string value) global native
function JIntMap_setObj(int object, int key, int container) global native
function JIntMap_setForm(int object, int key, form value) global native
bool function JIntMap_hasKey(int object, int key) global native
int function JIntMap_valueType(int object, int key) global native
int function JIntMap_allKeys(int object) global native
int[] function JIntMap_allKeysPArray(int object) global native
int function JIntMap_allValues(int object) global native
bool function JIntMap_removeKey(int object, int key) global native
int function JIntMap_count(int object) global native
function JIntMap_clear(int object) global native
function JIntMap_addPairs(int object, int source, bool overrideDuplicates) global native
int function JIntMap_nextKey(int object, int previousKey=0, int endKey=0) global native
int function JIntMap_getNthKey(int object, int keyIndex) global native

; JLua

float function JLua_evalLuaFlt(string luaCode, int transport, float default=0.0, bool minimizeLifetime=true) global native
int function JLua_evalLuaInt(string luaCode, int transport, int default=0, bool minimizeLifetime=true) global native
string function JLua_evalLuaStr(string luaCode, int transport, string default="", bool minimizeLifetime=true) global native
int function JLua_evalLuaObj(string luaCode, int transport, int default=0, bool minimizeLifetime=true) global native
form function JLua_evalLuaForm(string luaCode, int transport, form default=None, bool minimizeLifetime=true) global native
int function JLua_setStr(string key, string value, int transport=0) global native
int function JLua_setFlt(string key, float value, int transport=0) global native
int function JLua_setInt(string key, int value, int transport=0) global native
int function JLua_setForm(string key, form value, int transport=0) global native
int function JLua_setObj(string key, int value, int transport=0) global native

; JMap

int function JMap_object() global native
int function JMap_getInt(int object, string key, int default=0) global native
float function JMap_getFlt(int object, string key, float default=0.0) global native
string function JMap_getStr(int object, string key, string default="") global native
int function JMap_getObj(int object, string key, int default=0) global native
form function JMap_getForm(int object, string key, form default=None) global native
function JMap_setInt(int object, string key, int value) global native
function JMap_setFlt(int object, string key, float value) global native
function JMap_setStr(int object, string key, string value) global native
function JMap_setObj(int object, string key, int container) global native
function JMap_setForm(int object, string key, form value) global native
bool function JMap_hasKey(int object, string key) global native
int function JMap_valueType(int object, string key) global native
int function JMap_allKeys(int object) global native
string[] function JMap_allKeysPArray(int object) global native
int function JMap_allValues(int object) global native
bool function JMap_removeKey(int object, string key) global native
int function JMap_count(int object) global native
function JMap_clear(int object) global native
function JMap_addPairs(int object, int source, bool overrideDuplicates) global native
string function JMap_nextKey(int object, string previousKey="", string endKey="") global native
string function JMap_getNthKey(int object, int keyIndex) global native

; JString

int function JString_wrap(string sourceText, int charactersPerLine=60) global native

; JValue

int function JValue_retain(int object, string tag="") global native
int function JValue_release(int object) global native
int function JValue_releaseAndRetain(int previousObject, int newObject, string tag="") global native
function JValue_releaseObjectsWithTag(string tag) global native
int function JValue_zeroLifetime(int object) global native
int function JValue_addToPool(int object, string poolName) global native
function JValue_cleanPool(string poolName) global native
int function JValue_shallowCopy(int object) global native
int function JValue_deepCopy(int object) global native
bool function JValue_isExists(int object) global native
bool function JValue_isArray(int object) global native
bool function JValue_isMap(int object) global native
bool function JValue_isFormMap(int object) global native
bool function JValue_isIntegerMap(int object) global native
bool function JValue_empty(int object) global native
int function JValue_count(int object) global native
function JValue_clear(int object) global native
int function JValue_readFromFile(string filePath) global native
int function JValue_readFromDirectory(string directoryPath, string extension="") global native
int function JValue_objectFromPrototype(string prototype) global native
function JValue_writeToFile(int object, string filePath) global native
bool function JValue_hasPath(int object, string path) global native
int function JValue_solvedValueType(int object, string path) global native
float function JValue_solveFlt(int object, string path, float default=0.0) global native
int function JValue_solveInt(int object, string path, int default=0) global native
string function JValue_solveStr(int object, string path, string default="") global native
int function JValue_solveObj(int object, string path, int default=0) global native
form function JValue_solveForm(int object, string path, form default=None) global native
bool function JValue_solveFltSetter(int object, string path, float value, bool createMissingKeys=false) global native
bool function JValue_solveIntSetter(int object, string path, int value, bool createMissingKeys=false) global native
bool function JValue_solveStrSetter(int object, string path, string value, bool createMissingKeys=false) global native
bool function JValue_solveObjSetter(int object, string path, int value, bool createMissingKeys=false) global native
bool function JValue_solveFormSetter(int object, string path, form value, bool createMissingKeys=false) global native
float function JValue_evalLuaFlt(int object, string luaCode, float default=0.0) global native
int function JValue_evalLuaInt(int object, string luaCode, int default=0) global native
string function JValue_evalLuaStr(int object, string luaCode, string default="") global native
int function JValue_evalLuaObj(int object, string luaCode, int default=0) global native
form function JValue_evalLuaForm(int object, string luaCode, form default=None) global native
