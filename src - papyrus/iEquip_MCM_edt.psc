Scriptname iEquip_MCM_edt extends iEquip_MCM_helperfuncs

; ######################
; ### Initialization ###
; ######################

; #################
; ### Edit Mode ###
; #################

; ---------------------
; - Edit Mode Options -
; ---------------------

State edt_sld_slowTimeStr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("iEquip Edit Mode runs with the game unpaused so to avoid unneccessary death or injury while you set things up we apply a slow time effect. "+\
                            "This slider lets you set how much time slows by in Edit Mode\nDefault is 100% or fully paused, at 0 time passes normally in Edit Mode")
        elseIf currentEvent == "Open"
            fillSlider(MCM.iEquip_EditModeSlowTimeStrength.GetValue(), 0.0, 100.0, 10.0, 100.0)
        elseIf currentEvent == "Accept"
            MCM.SetSliderOptionValueST(currentVar)
            MCM.iEquip_EditModeSlowTimeStrength.SetValue(currentVar)
        endIf 
    endEvent
endState

State edt_tgl_enblBringFrnt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Bring To Front feature in Edit Mode allows you to rearrange the layer order of overlapping widget elements\n"+\
                            "Disabled by default as adds a short delay when switching presets and toggling Edit Mode")
        elseIf currentEvent == "Select"
            MCM.EM.bringToFrontEnabled = !MCM.EM.bringToFrontEnabled
            MCM.SetToggleOptionValueST(MCM.EM.bringToFrontEnabled)
        elseIf currentEvent == "Default"
            MCM.EM.bringToFrontEnabled = false
            MCM.SetToggleOptionValueST(MCM.EM.bringToFrontEnabled)
        endIf 
    endEvent
endState

State edt_men_chooseHtKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose to use the recommended Edit Mode hotkeys or set your own")
        elseIf currentEvent == "Open"
            fillMenu(MCM.currentEMKeysChoice, MCM.EMKeysChoice, 0)
        elseIf currentEvent == "Accept"
            MCM.currentEMKeysChoice = currentVar as int
            
            if MCM.currentEMKeysChoice == 0
                MCM.KH.resetEditModeKeys()
            endIf
            
            MCM.SetMenuOptionValueST(MCM.EMKeysChoice[MCM.currentEMKeysChoice])
        endIf 
    endEvent
endState

; ------------------
; - Edit Mode Keys -
; ------------------
updateKeyMaps
State edt_key_nextElem
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditNextKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditNextKey = 55
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditNextKey)
    endEvent
endState

State edt_key_prevElem
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditPrevKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditPrevKey = 181
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditPrevKey)        
    endEvent
endState

State edt_key_moveUp
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditUpKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditUpKey = 200
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditUpKey)        
    endEvent
endState

State edt_key_moveDown
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditDownKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditDownKey = 208
        endIf

        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditDownKey)        
    endEvent
endState

State edt_key_moveLeft
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditLeftKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditLeftKey = 203
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditLeftKey)        
    endEvent
endState

State edt_key_moveRight
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditRightKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditRightKey = 205
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditRightKey)        
    endEvent
endState

State edt_key_sclUp
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditScaleUpKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditScaleUpKey = 78
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditScaleUpKey)
    endEvent
endState

State edt_key_sclDown
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditScaleDownKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditScaleDownKey = 74
        endIf
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditScaleDownKey)
    endEvent
endState

State edt_key_rotate
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditRotateKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditRotateKey = 80
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditRotateKey)
    endEvent
endState

State edt_key_adjTransp
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditAlphaKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditAlphaKey = 81
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditAlphaKey)
    endEvent
endState

State edt_key_bringFrnt
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditDepthKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditDepthKey = 72
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditDepthKey)
    endEvent
endState

State edt_key_setTxtAlCo
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditTextKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditTextKey = 79
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditTextKey)
    endEvent
endState

State edt_key_tglRulers
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditRulersKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditRulersKey = 77
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditRulersKey)
    endEvent
endState

State edt_key_rstSelElem
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditResetKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditResetKey = 82
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditResetKey)
    endEvent
endState

State edt_key_loadPrst
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditLoadPresetKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditLoadPresetKey = 75
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditLoadPresetKey)
    endEvent
endState

State edt_key_savePrst
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditSavePresetKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditSavePresetKey = 76
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditSavePresetKey)
    endEvent
endState

State edt_key_discChangs
    event OnBeginState()
        if currentEvent == "Change"
            MCM.KH.iEquip_EditDiscardKey = currentVar as int
            MCM.KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            MCM.KH.iEquip_EditDiscardKey = 83
        endIf 
        
        MCM.SetKeyMapOptionValueST(MCM.KH.iEquip_EditDiscardKey)
    endEvent
endState
