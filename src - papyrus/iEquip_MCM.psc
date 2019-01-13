Scriptname iEquip_MCM extends SKI_ConfigBase

iEquip_WidgetCore Property WC Auto
iEquip_KeyHandler Property KH Auto

iEquip_MCM_gen Property gen Auto
iEquip_MCM_htk Property htk Auto
iEquip_MCM_que Property que Auto
iEquip_MCM_pot Property pot Auto
iEquip_MCM_rep Property poi Auto
iEquip_MCM_ui Property uii Auto
iEquip_MCM_pro Property pro Auto
iEquip_MCM_edt Property edt Auto
iEquip_MCM_inf Property inf Auto

bool Property bEnabled = false Auto Hidden
bool Property bUpdateKeyMaps = false Auto Hidden

int Property iCurrentWidgetFadeoutChoice = 1 Auto Hidden
int Property iCurrentNameFadeoutChoice = 1 Auto Hidden
int Property iAmmoIconStyle = 0 Auto Hidden
int Property iCurrentQSPreferredMagicSchoolChoice = 2 Auto Hidden
int Property iCurrentQRPreferredMagicSchoolChoice = 2 Auto Hidden
int Property iCurrentEMKeysChoice = 0 Auto Hidden

string Property MCMSettingsPath = "Data/iEquip/MCM Settings/" autoReadOnly
string Property FileExtMCM = ".IEQS" autoReadOnly
string sCurrentPage = ""

; ###########################
; ### MCM Version Control ###

int function GetVersion()
    return 1
endFunction

;/event OnVersionUpdate(int a_version)
    if (a_version >= 1 && CurrentVersion < 1)
        Debug.Notification("$IEQ_MCM_not_Updating" + " " + a_version as string)
        OnConfigInit()
        EM.ResetDefaults()
        updateSettings()
    endIf
endEvent/;

; #############################
; ### MCM Internal Settings ###

event OnConfigInit()
    Pages = new String[9]
    Pages[0] = "$iEquip_MCM_lbl_General"
    Pages[1] = "$iEquip_MCM_lbl_Hotkey"
    Pages[2] = "$iEquip_MCM_lbl_Queue"
    Pages[3] = "$iEquip_MCM_lbl_Potions"
    Pages[4] = "$iEquip_MCM_lbl_Recharging"
    Pages[5] = "$iEquip_MCM_lbl_Pro"
    Pages[6] = "$iEquip_MCM_lbl_Misc"
    Pages[7] = "$iEquip_MCM_lbl_Edit"
    Pages[8] = "$iEquip_MCM_lbl_Info"

    gen.initData()
    htk.initData()
    que.initData()
    pot.initData()
    poi.initData()    
    uii.initData()          
    pro.initData()   
    edt.initData()           
    inf.initData()
endEvent

Event OnConfigClose()
    if WC.isEnabled != bEnabled
        WC.isEnabled = bEnabled
    endIf
    updateSettings()
endEvent

function updateSettings()
    if WC.isEnabled
        debug.Notification("$iEquip_MCM_not_ApplyingSettings")
        if bUpdateKeyMaps
            KH.updateKeyMaps()
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
        elseIf page == "$iEquip_MCM_lbl_Hotkey"
            htk.drawPage()
        elseIf page == "$iEquip_MCM_lbl_Queue" 
            que.drawPage()
        elseIf page == "$iEquip_MCM_lbl_Potions" 
            pot.drawPage()
        elseIf page == "$iEquip_MCM_lbl_Recharging"
            poi.drawPage()    
        elseIf page == "$iEquip_MCM_lbl_Misc"
            uii.drawPage()          
        elseIf page == "$iEquip_MCM_lbl_Pro"
            pro.drawPage()   
        elseIf page == "$iEquip_MCM_lbl_Edit"
            edt.drawPage()           
        elseIf page == "$iEquip_MCM_lbl_Info"
            inf.drawPage()
        endIf
    endif
endEvent

function jumpToPage(string eventName, float tmpVar = -1.0)
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
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Misc"
        uii.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Pro"
        pro.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Edit"
        edt.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "$iEquip_MCM_lbl_Info"
        inf.jumpToState(sCurrentState, eventName, tmpVar)
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
    if (conflictControl != "")
        string msg
        
        if (conflictName != "")
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
        else
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
        endIf
        
        if ShowMessage(msg, true, "$Yes", "$No")
            jumpToPage("Change", keyCode)
        endIf
    else
        jumpToPage("Change", keyCode)
    endIf
endEvent

; #################
; ### MCM TOOLS ###

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
    string[] newStringArray = Utility.CreateStringArray(stringArray.length - 1)
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
