ScriptName iEquip_ObjectReferenceExt


; @brief Counts the number of items with the given form type in the given container.
; @param a_container The container to search.
; @param a_type The form type to search for.
; @return Returns -1 on error, else returns the number of items counted.
Int Function GetNumItemsOfType(ObjectReference a_container, Int a_type) Global Native


; @brief Returns the nth form with the given type in the given container.
; @param a_container The container to search.
; @param a_type The form type to search for.
; @param a_n The nth form to return.
; @return Returns NONE on error, else returns the nth form of the given type.
Form Function GetNthFormOfType(ObjectReference a_container, Int a_type, Int a_n) Global Native
