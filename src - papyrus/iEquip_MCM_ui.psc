Scriptname iEquip_MCM_ui extends iEquip_MCM_Page

iEquip_AmmoMode Property AM Auto
iEquip_TemperedItemHandler Property TI Auto

string[] ammoIconOptions
string[] backgroundStyleOptions
string[] fadeoutOptions
string[] firstPressIfNameHiddenOptions
string[] temperLevelTextOptions

int[] aiDropShadowBlurValues

int iCurrentWidgetFadeoutChoice = 1
int iCurrentNameFadeoutChoice = 1
int iAmmoIconStyle

; #############
; ### SETUP ###

function initData()
    ammoIconOptions = new String[3]
    ammoIconOptions[0] = "$iEquip_MCM_ui_opt_Single"
    ammoIconOptions[1] = "$iEquip_MCM_ui_opt_Triple"
    ammoIconOptions[2] = "$iEquip_MCM_ui_opt_Quiver"
    
    backgroundStyleOptions = new String[7]
    backgroundStyleOptions[0] = "$iEquip_MCM_ui_opt_NoBg"
    backgroundStyleOptions[1] = "$iEquip_MCM_ui_opt_SqBBg"
    backgroundStyleOptions[2] = "$iEquip_MCM_ui_opt_SqNoBBg"
    backgroundStyleOptions[3] = "$iEquip_MCM_ui_opt_RoBBg"
    backgroundStyleOptions[4] = "$iEquip_MCM_ui_opt_RoNoBBg"
    backgroundStyleOptions[5] = "$iEquip_MCM_ui_opt_RoFade"
    backgroundStyleOptions[6] = "$iEquip_MCM_ui_opt_Dialogue"
    
    fadeoutOptions = new String[4]
    fadeoutOptions[0] = "$iEquip_MCM_ui_opt_Slow"
    fadeoutOptions[1] = "$iEquip_MCM_ui_opt_Normal"
    fadeoutOptions[2] = "$iEquip_MCM_ui_opt_Fast"
    fadeoutOptions[3] = "$iEquip_common_Custom"
    
    firstPressIfNameHiddenOptions = new String[2]
    firstPressIfNameHiddenOptions[0] = "$iEquip_MCM_ui_opt_CycleSlot"
    firstPressIfNameHiddenOptions[1] = "$iEquip_MCM_ui_opt_ShowName"

    aiDropShadowBlurValues = new int[6]
    aiDropShadowBlurValues[0] = 0
    aiDropShadowBlurValues[1] = 2
    aiDropShadowBlurValues[2] = 4
    aiDropShadowBlurValues[3] = 8
    aiDropShadowBlurValues[4] = 16
    aiDropShadowBlurValues[5] = 32

    temperLevelTextOptions = new string[13]
    temperLevelTextOptions[0] = "$iEquip_MCM_ui_opt_tmpLvlTxt0"
    temperLevelTextOptions[1] = "$iEquip_MCM_ui_opt_tmpLvlTxt1"
    temperLevelTextOptions[2] = "$iEquip_MCM_ui_opt_tmpLvlTxt2"
    temperLevelTextOptions[3] = "$iEquip_MCM_ui_opt_tmpLvlTxt3"
    temperLevelTextOptions[4] = "$iEquip_MCM_ui_opt_tmpLvlTxt4"
    temperLevelTextOptions[5] = "$iEquip_MCM_ui_opt_tmpLvlTxt5"
    temperLevelTextOptions[6] = "$iEquip_MCM_ui_opt_tmpLvlTxt6"
    temperLevelTextOptions[7] = "$iEquip_MCM_ui_opt_tmpLvlTxt7"
    temperLevelTextOptions[8] = "$iEquip_MCM_ui_opt_tmpLvlTxt8"
    temperLevelTextOptions[9] = "$iEquip_MCM_ui_opt_tmpLvlTxt9"
    temperLevelTextOptions[10] = "$iEquip_MCM_ui_opt_tmpLvlTxt10"
    temperLevelTextOptions[11] = "$iEquip_MCM_ui_opt_tmpLvlTxt11"
    temperLevelTextOptions[12] = "$iEquip_MCM_ui_opt_tmpLvlTxt12"

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.iPositionIndicatorColor)
	jArray.addFlt(jPageObj, WC.fPositionIndicatorAlpha)
	jArray.addInt(jPageObj, WC.iCurrPositionIndicatorColor)
	jArray.addInt(jPageObj, WC.fCurrPositionIndicatorAlpha)
	
	jArray.addInt(jPageObj, WC.bFadeLeftIconWhen2HEquipped)
	jArray.addFlt(jPageObj, WC.fLeftIconFadeAmount)
	jArray.addInt(jPageObj, TI.bFadeIconOnDegrade)
	jArray.addInt(jPageObj, TI.iTemperNameFormat)
	jArray.addInt(jPageObj, iAmmoIconStyle)
	jArray.addInt(jPageObj, WC.iBackgroundStyle) ; Save in preset also
	
	jArray.addInt(jPageObj, WC.bDropShadowEnabled)
	jArray.addFlt(jPageObj, WC.fDropShadowAlpha)
	jArray.addFlt(jPageObj, WC.fDropShadowAngle)
	jArray.addInt(jPageObj, WC.iDropShadowBlur)
	jArray.addFlt(jPageObj, WC.fDropShadowDistance)
	jArray.addFlt(jPageObj, WC.fDropShadowStrength)
	
	jArray.addInt(jPageObj, WC.bWidgetFadeoutEnabled)
	jArray.addFlt(jPageObj, WC.fWidgetFadeoutDelay)
	jArray.addInt(jPageObj, iCurrentWidgetFadeoutChoice)
	jArray.addFlt(jPageObj, WC.fWidgetFadeoutDuration)
	jArray.addInt(jPageObj, WC.bAlwaysVisibleWhenWeaponsDrawn)
	
	jArray.addInt(jPageObj, WC.bNameFadeoutEnabled)
	jArray.addFlt(jPageObj, WC.fMainNameFadeoutDelay)
	jArray.addFlt(jPageObj, WC.fPoisonNameFadeoutDelay)
	jArray.addFlt(jPageObj, WC.fPreselectNameFadeoutDelay)
	jArray.addInt(jPageObj, iCurrentNameFadeoutChoice)
	jArray.addFlt(jPageObj, WC.fNameFadeoutDuration)
	jArray.addInt(jPageObj, WC.bFirstPressShowsName)
    
	return jPageObj
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj
	WC.iPositionIndicatorColor = jArray.getInt(jPageObj, 0)
	WC.fPositionIndicatorAlpha = jArray.getFlt(jPageObj, 1)
	WC.iCurrPositionIndicatorColor = jArray.getInt(jPageObj, 2)
	WC.fCurrPositionIndicatorAlpha = jArray.getFlt(jPageObj, 3)
	
	WC.bFadeLeftIconWhen2HEquipped = jArray.getInt(jPageObj, 4)
	WC.fLeftIconFadeAmount = jArray.getFlt(jPageObj, 5)
	TI.bFadeIconOnDegrade = jArray.getInt(jPageObj, 6)
	TI.iTemperNameFormat = jArray.getInt(jPageObj, 7)
	iAmmoIconStyle = jArray.getInt(jPageObj, 8)
	WC.iBackgroundStyle = jArray.getInt(jPageObj, 9)
	
	WC.bDropShadowEnabled = jArray.getInt(jPageObj, 10)
	WC.fDropShadowAlpha = jArray.getFlt(jPageObj, 11)
	WC.fDropShadowAngle = jArray.getFlt(jPageObj, 12)
	WC.iDropShadowBlur = jArray.getInt(jPageObj, 13)
	WC.fDropShadowDistance = jArray.getFlt(jPageObj, 14)
	WC.fDropShadowStrength = jArray.getFlt(jPageObj, 15)
	
	WC.bWidgetFadeoutEnabled = jArray.getInt(jPageObj, 16)
	WC.fWidgetFadeoutDelay = jArray.getFlt(jPageObj, 17)
	iCurrentWidgetFadeoutChoice = jArray.getInt(jPageObj, 18)
	WC.fWidgetFadeoutDuration = jArray.getFlt(jPageObj, 19)
	WC.bAlwaysVisibleWhenWeaponsDrawn = jArray.getInt(jPageObj, 20)
	
	WC.bNameFadeoutEnabled = jArray.getInt(jPageObj, 21)
	WC.fMainNameFadeoutDelay = jArray.getFlt(jPageObj, 22)
	WC.fPoisonNameFadeoutDelay = jArray.getFlt(jPageObj, 23)
	WC.fPreselectNameFadeoutDelay = jArray.getFlt(jPageObj, 24)
	iCurrentNameFadeoutChoice = jArray.getInt(jPageObj, 25)
	WC.fNameFadeoutDuration = jArray.getFlt(jPageObj, 26)
	WC.bFirstPressShowsName = jArray.getInt(jPageObj, 27)
endFunction

function drawPage()

    if MCM.bEnabled && !MCM.bFirstEnabled
        
        if WC.bShowPositionIndicators
            MCM.AddHeaderOption("$iEquip_MCM_ui_lbl_posIndOpts")
            MCM.AddColorOptionST("ui_col_posIndColor", "$iEquip_MCM_ui_lbl_posIndColor", WC.iPositionIndicatorColor)
            MCM.AddSliderOptionST("ui_sld_posIndAlpha", "$iEquip_MCM_ui_lbl_posIndAlpha", WC.fPositionIndicatorAlpha, "{0}%")
            MCM.AddColorOptionST("ui_col_currPosIndColor", "$iEquip_MCM_ui_lbl_currPosIndColor", WC.iCurrPositionIndicatorColor)
            MCM.AddSliderOptionST("ui_sld_currPosIndAlpha", "$iEquip_MCM_ui_lbl_currPosIndAlpha", WC.fCurrPositionIndicatorAlpha, "{0}%")
            MCM.AddEmptyOption()
        endIf

        MCM.AddHeaderOption("$iEquip_MCM_ui_lbl_iconBgOpts")
        MCM.AddToggleOptionST("ui_tgl_fadeLeftIco2h", "$iEquip_MCM_ui_lbl_fadeLeftIco2h", WC.bFadeLeftIconWhen2HEquipped)
                
        if WC.bFadeLeftIconWhen2HEquipped
            MCM.AddSliderOptionST("ui_sld_leftIcoFade", "$iEquip_MCM_ui_lbl_leftIcoFade", WC.fLeftIconFadeAmount, "{0}%")
        endIf

        MCM.AddToggleOptionST("ui_tgl_tempLvlFade", "$iEquip_MCM_ui_lbl_tempLvlFade", TI.bFadeIconOnDegrade)
        MCM.AddMenuOptionST("ui_men_tmpLvlTxt", "$iEquip_MCM_ui_lbl_tmpLvlTxt", temperLevelTextOptions[TI.iTemperNameFormat])

        MCM.AddMenuOptionST("ui_men_ammoIcoStyle", "$iEquip_MCM_ui_lbl_ammoIcoStyle", ammoIconOptions[iAmmoIconStyle])

        MCM.AddMenuOptionST("ui_men_bckgroundStyle", "$iEquip_MCM_ui_lbl_bckgroundStyle", backgroundStyleOptions[WC.iBackgroundStyle])
        
        MCM.SetCursorPosition(1)
        ;We don't want drop shadow settings being messed around with while we are in Edit Mode
        if !WC.EM.isEditMode
            MCM.AddHeaderOption("$iEquip_MCM_ui_lbl_txtShadOpts")
            MCM.AddToggleOptionST("ui_tgl_dropShadow", "$iEquip_MCM_ui_lbl_dropShadow", WC.bDropShadowEnabled)
            
            if WC.bDropShadowEnabled
                MCM.AddSliderOptionST("ui_sld_dropShadowAlpha", "$iEquip_MCM_ui_lbl_dropShadowAlpha", WC.fDropShadowAlpha*100, "{0}%")
                MCM.AddSliderOptionST("ui_sld_dropShadowAngle", "$iEquip_MCM_ui_lbl_dropShadowAngle", WC.fDropShadowAngle, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_degrees"))
                MCM.AddTextOptionST("ui_txt_dropShadowBlur", "$iEquip_MCM_ui_lbl_dropShadowBlur", WC.iDropShadowBlur as string + " " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
                MCM.AddSliderOptionST("ui_sld_dropShadowDistance", "$iEquip_MCM_ui_lbl_dropShadowDistance", WC.fDropShadowDistance, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
                MCM.AddSliderOptionST("ui_sld_dropShadowStrength", "$iEquip_MCM_ui_lbl_dropShadowStrength", WC.fDropShadowStrength*100, "{0}%")
            endIf

            MCM.AddEmptyOption()
        endIf

        MCM.AddHeaderOption("$iEquip_MCM_ui_lbl_fadeoutopts")
        MCM.AddToggleOptionST("ui_tgl_enblWdgetFade", "$iEquip_MCM_ui_lbl_enblWdgetFade", WC.bWidgetFadeoutEnabled)
                
        if WC.bWidgetFadeoutEnabled
            MCM.AddSliderOptionST("ui_sld_wdgetFadeDelay", "$iEquip_MCM_ui_lbl_wdgetFadeDelay", WC.fWidgetFadeoutDelay, "{0}")
            MCM.AddMenuOptionST("ui_men_wdgetFadeSpeed", "$iEquip_MCM_ui_lbl_wdgetFadeSpeed", fadeoutOptions[iCurrentWidgetFadeoutChoice])
                    
            if iCurrentWidgetFadeoutChoice == 3
                MCM.AddSliderOptionST("ui_sld_wdgetFadeDur", "$iEquip_MCM_ui_lbl_wdgetFadeDur", WC.fWidgetFadeoutDuration, "{1}")
            endIf

            MCM.AddToggleOptionST("ui_tgl_visWhenWeapDrawn", "$iEquip_MCM_ui_lbl_visWhenWeapDrawn", WC.bAlwaysVisibleWhenWeaponsDrawn)
        endIf
        
        MCM.AddEmptyOption()
        MCM.AddToggleOptionST("ui_tgl_enblNameFade", "$iEquip_MCM_ui_lbl_enblNameFade", WC.bNameFadeoutEnabled)
                
        if WC.bNameFadeoutEnabled
            MCM.AddSliderOptionST("ui_sld_mainNameFadeDelay", "$iEquip_MCM_ui_lbl_mainNameFadeDelay", WC.fMainNameFadeoutDelay, "{1}")
            MCM.AddSliderOptionST("ui_sld_poisonNameFadeDelay", "$iEquip_MCM_ui_lbl_poisonNameFadeDelay", WC.fPoisonNameFadeoutDelay, "{1}")
                    
            if WC.bProModeEnabled
                MCM.AddSliderOptionST("ui_sld_preselectNameFadeDelay", "$iEquip_MCM_ui_lbl_preselectNameFadeDelay", WC.fPreselectNameFadeoutDelay, "{1}")
            endIf
                    
            MCM.AddMenuOptionST("ui_men_nameFadeSpeed", "$iEquip_MCM_ui_lbl_nameFadeSpeed", fadeoutOptions[iCurrentNameFadeoutChoice])
                    
            if (iCurrentNameFadeoutChoice == 3)
                MCM.AddSliderOptionST("ui_sld_nameFadeDur", "$iEquip_MCM_ui_lbl_nameFadeDur", WC.fNameFadeoutDuration, "{1}")
            endIf
                    
            MCM.AddMenuOptionST("ui_men_firstPressNameHidn", "$iEquip_MCM_ui_lbl_firstPressNameHidn", firstPressIfNameHiddenOptions[WC.bFirstPressShowsName as int])
        endIf
    endIf
endFunction

; ##################
; ### UI Options ###
; ##################

; ------------------
; - Widget Options -
; ------------------

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

State ui_tgl_tempLvlFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempLvlFade")
        elseIf currentEvent == "Select"
            TI.bFadeIconOnDegrade = !TI.bFadeIconOnDegrade
            MCM.SetToggleOptionValueST(TI.bFadeIconOnDegrade)
            WC.bTemperFadeSettingChanged = true
        endIf 
    endEvent
endState

State ui_men_tmpLvlTxt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tmpLvlTxt")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TI.iTemperNameFormat, temperLevelTextOptions, 1)
        elseIf currentEvent == "Accept"
            TI.iTemperNameFormat = currentVar as int
            MCM.SetMenuOptionValueST(temperLevelTextOptions[TI.iTemperNameFormat])
            WC.bTemperLevelTextStyleChanged = true
        endIf 
    endEvent
endState

State ui_tgl_fadeLeftIco2h
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_fadeLeftIco2h")
        elseIf currentEvent == "Select"
            WC.bFadeLeftIconWhen2HEquipped = !WC.bFadeLeftIconWhen2HEquipped
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bFadeLeftIconWhen2HEquipped = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_leftIcoFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_leftIcoFade")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fLeftIconFadeAmount, 0.0, 100.0, 10.0, 70.0)
        elseIf currentEvent == "Accept"
            WC.fLeftIconFadeAmount = currentVar
            MCM.SetSliderOptionValueST(WC.fLeftIconFadeAmount, "{0}%")
        endIf 
    endEvent
endState

State ui_men_ammoIcoStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_ammoIcoStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iAmmoIconStyle, ammoIconOptions, 0)
        elseIf currentEvent == "Accept"
            iAmmoIconStyle = currentVar as int
        
            if iAmmoIconStyle == 0
                AM.sAmmoIconSuffix = ""
            elseIf iAmmoIconStyle == 1
                AM.sAmmoIconSuffix = "Triple"
            elseIf iAmmoIconStyle == 2
                AM.sAmmoIconSuffix = "Quiver"
            endIf
            
            MCM.SetMenuOptionValueST(ammoIconOptions[iAmmoIconStyle])
            WC.bAmmoIconChanged = true
        endIf 
    endEvent
endState

State ui_men_bckgroundStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_bckgroundStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iBackgroundStyle, backgroundStyleOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iBackgroundStyle = currentVar as int
            MCM.SetMenuOptionValueST(backgroundStyleOptions[WC.iBackgroundStyle])
            WC.bBackgroundStyleChanged = true
        endIf 
    endEvent
endState

State ui_tgl_dropShadow
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadow")
        else
            if currentEvent == "Select"
                WC.bDropShadowEnabled = !WC.bDropShadowEnabled
            elseIf currentEvent == "Default"
                WC.bDropShadowEnabled = true
            endIf
            MCM.SetToggleOptionValueST(WC.bDropShadowEnabled)
            MCM.forcePageReset()
            WC.bDropShadowSettingChanged = true
        endIf
    endEvent
endState

State ui_sld_dropShadowAlpha
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadowAlpha")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fDropShadowAlpha*100, 10.0, 100.0, 10.0, 80.0)
        elseIf currentEvent == "Accept"
            WC.fDropShadowAlpha = currentVar/100
            MCM.SetSliderOptionValueST(WC.fDropShadowAlpha*100, "{0}%")
            WC.bDropShadowSettingChanged = true
        endIf 
    endEvent
endState

State ui_sld_dropShadowAngle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadowAngle")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fDropShadowAngle, 0.0, 360.0, 15.0, 105.0)
        elseIf currentEvent == "Accept"
            WC.fDropShadowAngle = currentVar
            MCM.SetSliderOptionValueST(WC.fDropShadowAngle, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_degrees"))
            WC.bDropShadowSettingChanged = true
        endIf 
    endEvent
endState

State ui_txt_dropShadowBlur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadowBlur")
        elseIf currentEvent == "Select"
            int i = aiDropShadowBlurValues.Find(WC.iDropShadowBlur)
            i += 1
            if i > 5
                i = 0
            endIf
            WC.iDropShadowBlur = aiDropShadowBlurValues[i]
            MCM.SetTextOptionValueST(aiDropShadowBlurValues[i] as string + " " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
            WC.bDropShadowSettingChanged = true
        endIf
    endEvent
endState

State ui_sld_dropShadowDistance
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadowDistance")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fDropShadowDistance, 0.0, 10.0, 1.0, 2.0)
        elseIf currentEvent == "Accept"
            WC.fDropShadowDistance = currentVar
            MCM.SetSliderOptionValueST(WC.fDropShadowDistance, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
            WC.bDropShadowSettingChanged = true
        endIf 
    endEvent
endState

State ui_sld_dropShadowStrength
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_dropShadowStrength")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fDropShadowStrength*100, 25.0, 2000.0, 25.0, 100.0)
        elseIf currentEvent == "Accept"
            WC.fDropShadowStrength = currentVar/100
            MCM.SetSliderOptionValueST(WC.fDropShadowStrength*100, "{0}%")
            WC.bDropShadowSettingChanged = true
        endIf 
    endEvent
endState
 
; --------------------
; - Fade Out Options -
; --------------------

State ui_tgl_enblWdgetFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_enblWdgetFade")
        else
            if currentEvent == "Select"
                WC.bWidgetFadeoutEnabled = !WC.bWidgetFadeoutEnabled
            elseIf currentEvent == "Default"
                WC.bWidgetFadeoutEnabled = false
            endIf
            MCM.forcePageReset()
            WC.bFadeOptionsChanged = true
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_wdgetFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fWidgetFadeoutDelay, 0.0, 180.0, 5.0, 30.0)
        elseIf currentEvent == "Accept"
            WC.fWidgetFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fWidgetFadeoutDelay, "{0}")
        endIf 
    endEvent
endState

State ui_men_wdgetFadeSpeed
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(iCurrentWidgetFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            iCurrentWidgetFadeoutChoice = currentVar as int
        
            if iCurrentWidgetFadeoutChoice == 0
                WC.fWidgetFadeoutDuration = 3.0 ;Slow
            elseIf iCurrentWidgetFadeoutChoice == 1
                WC.fWidgetFadeoutDuration = 1.5 ;Normal
            elseIf iCurrentWidgetFadeoutChoice == 2
                WC.fWidgetFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[iCurrentWidgetFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_wdgetFadeDur")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fWidgetFadeoutDuration, 0.0, 10.0, 0.1, 1.5)
        elseIf currentEvent == "Accept"
            WC.fWidgetFadeoutDuration = currentVar
            MCM.SetSliderOptionValueST(WC.fWidgetFadeoutDuration, "{1}")
        endIf 
    endEvent
endState

State ui_tgl_visWhenWeapDrawn
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_visWhenWeapDrawn")
        else
            if currentEvent == "Select"
                WC.bAlwaysVisibleWhenWeaponsDrawn = !WC.bAlwaysVisibleWhenWeaponsDrawn
            elseIf currentEvent == "Default"
                WC.bAlwaysVisibleWhenWeaponsDrawn = true
            endIf
            MCM.SetToggleOptionValueST(WC.bAlwaysVisibleWhenWeaponsDrawn)
            WC.bFadeOptionsChanged = true
        endIf 
    endEvent
endState

State ui_tgl_enblNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_enblNameFade")
        else
            if currentEvent == "Select"
                WC.bNameFadeoutEnabled = !WC.bNameFadeoutEnabled
            elseIf currentEvent == "Default"
                WC.bNameFadeoutEnabled = false
            endIf
            WC.bFadeOptionsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_mainNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_mainNameFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fMainNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            WC.fMainNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fMainNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_sld_poisonNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_poisonNameFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fPoisonNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            WC.fPoisonNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fPoisonNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_sld_preselectNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_preselectNameFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fPreselectNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            WC.fPreselectNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fPreselectNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_men_nameFadeSpeed
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_nameFadeSpeed")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iCurrentNameFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            iCurrentNameFadeoutChoice = currentVar as int
        
            if iCurrentNameFadeoutChoice == 0
                WC.fNameFadeoutDuration = 3.0 ;Slow
            elseIf iCurrentNameFadeoutChoice == 1
                WC.fNameFadeoutDuration = 1.5 ;Normal
            elseIf iCurrentNameFadeoutChoice == 2
                WC.fNameFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[iCurrentNameFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_nameFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_nameFadeDur")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fNameFadeoutDuration, 0.0, 10.0, 0.1, 1.5)
        elseIf currentEvent == "Accept"
            WC.fNameFadeoutDuration = currentVar
            MCM.SetSliderOptionValueST(WC.fNameFadeoutDuration, "{1}")
        endIf 
    endEvent
endState

State ui_men_firstPressNameHidn
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(WC.bFirstPressShowsName as int, firstPressIfNameHiddenOptions, 0)
        elseIf currentEvent == "Accept"
            WC.bFirstPressShowsName = currentVar as bool
            MCM.SetMenuOptionValueST(firstPressIfNameHiddenOptions[WC.bFirstPressShowsName as int])
        endIf 
    endEvent
endState
