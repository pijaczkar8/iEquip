
Scriptname iEquip_AddedItemHandler extends ReferenceAlias

Import iEquip_AmmoExt
Import iEquip_FormExt
Import StringUtil

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
;iEquip_PlayerEventHandler Property EH Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef Auto

FormList Property iEquip_RemovedItemsFLST Auto
FormList Property iEquip_ItemsToAddFLST Auto

Event OnInit()
	gotoState("DISABLED")
	OnPlayerLoadGame()
endEvent

function OniEquipEnabled(bool enabled)
	if enabled
		gotoState("")
	else
		gotoState("DISABLED")
	endIf
endFunction
	
Event OnPlayerLoadGame()
	debug.trace("iEquip_AddedItemHandler OnPlayerLoadGame called")
	if WC.isEnabled
		gotoState("")
	else
		gotoState("DISABLED")
	endIf
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	debug.trace("iEquip_AddedItemHandler OnItemAdded called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	iEquip_ItemsToAddFLST.AddForm(akBaseItem)
	registerForSingleUpdate(0.5)
endEvent

event OnUpdate()
	debug.trace("iEquip_AddedItemHandler OnUpdate called")
	int i = 0
	int j
	int numForms = iEquip_ItemsToAddFLST.GetSize()
	debug.trace("iEquip_AddedItemHandler OnUpdate - number of forms to process: " + numForms)
	form formToAdd
	while i < numForms
		formToAdd = iEquip_ItemsToAddFLST.GetAt(i)
		;Handle Potions, Ammo and bound ammo first
		if formToAdd as potion
			PO.onPotionAdded(formToAdd)
		elseIf formToAdd as ammo && (Game.GetModName(formToAdd.GetFormID() / 0x1000000) != "JZBai_ThrowingWpnsLite.esp")
			if WC.EH.boundSpellEquipped && iEquip_AmmoExt.IsAmmoBound(formToAdd as ammo)
				AM.addBoundAmmoToQueue(formToAdd, formToAdd.GetName())
			else
				AM.onAmmoAdded(formToAdd)
			endIf
	    ;Otherwise check if the item just added is currently in the removed items cache then re-add it to the queue it was removed from
	    elseIf WC.bEnableRemovedItemCaching && iEquip_RemovedItemsFLST.HasForm(formToAdd)
	    	WC.addBackCachedItem(formToAdd)
	    ;Or finally check if we've just added one of a currently equipped item which requires a counter update
		else
			j = 0
			int itemType = formToAdd.GetType()
			while j < 2
				if WC.asCurrentlyEquipped[j] == formToAdd.GetName()
					;Ammo, scrolls, torch or other throwing weapons
					;if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
					if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_FormExt.IsGrenade(formToAdd))	
		    			WC.setSlotCount(j, PlayerRef.GetItemCount(formToAdd))
		    		endIf
	        	endIf
	        	j += 1
	        endWhile
		endIf
		i += 1
	endWhile
	iEquip_ItemsToAddFLST.Revert()
	debug.trace("iEquip_AddedItemHandler OnUpdate - all added forms processed, iEquip_ItemsToAddFLST count: " + iEquip_ItemsToAddFLST.GetSize() + " (should be 0)")
endEvent

state DISABLED

	event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;Do nothing
	endEvent

endState
