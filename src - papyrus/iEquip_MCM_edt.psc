Scriptname iEquip_MCM_edt extends iEquip_MCM_Page

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
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddHeaderOption("$iEquip_MCM_edt_lbl_EMOptions")
        MCM.AddSliderOptionST("edt_sld_slowTimeStr", "$iEquip_MCM_edt_lbl_slowTimeStr", iEquip_EditModeSlowTimeStrength.GetValueint())
                
        MCM.SetCursorPosition(1)               
        MCM.AddHeaderOption("")
        MCM.AddMenuOptionST("edt_men_chooseHtKey", "$iEquip_MCM_edt_lbl_chooseHtKey", EMKeysChoice[MCM.iCurrentEMKeysChoice])
                
        if(MCM.iCurrentEMKeysChoice == 1)
            MCM.AddEmptyOption()
            MCM.AddKeyMapOptionST("edt_key_nextElem", "$iEquip_MCM_edt_lbl_nextElem", KH.iEditNextKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_prevElem", "$iEquip_MCM_edt_lbl_prevElem", KH.iEditPrevKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_moveUp", "$iEquip_MCM_edt_lbl_moveUp", KH.iEditUpKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_moveDown", "$iEquip_MCM_edt_lbl_moveDown", KH.iEditDownKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_moveLeft", "$iEquip_MCM_edt_lbl_moveLeft", KH.iEditLeftKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_moveRight", "$iEquip_MCM_edt_lbl_moveRight", KH.iEditRightKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_sclUp", "$iEquip_MCM_edt_lbl_sclUp", KH.iEditScaleUpKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_sclDown", "$iEquip_MCM_edt_lbl_sclDown", KH.iEditScaleDownKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_rotate", "$iEquip_MCM_edt_lbl_rotate", KH.iEditRotateKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_adjTransp", "$iEquip_MCM_edt_lbl_adjTransp", KH.iEditAlphaKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_bringFrnt", "$iEquip_MCM_edt_lbl_bringFrnt", KH.iEditDepthKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_setTxtAlCo", "$iEquip_MCM_edt_lbl_setTxtAlCo", KH.iEditTextKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_tglRulers", "$iEquip_MCM_edt_lbl_tglRulers", KH.iEditRulersKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_rstSelElem", "$iEquip_MCM_edt_lbl_rstSelElem", KH.iEditResetKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_loadPrst", "$iEquip_common_LoadPreset", KH.iEditLoadPresetKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_savePrst", "$iEquip_common_SavePreset", KH.iEditSavePresetKey, mcmUnmapFLAG)
            MCM.AddKeyMapOptionST("edt_key_discChangs", "$iEquip_common_DiscardChanges", KH.iEditDiscardKey, mcmUnmapFLAG)
        endIf
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
            MCM.SetInfoText("$iEquip_MCM_edt_txt_slowTimeStr")
        elseIf currentEvent == "Open"
            MCM.fillSlider(iEquip_EditModeSlowTimeStrength.GetValue(), 0.0, 100.0, 10.0, 100.0)
        elseIf currentEvent == "Accept"
            MCM.SetSliderOptionValueST(currentVar)
            iEquip_EditModeSlowTimeStrength.SetValue(currentVar)
        endIf 
    endEvent
endState

State edt_men_chooseHtKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_edt_txt_chooseHtKey")
        elseIf currentEvent == "Open"
            MCM.fillMenu(MCM.iCurrentEMKeysChoice, EMKeysChoice, 0)
        elseIf currentEvent == "Accept"
            MCM.iCurrentEMKeysChoice = currentVar as int
            
            if MCM.iCurrentEMKeysChoice == 0
                KH.resetEditModeKeys()
                MCM.bUpdateKeyMaps = true
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
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditNextKey = currentVar as int
            else
                KH.iEditNextKey = 55
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditNextKey)
        endIf
    endEvent
endState

State edt_key_prevElem
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditPrevKey = currentVar as int
            else
                KH.iEditPrevKey = 181
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditPrevKey)        
        endIf
    endEvent
endState

State edt_key_moveUp
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditUpKey = currentVar as int
            else
                KH.iEditUpKey = 200
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditUpKey)      
        endIf
    endEvent
endState

State edt_key_moveDown
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditDownKey = currentVar as int
            else
                KH.iEditDownKey = 208
            endIf

            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditDownKey)
        endIf
    endEvent
endState

State edt_key_moveLeft
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditLeftKey = currentVar as int
            else
                KH.iEditLeftKey = 203
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditLeftKey)   
        endIf
    endEvent
endState

State edt_key_moveRight
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditRightKey = currentVar as int
            else
                KH.iEditRightKey = 205
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditRightKey)
        endIf
    endEvent
endState

State edt_key_sclUp
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditScaleUpKey = currentVar as int
            else
                KH.iEditScaleUpKey = 78
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditScaleUpKey)
        endIf
    endEvent
endState

State edt_key_sclDown
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditScaleDownKey = currentVar as int
            else
                KH.iEditScaleDownKey = 74
            endIf
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditScaleDownKey)
        endIf
    endEvent
endState

State edt_key_rotate
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditRotateKey = currentVar as int
            else
                KH.iEditRotateKey = 80
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditRotateKey)
        endIf
    endEvent
endState

State edt_key_adjTransp
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditAlphaKey = currentVar as int
            else
                KH.iEditAlphaKey = 81
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditAlphaKey)
        endIf
    endEvent
endState

State edt_key_bringFrnt
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditDepthKey = currentVar as int
            else
                KH.iEditDepthKey = 72
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditDepthKey)
        endIf
    endEvent
endState

State edt_key_setTxtAlCo
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditTextKey = currentVar as int
            else
                KH.iEditTextKey = 79
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditTextKey)
        endIf
    endEvent
endState

State edt_key_tglRulers
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditRulersKey = currentVar as int
            else
                KH.iEditRulersKey = 77
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditRulersKey)
        endIf
    endEvent
endState

State edt_key_rstSelElem
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditResetKey = currentVar as int
            else
                KH.iEditResetKey = 82
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditResetKey)
        endIf
    endEvent
endState

State edt_key_loadPrst
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditLoadPresetKey = currentVar as int
            else
                KH.iEditLoadPresetKey = 75
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditLoadPresetKey)
        endIf
    endEvent
endState

State edt_key_savePrst
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditSavePresetKey = currentVar as int
            else
                KH.iEditSavePresetKey = 76
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditSavePresetKey)
        endIf
    endEvent
endState

State edt_key_discChangs
    event OnBeginState()
        if currentEvent == "Change" || "Default"
            if currentEvent == "Change"
                KH.iEditDiscardKey = currentVar as int
            else
                KH.iEditDiscardKey = 83
            endIf 
            
            MCM.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iEditDiscardKey)
        endIf
    endEvent
endState
