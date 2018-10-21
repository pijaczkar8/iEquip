Scriptname iEquip_MCM_gen extends iEquip_MCM_helperfuncs

sound property UILevelUp auto

int proModeEasterEggCounter = 5

; ########################
; ### General Settings ###
; ########################

State gen_tgl_onOff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Turn iEquip ON or OFF here\nDefault: OFF")
        elseIf currentEvent == "Select"
            MCM.bEnabled = !MCM.bEnabled
            if MCM.isFirstEnabled
                MCM.ShowMessage("Welcome to iEquip\n\nThank you for installing iEquip\nMCM wil now close and reopen.", false, "OK")
                MCM.justEnabled = true
                MCM.isFirstEnabled = false
                MCM.restartingMCM = true
                MCM.KH.CloseAndReopeniEquipMCM()
            else
                MCM.forcePageReset()
            endIf
        elseIf currentEvent == "Default"
            MCM.bEnabled = false 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_tgl_enblEditMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable Edit Mode to allow real time editing of the widget layout\n"+\
                            "To access edit mode press your Utility Key and select Edit Mode from the Utility Menu\nDefault = True")
        elseIf currentEvent == "Select"
            MCM.bEditModeEnabled = !MCM.bEditModeEnabled
            MCM.SetToggleOptionValueST(MCM.bEditModeEnabled)
        elseIf currentEvent == "Default"
            MCM.bEditModeEnabled = true 
            MCM.SetToggleOptionValueST(MCM.bEditModeEnabled)
        endIf
    endEvent
endState

State gen_txt_dragEastr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("??????")
        elseIf currentEvent == "Select"
            if proModeEasterEggCounter >= 0
                string msg
            
                if proModeEasterEggCounter == 5
                    msg = "Wait, what are you doing..."
                elseIf proModeEasterEggCounter == 4
                    msg = "You're not seriously going in there?"
                elseIf proModeEasterEggCounter == 3
                    msg = "Are you out of your mind?"
                elseIf proModeEasterEggCounter == 2
                    msg = "I really don't think you should..."
                elseIf proModeEasterEggCounter == 1
                    msg = "Do you EVER listen?"
                elseIf proModeEasterEggCounter == 0
                    msg = "Fine, have it your way..."
                endIf
                
                MCM.SetTextOptionValueST(msg)
                proModeEasterEggCounter -= 1
            else
                ; Wohoo, let's play an epic tune
                UILevelUp.Play(MCM.PlayerRef)
                MCM.ShowMessage("iEquip Pro Mode unlocked!\n\nYour dogged determination has paid off, friend. "+\
                "You now have access to everything iEquip has to offer.  Now stand back while we restart the iEquip MCM and reveal your rewards...", false, "OK")
                MCM.stillToEnableProMode = false
                MCM.bProModeEnabled = true
                MCM.restartingMCM = true
                MCM.KH.CloseAndReopeniEquipMCM()
            endIf
        endIf
    endEvent
endState

State gen_tgl_enblProMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling Pro Mode unlocks many additional features and options including Preselect Mode, "+\
                            "QuickShield and QuickDualCast\nDefault = Off")
        elseIf currentEvent == "Select"
            MCM.bProModeEnabled = !MCM.bProModeEnabled
            MCM.SetToggleOptionValueST(MCM.bProModeEnabled)
        elseIf currentEvent == "Default"
            MCM.ShowMessage("iEquip Pro Mode disabled!\n\nYou have just disabled iEquip Pro Mode.\n"+\ 
                            "The MCM will now restart.", false, "OK")
            MCM.bProModeEnabled = false 
            MCM.bQuickShieldEnabled = false
            MCM.bQuickDualCastEnabled = false
            MCM.restartingMCM = true
            MCM.KH.CloseAndReopeniEquipMCM()
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State gen_tgl_enblShoutSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the shout slot in the widget\nDefault: Enabled")
        elseIf currentEvent == "Select"
            MCM.WC.shoutEnabled = !MCM.WC.shoutEnabled
            MCM.SetToggleOptionValueST(MCM.WC.shoutEnabled)
            MCM.slotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.shoutEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.shoutEnabled)
            MCM.slotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblConsumSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the consumable slot in the widget. Also disables the consume item feature.\n"+\
                            "You can still choose to have the poison slot enabled even if the consumable slot is disabled.\nDefault: Enabled")
        elseIf currentEvent == "Select"
            MCM.WC.consumablesEnabled = !MCM.WC.consumablesEnabled
            MCM.SetToggleOptionValueST(MCM.WC.consumablesEnabled)
            MCM.slotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.consumablesEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.consumablesEnabled)
            MCM.slotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the poison slot in the widget. Also disables all poisoning features.\n"+\
                            "If you have disabled the consumable slot then you can cycle the your poisons with a single press rather than a double press\nDefault: Enabled")
        elseIf currentEvent == "Select"
            MCM.WC.poisonsEnabled = !MCM.WC.poisonsEnabled
            MCM.SetToggleOptionValueST(MCM.WC.poisonsEnabled)
            MCM.slotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.poisonsEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.poisonsEnabled)
            MCM.slotEnabledOptionsChanged = true
        endIf
    endEvent
endState

; ------------------------
; - Visible Gear Options -
; ------------------------        

State gen_tgl_enblAllGeard
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enables the vanilla Geared Up feature which is disabled by default. This allows you to display favorited items on your character when not equipped. "+\
                            "iEquip uses the same methods as Equipping Overhaul and Visible Favorited Items as workrounds to the bugs with the vanilla implementation.\nDefault: Off")
        elseIf currentEvent == "Select"
            MCM.bEnableGearedUp = !MCM.bEnableGearedUp
            MCM.SetToggleOptionValueST(MCM.bEnableGearedUp)
            MCM.gearedUpOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.bEnableGearedUp = true 
            MCM.SetToggleOptionValueST(MCM.bEnableGearedUp)
            MCM.gearedUpOptionChanged = true
        endIf
    endEvent
endState

State gen_tgl_autoUnqpAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("When enabled any currently equipped ammo will be unequipped when you no longer have a ranged weapon equipped, "+\
                            "removing the quiver from your character when not wielding a bow or crossbow.\nDefault: On")
        elseIf currentEvent == "Select"
            MCM.bUnequipAmmo = !MCM.bUnequipAmmo
            MCM.SetToggleOptionValueST(MCM.bUnequipAmmo)
        elseIf currentEvent == "Default"
            MCM.bUnequipAmmo = true 
            MCM.SetToggleOptionValueST(MCM.bUnequipAmmo)
        endIf
    endEvent
endState

; ---------------------
; - Cycling Behaviour -
; ---------------------

State gen_tgl_eqpPaus
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With Equip On Pause enabled you can cycle through as many items as you like until you find what you want. Only once you stop cycling will the selected item equip after the delay set below.\n"+\
                            "If you disable Equip On Pause each time you cycle a slot the item will be equipped immediately which can make cycling through quite tedious.\nDefault: ON")
        elseIf currentEvent == "Select"
            MCM.bEquipOnPause = !MCM.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            fillSlider(MCM.equipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            MCM.equipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.equipOnPauseDelay, "{1} seconds")
        endIf
    endEvent
endState

State gen_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show small icons indicating item is poisoned and/or enchanted next to the item icons in the main left and right slots whilst cycling, "+\
                            "and in the left and right preselect slots when Preselect Mode is active.")
        elseIf currentEvent == "Select"
            MCM.bShowAttributeIcons = !MCM.bShowAttributeIcons
            MCM.SetToggleOptionValueST(MCM.bShowAttributeIcons)
            MCM.bAttributeIconsOptionChanged = true
        endIf
    endEvent
endState

State gen_men_ammoLstSrt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("iEquip scans you inventory each time you equip a ranged weapon and updates the list of ammo as required depending on the type of weapon being equipped. "+\
                            "You can optionally choose to have the resultant list sorted by damage, alphabetically or by current quantity. "+\
                            "If you choose to sort by damage you will always equip your strongest ammo first, and if by quantity you will equip the ammo you have the most of first.\nDefault = Unsorted")
        elseIf currentEvent == "Open"
            fillMenu(MCM.AmmoListSorting, MCM.ammoSortingOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.AmmoListSorting = currentVar as int
            MCM.SetMenuOptionValueST(MCM.ammoSortingOptions[MCM.AmmoListSorting])
            MCM.ammoSortingChanged = true
        endIf
    endEvent
endState

State gen_tgl_skpCurItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("In regular cycling you can land back on your currently equipped item to keep it equipped. "+\
                            "With this setting enabled the currently equipped item is skipped when cycling meaning that once you start cycling you are committed to changing item.\nDefault - Off")
        elseIf currentEvent == "Select"
            MCM.bSkipCurrentItemWhenCycling = !MCM.bSkipCurrentItemWhenCycling
            MCM.SetToggleOptionValueST(MCM.bSkipCurrentItemWhenCycling)
        elseIf currentEvent == "Default"
            MCM.bSkipCurrentItemWhenCycling = false
            MCM.SetToggleOptionValueST(MCM.bSkipCurrentItemWhenCycling)
        endIf
    endEvent
endState
