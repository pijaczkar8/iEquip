Scriptname iEquip_MCM_cyc extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto
iEquip_KeyHandler Property KH Auto

string[] posIndBehaviour

string[] autoEquipOptions
string[] whenToAutoEquipOptions
string[] currItemEnchOptions
string[] currItemPoisOptions

; #############
; ### SETUP ###

function initData()
    posIndBehaviour = new string[3]
    posIndBehaviour[0] = "$iEquip_MCM_common_opt_disabled"
    posIndBehaviour[1] = "$iEquip_MCM_gen_opt_onlyCycling"
    posIndBehaviour[2] = "$iEquip_MCM_gen_opt_alwaysVisible"

    autoEquipOptions = new string[4]
    autoEquipOptions[0] = "$iEquip_MCM_common_opt_disabled"
    autoEquipOptions[1] = "$iEquip_MCM_gen_opt_anyTime"
    autoEquipOptions[2] = "$iEquip_MCM_gen_opt_weapDrawn"
    autoEquipOptions[3] = "$iEquip_MCM_gen_opt_combatOnly"

    whenToAutoEquipOptions = new string[3]
    whenToAutoEquipOptions[0] = "$iEquip_MCM_gen_opt_alwaysEquip"
    whenToAutoEquipOptions[1] = "$iEquip_MCM_gen_opt_equipIfBetter"
    whenToAutoEquipOptions[2] = "$iEquip_MCM_gen_opt_equipIfUnarmed"

    currItemEnchOptions = new string[3]
    currItemEnchOptions[0] = "$iEquip_MCM_gen_opt_dontEquip"
    currItemEnchOptions[1] = "$iEquip_MCM_gen_opt_equipIfNoCharge"
    currItemEnchOptions[2] = "$iEquip_MCM_gen_opt_alwaysEquip"

    currItemPoisOptions = new string[2]
    currItemPoisOptions[0] = "$iEquip_MCM_gen_opt_dontEquip"
    currItemPoisOptions[1] = "$iEquip_MCM_gen_opt_alwaysEquip"

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bEquipOnPause as int)
    jArray.addFlt(jPageObj, WC.fEquipOnPauseDelay)

    jArray.addInt(jPageObj, WC.bSlowTimeWhileCycling as int)
    jArray.addInt(jPageObj, WC.iCycleSlowTimeStrength)

    jArray.addInt(jPageObj, WC.bSkipAutoAddedItems as int)
    jArray.addInt(jPageObj, WC.bSkipRHUnarmedInCombat as int)
    
    jArray.addInt(jPageObj, WC.iPosInd)
    jArray.addInt(jPageObj, WC.iPositionIndicatorColor)
    jArray.addFlt(jPageObj, WC.fPositionIndicatorAlpha)
    jArray.addInt(jPageObj, WC.iCurrPositionIndicatorColor)
    jArray.addFlt(jPageObj, WC.fCurrPositionIndicatorAlpha)

    jArray.addInt(jPageObj, WC.bShowAttributeIcons as int)

    jArray.addInt(jPageObj, WC.iAutoEquipEnabled)
    jArray.addInt(jPageObj, WC.iAutoEquip)
    jArray.addInt(jPageObj, WC.iCurrentItemEnchanted)
    jArray.addInt(jPageObj, WC.iCurrentItemPoisoned)
    jArray.addInt(jPageObj, WC.bAutoEquipHardcore as int)
    jArray.addInt(jPageObj, WC.bAutoEquipDontDropFavorites as int)

    jArray.addInt(jPageObj, WC.bEnableGearedUp as int)
    
    jArray.addInt(jPageObj, PM.bPreselectEnabled as int)
    jArray.addInt(jPageObj, PM.bShoutPreselectEnabled as int)
    jArray.addInt(jPageObj, PM.bPreselectSwapItemsOnEquip as int)
    jArray.addInt(jPageObj, PM.bTogglePreselectOnEquipAll as int)
    jArray.addInt(jPageObj, PM.bPreselectSwapItemsOnQuickAction as int)

	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj

    WC.bEquipOnPause = jArray.getInt(jPageObj, 7)
    WC.fEquipOnPauseDelay = jArray.getFlt(jPageObj, 8)

    WC.bSlowTimeWhileCycling = jArray.getInt(jPageObj, 17)
    WC.iCycleSlowTimeStrength = jArray.getInt(jPageObj, 18)

    WC.bSkipAutoAddedItems = jArray.getInt(jPageObj, 15)
    WC.bSkipRHUnarmedInCombat = jArray.getInt(jPageObj, 19)
    
    WC.iPosInd = jArray.getInt(jPageObj, 9)
    WC.iPositionIndicatorColor = jArray.getInt(jPageObj, 0)
    WC.fPositionIndicatorAlpha = jArray.getFlt(jPageObj, 1)
    WC.iCurrPositionIndicatorColor = jArray.getInt(jPageObj, 2)
    WC.fCurrPositionIndicatorAlpha = jArray.getFlt(jPageObj, 3)

    WC.bShowAttributeIcons = jArray.getInt(jPageObj, 10)

    WC.iAutoEquipEnabled = jArray.getInt(jPageObj, 20)
    WC.iAutoEquip = jArray.getInt(jPageObj, 21)
    WC.iCurrentItemEnchanted = jArray.getInt(jPageObj, 22)
    WC.iCurrentItemPoisoned = jArray.getInt(jPageObj, 23)
    WC.bAutoEquipHardcore = jArray.getInt(jPageObj, 24)
    WC.bAutoEquipDontDropFavorites = jArray.getInt(jPageObj, 25)

    WC.bEnableGearedUp = jArray.getInt(jPageObj, 11)

    PM.bPreselectEnabled = jArray.getInt(jPageObj, 3)
    PM.bShoutPreselectEnabled = jArray.getInt(jPageObj, 4)
    PM.bPreselectSwapItemsOnEquip = jArray.getInt(jPageObj, 5)
    PM.bTogglePreselectOnEquipAll = jArray.getInt(jPageObj, 6)
    PM.bPreselectSwapItemsOnQuickAction = jArray.getInt(jPageObj, 39)

endFunction

function drawPage()
 
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_Cycling</font>")
    MCM.AddToggleOptionST("gen_tgl_eqpPaus", "$iEquip_MCM_gen_lbl_eqpPaus", WC.bEquipOnPause)
            
    if WC.bEquipOnPause
        MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "$iEquip_MCM_gen_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
    endIf

    MCM.AddToggleOptionST("gen_tgl_slowTime", "$iEquip_MCM_gen_lbl_slowTime", WC.bSlowTimeWhileCycling)
    
    if WC.bSlowTimeWhileCycling
        MCM.AddSliderOptionST("gen_sld_slowTimeStr", "$iEquip_MCM_common_lbl_slowTimeStr", WC.iCycleSlowTimeStrength as float, "{0}%")
    endIf

    if WC.bAllowSingleItemsInBothQueues
        MCM.AddToggleOptionST("que_tgl_allow1hSwitch", "$iEquip_MCM_que_lbl_allow1hSwitch", WC.bAllowWeaponSwitchHands)
    endIf

    MCM.AddToggleOptionST("que_tgl_skipAutoAddedItems", "$iEquip_MCM_que_lbl_skipAutoAddedItems", WC.bSkipAutoAddedItems)
    MCM.AddToggleOptionST("gen_tgl_skipUnarmed", "$iEquip_MCM_gen_lbl_skipUnarmed", WC.bSkipRHUnarmedInCombat)

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
    MCM.AddMenuOptionST("gen_men_showPosInd", "$iEquip_MCM_gen_lbl_queuePosInd", posIndBehaviour[WC.iPosInd])

    if WC.iPosInd > 0
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_ui_lbl_posIndOpts</font>")
        MCM.AddColorOptionST("ui_col_posIndColor", "$iEquip_MCM_ui_lbl_posIndColor", WC.iPositionIndicatorColor)
        MCM.AddSliderOptionST("ui_sld_posIndAlpha", "$iEquip_MCM_ui_lbl_posIndAlpha", WC.fPositionIndicatorAlpha, "{0}%")
        MCM.AddColorOptionST("ui_col_currPosIndColor", "$iEquip_MCM_ui_lbl_currPosIndColor", WC.iCurrPositionIndicatorColor)
        MCM.AddSliderOptionST("ui_sld_currPosIndAlpha", "$iEquip_MCM_ui_lbl_currPosIndAlpha", WC.fCurrPositionIndicatorAlpha, "{0}%")
        MCM.AddEmptyOption()
    endIf

    MCM.AddToggleOptionST("gen_tgl_showAtrIco", "$iEquip_MCM_gen_lbl_showAtrIco", WC.bShowAttributeIcons)

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pro_lbl_preselectOpts</font>")
    MCM.AddTextOptionST("pro_txt_whatPreselect", "<font color='#a6bffe'>$iEquip_MCM_pro_lbl_whatPreselect</font>", "")

    if PM.bPreselectEnabled
        MCM.AddToggleOptionST("pro_tgl_enblPreselect", "<font color='#c7ea46'>$iEquip_MCM_pro_lbl_enblPreselect</font>", PM.bPreselectEnabled)
        MCM.AddToggleOptionST("pro_tgl_enblShoutPreselect", "$iEquip_MCM_pro_lbl_enblShoutPreselect", PM.bShoutPreselectEnabled)
        MCM.AddToggleOptionST("pro_tgl_swapPreselectItm", "$iEquip_MCM_pro_lbl_swapPreselectItm", PM.bPreselectSwapItemsOnEquip)
        MCM.AddToggleOptionST("pro_tgl_swapPreselectAdv", "$iEquip_MCM_pro_lbl_swapPreselectAdv", PM.bPreselectSwapItemsOnQuickAction)
        MCM.AddToggleOptionST("pro_tgl_eqpAllExitPreselectMode", "$iEquip_MCM_pro_lbl_eqpAllExitPreselectMode", PM.bTogglePreselectOnEquipAll)
    else
        MCM.AddToggleOptionST("pro_tgl_enblPreselect", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblPreselect</font>", PM.bPreselectEnabled)
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

State ui_col_posIndColor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_posIndColor")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(WC.iPositionIndicatorColor)
            MCM.SetColorDialogDefaultColor(0xFFFFFF)
        else
            If currentEvent == "Accept"
                WC.iPositionIndicatorColor = currentVar as int
            elseIf currentEvent == "Default"
                WC.iPositionIndicatorColor = 0xFFFFFF
            endIf
            MCM.SetColorOptionValueST(WC.iPositionIndicatorColor)
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

State ui_sld_posIndAlpha
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_posIndAlpha")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fPositionIndicatorAlpha, 10.0, 100.0, 10.0, 60.0)
        elseIf currentEvent == "Accept"
            WC.fPositionIndicatorAlpha = currentVar
            MCM.SetSliderOptionValueST(WC.fPositionIndicatorAlpha, "{0}%")
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

State ui_col_currPosIndColor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_currPosIndColor")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(WC.iCurrPositionIndicatorColor)
            MCM.SetColorDialogDefaultColor(0xCCCCCC)
        else
            If currentEvent == "Accept"
                WC.iCurrPositionIndicatorColor = currentVar as int
            elseIf currentEvent == "Default"
                WC.iCurrPositionIndicatorColor = 0xCCCCCC
            endIf
            MCM.SetColorOptionValueST(WC.iCurrPositionIndicatorColor)
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

State ui_sld_currPosIndAlpha
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_currPosIndAlpha")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fCurrPositionIndicatorAlpha, 10.0, 100.0, 10.0, 40.0)
        elseIf currentEvent == "Accept"
            WC.fCurrPositionIndicatorAlpha = currentVar
            MCM.SetSliderOptionValueST(WC.fCurrPositionIndicatorAlpha, "{0}%")
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

