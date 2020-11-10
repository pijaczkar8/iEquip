Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_PotionScript Property PO Auto
iEquip_ProMode Property PM Auto

string[] whenEffectActiveOptions
string[] emptyPotionQueueOptions
string[] potionSelectOptions
string[] showSelectorOptions

string[] QHEquipOptions
string[] QBuffControlOptions
string[] QBuffOptions
string[] QResistOptions

; #############
; ### SETUP ###

function initData()

    whenEffectActiveOptions = new string[4]
    whenEffectActiveOptions[0] = "$iEquip_MCM_pot_opt_allow"
    whenEffectActiveOptions[1] = "$iEquip_MCM_pot_opt_allowIfStronger"
    whenEffectActiveOptions[2] = "$iEquip_MCM_pot_opt_onlyInCombat"
    whenEffectActiveOptions[3] = "$iEquip_MCM_pot_opt_block"
    
    emptyPotionQueueOptions = new String[3]
    emptyPotionQueueOptions[0] = "$iEquip_MCM_pot_opt_fadeIcon"
    emptyPotionQueueOptions[1] = "$iEquip_MCM_pot_opt_hideIcon"
    emptyPotionQueueOptions[2] = "$iEquip_MCM_pot_opt_leaveIcon"

    showSelectorOptions = new String[3]
    showSelectorOptions[0] = "$iEquip_MCM_pot_opt_consOrShowSelector"
    showSelectorOptions[1] = "$iEquip_MCM_pot_opt_consAndShowSelector"
    showSelectorOptions[2] = "$iEquip_MCM_pot_opt_alwaysShowSelector"

    potionSelectOptions = new String[3]
    potionSelectOptions[0] = "$iEquip_MCM_pot_opt_alwaysStrongest"
    potionSelectOptions[1] = "$iEquip_MCM_pot_opt_smartSelect"
    potionSelectOptions[2] = "$iEquip_MCM_pot_opt_alwaysWeakest"

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

    QResistOptions = new string[3]
    QResistOptions[0] = "$iEquip_MCM_pot_opt_byMag"
    QResistOptions[1] = "$iEquip_MCM_pot_opt_byDur"
    QResistOptions[2] = "$iEquip_MCM_pot_opt_byMagxDur"

    QBuffControlOptions = new string[3]
    QBuffControlOptions[0] = "$iEquip_MCM_pot_opt_alwaysQB"
    QBuffControlOptions[1] = "$iEquip_MCM_pot_opt_QBOn2ndPress"
    QBuffControlOptions[2] = "$iEquip_MCM_pot_opt_2ndPressInCombat"
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bPotionGrouping as int)
	jArray.addInt(jPageObj, PO.bCheckOtherEffects as int)
    jArray.addInt(jPageObj, PO.bPrioritiseRestoreEffects as int)
    jArray.addInt(jPageObj, PO.bExcludeHostilePotions as int)
	jArray.addInt(jPageObj, PO.bExcludeRestoreAllEffects as int)
	
    jArray.addFlt(jPageObj, PO.fConsRestoreThreshold)
    jArray.addInt(jPageObj, PO.iPotionSelectChoice)
	jArray.addFlt(jPageObj, PO.fSmartSelectThreshold)
	jArray.addInt(jPageObj, PO.iActiveEffectRule)
	jArray.addFlt(jPageObj, PO.fAboveCurrentEffectMag)
	
	jArray.addInt(jPageObj, WC.iPotionSelectorChoice)
	jArray.addFlt(jPageObj, WC.fPotionSelectorFadeoutDelay)
	jArray.addInt(jPageObj, PO.iEmptyPotionQueueChoice)
	jArray.addFlt(jPageObj, WC.fconsIconFadeAmount)
	jArray.addInt(jPageObj, PO.bFlashPotionWarning as int)
	jArray.addInt(jPageObj, PO.bEnableRestorePotionWarnings as int)
	jArray.addInt(jPageObj, PO.bNotificationOnLowRestorePotions as int)
    jArray.addInt(jPageObj, PO.bShowConsumedNotifications as int)
    jArray.addInt(jPageObj, PO.bShowNoPotionsNotifications as int)
    jArray.addInt(jPageObj, PO.bShowEffectActiveNotifications as int)
    jArray.addInt(jPageObj, PO.bShowStatFullNotifications as int)

    jArray.addInt(jPageObj, PM.bQuickRestoreEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickHealEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickMagickaEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickStaminaEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickBuffEnabled as int)
    jArray.addInt(jPageObj, PM.iQuickBuffControl)
    jArray.addFlt(jPageObj, PM.fQuickBuff2ndPressDelay)
    jArray.addInt(jPageObj, PO.iQuickBuffsToApply)
    jArray.addInt(jPageObj, PM.bQuickResistEnabled as int)
    jArray.addInt(jPageObj, PO.iResistSortingMethod)
    jArray.AddInt(jPageObj, PO.abQuickResist[0] as int)
    jArray.AddInt(jPageObj, PO.abQuickResist[1] as int)
    jArray.AddInt(jPageObj, PO.abQuickResist[2] as int)
    jArray.AddInt(jPageObj, PO.abQuickResist[3] as int)
    jArray.AddInt(jPageObj, PO.abQuickResist[4] as int)
    jArray.addInt(jPageObj, PM.bQuickHealPreferMagic as int)
    jArray.addInt(jPageObj, PM.bQuickHealUseFallback as int)
    jArray.addInt(jPageObj, PM.iQuickHealEquipChoice)
    jArray.addInt(jPageObj, PM.bQuickHealSwitchBackEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickHealSwitchBackAndRestore as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	
    if presetVersion < 152
        WC.bPotionGrouping = jArray.getInt(jPageObj, 0)
        PO.bCheckOtherEffects = jArray.getInt(jPageObj, 1)
        PO.bExcludeRestoreAllEffects = jArray.getInt(jPageObj, 2)
        
        PO.iPotionSelectChoice = jArray.getInt(jPageObj, 3)
        PO.fSmartSelectThreshold = jArray.getFlt(jPageObj, 4)
        PO.bBlockIfRestEffectActive = jArray.getInt(jPageObj, 5)
        PO.bSuspendChecksInCombat = jArray.getInt(jPageObj, 6)
        ;PO.bBlockIfBuffEffectActive = jArray.getInt(jPageObj, 7)
        if PO.bBlockIfRestEffectActive
            if !PO.bSuspendChecksInCombat
                PO.iActiveEffectRule = 3
            endIf
        else
            PO.iActiveEffectRule = 1
        endIf

        WC.iPotionSelectorChoice = jArray.getInt(jPageObj, 8)
        if WC.iPotionSelectorChoice > 1
            WC.iPotionSelectorChoice -=1
        endIf
        ;WC.fSmartConsumeThreshold = jArray.getFlt(jPageObj, 9)
        WC.fPotionSelectorFadeoutDelay = jArray.getFlt(jPageObj, 10)
        PO.iEmptyPotionQueueChoice = jArray.getInt(jPageObj, 11)
        WC.fconsIconFadeAmount = jArray.getFlt(jPageObj, 12)
        PO.bFlashPotionWarning = jArray.getInt(jPageObj, 13)
        PO.bEnableRestorePotionWarnings = jArray.getInt(jPageObj, 14)
        PO.bNotificationOnLowRestorePotions = jArray.getInt(jPageObj, 15)
        PO.iNotificationLevel = jArray.getInt(jPageObj, 16)
        
        ; Update new notification settings from old value in preset
        PO.bShowConsumedNotifications = PO.iNotificationLevel > 0           ; If previously Minimal or Verbose
        PO.bShowNoPotionsNotifications = PO.iNotificationLevel > 0          ; If previously Minimal or Verbose
        PO.bShowEffectActiveNotifications = PO.iNotificationLevel == 2      ; If previously Verbose
        PO.bShowStatFullNotifications = PO.iNotificationLevel == 2          ; If previously Verbose

        PM.bQuickRestoreEnabled = jArray.getInt(jPageObj, 17)
        PM.bQuickHealEnabled = jArray.getInt(jPageObj, 18)
        PM.bQuickMagickaEnabled = jArray.getInt(jPageObj, 19)
        PM.bQuickStaminaEnabled = jArray.getInt(jPageObj, 20)
        PO.fConsRestoreThreshold = jArray.getFlt(jPageObj, 21)
        PM.bQuickBuffEnabled = jArray.getInt(jPageObj, 22)
        PM.iQuickBuffControl = jArray.getInt(jPageObj, 23)
        PM.fQuickBuff2ndPressDelay = jArray.getFlt(jPageObj, 24)
        PO.iQuickBuffsToApply = jArray.getInt(jPageObj, 25)
        PM.bQuickHealPreferMagic = jArray.getInt(jPageObj, 26)
        PM.bQuickHealUseFallback = jArray.getInt(jPageObj, 27)
        PM.iQuickHealEquipChoice = jArray.getInt(jPageObj, 28)
        PM.bQuickHealSwitchBackEnabled = jArray.getInt(jPageObj, 29)
        PM.bQuickHealSwitchBackAndRestore = jArray.getInt(jPageObj, 30)
    else
        WC.bPotionGrouping = jArray.getInt(jPageObj, 0)
        PO.bCheckOtherEffects = jArray.getInt(jPageObj, 1)
        PO.bPrioritiseRestoreEffects = jArray.getInt(jPageObj, 2, 1)
        PO.bExcludeHostilePotions = jArray.getInt(jPageObj, 3, 1)
        PO.bExcludeRestoreAllEffects = jArray.getInt(jPageObj, 4)
        
        PO.fConsRestoreThreshold = jArray.getFlt(jPageObj, 5)
        PO.iPotionSelectChoice = jArray.getInt(jPageObj, 6)
        PO.fSmartSelectThreshold = jArray.getFlt(jPageObj, 7)
        PO.iActiveEffectRule = jArray.getInt(jPageObj, 8)
        PO.fAboveCurrentEffectMag = jArray.getFlt(jPageObj, 9)

        WC.iPotionSelectorChoice = jArray.getInt(jPageObj, 10)
        WC.fPotionSelectorFadeoutDelay = jArray.getFlt(jPageObj, 11)
        PO.iEmptyPotionQueueChoice = jArray.getInt(jPageObj, 12)
        WC.fconsIconFadeAmount = jArray.getFlt(jPageObj, 13)
        PO.bFlashPotionWarning = jArray.getInt(jPageObj, 14)
        PO.bEnableRestorePotionWarnings = jArray.getInt(jPageObj, 15)
        PO.bNotificationOnLowRestorePotions = jArray.getInt(jPageObj, 16)
        PO.bShowConsumedNotifications = jArray.getInt(jPageObj, 17)
        PO.bShowNoPotionsNotifications = jArray.getInt(jPageObj, 18)
        PO.bShowEffectActiveNotifications = jArray.getInt(jPageObj, 19)
        PO.bShowStatFullNotifications = jArray.getInt(jPageObj, 20)
        
        PM.bQuickRestoreEnabled = jArray.getInt(jPageObj, 21)
        PM.bQuickHealEnabled = jArray.getInt(jPageObj, 22)
        PM.bQuickMagickaEnabled = jArray.getInt(jPageObj, 23)
        PM.bQuickStaminaEnabled = jArray.getInt(jPageObj, 24)
        PM.bQuickBuffEnabled = jArray.getInt(jPageObj, 25)
        PM.iQuickBuffControl = jArray.getInt(jPageObj, 26)
        PM.fQuickBuff2ndPressDelay = jArray.getFlt(jPageObj, 27)
        PO.iQuickBuffsToApply = jArray.getInt(jPageObj, 28)
        PM.bQuickResistEnabled = jArray.getInt(jPageObj, 29)
        PO.iResistSortingMethod = jArray.getInt(jPageObj, 30)
        PO.abQuickResist[0] = jArray.getInt(jPageObj, 31)
        PO.abQuickResist[1] = jArray.getInt(jPageObj, 32)
        PO.abQuickResist[2] = jArray.getInt(jPageObj, 33)
        PO.abQuickResist[3] = jArray.getInt(jPageObj, 34)
        PO.abQuickResist[4] = jArray.getInt(jPageObj, 35)
        PM.bQuickHealPreferMagic = jArray.getInt(jPageObj, 36)
        PM.bQuickHealUseFallback = jArray.getInt(jPageObj, 37)
        PM.iQuickHealEquipChoice = jArray.getInt(jPageObj, 38)
        PM.bQuickHealSwitchBackEnabled = jArray.getInt(jPageObj, 39)
        PM.bQuickHealSwitchBackAndRestore = jArray.getInt(jPageObj, 40)
    endIf

endFunction

function drawPage()

	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_potOpts</font>")
	MCM.AddToggleOptionST("pot_tgl_enblPotionGroup", "$iEquip_MCM_pot_lbl_enblPotionGroup", WC.bPotionGrouping)
			
	if WC.bPotionGrouping
		MCM.AddToggleOptionST("pot_tgl_checkAllEffects", "$iEquip_MCM_pot_lbl_checkAllEffects", PO.bCheckOtherEffects)
        if PO.bCheckOtherEffects
            MCM.AddToggleOptionST("pot_tgl_prioritiseRestoreEffects", "$iEquip_MCM_pot_lbl_prioritiseRestoreEffects", PO.bPrioritiseRestoreEffects)
            MCM.AddToggleOptionST("pot_tgl_exclHostilePotions", "$iEquip_MCM_pot_lbl_exclHostilePotions", PO.bExcludeHostilePotions)
        endIf
		MCM.AddToggleOptionST("pot_tgl_exclRestAllEffects", "$iEquip_MCM_pot_lbl_exclRestAllEffects", PO.bExcludeRestoreAllEffects)
	endIf

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_potConsOpts</font>")
    MCM.AddSliderOptionST("pot_sld_ConsRestoreThreshold", "$iEquip_MCM_pot_lbl_ConsRestoreThreshold", PO.fConsRestoreThreshold*100, "{0}%")
    MCM.AddTextOptionST("pot_txt_whatSmartSelect", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_pot_lbl_whatSmartSelect</font>", "")
    MCM.AddMenuOptionST("pot_men_PotionSelect", "$iEquip_MCM_pot_lbl_PotionSelect", potionSelectOptions[PO.iPotionSelectChoice])
    if PO.iPotionSelectChoice == 1 ; Smart Select
        MCM.AddSliderOptionST("pot_sld_StatThreshold", "$iEquip_MCM_pot_lbl_StatThreshold", PO.fSmartSelectThreshold*100, "{0}%")
    endIf
    MCM.AddMenuOptionST("pot_men_whenEffectActive", "$iEquip_MCM_pot_lbl_whenEffectActive", whenEffectActiveOptions[PO.iActiveEffectRule])
    if PO.iActiveEffectRule == 1 || PO.iActiveEffectRule == 2
        MCM.AddSliderOptionST("pot_sld_aboveCurrEffectMagThreshold", "$iEquip_MCM_pot_lbl_aboveCurrEffectMagThreshold", PO.fAboveCurrentEffectMag*100, "{0}% stronger")
    endIf

	MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_potSelOpts</font>")
	MCM.AddMenuOptionST("pot_men_showSelector", "$iEquip_MCM_pot_lbl_showSelector", showSelectorOptions[WC.iPotionSelectorChoice])
	MCM.AddSliderOptionST("pot_sld_selectorFadeDelay", "$iEquip_MCM_pot_lbl_selectorFadeDelay", WC.fPotionSelectorFadeoutDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	
	MCM.AddEmptyOption()
	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
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
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_common_lbl_NotifOptions</font>")
    MCM.AddToggleOptionST("pot_tgl_showConsumedNotifications", "$iEquip_MCM_pot_lbl_showConsumedNotifications", PO.bShowConsumedNotifications)
    MCM.AddToggleOptionST("pot_tgl_showNoPotionsNotifications", "$iEquip_MCM_pot_lbl_showNoPotionsNotifications", PO.bShowNoPotionsNotifications) 
    MCM.AddToggleOptionST("pot_tgl_showEffectActiveNotifications", "$iEquip_MCM_pot_lbl_showEffectActiveNotifications", PO.bShowEffectActiveNotifications)
    MCM.AddToggleOptionST("pot_tgl_showStatFullNotifications", "$iEquip_MCM_pot_lbl_showStatFullNotifications", PO.bShowStatFullNotifications)

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_quickRestoreOpts</font>")
    MCM.AddTextOptionST("pot_txt_whatQuickRestore", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_pot_lbl_whatQuickRestore</font>", "")

    if PM.bQuickRestoreEnabled
        MCM.AddToggleOptionST("pot_tgl_enblQuickRestore", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_pot_lbl_enblQuickRestore</font>", PM.bQuickRestoreEnabled)
        ;QuickHeal
        MCM.AddToggleOptionST("pot_tgl_enblQuickheal", "$iEquip_MCM_pot_lbl_enblQuickheal", PM.bQuickHealEnabled) 
        ;QuickMagicka
        MCM.AddToggleOptionST("pot_tgl_enblQuickMagicka", "$iEquip_MCM_pot_lbl_enblQuickMagicka", PM.bQuickMagickaEnabled) 
        ;QuickStamina
        MCM.AddToggleOptionST("pot_tgl_enblQuickStamina", "$iEquip_MCM_pot_lbl_enblQuickStamina", PM.bQuickStaminaEnabled)        
        ;Core settings
        
        if PM.bQuickBuffEnabled
            MCM.AddToggleOptionST("pot_tgl_quickBuff", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_pot_lbl_quickBuff</font>", PM.bQuickBuffEnabled)
            MCM.AddMenuOptionST("pot_men_quickBuffControl", "$iEquip_MCM_pot_lbl_quickBuffControl", QBuffControlOptions[PM.iQuickBuffControl])
            
            if PM.iQuickBuffControl > 0
                MCM.AddSliderOptionST("pot_sld_quickBuffDelay", "$iEquip_MCM_pot_lbl_quickBuffDelay", PM.fQuickBuff2ndPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
            endIf
            MCM.AddMenuOptionST("pot_men_buffsToApply", "$iEquip_MCM_pot_lbl_buffsToApply", QBuffOptions[PO.iQuickBuffsToApply])
            if PM.bQuickResistEnabled
                MCM.AddToggleOptionST("pot_tgl_quickResist", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_pot_lbl_quickResist</font>", PM.bQuickResistEnabled)
                MCM.AddMenuOptionST("pot_men_quickResistPref", "$iEquip_MCM_pot_lbl_quickResistPref",QResistOptions[PO.iResistSortingMethod])
                MCM.AddToggleOptionST("pot_tgl_quickResistMagic", "$iEquip_MCM_pot_lbl_quickResistMagic", PO.abQuickResist[2])
                MCM.AddToggleOptionST("pot_tgl_quickResistFire", "$iEquip_MCM_pot_lbl_quickResistFire", PO.abQuickResist[0])
                MCM.AddToggleOptionST("pot_tgl_quickResistFrost", "$iEquip_MCM_pot_lbl_quickResistFrost", PO.abQuickResist[1])
                MCM.AddToggleOptionST("pot_tgl_quickResistShock", "$iEquip_MCM_pot_lbl_quickResistShock", PO.abQuickResist[4])
                MCM.AddToggleOptionST("pot_tgl_quickResistPoison", "$iEquip_MCM_pot_lbl_quickResistPoison", PO.abQuickResist[3])
            else
                MCM.AddToggleOptionST("pot_tgl_quickResist", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_pot_lbl_quickResist</font>", PM.bQuickResistEnabled)
            endIf
        else
            MCM.AddToggleOptionST("pot_tgl_quickBuff", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_pot_lbl_quickBuff</font>", PM.bQuickBuffEnabled)
        endIf
        ;QuickHeal Options
        if PM.bQuickHealEnabled
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_quickHealOpts</font>")
            MCM.AddToggleOptionST("pot_tgl_prefHealMag", "$iEquip_MCM_common_lbl_prefMag", PM.bQuickHealPreferMagic)
            MCM.AddToggleOptionST("pot_tgl_useFallback", "$iEquip_MCM_pot_lbl_useFallback", PM.bQuickHealUseFallback)
                    
            if PM.bQuickHealPreferMagic
                MCM.AddMenuOptionST("pot_men_alwysEqpSpll", "$iEquip_MCM_pot_lbl_alwysEqpSpll", QHEquipOptions[PM.iQuickHealEquipChoice])
                MCM.AddToggleOptionST("pot_tgl_prefHealMagIgnoreTHold", "$iEquip_MCM_pot_lbl_prefHealMagIgnoreTHold", PM.bQuickHealPreferMagicIgnoreThreshold)
            endIf

            MCM.AddToggleOptionST("pot_tgl_swtchBck", "$iEquip_MCM_pot_lbl_swtchBck", PM.bQuickHealSwitchBackEnabled)
            
            if PM.bQuickHealSwitchBackEnabled
                MCM.AddToggleOptionST("pot_tgl_swtchBckRest", "$iEquip_MCM_pot_lbl_swtchBckRest", PM.bQuickHealSwitchBackAndRestore)
            endIf
        endIf
    else
        MCM.AddToggleOptionST("pot_tgl_enblQuickRestore", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_pot_lbl_enblQuickRestore</font>", PM.bQuickRestoreEnabled)
    endIf
endFunction

; ###############
; ### Potions ###
; ###############

; ------------------------
; - Potion Group Options -
; ------------------------

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
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_tgl_prioritiseRestoreEffects
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_prioritiseRestoreEffects")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bPrioritiseRestoreEffects)
            PO.bPrioritiseRestoreEffects = !PO.bPrioritiseRestoreEffects
            MCM.SetToggleOptionValueST(PO.bPrioritiseRestoreEffects)
        endIf
    endEvent
endState

State pot_tgl_exclHostilePotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_exclHostilePotions")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PO.bExcludeHostilePotions)
            PO.bExcludeHostilePotions = !PO.bExcludeHostilePotions
            MCM.SetToggleOptionValueST(PO.bExcludeHostilePotions)
            if PO.bExcludeHostilePotions
                PO.removeHostilePotionsFromGroups()
            endIf
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

; ------------------------------
; - Potion Consumption Options -
; ------------------------------

State pot_sld_ConsRestoreThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_ConsRestoreThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PO.fConsRestoreThreshold*100, 5.0, 100.0, 5.0, 70.0)
        elseIf currentEvent == "Accept"
            PO.fConsRestoreThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PO.fConsRestoreThreshold*100, "{0}%")
        endIf
    endEvent
endState

State pot_txt_whatSmartSelect
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("$iEquip_MCM_pot_msg_whatSmartSelect", false, "$iEquip_common_msg_Exit")
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
            MCM.SetSliderOptionValueST(PO.fSmartSelectThreshold*100, "{0}%")
        endIf
    endEvent
endState

State pot_men_whenEffectActive
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_whenEffectActive")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iActiveEffectRule, whenEffectActiveOptions, 2)
        elseIf currentEvent == "Accept"
            PO.iActiveEffectRule = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_sld_aboveCurrEffectMagThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_aboveCurrEffectMagThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PO.fAboveCurrentEffectMag*100, 0.0, 100.0, 5.0, 30.0)
        elseIf currentEvent == "Accept"
            PO.fAboveCurrentEffectMag = currentVar/100
            MCM.SetSliderOptionValueST(PO.fAboveCurrentEffectMag*100, "{0}% stronger")
        endIf
    endEvent
endState

; --------------------------------
; - Potion Type Selector Options -
; --------------------------------

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

; ------------------------
; - Notification Options -
; ------------------------

State pot_tgl_showConsumedNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_showConsumedNotifications")
        elseIf currentEvent == "Select"
            PO.bShowConsumedNotifications = !PO.bShowConsumedNotifications
            MCM.SetToggleOptionValueST(PO.bShowConsumedNotifications)
        endIf
    endEvent
endState

State pot_tgl_showNoPotionsNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_showNoPotionsNotifications")
        elseIf currentEvent == "Select"
            PO.bShowNoPotionsNotifications = !PO.bShowNoPotionsNotifications
            MCM.SetToggleOptionValueST(PO.bShowNoPotionsNotifications)
        endIf
    endEvent
endState

State pot_tgl_showEffectActiveNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_showEffectActiveNotifications")
        elseIf currentEvent == "Select"
            PO.bShowEffectActiveNotifications = !PO.bShowEffectActiveNotifications
            MCM.SetToggleOptionValueST(PO.bShowEffectActiveNotifications)
        endIf
    endEvent
endState

State pot_tgl_showStatFullNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_showStatFullNotifications")
        elseIf currentEvent == "Select"
            PO.bShowStatFullNotifications = !PO.bShowStatFullNotifications
            MCM.SetToggleOptionValueST(PO.bShowStatFullNotifications)
        endIf
    endEvent
endState

; ------------------------
; - QuickRestore Options -
; ------------------------

State pot_txt_whatQuickRestore
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_quickRestore1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_quickRestore2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    if MCM.ShowMessage("$iEquip_help_quickRestore3", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                        if MCM.ShowMessage("$iEquip_help_quickRestore4", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                            MCM.ShowMessage("$iEquip_help_quickRestore5", false, "$iEquip_common_msg_Exit")
                        endIf
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

State pot_tgl_quickResist
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_quickResist")
        elseIf currentEvent == "Select"
            PM.bQuickResistEnabled = !PM.bQuickResistEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_quickResistPref
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_quickResistPref")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iResistSortingMethod, QResistOptions, 0)
        elseIf currentEvent == "Accept"
            PO.iResistSortingMethod = currentVar as int
            MCM.SetMenuOptionValueST(QResistOptions[PO.iResistSortingMethod])
        endIf
    endEvent
endState

State pot_tgl_quickResistFire
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText(iEquip_StringExt.LocalizeString("$iEquip_MCM_pot_txt_quickResistIncl{"+PO.asResistEffectNames[0]+"}"))
        elseIf currentEvent == "Select"
            PO.abQuickResist[0] = !PO.abQuickResist[0]
            MCM.SetToggleOptionValueST(PO.abQuickResist[0])
        endIf
    endEvent
endState

State pot_tgl_quickResistFrost
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText(iEquip_StringExt.LocalizeString("$iEquip_MCM_pot_txt_quickResistIncl{"+PO.asResistEffectNames[1]+"}"))
        elseIf currentEvent == "Select"
            PO.abQuickResist[1] = !PO.abQuickResist[1]
            MCM.SetToggleOptionValueST(PO.abQuickResist[1])
        endIf
    endEvent
endState

State pot_tgl_quickResistMagic
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText(iEquip_StringExt.LocalizeString("$iEquip_MCM_pot_txt_quickResistIncl{"+PO.asResistEffectNames[2]+"}"))
        elseIf currentEvent == "Select"
            PO.abQuickResist[2] = !PO.abQuickResist[2]
            MCM.SetToggleOptionValueST(PO.abQuickResist[2])
        endIf
    endEvent
endState

State pot_tgl_quickResistPoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText(iEquip_StringExt.LocalizeString("$iEquip_MCM_pot_txt_quickResistIncl{"+PO.asResistEffectNames[3]+"}"))
        elseIf currentEvent == "Select"
            PO.abQuickResist[3] = !PO.abQuickResist[3]
            MCM.SetToggleOptionValueST(PO.abQuickResist[3])
        endIf
    endEvent
endState

State pot_tgl_quickResistShock
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText(iEquip_StringExt.LocalizeString("$iEquip_MCM_pot_txt_quickResistIncl{"+PO.asResistEffectNames[4]+"}"))
        elseIf currentEvent == "Select"
            PO.abQuickResist[4] = !PO.abQuickResist[4]
            MCM.SetToggleOptionValueST(PO.abQuickResist[4])
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

State pot_tgl_prefHealMagIgnoreTHold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_prefHealMagIgnoreTHold")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealPreferMagicIgnoreThreshold)
            PM.bQuickHealPreferMagicIgnoreThreshold = !PM.bQuickHealPreferMagicIgnoreThreshold
            MCM.SetToggleOptionValueST(PM.bQuickHealPreferMagicIgnoreThreshold)
        endIf
    endEvent
endState

State pot_tgl_swtchBck
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_swtchBck")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealSwitchBackEnabled)
            PM.bQuickHealSwitchBackEnabled = !PM.bQuickHealSwitchBackEnabled
            MCM.forcePageReset()
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

; Deprecated in v1.5
string[] notificationOptions