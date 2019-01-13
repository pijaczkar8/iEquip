Scriptname iEquip_MCM_rep extends iEquip_MCM_Page

iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_WidgetCore Property WC Auto

string[] chargeDisplayOptions
string[] meterFillDirectionOptions
int[] meterFillDirection
string[] poisonMessageOptions
string[] poisonIndicatorOptions

; #############
; ### SETUP ###

function initData()
    chargeDisplayOptions = new String[3]
    chargeDisplayOptions[0] = "Hidden"
    chargeDisplayOptions[1] = "Charge Meters"
    chargeDisplayOptions[2] = "Dynamic Soulgem"

    meterFillDirectionOptions = new String[3]
    meterFillDirectionOptions[0] = "left"
    meterFillDirectionOptions[1] = "right"
    meterFillDirectionOptions[2] = "both"

    meterFillDirection = new int[2]
    meterFillDirection[0] = 1
    meterFillDirection[1] = 0

    poisonMessageOptions = new String[3]
    poisonMessageOptions[0] = "Show All"
    poisonMessageOptions[1] = "Top-up & Switch"
    poisonMessageOptions[2] = "Don't show"
    
    poisonIndicatorOptions = new String[4]
    poisonIndicatorOptions[0] = "Count Only"
    poisonIndicatorOptions[1] = "Single Drop & Count"
    poisonIndicatorOptions[2] = "Single Drop"
    poisonIndicatorOptions[3] = "Multiple Drops"
endFunction

function drawPage()
    if MCM.bEnabled
        MCM.AddTextOptionST("rep_txt_showEnchRechHelp", "Show Enchantment Recharging Help", "")
        MCM.AddToggleOptionST("rep_tgl_enblEnchRech", "Enable enchanted weapon recharging", RC.bRechargingEnabled)
        MCM.AddEmptyOption()
                
        if RC.bRechargingEnabled
            MCM.AddHeaderOption("Soulgem Use Options")
            MCM.AddToggleOptionST("rep_tgl_useLargSoul", "Use largest available soul", RC.bUseLargestSoul)
            MCM.AddToggleOptionST("rep_tgl_useOvrsizSoul", "Use oversized souls", RC.bAllowOversizedSouls)
            MCM.AddToggleOptionST("rep_tgl_usePartGem", "Use partially filled gems", RC.bUsePartFilledGems)
                    
            MCM.AddHeaderOption("Widget Options")
            MCM.AddMenuOptionST("rep_men_showEnchCharge", "Charge displayed as", chargeDisplayOptions[CM.iChargeDisplayType])
            if CM.iChargeDisplayType > 0
                MCM.AddToggleOptionST("rep_tgl_enableChargeFadeout", "Enable enchantment charge fadeout", CM.bChargeFadeoutEnabled)
                if CM.bChargeFadeoutEnabled
                    MCM.AddSliderOptionST("rep_sld_chargeFadeDelay", "Fadeout delay", CM.fChargeFadeoutDelay, "Fade after {1} secs")
                endIf
                
                MCM.AddColorOptionST("rep_col_normFillCol", "Normal charge fill colour", CM.iPrimaryFillColor)
                MCM.AddToggleOptionST("rep_tgl_enableCustomFlashCol", "Enable custom flash colour", CM.bCustomFlashColor)
                if CM.bCustomFlashColor
                    MCM.AddColorOptionST("rep_col_meterFlashCol", "Empty warning flash colour", CM.iFlashColor)
                endIf
                
                MCM.AddToggleOptionST("rep_tgl_changeColLowCharge", "Change colour on low charge", CM.bEnableLowCharge)
                if CM.bEnableLowCharge
                    MCM.AddSliderOptionST("rep_sld_setLowChargeTresh", "Set low charge threshold", CM.fLowChargeThreshold*100, "{0}%")
                    MCM.AddColorOptionST("rep_col_lowFillCol", "Low charge fill colour", CM.iLowChargeFillColor)
                endIf
                
                if CM.iChargeDisplayType == 1
                    MCM.AddToggleOptionST("rep_tgl_enableGradientFill", "Enable gradient fill", CM.bEnableGradientFill)
                    if CM.bEnableGradientFill
                        MCM.AddColorOptionST("rep_col_gradFillCol", "Gradient (low) fill colour", CM.iSecondaryFillColor)
                    endIf
                    
                    MCM.AddMenuOptionST("rep_men_leftFillDir", "Left meter fill direction", meterFillDirectionOptions[meterFillDirection[0]])
                    MCM.AddMenuOptionST("rep_men_rightFillDir", "Right meter fill direction", meterFillDirectionOptions[meterFillDirection[1]])
                endIf
            endIf
        endIf

        MCM.SetCursorPosition(1)
                
        if !WC.bPoisonsEnabled
            MCM.AddEmptyOption()
            MCM.AddTextOption("Poisoning features are currently disabled.", "")
            MCM.AddTextOption("If you wish to use the poisoning features", "")
            MCM.AddTextOption("please re-enable the Poison Widget in the", "")
            MCM.AddTextOption("General Settings page", "")
         else
            MCM.AddTextOptionST("rep_txt_showPoisonHelp", "Show Poisoning Help", "")
                   
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("Poison Use Options")
            MCM.AddMenuOptionST("rep_men_confMsg", "Confirmation messages", poisonMessageOptions[WC.iShowPoisonMessages])
            MCM.AddToggleOptionST("rep_tgl_allowPoisonSwitch", "Allow poison switching", WC.bAllowPoisonSwitching)
            MCM.AddToggleOptionST("rep_tgl_allowPoisonTopup", "Allow poison top-up", WC.bAllowPoisonTopUp)
                    
            MCM.AddHeaderOption("Poison Charge Options")
            MCM.AddSliderOptionST("rep_sld_chargePerVial", "Charges per vial", WC.iPoisonChargesPerVial, "{0} charges")
            MCM.AddSliderOptionST("rep_sld_chargeMult", "Charge Multiplier", WC.iPoisonChargeMultiplier, "{0}x base charges")
                    
            MCM.AddHeaderOption("Widget Options")
            MCM.AddMenuOptionST("rep_men_poisonIndStyle", "Poison indicator style", poisonIndicatorOptions[WC.iPoisonIndicatorStyle])
        endIf
    endIf
endFunction

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
            RC.bRechargingEnabled = !RC.bRechargingEnabled
        elseIf currentEvent == "Default"
            RC.bRechargingEnabled = true
        endIf

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
            MCM.SetInfoText("Disabling this will stop you from wasting souls which are larger than the charge required to completely refill the weapon")
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
            MCM.SetInfoText("To support GIST - Genuinely Intelligent Soul Trap by opusGlass you can stop iEquip from using partially filled gems allowing GIST to continue filling them")
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
            MCM.SetInfoText("Choose how you would like the enchantment charge for equipped weapons to be displayed in the widget\nCharge Meters - show custom enchantment charge level meters in the widget\n"+\
                "Dynamic Soulgems - show dynamic soulgem icons in the widget which change fill level to indicate the current level of enchantment charge\nVanilla HUD enchantment charge meters will be hidden")
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
            MCM.SetInfoText("With this setting enabled the charge meters will show on equipping an enchanted weapon, but will fade out after the delay set below\nAdditionally you can choose whether to re-show on entering combat or when the current charge is below the low charge threshold if set below.\nDefault: Disabled")
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
            MCM.SetInfoText("Set the delay in seconds before the enchantment bars fade out")
        elseIf currentEvent == "Open"
            MCM.fillSlider(CM.fChargeFadeoutDelay, 1.0, 20.0, 0.5, 5.0)
        elseIf currentEvent == "Accept"
            CM.fChargeFadeoutDelay = currentVar
            MCM.SetSliderOptionValueST(CM.fChargeFadeoutDelay, "Fade after {1} secs")
        endIf 
    endEvent
endState

State rep_col_normFillCol
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Set the regular fill colour for the enchantment charge meters in the widget")
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
            MCM.SetInfoText("When your weapon enchantment charge runs out the meter or soulgem will flash a warning. By default this will match whatever you have set as your fill colour. Enabling this setting allows you to instead set a custom flash color\nDefault: Disabled")
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
            MCM.SetInfoText("Set a custom colour for the warning flash that displays when the charge on the equipped weapon runs out")
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
            MCM.SetInfoText("Enables a gradient colour fill in the enchantment bars from regular fill (full) to secondary fill (empty)")
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
            MCM.SetInfoText("Set the secondary fill colour (only used when gradient fill is enabled)")
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
            MCM.SetInfoText("Allows the enchantment charge bars to change colour when the charge falls below the level specified below")
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
            MCM.SetInfoText("Set the level below which you would like the enchantment bars to change colour")
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
            MCM.SetInfoText("Set the low charge fill colour for the enchantment charge meters in the widget")
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
            MCM.SetInfoText("Choose the fill direction for the left enchantment charge meter\nRight Fill means the full is right, empty is left.  And vice versa for Left Fill\n"+\
                            "Centre Fill means the meter will fill from the centre outwards in both directions\nDefault: Left Fill")
        elseIf currentEvent == "Open"
            MCM.fillMenu(meterFillDirection[0], meterFillDirectionOptions, 0)
        elseIf currentEvent == "Accept"
            meterFillDirection[0] = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[meterFillDirection[0]])
            CM.asMeterFillDirection[0] = meterFillDirectionOptions[meterFillDirection[0]]
            CM.bSettingsChanged = true
        endIf 
    endEvent
endState

State rep_men_rightFillDir
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the fill direction for the right enchantment charge meter\nRight Fill means the full is right, empty is left.  And vice versa for Left Fill\n"+\
                            "Centre Fill means the meter will fill from the centre outwards in both directions\nDefault: Right Fill")
        elseIf currentEvent == "Open"
            MCM.fillMenu(meterFillDirection[1], meterFillDirectionOptions, 1)
        elseIf currentEvent == "Accept"
            meterFillDirection[1] = currentVar as int
            MCM.SetMenuOptionValueST(meterFillDirectionOptions[meterFillDirection[1]])
            CM.asMeterFillDirection[1] = meterFillDirectionOptions[meterFillDirection[1]]
            CM.bSettingsChanged = true
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
            MCM.SetInfoText("With this enabled, if the weapon you are dosing is already poisoned with a different poison you will be given the option to remove the current poison before applying the new one. "+\
                            "Otherwise you will need to use up the existing poison before applying a new one\nDefault - On")
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
            MCM.SetInfoText("With this enabled, if the weapon you are dosing is already poisoned with the same poison you will be given the option to top up the current poison. "+\
                            "If you choose to do so the doses will stack. As with the Charges Per Vial and Multiplier settings it is entirely up to you how you wish to balance or break your game.\nDefault - Off")
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
            MCM.SetInfoText("Allows you to set the number of charges per vial/application. Use with discretion!\nDefault: Single charge per application (vanilla)")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargesPerVial, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargesPerVial = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargesPerVial, "{0} charges per vial")
        endIf 
    endEvent
endState

State rep_sld_chargeMult
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allows you to adjust iEquip poison dosing to match any perk overhauls you may be using which affect the Concentrated Poison perk or add new perks which multiply the number of charges per application. "+\
                            "If left set at 1 iEquip will check whether the player has the Concentrated Poison perk and apply the vanilla x2 multiplier if you do.\nDefault: 1x (vanilla)")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iPoisonChargeMultiplier, 1.0, 5.0, 1.0, 1.0)
        elseIf currentEvent == "Accept"
            WC.iPoisonChargeMultiplier = currentVar as int
            MCM.SetSliderOptionValueST(WC.iPoisonChargeMultiplier, "{0}x charges")
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
            MCM.fillMenu(WC.iPoisonIndicatorStyle, poisonIndicatorOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iPoisonIndicatorStyle = currentVar as int
            MCM.SetMenuOptionValueST(poisonIndicatorOptions[WC.iPoisonIndicatorStyle])
            WC.bPoisonIndicatorStyleChanged = true
        endIf 
    endEvent
endState
