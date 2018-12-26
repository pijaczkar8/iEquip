Scriptname iEquip_MCM extends SKI_ConfigBase

import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_EditMode Property EM Auto
iEquip_KeyHandler Property KH Auto
iEquip_AmmoMode Property AM Auto
iEquip_ProMode Property PM Auto
iEquip_PotionScript Property PO Auto

iEquip_MCM_gen Property gen Auto
iEquip_MCM_htk Property htk Auto
iEquip_MCM_que Property que Auto
iEquip_MCM_pot Property pot Auto
iEquip_MCM_rep Property poi Auto
iEquip_MCM_ui Property uii Auto
iEquip_MCM_pro Property pro Auto
iEquip_MCM_edt Property edt Auto
iEquip_MCM_inf Property inf Auto

Float Property iEquip_CurrentVersion Auto

actor property PlayerRef auto

Bool bRequiresResetOnUpdate = False ;Set to true for version updates which require a full reset

bool Property bIsFirstEnabled = true Auto Hidden
bool Property bEnabled = false Auto Hidden

;Strings used by save/load settings functions
string MCMSettingsPath = "Data/iEquip/MCM Settings/"
string FileExtMCM = ".IEQS"

int Property iCurrentWidgetFadeoutChoice = 1 Auto Hidden
int Property iCurrentNameFadeoutChoice = 1 Auto Hidden
int Property iAmmoIconStyle = 0 Auto Hidden
int Property iCurrentQSPreferredMagicSchoolChoice = 2 Auto Hidden
int Property iCurrentQRPreferredMagicSchoolChoice = 2 Auto Hidden
int Property iCurrentEMKeysChoice = 0 Auto Hidden

; ###########################
; ### START OF UPDATE MCM ###

int function GetVersion()
    return 1
endFunction

event OnVersionUpdate(int a_version)
    if (a_version > CurrentVersion && CurrentVersion > 0)
        Debug.Notification("Updating iEquip to Version " + a_version as string)
        if bRequiresResetOnUpdate ;For major version updates - fully resets mod, use only if absolutely neccessary
            OnConfigInit()
            EM.ResetDefaults()
        else
            ApplyMCMSettings()
        endIf
    endIf
endEvent


; ###########################
; ### START OF CONFIG MCM ###

function ApplyMCMSettings()
	debug.trace("iEquip_WidgetCore ApplyMCMSettings called")
	
	if WC.isEnabled
        debug.Notification("Applying iEquip settings...")
        
        WC.ApplyChanges()
        KH.updateEditModeKeys()           
        if EM.isEditMode
            EM.LoadAllElements()
        endIf
	elseIf !bIsFirstEnabled
		debug.Notification("iEquip disabled...")
	endIf
endFunction

Event OnConfigInit() 
    gen.initData()
    htk.initData()
    que.initData()
    pot.initData()
    poi.initData()    
    uii.initData()          
    pro.initData()   
    edt.initData()           
    inf.initData()  
    
    Pages = new String[1]
    Pages[0] = "General Settings"
endEvent

event OnConfigOpen()
    WC.bRefreshQueues = false
    WC.bFadeOptionsChanged = false
    WC.bAmmoIconChanged = false
    WC.bAmmoSortingChanged = false
    WC.bSlotEnabledOptionsChanged = false
    WC.bGearedUpOptionChanged = false
    WC.bAttributeIconsOptionChanged = false
    WC.bPoisonIndicatorStyleChanged = false
    WC.bPotionGroupingOptionsChanged = false
    WC.bBackgroundStyleChanged = false
    WC.bDropShadowSettingChanged = false
    WC.bReduceMaxQueueLengthPending = false
    
    if bIsFirstEnabled == false
        if WC.bProModeEnabled
            if WC.bEditModeEnabled
                Pages = new String[9]
                Pages[8] = "Information"
                Pages[7] = "Edit Mode"
                Pages[6] = "Misc UI Options"
                Pages[5] = "Pro Mode"
            else
                Pages = new String[8] 
                Pages[7] = "Information"
                Pages[6] = "Misc UI Options"
                Pages[5] = "Pro Mode"
            endIf
        else
            if WC.bEditModeEnabled
                Pages = new String[8]
                Pages[7] = "Information"
                Pages[6] = "Edit Mode"
                Pages[5] = "Misc UI Options"
            else
                Pages = new String[7]
                Pages[6] = "Information"
                Pages[5] = "Misc UI Options"
            endIf
        endIf
        
        Pages[4] = "Recharging and Poisoning"
        Pages[3] = "Potions"
        Pages[2] = "Queue Options"
        Pages[1] = "Hotkey Options"
        Pages[0] = "General Settings"
    endIf
endEvent

Event OnConfigClose()
    if WC.isEnabled != bEnabled
        if !bEnabled && EM.isEditMode
            EM.bDisabling = true
            EM.toggleEditMode()
            EM.bDisabling = false
        endIf
        if !bIsFirstEnabled
            WC.isEnabled = bEnabled
        endIf
    endIf
    
    ApplyMCMSettings()
endEvent

; ####################################
; ### START OF MCM PAGE POPULATION ###

event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    if (page == "")
        LoadCustomContent("iEquip/iEquip_splash.swf", 196, 123)
    else
        UnloadCustomContent()
    
        if page == "General Settings"
            gen.drawPage()
        elseIf page == "Hotkey Options"
            htk.drawPage()
        elseIf page == "Queue Options" 
            que.drawPage()
        elseIf page == "Potions" 
            pot.drawPage()
        elseIf page == "Recharging and Poisoning"
            poi.drawPage()    
        elseIf page == "Misc UI Options"
            uii.drawPage()          
        elseIf page == "Pro Mode"
            pro.drawPage()   
        elseIf page == "Edit Mode"
            edt.drawPage()           
        elseIf page == "Information"
            inf.drawPage()
        endIf
    endif
endEvent

; #######################
; ### START OF EVENTS ###

; Jump to script func

function jumpToScriptEvent(string eventName, float tmpVar = -1.0)
    string currentState = GetState()
    
    if find(currentState, "gen") == 0
        gen.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "htk") == 0
        htk.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "que") == 0
        que.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "pot") == 0
        pot.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "rep") == 0
        poi.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "ui") == 0
        uii.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "pro") == 0
        pro.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "edt") == 0
        edt.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "inf") == 0
        inf.jumpToState(currentState, eventName, tmpVar)
    endIf
endFunction

; GENERAL

event OnHighlightST()
    jumpToScriptEvent("Highlight")
endEvent

event OnSelectST()
    jumpToScriptEvent("Select")
endEvent

event OnDefaultST()
    jumpToScriptEvent("Default")
endEvent

; Hotkeys

event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
    if (conflictControl != "")
        string msg
        
        if (conflictName != "")
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
        else
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
        endIf
        
        if ShowMessage(msg, true, "$Yes", "$No")
            jumpToScriptEvent("Change", keyCode)
        endIf
    else
        jumpToScriptEvent("Change", keyCode)
    endIf
endEvent

; SLIDERS

event OnSliderOpenST()
    jumpToScriptEvent("Open")
endEvent

event OnSliderAcceptST(float value)
    jumpToScriptEvent("Accept", value)
endEvent

; MENUS

event OnMenuOpenST()
    jumpToScriptEvent("Open")
endEvent
    
event OnMenuAcceptST(int index)
    jumpToScriptEvent("Accept", index)
endEvent

; COLORS

event OnColorOpenST()
    jumpToScriptEvent("Open")
endEvent
    
event OnColorAcceptST(int color)
    jumpToScriptEvent("Accept", color)
endEvent
