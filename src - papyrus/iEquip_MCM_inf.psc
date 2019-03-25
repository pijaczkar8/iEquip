Scriptname iEquip_MCM_inf extends iEquip_MCM_Page

import Utility
import StringUtil
import iEquip_StringExt

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
	MCM.AddTextOptionST("$iEquip_MCM_inf_lbl_version", MCM.GetVersion() as string)
    ;+++Dependency checks
    ;+++Supported mods detected

    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.SetCursorPosition(1)
		MCM.AddHeaderOption("$iEquip_MCM_inf_lbl_presets")
		MCM.AddInputOptionST("inf_inp_savepreset", "$iEquip_MCM_inf_lbl_savepreset", "")
		MCM.AddMenuOptionST("inf_men_loadpreset", "$iEquip_MCM_inf_lbl_loadpreset", "")
		MCM.AddMenuOptionST("inf_men_deletepreset", "$iEquip_MCM_inf_lbl_deletepreset", "")
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
			MCM.SetInputDialogStartText("$iEquip_MCM_inf_lbl_PresetName")
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
			string[] tmpStrArr = jMap.allKeysPArray(jObj)
			jValue.zeroLifetime(jObj)
			
			saPresets = CreateStringArray(tmpStrArr.length + 1, String fill = "NONE")
			while(i < tmpStrArr.length)
				saPresets[i + 1] = Substring(tmpStrArr[i], 0, Find(tmpStrArr[i], "."))
				i += 1
			EndWhile
			
			MCM.fillMenu(0, saPresets, 0)
        elseIf currentEvent == "Accept"
			if (currentVar as int != 0)
				MCM.loadPreset(saPresets[currentVar as int])
			endIf
        endIf 
    endEvent
endState

State inf_men_deletepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_deletepreset")
        elseIf currentEvent == "Open"
			int jObj = JValue.readFromDirectory(MCM.MCMSettingsPath, MCM.FileExtMCM)
			string[] tmpStrArr = jMap.allKeysPArray(jObj)
			jValue.zeroLifetime(jObj)
			
			saPresets = CreateStringArray(tmpStrArr.length + 1, String fill = "NONE")
			while(i < tmpStrArr.length)
				saPresets[i + 1] = Substring(tmpStrArr[i], 0, Find(tmpStrArr[i], "."))
				i += 1
			EndWhile
			
			MCM.fillMenu(0, saPresets, 0)
        elseIf currentEvent == "Accept"
			if (currentVar as int != 0)
				MCM.deletePreset(saPresets[currentVar as int])
			endIf
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
