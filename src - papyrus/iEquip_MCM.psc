Scriptname iEquip_MCM extends SKI_ConfigBase

import Utility
import StringUtil
import iEquip_StringExt

iEquip_WidgetCore property WC auto
iEquip_MCM_gen property gen auto
iEquip_MCM_add property add auto
iEquip_MCM_cyc property cyc auto
iEquip_MCM_eqp property eqp auto
iEquip_MCM_amm property amm auto
iEquip_MCM_rep property poi auto
iEquip_MCM_pot property pot auto
iEquip_MCM_tch property tch auto
iEquip_MCM_ui property uii auto
iEquip_MCM_edt property edt auto
iEquip_MCM_inf property inf auto

bool property bEnabled auto hidden
bool property bBusy auto hidden
string sCurrentPage

; ###########################
; ### MCM Version Control ###

int function GetVersion()
    return 124  ; 3 digit versioning - ie. 103 = 1.0.3 where 1 is the main version, 0 is an incremental update, and 3 is a hotfix version 
endFunction

event OnVersionUpdate(int a_version)
    if (a_version >= 124 && CurrentVersion < 124)
        OnConfigInit()
    endIf
endEvent

; #############################
; ### MCM Internal Settings ###

event OnConfigInit()
    Pages = new String[11]
    Pages[0] = "$iEquip_MCM_lbl_GeneralHotkeys"
    Pages[1] = "$iEquip_MCM_lbl_AddingItems"
    Pages[2] = "$iEquip_MCM_lbl_Cycling"
    Pages[3] = "$iEquip_MCM_lbl_Equipping"
    Pages[4] = "$iEquip_MCM_lbl_AmmoQuickRanged"
    Pages[5] = "$iEquip_MCM_lbl_PoisoningRecharging"
    Pages[6] = "$iEquip_MCM_lbl_PotionsQuickRestore"
    Pages[7] = "$iEquip_MCM_lbl_TorchQuickLight"
    Pages[8] = "$iEquip_MCM_lbl_MiscUI"
    Pages[9] = "$iEquip_MCM_lbl_EditMode"
    Pages[10] = "$iEquip_MCM_lbl_Info"

    gen.initData()
    add.initData()
    cyc.initData()
    eqp.initData()
    amm.initData()
    poi.initData()
    pot.initData()    
    tch.initData()
    uii.initData()
    edt.initData()           
    inf.initData()

endEvent

Event OnConfigClose()
    if WC.isEnabled != bEnabled
        WC.isEnabled = bEnabled
    else
        updateSettings()
    endIf
endEvent

function updateSettings()
    if WC.isEnabled
        debug.Notification("$iEquip_MCM_not_ApplyingSettings")  
        WC.ApplyChanges()
    endIf
endFunction

; #################
; ### MCM Pages ###

event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    sCurrentPage = page
    
    if (page == "")
        LoadCustomContent("iEquip/iEquip_splash.swf", 196, 123)
    else
        UnloadCustomContent()
    
        if page == "$iEquip_MCM_lbl_GeneralHotkeys"
            gen.drawPage()
		elseIf WC.isEnabled
			if page == "$iEquip_MCM_lbl_AddingItems"
				add.drawPage()
			elseIf page == "$iEquip_MCM_lbl_Cycling" 
				cyc.drawPage()
            elseIf page == "$iEquip_MCM_lbl_Equipping" 
                eqp.drawPage()
            elseIf page == "$iEquip_MCM_lbl_AmmoQuickRanged" 
                amm.drawPage()
            elseIf page == "$iEquip_MCM_lbl_PoisoningRecharging"
                poi.drawPage()
			elseIf page == "$iEquip_MCM_lbl_PotionsQuickRestore" 
				pot.drawPage()
            elseIf page == "$iEquip_MCM_lbl_TorchQuickLight"
                tch.drawPage()  
			elseIf page == "$iEquip_MCM_lbl_MiscUI"
				uii.drawPage()          
			elseIf page == "$iEquip_MCM_lbl_EditMode"
				edt.drawPage()           
			elseIf page == "$iEquip_MCM_lbl_Info"
				inf.drawPage()
			endIf
        endIf
    endif
endEvent

function jumpToPage(string eventName, float tmpVar = -1.0, string tmpStr = "")
    string sCurrentState = GetState()
    
    if sCurrentPage == "$iEquip_MCM_lbl_GeneralHotkeys"
        gen.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_AddingItems"
        add.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Cycling"
        cyc.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Equipping"
        eqp.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_AmmoQuickRanged"
        amm.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_PoisoningRecharging"
        poi.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_PotionsQuickRestore"
        pot.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_TorchQuickLight"
        tch.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_MiscUI"
        uii.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_EditMode"
        edt.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Info"
        inf.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    endIf
endFunction


; #######################
; ### START OF EVENTS ###

; GENERAL

event OnHighlightST()
    jumpToPage("Highlight")
endEvent

event OnSelectST()
    jumpToPage("Select")
endEvent

event OnDefaultST()
    jumpToPage("Default")
endEvent

; SLIDERS

event OnSliderOpenST()
    jumpToPage("Open")
endEvent

event OnSliderAcceptST(float value)
    jumpToPage("Accept", value)
endEvent

; MENUS

event OnMenuOpenST()
    jumpToPage("Open")
endEvent
    
event OnMenuAcceptST(int index)
    jumpToPage("Accept", index)
endEvent

; COLORS

event OnColorOpenST()
    jumpToPage("Open")
endEvent
    
event OnColorAcceptST(int color)
    jumpToPage("Accept", color)
endEvent

; HOTKEYS

event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
    if (conflictControl != "" && keyCode != -1) ; CHECK IF THIS IS ACTUALLY WORKING
        string msg
        
        if (conflictName != "")
            ;msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
            msg = "$iEquip_MCM_msg_AlreadyMapped1{" + conflictControl + "}{" + conflictName + "}"
        else
            ;msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
            msg = "$iEquip_MCM_msg_AlreadyMapped2{" + conflictControl + "}"
        endIf
        
        if ShowMessage(msg, true, "$Yes", "$No")
            jumpToPage("Change", keyCode)
        endIf
    else
        jumpToPage("Change", keyCode)
    endIf
endEvent

; INPUT

event OnInputOpenST()
	jumpToPage("Open")
endEvent

event OnInputAcceptST(string sInput)
    jumpToPage("Accept", -1.0, sInput)
endEvent

; #################
; ### MCM TOOLS ###

function savePreset(string presetName)	; Save data to JContainer file
	int jMCMPreset = jMap.object()
	
	jMap.setInt(jMCMPreset, "Version", GetVersion())
	jMap.setObj(jMCMPreset, "GeneralHotkeys", gen.saveData())
	jMap.setObj(jMCMPreset, "AddingItems", add.saveData())
	jMap.setObj(jMCMPreset, "Cycling", cyc.saveData())
    jMap.setObj(jMCMPreset, "Equipping", eqp.saveData())
    jMap.setObj(jMCMPreset, "AmmoQuickRanged", amm.saveData())
	jMap.setObj(jMCMPreset, "PoisoningRecharging", poi.saveData())
	jMap.setObj(jMCMPreset, "PotionsQuickRestore", pot.saveData())
	jMap.setObj(jMCMPreset, "TorchQuickLight", tch.saveData())
	jMap.setObj(jMCMPreset, "MiscUI", uii.saveData())
	jMap.setObj(jMCMPreset, "EditMode", edt.saveData())
	jMap.setObj(jMCMPreset, "Info", inf.saveData())		
	
	jValue.writeTofile(jMCMPreset, WC.MCMSettingsPath + presetName + WC.FileExt)
	jValue.zeroLifetime(jMCMPreset)
endFunction

function loadPreset(string presetName, bool bNoExt = false)	; Load MCM data
	if (bBusy)
		ShowMessage("$iEquip_common_LoadPresetBusy", false)
	else
		int jMCMPreset
		
		if (bNoExt)
			jMCMPreset = jValue.readFromFile(WC.MCMSettingsPath + presetName)
		else
			jMCMPreset = jValue.readFromFile(WC.MCMSettingsPath + presetName + WC.FileExt)
		endIf
		
		int presetVersion = jMap.getInt(jMCMPreset, "Version")

        if presetVersion < 121
			ShowMessage("$iEquip_common_LoadPresetError", false)
		else
			bBusy = true
			
			gen.loadData(jMap.getObj(jMCMPreset, "GeneralHotkeys"), presetVersion)
			add.loadData(jMap.getObj(jMCMPreset, "AddingItems"), presetVersion)
			cyc.loadData(jMap.getObj(jMCMPreset, "Cycling"), presetVersion)
            eqp.loadData(jMap.getObj(jMCMPreset, "Equipping"), presetVersion)
			amm.loadData(jMap.getObj(jMCMPreset, "AmmoQuickRanged"), presetVersion)
			poi.loadData(jMap.getObj(jMCMPreset, "PoisoningRecharging"), presetVersion)
			pot.loadData(jMap.getObj(jMCMPreset, "PotionsQuickRestore"), presetVersion)
			tch.loadData(jMap.getObj(jMCMPreset, "TorchQuickLight"), presetVersion)
            uii.loadData(jMap.getObj(jMCMPreset, "MiscUI"), presetVersion)
			edt.loadData(jMap.getObj(jMCMPreset, "EditMode"), presetVersion)
			inf.loadData(jMap.getObj(jMCMPreset, "Info"), presetVersion)
			
			WC.bMCMPresetLoaded = true

            if presetVersion < GetVersion() ; If we've just loaded an older preset delete it and resave to update to the current version so all new settings are included
                deletePreset(presetName)
                savePreset(presetName)
                ShowMessage("$iEquip_MCM_msg_presetUpdated", false)
            endIf

			bBusy = false
		endIf
		
		jValue.zeroLifetime(jMCMPreset)
	endIf
endFunction

function updatePreset(string presetName)
    deletePreset(presetName)
    savePreset(presetName)
endFunction

function deletePreset(string presetName)
	JContainers.removeFileAtPath(WC.MCMSettingsPath + presetName + WC.FileExt)
endFunction

string[] function getPresets(string defFill)
	int jObj = JValue.readFromDirectory(WC.MCMSettingsPath, WC.FileExt)
	int i
	string[] tmpStrArr = jMap.allKeysPArray(jObj)
	string[] saPresets = CreateStringArray(tmpStrArr.length + 1, defFill)
	jValue.zeroLifetime(jObj)
	
	while(i < tmpStrArr.length)
		saPresets[i + 1] = Substring(tmpStrArr[i], 0, find(tmpStrArr[i], WC.FileExt))
		i += 1
	endWhile
	
	return saPresets
endFunction

; -----------
; - Sliders -
; -----------

function fillSlider(float startVal, float startRange, float endRange, float intervalVal, float defaultVal)
    SetSliderDialogStartValue(startVal)
    SetSliderDialogRange(startRange, endRange)  
    SetSliderDialogInterval(intervalVal)
    SetSliderDialogDefaultValue(defaultVal)
endFunction 

; ---------
; - Menus -
; ---------

function fillMenu(int startVal, string[] options, int defaultVal)
    SetMenuDialogStartIndex(startVal)
    SetMenuDialogOptions(options)
    SetMenuDialogDefaultIndex(defaultVal)
endFunction

; -------------------
; - Everything else -
; -------------------

string[] function cutStrArray(string[] stringArray, int cutIndex)
	if stringArray.length < 2
		return stringArray
	endIf

	string[] newStringArray = CreateStringArray(stringArray.length - 1)
	int oldAIndex
	int newAIndex
		
	while oldAIndex < stringArray.length && newAIndex < stringArray.length - 1
		if oldAIndex != cutIndex
			newStringArray[newAIndex] = stringArray[oldAIndex]
			newAIndex += 1
		endIf
			
		oldAIndex += 1
	endWhile
	
	return newStringArray
endFunction

; Deprecated in 1.2
iEquip_MCM_htk property htk auto
iEquip_MCM_que property que auto
iEquip_MCM_pro property pro auto