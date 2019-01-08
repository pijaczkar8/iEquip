Scriptname iEquip_MCM extends SKI_ConfigBase

import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_EditMode Property EM Auto
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

Float Property iEquip_CurrentVersion Auto

actor property PlayerRef auto

;Set to true for version updates which require a full reset
Bool bRequiresResetOnUpdate = False

bool Property bIsFirstEnabled = true Auto Hidden
bool Property bEnabled = false Auto Hidden

; Strings used by save/load settings functions
string MCMSettingsPath = "Data/iEquip/MCM Settings/"
string FileExtMCM = ".IEQS"
string sCurrentPage = ""

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
        Debug.Notification("$IEQ_MCM_not_Updating" + " " + a_version as string)
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
        debug.Notification("$iEquip_MCM_not_ApplyingSettings")
        
        WC.ApplyChanges()
        KH.updateEditModeKeys()           
        if EM.isEditMode
            EM.LoadAllElements()
        endIf
    elseIf !bIsFirstEnabled
        debug.Notification("$iEquip_MCM_not_Disabled")
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
    Pages[0] = "$iEquip_MCM_lbl_General"
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
            Pages = new String[9]
            Pages[8] = "$iEquip_MCM_lbl_Info"
            Pages[7] = "$iEquip_MCM_lbl_Edit"
            Pages[6] = "$iEquip_MCM_lbl_Misc"
            Pages[5] = "$iEquip_MCM_lbl_Pro"
        else
            Pages = new String[8]
            Pages[7] = "$iEquip_MCM_lbl_Info"
            Pages[6] = "$iEquip_MCM_lbl_Edit"
            Pages[5] = "$iEquip_MCM_lbl_Misc"
        endIf
        
        Pages[4] = "$iEquip_MCM_lbl_Recharging"
        Pages[3] = "$iEquip_MCM_lbl_Potions"
        Pages[2] = "$iEquip_MCM_lbl_Queue"
        Pages[1] = "$iEquip_MCM_lbl_Hotkey"
        Pages[0] = "$iEquip_MCM_lbl_General"
    endIf
endEvent

Event OnConfigClose()
    if WC.isEnabled != bEnabled
        if !bEnabled && EM.isEditMode
            WC.updateWidgetVisibility(false)
            Utility.Wait(0.2)
            EM.DisableEditMode()
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

; #######################
; ### START OF EVENTS ###

; Jump to script function

function jumpToScriptEvent(string eventName, float tmpVar = -1.0)
    string sCurrentState = GetState()
    
    if sCurrentPage == "General Settings"
        gen.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Hotkey Options"
        htk.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Queue Options"
        que.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Potions"
        pot.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Recharging and Poisoning"
        poi.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Misc UI Options"
        uii.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Pro Mode"
        pro.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Edit Mode"
        edt.jumpToState(sCurrentState, eventName, tmpVar)
    elseIf sCurrentPage == "Information"
        inf.jumpToState(sCurrentState, eventName, tmpVar)
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
