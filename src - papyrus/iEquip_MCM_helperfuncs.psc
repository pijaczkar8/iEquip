Scriptname iEquip_MCM_helperfuncs extends quest

iEquip_MCM Property MCM Auto

string Property currentEvent Auto Hidden
float Property currentVar Auto Hidden

; #########################
; ### DEFAULT BEHAVIOUR ###

function initData()
    debug.trace("ERR: An iEquip MCM Page has no defined init data")
endFunction

int function saveData()
    debug.trace("ERR: An iEquip MCM Page has no defined save data")
    return -1
endFunction

function loadData(int jPageObj)
    debug.trace("ERR: An iEquip MCM Page has no defined load data")
endFunction


function drawPage()
    debug.trace("ERR: An iEquip MCM Page has no defined draw page")
endFunction

; ########################
; ### HELPER FUNCTIONS ###

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

; -------------------
; - Everything else -
; -------------------

string[] function cutStrArray(string[] stringArray, int cutIndex)
    string[] newStringArray = Utility.CreateStringArray(stringArray.length - 1)
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
