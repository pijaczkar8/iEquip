Scriptname iEquip_MCM_inf extends iEquip_MCM_Page

iEquip_KeyHandler Property KH Auto
iEquip_EditMode Property EM Auto

string[] saPresets

; #############
; ### SETUP ###

function drawPage()
    MCM.AddHeaderOption("$iEquip_MCM_lbl_Info")
	MCM.AddTextOptionST("", "$iEquip_MCM_inf_lbl_version" + " " + MCM.GetVersion(), "")
    ;+++Dependency checks
    ;+++Supported mods detected

    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.SetCursorPosition(1)
		MCM.AddHeaderOption("$iEquip_MCM_inf_lbl_presets")
		MCM.AddEmptyOption()
		MCM.AddMenuOptionST("inf_men_loadpreset", "$iEquip_MCM_inf_lbl_loadpreset", "LOAD")
		MCM.AddMenuOptionST("inf_men_deletepreset", "$iEquip_MCM_inf_lbl_deletepreset", "DELETE")

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

State inf_men_loadpreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_loadpreset")
        elseIf currentEvent == "Open"
			saPresets = JMap.allKeysPArray(JValue.readFromDirectory(MCM.MCMSettingsPath, MCM.FileExtMCM))
			
			if saPresets.length > 0
				MCM.fillMenu(0, saPresets, 0)
			else
				; Add showmessage here
			endIf
        elseIf currentEvent == "Accept"
			MCM.loadPreset(saPresets[currentVar as int])
        endIf 
    endEvent
endState

State inf_men_deletepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_deletepreset")
        elseIf currentEvent == "Open"
			saPresets = JMap.allKeysPArray(JValue.readFromDirectory(MCM.MCMSettingsPath, MCM.FileExtMCM))
			
			if saPresets.length > 0
				MCM.fillMenu(0, saPresets, 0)
			else
				; Add showmessage here
			endIf
        elseIf currentEvent == "Accept"
			MCM.deletePreset(saPresets[currentVar as int])
        endIf 
    endEvent
endState

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
