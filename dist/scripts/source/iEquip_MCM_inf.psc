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

State inf_key_openJour
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Press the key you would normally use to open the Journal Menu from in game\nDefault is J for keyboards and Start for gamepads")
        elseIf currentEvent == "Change"
            MCM.KH.KEY_J = currentVar as int
            switchKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.KEY_J = 36
            MCM.SetKeyMapOptionValueST(MCM.KH.KEY_J)
        endIf 
    endEvent
endState

State inf_key_exitMenu
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Press the key you would normally use to leave the Journal Menu from in game\nDefault is ESC for keyboards and Start for gamepads")
        elseIf currentEvent == "Change"
            MCM.KH.KEY_ESCAPE = currentVar as int
            switchKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.KEY_ESCAPE = 1
            MCM.SetKeyMapOptionValueST(MCM.KH.KEY_ESCAPE)
        endIf 
    endEvent
endState

State inf_key_tabLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Press the key you would normally use to switch one tab to the LEFT in the Journal Menu")
        elseIf currentEvent == "Change"
            MCM.KH.KEY_NUM5 = currentVar as int
            switchKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.KEY_NUM5 = 75
            MCM.SetKeyMapOptionValueST(MCM.KH.KEY_NUM5)
        endIf 
    endEvent
endState

State inf_key_enter
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Press the key you would normally use to select an entry from the MCM list of mods")
        elseIf currentEvent == "Change"
            MCM.KH.KEY_ENTER = currentVar as int
            switchKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.KEY_ENTER = 28
            MCM.SetKeyMapOptionValueST(MCM.KH.KEY_ENTER)
        endIf 
    endEvent
endState

State inf_key_down
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Press the key you would normally use to move down one entry in the MCM list of mods")
        elseIf currentEvent == "Change"
            MCM.KH.KEY_DOWN_ARROW = currentVar as int
            switchKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.KEY_DOWN_ARROW = 208
            MCM.SetKeyMapOptionValueST(MCM.KH.KEY_DOWN_ARROW)
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
                MCM.KH.CloseAndReopeniEquipMCM()
            endIf
        endIf 
    endEvent
endState
