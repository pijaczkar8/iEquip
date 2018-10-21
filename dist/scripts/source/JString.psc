
;/  various string utility methods
/;
ScriptName JString
;/  Breaks source text onto set of lines of almost equal size.
    Returns JArray object containing lines.
    Accepts ASCII and UTF-8 encoded strings only
/;
int function wrap(string sourceText, int charactersPerLine=60) global native

;/  FormId|Form <-> "__formData|<pluginName>|<lowFormId>"-string converisons
/;
int function decodeFormStringToFormId(string formString) global native
form function decodeFormStringToForm(string formString) global native
string function encodeFormToString(form value) global native
string function encodeFormIdToString(int formId) global native
