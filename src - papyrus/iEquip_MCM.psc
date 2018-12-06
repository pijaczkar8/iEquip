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

Bool iEquip_RequiresResetOnUpdate = False ;Set to true for version updates which require a full reset

Actor Property PlayerRef  Auto  
Form Property iEquip_Unarmed1H  Auto  
Form Property iEquip_Unarmed2H  Auto  

Bool Property iEquip_Reset = False Auto Hidden
Bool Property refreshQueues = False Auto Hidden
Bool Property fadeOptionsChanged = False Auto Hidden
Bool Property ammoIconChanged = False Auto Hidden
Bool Property ammoSortingChanged = False Auto Hidden

bool Property isFirstEnabled = true Auto Hidden
bool Property justEnabled = false Auto Hidden
int Property AmmoListSorting = 1 Auto Hidden
string Property ammoIconSuffix = "" Auto Hidden
bool Property bEnableGearedUp = false Auto Hidden
bool Property gearedUpOptionChanged = false Auto Hidden
bool Property bUnequipAmmo = true Auto Hidden
bool Property slotEnabledOptionsChanged = false Auto Hidden

;Main On/Off switch
bool Property bEnabled = false Auto Hidden
bool Property bEditModeEnabled = true Auto Hidden
bool Property bProModeEnabled = false Auto Hidden
bool Property bEquipOnPause = true Auto Hidden

int Property maxQueueLength = 7 Auto Hidden
bool Property bHardLimitQueueSize = true Auto Hidden
bool Property bAllowWeaponSwitchHands = true Auto Hidden
bool Property bAllowSingleItemsInBothQueues = true Auto Hidden
bool Property bAutoAddNewItems = false Auto Hidden
bool Property bEnableRemovedItemCaching = true Auto Hidden
int Property maxCachedItems = 30 Auto Hidden

float Property equipOnPauseDelay = 2.0 Auto Hidden

float Property mainNameFadeoutDelay = 5.0 Auto Hidden
float Property poisonNameFadeoutDelay = 5.0 Auto Hidden
float Property preselectNameFadeoutDelay = 5.0 Auto Hidden
float Property nameFadeoutDuration = 1.5 Auto Hidden
float Property widgetFadeoutDelay = 30.0 Auto Hidden
float Property widgetFadeoutDuration = 1.5 Auto Hidden

bool Property bPreselectEnabled = true Auto Hidden
bool Property bShoutPreselectEnabled = true Auto Hidden
bool Property bPreselectSwapItemsOnEquip = false Auto Hidden
bool Property bTogglePreselectOnEquipAll = false Auto Hidden

;Strings used by save/load settings functions
string MCMSettingsPath = "Data/iEquip/MCM Settings/"
string FileExtMCM = ".IEQS"

bool Property backgroundStyleChanged = false Auto Hidden
bool Property bSkipCurrentItemWhenCycling = false Auto Hidden
bool Property bFadeLeftIconWhen2HEquipped = true Auto Hidden
float Property leftIconFadeAmount = 70.0 Auto Hidden

bool Property bHealthPotionGrouping = true Auto Hidden
bool Property bUseStrongestHealthPotion = true Auto Hidden
bool Property bStaminaPotionGrouping = true Auto Hidden
bool Property bUseStrongestStaminaPotion = true Auto Hidden
bool Property bMagickaPotionGrouping = true Auto Hidden
bool Property bUseStrongestMagickaPotion = true Auto Hidden
int Property emptyPotionQueueChoice = 0 Auto Hidden
bool Property bEmptyPotionQueueChoiceChanged = false Auto Hidden
bool Property bFlashPotionWarning = true Auto Hidden
bool Property bPotionGroupingOptionsChanged = false Auto Hidden

bool Property bQuickShieldEnabled = false Auto Hidden
bool Property bQuickShield2HSwitchAllowed = true Auto Hidden
bool Property bQuickShieldPreferMagic = false Auto Hidden
int Property preselectQuickShield = 1 Auto Hidden
string Property quickShieldPreferredMagicSchool = "Destruction" Auto Hidden

bool Property bQuickRangedEnabled = false Auto Hidden
int Property preselectQuickRanged = 1 Auto Hidden
int Property quickRangedPreferredWeaponType = 0 Auto Hidden
int Property quickRangedSwitchOutAction = 1 Auto Hidden
string Property quickRangedPreferredMagicSchool = "Destruction" Auto Hidden

bool Property bQuickDualCastEnabled = false Auto Hidden
bool Property bQuickDualCastMustBeInBothQueues = false Auto Hidden
bool Property bQuickDualCastDestruction = false Auto Hidden
bool Property bQuickDualCastIllusion = false Auto Hidden
bool Property bQuickDualCastAlteration = false Auto Hidden
bool Property bQuickDualCastConjuration = false Auto Hidden
bool Property bQuickDualCastRestoration = false Auto Hidden

bool Property bQuickHealEnabled = false Auto Hidden
bool Property bQuickHealPreferMagic = false Auto Hidden
int Property quickHealEquipChoice = 3 Auto Hidden
bool Property bQuickHealUseSecondChoice = true Auto Hidden
bool Property bQuickHealSwitchBackEnabled = true Auto Hidden

bool Property bAllowPoisonSwitching = true Auto Hidden
bool Property bAllowPoisonTopUp = true Auto Hidden
int Property poisonChargeMultiplier = 1 Auto Hidden
int Property poisonChargesPerVial = 1 Auto Hidden
int Property showPoisonMessages = 0 Auto Hidden
int Property poisonIndicatorStyle = 1 Auto Hidden
bool Property poisonIndicatorStyleChanged = false Auto Hidden

bool Property bShowAttributeIcons = true Auto Hidden
bool Property bAttributeIconsOptionChanged = false Auto Hidden

int Property currentWidgetFadeoutChoice = 1 Auto Hidden
int Property currentNameFadeoutChoice = 1 Auto Hidden
int Property ammoIconStyle = 0 Auto Hidden
int Property currentQSPreferredMagicSchoolChoice = 2 Auto Hidden
int Property currentQRPreferredMagicSchoolChoice = 2 Auto Hidden
int Property currentEMKeysChoice = 0 Auto Hidden

; ###########################
; ### START OF UPDATE MCM ###

int function GetVersion()
    return 1
endFunction

event OnVersionUpdate(int a_version)
    if (a_version > CurrentVersion && CurrentVersion > 0)
        Debug.Notification("Updating iEquip to Version " + a_version as string)
        if iEquip_RequiresResetOnUpdate ;For major version updates - fully resets mod, use only if absolutely neccessary
            OnConfigInit()
            EM.ResetDefaults()
        else
            ApplyMCMSettings()
        endIf
    endIf
endEvent


; ### END OF UPDATE MCM ###
; #########################

function ApplyMCMSettings()
	debug.trace("iEquip_WidgetCore ApplyMCMSettings called")
	
	if WC.isEnabled
        debug.Notification("Applying iEquip settings...")
        
        WC.ApplyChanges()
        KH.updateEditModeKeys()           
        if EM.isEditMode
            EM.LoadEditModeWidgets()
        endIf
	elseIf !isFirstEnabled
		debug.Notification("iEquip disabled...")
	endIf
endFunction

; ###########################
; ### START OF CONFIG MCM ###

Event OnConfigInit()
    if(!playerRef.getItemCount(iEquip_Unarmed1H))
        PlayerRef.AddItem(iEquip_Unarmed1H)
    endIf
    if(!playerRef.getItemCount(iEquip_Unarmed2H))
        PlayerRef.AddItem(iEquip_Unarmed2H)
    endIf
    
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
    refreshQueues = false
    fadeOptionsChanged = false
    ammoIconChanged = false
    ammoSortingChanged = false
    slotEnabledOptionsChanged = false
    gearedUpOptionChanged = false
    bAttributeIconsOptionChanged = false
    poisonIndicatorStyleChanged = false
    bPotionGroupingOptionsChanged = false
    backgroundStyleChanged = false
    
    if isFirstEnabled == false
        if bProModeEnabled
            if bEditModeEnabled
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
            if bEditModeEnabled
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
            EM.Disabling = true
            EM.toggleEditMode()
            EM.Disabling = false
        endIf
        if !isFirstEnabled
            WC.isEnabled = bEnabled
        endIf
    endIf
    ApplyMCMSettings()
endEvent

; ### END OF CONFIG MCM ###
; #########################

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

; ### END OF MCM PAGE POPULATION ###
; ##################################

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

; #######################
; ### START OF EVENTS ###

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

; ### END OF EVENTS ###
; #####################
