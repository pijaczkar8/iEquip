ScriptName iEquip_RemovedPotionUpdateScript Extends Quest Hidden

iEquip_PotionScript property PO auto

bool bWaitingForRemovedPotionUpdate

function registerForRemovedPotionUpdate()
	RegisterForSingleUpdate(0.3)
	bWaitingForRemovedPotionUpdate = true
endFunction

event OnUpdate()
	if bWaitingForRemovedPotionUpdate
		if PO.GetState() == "PROCESSING"
			RegisterForSingleUpdate(0.1)
		else
			bWaitingForRemovedPotionUpdate = false
			PO.handleRemovedPotions()
		endIf
	endIf
endEvent
