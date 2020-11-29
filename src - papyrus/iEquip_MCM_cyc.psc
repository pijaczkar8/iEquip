Scriptname iEquip_MCM_cyc extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto

string[] posIndBehaviour

; #############
; ### SETUP ###

function initData()
    posIndBehaviour = new string[3]
    posIndBehaviour[0] = "$iEquip_MCM_common_opt_disabled"
    posIndBehaviour[1] = "$iEquip_MCM_cyc_opt_onlyCycling"
    posIndBehaviour[2] = "$iEquip_MCM_cyc_opt_alwaysVisible"
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bEquipOnPause as int)
    jArray.addFlt(jPageObj, WC.fEquipOnPauseDelay)

    jArray.addInt(jPageObj, WC.bSlowTimeWhileCycling as int)
    jArray.addInt(jPageObj, WC.iCycleSlowTimeStrength)

    jArray.addInt(jPageObj, WC.bAllowWeaponSwitchHands as int)
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
 
    jArray.addInt(jPageObj, PM.bPreselectEnabled as int)
    jArray.addInt(jPageObj, PM.bShoutPreselectEnabled as int)
    jArray.addInt(jPageObj, PM.bPreselectSwapItemsOnEquip as int)
    jArray.addInt(jPageObj, PM.bTogglePreselectOnEquipAll as int)
    jArray.addInt(jPageObj, PM.bPreselectSwapItemsOnQuickAction as int)

	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj

    WC.bEquipOnPause = jArray.getInt(jPageObj, 0)
    WC.fEquipOnPauseDelay = jArray.getFlt(jPageObj, 1)

    WC.bSlowTimeWhileCycling = jArray.getInt(jPageObj, 2)
    WC.iCycleSlowTimeStrength = jArray.getInt(jPageObj, 3)

    WC.bAllowWeaponSwitchHands = jArray.getInt(jPageObj, 4)
    WC.bSkipRHUnarmedInCombat = jArray.getInt(jPageObj, 5)
    
    if presetVersion < 157
        WC.iPosInd = jArray.getInt(jPageObj, 7)
        WC.iPositionIndicatorColor = jArray.getInt(jPageObj, 8)
        WC.fPositionIndicatorAlpha = jArray.getFlt(jPageObj, 9)
        WC.iCurrPositionIndicatorColor = jArray.getInt(jPageObj, 10)
        WC.fCurrPositionIndicatorAlpha = jArray.getFlt(jPageObj, 11)

        WC.bShowAttributeIcons = jArray.getInt(jPageObj, 12)

        WC.iAutoEquipEnabled = jArray.getInt(jPageObj, 13)
        WC.iAutoEquip = jArray.getInt(jPageObj, 14)
        WC.iCurrentItemEnchanted = jArray.getInt(jPageObj, 15)
        WC.iCurrentItemPoisoned = jArray.getInt(jPageObj, 16)
        WC.bAutoEquipHardcore = jArray.getInt(jPageObj, 17)
        WC.bAutoEquipDontDropFavorites = jArray.getInt(jPageObj, 18)

        PM.bPreselectEnabled = jArray.getInt(jPageObj, 19)
        PM.bShoutPreselectEnabled = jArray.getInt(jPageObj, 20)
        PM.bPreselectSwapItemsOnEquip = jArray.getInt(jPageObj, 21)
        PM.bTogglePreselectOnEquipAll = jArray.getInt(jPageObj, 22)
        PM.bPreselectSwapItemsOnQuickAction = jArray.getInt(jPageObj, 23)
    else
        WC.iPosInd = jArray.getInt(jPageObj, 6)
        WC.iPositionIndicatorColor = jArray.getInt(jPageObj, 7)
        WC.fPositionIndicatorAlpha = jArray.getFlt(jPageObj, 8)
        WC.iCurrPositionIndicatorColor = jArray.getInt(jPageObj, 9)
        WC.fCurrPositionIndicatorAlpha = jArray.getFlt(jPageObj, 10)

        WC.bShowAttributeIcons = jArray.getInt(jPageObj, 11)

        WC.iAutoEquipEnabled = jArray.getInt(jPageObj, 12)
        WC.iAutoEquip = jArray.getInt(jPageObj, 13)
        WC.iCurrentItemEnchanted = jArray.getInt(jPageObj, 14)
        WC.iCurrentItemPoisoned = jArray.getInt(jPageObj, 15)
        WC.bAutoEquipHardcore = jArray.getInt(jPageObj, 16)
        WC.bAutoEquipDontDropFavorites = jArray.getInt(jPageObj, 17)

        PM.bPreselectEnabled = jArray.getInt(jPageObj, 18)
        PM.bShoutPreselectEnabled = jArray.getInt(jPageObj, 19)
        PM.bPreselectSwapItemsOnEquip = jArray.getInt(jPageObj, 20)
        PM.bTogglePreselectOnEquipAll = jArray.getInt(jPageObj, 21)
        PM.bPreselectSwapItemsOnQuickAction = jArray.getInt(jPageObj, 22)
    endIf

endFunction

function drawPage()
 
	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_cyc_lbl_Cycling</font>")
    MCM.AddToggleOptionST("cyc_tgl_eqpPaus", "$iEquip_MCM_cyc_lbl_eqpPaus", WC.bEquipOnPause)
            
    if WC.bEquipOnPause
        MCM.AddSliderOptionST("cyc_sld_eqpPausDelay", "$iEquip_MCM_cyc_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
    endIf

    MCM.AddToggleOptionST("cyc_tgl_slowTime", "$iEquip_MCM_cyc_lbl_slowTime", WC.bSlowTimeWhileCycling)
    
    if WC.bSlowTimeWhileCycling
        MCM.AddSliderOptionST("cyc_sld_slowTimeStr", "$iEquip_MCM_common_lbl_slowTimeStr", WC.iCycleSlowTimeStrength as float, "{0}%")
    endIf

    if WC.bAllowSingleItemsInBothQueues
        MCM.AddToggleOptionST("cyc_tgl_allow1hSwitch", "$iEquip_MCM_cyc_lbl_allow1hSwitch", WC.bAllowWeaponSwitchHands)
    endIf

    MCM.AddToggleOptionST("cyc_tgl_skipUnarmed", "$iEquip_MCM_cyc_lbl_skipUnarmed", WC.bSkipRHUnarmedInCombat)

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
    MCM.AddToggleOptionST("cyc_tgl_showAtrIco", "$iEquip_MCM_cyc_lbl_showAtrIco", WC.bShowAttributeIcons)
    MCM.AddMenuOptionST("cyc_men_showPosInd", "$iEquip_MCM_cyc_lbl_queuePosInd", posIndBehaviour[WC.iPosInd])

    if WC.iPosInd > 0
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_cyc_lbl_posIndOpts</font>")
        MCM.AddColorOptionST("cyc_col_posIndColor", "$iEquip_MCM_cyc_lbl_posIndColor", WC.iPositionIndicatorColor)
        MCM.AddSliderOptionST("cyc_sld_posIndAlpha", "$iEquip_MCM_cyc_lbl_posIndAlpha", WC.fPositionIndicatorAlpha, "{0}%")
        MCM.AddColorOptionST("cyc_col_currPosIndColor", "$iEquip_MCM_cyc_lbl_currPosIndColor", WC.iCurrPositionIndicatorColor)
        MCM.AddSliderOptionST("cyc_sld_currPosIndAlpha", "$iEquip_MCM_cyc_lbl_currPosIndAlpha", WC.fCurrPositionIndicatorAlpha, "{0}%")
        MCM.AddEmptyOption()
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_cyc_lbl_preselectOpts</font>")
    MCM.AddTextOptionST("cyc_txt_whatPreselect", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_cyc_lbl_whatPreselect</font>", "")

    if PM.bPreselectEnabled
        MCM.AddToggleOptionST("cyc_tgl_enblPreselect", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_cyc_lbl_enblPreselect</font>", PM.bPreselectEnabled)
        MCM.AddToggleOptionST("cyc_tgl_enblShoutPreselect", "$iEquip_MCM_cyc_lbl_enblShoutPreselect", PM.bShoutPreselectEnabled)
        MCM.AddToggleOptionST("cyc_tgl_swapPreselectItm", "$iEquip_MCM_cyc_lbl_swapPreselectItm", PM.bPreselectSwapItemsOnEquip)
        MCM.AddToggleOptionST("cyc_tgl_swapPreselectAdv", "$iEquip_MCM_cyc_lbl_swapPreselectAdv", PM.bPreselectSwapItemsOnQuickAction)
        MCM.AddToggleOptionST("cyc_tgl_eqpAllExitPreselectMode", "$iEquip_MCM_cyc_lbl_eqpAllExitPreselectMode", PM.bTogglePreselectOnEquipAll)
    else
        MCM.AddToggleOptionST("cyc_tgl_enblPreselect", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_cyc_lbl_enblPreselect</font>", PM.bPreselectEnabled)
    endIf

endFunction

; ---------------------
; - Cycling Behaviour -
; ---------------------

State cyc_tgl_eqpPaus
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_eqpPaus")
        elseIf currentEvent == "Select"
            WC.bEquipOnPause = !WC.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State cyc_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillSlider(WC.fEquipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            WC.fEquipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fEquipOnPauseDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State cyc_tgl_slowTime
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_slowTime")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && WC.bSlowTimeWhileCycling)
            WC.bSlowTimeWhileCycling = !WC.bSlowTimeWhileCycling
            MCM.forcePageReset()
        endIf
    endEvent
endState

State cyc_sld_slowTimeStr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_slowTimeStr")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iCycleSlowTimeStrength as float, 0.0, 100.0, 5.0, 50.0)
        elseIf currentEvent == "Accept"
            WC.iCycleSlowTimeStrength = currentVar as int
            MCM.SetSliderOptionValueST(currentVar, "{0}%")
        endIf 
    endEvent
endState

; ----------------
; - Skip Options -
; ----------------

State cyc_tgl_allow1hSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_allow1hSwitch")
        elseIf currentEvent == "Select"
            WC.bAllowWeaponSwitchHands = !WC.bAllowWeaponSwitchHands
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        elseIf currentEvent == "Default"
            WC.bAllowWeaponSwitchHands = false 
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        endIf
    endEvent
endState

State cyc_tgl_skipUnarmed
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_skipUnarmed")
        elseIf currentEvent == "Select"
            WC.bSkipRHUnarmedInCombat = !WC.bSkipRHUnarmedInCombat
            MCM.SetToggleOptionValueST(WC.bSkipRHUnarmedInCombat)
        endIf
    endEvent
endState

; ------------------
; - Widget Options -
; ------------------

State cyc_men_showPosInd
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_showPosInd")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iPosInd, posIndBehaviour, 1)
        elseIf currentEvent == "Accept"
            WC.iPosInd = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State cyc_col_posIndColor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_posIndColor")
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

State cyc_sld_posIndAlpha
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_posIndAlpha")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fPositionIndicatorAlpha, 10.0, 100.0, 10.0, 60.0)
        elseIf currentEvent == "Accept"
            WC.fPositionIndicatorAlpha = currentVar
            MCM.SetSliderOptionValueST(WC.fPositionIndicatorAlpha, "{0}%")
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

State cyc_col_currPosIndColor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_currPosIndColor")
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

State cyc_sld_currPosIndAlpha
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_currPosIndAlpha")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fCurrPositionIndicatorAlpha, 10.0, 100.0, 10.0, 40.0)
        elseIf currentEvent == "Accept"
            WC.fCurrPositionIndicatorAlpha = currentVar
            MCM.SetSliderOptionValueST(WC.fCurrPositionIndicatorAlpha, "{0}%")
            WC.bPositionIndicatorSettingsChanged = true
        endIf 
    endEvent
endState

State cyc_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_showAtrIco")
        elseIf currentEvent == "Select"
            WC.bShowAttributeIcons = !WC.bShowAttributeIcons
            MCM.SetToggleOptionValueST(WC.bShowAttributeIcons)
            WC.bAttributeIconsOptionChanged = true
        endIf
    endEvent
endState

; ---------------------
; - Preselect Options -
; ---------------------

State cyc_txt_whatPreselect
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_preselect1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_preselect2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    MCM.ShowMessage("$iEquip_help_preselect3", false, "$OK")
                endIf
            endIf
        endIf
    endEvent    
endState

State cyc_tgl_enblPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_enblPreselect")
        elseIf currentEvent == "Select"
            PM.bPreselectEnabled = !PM.bPreselectEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bPreselectEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State cyc_tgl_enblShoutPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_enblShoutPreselect")
        elseIf currentEvent == "Select"
            PM.bShoutPreselectEnabled = !PM.bShoutPreselectEnabled
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        elseIf currentEvent == "Default"
            PM.bShoutPreselectEnabled = true
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        endIf
    endEvent
endState

State cyc_tgl_swapPreselectItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_swapPreselectItm")
        elseIf currentEvent == "Select"
            PM.bPreselectSwapItemsOnEquip = !PM.bPreselectSwapItemsOnEquip
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        elseIf currentEvent == "Default"
            PM.bPreselectSwapItemsOnEquip = false
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        endIf
    endEvent
endState

State cyc_tgl_swapPreselectAdv
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_swapPreselectAdv")
        elseIf currentEvent == "Select" || currentEvent == "Default" && !PM.bPreselectSwapItemsOnEquip
            PM.bPreselectSwapItemsOnEquip = !PM.bPreselectSwapItemsOnEquip
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        endIf
    endEvent
endState

State cyc_tgl_eqpAllExitPreselectMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_cyc_txt_eqpAllExitPreselectMode")
        elseIf currentEvent == "Select"
            PM.bTogglePreselectOnEquipAll = !PM.bTogglePreselectOnEquipAll
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        elseIf currentEvent == "Default"
            PM.bTogglePreselectOnEquipAll = false
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        endIf
    endEvent
endState
