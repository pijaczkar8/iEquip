Scriptname iEquip_MCM_ui extends iEquip_MCM_helperfuncs

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
    MCM.AddHeaderOption("Widget Options")
    MCM.AddToggleOptionST("ui_tgl_fadeLeftIco2h", "Fade left icon if 2H equipped", MCM.bFadeLeftIconWhen2HEquipped)
            
    if MCM.bFadeLeftIconWhen2HEquipped
        MCM.AddSliderOptionST("ui_sld_leftIcoFade", "Left icon fade", MCM.leftIconFadeAmount, "{0}%")
    endIf
            
    MCM.AddMenuOptionST("ui_men_ammoIcoStyle", "Ammo icon style", ammoIconOptions[MCM.ammoIconStyle])
    ;MCM.AddToggleOptionST("ui_tgl_enblWdgetBckground", "Enable widget backgrounds", EM.BackgroundsShown)
    
    ;if EM.BackgroundsShown
    ;    MCM.AddMenuOptionST("ui_men_bckgroundStyle", "Background style", backgroundStyleOptions[WC.backgroundStyle])
    ;endIf
    ;+++Disable spin on in/out animations
            
    MCM.SetCursorPosition(1)
    ;widget fade variable sliders
    MCM.AddHeaderOption("Fade Out Options")
    MCM.AddToggleOptionST("ui_tgl_enblWdgetFade", "Enable widget fadeout", MCM.WC.widgetFadeoutEnabled)
            
    if MCM.WC.widgetFadeoutEnabled
        MCM.AddSliderOptionST("ui_sld_wdgetFadeDelay", "Widget fadeout delay", MCM.widgetFadeoutDelay, "{0}")
        MCM.AddMenuOptionST("ui_men_wdgetFadeSpeed", "Widget fadeout animation speed", fadeoutOptions[MCM.currentWidgetFadeoutChoice])
                
        if (MCM.currentWidgetFadeoutChoice == 3)
            MCM.AddSliderOptionST("ui_sld_wdgetFadeDur", "Widget fadeout duration", MCM.widgetFadeoutDuration, "{1}")
        endIf
    endIf
    
    MCM.AddEmptyOption()
    MCM.AddToggleOptionST("ui_tgl_enblNameFade", "Enable name fadeouts", MCM.WC.nameFadeoutEnabled)
            
    if MCM.WC.nameFadeoutEnabled
        MCM.AddSliderOptionST("ui_sld_mainNameFadeDelay", "Main name fadeout delay", MCM.mainNameFadeoutDelay, "{1}")
        MCM.AddSliderOptionST("ui_sld_poisonNameFadeDelay", "Poison name fadeout delay", MCM.poisonNameFadeoutDelay, "{1}")
                
        if MCM.bProModeEnabled
            MCM.AddSliderOptionST("ui_sld_preselectNameFadeDelay", "Preselect name fadeout delay", MCM.preselectNameFadeoutDelay, "{1}")
        endIf
                
        MCM.AddMenuOptionST("ui_men_nameFadeSpeed", "Name fadeout animation speed", fadeoutOptions[MCM.currentNameFadeoutChoice])
                
        if (MCM.currentNameFadeoutChoice == 3)
            MCM.AddSliderOptionST("ui_sld_nameFadeDur", "Name fadeout duration", MCM.nameFadeoutDuration, "{1}")
        endIf
                
        MCM.AddMenuOptionST("ui_men_firstPressNameHidn", "First press when name hidden", firstPressIfNameHiddenOptions[MCM.WC.firstPressShowsName as int])
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
            MCM.bFadeLeftIconWhen2HEquipped = !MCM.bFadeLeftIconWhen2HEquipped
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bFadeLeftIconWhen2HEquipped = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_leftIcoFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose how much you would like the left icon faded out by.\nDefault: 70%")
        elseIf currentEvent == "Open"
            fillSlider(MCM.leftIconFadeAmount, 10.0, 80.0, 10.0, 70.0)
        elseIf currentEvent == "Accept"
            MCM.leftIconFadeAmount = currentVar
            MCM.SetSliderOptionValueST(MCM.leftIconFadeAmount, "{0}%")
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
            fillMenu(MCM.ammoIconStyle, ammoIconOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.ammoIconStyle = currentVar as int
        
            if MCM.ammoIconStyle == 0
                MCM.ammoIconSuffix = ""
            elseIf MCM.ammoIconStyle == 1
                MCM.ammoIconSuffix = "Triple"
            elseIf MCM.ammoIconStyle == 2
                MCM.ammoIconSuffix = "Quiver"
            endIf
            
            MCM.SetMenuOptionValueST(ammoIconOptions[MCM.ammoIconStyle])
            MCM.ammoIconChanged = true
        endIf 
    endEvent
endState

;/State ui_tgl_enblWdgetBckground
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enables backgrounds for each of the widgets.  Once enabled backgrounds are available in Edit Mode and can be shown, hidden and manipulated like all other elements\nDefault is Disabled")
        elseIf currentEvent == "Select"
            MCM.EM.BackgroundsShown = !MCM.EM.BackgroundsShown
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.EM.BackgroundsShown = false
            MCM.forcePageReset()
        endIf 
    endEvent
<<<<<<< HEAD
endState
/;

State ui_men_bckgroundStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the style for your slot backgrounds.\nBackgrounds can be scaled, rotated and faded in Edit Mode\nDefault: Hidden")
        elseIf currentEvent == "Open"
            fillMenu(MCM.WC.backgroundStyle, backgroundStyleOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.WC.backgroundStyle = currentVar as int
            MCM.SetMenuOptionValueST(backgroundStyleOptions[MCM.WC.backgroundStyle])
            MCM.backgroundStyleChanged = true
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
        elseIf currentEvent == "Select"
            MCM.WC.widgetFadeoutEnabled = !MCM.WC.widgetFadeoutEnabled
            MCM.fadeOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.widgetFadeoutEnabled = false 
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The time in seconds of inactivity after which the iEquip widget will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 30 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.widgetFadeoutDelay, 0.0, 180.0, 5.0, 30.0)
        elseIf currentEvent == "Accept"
            MCM.widgetFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.widgetFadeoutDelay, "{0}")
        endIf 
    endEvent
endState

State ui_men_wdgetFadeSpeed
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.currentWidgetFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.currentWidgetFadeoutChoice = currentVar as int
        
            if MCM.currentWidgetFadeoutChoice == 0
                MCM.widgetFadeoutDuration = 3.0 ;Slow
            elseIf MCM.currentWidgetFadeoutChoice == 1
                MCM.widgetFadeoutDuration = 1.5 ;Normal
            elseIf MCM.currentWidgetFadeoutChoice == 2
                MCM.widgetFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[MCM.currentWidgetFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_wdgetFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The duration in seconds of the widget fade out animation\nSetting this to zero will make the text hide instantly after the delays set above\nDefault duration = 1.5 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.widgetFadeoutDuration, 0.0, 10.0, 0.1, 1.5)
        elseIf currentEvent == "Accept"
            MCM.widgetFadeoutDuration = currentVar
            MCM.SetSliderOptionValueST(MCM.widgetFadeoutDuration, "{1}")
        endIf 
    endEvent
endState

State ui_tgl_enblNameFade
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enables fadeout of item names after cycling.  Once enabled additional fadeout options will become available to you\nDefault is Disabled")
        elseIf currentEvent == "Select"
            MCM.WC.nameFadeoutEnabled = !MCM.WC.nameFadeoutEnabled
            MCM.fadeOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.nameFadeoutEnabled = false 
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State ui_sld_mainNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The time in seconds after cycling the main slots after which the main item names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.mainNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            MCM.mainNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.mainNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_sld_poisonNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The time in seconds after cycling the main slots after which the poison names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.poisonNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            MCM.poisonNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.poisonNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_sld_preselectNameFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The time in seconds after cycling the preselect slots after which the preselect item names text will fade out\nSetting this to zero will disable the fadeout\nDefault delay = 5.0 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.preselectNameFadeoutDelay, 0.0, 30.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            MCM.preselectNameFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.preselectNameFadeoutDelay, "{1}")
        endIf 
    endEvent
endState

State ui_men_nameFadeSpeed
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The speed of the fadeout animation for the item name text\nDefault: Normal (1.5 seconds)")
        elseIf currentEvent == "Open"
            fillMenu(MCM.currentNameFadeoutChoice, fadeoutOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.currentNameFadeoutChoice = currentVar as int
        
            if MCM.currentNameFadeoutChoice == 0
                MCM.nameFadeoutDuration = 3.0 ;Slow
            elseIf MCM.currentNameFadeoutChoice == 1
                MCM.nameFadeoutDuration = 1.5 ;Normal
            elseIf MCM.currentNameFadeoutChoice == 2
                MCM.nameFadeoutDuration = 0.5 ;Fast
            endIf
            
            MCM.SetMenuOptionValueST(fadeoutOptions[MCM.currentNameFadeoutChoice])
        endIf 
    endEvent
endState

State ui_sld_nameFadeDur
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The duration in seconds of the names fade out animation\nSetting this to zero will make the text hide instantly after the delays set above\nDefault duration = 1.5 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.nameFadeoutDuration, 0.0, 10.0, 0.1, 1.5)
        elseIf currentEvent == "Accept"
            MCM.nameFadeoutDuration = currentVar
            MCM.SetSliderOptionValueST(MCM.nameFadeoutDuration, "{1}")
        endIf 
    endEvent
endState

State ui_men_firstPressNameHidn
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.WC.firstPressShowsName as int, firstPressIfNameHiddenOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.WC.firstPressShowsName = currentVar as bool
            MCM.SetMenuOptionValueST(firstPressIfNameHiddenOptions[MCM.WC.firstPressShowsName as int])
        endIf 
    endEvent
endState
