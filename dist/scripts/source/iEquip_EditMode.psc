ScriptName iEquip_EditMode Extends Quest

import UI
import Utility
import StringUtil
Import iEquip_UILIB
import _Q2C_Functions

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_ChargeMeters Property CM Auto

bool property isEditMode = False Auto
int property SelectedItem = -1 Auto
bool firstTimeInEditMode = true
;MCM toggle for Bring To Front function in Edit Mode.  Disabled by default as likely to be little used and causes delay when switching presets and entering/leaving Edit Mode
bool Property bringToFrontEnabled = false Auto
bool bringToFrontFirstTime = True
bool wasLeftCounterShown = false
bool wasRightCounterShown = false
int previousLeftCount
int previousRightCount

bool isWidgetMaster = False
bool property bDisabling = false Auto
bool startbringToFront = False

Float MoveStep
Float RotateStep
Float AlphaStep
bool bClockwise = false
int Rotation
int RulersShown = 1
int Property EMHighlightColor = 0x0099FF Auto
int Property EMCurrentValueColor = 0xEAAB00 Auto

string Property WidgetPresetPath = "Data/iEquip/Widget Presets/" autoReadonly
string Property FileExtWP = ".IEQP" autoReadonly
int[] Property EMCustomColors Auto

bool preselectEnabledOnEnter = false

int iItemToMoveToFront
int iItemToSendToBack
bool SettingDepth = false
int WaitingForFlash
int DepthA
int DepthB

String Element = ""
String HUD_MENU
String WidgetRoot

String[] WidgetGroups
int[] firstElementInGroup
bool cyclingGroups = true

float[] afWidget_CurX
float[] afWidget_CurY
float[] afWidget_CurS
float[] afWidget_CurR
float[] afWidget_CurA
int[] aiWidget_CurD
int[] aiWidget_CurTC
string[] asWidget_CurTA
bool[] abWidget_CurV

SPELL Property iEquip_SlowTimeSpell  Auto
Message property iEquip_ConfirmReset auto
Message property iEquip_ConfirmResetParent auto
Message property iEquip_ConfirmDiscardChanges auto

float CurrentVanityModeDelay

int initColorPicker_STATE = -1 ;0 = Setting Highlight color, 1 = Setting Current Info Text color, 2 = Setting Selected Text Item color

function onInit()
    HUD_MENU = WC.HUD_MENU
    
	EMCustomColors = new Int[14]
	int i = 0
    
	While i < EMCustomColors.length
		EMCustomColors[i] = -1
		i += 1
	endWhile
endFunction

; ##############
; ### EVENTS ###

Event onGotDepth(String sEventName, String sStringArg, Float fNumArg, Form kSender)
	;debug.trace("iEquip EditMode onGotDepth event received")
	If(sEventName == "iEquip_GotDepth")
		If WaitingForFlash == 2
			DepthA = fNumArg as int
			;debug.trace("DepthA set to " + DepthA as String)
		else
			DepthB = fNumArg as int
			;debug.trace("DepthB set to " + DepthB as String)
		endIf
		WaitingForFlash -= 1
	endIf
endEvent



;Edit Mode Functions

function updateWidgets()
	debug.trace("iEquip EditMode updateWidgets called")
	debug.trace("iEquip EditMode updateWidgets - SettingDepth on function start = " + SettingDepth as String)
	int[] args = new int[2]
	SettingDepth = false
	Utility.Wait(2)
	self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
    
	While args[0] < WC.asWidgetDescriptions.Length
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._x", WC.afWidget_X[args[0]])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._y", WC.afWidget_Y[args[0]])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._xscale", WC.afWidget_S[args[0]])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._yscale", WC.afWidget_S[args[0]])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._rotation", WC.afWidget_R[args[0]])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._alpha", WC.afWidget_A[args[0]])
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[args[0]] + "._visible", WC.abWidget_V[args[0]])
        
		if WC.abWidget_isText[args[0]]
			If WC.asWidget_TA[args[0]] == "left"
				args[1] = 0
			elseIf WC.asWidget_TA[args[0]] == "center"
				args[1] = 1
			else
				args[1] = 2
			endIf
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
			args[1] = WC.aiWidget_TC[args[0]]
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
		endIf
        
		if bringToFrontEnabled && isEditMode && !WC.bIsFirstLoad && !WC.bLoading
			while SettingDepth == true
				Utility.Wait(0.01)
			endWhile
            
			if args[0] != 0
				SetDepthOrder(args[0], 0)
                
			endIf
		endIf
        
        args[0] = args[0] + 1
	EndWhile
    
	if isEditMode
		handleEditModeHighlights(1)
	endIf
    
	self.UnregisterForModEvent("iEquip_GotDepth")
	debug.trace("iEquip EditMode updateWidgets finished")
endFunction

; CHECK IF CAN BE REWRITTEN
Function SetDepthOrder(int iIndex, int SetReset)
	;debug.trace("iEquip EM SetDepthOrder called")
	;SetReset: 0 = Set, 1 = Reset
	Int SendBehind
	SettingDepth = true
    
	if SetReset == 0
		SendBehind = WC.aiWidget_D[iIndex]
	else
		SendBehind = WC.aiWidget_DefD[iIndex]
	endIf
    
	debug.trace("iEquip EM SendBehind = " + SendBehind as String)
	if SendBehind != -1
		WaitingForFlash = 2
		;debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", iIndex)
		;debug.trace("iEquip EM .getCurrentItemDepth called for the first time")
        
		While WaitingForFlash > 1
			Wait(0.01)
		endWhile
        
		;debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", SendBehind)
		;debug.trace("iEquip EM .getCurrentItemDepth called for the second time")
        
		While WaitingForFlash > 0
			Wait(0.01)
		endWhile
        
		;debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
        
		if DepthA < DepthB
			;debug.trace("iEquip EM DepthA is less than DepthB, calling .swapItemDepths")
			int[] args = new int[2]
			args[0] = iIndex
			args[1] = SendBehind
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", args)
			WC.aiWidget_D[iIndex] = SendBehind
            
			if WC.aiWidget_D[SendBehind] == iIndex
				WC.aiWidget_D[SendBehind] = -1
			endIf
		endIf
	endIf
	SettingDepth = false
	;debug.trace("iEquip EM SetDepthOrder setting SettingDepth before closing to: " + SettingDepth as String)
	;debug.trace("iEquip EM SetDepthOrder finished")
endFunction

function LoadEditModeWidgets()
	debug.trace("iEquip EditMode LoadEditModeWidgets called")
	Int iIndex = 0
	While iIndex < WC.asWidgetDescriptions.Length
		UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true) ;Everything else other than the backgrounds needs to be visible in Edit Mode
		iIndex += 1
	EndWhile
	;Show left and right counters if not currently shown
	if !WC.bLeftCounterShown
		wasLeftCounterShown = false
		WC.setCounterVisibility(0, true)
	else
		wasLeftCounterShown = true
		previousLeftCount = UI.getString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text") as int
	endIf
	WC.setSlotCount(0,99)
	if !WC.bRightCounterShown
		wasRightCounterShown = false
		WC.setCounterVisibility(1, true)
	else
		wasRightCounterShown = true
		previousRightCount = UI.getString(HUD_MENU, WidgetRoot + ".widgetMaster.RightHandWidget.rightCount_mc.rightCount.text") as int
	endIf
	WC.setSlotCount(1,99)
	;Show any currently hidden names
	int Q = 0
	while Q < 8
		if !WC.abIsNameShown[Q]
			WC.showName(Q, true, false, 0.0)
		endIf
		Q += 1
	endWhile
	Q = 0
	int iHandle
	while Q < 2
		;Check and show left and right poison elements if not already displayed
		if !WC.abPoisonInfoDisplayed[Q]
			string poisonNamePath = ".widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName.text"
			if Q == 1
				poisonNamePath = ".widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName.text"
			endIf
			UI.SetString(HUD_MENU, WidgetRoot + poisonNamePath, "Some horrible poison")
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
			if(iHandle)
				UICallback.PushInt(iHandle, Q)
				UICallback.PushString(iHandle, "Drops3")
				UICallback.Send(iHandle)
			endIf
		endIf
		if !WC.abIsPoisonNameShown[Q]
			WC.showName(Q, true, true, 0.0)
		endIf
		;Check and show left and right attribute icons including those for the preselect slots
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Main slot
			UICallback.PushString(iHandle, "Both")
			UICallback.Send(iHandle)
		endif
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
		if(iHandle)
			UICallback.PushInt(iHandle, Q + 5) ;Preselect slot
			UICallback.PushString(iHandle, "Both")
			UICallback.Send(iHandle)
		endif
		Q += 1
	endWhile
	debug.trace("iEquip EditMode LoadEditModeWidgets finished")
endFunction

; CAN PROBABLY BE IMPLEMENTED IN PARTS
function UpdateEditModeInfoText()
	debug.trace("iEquip EditMode UpdateEditModeInfoText called")
    
	Int iIndex = SelectedItem
	if iIndex >= 0
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.SelectedElementText.text", WC.asWidgetDescriptions[iIndex])
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", (MoveStep as int) as String + " pixels")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", (RotateStep as int) as String + " degrees")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", (AlphaStep as int) as String + "%")
        
		if bClockwise
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", "Clockwise")
		else
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", "Counter-clockwise")
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iIndex] as int) as String + "%")
        
		Rotation = WC.afWidget_R[iIndex] as int
		if Rotation > 180
			Rotation = Rotation - 360
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", Rotation as String + " degrees")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iIndex] as int) as String + "%")
        
		if WC.abWidget_isText[iIndex]
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", WC.asWidget_TA[iIndex] + " aligned")
		else
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", "")
		endIf
        
		If RulersShown == 1
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Edge grid")
		elseIf RulersShown == 2
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Fullscreen grid")
		else
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Hidden")
        endIf
	endIf
    
	debug.trace("iEquip EditMode UpdateEditModeInfoText finished")
endFunction

function handleEditModeHighlights(int mode)
	;mode: 1 = Add highlight, 0 = Remove highlight
	debug.trace("iEquip EditMode handleEditModeHighlights called")
	int iIndex = SelectedItem
	int isText = WC.abWidget_isText[iIndex] as int
	int[] args = new int[3]
	args[0] = isText
	args[1] = iIndex
	args[2] = WC.aiWidget_TC[iIndex] ;Current text colour if text element
	if mode == 1
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".highlightSelectedElement", args)
	else
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".removeCurrentHighlight", args)
	endIf
endFunction

Function TweenElement(float attribute, float targetValue, float duration)
	;Calls tweenIt in iEquipWidget.as to animate changes in position, scale, rotation and alpha
	;tweenIt now utilises Greensock.TweenLite rather than mx.tween
	debug.trace("iEquip EditMode TweenElement called on " + Element)
	float[] args = new float[3]
    
	;0 = Attribute to change - 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 = _rotation, 4 = _alpha
	;1 = Target value - sent from calling function as value after increment applied
	;2 = Duration in seconds for tween to take
	args[0] = attribute
	args[1] = targetValue
	args[2] = duration
	UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenIt", args)
EndFunction

function initColorPicker(int target)
	;target: 0 = Highlight colour, 1 = Current item info text colour, 2 = Selected text colour
    debug.trace("iEquip EM initColorPicker called")

    if initColorPicker_STATE == -1 ;First time calling
    	initColorPicker_STATE = target ;So when called again if returning from setting a custom colour we know how to re-call the color menu in it's previous state
    else
    	initColorPicker_STATE == -1 ;Reset to -1 if this is the second call in this string of events, then apply the custom color to whatever it was set for before redrawing the color menu
    endIf

    string titleText
	int currentColor
    int defaultColor
    
	if target == 0
		titleText = "Select a color for selected item highlights"
		currentColor = EMHighlightColor
		defaultColor = 0x0099FF
	elseIf target == 1
		titleText = "Select a color for selected item info text"
		currentColor = EMCurrentValueColor
		defaultColor = 0xEAAB00
	else
		titleText = "Select a text color for selected text element"
    	currentColor = WC.aiWidget_TC[SelectedItem]
    	defaultColor = 0xFFFFFF
    endIf
    
    ; Show color menu
    Int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowColorMenu(titleText, currentColor, defaultColor, EMCustomColors)
    
    if MenuReturnArgs[1] == 0 ;Apply selected colour
	    if MenuReturnArgs[0] > 0
	        if target == 0
	            EMHighlightColor = MenuReturnArgs[0]
	            UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", MenuReturnArgs[0])
	            if isEditMode
	                handleEditModeHighlights(1)
	            endIf
	        else
                ;target: 1 = Current item info text colour, 2 = Selected text colour
                int newColor = MenuReturnArgs[0] as int
                
                if target == 1
                    EMCurrentValueColor = newColor
                    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeCurrentValueColor", newColor)
                else
                    int iIndex = SelectedItem
                    WC.aiWidget_TC[iIndex] = newColor
                    int[] args = new int[2]
                    args[0] = iIndex
                    args[1] = newColor
                    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
                endIf
	        endIf
	    endIf
	elseIf MenuReturnArgs[1] == 1 ;Pressed the Custom button
		showEMTextInputMenu(1)
	endIf
    
    debug.trace("iEquip EM initColorPicker finished")
endFunction

function showEMTextInputMenu(int target)
    String textInput
    
    if target == 0  ; Save Preset
        textInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("Name this layout preset", "")
        if textInput != ""
            int jSavePreset = jMap.object()

            jMap.setObj(jSavePreset, "_X", jArray.objectWithFloats(WC.afWidget_X))
            jMap.setObj(jSavePreset, "_Y", jArray.objectWithFloats(WC.afWidget_Y))
            jMap.setObj(jSavePreset, "_S", jArray.objectWithFloats(WC.afWidget_S))
            jMap.setObj(jSavePreset, "_R", jArray.objectWithFloats(WC.afWidget_R))
            jMap.setObj(jSavePreset, "_A", jArray.objectWithFloats(WC.afWidget_A))
            jMap.setObj(jSavePreset, "_D", jArray.objectWithInts(WC.aiWidget_D))
            jMap.setObj(jSavePreset, "_TC", jArray.objectWithInts(WC.aiWidget_TC))
            jMap.setObj(jSavePreset, "_TA", jArray.objectWithStrings(WC.asWidget_TA))
            jMap.setObj(jSavePreset, "_V", jArray.objectWithBooleans(WC.abWidget_V))

            jValue.writeTofile(jSavePreset, WidgetPresetPath + textInput + FileExtWP)
            Debug.Notification("Current layout saved as " + textInput + FileExtWP)
        endIf
    else            ; Enter color value
        textInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("Enter a custom colour hex code", "RRGGBB")
        if textInput != "" && textInput != "RRGGBB"
            updateCustomColors(0, HexStringToInt(textInput), 0) ;(action: 0 = Add, colour)
        endIf
	endIf
endFunction

Int Function HexStringToInt(String sHex)
    Int iDec = 0
    Int iPlace = 1
    Int iIndex = 6
    
    While (iIndex > 0)
        iIndex -= 1
        String sChar = SubString(sHex, iIndex, 1)
        Int iSubNumber = 0
        If (IsDigit(sChar))
            iSubNumber = sChar as Int
        Else
            iSubNumber = AsOrd(sChar) - 55
        EndIf
        iDec += iSubNumber * iPlace
        iPlace *= 16
    EndWhile
    
    Return iDec
EndFunction

function updateCustomColors(int action_, int newColor, int aIndex)
	debug.trace("iEquip EditMode updateCustomColors called")
	;action: 0 = Add custom colour, 1 = Clear custom colour
	if action_ == 0 ;Add new custom color in first available empty slot
		int iIndex = 0
		While iIndex < EMCustomColors.length && EMCustomColors[iIndex] != -1
			iIndex += 1
		endWhile
        
		if iIndex != EMCustomColors.length
            EMCustomColors[iIndex] = newColor
            
            ;Apply the custom color to whatever it was set for, before redrawing the color menu
            if initColorPicker_STATE == 0
                EMHighlightColor = newColor
                UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", newColor)
                handleEditModeHighlights(1)
            elseIf initColorPicker_STATE == 1
                EMCurrentValueColor = newColor
                UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeCurrentValueColor", newColor)
            else
                iIndex = SelectedItem
                WC.aiWidget_TC[iIndex] = newColor
                int[] args = new int[2]
                args[0] = iIndex
                args[1] = newColor
                UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
            endIf
            
            initColorPicker(initColorPicker_STATE)
		else
            debug.MessageBox("You have no free custom colour slots available\n\nYou can free up slots by removing custom colours you don't need using the Delete function in the colour menu")
		endIf
	elseIf action_ == 1 ;Delete currently highlighted custom color
		EMCustomColors[aIndex] = -1 ;Do delete action first if required
		;Then iterate through the array sorting all of the colour values to the start leaving all the empty (-1) slots at the end
		Int Index1 = EMCustomColors.Length - 1
		While (Index1 > 0)
			Int Index2 = 0
			While (Index2 < Index1)
				If (EMCustomColors[Index2] == -1)
					EMCustomColors[Index2] = EMCustomColors [Index2 + 1]
					EMCustomColors[Index2 + 1] = -1
				EndIf
				Index2 += 1
			EndWhile
			Index1 -= 1
		EndWhile
        
        initColorPicker(initColorPicker_STATE)
	endIf
endFunction

; ----------------------
; - EXTERNAL FUNCTIONS -
; ----------------------

function toggleEditMode()
	debug.trace("iEquip EditMode toggleEditMode called")
    WidgetRoot = WC.WidgetRoot
    if !isEditMode
		CurrentVanityModeDelay = GetINIFloat("fAutoVanityModeDelay:Camera")
	endIf
	WC.hideWidget()
	Wait(0.2)
	isEditMode = !isEditMode
    
	if isEditMode
		WidgetGroups = new String[6]
		WidgetGroups[0] = ""
		WidgetGroups[1] = "Left"
		WidgetGroups[2] = "Right"
		WidgetGroups[3] = "Shout"
		WidgetGroups[4] = "Consumable"
		WidgetGroups[5] = "Poison"

		firstElementInGroup = new int[6]
		firstElementInGroup[0] = 6 ;leftBg_mc
		firstElementInGroup[1] = 6 ;leftBg_mc
		firstElementInGroup[2] = 19 ;rightBg_mc
		firstElementInGroup[3] = 32 ;shoutBg_mc
		firstElementInGroup[4] = 38 ;consumableBg_mc
		firstElementInGroup[5] = 42 ;poisonBg_mc

		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true) ;Remove DropShadowFilter from all text elements before entering Edit Mode
        ; StoreOpeningValues
        Int iIndex = 0
        afWidget_CurX = new Float[46]
        afWidget_CurY = new Float[46]
        afWidget_CurS = new Float[46]
        afWidget_CurR = new Float[46]
        afWidget_CurA = new Float[46]
        aiWidget_CurD = new Int[46]
        asWidget_CurTA = new string[46]
        aiWidget_CurTC = new int[46]
        abWidget_CurV = new bool[46]
        
        While iIndex < WC.asWidgetDescriptions.Length
            afWidget_CurX[iIndex] = WC.afWidget_X[iIndex]
            afWidget_CurY[iIndex] = WC.afWidget_Y[iIndex]
            afWidget_CurS[iIndex] = WC.afWidget_S[iIndex]
            afWidget_CurR[iIndex] = WC.afWidget_R[iIndex]
            afWidget_CurA[iIndex] = WC.afWidget_A[iIndex]
            aiWidget_CurD[iIndex] = WC.aiWidget_D[iIndex]
            asWidget_CurTA[iIndex] = WC.asWidget_TA[iIndex]
            aiWidget_CurTC[iIndex] = WC.aiWidget_TC[iIndex]
            abWidget_CurV[iIndex] = WC.abWidget_V[iIndex]
            
            iIndex += 1
        EndWhile
        cyclingGroups = true
		SelectedItem = 0
		Element = WidgetRoot + WC.asWidgetElements[SelectedItem]
		bClockwise = true
		MoveStep = 10.0000
		RotateStep = 15.0000
		AlphaStep = 10.0000
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", EMHighlightColor)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeCurrentValueColor", EMCurrentValueColor)
		SetINIFloat("fAutoVanityModeDelay:Camera", 9999999) ;Effectively disables Vanity Camera whilst in Edit Mode    
      
		if !WC.bPreselectMode
			preselectEnabledOnEnter = true
			WC.PM.togglePreselectMode()
		endIf
        
		LoadEditModeWidgets()
		UpdateEditModeInfoText()
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", 0)
		handleEditModeHighlights(1)
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", true)
        
		If RulersShown == 1
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
		elseIf RulersShown == 2
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
		else
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
			UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
		endIf
        
        Game.GetPlayer().AddSpell(iEquip_SlowTimeSpell, false)

        if firstTimeInEditMode
        	firstTimeInEditMode = False
        	debug.MessageBox("iEquip Edit Mode\n\nWelcome to Edit Mode\n\nUse the keys shown at the top of the instructions panel to cycle through the widget elements, press and hold either key to switch between cycling the widget groups or cycling the individual elements.\n\nThe instructions panel also contains information on all the changes you can make in Edit Mode, and how to save and load layout presets.")
        endIf
	else
		handleEditModeHighlights(0)
		SelectedItem = -1

		resetWidgetsToPreviousState()
        UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false) ;Restore DropShadowFilter to all text elements when leaving Edit Mode
		SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
		SetINIFloat("fAutoVanityModeDelay:Camera", CurrentVanityModeDelay) ;Resets Vanity Camera delay back to previous value on leaving Edit Mode
        
        Game.GetPlayer().RemoveSpell(iEquip_SlowTimeSpell)
	endIf
    
	if !bDisabling
		WC.showWidget() ;Reshow widget only if toggleEditMode not called as a result of turning iEquip off in the MCM
	endIf
    
	debug.trace("iEquip EditMode toggleEditMode finished")
endFunction

;Handle mouse clicks on the Load Preset and Save Preset buttons in Edit Mode - have to be contained in the MCM script for the List Menu to work correctly
function showEMPresetListMenu()
    bool bDontExit = true
    
    while bDontExit
        string[] PresetList = JMap.allKeysPArray(JValue.readFromDirectory(WidgetPresetPath, FileExtWP))
    
        if 128 >= PresetList.length && PresetList.length > 0
            int i = 0
            
            while(i < PresetList.length)
                PresetList[i] = Substring(PresetList[i], 0, Find(PresetList[i], "."))
                i += 1
            EndWhile
        
            int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowList("Select a widget preset to load", PresetList, 0, 0)
            
            if MenuReturnArgs[1] == 0       ; Load preset
                int jLoadPreset = jValue.readFromFile(WidgetPresetPath + PresetList[MenuReturnArgs[0]] + FileExtWP)
                int[] abWidget_V_temp = new int[46]

                JArray.writeToFloatPArray(JMap.getObj(jLoadPreset, "_X"), WC.afWidget_X, 0, -1, 0, 0)
                JArray.writeToFloatPArray(JMap.getObj(jLoadPreset, "_Y"), WC.afWidget_Y, 0, -1, 0, 0)
                JArray.writeToFloatPArray(JMap.getObj(jLoadPreset, "_S"), WC.afWidget_S, 0, -1, 0, 0)
                JArray.writeToFloatPArray(JMap.getObj(jLoadPreset, "_R"), WC.afWidget_R, 0, -1, 0, 0)
                JArray.writeToFloatPArray(JMap.getObj(jLoadPreset, "_A"), WC.afWidget_A, 0, -1, 0, 0)
                JArray.writeToIntegerPArray(JMap.getObj(jLoadPreset, "_D"), WC.aiWidget_D, 0, -1, 0, 0)
                JArray.writeToIntegerPArray(JMap.getObj(jLoadPreset, "_TC"), WC.aiWidget_TC, 0, -1, 0, 0)
                JArray.writeToStringPArray(JMap.getObj(jLoadPreset, "_TA"), WC.asWidget_TA, 0, -1, 0, 0)
                JArray.writeToIntegerPArray(JMap.getObj(jLoadPreset, "_V"), abWidget_V_temp, 0, -1, 0, 0)
                
                int iIndex = 0
                while iIndex < WC.asWidgetDescriptions.Length
                    WC.abWidget_V[iIndex] = abWidget_V_temp[iIndex] as bool
                    iIndex += 1
                endwhile
                
                WC.hideWidget()
                Utility.Wait(0.2)
                updateWidgets()
                Utility.Wait(0.1)
                WC.showWidget()
                Debug.Notification("Widget layout switched to " + PresetList[MenuReturnArgs[0]] + FileExtWP)
                
                bDontExit = false
            elseIf MenuReturnArgs[1] == 1   ; Delete preset
                JContainers.removeFileAtPath(WidgetPresetPath + PresetList[MenuReturnArgs[0]] + FileExtWP)
                bDontExit = true
            elseIf MenuReturnArgs[1] == 2   ; Delete preset cancelled
                bDontExit = true
            else                            ; Exit
                bDontExit = false
            endIf
        else
            Debug.Notification("No saved presets found, or there are too many presets")
            bDontExit = false
        endIf
    endWhile
endFunction

function bringToFront()
	debug.trace("iEquip EditMode bringToFront called")
	
	if bringToFrontFirstTime
		debug.MessageBox("This feature allows you to adjust the layer order of the elements within each widget, and the layer order of the widgets themselves\n\n"+\
                         "You cannot bring an element of one widget in front of one from another widget, only elements within the same widget\n\nIt is disabled for backgrounds and when the complete widget is selected for obvious reasons")
		bringToFrontFirstTime = False
	endIf

	if SelectedItem != -1 && !WC.abWidget_isBg[SelectedItem]
		if !startbringToFront
			iItemToMoveToFront = SelectedItem
			debug.MessageBox("Now select the item you want to move the " + WC.asWidgetDescriptions[SelectedItem] + " in front of and press the Bring To Front key a second time")
		else
			int[] args = new int[2]
			args[0] = iItemToMoveToFront
			args[1] = SelectedItem
            
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", args)
			WC.aiWidget_D[iItemToMoveToFront] = SelectedItem
			if WC.aiWidget_D[SelectedItem] == iItemToMoveToFront
				WC.aiWidget_D[SelectedItem] = -1
			endIf
		endIf
	endIf
    
	startbringToFront = !startbringToFront
endFunction

function toggleRulers()
    RulersShown += 1

	if RulersShown == 1
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
	elseIf RulersShown == 2
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
		Utility.Wait(0.5)
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
	else
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
		RulersShown = 0
	endIf
    
	updateEditModeInfoText()
endFunction

function toggleStep(int step)
	debug.trace("iEquip EditMode toggleStep called")
	;0 = MoveStep
	;1 = RotateStep
	;2 = AlphaStep
    
	if step == 0
		if MoveStep == 1.0
			MoveStep = 10.0
		elseIf MoveStep == 10.0
			MoveStep = 50.0
		elseIf MoveStep == 50.0
			MoveStep = 100.0
		elseIf MoveStep == 100.0
			MoveStep = 1.0
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", (MoveStep as int) as String + " pixels")
	elseIf step == 1
		if RotateStep == 15.0000
			RotateStep = 45.0000
		elseIf RotateStep == 45.0000
			RotateStep = 90.0000
		elseIf RotateStep == 90.0000
			RotateStep = 1.00000
		elseIf RotateStep == 1.00000
			RotateStep = 5.00000
		else
			RotateStep = 15.0000
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", (RotateStep as int) as String + " degrees")
	else
		if AlphaStep == 10.0000
			AlphaStep = 20.0000
		elseIf AlphaStep == 20.0000
			AlphaStep = 5.00000
		else
			AlphaStep = 10.0000
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", (AlphaStep as int) as String + "%")
	endIf
endFunction

function toggleRotateDirection()
	debug.trace("iEquip EditMode togglebClockwise called")
    string tmpStr
    
	if bClockwise
        tmpStr = "Counterclockwise"
	else
        tmpStr = "Clockwise"
	endIf
    bClockwise = !bClockwise
    
    UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", tmpStr)
endFunction

; CHECK IF MOVE FUNCTIONS CAN BE COMBINED
function MoveLeft()
	debug.trace("iEquip EditMode MoveLeft called")
	if SelectedItem >= 0
		WC.afWidget_X[SelectedItem] = WC.afWidget_X[SelectedItem] - MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(0, WC.afWidget_X[SelectedItem], fDuration)
	endIf
endFunction

function MoveRight()
	debug.trace("iEquip EditMode MoveRight called")
	If SelectedItem >= 0
		WC.afWidget_X[SelectedItem] = WC.afWidget_X[SelectedItem] + MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(0, WC.afWidget_X[SelectedItem], fDuration)
	EndIf
endFunction

function MoveUp()
	debug.trace("iEquip EditMode MoveUp called")
	If SelectedItem >= 0
		WC.afWidget_Y[SelectedItem] = WC.afWidget_Y[SelectedItem] - MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(1, WC.afWidget_Y[SelectedItem], fDuration)
	EndIf
endFunction

function MoveDown()
	debug.trace("iEquip EditMode MoveDown called")
	If SelectedItem >= 0
		WC.afWidget_Y[SelectedItem] = WC.afWidget_Y[SelectedItem] + MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(1, WC.afWidget_Y[SelectedItem], fDuration)
	EndIf
endFunction

function ScaleUp()
	debug.trace("iEquip EditMode ScaleUp called")
	If SelectedItem >= 0
		WC.afWidget_S[SelectedItem] = WC.afWidget_S[SelectedItem] + MoveStep
		Float fDuration = 0.01*MoveStep
		TweenElement(2, WC.afWidget_S[SelectedItem], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[SelectedItem] as int) as String + "%")
endFunction

function ScaleDown()
	debug.trace("iEquip EditMode ScaleDown called") 
	If SelectedItem >= 0
		WC.afWidget_S[SelectedItem] = WC.afWidget_S[SelectedItem] - MoveStep
		if WC.afWidget_S[SelectedItem] <= 30
			WC.afWidget_S[SelectedItem] = 30
		endIf
		Float fDuration = 0.01*MoveStep
		TweenElement(2, WC.afWidget_S[SelectedItem], fDuration)
	EndIf 
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[SelectedItem] as int) as String + "%")
endFunction

function Rotate()
	debug.trace("iEquip EditMode Rotate called")
	If SelectedItem > 0
		if bClockwise
			WC.afWidget_R[SelectedItem] = WC.afWidget_R[SelectedItem] + RotateStep
			if WC.afWidget_R[SelectedItem] >= 360
				WC.afWidget_R[SelectedItem] = WC.afWidget_R[SelectedItem] - 360
			endIf
		else
			WC.afWidget_R[SelectedItem] = WC.afWidget_R[SelectedItem] - RotateStep
			if WC.afWidget_R[SelectedItem] < 0
				WC.afWidget_R[SelectedItem] = WC.afWidget_R[SelectedItem] + 360
			endIf
		endIf
        
		if WC.afWidget_R[SelectedItem] == 360
			WC.afWidget_R[SelectedItem] = 0
		endIf
        
		Rotation = WC.afWidget_R[SelectedItem] as int
		if Rotation > 180
			Rotation = Rotation - 360
		endIf
        
		Float fDuration = 0.005 * RotateStep
        
		if fDuration < 0.125
			fDuration = 0.125
		endIf
		TweenElement(3, Rotation, fDuration)
	EndIf 
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", Rotation as String + " degrees")
endFunction

function setTextAlignment()
	debug.trace("iEquip EditMode setTextAlignment called")    
	if SelectedItem > 0
        int[] args = new int[2]
		args[0] = SelectedItem
    
		If WC.asWidget_TA[SelectedItem] == "left"
			WC.asWidget_TA[SelectedItem] = "Center"
			args[1] = 1
		elseIf WC.asWidget_TA[SelectedItem] == "center"
			WC.asWidget_TA[SelectedItem] = "Right"
			args[1] = 2
		else
			WC.asWidget_TA[SelectedItem] = "Left"
			args[1] = 0
		endIf

		tweenElement(5, 0, 0.15) ;Fade out before changing alignment
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
		tweenElement(5, WC.afWidget_A[SelectedItem], 0.15) ;Fade back in
	endIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", WC.asWidget_TA[SelectedItem] + " aligned")
endFunction

function SetAlpha()
	debug.trace("iEquip EditMode SetAlpha called")
	If SelectedItem >= 0
		WC.afWidget_A[SelectedItem] = WC.afWidget_A[SelectedItem] - AlphaStep
        
		if WC.afWidget_A[SelectedItem] <= 0
			WC.afWidget_A[SelectedItem] = 100
		endIf
        
		TweenElement(4, WC.afWidget_A[SelectedItem], 0.01 * AlphaStep)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[SelectedItem] as int) as String + "%")
endFunction

function cycleEditModeElements(bool next)
	debug.trace("iEquip EditMode cycleEditModeElements called")
	handleEditModeHighlights(0)
    int firstElement = 0
    int lastElement = 5
	if !cyclingGroups
		firstElement = 6
		lastElement = 45
	endIf
	if next
		SelectedItem += 1
		if SelectedItem > lastElement
			SelectedItem = firstElement
		endIf
	else
		SelectedItem -= 1
		if SelectedItem < firstElement
			SelectedItem = lastElement
		endIf
	endIf
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", SelectedItem)
	handleEditModeHighlights(1)
    Element = WidgetRoot + WC.asWidgetElements[SelectedItem]
	UpdateEditModeInfoText()
endFunction

;This function is called on longpress EditNext/Prev and switches between cycling through the complete widget and widget groups or individual elements
function toggleSelectionRange()
	debug.trace("iEquip EditMode selectCurrentGroup called")
	handleEditModeHighlights(0)
	cyclingGroups = !cyclingGroups
	; If you have a widget group selected then select the first individual element in that group
	if SelectedItem < 6
		SelectedItem = firstElementInGroup[SelectedItem]
	; Otherwise select the widget group containing the currently selected item
	else			
		SelectedItem = WidgetGroups.Find(WC.asWidgetGroup[SelectedItem])
	endIf
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", SelectedItem)
	handleEditModeHighlights(1)
    Element = WidgetRoot + WC.asWidgetElements[SelectedItem]
	UpdateEditModeInfoText()
endFunction

; ##############
; ### RESETS ###

function DiscardChanges()
	if iEquip_ConfirmDiscardChanges.Show() ;Add messagebox to check if user wants to discard changes and revert to state saved on entering Edit Mode, return out if not
        Int iIndex = 0
        
        WC.hideWidget()
        Wait(0.2)
        
        While iIndex < WC.asWidgetDescriptions.Length
            WC.afWidget_X[iIndex] = afWidget_CurX[iIndex]
            WC.afWidget_Y[iIndex] = afWidget_CurY[iIndex]
            WC.afWidget_S[iIndex] = afWidget_CurS[iIndex]
            WC.afWidget_R[iIndex] = afWidget_CurR[iIndex]
            WC.afWidget_A[iIndex] = afWidget_CurA[iIndex]
            WC.aiWidget_D[iIndex] = aiWidget_CurD[iIndex]
            WC.aiWidget_TC[iIndex] = aiWidget_CurTC[iIndex]
            WC.asWidget_TA[iIndex] = asWidget_CurTA[iIndex]
            WC.abWidget_V[iIndex] = abWidget_CurV[iIndex]
            iIndex += 1
        EndWhile
        
        updateWidgets()
        UpdateEditModeInfoText()
        WC.showWidget()
	endIf
endFunction

function ResetItem() ; NEEDS TO BE REWRITTEN/OPTIMIZED
    debug.trace("iEquip EditMode ResetItem called")
    If SelectedItem > 0
        self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
        If WC.abWidget_isParent[SelectedItem]
            int iButton = iEquip_ConfirmResetParent.Show() ;Add messagebox to check if user wants to reset parent and all child elements or not, return out if not
            if iButton != 1
                return
            endIf
        else
            int iButton = iEquip_ConfirmReset.Show() ;Add messagebox to check if user wants to reset element or not, return out if not
            if iButton != 1
                return
            endIf
        endIf
        tweenElement(5, 0, 0.15)
        Utility.Wait(0.15)
        ;Reset single element - if it is a parent element reset the parent clip first then check below and reset the children
        resetSingleElement(SelectedItem, WC.abWidget_isParent[SelectedItem])
        ;Check if selected element is one of the widget parents and reset all children accordingly
        if WC.abWidget_isParent[SelectedItem]
            debug.trace("iEquip EditMode ResetChildren called")
            String Group = WC.asWidgetGroup[SelectedItem]
            int i = 6
            While i < WC.asWidgetDescriptions.Length
                if WC.asWidgetGroup[i] == Group
                    resetSingleElement(i, false, true)
                endIf
                i += 1
            EndWhile
            tweenElement(5, WC.afWidget_A[SelectedItem], 0.2)
            debug.Notification("All elements of the " + WC.asWidgetDescriptions[SelectedItem] + " have been reset")
            debug.trace("iEquip EditMode ResetChildren finished")
        endIf
        self.UnRegisterForModEvent("iEquip_GotDepth")
    EndIf
    UpdateEditModeInfoText()
    debug.trace("iEquip EditMode ResetItem finished")
endFunction

function resetSingleElement(int iIndex, bool parentClip = false, bool resettingChild = false)
	debug.trace("iEquip EditMode resetSingleElement called - iIndex: " + iIndex + ", parentClip: " + parentClip + ", resettingChild: " + resettingChild)
	WC.afWidget_X[iIndex] = WC.afWidget_DefX[iIndex]
	WC.afWidget_Y[iIndex] = WC.afWidget_DefY[iIndex]
	WC.afWidget_S[iIndex] = WC.afWidget_DefS[iIndex]
	WC.afWidget_R[iIndex] = WC.afWidget_DefR[iIndex]
	WC.afWidget_A[iIndex] = WC.afWidget_DefA[iIndex]
    
	if WC.abWidget_isText[iIndex] ;Checks if the element is text and applies the default text size and alignment
		WC.asWidget_TA[iIndex] = WC.asWidget_DefTA[iIndex]
		int alignment
		If WC.asWidget_TA[iIndex] == "left"
			alignment = 0
		elseIf WC.asWidget_TA[iIndex] == "center"
			alignment = 1
		else
			alignment = 2
		endIf
		int[] args = new int[2]
		args[0] = iIndex
		args[1] = alignment
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
		args[1] = 0xFFFFFF
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
	endIf
    
	UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._x", WC.afWidget_X[iIndex])
	UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._y", WC.afWidget_Y[iIndex])
	UI.setFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._xscale", WC.afWidget_S[iIndex])
	UI.setFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._yscale", WC.afWidget_S[iIndex])
	UI.setFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._rotation", WC.afWidget_R[iIndex])

	UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true)
	if BringToFrontEnabled
		SetDepthOrder(iIndex, 1)
	endIf
    
	If !parentClip && !resettingChild
		debug.Notification("The " + WC.asWidgetDescriptions[iIndex] + " has been reset")
		tweenElement(5, WC.afWidget_A[iIndex], 0.2)
	endIf
endFunction

function resetWidgetsToPreviousState()
	int Q = 0
	;Reset all names and reregister for fades if required
	while Q < 8
		WC.showName(Q, true, false, 0.0)
		Q += 1
	endWhile
	;Reset left and right counters
	if !wasLeftCounterShown
		WC.setCounterVisibility(0, false)
	else
		WC.setSlotCount(0, previousLeftCount)
	endIf
	if !wasRightCounterShown
		WC.setCounterVisibility(1, false)
	else
		WC.setSlotCount(1, previousRightCount)
	endIf
	Q = 0
	int iHandle
	while Q < 2
		;Reset poison elements
		if !WC.abPoisonInfoDisplayed[Q]
			WC.hidePoisonInfo(Q, true)
		else
			WC.checkAndUpdatePoisonInfo(Q)
		endIf
		;Reset attribute icons
		WC.hideAttributeIcons(Q)
		if WC.bPreselectMode && preselectEnabledOnEnter
			WC.updateAttributeIcons(Q, 0)
		endIf
		Q += 1
	endWhile
	;Reset Preselect Mode
	if preselectEnabledOnEnter && WC.bPreselectMode
        WC.PM.togglePreselectMode()
		preselectEnabledOnEnter = false
	endIf
	;Reset enchantment meters and soulgems
	CM.updateChargeMeters(true)
endFunction

function ResetDefaults()
	debug.trace("iEquip EditMode ResetDefaults called")
	WC.hideWidget()
	UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	debug.Notification("Resetting iEquip...")
	WC.ResetWidgetArrays()
	updateWidgets()
    
	if isEditMode
		SelectedItem = 0
		LoadEditModeWidgets()
		UpdateEditModeInfoText()
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", true)
	endIf
    
	WC.showWidget()
	MCM.bReset = false

	debug.Notification("All iEquip widgets reset")
	debug.trace("iEquip EditMode ResetDefaults finished")
endFunction
