Scriptname iEquip_MCM_Page extends quest

iEquip_MCM Property MCM Auto
iEquip_WidgetCore Property WC Auto

string Property currentEvent Auto Hidden
string Property currentStrVar Auto Hidden
float Property currentVar Auto Hidden

; #########################
; ### DEFAULT BEHAVIOUR ###

function initData()                  ; Initialize page specific data
    debug.trace("WARN: An iEquip MCM Page has no defined init data")
endFunction

int function saveData()             ; Save page data and return jObject
    debug.trace("WARN: An iEquip MCM Page has no defined save data")
    return jArray.object()
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj
    debug.trace("WARN: An iEquip MCM Page has no defined load data")
endFunction


function drawPage()                 ; Draw page
    debug.trace("WARN: An iEquip MCM Page has no defined draw page")
endFunction

function jumpToState(string stateName, string eventName, float tmpVar = -1.0, string tmpStr = "")
    currentEvent = eventName
	currentVar = tmpVar
	currentStrVar = tmpStr
        
    GoToState(stateName)
endFunction
