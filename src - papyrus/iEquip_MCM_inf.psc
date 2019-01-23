Scriptname iEquip_MCM_inf extends iEquip_MCM_Page

iEquip_KeyHandler Property KH Auto
iEquip_EditMode Property EM Auto

; #############
; ### SETUP ###

function drawPage()
    MCM.AddHeaderOption("$iEquip_MCM_lbl_Info")
    ;+++Version number
    ;+++Dependency checks
    ;+++Supported mods detected

    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.SetCursorPosition(1)

        MCM.AddHeaderOption("$iEquip_MCM_inf_lbl_maintenance")
        MCM.AddEmptyOption()
        MCM.AddTextOptionST("inf_txt_rstLayout", "$iEquip_MCM_inf_lbl_rstLayout", "")
    endIf
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
            MCM.SetInfoText("$iEquip_MCM_inf_txt_rstLayout")
        elseIf currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_MCM_inf_msg_rstLayout", true, "$iEquip_MCM_common_reset", "$iEquip_MCM_common_cancel")
                EM.ResetDefaults()
            endIf
        endIf 
    endEvent
endState
