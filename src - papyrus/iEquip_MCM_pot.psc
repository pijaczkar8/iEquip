Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_PotionScript Property PO Auto

string[] emptyPotionQueueOptions
string[] potionSelectOptions
string[] showSelectorOptions

; #############
; ### SETUP ###

function initData()
    
    emptyPotionQueueOptions = new String[3]
    emptyPotionQueueOptions[0] = "$iEquip_MCM_pot_opt_fadeicon"
    emptyPotionQueueOptions[1] = "$iEquip_MCM_pot_opt_hideIcon"
    emptyPotionQueueOptions[2] = "$iEquip_MCM_pot_opt_leaveIcon"

    showSelectorOptions = new String[3]
    showSelectorOptions[0] = "$iEquip_MCM_pot_opt_alwaysShowSelector"
    showSelectorOptions[1] = "$iEquip_MCM_pot_opt_showAboveThreshold"
    showSelectorOptions[2] = "$iEquip_MCM_pot_opt_hybridShow"

    potionSelectOptions = new String[3]
    potionSelectOptions[0] = "$iEquip_MCM_pot_opt_alwaysStrongest"
    potionSelectOptions[1] = "$iEquip_MCM_pot_opt_smartSelect"
    potionSelectOptions[2] = "$iEquip_MCM_pot_opt_alwaysWeakest"
endFunction

function drawPage()
    ;ToDo - remove after testing
    emptyPotionQueueOptions = new String[3]
    emptyPotionQueueOptions[0] = "$iEquip_MCM_pot_opt_fadeicon"
    emptyPotionQueueOptions[1] = "$iEquip_MCM_pot_opt_hideIcon"
    emptyPotionQueueOptions[2] = "$iEquip_MCM_pot_opt_leaveIcon"
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddHeaderOption("$iEquip_MCM_pot_lbl_potOpts")
        MCM.AddToggleOptionST("pot_tgl_enblPotionGroup", "$iEquip_MCM_pot_lbl_enblPotionGroup", WC.bPotionGrouping)
                
        if WC.bPotionGrouping
            MCM.AddToggleOptionST("pot_tgl_checkAllEffects", "$iEquip_MCM_pot_lbl_checkAllEffects", PO.bCheckOtherEffects)
            MCM.AddToggleOptionST("pot_tgl_exclRestAllEffects", "$iEquip_MCM_pot_lbl_exclRestAllEffects", PO.bExcludeRestoreAllEffects)
            MCM.AddMenuOptionST("pot_men_PotionSelect", "$iEquip_MCM_pot_lbl_PotionSelect", potionSelectOptions[PO.iPotionSelectChoice])
            
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_pot_lbl_thrshldFX")
            if PO.iPotionSelectChoice == 1 ; Smart Select
                MCM.AddSliderOptionST("pot_sld_StatThreshold", "$iEquip_MCM_pot_lbl_StatThreshold", PO.fSmartConsumeThreshold*100, "{0} %")
            endIf
            MCM.AddToggleOptionST("pot_tgl_blockIfRestEffect", "$iEquip_MCM_pot_lbl_blockIfRestEffect", PO.bBlockIfRestEffectActive)
            if PO.bBlockIfRestEffectActive
                MCM.AddToggleOptionST("pot_tgl_addCombatException", "$iEquip_MCM_pot_lbl_addCombatException", PO.bSuspendChecksInCombat)
            endIf
            MCM.AddToggleOptionST("pot_tgl_blockIfBuffEffect", "$iEquip_MCM_pot_lbl_blockIfBuffEffect", PO.bBlockIfBuffEffectActive)

            
            MCM.AddEmptyOption()
            if !WC.abPotionGroupEnabled[0]
                MCM.AddTextOptionST("pot_txt_addHealthGroup", "$iEquip_MCM_gen_lbl_addHealthGroup", "")
            endIf
            if !WC.abPotionGroupEnabled[1]
                MCM.AddTextOptionST("pot_txt_addMagickaGroup", "$iEquip_MCM_gen_lbl_addMagickaGroup", "")
            endIf
            if !WC.abPotionGroupEnabled[2]
                MCM.AddTextOptionST("pot_txt_addStaminaGroup", "$iEquip_MCM_gen_lbl_addStaminaGroup", "")
            endIf
        endIf
        
        MCM.SetCursorPosition(1)

        MCM.AddHeaderOption("$iEquip_MCM_pot_lbl_potSelOpts")
        MCM.AddMenuOptionST("pot_men_showSelector", "$iEquip_MCM_pot_lbl_showSelector", showSelectorOptions[WC.iPotionSelectorChoice])
        MCM.AddSliderOptionST("pot_sld_selectorFadeDelay", "$iEquip_MCM_pot_lbl_selectorFadeDelay", WC.fPotionSelectorFadeoutDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddEmptyOption()
        
        MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
        MCM.AddMenuOptionST("pot_men_whenNoPotions", "$iEquip_MCM_pot_lbl_whenNoPotions", emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
        if PO.iEmptyPotionQueueChoice == 0
            MCM.AddSliderOptionST("pot_sld_consIcoFade", "$iEquip_MCM_pot_lbl_consIcoFade", WC.fconsIconFadeAmount, "{0}%")
        endIf
        MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "$iEquip_MCM_pot_lbl_warningOnLastPotion", PO.bFlashPotionWarning)
        MCM.AddToggleOptionST("pot_tgl_enblRestPotWarn", "$iEquip_MCM_pot_lbl_enblRestPotWarn", PO.bEnableRestorePotionWarnings)
        if PO.bEnableRestorePotionWarnings
            MCM.AddToggleOptionST("pot_tgl_lowRestPotNot", "$iEquip_MCM_pot_lbl_lowRestPotNot", PO.bNotificationOnLowRestorePotions)
        endIf
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
            MCM.fillSlider(PO.fSmartConsumeThreshold*100, 5.0, 100.0, 5.0, 40.0)
        elseIf currentEvent == "Accept"
            PO.fSmartConsumeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PO.fSmartConsumeThreshold*100, "{0} %")
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

State pot_txt_addHealthGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addHealthGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(0)
            WC.abPotionGroupAddedBack[0] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_addMagickaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addMagickaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(1)
            WC.abPotionGroupAddedBack[1] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_addStaminaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addStaminaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(2)
            WC.abPotionGroupAddedBack[2] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
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
