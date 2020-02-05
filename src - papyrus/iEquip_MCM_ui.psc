Scriptname iEquip_MCM_ui extends iEquip_MCM_Page

iEquip_TemperedItemHandler Property TI Auto

string[] backgroundStyleOptions
string[] fadeoutOptions
string[] firstPressIfNameHiddenOptions
string[] temperLevelTextOptions
string[] coloredIconOptions
string[] tempLvlThresholdOptions

int[] aiDropShadowBlurValues

string[] temperTierIndicatorStyles

; #############
; ### SETUP ###

function initData()
    
    backgroundStyleOptions = new String[8]
    backgroundStyleOptions[0] = "$iEquip_MCM_ui_opt_NoBg"
    backgroundStyleOptions[1] = "$iEquip_MCM_ui_opt_SqBBg"
    backgroundStyleOptions[2] = "$iEquip_MCM_ui_opt_SqNoBBg"
    backgroundStyleOptions[3] = "$iEquip_MCM_ui_opt_RoBBg"
    backgroundStyleOptions[4] = "$iEquip_MCM_ui_opt_RoNoBBg"
    backgroundStyleOptions[5] = "$iEquip_MCM_ui_opt_RoFade"
    backgroundStyleOptions[6] = "$iEquip_MCM_ui_opt_Dialogue"
    backgroundStyleOptions[7] = "$iEquip_MCM_ui_opt_DarkSouls"
    
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

    temperTierIndicatorStyles = new string[8]
    temperTierIndicatorStyles[0] = "$iEquip_MCM_ui_opt_tmpTierStyle1"
    temperTierIndicatorStyles[1] = "$iEquip_MCM_ui_opt_tmpTierStyle2"
    temperTierIndicatorStyles[2] = "$iEquip_MCM_ui_opt_tmpTierStyle3"
    temperTierIndicatorStyles[3] = "$iEquip_MCM_ui_opt_tmpTierStyle4"
    temperTierIndicatorStyles[4] = "$iEquip_MCM_ui_opt_tmpTierStyle5"
    temperTierIndicatorStyles[5] = "$iEquip_MCM_ui_opt_tmpTierStyle6"
    temperTierIndicatorStyles[6] = "$iEquip_MCM_ui_opt_tmpTierStyle7"
    temperTierIndicatorStyles[7] = "$iEquip_MCM_ui_opt_tmpTierStyle8"

    coloredIconOptions = new string[3]
    coloredIconOptions[0] = "$iEquip_MCM_ui_opt_noColor"
    coloredIconOptions[1] = "$iEquip_MCM_ui_opt_colorLower"
    coloredIconOptions[2] = "$iEquip_MCM_ui_opt_colorFull"

    tempLvlThresholdOptions = new string[4]
    tempLvlThresholdOptions[0] = "$iEquip_MCM_ui_opt_tmpLvl4020"
    tempLvlThresholdOptions[1] = "$iEquip_MCM_ui_opt_tmpLvl3020"
    tempLvlThresholdOptions[2] = "$iEquip_MCM_ui_opt_tmpLvl3010"
    tempLvlThresholdOptions[3] = "$iEquip_MCM_ui_opt_tmpLvl2010"

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()
	
	jArray.addInt(jPageObj, WC.bFadeLeftIconWhen2HEquipped as int)
	jArray.addFlt(jPageObj, WC.fLeftIconFadeAmount)
    jArray.addInt(jPageObj, TI.iTemperNameFormat)
    jArray.addInt(jPageObj, TI.bTemperInfoBelowName as int)
	jArray.addInt(jPageObj, TI.bFadeIconOnDegrade as int)
	jArray.addInt(jPageObj, TI.iColoredIconStyle)
    jArray.addInt(jPageObj, TI.iColoredIconLevels)

	jArray.addInt(jPageObj, WC.iBackgroundStyle) ; Save in preset also
	
	jArray.addInt(jPageObj, WC.bDropShadowEnabled as int)
	jArray.addFlt(jPageObj, WC.fDropShadowAlpha)
	jArray.addFlt(jPageObj, WC.fDropShadowAngle)
	jArray.addInt(jPageObj, WC.iDropShadowBlur)
	jArray.addFlt(jPageObj, WC.fDropShadowDistance)
	jArray.addFlt(jPageObj, WC.fDropShadowStrength)
	
	jArray.addInt(jPageObj, WC.bWidgetFadeoutEnabled as int)
	jArray.addFlt(jPageObj, WC.fWidgetFadeoutDelay)
	jArray.addInt(jPageObj, WC.iCurrentWidgetFadeoutChoice)
	jArray.addFlt(jPageObj, WC.fWidgetFadeoutDuration)
	jArray.addInt(jPageObj, WC.bAlwaysVisibleWhenWeaponsDrawn as int)
	
	jArray.addInt(jPageObj, WC.bNameFadeoutEnabled as int)
	jArray.addFlt(jPageObj, WC.fMainNameFadeoutDelay)
	jArray.addFlt(jPageObj, WC.fPoisonNameFadeoutDelay)
	jArray.addFlt(jPageObj, WC.fPreselectNameFadeoutDelay)
	jArray.addInt(jPageObj, WC.iCurrentNameFadeoutChoice)
	jArray.addFlt(jPageObj, WC.fNameFadeoutDuration)
	jArray.addInt(jPageObj, WC.bFirstPressShowsName as int)
    jArray.addInt(jPageObj, WC.bLeftRightNameFadeEnabled as int)
    jArray.addInt(jPageObj, WC.bShoutNameFadeEnabled as int)
    jArray.addInt(jPageObj, WC.bConsPoisNameFadeEnabled as int)

    jArray.addInt(jPageObj, TI.bShowTemperTierIndicator as int)
    jArray.addInt(jPageObj, TI.iTemperTierDisplayChoice)
    jArray.addInt(jPageObj, TI.bShowFadedTiers as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	
	WC.bFadeLeftIconWhen2HEquipped = jArray.getInt(jPageObj, 4)
	WC.fLeftIconFadeAmount = jArray.getFlt(jPageObj, 5)
    TI.iTemperNameFormat = jArray.getInt(jPageObj, 6)
    TI.bTemperInfoBelowName = jArray.getInt(jPageObj, 7)
	TI.bFadeIconOnDegrade = jArray.getInt(jPageObj, 8)
	TI.iColoredIconStyle = jArray.getInt(jPageObj, 9)
    TI.iColoredIconLevels = jArray.getInt(jPageObj, 10)

	WC.iBackgroundStyle = jArray.getInt(jPageObj, 12)
	
	WC.bDropShadowEnabled = jArray.getInt(jPageObj, 13)
	WC.fDropShadowAlpha = jArray.getFlt(jPageObj, 14)
	WC.fDropShadowAngle = jArray.getFlt(jPageObj, 15)
	WC.iDropShadowBlur = jArray.getInt(jPageObj, 16)
	WC.fDropShadowDistance = jArray.getFlt(jPageObj, 17)
	WC.fDropShadowStrength = jArray.getFlt(jPageObj, 18)
	
	WC.bWidgetFadeoutEnabled = jArray.getInt(jPageObj, 19)
	WC.fWidgetFadeoutDelay = jArray.getFlt(jPageObj, 20)
	WC.iCurrentWidgetFadeoutChoice = jArray.getInt(jPageObj, 21)
	WC.fWidgetFadeoutDuration = jArray.getFlt(jPageObj, 22)
	WC.bAlwaysVisibleWhenWeaponsDrawn = jArray.getInt(jPageObj, 23)
	
	WC.bNameFadeoutEnabled = jArray.getInt(jPageObj, 24)
	WC.fMainNameFadeoutDelay = jArray.getFlt(jPageObj, 25)
	WC.fPoisonNameFadeoutDelay = jArray.getFlt(jPageObj, 26)
	WC.fPreselectNameFadeoutDelay = jArray.getFlt(jPageObj, 27)
	WC.iCurrentNameFadeoutChoice = jArray.getInt(jPageObj, 28)
	WC.fNameFadeoutDuration = jArray.getFlt(jPageObj, 29)
	WC.bFirstPressShowsName = jArray.getInt(jPageObj, 30)
    WC.bLeftRightNameFadeEnabled = jArray.getInt(jPageObj, 31)
    WC.bShoutNameFadeEnabled = jArray.getInt(jPageObj, 32)
    WC.bConsPoisNameFadeEnabled = jArray.getInt(jPageObj, 33)

	TI.bShowTemperTierIndicator = jArray.getInt(jPageObj, 34)
	TI.iTemperTierDisplayChoice = jArray.getInt(jPageObj, 35)
	TI.bShowFadedTiers = jArray.getInt(jPageObj, 36)
endFunction

function drawPage()

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_ui_lbl_temperedItemOpts</font>")
	MCM.AddMenuOptionST("ui_men_tmpLvlTxt", "$iEquip_MCM_ui_lbl_tmpLvlTxt", temperLevelTextOptions[TI.iTemperNameFormat])
	
	if TI.iTemperNameFormat > 0 && TI.iTemperNameFormat < 9
		MCM.AddToggleOptionST("ui_tgl_tempInfoBelow", "$iEquip_MCM_ui_lbl_tempInfoBelow", TI.bTemperInfoBelowName)
	endIf

	MCM.AddToggleOptionST("ui_tgl_tempTierDisplay", "$iEquip_MCM_ui_lbl_tempTierDisplay", TI.bShowTemperTierIndicator)

	if TI.bShowTemperTierIndicator
		MCM.AddMenuOptionST("ui_men_tempTierStyle", "$iEquip_MCM_ui_lbl_tempTierStyle", temperTierIndicatorStyles[TI.iTemperTierDisplayChoice])
		MCM.AddToggleOptionST("ui_tgl_showFadedTiers", "$iEquip_MCM_ui_lbl_showFadedTiers", TI.bShowFadedTiers)
	endIf
	
	MCM.AddToggleOptionST("ui_tgl_tempLvlFade", "$iEquip_MCM_ui_lbl_tempLvlFade", TI.bFadeIconOnDegrade)
	
	if TI.bFadeIconOnDegrade
		MCM.AddMenuOptionST("ui_men_tempLvlColorIcon", "$iEquip_MCM_ui_lbl_tempLvlColorIcon", coloredIconOptions[TI.iColoredIconStyle])

		if TI.iColoredIconStyle > 0
			MCM.AddMenuOptionST("ui_men_tempLvlThresholds", "$iEquip_MCM_ui_lbl_tempLvlThresholds", tempLvlThresholdOptions[TI.iColoredIconLevels])
		endIf
	endIf
	MCM.AddEmptyOption()

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_ui_lbl_iconBgOpts</font>")

	MCM.AddToggleOptionST("ui_tgl_fadeLeftIco2h", "$iEquip_MCM_ui_lbl_fadeLeftIco2h", WC.bFadeLeftIconWhen2HEquipped)
			
	if WC.bFadeLeftIconWhen2HEquipped
		MCM.AddSliderOptionST("ui_sld_leftIcoFade", "$iEquip_MCM_ui_lbl_leftIcoFade", WC.fLeftIconFadeAmount, "{0}%")
	endIf

	MCM.AddMenuOptionST("ui_men_bckgroundStyle", "$iEquip_MCM_ui_lbl_bckgroundStyle", backgroundStyleOptions[WC.iBackgroundStyle])
	
	MCM.SetCursorPosition(1)

	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_ui_lbl_fadeoutopts</font>")
	MCM.AddToggleOptionST("ui_tgl_enblWdgetFade", "$iEquip_MCM_ui_lbl_enblWdgetFade", WC.bWidgetFadeoutEnabled)
			
	if WC.bWidgetFadeoutEnabled
		MCM.AddSliderOptionST("ui_sld_wdgetFadeDelay", "$iEquip_MCM_ui_lbl_wdgetFadeDelay", WC.fWidgetFadeoutDelay, "{0}")
		MCM.AddMenuOptionST("ui_men_wdgetFadeSpeed", "$iEquip_MCM_ui_lbl_wdgetFadeSpeed", fadeoutOptions[WC.iCurrentWidgetFadeoutChoice])
				
		if WC.iCurrentWidgetFadeoutChoice == 3
			MCM.AddSliderOptionST("ui_sld_wdgetFadeDur", "$iEquip_MCM_ui_lbl_wdgetFadeDur", WC.fWidgetFadeoutDuration, "{1}")
		endIf

		MCM.AddToggleOptionST("ui_tgl_visWhenWeapDrawn", "$iEquip_MCM_ui_lbl_visWhenWeapDrawn", WC.bAlwaysVisibleWhenWeaponsDrawn)
	endIf
	
	MCM.AddEmptyOption()
	MCM.AddToggleOptionST("ui_tgl_enblNameFade", "$iEquip_MCM_ui_lbl_enblNameFade", WC.bNameFadeoutEnabled)
			
	if WC.bNameFadeoutEnabled

		MCM.AddToggleOptionST("ui_tgl_leftRightNameFade", "$iEquip_MCM_ui_lbl_leftRightNameFade", WC.bLeftRightNameFadeEnabled)
		MCM.AddToggleOptionST("ui_tgl_shoutNameFade", "$iEquip_MCM_ui_lbl_shoutNameFade", WC.bShoutNameFadeEnabled)
		MCM.AddToggleOptionST("ui_tgl_consPoisNameFade", "$iEquip_MCM_ui_lbl_consPoisNameFade", WC.bConsPoisNameFadeEnabled)

		MCM.AddSliderOptionST("ui_sld_mainNameFadeDelay", "$iEquip_MCM_ui_lbl_mainNameFadeDelay", WC.fMainNameFadeoutDelay, "{1}")
		MCM.AddSliderOptionST("ui_sld_poisonNameFadeDelay", "$iEquip_MCM_ui_lbl_poisonNameFadeDelay", WC.fPoisonNameFadeoutDelay, "{1}")
				
		if WC.bProModeEnabled
			MCM.AddSliderOptionST("ui_sld_preselectNameFadeDelay", "$iEquip_MCM_ui_lbl_preselectNameFadeDelay", WC.fPreselectNameFadeoutDelay, "{1}")
		endIf
				
		MCM.AddMenuOptionST("ui_men_nameFadeSpeed", "$iEquip_MCM_ui_lbl_nameFadeSpeed", fadeoutOptions[WC.iCurrentNameFadeoutChoice])
				
		if (WC.iCurrentNameFadeoutChoice == 3)
			MCM.AddSliderOptionST("ui_sld_nameFadeDur", "$iEquip_MCM_ui_lbl_nameFadeDur", WC.fNameFadeoutDuration, "{1}")
		endIf
				
		MCM.AddMenuOptionST("ui_men_firstPressNameHidn", "$iEquip_MCM_ui_lbl_firstPressNameHidn", firstPressIfNameHiddenOptions[WC.bFirstPressShowsName as int])
	endIf

	MCM.AddEmptyOption()

	;We don't want drop shadow settings being messed around with while we are in Edit Mode
	if !WC.EM.isEditMode
		MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_ui_lbl_txtShadOpts</font>")
		MCM.AddToggleOptionST("ui_tgl_dropShadow", "$iEquip_MCM_ui_lbl_dropShadow", WC.bDropShadowEnabled)
		
		if WC.bDropShadowEnabled
			MCM.AddSliderOptionST("ui_sld_dropShadowAlpha", "$iEquip_MCM_ui_lbl_dropShadowAlpha", WC.fDropShadowAlpha*100, "{0}%")
			MCM.AddSliderOptionST("ui_sld_dropShadowAngle", "$iEquip_MCM_ui_lbl_dropShadowAngle", WC.fDropShadowAngle, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_degrees"))
			MCM.AddTextOptionST("ui_txt_dropShadowBlur", "$iEquip_MCM_ui_lbl_dropShadowBlur", WC.iDropShadowBlur as string + " " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
			MCM.AddSliderOptionST("ui_sld_dropShadowDistance", "$iEquip_MCM_ui_lbl_dropShadowDistance", WC.fDropShadowDistance, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
			MCM.AddSliderOptionST("ui_sld_dropShadowStrength", "$iEquip_MCM_ui_lbl_dropShadowStrength", WC.fDropShadowStrength*100, "{0}%")
		endIf
	endIf

endFunction

; ##################
; ### UI Options ###
; ##################

; ------------------
; - Widget Options -
; ------------------

State ui_men_tmpLvlTxt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tmpLvlTxt")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TI.iTemperNameFormat, temperLevelTextOptions, 1)
        elseIf currentEvent == "Accept"
            TI.iTemperNameFormat = currentVar as int
            MCM.SetMenuOptionValueST(temperLevelTextOptions[TI.iTemperNameFormat])
            WC.bTemperDisplaySettingChanged = true
            MCM.ForcePageReset()
        endIf 
    endEvent
endState

State ui_tgl_tempInfoBelow
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempInfoBelow")
        elseIf currentEvent == "Select"
            TI.bTemperInfoBelowName = !TI.bTemperInfoBelowName
            MCM.SetToggleOptionValueST(TI.bTemperInfoBelowName)
            WC.bTemperDisplaySettingChanged = true
        endIf 
    endEvent
endState

State ui_tgl_tempTierDisplay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempTierDisplay")
        elseIf currentEvent == "Select"
            TI.bShowTemperTierIndicator = !TI.bShowTemperTierIndicator
            WC.bTemperDisplaySettingChanged = true
            MCM.ForcePageReset()
        endIf 
    endEvent
endState

State ui_men_tempTierStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempTierStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TI.iTemperTierDisplayChoice, temperTierIndicatorStyles, 1)
        elseIf currentEvent == "Accept"
            TI.iTemperTierDisplayChoice = currentVar as int
            MCM.SetMenuOptionValueST(temperTierIndicatorStyles[TI.iTemperTierDisplayChoice])
            WC.bTemperDisplaySettingChanged = true
            MCM.ForcePageReset()
        endIf 
    endEvent
endState

State ui_tgl_showFadedTiers
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_showFadedTiers")
        elseIf currentEvent == "Select"
            TI.bShowFadedTiers = !TI.bShowFadedTiers
            MCM.SetToggleOptionValueST(TI.bShowFadedTiers)
            WC.bTemperDisplaySettingChanged = true
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
            WC.bTemperDisplaySettingChanged = true
            MCM.ForcePageReset()
        endIf 
    endEvent
endState

State ui_men_tempLvlColorIcon
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempLvlColorIcon")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TI.iColoredIconStyle, coloredIconOptions, 1)
        elseIf currentEvent == "Accept"
            TI.iColoredIconStyle = currentVar as int
            MCM.SetMenuOptionValueST(coloredIconOptions[TI.iColoredIconStyle])
            WC.bTemperDisplaySettingChanged = true
            MCM.ForcePageReset()
        endIf 
    endEvent
endState

State ui_men_tempLvlThresholds
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_tempLvlThresholds")
        elseIf currentEvent == "Open"
            MCM.fillMenu(TI.iColoredIconLevels, tempLvlThresholdOptions, 1)
        elseIf currentEvent == "Accept"
            TI.iColoredIconLevels = currentVar as int
            MCM.SetMenuOptionValueST(tempLvlThresholdOptions[TI.iColoredIconLevels])
            WC.bTemperDisplaySettingChanged = true
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

State ui_men_bckgroundStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_bckgroundStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iBackgroundStyle, backgroundStyleOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iBackgroundStyle = currentVar as int
            WC.bBackgroundStyleChanged = true
			MCM.SetMenuOptionValueST(backgroundStyleOptions[WC.iBackgroundStyle])
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
			
            WC.bDropShadowSettingChanged = true
			MCM.SetToggleOptionValueST(WC.bDropShadowEnabled)
            MCM.forcePageReset()
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
            WC.bDropShadowSettingChanged = true
			MCM.SetSliderOptionValueST(WC.fDropShadowAngle, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_degrees"))
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
            WC.bDropShadowSettingChanged = true
			MCM.SetTextOptionValueST(aiDropShadowBlurValues[i] as string + " " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
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
            WC.bDropShadowSettingChanged = true
			MCM.SetSliderOptionValueST(WC.fDropShadowDistance, "{0} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_ui_pixels"))
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
            WC.bDropShadowSettingChanged = true
			MCM.SetSliderOptionValueST(WC.fDropShadowStrength*100, "{0}%")
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

            WC.bFadeOptionsChanged = true
			MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_wdgetFadeDelay")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.fWidgetFadeoutDelay, 0.0, 60.0, 0.5, 10.0)
        elseIf currentEvent == "Accept"
            WC.fWidgetFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fWidgetFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_men_wdgetFadeSpeed
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(WC.iCurrentWidgetFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iCurrentWidgetFadeoutChoice = currentVar as int
            MCM.SetMenuOptionValueST(fadeoutOptions[WC.iCurrentWidgetFadeoutChoice])
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
        elseIf currentEvent == "Select" || currentEvent == "Default"
            if currentEvent == "Select"
                WC.bAlwaysVisibleWhenWeaponsDrawn = !WC.bAlwaysVisibleWhenWeaponsDrawn
            else
                WC.bAlwaysVisibleWhenWeaponsDrawn = true
            endIf
			
			WC.bFadeOptionsChanged = true
            MCM.SetToggleOptionValueST(WC.bAlwaysVisibleWhenWeaponsDrawn)
        endIf 
    endEvent
endState

State ui_tgl_enblNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_enblNameFade")
        elseIf currentEvent == "Select" || currentEvent == "Default"
            if currentEvent == "Select"
                WC.bNameFadeoutEnabled = !WC.bNameFadeoutEnabled
            else
                WC.bNameFadeoutEnabled = false
            endIf
			
            WC.bFadeOptionsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_tgl_leftRightNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_leftRightNameFade")
        elseIf currentEvent == "Select" || currentEvent == "Default"
            if currentEvent == "Select"
                WC.bLeftRightNameFadeEnabled = !WC.bLeftRightNameFadeEnabled
            else
                WC.bLeftRightNameFadeEnabled = true
            endIf
			
			WC.bFadeOptionsChanged = true
			MCM.SetToggleOptionValueST(WC.bLeftRightNameFadeEnabled)
        endIf 
    endEvent
endState

State ui_tgl_shoutNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_shoutNameFade")
        elseIf currentEvent == "Select" || currentEvent == "Default"
            if currentEvent == "Select"
                WC.bShoutNameFadeEnabled = !WC.bShoutNameFadeEnabled
            else
                WC.bShoutNameFadeEnabled = true
            endIf
			
			WC.bFadeOptionsChanged = true
			MCM.SetToggleOptionValueST(WC.bShoutNameFadeEnabled)
        endIf 
    endEvent
endState

State ui_tgl_consPoisNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_consPoisNameFade")
        elseIf currentEvent == "Select" || currentEvent == "Default"
            if currentEvent == "Select"
                WC.bConsPoisNameFadeEnabled = !WC.bConsPoisNameFadeEnabled
            else
                WC.bConsPoisNameFadeEnabled = true
            endIf
			
			WC.bFadeOptionsChanged = true
			MCM.SetToggleOptionValueST(WC.bConsPoisNameFadeEnabled)
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
            MCM.fillMenu(WC.iCurrentNameFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iCurrentNameFadeoutChoice = currentVar as int
            MCM.SetMenuOptionValueST(fadeoutOptions[WC.iCurrentNameFadeoutChoice])
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

; Deprecated

string[] ammoIconOptions