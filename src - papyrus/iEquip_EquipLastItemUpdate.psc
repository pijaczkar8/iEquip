ScriptName iEquip_EquipLastItemUpdate Extends Quest Hidden

iEquip_EquipLastItem property EL auto

bool bWaitingForEquipLastItemUpdate

function registerForEquipLastItemUpdate(float fTimeout)
	RegisterForSingleUpdate(fTimeout)
	bWaitingForEquipLastItemUpdate = true
endFunction

event OnUpdate()
	if bWaitingForEquipLastItemUpdate
		bWaitingForEquipLastItemUpdate = false
		EL.runUpdate()
	endIf
endEvent
