ScriptName iEquip_StringExt


; @brief Returns the localization for a given string.
; @param a_str The string to localize.
; @return Returns the localized version of the string.
String Function LocalizeString(String a_str) Global Native


; @brief Returns the crc32 hash for a given string.
; @param a_str The string to hash.
; @param a_start The starting hash.
; @return Returns the crc32 hash of the string.
Int Function CalcCRC32Hash(String a_str, Int a_start) Global Native


; @brief Returns the given integer as a hex string.
; @param a_num The number to convert to a hex string.
; @return Returns a_num as a hex string.
String Function IntToHexString(Int a_num) Global Native
