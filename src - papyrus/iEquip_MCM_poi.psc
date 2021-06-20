Scriptname iEquip_MCM_poi extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ThrowingPoisons Property TP Auto
iEquip_KeyHandler Property KH Auto

string[] poisonMessageOptions
string[] poisonIndicatorOptions
string[] throwingPoisonOptions
string[] throwingPoisonHands
string[] effectsOptions

int mcmUnmapFLAG
int mcmDisabledFLAG

; #############
; ### SETUP ###

function initData()

    poisonMessageOptions = new String[3]
    poisonMessageOptions[0] = "$iEquip_MCM_poi_opt_ShowAll"
    poisonMessageOptions[1] = "$iEquip_MCM_poi_opt_TopUpSw"
    poisonMessageOptions[2] = "$iEquip_MCM_poi_opt_DntShow"
    
    poisonIndicatorOptions = new String[4]
    poisonIndicatorOptions[0] = "$iEquip_MCM_poi_opt_Count"
    poisonIndicatorOptions[1] = "$iEquip_MCM_poi_opt_DropCount"
    poisonIndicatorOptions[2] = "$iEquip_MCM_poi_opt_Drop"
    poisonIndicatorOptions[3] = "$iEquip_MCM_poi_opt_Drops"

    throwingPoisonOptions = new String[2]
    throwingPoisonOptions[0] = "$iEquip_MCM_poi_opt_TP_ThrowSwitchBack"
    throwingPoisonOptions[1] = "$iEquip_MCM_poi_opt_TP_Toggle"

    throwingPoisonHands = new String[2]
    throwingPoisonHands[0] = "$iEquip_MCM_pot_opt_left"
    throwingPoisonHands[1] = "$iEquip_MCM_pot_opt_right"

    effectsOptions = new String[4]
    effectsOptions[0] = "$iEquip_MCM_common_opt_noFX"
    effectsOptions[1] = "$iEquip_MCM_common_opt_SFXOnly"
    effectsOptions[2] = "$iEquip_MCM_common_opt_VFXOnly"
    effectsOptions[3] = "$iEquip_MCM_common_opt_bothFX"

    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
    mcmDisabledFLAG = MCM.OPTION_FLAG_DISABLED
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()

    jArray.addInt(jPageObj, WC.iPoisonFX)

    jArray.addInt(jPageObj, WC.iShowPoisonMessages)
	jArray.addInt(jPageObj, WC.bAllowPoisonSwitching as int)
	jArray.addInt(jPageObj, WC.bAllowPoisonTopUp as int)
	
	jArray.addInt(jPageObj, WC.iPoisonChargesPerVial)
	jArray.addInt(jPageObj, WC.iPoisonChargeMultiplier)
	
	jArray.addInt(jPageObj, WC.iPoisonIndicatorStyle)

    jArray.addInt(jPageObj, TP.bThrowingPoisonsEnabled as int)
    jArray.addInt(jPageObj, TP.iThrowingPoisonBehavior)
    jArray.addInt(jPageObj, KH.iThrowingPoisonsKey)
    jArray.addInt(jPageObj, TP.iThrowingPoisonHand)
    jArray.addFlt(jPageObj, TP.fThrowingPoisonEffectsMagMult)
    jArray.addFlt(jPageObj, TP.fPoisonHazardRadius)
    jArray.addFlt(jPageObj, TP.fPoisonHazardDuration)
    jArray.addInt(jPageObj, TP.iNumPoisonHazards)
    jArray.addFlt(jPageObj, TP.fThrowingPoisonProjectileGravity)
	
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	
	WC.iPoisonFX = jArray.getInt(jPageObj, 0, 3)

    WC.iShowPoisonMessages = jArray.getInt(jPageObj, 1)
	WC.bAllowPoisonSwitching = jArray.getInt(jPageObj, 2)
	WC.bAllowPoisonTopUp = jArray.getInt(jPageObj, 3)
	
	WC.iPoisonChargesPerVial = jArray.getInt(jPageObj, 4)
	WC.iPoisonChargeMultiplier = jArray.getInt(jPageObj, 5)
	
	WC.iPoisonIndicatorStyle = jArray.getInt(jPageObj, 6)

    TP.bThrowingPoisonsEnabled = jArray.getInt(jPageObj, 7, 0)
    TP.iThrowingPoisonBehavior = jArray.getInt(jPageObj, 8, 1)
    KH.iThrowingPoisonsKey = jArray.getInt(jPageObj, 9, -1)
    TP.iThrowingPoisonHand = jArray.getInt(jPageObj, 10, 1)
    TP.fThrowingPoisonEffectsMagMult = jArray.getFlt(jPageObj, 11, 0.6)
    TP.fPoisonHazardRadius = jArray.getFlt(jPageObj, 12, 6.0)
    TP.fPoisonHazardDuration = jArray.getFlt(jPageObj, 13, 5.0)
    TP.iNumPoisonHazards = jArray.getInt(jPageObj, 14, 5)
    TP.fThrowingPoisonProjectileGravity = jArray.getFlt(jPageObj, 15, 1.2)

endFunction

function drawPage()

    MCM.AddTextOptionST("poi_txt_showPoisonHelp", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_poi_lbl_showPoisonHelp</font>", "")
    if WC.bPoisonsEnabled
        MCM.AddToggleOptionST("poi_tgl_enblPoisonSlt", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_gen_lbl_enblPoisonSlt</font>", WC.bPoisonsEnabled)
        MCM.AddMenuOptionST("poi_men_poisonFX", "$iEquip_MCM_common_lbl_FX", effectsOptions[WC.iPoisonFX])
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_poi_lbl_poisonUseOpts</font>")
        MCM.AddMenuOptionST("poi_men_confMsg", "$iEquip_MCM_poi_lbl_confMsg", poisonMessageOptions[WC.iShowPoisonMessages])
        MCM.AddToggleOptionST("poi_tgl_allowPoisonSwitch", "$iEquip_MCM_poi_lbl_allowPoisonSwitch", WC.bAllowPoisonSwitching)
        MCM.AddToggleOptionST("poi_tgl_allowPoisonTopup", "$iEquip_MCM_poi_lbl_allowPoisonTopup", WC.bAllowPoisonTopUp)
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_poi_lbl_poisonChargeOpts</font>")
        MCM.AddSliderOptionST("poi_sld_chargePerVial", "$iEquip_MCM_poi_lbl_chargePerVial", WC.iPoisonChargesPerVial, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_chrgs"))

        if WC.iPoisonChargeMultiplier < 2
            WC.iPoisonChargeMultiplier = 2     ; Should have been 2 by default (Concentrated Poison perk multiplier)
        endIf

        MCM.AddSliderOptionST("poi_sld_chargeMult", "$iEquip_MCM_poi_lbl_chargeMult", WC.iPoisonChargeMultiplier, "{0}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_baseChrgs"))
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_common_lbl_WidgetOptions</font>")
        MCM.AddMenuOptionST("poi_men_poisonIndStyle", "$iEquip_MCM_poi_lbl_poisonIndStyle", poisonIndicatorOptions[WC.iPoisonIndicatorStyle])

        MCM.SetCursorPosition(1)
        MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_pot_lbl_throwingPoisonsOpts</font>")
        MCM.AddTextOptionST("poi_txt_showThrowingPoisonHelp", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_poi_lbl_showThrowingPoisonHelp</font>", "")
        if !WC.bPowerOfThreeExtenderLoaded
            MCM.AddToggleOptionST("poi_tgl_enableThrowingPoisons", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_poi_lbl_enableThrowingPoisons</font>", TP.bThrowingPoisonsEnabled, mcmDisabledFLAG)
            MCM.AddEmptyOption()
            MCM.AddTextOptionST("poi_txt_throwingPoisonsDisabled_a", "$iEquip_MCM_poi_lbl_throwingPoisonsDisabled_a", "")
            MCM.AddTextOptionST("poi_txt_throwingPoisonsDisabled_b", "$iEquip_MCM_poi_lbl_throwingPoisonsDisabled_b", "")
        else
            if TP.bThrowingPoisonsEnabled
                MCM.AddToggleOptionST("poi_tgl_enableThrowingPoisons", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_poi_lbl_enableThrowingPoisons</font>", TP.bThrowingPoisonsEnabled)
                MCM.AddTextOptionST("poi_txt_throwingPoisonsBehavior", "$iEquip_MCM_poi_lbl_throwingPoisonsBehavior", throwingPoisonOptions[TP.iThrowingPoisonBehavior])
                MCM.AddKeyMapOptionST("poi_key_throwingPoisonsKey", "$iEquip_MCM_poi_lbl_throwingPoisonsKey", KH.iThrowingPoisonsKey, mcmUnmapFLAG)
                MCM.AddTextOptionST("poi_txt_throwingPoisonsHand", "$iEquip_MCM_poi_lbl_throwingPoisonsHand", throwingPoisonHands[TP.iThrowingPoisonHand])
                MCM.AddSliderOptionST("poi_sld_throwingPoisonMagnitude", "$iEquip_MCM_poi_lbl_throwingPoisonMagnitude", TP.fThrowingPoisonEffectsMagMult, "{1}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_baseMag"))
                MCM.AddSliderOptionST("poi_sld_throwingPoisonRadius", "$iEquip_MCM_poi_lbl_throwingPoisonRadius", TP.fPoisonHazardRadius, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_hzrdRadius"))
                MCM.AddSliderOptionST("poi_sld_throwingPoisonDuration", "$iEquip_MCM_poi_lbl_throwingPoisonDuration", TP.fPoisonHazardDuration, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
                MCM.AddSliderOptionST("poi_sld_throwingPoisonLimit", "$iEquip_MCM_poi_lbl_throwingPoisonLimit", TP.iNumPoisonHazards as float, "{0} " +  iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_hzrds"))
                MCM.AddSliderOptionST("poi_sld_throwingPoisonGravity", "$iEquip_MCM_poi_lbl_throwingPoisonGravity", TP.fThrowingPoisonProjectileGravity, "{1}")
            else
                MCM.AddToggleOptionST("poi_tgl_enableThrowingPoisons", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_poi_lbl_enableThrowingPoisons</font>", TP.bThrowingPoisonsEnabled)
            endIf
        endIf
    else
        MCM.AddToggleOptionST("poi_tgl_enblPoisonSlt", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_gen_lbl_enblPoisonSlt</font>", WC.bPoisonsEnabled)
    endIf
endFunction


; ----------------------
; -    Poison Help     -
; ----------------------

State poi_txt_showPoisonHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_poisoning1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                MCM.ShowMessage("$iEquip_help_poisoning2", false, "$iEquip_common_msg_Exit")
            endIf
        endIf 
    endEvent
endState

State poi_tgl_enblPoisonSlt
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

State poi_men_poisonFX
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_poisonFX")
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

State poi_men_confMsg
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_confMsg")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iShowPoisonMessages, poisonMessageOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iShowPoisonMessages = currentVar as int
            MCM.SetMenuOptionValueST(poisonMessageOptions[WC.iShowPoisonMessages])
        endIf 
    endEvent
endState

State poi_tgl_allowPoisonSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_allowPoisonSwitch")
        elseIf currentEvent == "Select"
            WC.bAllowPoisonSwitching = !WC.bAllowPoisonSwitching
            MCM.SetToggleOptionValueST(WC.bAllowPoisonSwitching)
        elseIf currentEvent == "Default"
            WC.bAllowPoisonSwitching = true
            MCM.SetToggleOptionValueST(WC.bAllowPoisonSwitching)
        endIf 
    endEvent
endState

State poi_tgl_allowPoisonTopup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_allowPoisonTopup")
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

State poi_sld_chargePerVial
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_chargePerVial")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargesPerVial, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargesPerVial = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargesPerVial, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_chrgs"))
        endIf 
    endEvent
endState

State poi_sld_chargeMult
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_chargeMult")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargeMultiplier, 2.0, 5.0, 1.0, 2.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargeMultiplier = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargeMultiplier, "{0}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_baseChrgs"))
        endIf 
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State poi_men_poisonIndStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_poisonIndStyle")
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

State poi_txt_showThrowingPoisonHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_throwingPoisons1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_throwingPoisons2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    MCM.ShowMessage("$iEquip_help_throwingPoisons3", false, "$iEquip_common_msg_Exit")
                endIf
            endIf
        endIf 
    endEvent
endState

State poi_tgl_enableThrowingPoisons
    event OnBeginState()
        if currentEvent == "Select" || (currentEvent == "Default" && TP.bThrowingPoisonsEnabled)
            TP.bThrowingPoisonsEnabled = !TP.bThrowingPoisonsEnabled
            if !TP.bThrowingPoisonsEnabled && TP.bPoisonEquipped
                WC.bThrowingPoisonsDisabled = true
            else
                TP.enableThrowingPoisons()
            endIf
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State poi_txt_throwingPoisonsBehavior
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonsBehavior")
        elseIf currentEvent == "Select"
            TP.iThrowingPoisonBehavior = (TP.iThrowingPoisonBehavior + 1) % 2
            MCM.SetTextOptionValueST(throwingPoisonOptions[TP.iThrowingPoisonBehavior])
        endIf 
    endEvent
endState

State poi_key_throwingPoisonsKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonsKey")
        elseIf currentEvent == "Change" || currentEvent == "Default"
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

State poi_txt_throwingPoisonsHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonsHand")
        elseIf currentEvent == "Select"
            TP.iThrowingPoisonHand = (TP.iThrowingPoisonHand + 1) % 2
            MCM.SetTextOptionValueST(throwingPoisonHands[TP.iThrowingPoisonHand])
            WC.bThrowingPoisonsHandChanged = true
        endIf 
    endEvent
endState

State poi_sld_throwingPoisonMagnitude
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonMagnitude")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fThrowingPoisonEffectsMagMult, 0.1, 1.0, 0.1, 0.6)
        elseIf currentEvent == "Accept"
            TP.fThrowingPoisonEffectsMagMult = currentVar
            MCM.SetSliderOptionValueST(TP.fThrowingPoisonEffectsMagMult, "{1}x " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_baseMag"))
            if TP.bPoisonEquipped
                TP.updatePoisonEffectsOnSpell()
            endIf
        endIf 
    endEvent
endState

State poi_sld_throwingPoisonRadius
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonRadius")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fPoisonHazardRadius, 1.0, 15.0, 1.0, 6.0)
        elseIf currentEvent == "Accept"
            TP.fPoisonHazardRadius = currentVar
            MCM.SetSliderOptionValueST(TP.fPoisonHazardRadius, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_hzrdRadius"))
            TP.updateHazardRadius()
        endIf 
    endEvent
endState

State poi_sld_throwingPoisonDuration
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonDuration")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fPoisonHazardDuration, 1.0, 30.0, 1.0, 5.0)
        elseIf currentEvent == "Accept"
            TP.fPoisonHazardDuration = currentVar
            MCM.SetSliderOptionValueST(TP.fPoisonHazardDuration, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
            TP.updateHazardDuration()
        endIf 
    endEvent
endState

State poi_sld_throwingPoisonLimit
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonLimit")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.iNumPoisonHazards as float, 1.0, 15.0, 1.0, 5.0)
        elseIf currentEvent == "Accept"
            TP.iNumPoisonHazards = currentVar as int
            MCM.SetSliderOptionValueST(TP.iNumPoisonHazards as float, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_poi_lbl_hzrds"))
            TP.updateHazardLimit()
        endIf 
    endEvent
endState

State poi_sld_throwingPoisonGravity
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_poi_txt_throwingPoisonGravity")
        elseIf currentEvent == "Open"
            MCM.fillSlider(TP.fThrowingPoisonProjectileGravity, 0.0, 2.0, 0.1, 1.2)
        elseIf currentEvent == "Accept"
            TP.fThrowingPoisonProjectileGravity = currentVar
            MCM.SetSliderOptionValueST(TP.fThrowingPoisonProjectileGravity, "{1}")
            TP.updateProjectileGravity()
        endIf 
    endEvent
endState
