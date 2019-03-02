ScriptName iEquip_UILIB Extends Form
{SkyUILib API - Version 1}

;Private variables
Bool bMenuOpen
Bool bCallTextInput
String sTitle
String sInitialText
String sInput
String[] sOptions
String[] sIconNameList
String[] sList
Bool[] bEnchFlags
Bool[] bPoisonFlags
Int iStartIndex
Int iDefaultIndex
Bool bDirectAccess
Int iStartColor
Int iDefaultColor
Int[] aCustomColors
Int iInput
Int iLoadDelete

Message Property iEquip_ConfirmDeletePreset Auto
Message Property iEquip_ConfirmClearQueue Auto

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto

function onInit()
	debug.trace("iEquip_UILIB onInit start")
	aCustomColors = new int[14]
	int i = 0
	While i < aCustomColors.length
		aCustomColors[i] = -1
		i += 1
	endWhile
	debug.trace("iEquip_UILIB onInit end")
endFunction

Bool function IsMenuOpen()
	debug.trace("iEquip_UILIB IsMenuOpen start")
	debug.trace("iEquip_UILIB IsMenuOpen end")
	return bMenuOpen
endFunction

;Text input
Function TextInputMenu_Open(Form akClient) Global
	debug.trace("iEquip_UILIB TextInputMenu_Open start")
	akClient.RegisterForModEvent("iEquip_textInputOpen", "OnTextInputOpen")
	akClient.RegisterForModEvent("iEquip_textInputClose", "OnTextInputClose")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_textinputmenu")
	debug.trace("iEquip_UILIB TextInputMenu_Open end")
EndFunction

Function TextInputMenu_SetData(String asTitle, String asInitialText) Global
	debug.trace("iEquip_UILIB TextInputMenu_SetData start")
	UI.InvokeNumber("CustomMenu", "_root.iEquipTextInputDialog.setPlatform", (Game.UsingGamepad() as Int))
	String[] sData = new String[2]
	sData[0] = asTitle
	sData[1] = asInitialText
	UI.InvokeStringA("CustomMenu", "_root.iEquipTextInputDialog.initData", sData)
	debug.trace("iEquip_UILIB TextInputMenu_SetData end")
EndFunction

Function TextInputMenu_Release(Form akClient) Global
	debug.trace("iEquip_UILIB TextInputMenu_Release start")
	akClient.UnregisterForModEvent("iEquip_textInputOpen")
	akClient.UnregisterForModEvent("iEquip_textInputClose")
	debug.trace("iEquip_UILIB TextInputMenu_Release end")
EndFunction

String Function ShowTextInput(String asTitle, String asInitialText)
	debug.trace("iEquip_UILIB ShowTextInput start")
	If(bMenuOpen)
		Return ""
	EndIf
	bMenuOpen = True
	sInput = ""
	sTitle = asTitle
	sInitialText = asInitialText
	TextInputMenu_Open(Self)
	While(bMenuOpen)
		Utility.WaitMenuMode(0.1)
	EndWhile
	TextInputMenu_Release(Self)
	debug.trace("iEquip_UILIB ShowTextInput end")
	Return sInput
EndFunction

Event OnTextInputOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnTextInputOpen start")
	If(asEventName == "iEquip_textInputOpen")
		TextInputMenu_SetData(sTitle, sInitialText)
	EndIf
	debug.trace("iEquip_UILIB OnTextInputOpen end")
EndEvent

Event OnTextInputClose(String asEventName, String asInput, Float afCancelled, Form akSender)
	debug.trace("iEquip_UILIB OnTextInputClose start")
	If(asEventName == "iEquip_textInputClose")
		If(afCancelled as Bool)
			sInput = ""
		Else
			sInput = asInput
		EndIf
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnTextInputClose end")
EndEvent

;List
Function ListMenu_Open(Form akClient) Global
	debug.trace("iEquip_UILIB ListMenu_Open start")
	akClient.RegisterForModEvent("iEquip_listMenuOpen", "OnListMenuOpen")
	akClient.RegisterForModEvent("iEquip_listMenuCancel", "OnListMenuCancel")
	akClient.RegisterForModEvent("iEquip_listMenuDeletePreset", "OnListMenuDeletePreset")
	akClient.RegisterForModEvent("iEquip_listMenuLoad", "OnListMenuLoad")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_listmenu")
	debug.trace("iEquip_UILIB ListMenu_Open end")
EndFunction

Function ListMenu_SetData(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex) Global
	debug.trace("iEquip_UILIB ListMenu_SetData start")
	UI.InvokeNumber("CustomMenu", "_root.iEquipListDialog.setPlatform", (Game.UsingGamepad() as Int))
	UI.InvokeStringA("CustomMenu", "_root.iEquipListDialog.initListData", asOptions)
	Int iHandle = UICallback.Create("CustomMenu", "_root.iEquipListDialog.initListParams")
	If(iHandle)
		UICallback.PushString(iHandle, asTitle)
		UICallback.PushInt(iHandle, aiStartIndex)
		UICallback.PushInt(iHandle, aiDefaultIndex)
		UICallback.Send(iHandle)
	EndIf
	debug.trace("iEquip_UILIB ListMenu_SetData end")
EndFunction

Function ListMenu_Release(Form akClient) Global
	debug.trace("iEquip_UILIB ListMenu_Release start")
	akClient.UnregisterForModEvent("iEquip_listMenuOpen")
	akClient.UnregisterForModEvent("iEquip_listMenuCancel")
	akClient.UnregisterForModEvent("iEquip_listMenuDeletePreset")
	akClient.UnregisterForModEvent("iEquip_listMenuLoad")
	debug.trace("iEquip_UILIB ListMenu_Release end")
EndFunction

Int[] Function ShowList(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex)
	debug.trace("iEquip_UILIB ShowList start")
	int[] args = new int[2]
	args[0] = -1
	If(bMenuOpen)
		Return args
	EndIf
	bMenuOpen = True
	iInput = -1
	iLoadDelete = -1 ;Set to 1 to send delete preset arg to EM.showEMPresetList, set to 0 to send load preset arg
	sTitle = asTitle
	sOptions = asOptions
	iStartIndex = aiStartIndex
	iDefaultIndex = aiDefaultIndex
	ListMenu_Open(Self)
	While(bMenuOpen)
		Utility.WaitMenuMode(0.1)
	EndWhile
	ListMenu_Release(Self)
	args[0] = iInput
	args[1] = iLoadDelete
	debug.trace("iEquip_UILIB ShowList end")
	Return args
EndFunction

Event OnListMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnListMenuOpen start")
	If(asEventName == "iEquip_listMenuOpen")
		ListMenu_SetData(sTitle, sOptions, iStartIndex, iDefaultIndex)
	EndIf
	debug.trace("iEquip_UILIB OnListMenuOpen end")
EndEvent

Event OnListMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnListMenuCancel start")
	If(asEventName == "iEquip_listMenuCancel")
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnListMenuCancel end")
EndEvent

Event OnListMenuDeletePreset(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip_UILIB OnListMenuDeletePreset start")
	If(asEventName == "iEquip_listMenuDeletePreset")
		int iButton = iEquip_ConfirmDeletePreset.Show()
        if iButton != 1
        	iInput = 0
        	iLoadDelete = 2
        	bMenuOpen = False
           return
        endIf
		iInput = afInput as Int
		iLoadDelete = 1
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnListMenuDeletePreset end")
EndEvent

Event OnListMenuLoad(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip_UILIB OnListMenuLoad start")
	If(asEventName == "iEquip_listMenuLoad")
		iInput = afInput as Int
		iLoadDelete = 0
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnListMenuLoad end")
EndEvent

;Color

Int[] Function ShowColorMenu(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] CustomColors)
	debug.trace("iEquip_UILIB ShowColorMenu start")
	int[] args = new int[2]
	args[0] = -1
	If(bMenuOpen)
		Return args
	EndIf
	bMenuOpen = True
	bCallTextInput = False
	iInput = -1
	sTitle = asTitle
	iStartColor = aiStartColor
	iDefaultColor = aiDefaultColor
	aCustomColors = new int[14]
	aCustomColors = CustomColors
	Int NewCustom
	ColorMenu_Open(Self)
	While(bMenuOpen)
		Utility.WaitMenuMode(0.1)
	EndWhile
	ColorMenu_Release(Self)
	if bCallTextInput
		NewCustom = 1
		bCallTextInput = False
	endIf
	args[0] = iInput
	args[1] = NewCustom
	debug.trace("iEquip_UILIB ShowColorMenu end")
	Return args
EndFunction

Function ColorMenu_Open(Form akClient) Global
	debug.trace("iEquip_UILIB ColorMenu_Open start")
	akClient.RegisterForModEvent("iEquip_colorMenuOpen", "OnColorMenuOpen")
	akClient.RegisterForModEvent("iEquip_colorMenuCancel", "OnColorMenuCancel")
	akClient.RegisterForModEvent("iEquip_colorMenuAccept", "OnColorMenuAccept")
	akClient.RegisterForModEvent("iEquip_colorMenuDelete", "OnColorMenuDelete")
	akClient.RegisterForModEvent("iEquip_colorMenuCustom", "OnColorMenuCustom")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_ColorMenu")
	debug.trace("iEquip_UILIB ColorMenu_Open end")
EndFunction

Event OnColorMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnColorMenuOpen start")
	If(asEventName == "iEquip_colorMenuOpen")
		ColorMenu_SetData(sTitle, iStartColor, iDefaultColor, aCustomColors)
	EndIf
	debug.trace("iEquip_UILIB OnColorMenuOpen end")
EndEvent

Function ColorMenu_SetData(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] aaCustomColors) Global
	debug.trace("iEquip_UILIB ColorMenu_SetData start")
	Int iIndex
	Int iIndex2
	Int[] args = new Int[2]
	While iIndex < aaCustomColors.length
		if aaCustomColors[iIndex] != -1
			args[0] = aaCustomColors[iIndex]
			args[1] = iIndex2
			UI.InvokeIntA("CustomMenu", "_root.iEquipColorDialog.setCustomColorListValues", args)
			iIndex2 += 1
		endIf
		iIndex += 1
	endWhile
	Int iHandle = UICallback.Create("CustomMenu", "_root.iEquipColorDialog.initColorDialogParams")
	If(iHandle)
		UICallback.PushString(iHandle, asTitle)
		UICallback.PushInt(iHandle, aiStartColor)
		UICallback.PushInt(iHandle, aiDefaultColor)
		UICallback.Send(iHandle)
	EndIf
	UI.InvokeNumber("CustomMenu", "_root.iEquipColorDialog.setPlatform", (Game.UsingGamepad() as Int))
	debug.trace("iEquip_UILIB ColorMenu_SetData end")
EndFunction

Event OnColorMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnColorMenuCancel start")
	If(asEventName == "iEquip_colorMenuCancel")
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnColorMenuCancel end")
EndEvent

Event OnColorMenuCustom(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnColorMenuCustom start")
	;Event only called if Custom has been pressed to add a custom colour
	If(asEventName == "iEquip_colorMenuCustom")
		bCallTextInput = True
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnColorMenuCustom end")
EndEvent

Event OnColorMenuDelete(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnColorMenuDelete start")
	;Event only called if Default has been pressed to reset a custom colour slot
	If(asEventName == "iEquip_colorMenuDelete")
		bMenuOpen = False
		EM.DeleteCustomColor(afNumArg as Int)
	EndIf
	debug.trace("iEquip_UILIB OnColorMenuDelete end")
EndEvent

Event OnColorMenuAccept(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip_UILIB OnColorMenuAccept start")
	If(asEventName == "iEquip_colorMenuAccept")
		iInput = afInput as Int
		bMenuOpen = False
	EndIf
	debug.trace("iEquip_UILIB OnColorMenuAccept end")
EndEvent

Function ColorMenu_Release(Form akClient) Global
	debug.trace("iEquip_UILIB ColorMenu_Release start")
	akClient.UnregisterForModEvent("iEquip_colorMenuOpen")
	akClient.UnregisterForModEvent("iEquip_colorMenuCancel")
	akClient.UnregisterForModEvent("iEquip_colorMenuAccept")
	akClient.UnregisterForModEvent("iEquip_colorMenuCustom")
	akClient.UnregisterForModEvent("iEquip_colorMenuDelete")
	debug.trace("iEquip_UILIB ColorMenu_Release end")
EndFunction

;Queue
Function QueueMenu_Open(Form akClient) Global
	debug.trace("iEquip_UILIB QueueMenu_Open start")
	akClient.RegisterForModEvent("iEquip_queueMenuOpen", "OnQueueMenuOpen")
	akClient.RegisterForModEvent("iEquip_queueMenuMoveUp", "OnQueueMenuMoveUp")
	akClient.RegisterForModEvent("iEquip_queueMenuMoveDown", "OnQueueMenuMoveDown")
	akClient.RegisterForModEvent("iEquip_queueMenuRemove", "OnQueueMenuRemove")
	akClient.RegisterForModEvent("iEquip_queueMenuClear", "OnQueueMenuClear")
	akClient.RegisterForModEvent("iEquip_queueMenuExit", "OnQueueMenuExit")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_queuemenu")
	debug.trace("iEquip_UILIB QueueMenu_Open end")
EndFunction

Function QueueMenu_SetData(String asTitle, String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, Int aiStartIndex, Int aiDefaultIndex, bool directAccess) Global
	debug.trace("iEquip_UILIB QueueMenu_SetData start")
	UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.setExitButtonText", directAccess)
	UI.InvokeNumber("CustomMenu", "_root.iEquipQueueDialog.setPlatform", (Game.UsingGamepad() as Int))
	Int iIndex
	String iconName
	bool isEnchanted
	bool isPoisoned
	While iIndex < asIconNameList.length
		iconName = asIconNameList[iIndex]
		isEnchanted = abEnchFlags[iIndex]
		isPoisoned = abPoisonFlags[iIndex]
		UI.InvokeString("CustomMenu", "_root.iEquipQueueDialog.initIconNameList", iconName)
		UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.initIsEnchantedList", isEnchanted)
		UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.initIsPoisonedList", isPoisoned)
		iIndex += 1
	endWhile
	UI.InvokeStringA("CustomMenu", "_root.iEquipQueueDialog.initListData", asList)
	Int iHandle2 = UICallback.Create("CustomMenu", "_root.iEquipQueueDialog.initListParams")
	If(iHandle2)
		UICallback.PushString(iHandle2, asTitle)
		UICallback.PushInt(iHandle2, aiStartIndex)
		UICallback.PushInt(iHandle2, aiDefaultIndex)
		UICallback.Send(iHandle2)
	EndIf
	debug.trace("iEquip_UILIB QueueMenu_SetData end")
EndFunction

Function QueueMenu_RefreshTitle(String asTitle) Global
	debug.trace("iEquip_UILIB QueueMenu_RefreshTitle start")
	UI.SetString("CustomMenu", "_root.iEquipQueueDialog.titleTextField.text", asTitle)
	debug.trace("iEquip_UILIB QueueMenu_RefreshTitle end")
endFunction

Function QueueMenu_RefreshList(String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, int iIndex) Global
	debug.trace("iEquip_UILIB QueueMenu_RefreshList start")
	UI.Invoke("CustomMenu", "_root.iEquipQueueDialog.clearIconLists")
	Int iIndex2
	String iconName
	bool isEnchanted
	bool isPoisoned
	While iIndex2 < asIconNameList.length
		iconName = asIconNameList[iIndex2]
		isEnchanted = abEnchFlags[iIndex2]
		isPoisoned = abPoisonFlags[iIndex2]
		UI.InvokeString("CustomMenu", "_root.iEquipQueueDialog.initIconNameList", iconName)
		UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.initIsEnchantedList", isEnchanted)
		UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.initIsPoisonedList", isPoisoned)
		iIndex2 += 1
	endWhile
	UI.InvokeStringA("CustomMenu", "_root.iEquipQueueDialog.refreshList", asList)
	UI.InvokeInt("CustomMenu", "_root.iEquipQueueDialog.redrawList", iIndex)
	debug.trace("iEquip_UILIB QueueMenu_RefreshList end")
endFunction

Function QueueMenu_Release(Form akClient) Global
	debug.trace("iEquip_UILIB QueueMenu_Release start")
	akClient.UnregisterForModEvent("iEquip_queueMenuOpen")
	akClient.UnregisterForModEvent("iEquip_queueMenuMoveUp")
	akClient.UnregisterForModEvent("iEquip_queueMenuMoveDown")
	akClient.UnregisterForModEvent("iEquip_queueMenuRemove")
	akClient.UnregisterForModEvent("iEquip_queueMenuClear")
	akClient.UnregisterForModEvent("iEquip_queueMenuExit")
	debug.trace("iEquip_UILIB QueueMenu_Release end")
EndFunction

Function ShowQueueMenu(String asTitle, String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, Int aiStartIndex, Int aiDefaultIndex, bool directAccess = false)
	debug.trace("iEquip_UILIB ShowQueueMenu start")
	If(bMenuOpen)
		Return
	EndIf
	bMenuOpen = True
	sTitle = asTitle
	sIconNameList = asIconNameList
	sList = asList
	bEnchFlags = abEnchFlags
	bPoisonFlags = abPoisonFlags
	iStartIndex = aiStartIndex
	iDefaultIndex = aiDefaultIndex
	bDirectAccess = directAccess
	QueueMenu_Open(Self)
	While(bMenuOpen)
		Utility.WaitMenuMode(0.1)
	EndWhile
	QueueMenu_Release(Self)
	debug.trace("iEquip_UILIB ShowQueueMenu end")
EndFunction

Event OnQueueMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuOpen start")
	If(asEventName == "iEquip_queueMenuOpen")
		QueueMenu_SetData(sTitle, sIconNameList, sList, bEnchFlags, bPoisonFlags, iStartIndex, iDefaultIndex, bDirectAccess)
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuOpen end")
EndEvent

Event OnQueueMenuMoveUp(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuMoveUp start")
	If(asEventName == "iEquip_queueMenuMoveUp")
		int iIndex = afNumArg as int
		WC.QueueMenuSwap(0, iIndex)
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuMoveUp end")
EndEvent

Event OnQueueMenuMoveDown(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuMoveDown start")
	If(asEventName == "iEquip_queueMenuMoveDown")
		int iIndex = afNumArg as int
		WC.QueueMenuSwap(1, iIndex)
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuMoveDown end")
EndEvent

Event OnQueueMenuRemove(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuRemove start")
	If(asEventName == "iEquip_queueMenuRemove")
		int iIndex = afNumArg as int
		WC.QueueMenuRemoveFromQueue(iIndex)
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuRemove end")
EndEvent

Event OnQueueMenuClear(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuClear start")
	If(asEventName == "iEquip_queueMenuClear")
		bMenuOpen = False
		int i = iEquip_ConfirmClearQueue.Show()
		if i == 0 ;Cancel
			WC.recallPreviousQueueMenu()
		else
			WC.QueueMenuClearQueue()
		endIf
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuClear end")
EndEvent

Event OnQueueMenuExit(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip_UILIB OnQueueMenuExit start")
	If(asEventName == "iEquip_queueMenuExit")
		bMenuOpen = False
		WC.recallQueueMenu()
	EndIf
	debug.trace("iEquip_UILIB OnQueueMenuExit end")
EndEvent

function closeQueueMenu()
	debug.trace("iEquip_UILIB closeQueueMenu start")
	UI.Invoke("CustomMenu", "_root.iEquipQueueDialog.closeQueueMenu")
	Utility.WaitMenuMode(0.1)
	bMenuOpen = False
	debug.trace("iEquip_UILIB closeQueueMenu end")
endFunction