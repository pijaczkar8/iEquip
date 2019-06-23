ScriptName iEquip_LeftHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_BeastMode Property BM Auto

bool bReverse
bool bWaitingForEquipOnPauseUpdate
bool bCyclingAmmo
bool bBeastMode

function registerForEquipOnPauseUpdate(bool Reverse, bool CyclingAmmo = false, bool beastMode = false)
	;debug.trace("iEquip_LeftHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	bReverse = Reverse
	bCyclingAmmo = CyclingAmmo
	bBeastMode = beastMode
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	;debug.trace("iEquip_LeftHandEquipUpdateScript OnUpdate called")
	if bWaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForEquipOnPauseUpdate = false
		if bCyclingAmmo
			AM.equipAmmo()
		elseIf bBeastMode
			BM.checkAndEquipShownHandItem(0, false)
		else
			WC.checkAndEquipShownHandItem(0, bReverse)
		endIf
	endIf
endEvent