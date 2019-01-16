Scriptname iEquip_MCM_ui extends iEquip_MCM_Page

iEquip_AmmoMode Property AM Auto

string[] ammoIconOptions
string[] backgroundStyleOptions
string[] fadeoutOptions
string[] firstPressIfNameHiddenOptions

; #############
; ### SETUP ###

function initData()
    ammoIconOptions = new String[3]
    ammoIconOptions[0] = "Single"
    ammoIconOptions[1] = "Triple"
    ammoIconOptions[2] = "Quiver"
    
    backgroundStyleOptions = new String[5]
    backgroundStyleOptions[0] = "No background"
    backgroundStyleOptions[1] = "Square with border"
    backgroundStyleOptions[2] = "Square without border"
    backgroundStyleOptions[3] = "Round with border"
    backgroundStyleOptions[4] = "Round without border"
    
    fadeoutOptions = new String[4]
    fadeoutOptions[0] = "Slow"
    fadeoutOptions[1] = "Normal"
    fadeoutOptions[2] = "Fast"
    fadeoutOptions[3] = "Custom"
    
    firstPressIfNameHiddenOptions = new String[2]
    firstPressIfNameHiddenOptions[0] = "Cycle slot"
    firstPressIfNameHiddenOptions[1] = "Show name"
endFunction

function drawPage()
    if MCM.bEnabled
        MCM.AddHeaderOption("Widget Options")
        MCM.AddToggleOptionST("ui_tgl_fadeLeftIco2h", "Fade left icon if 2H equipped", WC.bFadeLeftIconWhen2HEquipped)
                
        if WC.bFadeLeftIconWhen2HEquipped
            MCM.AddSliderOptionST("ui_sld_leftIcoFade", "Left icon fade", WC.fLeftIconFadeAmount, "{0}%")
        endIf
                
        MCM.AddMenuOptionST("ui_men_ammoIcoStyle", "Ammo icon style", ammoIconOptions[MCM.iAmmoIconStyle])

        MCM.AddMenuOptionST("ui_men_bckgroundStyle", "Background style", backgroundStyleOptions[WC.iBackgroundStyle])
        MCM.AddToggleOptionST("ui_tgl_dropShadow", "Drop shadow on text", WC.bDropShadowEnabled)
                
        MCM.SetCursorPosition(1)
        MCM.AddHeaderOption("Fade Out Options")
        MCM.AddToggleOptionST("ui_tgl_enblWdgetFade", "Enable widget fadeout", WC.bWidgetFadeoutEnabled)
                
        if WC.bWidgetFadeoutEnabled
            MCM.AddSliderOptionST("ui_sld_wdgetFadeDelay", "Widget fadeout delay", WC.fWidgetFadeoutDelay, "{0}")
            MCM.AddMenuOptionST("ui_men_wdgetFadeSpeed", "Widget fadeout animation speed", fadeoutOptions[MCM.iCurrentWidgetFadeoutChoice])
                    
            if (MCM.iCurrentWidgetFadeoutChoice == 3)
                MCM.AddSliderOptionST("ui_sld_wdgetFadeDur", "Widget fadeout duration", WC.fWidgetFadeoutDuration, "{1}")
            endIf

            MCM.AddToggleOptionST("ui_tgl_visWhenWeapDrawn", "Always visible when weapons drawn", WC.bAlwaysVisibleWhenWeaponsDrawn)
        endIf
        
        MCM.AddEmptyOption()
        MCM.AddToggleOptionST("ui_tgl_enblNameFade", "Enable name fadeouts", WC.bNameFadeoutEnabled)
                
        if WC.bNameFadeoutEnabled
            MCM.AddSliderOptionST("ui_sld_mainNameFadeDelay", "Main name fadeout delay", WC.fMainNameFadeoutDelay, "{1}")
            MCM.AddSliderOptionST("ui_sld_poisonNameFadeDelay", "Poison name fadeout delay", WC.fPoisonNameFadeoutDelay, "{1}")
                    
            if WC.bProModeEnabled
                MCM.AddSliderOptionST("ui_sld_preselectNameFadeDelay", "Preselect name fadeout delay", WC.fPreselectNameFadeoutDelay, "{1}")
            endIf
                    
            MCM.AddMenuOptionST("ui_men_nameFadeSpeed", "Name fadeout animation speed", fadeoutOptions[MCM.iCurrentNameFadeoutChoice])
                    
            if (MCM.iCurrentNameFadeoutChoice == 3)
                MCM.AddSliderOptionST("ui_sld_nameFadeDur", "Name fadeout duration", WC.fNameFadeoutDuration, "{1}")
            endIf
                    
            MCM.AddMenuOptionST("ui_men_firstPressNameHidn", "First press when name hidden", firstPressIfNameHiddenOptions[WC.bFirstPressShowsName as int])
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
            MCM.SetInfoText("If enabled the left hand icon will be faded when a 2H or ranged weapon is equipped in the right hand\nDefault: Enabled")
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
            MCM.SetInfoText("Choose how much you would like the left icon faded out by.\nDefault: 70%")
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
            MCM.SetInfoText("Choose the style of arrow/bolt icons which will display in the left hand slot when you have a ranged weapon equipped. "+\
                            "All styles will also display an enchantment type icon if special arrows are equipped (fire, ice,shock, etc)\nSingle - A single default arrow or bolt icon\n"+\
                            "Triple - three default arrow or bolt icons of varied size\nQuiver - Arrow or bolt quiver icons\nDefault: Single")
        elseIf currentEvent == "Open"
            MCM.fillMenu(MCM.iAmmoIconStyle, ammoIconOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.iAmmoIconStyle = currentVar as int
        
            if MCM.iAmmoIconStyle == 0
                AM.sAmmoIconSuffix = ""
            elseIf MCM.iAmmoIconStyle == 1
                AM.sAmmoIconSuffix = "Triple"
            elseIf MCM.iAmmoIconStyle == 2
                AM.sAmmoIconSuffix = "Quiver"
            endIf
            
            MCM.SetMenuOptionValueST(ammoIconOptions[MCM.iAmmoIconStyle])
            WC.bAmmoIconChanged = true
        endIf 
    endEvent
endState

State ui_men_bckgroundStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the style for your slot backgrounds.\nBackgrounds can be scaled, rotated and faded in Edit Mode\nDefault: No Background")
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
            MCM.SetInfoText("This allows you to disable the drop shadow effect on the text elements in the widget\nDefault: Enabled")
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
            MCM.SetInfoText("Enables widget fadeout after a period of inactivity.  Once enabled additional fadeout options will become available to you\nDefault is Disabled")
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
            MCM.SetInfoText("The time in seconds of inactivity after which the iEquip widget will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 30 seconds")
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
            MCM.fillMenu(MCM.iCurrentWidgetFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.iCurrentWidgetFadeoutChoice = currentVar as int
        
            if MCM.iCurrentWidgetFadeoutChoice == 0
                WC.fWidgetFadeoutDuration = 3.0 ;Slow
            elseIf MCM.iCurrentWidgetFadeoutChoice == 1
                WC.fWidgetFadeoutDuration = 1.5 ;Normal
            elseIf MCM.iCurrentWidgetFadeoutChoice == 2
                WC.fWidgetFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[MCM.iCurrentWidgetFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The duration in seconds of the widget fade out animation\nSetting this to zero will make the text hide instantly after the delays set above\nDefault duration = 1.5 seconds")
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
            MCM.SetInfoText("Ensures that the widget will always be visible when you have your weapons drawn.  If the widget is currently faded out when you draw your weapons it will automatically be re-shown\nDefault is Enabled")
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
            MCM.SetInfoText("Enables fadeout of item names after cycling.  Once enabled additional fadeout options will become available to you\nDefault is Disabled")
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
            MCM.SetInfoText("The time in seconds after cycling the main slots after which the main item names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
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
            MCM.SetInfoText("The time in seconds after cycling the main slots after which the poison names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
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
            MCM.SetInfoText("The time in seconds after cycling the preselect slots after which the preselect item names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
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
            MCM.SetInfoText("The speed of the fadeout animation for the item name text\nDefault: Normal (1.5 seconds)")
        elseIf currentEvent == "Open"
            MCM.fillMenu(MCM.iCurrentNameFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.iCurrentNameFadeoutChoice = currentVar as int
        
            if MCM.iCurrentNameFadeoutChoice == 0
                WC.fNameFadeoutDuration = 3.0 ;Slow
            elseIf MCM.iCurrentNameFadeoutChoice == 1
                WC.fNameFadeoutDuration = 1.5 ;Normal
            elseIf MCM.iCurrentNameFadeoutChoice == 2
                WC.fNameFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[MCM.iCurrentNameFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_nameFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The duration in seconds of the names fade out animation\nSetting this to zero will make the text hide instantly after the delays set above\nDefault duration = 1.5 seconds")
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
