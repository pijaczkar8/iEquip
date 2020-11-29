Scriptname iEquip_MCM_add extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto
iEquip_KeyHandler Property KH Auto

bool bAutoAddEnabled
bool bUpdateAutoAddSettings = true

; #############
; ### SETUP ###

function initData()
    if bUpdateAutoAddSettings
        if EH.bAutoAddNewItems || EH.bAutoAddShouts || EH.bAutoAddPowers || PO.bAutoAddPotions || PO.bAutoAddPoisons || PO.bAutoAddConsumables
            bAutoAddEnabled = true
        endIf
        bUpdateAutoAddSettings = false
    endIf
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bShowQueueConfirmationMessages as int)
	jArray.addInt(jPageObj, WC.bAllowSingleItemsInBothQueues as int)
    jArray.addInt(jPageObj, KH.bDisableAddToQueue as int)

    jArray.addInt(jPageObj, EH.bAutoAddNewItems as int)
    jArray.addInt(jPageObj, EH.bAutoAddShouts as int)
    jArray.addInt(jPageObj, EH.bAutoAddPowers as int)
    jArray.addInt(jPageObj, PO.bAutoAddPotions as int)
    jArray.addInt(jPageObj, PO.bAutoAddPoisons as int)
    jArray.addInt(jPageObj, PO.bAutoAddConsumables as int)
	
	jArray.addInt(jPageObj, WC.bEnableRemovedItemCaching as int)
	jArray.addInt(jPageObj, WC.iMaxCachedItems)
	jArray.addInt(jPageObj, WC.bBlacklistEnabled as int)

    jArray.addInt(jPageObj, bAutoAddEnabled as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	
	WC.bShowQueueConfirmationMessages = jArray.getInt(jPageObj, 0)
	WC.bAllowSingleItemsInBothQueues = jArray.getInt(jPageObj, 1)
	KH.bDisableAddToQueue = jArray.getInt(jPageObj, 2)
	
    EH.bAutoAddNewItems = jArray.getInt(jPageObj, 3)
	EH.bAutoAddShouts = jArray.getInt(jPageObj, 4)
	EH.bAutoAddPowers = jArray.getInt(jPageObj, 5)
	PO.bAutoAddPotions = jArray.getInt(jPageObj, 6)
	PO.bAutoAddPoisons = jArray.getInt(jPageObj, 7)
	PO.bAutoAddConsumables = jArray.getInt(jPageObj, 8)

    if presetVersion < 157
        WC.bEnableRemovedItemCaching = jArray.getInt(jPageObj, 10)
        WC.iMaxCachedItems = jArray.getInt(jPageObj, 11)
        WC.bBlacklistEnabled = jArray.getInt(jPageObj, 12)
    else
        WC.bEnableRemovedItemCaching = jArray.getInt(jPageObj, 9)
        WC.iMaxCachedItems = jArray.getInt(jPageObj, 10)
        WC.bBlacklistEnabled = jArray.getInt(jPageObj, 11)
        bAutoAddEnabled = jArray.getInt(jPageObj, 12)
    endIf

endFunction

function drawPage()

	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_add_lbl_addToQueOpts</font>")
	MCM.AddToggleOptionST("add_tgl_showConfMsg", "$iEquip_MCM_add_lbl_showConfMsg", WC.bShowQueueConfirmationMessages)
	MCM.AddToggleOptionST("add_tgl_signlBothQue", "$iEquip_MCM_add_lbl_signlBothQue", WC.bAllowSingleItemsInBothQueues)
    MCM.AddToggleOptionST("add_tgl_dsblAddToQue", "$iEquip_MCM_add_lbl_dsblAddToQue", KH.bDisableAddToQueue)

	MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_add_lbl_autoAddOpts</font>")
    MCM.AddToggleOptionST("add_tgl_autoAdd", "$iEquip_MCM_add_lbl_autoAdd", bAutoAddEnabled)
    if bAutoAddEnabled
        MCM.AddToggleOptionST("add_tgl_autoAddHandItems", "$iEquip_MCM_add_lbl_autoAddHandItems", EH.bAutoAddNewItems)
        MCM.AddToggleOptionST("add_tgl_autoAddShouts", "$iEquip_MCM_add_lbl_autoAddShouts", EH.bAutoAddShouts)
        MCM.AddToggleOptionST("add_tgl_autoAddPowers", "$iEquip_MCM_add_lbl_autoAddPowers", EH.bAutoAddPowers)
        MCM.AddToggleOptionST("add_tgl_autoAddPotions", "$iEquip_MCM_add_lbl_autoAddPotions", PO.bAutoAddPotions)
        MCM.AddToggleOptionST("add_tgl_autoAddPoisons", "$iEquip_MCM_add_lbl_autoAddPoisons", PO.bAutoAddPoisons)
        MCM.AddToggleOptionST("add_tgl_autoAddConsumables", "$iEquip_MCM_add_lbl_autoAddConsumables", PO.bAutoAddConsumables)
    endIf

	MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_add_lbl_cacheBlkLst</font>")
    MCM.AddToggleOptionST("add_tgl_allowCacheRmvItm", "$iEquip_MCM_add_lbl_allowCacheRmvItm", WC.bEnableRemovedItemCaching)
            
    if WC.bEnableRemovedItemCaching
        MCM.AddSliderOptionST("add_sld_MaxItmCache", "$iEquip_MCM_add_lbl_MaxItmCache", WC.iMaxCachedItems, iEquip_StringExt.LocalizeString("$iEquip_MCM_add_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_add_lbl_items"))
    endIf

    MCM.AddToggleOptionST("add_tgl_enblBlacklist", "$iEquip_MCM_add_lbl_enblBlacklist", WC.bBlacklistEnabled)
    
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_add_lbl_addBack</font>")
    
    if WC.findInQueue(0, "$iEquip_common_Unarmed") == -1
        MCM.AddTextOptionST("add_txt_addFistsLeft", "$iEquip_MCM_add_lbl_AddUnarmedLeft", "")
    endIf

    if WC.findInQueue(1, "$iEquip_common_Unarmed") == -1
        MCM.AddTextOptionST("add_txt_addFistsRight", "$iEquip_MCM_add_lbl_AddUnarmedRight", "")
    endIf

    if WC.bPotionGrouping
        MCM.AddEmptyOption()
        if !WC.abPotionGroupEnabled[0]
            MCM.AddTextOptionST("add_txt_addHealthGroup", "$iEquip_MCM_add_lbl_addHealthGroup", "")
        endIf
        if !WC.abPotionGroupEnabled[1]
            MCM.AddTextOptionST("add_txt_addMagickaGroup", "$iEquip_MCM_add_lbl_addMagickaGroup", "")
        endIf
        if !WC.abPotionGroupEnabled[2]
            MCM.AddTextOptionST("add_txt_addStaminaGroup", "$iEquip_MCM_add_lbl_addStaminaGroup", "")
        endIf
    endIf
endFunction

; ------------------------
; - Add To Queue Options -
; ------------------------

State add_tgl_showConfMsg
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_showConfMsg")
        elseIf currentEvent == "Select"
            WC.bShowQueueConfirmationMessages = !WC.bShowQueueConfirmationMessages
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        elseIf currentEvent == "Default"
            WC.bShowQueueConfirmationMessages = true 
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        endIf
    endEvent
endState

State add_tgl_signlBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_signlBothQue")
        elseIf currentEvent == "Select"
            WC.bAllowSingleItemsInBothQueues = !WC.bAllowSingleItemsInBothQueues
        
            if !WC.bAllowSingleItemsInBothQueues
                if MCM.ShowMessage("$iEquip_MCM_add_msg_signlBothQue",  true, "$iEquip_MCM_add_btn_purge", "$iEquip_MCM_add_btn_leave")
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

State add_tgl_dsblAddToQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_dsblAddToQue")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && KH.bDisableAddToQueue)
            KH.bDisableAddToQueue = !KH.bDisableAddToQueue
            MCM.SetToggleOptionValueST(KH.bDisableAddToQueue)
        endIf
    endEvent
endState

; --------------------
; - Auto Add Options -
; --------------------

State add_tgl_autoAdd
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAdd")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && bAutoAddEnabled)
                bAutoAddEnabled = !bAutoAddEnabled
                if !bAutoAddEnabled
                    EH.bAutoAddNewItems = false
                    EH.bAutoAddShouts = false
                    EH.bAutoAddPowers = false
                    PO.bAutoAddConsumables = false
                    PO.bAutoAddPotions = false
                    PO.bAutoAddPoisons = false
                endIf
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_tgl_autoAddHandItems
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddHandItems")
        else
            If currentEvent == "Select"
                EH.bAutoAddNewItems = !EH.bAutoAddNewItems
            elseIf currentEvent == "Default"
                EH.bAutoAddNewItems = false
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddNewItems)
        endIf
    endEvent
endState

State add_tgl_autoAddShouts
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddShouts")
        else
            If currentEvent == "Select"
                EH.bAutoAddShouts = !EH.bAutoAddShouts
            elseIf currentEvent == "Default"
                EH.bAutoAddShouts = false
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddShouts)
        endIf
    endEvent
endState

State add_tgl_autoAddPowers
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddPowers")
        else
            If currentEvent == "Select"
                EH.bAutoAddPowers = !EH.bAutoAddPowers
            elseIf currentEvent == "Default"
                EH.bAutoAddPowers = false
            endIf
            MCM.SetToggleOptionValueST(EH.bAutoAddPowers)
        endIf
    endEvent
endState

State add_tgl_autoAddPotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddPotions")
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

State add_tgl_autoAddPoisons
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddPoisons")
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

State add_tgl_autoAddConsumables
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_autoAddConsumables")
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

; -----------------------------
; - Cache & Blacklist Options -
; -----------------------------

State add_tgl_allowCacheRmvItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_allowCacheRmvItm")
        elseIf currentEvent == "Select"
            WC.bEnableRemovedItemCaching = !WC.bEnableRemovedItemCaching
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEnableRemovedItemCaching = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_sld_MaxItmCache
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iMaxCachedItems, 0.0, 128.0, 1.0, 60.0)
        elseIf currentEvent == "Accept"
            WC.iMaxCachedItems = currentVar as int
            MCM.SetSliderOptionValueST(WC.iMaxCachedItems, iEquip_StringExt.LocalizeString("$iEquip_MCM_add_lbl_max") + " {0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_add_lbl_cachedItms"))
        endIf
    endEvent
endState

State add_tgl_enblBlacklist
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_enblBlacklist")
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

; --------------------
; - Add Back Options -
; --------------------

State add_txt_addFistsLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_addFistsLeft")
        elseIf currentEvent == "Select"
            WC.addFists(0)
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_txt_addFistsRight
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_addFistsRight")
        elseIf currentEvent == "Select"
            WC.addFists(1)
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_txt_addHealthGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_addHealthGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(0)
            WC.abPotionGroupAddedBack[0] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_txt_addMagickaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_addMagickaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(1)
            WC.abPotionGroupAddedBack[1] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State add_txt_addStaminaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_add_txt_addStaminaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(2)
            WC.abPotionGroupAddedBack[2] = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState
