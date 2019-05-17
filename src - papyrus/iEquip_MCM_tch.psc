Scriptname iEquip_MCM_tch extends iEquip_MCM_Page

iEquip_TorchScript property TO auto
iEquip_KeyHandler Property KH Auto

string[] dropLitTorchBehaviour
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int iTorchMeterFillDirection
string[] modStates

int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()                  ; Initialize page specific data

	meterFillDirectionOptions = new string[3]
    meterFillDirectionOptions[0] = "$iEquip_MCM_rep_opt_left"
    meterFillDirectionOptions[1] = "$iEquip_MCM_rep_opt_right"
    meterFillDirectionOptions[2] = "$iEquip_MCM_rep_opt_both"

    rawMeterFillDirectionOptions = new string[3] ;DO NOT TRANSLATE!
    rawMeterFillDirectionOptions[0] = "left"
    rawMeterFillDirectionOptions[1] = "right"
    rawMeterFillDirectionOptions[2] = "both"

    dropLitTorchBehaviour = new string[5]
    dropLitTorchBehaviour[0] = "$iEquip_MCM_gen_opt_DoNothing"
    dropLitTorchBehaviour[1] = "$iEquip_MCM_tch_opt_TorchNothing"
    dropLitTorchBehaviour[2] = "$iEquip_MCM_tch_opt_TorchCycle"
    dropLitTorchBehaviour[3] = "$iEquip_MCM_tch_opt_CycleLeft"
    dropLitTorchBehaviour[4] = "$iEquip_MCM_htk_lbl_quickShield"

    modStates = new string[2]
    modStates[0] = "$iEquip_MCM_common_notDetected"
    modStates[1] = "$iEquip_MCM_common_installed"

    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()

    jArray.addInt(jPageObj, TO.bShowTorchMeter as int)
    jArray.addInt(jPageObj, TO.iTorchMeterFillColor)
    jArray.addInt(jPageObj, iTorchMeterFillDirection)
    jArray.addFlt(jPageObj, TO.fTorchDuration)
    jArray.addInt(jPageObj, TO.bFiniteTorchLife as int)
    jArray.addInt(jPageObj, TO.bReduceLightAsTorchRunsOut as int)
    jArray.addInt(jPageObj, TO.bAutoReEquipTorch as int)
    jArray.addInt(jPageObj, TO.bRealisticReEquip as int)
    jArray.addFlt(jPageObj, TO.fRealisticReEquipDelay)
    jArray.addInt(jPageObj, KH.iToggleTorchKey)
    jArray.addInt(jPageObj, TO.bDropLitTorchesEnabled as int)
    jArray.addInt(jPageObj, TO.iDropLitTorchBehavior)

    return jPageObj    
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj

	TO.bShowTorchMeter = jArray.getInt(jPageObj, 0)
    TO.iTorchMeterFillColor = jArray.getInt(jPageObj, 1)
    TO.iTorchMeterFillColorDark = multiplyRGB(TO.iTorchMeterFillColor, 0.4)
    iTorchMeterFillDirection = jArray.getInt(jPageObj, 2)
    TO.sTorchMeterFillDirection = rawMeterFillDirectionOptions[iTorchMeterFillDirection]
    TO.fTorchDuration = jArray.getInt(jPageObj, 3)
    TO.bFiniteTorchLife = jArray.getInt(jPageObj, 4)
    TO.bReduceLightAsTorchRunsOut = jArray.getInt(jPageObj, 5)
    TO.bAutoReEquipTorch = jArray.getInt(jPageObj, 6)
    TO.bRealisticReEquip = jArray.getInt(jPageObj, 7)
    TO.fRealisticReEquipDelay = jArray.getFlt(jPageObj, 9)
    KH.iToggleTorchKey = jArray.getInt(jPageObj, 9)
    TO.bDropLitTorchesEnabled = jArray.getInt(jPageObj, 10)
    TO.iDropLitTorchBehavior = jArray.getInt(jPageObj, 11)

endFunction

function drawPage()
	if WC.isEnabled

		MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
		MCM.AddToggleOptionST("tch_tgl_showTorchMeter", "$iEquip_MCM_tch_lbl_showTorchMeter", TO.bShowTorchMeter)
		if TO.bShowTorchMeter
			MCM.AddColorOptionST("tch_col_torchMeterCol", "$iEquip_MCM_tch_lbl_torchMeterCol", TO.iTorchMeterFillColor)
			MCM.AddMenuOptionST("tch_men_torchMeterFillDir", "$iEquip_MCM_tch_lbl_torchMeterFillDir", meterFillDirectionOptions[iTorchMeterFillDirection])
		endIf

		MCM.AddEmptyOption()

		MCM.AddHeaderOption("$iEquip_MCM_tch_lbl_torchLifeOptions")
		MCM.AddSliderOptionST("tch_sld_torchDuration", "$iEquip_MCM_tch_lbl_torchDuration", (TO.fTorchDuration + 5.0) / 60, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_minutes"))
		MCM.AddToggleOptionST("tch_tgl_finiteTorchLife", "$iEquip_MCM_tch_lbl_finiteTorchLife", TO.bFiniteTorchLife)
		if TO.bFiniteTorchLife
			MCM.AddToggleOptionST("tch_tgl_torchesFade", "$iEquip_MCM_tch_lbl_torchesFade", TO.bReduceLightAsTorchRunsOut)
		endIf

		MCM.AddToggleOptionST("tch_tgl_reequipTorch", "$iEquip_MCM_tch_lbl_reequipTorch", TO.bAutoReEquipTorch)
		if TO.bAutoReEquipTorch
			MCM.AddToggleOptionST("tch_tgl_realisticEquip", "$iEquip_MCM_tch_lbl_realisticEquip", TO.bRealisticReEquip)
			if TO.bRealisticReEquip
				MCM.AddSliderOptionST("tch_sld_realisticEquipDelay", "$iEquip_MCM_tch_lbl_realisticEquipDelay", TO.fRealisticReEquipDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
			endIf
		endIf

		MCM.SetCursorPosition(1)

		MCM.AddHeaderOption("$iEquip_MCM_tch_lbl_torchKeyOptions")
		MCM.AddKeyMapOptionST("tch_key_toggleTorch", "$iEquip_MCM_tch_lbl_toggleTorch", KH.iToggleTorchKey, mcmUnmapFLAG)
        MCM.AddToggleOptionST("tch_tgl_toggleTorchEquipRH", "$iEquip_MCM_tch_lbl_toggleTorchEquipRH", TO.bToggleTorchEquipRH)

		MCM.AddEmptyOption()
		
		MCM.AddHeaderOption("$iEquip_MCM_tch_lbl_torchDropOptions")
		MCM.AddToggleOptionST("tch_tgl_dropLitTorches", "$iEquip_MCM_tch_lbl_dropLitTorches", TO.bDropLitTorchesEnabled)
		if TO.bDropLitTorchesEnabled
			MCM.AddMenuOptionST("tch_men_dropLitTorchBehavior", "$iEquip_MCM_tch_lbl_dropLitTorchBehavior", dropLitTorchBehaviour[TO.iDropLitTorchBehavior])
		endIf

		MCM.AddEmptyOption()

		MCM.AddHeaderOption("$iEquip_MCM_lbl_Info")
		MCM.AddTextOptionST("tch_txt_realisticTorches", "$iEquip_MCM_tch_lbl_realisticTorches", modStates[(Game.GetModByName("RealisticTorches.esp") != 255) as int])
	endIf
endFunction

; -----------------
; - Torch Options -
; -----------------

State tch_tgl_showTorchMeter
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_showTorchMeter")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bShowTorchMeter)
            TO.bShowTorchMeter = !TO.bShowTorchMeter
            MCM.forcePageReset()
        endIf
    endEvent
endState

State tch_col_torchMeterCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_torchMeterCol")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(TO.iTorchMeterFillColor)
            MCM.SetColorDialogDefaultColor(0xFFF8AC)
        else
            If currentEvent == "Accept"
                TO.iTorchMeterFillColor = currentVar as int
            elseIf currentEvent == "Default"
                TO.iTorchMeterFillColor = 0xFFF8AC
            endIf
            TO.iTorchMeterFillColorDark = multiplyRGB(TO.iTorchMeterFillColor, 0.4)
            MCM.SetColorOptionValueST(TO.iTorchMeterFillColor)
            TO.bSettingsChanged = true
        endIf 
    endEvent
endState

State tch_men_torchMeterFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_torchMeterFillDir")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iTorchMeterFillDirection, meterFillDirectionOptions, 0)
        elseIf currentEvent == "Accept"
            iTorchMeterFillDirection = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[iTorchMeterFillDirection])
            TO.sTorchMeterFillDirection = rawMeterFillDirectionOptions[iTorchMeterFillDirection]
            TO.bSettingsChanged = true
        endIf 
    endEvent
endState

State tch_sld_torchDuration
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_setTorchDuration")
        elseIf currentEvent == "Open"
            MCM.fillSlider((TO.fTorchDuration + 5.0) / 60.0, 1.0, TO.fMaxTorchDuration / 60.0, 0.5, TO.fMaxTorchDuration / 60.0)
        elseIf currentEvent == "Accept"
            TO.fTorchDuration = currentVar * 60.0 - 5.0
            MCM.SetSliderOptionValueST((TO.fTorchDuration + 5.0) / 60.0, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_minutes"))
            TO.bTorchDurationSettingChanged = true
        endIf
    endEvent
endState

State tch_tgl_reequipTorch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_reequipTorch")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bAutoReEquipTorch)
            TO.bAutoReEquipTorch = !TO.bAutoReEquipTorch
            MCM.forcePageReset()
        endIf
    endEvent
endState

State tch_tgl_realisticEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_realisticEquip")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bRealisticReEquip)
            TO.bRealisticReEquip = !TO.bRealisticReEquip
            MCM.forcePageReset()
        endIf
    endEvent
endState

State tch_sld_realisticEquipDelay
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillSlider(TO.fRealisticReEquipDelay, 0.5, 5.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            TO.fRealisticReEquipDelay = currentVar
            MCM.SetSliderOptionValueST(TO.fRealisticReEquipDelay, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State tch_tgl_finiteTorchLife
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_finiteTorchLife")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bFiniteTorchLife)
            TO.bFiniteTorchLife = !TO.bFiniteTorchLife
            MCM.forcePageReset()
        endIf
    endEvent
endState

State tch_tgl_torchesFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_torchesFade")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bReduceLightAsTorchRunsOut)
            TO.bReduceLightAsTorchRunsOut = !TO.bReduceLightAsTorchRunsOut
            MCM.SetToggleOptionValueST(TO.bReduceLightAsTorchRunsOut)
        endIf
    endEvent
endState

State tch_key_toggleTorch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_toggleTorchHotKey")
        elseIf currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iToggleTorchKey = currentVar as int
            else
                KH.iToggleTorchKey = -1
            endIf
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iToggleTorchKey)        
        endIf
    endEvent
endState

State tch_tgl_toggleTorchEquipRH
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_toggleTorchEquipRH")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !TO.bToggleTorchEquipRH)
            TO.bToggleTorchEquipRH = !TO.bToggleTorchEquipRH
            MCM.SetToggleOptionValueST(TO.bToggleTorchEquipRH)
        endIf
    endEvent
endState

State tch_tgl_dropLitTorches
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_dropLitTorches")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && TO.bDropLitTorchesEnabled)
            TO.bDropLitTorchesEnabled = !TO.bDropLitTorchesEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State tch_men_dropLitTorchBehavior
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_tch_txt_dropLitTorchBehavior")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TO.iDropLitTorchBehavior, dropLitTorchBehaviour, 0)
        elseIf currentEvent == "Accept"
            TO.iDropLitTorchBehavior = currentVar as int
            MCM.SetMenuOptionValueST(dropLitTorchBehaviour[TO.iDropLitTorchBehavior])
        endIf
    endEvent
endState

State tch_txt_realisticTorches
    event OnBeginState()
        if currentEvent == "Highlight"
        	if Game.GetModByName("RealisticTorches.esp") != 255
            	MCM.SetInfoText("$iEquip_MCM_tch_txt_realisticTorches")
            else
            	MCM.SetInfoText("$iEquip_MCM_tch_txt_noRealisticTorches")
            endIf
        endIf
    endEvent
endState

int function multiplyRGB(Int a_color, Float a_multiplier)
    Int red = Math.LogicalAND(a_color, 0xFF0000)
    Int green = Math.LogicalAND(a_color, 0x00FF00)
    Int blue = Math.LogicalAND(a_color, 0x0000FF)

    red = (red as float * a_multiplier) as int
    green = (green as float * a_multiplier) as int
    blue = (blue as float * a_multiplier) as int

    If (red > 0xFF0000)
        red = 0xFF0000
    EndIf
    If (green > 0x00FF00)
        green = 0x0FF000
    EndIf
    If (blue > 0x0000FF)
        blue = 0x0000FF
    EndIf
   
    Int result = Math.LogicalAND(red, 0xFF0000)
    result += Math.LogicalAND(green, 0x00FF00)
    result += Math.LogicalAND(blue, 0x0000FF)
    return result
endFunction
