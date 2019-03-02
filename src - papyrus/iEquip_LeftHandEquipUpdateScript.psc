ScriptName iEquip_LeftHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto

bool bReverse
bool bWaitingForEquipOnPauseUpdate
bool bCyclingAmmo

function registerForEquipOnPauseUpdate(bool Reverse, bool CyclingAmmo = false)
	debug.trace("iEquip_LeftHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	bReverse = Reverse
	bCyclingAmmo = CyclingAmmo
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	debug.trace("iEquip_LeftHandEquipUpdateScript OnUpdate called")
	if bWaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForEquipOnPauseUpdate = false
		if bCyclingAmmo
			AM.equipAmmo()
		else
			WC.checkAndEquipShownHandItem(0, bReverse)
		endIf
	endIf
endEvent