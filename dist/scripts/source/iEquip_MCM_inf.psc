Scriptname iEquip_MCM_inf extends iEquip_MCM_helperfuncs

iEquip_KeyHandler Property KH Auto
iEquip_EditMode Property EM Auto

; #############
; ### SETUP ###

function drawPage()
    MCM.AddHeaderOption("Information")
    ;+++Version number
    ;+++Dependency checks
    ;+++Supported mods detected
            
    MCM.SetCursorPosition(1)
            
    MCM.AddHeaderOption("Maintenance")
    MCM.AddEmptyOption()
    MCM.AddTextOptionST("inf_txt_rstLayout", "Reset default iEquip layout", "")
endFunction

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
                EM.ResetDefaults()
                KH.OpeniEquipMCM(true)
            endIf
        endIf 
    endEvent
endState
