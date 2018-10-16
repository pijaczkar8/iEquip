ScriptName iEquip_ShoutNameUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

Import UICallback

String HUD_MENU
String WidgetRoot

Float Delay
Float Duration

bool WaitingForNameFadeoutUpdate = false

Int Element = 34 ;Array index for shoutName_mc in the clipArray in iEquipWidget.as

function registerForNameFadeoutUpdate()
	HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	Delay = MCM.mainNameFadeoutDelay
	Duration = MCM.nameFadeoutDuration
	if WC.nameFadeoutEnabled && Delay > 0
		RegisterForSingleUpdate(Delay)
		WaitingForNameFadeoutUpdate = true
	endIf
endFunction

function unregisterForNameFadeoutUpdate()
	UnregisterForUpdate()
	WaitingForNameFadeoutUpdate = false
endFunction

event OnUpdate()
	if WaitingForNameFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		WaitingForNameFadeoutUpdate = false
		WC.isNameShown[2] = false
		Int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetNameAlpha")
		If(iHandle)
			UICallback.PushInt(iHandle, Element) ;Which _mc we're fading out
			UICallback.PushFloat(iHandle, 0) ;Target alpha which for FadeOut is 0
			UICallback.PushFloat(iHandle, Duration) ;FadeOut duration
			UICallback.Send(iHandle)
		EndIf
	endIf
endEvent