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
string[] dropLitTorchBehaviour
int iPosIndChoice = 1
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int iTorchMeterFillDirection

bool bFirstTimeDisablingTooltips = true

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

    meterFillDirectionOptions = new string[3]
    meterFillDirectionOptions[0] = "$iEquip_MCM_rep_opt_left"
    meterFillDirectionOptions[1] = "$iEquip_MCM_rep_opt_right"
    meterFillDirectionOptions[2] = "$iEquip_MCM_rep_opt_both"

    rawMeterFillDirectionOptions = new string[3] ;DO NOT TRANSLATE!
    rawMeterFillDirectionOptions[0] = "left"
    rawMeterFillDirectionOptions[1] = "right"
    rawMeterFillDirectionOptions[2] = "both"

    dropLitTorchBehaviour = new string[5]
    dropLitTorchBehaviour[0] = "$iEquip_MCM_gen_opt_DoNothing"
    dropLitTorchBehaviour[1] = "$iEquip_MCM_gen_opt_TorchNothing"
    dropLitTorchBehaviour[2] = "$iEquip_MCM_gen_opt_TorchCycle"
    dropLitTorchBehaviour[3] = "$iEquip_MCM_gen_opt_CycleLeft"
    dropLitTorchBehaviour[4] = "$iEquip_MCM_htk_opt_qckShld"

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

    jArray.addInt(jPageObj, TO.bShowTorchMeter as int)
    jArray.addInt(jPageObj, TO.iTorchMeterFillColor)
    jArray.addInt(jPageObj, iTorchMeterFillDirection)
    jArray.addFlt(jPageObj, TO.fTorchDuration)
    jArray.addInt(jPageObj, TO.bAutoReEquipTorch as int)
    jArray.addInt(jPageObj, TO.bRealisticReEquip as int)
    jArray.addFlt(jPageObj, TO.fRealisticReEquipDelay)
    jArray.addInt(jPageObj, TO.bFiniteTorchLife as int)
    jArray.addInt(jPageObj, TO.bReduceLightAsTorchRunsOut as int)
    jArray.addInt(jPageObj, TO.bDropLitTorchesEnabled as int)
    jArray.addInt(jPageObj, TO.iDropLitTorchBehavior)
	
	jArray.addInt(jPageObj, WC.bEquipOnPause as int)
	jArray.addFlt(jPageObj, WC.fEquipOnPauseDelay)
	
	jArray.addInt(jPageObj, iPosIndChoice)
	jArray.addInt(jPageObj, WC.bShowAttributeIcons as int)
	
	jArray.addInt(jPageObj, WC.bEnableGearedUp as int)
	jArray.addInt(jPageObj, WC.bUnequipAmmo as int)

	jArray.addInt(jPageObj, BM.abShowInTransformedState[0] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[1] as int)
    jArray.addInt(jPageObj, BM.abShowInTransformedState[2] as int)
    
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

    TO.bShowTorchMeter = jArray.getInt(jPageObj, 7)
    TO.iTorchMeterFillColor = jArray.getInt(jPageObj, 8)
    TO.iTorchMeterFillColorDark = multiplyRGB(TO.iTorchMeterFillColor, 0.4)
    iTorchMeterFillDirection = jArray.getInt(jPageObj, 9)
    TO.sTorchMeterFillDirection = rawMeterFillDirectionOptions[iTorchMeterFillDirection]
    TO.fTorchDuration = jArray.getInt(jPageObj, 10)
    TO.bAutoReEquipTorch = jArray.getInt(jPageObj, 11)
    TO.bRealisticReEquip = jArray.getInt(jPageObj, 12)
    TO.fRealisticReEquipDelay = jArray.getFlt(jPageObj, 13)
    TO.bFiniteTorchLife = jArray.getInt(jPageObj, 14)
    TO.bReduceLightAsTorchRunsOut = jArray.getInt(jPageObj, 15)
    TO.bDropLitTorchesEnabled = jArray.getInt(jPageObj, 16)
    TO.iDropLitTorchBehavior = jArray.getInt(jPageObj, 17)
	
	WC.bEquipOnPause = jArray.getInt(jPageObj, 18)
	WC.fEquipOnPauseDelay = jArray.getFlt(jPageObj, 19)
	
	iPosIndChoice = jArray.getInt(jPageObj, 20)
    updatePositionIndicatorSettings()

	WC.bShowAttributeIcons = jArray.getInt(jPageObj, 21)
	
	WC.bEnableGearedUp = jArray.getInt(jPageObj, 22)
	WC.bUnequipAmmo = jArray.getInt(jPageObj, 23)

	BM.abShowInTransformedState[0] = jArray.getInt(jPageObj, 24)
	BM.abShowInTransformedState[1] = jArray.getInt(jPageObj, 25)
	BM.abShowInTransformedState[2] = jArray.getInt(jPageObj, 26)
endFunction

function drawPage()

    MCM.AddToggleOptionST("gen_tgl_onOff", "$iEquip_MCM_gen_lbl_onOff", MCM.bEnabled)
    MCM.AddToggleOptionST("gen_tgl_showTooltips", "$iEquip_MCM_gen_lbl_showTooltips", WC.bShowTooltips)
           
    if MCM.bEnabled
    	MCM.AddEmptyOption()
    	if MCM.bFirstEnabled
    		MCM.AddTextOptionST("gen_txt_firstEnabled1", "$iEquip_MCM_common_lbl_firstEnabled1", "")
    		MCM.AddTextOptionST("gen_txt_firstEnabled2", "$iEquip_MCM_common_lbl_firstEnabled2", "")
    		MCM.AddTextOptionST("gen_txt_firstEnabled3", "$iEquip_MCM_common_lbl_firstEnabled3", "")
            MCM.AddEmptyOption()
            MCM.AddTextOptionST("gen_txt_firstEnabled4", "$iEquip_MCM_common_lbl_firstEnabled4", "")
            MCM.AddTextOptionST("gen_txt_firstEnabled5", "$iEquip_MCM_common_lbl_firstEnabled5", "")
    	else
	        MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
	        MCM.AddToggleOptionST("gen_tgl_enblShoutSlt", "$iEquip_MCM_gen_lbl_enblShoutSlt", WC.bShoutEnabled)
	        MCM.AddToggleOptionST("gen_tgl_enblConsumSlt", "$iEquip_MCM_gen_lbl_enblConsumSlt", WC.bConsumablesEnabled)
	        MCM.AddToggleOptionST("gen_tgl_enblPoisonSlt", "$iEquip_MCM_gen_lbl_enblPoisonSlt", WC.bPoisonsEnabled)

	        MCM.AddEmptyOption()
	        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_AmmoMode")
	        MCM.AddTextOptionST("gen_txt_AmmoModeChoice", "$iEquip_MCM_gen_lbl_AmmoModeChoice", ammoModeOptions[AM.bSimpleAmmoMode as int])
	        MCM.AddMenuOptionST("gen_men_ammoLstSrt", "$iEquip_MCM_gen_lbl_ammoLstSrt", ammoSortingOptions[AM.iAmmoListSorting])
	        MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "$iEquip_MCM_gen_lbl_whenNoAmmoLeft", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])

	        MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_TorchOptions")
            MCM.AddToggleOptionST("gen_tgl_showTorchMeter", "$iEquip_MCM_gen_lbl_showTorchMeter", TO.bShowTorchMeter)
            if TO.bShowTorchMeter
                MCM.AddColorOptionST("gen_col_torchMeterCol", "$iEquip_MCM_gen_lbl_torchMeterCol", TO.iTorchMeterFillColor)
                MCM.AddMenuOptionST("gen_men_torchMeterFillDir", "$iEquip_MCM_gen_lbl_torchMeterFillDir", meterFillDirectionOptions[iTorchMeterFillDirection])
            endIf

            MCM.AddSliderOptionST("gen_sld_torchDuration", "$iEquip_MCM_gen_lbl_torchDuration", (TO.fTorchDuration + 5.0) / 60, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_minutes"))

            MCM.AddToggleOptionST("gen_tgl_reequipTorch", "$iEquip_MCM_gen_lbl_reequipTorch", TO.bAutoReEquipTorch)
            if TO.bAutoReEquipTorch
                MCM.AddToggleOptionST("gen_tgl_realisticEquip", "$iEquip_MCM_gen_lbl_realisticEquip", TO.bRealisticReEquip)
                if TO.bRealisticReEquip
                    MCM.AddSliderOptionST("gen_sld_realisticEquipDelay", "$iEquip_MCM_gen_lbl_realisticEquipDelay", TO.fRealisticReEquipDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
                endIf
            endIf

            MCM.AddToggleOptionST("gen_tgl_finiteTorchLife", "$iEquip_MCM_gen_lbl_finiteTorchLife", TO.bFiniteTorchLife)
            if TO.bFiniteTorchLife
                MCM.AddToggleOptionST("gen_tgl_torchesFade", "$iEquip_MCM_gen_lbl_torchesFade", TO.bReduceLightAsTorchRunsOut)
            endIf

            MCM.AddToggleOptionST("gen_tgl_dropLitTorches", "$iEquip_MCM_gen_lbl_dropLitTorches", TO.bDropLitTorchesEnabled)
            if TO.bDropLitTorchesEnabled
                MCM.AddMenuOptionST("gen_men_dropLitTorchBehavior", "$iEquip_MCM_gen_lbl_dropLitTorchBehavior", dropLitTorchBehaviour[TO.iDropLitTorchBehavior])
            endIf

            MCM.SetCursorPosition(1)
	                
	        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_Cycling")
	        MCM.AddToggleOptionST("gen_tgl_eqpPaus", "$iEquip_MCM_gen_lbl_eqpPaus", WC.bEquipOnPause)
	                
	        if WC.bEquipOnPause
	            MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "$iEquip_MCM_gen_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	        endIf

	        MCM.AddMenuOptionST("gen_men_showPosInd", "$iEquip_MCM_gen_lbl_queuePosInd", posIndBehaviour[iPosIndChoice])

	        MCM.AddToggleOptionST("gen_tgl_showAtrIco", "$iEquip_MCM_gen_lbl_showAtrIco", WC.bShowAttributeIcons)

	        if WC.findInQueue(1, "$iEquip_common_Unarmed") == -1
	            MCM.AddTextOptionST("gen_txt_addFists", "$iEquip_MCM_gen_lbl_AddUnarmed", "")
	        endIf

	        MCM.AddEmptyOption()
	        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_VisGear")
	        MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "$iEquip_MCM_gen_lbl_enblAllGeard", WC.bEnableGearedUp)
	        MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "$iEquip_MCM_gen_lbl_autoUnqpAmmo", WC.bUnequipAmmo)

            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_BeastMode")
            MCM.AddToggleOptionST("gen_tgl_BM_werewolf", "$iEquip_MCM_gen_lbl_BM_werewolf", BM.abShowInTransformedState[0])
            if EH.bIsDawnguardLoaded
                MCM.AddToggleOptionST("gen_tgl_BM_vampLord", "$iEquip_MCM_gen_lbl_BM_vampLord", BM.abShowInTransformedState[1])
            endIf
            if EH.bIsUndeathLoaded
                MCM.AddToggleOptionST("gen_tgl_BM_lich", "$iEquip_MCM_gen_lbl_BM_lich", BM.abShowInTransformedState[2])
            endIf
	    endIf
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
            if !MCM.bEnabled && EH.bPlayerIsABeast
                MCM.ShowMessage("$iEquip_MCM_gen_mes_transformBackFirst", false, "$OK")
            else
                MCM.bEnabled = !MCM.bEnabled
                MCM.forcePageReset()
            endIf
        elseIf currentEvent == "Default"
            MCM.bEnabled = false 
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

; -----------------
; - Torch Options -
; -----------------

State gen_tgl_showTorchMeter
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showTorchMeter")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bShowTorchMeter)
            TO.bShowTorchMeter = !TO.bShowTorchMeter
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_col_torchMeterCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_torchMeterCol")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(TO.iTorchMeterFillColor)
            MCM.SetColorDialogDefaultColor(0xFFF8AC)
        else
            If currentEvent == "Accept"
                TO.iTorchMeterFillColor = currentVar as int
            elseIf currentEvent == "Default"
                TO.iTorchMeterFillColor = 0xFFF8AC
            endIf
            TO.iTorchMeterFillColorDark = multiplyRGB(TO.iTorchMeterFillColor, 0.4)
            MCM.SetColorOptionValueST(TO.iTorchMeterFillColor)
            TO.bSettingsChanged = true
        endIf 
    endEvent
endState

State gen_men_torchMeterFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_torchMeterFillDir")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iTorchMeterFillDirection, meterFillDirectionOptions, 0)
        elseIf currentEvent == "Accept"
            iTorchMeterFillDirection = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[iTorchMeterFillDirection])
            TO.sTorchMeterFillDirection = rawMeterFillDirectionOptions[iTorchMeterFillDirection]
            TO.bSettingsChanged = true
        endIf 
    endEvent
endState

State gen_sld_torchDuration
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_setTorchDuration")
        elseIf currentEvent == "Open"
            MCM.fillSlider((TO.fTorchDuration + 5.0) / 60.0, 1.0, TO.fMaxTorchDuration / 60.0, 0.5, TO.fMaxTorchDuration / 60.0)
        elseIf currentEvent == "Accept"
            TO.fTorchDuration = currentVar * 60.0 - 5.0
            MCM.SetSliderOptionValueST((TO.fTorchDuration + 5.0) / 60.0, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_minutes"))
            TO.bTorchDurationSettingChanged = true
        endIf
    endEvent
endState

State gen_tgl_reequipTorch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_reequipTorch")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bAutoReEquipTorch)
            TO.bAutoReEquipTorch = !TO.bAutoReEquipTorch
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_tgl_realisticEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_realisticEquip")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bRealisticReEquip)
            TO.bRealisticReEquip = !TO.bRealisticReEquip
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_realisticEquipDelay
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillSlider(TO.fRealisticReEquipDelay, 0.5, 5.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            TO.fRealisticReEquipDelay = currentVar
            MCM.SetSliderOptionValueST(TO.fRealisticReEquipDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State gen_tgl_finiteTorchLife
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_finiteTorchLife")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bFiniteTorchLife)
            TO.bFiniteTorchLife = !TO.bFiniteTorchLife
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_tgl_torchesFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_torchesFade")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bReduceLightAsTorchRunsOut)
            TO.bReduceLightAsTorchRunsOut = !TO.bReduceLightAsTorchRunsOut
            MCM.SetToggleOptionValueST(TO.bReduceLightAsTorchRunsOut)
        endIf
    endEvent
endState

State gen_tgl_dropLitTorches
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_dropLitTorches")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && TO.bDropLitTorchesEnabled)
            TO.bDropLitTorchesEnabled = !TO.bDropLitTorchesEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_men_dropLitTorchBehavior
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_dropLitTorchBehavior")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TO.iDropLitTorchBehavior, dropLitTorchBehaviour, 0)
        elseIf currentEvent == "Accept"
            TO.iDropLitTorchBehavior = currentVar as int
            MCM.SetMenuOptionValueST(dropLitTorchBehaviour[TO.iDropLitTorchBehavior])
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

State gen_men_showPosInd
    event OnBeginState()
    	if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showPosInd")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iPosIndChoice, posIndBehaviour, 1)
        elseIf currentEvent == "Accept"
            iPosIndChoice = currentVar as int
            MCM.SetMenuOptionValueST(posIndBehaviour[iPosIndChoice])
            updatePositionIndicatorSettings()
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

State gen_txt_addFists
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_addFists")
        elseIf currentEvent == "Select"
            WC.addFists()
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

; General Functions

function updatePositionIndicatorSettings()
    if iPosIndChoice == 0
        WC.bShowPositionIndicators = false
    else
        WC.bShowPositionIndicators = true
    endIf
    if iPosIndChoice == 2
        WC.bPermanentPositionIndicators = true
    else
        WC.bPermanentPositionIndicators = false
    endIf
endFunction

int function multiplyRGB(Int a_color, Float a_multiplier)
    Int red = Math.LogicalAND(a_color, 0xFF0000)
    Int green = Math.LogicalAND(a_color, 0x00FF00)
    Int blue = Math.LogicalAND(a_color, 0x0000FF)

    red = (red as float * a_multiplier) as int
    green = (green as float * a_multiplier) as int
    blue = (blue as float * a_multiplier) as int

    If (red > 0xFF0000)
        red = 0xFF0000
    EndIf
    If (green > 0x00FF00)
        green = 0x0FF000
    EndIf
    If (blue > 0x0000FF)
        blue = 0x0000FF
    EndIf
   
    Int result = Math.LogicalAND(red, 0xFF0000)
    result += Math.LogicalAND(green, 0x00FF00)
    result += Math.LogicalAND(blue, 0x0000FF)
    return result
endFunction