ScriptName iEquip_RightHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto
iEquip_BeastMode Property BM Auto

bool bReverse
bool bWaitingForEquipOnPauseUpdate
bool bBeastMode

function registerForEquipOnPauseUpdate(bool Reverse, bool beastMode = false)
	;debug.trace("iEquip_RightHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	bReverse = Reverse
	bBeastMode = beastMode
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	;debug.trace("iEquip_RightHandEquipUpdateScript OnUpdate called")
	if bWaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForEquipOnPauseUpdate = false
		if bBeastMode
			BM.checkAndEquipShownHandItem(1, false)
		else
			WC.checkAndEquipShownHandItem(1, bReverse)
		endIf
	endIf
endEvent