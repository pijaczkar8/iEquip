ScriptName iEquip_UILIB Extends Form
{SkyUILib API - Version 1}

;Private variables
Bool bMenuOpen
Bool bCallTextInput
String sTitle
String sInitialText
String sInput
String[] sOptions
Int iStartIndex
Int iDefaultIndex
Int iStartColor
Int iDefaultColor
Int[] aCustomColors
Int iInput
Int iLoadDelete

Message Property iEquip_ConfirmDeletePreset Auto

iEquip_EditMode Property EM Auto

function onInit()
	aCustomColors = new int[14]
	int i = 0
	While i < aCustomColors.length
		aCustomColors[i] = -1
		i += 1
	endWhile
endFunction

;Text input
Function TextInputMenu_Open(Form akClient) Global
	debug.trace("iEquip UILIB TextInputMenu_Open start")
	akClient.RegisterForModEvent("iEquip_textInputOpen", "OnTextInputOpen")
	akClient.RegisterForModEvent("iEquip_textInputClose", "OnTextInputClose")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_textinputmenu")
EndFunction

Function TextInputMenu_SetData(String asTitle, String asInitialText) Global
	debug.trace("iEquip UILIB TextInputMenu_SetData start")
	UI.InvokeNumber("CustomMenu", "_root.iEquipTextInputDialog.setPlatform", (Game.UsingGamepad() as Int))
	String[] sData = new String[2]
	sData[0] = asTitle
	sData[1] = asInitialText
	UI.InvokeStringA("CustomMenu", "_root.iEquipTextInputDialog.initData", sData)
EndFunction

Function TextInputMenu_Release(Form akClient) Global
	debug.trace("iEquip UILIB TextInputMenu_Release start")
	akClient.UnregisterForModEvent("iEquip_textInputOpen")
	akClient.UnregisterForModEvent("iEquip_textInputClose")
EndFunction

String Function ShowTextInput(String asTitle, String asInitialText)
	debug.trace("iEquip UILIB ShowTextInput start")
	If(bMenuOpen)
		debug.trace("iEquip UILIB ShowTextInput returning empty as bMenuOpen = true")
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
	debug.trace("iEquip UILIB ShowTextInput returning string before ending")
	Return sInput
EndFunction

Event OnTextInputOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip UILIB OnTextInputOpen start")
	If(asEventName == "iEquip_textInputOpen")
		TextInputMenu_SetData(sTitle, sInitialText)
	EndIf
EndEvent

Event OnTextInputClose(String asEventName, String asInput, Float afCancelled, Form akSender)
	debug.trace("iEquip UILIB OnTextInputClose start")
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
	debug.trace("iEquip UILIB ListMenu_Open start")
	akClient.RegisterForModEvent("iEquip_listMenuOpen", "OnListMenuOpen")
	akClient.RegisterForModEvent("iEquip_listMenuCancel", "OnListMenuCancel")
	akClient.RegisterForModEvent("iEquip_listMenuDeletePreset", "OnListMenuDeletePreset")
	akClient.RegisterForModEvent("iEquip_listMenuLoad", "OnListMenuLoad")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_listmenu")
	debug.trace("iEquip UILIB ListMenu_Open finish")
EndFunction

Function ListMenu_SetData(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex) Global
	debug.trace("iEquip UILIB ListMenu_SetData start")
	UI.InvokeNumber("CustomMenu", "_root.iEquipListDialog.setPlatform", (Game.UsingGamepad() as Int))
	debug.trace("iEquip UILIB ListMenu_SetData .setPlatform called")
	UI.InvokeStringA("CustomMenu", "_root.iEquipListDialog.initListData", asOptions)
	debug.trace("iEquip UILIB ListMenu_SetData .initListData called")
	Int iHandle = UICallback.Create("CustomMenu", "_root.iEquipListDialog.initListParams")
	debug.trace("iEquip UILIB ListMenu_SetData .initListParams called")
	If(iHandle)
		UICallback.PushString(iHandle, asTitle)
		UICallback.PushInt(iHandle, aiStartIndex)
		UICallback.PushInt(iHandle, aiDefaultIndex)
		UICallback.Send(iHandle)
	EndIf
	debug.trace("iEquip UILIB ListMenu_SetData finished")
EndFunction

Function ListMenu_Release(Form akClient) Global
	akClient.UnregisterForModEvent("iEquip_listMenuOpen")
	akClient.UnregisterForModEvent("iEquip_listMenuCancel")
	akClient.UnregisterForModEvent("iEquip_listMenuDeletePreset")
	akClient.UnregisterForModEvent("iEquip_listMenuLoad")
EndFunction

Int[] Function ShowList(String asTitle, String[] asOptions, Int aiStartIndex, Int aiDefaultIndex)
	debug.trace("iEquip UILIB ShowList started")
	int[] args = new int[2]
	args[0] = -1
	args[1] = 0
	If(bMenuOpen)
		debug.trace("iEquip UILIB ShowList returning -1,0 as bMenuOpen = true")
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
	debug.trace("iEquip UILIB ShowList returning values before ending")
	Return args
EndFunction

Event OnListMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip UILIB OnListMenuOpen start")
	If(asEventName == "iEquip_listMenuOpen")
		ListMenu_SetData(sTitle, sOptions, iStartIndex, iDefaultIndex)
	EndIf
EndEvent

Event OnListMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip UILIB OnListMenuCancel start")
	If(asEventName == "iEquip_listMenuCancel")
		bMenuOpen = False
	EndIf
EndEvent

Event OnListMenuDeletePreset(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip UILIB OnListMenuDeletePreset start")
	If(asEventName == "iEquip_listMenuDeletePreset")
		int iButton = iEquip_ConfirmDeletePreset.Show() ;Add messagebox to check if user wants to reset parent and all child elements or not, return out if not
        if iButton != 1
           return
        endIf
        ;UI.Invoke("CustomMenu", "_root.iEquipListDialog.confirmDelete")
		iInput = afInput as Int
		debug.trace("iEquip_UILIB OnListMenuDeletePreset: iInput = " + iInput as String)
		debug.notification("iEquip_UILIB OnListMenuDeletePreset: iInput = " + iInput as String)
		iLoadDelete = 1
		bMenuOpen = False
	EndIf
EndEvent

Event OnListMenuLoad(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip UILIB OnListMenuLoad start")
	If(asEventName == "iEquip_listMenuLoad")
		debug.notification("iEquip_UILIB OnListMenuLoad: afInput = " + afInput as String)
		iInput = afInput as Int
		debug.trace("iEquip_UILIB OnListMenuLoad: iInput = " + iInput as String)
		debug.notification("iEquip_UILIB OnListMenuLoad: iInput = " + iInput as String)
		iLoadDelete = 0
		bMenuOpen = False
	EndIf
EndEvent

;Color

Int[] Function ShowColorMenu(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] CustomColors)
	debug.trace("iEquip UILIB ShowColorMenu started")
	int[] args = new int[2]
	args[0] = -1
	args[1] = 0
	If(bMenuOpen)
		debug.trace("iEquip UILIB ShowColorMenu returning -1,0 as bMenuOpen = true")
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
	debug.notification("aCustomColors length: " + aCustomColors.length as String + ", index 0 contains " + aCustomColors[0] as String)
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
	debug.trace("iEquip UILIB ColorMenu_Open start")
	akClient.RegisterForModEvent("iEquip_colorMenuOpen", "OnColorMenuOpen")
	akClient.RegisterForModEvent("iEquip_colorMenuCancel", "OnColorMenuCancel")
	akClient.RegisterForModEvent("iEquip_colorMenuAccept", "OnColorMenuAccept")
	akClient.RegisterForModEvent("iEquip_colorMenuDefault", "OnColorMenuDefault")
	akClient.RegisterForModEvent("iEquip_colorMenuCustom", "OnColorMenuCustom")
	UI.OpenCustomMenu("iEquip_uilib/iEquip_UILIB_ColorMenu")
	debug.trace("iEquip UILIB ColorMenu_Open finish")
EndFunction

Event OnColorMenuOpen(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip UILIB OnColorMenuOpen start")
	If(asEventName == "iEquip_colorMenuOpen")
		ColorMenu_SetData(sTitle, iStartColor, iDefaultColor, aCustomColors)
	EndIf
EndEvent

Function ColorMenu_SetData(String asTitle, Int aiStartColor, Int aiDefaultColor, Int[] aaCustomColors) Global
	debug.trace("iEquip UILIB ColorMenu_SetData start")
	
	UI.InvokeNumber("CustomMenu", "_root.iEquipColorDialog.setPlatform", (Game.UsingGamepad() as Int))
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
	debug.trace("iEquip UILIB ColorMenu_SetData finished")
EndFunction

Event OnColorMenuCancel(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	debug.trace("iEquip UILIB OnColorMenuCancel start")
	If(asEventName == "iEquip_colorMenuCancel")
		bMenuOpen = False
	EndIf
EndEvent

Event OnColorMenuCustom(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	;Event only called if Custom has been pressed to add a custom colour
	debug.trace("iEquip UILIB OnColorMenuCustom start")
	If(asEventName == "iEquip_colorMenuCustom")
		bCallTextInput = True
		bMenuOpen = False
	EndIf
EndEvent

Event OnColorMenuDefault(String asEventName, String asStringArg, Float afNumArg, Form akSender)
	;Event only called if Default has been pressed to reset a custom colour slot
	debug.trace("iEquip UILIB OnColorMenuDefault start")
	If(asEventName == "iEquip_colorMenuDefault")
		Int ArrayIndexToDelete = afNumArg as Int
		bMenuOpen = False
		EM.updateCustomColors(1, 0, ArrayIndexToDelete)
	EndIf
EndEvent

Event OnColorMenuAccept(String asEventName, String asStringArg, Float afInput, Form akSender)
	debug.trace("iEquip UILIB OnColorMenuLoad start")
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
	akClient.UnregisterForModEvent("iEquip_colorMenuDefault")
EndFunction

