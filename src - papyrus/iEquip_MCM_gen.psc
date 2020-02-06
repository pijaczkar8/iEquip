Scriptname iEquip_MCM_gen extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_BeastMode property BM auto
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

    PM.bScanInventory = jArray.getInt(jPageObj, 4)

	BM.abShowInTransformedState[0] = jArray.getInt(jPageObj, 5)
	BM.abShowInTransformedState[1] = jArray.getInt(jPageObj,6)
	BM.abShowInTransformedState[2] = jArray.getInt(jPageObj, 7)
    BM.abShowInTransformedState[3] = jArray.getInt(jPageObj, 8)

    KH.iLeftKey = jArray.getInt(jPageObj, 9)
    KH.iRightKey = jArray.getInt(jPageObj, 10)
    KH.iShoutKey = jArray.getInt(jPageObj, 11)
    KH.iConsumableKey = jArray.getInt(jPageObj, 12)
    KH.iUtilityKey = jArray.getInt(jPageObj, 13)
    KH.bNoUtilMenuInCombat = jArray.getInt(jPageObj, 14)
    
    KH.fMultiTapDelay = jArray.getFlt(jPageObj, 15)
    KH.fLongPressDelay = jArray.getFlt(jPageObj, 16)
    
    KH.bExtendedKbControlsEnabled = jArray.getInt(jPageObj, 17)
    KH.iConsumeItemKey = jArray.getInt(jPageObj, 18)
    KH.iCyclePoisonKey = jArray.getInt(jPageObj, 19)
    KH.iQuickRestoreKey = jArray.getInt(jPageObj, 20)
    KH.iQuickShieldKey = jArray.getInt(jPageObj, 21)
    KH.iQuickRangedKey = jArray.getInt(jPageObj, 22)
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

		MCM.AddToggleOptionST("gen_tgl_allowInvScan", "$iEquip_MCM_gen_lbl_allowInvScan", PM.bScanInventory)

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

        MCM.SetCursorPosition(1)

        MCM.AddTextOptionST("gen_txt_htkHelp", "<font color='#a6bffe'>$iEquip_MCM_gen_lbl_htkHelp</font>", "")
        
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_MainHtks</font>")
        MCM.AddKeyMapOptionST("gen_key_leftHand", "$iEquip_MCM_gen_lbl_leftHand", KH.iLeftKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("gen_key_rightHand", "$iEquip_MCM_gen_lbl_rightHand", KH.iRightKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("gen_key_shout", "$iEquip_MCM_gen_lbl_shout", KH.iShoutKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("gen_key_consumPoison", "$iEquip_MCM_gen_lbl_consumPoison", KH.iConsumableKey, mcmUnmapFLAG)
        MCM.AddEmptyOption()
                
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_UtHtkOpts</font>")
        MCM.AddKeyMapOptionST("gen_key_util", "$iEquip_MCM_gen_lbl_util", KH.iUtilityKey, mcmUnmapFLAG)
        MCM.AddToggleOptionST("gen_tgl_blockUtilMenuInCombat", "$iEquip_MCM_gen_lbl_blockUtilMenuInCombat", KH.bNoUtilMenuInCombat)
        
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_KeyPressOpts</font>")
        MCM.AddSliderOptionST("gen_sld_multiTapDelay", "$iEquip_MCM_gen_lbl_multiTapDelay", KH.fMultiTapDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddSliderOptionST("gen_sld_longPrsDelay", "$iEquip_MCM_gen_lbl_longPrsDelay", KH.fLongPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddEmptyOption()
        
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_ExtKbCtrls</font>")
        MCM.AddToggleOptionST("gen_tgl_enblExtKbCtrls", "$iEquip_MCM_gen_lbl_enblExtKbCtrls", KH.bExtendedKbControlsEnabled)
        
        if KH.bExtendedKbControlsEnabled
            MCM.AddKeyMapOptionST("gen_key_consItem", "$iEquip_MCM_gen_lbl_consItem", KH.iConsumeItemKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("gen_key_cyclePoison", "$iEquip_MCM_gen_lbl_cyclePoison", KH.iCyclePoisonKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("gen_key_quickRestore", "$iEquip_MCM_gen_lbl_quickRestore", KH.iQuickRestoreKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("gen_key_quickShield", "$iEquip_MCM_gen_lbl_quickShield", KH.iQuickShieldKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("gen_key_quickRanged", "$iEquip_MCM_gen_lbl_quickRanged", KH.iQuickRangedKey, mcmUnmapFLAG)
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

; ------------------------------
; - Inventory Scanning Options -
; ------------------------------

State gen_tgl_allowInvScan
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_allowInvScan")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bScanInventory)
            PM.bScanInventory = !PM.bScanInventory
            MCM.SetToggleOptionValueST(PM.bScanInventory)
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

; ######################
; ### Hotkey Options ###
; ######################

State gen_txt_htkHelp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_htkHelp")
        elseIf currentEvent == "Select"
            bool bKeepReading = MCM.ShowMessage("$iEquip_help_controls0",  true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
            if bKeepReading 
                bKeepReading = MCM.ShowMessage("$iEquip_help_controls1",  true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if bKeepReading
                    bKeepReading = MCM.ShowMessage("$iEquip_help_controls2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    if bKeepReading
                        bKeepReading = MCM.ShowMessage("$iEquip_help_controls3", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                        if bKeepReading
                            bKeepReading = MCM.ShowMessage("$iEquip_help_controls4", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                            if bKeepReading
                                bKeepReading = MCM.ShowMessage("$iEquip_help_controls5", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                                if bKeepReading
                                    bKeepReading = MCM.ShowMessage("$iEquip_help_controls6", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                                    if bKeepReading
                                        MCM.ShowMessage("$iEquip_help_controls7", false, "$iEquip_common_msg_Exit")
                                    endIf
                                endIf
                            endIf
                        endIf
                    endIf 
                endIf
            endIf
        endIf 
    endEvent
endState

; ----------------
; - Main Hotkeys -
; ----------------

State gen_key_leftHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_leftHand")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iLeftKey = currentVar as int
            else
                KH.iLeftKey = 34
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iLeftKey)
        endIf
    endEvent
endState

State gen_key_rightHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_rightHand")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iRightKey = currentVar as int
            else
                KH.iRightKey = 35
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iRightKey)
        endIf
    endEvent
endState

State gen_key_shout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_shout")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iShoutKey = currentVar as int
            else
                KH.iShoutKey = 21
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iShoutKey)
        endIf
    endEvent
endState

State gen_key_consumPoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_consumPoison")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iConsumableKey = currentVar as int
            else
                KH.iConsumableKey = 48
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iConsumableKey)
        endIf
    endEvent
endState
        
; --------------------------
; - Utility Hotkey Options -
; --------------------------

State gen_key_util
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_util")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iUtilityKey = currentVar as int
            else
                KH.iUtilityKey = 37
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iUtilityKey)        
        endIf
    endEvent
endState

State gen_tgl_blockUtilMenuInCombat
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_blockUtilMenuInCombat")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bNoUtilMenuInCombat)
            KH.bNoUtilMenuInCombat = !KH.bNoUtilMenuInCombat
            MCM.SetToggleOptionValueST(KH.bNoUtilMenuInCombat)
        endIf
    endEvent
endState

; ---------------------
; - Key Press Options -
; ---------------------

State gen_sld_multiTapDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_multiTapDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(KH.fMultiTapDelay, 0.2, 1.0, 0.1, 0.3)
        elseIf currentEvent == "Accept"
            KH.fMultiTapDelay = currentVar
            MCM.SetSliderOptionValueST(KH.fMultiTapDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State gen_sld_longPrsDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_longPrsDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(KH.fLongPressDelay, 0.3, 1.5, 0.1, 0.6)
        elseIf currentEvent == "Accept"
            KH.fLongPressDelay = currentVar
            MCM.SetSliderOptionValueST(KH.fLongPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

; --------------------
; - Optional Hotkeys -
; --------------------

State gen_tgl_enblExtKbCtrls
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblExtKbCtrls")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bExtendedKbControlsEnabled)
            KH.bExtendedKbControlsEnabled = !KH.bExtendedKbControlsEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_key_consItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iConsumeItemKey = currentVar as int
            else
                KH.iConsumeItemKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iConsumeItemKey)        
        endIf
    endEvent
endState

State gen_key_cyclePoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iCyclePoisonKey = currentVar as int
            else
                KH.iCyclePoisonKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iCyclePoisonKey)        
        endIf
    endEvent
endState

State gen_key_quickRestore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickRestoreKey = currentVar as int
            else
                KH.iQuickRestoreKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickRestoreKey)        
        endIf
    endEvent
endState

State gen_key_quickShield
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickShieldKey = currentVar as int
            else
                KH.iQuickShieldKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickShieldKey)        
        endIf
    endEvent
endState

State gen_key_quickRanged
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickRangedKey = currentVar as int
            else
                KH.iQuickRangedKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickRangedKey)        
        endIf
    endEvent
endState

; Deprecated
iEquip_AmmoMode property AM auto
iEquip_PlayerEventHandler property EH auto
iEquip_TorchScript property TO auto
