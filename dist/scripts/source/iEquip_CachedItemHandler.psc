
Scriptname iEquip_CachedItemHandler extends ReferenceAlias

Import iEquip_AmmoExt
Import iEquip_WeaponExt
Import StringUtil

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_PlayerEventHandler Property EH Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef Auto

FormList Property iEquip_RemovedItemsFLST Auto

Event OnInit()
	debug.trace("iEquip_CachedItemHandler OnInit called")
	gotoState("DISABLED")
	OnPlayerLoadGame()
endEvent

function OniEquipEnabled(bool enabled)
	debug.trace("iEquip_CachedItemHandler OniEquipEnabled called")
	if enabled
		gotoState("")
	else
		gotoState("DISABLED")
	endIf
endFunction
	
Event OnPlayerLoadGame()
	debug.trace("iEquip_CachedItemHandler OnPlayerLoadGame called")
	if WC.isEnabled
		gotoState("")
	else
		gotoState("DISABLED")
	endIf
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	debug.trace("iEquip_CachedItemHandler OnItemAdded called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	;Handle Potions, Ammo and bound ammo first
	if akBaseItem as potion
		PO.onPotionAdded(akBaseItem)
	elseIf EH.boundSpellEquipped && iEquip_AmmoExt.IsAmmoBound(akBaseItem as ammo)
		AM.addBoundAmmoToQueue(akBaseItem, akBaseItem.GetName())
	elseIf AM.bAmmoMode && akBaseItem as ammo
		if AM.currentAmmoForm.GetName() == akBaseItem.GetName()
	    	AM.setSlotCount(PlayerRef.GetItemCount(akBaseItem))
        endIf
    ;Otherwise check if the item just added is currently in the removed items cache then re-add it to the queue it was removed from
    elseIf WC.bEnableRemovedItemCaching && iEquip_RemovedItemsFLST.HasForm(akBaseItem)
    	WC.addBackCachedItem(akBaseItem)
    ;Or finally check if we've just added one of a currently equipped item which requires a counter update
	else
		i = 0
		int itemType = akBaseItem.GetType()
		;string itemName = akBaseItem.GetName()
		while i < 2
			;if WC.asCurrentlyEquipped[i] == itemName
			if WC.asCurrentlyEquipped[i] == akBaseItem.GetName()
				;Ammo, scrolls, torch or other throwing weapons
				;if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
				if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_WeaponExt.IsWeaponGrenade(akBaseItem as Weapon))	
	    			WC.setSlotCount(i, PlayerRef.GetItemCount(akBaseItem))
	    		endIf
        	endIf
        	i += 1
        endWhile
	endIf
endEvent

state DISABLED

	event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;Do nothing
	endEvent

endState
