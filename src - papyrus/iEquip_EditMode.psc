ScriptName iEquip_EditMode Extends Quest

import UI
import Utility
import iEquip_Utility
import StringUtil

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_KeyHandler Property KH Auto
iEquip_SlowTime Property ST Auto

bool property isEditMode = False Auto
int property SelectedItem = 0 Auto

String HUD_MENU
String WidgetRoot

bool ResettingChildren = False
bool property Disabling = false Auto
bool bLeavingEditMode = False
bool startBringToFront = False

Float MoveStep
Float RotateStep
Float AlphaStep
int RotateDirection
int Rotation
int RulersShown = 1
int Property EMHighlightColor = 0x0099FF Auto
int Property EMCurrentValueColor = 0xEAAB00 Auto

string[] PresetList
string Property WidgetPresetPath = "Data/iEquip/Widget Presets/" autoReadonly
string Property FileExtWP = ".IEQP" autoReadonly
int[] Property EMCustomColors Auto

int iItemToMoveToFront
int iItemToSendToBack
;int CurrentlyUpdating
bool SettingDepth = false
int WaitingForFlash
int DepthA
int DepthB

String Element = ""

float[] afWidget_CurX
float[] afWidget_CurY
float[] afWidget_CurS
float[] afWidget_CurR
float[] afWidget_CurA
int[] aiWidget_CurD
int[] aiWidget_CurTC
string[] asWidget_CurTA
bool[] abWidget_CurV

Bool Function isParent(Int iIndex)
    Return WC.abWidget_isParent[iIndex]
EndFunction

Bool Function isTextElement(Int iIndex)
    Return WC.abWidget_isText[iIndex]
EndFunction

Bool Function isBackground(Int iIndex)
    Return WC.abWidget_isBg[iIndex]
EndFunction

Message property iEquip_ConfirmReset auto
Message property iEquip_ConfirmResetParent auto
Message property iEquip_ConfirmDiscardChanges auto

float CurrentVanityModeDelay

int initColorPicker_STATE = -1 ;0 = Setting Highlight color, 1 = Setting Current Info Text color, 2 = Setting Selected Text Item color

function onInit()
	EMCustomColors = new Int[14]
	int i = 0
	While i < EMCustomColors.length
		EMCustomColors[i] = -1
		i += 1
	endWhile
endFunction

function ToggleEditMode()
	debug.trace("iEquip EditMode ToggleEditMode called")
	CurrentVanityModeDelay = Utility.GetINIFloat("fAutoVanityModeDelay:Camera")
	WC.hideWidget()
	Utility.Wait(0.2)
	HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	if isEditMode
		bLeavingEditMode = True
		handleEditModeHighlights(0)
		SelectedItem = 0
		if MCM.ShowMessages
			debug.Notification("Exit Edit Mode")
		endIf
		UpdateWidgets()
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
		Utility.SetINIFloat("fAutoVanityModeDelay:Camera", CurrentVanityModeDelay) ;Resets Vanity Camera delay back to previous value on leaving Edit Mode
		bLeavingEditMode = False
	else
		StoreOpeningValues()
		SelectedItem = 1
		UpdateElementVariable()
		RotateDirection = 1
		MoveStep = 10.0000
		RotateStep = 15.0000
		AlphaStep = 10.0000
		Utility.SetINIFloat("fAutoVanityModeDelay:Camera", 9999999) ;Effectively disables Vanity Camera whilst in Edit Mode
		if MCM.ShowMessages
			debug.Notification("Enter Edit Mode")
		endIf
		updateEditModeButtons()
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
	endIf
	ST.SlowTime() ;Toggle Slow Time effect
	if !Disabling
		WC.showWidget() ;Reshow widget only if ToggleEditMode not called as a result of turning iEquip off in the MCM
	endIf
	isEditMode = !isEditMode
	debug.trace("iEquip EditMode ToggleEditMode finished")
endFunction

Function StoreOpeningValues()
	Int iIndex = 0
	afWidget_CurX = new Float[13]
	afWidget_CurY = new Float[13]
	afWidget_CurS = new Float[13]
	afWidget_CurR = new Float[13]
	afWidget_CurA = new Float[13]
	aiWidget_CurD = new Int[13]
	asWidget_CurTA = new string[13]
	aiWidget_CurTC = new int[13]
	abWidget_CurV = new bool[13]
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
endFunction
;Edit Mode Functions

function toggleRulers()
	If RulersShown == 0
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
		RulersShown = 1
	elseIf RulersShown == 1
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
		Utility.Wait(0.5)
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
		RulersShown = 2
	else
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
		RulersShown = 0
	endIf
	updateEditModeInfoText()
endFunction

Function UpdateElementVariable()
	debug.trace("iEquip EditMode UpdateElementVariable called")
	int iIndex = SelectedItem - 1
	Element = WidgetRoot + WC.asWidgetElements[iIndex]
EndFunction

function UpdateWidgets()
	debug.trace("iEquip EditMode UpdateWidgets called")
	debug.trace("iEquip EditMode UpdateWidgets - SettingDepth on function start = " + SettingDepth as String)
	Int iIndex = 0
	int[] args = new int[2]
	SettingDepth = false
	self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
	While iIndex < WC.asWidgetDescriptions.Length
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._x", WC.afWidget_X[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._y", WC.afWidget_Y[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._xscale", WC.afWidget_S[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._yscale", WC.afWidget_S[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._rotation", WC.afWidget_R[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._alpha", WC.afWidget_A[iIndex])
		if !bLeavingEditMode && !WC.isFirstLoad
			debug.trace("iEquip EditMode UpdateWidgets - SettingDepth before entering while loop = " + SettingDepth as String)
			while SettingDepth == true
				Utility.Wait(0.01)
			endWhile
			SetDepthOrder(iIndex, 0)
		endIf
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
		if isTextElement(iIndex)
			int alignment = 0
			If WC.asWidget_TA[iIndex] == "left"
				alignment = 0
			elseIf WC.asWidget_TA[iIndex] == "center"
				alignment = 1
			else
				alignment = 2
			endIf
			args[0] = iIndex
			args[1] = alignment
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
			args[1] = WC.aiWidget_TC[iIndex]
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
		endIf
		iIndex += 1
	EndWhile
	if isEditMode && !bLeavingEditMode
		handleEditModeHighlights(1)
	endIf
	self.UnRegisterForModEvent("iEquip_GotDepth")
	debug.trace("iEquip EditMode UpdateWidgets finished")
endFunction

Function SetDepthOrder(int iIndex, int SetReset)
	debug.trace("iEquip EM SetDepthOrder called")
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
		;Utility.Wait(0.5)
		WaitingForFlash = 2
		debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", iIndex)
		debug.trace("iEquip EM .getCurrentItemDepth called for the first time")
		While WaitingForFlash > 1
			Utility.Wait(0.01)
		endWhile
		debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", SendBehind)
		debug.trace("iEquip EM .getCurrentItemDepth called for the second time")
		While WaitingForFlash > 0
			Utility.Wait(0.01)
		endWhile
		debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		if DepthA < DepthB
			debug.trace("iEquip EM DepthA is less than DepthB, calling .swapItemDepths")
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
	debug.trace("iEquip EM SetDepthOrder setting SettingDepth before closing to: " + SettingDepth as String)
	debug.trace("iEquip EM SetDepthOrder finished")
endFunction

Event onGotDepth(String sEventName, String sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip EditMode onGotDepth event received")
	If(sEventName == "iEquip_GotDepth")
		If WaitingForFlash == 2
			DepthA = fNumArg as int
			;debug.notification("DepthA set to " + DepthA as String)
			debug.trace("DepthA set to " + DepthA as String)
		else
			DepthB = fNumArg as int
			;debug.notification("DepthB set to " + DepthB as String)
			debug.trace("DepthB set to " + DepthB as String)
		endIf
		WaitingForFlash -= 1
	endIf
endEvent

function LoadEditModeWidgets()
	debug.trace("iEquip EditMode LoadEditModeWidgets called")
	Int iIndex = 0
	While iIndex < WC.asWidgetDescriptions.Length
		if isBackground(iIndex);Need to add check for background visibility here so they are only shown if backgrounds checked in MCM
			UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
		else
			UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true) ;Everything else other than the backgrounds needs to be visible in Edit Mode
		endIf
		iIndex += 1
	EndWhile
	;Also need to now set the various icons and text elements to specifics optimised for edit mode for example bow in right hand, axe in left hand, long names, etc
	
	debug.trace("iEquip EditMode LoadEditModeWidgets finished")
endFunction

function updateEditModeButtons()
	int[] args = new int[18]
	args[0] = KH.iEquip_editmodeKey
	args[1] = KH.iEquip_EditPrevKey
	args[2] = KH.iEquip_EditNextKey
	args[3] = KH.iEquip_EditUpKey
	args[4] = KH.iEquip_EditDownKey
	args[5] = KH.iEquip_EditLeftKey
	args[6] = KH.iEquip_EditRightKey
	args[7] = KH.iEquip_EditScaleUpKey
	args[8] = KH.iEquip_EditScaleDownKey
	args[9] = KH.iEquip_EditRotateKey
	args[10] = KH.iEquip_EditAlphaKey
	args[11] = KH.iEquip_EditTextKey
	args[12] = KH.iEquip_EditDepthKey
	args[13] = KH.iEquip_EditRulersKey
	args[14] = KH.iEquip_EditResetKey
	args[15] = KH.iEquip_EditLoadPresetKey
	args[16] = KH.iEquip_EditSavePresetKey
	args[17] = KH.iEquip_EditDiscardKey
	UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setEditModeButtons", args)
endFunction

function UpdateEditModeInfoText()
	debug.trace("iEquip EditMode UpdateEditModeInfoText called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.SelectedElementText.text", WC.asWidgetDescriptions[iIndex])
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", (MoveStep as int) as String + " pixels")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", (RotateStep as int) as String + " degrees")
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", (AlphaStep as int) as String + "%")
		if RotateDirection == 1
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
		if isTextElement(iIndex)
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", WC.asWidget_TA[iIndex] + " aligned")
		else
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", "")
		endIf
		if WC.abWidget_V[iIndex]
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Visible")
		else
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Hidden")
		endIf
		If RulersShown == 1
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Edge grid")
		elseIf RulersShown == 2
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Fullscreen grid")
		else
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", "Hidden")
	endIf
	EndIf
	debug.trace("iEquip EditMode UpdateEditModeInfoText finished")
endFunction

function cycleEditModeElements(int nextPrev)
	debug.trace("iEquip EditMode cycleEditModeElements called")
	handleEditModeHighlights(0)
	if nextPrev == 1
		SelectedItem = SelectedItem + 1
		if SelectedItem == 14
			SelectedItem = 1
		endIf
	else
		SelectedItem = SelectedItem - 1
		if SelectedItem == 0
			SelectedItem = 13
		endIf
	endIf
	int iIndex = SelectedItem - 1
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iIndex)
	handleEditModeHighlights(1)
	UpdateElementVariable()
	UpdateEditModeInfoText()
endFunction

function handleEditModeHighlights(int mode)
	;mode: 1 = Add highlight, 0 = Remove highlight
	debug.trace("iEquip EditMode handleEditModeHighlights called")
	int iIndex = SelectedItem - 1
	if isParent(iIndex)
		handleChildHighlights(iIndex, mode)
	else
		int isText = isTextElement(iIndex) as int
		int[] args = new int[3]
		args[0] = isText
		args[1] = iIndex
		args[2] = WC.aiWidget_TC[iIndex] ;Current text colour if text element
		if mode == 1
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".highlightSelectedElement", args)
		else
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".removeCurrentHighlight", args)
		endIf
	endIf
endFunction

function handleChildHighlights(int iIndex, int mode)
	Int iIndex2 = 4 ;First four elements in the descriptions array are the parent movieclips for the four slots so this is the first of the child elements
	Int iIndex3 = iIndex ;Store the original iIndex value so we can reset Selected Item back to the parent once we're done
	String Group = WC.asWidgetGroup[iIndex] ;Stores the group name from the parent this function was called on
	While iIndex2 < WC.asWidgetDescriptions.Length
		if WC.asWidgetGroup[iIndex2] == Group
			SelectedItem = iIndex2 + 1 ;Sets SelectedItem to the discovered child ready for handleEditModeHighlights() to set the correct iIndex value
			UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iIndex2) ;Sets current clip in the actionscript to the discovered child
			handleEditModeHighlights(mode)
		endIf
		iIndex2 += 1
	EndWhile
	SelectedItem = iIndex3 + 1 ;Sets iEquip_Selected back to the original parent element before exiting the function back into ResetItem()
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iIndex3) ;Set actionscript setCurrentClip back to parent before exiting
endFunction

function ToggleStep(int a)
	debug.trace("iEquip EditMode ToggleStep called")
	int Step = a
	;0 = MoveStep
	;1 = RotateStep
	;2 = AlphaStep
	if Step == 0
		if MoveStep == 1.00000
			MoveStep = 10.0000
		elseIf MoveStep == 10.0000
			MoveStep = 50.0000
		elseIf MoveStep == 50.0000
			MoveStep = 100.0000
		elseIf MoveStep == 100.0000
			MoveStep = 1.00000
		endIf
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", (MoveStep as int) as String + " pixels")
	elseIf Step == 1
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

Function ToggleRotateDirection()
	debug.trace("iEquip EditMode ToggleRotateDirection called")
	; 0 = Counter Clockwise
	; 1 = Clockwise
	if RotateDirection == 1
		RotateDirection = 0
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", "Counterclockwise")
	else
		RotateDirection = 1
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", "Clockwise")
	endIf
endFunction

Function MoveLeft()
	debug.trace("iEquip EditMode MoveLeft called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_X[iIndex]
		WC.afWidget_X[iIndex] = WC.afWidget_X[iIndex] - MoveStep
		Float fDuration = 1.5/360*MoveStep
		TweenElement(0, fCurrentValue, WC.afWidget_X[iIndex], fDuration)
	EndIf
EndFunction

Function MoveRight()
	debug.trace("iEquip EditMode MoveRight called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_X[iIndex]
		WC.afWidget_X[iIndex] = WC.afWidget_X[iIndex] + MoveStep
		Float fDuration = 1.5/360*MoveStep
		TweenElement(0, fCurrentValue, WC.afWidget_X[iIndex], fDuration)
	EndIf
EndFunction

Function MoveUp()
	debug.trace("iEquip EditMode MoveUp called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_Y[iIndex]
		WC.afWidget_Y[iIndex] = WC.afWidget_Y[iIndex] - MoveStep
		Float fDuration = 1.5/360*MoveStep
		TweenElement(1, fCurrentValue, WC.afWidget_Y[iIndex], fDuration)
	EndIf
EndFunction

Function MoveDown()
	debug.trace("iEquip EditMode MoveDown called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_Y[iIndex]
		WC.afWidget_Y[iIndex] = WC.afWidget_Y[iIndex] + MoveStep
		Float fDuration = 1.5/360*MoveStep
		TweenElement(1, fCurrentValue, WC.afWidget_Y[iIndex], fDuration)
	EndIf
EndFunction

Function ScaleUp()
	debug.trace("iEquip EditMode ScaleUp called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_S[iIndex]
		WC.afWidget_S[iIndex] = WC.afWidget_S[iIndex] + MoveStep
		Float fDuration = 0.01*MoveStep
		TweenElement(2, fCurrentValue, WC.afWidget_S[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iIndex] as int) as String + "%")
EndFunction

Function ScaleDown()
	debug.trace("iEquip EditMode ScaleDown called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_S[iIndex]
		WC.afWidget_S[iIndex] = WC.afWidget_S[iIndex] - MoveStep
		if WC.afWidget_S[iIndex] <= 30
			WC.afWidget_S[iIndex] = 30
		endIf
		Float fDuration = 0.01*MoveStep
		TweenElement(2, fCurrentValue, WC.afWidget_S[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iIndex] as int) as String + "%")
EndFunction

;/Function BringToFront()
	debug.trace("iEquip EditMode BringToFront called")
	Int iIndex = SelectedItem - 1
	if !startBringToFront
		iItemToMoveToFront = iIndex
		debug.MessageBox("Now select the item you want to move the " + WC.asWidgetDescriptions[iIndex] + " in front of and press the Bring To Front key a second time")
	else
		self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
		WaitingForFlash = 2
		iItemToSendToBack = iIndex
		int[] args = new int[2]
		args[0] = iItemToMoveToFront
		args[1] = iItemToSendToBack
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", args)
		CurrentlyUpdating = iItemToMoveToFront
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", iItemToMoveToFront)
		While WaitingForFlash > 1
			Utility.Wait(0.1)
		endWhile
		CurrentlyUpdating = iItemToSendToBack
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", iItemToSendToBack)
		While WaitingForFlash > 0
			Utility.Wait(0.1)
		endWhile
		self.UnRegisterForModEvent("iEquip_GotDepth")
	endIf
	startBringToFront = !startBringToFront
endFunction/;

Function BringToFront()
	debug.trace("iEquip EditMode BringToFront called")
	Int iIndex = SelectedItem - 1
	if !startBringToFront
		iItemToMoveToFront = iIndex
		debug.MessageBox("Now select the item you want to move the " + WC.asWidgetDescriptions[iIndex] + " in front of and press the Bring To Front key a second time")
	else
		iItemToSendToBack = iIndex
		int[] args = new int[2]
		args[0] = iItemToMoveToFront
		args[1] = iItemToSendToBack
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", args)
		WC.aiWidget_D[iItemToMoveToFront] = iItemToSendToBack
		if WC.aiWidget_D[iItemToSendToBack] == iItemToMoveToFront
			WC.aiWidget_D[iItemToSendToBack] = -1
		endIf
	endIf
	startBringToFront = !startBringToFront
endFunction

;/Event onGotDepth(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_GotDepth")
		WC.afWidget_D[CurrentlyUpdating] = afNumArg
		WaitingForFlash -= 1
	endIf
endEvent/;

Function Rotate()
	debug.trace("iEquip EditMode Rotate called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_R[iIndex]
		if RotateDirection == 1
			WC.afWidget_R[iIndex] = WC.afWidget_R[iIndex] + RotateStep
			if WC.afWidget_R[iIndex] >= 360
				WC.afWidget_R[iIndex] = WC.afWidget_R[iIndex] - 360
			endIf
		else
			WC.afWidget_R[iIndex] = WC.afWidget_R[iIndex] - RotateStep
			if WC.afWidget_R[iIndex] < 0
				WC.afWidget_R[iIndex] = WC.afWidget_R[iIndex] + 360
			endIf
		endIf
		if WC.afWidget_R[iIndex] == 360
			WC.afWidget_R[iIndex] = 0
		endIf
		;UI.SetFloat(HUD_MENU, Element + "._rotation", WC.afWidget_R[iIndex])
		Float fDuration = 1/360*RotateStep
		TweenElement(4, fCurrentValue, WC.afWidget_R[iIndex], fDuration)
	EndIf
	Rotation = WC.afWidget_R[iIndex] as int
	if Rotation > 180
		Rotation = Rotation - 360
	endIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", Rotation as String + " degrees")
EndFunction

Function SetAlpha()
	debug.trace("iEquip EditMode SetAlpha called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		Float fCurrentValue = WC.afWidget_A[iIndex]
		WC.afWidget_A[iIndex] = WC.afWidget_A[iIndex] - AlphaStep
		if WC.afWidget_A[iIndex] <= 0
			WC.afWidget_A[iIndex] = 100
		endIf
		Float fDuration = 0.01*AlphaStep
		TweenElement(5, fCurrentValue, WC.afWidget_A[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iIndex] as int) as String + "%")
EndFunction

Function TweenElement(float Attribute, float startValue, float targetValue, float duration)
	;Calls tweenIt in iEquipWidget.as to animate changes in position, scale, rotation and alpha
	debug.trace("iEquip EditMode TweenElement called on " + Element)
	float[] args = new float[3]
	;0 = Attribute to change - 0 = _x, 1 = _y, 2 = _xscale, 3 = _yscale but use 2 as tweenIt will do both, 4 = _rotation, 5 = _alpha
	;1 = Starting value - sent from calling function, taken as value before increment applied
	;2 = Target value - sent from calling function as value after increment applied
	;3 = Duration in seconds for tween to take
	args[0] = Attribute
	;args[1] = startValue
	args[1] = targetValue
	args[2] = duration
	UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenIt", args)
EndFunction

Function SetTextAlignment()
	debug.trace("iEquip EditMode SetTextAlignment called")
	Int iIndex = SelectedItem - 1
	int alignment = 0
	If iIndex >= 0
		If WC.asWidget_TA[iIndex] == "left"
			WC.asWidget_TA[iIndex] = "center"
			alignment = 1
		elseIf WC.asWidget_TA[iIndex] == "center"
			WC.asWidget_TA[iIndex] = "right"
			alignment = 2
		else
			WC.asWidget_TA[iIndex] = "left"
			alignment = 0
		endIf
		int[] args = new int[2]
		args[0] = iIndex
		args[1] = alignment
		tweenElement(5, WC.afWidget_A[iIndex], 0, 0.15) ;Fade out before changing alignment
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
		tweenElement(5, 0, WC.afWidget_A[iIndex], 0.15) ;Fade back in
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", WC.asWidget_TA[iIndex] + " aligned")
EndFunction

function initColorPicker(int target)
	;target: 0 = Highlight colour, 1 = Current item info text colour, 2 = Selected text colour
    debug.trace("iEquip EM initColorPicker called")

    if initColorPicker_STATE == -1 ;First time calling
    	initColorPicker_STATE = target ;So when called again if returning from setting a custom colour we know how to re-call the color menu in it's previous state
    else
    	initColorPicker_STATE == -1 ;Reset to -1 if this is the second call in this string of events, then apply the custom color to whatever it was set for before redrawing the color menu
    endIf

	int iIndex = SelectedItem - 1
	string titleText = ""
	int currentColor = 0xFFFFFF
    int defaultColor = 0xFFFFFF
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
    	currentColor = WC.aiWidget_TC[iIndex]
    	defaultColor = 0xFFFFFF
    endIf
    showEMColorMenu(target, titleText, currentColor, defaultColor)
    debug.trace("iEquip EM initColorPicker finished")
endFunction

;Handle mouse clicks on the Load Preset and Save Preset buttons in Edit Mode - have to be contained in the MCM script for the List Menu to work correctly
function showEMPresetListMenu()
    updateEMPresetList()
    if PresetList[0] == ""
        Debug.Notification("No saved presets found")
        return
    else
        String title = "Select a widget preset to load"
        int[] MenuReturnArgs
        int PresetIndex
        MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowList(title, PresetList, 0, 0)
        PresetIndex = MenuReturnArgs[0]
        String SelectedPreset = PresetList[PresetIndex]
        int iLoadDelete = MenuReturnArgs[1]
        if iLoadDelete == 0
            WC.LoadWidgetPreset(SelectedPreset + FileExtWP)
        elseIf iLoadDelete == 1
            DeleteWidgetPreset(SelectedPreset + FileExtWP)
        endIf
    endIf
endFunction

function updateEMPresetList()
    String fileName
    PresetList = new string[128]
    int listIndex = 0
    int FileList = JValue.readFromDirectory(WidgetPresetPath, FileExtWP)
    int FileNameArray = JMap.allKeys(FileList)
    int arraySize = JArray.count(FileNameArray)
    int i = 0
    while(i < arraySize)
        fileName = JArray.getStr(FileNameArray, i)
        string[] fileNameChunk = argstring(fileName, ".")
        PresetList[listIndex] = fileNameChunk[0]
        listIndex += 1
        i += 1
    EndWhile
endFunction

function showEMTextInputMenu(int target)
    ;target: 0 = Preset Name, 1 = Custom color hex code
    String title = ""
    String initialText = ""
	int customColor
    if target == 0
        title = "Name this layout preset"
    else
        title = "Enter a custom colour hex code"
        initialText = "RRGGBB"
	endIf
    String TextInput = ((Self as Form) as iEquip_UILIB).ShowTextInput(title, initialText)
    if TextInput != "" && TextInput != "RRGGBB"
        if target == 0
            SaveWidgetPreset(TextInput + FileExtWP)
        else
            customColor = HexStringToInt(TextInput) ;Convert TextInput to Int
            updateCustomColors(0, customColor, 0) ;(action: 0 = Add, colour)
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

function showEMColorMenu(int target, string titleText, int currentColor, int defaultColor)
    ;target: 0 = Highlight colour, 1 = Current item info text colour, 2 = Selected text colour
    Int[] MenuReturnArgs
    MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowColorMenu(titleText, currentColor, defaultColor, EMCustomColors)
    Int NewColor = MenuReturnArgs[0]
    Int NewCustom = MenuReturnArgs[1]
    if NewCustom == 0 ;Apply selected colour
	    if NewColor > 0
	        if target == 0
	            EMHighlightColor = NewColor
	            UI.InvokeInt(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeHighlightColor", NewColor as Int)
	            if isEditMode
	                handleEditModeHighlights(1)
	            endIf
	        else
	            setTextColor(target, NewColor)
	        endIf
	    endIf
	elseIf NewCustom == 1 ;Pressed the Custom button
		showEMTextInputMenu(1)
	endIf
endFunction

string[] function ArgString(string args, string delimiter = ",") global
	string[] Output
	if args == ""
		return Output
	endIf
	int Next = StringUtil.Find(args, delimiter)
	if Next == -1
		return PushString(args, Output)
	endIf
	args += delimiter
	int Len = StringUtil.GetLength(args)
	int Count
	while Next != -1 && Next < Len
		Count += 1
		Next = StringUtil.Find(args, delimiter, (Next + 1))
	endWhile
	int i
	Output = StringArray(Count)
	int DelimLen = StringUtil.GetLength(delimiter)
	int Prev
	Next = StringUtil.Find(args, delimiter)
	while Next != -1 && Next < Len
		Output[i] = Trim(StringUtil.SubString(args, Prev, (Next - Prev)))
		Prev = Next + DelimLen
		Next = StringUtil.Find(args, delimiter, Prev)
		i += 1
	endWhile
	return Output
endFunction

function setTextColor(int target, float newColor_)
	debug.trace("iEquip EditMode setTextColor called")
	;target: 1 = Current item info text colour, 2 = Selected text colour
	int newColor = newColor_ as int
	if target == 1
		EMCurrentValueColor = newColor
		UI.InvokeInt(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeCurrentValueColor", newColor)
	else
		int iIndex = SelectedItem - 1
		WC.aiWidget_TC[iIndex] = newColor
		int[] args = new int[2]
		args[0] = iIndex
		args[1] = newColor
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
	endIf
EndFunction

function updateCustomColors(int action_, int newColor, int aIndex)
	debug.trace("iEquip EditMode updateCustomColors called")
	;action: 0 = Add custom colour, 1 = Clear custom colour
	if action_ == 0 ;Add new custom color in first available empty slot
		int iIndex = 0
		While iIndex < EMCustomColors.length && EMCustomColors[iIndex] != -1
			iIndex += 1
		endWhile
		if iIndex == EMCustomColors.length
			debug.MessageBox("You have no free custom colour slots available\n\nYou can free up slots by removing custom colours you don't need using the Delete function in the colour menu")
			return
		else
			EMCustomColors[iIndex] = newColor
		endIf
		;Apply the custom color to whatever it was set for, before redrawing the color menu
		if initColorPicker_STATE == 0
			EMHighlightColor = newColor
    		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", newColor)
    		handleEditModeHighlights(1)
    	elseIf initColorPicker_STATE == 1
    		EMCurrentValueColor = newColor
    		UI.InvokeInt(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeCurrentValueColor", newColor)
    	else
    		iIndex = SelectedItem - 1
    		WC.aiWidget_TC[iIndex] = newColor
			int[] args = new int[2]
			args[0] = iIndex
			args[1] = newColor
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
		endIf
	elseIf action_ == 1 ;Delete currently highlighted custom color
		EMCustomColors[aIndex] = -1 ;Do delete action first if required
		;Then iterate through the array sorting all of the colour values to the start leaving all the empty (-1) slots at the end
		Int Index1
		Int Index2 = EMCustomColors.Length - 1
		While (Index2 > 0)
			Index1 = 0
			While (Index1 < Index2)
				If (EMCustomColors [Index1] == -1)
					EMCustomColors [Index1] = EMCustomColors [Index1 + 1]
					EMCustomColors [Index1 + 1] = -1
				EndIf
				Index1 += 1
			EndWhile
			Index2 -= 1
		EndWhile
	endIf
	initColorPicker(initColorPicker_STATE)
endFunction

Function setVisibility()
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		if WC.abWidget_V[iIndex] == true
			WC.abWidget_V[iIndex] = false
		else
			WC.abWidget_V[iIndex] = true
		endIf
		UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
	endIf
	if WC.abWidget_V[iIndex]
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Visible")
	else
		UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Hidden")
	endIf
endFunction

Function ResetItem()
	debug.trace("iEquip EditMode ResetItem called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
		If !ResettingChildren ;Skip showing confirmation messagebox if already resetting all or resetting children
			If isParent(iIndex)
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
			tweenElement(5, WC.afWidget_A[iIndex], 0, 0.15)
			Utility.Wait(0.15)
		endIf
		WC.afWidget_X[iIndex] = WC.afWidget_DefX[iIndex]
		WC.afWidget_Y[iIndex] = WC.afWidget_DefY[iIndex]
		WC.afWidget_S[iIndex] = WC.afWidget_DefS[iIndex]
		WC.afWidget_R[iIndex] = WC.afWidget_DefR[iIndex]
		WC.afWidget_A[iIndex] = WC.afWidget_DefA[iIndex]
		if isTextElement(iIndex) ;Checks if the element is text and applies the default text size and alignment
			WC.asWidget_TA[iIndex] = WC.asWidget_DefTA[iIndex]
			int alignment = 0
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
		if ResettingChildren
			UI.setFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._alpha", WC.afWidget_A[iIndex])
		endIf
		if isBackground(iIndex)
			UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
		else
			UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true)
		endIf
		SetDepthOrder(iIndex, 1)
		if isParent(iIndex) ;Check if selected element is one of the widget parents and reset all children accordingly
			ResetChildren(iIndex)
		endIf
		if !ResettingChildren
			tweenElement(5, 0, WC.afWidget_A[iIndex], 0.2)
		endIf
		If MCM.ShowMessages && !isParent(iIndex) && !ResettingChildren
			debug.Notification("The " + WC.asWidgetDescriptions[iIndex] + " has been reset")
		elseIf MCM.ShowMessages && isParent(iIndex)
			debug.Notification("All elements of the " + WC.asWidgetDescriptions[iIndex] + " have been reset")
		EndIf
		self.UnRegisterForModEvent("iEquip_GotDepth")
	EndIf
	UpdateEditModeInfoText()
	debug.trace("iEquip EditMode ResetItem finished")
EndFunction

Function ResetChildren(int iIndex)
	debug.trace("iEquip EditMode ResetChildren called")
	Int iIndex2 = 4
	Int iIndex3 = iIndex
	String Group = WC.asWidgetGroup[iIndex]
	ResettingChildren = True

	While iIndex2 < WC.asWidgetDescriptions.Length
		if WC.asWidgetGroup[iIndex2] == Group
			SelectedItem = iIndex2 + 1
			ResetItem()
		endIf
		iIndex2 += 1
	EndWhile
	ResettingChildren = False
	SelectedItem = iIndex3 + 1 ;Sets iEquip_Selected back to the original parent element before exiting the function back into ResetItem()
	debug.trace("iEquip EditMode ResetChildren finished")
EndFunction

function ResetDefaults()
	debug.trace("iEquip EditMode ResetDefaults called")
	WC.hideWidget()
	UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	debug.Notification("Resetting iEquip...")
	WC.ResetWidgetArrays()
	UpdateWidgets()
	if isEditMode
		SelectedItem = 1
		LoadEditModeWidgets()
		UpdateEditModeInfoText()
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", true)
	endIf
	WC.showWidget()
	MCM.iEquip_Reset = false
	If MCM.ShowMessages
		debug.Notification("All iEquip widgets reset")
	EndIf
	debug.trace("iEquip EditMode ResetDefaults finished")
endFunction

Function DiscardChanges()
	Int iIndex = 0
	int iButton = iEquip_ConfirmDiscardChanges.Show() ;Add messagebox to check if user wants to discard changes and revert to state saved on entering Edit Mode, return out if not
	if iButton != 1
		return
	endIf
	WC.hideWidget()
	Utility.Wait(0.2)
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
	UpdateWidgets()
	UpdateEditModeInfoText()
	WC.showWidget()
endFunction

function ApplyMCMSettings()
	debug.trace("iEquip EditMode ApplyMCMSettings called")
	
	if WC.isEnabled
		if MCM.iEquip_Reset
			ResetDefaults()
		else
			if MCM.ShowMessages
				debug.Notification("Applying iEquip settings...")
			endIf
			ApplyChanges()
			if isEditMode
				updateEditModeButtons()
				LoadEditModeWidgets()
			;else
				;UpdateWidgets()
			endIf
		endIf
	endIf
	
	if !WC.isEnabled
		debug.Notification("iEquip disabled...")
	endIf
	
	debug.trace("iEquip EditMode ApplyMCMSettings finished")
endFunction

function ApplyChanges()
	debug.trace("iEquip EditMode ApplyChanges called")
		
	debug.trace("iEquip EditMode ApplyChanges finished")
endFunction

;Preset load/save functions, called from the MCM show menu functions
;Load function is in WidgetCore

function SaveWidgetPreset(string PresetName)
	Int jSavePreset = jMap.object()

	Int jafWidget_X = jArray.objectWithFloats(WC.afWidget_X)
	Int jafWidget_Y = jArray.objectWithFloats(WC.afWidget_Y)
	Int jafWidget_S = jArray.objectWithFloats(WC.afWidget_S)
	Int jafWidget_R = jArray.objectWithFloats(WC.afWidget_R)
	Int jafWidget_A = jArray.objectWithFloats(WC.afWidget_A)
	Int jaiWidget_D = jArray.objectWithInts(WC.aiWidget_D)
	Int jaiWidget_TC = jArray.objectWithInts(WC.aiWidget_TC)
	Int jasWidget_TA = jArray.objectWithStrings(WC.asWidget_TA)
	Int jabWidget_V = jArray.objectWithBooleans(WC.abWidget_V)

	jMap.setObj(jSavePreset, "_X", jafWidget_X)
	jMap.setObj(jSavePreset, "_Y", jafWidget_Y)
	jMap.setObj(jSavePreset, "_S", jafWidget_S)
	jMap.setObj(jSavePreset, "_R", jafWidget_R)
	jMap.setObj(jSavePreset, "_A", jafWidget_A)
	jMap.setObj(jSavePreset, "_D", jaiWidget_D)
	jMap.setObj(jSavePreset, "_TC", jaiWidget_TC)
	jMap.setObj(jSavePreset, "_TA", jasWidget_TA)
	jMap.setObj(jSavePreset, "_V", jabWidget_V)

	jValue.writeTofile(jSavePreset, WidgetPresetPath + PresetName)
	Debug.Notification("Current layout saved as " + PresetName)
endFunction

function DeleteWidgetPreset(string SelectedPreset)
	JContainers.removeFileAtPath(WidgetPresetPath + SelectedPreset)
endFunction
