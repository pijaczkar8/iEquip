ScriptName iEquip_RightHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

bool Reverse = false
bool WaitingForEquipOnPauseUpdate = false

function registerForEquipOnPauseUpdate(bool bReverse)
	debug.trace("iEquip_RightHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	Reverse = bReverse
	RegisterForSingleUpdate(MCM.equipOnPauseDelay)
	WaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	debug.trace("iEquip_RightHandEquipUpdateScript OnUpdate called")
	if WaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		WaitingForEquipOnPauseUpdate = false
		WC.checkAndEquipShownHandItem(1, Reverse)
	endIf
endEvent