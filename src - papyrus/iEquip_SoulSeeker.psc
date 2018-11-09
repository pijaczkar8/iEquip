ScriptName iEquip_SoulSeeker


; @brief Fetches the most optimal soulgem to fill an enchanted weapon.
; @param a_reqCharge The required soul to fetch. Valid inputs 1-5.
; @param a_fillMethod The method used to fill the soulgem. Valid inputs 0-1.
; @param a_partialFill Determines whether partially filled soul gems can be returned.
; @param a_wasteOK Determines whether soulgems exceeding the requred size can be returned.
; @return Returns the soul size of the found soul. Returns -1 if the search was a failure.
; @notes This function will remove the soulgem automatically.
Int Function BringMeASoul(Int a_reqCharge, Int a_fillMethod, Bool a_partialFill, Bool a_wasteOK) Global Native