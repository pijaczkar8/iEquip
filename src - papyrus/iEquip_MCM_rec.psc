Scriptname iEquip_MCM_rec extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto

string[] chargeDisplayOptions
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int[] meterFillDirection
string[] effectsOptions

; #############
; ### SETUP ###

function initData()
    chargeDisplayOptions = new String[4]
    chargeDisplayOptions[0] = "$iEquip_MCM_rec_opt_Hidden"
    chargeDisplayOptions[1] = "$iEquip_MCM_rec_opt_Meters"
    chargeDisplayOptions[2] = "$iEquip_MCM_rec_opt_Soulgem"
    chargeDisplayOptions[3] = "$iEquip_MCM_rec_opt_RadialMeters"

    meterFillDirectionOptions = new String[3]
    meterFillDirectionOptions[0] = "$iEquip_MCM_rec_opt_left"
    meterFillDirectionOptions[1] = "$iEquip_MCM_rec_opt_right"
    meterFillDirectionOptions[2] = "$iEquip_MCM_rec_opt_both"

    rawMeterFillDirectionOptions = new String[3] ;DO NOT TRANSLATE!
    rawMeterFillDirectionOptions[0] = "left"
    rawMeterFillDirectionOptions[1] = "right"
    rawMeterFillDirectionOptions[2] = "both"

    meterFillDirection = new int[2]
    meterFillDirection[0] = 1

    effectsOptions = new String[4]
    effectsOptions[0] = "$iEquip_MCM_common_opt_noFX"
    effectsOptions[1] = "$iEquip_MCM_common_opt_SFXOnly"
    effectsOptions[2] = "$iEquip_MCM_common_opt_VFXOnly"
    effectsOptions[3] = "$iEquip_MCM_common_opt_bothFX"
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, RC.bRechargingEnabled as int)
    jArray.addInt(jPageObj, RC.iRechargeFX)
	
	jArray.addInt(jPageObj, RC.bUseLargestSoul as int)
	jArray.addInt(jPageObj, RC.bAllowOversizedSouls as int)
	jArray.addInt(jPageObj, RC.bUsePartFilledGems as int)
	
	jArray.addInt(jPageObj, CM.iChargeDisplayType)
	jArray.addInt(jPageObj, CM.bChargeFadeoutEnabled as int)
	jArray.addFlt(jPageObj, CM.fChargeFadeoutDelay)
	jArray.addInt(jPageObj, CM.iPrimaryFillColor)
	jArray.addInt(jPageObj, CM.bCustomFlashColor as int)
	jArray.addInt(jPageObj, CM.iFlashColor)
	jArray.addInt(jPageObj, CM.bEnableLowCharge as int)
	jArray.addFlt(jPageObj, CM.fLowChargeThreshold)
	jArray.addInt(jPageObj, CM.iLowChargeFillColor)
	jArray.addInt(jPageObj, CM.bEnableGradientFill as int)
	jArray.addInt(jPageObj, CM.iSecondaryFillColor)
	jArray.addInt(jPageObj, meterFillDirection[0])
    jArray.addInt(jPageObj, meterFillDirection[1])

    jArray.addInt(jPageObj, WC.EH.bRealTimeStaffMeters as int)

    jArray.addInt(jPageObj, RC.bShowNotifications as int)
	
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	RC.bRechargingEnabled = jArray.getInt(jPageObj, 0)
    RC.iRechargeFX = jArray.getInt(jPageObj, 1, 3)
	
	RC.bUseLargestSoul = jArray.getInt(jPageObj, 2)
	RC.bAllowOversizedSouls = jArray.getInt(jPageObj, 3)
	RC.bUsePartFilledGems = jArray.getInt(jPageObj, 4)
	
	CM.iChargeDisplayType = jArray.getInt(jPageObj, 5)
	CM.bChargeFadeoutEnabled = jArray.getInt(jPageObj, 6)
	CM.fChargeFadeoutDelay = jArray.getFlt(jPageObj, 7)
	CM.iPrimaryFillColor = jArray.getInt(jPageObj, 8)
	CM.bCustomFlashColor = jArray.getInt(jPageObj, 9)
	CM.iFlashColor = jArray.getInt(jPageObj, 10)
	CM.bEnableLowCharge = jArray.getInt(jPageObj, 11)
	CM.fLowChargeThreshold = jArray.getFlt(jPageObj, 12)
	CM.iLowChargeFillColor = jArray.getInt(jPageObj, 13)
	CM.bEnableGradientFill = jArray.getInt(jPageObj, 14)
	CM.iSecondaryFillColor = jArray.getInt(jPageObj, 15)
	meterFillDirection[0] = jArray.getInt(jPageObj, 16)
    CM.asMeterFillDirection[0] = rawMeterFillDirectionOptions[meterFillDirection[0]]
	meterFillDirection[1] = jArray.getInt(jPageObj, 17)
	CM.asMeterFillDirection[1] = rawMeterFillDirectionOptions[meterFillDirection[1]]

    WC.EH.bRealTimeStaffMeters = jArray.getInt(jPageObj, 18)
    RC.bShowNotifications = jArray.getInt(jPageObj, 19, 1)

endFunction

function drawPage()
	MCM.AddTextOptionST("rec_txt_showEnchRechHelp", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_rec_lbl_showEnchRechHelp</font>", "")
    if RC.bRechargingEnabled
        MCM.AddToggleOptionST("rec_tgl_enblEnchRech", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_rec_lbl_enblEnchRech</font>", RC.bRechargingEnabled)
        MCM.AddMenuOptionST("rec_men_rechargeFX", "$iEquip_MCM_common_lbl_FX", effectsOptions[RC.iRechargeFX])
        MCM.AddToggleOptionST("rec_tgl_warningNotifications", "$iEquip_MCM_rec_lbl_warningNotifications", RC.bShowNotifications)
        MCM.AddToggleOptionST("rec_tgl_gemUseNotifications", "$iEquip_MCM_rec_lbl_gemUseNotifications", RC.bShowGemUseNotifications)
        MCM.AddEmptyOption()

        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_rec_lbl_soulgemUseOpts</font>")
        MCM.AddToggleOptionST("rec_tgl_useLargSoul", "$iEquip_MCM_rec_lbl_useLargSoul", RC.bUseLargestSoul)
        MCM.AddToggleOptionST("rec_tgl_useOvrsizSoul", "$iEquip_MCM_rec_lbl_useOvrsizSoul", RC.bAllowOversizedSouls)
        MCM.AddToggleOptionST("rec_tgl_usePartGem", "$iEquip_MCM_rec_lbl_usePartGem", RC.bUsePartFilledGems)
    else
        MCM.AddToggleOptionST("rec_tgl_enblEnchRech", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_rec_lbl_enblEnchRech</font>", RC.bRechargingEnabled)
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
    MCM.AddMenuOptionST("rec_men_showEnchCharge", "$iEquip_MCM_rec_lbl_showEnchCharge", chargeDisplayOptions[CM.iChargeDisplayType])
    if CM.iChargeDisplayType > 0
        MCM.AddToggleOptionST("rec_tgl_enableChargeFadeout", "$iEquip_MCM_rec_lbl_enableChargeFadeout", CM.bChargeFadeoutEnabled)
        if CM.bChargeFadeoutEnabled
            MCM.AddSliderOptionST("rec_sld_chargeFadeDelay", "$iEquip_MCM_rec_lbl_chargeFadeDelay", CM.fChargeFadeoutDelay, (iEquip_StringExt.LocalizeString("$iEquip_MCM_rec_lbl_fadeAfter") + " {1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds")))
        endIf
        
        MCM.AddColorOptionST("rec_col_normFillCol", "$iEquip_MCM_rec_lbl_normFillCol", CM.iPrimaryFillColor)
        MCM.AddToggleOptionST("rec_tgl_enableCustomFlashCol", "$iEquip_MCM_rec_lbl_enableCustomFlashCol", CM.bCustomFlashColor)
        if CM.bCustomFlashColor
            MCM.AddColorOptionST("rec_col_meterFlashCol", "$iEquip_MCM_rec_lbl_meterFlashCol", CM.iFlashColor)
        endIf
        
        MCM.AddToggleOptionST("rec_tgl_changeColLowCharge", "$iEquip_MCM_rec_lbl_changeColLowCharge", CM.bEnableLowCharge)
        if CM.bEnableLowCharge
            MCM.AddSliderOptionST("rec_sld_setLowChargeTresh", "$iEquip_MCM_rec_lbl_setLowChargeTresh", CM.fLowChargeThreshold*100, "{0}%")
            MCM.AddColorOptionST("rec_col_lowFillCol", "$iEquip_MCM_rec_lbl_lowFillCol", CM.iLowChargeFillColor)
        endIf
        
        if CM.iChargeDisplayType == 1
            MCM.AddToggleOptionST("rec_tgl_enableGradientFill", "$iEquip_MCM_rec_lbl_enableGradientFill", CM.bEnableGradientFill)
            if CM.bEnableGradientFill
                MCM.AddColorOptionST("rec_col_gradFillCol", "$iEquip_MCM_rec_lbl_gradFillCol", CM.iSecondaryFillColor)
            endIf
            
            MCM.AddMenuOptionST("rec_men_leftFillDir", "$iEquip_MCM_rec_lbl_leftFillDir", meterFillDirectionOptions[meterFillDirection[0]])
            MCM.AddMenuOptionST("rec_men_rightFillDir", "$iEquip_MCM_rec_lbl_rightFillDir", meterFillDirectionOptions[meterFillDirection[1]])
        endIf
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_rec_lbl_StaffCasting</font>")
        MCM.AddToggleOptionST("rec_tgl_realTimeStaffMeters", "$iEquip_MCM_rec_lbl_realTimeStaffMeters", WC.EH.bRealTimeStaffMeters)
    endIf
endFunction

; ##############################
; ### Recharging & Poisoning ###
; ##############################

State rec_txt_showEnchRechHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_recharging1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                MCM.ShowMessage("$iEquip_help_recharging2", false, "$iEquip_common_msg_Exit")
            endIf
        endIf 
    endEvent
endState

State rec_tgl_enblEnchRech
    event OnBeginState()
        if currentEvent == "Select"
            RC.bRechargingEnabled = !RC.bRechargingEnabled
        elseIf currentEvent == "Default"
            RC.bRechargingEnabled = true
        endIf

        MCM.forcePageReset()
    endEvent
endState

; -------------------
; - VFX/SFX Options -
; -------------------

State rec_men_rechargeFX
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_rechargeFX")
        elseIf currentEvent == "Open"
            MCM.fillMenu(RC.iRechargeFX, effectsOptions, 3)
        elseIf currentEvent == "Accept"
            RC.iRechargeFX = currentVar as int
            MCM.SetMenuOptionValueST(effectsOptions[RC.iRechargeFX])
        endIf 
    endEvent
endState

; ------------------------
; - Notification Options -
; ------------------------

State rec_tgl_warningNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_warningNotifications")
        elseIf currentEvent == "Select"
            RC.bShowNotifications = !RC.bShowNotifications
            MCM.SetToggleOptionValueST(RC.bShowNotifications)
        endIf 
    endEvent
endState

State rec_tgl_gemUseNotifications
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_gemUseNotifications")
        elseIf currentEvent == "Select"
            RC.bShowGemUseNotifications = !RC.bShowGemUseNotifications
            MCM.SetToggleOptionValueST(RC.bShowGemUseNotifications)
        endIf 
    endEvent
endState
; -----------------------
; - Soulgem Use Options -
; -----------------------

State rec_tgl_useLargSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_useLargSoul")
        else
            If currentEvent == "Select"
                RC.bUseLargestSoul = !RC.bUseLargestSoul
            elseIf currentEvent == "Default"
                RC.bUseLargestSoul = true
            endIf
            MCM.SetToggleOptionValueST(RC.bUseLargestSoul)
        endIf 
    endEvent
endState

State rec_tgl_useOvrsizSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_useOvrsizSoul")
        else
            If currentEvent == "Select"
                RC.bAllowOversizedSouls = !RC.bAllowOversizedSouls
            elseIf currentEvent == "Default"
                RC.bAllowOversizedSouls = false
            endIf
            MCM.SetToggleOptionValueST(RC.bAllowOversizedSouls)
        endIf 
    endEvent
endState

State rec_tgl_usePartGem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_usePartGem")
        else
            If currentEvent == "Select"
                RC.bUsePartFilledGems = !RC.bUsePartFilledGems
            elseIf currentEvent == "Default"
                RC.bUsePartFilledGems = false
            endIf
            MCM.SetToggleOptionValueST(RC.bUsePartFilledGems)
        endIf 
    endEvent
endState

; ----------------------
; -    Staff Casting   -
; ----------------------

State rec_tgl_realTimeStaffMeters
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_realTimeStaffMeters")
        elseIf currentEvent == "Select" || ("Default" && !WC.EH.bRealTimeStaffMeters)
            WC.EH.bRealTimeStaffMeters = !WC.EH.bRealTimeStaffMeters
            MCM.SetToggleOptionValueST(WC.EH.bRealTimeStaffMeters)
        endIf 
    endEvent
endState

; ------------------
; - Widget Options -
; ------------------

State rec_men_showEnchCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_showEnchCharge")
        elseIf currentEvent == "Open"
            MCM.fillMenu(CM.iChargeDisplayType, chargeDisplayOptions, 1)
        elseIf currentEvent == "Accept"
            CM.iChargeDisplayType = currentVar as int
            MCM.SetMenuOptionValueST(chargeDisplayOptions[CM.iChargeDisplayType])
            
            if CM.iChargeDisplayType == 2
                CM.bEnableGradientFill = false
            endIf

            CM.bSettingsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State rec_tgl_enableChargeFadeout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_enableChargeFadeout")
        else
            If currentEvent == "Select"
                CM.bChargeFadeoutEnabled = !CM.bChargeFadeoutEnabled
            elseIf currentEvent == "Default"
                CM.bChargeFadeoutEnabled = false
            endIf
            MCM.SetToggleOptionValueST(CM.bChargeFadeoutEnabled)

            CM.bSettingsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State rec_sld_chargeFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_chargeFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(CM.fChargeFadeoutDelay, 1.0, 20.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            CM.fChargeFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(CM.fChargeFadeoutDelay, (iEquip_StringExt.LocalizeString("$iEquip_MCM_rec_lbl_fadeAfter") + " {1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds")))
        endIf 
    endEvent
endState

State rec_col_normFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_normFillCol")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(CM.iPrimaryFillColor)
            MCM.SetColorDialogDefaultColor(0x8c9ec2)
        else
            If currentEvent == "Accept"
                CM.iPrimaryFillColor = currentVar as int
            elseIf currentEvent == "Default"
                CM.iPrimaryFillColor = 0x8c9ec2
            endIf
            MCM.SetColorOptionValueST(CM.iPrimaryFillColor)
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rec_tgl_enableCustomFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_enableCustomFlashCol")
        else
            If currentEvent == "Select"
                CM.bCustomFlashColor = !CM.bCustomFlashColor
            elseIf currentEvent == "Default"
                CM.bCustomFlashColor = false
            endIf
            MCM.SetToggleOptionValueST(CM.bCustomFlashColor)
            if !CM.bCustomFlashColor
                CM.iFlashColor = -1
            endIf
            
            CM.bSettingsChanged = true
            MCM.forcePageReset() 
        endIf
    endEvent
endState

State rec_col_meterFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_meterFlashCol")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(CM.iFlashColor)
            MCM.SetColorDialogDefaultColor(0xFFFFFF)
        else
            If currentEvent == "Accept"
                CM.iFlashColor = currentVar as int
            elseIf currentEvent == "Default"
                CM.iFlashColor = 0xFFFFFF
            endIf
            
            MCM.SetColorOptionValueST(CM.iFlashColor)
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rec_tgl_enableGradientFill
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_enableGradientFill")
        else
            If currentEvent == "Select"
                CM.bEnableGradientFill = !CM.bEnableGradientFill
            elseIf currentEvent == "Default"
                CM.bEnableGradientFill = false
            endIf
            MCM.SetToggleOptionValueST(CM.bEnableGradientFill)
            if CM.bEnableLowCharge
                CM.bEnableLowCharge = false
            endIf
            
            if !CM.bEnableGradientFill
                CM.iSecondaryFillColor = -1
            endIf
            
            CM.bSettingsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State rec_col_gradFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_gradFillCol")
        elseIf currentEvent == "Open"
            if CM.iSecondaryFillColor == -1
                MCM.SetColorDialogStartColor(0xee4242)
            else
                MCM.SetColorDialogStartColor(CM.iSecondaryFillColor)
            endIf
            MCM.SetColorDialogDefaultColor(0xee4242)
        else
            If currentEvent == "Accept"
                CM.iSecondaryFillColor = currentVar as int
            elseIf currentEvent == "Default"
                CM.iSecondaryFillColor = 0xee4242
            endIf
            
            MCM.SetColorOptionValueST(CM.iSecondaryFillColor)
            CM.bSettingsChanged = true
        endIf
    endEvent
endState

State rec_tgl_changeColLowCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_changeColLowCharge")
        else
            If currentEvent == "Select"
                CM.bEnableLowCharge = !CM.bEnableLowCharge
            elseIf currentEvent == "Default"
                CM.bEnableLowCharge = true
            endIf
            MCM.SetToggleOptionValueST(CM.bEnableLowCharge)
            if CM.bEnableGradientFill
                CM.bEnableGradientFill = false
            endIf

            CM.bSettingsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State rec_sld_setLowChargeTresh
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_setLowChargeTresh")
        elseIf currentEvent == "Open"
            MCM.fillSlider(CM.fLowChargeThreshold*100, 5.0, 50.0, 5.0, 20.0)
        elseIf currentEvent == "Accept"
            CM.fLowChargeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(CM.fLowChargeThreshold*100, "{0}%")
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rec_col_lowFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_lowFillCol")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(CM.iLowChargeFillColor)
            MCM.SetColorDialogDefaultColor(0xFF0000)
        else
            If currentEvent == "Accept"
                CM.iLowChargeFillColor = currentVar as int
            elseIf currentEvent == "Default"
                CM.iLowChargeFillColor = 0xFF0000
            endIf
            
            MCM.SetColorOptionValueST(CM.iLowChargeFillColor)
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rec_men_leftFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_leftFillDir")
        elseIf currentEvent == "Open"
            MCM.fillMenu(meterFillDirection[0], meterFillDirectionOptions, 0)
        elseIf currentEvent == "Accept"
            meterFillDirection[0] = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[meterFillDirection[0]])
            CM.asMeterFillDirection[0] = rawMeterFillDirectionOptions[meterFillDirection[0]]
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rec_men_rightFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rec_txt_rightFillDir")
        elseIf currentEvent == "Open"
            MCM.fillMenu(meterFillDirection[1], meterFillDirectionOptions, 1)
        elseIf currentEvent == "Accept"
            meterFillDirection[1] = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[meterFillDirection[1]])
            CM.asMeterFillDirection[1] = rawMeterFillDirectionOptions[meterFillDirection[1]]
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState
