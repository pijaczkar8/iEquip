Scriptname iEquip_MCM_gen extends iEquip_MCM_helperfuncs

iEquip_WidgetCore Property WC Auto
iEquip_KeyHandler Property KH Auto
iEquip_AmmoMode Property AM Auto

sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] ammoSortingOptions
string[] whenNoAmmoLeftOptions

; #############
; ### SETUP ###

function initData()
    ammoSortingOptions = new String[4]
    ammoSortingOptions[0] = "Unsorted"
    ammoSortingOptions[1] = "By damage"
    ammoSortingOptions[2] = "Alphabetically"
    ammoSortingOptions[3] = "By quantity"

    whenNoAmmoLeftOptions = new String[4]
    whenNoAmmoLeftOptions[0] = "Do nothing"
    whenNoAmmoLeftOptions[1] = "Switch/Do nothing"
    whenNoAmmoLeftOptions[2] = "Switch/Cycle"
    whenNoAmmoLeftOptions[3] = "Cycle right hand"
endFunction

function drawPage()
    MCM.AddToggleOptionST("gen_tgl_onOff", "iEquip On/Off", MCM.bEnabled)
           
    if !MCM.bIsFirstEnabled && MCM.bEnabled
        if bStillToEnableProMode
            MCM.AddTextOptionST("gen_txt_dragEastr", "", "Here be dragons...")
        else
            MCM.AddToggleOptionST("gen_tgl_enblProMode", "Enable Pro Mode features", WC.bProModeEnabled)
        endIf
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("Widget Options")
        MCM.AddToggleOptionST("gen_tgl_enblShoutSlt", "Enable shout slot", WC.bShoutEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblConsumSlt", "Enable consumables slot", WC.bConsumablesEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblPoisonSlt", "Enable poisons slot", WC.bPoisonsEnabled)
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("Visible Gear Options")
        MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "Enable All Geared Up", WC.bEnableGearedUp)
        MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "Auto Unequip Ammo", WC.bUnequipAmmo)

        MCM.SetCursorPosition(1)
                
        MCM.AddHeaderOption("Cycling behaviour")
        MCM.AddToggleOptionST("gen_tgl_eqpPaus", "Equip on pause", WC.bEquipOnPause)
                
        if WC.bEquipOnPause
            MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "Equip on pause delay", WC.fEquipOnPauseDelay, "{1} seconds")
        endIf
                
        MCM.AddToggleOptionST("gen_tgl_showAtrIco", "Show attribute icons", WC.bShowAttributeIcons)
        MCM.AddMenuOptionST("gen_men_ammoLstSrt", "Ammo list sorting", ammoSortingOptions[AM.iAmmoListSorting])
        MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "When no ammo left", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
        if WC.findInQueue(1, "Unarmed") == -1
            MCM.AddTextOptionST("gen_txt_addFists", "Add 'Unarmed' shortcut to right queue", "")
        endIf
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
                ;MCM.ShowMessage("Please exit out of the Journal Menu, then re-open the iEquip MCM to complete the installation", False, "OK")
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
                WC.bProModeEnabled = true
                ;MCM.ShowMessage("Please exit out of the Journal Menu, then re-open the iEquip MCM to finish enabling Pro Mode", False, "OK")
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
            WC.bProModeEnabled = !WC.bProModeEnabled
            MCM.SetToggleOptionValueST(WC.bProModeEnabled)
        elseIf currentEvent == "Default"
            MCM.ShowMessage("iEquip Pro Mode disabled!\n\nYou have just disabled iEquip Pro Mode.\n"+\ 
                            "The MCM will now restart.", false, "OK")
            WC.bProModeEnabled = false 
            MCM.KH.bQuickShieldEnabled = false
            WC.bQuickDualCastEnabled = false
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
            WC.bShoutEnabled = !WC.bShoutEnabled
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bShoutEnabled = true 
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblConsumSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the consumable slot in the widget. Also disables the consume item feature.\n"+\
                            "You can still choose to have the poison slot enabled even if the consumable slot is disabled.\nDefault: Enabled")
        elseIf currentEvent == "Select"
            WC.bConsumablesEnabled = !WC.bConsumablesEnabled
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bConsumablesEnabled = true 
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable the poison slot in the widget. Also disables all poisoning features.\n"+\
                            "If you have disabled the consumable slot then you can cycle the your poisons with a single press rather than a double press\nDefault: Enabled")
        elseIf currentEvent == "Select"
            WC.bPoisonsEnabled = !WC.bPoisonsEnabled
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bPoisonsEnabled = true 
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
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
            WC.bEnableGearedUp = !WC.bEnableGearedUp
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        elseIf currentEvent == "Default"
            WC.bEnableGearedUp = true 
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        endIf
    endEvent
endState

State gen_tgl_autoUnqpAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("When enabled any currently equipped ammo will be unequipped when you no longer have a ranged weapon equipped, "+\
                            "removing the quiver from your character when not wielding a bow or crossbow.\nDefault: On")
        elseIf currentEvent == "Select"
            WC.bUnequipAmmo = !WC.bUnequipAmmo
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
        elseIf currentEvent == "Default"
            WC.bUnequipAmmo = true 
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
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
            WC.bEquipOnPause = !WC.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            fillSlider(WC.fEquipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            WC.fEquipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fEquipOnPauseDelay, "{1} seconds")
        endIf
    endEvent
endState

State gen_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show small icons indicating item is poisoned and/or enchanted next to the item icons in the main left and right slots whilst cycling, "+\
                            "and in the left and right preselect slots when Preselect Mode is active.")
        elseIf currentEvent == "Select"
            WC.bShowAttributeIcons = !WC.bShowAttributeIcons
            MCM.SetToggleOptionValueST(WC.bShowAttributeIcons)
            WC.bAttributeIconsOptionChanged = true
        endIf
    endEvent
endState

State gen_men_ammoLstSrt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("iEquip curates lists of arrows and bolts currently in your inventory and updates them whenever ammo is added or removed. "+\
                            "You can optionally choose to have the resultant list sorted by damage, alphabetically or by current quantity. "+\
                            "If you choose to sort by damage you will always equip your strongest ammo first, and if by quantity you will equip the ammo you have the most of first.\nDefault = By Damage")
        elseIf currentEvent == "Open"
            fillMenu(AM.iAmmoListSorting, ammoSortingOptions, 0)
        elseIf currentEvent == "Accept"
            AM.iAmmoListSorting = currentVar as int
            MCM.SetMenuOptionValueST(ammoSortingOptions[AM.iAmmoListSorting])
            WC.bAmmoSortingChanged = true
        endIf
    endEvent
endState

State gen_men_whenNoAmmoLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose what happens when you use up your last piece of ammo for an equipped ranged weapon\n "+\
                            "Do Nothing - The left slot will remain empty waiting for you to find and pick up some suitable ammo\n"+\
                            "Switch/Do Nothing - Equip an alternative ranged weapon if you have the correct ammo for it, otherwise do nothing\n"+\
                            "Switch/Cycle - As above, but if no suitable alternative found iEquip will cycle as detailed below\n"+\
                            "Cycle - Cycle your right hand, or if you are currently QuickRanged and have enabled Switch Out do that\nDefault = Switch / Cycle")
        elseIf currentEvent == "Open"
            fillMenu(AM.iActionOnLastAmmoUsed, whenNoAmmoLeftOptions, 2)
        elseIf currentEvent == "Accept"
            AM.iActionOnLastAmmoUsed = currentVar as int
            MCM.SetMenuOptionValueST(whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
        endIf
    endEvent
endState

State gen_txt_addFists
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Add the 'Unarmed' shortcut back into your right hand queue. Cycling to this will unequip both hands, for whenever you just feel like a good old-fashioned punch-up!")
        elseIf currentEvent == "Select"
            WC.addFists()
            MCM.forcePageReset()
        endIf
    endEvent
endState
