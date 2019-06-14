Scriptname iEquip_MCM extends SKI_ConfigBase

import Utility
import StringUtil

iEquip_WidgetCore property WC auto
iEquip_KeyHandler property KH auto

iEquip_MCM_gen property gen auto
iEquip_MCM_htk property htk auto
iEquip_MCM_que property que auto
iEquip_MCM_pot property pot auto
iEquip_MCM_rep property poi auto
iEquip_MCM_tch property tch auto
iEquip_MCM_ui property uii auto
iEquip_MCM_pro property pro auto
iEquip_MCM_edt property edt auto
iEquip_MCM_inf property inf auto

bool property bEnabled auto hidden
bool property bUpdateKeyMaps auto hidden
bool property bBusy auto hidden
string sCurrentPage

; ###########################
; ### MCM Version Control ###

int function GetVersion()
    return 1
endFunction

;/event OnVersionUpdate(int a_version)
    if (a_version >= 1 && CurrentVersion < 1)
        Debug.Notification("$IEQ_MCM_not_Updating" + " " + a_version as string)
        OnConfigInit()
        updateSettings()
    endIf
endEvent/;

; #############################
; ### MCM Internal Settings ###

event OnConfigInit()
    Pages = new String[10]
    Pages[0] = "$iEquip_MCM_lbl_General"
    Pages[1] = "$iEquip_MCM_lbl_Hotkey"
    Pages[2] = "$iEquip_MCM_lbl_Queue"
    Pages[3] = "$iEquip_MCM_lbl_Potions"
    Pages[4] = "$iEquip_MCM_lbl_Recharging"
    Pages[5] = "$iEquip_MCM_lbl_Torch"
    Pages[6] = "$iEquip_MCM_lbl_Pro"
    Pages[7] = "$iEquip_MCM_lbl_Misc"
    Pages[8] = "$iEquip_MCM_lbl_Edit"
    Pages[9] = "$iEquip_MCM_lbl_Info"

    gen.initData()
    htk.initData()
    que.initData()
    pot.initData()
    poi.initData()
    tch.initData()    
    uii.initData()          
    pro.initData()
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
        if bUpdateKeyMaps
            KH.updateKeyMaps()
			bUpdateKeyMaps = false
        endIf        
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
    
        if page == "$iEquip_MCM_lbl_General"
            gen.drawPage()
		elseIf WC.isEnabled
			if page == "$iEquip_MCM_lbl_Hotkey"
				htk.drawPage()
			elseIf page == "$iEquip_MCM_lbl_Queue" 
				que.drawPage()
			elseIf page == "$iEquip_MCM_lbl_Potions" 
				pot.drawPage()
			elseIf page == "$iEquip_MCM_lbl_Recharging"
				poi.drawPage()
            elseIf page == "$iEquip_MCM_lbl_Torch"
                tch.drawPage()  
			elseIf page == "$iEquip_MCM_lbl_Misc"
				uii.drawPage()          
			elseIf page == "$iEquip_MCM_lbl_Pro"
				pro.drawPage()   
			elseIf page == "$iEquip_MCM_lbl_Edit"
				edt.drawPage()           
			elseIf page == "$iEquip_MCM_lbl_Info"
				inf.drawPage()
			endIf
        endIf
    endif
endEvent

function jumpToPage(string eventName, float tmpVar = -1.0, string tmpStr = "")
    string sCurrentState = GetState()
    
    if sCurrentPage == "$iEquip_MCM_lbl_General"
        gen.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Hotkey"
        htk.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Queue"
        que.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Potions"
        pot.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Recharging"
        poi.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Torch"
        tch.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Misc"
        uii.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Pro"
        pro.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Edit"
        edt.jumpToState(sCurrentState, eventName, tmpVar)
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
	jMap.setObj(jMCMPreset, "General", gen.saveData())
	jMap.setObj(jMCMPreset, "Hotkey", htk.saveData())
	jMap.setObj(jMCMPreset, "Queue", que.saveData())
	jMap.setObj(jMCMPreset, "Potions", pot.saveData())
	jMap.setObj(jMCMPreset, "Poisons&", poi.saveData())
    jMap.setObj(jMCMPreset, "Torch", tch.saveData())
	jMap.setObj(jMCMPreset, "Ui", uii.saveData())
	jMap.setObj(jMCMPreset, "Pro", pro.saveData())
	jMap.setObj(jMCMPreset, "Editmode", edt.saveData())
	jMap.setObj(jMCMPreset, "Info", inf.saveData())		
	
	jValue.writeTofile(jMCMPreset, WC.MCMSettingsPath + presetName + WC.FileExt)
	jValue.zeroLifetime(jMCMPreset)
endFunction

function loadPreset(string presetName, bool bNoExt = false)	; Load MCM data
	if (bBusy)
		ShowMessage("$iEquip_common_LoadPresetBusy")
	else
		int jMCMPreset
		
		if (bNoExt)
			jMCMPreset = jValue.readFromFile(WC.MCMSettingsPath + presetName)
		else
			jMCMPreset = jValue.readFromFile(WC.MCMSettingsPath + presetName + WC.FileExt)
		endIf
		
		if (jMap.getInt(jMCMPreset, "Version") != GetVersion())
			ShowMessage("$iEquip_common_LoadPresetError")
		else
			bBusy = true
			
			gen.loadData(jMap.getObj(jMCMPreset, "General"))
			htk.loadData(jMap.getObj(jMCMPreset, "Hotkey"))
			que.loadData(jMap.getObj(jMCMPreset, "Queue"))
			pot.loadData(jMap.getObj(jMCMPreset, "Potions"))
			poi.loadData(jMap.getObj(jMCMPreset, "Poisons&"))
			tch.loadData(jMap.getObj(jMCMPreset, "Torch"))
			uii.loadData(jMap.getObj(jMCMPreset, "Ui"))
			pro.loadData(jMap.getObj(jMCMPreset, "Pro"))
			edt.loadData(jMap.getObj(jMCMPreset, "Editmode"))
			inf.loadData(jMap.getObj(jMCMPreset, "Info"))
			
			bUpdateKeyMaps = true
			WC.bMCMPresetLoaded = true
			bBusy = false
		endIf
		
		jValue.zeroLifetime(jMCMPreset)
	endIf
endFunction

function deletePreset(string presetName)
	JContainers.removeFileAtPath(WC.MCMSettingsPath + presetName + WC.FileExt)
endFunction

function getPresets(string[] saPresets, string defFill)
	int jObj = JValue.readFromDirectory(WC.MCMSettingsPath, WC.FileExt)
	string[] tmpStrArr = jMap.allKeysPArray(jObj)
	jValue.zeroLifetime(jObj)
	int i
	saPresets = CreateStringArray(tmpStrArr.length + 1, defFill)
	while(i < tmpStrArr.length)
		saPresets[i + 1] = Substring(tmpStrArr[i], 0, find(tmpStrArr[i], WC.FileExt))
		i += 1
	endWhile
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
