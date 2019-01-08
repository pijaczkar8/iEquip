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
    EMKeysChoice[0] = "$iEquip_common_Default"
    EMKeysChoice[1] = "$iEquip_common_Custom"
endFunction

function drawPage()
    MCM.AddHeaderOption("$iEquip_MCM_edt_lbl_EMOptions")
    MCM.AddSliderOptionST("edt_sld_slowTimeStr", "$iEquip_MCM_edt_lbl_slowTimeStr", iEquip_EditModeSlowTimeStrength.GetValueint())
            
    MCM.SetCursorPosition(1)
            
    MCM.AddHeaderOption("")
    MCM.AddEmptyOption()
    MCM.AddMenuOptionST("edt_men_chooseHtKey", "$iEquip_MCM_edt_lbl_chooseHtKey", EMKeysChoice[MCM.iCurrentEMKeysChoice])
            
    if(MCM.iCurrentEMKeysChoice == 1)
        MCM.AddEmptyOption()
        MCM.AddKeyMapOptionST("edt_key_nextElem", "Next element", KH.iEditNextKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_prevElem", "Previous element", KH.iEditPrevKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveUp", "Move up", KH.iEditUpKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveDown", "Move down", KH.iEditDownKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveLeft", "Move left", KH.iEditLeftKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_moveRight", "Move right", KH.iEditRightKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_sclUp", "Scale up", KH.iEditScaleUpKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_sclDown", "Scale down", KH.iEditScaleDownKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_rotate", "Rotate", KH.iEditRotateKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_adjTransp", "Adjust transparency", KH.iEditAlphaKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_bringFrnt", "Bring to front", KH.iEditDepthKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_setTxtAlCo", "Set text alignment and colour", KH.iEditTextKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_tglRulers", "Toggle rulers", KH.iEditRulersKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_rstSelElem", "Reset selected element", KH.iEditResetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_loadPrst", "$iEquip_common_LoadPreset", KH.iEditLoadPresetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_savePrst", "$iEquip_common_SavePreset", KH.iEditSavePresetKey, mcmUnmapFLAG)
        MCM.AddKeyMapOptionST("edt_key_discChangs", "$iEquip_common_DiscardChanges", KH.iEditDiscardKey, mcmUnmapFLAG)
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

State edt_men_chooseHtKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose to use the recommended Edit Mode hotkeys or set your own")
        elseIf currentEvent == "Open"
            fillMenu(MCM.iCurrentEMKeysChoice, EMKeysChoice, 0)
        elseIf currentEvent == "Accept"
            MCM.iCurrentEMKeysChoice = currentVar as int
            
            if MCM.iCurrentEMKeysChoice == 0
                KH.resetEditModeKeys()
            endIf
            
            MCM.SetMenuOptionValueST(EMKeysChoice[MCM.iCurrentEMKeysChoice])
        endIf 
    endEvent
endState

; ------------------
; - Edit Mode Keys -
; ------------------

State edt_key_nextElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditNextKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditNextKey = 55
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditNextKey)
    endEvent
endState

State edt_key_prevElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditPrevKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditPrevKey = 181
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditPrevKey)        
    endEvent
endState

State edt_key_moveUp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditUpKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditUpKey = 200
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditUpKey)        
    endEvent
endState

State edt_key_moveDown
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditDownKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditDownKey = 208
        endIf

        MCM.SetKeyMapOptionValueST(KH.iEditDownKey)        
    endEvent
endState

State edt_key_moveLeft
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditLeftKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditLeftKey = 203
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditLeftKey)        
    endEvent
endState

State edt_key_moveRight
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditRightKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditRightKey = 205
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditRightKey)        
    endEvent
endState

State edt_key_sclUp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditScaleUpKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditScaleUpKey = 78
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditScaleUpKey)
    endEvent
endState

State edt_key_sclDown
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditScaleDownKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditScaleDownKey = 74
        endIf
        
        MCM.SetKeyMapOptionValueST(KH.iEditScaleDownKey)
    endEvent
endState

State edt_key_rotate
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditRotateKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditRotateKey = 80
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditRotateKey)
    endEvent
endState

State edt_key_adjTransp
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditAlphaKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditAlphaKey = 81
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditAlphaKey)
    endEvent
endState

State edt_key_bringFrnt
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditDepthKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditDepthKey = 72
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditDepthKey)
    endEvent
endState

State edt_key_setTxtAlCo
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditTextKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditTextKey = 79
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditTextKey)
    endEvent
endState

State edt_key_tglRulers
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditRulersKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditRulersKey = 77
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditRulersKey)
    endEvent
endState

State edt_key_rstSelElem
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditResetKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditResetKey = 82
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditResetKey)
    endEvent
endState

State edt_key_loadPrst
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditLoadPresetKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditLoadPresetKey = 75
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditLoadPresetKey)
    endEvent
endState

State edt_key_savePrst
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditSavePresetKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditSavePresetKey = 76
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditSavePresetKey)
    endEvent
endState

State edt_key_discChangs
    event OnBeginState()
        if currentEvent == "Change"
            KH.iEditDiscardKey = currentVar as int
            KH.updateKeyMaps()
        elseIf currentEvent == "Default"
            KH.iEditDiscardKey = 83
        endIf 
        
        MCM.SetKeyMapOptionValueST(KH.iEditDiscardKey)
    endEvent
endState
