ScriptName iEquip_TempItemCleanupUpdateScript Extends Quest Hidden

import iEquip_InventoryExt

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_AmmoMode property AM auto

Actor property PlayerRef auto

bool bWaitingForCleanupUpdate
bool bRemovingTempItems

function registerForCleanupUpdate()
	RegisterForSingleUpdate(1.0)
	bWaitingForCleanupUpdate = true
endFunction

event OnUpdate()
	if bWaitingForCleanupUpdate
		if !bRemovingTempItems 																			; Should block multiple runs in the case of two or three items being unequipped in quick succession

			bRemovingTempItems = true

			int Q
			int i
			int targetQ
			int targetObj
			int handle
			int slot
			form currentObject
			bool removeItem

			Utility.Wait(1.0) 																			; Should be enough time to let any equipping events happen, triggering Ammo Mode, etc, before we remove temp items

			while Q < 3
				targetQ = WC.aiTargetQ[Q]
				currentObject = PlayerRef.GetEquippedObject(Q)
				i = jArray.count(targetQ) - 1															; Temp items will always have been added at the end of the queue so start at the end and work backwards
				while i > 0
					targetObj = jArray.getObj(targetQ, i)
					if jMap.getInt(targetObj, "iEquipTempItem") == 1
						if !currentObject || jMap.getForm(targetObj, "iEquipForm") != currentObject 	; If we don't have anything currently equipped, or the equipped form doesn't match the temp item, mark the temp item for removal
							removeItem = true
						elseIf Q < 2																	; Otherwise if we're checking left/right queues and the forms do match, check the temp item refHandle against the worn one 
							handle = jMap.getInt(targetObj, "iEquipHandle", 0xFFFF)
							if handle != 0xFFFF
								if Q == 0 && currentObject as armor && (currentObject as armor).IsShield()
									slot = 2
								else
									slot = Q
								endIf
								
								if handle != iEquip_InventoryExt.GetRefHandleFromWornObject(slot) 		; And mark the temp item for removal if the refHandle doesn't match the currently equipped one
									removeItem = true
								endIf
							endIf
						endIf
						if removeItem && i != WC.aiCurrentQueuePosition[Q] && !((PM.bPreselectMode || (Q == 0 && AM.bAmmoMode)) && i == WC.aiCurrentlyPreselected[Q]) 	; Now check it's not the currently displayed item, and not currently preselected if relevant and remove if safe to do so
							WC.removeTempItemFromQueue(Q, i)
						endIf
					endIf
					i -= 1
				endWhile	
				Q += 1
			endWhile
			bRemovingTempItems = false
		endIf
	endIf
endEvent
