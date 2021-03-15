Scriptname iEquip_MCM extends SKI_ConfigBase

import Utility
import StringUtil
import iEquip_StringExt

iEquip_WidgetCore property WC auto
iEquip_KeyHandler Property KH Auto
iEquip_MCM_gen property gen auto
iEquip_MCM_add property add auto
iEquip_MCM_cyc property cyc auto
iEquip_MCM_eqp property eqp auto
iEquip_MCM_amm property amm auto
iEquip_MCM_poi property pois auto
iEquip_MCM_rec property rec auto
iEquip_MCM_pot property pot auto
iEquip_MCM_tch property tch auto
iEquip_MCM_ui property uii auto
iEquip_MCM_edt property edt auto
iEquip_MCM_inf property inf auto

bool property bEnabled auto hidden
bool property bBusy auto hidden
string sCurrentPage

string[] asControlNames
int[] aiHotkeys

string headerColourDefault = "#c1a57a"
string helpColourDefault = "#a6bffe"
string enabledColourDefault = "#c7ea46"
string disabledColourDefault = "#ff7417"

string headerColourPaper = "#723012"
string helpColourPaper = "#0c2263"
string enabledColourPaper = "#135a09"
string disabledColourPaper = "#d05300"

string property headerColour auto hidden
string property helpColour auto hidden
string property enabledColour auto hidden
string property disabledColour auto hidden

bool bUsePaperColours

; ###########################
; ### MCM Version Control ###

int function GetVersion()
    return 162  ; 3 digit versioning - ie. 103 = 1.0.3 where 1 is the main version, 0 is an incremental update, and 3 is a hotfix version 
endFunction

event OnVersionUpdate(int a_version)
    if (a_version >= 162 && CurrentVersion < 162)
        OnConfigInit()
    endIf
endEvent

; #############################
; ### MCM Internal Settings ###

event OnConfigInit()
    Pages = new String[12]
    Pages[0] = "$iEquip_MCM_lbl_GeneralHotkeys"
    Pages[1] = "$iEquip_MCM_lbl_AddingItems"
    Pages[2] = "$iEquip_MCM_lbl_Cycling"
    Pages[3] = "$iEquip_MCM_lbl_Equipping"
    Pages[4] = "$iEquip_MCM_lbl_AmmoQuickRanged"
    Pages[5] = "$iEquip_MCM_lbl_Poisoning"
    Pages[6] = "$iEquip_MCM_lbl_Recharging"
    Pages[7] = "$iEquip_MCM_lbl_PotionsQuickRestore"
    Pages[8] = "$iEquip_MCM_lbl_TorchQuickLight"
    Pages[9] = "$iEquip_MCM_lbl_MiscUI"
    Pages[10] = "$iEquip_MCM_lbl_EditMode"
    Pages[11] = "$iEquip_MCM_lbl_Info"

    asControlNames = new string[12]
    asControlNames[0] = "$iEquip_MCM_gen_lbl_leftHand"
    asControlNames[1] = "$iEquip_MCM_gen_lbl_rightHand"
    asControlNames[2] = "$iEquip_MCM_gen_lbl_shout"
    asControlNames[3] = "$iEquip_MCM_gen_lbl_consumPoison"
    asControlNames[4] = "$iEquip_MCM_gen_lbl_util"
    asControlNames[5] = "$iEquip_MCM_gen_lbl_consItem"
    asControlNames[6] = "$iEquip_MCM_gen_lbl_cyclePoison"
    asControlNames[7] = "$iEquip_MCM_gen_lbl_quickRestore"
    asControlNames[8] = "$iEquip_MCM_gen_lbl_quickShield"
    asControlNames[9] = "$iEquip_MCM_gen_lbl_quickRanged"
    asControlNames[10] = "$iEquip_MCM_tch_lbl_quickLight"
    asControlNames[11] = "$iEquip_MCM_poi_lbl_throwingPoisonsKey"

    aiHotkeys = new int[12]

    headerColour = headerColourDefault
    helpColour = helpColourDefault
    enabledColour = enabledColourDefault
    disabledColour = disabledColourDefault

    RegisterForModEvent("iEquip_KeyHandlerReady", "updateHotkeysArray")

    gen.initData()
    add.initData()
    cyc.initData()
    eqp.initData()
    amm.initData()
    pois.initData()
    rec.initData()
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

function updateHotkeysArray()
    aiHotkeys[0] = KH.iLeftKey
    aiHotkeys[1] = KH.iRightKey
    aiHotkeys[2] = KH.iShoutKey
    aiHotkeys[3] = KH.iConsumableKey
    aiHotkeys[4] = KH.iUtilityKey
    aiHotkeys[5] = KH.iConsumeItemKey
    aiHotkeys[6] = KH.iCyclePoisonKey
    aiHotkeys[7] = KH.iQuickRestoreKey
    aiHotkeys[8] = KH.iQuickShieldKey
    aiHotkeys[9] = KH.iQuickRangedKey
    aiHotkeys[10] = KH.iQuickLightKey
    aiHotkeys[11] = KH.iThrowingPoisonsKey
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
            elseIf page == "$iEquip_MCM_lbl_Poisoning"
                pois.drawPage()
            elseIf page == "$iEquip_MCM_lbl_Recharging"
                rec.drawPage()
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
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Poisoning"
        pois.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Recharging"
        rec.jumpToState(sCurrentState, eventName, tmpVar, tmpStr)
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

bool property bPaperColours
    bool function Get()
        Return bUsePaperColours
    endFunction
    
    function Set(bool usePaperColours)
        bUsePaperColours = usePaperColours
        
        if bUsePaperColours
            headerColour = headerColourPaper
            helpColour = helpColourPaper
            enabledColour = enabledColourPaper
            disabledColour = disabledColourPaper
        else
            headerColour = headerColourDefault
            helpColour = helpColourDefault
            enabledColour = enabledColourDefault
            disabledColour = disabledColourDefault
        endIf
    endFunction
EndProperty


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
            msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_msg_AlreadyMapped1{" + conflictControl + "}{" + conflictName + "}")
        else
            ;msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
            msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_msg_AlreadyMapped2{" + conflictControl + "}")
        endIf
        
        if ShowMessage(msg, true, "$Yes", "$No")
            jumpToPage("Change", keyCode)
            updateHotkeysArray()
        endIf
    else
        jumpToPage("Change", keyCode)
        updateHotkeysArray()
    endIf
endEvent

String Function GetCustomControl(Int a_keyCode)
    string controlName
    if aiHotkeys.Find(a_keyCode) != -1
        controlName = asControlNames[aiHotkeys.Find(a_keyCode)]
    endIf
    if controlName != ""
        controlName = iEquip_StringExt.LocalizeString(controlName)
    endIf
    return controlName
EndFunction

; INPUT

event OnInputOpenST()
    jumpToPage("Open")
endEvent

event OnInputAcceptST(string sInput)
    jumpToPage("Accept", -1.0, sInput)
endEvent

; #################
; ### MCM TOOLS ###

function savePreset(string presetName)  ; Save data to JContainer file
    int jMCMPreset = jMap.object()
    
    jMap.setInt(jMCMPreset, "Version", GetVersion())
    jMap.setObj(jMCMPreset, "GeneralHotkeys", gen.saveData())
    jMap.setObj(jMCMPreset, "AddingItems", add.saveData())
    jMap.setObj(jMCMPreset, "Cycling", cyc.saveData())
    jMap.setObj(jMCMPreset, "Equipping", eqp.saveData())
    jMap.setObj(jMCMPreset, "AmmoQuickRanged", amm.saveData())
    jMap.setObj(jMCMPreset, "Poisoning", pois.saveData())
    jMap.setObj(jMCMPreset, "Recharging", rec.saveData())
    jMap.setObj(jMCMPreset, "PotionsQuickRestore", pot.saveData())
    jMap.setObj(jMCMPreset, "TorchQuickLight", tch.saveData())
    jMap.setObj(jMCMPreset, "MiscUI", uii.saveData())
    jMap.setObj(jMCMPreset, "EditMode", edt.saveData())
    jMap.setObj(jMCMPreset, "Info", inf.saveData())     
    
    jValue.writeTofile(jMCMPreset, WC.MCMSettingsPath + presetName + WC.FileExt)
    jValue.zeroLifetime(jMCMPreset)
endFunction

function loadPreset(string presetName, bool bNoExt = false) ; Load MCM data
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
            if presetVersion < 150
                poi.loadData(jMap.getObj(jMCMPreset, "PoisoningRecharging"), presetVersion)
            else
                pois.loadData(jMap.getObj(jMCMPreset, "Poisoning"), presetVersion)
                rec.loadData(jMap.getObj(jMCMPreset, "Recharging"), presetVersion)
            endIf
            pot.loadData(jMap.getObj(jMCMPreset, "PotionsQuickRestore"), presetVersion)
            tch.loadData(jMap.getObj(jMCMPreset, "TorchQuickLight"), presetVersion)
            uii.loadData(jMap.getObj(jMCMPreset, "MiscUI"), presetVersion)
            edt.loadData(jMap.getObj(jMCMPreset, "EditMode"), presetVersion)
            inf.loadData(jMap.getObj(jMCMPreset, "Info"), presetVersion)
            
            WC.bMCMPresetLoaded = true

            if presetVersion < GetVersion() ; If we've just loaded an older preset delete it and resave to update to the current version so all new settings are included
                updatePreset(presetName)
            endIf

            bBusy = false
        endIf
        
        jValue.zeroLifetime(jMCMPreset)
    endIf
endFunction

function updatePreset(string presetName)
    deletePreset(presetName)
    savePreset(presetName)
    ShowMessage("$iEquip_MCM_msg_presetUpdated", false)
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
; Deprecated in 1.5
iEquip_MCM_rep property poi auto