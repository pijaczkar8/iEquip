
;/  Evaluates Lua code
/;
ScriptName JLua
;/  Evaluates piece of Lua code. The arguments are carried by @transport object.
    The @transport is any kind of object, not just JMap.
    If @minimizeLifetime is True the function will invoke JValue.zeroLifetime on the @transport object.
    Returns @default value if evaluation fails.
    Usage example:
    
        ; 7 from the end until 9 from the end. Returns "Lua" string
        string input = "Hello Lua user"
        string s = JLua.evaLuaStr("return string.sub(args.string, args.low, args.high)",\
            JLua.setObj("string",input, JLua.setInt("low",7, JLua.setInt("high",9 )))\
        )
    
/;
float function evalLuaFlt(string luaCode, int transport, float default=0.0, bool minimizeLifetime=true) global native
int function evalLuaInt(string luaCode, int transport, int default=0, bool minimizeLifetime=true) global native
string function evalLuaStr(string luaCode, int transport, string default="", bool minimizeLifetime=true) global native
int function evalLuaObj(string luaCode, int transport, int default=0, bool minimizeLifetime=true) global native
form function evalLuaForm(string luaCode, int transport, form default=None, bool minimizeLifetime=true) global native

;/  Inserts new (or replaces existing) {key -> value} pair. Expects that @transport is JMap object, if @transport is 0 it creates new JMap object.
    Returns @transport
/;
int function setStr(string key, string value, int transport=0) global native
int function setFlt(string key, float value, int transport=0) global native
int function setInt(string key, int value, int transport=0) global native
int function setForm(string key, form value, int transport=0) global native
int function setObj(string key, int value, int transport=0) global native
