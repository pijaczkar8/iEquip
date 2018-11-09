Scriptname iEquip_MCM_helperfuncs extends quest

import UI
import Utility
import stringUtil

iEquip_MCM Property MCM Auto

string Property currentEvent Auto Hidden
float Property currentVar Auto Hidden

; ########################
; ### HELPER FUNCTIONS ###
; ########################

; ---------------
; - jumpToState -
; ---------------

function jumpToState(string stateName, string eventName, float tmpVar = -1.0)
    currentEvent = eventName
    currentVar = tmpVar
        
    GoToState(stateName)
endFunction

; -----------
; - Sliders -
; -----------

function fillSlider(float startVal, float startRange, float endRange, float intervalVal, float defaultVal)
    MCM.SetSliderDialogStartValue(startVal)
    MCM.SetSliderDialogRange(startRange, endRange)  
    MCM.SetSliderDialogInterval(intervalVal)
    MCM.SetSliderDialogDefaultValue(defaultVal)
endFunction 

; ---------
; - Menus -
; ---------

function fillMenu(int startVal, string[] options, int defaultVal)
    MCM.SetMenuDialogStartIndex(startVal)
    MCM.SetMenuDialogOptions(options)
    MCM.SetMenuDialogDefaultIndex(defaultVal)
endFunction 

; -----------
; - Keymaps -
; -----------

function switchKeyMaps(int keycode)
    MCM.KH.UnregisterForAllKeys()
    
    if MCM.EM.isEditMode
        MCM.KH.RegisterForEditModeKeys()
    else
        MCM.KH.RegisterForGameplayKeys()
    endIf
    
    MCM.SetKeyMapOptionValueST(keyCode)
endFunction

; -------------------
; - Everything else -
; -------------------

string[] function cutStrArray(string[] stringArray, int cutIndex)
    string[] newStringArray = CreateStringArray(stringArray.length - 1)
    int oldAIndex
    int newAIndex
        
    while oldAIndex < stringArray.length && newAIndex < stringArray.length - 1
        if oldAIndex != cutIndex
            newStringArray[newAIndex] = stringArray[oldAIndex]
            newAIndex += 1
        endIf
            
        oldAIndex += 1
    endWhile
    
    return newStringArray
endFunction

function resetEditModeKeys()
    MCM.KH.iEquip_EditNextKey = 55
    MCM.KH.iEquip_EditPrevKey = 181
    MCM.KH.iEquip_EditUpKey = 200
    MCM.KH.iEquip_EditDownKey = 208
    MCM.KH.iEquip_EditLeftKey = 203
    MCM.KH.iEquip_EditRightKey = 205
    MCM.KH.iEquip_EditScaleUpKey = 78
    MCM.KH.iEquip_EditScaleDownKey = 74
    MCM.KH.iEquip_EditRotateKey = 80
    MCM.KH.iEquip_EditAlphaKey = 81
    MCM.KH.iEquip_EditDepthKey = 72
    MCM.KH.iEquip_EditTextKey = 79
    MCM.KH.iEquip_EditRulersKey = 77
    MCM.KH.iEquip_EditResetKey = 82
    MCM.KH.iEquip_EditLoadPresetKey = 75
    MCM.KH.iEquip_EditSavePresetKey = 76
    MCM.KH.iEquip_EditDiscardKey = 83
endFunction
