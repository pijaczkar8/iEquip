Scriptname iEquip_MCM_gen extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_AmmoMode property AM auto
iEquip_BeastMode property BM auto
iEquip_PlayerEventHandler property EH auto
iEquip_TorchScript property TO auto

string[] ammoSortingOptions
string[] whenNoAmmoLeftOptions
string[] ammoModeOptions
string[] posIndBehaviour

bool bFirstTimeDisablingTooltips = true
bool bFirstEnabled = false

; #############
; ### SETUP ###

function initData()
    ammoSortingOptions = new string[4]
    ammoSortingOptions[0] = "$iEquip_MCM_gen_opt_Unsorted"
    ammoSortingOptions[1] = "$iEquip_MCM_gen_opt_ByDamage"
    ammoSortingOptions[2] = "$iEquip_MCM_gen_opt_Alphabetically"
    ammoSortingOptions[3] = "$iEquip_MCM_gen_opt_ByQuantity"

    whenNoAmmoLeftOptions = new string[4]
    whenNoAmmoLeftOptions[0] = "$iEquip_MCM_gen_opt_DoNothing"
    whenNoAmmoLeftOptions[1] = "$iEquip_MCM_gen_opt_SwitchNothing"
    whenNoAmmoLeftOptions[2] = "$iEquip_MCM_gen_opt_SwitchCycle"
    whenNoAmmoLeftOptions[3] = "$iEquip_MCM_gen_opt_Cycle"

    ammoModeOptions = new string[2]
    ammoModeOptions[0] = "$iEquip_MCM_gen_opt_advAM"
    ammoModeOptions[1] = "$iEquip_MCM_gen_opt_simpleAM"

    posIndBehaviour = new string[3]
    posIndBehaviour[0] = "$iEquip_MCM_common_opt_disabled"
    posIndBehaviour[1] = "$iEquip_MCM_gen_opt_onlyCycling"
    posIndBehaviour[2] = "$iEquip_MCM_gen_opt_alwaysVisible"

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bShowTooltips as int)
	jArray.addInt(jPageObj, WC.bShoutEnabled as int)
	jArray.addInt(jPageObj, WC.bConsumablesEnabled as int)
	jArray.addInt(jPageObj, WC.bPoisonsEnabled as int)
	
	jArray.addInt(jPageObj, AM.bSimpleAmmoMode as int)
	jArray.addInt(jPageObj, AM.iAmmoListSorting)
	jArray.addInt(jPageObj, AM.iActionOnLastAmmoUsed)
	
	jArray.addInt(jPageObj, WC.bEquipOnPause as int)
	jArray.addFlt(jPageObj, WC.fEquipOnPauseDelay)
	
	jArray.addInt(jPageObj, WC.iPosInd)
	jArray.addInt(jPageObj, WC.bShowAttributeIcons as int)
	
	jArray.addInt(jPageObj, WC.bEnableGearedUp as int)
	jArray.addInt(jPageObj, WC.bUnequipAmmo as int)

	jArray.addInt(jPageObj, BM.abShowInTransformedState[0] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[1] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[2] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[3] as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj
	WC.bShowTooltips = jArray.getInt(jPageObj, 0)
	WC.bShoutEnabled = jArray.getInt(jPageObj, 1)
	WC.bConsumablesEnabled = jArray.getInt(jPageObj, 2)
	WC.bPoisonsEnabled = jArray.getInt(jPageObj, 3)
	
	AM.bSimpleAmmoMode = jArray.getInt(jPageObj, 4)
	AM.iAmmoListSorting = jArray.getInt(jPageObj, 5)
	AM.iActionOnLastAmmoUsed = jArray.getInt(jPageObj, 6)
	
	WC.bEquipOnPause = jArray.getInt(jPageObj, 7)
	WC.fEquipOnPauseDelay = jArray.getFlt(jPageObj, 8)
	
	WC.iPosInd = jArray.getInt(jPageObj, 9)

	WC.bShowAttributeIcons = jArray.getInt(jPageObj, 10)
	
	WC.bEnableGearedUp = jArray.getInt(jPageObj, 11)
	WC.bUnequipAmmo = jArray.getInt(jPageObj, 12)

	BM.abShowInTransformedState[0] = jArray.getInt(jPageObj, 13)
	BM.abShowInTransformedState[1] = jArray.getInt(jPageObj, 14)
	BM.abShowInTransformedState[2] = jArray.getInt(jPageObj, 15)
    BM.abShowInTransformedState[3] = jArray.getInt(jPageObj, 16)
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
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_AmmoMode</font>")
		MCM.AddTextOptionST("gen_txt_AmmoModeChoice", "$iEquip_MCM_gen_lbl_AmmoModeChoice", ammoModeOptions[AM.bSimpleAmmoMode as int])
		MCM.AddMenuOptionST("gen_men_ammoLstSrt", "$iEquip_MCM_gen_lbl_ammoLstSrt", ammoSortingOptions[AM.iAmmoListSorting])
		MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "$iEquip_MCM_gen_lbl_whenNoAmmoLeft", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])

		MCM.SetCursorPosition(1)
				
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_Cycling</font>")
		MCM.AddToggleOptionST("gen_tgl_eqpPaus", "$iEquip_MCM_gen_lbl_eqpPaus", WC.bEquipOnPause)
				
		if WC.bEquipOnPause
			MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "$iEquip_MCM_gen_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
            MCM.AddToggleOptionST("gen_tgl_slowTime", "$iEquip_MCM_gen_lbl_slowTime", WC.bSlowTimeWhileCycling)
            if WC.bSlowTimeWhileCycling
                MCM.AddSliderOptionST("gen_sld_slowTimeStr", "$iEquip_MCM_common_lbl_slowTimeStr", WC.iCycleSlowTimeStrength as float, "{0}%")
            endIf
		endIf

		MCM.AddMenuOptionST("gen_men_showPosInd", "$iEquip_MCM_gen_lbl_queuePosInd", posIndBehaviour[WC.iPosInd])

		MCM.AddToggleOptionST("gen_tgl_showAtrIco", "$iEquip_MCM_gen_lbl_showAtrIco", WC.bShowAttributeIcons)

        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_unarmedOptions</font>")

        MCM.AddToggleOptionST("gen_tgl_skipUnarmed", "$iEquip_MCM_gen_lbl_skipUnarmed", WC.bSkipRHUnarmedInCombat)

		if WC.findInQueue(0, "$iEquip_common_Unarmed") == -1
            MCM.AddTextOptionST("gen_txt_addFistsLeft", "$iEquip_MCM_gen_lbl_AddUnarmedLeft", "")
        endIf

        if WC.findInQueue(1, "$iEquip_common_Unarmed") == -1
			MCM.AddTextOptionST("gen_txt_addFistsRight", "$iEquip_MCM_gen_lbl_AddUnarmedRight", "")
		endIf

		MCM.AddEmptyOption()
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_VisGear</font>")
		MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "$iEquip_MCM_gen_lbl_enblAllGeard", WC.bEnableGearedUp)
		MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "$iEquip_MCM_gen_lbl_autoUnqpAmmo", WC.bUnequipAmmo)

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
            ;Block enabling if player is currently a werewolf, vampire lord or lich.  iEquip will handle any subsequent player transformations once enabled.
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
                
                if (LALChargen && !LALChargen.IsCompleted())
                    MCM.ShowMessage("$iEquip_MCM_gen_mes_finishChargenFirst", false, "$OK")
                elseIf (UnboundChargen && !UnboundChargen.IsCompleted())
                    MCM.ShowMessage("$iEquip_MCM_gen_mes_finishChargenUnboundFirst", false, "$OK")
                elseIf EH.bPlayerIsABeast
                    MCM.ShowMessage("$iEquip_MCM_gen_mes_transformBackFirst", false, "$OK")
                else
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
; - Ammo Mode Options -
; ------------------------ 

State gen_txt_AmmoModeChoice
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_AmmoModeChoice")
        elseIf currentEvent == "Select"
            AM.bSimpleAmmoMode = !AM.bSimpleAmmoMode
            MCM.SetTextOptionValueST(ammoModeOptions[AM.bSimpleAmmoMode as int])
        endIf
    endEvent
endState

State gen_men_ammoLstSrt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_ammoLstSrt")
        elseIf currentEvent == "Open"
            MCM.fillMenu(AM.iAmmoListSorting, ammoSortingOptions, 0)
        elseIf currentEvent == "Accept"
            AM.iAmmoListSorting = currentVar as int
            MCM.SetMenuOptionValueST(ammoSortingOptions[AM.iAmmoListSorting])
            WC.bAmmoSortingChanged = true
        endIf
    endEvent
endState

State gen_men_whenNoAmmoLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_whenNoAmmoLeft")
        elseIf currentEvent == "Open"
            MCM.fillMenu(AM.iActionOnLastAmmoUsed, whenNoAmmoLeftOptions, 2)
        elseIf currentEvent == "Accept"
            AM.iActionOnLastAmmoUsed = currentVar as int
            MCM.SetMenuOptionValueST(whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
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
            MCM.fillSlider(WC.iCycleSlowTimeStrength as float, 0.0, 100.0, 10.0, 50.0)
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
