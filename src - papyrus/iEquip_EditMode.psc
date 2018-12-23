ScriptName iEquip_EditMode Extends Quest

; - IMPORTS

import Utility
import StringUtil
import iEquip_UILIB

; - SCRIPTS

iEquip_WidgetCore Property WC Auto
iEquip_ProMode Property PM Auto

; - REFERENCES -

Spell Property iEquip_SlowTimeSpell  Auto
Message property iEquip_ConfirmReset Auto
Message Property iEquip_ConfirmResetParent Auto
Message Property iEquip_ConfirmDiscardChanges Auto

; - WIDGET VARIABLES -

float[] afWidget_CurX
float[] afWidget_CurY
float[] afWidget_CurS
float[] afWidget_CurR
float[] afWidget_CurA
int[] aiWidget_CurD
int[] aiWidget_CurTC
string[] asWidget_CurTA
bool[] abWidget_CurV

; - Bools -

bool Property isEditMode = false Auto Hidden
bool Property bDisabling = false Auto Hidden
bool bFirstCycleKeyPressed = true
bool bringToFrontFirstTime = true
bool property preselectEnabledOnEnter = false auto hidden
bool property wasLeftCounterShown = false auto hidden
bool property wasRightCounterShown = false auto hidden

; - Floats -

float CurrentVanityModeDelay

; - Ints -

int Property iSelectedElement = -1 Auto Hidden
int[] iCustomColors
int[] iFirstElementInGroup
int iFirstElement
int iLastElement
int iHighlightColor = 0x0099FF
int iCurrentColorValue = 0xEAAB00
int iLastColorSelection
int iNextColorIndex
int property previousLeftCount auto hidden
int property previousRightCount auto hidden
int iSelectedElementFront = -1
int MoveStep
int RotateStep
int AlphaStep
int RulersShown = 1

; - Strings -

string Property WidgetPresetPath = "Data/iEquip/Widget Presets/" autoReadonly
string Property FileExtWP = ".IEQP" autoReadonly
string[] WidgetGroups
string[] sTextAlignment
string HUD_MENU = "HUD Menu"
string WidgetRoot
string sRotation

; ######################
; ### INITIALIZATION ###

function OnInit()
	iCustomColors = new int[14]
    
	int iIndex = iCustomColors.length
	While iIndex > 0
        iIndex -= 1
		iCustomColors[iIndex] = -1
	endWhile
endFunction

; #######################
; ### Toggle EditMode ###

Auto State FirstTimeEntering
    function ToggleEditMode()
        Gotostate("")
        ToggleEditMode()
        debug.MessageBox("iEquip Edit Mode\n\nWelcome to Edit Mode\n\nHere you can change the position, size and rotation of every individual element in the widget,"+\
                         "as well as the alignment and text colour of any text element.\n\nThe instructions panel also contains information on all the changes you can make in Edit Mode, and how to save and load layout presets.")
    endFunction
endState

function ToggleEditMode()
    WidgetRoot = WC.WidgetRoot
	WC.updateWidgetVisibility(false)
    Wait(0.2)
    isEditMode = !isEditMode
    
	if isEditMode
        CurrentVanityModeDelay = GetINIFloat("fAutoVanityModeDelay:Camera")
        
		WidgetGroups = new String[6]
		WidgetGroups[0] = ""
		WidgetGroups[1] = "Left"
		WidgetGroups[2] = "Right"
		WidgetGroups[3] = "Shout"
		WidgetGroups[4] = "Consumable"
		WidgetGroups[5] = "Poison"
        sTextAlignment = new string[3]
        sTextAlignment[0] = "Left"
        sTextAlignment[1] = "Center"
        sTextAlignment[2] = "Right"

		iFirstElementInGroup = new int[6]
		iFirstElementInGroup[0] = 6  ; leftBg_mc
		iFirstElementInGroup[1] = 6  ; leftBg_mc
		iFirstElementInGroup[2] = 19 ; rightBg_mc
		iFirstElementInGroup[3] = 32 ; shoutBg_mc
		iFirstElementInGroup[4] = 38 ; consumableBg_mc
		iFirstElementInGroup[5] = 42 ; poisonBg_mc

		if WC.bDropShadowEnabled
            UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true) ;Remove DropShadowFilter from all text elements before entering Edit Mode
        endIf
        ; StoreOpeningValues
        int iIndex = 0
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
        iFirstElement = 0
        iLastElement = 5
		iSelectedElement = 0
        iSelectedElementFront = -1
		sRotation = "Clockwise"
		MoveStep = 10
		RotateStep = 15
		AlphaStep = 10
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", iHighlightColor)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeCurrentValueColor", iCurrentColorValue)
		SetINIFloat("fAutoVanityModeDelay:Camera", 9999999) ;Effectively disables Vanity Camera whilst in Edit Mode    
      
		if !WC.bPreselectMode
			preselectEnabledOnEnter = true
			PM.togglePreselectMode()
		endIf
        
		LoadAllElements()
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", 0)
		HighlightElement(true)
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
	else
		HighlightElement(false)
		iSelectedElement = -1

		WC.resetWidgetsToPreviousState()
        if WC.bDropShadowEnabled
            UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false) ;Restore DropShadowFilter to all text elements when leaving Edit Mode
        endIf
		UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
		SetINIFloat("fAutoVanityModeDelay:Camera", CurrentVanityModeDelay) ;Resets Vanity Camera delay back to previous value on leaving Edit Mode
        
        Game.GetPlayer().RemoveSpell(iEquip_SlowTimeSpell)
	endIf
    
	if !bDisabling
		WC.updateWidgetVisibility() ;Reshow widget only if toggleEditMode not called as a result of turning iEquip off in the MCM
	endIf
endFunction

; #######################
; ### Element Editing ###

; - Highlight -

function HighlightElement(bool bAdd)
	debug.trace("iEquip EditMode HighlightElement called")
	int[] iArgs = new int[3]
	iArgs[0] = WC.abWidget_isText[iSelectedElement] as int   ; Is text element
	iArgs[1] = iSelectedElement                              ; iSelectedElement                
	iArgs[2] = WC.aiWidget_TC[iSelectedElement]              ; Current text colour if text element
    
	if bAdd
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".highlightSelectedElement", iArgs)
	else
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".removeCurrentHighlight", iArgs)
	endIf
endFunction

; - Depth -

function SwapIndexDepth(int[] iDepthIndex)
    ; Takes int array iDepthIndex[2] as param, and swaps the widget depth for the indexes
    int iTmp = WC.aiWidget_D[iDepthIndex[0]]

    WC.aiWidget_D[iDepthIndex[0]] = WC.aiWidget_D[iDepthIndex[1]]
    WC.aiWidget_D[iDepthIndex[1]] = iTmp
    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", iDepthIndex)
endFunction

function SwapElementDepth()
    ; Swap depth of the two selected elements

	if bringToFrontFirstTime
		debug.MessageBox("This feature allows you to adjust the layer order of the elements within each widget, and the layer order of the widgets themselves\n\n"+\
                         "You cannot bring an element of one widget in front of one from another widget, only elements within the same widget\n\nIt is disabled for backgrounds and when the complete widget is selected for obvious reasons")
		bringToFrontFirstTime = False
	endIf

	if iSelectedElement != -1 && !WC.abWidget_isBg[iSelectedElement]
		if iSelectedElementFront == -1
			iSelectedElementFront = iSelectedElement
			debug.MessageBox("Now select the item you want to move the " + WC.asWidgetDescriptions[iSelectedElement] + " in front of and press the Bring To Front key a second time")
		else
            if WC.asWidgetGroup[iSelectedElementFront] == WC.asWidgetGroup[iSelectedElement]
                int[] iDepthIndex = new int[2]
                iDepthIndex[0] = iSelectedElementFront
                iDepthIndex[1] = iSelectedElement
                
                SwapIndexDepth(iDepthIndex)
            else
                debug.notification("Error: The selected elements are not part of the same widget")
            endIf
            
            iSelectedElementFront = -1
		endIf
	endIf
endFunction

function SetElementDepthOrder(int DepthIndexA, bool bSet = true)
    int DepthIndexB

    debug.notification("Setting depth")
    
	if bSet       ; SET
        DepthIndexB = WC.aiWidget_D[DepthIndexA]
        if DepthIndexA >= DepthIndexB
            DepthIndexB = -1
        endIf
	else          ; RESET
        ; Check that value is not default already
        if WC.aiWidget_D[DepthIndexA] != WC.aiWidget_DefD[DepthIndexA]
            int iIndex = 0
            
            ; Find iIndex with default value for DepthIndexA
            while WC.aiWidget_D[iIndex] != WC.aiWidget_DefD[DepthIndexA]
                iIndex += 1
            endWhile
            DepthIndexB = iIndex
        else
            DepthIndexB = -1
        endIf 
	endIf
    
    if DepthIndexB != -1
        int[] iArgs = new int[2]
        iArgs[0] = DepthIndexA
        iArgs[1] = DepthIndexB
    
        SwapIndexDepth(iArgs)
    endIf
endFunction

; - Tween -

Function TweenElement(float attribute, float targetValue, float duration)
	float[] iArgs = new float[3]
	iArgs[0] = attribute     ; Attribute to change - 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 = _rotation, 4 = _alpha
	iArgs[1] = targetValue   ; Target value - sent from calling function as value after increment applied
	iArgs[2] = duration      ; Duration in seconds for tween to take
    
	UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenIt", iArgs)
EndFunction

; - Move -

function MoveElement(int iDirection)
    ; 0 = Up    1 = Down
    ; 2 = Left  3 = Right

    if iSelectedElement != -1
        float fDuration = 0.005 * MoveStep
    
        if iDirection < 2
            if iDirection == 0  ; Up
                WC.afWidget_Y[iSelectedElement] = WC.afWidget_Y[iSelectedElement] - MoveStep
            else                ; Down
                WC.afWidget_Y[iSelectedElement] = WC.afWidget_Y[iSelectedElement] + MoveStep
            endIf
        
            TweenElement(1, WC.afWidget_Y[iSelectedElement], fDuration)
        else
            if iDirection == 2  ; Left
                WC.afWidget_X[iSelectedElement] = WC.afWidget_X[iSelectedElement] - MoveStep
            else                ; Right
                WC.afWidget_X[iSelectedElement] = WC.afWidget_X[iSelectedElement] + MoveStep
            endIf
        
            TweenElement(0, WC.afWidget_X[iSelectedElement], fDuration)
        endIf
    endIf
endFunction

; - Scale -

function ScaleElement(int iScale)
    if iSelectedElement != -1
        float fDuration = 0.01 * MoveStep
    
        if iScale == 0      ; Up
            WC.afWidget_S[iSelectedElement] = WC.afWidget_S[iSelectedElement] + MoveStep
        else                ; Down
            WC.afWidget_S[iSelectedElement] = WC.afWidget_S[iSelectedElement] - MoveStep
            if WC.afWidget_S[iSelectedElement] <= 30
                WC.afWidget_S[iSelectedElement] = 30
            endIf
        endIf
    
        TweenElement(2, WC.afWidget_S[iSelectedElement], fDuration)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iSelectedElement] as int) as String + "%")
    endIf
endFunction

; - Rotate -

function RotateElement()
	if iSelectedElement > 0
        float fDuration = 0.005 * RotateStep
        int iRotation = WC.afWidget_R[iSelectedElement] as int
        
        if fDuration < 0.125
			fDuration = 0.125
		endIf
    
		if sRotation == "Clockwise"
			iRotation = iRotation + RotateStep
       
            If iRotation >= 360
                iRotation = 0
            endIf
		else
            iRotation = iRotation - RotateStep
        
            if WC.afWidget_R[iSelectedElement] == 0
                iRotation = 360 - RotateStep
            elseIf iRotation < 0
                iRotation = 0
            endIf
		endIf
        
        WC.afWidget_R[iSelectedElement] = iRotation as float
		TweenElement(3, WC.afWidget_R[iSelectedElement], fDuration)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", iRotation as String + " degrees")
	EndIf 
endFunction

; - Transparency -

function SetElementAlpha()
	If iSelectedElement != -1
		WC.afWidget_A[iSelectedElement] = WC.afWidget_A[iSelectedElement] - AlphaStep
		if WC.afWidget_A[iSelectedElement] <= 0
			WC.afWidget_A[iSelectedElement] = 100
		endIf
        
		TweenElement(4, WC.afWidget_A[iSelectedElement], 0.01 * AlphaStep)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iSelectedElement] as int) as String + "%")
	EndIf
endFunction

; ########################
; ### Element Handling ###

; - Apply Color -

function ApplyElementColor (int iType, int iColor)
    if iColor > 0
        if iType == 0
	            iHighlightColor = iColor
	            UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", iColor)
	            HighlightElement(true)
        elseIf iType == 1
            iCurrentColorValue = iColor
            UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeCurrentValueColor", iColor)
        else
            WC.aiWidget_TC[iSelectedElement] = iColor
            int[] args = new int[2]
            args[0] = iSelectedElement
            args[1] = iColor
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
        endIf
    endIf
endFunction

function ToggleCycleRange()
	if bFirstCycleKeyPressed
		bFirstCycleKeyPressed = false
		showCyclingHelp()	
	endIf
    ; Toggle between cycling groups/single enlements
    HighlightElement(false)
    
    if 0 <= iSelectedElement && iSelectedElement  <= 5           ; If group is selected, find first child
        iSelectedElement = iFirstElementInGroup[iSelectedElement]
        iFirstElement = 6
        iLastElement = 45
    else                                    ; Else find parent group
        iSelectedElement = WidgetGroups.Find(WC.asWidgetGroup[iSelectedElement])
        iFirstElement = 0
        iLastElement = 5
    endIf
    
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iSelectedElement)
    HighlightElement(true)
    UpdateEditModeGuide()
endFunction

; - Cycle Elements -

function CycleElements(int iNextPrev)    
	if bFirstCycleKeyPressed
		bFirstCycleKeyPressed = false
		showCyclingHelp()	
	endIf
    HighlightElement(false)
    
    iSelectedElement += iNextPrev
	if iNextPrev == 1   ; Next
		if iSelectedElement > iLastElement
			iSelectedElement = iFirstElement
		endIf
	else                ; Previous
		if iSelectedElement < iFirstElement
			iSelectedElement = iLastElement
		endIf
	endIf
    
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iSelectedElement)
	HighlightElement(true)
	UpdateEditModeGuide()
endFunction

function showCyclingHelp()
	debug.MessageBox("!!! IMPORTANT INFORMATION !!!\n\nCycling elements in Edit Mode\n\nSINGLE PRESS the keys shown at the top of the instructions panel to cycle through the widget elements."+\
        "\n\nPRESS AND HOLD either key to switch from cycling the widget groups to cycling the individual elements.")
endFunction

; - Update Data -

function UpdateElementData(int iIndex, bool bVisible, bool bUpdateAlpha = true)
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._x", WC.afWidget_X[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._y", WC.afWidget_Y[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._xscale", WC.afWidget_S[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._yscale", WC.afWidget_S[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._rotation", WC.afWidget_R[iIndex])
    
    if bUpdateAlpha
        UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._alpha", WC.afWidget_A[iIndex])
    endIf
    
    UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", bVisible)
endFunction

function UpdateElementText(int[] iArgs, int iNewColor) 
    If WC.asWidget_TA[iArgs[0]] == "Left"
        iArgs[1] = 0
    elseIf WC.asWidget_TA[iArgs[0]] == "Center"
        iArgs[1] = 1
    else
        iArgs[1] = 2
    endIf
    
    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", iArgs)
    iArgs[1] = iNewColor
    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".SetTextColor", iArgs)
endFunction

function UpdateEditModeGuide()
	if iSelectedElement != -1
        string tmpStr
    
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.SelectedElementText.text", WC.asWidgetDescriptions[iSelectedElement])
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", MoveStep as String + " pixels")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", RotateStep as String + " degrees")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", AlphaStep as String + "%")
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", sRotation)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iSelectedElement] as int) as String + "%")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", (WC.afWidget_R[iSelectedElement] as int) as String + " degrees")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iSelectedElement] as int) as String + "%")
        
		if WC.abWidget_isText[iSelectedElement]
            tmpStr = WC.asWidget_TA[iSelectedElement] + " aligned"
		else
            tmpStr = ""
		endIf
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", tmpStr)
        
		If RulersShown == 1
            tmpStr = "Edge grid"
		elseIf RulersShown == 2
            tmpStr = "Fullscreen grid"
		else
            tmpStr = "Hidden"
        endIf
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", tmpStr)
	endIf
endFunction

function UpdateElementsAll()
    int[] iArgs = new int[2]
    int iIndex = 0
    
	while iIndex < WC.asWidgetDescriptions.Length  
        if WC.abWidget_isText[iIndex]
            iArgs[0] = iIndex
            UpdateElementText(iArgs, WC.aiWidget_TC[iIndex])
        endIf
        
        UpdateElementData(iIndex, WC.abWidget_V[iIndex])
        iIndex += 1
    endWhile
    
    if !WC.bIsFirstLoad && !WC.bLoading
        iIndex = 1
    
        while iIndex < WC.asWidgetDescriptions.Length
            SetElementDepthOrder(iIndex)
            iIndex += 1
        endWhile

        HighlightElement(true)
    endIf

endFunction

; - Load Data -

; CHECK IF CAN BE REWRITTEN/OPTIMIZED
function LoadAllElements()
	int iIndex = WC.asWidgetDescriptions.Length
    
	While iIndex > 0
        iIndex -= 1
		UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true) ;Everything else other than the backgrounds needs to be visible in Edit Mode
	EndWhile
    
	; Show left and right counters if not currently shown
	if !WC.abIsCounterShown[0]
		wasLeftCounterShown = false
		WC.setCounterVisibility(0, true)
	else
		wasLeftCounterShown = true
		previousLeftCount = UI.getString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text") as int
	endIf
	WC.setSlotCount(0,99)
    
	if !WC.abIsCounterShown[1]
		wasRightCounterShown = false
		WC.setCounterVisibility(1, true)
	else
		wasRightCounterShown = true
		previousRightCount = UI.getString(HUD_MENU, WidgetRoot + ".widgetMaster.RightHandWidget.rightCount_mc.rightCount.text") as int
	endIf
	WC.setSlotCount(1,99)
    
	; Show any currently hidden names
	while iIndex < 8
		if !WC.abIsNameShown[iIndex]
			WC.showName(iIndex, true, false, 0.0)
		endIf
		iIndex += 1
	endWhile
	iIndex = 0

	while iIndex < 2
		; Check and show left and right poison elements if not already displayed
		if !WC.abPoisonInfoDisplayed[iIndex]
			string poisonNamePath = ".widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName.text"
			if iIndex == 1
				poisonNamePath = ".widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName.text"
			endIf
			UI.SetString(HUD_MENU, WidgetRoot + poisonNamePath, "Some horrible poison")
            CreateHandleIntStr(".updatePoisonIcon", iIndex, "Drops3")
		endIf
        
		if !WC.abIsPoisonNameShown[iIndex]
			WC.showName(iIndex, true, true, 0.0)
		endIf

		;Check and show left and right attribute icons including those for the preselect slots
        CreateHandleIntStr(".updateAttributeIcons", iIndex, "Both")
        CreateHandleIntStr(".updateAttributeIcons", iIndex + 5, "Both")

		iIndex += 1
	endWhile
    
    UpdateEditModeGuide()
endFunction

; ####################
; ### Edit Toggles ###

function ToggleTextAlignment()
    if WC.abWidget_isText[iSelectedElement]
        int[] iArgs = new int[2]
        iArgs[0] = iSelectedElement
    
        TweenElement(5, 0, 0.15)                                 ; Fade out before changing alignment
        
        If WC.asWidget_TA[iArgs[0]] == "Left"
            iArgs[1] = 1
        elseIf WC.asWidget_TA[iArgs[0]] == "Center"
            iArgs[1] = 2
        else
            iArgs[1] = 0
        endIf
    
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", iArgs)
        WC.asWidget_TA[iSelectedElement] = sTextAlignment[iArgs[1]]
        
        TweenElement(5, WC.afWidget_A[iSelectedElement], 0.15)   ; Fade back in
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", WC.asWidget_TA[iSelectedElement] + " aligned")
    endIf
endfunction

function ToggleRulers()
    RulersShown += 1

	if RulersShown == 1
		UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
	elseIf RulersShown == 2
		UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
		Wait(0.5)
		UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
	else
		UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
		RulersShown = 0
	endIf
    
	UpdateEditModeGuide()
endFunction

function IncrementStep(int iStep)
	if iStep == 0                    ; MoveStep
		if MoveStep == 1
			MoveStep = 10
		elseIf MoveStep == 10
			MoveStep = 50
		elseIf MoveStep == 50
			MoveStep = 100
		elseIf MoveStep == 100
			MoveStep = 1
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", MoveStep as String + " pixels")
	elseIf iStep == 1                ; RotateStep
		if RotateStep == 15
			RotateStep = 45
		elseIf RotateStep == 45
			RotateStep = 90
		elseIf RotateStep == 90
			RotateStep = 1
		elseIf RotateStep == 1
			RotateStep = 5
		else
			RotateStep = 15
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", RotateStep as String + " degrees")
	else                            ; AlphaStep
		if AlphaStep == 10
			AlphaStep = 20
		elseIf AlphaStep == 20
			AlphaStep = 5
		else
			AlphaStep = 10
		endIf
        
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", AlphaStep as String + "%")
	endIf
endFunction

function ToggleRotation()
	if sRotation == "Clockwise"
        sRotation = "Counterclockwise"
	else
        sRotation = "Clockwise"
	endIf
    
    UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", sRotation)
endFunction

; #############
; ### Menus ###

function ShowPresetList()
    bool bDontExit = true
    
    while bDontExit
        string[] sPresetList = JMap.allKeysPArray(JValue.readFromDirectory(WidgetPresetPath, FileExtWP))
    
        if 0 < sPresetList.length
            int i = 0
            
            while(i < sPresetList.length)
                sPresetList[i] = Substring(sPresetList[i], 0, Find(sPresetList[i], "."))
                i += 1
            EndWhile
        
            int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowList("Select a widget preset to load", sPresetList, 0, 0)
            
            if MenuReturnArgs[1] == 0       ; Load preset
                LoadPreset(jValue.readFromFile(WidgetPresetPath + sPresetList[MenuReturnArgs[0]] + FileExtWP))
                Debug.Notification("Widget layout switched to " + sPresetList[MenuReturnArgs[0]] + FileExtWP)
                bDontExit = false
            elseIf MenuReturnArgs[1] == 1   ; Delete preset
                bDontExit = true
                JContainers.removeFileAtPath(WidgetPresetPath + sPresetList[MenuReturnArgs[0]] + FileExtWP)
            elseIf MenuReturnArgs[1] == 2   ; Delete preset cancelled
                bDontExit = true
            else                            ; Exit
                bDontExit = false
            endIf
        else
            Debug.Notification("No saved presets found")
            bDontExit = false
        endIf
    endWhile
endFunction

function ShowColorSelection(int iType)
    string sText
	int iColor
    int iDefColor
    iLastColorSelection = iType
    
	if iType == 0       ; Highlight colour
		sText = "Select a color for selected item highlights"
		iColor = iHighlightColor
		iDefColor = 0x0099FF
	elseIf iType == 1   ; Current item info text colour
		sText = "Select a color for selected item info text"
		iColor = iCurrentColorValue
		iDefColor = 0xEAAB00
	else                ; Selected text colour
        ; Make sure element is text
        if WC.abWidget_isText[iSelectedElement]
            sText = "Select a text color for selected text element"
            iColor = WC.aiWidget_TC[iSelectedElement]
            iDefColor = 0xFFFFFF
        else
            sText = ""
        endIf
    endIf
    
    ; Show color menu
    if sText != ""
        int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowColorMenu(sText, iColor, iDefColor, iCustomColors)
        
        if MenuReturnArgs[1] == 0               ; Selected Color
            ApplyElementColor(iType, MenuReturnArgs[0])
        elseIf MenuReturnArgs[1] == 1           ; Custom Color
            string sInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("Enter a custom colour hex code", "RRGGBB")
            
            if sInput != "" && sInput != "RRGGBB"
                iCustomColors[iNextColorIndex] = HexStringToInt(sInput)
                ApplyElementColor(iType, iCustomColors[iNextColorIndex])
                iNextColorIndex = (iNextColorIndex + 1) % iCustomColors.length
            endIf
        endIf
    endIf
endFunction

function DeleteCustomColor(int iDeleteIndex)
    ; Deletes color index and sorts remaining slots
    int iArrayIndexes = iCustomColors.length - 1
    iCustomColors[iDeleteIndex] = -1
    
    while iDeleteIndex < iArrayIndexes
        iCustomColors[iDeleteIndex] = iCustomColors[iDeleteIndex + 1]
        iDeleteIndex += 1
    endWhile

    iNextColorIndex = (iNextColorIndex - 1) % iCustomColors.length
    ShowColorSelection(iLastColorSelection)
endFunction

; #############################
; ### Preset Saving/Loading ###

; - Save -

function SavePreset()
    string textInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("Name this layout preset", "")
    
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
endFunction

; - Load -

function LoadPreset(int jPreset)
    int[] abWidget_V_temp = new int[46]

    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_X"), WC.afWidget_X, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_Y"), WC.afWidget_Y, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_S"), WC.afWidget_S, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_R"), WC.afWidget_R, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_A"), WC.afWidget_A, 0, -1, 0, 0)
    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_D"), WC.aiWidget_D, 0, -1, 0, 0)
    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_TC"), WC.aiWidget_TC, 0, -1, 0, 0)
    JArray.writeToStringPArray(JMap.getObj(jPreset, "_TA"), WC.asWidget_TA, 0, -1, 0, 0)
    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_V"), abWidget_V_temp, 0, -1, 0, 0)
    
    int iIndex = WC.asWidgetDescriptions.Length
    while iIndex > 0
        iIndex -= 1
        WC.abWidget_V[iIndex] = abWidget_V_temp[iIndex] as bool
    endwhile
    
    WC.updateWidgetVisibility(false)
    Wait(0.2)
    UpdateElementsAll()
    Wait(0.1)
    WC.updateWidgetVisibility()
endFunction

; #####################
; ### Reset/Discard ###

; - Discard -

function DiscardChanges()
    ; Confirmation messagebox
	if iEquip_ConfirmDiscardChanges.Show()
        Int iIndex = 0
        
        WC.updateWidgetVisibility(false)
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
        
        UpdateElementsAll()
        UpdateEditModeGuide()
        WC.updateWidgetVisibility()
	endIf
endFunction

; - Reset  -

function ResetElementIndex(int[] iArgs, int iIndex)
    WC.afWidget_X[iIndex] = WC.afWidget_DefX[iIndex]
    WC.afWidget_Y[iIndex] = WC.afWidget_DefY[iIndex]
    WC.afWidget_S[iIndex] = WC.afWidget_DefS[iIndex]
    WC.afWidget_R[iIndex] = WC.afWidget_DefR[iIndex]
    WC.afWidget_A[iIndex] = WC.afWidget_DefA[iIndex]
    
    if WC.abWidget_isText[iIndex]
        WC.asWidget_TA[iIndex] = WC.asWidget_DefTA[iIndex]
        iArgs[0] = iIndex
        UpdateElementText(iArgs, 0xFFFFFF)
    endIf

    UpdateElementData(iIndex, true, false)
    SetElementDepthOrder(iIndex, false)
endFunction

function ResetElement()
    If iSelectedElement > 0
        Message msgBox
    
        If WC.abWidget_isParent[iSelectedElement]
            msgBox = iEquip_ConfirmResetParent
        else
            msgBox = iEquip_ConfirmReset
        endIf
        
        ; Confirm choice
        if msgBox.Show() == 1
            int[] iArgs = new int[2]
            HighlightElement(false)
            TweenElement(5, 0, 0.15)
            Wait(0.15)
            
            ; Reset element and children
            ResetElementIndex(iArgs, iSelectedElement)
            if WC.abWidget_isParent[iSelectedElement]
                int iIndex = 6
                
                While iIndex < WC.asWidgetDescriptions.Length
                    if WC.asWidgetGroup[iIndex] == WC.asWidgetGroup[iSelectedElement]
                        ResetElementIndex(iArgs, iIndex)
                    endIf
                    iIndex += 1
                EndWhile
            endIf
            
            TweenElement(5, WC.afWidget_A[iSelectedElement], 0.2)
            UpdateEditModeGuide()
            HighlightElement(true)
        endIf
    EndIf
endFunction

function ResetDefaults()
    ; Resets all widget data
	debug.Notification("Resetting iEquip...")
	WC.updateWidgetVisibility(false)
	UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	WC.ResetWidgetArrays()
	UpdateElementsAll()
    
	if isEditMode
		iSelectedElement = 0
		LoadAllElements()
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", true)
	endIf
    
	WC.updateWidgetVisibility()
	debug.Notification("Finished resetting iEquip")
endFunction

; #####################
; ### MISCELLANEOUS ###

; - CreateCallbackHandle -

bool function CreateHandleIntStr(string func, int i, string str)
    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + func)
    if(iHandle)
        UICallback.PushInt(iHandle, i)
        UICallback.PushString(iHandle, str)
        UICallback.Send(iHandle)
        
        return true
    else
        return false
    endif
endFunction

; - HexToInt -

int function HexStringToInt(string sHex)
    int iDec = 0
    int iPlace = 1
    int iIndex = 6
    
    while iIndex > 0
        iIndex -= 1
        string sChar = SubString(sHex, iIndex, 1)
        int iSubNumber = 0
        
        If IsDigit(sChar)
            iSubNumber = sChar as int
        Else
            iSubNumber = AsOrd(sChar) - 55
        EndIf
        
        iDec += iSubNumber * iPlace
        iPlace *= 16
    endWhile
    
    Return iDec
endFunction
