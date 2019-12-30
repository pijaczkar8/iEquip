ScriptName iEquip_SlowTimeEffectUpdateScript Extends Quest

iEquip_WidgetCore Property WC Auto

bool bWaitingForSlowTimeEffectUpdate

function registerForSlowTimeEffectUpdate()
	;debug.trace("iEquip_LeftHandEquipUpdateScript registerForEquipOnPauseUpdate called")
	RegisterForSingleUpdate(WC.fEquipOnPauseDelay)
	bWaitingForSlowTimeEffectUpdate = true
endFunction

event OnUpdate()
	;debug.trace("iEquip_LeftHandEquipUpdateScript OnUpdate called")
	if bWaitingForSlowTimeEffectUpdate 										; Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForSlowTimeEffectUpdate = false
		WC.removeSlowTimeEffect()
	endIf
endEvent