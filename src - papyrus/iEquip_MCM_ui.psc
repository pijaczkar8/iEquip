Scriptname iEquip_MCM_ui extends iEquip_MCM_Page

iEquip_AmmoMode Property AM Auto

string[] ammoIconOptions
string[] backgroundStyleOptions
string[] fadeoutOptions
string[] firstPressIfNameHiddenOptions

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
    
    backgroundStyleOptions = new String[5]
    backgroundStyleOptions[0] = "$iEquip_MCM_ui_opt_NoBg"
    backgroundStyleOptions[1] = "$iEquip_MCM_ui_opt_SqBBg"
    backgroundStyleOptions[2] = "$iEquip_MCM_ui_opt_SqNoBBg"
    backgroundStyleOptions[3] = "$iEquip_MCM_ui_opt_RoBBg"
    backgroundStyleOptions[4] = "$iEquip_MCM_ui_opt_RoNoBBg"
    
    fadeoutOptions = new String[4]
    fadeoutOptions[0] = "$iEquip_MCM_ui_opt_Slow"
    fadeoutOptions[1] = "$iEquip_MCM_ui_opt_Normal"
    fadeoutOptions[2] = "$iEquip_MCM_ui_opt_Fast"
    fadeoutOptions[3] = "$iEquip_common_Custom"
    
    firstPressIfNameHiddenOptions = new String[2]
    firstPressIfNameHiddenOptions[0] = "$iEquip_MCM_ui_opt_CycleSlot"
    firstPressIfNameHiddenOptions[1] = "$iEquip_MCM_ui_opt_ShowName"
endFunction

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
        MCM.AddToggleOptionST("ui_tgl_fadeLeftIco2h", "$iEquip_MCM_ui_lbl_fadeLeftIco2h", WC.bFadeLeftIconWhen2HEquipped)
                
        if WC.bFadeLeftIconWhen2HEquipped
            MCM.AddSliderOptionST("ui_sld_leftIcoFade", "$iEquip_MCM_ui_lbl_leftIcoFade", WC.fLeftIconFadeAmount, "{0}%")
        endIf
                
        MCM.AddMenuOptionST("ui_men_ammoIcoStyle", "$iEquip_MCM_ui_lbl_ammoIcoStyle", ammoIconOptions[iAmmoIconStyle])

        MCM.AddMenuOptionST("ui_men_bckgroundStyle", "$iEquip_MCM_ui_lbl_bckgroundStyle", backgroundStyleOptions[WC.iBackgroundStyle])
        MCM.AddToggleOptionST("ui_tgl_dropShadow", "$iEquip_MCM_ui_lbl_dropShadow", WC.bDropShadowEnabled)
                
        MCM.SetCursorPosition(1)
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
            MCM.fillSlider(WC.fLeftIconFadeAmount, 10.0, 80.0, 10.0, 70.0)
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
