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

State inf_tgl_setAccess
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("If the quick MCM access isn't working for you it may be because you are using a controlmap which changes the default keys for actions such as opening the Journal Menu or scrolling down in menus. "+\
                            "Try setting the five keys below to the ones you would normally use to navigate to the MCM.")
        elseIf currentEvent == "Select"
            MCM.bQuickMCMSetKeys = !MCM.bQuickMCMSetKeys
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickMCMSetKeys = false
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State inf_txt_rstLayout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Selecting this will nuke any changes you have made to iEquip and fully restore the default layout")
        elseIf currentEvent == "Select"
            if MCM.ShowMessage("Are you sure you wish to completely reset iEquip and discard any layout changes you have made?", true, "Reset", "Cancel")
                MCM.iEquip_Reset = !MCM.iEquip_Reset
                MCM.restartingMCM = true
                closeAndReopeniEquipMCM()
            endIf
        endIf 
    endEvent
endState
