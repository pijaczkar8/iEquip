Scriptname iEquip_MCM_htk extends iEquip_MCM_helperfuncs

iEquip_KeyHandler Property KH Auto

string[] utilityKeyDoublePressOptions
int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP

    utilityKeyDoublePressOptions = new String[4]
    utilityKeyDoublePressOptions[0] = "Disabled"
    utilityKeyDoublePressOptions[1] = "Queue Menu"
    utilityKeyDoublePressOptions[2] = "Edit Mode"
    utilityKeyDoublePressOptions[3] = "MCM"
endFunction

function drawPage()
    MCM.AddTextOptionST("htk_txt_htkHelp", "Show hotkey help", "")
        
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Main Hotkeys")
    MCM.AddKeyMapOptionST("htk_key_leftHand", "Left Hand Hotkey", KH.iEquip_leftKey, mcmUnmapFLAG)
    MCM.AddKeyMapOptionST("htk_key_rightHand", "Right Hand Hotkey", KH.iEquip_rightKey, mcmUnmapFLAG)
    MCM.AddKeyMapOptionST("htk_key_shout", "Shout Hotkey", KH.iEquip_shoutKey, mcmUnmapFLAG)
    MCM.AddKeyMapOptionST("htk_key_consumPoison", "Consumable/Poison Hotkey", KH.iEquip_consumableKey, mcmUnmapFLAG)
            
    MCM.AddHeaderOption("Utility Hotkey Options")
    MCM.AddKeyMapOptionST("htk_key_util", "Utility Hotkey", KH.iEquip_utilityKey, mcmUnmapFLAG)
    MCM.AddMenuOptionST("htk_men_utilDubPress", "Utility key double press", utilityKeyDoublePressOptions[KH.utilityKeyDoublePress])
    MCM.AddToggleOptionST("htk_tgl_utilCompat", "Quickmenu Compatibility", !KH.bNormalSystemPageBehav)

    MCM.SetCursorPosition(1)
            
    ;These are just so the right side lines up nicely with the left!
    MCM.AddEmptyOption()
    MCM.AddEmptyOption()
    
    MCM.AddHeaderOption("Key Press Options")
    MCM.AddSliderOptionST("htk_sld_multiTapDelay", "Multi-Tap Delay", KH.multiTapDelay, "{1} seconds")
    MCM.AddSliderOptionST("htk_sld_longPrsDelay", "Long Press Delay", KH.longPressDelay, "{1} seconds")
    MCM.AddSliderOptionST("htk_sld_prsHoldDelay", "Press & Hold Delay", KH.pressAndHoldDelay, "{1} seconds")
endFunction

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
            KH.iEquip_leftKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(KH.iEquip_leftKey)
        elseIf currentEvent == "Default"
            KH.iEquip_leftKey = 47 
            MCM.SetKeyMapOptionValueST(KH.iEquip_leftKey)
        endIf
    endEvent
endState

State htk_key_rightHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the right hand widget functions\nDefault: B")
        elseIf currentEvent == "Change"
            KH.iEquip_rightKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(KH.iEquip_rightKey)
        elseIf currentEvent == "Default"
            KH.iEquip_rightKey = 48 
            MCM.SetKeyMapOptionValueST(KH.iEquip_rightKey)
        endIf
    endEvent
endState

State htk_key_shout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the shout widget functions\nDefault: Y")
        elseIf currentEvent == "Change"
            KH.iEquip_shoutKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(KH.iEquip_shoutKey)
        elseIf currentEvent == "Default"
            KH.iEquip_shoutKey = 45 
            MCM.SetKeyMapOptionValueST(KH.iEquip_shoutKey)
        endIf
    endEvent
endState

State htk_key_consumPoison
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select a hotkey to control the consumable and poison widgets functions\nDefault: X")
        elseIf currentEvent == "Change"
            KH.iEquip_consumableKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(KH.iEquip_consumableKey)
        elseIf currentEvent == "Default"
            KH.iEquip_consumableKey = 21
            MCM.SetKeyMapOptionValueST(KH.iEquip_consumableKey)
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
            KH.iEquip_utilityKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
            MCM.SetKeyMapOptionValueST(KH.iEquip_utilityKey)
        elseIf currentEvent == "Default"
            KH.iEquip_utilityKey = 69
            MCM.SetKeyMapOptionValueST(KH.iEquip_utilityKey)
        endIf
    endEvent
endState

State htk_men_utilDubPress
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(KH.utilityKeyDoublePress, utilityKeyDoublePressOptions, 0)
        elseIf currentEvent == "Accept"
            KH.utilityKeyDoublePress = currentVar as int
            MCM.SetMenuOptionValueST(utilityKeyDoublePressOptions[KH.utilityKeyDoublePress])
        endIf
    endEvent
endState

State htk_tgl_utilCompat
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable this if you have \"Stay at System Page\" installed\nDefault: Off")
        elseIf currentEvent == "Select"
            KH.bNormalSystemPageBehav = !KH.bNormalSystemPageBehav
            MCM.SetToggleOptionValueST(!KH.bNormalSystemPageBehav)
        elseIf currentEvent == "Default"
            KH.bNormalSystemPageBehav = true 
            MCM.SetToggleOptionValueST(!KH.bNormalSystemPageBehav)
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
            fillSlider(KH.multiTapDelay, 0.2, 1.0, 0.1, 0.3)
        elseIf currentEvent == "Accept"
            KH.multiTapDelay = currentVar
            MCM.SetSliderOptionValueST(KH.multiTapDelay, "{1} seconds")
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
            fillSlider(KH.longPressDelay, 0.3, 1.5, 0.1, 0.5)
        elseIf currentEvent == "Accept"
            KH.longPressDelay = currentVar
            MCM.SetSliderOptionValueST(KH.longPressDelay, "{1} seconds")
        endIf
    endEvent
endState

State htk_sld_prsHoldDelay
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("This defines the length of time you need to hold a key down for for it to register as Press & Hold for actions like toggling Preselect and Equip All Preselected Items\n"+\
                            "Make sure there is enough difference between this and the Long Press Delay setting to avoid key presses being misinterpreted.\nDefault: 1.0 seconds")
        elseIf currentEvent == "Open"
            fillSlider(KH.pressAndHoldDelay, 0.6, 2.0, 0.1, 1.0)
        elseIf currentEvent == "Accept"
            KH.pressAndHoldDelay = currentVar
            MCM.SetSliderOptionValueST(KH.pressAndHoldDelay, "{1} seconds")
        endIf
    endEvent
endState