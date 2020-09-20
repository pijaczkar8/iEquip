Scriptname iEquip_MCM_rep extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_ThrowingPoisons Property TP Auto
iEquip_KeyHandler Property KH Auto

string[] chargeDisplayOptions
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int[] meterFillDirection
string[] poisonMessageOptions
string[] poisonIndicatorOptions
string[] throwingPoisonOptions
string[] throwingPoisonHands
string[] effectsOptions

int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()
    chargeDisplayOptions = new String[4]
    chargeDisplayOptions[0] = "$iEquip_MCM_rep_opt_Hidden"
    chargeDisplayOptions[1] = "$iEquip_MCM_rep_opt_Meters"
    chargeDisplayOptions[2] = "$iEquip_MCM_rep_opt_Soulgem"
    chargeDisplayOptions[3] = "$iEquip_MCM_rep_opt_RadialMeters"

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

    throwingPoisonOptions = new String[3]
    throwingPoisonOptions[0] = "$iEquip_MCM_common_opt_disabled"
    throwingPoisonOptions[1] = "$iEquip_MCM_rep_opt_TP_ThrowSwitchBack"
    throwingPoisonOptions[2] = "$iEquip_MCM_rep_opt_TP_Toggle"

    throwingPoisonHands = new String[2]
    throwingPoisonHands[0] = "$iEquip_MCM_pot_opt_left"
    throwingPoisonHands[1] = "$iEquip_MCM_pot_opt_right"

    effectsOptions = new String[4]
    effectsOptions[0] = "$iEquip_MCM_rep_opt_noFX"
    effectsOptions[1] = "$iEquip_MCM_rep_opt_SFXOnly"
    effectsOptions[2] = "$iEquip_MCM_rep_opt_VFXOnly"
    effectsOptions[3] = "$iEquip_MCM_rep_opt_bothFX"

    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, RC.bRechargingEnabled as int)
	
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

	jArray.addInt(jPageObj, WC.iShowPoisonMessages)
	jArray.addInt(jPageObj, WC.bAllowPoisonSwitching as int)
	jArray.addInt(jPageObj, WC.bAllowPoisonTopUp as int)
	
	jArray.addInt(jPageObj, WC.iPoisonChargesPerVial)
	jArray.addInt(jPageObj, WC.iPoisonChargeMultiplier)
	
	jArray.addInt(jPageObj, WC.iPoisonIndicatorStyle)

    jArray.addInt(jPageObj, TP.iThrowingPoisonBehavior)
    jArray.addInt(jPageObj, KH.iThrowingPoisonsKey)
    jArray.addInt(jPageObj, TP.iThrowingPoisonHand)
    jArray.addFlt(jPageObj, TP.fThrowingPoisonEffectsMagMult)
    jArray.addFlt(jPageObj, TP.fPoisonHazardRadius)
    jArray.addFlt(jPageObj, TP.fPoisonHazardDuration)
    jArray.addInt(jPageObj, TP.iNumPoisonHazards)
    jArray.addFlt(jPageObj, TP.fThrowingPoisonProjectileGravity)

    jArray.addInt(jPageObj, RC.iRechargeFX)
    jArray.addInt(jPageObj, WC.iPoisonFX)
	
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	RC.bRechargingEnabled = jArray.getInt(jPageObj, 0)
	
	RC.bUseLargestSoul = jArray.getInt(jPageObj, 1)
	RC.bAllowOversizedSouls = jArray.getInt(jPageObj, 2)
	RC.bUsePartFilledGems = jArray.getInt(jPageObj, 3)
	
	CM.iChargeDisplayType = jArray.getInt(jPageObj, 4)
	CM.bChargeFadeoutEnabled = jArray.getInt(jPageObj, 5)
	CM.fChargeFadeoutDelay = jArray.getFlt(jPageObj, 6)
	CM.iPrimaryFillColor = jArray.getInt(jPageObj, 7)
	CM.bCustomFlashColor = jArray.getInt(jPageObj, 8)
	CM.iFlashColor = jArray.getInt(jPageObj, 9)
	CM.bEnableLowCharge = jArray.getInt(jPageObj, 10)
	CM.fLowChargeThreshold = jArray.getFlt(jPageObj, 11)
	CM.iLowChargeFillColor = jArray.getInt(jPageObj, 12)
	CM.bEnableGradientFill = jArray.getInt(jPageObj, 13)
	CM.iSecondaryFillColor = jArray.getInt(jPageObj, 14)
	meterFillDirection[0] = jArray.getInt(jPageObj, 15)
    CM.asMeterFillDirection[0] = rawMeterFillDirectionOptions[meterFillDirection[0]]
	meterFillDirection[1] = jArray.getInt(jPageObj, 16)
	CM.asMeterFillDirection[1] = rawMeterFillDirectionOptions[meterFillDirection[1]]

    WC.EH.bRealTimeStaffMeters = jArray.getInt(jPageObj, 17)

	WC.iShowPoisonMessages = jArray.getInt(jPageObj, 18)
	WC.bAllowPoisonSwitching = jArray.getInt(jPageObj, 19)
	WC.bAllowPoisonTopUp = jArray.getInt(jPageObj, 20)
	
	WC.iPoisonChargesPerVial = jArray.getInt(jPageObj, 21)
	WC.iPoisonChargeMultiplier = jArray.getInt(jPageObj, 22)
	
	WC.iPoisonIndicatorStyle = jArray.getInt(jPageObj, 23)

    TP.iThrowingPoisonBehavior = jArray.getInt(jPageObj, 24, 1)
    KH.iThrowingPoisonsKey = jArray.getInt(jPageObj, 25, -1)
    TP.iThrowingPoisonHand = jArray.getInt(jPageObj, 26, 1)
    TP.fThrowingPoisonEffectsMagMult = jArray.getFlt(jPageObj, 27, 0.6)
    TP.fPoisonHazardRadius = jArray.getFlt(jPageObj, 28, 6.0)
    TP.fPoisonHazardDuration = jArray.getFlt(jPageObj, 29, 5.0)
    TP.iNumPoisonHazards = jArray.getInt(jPageObj, 30, 5)
    TP.fThrowingPoisonProjectileGravity = jArray.getFlt(jPageObj, 31, 1.2)

    RC.iRechargeFX = jArray.getInt(jPageObj, 32, 3)
    WC.iPoisonFX = jArray.getInt(jPageObj, 33, 3)
endFunction

function drawPage()
	MCM.AddTextOptionST("rep_txt_showEnchRechHelp", "<font color='#a6bffe'>$iEquip_MCM_rep_lbl_showEnchRechHelp</font>", "")
    if RC.bRechargingEnabled
        MCM.AddToggleOptionST("rep_tgl_enblEnchRech", "<font color='#c7ea46'>$iEquip_MCM_rep_lbl_enblEnchRech</font>", RC.bRechargingEnabled)
        MCM.AddMenuOptionST("rep_men_rechargeFX", "$iEquip_MCM_rep_lbl_FX", effectsOptions[RC.iRechargeFX])
        MCM.AddEmptyOption()

        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_rep_lbl_soulgemUseOpts</font>")
        MCM.AddToggleOptionST("rep_tgl_useLargSoul", "$iEquip_MCM_rep_lbl_useLargSoul", RC.bUseLargestSoul)
        MCM.AddToggleOptionST("rep_tgl_useOvrsizSoul", "$iEquip_MCM_rep_lbl_useOvrsizSoul", RC.bAllowOversizedSouls)
        MCM.AddToggleOptionST("rep_tgl_usePartGem", "$iEquip_MCM_rep_lbl_usePartGem", RC.bUsePartFilledGems)
       
        MCM.AddEmptyOption()        
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
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

        MCM.AddEmptyOption()        
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_rep_lbl_StaffCasting</font>")
        MCM.AddToggleOptionST("rep_tgl_realTimeStaffMeters", "$iEquip_MCM_rep_lbl_realTimeStaffMeters", WC.EH.bRealTimeStaffMeters)
	else
        MCM.AddToggleOptionST("rep_tgl_enblEnchRech", "<font color='#ff7417'>$iEquip_MCM_rep_lbl_enblEnchRech</font>", RC.bRechargingEnabled)
	endIf

	MCM.SetCursorPosition(1)

    MCM.AddTextOptionST("rep_txt_showPoisonHelp", "<font color='#a6bffe'>$iEquip_MCM_rep_lbl_showPoisonHelp</font>", "")
    if WC.bPoisonsEnabled
        MCM.AddToggleOptionST("rep_tgl_enblPoisonSlt", "<font color='#c7ea46'>$iEquip_MCM_gen_lbl_enblPoisonSlt</font>", WC.bPoisonsEnabled)
        MCM.AddMenuOptionST("rep_men_poisonFX", "$iEquip_MCM_rep_lbl_FX", effectsOptions[WC.iPoisonFX])
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_rep_lbl_poisonUseOpts</font>")
        MCM.AddMenuOptionST("rep_men_confMsg", "$iEquip_MCM_rep_lbl_confMsg", poisonMessageOptions[WC.iShowPoisonMessages])
        MCM.AddToggleOptionST("rep_tgl_allowPoisonSwitch", "$iEquip_MCM_rep_lbl_allowPoisonSwitch", WC.bAllowPoisonSwitching)
        MCM.AddToggleOptionST("rep_tgl_allowPoisonTopup", "$iEquip_MCM_rep_lbl_allowPoisonTopup", WC.bAllowPoisonTopUp)
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_rep_lbl_poisonChargeOpts</font>")
        MCM.AddSliderOptionST("rep_sld_chargePerVial", "$iEquip_MCM_rep_lbl_chargePerVial", WC.iPoisonChargesPerVial, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_chrgs"))

        if WC.iPoisonChargeMultiplier < 2
            WC.iPoisonChargeMultiplier = 2     ; Should have been 2 by default (Concentrated Poison perk multiplier)
        endIf

        MCM.AddSliderOptionST("rep_sld_chargeMult", "$iEquip_MCM_rep_lbl_chargeMult", WC.iPoisonChargeMultiplier, "{0}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_baseChrgs"))
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
        MCM.AddMenuOptionST("rep_men_poisonIndStyle", "$iEquip_MCM_rep_lbl_poisonIndStyle", poisonIndicatorOptions[WC.iPoisonIndicatorStyle])

        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_rep_lbl_ThrowingPoisonOptions</font>")
        if !WC.bPowerOfThreeExtenderLoaded
            MCM.AddTextOptionST("rep_txt_throwingPoisonsDisabled_a", "$iEquip_MCM_rep_lbl_throwingPoisonsDisabled_a", "")
            MCM.AddTextOptionST("rep_txt_throwingPoisonsDisabled_b", "$iEquip_MCM_rep_lbl_throwingPoisonsDisabled_b", "")
        else
            MCM.AddMenuOptionST("rep_men_throwingPoisonsBehavior", "$iEquip_MCM_rep_lbl_throwingPoisonsBehavior", throwingPoisonOptions[TP.iThrowingPoisonBehavior])
            if TP.iThrowingPoisonBehavior > 0
                MCM.AddKeyMapOptionST("rep_key_throwingPoisonsKey", "$iEquip_MCM_rep_lbl_throwingPoisonsKey", KH.iThrowingPoisonsKey, mcmUnmapFLAG)
                MCM.AddTextOptionST("rep_txt_throwingPoisonsHand", "$iEquip_MCM_rep_lbl_throwingPoisonsHand", throwingPoisonHands[TP.iThrowingPoisonHand])
                MCM.AddSliderOptionST("rep_sld_throwingPoisonMagnitude", "$iEquip_MCM_rep_lbl_throwingPoisonMagnitude", TP.fThrowingPoisonEffectsMagMult, "{1}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_baseMag"))
                MCM.AddSliderOptionST("rep_sld_throwingPoisonRadius", "$iEquip_MCM_rep_lbl_throwingPoisonRadius", TP.fPoisonHazardRadius, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_hzrdRadius"))
                MCM.AddSliderOptionST("rep_sld_throwingPoisonDuration", "$iEquip_MCM_rep_lbl_throwingPoisonDuration", TP.fPoisonHazardDuration, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
                MCM.AddSliderOptionST("rep_sld_throwingPoisonLimit", "$iEquip_MCM_rep_lbl_throwingPoisonLimit", TP.iNumPoisonHazards as float, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_hzrds"))
                MCM.AddSliderOptionST("rep_sld_throwingPoisonGravity", "$iEquip_MCM_rep_lbl_throwingPoisonGravity", TP.fThrowingPoisonProjectileGravity, "{1}")
            endIf
        endIf
    else
        MCM.AddToggleOptionST("rep_tgl_enblPoisonSlt", "<font color='#ff7417'>$iEquip_MCM_gen_lbl_enblPoisonSlt</font>", WC.bPoisonsEnabled)
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

; -------------------
; - VFX/SFX Options -
; -------------------

State rep_men_rechargeFX
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_rechargeFX")
        elseIf currentEvent == "Open"
            MCM.fillMenu(RC.iRechargeFX, effectsOptions, 3)
        elseIf currentEvent == "Accept"
            RC.iRechargeFX = currentVar as int
            MCM.SetMenuOptionValueST(effectsOptions[RC.iRechargeFX])
        endIf 
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
; -    Staff Casting   -
; ----------------------

State rep_tgl_realTimeStaffMeters
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_realTimeStaffMeters")
        elseIf currentEvent == "Select" || ("Default" && !WC.EH.bRealTimeStaffMeters)
            WC.EH.bRealTimeStaffMeters = !WC.EH.bRealTimeStaffMeters
            MCM.SetToggleOptionValueST(WC.EH.bRealTimeStaffMeters)
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

State rep_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblPoisonSlt")
        elseIf currentEvent == "Select" || ("Default" && !WC.bPoisonsEnabled)
            WC.bPoisonsEnabled = !WC.bPoisonsEnabled
            WC.bSlotEnabledOptionsChanged = true
            MCM.ForcePageReset()
        endIf
    endEvent
endState

; -------------------
; - VFX/SFX Options -
; -------------------

State rep_men_poisonFX
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_poisonFX")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iPoisonFX, effectsOptions, 3)
        elseIf currentEvent == "Accept"
            WC.iPoisonFX = currentVar as int
            MCM.SetMenuOptionValueST(effectsOptions[WC.iPoisonFX])
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
            MCM.fillSlider(WC.iPoisonChargeMultiplier, 2.0, 5.0, 1.0, 2.0)
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

; ---------------------------
; - Throwing Poison Options -
; ---------------------------

State rep_men_throwingPoisonsBehavior
    event OnBeginState()
        int prevValue = TP.iThrowingPoisonBehavior
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonsBehavior")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TP.iThrowingPoisonBehavior, throwingPoisonOptions, 1)
        elseIf currentEvent == "Accept"
            TP.iThrowingPoisonBehavior = currentVar as int
            if currentVar as int == 0 && TP.bPoisonEquipped
                WC.bThrowingPoisonsDisabled = true
            endIf
            if prevValue > 0 && currentVar as int > 0
                MCM.SetMenuOptionValueST(throwingPoisonOptions[TP.iThrowingPoisonBehavior])
            else
                MCM.forcePageReset()
            endIf
        endIf 
    endEvent
endState

State rep_key_throwingPoisonsKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonsKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iThrowingPoisonsKey = currentVar as int
            else
                KH.iThrowingPoisonsKey = -1
            endIf
            KH.updateExtKbKeysArray()
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iThrowingPoisonsKey)        
        endIf
    endEvent
endState

State rep_txt_throwingPoisonsHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonsHand")
        elseIf currentEvent == "Select"
            TP.iThrowingPoisonHand = (TP.iThrowingPoisonHand + 1) % 2
            MCM.SetTextOptionValueST(throwingPoisonHands[TP.iThrowingPoisonHand])
        endIf 
    endEvent
endState

State rep_sld_throwingPoisonMagnitude
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonMagnitude")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fThrowingPoisonEffectsMagMult, 0.1, 1.0, 0.1, 0.6)
        elseIf currentEvent == "Accept"
            TP.fThrowingPoisonEffectsMagMult = currentVar
            MCM.SetSliderOptionValueST(TP.fThrowingPoisonEffectsMagMult, "{1}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_baseMag"))
            if TP.bPoisonEquipped
                TP.updatePoisonEffectsOnSpell()
            endIf
        endIf 
    endEvent
endState

State rep_sld_throwingPoisonRadius
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonRadius")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fPoisonHazardRadius, 1.0, 15.0, 1.0, 6.0)
        elseIf currentEvent == "Accept"
            TP.fPoisonHazardRadius = currentVar
            MCM.SetSliderOptionValueST(TP.fPoisonHazardRadius, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_hzrdRadius"))
            TP.updateHazardRadius()
        endIf 
    endEvent
endState

State rep_sld_throwingPoisonDuration
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonDuration")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fPoisonHazardDuration, 1.0, 30.0, 1.0, 5.0)
        elseIf currentEvent == "Accept"
            TP.fPoisonHazardDuration = currentVar
            MCM.SetSliderOptionValueST(TP.fPoisonHazardDuration, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
            TP.updateHazardDuration()
        endIf 
    endEvent
endState

State rep_sld_throwingPoisonLimit
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonLimit")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.iNumPoisonHazards as float, 1.0, 15.0, 1.0, 5.0)
        elseIf currentEvent == "Accept"
            TP.iNumPoisonHazards = currentVar as int
            MCM.SetSliderOptionValueST(TP.iNumPoisonHazards as float, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_rep_lbl_hzrds"))
            TP.updateHazardLimit()
        endIf 
    endEvent
endState

State rep_sld_throwingPoisonGravity
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_rep_txt_throwingPoisonGravity")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fThrowingPoisonProjectileGravity, 0.0, 2.0, 0.1, 1.2)
        elseIf currentEvent == "Accept"
            TP.fThrowingPoisonProjectileGravity = currentVar
            MCM.SetSliderOptionValueST(TP.fThrowingPoisonProjectileGravity, "{1}")
            TP.updateProjectileGravity()
        endIf 
    endEvent
endState
