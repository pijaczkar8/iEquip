ScriptName iEquip_LeftHandEquipUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

bool Reverse = false
bool WaitingForEquipOnPauseUpdate = false
bool cyclingAmmo = false

function registerForEquipOnPauseUpdate(bool bReverse, bool bCyclingAmmo = false)
	debug.trace("iEquip_LeftHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	Reverse = bReverse
	cyclingAmmo = bCyclingAmmo
	RegisterForSingleUpdate(MCM.equipOnPauseDelay)
	WaitingForEquipOnPauseUpdate = true
endFunction

event OnUpdate()
	debug.trace("iEquip_LeftHandEquipUpdateScript OnUpdate called")
	if WaitingForEquipOnPauseUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		WaitingForEquipOnPauseUpdate = false
		if cyclingAmmo
			WC.equipAmmo()
		else
			WC.checkAndEquipShownHandItem(0, Reverse)
		endIf
	endIf
endEvent