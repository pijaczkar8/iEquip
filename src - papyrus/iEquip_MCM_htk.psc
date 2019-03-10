Scriptname iEquip_MCM_htk extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_KeyHandler Property KH Auto

int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
endFunction

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddTextOptionST("htk_txt_htkHelp", "$iEquip_MCM_htk_lbl_htkHelp", "")
            
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("$iEquip_MCM_htk_lbl_MainHtks")
        MCM.AddKeyMapOptionST("htk_key_leftHand", "$iEquip_MCM_htk_lbl_leftHand", KH.iLeftKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_rightHand", "$iEquip_MCM_htk_lbl_rightHand", KH.iRightKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_shout", "$iEquip_MCM_htk_lbl_shout", KH.iShoutKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("htk_key_consumPoison", "$iEquip_MCM_htk_lbl_consumPoison", KH.iConsumableKey, mcmUnmapFLAG)
        MCM.AddEmptyOption()
                
        MCM.AddHeaderOption("$iEquip_MCM_htk_lbl_UtHtkOpts")
        MCM.AddKeyMapOptionST("htk_key_util", "$iEquip_MCM_htk_lbl_util", KH.iUtilityKey, mcmUnmapFLAG)

        MCM.SetCursorPosition(1)
                
        ;These are just so the right side lines up nicely with the left!
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        
        MCM.AddHeaderOption("$iEquip_MCM_htk_lbl_KeyPressOpts")
        MCM.AddSliderOptionST("htk_sld_multiTapDelay", "$iEquip_MCM_htk_lbl_multiTapDelay", KH.fMultiTapDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddSliderOptionST("htk_sld_longPrsDelay", "$iEquip_MCM_htk_lbl_longPrsDelay", KH.fLongPressDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddEmptyOption()
        
        MCM.AddHeaderOption("$iEquip_MCM_htk_lbl_OptAddHtks")
        MCM.AddToggleOptionST("htk_tgl_optConsumeHotkey", "$iEquip_MCM_htk_lbl_optConsumeHotkey", KH.bConsumeItemHotkeyEnabled)
        if KH.bConsumeItemHotkeyEnabled
            MCM.AddKeyMapOptionST("htk_key_optional_consumeItem", "$iEquip_MCM_htk_lbl_consumeItem", KH.iOptConsumeKey, mcmUnmapFLAG)
        endIf
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
            bool bKeepReading = MCM.ShowMessage("$iEquip_help_controls1",  true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
            if bKeepReading 
                bKeepReading = MCM.ShowMessage("$iEquip_help_controls2",  true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if bKeepReading
                    bKeepReading = MCM.ShowMessage("$iEquip_help_controls3", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                     if bKeepReading
                        MCM.ShowMessage("$iEquip_help_controls4", false, "$iEquip_common_msg_Exit")
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
            
            MCM.bUpdateKeyMaps = true
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
            
            MCM.bUpdateKeyMaps = true
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
            
            MCM.bUpdateKeyMaps = true
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
            
            MCM.bUpdateKeyMaps = true
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
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iUtilityKey)        
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

State htk_tgl_optConsumeHotkey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_optConsumeHotkey")
        elseIf currentEvent == "Select" || "Default"
            If currentEvent == "Select"
                KH.bConsumeItemHotkeyEnabled = !KH.bConsumeItemHotkeyEnabled
            else
                KH.bConsumeItemHotkeyEnabled = false
            endIf
            MCM.forcePageReset()
        endIf
    endEvent
endState

State htk_key_optional_consumeItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_htk_txt_consumeItem")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iOptConsumeKey = currentVar as int
            else
                KH.iOptConsumeKey = -1
            endIf
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iOptConsumeKey)        
        endIf
    endEvent
endState
