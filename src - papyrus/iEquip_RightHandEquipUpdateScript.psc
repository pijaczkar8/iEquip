ScriptName iEquip_RightHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto

bool bReverse
bool bWaitingForEquipOnPauseUpdate

function registerForEquipOnPauseUpdate(bool Reverse)
	debug.trace("iEquip_RightHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	bReverse = Reverse
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	debug.trace("iEquip_RightHandEquipUpdateScript OnUpdate called")
	if bWaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForEquipOnPauseUpdate = false
		WC.checkAndEquipShownHandItem(1, bReverse)
	endIf
endEvent