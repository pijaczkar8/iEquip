Scriptname iEquip_MCM_gen extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_AmmoMode property AM auto
iEquip_BeastMode property BM auto
iEquip_PlayerEventHandler property EH auto
iEquip_TorchScript property TO auto
iEquip_KeyHandler Property KH Auto
iEquip_ProMode Property PM Auto

int mcmUnmapFLAG

bool bFirstTimeDisablingTooltips = true
bool bFirstEnabled = false

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bShowTooltips as int)
	jArray.addInt(jPageObj, WC.bShoutEnabled as int)
	jArray.addInt(jPageObj, WC.bConsumablesEnabled as int)
	jArray.addInt(jPageObj, WC.bPoisonsEnabled as int)

    jArray.addInt(jPageObj, PM.bScanInventory as int)

	jArray.addInt(jPageObj, BM.abShowInTransformedState[0] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[1] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[2] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[3] as int)

    jArray.addInt(jPageObj, KH.iLeftKey)
    jArray.addInt(jPageObj, KH.iRightKey)
    jArray.addInt(jPageObj, KH.iShoutKey)
    jArray.addInt(jPageObj, KH.iConsumableKey)
    jArray.addInt(jPageObj, KH.iUtilityKey)
    jArray.addInt(jPageObj, KH.bNoUtilMenuInCombat as int)
    
    jArray.addFlt(jPageObj, KH.fMultiTapDelay)
    jArray.addFlt(jPageObj, KH.fLongPressDelay)
    
    jArray.addInt(jPageObj, KH.bExtendedKbControlsEnabled as int)
    jArray.addInt(jPageObj, KH.iConsumeItemKey)
    jArray.addInt(jPageObj, KH.iCyclePoisonKey)
    jArray.addInt(jPageObj, KH.iQuickRestoreKey)
    jArray.addInt(jPageObj, KH.iQuickShieldKey)
    jArray.addInt(jPageObj, KH.iQuickRangedKey)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	WC.bShowTooltips = jArray.getInt(jPageObj, 0)
	WC.bShoutEnabled = jArray.getInt(jPageObj, 1)
	WC.bConsumablesEnabled = jArray.getInt(jPageObj, 2)
	WC.bPoisonsEnabled = jArray.getInt(jPageObj, 3)

    PM.bScanInventory = jArray.getInt(jPageObj, 40)

	BM.abShowInTransformedState[0] = jArray.getInt(jPageObj, 13)
	BM.abShowInTransformedState[1] = jArray.getInt(jPageObj, 14)
	BM.abShowInTransformedState[2] = jArray.getInt(jPageObj, 15)
    BM.abShowInTransformedState[3] = jArray.getInt(jPageObj, 16)

    KH.iLeftKey = jArray.getInt(jPageObj, 0)
    KH.iRightKey = jArray.getInt(jPageObj, 1)
    KH.iShoutKey = jArray.getInt(jPageObj, 2)
    KH.iConsumableKey = jArray.getInt(jPageObj, 3)
    KH.iUtilityKey = jArray.getInt(jPageObj, 4)
    KH.bNoUtilMenuInCombat = jArray.getInt(jPageObj, 5)
    
    KH.fMultiTapDelay = jArray.getFlt(jPageObj, 6)
    KH.fLongPressDelay = jArray.getFlt(jPageObj, 7)
    
    KH.bExtendedKbControlsEnabled = jArray.getInt(jPageObj, 8)
    KH.iConsumeItemKey = jArray.getInt(jPageObj, 9)
    KH.iCyclePoisonKey = jArray.getInt(jPageObj, 10)
    KH.iQuickRestoreKey = jArray.getInt(jPageObj, 11)
    KH.iQuickShieldKey = jArray.getInt(jPageObj, 12)
    KH.iQuickRangedKey = jArray.getInt(jPageObj, 13)
endFunction

function drawPage()

    if MCM.bEnabled
        MCM.AddToggleOptionST("gen_tgl_onOff", "<font color='#c7ea46'>$iEquip_MCM_gen_lbl_onOff</font>", MCM.bEnabled)
    else
        MCM.AddToggleOptionST("gen_tgl_onOff", "<font color='#ff7417'>$iEquip_MCM_gen_lbl_onOff</font>", MCM.bEnabled)
    endIf
    MCM.AddToggleOptionST("gen_tgl_showTooltips", "$iEquip_MCM_gen_lbl_showTooltips", WC.bShowTooltips)
    MCM.AddEmptyOption()
	
    if WC.isEnabled
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
		MCM.AddToggleOptionST("gen_tgl_enblShoutSlt", "$iEquip_MCM_gen_lbl_enblShoutSlt", WC.bShoutEnabled)
		MCM.AddToggleOptionST("gen_tgl_enblConsumSlt", "$iEquip_MCM_gen_lbl_enblConsumSlt", WC.bConsumablesEnabled)
		MCM.AddToggleOptionST("gen_tgl_enblPoisonSlt", "$iEquip_MCM_gen_lbl_enblPoisonSlt", WC.bPoisonsEnabled)

        MCM.AddEmptyOption()

		MCM.AddEmptyOption()
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_BeastMode</font>")
		MCM.AddToggleOptionST("gen_tgl_BM_werewolf", "$iEquip_MCM_gen_lbl_BM_werewolf", BM.abShowInTransformedState[0])
		if Game.GetModByName("Dawnguard.esm") != 255
			MCM.AddToggleOptionST("gen_tgl_BM_vampLord", "$iEquip_MCM_gen_lbl_BM_vampLord", BM.abShowInTransformedState[1])
		endIf
		if Game.GetModByName("Undeath.esp") != 255
			MCM.AddToggleOptionST("gen_tgl_BM_lich", "$iEquip_MCM_gen_lbl_BM_lich", BM.abShowInTransformedState[2])
		endIf
        if Game.GetModByName("The Path of Transcendence.esp") != 255
            MCM.AddToggleOptionST("gen_tgl_BM_POTBoneTyrant", "$iEquip_MCM_gen_lbl_BM_POTBoneTyrant", BM.abShowInTransformedState[3])
        endIf
	elseIf bFirstEnabled
		MCM.AddTextOptionST("gen_txt_firstEnabled1", "$iEquip_MCM_common_lbl_firstEnabled1", "")
		MCM.AddTextOptionST("gen_txt_firstEnabled2", "$iEquip_MCM_common_lbl_firstEnabled2", "")
		MCM.AddTextOptionST("gen_txt_firstEnabled3", "$iEquip_MCM_common_lbl_firstEnabled3", "")
		MCM.AddEmptyOption()
		MCM.AddTextOptionST("gen_txt_firstEnabled4", "$iEquip_MCM_common_lbl_firstEnabled4", "")
		MCM.AddTextOptionST("gen_txt_firstEnabled5", "$iEquip_MCM_common_lbl_firstEnabled5", "")
    else
        MCM.AddTextOptionST("gen_txt_altStartWarning1", "$iEquip_MCM_common_lbl_altStartWarning1", "")
        MCM.AddTextOptionST("gen_txt_altStartWarning2", "$iEquip_MCM_common_lbl_altStartWarning2", "")
        MCM.AddTextOptionST("gen_txt_altStartWarning3", "$iEquip_MCM_common_lbl_altStartWarning3", "")
        MCM.AddTextOptionST("gen_txt_altStartWarning4", "$iEquip_MCM_common_lbl_altStartWarning4", "")
    endIf
endFunction

; ########################
; ### General Settings ###
; ########################

State gen_tgl_onOff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_onOff")
        elseIf currentEvent == "Select"
            if MCM.bEnabled
                MCM.bEnabled = false
                bFirstEnabled = false
                MCM.forcePageReset()
            elseIf !JContainers.isInstalled()                                               ; Dependency checks
                MCM.ShowMessage("$iEquip_MCM_gen_mes_jcontmissing", false, "$OK")
            elseIf !(JContainers.APIVersion() >= 3 && JContainers.featureVersion() >= 3)
            ; SSE Note - Comment out the preceding line and uncomment the following - JContainers versions differ between LE and SE    
            ;elseIf !(JContainers.APIVersion() >= 4 && JContainers.featureVersion() >= 1)
                MCM.ShowMessage("$iEquip_MCM_gen_mes_jcontoldversion", false, "$OK")
            else                                                                            ; Requirement checks
                Quest LALChargen = Quest.GetQuest("ARTHLALChargenQuest")
                Quest UnboundChargen = Quest.GetQuest("SkyrimUnbound")

                bool IgnoreAltStartQuestWarnings
                
                if (LALChargen && UnboundChargen) && MCM.ShowMessage("$iEquip_MCM_gen_mes_dontUseBoth", true, iEquip_StringExt.LocalizeString("$iEquip_btn_continue"), "$Cancel")
                    IgnoreAltStartQuestWarnings = true
                elseIf (LALChargen && !LALChargen.IsCompleted()) && MCM.ShowMessage("$iEquip_MCM_gen_mes_finishChargenFirst", true, iEquip_StringExt.LocalizeString("$iEquip_btn_continue"), "$Cancel")
                    IgnoreAltStartQuestWarnings = true
                elseIf (UnboundChargen && !UnboundChargen.IsCompleted()) && MCM.ShowMessage("$iEquip_MCM_gen_mes_finishChargenUnboundFirst", true, iEquip_StringExt.LocalizeString("$iEquip_btn_continue"), "$Cancel")
                    IgnoreAltStartQuestWarnings = true
                endIf
                
                if EH.bPlayerIsABeast
                    MCM.ShowMessage("$iEquip_MCM_gen_mes_transformBackFirst", false, "$OK")
                elseIf !(LALChargen || UnboundChargen) || IgnoreAltStartQuestWarnings
                    MCM.bEnabled = true
                    bFirstEnabled = true
                    MCM.forcePageReset()
                endIf
            endIf
        elseIf currentEvent == "Default"
            MCM.bEnabled = false 
            bFirstEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_tgl_showTooltips
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showTooltips")
        elseIf currentEvent == "Select"
            if !WC.bShowTooltips || (!bFirstTimeDisablingTooltips || MCM.ShowMessage("$iEquip_MCM_gen_msg_showTooltips",  true, "$Yes", "$No"))
                bFirstTimeDisablingTooltips = false
                WC.bShowTooltips = !WC.bShowTooltips
            endIf
            MCM.SetToggleOptionValueST(WC.bShowTooltips)
        elseIf currentEvent == "Default"
            WC.bShowTooltips = true 
            MCM.SetToggleOptionValueST(WC.bShowTooltips)
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State gen_tgl_enblShoutSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblShoutSlt")
        elseIf currentEvent == "Select"
            WC.bShoutEnabled = !WC.bShoutEnabled
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bShoutEnabled = true 
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblConsumSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblConsumSlt")
        elseIf currentEvent == "Select"
            WC.bConsumablesEnabled = !WC.bConsumablesEnabled
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bConsumablesEnabled = true 
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblPoisonSlt")
        elseIf currentEvent == "Select"
            WC.bPoisonsEnabled = !WC.bPoisonsEnabled
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bPoisonsEnabled = true 
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState



; ------------------------
; - Auto-Equipping Options -
; ------------------------ 

State gen_men_enableAutoEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enableAutoEquip")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iAutoEquipEnabled, autoEquipOptions, 0)
        elseIf currentEvent == "Accept"
            bool reset
            if (WC.iAutoEquipEnabled > 0 && currentVar as int == 0) || (WC.iAutoEquipEnabled == 0 && currentVar as int > 0)
                reset = true
            endIf
            WC.iAutoEquipEnabled = currentVar as int
            if reset
                MCM.forcePageReset()
            else
                MCM.SetMenuOptionValueST(autoEquipOptions[WC.iAutoEquipEnabled])
            endIf
        endIf
    endEvent
endState

State gen_men_whenToAutoEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_whenToAutoEquip")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iAutoEquip, whenToAutoEquipOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iAutoEquip = currentVar as int
            MCM.SetMenuOptionValueST(whenToAutoEquipOptions[WC.iAutoEquip])
        endIf
    endEvent
endState

State gen_men_currItemEnch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_currItemEnch")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iCurrentItemEnchanted, currItemEnchOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iCurrentItemEnchanted = currentVar as int
            MCM.SetMenuOptionValueST(currItemEnchOptions[WC.iCurrentItemEnchanted])
        endIf
    endEvent
endState

State gen_men_currItemPois
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_currItemPois")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iCurrentItemPoisoned, currItemPoisOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iCurrentItemPoisoned = currentVar as int
            MCM.SetMenuOptionValueST(currItemPoisOptions[WC.iCurrentItemPoisoned])
        endIf
    endEvent
endState

State gen_tgl_autoEquipHardcore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_autoEquipHardcore")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && WC.bAutoEquipHardcore)
            WC.bAutoEquipHardcore = !WC.bAutoEquipHardcore
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_tgl_dontDropFavorites
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_dontDropFavorites")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !WC.bAutoEquipDontDropFavorites)
            WC.bAutoEquipDontDropFavorites = !WC.bAutoEquipDontDropFavorites
            MCM.SetToggleOptionValueST(WC.bAutoEquipDontDropFavorites)
        endIf
    endEvent
endState

; ---------------------
; - Cycling Behaviour -
; ---------------------

State gen_tgl_eqpPaus
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_eqpPaus")
        elseIf currentEvent == "Select"
            WC.bEquipOnPause = !WC.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillSlider(WC.fEquipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            WC.fEquipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State gen_tgl_slowTime
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_slowTime")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && WC.bSlowTimeWhileCycling)
            WC.bSlowTimeWhileCycling = !WC.bSlowTimeWhileCycling
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_slowTimeStr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_slowTimeStr")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iCycleSlowTimeStrength as float, 0.0, 100.0, 5.0, 50.0)
        elseIf currentEvent == "Accept"
            WC.iCycleSlowTimeStrength = currentVar as int
            MCM.SetSliderOptionValueST(currentVar, "{0}%")
        endIf 
    endEvent
endState

State gen_men_showPosInd
    event OnBeginState()
    	if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showPosInd")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iPosInd, posIndBehaviour, 1)
        elseIf currentEvent == "Accept"
            WC.iPosInd = currentVar as int
            MCM.SetMenuOptionValueST(posIndBehaviour[WC.iPosInd])
        endIf
    endEvent
endState

State gen_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showAtrIco")
        elseIf currentEvent == "Select"
            WC.bShowAttributeIcons = !WC.bShowAttributeIcons
            MCM.SetToggleOptionValueST(WC.bShowAttributeIcons)
            WC.bAttributeIconsOptionChanged = true
        endIf
    endEvent
endState

; ---------------------
; - Unarmed Shortcuts -
; ---------------------

State gen_tgl_skipUnarmed
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_skipUnarmed")
        elseIf currentEvent == "Select"
            WC.bSkipRHUnarmedInCombat = !WC.bSkipRHUnarmedInCombat
            MCM.SetToggleOptionValueST(WC.bSkipRHUnarmedInCombat)
        endIf
    endEvent
endState

State gen_txt_addFistsLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_addFistsLeft")
        elseIf currentEvent == "Select"
            WC.addFists(0)
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_txt_addFistsRight
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_addFistsRight")
        elseIf currentEvent == "Select"
            WC.addFists(1)
            MCM.forcePageReset()
        endIf
    endEvent
endState

; ------------------------
; - Visible Gear Options -
; ------------------------        

State gen_tgl_enblAllGeard
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblAllGeard")
        elseIf currentEvent == "Select"
            WC.bEnableGearedUp = !WC.bEnableGearedUp
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        elseIf currentEvent == "Default"
            WC.bEnableGearedUp = true 
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        endIf
    endEvent
endState

State gen_tgl_autoUnqpAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_autoUnqpAmmo")
        elseIf currentEvent == "Select"
            WC.bUnequipAmmo = !WC.bUnequipAmmo
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
        elseIf currentEvent == "Default"
            WC.bUnequipAmmo = true 
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
        endIf
    endEvent
endState

; ------------------------
; -  Beast Mode Options  -
; ------------------------ 

State gen_tgl_BM_werewolf
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_BM_werewolf")
        elseIf currentEvent == "Select"
            BM.abShowInTransformedState[0] = !BM.abShowInTransformedState[0]
            MCM.SetToggleOptionValueST(BM.abShowInTransformedState[0])
            WC.bBeastModeOptionsChanged = true
        endIf
    endEvent
endState
State gen_tgl_BM_vampLord
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_BM_vampLord")
        elseIf currentEvent == "Select"
            BM.abShowInTransformedState[1] = !BM.abShowInTransformedState[1]
            MCM.SetToggleOptionValueST(BM.abShowInTransformedState[1])
            WC.bBeastModeOptionsChanged = true
        endIf
    endEvent
endState
State gen_tgl_BM_lich
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_BM_lich")
        elseIf currentEvent == "Select"
            BM.abShowInTransformedState[2] = !BM.abShowInTransformedState[2]
            MCM.SetToggleOptionValueST(BM.abShowInTransformedState[2])
            WC.bBeastModeOptionsChanged = true
        endIf
    endEvent
endState
State gen_tgl_BM_POTBoneTyrant
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_BM_POTBoneTyrant")
        elseIf currentEvent == "Select"
            BM.abShowInTransformedState[3] = !BM.abShowInTransformedState[3]
            MCM.SetToggleOptionValueST(BM.abShowInTransformedState[3])
            WC.bBeastModeOptionsChanged = true
        endIf
    endEvent
endState
