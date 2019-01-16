Scriptname iEquip_MCM_Page extends quest

iEquip_MCM Property MCM Auto
iEquip_WidgetCore Property WC Auto

string Property currentEvent Auto Hidden
float Property currentVar Auto Hidden

; #########################
; ### DEFAULT BEHAVIOUR ###

function initData()                  ; Initialize page specific data
    debug.trace("ERR: An iEquip MCM Page has no defined init data")
endFunction

int function saveData()             ; Save page data and return jObject
    debug.trace("ERR: An iEquip MCM Page has no defined save data")
    return -1
endFunction

function loadData(int jPageObj)     ; Load page data from jPageObj
    debug.trace("ERR: An iEquip MCM Page has no defined load data")
endFunction


function drawPage()                 ; Draw page
    debug.trace("ERR: An iEquip MCM Page has no defined draw page")
endFunction

function jumpToState(string stateName, string eventName, float tmpVar = -1.0)
    currentEvent = eventName
    currentVar = tmpVar
        
    GoToState(stateName)
endFunction
