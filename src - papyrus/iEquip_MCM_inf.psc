Scriptname iEquip_MCM_inf extends iEquip_MCM_Page

import StringUtil

iEquip_KeyHandler Property KH Auto
iEquip_EditMode Property EM Auto

string[] saPresets

; #############
; ### SETUP ###

function initData()                  ; Initialize page specific data
endFunction

int function saveData()             ; Save page data and return jObject
    return -1
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj
endFunction

function drawPage()
    MCM.AddHeaderOption("$iEquip_MCM_lbl_Info")
	MCM.AddTextOptionST("", "$iEquip_MCM_inf_lbl_version" + " " + (MCM.GetVersion() as string), "")
    ;+++Dependency checks
    ;+++Supported mods detected

    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.SetCursorPosition(1)
		MCM.AddHeaderOption("$iEquip_MCM_inf_lbl_presets")
		MCM.AddInputOptionST("inf_inp_savepreset", "$iEquip_MCM_inf_lbl_savepreset", "$iEquip_common_SavePreset")
		MCM.AddMenuOptionST("inf_men_loadpreset", "$iEquip_MCM_inf_lbl_loadpreset", "$iEquip_common_LoadPreset")
		MCM.AddMenuOptionST("inf_men_deletepreset", "$iEquip_MCM_inf_lbl_deletepreset", "$iEquip_btn_delPreset")
		MCM.AddEmptyOption()
		
        MCM.AddHeaderOption("$iEquip_MCM_inf_lbl_maintenance")
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

State inf_inp_savepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_savepreset")
        elseIf currentEvent == "Open"
			MCM.SetInputDialogStartText("PRESETNAME")
        elseIf currentEvent == "Accept"
			MCM.savePreset(currentStrVar)
        endIf 
    endEvent
endState

State inf_men_loadpreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_loadpreset")
        elseIf currentEvent == "Open"
			int jObj = JValue.readFromDirectory(MCM.MCMSettingsPath, MCM.FileExtMCM)
			saPresets = jMap.allKeysPArray(jObj)
			jValue.zeroLifetime(jObj)
			
			if saPresets.length > 0
				int i = 0
			    while(i < saPresets.length)
					saPresets[i] = Substring(saPresets[i], 0, Find(saPresets[i], "."))
					i += 1
				EndWhile
			
				MCM.fillMenu(0, saPresets, 0)
			else
				MCM.ShowMessage("$iEquip_EM_not_noPresets", false, "$OK")
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
			int jObj = JValue.readFromDirectory(MCM.MCMSettingsPath, MCM.FileExtMCM)
			saPresets = jMap.allKeysPArray(jObj)
			jValue.zeroLifetime(jObj)
			
			if saPresets.length > 0
				int i = 0
			    while(i < saPresets.length)
					saPresets[i] = Substring(saPresets[i], 0, Find(saPresets[i], "."))
					i += 1
				EndWhile
			
				MCM.fillMenu(0, saPresets, 0)
			else
				MCM.ShowMessage("$iEquip_EM_not_noPresets", false, "$OK")
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
