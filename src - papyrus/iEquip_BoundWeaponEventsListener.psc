Scriptname iEquip_BoundWeaponEventsListener extends Quest Hidden 

Import iEquip_FormExt

iEquip_WidgetCore Property WC Auto

bool property bIsBoundSpellEquipped = false auto

function OniEquipEnabled()
	iEquip_FormExt.RegisterForBoundWeaponEquippedEvent(Self)
	iEquip_FormExt.RegisterForBoundWeaponUnequippedEvent(Self)
EndFunction

function onGameLoaded()
	iEquip_FormExt.RegisterForBoundWeaponEquippedEvent(Self)
	iEquip_FormExt.RegisterForBoundWeaponUnequippedEvent(Self)
endFunction

Event OnBoundWeaponEquipped(Int a_weaponType, Int a_equipSlot)
	debug.trace("iEquip_BoundWeaponEventsListener OnBoundWeaponEquipped event received - weapon type: " + a_weaponType + ", slot: " + a_equipSlot)
	if bIsBoundSpellEquipped && a_equipSlot != 0
		int otherHand = 1
		bool equipBoth = a_equipSlot == 3 && (a_weaponType < 5 || a_weaponType == 8)
		if a_equipSlot == 2
			a_equipSlot = 0
		else
			a_equipSlot = 1
			otherHand = 0
		endIf
		WC.onBoundWeaponEquipped(a_weaponType, a_equipSlot)
		if equipBoth
			WC.onBoundWeaponEquipped(a_weaponType, otherHand)
		endIf
	endIf
EndEvent

Event OnBoundWeaponUnequipped(Weapon a_weap, Int a_unequipSlot)
	debug.trace("iEquip_BoundWeaponEventsListener OnBoundWeaponUnequipped event received - weapon: " + a_weap.GetName() + ", slot: " + a_unequipSlot)
	if bIsBoundSpellEquipped && a_unequipSlot != 0
		if a_unequipSlot == 2
			a_unequipSlot = 0
		else
			a_unequipSlot = 1
		endIf
		WC.onBoundWeaponUnequipped(a_weap, a_unequipSlot)
	endIf
EndEvent