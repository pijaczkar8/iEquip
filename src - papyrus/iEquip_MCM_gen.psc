Scriptname iEquip_MCM_gen extends iEquip_MCM_helperfuncs

iEquip_KeyHandler Property KH Auto

sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] ammoSortingOptions

; #############
; ### SETUP ###

function initData()
    ammoSortingOptions = new String[4]
    ammoSortingOptions[0] = "Unsorted"
    ammoSortingOptions[1] = "By damage"
    ammoSortingOptions[2] = "Alphabetically"
    ammoSortingOptions[3] = "By quantity"
endFunction

function drawPage()
    MCM.AddToggleOptionST("gen_tgl_onOff", "iEquip On/Off", MCM.bEnabled)
           
    if !MCM.bIsFirstEnabled && MCM.bEnabled
        MCM.AddToggleOptionST("gen_tgl_enblEditMode", "Enable Edit Mode features", MCM.WC.bEditModeEnabled)
                
        if bStillToEnableProMode
            MCM.AddTextOptionST("gen_txt_dragEastr", "", "Here be dragons...")
        else
            MCM.AddToggleOptionST("gen_tgl_enblProMode", "Enable Pro Mode features", MCM.WC.bProModeEnabled)
        endIf
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("Widget Options")
        MCM.AddToggleOptionST("gen_tgl_enblShoutSlt", "Enable shout slot", MCM.WC.bShoutEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblConsumSlt", "Enable consumables slot", MCM.WC.bConsumablesEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblPoisonSlt", "Enable poisons slot", MCM.WC.bPoisonsEnabled)
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("Visible Gear Options")
        MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "Enable All Geared Up", MCM.WC.bEnableGearedUp)
        MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "Auto Unequip Ammo", MCM.WC.bUnequipAmmo)

        MCM.SetCursorPosition(1)
                
        MCM.AddHeaderOption("Cycling behaviour")
        MCM.AddToggleOptionST("gen_tgl_eqpPaus", "Equip on pause", MCM.WC.bEquipOnPause)
                
        if MCM.WC.bEquipOnPause
            MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "Equip on pause delay", MCM.WC.fEquipOnPauseDelay, "{1} seconds")
        endIf
                
        MCM.AddToggleOptionST("gen_tgl_showAtrIco", "Show attribute icons", MCM.WC.bShowAttributeIcons)
        MCM.AddMenuOptionST("gen_men_ammoLstSrt", "Ammo list sorting", ammoSortingOptions[MCM.AM.iAmmoListSorting])
        MCM.AddToggleOptionST("gen_tgl_skpCurItem", "Skip current item", MCM.WC.bSkipCurrentItemWhenCycling)
    endIf
endFunction

; ########################
; ### General Settings ###
; ########################

State gen_tgl_onOff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Turn iEquip ON or OFF here\nDefault: OFF")
        elseIf currentEvent == "Select"
            if MCM.bIsFirstEnabled
                KH.openiEquipMCM(true)
            else
                MCM.bEnabled = !MCM.bEnabled
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
            MCM.WC.bEditModeEnabled = !MCM.WC.bEditModeEnabled
            MCM.SetToggleOptionValueST(MCM.WC.bEditModeEnabled)
        elseIf currentEvent == "Default"
            MCM.WC.bEditModeEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.bEditModeEnabled)
        endIf
    endEvent
endState

State gen_txt_dragEastr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("??????")
        elseIf currentEvent == "Select"
            if iProModeEasterEggCounter >= 0
                string msg
            
                if iProModeEasterEggCounter == 5
                    msg = "Wait, what are you doing..."
                elseIf iProModeEasterEggCounter == 4
                    msg = "You're not seriously going in there?"
                elseIf iProModeEasterEggCounter == 3
                    msg = "Are you out of your mind?"
                elseIf iProModeEasterEggCounter == 2
                    msg = "I really don't think you should..."
                elseIf iProModeEasterEggCounter == 1
                    msg = "Do you EVER listen?"
                elseIf iProModeEasterEggCounter == 0
                    msg = "Fine, have it your way..."
                endIf
                
                MCM.SetTextOptionValueST(msg)
                iProModeEasterEggCounter -= 1
            else
                ; Wohoo, let's play an epic tune
                UILevelUp.Play(MCM.PlayerRef)
                MCM.ShowMessage("iEquip Pro Mode unlocked!\n\nYour dogged determination has paid off, friend. "+\
                "You now have access to everything iEquip has to offer.  Now stand back while we restart the iEquip MCM and reveal your rewards...", false, "OK")
                bStillToEnableProMode = false
                MCM.WC.bProModeEnabled = true

                KH.openiEquipMCM(true)
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
            MCM.WC.bProModeEnabled = !MCM.WC.bProModeEnabled
            MCM.SetToggleOptionValueST(MCM.WC.bProModeEnabled)
        elseIf currentEvent == "Default"
            MCM.ShowMessage("iEquip Pro Mode disabled!\n\nYou have just disabled iEquip Pro Mode.\n"+\ 
                            "The MCM will now restart.", false, "OK")
            MCM.WC.bProModeEnabled = false 
            MCM.KH.bQuickShieldEnabled = false
            MCM.WC.bQuickDualCastEnabled = false
            KH.openiEquipMCM(true)
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
            MCM.WC.bShoutEnabled = !MCM.WC.bShoutEnabled
            MCM.SetToggleOptionValueST(MCM.WC.bShoutEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.bShoutEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.bShoutEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblConsumSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the consumable slot in the widget. Also disables the consume item feature.\n"+\
                            "You can still choose to have the poison slot enabled even if the consumable slot is disabled.\nDefault: Enabled")
        elseIf currentEvent == "Select"
            MCM.WC.bConsumablesEnabled = !MCM.WC.bConsumablesEnabled
            MCM.SetToggleOptionValueST(MCM.WC.bConsumablesEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.bConsumablesEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.bConsumablesEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the poison slot in the widget. Also disables all poisoning features.\n"+\
                            "If you have disabled the consumable slot then you can cycle the your poisons with a single press rather than a double press\nDefault: Enabled")
        elseIf currentEvent == "Select"
            MCM.WC.bPoisonsEnabled = !MCM.WC.bPoisonsEnabled
            MCM.SetToggleOptionValueST(MCM.WC.bPoisonsEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.bPoisonsEnabled = true 
            MCM.SetToggleOptionValueST(MCM.WC.bPoisonsEnabled)
            MCM.WC.bSlotEnabledOptionsChanged = true
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
            MCM.WC.bEnableGearedUp = !MCM.WC.bEnableGearedUp
            MCM.SetToggleOptionValueST(MCM.WC.bEnableGearedUp)
            MCM.WC.bGearedUpOptionChanged = true
        elseIf currentEvent == "Default"
            MCM.WC.bEnableGearedUp = true 
            MCM.SetToggleOptionValueST(MCM.WC.bEnableGearedUp)
            MCM.WC.bGearedUpOptionChanged = true
        endIf
    endEvent
endState

State gen_tgl_autoUnqpAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("When enabled any currently equipped ammo will be unequipped when you no longer have a ranged weapon equipped, "+\
                            "removing the quiver from your character when not wielding a bow or crossbow.\nDefault: On")
        elseIf currentEvent == "Select"
            MCM.WC.bUnequipAmmo = !MCM.WC.bUnequipAmmo
            MCM.SetToggleOptionValueST(MCM.WC.bUnequipAmmo)
        elseIf currentEvent == "Default"
            MCM.WC.bUnequipAmmo = true 
            MCM.SetToggleOptionValueST(MCM.WC.bUnequipAmmo)
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
            MCM.WC.bEquipOnPause = !MCM.WC.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            fillSlider(MCM.WC.fEquipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            MCM.WC.fEquipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.WC.fEquipOnPauseDelay, "{1} seconds")
        endIf
    endEvent
endState

State gen_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show small icons indicating item is poisoned and/or enchanted next to the item icons in the main left and right slots whilst cycling, "+\
                            "and in the left and right preselect slots when Preselect Mode is active.")
        elseIf currentEvent == "Select"
            MCM.WC.bShowAttributeIcons = !MCM.WC.bShowAttributeIcons
            MCM.SetToggleOptionValueST(MCM.WC.bShowAttributeIcons)
            MCM.WC.bAttributeIconsOptionChanged = true
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
            fillMenu(MCM.AM.iAmmoListSorting, ammoSortingOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.AM.iAmmoListSorting = currentVar as int
            MCM.SetMenuOptionValueST(ammoSortingOptions[MCM.AM.iAmmoListSorting])
            MCM.WC.bAmmoSortingChanged = true
        endIf
    endEvent
endState

State gen_tgl_skpCurItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("In regular cycling you can land back on your currently equipped item to keep it equipped. "+\
                            "With this setting enabled the currently equipped item is skipped when cycling meaning that once you start cycling you are committed to changing item.\nDefault - Off")
        elseIf currentEvent == "Select"
            MCM.WC.bSkipCurrentItemWhenCycling = !MCM.WC.bSkipCurrentItemWhenCycling
            MCM.SetToggleOptionValueST(MCM.WC.bSkipCurrentItemWhenCycling)
        elseIf currentEvent == "Default"
            MCM.WC.bSkipCurrentItemWhenCycling = false
            MCM.SetToggleOptionValueST(MCM.WC.bSkipCurrentItemWhenCycling)
        endIf
    endEvent
endState
