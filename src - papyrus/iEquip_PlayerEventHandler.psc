
Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_AmmoExt
Import iEquip_WeaponExt
Import iEquip_FormExt
Import StringUtil

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_MCM Property MCM Auto
iEquip_PotionScript Property PO Auto
iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_BoundWeaponEventsListener Property BW Auto

Actor Property PlayerRef Auto
bool Property bPoisonSlotEnabled = true Auto
bool bIsCrossbowEquipped = false
bool bIsBoundSpellEquipped = false
bool bWaitingForPlayerToDrawEnchantedWeapon = false
bool bUpdateThrottle
int iSlotToUpdate = -1

Event OnInit()
	gotoState("DISABLED")
	OnPlayerLoadGame()
endEvent

function OniEquipEnabled(bool enabled)
	if enabled
		gotoState("")
		Utility.SetINIBool("bDisableGearedUp:General", True)
		WC.refreshVisibleItems()
		If WC.bEnableGearedUp
			Utility.SetINIBool("bDisableGearedUp:General", False)
			WC.refreshVisibleItems()
		EndIf
		RegisterForAnimationEvent(PlayerRef, "weaponSwing")
		RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
		RegisterForAnimationEvent(PlayerRef, "arrowRelease")
		BW.OniEquipEnabled()
	else
		gotoState("DISABLED")
	endIf
endFunction
	
Event OnPlayerLoadGame()
	debug.trace("iEquip_PlayerEventHandler OnPlayerLoadGame called")
	if WC.isEnabled
		gotoState("")
		Utility.SetINIBool("bDisableGearedUp:General", True)
		WC.refreshVisibleItems()
		If WC.bEnableGearedUp
			Utility.SetINIBool("bDisableGearedUp:General", False)
			WC.refreshVisibleItems()
		EndIf
		RegisterForAnimationEvent(PlayerRef, "weaponSwing")
		RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
		RegisterForAnimationEvent(PlayerRef, "arrowRelease")
		BW.bIsBoundSpellEquipped = bIsBoundSpellEquipped
		BW.onGameLoaded()
		PO.onGameLoaded()
	else
		gotoState("DISABLED")
	endIf
endEvent

bool Property crossbowEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Get called")
		return bIsCrossbowEquipped
	endFunction

	function Set(Bool equipped)
		bIsCrossbowEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Set called - bIsCrossbowEquipped: " + equipped)
		if bIsCrossbowEquipped
			RegisterForActorAction(6)
		else
			UnregisterForActorAction(6)
		endIf
	endFunction
endProperty

bool Property boundSpellEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get called")
		return bIsBoundSpellEquipped
	endFunction

	function Set(Bool equipped)
		bIsBoundSpellEquipped = equipped
		BW.bIsBoundSpellEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set called - bIsBoundSpellEquipped: " + equipped)
	endFunction
endProperty

bool Property waitForEnchantedWeaponDrawn
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler waitForEnchantedWeaponDrawn Get called")
		return bWaitingForPlayerToDrawEnchantedWeapon
	endFunction

	function Set(Bool waiting)
		bWaitingForPlayerToDrawEnchantedWeapon = waiting
		debug.trace("iEquip_PlayerEventHandler waitForEnchantedWeaponDrawn Set called - bWaitingForPlayerToDrawEnchantedWeapon: " + waiting)
		if bWaitingForPlayerToDrawEnchantedWeapon
			RegisterForActorAction(8) ;Draw End
		else
			UnregisterForActorAction(8)
		endIf
	endFunction
endProperty


Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	debug.trace("iEquip_PlayerEventHandler OnActorAction called - actionType: " + actionType + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 6
			AM.updateAmmoCounterOnCrossbowShot()
		elseIf actionType == 8
			CM.updateChargeMetersOnWeaponsDrawn()
			waitForEnchantedWeaponDrawn = false
		endIf
	endIf
endEvent

Event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
	debug.trace("iEquip_PlayerEventHandler OnPlayerBowShot called")
	AM.updateAmmoCounterOnBowShot(akAmmo)
endEvent

Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	debug.trace("iEquip_PlayerEventHandler OnAnimationEvent received - EventName: " + EventName)
	if EventName == "weaponSwing" || EventName == "arrowRelease"
		if iSlotToUpdate == -1
			iSlotToUpdate = 1
		elseIf iSlotToUpdate == 0
			iSlotToUpdate = 2
		endIf
	elseIf EventName == "weaponLeftSwing"
		if iSlotToUpdate == -1
			iSlotToUpdate = 0
		elseIf iSlotToUpdate == 1
			iSlotToUpdate = 2
		endIf
	endIf
	If !bUpdateThrottle
		bUpdateThrottle = true
		RegisterForSingleUpdate(0.8)
	EndIf
EndEvent

Event OnUpdate()
	debug.trace("iEquip_PlayerEventHandler OnUpdate called")
	bUpdateThrottle = false
	if iSlotToUpdate == 0 || iSlotToUpdate == 1
		If bPoisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(iSlotToUpdate)
		endIf
		if RC.bRechargingEnabled && CM.abIsChargeMeterShown[iSlotToUpdate]
			if CM.iChargeDisplayType > 0
				CM.updateMeterPercent(iSlotToUpdate)
			endIf
		endIf
	else
		If bPoisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(0)
			WC.checkAndUpdatePoisonInfo(1)
		endIf
		if RC.bRechargingEnabled
			if CM.iChargeDisplayType > 0
				if CM.abIsChargeMeterShown[0]
					CM.updateMeterPercent(0)
				endIf
				if CM.abIsChargeMeterShown[1]
					CM.updateMeterPercent(1)
				endIf
			endIf
		endIf
	endIf
	iSlotToUpdate = -1
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  debug.trace("iEquip_PlayerEventHandler OnObjectEquipped called - akBaseObject: " + akBaseObject + " - " + akBaseObject.GetName())

endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemAdded called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	if akBaseItem as potion
		PO.onPotionAdded(akBaseItem)
	elseIf bIsBoundSpellEquipped && iEquip_AmmoExt.IsAmmoBound(akBaseItem as ammo)
		AM.addBoundAmmoToQueue(akBaseItem, akBaseItem.GetName())
	elseIf AM.bAmmoMode && akBaseItem as ammo
		if AM.currentAmmoForm.GetName() == akBaseItem.GetName()
	    	AM.setSlotCount(PlayerRef.GetItemCount(akBaseItem))
        endIf
	else
		i = 0
		int itemType = akBaseItem.GetType()
		string itemName = akBaseItem.GetName()
		while i < 2
			if WC.asCurrentlyEquipped[i] == itemName
				;Ammo, scrolls, torch or other throwing weapons
				if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
	    			WC.setSlotCount(i, PlayerRef.GetItemCount(akBaseItem))
	    		endIf
        	endIf
        	i += 1
        endWhile
	endIf
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	if akBaseItem as potion
		PO.onPotionRemoved(akBaseItem)
	elseIf AM.bAmmoMode && akBaseItem as ammo
		if AM.currentAmmoForm.GetName() == akBaseItem.GetName()
	    	AM.setSlotCount(PlayerRef.GetItemCount(akBaseItem))
        endIf
	else
		i = 0
		int itemType = akBaseItem.GetType()
		string itemName = akBaseItem.GetName()
		while i < 2
			if WC.asCurrentlyEquipped[i] == itemName
				;Ammo, scrolls, torch or other throwing weapons
				if (itemType == 42 && !WC.bAmmoMode) || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
	    			WC.setSlotCount(i, PlayerRef.GetItemCount(akBaseItem))
	    		endIf
        	endIf
        	i += 1
        endWhile
	endIf
endEvent

state DISABLED	
	event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	endEvent
	
	event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
	endEvent

	event OnAnimationEvent(ObjectReference aktarg, string EventName)
	endEvent

	event OnUpdate()
	endEvent

	event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	endEvent

	event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	endEvent

	event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	endEvent
endState
