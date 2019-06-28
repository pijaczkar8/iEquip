ScriptName iEquip_UIExt


; @brief Returns the form at the given inventory index.
; @param a_index The index of the item to obtain the form of.
; @return Returns NONE on error, else returns the form.
Form Function GetFormAtInventoryIndex(Int a_index) Global Native


; @brief Returns the shout meter's current fill as a percentage of the total.
; @return Returns 100.0 on error, else returns the current fill percentage.
Float Function GetShoutFillPct() Global Native


; @brief Returns the total cooldown of the last shout used.
; @return Returns 0.0 on error, else returns the cooldown.
Float Function GetShoutCooldownTime() Global Native
