
scriptname iEquip_ChargeMeterUpdateScript extends quest

Import UICallback

iEquip_WidgetCore Property WC Auto
iEquip_ChargeMeters Property CM Auto

int Q
String HUD_MENU
String WidgetRoot
int targetDisplay

bool WaitingForMeterFadeoutUpdate = false

function registerForMeterFadeoutUpdate(int slot, int displayType, float delay)
	Q = slot
	targetDisplay = displayType
	HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	RegisterForSingleUpdate(delay)
	WaitingForMeterFadeoutUpdate = true
endFunction

event OnUpdate()
	if WaitingForMeterFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		WaitingForMeterFadeoutUpdate = false
		CM.isChargeMeterShown[Q] = false
		Int iHandle
		if targetDisplay == 1
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenChargeMeterAlpha")
		elseIf targetDisplay == 2
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenSoulGemAlpha")
		endIf
		If(iHandle)
			UICallback.PushInt(iHandle, Q)
			UICallback.PushFloat(iHandle, 0.0) ;Target alpha which for FadeOut is 0
			UICallback.Send(iHandle)
		EndIf
	endIf
endEvent