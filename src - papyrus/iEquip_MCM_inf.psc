Scriptname iEquip_MCM_inf extends iEquip_MCM_helperfuncs

; ########################
; ### Information Page ###
; ########################

; ---------------
; - Information -
; ---------------

; Nothing here yet

; ---------------
; - Maintenance -
; ---------------

State inf_txt_rstLayout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Selecting this will nuke any changes you have made to iEquip and fully restore the default layout")
        elseIf currentEvent == "Select"
            if MCM.ShowMessage("Are you sure you wish to completely reset iEquip and discard any layout changes you have made?", true, "Reset", "Cancel")
                MCM.iEquip_Reset = !MCM.iEquip_Reset
                MCM.KH.openiEquipMCM(true)
            endIf
        endIf 
    endEvent
endState
