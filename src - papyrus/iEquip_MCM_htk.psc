Scriptname iEquip_MCM_htk extends iEquip_MCM_helperfuncs

; ######################
; ### Hotkey Options ###
; ######################

State htk_txt_htkHelp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Show a full description of what actions are available on each hotkey")
        elseIf currentEvent == "Select"
            bool bKeepReading
    
            if MCM.bProModeEnabled
                bKeepReading = MCM.ShowMessage("Left/Right Hotkeys in Regular Mode\n\nSingle Press - Cycle queue forwards\nSingle Press with Utility Key held - Cycle queue backwards\n"+\
                                               "Double Press - Apply current poison\nTriple Press - Recharge enchanted item\nPress and hold - Enable Preselect Mode\n\n"+\
                                               "Left/Right Hotkeys in Preselect Mode\n\nSingle Press - Cycle preselect queue forwards\n"+\
                                               "Single Press with Utility Key held - Cycle preselect queue backwards\nLongpress - Equip preselected item\n"+\
                                               "Press and hold - Equip all preselected items\n\nPage 1/4",  true, "Next page", "Exit")
                if bKeepReading 
                    bKeepReading = MCM.ShowMessage("Shout Hotkey in Regular Mode\n\nSingle Press - Cycle queue forwards\nSingle Press with Utility Key held - Cycle queue backwards\nPress and hold - Open queue management menu\n\n"+\
                                                   "Shout Hotkey in Preselect Mode\n\nSingle Press - Cycle preselect queue forwards\nSingle Press with Utility Key held - Cycle preselect queue backwards\n"+\
                                                   "Longpress - Equip preselected shout/power\n\nPage 2/4",  true, "Next page", "Exit")
                    if bKeepReading
                        bKeepReading = MCM.ShowMessage("Consumable/Poison Hotkey\n\nSingle Press - Cycle consumable queue forwards\nSingle Press with Utility Key held - Cycle consumable queue backwards\n"+\
                                                       "Press and hold - Consume current potion/food/drink\n\nDouble Press - Cycle poison queue forwards\n"+\
                                                       "Double Press with Utility Key held - Cycle poison queue backwards\n\nConsumable/Poison Hotkey in Preselect Mode\n\n"+\
                                                       "Press and hold - Exit Preselect Mode\n\nPage 3/4", true, "Next page", "Exit")
                    endIf
                endIf
            else
                bKeepReading = MCM.ShowMessage("Left/Right Hotkeys in Regular Mode\n\nSingle Press - Cycle queue forwards\nSingle Press with Utility Key held - Cycle queue backwards\n"+\
                                               "Double Press - Apply current poison\nTriple Press - Recharge enchanted item\n\nPage 1/4",  true, "Next page", "Exit")
                if bKeepReading
                    bKeepReading = MCM.ShowMessage("Shout Hotkey in Regular Mode\n\nSingle Press - Cycle queue forwards\n"+\
                                                   "Single Press with Utility Key held - Cycle queue backwards\n\nPage 2/4",  true, "Next page", "Exit")
                    if bKeepReading
                        bKeepReading = MCM.ShowMessage("Consumable/Poison Hotkey\n\nSingle Press - Cycle consumable queue forwards\nSingle Press with Utility Key held - Cycle consumable queue backwards\n"+\
                                                       "Press and hold - Consume current potion/food/drink\n\nDouble Press - Cycle poison queue forwards\n"+\
                                                       "Double Press with Utility Key held - Cycle poison queue backwards\n\nPage 3/4", true, "Next page", "Exit")
                    endIf
                endIf
            endIf
            
            if bKeepReading
                if MCM.bEditModeEnabled
                    MCM.ShowMessage("Utility Hotkey\n\nSingle Press - Open Queue Management Menu\n\nDouble Press - Toggle Edit Mode\n\n"+\
                                    "Triple Press - Direct access to the iEquip MCM\n\nPage 4/4", false, "Exit")
                else
                    MCM.ShowMessage("Utility Hotkey\n\nSingle Press - Open Queue Management Menu\n\n"+\
                                    "Triple Press - Direct access to the iEquip MCM\n\nPage 4/4", false, "Exit")
                endIf
            endIf 
        endIf
    endEvent
endState

; ----------------
; - Main Hotkeys -
; ----------------

State htk_key_leftHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the left hand widget functions\nDefault: V")
        elseIf currentEvent == "Change"
            MCM.KH.iEquip_leftKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_leftKey)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_leftKey = 47 
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_leftKey)
        endIf
    endEvent
endState

State htk_key_rightHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the right hand widget functions\nDefault: B")
        elseIf currentEvent == "Change"
            MCM.KH.iEquip_rightKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_rightKey)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_rightKey = 48 
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_rightKey)
        endIf
    endEvent
endState

State htk_key_shout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the shout widget functions\nDefault: Y")
        elseIf currentEvent == "Change"
            MCM.KH.iEquip_shoutKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_shoutKey)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_shoutKey = 45 
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_shoutKey)
        endIf
    endEvent
endState

State htk_key_consumPoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the consumable and poison widgets functions\nDefault: X")
        elseIf currentEvent == "Change"
            MCM.KH.iEquip_consumableKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_consumableKey)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_consumableKey = 21
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_consumableKey)
        endIf
    endEvent
endState
        
; --------------------------
; - Utility Hotkey Options -
; --------------------------

State htk_key_util
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey for accessing various menus and modes\nDefault: NumLock")
        elseIf currentEvent == "Change"
            MCM.KH.iEquip_utilityKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_utilityKey)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_utilityKey = 69
            MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_utilityKey)
        endIf
    endEvent
endState

State htk_men_utilDubPress
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.utilityKeyDoublePress, MCM.utilityKeyDoublePressOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.utilityKeyDoublePress = currentVar as int
            MCM.SetMenuOptionValueST(MCM.utilityKeyDoublePressOptions[MCM.utilityKeyDoublePress])
        endIf
    endEvent
endState

; ---------------------
; - Key Press Options -
; ---------------------

State htk_sld_multiTapDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("This defines the maximum delay there can be between key presses for them to register as a multi-tap (double/triple press)\n"+\
                            "Set this to the minimum time in which you can comfortably execute a multi-tap\nDefault: 0.3 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.KH.multiTapDelay, 0.2, 1.0, 0.1, 0.3)
        elseIf currentEvent == "Accept"
            MCM.KH.multiTapDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.KH.multiTapDelay, "{1} seconds")
        endIf
    endEvent
endState

State htk_sld_longPrsDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("This defines the length of time you need to hold a key down for for it to register as a Long Press\n"+\
                            "This does not conflict with the multi-tap setting so set it to whatever you are comfortable with, "+\
                            "but not so short that every key press is classed as a Long Press!\nDefault: 0.5 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.KH.longPressDelay, 0.3, 1.5, 0.1, 0.5)
        elseIf currentEvent == "Accept"
            MCM.KH.longPressDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.KH.longPressDelay, "{1} seconds")
        endIf
    endEvent
endState

State htk_sld_prsHoldDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("This defines the length of time you need to hold a key down for for it to register as Press & Hold for actions like toggling Preselect and Equip All Preselected Items\n"+\
                            "Make sure there is enough difference between this and the Long Press Delay setting to avoid key presses being misinterpreted.\nDefault: 1.0 seconds")
        elseIf currentEvent == "Open"
            fillSlider(MCM.KH.pressAndHoldDelay, 0.6, 2.0, 0.1, 1.0)
        elseIf currentEvent == "Accept"
            MCM.KH.pressAndHoldDelay = currentVar
            MCM.SetSliderOptionValueST(MCM.KH.pressAndHoldDelay, "{1} seconds")
        endIf
    endEvent
endState
