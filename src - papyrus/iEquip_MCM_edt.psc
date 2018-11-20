Scriptname iEquip_MCM_edt extends iEquip_MCM_helperfuncs

iEquip_KeyHandler Property KH Auto

GlobalVariable Property iEquip_EditModeSlowTimeStrength Auto

string[] EMKeysChoice
int mcmUnmapFLAG

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP

    EMKeysChoice = new String[2]
    EMKeysChoice[0] = "Default"
    EMKeysChoice[1] = "Custom"
endFunction

function drawPage()
    MCM.AddHeaderOption("Edit Mode Options")
    MCM.AddSliderOptionST("edt_sld_slowTimeStr", "Slow Time effect strength ", iEquip_EditModeSlowTimeStrength.GetValueint())
    MCM.AddToggleOptionST("edt_tgl_enblBringFrnt", "Enable Bring To Front", MCM.EM.bringToFrontEnabled)
            
    MCM.SetCursorPosition(1)
            
    MCM.AddHeaderOption("Edit Mode Keys")
    MCM.AddEmptyOption()
    MCM.AddMenuOptionST("edt_men_chooseHtKey", "Choose your hotkeys", EMKeysChoice[MCM.currentEMKeysChoice])
            
    if(MCM.currentEMKeysChoice == 1)
        MCM.AddEmptyOption()
        MCM.AddKeyMapOptionST("edt_key_nextElem", "Next element", KH.iEquip_EditNextKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_prevElem", "Previous element", KH.iEquip_EditPrevKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveUp", "Move up", KH.iEquip_EditUpKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveDown", "Move down", KH.iEquip_EditDownKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveLeft", "Move left", KH.iEquip_EditLeftKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveRight", "Move right", KH.iEquip_EditRightKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_sclUp", "Scale up", KH.iEquip_EditScaleUpKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_sclDown", "Scale down", KH.iEquip_EditScaleDownKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_rotate", "Rotate", KH.iEquip_EditRotateKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_adjTransp", "Adjust transparency", KH.iEquip_EditAlphaKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_bringFrnt", "Bring to front", KH.iEquip_EditDepthKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_setTxtAlCo", "Set text alignment and colour", KH.iEquip_EditTextKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_tglRulers", "Toggle rulers", KH.iEquip_EditRulersKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_rstSelElem", "Reset selected element", KH.iEquip_EditResetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_loadPrst", "Load preset", KH.iEquip_EditLoadPresetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_savePrst", "Save preset", KH.iEquip_EditSavePresetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_discChangs", "Discard changes", KH.iEquip_EditDiscardKey, mcmUnmapFLAG)
    endIf
endFunction

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
            fillSlider(iEquip_EditModeSlowTimeStrength.GetValue(), 0.0, 100.0, 10.0, 100.0)
        elseIf currentEvent == "Accept"
            MCM.SetSliderOptionValueST(currentVar)
            iEquip_EditModeSlowTimeStrength.SetValue(currentVar)
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
            fillMenu(MCM.currentEMKeysChoice, EMKeysChoice, 0)
        elseIf currentEvent == "Accept"
            MCM.currentEMKeysChoice = currentVar as int
            
            if MCM.currentEMKeysChoice == 0
                KH.resetEditModeKeys()
            endIf
            
            MCM.SetMenuOptionValueST(EMKeysChoice[MCM.currentEMKeysChoice])
        endIf 
    endEvent
endState

; ------------------
; - Edit Mode Keys -
; ------------------

State edt_key_nextElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditNextKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditNextKey = 55
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditNextKey)
    endEvent
endState

State edt_key_prevElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditPrevKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditPrevKey = 181
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditPrevKey)        
    endEvent
endState

State edt_key_moveUp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditUpKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditUpKey = 200
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditUpKey)        
    endEvent
endState

State edt_key_moveDown
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditDownKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditDownKey = 208
        endIf

        MCM.SetKeyMapOptionValueST(KH.iEquip_EditDownKey)        
    endEvent
endState

State edt_key_moveLeft
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditLeftKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditLeftKey = 203
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditLeftKey)        
    endEvent
endState

State edt_key_moveRight
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditRightKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditRightKey = 205
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditRightKey)        
    endEvent
endState

State edt_key_sclUp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditScaleUpKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditScaleUpKey = 78
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditScaleUpKey)
    endEvent
endState

State edt_key_sclDown
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditScaleDownKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditScaleDownKey = 74
        endIf
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditScaleDownKey)
    endEvent
endState

State edt_key_rotate
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditRotateKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditRotateKey = 80
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditRotateKey)
    endEvent
endState

State edt_key_adjTransp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditAlphaKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditAlphaKey = 81
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditAlphaKey)
    endEvent
endState

State edt_key_bringFrnt
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditDepthKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditDepthKey = 72
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditDepthKey)
    endEvent
endState

State edt_key_setTxtAlCo
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditTextKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditTextKey = 79
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditTextKey)
    endEvent
endState

State edt_key_tglRulers
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditRulersKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditRulersKey = 77
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditRulersKey)
    endEvent
endState

State edt_key_rstSelElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditResetKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditResetKey = 82
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditResetKey)
    endEvent
endState

State edt_key_loadPrst
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditLoadPresetKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditLoadPresetKey = 75
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditLoadPresetKey)
    endEvent
endState

State edt_key_savePrst
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditSavePresetKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditSavePresetKey = 76
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditSavePresetKey)
    endEvent
endState

State edt_key_discChangs
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEquip_EditDiscardKey = currentVar as int
            KH.updateKeyMaps(currentVar as int)
        elseIf currentEvent == "Default"
            KH.iEquip_EditDiscardKey = 83
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEquip_EditDiscardKey)
    endEvent
endState
