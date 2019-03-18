ScriptName iEquip_UIExt


; @brief Returns the form at the given inventory index.
; @param a_index The index of the item to obtain the form of.
; @return Returns NONE on error, else returns the form.
Form Function GetFormAtInventoryIndex(Int a_index) Global Native


; @brief Returns the temper string of the item at the given inventory index, with the given count.
; @param a_index The index of the item to obtain the temper string of.
; @param a_count The stack count of the item to obtain the temper string of.
; @return Returns "" on error, else returns the temper string.
String Function GetTemperStringAtInventoryIndex(Int a_index, Int a_count) Global Native
