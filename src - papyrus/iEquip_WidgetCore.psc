Scriptname iEquip_WidgetCore extends SKI_WidgetBase
{This script adds functionality to the iEquip widget}

Import Input
Import Form
Import UI

Actor Property PlayerRef Auto

iEquip_EditMode Property EM Auto
iEquip_MCM Property MCM Auto
iEquip_KeyHandler Property KH Auto

;  Variables

Int Property _shoutIndex = 0 Auto
Int Property _leftIndex = 0 Auto
Int Property _rightIndex = 0 Auto
Int Property _potionIndex = 0 Auto

String[] Property asWidgetDescriptions Auto
String[] Property asWidgetElements Auto
String[] Property asWidget_TA Auto
String[] Property asWidget_DefTA Auto
String[] Property asWidgetGroup Auto

Float[] Property afWidget_X Auto
Float[] Property afWidget_Y Auto
Float[] Property afWidget_S Auto
Float[] Property afWidget_R Auto
Float[] Property afWidget_A Auto

Int[] Property aiWidget_D Auto
Int[] Property aiWidget_TC Auto

Float[] Property afWidget_DefX Auto
Float[] Property afWidget_DefY Auto
Float[] Property afWidget_DefS Auto
Float[] Property afWidget_DefR Auto
Float[] Property afWidget_DefA Auto

Int[] Property aiWidget_DefD Auto

Bool[] Property abWidget_V Auto
Bool[] Property abWidget_DefV Auto
Bool[] Property abWidget_isParent Auto
Bool[] Property abWidget_isText Auto
Bool[] Property abWidget_isBg Auto

Int fadeWaitsQueued = 0
Int potionCount
Int[] itemArguments
Int CurrentlyUpdating

Bool iEquip_Enabled = false
Bool ASSIGNMENT_MODE = false 
Bool allocated = false
Bool dataSet = false
Bool Property isFirstLoad = true Auto
Bool isFirstEnabled = true
Bool WaitingForFlash = false
Bool Property Loading = false Auto

String[] itemNames


String Function GetWidgetType()
	debug.trace("iEquip WidgetCore GetWidgetType called")
	Return "iEquip_WidgetCore"
EndFunction

Event OnWidgetInit()
	debug.trace("iEquip WidgetCore OnWidgetInit called")
	PopulateWidgetArrays()

	_currQIndices = new int[4]
    int i = 0
    while i < 4
        _currQIndices[i] = 0
        i +=1
    endWhile

    _potionQueue = new Form[7]
    _shoutQueue = new Form[7]
    _rightHandQueue = new Form[7]
    _leftHandQueue = new Form[7]
	debug.trace("iEquip WidgetCore OnWidgetInit finished")
EndEvent

String Function GetWidgetSource()
	debug.trace("iEquip WidgetCore GetWidgetSource called")
	Return "iEquip/iEquipWidget.swf"
EndFunction

Event OnWidgetLoad()
	debug.trace("iEquip WidgetCore OnWidgetLoad called")

	MCM.iEquip_Reset = false
	EM.SelectedItem = 0
	EM.isEditMode = false
	Loading = true
	; Don't call the parent event since it will display the widget regardless of the "Shown" property.
    ;parent.OnWidgetLoad()
    repushDataToFlash()
    Utility.Wait(0.1)
    potionIndex = _potionIndex
    Utility.Wait(0.1)
    shoutIndex = _shoutIndex
    Utility.Wait(0.1)
    leftIndex = _leftIndex
    Utility.Wait(0.1)
    rightIndex = _rightIndex

    OnWidgetReset()

    ; Determine if the widget should be displayed
    UpdateWidgetModes()
    ;Make sure to hide Edit Mode
	UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
    ; Use RunOnce bool here - if first load hide everything and show messagebox
	if isFirstLoad
		getAndStoreDefaultWidgetValues()
		debug.MessageBox("Thank you for installing iEquip\n\nBefore you can use iEquip for the first time you need to open the MCM and set things up.\n\nFirst thing to do is choose your gear for each widget to manage, then head to the General tab and enable the widgets.\n\nWe hope you enjoy using iEquip!")
		UI.invokeBool(HUD_MENU, WidgetRoot + "setVisible", false)
		isFirstLoad = false
	else
		;updateShown() - switch to updateShown once implemented, still with isFirstLoad
		showWidget()
		UI.invokeBool(HUD_MENU, WidgetRoot + ".setVisible", iEquip_Enabled)
	endIf
	Loading = False
	debug.trace("iEquip WidgetCore OnWidgetLoad finished")
endEvent

Event OnWidgetReset()
	debug.trace("iEquip WidgetCore OnWidgetReset called")
    allocateItemArrays()
    RequireExtend = false
	
	parent.OnWidgetReset()

	; Register all needed events and keys
	updateConfig()
	
	debug.trace("iEquip WidgetCore OnWidgetReset finished")
EndEvent

; Shows the widget if the control mode is set to always,
; clears any keys registered in previous save and then reregisters the gameplay hotkeys.
function updateConfig()
	; Cleanup
	EM.UpdateWidgets()
	UnregisterForAllKeys()
	
	;/if(_controlMode == "always" && _shown)
		showWidget()
	else
		hideWidget()
		_displayed = false
		RegisterForKey(_hotkey)
		if(_controlMode != "periodically")
			_period = "none"
		endIf
	endIf/;
	KH.RegisterForGameplayKeys()
endFunction

;/ Shows the widget for _displayTime seconds.
function showTimed()
	showWidget()
	Utility.Wait(_displayTime)
	; The control mode might have changed, so check again.
	if(_controlMode == "timedHotkey" || _controlMode == "periodically")
		hideWidget()
	endIf
endFunction/;

; Shows the widget if it should be shown, hides it otherwise.
;/function updateShown()
	if(_shown && (_controlMode == "always" || (_controlMode == "toggledHotkey" && _displayed)))
		showWidget()
	else
		hideWidget()
	endIf
endFunction/;

; Shows the widget.
function showWidget()
	if(Ready)
		UpdateWidgetModes()
		FadeTo(100, 0.2)
	endIf
endFunction

; Hides the widget.
function hideWidget()
	if(Ready)
		FadeTo(0, 0.2)
	endIf
endFunction


Bool Property isEnabled
{Set this property true to enable the widget}
	Bool Function Get()
		Return iEquip_Enabled
	EndFunction
	
	Function Set(Bool enabled)
		iEquip_Enabled = enabled
		debug.trace("iEquip WidgetCore isEnabled Set to " + enabled as String)
		If (Ready)
			if iEquip_Enabled
				if isFirstEnabled 
					repushDataToFlash()
					Utility.Wait(0.1)
					potionIndex = _potionIndex
					Utility.Wait(0.1)
					shoutIndex = _shoutIndex
					Utility.Wait(0.1)
					leftIndex = _leftIndex
					Utility.Wait(0.1)
					rightIndex = _rightIndex
					isFirstEnabled = false
				endIf
				UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
				KH.RegisterForGameplayKeys()
			else
				KH.UnregisterForAllKeys()
			endIf
		debug.trace("iEquip WidgetCore isEnabled Set - Ready and iEquip_Enabled = " + iEquip_Enabled as String)
		showWidget() ;Just in case you were in Edit Mode when you disabled because ToggleEditMode won't have done this
		UI.invokeBool(HUD_MENU, WidgetRoot + ".setVisible", iEquip_Enabled)
		EndIf
	EndFunction
EndProperty


function resetWaits()
	debug.trace("iEquip WidgetCore resetWaits called")
    fadeWaitsQueued = 0
endFunction

function allocateItemArrays()
	debug.trace("iEquip WidgetCore allocateItemArrays called")
    if(!allocated)
        itemArguments = new Int[112]
        itemNames = new String[28]
        allocated = true
        dataSet = false
    endIf
endFunction

Function PopulateWidgetArrays()
	debug.trace("iEquip WidgetCore PopulateWidgetArrays called")
	asWidgetDescriptions = new String[18]
	asWidgetElements = new String[18]
	asWidget_TA = new String[18]
	asWidgetGroup = new String[18]
	
	afWidget_X = new Float[18]
	afWidget_Y = new Float[18]
	afWidget_S = new Float[18]
	afWidget_R = new Float[18]
	afWidget_A = new Float[18]
	
	aiWidget_D = new Int[18] ;Stored the index value of any Bring To Front target element ie the element to be sent behind
	aiWidget_TC = new Int[18]
	
	abWidget_V = new bool[18]
	abWidget_isParent = new bool[18]
	abWidget_isText = new bool[18]
	abWidget_isBg = new bool[18]

	;AddWidget arguments - Description, Full Path, X position, Y position, Scale, Rotation, Alpha, Depth, Text Colour, Text Alignment, Visibility, isParent, isText, isBackground, Widget Group
	;Master widget
	AddWidget("Complete widget", ".widgetMaster", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, false, "")
	;Main sub-widgets
	AddWidget("Shout Widget", ".widgetMaster.ShoutWidget", 0, 0, 0, 0, 0, -1, 0, None, true, true, false, false, "Shout")
	AddWidget("Left Hand Widget", ".widgetMaster.LeftHandWidget", 0, 0, 0, 0, 0, 1, 0, None, true, true, false, false, "Left")
	AddWidget("Right Hand Widget", ".widgetMaster.RightHandWidget", 0, 0, 0, 0, 0, 2, 0, None, true, true, false, false, "Right")
	AddWidget("Potion Widget", ".widgetMaster.PotionWidget", 0, 0, 0, 0, 0, 3, 0, None, true, true, false, false, "Potion")
	;Shout widget components
	AddWidget("Shout Background", ".widgetMaster.ShoutWidget.shoutBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Shout")
	AddWidget("Shout Icon", ".widgetMaster.ShoutWidget.shoutIcon_mc", 0, 0, 0, 0, 0, 5, 0, None, true, false, false, false, "Shout")
	AddWidget("Shout Name", ".widgetMaster.ShoutWidget.shoutName_mc", 0, 0, 0, 0, 0, 6, 0xFFFFFF, "Center", true, false, true, false, "Shout")
	;Left Hand widget components
	AddWidget("Left Hand Background", ".widgetMaster.LeftHandWidget.leftBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Left")
	AddWidget("Left Hand Icon", ".widgetMaster.LeftHandWidget.leftIcon_mc", 0, 0, 0, 0, 0, 8, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Item Name", ".widgetMaster.LeftHandWidget.leftName_mc", 0, 0, 0, 0, 0, 9, 0xFFFFFF, "Left", true, false, true, false, "Left")
	;Right Hand widget components
	AddWidget("Right Hand Background", ".widgetMaster.RightHandWidget.rightBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Right")
	AddWidget("Right Hand Icon", ".widgetMaster.RightHandWidget.rightIcon_mc", 0, 0, 0, 0, 0, 11, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Item Name", ".widgetMaster.RightHandWidget.rightName_mc", 0, 0, 0, 0, 0, 12, 0xFFFFFF, "Right", true, false, true, false, "Right")
	;Potion widget components
	AddWidget("Potion Background", ".widgetMaster.PotionWidget.potionBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Potion")
	AddWidget("Potion Icon", ".widgetMaster.PotionWidget.potionIcon_mc", 0, 0, 0, 0, 0, 14, 0, None, true, false, false, false, "Potion")
	AddWidget("Potion Name", ".widgetMaster.PotionWidget.potionName_mc", 0, 0, 0, 0, 0, 15, 0xFFFFFF, "Center", true, false, true, false, "Potion")
	AddWidget("Potion Count", ".widgetMaster.PotionWidget.potionCount_mc", 0, 0, 0, 0, 0, 16, 0xFFFFFF, "Center", true, false, true, false, "Potion")
	
	debug.trace("iEquip WidgetCore PopulateWidgetArrays finished")
EndFunction

Function AddWidget( String sDescription, String sPath, Float fX, Float fY, Float fS, Float fR, Float fA, Int iD, Int iTC, String sTA, bool bV, bool bIsParent, bool bIsText, bool bIsBg, String sGroup)
	debug.trace("iEquip WidgetCore AddWidget called on " + sDescription)
	Int iIndex = 0
	While iIndex < asWidgetDescriptions.Length && asWidgetDescriptions[iIndex] != ""
		iIndex += 1
	EndWhile
	If iIndex >= asWidgetDescriptions.Length
		Debug.MessageBox("iEquip: Failed to add widget to arrays (" + sDescription + ")")
	Else
		asWidgetDescriptions[iIndex] = sDescription
		asWidgetElements[iIndex] = sPath
		afWidget_X[iIndex] = fX
		afWidget_Y[iIndex] = fY
		afWidget_S[iIndex] = fS
		afWidget_R[iIndex] = fR
		afWidget_A[iIndex] = fA
		aiWidget_D[iIndex] = iD
		aiWidget_TC[iIndex] = iTC
		asWidget_TA[iIndex] = sTA
		abWidget_V[iIndex] = bV
		abWidget_isParent[iIndex] = bIsParent
		abWidget_isText[iIndex] = bIsText
		abWidget_isBg[iIndex] = bIsBg
		asWidgetGroup[iIndex] = sGroup
	EndIf
	debug.trace("iEquip WidgetCore AddWidget finished")
EndFunction

function getAndStoreDefaultWidgetValues()
	debug.trace("iEquip WidgetCore getAndStoreDefaultWidgetValues called")
	afWidget_DefX = new Float[18]
	afWidget_DefY = new Float[18]
	afWidget_DefS = new Float[18]
	afWidget_DefR = new Float[18]
	afWidget_DefA = new Float[18]
	aiWidget_DefD = new Int[18]
	asWidget_DefTA = new String[18]
	abWidget_DefV = new bool[18]
	Int iIndex = 0
	String Element = ""
	While iIndex < asWidgetDescriptions.Length
		Element = WidgetRoot + asWidgetElements[iIndex]
		afWidget_X[iIndex] = UI.GetFloat(HUD_MENU, Element + "._x")
		afWidget_Y[iIndex] = UI.GetFloat(HUD_MENU, Element + "._y")
		afWidget_S[iIndex] = UI.GetFloat(HUD_MENU, Element + "._xscale")
		afWidget_R[iIndex] = UI.GetFloat(HUD_MENU, Element + "._rotation")
		afWidget_A[iIndex] = UI.GetFloat(HUD_MENU, Element + "._alpha")
		
		afWidget_DefX[iIndex] = afWidget_X[iIndex]
		afWidget_DefY[iIndex] = afWidget_Y[iIndex]
		afWidget_DefS[iIndex] = afWidget_S[iIndex]
		afWidget_DefR[iIndex] = afWidget_R[iIndex]
		afWidget_DefA[iIndex] = afWidget_A[iIndex]
		aiWidget_DefD[iIndex] = aiWidget_D[iIndex]
		asWidget_DefTA[iIndex] = asWidget_TA[iIndex]
		abWidget_DefV[iIndex] = abWidget_V[iIndex]
		iIndex += 1
	EndWhile
endFunction

Function ResetWidgetArrays()
	Int iIndex = 0
	While iIndex < asWidgetDescriptions.Length
		afWidget_X[iIndex] = afWidget_DefX[iIndex]
		afWidget_Y[iIndex] = afWidget_DefY[iIndex]
		afWidget_S[iIndex] = afWidget_DefS[iIndex]
		afWidget_R[iIndex] = afWidget_DefR[iIndex]
		afWidget_A[iIndex] = afWidget_DefA[iIndex]
		aiWidget_D[iIndex] = aiWidget_DefD[iIndex]
		if abWidget_isText[iIndex]
			aiWidget_TC[iIndex] = 0xFFFFFF
		endIf
		asWidget_TA[iIndex] = asWidget_DefTA[iIndex]
		abWidget_V[iIndex] = abWidget_DefV[iIndex]
		iIndex += 1
	EndWhile
endFunction

function LoadWidgetPreset(string SelectedPreset)
	Int jLoadPreset = jValue.readFromFile(EM.WidgetPresetPath + SelectedPreset)
	Int jafWidget_X = JMap.getObj (jLoadPreset, "_X")
	Int jafWidget_Y = JMap.getObj (jLoadPreset, "_Y")
	Int jafWidget_S = JMap.getObj (jLoadPreset, "_S")
	Int jafWidget_R = JMap.getObj (jLoadPreset, "_R")
	Int jafWidget_A = JMap.getObj (jLoadPreset, "_A")
	Int jaiWidget_D = JMap.getObj (jLoadPreset, "_D")
	Int jaiWidget_TC = JMap.getObj (jLoadPreset, "_TC")
	Int jasWidget_TA = JMap.getObj (jLoadPreset, "_TA")
	Int jabWidget_V = JMap.getObj (jLoadPreset, "_V")
	
	Int[] abWidget_V_temp = new Int[18]

	JArray.writeToFloatPArray (jafWidget_X, afWidget_X, 0, -1, 0, 0)
	JArray.writeToFloatPArray (jafWidget_Y, afWidget_Y, 0, -1, 0, 0)
	JArray.writeToFloatPArray (jafWidget_S, afWidget_S, 0, -1, 0, 0)
	JArray.writeToFloatPArray (jafWidget_R, afWidget_R, 0, -1, 0, 0)
	JArray.writeToFloatPArray (jafWidget_A, afWidget_A, 0, -1, 0, 0)
	JArray.writeToIntegerPArray (jaiWidget_D, aiWidget_D, 0, -1, 0, 0)
	JArray.writeToIntegerPArray (jaiWidget_TC, aiWidget_TC, 0, -1, 0, 0)
	JArray.writeToStringPArray (jasWidget_TA, asWidget_TA, 0, -1, 0, 0)
	JArray.writeToIntegerPArray (jabWidget_V, abWidget_V_temp, 0, -1, 0, 0)
	Int iIndex = 0
	While iIndex < asWidgetDescriptions.Length
		abWidget_V[iIndex] = abWidget_V_temp[iIndex] as Bool
		iIndex += 1
	endWhile
	hideWidget()
	Utility.Wait(0.2)
	EM.UpdateWidgets()
	Utility.Wait(0.1)
	showWidget()
	Debug.Notification("Widget layout switched to " + SelectedPreset)
endFunction

function fadeInAndOut(float fadeInDuration, float fadeOutDuration, float fadeWait, float fadeAlpha, bool fadeFlag)
	debug.trace("iEquip WidgetCore fadeInAndOut called")
    fadeOut(Alpha, fadeInDuration)
    fadeWaitsQueued += 1
    Utility.wait(fadeWait)
    if(fadeWaitsQueued > 0)
        fadeWaitsQueued -= 1
    endIf
    if(!fadeWaitsQueued && fadeFlag)
        fadeOut(fadeAlpha, fadeOutDuration)
    endIf
endFunction

function fadeOut(float a_alpha, float a_duration)
	debug.trace("iEquip WidgetCore fadeOut called")
    float[] args = new float[2]
    args[0] = a_alpha
    args[1] = a_duration
    UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".fadeOut", args)
endFunction

function show(String clip, Bool abvisible)
	debug.trace("iEquip WidgetCore show called on " + clip + ": " + abvisible as String)
	UI.setBool(clip, "_visible", abvisible)
endFunction

function setPotionCount(int count)
	debug.trace("iEquip WidgetCore setPotionCount called")
	potionCount = count
	UI.invokeInt(HUD_MENU, WidgetRoot + ".setPotionCounter", potionCount)
endFunction

function setAssignMode(bool a)
	debug.trace("iEquip WidgetCore setAssignMode called")
    ASSIGNMENT_MODE = a
endFunction

function repushDataToFlash()
	debug.trace("iEquip WidgetCore repushDataToFlash called")
    if(dataSet)
        Utility.Wait(0.5)
        int i = 0
        int[] args = new Int[4]
        while i < 28 
            Utility.Wait(0.05)
            args[0] = itemArguments[i*4]
            args[1] = itemArguments[i*4+1]
            args[2] = itemArguments[i*4+2]
            args[3] = itemArguments[i*4+3]
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setItemData", args)
            UI.InvokeString(HUD_MENU, WidgetRoot + ".setItemName", itemNames[i])
            i += 1
        endWhile
    endIf
endFunction

function setItemData(string itemName, int[] itemArgs)
	debug.trace("iEquip WidgetCore setItemData called on " + itemName)
    ;Must save the item data locally so it can be pushed into the actionscript when the game reloads
    int index = 4*(7*itemArgs[0] + itemArgs[1])
    itemArguments[index] = itemArgs[0] 
    itemArguments[index+1] = itemArgs[1] 
    itemArguments[index+2] = itemArgs[2] 
    itemArguments[index+3] = itemArgs[3] 
    itemNames[7*itemArgs[0] + itemArgs[1]] = itemName
    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setItemData", itemArgs)
    UI.InvokeString(HUD_MENU, WidgetRoot + ".setItemName", itemName)
    dataSet = true
endfunction


Int Property leftIndex
	Int Function Get()
		Return _leftIndex
	EndFunction
	
	Function Set(Int abVal)
		If (Ready)
           
			_leftIndex = abVal
            Int[] args = new Int[2]
            args[0] = _leftIndex
            args[1] = ASSIGNMENT_MODE as int
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".cycleLeftHand", args)
		EndIf
	EndFunction
EndProperty

Int Property rightIndex
	Int Function Get()
		Return _rightIndex
	EndFunction
	
	Function Set(Int abVal)
		If (Ready)
			_rightIndex = abVal
            Int[] args = new Int[2]
            args[0] = _rightIndex
            args[1] = ASSIGNMENT_MODE as int
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".cycleRightHand", args)
		EndIf
	EndFunction
EndProperty

Int Property shoutIndex
	Int Function Get()
		Return _shoutIndex
	EndFunction

	Function Set(Int abVal)
		If (Ready)
			_shoutIndex = abVal
            Int[] args = new Int[2]
            args[0] = _shoutIndex
            args[1] = ASSIGNMENT_MODE as int
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".cycleShout", args)
		EndIf
	EndFunction
EndProperty

Int Property potionIndex
	Int Function Get()
		Return _potionIndex
	EndFunction
	
	Function Set(Int abVal)
		If (Ready)
			_potionIndex = abVal
            Int[] args = new Int[2]
            args[0] = _potionIndex
            args[1] = ASSIGNMENT_MODE as int
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".cyclePotion", args)
			UI.invokeInt(HUD_MENU, WidgetRoot + ".setPotionCounter", potionCount)
		EndIf
	EndFunction
EndProperty

;-----------------------------------------------------------------------------------------------------------------------
;QUEUE FUNCTIONALITY CODE
;-----------------------------------------------------------------------------------------------------------------------
;these contain the objects for the final queues the user decides upon
Form[]       _potionQueue
Form[]       _shoutQueue
Form[]       _rightHandQueue 
Form[]       _leftHandQueue

;_currQIndices contains indices of currently active slots
;0 - LH
;1 - RH
;2 - Shout
;3 - Potion
int[] Property _currQIndices Auto

Int[] Function GetItemIconArgs(int queueID)
    debug.trace("iEquip_WidgetCore GetItemIconArgs called")
    Form[] Q
    if(queueID == 1)
        Q = _rightHandQueue
    elseif(queueID == 2)
        Q = _shoutQueue
    elseif(queueID == 3)
        Q = _potionQueue
    else
        Q = _leftHandQueue
    endIf
    Form item = Q[_currQIndices[queueID]]
    int[] args = new Int[4]
    args[0] = queueID 
    args[1] = _currQIndices[queueID] 
    if(item)
        args[2] = item.GetType() 
    else
        args[2] = 0
    endIf
    args[3] = -1 
    ;if it is a weapon, we want its weapon type
    if(args[2] == 41)
        Weapon W = item as Weapon
        int weaponType = W.GetWeaponType()
            ;2H axes and maces have the same ID for some reason, so we have to differentiate them
            if(weaponType == 7)
                weaponType = 8
            elseif(weaponType == 8)
                weaponType = 10
            endIf
            if(weaponType == 6)
                if(W.IsWarhammer())
                weaponType = 7
                endIf
            endIf
        args[3] = weaponType
    ;Is a spell
    elseIf(args[2] == 22) 
        Spell S = item as Spell
        int sIndex = S.GetCostliestEffectIndex()
        MagicEffect sEffect = S.GetNthEffectMagicEffect(sIndex)
        String school = sEffect.GetAssociatedSkill()
        if(school == "Alteration")
            args[3] = 18 
        elseIf(school == "Conjuration")
            args[3] = 19
        elseIf(school == "Destruction")
            args[3] = 20 
        elseIf(school == "Illusion")
            args[3] = 21 
        elseIf(school == "Restoration")
            args[3] = 22 
        endIf
    ;Is a potion
    elseIf(args[2] == 46)
        Potion P = item as Potion
        if(P.IsPoison())
            args[3] = 15
            return args
        elseIf(P.IsFood())
            args[3] = 13
            return args 
        endIf
        int pIndex = P.GetCostliestEffectIndex()
        MagicEffect pEffect = P.GetNthEffectMagicEffect(pIndex)
        String pStr = pEffect.GetName() 
        if(pStr == "Restore Health" || pStr == "Regenerate Health")
            args[3] = 0
        elseif(pStr == "Restore Magicka" || pStr == "Regenerate Magicka")
            args[3] = 3 
        elseif(pStr == "Restore Stamina" || pStr == "Regenerate Stamina")
            args[3] = 6 
        elseif(pStr == "Resist Fire")
            args[3] = 9 
        elseif(pStr == "Resist Shock")
            args[3] = 10 
        elseif(pStr == "Resist Frost")
            args[3] = 11 
        endIf
    endIf       
    return args
endFunction

function cycleSlot(int slotID)
	int[] args
	if slotID == 0 || slotID == 1
		cycleHand(slotID)
	elseIf slotID == 2
		cyclePower()
	elseIf slotID == 3
		cyclePotion()
	endIf
	args = GetItemIconArgs(slotID)
	setItemData(getCurrQItemName(slotID), args)
	if slotID == 0
		leftIndex = _currQIndices[slotID]
	elseIf slotID == 1
		rightIndex = _currQIndices[slotID]
	elseIf slotID == 2
		shoutIndex = _currQIndices[slotID]
	elseIf slotID == 3
		potionIndex = _currQIndices[slotID]
	endIf
	if(args[0])
        MCM.itemDataUpToDate[args[0]*MCM.MAX_QUEUE_SIZE + args[1]] = true
    endIf
endFunction

bool function cycleHand(int slotID)
    debug.trace("iEquip MCM cycleHand called")
    Form[] queue
    int equipSlotId
    int currIndex = _currQIndices[slotID]

    ;for some reason, when using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand,
    ;so we have to change the value for the left hand here  
    if(slotID == 0)
        queue = _leftHandQueue
        equipSlotId = 2 
    elseif (slotID == 1)
        queue = _rightHandQueue
        equipSlotId = 1
    endif

    ;First, we check to see if the currently equipped item is the same as the current item in the queue.  
    ;If it is, advance the queue. Else, equip the current item in the queue 
    Form currEquippedItem = PlayerRef.GetEquippedObject(slotID)
    Form currQItem = queue[currIndex]
    if(currEquippedItem != currQItem && currQItem != None)
        if(ValidateItem(currQItem))
            UnequipHand(slotID)
            if(currQItem.getType() == 22)                   
                PlayerRef.EquipSpell(currQItem as Spell, slotID)
            else
                PlayerRef.EquipItemEx(currQItem, equipSlotId, false, false)
            endIf
            return true
        else
            removeInvalidItem(slotID, currIndex)
        endIf
        ;if item fails validation or curr equipped item check, move to next item in queue
    endIf   
        
    int newIndex = advanceQueue(slotID, 0)
    Form nextQItem = queue[newIndex]
    if(ValidateItem(nextQItem))
        UnequipHand(slotID)
        if(nextQItem.getType() == 22)
            PlayerRef.EquipSpell(nextQItem as Spell, slotID)
        else
            PlayerRef.EquipItemEx(nextQItem, equipSlotId, false, false)
        endif
        return true
    else
        removeInvalidItem(slotID, newIndex)
    endIf
    return false
endFunction

function cyclePower()
    debug.trace("iEquip MCM cyclePower called")
    ;if no power is equipped OR a power is equipped that is not the same as the current power in the Queue, equip current queue power
    ;else, go to next power in the queue
    int currIndex = _currQIndices[2]
    shout currShout = PlayerRef.GetEquippedShout()
    int type = 0
    ;If the currently equipped power is not a shout but a spell (power), there isn't a way to tell it is equipped,
    ;so we have to advance the queue no matter what
    if(currShout != _shoutQueue[currIndex] && _shoutQueue[currIndex] != None && _shoutQueue[currIndex].GetType() != 22) 
        type = _shoutQueue[currIndex].GetType()
        ;If it is a spell (power)
        if( type == 22)
            PlayerRef.EquipSpell(_shoutQueue[currIndex] as Spell, 2 )
        elseIf(type == 119)
            PlayerRef.EquipShout(_shoutQueue[currIndex] as Shout )
        endIf

    else
        int newIndex = advanceQueue(2, 0);
        if(_shoutQueue[newIndex])
            type = _shoutQueue[newIndex].GetType()
        endIf
        if( type == 22)
            PlayerRef.EquipSpell(_shoutQueue[newIndex] as Spell, 2 )
        elseIf(type == 119)
            PlayerRef.EquipShout(_shoutQueue[newIndex] as Shout )
        endIf
    endif
endFunction

function cyclePotion()
    debug.trace("iEquip MCM cyclePotion called")
    advanceQueue(3, 0)
    int currIndex = _currQIndices[3]
    Form item = _potionQueue[currIndex]
    if(item)
        setPotionCount(PlayerRef.GetItemCount(item))
    endIf
endFunction

;uses the equipped item / potion in the bottom slot
function useEquippedItem()
    debug.trace("iEquip MCM useEquippedItem called")
    int currIndex = _currQIndices[3]    
    Form item = _potionQueue[currIndex]
    if( item != None)
        if(ValidateItem(item))
            PlayerRef.EquipItem(item, false, false)
        else
            removeInvalidItem(3, currIndex)
            Debug.Notification("You no longer have " + item.getName())
        endIf
    endIf
    setPotionCount(PlayerRef.GetItemCount(item))
endFunction

;Unequips item in hand
function UnequipHand(int a_hand)
    debug.trace("iEquip MCM UnequipHand called")
    int a_handEx = 1
    if (a_hand == 0)
        a_handEx = 2 ; unequipspell and *ItemEx need different hand args
    endIf

    Form handItem = PlayerRef.GetEquippedObject(a_hand)
    if (handItem)
        int itemType = handItem.GetType()
        if (itemType == 22)
            PlayerRef.UnequipSpell(handItem as Spell, a_hand)
        else
            PlayerRef.UnequipItemEx(handItem, a_handEx)
        endIf
    endIf
endFunction

;moves the queue to the next slot
int function advanceQueue_ASSIGNMENT_MODE(int queueID)
    debug.trace("iEquip MCM advanceQueue_ASSIGNMENT_MODE called")
    int currIndex = _currQIndices[queueID]
    int newIndex
    if (currIndex == MCM.MAX_QUEUE_SIZE - 1)
        newIndex = 0    
    else
        newIndex = currIndex + 1    
    endIf
    _currQIndices[queueID] = newIndex
    return newIndex
endFunction

int function advanceQueue(int queueID, int depth)
    debug.trace("iEquip MCM advanceQueue called")
    int newIndex = advanceQueue_ASSIGNMENT_MODE(queueID)
    ;Recursively advance until there is an item in the queue or the entire length of the queue has been traversed
    if(!ValidateSlot(queueID) && depth < MCM.MAX_QUEUE_SIZE)
        newIndex = advanceQueue(queueID, depth + 1)
    endIf
    return newIndex
endFunction

;makes sure whatever is in the current slot is equippable.
bool function ValidateSlot(int queueID)
    debug.trace("iEquip MCM ValidateSlot called")
    int currIndex = _currQIndices[queueID]
    if queueID == 0
        if _leftHandQueue[currIndex] == None || !ValidateItem(_leftHandQueue[currIndex])
            return false
        endIf
    elseif queueID == 1 
        if _rightHandQueue[currIndex] == None || !ValidateItem(_rightHandQueue[currIndex])
            return false
        endIf
    elseif queueId == 2
        if _shoutQueue[currIndex] == None || !ValidateItem(_shoutQueue[currIndex])
            return false
        endIf
    elseif queueId == 3 
        if _potionQueue[currIndex] == None || !ValidateItem(_potionQueue[currIndex])
            return false    
        endIf
    endIf
    return true
endFunction

;make sure the player has the item or spell and it is favorited
bool function ValidateItem(Form a_item)
    debug.trace("iEquip MCM ValidateItem called")
    if (a_item == None)
        return false
    endif
    int a_itemType = a_item.GetType()
    int itemCount 

    ; This is a Spell or Shout and can't be counted like an item
    if (a_itemType == 22 || a_itemType == 119)
        return PlayerRef.HasSpell(a_item)
    ; This is an inventory item
    else 
        itemCount = PlayerRef.GetItemCount(a_item)
        if (itemCount < 1)
            Debug.Notification("You no longer have " + a_item.getName())
            return false
        endIf
    endIf
    ;This item is already equipped, possibly in the other hand, and there is only 1 of it
    if ((a_item == PlayerRef.GetEquippedObject(0) || a_item == PlayerRef.GetEquippedObject(1)) && itemCount < 2)
        return false
    endif
    return true
endFunction

;if an item fails validation, remove it from the queue
function removeInvalidItem(int queueID, int index)
    debug.trace("iEquip MCM removeInvalidItem called")
    if(queueID == 0)
        _leftHandQueue[index] = None
    elseif(queueID == 1)
        _rightHandQueue[index] = None
    elseif(queueID == 2)
        _shoutQueue[index] = None
    elseif(queueID == 3)
        _potionQueue[index] = None
    endIf
endFunction

;Getters for the widget script
String function getCurrQItemName(int queueID)
    debug.trace("iEquip MCM getCurrQItemName called")
    int currIndex = _currQIndices[queueID]

    if(queueID == 0)
        if(_leftHandQueue[currIndex])
            return  _leftHandQueue[currIndex].getName()
        endIf
    elseif(queueID == 1)
        if(_rightHandQueue[currIndex])
            return _rightHandQueue[currIndex].getName()
        endIf
    elseif(queueID == 2)
        if(_shoutQueue[currIndex])
            return _shoutQueue[currIndex].getName()
        endIf
    elseif(queueID == 3)
        if(_potionQueue[currIndex])
            return _potionQueue[currIndex].getName()
        endIf
    endIf
    return ""
endFunction 

function AssignCurrEquippedItem(Int aiSlot)
    debug.trace("iEquip MCM AssignCurrEquippedItem called")
    Form obj = PlayerRef.GetEquippedObject(aiSlot)
    int ndx = _currQIndices[aiSlot]
    if(aiSlot == 0)
        _leftHandQueue[ndx] = obj 
    elseif(aiSlot == 1)
        _rightHandQueue[ndx] = obj 
    elseif(aiSlot == 2)
        _shoutQueue[ndx] = obj 
    endIf
endFunction