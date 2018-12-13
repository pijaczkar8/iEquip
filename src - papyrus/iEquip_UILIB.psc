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
	aCustomColors = new int[14]
	int i = 0
	While i < aCustomColors.length
		aCustomColors[i] = -1
		i += 1
	endWhile
endFunction

Bool function IsMenuOpen()
	return bMenuOpen
endFunction

;Text input
Function TextInputMenu_Open(Form akClient) Global
	akClient.RegisterForModEvent("iEquip_textInputOpen", "OnTextInputOpen")
	akClient.RegisterForModEvent("iEquip_textInputClose", "OnTextInputClose")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_textinputmenu")
EndFunction

Function TextInputMenu_SetData(String asTitle, String asInitialText) Global
	UI.InvokeNumber("CustomMenu", "_root.iEquipTextInputDialog.setPlatform", (Game.UsingGamepad() as Int))
	String[] sData = new String[2]
	sData[0] = asTitle
	sData[1] = asInitialText
	UI.InvokeStringA("CustomMenu", "_root.iEquipTextInputDialog.initData", sData)
EndFunction

Function TextInputMenu_Release(Form akClient) Global
	akClient.UnregisterForModEvent("iEquip_textInputOpen")
	akClient.UnregisterForModEvent("iEquip_textInputClose")
EndFunction

String Function ShowTextInput(String asTitle, String asInitialText)
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
	Return sInput
EndFunction

Event OnTextInputOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_textInputOpen")
		TextInputMenu_SetData(sTitle, sInitialText)
	EndIf
EndEvent

Event OnTextInputClose(String asEventName, String asInput, Float afCancelled, Form akSender)
	If(asEventName == "iEquip_textInputClose")
		If(afCancelled as Bool)
			sInput = ""
		Else
			sInput = asInput
		EndIf
		bMenuOpen = False
	EndIf
EndEvent

;List
Function ListMenu_Open(Form akClient) Global
	akClient.RegisterForModEvent("iEquip_listMenuOpen", "OnListMenuOpen")
	akClient.RegisterForModEvent("iEquip_listMenuCancel", "OnListMenuCancel")
	akClient.RegisterForModEvent("iEquip_listMenuDeletePreset", "OnListMenuDeletePreset")
	akClient.RegisterForModEvent("iEquip_listMenuLoad", "OnListMenuLoad")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_listmenu")
EndFunction

Function ListMenu_SetData(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex) Global
	UI.InvokeNumber("CustomMenu", "_root.iEquipListDialog.setPlatform", (Game.UsingGamepad() as Int))
	UI.InvokeStringA("CustomMenu", "_root.iEquipListDialog.initListData", asOptions)
	Int iHandle = UICallback.Create("CustomMenu", "_root.iEquipListDialog.initListParams")
	If(iHandle)
		UICallback.PushString(iHandle, asTitle)
		UICallback.PushInt(iHandle, aiStartIndex)
		UICallback.PushInt(iHandle, aiDefaultIndex)
		UICallback.Send(iHandle)
	EndIf
EndFunction

Function ListMenu_Release(Form akClient) Global
	akClient.UnregisterForModEvent("iEquip_listMenuOpen")
	akClient.UnregisterForModEvent("iEquip_listMenuCancel")
	akClient.UnregisterForModEvent("iEquip_listMenuDeletePreset")
	akClient.UnregisterForModEvent("iEquip_listMenuLoad")
EndFunction

Int[] Function ShowList(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex)
	int[] args = new int[2]
	args[0] = -1
	args[1] = 0
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
	Return args
EndFunction

Event OnListMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_listMenuOpen")
		ListMenu_SetData(sTitle, sOptions, iStartIndex, iDefaultIndex)
	EndIf
EndEvent

Event OnListMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_listMenuCancel")
		bMenuOpen = False
	EndIf
EndEvent

Event OnListMenuDeletePreset(String asEventName, String asStringArg, Float afInput, Form akSender)
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
EndEvent

Event OnListMenuLoad(String asEventName, String asStringArg, Float afInput, Form akSender)
	If(asEventName == "iEquip_listMenuLoad")
		iInput = afInput as Int
		iLoadDelete = 0
		bMenuOpen = False
	EndIf
EndEvent

;Color

Int[] Function ShowColorMenu(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] CustomColors)
	int[] args = new int[2]
	args[0] = -1
	args[1] = 0
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
	Int NewCustom = 0
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
	Return args
EndFunction

Function ColorMenu_Open(Form akClient) Global
	akClient.RegisterForModEvent("iEquip_colorMenuOpen", "OnColorMenuOpen")
	akClient.RegisterForModEvent("iEquip_colorMenuCancel", "OnColorMenuCancel")
	akClient.RegisterForModEvent("iEquip_colorMenuAccept", "OnColorMenuAccept")
	akClient.RegisterForModEvent("iEquip_colorMenuDelete", "OnColorMenuDelete")
	akClient.RegisterForModEvent("iEquip_colorMenuCustom", "OnColorMenuCustom")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_ColorMenu")
EndFunction

Event OnColorMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_colorMenuOpen")
		ColorMenu_SetData(sTitle, iStartColor, iDefaultColor, aCustomColors)
	EndIf
EndEvent

Function ColorMenu_SetData(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] aaCustomColors) Global
	Int iIndex = 0
	Int iIndex2 = 0
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
EndFunction

Event OnColorMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_colorMenuCancel")
		bMenuOpen = False
	EndIf
EndEvent

Event OnColorMenuCustom(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	;Event only called if Custom has been pressed to add a custom colour
	If(asEventName == "iEquip_colorMenuCustom")
		bCallTextInput = True
		bMenuOpen = False
	EndIf
EndEvent

Event OnColorMenuDelete(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	;Event only called if Default has been pressed to reset a custom colour slot
	If(asEventName == "iEquip_colorMenuDelete")
		bMenuOpen = False
		EM.DeleteCustomColor(afNumArg as Int)
	EndIf
EndEvent

Event OnColorMenuAccept(String asEventName, String asStringArg, Float afInput, Form akSender)
	If(asEventName == "iEquip_colorMenuAccept")
		iInput = afInput as Int
		bMenuOpen = False
	EndIf
EndEvent

Function ColorMenu_Release(Form akClient) Global
	akClient.UnregisterForModEvent("iEquip_colorMenuOpen")
	akClient.UnregisterForModEvent("iEquip_colorMenuCancel")
	akClient.UnregisterForModEvent("iEquip_colorMenuAccept")
	akClient.UnregisterForModEvent("iEquip_colorMenuCustom")
	akClient.UnregisterForModEvent("iEquip_colorMenuDelete")
EndFunction

;Queue
Function QueueMenu_Open(Form akClient) Global
	akClient.RegisterForModEvent("iEquip_queueMenuOpen", "OnQueueMenuOpen")
	akClient.RegisterForModEvent("iEquip_queueMenuMoveUp", "OnQueueMenuMoveUp")
	akClient.RegisterForModEvent("iEquip_queueMenuMoveDown", "OnQueueMenuMoveDown")
	akClient.RegisterForModEvent("iEquip_queueMenuRemove", "OnQueueMenuRemove")
	akClient.RegisterForModEvent("iEquip_queueMenuClear", "OnQueueMenuClear")
	akClient.RegisterForModEvent("iEquip_queueMenuExit", "OnQueueMenuExit")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_queuemenu")
EndFunction

Function QueueMenu_SetData(String asTitle, String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, Int aiStartIndex, Int aiDefaultIndex, bool directAccess) Global
	UI.InvokeBool("CustomMenu", "_root.iEquipQueueDialog.setExitButtonText", directAccess)
	UI.InvokeNumber("CustomMenu", "_root.iEquipQueueDialog.setPlatform", (Game.UsingGamepad() as Int))
	Int iIndex = 0
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
EndFunction

Function QueueMenu_RefreshTitle(String asTitle) Global
	UI.SetString("CustomMenu", "_root.iEquipQueueDialog.titleTextField.text", asTitle)
endFunction

Function QueueMenu_RefreshList(String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, int iIndex) Global
	UI.Invoke("CustomMenu", "_root.iEquipQueueDialog.clearIconLists")
	Int iIndex2 = 0
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
endFunction

Function QueueMenu_Release(Form akClient) Global
	akClient.UnregisterForModEvent("iEquip_queueMenuOpen")
	akClient.UnregisterForModEvent("iEquip_queueMenuMoveUp")
	akClient.UnregisterForModEvent("iEquip_queueMenuMoveDown")
	akClient.UnregisterForModEvent("iEquip_queueMenuRemove")
	akClient.UnregisterForModEvent("iEquip_queueMenuClear")
	akClient.UnregisterForModEvent("iEquip_queueMenuExit")
EndFunction

Function ShowQueueMenu(String asTitle, String[] asIconNameList, String[] asList, bool[] abEnchFlags, bool[] abPoisonFlags, Int aiStartIndex, Int aiDefaultIndex, bool directAccess = false)
	
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
EndFunction

Event OnQueueMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuOpen")
		QueueMenu_SetData(sTitle, sIconNameList, sList, bEnchFlags, bPoisonFlags, iStartIndex, iDefaultIndex, bDirectAccess)
	EndIf
EndEvent

Event OnQueueMenuMoveUp(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuMoveUp")
		int iIndex = afNumArg as int
		WC.QueueMenuSwap(0, iIndex)
	EndIf
EndEvent

Event OnQueueMenuMoveDown(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuMoveDown")
		int iIndex = afNumArg as int
		WC.QueueMenuSwap(1, iIndex)
	EndIf
EndEvent

Event OnQueueMenuRemove(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuRemove")
		int iIndex = afNumArg as int
		WC.QueueMenuRemoveFromQueue(iIndex)
	EndIf
EndEvent

Event OnQueueMenuClear(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuClear")
		bMenuOpen = False
		int i = iEquip_ConfirmClearQueue.Show()
		if i == 0 ;Cancel
			WC.recallPreviousQueueMenu()
		else
			WC.QueueMenuClearQueue()
		endIf
	EndIf
EndEvent

Event OnQueueMenuExit(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	If(asEventName == "iEquip_queueMenuExit")
		bMenuOpen = False
		WC.recallQueueMenu()
	EndIf
EndEvent

function closeQueueMenu()
	UI.Invoke("CustomMenu", "_root.iEquipQueueDialog.closeQueueMenu")
	Utility.Wait(0.1)
	bMenuOpen = False
endFunction