
;/  Ordered collection of values (value is float, integer, string, form or another container).
    Inherits JValue functionality
/;
ScriptName JArray
;/  creates new container object. returns container's identifier (unique integer number).
/;
int function object() global native

;/  creates array of given size, filled with empty items
/;
int function objectWithSize(int size) global native

;/  creates new array that contains given values
    objectWithBooleans converts booleans into integers
/;
int function objectWithInts(int[] values) global native
int function objectWithStrings(string[] values) global native
int function objectWithFloats(float[] values) global native
int function objectWithBooleans(bool[] values) global native
int function objectWithForms(form[] values) global native

;/  creates new array containing all values from source array in range [startIndex, endIndex)
/;
int function subArray(int object, int startIndex, int endIndex) global native

;/  adds values from source array into this array. if insertAtIndex is -1 (default behaviour) it adds to the end.
    negative index accesses items from the end of container counting backwards.
/;
function addFromArray(int object, int source, int insertAtIndex=-1) global native
function addFromFormList(int object, FormList source, int insertAtIndex=-1) global native

;/  returns item at index. getObj function returns container.
    negative index accesses items from the end of container counting backwards.
/;
int function getInt(int object, int index, int default=0) global native
float function getFlt(int object, int index, float default=0.0) global native
string function getStr(int object, int index, string default="") global native
int function getObj(int object, int index, int default=0) global native
form function getForm(int object, int index, form default=None) global native

;/  returns index of the first found value/container that equals to given value/container (default behaviour if searchStartIndex is 0).
    if found nothing returns -1.
    searchStartIndex - array index where to start search
    negative index accesses items from the end of container counting backwards.
/;
int function findInt(int object, int value, int searchStartIndex=0) global native
int function findFlt(int object, float value, int searchStartIndex=0) global native
int function findStr(int object, string value, int searchStartIndex=0) global native
int function findObj(int object, int container, int searchStartIndex=0) global native
int function findForm(int object, form value, int searchStartIndex=0) global native

;/  replaces existing value/container at index with new value.
    negative index accesses items from the end of container counting backwards.
/;
function setInt(int object, int index, int value) global native
function setFlt(int object, int index, float value) global native
function setStr(int object, int index, string value) global native
function setObj(int object, int index, int container) global native
function setForm(int object, int index, form value) global native

;/  appends value/container to the end of array.
    if addToIndex >= 0 it inserts value at given index. negative index accesses items from the end of container counting backwards.
/;
function addInt(int object, int value, int addToIndex=-1) global native
function addFlt(int object, float value, int addToIndex=-1) global native
function addStr(int object, string value, int addToIndex=-1) global native
function addObj(int object, int container, int addToIndex=-1) global native
function addForm(int object, form value, int addToIndex=-1) global native

;/  returns number of items in array
/;
int function count(int object) global native

;/  removes all items from array
/;
function clear(int object) global native

;/  erases item at index. negative index accesses items from the end of container counting backwards.
/;
function eraseIndex(int object, int index) global native

;/  erases [first, last] range of items. negative index accesses items from the end of container counting backwards.
    For ex. with [1,-1] range it will erase everything except the first item
/;
function eraseRange(int object, int first, int last) global native

;/  returns type of the value at index. negative index accesses items from the end of container counting backwards.
    0 - no value, 1 - none, 2 - int, 3 - float, 4 - form, 5 - object, 6 - string
/;
int function valueType(int object, int index) global native

;/  Exchanges the items at index1 and index2. negative index accesses items from the end of container counting backwards.
/;
function swapItems(int object, int index1, int index2) global native

;/  Sorts the items into ascending order (none < int < float < form < object < string). Returns the array itself
/;
int function sort(int object) global native

;/  Sorts the items, removes duplicates. Returns array itself. You can treat it as JSet now
/;
int function unique(int object) global native

;/  TOTOTO??
/;
bool function writeToIntegerPArray(int object, int[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, int defaultRead=0) global native
bool function writeToFloatPArray(int object, float[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, float defaultRead=0.0) global native
bool function writeToFormPArray(int object, form[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, form defaultRead=None) global native
bool function writeToStringPArray(int object, string[] targetArray, int writeAtIdx=0, int stopWriteAtIdx=-1, int readIdx=0, string defaultRead="") global native
