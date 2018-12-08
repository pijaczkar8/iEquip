
scriptname iEquip_ChargeMeterUpdateScript extends quest

Import UICallback

iEquip_WidgetCore Property WC Auto
iEquip_ChargeMeters Property CM Auto

int Q
String WidgetRoot
int iTargetDisplay

bool bWaitingForMeterFadeoutUpdate = false

function registerForMeterFadeoutUpdate(int slot, int displayType, float delay)
	Q = slot
	iTargetDisplay = displayType
	WidgetRoot = WC.WidgetRoot
	RegisterForSingleUpdate(delay)
	bWaitingForMeterFadeoutUpdate = true
endFunction

event OnUpdate()
	if bWaitingForMeterFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForMeterFadeoutUpdate = false
		CM.abIsChargeMeterShown[Q] = false
		Int iHandle
		if iTargetDisplay == 1
			iHandle = UICallback.Create("HUD Menu", WidgetRoot + ".tweenChargeMeterAlpha")
		elseIf iTargetDisplay == 2
			iHandle = UICallback.Create("HUD Menu", WidgetRoot + ".tweenSoulGemAlpha")
		endIf
		If(iHandle)
			UICallback.PushInt(iHandle, Q)
			UICallback.PushFloat(iHandle, 0.0) ;Target alpha which for FadeOut is 0
			UICallback.Send(iHandle)
		EndIf
	endIf
endEvent