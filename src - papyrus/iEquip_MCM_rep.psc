Scriptname iEquip_MCM_rep extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto

string[] chargeDisplayOptions
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int[] meterFillDirection
string[] poisonMessageOptions
string[] poisonIndicatorOptions

; #############
; ### SETUP ###

function initData()
    chargeDisplayOptions = new String[3]
    chargeDisplayOptions[0] = "$iEquip_MCM_rep_opt_Hidden"
    chargeDisplayOptions[1] = "$iEquip_MCM_rep_opt_Meters"
    chargeDisplayOptions[2] = "$iEquip_MCM_rep_opt_Soulgem"

    meterFillDirectionOptions = new String[3]
    meterFillDirectionOptions[0] = "$iEquip_MCM_rep_opt_left"
    meterFillDirectionOptions[1] = "$iEquip_MCM_rep_opt_right"
    meterFillDirectionOptions[2] = "$iEquip_MCM_rep_opt_both"

    rawMeterFillDirectionOptions = new String[3] ;DO NOT TRANSLATE!
    rawMeterFillDirectionOptions[0] = "left"
    rawMeterFillDirectionOptions[1] = "right"
    rawMeterFillDirectionOptions[2] = "both"

    meterFillDirection = new int[2]
    meterFillDirection[0] = 1

    poisonMessageOptions = new String[3]
    poisonMessageOptions[0] = "$iEquip_MCM_rep_opt_ShowAll"
    poisonMessageOptions[1] = "$iEquip_MCM_rep_opt_TopUpSw"
    poisonMessageOptions[2] = "$iEquip_MCM_rep_opt_DntShow"
    
    poisonIndicatorOptions = new String[4]
    poisonIndicatorOptions[0] = "$iEquip_MCM_rep_opt_Count"
    poisonIndicatorOptions[1] = "$iEquip_MCM_rep_opt_DropCount"
    poisonIndicatorOptions[2] = "$iEquip_MCM_rep_opt_Drop"
    poisonIndicatorOptions[3] = "$iEquip_MCM_rep_opt_Drops"
endFunction

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddTextOptionST("rep_txt_showEnchRechHelp", "$iEquip_MCM_rep_lbl_showEnchRechHelp", "")
        MCM.AddToggleOptionST("rep_tgl_enblEnchRech", "$iEquip_MCM_rep_lbl_enblEnchRech", RC.bRechargingEnabled)
        MCM.AddEmptyOption()
                
        if RC.bRechargingEnabled
            MCM.AddHeaderOption("$iEquip_MCM_rep_lbl_soulgemUseOpts")
            MCM.AddToggleOptionST("rep_tgl_useLargSoul", "$iEquip_MCM_rep_lbl_useLargSoul", RC.bUseLargestSoul)
            MCM.AddToggleOptionST("rep_tgl_useOvrsizSoul", "$iEquip_MCM_rep_lbl_useOvrsizSoul", RC.bAllowOversizedSouls)
            MCM.AddToggleOptionST("rep_tgl_usePartGem", "$iEquip_MCM_rep_lbl_usePartGem", RC.bUsePartFilledGems)
           
            MCM.AddEmptyOption()        
            MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
            MCM.AddMenuOptionST("rep_men_showEnchCharge", "$iEquip_MCM_rep_lbl_showEnchCharge", chargeDisplayOptions[CM.iChargeDisplayType])
            if CM.iChargeDisplayType > 0
                MCM.AddToggleOptionST("rep_tgl_enableChargeFadeout", "$iEquip_MCM_rep_lbl_enableChargeFadeout", CM.bChargeFadeoutEnabled)
                if CM.bChargeFadeoutEnabled
                    MCM.AddSliderOptionST("rep_sld_chargeFadeDelay", "$iEquip_MCM_rep_lbl_chargeFadeDelay", CM.fChargeFadeoutDelay, (iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_fadeAfter") + " {1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds")))
                endIf
                
                MCM.AddColorOptionST("rep_col_normFillCol", "$iEquip_MCM_rep_lbl_normFillCol", CM.iPrimaryFillColor)
                MCM.AddToggleOptionST("rep_tgl_enableCustomFlashCol", "$iEquip_MCM_rep_lbl_enableCustomFlashCol", CM.bCustomFlashColor)
                if CM.bCustomFlashColor
                    MCM.AddColorOptionST("rep_col_meterFlashCol", "$iEquip_MCM_rep_lbl_meterFlashCol", CM.iFlashColor)
                endIf
                
                MCM.AddToggleOptionST("rep_tgl_changeColLowCharge", "$iEquip_MCM_rep_lbl_changeColLowCharge", CM.bEnableLowCharge)
                if CM.bEnableLowCharge
                    MCM.AddSliderOptionST("rep_sld_setLowChargeTresh", "$iEquip_MCM_rep_lbl_setLowChargeTresh", CM.fLowChargeThreshold*100, "{0}%")
                    MCM.AddColorOptionST("rep_col_lowFillCol", "$iEquip_MCM_rep_lbl_lowFillCol", CM.iLowChargeFillColor)
                endIf
                
                if CM.iChargeDisplayType == 1
                    MCM.AddToggleOptionST("rep_tgl_enableGradientFill", "$iEquip_MCM_rep_lbl_enableGradientFill", CM.bEnableGradientFill)
                    if CM.bEnableGradientFill
                        MCM.AddColorOptionST("rep_col_gradFillCol", "$iEquip_MCM_rep_lbl_gradFillCol", CM.iSecondaryFillColor)
                    endIf
                    
                    MCM.AddMenuOptionST("rep_men_leftFillDir", "$iEquip_MCM_rep_lbl_leftFillDir", meterFillDirectionOptions[meterFillDirection[0]])
                    MCM.AddMenuOptionST("rep_men_rightFillDir", "$iEquip_MCM_rep_lbl_rightFillDir", meterFillDirectionOptions[meterFillDirection[1]])
                endIf
            endIf
        endIf

        MCM.SetCursorPosition(1)
                
        if !WC.bPoisonsEnabled
            MCM.AddEmptyOption()
            MCM.AddTextOption("$iEquip_MCM_rep_txt_PoisonsDisabled1", "")
            MCM.AddTextOption("$iEquip_MCM_rep_txt_PoisonsDisabled2", "")
            MCM.AddTextOption("$iEquip_MCM_rep_txt_PoisonsDisabled3", "")
            MCM.AddTextOption("$iEquip_MCM_rep_txt_PoisonsDisabled4", "")
         else
            MCM.AddTextOptionST("rep_txt_showPoisonHelp", "$iEquip_MCM_rep_lbl_showPoisonHelp", "")
                   
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_rep_lbl_poisonUseOpts")
            MCM.AddMenuOptionST("rep_men_confMsg", "$iEquip_MCM_rep_lbl_confMsg", poisonMessageOptions[WC.iShowPoisonMessages])
            MCM.AddToggleOptionST("rep_tgl_allowPoisonSwitch", "$iEquip_MCM_rep_lbl_allowPoisonSwitch", WC.bAllowPoisonSwitching)
            MCM.AddToggleOptionST("rep_tgl_allowPoisonTopup", "$iEquip_MCM_rep_lbl_allowPoisonTopup", WC.bAllowPoisonTopUp)
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_rep_lbl_poisonChargeOpts")
            MCM.AddSliderOptionST("rep_sld_chargePerVial", "$iEquip_MCM_rep_lbl_chargePerVial", WC.iPoisonChargesPerVial, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_chrgs"))
            MCM.AddSliderOptionST("rep_sld_chargeMult", "$iEquip_MCM_rep_lbl_chargeMult", WC.iPoisonChargeMultiplier, "{0}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_baseChrgs"))
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
            MCM.AddMenuOptionST("rep_men_poisonIndStyle", "$iEquip_MCM_rep_lbl_poisonIndStyle", poisonIndicatorOptions[WC.iPoisonIndicatorStyle])
        endIf
    endIf
endFunction

; ##############################
; ### Recharging & Poisoning ###
; ##############################

State rep_txt_showEnchRechHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_recharging1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                MCM.ShowMessage("$iEquip_help_recharging2", false, "$iEquip_common_msg_Exit")
            endIf
        endIf 
    endEvent
endState

State rep_tgl_enblEnchRech
    event OnBeginState()
        if currentEvent == "Select"
            RC.bRechargingEnabled = !RC.bRechargingEnabled
        elseIf currentEvent == "Default"
            RC.bRechargingEnabled = true
        endIf

        MCM.forcePageReset()
    endEvent
endState

; -----------------------
; - Soulgem Use Options -
; -----------------------

State rep_tgl_useLargSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_useLargSoul")
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

State rep_tgl_useOvrsizSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_useOvrsizSoul")
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

State rep_tgl_usePartGem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_usePartGem")
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

; ------------------
; - Widget Options -
; ------------------

State rep_men_showEnchCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_showEnchCharge")
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

State rep_tgl_enableChargeFadeout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_enableChargeFadeout")
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

State rep_sld_chargeFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_chargeFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(CM.fChargeFadeoutDelay, 1.0, 20.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            CM.fChargeFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(CM.fChargeFadeoutDelay, (iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_fadeAfter") + " {1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds")))
        endIf 
    endEvent
endState

State rep_col_normFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_normFillCol")
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

State rep_tgl_enableCustomFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_enableCustomFlashCol")
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

State rep_col_meterFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_meterFlashCol")
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

State rep_tgl_enableGradientFill
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_enableGradientFill")
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

State rep_col_gradFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_gradFillCol")
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

State rep_tgl_changeColLowCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_changeColLowCharge")
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

State rep_sld_setLowChargeTresh
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_setLowChargeTresh")
        elseIf currentEvent == "Open"
            MCM.fillSlider(CM.fLowChargeThreshold*100, 5.0, 50.0, 5.0, 20.0)
        elseIf currentEvent == "Accept"
            CM.fLowChargeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(CM.fLowChargeThreshold*100, "{0}%")
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rep_col_lowFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_lowFillCol")
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

State rep_men_leftFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_leftFillDir")
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

State rep_men_rightFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_rightFillDir")
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

; ----------------------
; -    Poison Help     -
; ----------------------

State rep_txt_showPoisonHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_poisoning1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                MCM.ShowMessage("$iEquip_help_poisoning2", false, "$iEquip_common_msg_Exit")
            endIf
        endIf 
    endEvent
endState

; ----------------------
; - Poison Use Options -
; ----------------------

State rep_men_confMsg
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_confMsg")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iShowPoisonMessages, poisonMessageOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iShowPoisonMessages = currentVar as int
            MCM.SetMenuOptionValueST(poisonMessageOptions[WC.iShowPoisonMessages])
        endIf 
    endEvent
endState

State rep_tgl_allowPoisonSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_allowPoisonSwitch")
        elseIf currentEvent == "Select"
            WC.bAllowPoisonSwitching = !WC.bAllowPoisonSwitching
            MCM.SetToggleOptionValueST(WC.bAllowPoisonSwitching)
        elseIf currentEvent == "Default"
            WC.bAllowPoisonSwitching = true
            MCM.SetToggleOptionValueST(WC.bAllowPoisonSwitching)
        endIf 
    endEvent
endState

State rep_tgl_allowPoisonTopup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_allowPoisonTopup")
        elseIf currentEvent == "Select"
            WC.bAllowPoisonTopUp = !WC.bAllowPoisonTopUp
            MCM.SetToggleOptionValueST(WC.bAllowPoisonTopUp)
        elseIf currentEvent == "Default"
            WC.bAllowPoisonTopUp = true
            MCM.SetToggleOptionValueST(WC.bAllowPoisonTopUp)
        endIf 
    endEvent
endState

; -------------------------
; - Poison Charge Options -
; -------------------------

State rep_sld_chargePerVial
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_chargePerVial")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargesPerVial, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargesPerVial = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargesPerVial, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_chrgs"))
        endIf 
    endEvent
endState

State rep_sld_chargeMult
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_chargeMult")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargeMultiplier, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargeMultiplier = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargeMultiplier, "{0}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_baseChrgs"))
        endIf 
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State rep_men_poisonIndStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_poisonIndStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iPoisonIndicatorStyle, poisonIndicatorOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iPoisonIndicatorStyle = currentVar as int
            MCM.SetMenuOptionValueST(poisonIndicatorOptions[WC.iPoisonIndicatorStyle])
            WC.bPoisonIndicatorStyleChanged = true
        endIf 
    endEvent
endState
