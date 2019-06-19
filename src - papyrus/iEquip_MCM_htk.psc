Scriptname iEquip_MCM_htk extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_KeyHandler Property KH Auto

int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
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

function loadData(int jPageObj)     ; Load page data from jPageObj
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
	MCM.AddTextOptionST("htk_txt_htkHelp", "<font color='#a6bffe'>$iEquip_MCM_htk_lbl_htkHelp</font>", "")
		
	MCM.AddEmptyOption()
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_htk_lbl_MainHtks</font>")
	MCM.AddKeyMapOptionST("htk_key_leftHand", "$iEquip_MCM_htk_lbl_leftHand", KH.iLeftKey, mcmUnmapFLAG)
	MCM.AddKeyMapOptionST("htk_key_rightHand", "$iEquip_MCM_htk_lbl_rightHand", KH.iRightKey, mcmUnmapFLAG)
	MCM.AddKeyMapOptionST("htk_key_shout", "$iEquip_MCM_htk_lbl_shout", KH.iShoutKey, mcmUnmapFLAG)
	MCM.AddKeyMapOptionST("htk_key_consumPoison", "$iEquip_MCM_htk_lbl_consumPoison", KH.iConsumableKey, mcmUnmapFLAG)
	MCM.AddEmptyOption()
			
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_htk_lbl_UtHtkOpts</font>")
	MCM.AddKeyMapOptionST("htk_key_util", "$iEquip_MCM_htk_lbl_util", KH.iUtilityKey, mcmUnmapFLAG)
    MCM.AddToggleOptionST("htk_tgl_blockUtilMenuInCombat", "$iEquip_MCM_htk_lbl_blockUtilMenuInCombat", KH.bNoUtilMenuInCombat)

	MCM.SetCursorPosition(1)
			
	;These are just so the right side lines up nicely with the left!
	MCM.AddEmptyOption()
	MCM.AddEmptyOption()
	
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_htk_lbl_KeyPressOpts</font>")
	MCM.AddSliderOptionST("htk_sld_multiTapDelay", "$iEquip_MCM_htk_lbl_multiTapDelay", KH.fMultiTapDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	MCM.AddSliderOptionST("htk_sld_longPrsDelay", "$iEquip_MCM_htk_lbl_longPrsDelay", KH.fLongPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
	MCM.AddEmptyOption()
	
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_htk_lbl_ExtKbCtrls</font>")
	MCM.AddToggleOptionST("htk_tgl_enblExtKbCtrls", "$iEquip_MCM_htk_lbl_enblExtKbCtrls", KH.bExtendedKbControlsEnabled)
	if KH.bExtendedKbControlsEnabled
		MCM.AddKeyMapOptionST("htk_key_consItem", "$iEquip_MCM_htk_lbl_consItem", KH.iConsumeItemKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_cyclePoison", "$iEquip_MCM_htk_lbl_cyclePoison", KH.iCyclePoisonKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_quickRestore", "$iEquip_MCM_htk_lbl_quickRestore", KH.iQuickRestoreKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_quickShield", "$iEquip_MCM_htk_lbl_quickShield", KH.iQuickShieldKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_quickRanged", "$iEquip_MCM_htk_lbl_quickRanged", KH.iQuickRangedKey, mcmUnmapFLAG)
	endIf
endFunction

; ######################
; ### Hotkey Options ###
; ######################

State htk_txt_htkHelp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_htkHelp")
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
                                    MCM.ShowMessage("$iEquip_help_controls6", false, "$iEquip_common_msg_Exit")
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

State htk_key_leftHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_leftHand")
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

State htk_key_rightHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_rightHand")
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

State htk_key_shout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_shout")
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

State htk_key_consumPoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_consumPoison")
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

State htk_key_util
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_util")
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

State htk_tgl_blockUtilMenuInCombat
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_blockUtilMenuInCombat")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bNoUtilMenuInCombat)
            KH.bNoUtilMenuInCombat = !KH.bNoUtilMenuInCombat
            MCM.SetToggleOptionValueST(KH.bNoUtilMenuInCombat)
        endIf
    endEvent
endState

; ---------------------
; - Key Press Options -
; ---------------------

State htk_sld_multiTapDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_multiTapDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(KH.fMultiTapDelay, 0.2, 1.0, 0.1, 0.3)
        elseIf currentEvent == "Accept"
            KH.fMultiTapDelay = currentVar
            MCM.SetSliderOptionValueST(KH.fMultiTapDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State htk_sld_longPrsDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_longPrsDelay")
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

State htk_tgl_enblExtKbCtrls
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_enblExtKbCtrls")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bExtendedKbControlsEnabled)
            KH.bExtendedKbControlsEnabled = !KH.bExtendedKbControlsEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State htk_key_consItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iConsumeItemKey = currentVar as int
            else
                KH.iConsumeItemKey = -1
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iConsumeItemKey)        
        endIf
    endEvent
endState

State htk_key_cyclePoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iCyclePoisonKey = currentVar as int
            else
                KH.iCyclePoisonKey = -1
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iCyclePoisonKey)        
        endIf
    endEvent
endState

State htk_key_quickRestore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickRestoreKey = currentVar as int
            else
                KH.iQuickRestoreKey = -1
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickRestoreKey)        
        endIf
    endEvent
endState

State htk_key_quickShield
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickShieldKey = currentVar as int
            else
                KH.iQuickShieldKey = -1
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickShieldKey)        
        endIf
    endEvent
endState

State htk_key_quickRanged
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iQuickRangedKey = currentVar as int
            else
                KH.iQuickRangedKey = -1
            endIf
            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iQuickRangedKey)        
        endIf
    endEvent
endState
