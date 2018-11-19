Scriptname iEquip_MCM_rep extends iEquip_MCM_helperfuncs

; ##############################
; ### Recharging & Poisoning ###
; ##############################

State rep_txt_showEnchRechHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("Recharging enchanted items in iEquip\n\nLong press the left or right hotkeys to recharge the enchanted weapon in that hand. iEquip will then pick the most appropriate soul to use based on your settings below, "+\
                               "such as whether you want to use the largest soul that will fit or use up smaller souls first, or if you want to stop iEquip from using souls which are larger than needed to fully recharge the weapon\n\nPage 1/2", true, "Next Page", "Exit")
                MCM.ShowMessage("Recharging enchanted items in iEquip\n\niEquip supports GIST by opusGlass so you also have the option of not using partially filled gems.\n\n"+\
                                "You also have the option of how the current charge is displayed in the widget with customizable meters and/or a dynamic soul gem icon with various levels of fill\n\nPage 2/2", false, "Exit")
            endIf
        endIf 
    endEvent
endState

State rep_tgl_enblEnchRech
    event OnBeginState()
        if currentEvent == "Select"
            MCM.RC.bRechargingEnabled = !MCM.RC.bRechargingEnabled
        elseIf currentEvent == "Default"
            MCM.RC.bRechargingEnabled = true
        endIf
        if MCM.RC.bRechargingEnabled
            MCM.flag_rep_rechargingEnabled = MCM.OPTION_FLAG_NONE
        else
            MCM.flag_rep_rechargingEnabled = MCM.OPTION_FLAG_DISABLED
        endIf
        ;/MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_useLargSoul")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_useOvrsizSoul")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_usePartGem")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_men_showEnchCharge")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_enableChargeFadeout")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_sld_chargeFadeDelay")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_col_normFillCol")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_enableCustomFlashCol")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_col_meterFlashCol")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_changeColLowCharge")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_sld_setLowChargeTresh")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_col_lowFillCol")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_tgl_enableGradientFill")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_col_gradFillCol")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_men_leftFillDir")
        MCM.SetOptionFlagsST(MCM.flag_rep_rechargingEnabled, true, "rep_men_rightFillDir")/;
        MCM.forcePageReset()
    endEvent
endState

; -----------------------
; - Soulgem Use Options -
; -----------------------

State rep_tgl_useLargSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select whether to use the largest soul that will fit into the weapon, or to use up your smaller souls first.")
        else
            If currentEvent == "Select"
                MCM.RC.bUseLargestSoul = !MCM.RC.bUseLargestSoul
            elseIf currentEvent == "Default"
                MCM.RC.bUseLargestSoul = true
            endIf
            MCM.SetToggleOptionValueST(MCM.RC.bUseLargestSoul)
        endIf 
    endEvent
endState

State rep_tgl_useOvrsizSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Disabling this will stop you from wasting souls which are larger than the charge required to completely refill the weapon")
        else
            If currentEvent == "Select"
                MCM.RC.bAllowOversizedSouls = !MCM.RC.bAllowOversizedSouls
            elseIf currentEvent == "Default"
                MCM.RC.bAllowOversizedSouls = false
            endIf
            MCM.SetToggleOptionValueST(MCM.RC.bAllowOversizedSouls)
        endIf 
    endEvent
endState

State rep_tgl_usePartGem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("To support GIST - Genuinely Intelligent Soul Trap by opusGlass you can stop iEquip from using partially filled gems allowing GIST to continue filling them")
        else
            If currentEvent == "Select"
                MCM.RC.bUsePartFilledGems = !MCM.RC.bUsePartFilledGems
            elseIf currentEvent == "Default"
                MCM.RC.bUsePartFilledGems = false
            endIf
            MCM.SetToggleOptionValueST(MCM.RC.bUsePartFilledGems)
        endIf 
    endEvent
endState

; ------------------
; - Widget Options -
; ------------------

State rep_men_showEnchCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose how you would like the enchantment charge for equipped weapons to be displayed in the widget\nCharge Meters - show custom enchantment charge level meters in the widget\n"+\
                "Dynamic Soulgems - show dynamic soulgem icons in the widget which change fill level to indicate the current level of enchantment charge\nVanilla HUD enchantment charge meters will be hidden")
        elseIf currentEvent == "Open"
            fillMenu(MCM.CM.chargeDisplayType, MCM.chargeDisplayOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.CM.chargeDisplayType = currentVar as int
            MCM.SetMenuOptionValueST(MCM.chargeDisplayOptions[MCM.CM.chargeDisplayType])
            if MCM.CM.chargeDisplayType == 2 && MCM.CM.enableGradientFill
                MCM.CM.enableGradientFill = false
            endIf
            if MCM.CM.chargeDisplayType == 0
                MCM.flag_rep_chargeDisplayEnabled = MCM.OPTION_FLAG_DISABLED
            else
                MCM.flag_rep_chargeDisplayEnabled = MCM.OPTION_FLAG_NONE
            endIf
            ;/MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_tgl_enableChargeFadeout")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_sld_chargeFadeDelay")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_col_normFillCol")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_tgl_enableCustomFlashCol")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_col_meterFlashCol")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_tgl_changeColLowCharge")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_sld_setLowChargeTresh")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_col_lowFillCol")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_tgl_enableGradientFill")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_col_gradFillCol")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_men_leftFillDir")
            MCM.SetOptionFlagsST(MCM.flag_rep_chargeDisplayEnabled, true, "rep_men_rightFillDir")/;
            MCM.CM.settingsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State rep_tgl_enableChargeFadeout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this setting enabled the charge meters will show on equipping an enchanted weapon, but will fade out after the delay set below\nAdditionally you can choose whether to re-show on entering combat or when the current charge is below the low charge threshold if set below.\nDefault: Disabled")
        else
            If currentEvent == "Select"
                MCM.CM.chargeFadeoutEnabled = !MCM.CM.chargeFadeoutEnabled
            elseIf currentEvent == "Default"
                MCM.CM.chargeFadeoutEnabled = false
            endIf
            MCM.SetToggleOptionValueST(MCM.CM.chargeFadeoutEnabled)
            if MCM.CM.chargeFadeoutEnabled
                MCM.flag_rep_chargeFadeoutEnabled = MCM.OPTION_FLAG_NONE
            else
                MCM.flag_rep_chargeFadeoutEnabled = MCM.OPTION_FLAG_DISABLED
            endIf
            ;MCM.SetOptionFlagsST(MCM.flag_rep_chargeFadeoutEnabled, true, "rep_sld_chargeFadeDelay")
            MCM.CM.settingsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State rep_sld_chargeFadeDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the delay in seconds before the enchantment bars fade out")
        elseIf currentEvent == "Open"
            fillSlider(MCM.CM.chargeFadeoutDelay, 1.0, 20.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            MCM.CM.chargeFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.CM.chargeFadeoutDelay, "Fade after {1} secs")
        endIf 
    endEvent
endState

State rep_col_normFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the regular fill colour for the enchantment charge meters in the widget")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(MCM.CM.primaryFillColor)
            MCM.SetColorDialogDefaultColor(0x8c9ec2)
        else
            If currentEvent == "Accept"
                MCM.CM.primaryFillColor = currentVar as int
            elseIf currentEvent == "Default"
                MCM.CM.primaryFillColor = 0x8c9ec2
            endIf
            MCM.SetColorOptionValueST(MCM.CM.primaryFillColor)
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

State rep_tgl_enableCustomFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("When your weapon enchantment charge runs out the meter or soulgem will flash a warning. By default this will match whatever you have set as your fill colour. Enabling this setting allows you to instead set a custom flash color\nDefault: Disabled")
        else
            If currentEvent == "Select"
                MCM.CM.customFlashColor = !MCM.CM.customFlashColor
            elseIf currentEvent == "Default"
                MCM.CM.customFlashColor = false
            endIf
            MCM.SetToggleOptionValueST(MCM.CM.customFlashColor)
            if !MCM.CM.customFlashColor
                MCM.CM.flashColor = -1
            endIf
            if MCM.CM.customFlashColor
                MCM.flag_rep_customFlashColorEnabled = MCM.OPTION_FLAG_NONE
            else
                MCM.flag_rep_customFlashColorEnabled = MCM.OPTION_FLAG_DISABLED
            endIf
            ;MCM.SetOptionFlagsST(MCM.flag_rep_customFlashColorEnabled, true, "rep_col_meterFlashCol")
            MCM.CM.settingsChanged = true
            MCM.forcePageReset() 
        endIf
    endEvent
endState

State rep_col_meterFlashCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set a custom colour for the warning flash that displays when the charge on the equipped weapon runs out")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(MCM.CM.flashColor)
            MCM.SetColorDialogDefaultColor(0xFFFFFF)
        else
            If currentEvent == "Accept"
                MCM.CM.flashColor = currentVar as int
            elseIf currentEvent == "Default"
                MCM.CM.flashColor = 0xFFFFFF
            endIf
            MCM.SetColorOptionValueST(MCM.CM.flashColor)
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

State rep_tgl_enableGradientFill
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enables a gradient colour fill in the enchantment bars from regular fill (full) to secondary fill (empty)")
        else
            If currentEvent == "Select"
                MCM.CM.enableGradientFill = !MCM.CM.enableGradientFill
            elseIf currentEvent == "Default"
                MCM.CM.enableGradientFill = false
            endIf
            MCM.SetToggleOptionValueST(MCM.CM.enableGradientFill)
            if MCM.CM.enableLowCharge
                MCM.CM.enableLowCharge = false
                MCM.flag_rep_lowChargeEnabled = MCM.OPTION_FLAG_DISABLED
                ;MCM.SetOptionFlagsST(MCM.OPTION_FLAG_DISABLED, true, "rep_sld_setLowChargeTresh")
                ;MCM.SetOptionFlagsST(MCM.OPTION_FLAG_DISABLED, true, "rep_col_lowFillCol")
            endIf
            if !MCM.CM.enableGradientFill
                MCM.CM.secondaryFillColor = -1
            endIf
            if MCM.CM.enableGradientFill
                MCM.flag_rep_gradientFillEnabled = MCM.OPTION_FLAG_NONE
            else
                MCM.flag_rep_gradientFillEnabled = MCM.OPTION_FLAG_DISABLED
            endIf
            ;MCM.SetOptionFlagsST(MCM.flag_rep_gradientFillEnabled, true, "rep_col_gradFillCol")
            MCM.CM.settingsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State rep_col_gradFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the secondary fill colour (only used when gradient fill is enabled)")
        elseIf currentEvent == "Open"
            if MCM.CM.secondaryFillColor == -1
                MCM.SetColorDialogStartColor(0xee4242)
            else
                MCM.SetColorDialogStartColor(MCM.CM.secondaryFillColor)
            endIf
            MCM.SetColorDialogDefaultColor(0xee4242)
        else
            If currentEvent == "Accept"
                MCM.CM.secondaryFillColor = currentVar as int
            elseIf currentEvent == "Default"
                MCM.CM.secondaryFillColor = 0xee4242
            endIf
            MCM.SetColorOptionValueST(MCM.CM.secondaryFillColor)
            MCM.CM.settingsChanged = true
        endIf
    endEvent
endState

State rep_tgl_changeColLowCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allows the enchantment charge bars to change colour when the charge falls below the level specified below")
        else
            If currentEvent == "Select"
                MCM.CM.enableLowCharge = !MCM.CM.enableLowCharge
            elseIf currentEvent == "Default"
                MCM.CM.enableLowCharge = true
            endIf
            MCM.SetToggleOptionValueST(MCM.CM.enableLowCharge)
            if MCM.CM.enableGradientFill
                MCM.CM.enableGradientFill = false
                MCM.flag_rep_gradientFillEnabled = MCM.OPTION_FLAG_DISABLED
                ;MCM.SetOptionFlagsST(MCM.OPTION_FLAG_DISABLED, true, "rep_col_gradFillCol")
            endIf
            if MCM.CM.enableLowCharge
                MCM.flag_rep_lowChargeEnabled = MCM.OPTION_FLAG_NONE
            else
                MCM.flag_rep_lowChargeEnabled = MCM.OPTION_FLAG_DISABLED
            endIf
            ;MCM.SetOptionFlagsST(MCM.flag_rep_lowChargeEnabled, true, "rep_sld_setLowChargeTresh")
            ;MCM.SetOptionFlagsST(MCM.flag_rep_lowChargeEnabled, true, "rep_col_lowFillCol")
            MCM.CM.settingsChanged = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

State rep_sld_setLowChargeTresh
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the level below which you would like the enchantment bars to change colour")
        elseIf currentEvent == "Open"
            fillSlider(MCM.CM.lowChargeThreshold*100, 5.0, 50.0, 5.0, 20.0)
        elseIf currentEvent == "Accept"
            MCM.CM.lowChargeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(MCM.CM.lowChargeThreshold*100, "{0}%")
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

State rep_col_lowFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the low charge fill colour for the enchantment charge meters in the widget")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(MCM.CM.lowChargeFillColor)
            MCM.SetColorDialogDefaultColor(0xFF0000)
        else
            If currentEvent == "Accept"
                MCM.CM.lowChargeFillColor = currentVar as int
            elseIf currentEvent == "Default"
                MCM.CM.lowChargeFillColor = 0xFF0000
            endIf
            MCM.SetColorOptionValueST(MCM.CM.lowChargeFillColor)
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

State rep_men_leftFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the fill direction for the left enchantment charge meter\nRight Fill means the full is right, empty is left.  And vice versa for Left Fill\n"+\
                            "Centre Fill means the meter will fill from the centre outwards in both directions\nDefault: Left Fill")
        elseIf currentEvent == "Open"
            fillMenu(MCM.meterFillDirection[0], MCM.meterFillDirectionOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.meterFillDirection[0] = currentVar as int
            MCM.SetMenuOptionValueST(MCM.meterFillDirectionOptions[MCM.meterFillDirection[0]])
            MCM.CM.meterFillDirection[0] = MCM.meterFillDirectionOptions[MCM.meterFillDirection[0]]
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

State rep_men_rightFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the fill direction for the right enchantment charge meter\nRight Fill means the full is right, empty is left.  And vice versa for Left Fill\n"+\
                            "Centre Fill means the meter will fill from the centre outwards in both directions\nDefault: Right Fill")
        elseIf currentEvent == "Open"
            fillMenu(MCM.meterFillDirection[1], MCM.meterFillDirectionOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.meterFillDirection[1] = currentVar as int
            MCM.SetMenuOptionValueST(MCM.meterFillDirectionOptions[MCM.meterFillDirection[1]])
            MCM.CM.meterFillDirection[1] = MCM.meterFillDirectionOptions[MCM.meterFillDirection[1]]
            MCM.CM.settingsChanged = true
        endIf 
    endEvent
endState

; ----------------------
; -    Poison Help     -
; ----------------------

State rep_txt_showPoisonHelp
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("Applying Poisons In iEquip\n\nDouble press the left or right hotkeys to apply the currently selected poison to the weapon in that hand.\n\n"+\
                               "Has no effect in Preselect Mode, and left has no effect in Regular Mode if you have a ranged weapon equipped\n\nPage 1/3", true, "Next Page", "Exit")
                if MCM.ShowMessage("Applying Poisons In iEquip\n\nIf the weapon is already dosed with a different poison you have the option to remove the current one before applying a fresh poison.\n"+\
                                   "If the weapon is already dosed with the same poison the charges will stack\n\nPage 2/3", true, "Next Page", "Exit")
                    MCM.ShowMessage("Applying Poisons In iEquip\n\nIf the item you are poisoning was equipped by means other than iEquip the poisoning will still work and the poison widget will be updated\n\n"+\
                                    "The Charges Per Vial and Multiplier settings below are there to allow you to match poison dosing in iEquip to any other mods you may be using, "+\
                                    "or to make poisoning a more viable playstyle. Use at your discretion!\n\nPage 3/3", false, "Exit")
                endIf
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
            MCM.SetInfoText("Choose which poisoning confirmation messages to show.\nTop-up & Switch will only show messages when you apply poison to an already poisoned item.\n"+\
                            "With messages turned off iEquip will automatically top up or clean off existing poisons\nDefault: Show All")
        elseIf currentEvent == "Open"
            fillMenu(MCM.showPoisonMessages, MCM.poisonMessageOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.showPoisonMessages = currentVar as int
            MCM.SetMenuOptionValueST(MCM.poisonMessageOptions[MCM.showPoisonMessages])
        endIf 
    endEvent
endState

State rep_tgl_allowPoisonSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled, if the weapon you are dosing is already poisoned with a different poison you will be given the option to remove the current poison before applying the new one. "+\
                            "Otherwise you will need to use up the existing poison before applying a new one\nDefault - On")
        elseIf currentEvent == "Select"
            MCM.bAllowPoisonSwitching = !MCM.bAllowPoisonSwitching
            MCM.SetToggleOptionValueST(MCM.bAllowPoisonSwitching)
        elseIf currentEvent == "Default"
            MCM.bAllowPoisonSwitching = true
            MCM.SetToggleOptionValueST(MCM.bAllowPoisonSwitching)
        endIf 
    endEvent
endState

State rep_tgl_allowPoisonTopup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled, if the weapon you are dosing is already poisoned with the same poison you will be given the option to top up the current poison. "+\
                            "If you choose to do so the doses will stack. As with the Charges Per Vial and Multiplier settings it is entirely up to you how you wish to balance or break your game.\nDefault - Off")
        elseIf currentEvent == "Select"
            MCM.bAllowPoisonTopUp = !MCM.bAllowPoisonTopUp
            MCM.SetToggleOptionValueST(MCM.bAllowPoisonTopUp)
        elseIf currentEvent == "Default"
            MCM.bAllowPoisonTopUp = true
            MCM.SetToggleOptionValueST(MCM.bAllowPoisonTopUp)
        endIf 
    endEvent
endState

; -------------------------
; - Poison Charge Options -
; -------------------------

State rep_sld_chargePerVial
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allows you to set the number of charges per vial/application. Use with discretion!\nDefault: Single charge per application (vanilla)")
        elseIf currentEvent == "Open"
            fillSlider(MCM.poisonChargesPerVial, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            MCM.poisonChargesPerVial = currentVar as int
            MCM.SetSliderOptionValueST(MCM.poisonChargesPerVial, "{0} charges per vial")
        endIf 
    endEvent
endState

State rep_sld_chargeMult
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allows you to adjust iEquip poison dosing to match any perk overhauls you may be using which affect the Concentrated Poison perk or add new perks which multiply the number of charges per application. "+\
                            "If left set at 1 iEquip will check whether the player has the Concentrated Poison perk and apply the vanilla x2 multiplier if you do.\nDefault: 1x (vanilla)")
        elseIf currentEvent == "Open"
            fillSlider(MCM.poisonChargeMultiplier, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            MCM.poisonChargeMultiplier = currentVar as int
            MCM.SetSliderOptionValueST(MCM.poisonChargeMultiplier, "{0}x charges")
        endIf 
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State rep_men_poisonIndStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose how the poison charges will be displayed in the left and right slots if you have a poisoned weapon equipped.\n"+\
                            "The two count options will use the regular counter in either slot but with the count displayed in green.\nThe Multiple Drops option will display one, "+\
                            "two or three drops to match the number of remaining charges, and will display three drops and a green plus sign if more than three charges remain.\nDefault: Single Drop & Count")
        elseIf currentEvent == "Open"
            fillMenu(MCM.poisonIndicatorStyle, MCM.poisonIndicatorOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.poisonIndicatorStyle = currentVar as int
            MCM.SetMenuOptionValueST(MCM.poisonIndicatorOptions[MCM.poisonIndicatorStyle])
            MCM.poisonIndicatorStyleChanged = true
        endIf 
    endEvent
endState
