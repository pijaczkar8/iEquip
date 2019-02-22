ScriptName iEquip_ShoutPositionIndicatorUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto

Import UI

String WidgetRoot

bool bWaitingForFadeoutUpdate

function registerForFadeoutUpdate()
	WidgetRoot = WC.WidgetRoot
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForFadeoutUpdate = true
endFunction

event OnUpdate()
	if bWaitingForFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForFadeoutUpdate = false
		UI.invokeInt("HUD Menu", WidgetRoot + ".hideQueuePositionIndicator", 2)
	endIf
endEvent