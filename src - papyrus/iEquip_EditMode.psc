ScriptName iEquip_EditMode Extends Quest

import UI
import Utility
;import iEquip_Utility
import StringUtil
import iEquip_UILIB
import _Q2C_Functions

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_KeyHandler Property KH Auto
iEquip_SlowTime Property ST Auto
iEquip_ChargeMeters Property CM Auto

bool property isEditMode = False Auto
int property SelectedItem = 0 Auto
;MCM master switch for widget backgrounds. If enabled backgrounds can be shown/hidden/manipulated in Edit Mode, if disabled they are ignored entirely
;bool Property enableBackgrounds = false Auto
;MCM toggle for Bring To Front function in Edit Mode.  Disabled by default as likely to be little used and causes delay when switching presets and entering/leaving Edit Mode
bool Property BringToFrontEnabled = false Auto
bool BringToFrontFirstTime = True
bool wasLeftCounterShown = false
bool wasRightCounterShown = false
int previousLeftCount
int previousRightCount

String HUD_MENU
String WidgetRoot

bool isWidgetMaster = False
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

bool preselectEnabledOnEnter = false

int iItemToMoveToFront
int iItemToSendToBack
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

;/Bool Property BackgroundsShown
	Bool Function Get()
		Return enableBackgrounds
	EndFunction
	
	Function Set(Bool b)
		If (WC.Ready)
			enableBackgrounds = b
            Int iIndex = 0
            While iIndex < WC.asWidgetDescriptions.Length
            	if isBackground(iIndex)
            		WC.abWidget_V[iIndex] = b
            		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
            	endIf
            	iIndex += 1
            endWhile
		EndIf
	EndFunction
EndProperty/;

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
	isEditMode = !isEditMode
	CurrentVanityModeDelay = Utility.GetINIFloat("fAutoVanityModeDelay:Camera")
	WC.hideWidget()
	Utility.Wait(0.2)
	HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	if !isEditMode
		bLeavingEditMode = True
		handleEditModeHighlights(0)
		SelectedItem = 0
		resetWidgetsToPreviousState()
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false) ;Restore DropShadowFilter to all text elements when leaving Edit Mode
		UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
		Utility.SetINIFloat("fAutoVanityModeDelay:Camera", CurrentVanityModeDelay) ;Resets Vanity Camera delay back to previous value on leaving Edit Mode
		bLeavingEditMode = False
	else
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true) ;Remove DropShadowFilter from all text elements before entering Edit Mode
		StoreOpeningValues()
		SelectedItem = 1
		UpdateElementVariable()
		RotateDirection = 1
		MoveStep = 10.0000
		RotateStep = 15.0000
		AlphaStep = 10.0000
		UI.InvokeInt(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeHighlightColor", EMHighlightColor)
		UI.InvokeInt(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeCurrentValueColor", EMCurrentValueColor)
		Utility.SetINIFloat("fAutoVanityModeDelay:Camera", 9999999) ;Effectively disables Vanity Camera whilst in Edit Mode
		updateEditModeButtons()
		if !WC.isPreselectMode
			preselectEnabledOnEnter = true
			WC.togglePreselectMode()
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
	endIf
	ST.SlowTime() ;Toggle Slow Time effect
	if !Disabling
		WC.showWidget() ;Reshow widget only if ToggleEditMode not called as a result of turning iEquip off in the MCM
	endIf
	debug.trace("iEquip EditMode ToggleEditMode finished")
endFunction

Function StoreOpeningValues()
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
	Utility.Wait(2)
	self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
	While iIndex < WC.asWidgetDescriptions.Length
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._x", WC.afWidget_X[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._y", WC.afWidget_Y[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._xscale", WC.afWidget_S[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._yscale", WC.afWidget_S[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._rotation", WC.afWidget_R[iIndex])
		UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._alpha", WC.afWidget_A[iIndex])
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
		if BringToFrontEnabled && !bLeavingEditMode && !WC.isFirstLoad && !WC.Loading
			while SettingDepth == true
				Utility.Wait(0.01)
			endWhile
			if iIndex != 0
				SetDepthOrder(iIndex, 0)
			endIf
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
	;debug.trace("iEquip EM SetDepthOrder called")
	;SetReset: 0 = Set, 1 = Reset
	Int SendBehind
	SettingDepth = true
	if SetReset == 0
		SendBehind = WC.aiWidget_D[iIndex]
	else
		SendBehind = WC.aiWidget_DefD[iIndex]
	endIf
	;debug.trace("iEquip EM SendBehind = " + SendBehind as String)
	if SendBehind != -1
		WaitingForFlash = 2
		;debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", iIndex)
		;debug.trace("iEquip EM .getCurrentItemDepth called for the first time")
		While WaitingForFlash > 1
			Utility.Wait(0.01)
		endWhile
		;debug.trace("iEquip EM WaitingForFlash = " + WaitingForFlash as String)
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".getCurrentItemDepth", SendBehind)
		;debug.trace("iEquip EM .getCurrentItemDepth called for the second time")
		While WaitingForFlash > 0
			Utility.Wait(0.01)
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

Event onGotDepth(String sEventName, String sStringArg, Float fNumArg, Form kSender)
	;debug.trace("iEquip EditMode onGotDepth event received")
	If(sEventName == "iEquip_GotDepth")
		If WaitingForFlash == 2
			DepthA = fNumArg as int
			;debug.notification("DepthA set to " + DepthA as String)
			;debug.trace("DepthA set to " + DepthA as String)
		else
			DepthB = fNumArg as int
			;debug.notification("DepthB set to " + DepthB as String)
			;debug.trace("DepthB set to " + DepthB as String)
		endIf
		WaitingForFlash -= 1
	endIf
endEvent

function LoadEditModeWidgets()
	debug.trace("iEquip EditMode LoadEditModeWidgets called")
	Int iIndex = 0
	While iIndex < WC.asWidgetDescriptions.Length
		;if isBackground(iIndex);Need to add check for background visibility here so they are only shown if backgrounds checked in MCM
			;UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
		;else
			UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true) ;Everything else other than the backgrounds needs to be visible in Edit Mode
		;endIf
		iIndex += 1
	EndWhile
	;Show left and right counters if not currently shown
	if !WC.leftCounterShown
		wasLeftCounterShown = false
		WC.setCounterVisibility(0, true)
	else
		wasLeftCounterShown = true
		previousLeftCount = UI.getString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text") as int
	endIf
	WC.setSlotCount(0,99)
	if !WC.rightCounterShown
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
		if !WC.isNameShown[Q]
			WC.showName(Q, true, false, 0.0)
		endIf
		Q += 1
	endWhile
	Q = 0
	int iHandle
	while Q < 2
		;Check and show left and right poison elements if not already displayed
		if !WC.poisonInfoDisplayed[Q]
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
		if !WC.isPoisonNameShown[Q]
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
		if !WC.poisonInfoDisplayed[Q]
			WC.hidePoisonInfo(Q, true)
		else
			WC.checkAndUpdatePoisonInfo(Q)
		endIf
		;Reset attribute icons
		WC.hideAttributeIcons(Q)
		if WC.isPreselectMode && !preselectEnabledOnEnter
			WC.updateAttributeIcons(Q, 0)
		endIf
		Q += 1
	endWhile
	;Reset Preselect Mode
	if preselectEnabledOnEnter && WC.isPreselectMode
		WC.togglePreselectMode()
		preselectEnabledOnEnter = false
	endIf
	;Reset enchantment meters and soulgems
	CM.updateChargeMeters(true)
endFunction

function updateEditModeButtons()
	int[] args = new int[18]
	args[0] = KH.iEquip_UtilityKey
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
		;/if WC.abWidget_V[iIndex]
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Visible")
		else
			UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.VisibilityText.text", "Hidden")
		endIf/;
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
		;if isBackground(SelectedItem - 1) && !BackgroundsShown ;Skip over backgrounds if not enabled in MCM
			;SelectedItem = SelectedItem + 1
		;endIf
		if SelectedItem >= 47
			SelectedItem = 1
		endIf
	else
		SelectedItem = SelectedItem - 1
		;if isBackground(SelectedItem - 1) && !BackgroundsShown ;Skip over backgrounds if not enabled in MCM
			;SelectedItem = SelectedItem - 1
		;endIf
		if SelectedItem <= 0
			SelectedItem = 46
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
		WC.afWidget_X[iIndex] = WC.afWidget_X[iIndex] - MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(0, WC.afWidget_X[iIndex], fDuration)
	EndIf
EndFunction

Function MoveRight()
	debug.trace("iEquip EditMode MoveRight called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_X[iIndex] = WC.afWidget_X[iIndex] + MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(0, WC.afWidget_X[iIndex], fDuration)
	EndIf
EndFunction

Function MoveUp()
	debug.trace("iEquip EditMode MoveUp called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_Y[iIndex] = WC.afWidget_Y[iIndex] - MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(1, WC.afWidget_Y[iIndex], fDuration)
	EndIf
EndFunction

Function MoveDown()
	debug.trace("iEquip EditMode MoveDown called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_Y[iIndex] = WC.afWidget_Y[iIndex] + MoveStep
		Float fDuration = 0.005*MoveStep
		TweenElement(1, WC.afWidget_Y[iIndex], fDuration)
	EndIf
EndFunction

Function ScaleUp()
	debug.trace("iEquip EditMode ScaleUp called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_S[iIndex] = WC.afWidget_S[iIndex] + MoveStep
		Float fDuration = 0.01*MoveStep
		TweenElement(2, WC.afWidget_S[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iIndex] as int) as String + "%")
EndFunction

Function ScaleDown()
	debug.trace("iEquip EditMode ScaleDown called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_S[iIndex] = WC.afWidget_S[iIndex] - MoveStep
		if WC.afWidget_S[iIndex] <= 30
			WC.afWidget_S[iIndex] = 30
		endIf
		Float fDuration = 0.01*MoveStep
		TweenElement(2, WC.afWidget_S[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iIndex] as int) as String + "%")
EndFunction

Function Rotate()
	debug.trace("iEquip EditMode Rotate called")
	Int iIndex = SelectedItem - 1
	If iIndex > 0
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
		Rotation = WC.afWidget_R[iIndex] as int
		if Rotation > 180
			Rotation = Rotation - 360
		endIf
		Float fDuration = 0.005*RotateStep
		if fDuration < 0.125
			fDuration = 0.125
		endIf
		TweenElement(3, Rotation, fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", Rotation as String + " degrees")
EndFunction

Function SetAlpha()
	debug.trace("iEquip EditMode SetAlpha called")
	Int iIndex = SelectedItem - 1
	If iIndex >= 0
		WC.afWidget_A[iIndex] = WC.afWidget_A[iIndex] - AlphaStep
		if WC.afWidget_A[iIndex] <= 0
			WC.afWidget_A[iIndex] = 100
		endIf
		Float fDuration = 0.01*AlphaStep
		TweenElement(4, WC.afWidget_A[iIndex], fDuration)
	EndIf
	UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iIndex] as int) as String + "%")
EndFunction

Function TweenElement(float Attribute, float targetValue, float duration)
	;Calls tweenIt in iEquipWidget.as to animate changes in position, scale, rotation and alpha
	;tweenIt now utilises Greensock.TweenLite rather than mx.tween
	debug.trace("iEquip EditMode TweenElement called on " + Element)
	float[] args = new float[3]
	;0 = Attribute to change - 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 = _rotation, 4 = _alpha
	;1 = Target value - sent from calling function as value after increment applied
	;2 = Duration in seconds for tween to take
	args[0] = Attribute
	args[1] = targetValue
	args[2] = duration
	UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenIt", args)
EndFunction

Function BringToFront()
	debug.trace("iEquip EditMode BringToFront called")
	Int iIndex = SelectedItem - 1
	
	if BringToFrontFirstTime
		debug.MessageBox("This feature allows you to adjust the layer order of the elements within each widget, and the layer order of the widgets themselves\n\nYou cannot bring an element of one widget in front of one from another widget, only elements within the same widget\n\nIt is disabled for backgrounds and when the complete widget is selected for obvious reasons")
		BringToFrontFirstTime = False
	endIf

	if iIndex > 0 && !isBackground(iIndex)
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
	endIf
	startBringToFront = !startBringToFront
endFunction

Function SetTextAlignment()
	debug.trace("iEquip EditMode SetTextAlignment called")
	Int iIndex = SelectedItem - 1
	int alignment = 0
	If iIndex > 0
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
		tweenElement(5, 0, 0.15) ;Fade out before changing alignment
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", args)
		tweenElement(5, WC.afWidget_A[iIndex], 0.15) ;Fade back in
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
        elseIf iLoadDelete == 2 ;Delete preset cancelled, recall preset list
        	RecallPresetMenu()
        endIf
    endIf
endFunction

function RecallPresetMenu()
	Utility.Wait(0.05)
	showEMPresetListMenu()
endFunction

function updateEMPresetList()
   	String fileName
    PresetList = new string[128]
    ;int listIndex = 0
    ;int FileList = JValue.readFromDirectory(WidgetPresetPath, FileExtWP)
    int FileNameArray = JMap.allKeys(JValue.readFromDirectory(WidgetPresetPath, FileExtWP))
    int arraySize = JArray.count(FileNameArray)
    int i = 0
    while(i < arraySize)
        fileName = JArray.getStr(FileNameArray, i)
        ;string[] fileNameChunk = ArgString(JArray.getStr(FileNameArray, i), ".")
        PresetList[i] = SubString(fileName, 0, GetLength(fileName) - 5)
        ;listIndex += 1
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

;/string[] function ArgString(string args, string delimiter = ",") global
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
endFunction/;

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
		initColorPicker(initColorPicker_STATE)
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
		initColorPicker(initColorPicker_STATE)
	endIf
endFunction

;/Function setVisibility()
	Int iIndex = SelectedItem - 1
	if iIndex == 1 || iIndex == 2
		debug.MessageBox("You cannot hide or disable the main left and right hand widgets")
		return
	elseIf iIndex > 2 && iIndex < 6
		debug.MessageBox("Use the toggles on the UI Options page in the MCM to disable the shouts, consumables and poisons widgets")
		return
	elseIf iIndex == 10 || iIndex == 11 || iIndex == 16 || iIndex == 17 || iIndex == 22 || iIndex == 23 ;The preselect icon and text elements, backgrounds can be hidden individually or by turning all backgrounds off in the MCM
		debug.MessageBox("Preselect elements are automatically hidden when not in Preselect Mode or if you have disabled shout preselect in the MCM")
		return
	elseIf iIndex > 0
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
endFunction/;

Function ResetItem()
	debug.trace("iEquip EditMode ResetItem called")
	Int iIndex = SelectedItem - 1
	bool parentClip = isParent(iIndex)
	If iIndex > 0
		self.RegisterForModEvent("iEquip_GotDepth", "onGotDepth")
		If parentClip
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
		resetSingleElement(iIndex, parentClip)
		;Check if selected element is one of the widget parents and reset all children accordingly
		if parentClip
			ResetChildren(iIndex)
		endIf
		self.UnRegisterForModEvent("iEquip_GotDepth")
	EndIf
	UpdateEditModeInfoText()
	debug.trace("iEquip EditMode ResetItem finished")
EndFunction

function resetSingleElement(int iIndex, bool parentClip = false, bool resettingChild = false)
	debug.trace("iEquip EditMode resetSingleElement called - iIndex: " + iIndex + ", parentClip: " + parentClip + ", resettingChild: " + resettingChild)
	WC.afWidget_X[iIndex] = WC.afWidget_DefX[iIndex]
	WC.afWidget_Y[iIndex] = WC.afWidget_DefY[iIndex]
	WC.afWidget_S[iIndex] = WC.afWidget_DefS[iIndex]
	WC.afWidget_R[iIndex] = WC.afWidget_DefR[iIndex]
	WC.afWidget_A[iIndex] = WC.afWidget_DefA[iIndex]
	if isTextElement(iIndex) ;Checks if the element is text and applies the default text size and alignment
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
	;if isBackground(iIndex)
		;UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", WC.abWidget_V[iIndex])
	;else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._visible", true)
	;endIf
	if BringToFrontEnabled
		SetDepthOrder(iIndex, 1)
	endIf
	If !parentClip && !resettingChild
		debug.Notification("The " + WC.asWidgetDescriptions[iIndex] + " has been reset")
		tweenElement(5, WC.afWidget_A[iIndex], 0.2)
	endIf
endFunction

Function ResetChildren(int iIndex)
	debug.trace("iEquip EditMode ResetChildren called")
	String Group = WC.asWidgetGroup[iIndex]
	int i = 4
	While i < WC.asWidgetDescriptions.Length
		if WC.asWidgetGroup[i] == Group
			resetSingleElement(i, false, true)
		endIf
		i += 1
	EndWhile
	tweenElement(5, WC.afWidget_A[iIndex], 0.2)
	debug.Notification("All elements of the " + WC.asWidgetDescriptions[iIndex] + " have been reset")
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
	debug.Notification("All iEquip widgets reset")
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
	if PresetList[0] != ""
		RecallPresetMenu()
	endIf
endFunction
