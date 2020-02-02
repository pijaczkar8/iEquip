Scriptname iEquip_MCM_que extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto
iEquip_KeyHandler Property KH Auto

; #############
; ### SETUP ###

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.iMaxQueueLength)
	jArray.addInt(jPageObj, WC.bHardLimitQueueSize as int)
	
	jArray.addInt(jPageObj, WC.bShowQueueConfirmationMessages as int)
	jArray.addInt(jPageObj, WC.bAllowSingleItemsInBothQueues as int)
	jArray.addInt(jPageObj, WC.bAllowWeaponSwitchHands as int)
	
	jArray.addInt(jPageObj, WC.bEnableRemovedItemCaching as int)
	jArray.addInt(jPageObj, WC.iMaxCachedItems)
	jArray.addInt(jPageObj, WC.bBlacklistEnabled as int)
	
	jArray.addInt(jPageObj, EH.bAutoAddNewItems as int)
	jArray.addInt(jPageObj, EH.bAutoAddShouts as int)
	jArray.addInt(jPageObj, EH.bAutoAddPowers as int)
	jArray.addInt(jPageObj, PO.bAutoAddPotions as int)
	jArray.addInt(jPageObj, PO.bAutoAddPoisons as int)
	jArray.addInt(jPageObj, PO.bAutoAddConsumables as int)
	jArray.addInt(jPageObj, WC.bShowAutoAddedFlag as int)
	jArray.addInt(jPageObj, WC.bSkipAutoAddedItems as int)

    ; Missing settings from <v1.2
    jArray.addInt(jPageObj, KH.bDisableAddToQueue as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	WC.iMaxQueueLength = jArray.getInt(jPageObj, 0)
	WC.bHardLimitQueueSize = jArray.getInt(jPageObj, 1)
	
	WC.bShowQueueConfirmationMessages = jArray.getInt(jPageObj, 2)
	WC.bAllowSingleItemsInBothQueues = jArray.getInt(jPageObj, 3)
	WC.bAllowWeaponSwitchHands = jArray.getInt(jPageObj, 4)
	
	WC.bEnableRemovedItemCaching = jArray.getInt(jPageObj, 5)
	WC.iMaxCachedItems = jArray.getInt(jPageObj, 6)
	WC.bBlacklistEnabled = jArray.getInt(jPageObj, 7)
	
	EH.bAutoAddNewItems = jArray.getInt(jPageObj, 8)
	EH.bAutoAddShouts = jArray.getInt(jPageObj, 9)
	EH.bAutoAddPowers = jArray.getInt(jPageObj, 10)
	PO.bAutoAddPotions = jArray.getInt(jPageObj, 11)
	PO.bAutoAddPoisons = jArray.getInt(jPageObj, 12)
	PO.bAutoAddConsumables = jArray.getInt(jPageObj, 13)
	WC.bShowAutoAddedFlag = jArray.getInt(jPageObj, 14)
	WC.bSkipAutoAddedItems = jArray.getInt(jPageObj, 15)

    if presetVersion > 110
        KH.bDisableAddToQueue = jArray.getInt(jPageObj, 16)
    endIf
endFunction

function drawPage()
	;/MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_que_lbl_queLenOpts</font>")
	MCM.AddSliderOptionST("que_sld_maxItmQue", "$iEquip_MCM_que_lbl_maxItmQue", WC.iMaxQueueLength, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_items"))
	MCM.AddToggleOptionST("que_tgl_hrdLimQueSize", "$iEquip_MCM_que_lbl_hrdLimQueSize", WC.bHardLimitQueueSize)
	
	MCM.AddEmptyOption()/;  
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_que_lbl_addToQueOpts</font>")
	MCM.AddToggleOptionST("que_tgl_showConfMsg", "$iEquip_MCM_que_lbl_showConfMsg", WC.bShowQueueConfirmationMessages)
	MCM.AddToggleOptionST("que_tgl_signlBothQue", "$iEquip_MCM_que_lbl_signlBothQue", WC.bAllowSingleItemsInBothQueues)
			
	if WC.bAllowSingleItemsInBothQueues
		MCM.AddToggleOptionST("que_tgl_allow1hSwitch", "$iEquip_MCM_que_lbl_allow1hSwitch", WC.bAllowWeaponSwitchHands)
	endIf

    MCM.AddToggleOptionST("que_tgl_dsblAddToQue", "$iEquip_MCM_que_lbl_dsblAddToQue", KH.bDisableAddToQueue)

	MCM.AddEmptyOption()
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_que_lbl_cacheBlkLst</font>")
	MCM.AddToggleOptionST("que_tgl_allowCacheRmvItm", "$iEquip_MCM_que_lbl_allowCacheRmvItm", WC.bEnableRemovedItemCaching)
			
	if WC.bEnableRemovedItemCaching
		MCM.AddSliderOptionST("que_sld_MaxItmCache", "$iEquip_MCM_que_lbl_MaxItmCache", WC.iMaxCachedItems, iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_que_lbl_items"))
	endIf

	MCM.AddToggleOptionST("que_tgl_enblBlacklist", "$iEquip_MCM_que_lbl_enblBlacklist", WC.bBlacklistEnabled)

	MCM.SetCursorPosition(1)

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_que_lbl_autoAddOpts</font>")
	MCM.AddToggleOptionST("que_tgl_autoAddHandItems", "$iEquip_MCM_que_lbl_autoAddHandItems", EH.bAutoAddNewItems)
	MCM.AddToggleOptionST("que_tgl_autoAddShouts", "$iEquip_MCM_que_lbl_autoAddShouts", EH.bAutoAddShouts)
	MCM.AddToggleOptionST("que_tgl_autoAddPowers", "$iEquip_MCM_que_lbl_autoAddPowers", EH.bAutoAddPowers)
	MCM.AddToggleOptionST("que_tgl_autoAddPotions", "$iEquip_MCM_que_lbl_autoAddPotions", PO.bAutoAddPotions)
	MCM.AddToggleOptionST("que_tgl_autoAddPoisons", "$iEquip_MCM_que_lbl_autoAddPoisons", PO.bAutoAddPoisons)
	MCM.AddToggleOptionST("que_tgl_autoAddConsumables", "$iEquip_MCM_que_lbl_autoAddConsumables", PO.bAutoAddConsumables)
	MCM.AddEmptyOption()
	MCM.AddToggleOptionST("que_tgl_queueMenuAAFlags", "$iEquip_MCM_que_lbl_queueMenuAAFlags", WC.bShowAutoAddedFlag)
	MCM.AddToggleOptionST("que_tgl_skipAutoAddedItems", "$iEquip_MCM_que_lbl_skipAutoAddedItems", WC.bSkipAutoAddedItems)
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
            MCM.fillSlider(WC.iMaxQueueLength, 0.0, 100.0, 1.0, 25.0)
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

State que_tgl_dsblAddToQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_dsblAddToQue")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bDisableAddToQueue)
            KH.bDisableAddToQueue = !KH.bDisableAddToQueue
            MCM.SetToggleOptionValueST(KH.bDisableAddToQueue)
        endIf
    endEvent
endState

; --------------------
; - Auto Add Options -
; --------------------

State que_tgl_autoAddHandItems
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddHandItems")
        else
            If currentEvent == "Select"
                EH.bAutoAddNewItems = !EH.bAutoAddNewItems
            elseIf currentEvent == "Default"
                EH.bAutoAddNewItems = true
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddNewItems)
        endIf
    endEvent
endState

State que_tgl_autoAddShouts
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddShouts")
        else
            If currentEvent == "Select"
                EH.bAutoAddShouts = !EH.bAutoAddShouts
            elseIf currentEvent == "Default"
                EH.bAutoAddShouts = true
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddShouts)
        endIf
    endEvent
endState

State que_tgl_autoAddPowers
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_autoAddPowers")
        else
            If currentEvent == "Select"
                EH.bAutoAddPowers = !EH.bAutoAddPowers
            elseIf currentEvent == "Default"
                EH.bAutoAddPowers = true
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddPowers)
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
            elseIf currentEvent == "Default"
                PO.bAutoAddConsumables = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddConsumables)
        endIf 
    endEvent
endState

State que_tgl_queueMenuAAFlags
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_queueMenuAAFlags")
        else
            If currentEvent == "Select" || (currentEvent == "Default" && WC.bShowAutoAddedFlag)
                WC.bShowAutoAddedFlag = !WC.bShowAutoAddedFlag
            endIf
            MCM.SetToggleOptionValueST(WC.bShowAutoAddedFlag)
        endIf 
    endEvent
endState

State que_tgl_skipAutoAddedItems
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_que_txt_skipAutoAddedItems")
        else
            If currentEvent == "Select"
                WC.bSkipAutoAddedItems = !WC.bSkipAutoAddedItems
            elseIf currentEvent == "Default"
                WC.bSkipAutoAddedItems = false
            endIf

            if WC.bSkipAutoAddedItems
				if WC.iPosInd == 2
					WC.iPosInd = 1
					WC.bPositionIndicatorSettingsChanged = true
				elseIf WC.iPosInd == 1
					WC.iPosInd = 0
				endIf
            endIf
			
			MCM.SetToggleOptionValueST(WC.bSkipAutoAddedItems)
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
        elseIf currentEvent == "Select" || currentEvent == "Default" && WC.bBlacklistEnabled
            WC.bBlacklistEnabled = !WC.bBlacklistEnabled
            if !WC.bBlacklistEnabled
                EH.iEquip_LeftHandBlacklistFLST.Revert()
                EH.iEquip_RightHandBlacklistFLST.Revert()
                EH.iEquip_GeneralBlacklistFLST.Revert()
            endIf
            MCM.forcePageReset()
        endIf
    endEvent
endState

