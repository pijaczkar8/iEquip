Scriptname iEquip_MCM_gen extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_AmmoMode property AM auto
iEquip_BeastMode property BM auto
iEquip_PlayerEventHandler property EH auto

string[] ammoSortingOptions
string[] whenNoAmmoLeftOptions
string[] posIndBehaviour

bool bFirstTimeDisablingTooltips = true

; #############
; ### SETUP ###

function initData()
    ammoSortingOptions = new String[4]
    ammoSortingOptions[0] = "$iEquip_MCM_gen_opt_Unsorted"
    ammoSortingOptions[1] = "$iEquip_MCM_gen_opt_ByDamage"
    ammoSortingOptions[2] = "$iEquip_MCM_gen_opt_Alphabetically"
    ammoSortingOptions[3] = "$iEquip_MCM_gen_opt_ByQuantity"

    whenNoAmmoLeftOptions = new String[4]
    whenNoAmmoLeftOptions[0] = "$iEquip_MCM_gen_opt_DoNothing"
    whenNoAmmoLeftOptions[1] = "$iEquip_MCM_gen_opt_SwitchNothing"
    whenNoAmmoLeftOptions[2] = "$iEquip_MCM_gen_opt_SwitchCycle"
    whenNoAmmoLeftOptions[3] = "$iEquip_MCM_gen_opt_Cycle"

    posIndBehaviour = new String[2]
    posIndBehaviour[0] = "$iEquip_MCM_gen_opt_onlyCycling"
    posIndBehaviour[1] = "$iEquip_MCM_gen_opt_alwaysVisible"

endFunction

function drawPage()
    MCM.AddToggleOptionST("gen_tgl_onOff", "$iEquip_MCM_gen_lbl_onOff", MCM.bEnabled)
    MCM.AddToggleOptionST("gen_tgl_showTooltips", "$iEquip_MCM_gen_lbl_showTooltips", WC.bShowTooltips)
           
    if MCM.bEnabled
    	if MCM.bFirstEnabled
    		MCM.AddEmptyOption()
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
	        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_VisGear")
	        MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "$iEquip_MCM_gen_lbl_enblAllGeard", WC.bEnableGearedUp)
	        MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "$iEquip_MCM_gen_lbl_autoUnqpAmmo", WC.bUnequipAmmo)

	        MCM.SetCursorPosition(1)
	                
	        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_Cycling")
	        MCM.AddToggleOptionST("gen_tgl_eqpPaus", "$iEquip_MCM_gen_lbl_eqpPaus", WC.bEquipOnPause)
	                
	        if WC.bEquipOnPause
	            MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "$iEquip_MCM_gen_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	        endIf

	        MCM.AddToggleOptionST("gen_tgl_showPosInd", "$iEquip_MCM_gen_lbl_showshowPosInd", WC.bShowPositionIndicators)
            if WC.bShowPositionIndicators
                MCM.AddTextOptionST("gen_txt_posIndBehaviour", "", posIndBehaviour[WC.bPermanentPositionIndicators as int])
            endIf
	        MCM.AddToggleOptionST("gen_tgl_showAtrIco", "$iEquip_MCM_gen_lbl_showAtrIco", WC.bShowAttributeIcons)
	        MCM.AddMenuOptionST("gen_men_ammoLstSrt", "$iEquip_MCM_gen_lbl_ammoLstSrt", ammoSortingOptions[AM.iAmmoListSorting])
	        MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "$iEquip_MCM_gen_lbl_whenNoAmmoLeft", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
	        if WC.findInQueue(1, "$iEquip_common_Unarmed") == -1
	            MCM.AddTextOptionST("gen_txt_addFists", "$iEquip_MCM_gen_lbl_AddUnarmed", "")
	        endIf

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
            if !WC.bShowTooltips || (bFirstTimeDisablingTooltips && MCM.ShowMessage("$iEquip_MCM_gen_msg_showTooltips",  true, "$Yes", "$No"))
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

State gen_tgl_showPosInd
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showPosInd")
        elseIf currentEvent == "Select"
            WC.bShowPositionIndicators = !WC.bShowPositionIndicators
            MCM.SetToggleOptionValueST(WC.bShowPositionIndicators)
            MCM.ForcePageReset()
        endIf
    endEvent
endState

State gen_txt_posIndBehaviour
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_posIndBehaviour")
        elseIf currentEvent == "Select"
            WC.bPermanentPositionIndicators = !WC.bPermanentPositionIndicators
            MCM.SetTextOptionValueST(posIndBehaviour[WC.bPermanentPositionIndicators as int])
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