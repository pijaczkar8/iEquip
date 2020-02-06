Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_PotionScript Property PO Auto
iEquip_ProMode Property PM Auto

string[] emptyPotionQueueOptions
string[] potionSelectOptions
string[] showSelectorOptions
string[] notificationOptions

string[] QHEquipOptions
string[] QBuffControlOptions
string[] QBuffOptions

; #############
; ### SETUP ###

function initData()
    
    emptyPotionQueueOptions = new String[3]
    emptyPotionQueueOptions[0] = "$iEquip_MCM_pot_opt_fadeicon"
    emptyPotionQueueOptions[1] = "$iEquip_MCM_pot_opt_hideIcon"
    emptyPotionQueueOptions[2] = "$iEquip_MCM_pot_opt_leaveIcon"

    showSelectorOptions = new String[4]
    showSelectorOptions[0] = "$iEquip_MCM_pot_opt_consOrShowSelector"
    showSelectorOptions[1] = "$iEquip_MCM_pot_opt_consAndShowSelector"
    showSelectorOptions[2] = "$iEquip_MCM_pot_opt_smartConsAndShowSelector"
    showSelectorOptions[3] = "$iEquip_MCM_pot_opt_alwaysShowSelector"

    potionSelectOptions = new String[3]
    potionSelectOptions[0] = "$iEquip_MCM_pot_opt_alwaysStrongest"
    potionSelectOptions[1] = "$iEquip_MCM_pot_opt_smartSelect"
    potionSelectOptions[2] = "$iEquip_MCM_pot_opt_alwaysWeakest"

    notificationOptions = new String[3]
    notificationOptions[0] = "$iEquip_MCM_common_opt_disabled"
    notificationOptions[1] = "$iEquip_MCM_common_opt_minimal"
    notificationOptions[2] = "$iEquip_MCM_common_opt_verbose"

    QHEquipOptions = new String[4]
    QHEquipOptions[0] = "$iEquip_MCM_pot_opt_left"
    QHEquipOptions[1] = "$iEquip_MCM_pot_opt_right"
    QHEquipOptions[2] = "$iEquip_MCM_pot_opt_both"
    QHEquipOptions[3] = "$iEquip_MCM_pot_opt_whereFound"

    QBuffOptions = new string[4]
    QBuffOptions[0] = "$iEquip_MCM_pot_opt_eitherBuff"
    QBuffOptions[1] = "$iEquip_MCM_pot_opt_fortifyOnly"
    QBuffOptions[2] = "$iEquip_MCM_pot_opt_regenOnly"
    QBuffOptions[3] = "$iEquip_MCM_pot_opt_bothBuffs"

    QBuffControlOptions = new string[3]
    QBuffControlOptions[0] = "$iEquip_MCM_pot_opt_alwaysQB"
    QBuffControlOptions[1] = "$iEquip_MCM_pot_opt_QBOn2ndPress"
    QBuffControlOptions[2] = "$iEquip_MCM_pot_opt_2ndPressInCombat"
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bPotionGrouping as int)
	
	jArray.addInt(jPageObj, PO.bCheckOtherEffects as int)
	jArray.addInt(jPageObj, PO.bExcludeRestoreAllEffects as int)
	jArray.addInt(jPageObj, PO.iPotionSelectChoice)
	
	jArray.addFlt(jPageObj, PO.fSmartSelectThreshold)
	jArray.addInt(jPageObj, PO.bBlockIfRestEffectActive as int)
	jArray.addInt(jPageObj, PO.bSuspendChecksInCombat as int)
	jArray.addInt(jPageObj, PO.bBlockIfBuffEffectActive as int)
	
	jArray.addInt(jPageObj, WC.iPotionSelectorChoice)
    jArray.addFlt(jPageObj, WC.fSmartConsumeThreshold)
	jArray.addFlt(jPageObj, WC.fPotionSelectorFadeoutDelay)
	jArray.addInt(jPageObj, PO.iEmptyPotionQueueChoice)
	jArray.addFlt(jPageObj, WC.fconsIconFadeAmount)
	jArray.addInt(jPageObj, PO.bFlashPotionWarning as int)
	jArray.addInt(jPageObj, PO.bEnableRestorePotionWarnings as int)
	jArray.addInt(jPageObj, PO.bNotificationOnLowRestorePotions as int)
    jArray.addInt(jPageObj, PO.iNotificationLevel)

    jArray.addInt(jPageObj, PM.bQuickRestoreEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickHealEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickMagickaEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickStaminaEnabled as int)
    jArray.addFlt(jPageObj, PM.fQuickRestoreThreshold)
    jArray.addInt(jPageObj, PM.bQuickBuffEnabled as int)
    jArray.addInt(jPageObj, PM.iQuickBuffControl)
    jArray.addFlt(jPageObj, PM.fQuickBuff2ndPressDelay)
    jArray.addInt(jPageObj, PO.iQuickBuffsToApply)
    jArray.addInt(jPageObj, PM.bQuickHealPreferMagic as int)
    jArray.addInt(jPageObj, PM.bQuickHealUseFallback as int)
    jArray.addInt(jPageObj, PM.iQuickHealEquipChoice)
    jArray.addInt(jPageObj, PM.bQuickHealSwitchBackEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickHealSwitchBackAndRestore as int)   
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	WC.bPotionGrouping = jArray.getInt(jPageObj, 0)
	
	PO.bCheckOtherEffects = jArray.getInt(jPageObj, 1)
	PO.bExcludeRestoreAllEffects = jArray.getInt(jPageObj, 2)
	PO.iPotionSelectChoice = jArray.getInt(jPageObj, 3)
	
	PO.fSmartSelectThreshold = jArray.getFlt(jPageObj, 4)
	PO.bBlockIfRestEffectActive = jArray.getInt(jPageObj, 5)
	PO.bSuspendChecksInCombat = jArray.getInt(jPageObj, 6)
	PO.bBlockIfBuffEffectActive = jArray.getInt(jPageObj, 7)

	WC.iPotionSelectorChoice = jArray.getInt(jPageObj, 8)
    WC.fSmartConsumeThreshold = jArray.getFlt(jPageObj, 9)
	WC.fPotionSelectorFadeoutDelay = jArray.getFlt(jPageObj, 10)
	PO.iEmptyPotionQueueChoice = jArray.getInt(jPageObj, 11)
	WC.fconsIconFadeAmount = jArray.getFlt(jPageObj, 12)
	PO.bFlashPotionWarning = jArray.getInt(jPageObj, 13)
	PO.bEnableRestorePotionWarnings = jArray.getInt(jPageObj, 14)
	PO.bNotificationOnLowRestorePotions = jArray.getInt(jPageObj, 15)
    PO.iNotificationLevel = jArray.getInt(jPageObj, 16)

    PM.bQuickRestoreEnabled = jArray.getInt(jPageObj, 17)
    PM.bQuickHealEnabled = jArray.getInt(jPageObj, 18)
    PM.bQuickMagickaEnabled = jArray.getInt(jPageObj, 19)
    PM.bQuickStaminaEnabled = jArray.getInt(jPageObj, 20)
    PM.fQuickRestoreThreshold = jArray.getFlt(jPageObj, 21)
    PM.bQuickBuffEnabled = jArray.getInt(jPageObj, 22)
    PM.iQuickBuffControl = jArray.getInt(jPageObj, 23)
    PM.fQuickBuff2ndPressDelay = jArray.getFlt(jPageObj, 24)
    PO.iQuickBuffsToApply = jArray.getInt(jPageObj, 25)
    PM.bQuickHealPreferMagic = jArray.getInt(jPageObj, 26)
    PM.bQuickHealUseFallback = jArray.getInt(jPageObj, 27)
    PM.iQuickHealEquipChoice = jArray.getInt(jPageObj, 28)
    PM.bQuickHealSwitchBackEnabled = jArray.getInt(jPageObj, 29)
    PM.bQuickHealSwitchBackAndRestore = jArray.getInt(jPageObj, 30)
endFunction

function drawPage()

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pot_lbl_potOpts</font>")
	MCM.AddToggleOptionST("pot_tgl_enblPotionGroup", "$iEquip_MCM_pot_lbl_enblPotionGroup", WC.bPotionGrouping)
			
	if WC.bPotionGrouping
		MCM.AddToggleOptionST("pot_tgl_checkAllEffects", "$iEquip_MCM_pot_lbl_checkAllEffects", PO.bCheckOtherEffects)
		MCM.AddToggleOptionST("pot_tgl_exclRestAllEffects", "$iEquip_MCM_pot_lbl_exclRestAllEffects", PO.bExcludeRestoreAllEffects)
		MCM.AddMenuOptionST("pot_men_PotionSelect", "$iEquip_MCM_pot_lbl_PotionSelect", potionSelectOptions[PO.iPotionSelectChoice])
		
		if PO.iPotionSelectChoice == 1 ; Smart Select
			MCM.AddSliderOptionST("pot_sld_StatThreshold", "$iEquip_MCM_pot_lbl_StatThreshold", PO.fSmartSelectThreshold*100, "{0} %")
		endIf
		MCM.AddToggleOptionST("pot_tgl_blockIfRestEffect", "$iEquip_MCM_pot_lbl_blockIfRestEffect", PO.bBlockIfRestEffectActive)
		if PO.bBlockIfRestEffectActive
			MCM.AddToggleOptionST("pot_tgl_addCombatException", "$iEquip_MCM_pot_lbl_addCombatException", PO.bSuspendChecksInCombat)
		endIf
		MCM.AddToggleOptionST("pot_tgl_blockIfBuffEffect", "$iEquip_MCM_pot_lbl_blockIfBuffEffect", PO.bBlockIfBuffEffectActive)
	endIf

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pot_lbl_potSelOpts</font>")
	MCM.AddMenuOptionST("pot_men_showSelector", "$iEquip_MCM_pot_lbl_showSelector", showSelectorOptions[WC.iPotionSelectorChoice])
	MCM.AddSliderOptionST("pot_sld_SmartConsumeThreshold", "$iEquip_MCM_pot_lbl_SmartConsumeThreshold", WC.fSmartConsumeThreshold*100, "{0} %")
	MCM.AddSliderOptionST("pot_sld_selectorFadeDelay", "$iEquip_MCM_pot_lbl_selectorFadeDelay", WC.fPotionSelectorFadeoutDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	MCM.AddEmptyOption()
	
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
	MCM.AddMenuOptionST("pot_men_whenNoPotions", "$iEquip_MCM_pot_lbl_whenNoPotions", emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
	if PO.iEmptyPotionQueueChoice == 0
		MCM.AddSliderOptionST("pot_sld_consIcoFade", "$iEquip_MCM_pot_lbl_consIcoFade", WC.fconsIconFadeAmount, "{0}%")
	endIf
	MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "$iEquip_MCM_pot_lbl_warningOnLastPotion", PO.bFlashPotionWarning)
	MCM.AddToggleOptionST("pot_tgl_enblRestPotWarn", "$iEquip_MCM_pot_lbl_enblRestPotWarn", PO.bEnableRestorePotionWarnings)
	if PO.bEnableRestorePotionWarnings
		MCM.AddToggleOptionST("pot_tgl_lowRestPotNot", "$iEquip_MCM_pot_lbl_lowRestPotNot", PO.bNotificationOnLowRestorePotions)
	endIf

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_NotifOptions</font>")
    MCM.AddMenuOptionST("pot_men_ConsumeNotifications", "$iEquip_MCM_pot_lbl_ConsumeNotifications", notificationOptions[PO.iNotificationLevel])

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pot_lbl_quickRestoreOpts</font>")
    MCM.AddTextOptionST("pot_txt_whatQuickRestore", "<font color='#a6bffe'>$iEquip_MCM_pot_lbl_whatQuickRestore</font>", "")

    if PM.bQuickRestoreEnabled
        MCM.AddToggleOptionST("pot_tgl_enblQuickRestore", "<font color='#c7ea46'>$iEquip_MCM_pot_lbl_enblQuickRestore</font>", PM.bQuickRestoreEnabled)
        ;QuickHeal
        MCM.AddToggleOptionST("pot_tgl_enblQuickheal", "$iEquip_MCM_pot_lbl_enblQuickheal", PM.bQuickHealEnabled) 
        ;QuickMagicka
        MCM.AddToggleOptionST("pot_tgl_enblQuickMagicka", "$iEquip_MCM_pot_lbl_enblQuickMagicka", PM.bQuickMagickaEnabled) 
        ;QuickStamina
        MCM.AddToggleOptionST("pot_tgl_enblQuickStamina", "$iEquip_MCM_pot_lbl_enblQuickStamina", PM.bQuickStaminaEnabled)        
        ;Core settings
        MCM.AddSliderOptionST("pot_sld_QuickRestoreThreshold", "$iEquip_MCM_pot_lbl_QuickRestoreThreshold", PM.fQuickRestoreThreshold*100, "{0} %")
        MCM.AddToggleOptionST("pot_tgl_quickBuff", "$iEquip_MCM_pot_lbl_quickBuff", PM.bQuickBuffEnabled)
        
        if PM.bQuickBuffEnabled
            MCM.AddMenuOptionST("pot_men_quickBuffControl", "$iEquip_MCM_pot_lbl_quickBuffControl", QBuffControlOptions[PM.iQuickBuffControl])
            
            if PM.iQuickBuffControl > 0
                MCM.AddSliderOptionST("pot_sld_quickBuffDelay", "$iEquip_MCM_pot_lbl_quickBuffDelay", PM.fQuickBuff2ndPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
            endIf
            MCM.AddMenuOptionST("pot_men_buffsToApply", "$iEquip_MCM_pot_lbl_buffsToApply", QBuffOptions[PO.iQuickBuffsToApply])
        endIf
        ;QuickHeal Options
        if PM.bQuickHealEnabled
            MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pot_lbl_quickHealOpts</font>")
            MCM.AddToggleOptionST("pot_tgl_prefHealMag", "$iEquip_MCM_pot_lbl_prefMag", PM.bQuickHealPreferMagic)
            MCM.AddToggleOptionST("pot_tgl_useFallback", "$iEquip_MCM_pot_lbl_useFallback", PM.bQuickHealUseFallback)
                    
            if PM.bQuickHealPreferMagic
                MCM.AddMenuOptionST("pot_men_alwysEqpSpll", "$iEquip_MCM_pot_lbl_alwysEqpSpll", QHEquipOptions[PM.iQuickHealEquipChoice])
            endIf

            MCM.AddToggleOptionST("pot_tgl_swtchBck", "$iEquip_MCM_pot_lbl_swtchBck", PM.bQuickHealSwitchBackEnabled)
            
            if PM.bQuickHealSwitchBackEnabled
                MCM.AddToggleOptionST("pot_tgl_swtchBckRest", "$iEquip_MCM_pot_lbl_swtchBckRest", PM.bQuickHealSwitchBackAndRestore)
            endIf
        endIf
    else
        MCM.AddToggleOptionST("pot_tgl_enblQuickRestore", "<font color='#ff7417'>$iEquip_MCM_pot_lbl_enblQuickRestore</font>", PM.bQuickRestoreEnabled)
    endIf
endFunction

; ###############
; ### Potions ###
; ###############

; ------------------
; - Potion Options -
; ------------------

State pot_tgl_enblPotionGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_help_potionGroups")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !WC.bPotionGrouping)
            WC.bPotionGrouping = !WC.bPotionGrouping
            ;If we've just re-enabled Potion Grouping we need to add all three groups back into the consumable queue. If we've just disabled then WC.ApplyChanges() will handle removing any remaining groups
            if WC.bPotionGrouping
                WC.addPotionGroups()
            endIf
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_checkAllEffects
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_checkAllEffects")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bCheckOtherEffects)
            PO.bCheckOtherEffects = !PO.bCheckOtherEffects
            MCM.SetToggleOptionValueST(PO.bCheckOtherEffects)
        endIf
    endEvent
endState

State pot_tgl_exclRestAllEffects
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_exclRestAllEffects")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PO.bExcludeRestoreAllEffects)
            PO.bExcludeRestoreAllEffects = !PO.bExcludeRestoreAllEffects
            MCM.SetToggleOptionValueST(PO.bExcludeRestoreAllEffects)
            if PO.bExcludeRestoreAllEffects
                PO.removeRestoreAllPotionsFromGroups()
            else
                MCM.ShowMessage(iEquip_StringExt.LocalizeString("$iEquip_pot_msg_addRestAllToGroups"), false, "$OK")
            endIf
        endIf
    endEvent
endState

State pot_men_showSelector
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_showSelector")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iPotionSelectorChoice, showSelectorOptions, 2)
        elseIf currentEvent == "Accept"
            WC.iPotionSelectorChoice = currentVar as int
            MCM.SetMenuOptionValueST(showSelectorOptions[WC.iPotionSelectorChoice])
        endIf
    endEvent
endState

State pot_sld_SmartConsumeThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_SmartConsumeThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fSmartConsumeThreshold*100, 5.0, 100.0, 5.0, 80.0)
        elseIf currentEvent == "Accept"
            WC.fSmartConsumeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(WC.fSmartConsumeThreshold*100, "{0} %")
        endIf
    endEvent
endState

State pot_sld_selectorFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_selectorFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fPotionSelectorFadeoutDelay, 0.0, 30.0, 0.5, 4.0)
        elseIf currentEvent == "Accept"
            WC.fPotionSelectorFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fPotionSelectorFadeoutDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf 
    endEvent
endState

State pot_men_PotionSelect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_PotionSelect")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iPotionSelectChoice, potionSelectOptions, 1)
        elseIf currentEvent == "Accept"
            PO.iPotionSelectChoice = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_sld_StatThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_StatThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PO.fSmartSelectThreshold*100, 5.0, 100.0, 5.0, 40.0)
        elseIf currentEvent == "Accept"
            PO.fSmartSelectThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PO.fSmartSelectThreshold*100, "{0} %")
        endIf
    endEvent
endState

State pot_tgl_blockIfRestEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_blockIfRestEffect")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bBlockIfRestEffectActive)
            PO.bBlockIfRestEffectActive = !PO.bBlockIfRestEffectActive
            MCM.SetToggleOptionValueST(PO.bBlockIfRestEffectActive)
        endIf
    endEvent
endState

State pot_tgl_addCombatException
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addCombatException")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bSuspendChecksInCombat)
            PO.bSuspendChecksInCombat = !PO.bSuspendChecksInCombat
            MCM.SetToggleOptionValueST(PO.bSuspendChecksInCombat)
        endIf
    endEvent
endState

State pot_tgl_blockIfBuffEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_blockIfBuffEffect")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bBlockIfBuffEffectActive)
            PO.bBlockIfBuffEffectActive = !PO.bBlockIfBuffEffectActive
            MCM.SetToggleOptionValueST(PO.bBlockIfBuffEffectActive)
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State pot_men_whenNoPotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_whenNoPotions")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iEmptyPotionQueueChoice, emptyPotionQueueOptions, 0)
        elseIf currentEvent == "Accept"
            PO.iEmptyPotionQueueChoice = currentVar as int
            MCM.SetMenuOptionValueST(emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
            MCM.ForcePageReset()
        endIf
    endEvent
endState

State pot_sld_consIcoFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_consIcoFade")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fconsIconFadeAmount, 0.0, 100.0, 10.0, 70.0)
        elseIf currentEvent == "Accept"
            WC.fconsIconFadeAmount = currentVar
            MCM.SetSliderOptionValueST(WC.fconsIconFadeAmount, "{0}%")
        endIf 
    endEvent
endState

State pot_tgl_warningOnLastPotion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_warningOnLastPotion")
        elseIf currentEvent == "Select"
            PO.bFlashPotionWarning = !PO.bFlashPotionWarning
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        elseIf currentEvent == "Default"
            PO.bFlashPotionWarning = true 
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        endIf
    endEvent
endState

State pot_tgl_enblRestPotWarn
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_enblRestPotWarn")
        elseIf currentEvent == "Select"
            PO.bEnableRestorePotionWarnings = !PO.bEnableRestorePotionWarnings
            MCM.SetToggleOptionValueST(PO.bEnableRestorePotionWarnings)
            WC.bRestorePotionWarningSettingChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_lowRestPotNot
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_lowRestPotNot")
        elseIf currentEvent == "Select"
            PO.bNotificationOnLowRestorePotions = !PO.bNotificationOnLowRestorePotions
            MCM.SetToggleOptionValueST(PO.bNotificationOnLowRestorePotions)
        endIf
    endEvent
endState

State pot_men_ConsumeNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_ConsumeNotifications")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iNotificationLevel, notificationOptions, 2)
        elseIf currentEvent == "Accept"
            PO.iNotificationLevel = currentVar as int
            MCM.SetMenuOptionValueST(notificationOptions[PO.iNotificationLevel])
        endIf
    endEvent
endState

; ---------------------
; - QuickRestore Options -
; ---------------------

State pot_txt_whatQuickRestore
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_quickRestore1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_quickRestore2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    if MCM.ShowMessage("$iEquip_help_quickRestore3", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                        MCM.ShowMessage("$iEquip_help_quickRestore4", false, "$iEquip_common_msg_Exit")
                    endIf
                endIf
            endIf
        endIf
    endEvent
endState

State pot_tgl_enblQuickRestore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_enblQuickRestore")
        elseIf currentEvent == "Select"
            PM.bQuickRestoreEnabled = !PM.bQuickRestoreEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickRestoreEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_enblQuickheal
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_enblQuickheal")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickHealEnabled)
            PM.bQuickHealEnabled = !PM.bQuickHealEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_enblQuickMagicka
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_enblQuickMagicka")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickMagickaEnabled)
            PM.bQuickMagickaEnabled = !PM.bQuickMagickaEnabled
            MCM.SetToggleOptionValueST(PM.bQuickMagickaEnabled)
        endIf
    endEvent
endState

State pot_tgl_enblQuickStamina
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_enblQuickStamina")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickStaminaEnabled)
            PM.bQuickStaminaEnabled = !PM.bQuickStaminaEnabled
            MCM.SetToggleOptionValueST(PM.bQuickStaminaEnabled)
        endIf
    endEvent
endState

State pot_sld_QuickRestoreThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_QuickRestoreThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PM.fQuickRestoreThreshold*100, 5.0, 100.0, 5.0, 70.0)
        elseIf currentEvent == "Accept"
            PM.fQuickRestoreThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PM.fQuickRestoreThreshold*100, "{0} %")
        endIf
    endEvent
endState

State pot_tgl_quickBuff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_quickBuff")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickBuffEnabled)
            PM.bQuickBuffEnabled = !PM.bQuickBuffEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_quickBuffControl
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_quickBuffControl")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickBuffControl, QBuffControlOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iQuickBuffControl = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_sld_quickBuffDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_quickBuffDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PM.fQuickBuff2ndPressDelay, 0.0, 20.0, 0.5, 4.0)
        elseIf currentEvent == "Accept"
            PM.fQuickBuff2ndPressDelay = currentVar
            MCM.SetSliderOptionValueST(PM.fQuickBuff2ndPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf 
    endEvent
endState

State pot_men_buffsToApply
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_buffsToApply")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iQuickBuffsToApply, QBuffOptions, 3)
        elseIf currentEvent == "Accept"
            PO.iQuickBuffsToApply = currentVar as int
            MCM.SetMenuOptionValueST(QBuffOptions[PO.iQuickBuffsToApply])
        endIf
    endEvent
endState

State pot_tgl_prefHealMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_prefHealMag")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealPreferMagic)
            PM.bQuickHealPreferMagic = !PM.bQuickHealPreferMagic
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_useFallback
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_useFallback")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealUseFallback)
            PM.bQuickHealUseFallback = !PM.bQuickHealUseFallback
            MCM.SetToggleOptionValueST(PM.bQuickHealUseFallback)
        endIf
    endEvent
endState

State pot_men_alwysEqpSpll
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_alwysEqpSpll")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickHealEquipChoice, QHEquipOptions, 3)
        elseIf currentEvent == "Accept"
            PM.iQuickHealEquipChoice = currentVar as int
            MCM.SetMenuOptionValueST(QHEquipOptions[PM.iQuickHealEquipChoice])
        endIf
    endEvent
endState

State pot_tgl_swtchBck
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_swtchBck")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealSwitchBackEnabled)
            PM.bQuickHealSwitchBackEnabled = !PM.bQuickHealSwitchBackEnabled
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackEnabled)
        endIf
    endEvent
endState

State pot_tgl_swtchBckRest
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_swtchBckRest")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickHealSwitchBackAndRestore)
            PM.bQuickHealSwitchBackAndRestore = !PM.bQuickHealSwitchBackAndRestore
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackAndRestore)
        endIf
    endEvent
endState