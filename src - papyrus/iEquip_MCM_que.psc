Scriptname iEquip_MCM_que extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto

; #############
; ### SETUP ###

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddHeaderOption("$iEquip_MCM_que_lbl_queLenOpts")
        MCM.AddSliderOptionST("que_sld_maxItmQue", "$iEquip_MCM_que_lbl_maxItmQue", WC.iMaxQueueLength, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_items"))
        MCM.AddToggleOptionST("que_tgl_hrdLimQueSize", "$iEquip_MCM_que_lbl_hrdLimQueSize", WC.bHardLimitQueueSize)
                
        MCM.AddHeaderOption("$iEquip_MCM_que_lbl_addToQueOpts")
        MCM.AddToggleOptionST("que_tgl_showConfMsg", "$iEquip_MCM_que_lbl_showConfMsg", WC.bShowQueueConfirmationMessages)
        MCM.AddToggleOptionST("que_tgl_signlBothQue", "$iEquip_MCM_que_lbl_signlBothQue", WC.bAllowSingleItemsInBothQueues)
                
        if WC.bAllowSingleItemsInBothQueues
            MCM.AddToggleOptionST("que_tgl_allow1hSwitch", "$iEquip_MCM_que_lbl_allow1hSwitch", WC.bAllowWeaponSwitchHands)
        endIf

        MCM.SetCursorPosition(1)
        MCM.AddHeaderOption("$iEquip_MCM_que_lbl_autoAddOpts")
        MCM.AddToggleOptionST("que_tgl_autoAddItmQue", "$iEquip_MCM_que_lbl_autoAddItmQue", WC.bAutoAddNewItems)
        MCM.AddToggleOptionST("que_tgl_autoAddPotions", "$iEquip_MCM_que_lbl_autoAddPotions", PO.bAutoAddPotions)
        MCM.AddToggleOptionST("que_tgl_autoAddPoisons", "$iEquip_MCM_que_lbl_autoAddPoisons", PO.bAutoAddPoisons)
        MCM.AddToggleOptionST("que_tgl_autoAddConsumables", "$iEquip_MCM_que_lbl_autoAddConsumables", PO.bAutoAddConsumables)
        MCM.AddToggleOptionST("que_tgl_allowCacheRmvItm", "$iEquip_MCM_que_lbl_allowCacheRmvItm", WC.bEnableRemovedItemCaching)
                
        if WC.bEnableRemovedItemCaching
            MCM.AddSliderOptionST("que_sld_MaxItmCache", "$iEquip_MCM_que_lbl_MaxItmCache", WC.iMaxCachedItems, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_items"))
        endIf

        MCM.AddToggleOptionST("que_tgl_enblBlacklist", "$iEquip_MCM_que_lbl_enblBlacklist", WC.bBlacklistEnabled)
                
        if WC.bBlacklistEnabled && (EH.iEquip_LeftHandBlacklistFLST.GetSize() > 0 || EH.iEquip_RightHandBlacklistFLST.GetSize() > 0 || EH.iEquip_GeneralBlacklistFLST.GetSize() > 0)
            MCM.AddTextOptionST("que_txt_clearBlacklist", "", "$iEquip_MCM_que_lbl_clearBlacklist")
        endIf
    endIf
endFunction

; #####################
; ### Queue Options ###
; #####################

; ------------------------
; - Queue Length Options -
; ------------------------

State que_sld_maxItmQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_maxItmQue")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iMaxQueueLength, 0.0, 30.0, 1.0, 12.0)
        elseIf currentEvent == "Accept"
            if currentVar as int < WC.iMaxQueueLength
                if MCM.ShowMessage("$iEquip_MCM_que_msg_maxItmQue", true, "$OK", "$Cancel")
                    WC.iMaxQueueLength = currentVar as int
                    WC.bReduceMaxQueueLengthPending = true
                endIf
            else
                WC.iMaxQueueLength = currentVar as int
            endIf
            MCM.SetSliderOptionValueST(WC.iMaxQueueLength, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_items"))
        endIf
    endEvent
endState

State que_tgl_hrdLimQueSize
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_hrdLimQueSize")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !WC.bHardLimitQueueSize)
            bool continue = true
            if !WC.bHardLimitQueueSize
                continue = MCM.ShowMessage("$iEquip_MCM_que_msg_hrdLimQueSize", true, "$OK", "$Cancel")
                if continue
                    WC.bReduceMaxQueueLengthPending = true
                endIf
            endIf
            if continue
                WC.bHardLimitQueueSize = !WC.bHardLimitQueueSize
                MCM.SetToggleOptionValueST(WC.bHardLimitQueueSize)
            endIf
        endIf
    endEvent
endState

; ------------------------
; - Add To Queue Options -
; ------------------------

State que_tgl_showConfMsg
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_showConfMsg")
        elseIf currentEvent == "Select"
            WC.bShowQueueConfirmationMessages = !WC.bShowQueueConfirmationMessages
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        elseIf currentEvent == "Default"
            WC.bShowQueueConfirmationMessages = true 
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        endIf
    endEvent
endState

State que_tgl_signlBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_signlBothQue")
        elseIf currentEvent == "Select"
            WC.bAllowSingleItemsInBothQueues = !WC.bAllowSingleItemsInBothQueues
        
            if !WC.bAllowSingleItemsInBothQueues
                if MCM.ShowMessage("$iEquip_MCM_que_msg_signlBothQue",  true, "$iEquip_MCM_que_btn_purge", "$iEquip_MCM_que_btn_leave")
                    WC.bRefreshQueues = true
                endIf
            endIf
            
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bAllowSingleItemsInBothQueues = false 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State que_tgl_allow1hSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_allow1hSwitch")
        elseIf currentEvent == "Select"
            WC.bAllowWeaponSwitchHands = !WC.bAllowWeaponSwitchHands
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        elseIf currentEvent == "Default"
            WC.bAllowWeaponSwitchHands = false 
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        endIf
    endEvent
endState

; --------------------
; - Auto Add Options -
; --------------------

State que_tgl_autoAddItmQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddItmQue")
        elseIf currentEvent == "Select"
            WC.bAutoAddNewItems = !WC.bAutoAddNewItems
            MCM.SetToggleOptionValueST(WC.bAutoAddNewItems)
        elseIf currentEvent == "Default"
            WC.bAutoAddNewItems = true 
            MCM.SetToggleOptionValueST(WC.bAutoAddNewItems)
        endIf
    endEvent
endState

State que_tgl_autoAddPotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddPotions")
        else
            If currentEvent == "Select"
                PO.bAutoAddPotions = !PO.bAutoAddPotions
                MCM.SetToggleOptionValueST(PO.bAutoAddPotions)
            elseIf currentEvent == "Default"
                PO.bAutoAddPotions = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddPotions)
        endIf 
    endEvent
endState

State que_tgl_autoAddPoisons
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddPoisons")
        else
            If currentEvent == "Select"
                PO.bAutoAddPoisons = !PO.bAutoAddPoisons
                MCM.SetToggleOptionValueST(PO.bAutoAddPoisons)
            elseIf currentEvent == "Default"
                PO.bAutoAddPoisons = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddPoisons)
        endIf 
    endEvent
endState

State que_tgl_autoAddConsumables
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddConsumables")
        else
            If currentEvent == "Select"
                PO.bAutoAddConsumables = !PO.bAutoAddConsumables
                MCM.SetToggleOptionValueST(PO.bAutoAddConsumables)
            elseIf currentEvent == "Default"
                PO.bAutoAddConsumables = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddConsumables)
        endIf 
    endEvent
endState

State que_tgl_allowCacheRmvItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_allowCacheRmvItm")
        elseIf currentEvent == "Select"
            WC.bEnableRemovedItemCaching = !WC.bEnableRemovedItemCaching
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEnableRemovedItemCaching = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State que_sld_MaxItmCache
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iMaxCachedItems, 0.0, 128.0, 1.0, 60.0)
        elseIf currentEvent == "Accept"
            WC.iMaxCachedItems = currentVar as int
            MCM.SetSliderOptionValueST(WC.iMaxCachedItems, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_cachedItms"))
        endIf
    endEvent
endState

State que_tgl_enblBlacklist
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_enblBlacklist")
        elseIf currentEvent == "Select" || currentEvent == "Default" && !WC.bBlacklistEnabled
            WC.bBlacklistEnabled = !WC.bBlacklistEnabled
            if !WC.bBlacklistEnabled
                clearBlacklistFormlists()
            endIf
            MCM.forcePageReset()
        endIf
    endEvent
endState

State que_txt_clearBlacklist
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_clearBlacklist")
        elseIf currentEvent == "Select"
            clearBlacklistFormlists()
            MCM.forcePageReset()
        endIf
    endEvent
endState

function clearBlacklistFormlists()
    EH.iEquip_LeftHandBlacklistFLST.Revert()
    EH.iEquip_RightHandBlacklistFLST.Revert()
    EH.iEquip_GeneralBlacklistFLST.Revert()
endFunction