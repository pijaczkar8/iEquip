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
            MCM.bRechargingEnabled = !MCM.bRechargingEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bRechargingEnabled = true
            MCM.forcePageReset()
        endIf 
    endEvent
endState

; -----------------------
; - Soulgem Use Options -
; -----------------------

State rep_tgl_useLargSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select whether to use the largest soul that will fit into the weapon, or to use up your smaller souls first.")
        elseIf currentEvent == "Select"
            MCM.bUseLargestSoul = !MCM.bUseLargestSoul
            MCM.SetToggleOptionValueST(MCM.bUseLargestSoul)
        elseIf currentEvent == "Default"
            MCM.bUseLargestSoul = true
            MCM.SetToggleOptionValueST(MCM.bUseLargestSoul)
        endIf 
    endEvent
endState

State rep_tgl_useOvrsizSoul
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Disabling this will stop you from wasting souls which are larger than the charge required to completely refill the weapon")
        elseIf currentEvent == "Select"
            MCM.bAllowOversizedSouls = !MCM.bAllowOversizedSouls
            MCM.SetToggleOptionValueST(MCM.bAllowOversizedSouls)
        elseIf currentEvent == "Default"
            MCM.bAllowOversizedSouls = false
            MCM.SetToggleOptionValueST(MCM.bAllowOversizedSouls)
        endIf 
    endEvent
endState

State rep_tgl_usePartGem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("To support GIST - Genuinely Intelligent Soul Trap by opusGlass you can stop iEquip from using partially filled gems allowing GIST to continue filling them")
        elseIf currentEvent == "Select"
            MCM.bUsePartFilledGems = !MCM.bUsePartFilledGems
            MCM.SetToggleOptionValueST(MCM.bUsePartFilledGems)
        elseIf currentEvent == "Default"
            MCM.bUsePartFilledGems = false
            MCM.SetToggleOptionValueST(MCM.bUsePartFilledGems)
        endIf 
    endEvent
endState

; ------------------
; - Widget Options -
; ------------------

State rep_tgl_showEnchCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show custom enchantment charge level meters in the widget.  Please not that iEquip disables the vanilla HUD enchantment charge meters")
        elseIf currentEvent == "Select"
            MCM.bShowChargeMeters = !MCM.bShowChargeMeters
            MCM.SetToggleOptionValueST(MCM.bShowChargeMeters)
            MCM.enchantmentDisplayOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.bShowChargeMeters = true
            MCM.SetToggleOptionValueST(MCM.bShowChargeMeters)
        endIf 
    endEvent
endState

State rep_tgl_showDynGemIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show dynamic soulgem icons in the widget which change fill level to indicate the current level of enchantment charge")
        elseIf currentEvent == "Select"
            MCM.bShowDynamicSoulgem = !MCM.bShowDynamicSoulgem
            MCM.SetToggleOptionValueST(MCM.bShowDynamicSoulgem)
            MCM.enchantmentDisplayOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.bShowDynamicSoulgem = true
            MCM.SetToggleOptionValueST(MCM.bShowDynamicSoulgem)
        endIf 
    endEvent
endState

State rep_col_normFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the regular fill colour for the enchantment charge meters in the widget")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(MCM.meterFillColor)
            MCM.SetColorDialogDefaultColor(0x8c9ec2)
        elseIf currentEvent == "Accept"
            MCM.meterFillColor = currentVar as int
            MCM.SetColorOptionValueST(MCM.meterFillColor)
            MCM.enchantmentDisplayOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.meterFillColor = 0x8c9ec2
            MCM.SetColorOptionValueST(MCM.meterFillColor)
        endIf 
    endEvent
endState

State rep_tgl_changeColLowCharge
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allows the enchantment charge bars to change colour when the charge falls below the level specified below")
        elseIf currentEvent == "Select"
            MCM.bEnableLowCharge = !MCM.bEnableLowCharge
            MCM.SetToggleOptionValueST(MCM.bEnableLowCharge)
            MCM.enchantmentDisplayOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.bEnableLowCharge = true
            MCM.SetToggleOptionValueST(MCM.bAllowPoisonTopUp)
        endIf 
    endEvent
endState

State rep_sld_setLowChargeTresh
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the level below which you would like the enchantment bars to change colour")
        elseIf currentEvent == "Open"
            fillSlider(MCM.lowChargeThreshold, 5.0, 50.0, 5.0, 20.0)
        elseIf currentEvent == "Accept"
            MCM.lowChargeThreshold = currentVar
            MCM.SetSliderOptionValueST(MCM.lowChargeThreshold, "{0}%")
        endIf 
    endEvent
endState

State rep_col_lowFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the low charge fill colour for the enchantment charge meters in the widget")
        elseIf currentEvent == "Open"
            MCM.SetColorDialogStartColor(MCM.lowChargeFillColor)
            MCM.SetColorDialogDefaultColor(0xFF0000)
        elseIf currentEvent == "Accept"
            MCM.lowChargeFillColor = currentVar as int
            MCM.SetColorOptionValueST(MCM.lowChargeFillColor)
            MCM.enchantmentDisplayOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.lowChargeFillColor = 0xFF0000
            MCM.SetColorOptionValueST(MCM.lowChargeFillColor)
        endIf 
    endEvent
endState

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
