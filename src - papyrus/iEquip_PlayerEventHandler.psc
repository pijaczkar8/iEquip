Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_AmmoExt
Import iEquip_WeaponExt
Import iEquip_FormExt
Import StringUtil

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_PotionScript Property PO Auto
iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_BoundWeaponEventsListener Property BW Auto

Actor Property PlayerRef Auto
bool Property poisonSlotEnabled = true Auto
bool isCrossbowEquipped = false
bool isBoundSpellEquipped = false
bool waitingForPlayerToDrawEnchantedWeapon = false
bool updateThrottle
int slotToUpdate = -1

Event OnInit()
	gotoState("DISABLED")
	OnPlayerLoadGame()
endEvent

function OniEquipEnabled(bool enabled)
	if enabled
		gotoState("")
		Utility.SetINIBool("bDisableGearedUp:General", True)
		WC.refreshVisibleItems()
		If MCM.bEnableGearedUp
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
		If MCM.bEnableGearedUp
			Utility.SetINIBool("bDisableGearedUp:General", False)
			WC.refreshVisibleItems()
		EndIf
		RegisterForAnimationEvent(PlayerRef, "weaponSwing")
		RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
		RegisterForAnimationEvent(PlayerRef, "arrowRelease")
		BW.isBoundSpellEquipped = isBoundSpellEquipped
		BW.onGameLoaded()
		PO.onGameLoaded()
	else
		gotoState("DISABLED")
	endIf
endEvent

bool Property crossbowEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Get called")
		return isCrossbowEquipped
	endFunction

	function Set(Bool equipped)
		isCrossbowEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Set called - isCrossbowEquipped: " + equipped)
		if isCrossbowEquipped
			RegisterForActorAction(6)
		else
			UnregisterForActorAction(6)
		endIf
	endFunction
endProperty

bool Property boundSpellEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get called")
		return isBoundSpellEquipped
	endFunction

	function Set(Bool equipped)
		isBoundSpellEquipped = equipped
		BW.isBoundSpellEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set called - isBoundSpellEquipped: " + equipped)
	endFunction
endProperty

bool Property waitForEnchantedWeaponDrawn
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler waitForEnchantedWeaponDrawn Get called")
		return waitingForPlayerToDrawEnchantedWeapon
	endFunction

	function Set(Bool waiting)
		waitingForPlayerToDrawEnchantedWeapon = waiting
		debug.trace("iEquip_PlayerEventHandler waitForEnchantedWeaponDrawn Set called - waitingForPlayerToDrawEnchantedWeapon: " + waiting)
		if waitingForPlayerToDrawEnchantedWeapon
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
			WC.updateAmmoCounterOnCrossbowShot()
		elseIf actionType == 8
			CM.updateChargeMetersOnWeaponsDrawn()
			waitForEnchantedWeaponDrawn = false
		endIf
	endIf
endEvent

Event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
	debug.trace("iEquip_PlayerEventHandler OnPlayerBowShot called")
	WC.updateAmmoCounterOnBowShot(akAmmo)
endEvent

Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	debug.trace("iEquip_PlayerEventHandler OnAnimationEvent received - EventName: " + EventName)
	if EventName == "weaponSwing" || EventName == "arrowRelease"
		if slotToUpdate == -1
			slotToUpdate = 1
		elseIf slotToUpdate == 0
			slotToUpdate = 2
		endIf
	elseIf EventName == "weaponLeftSwing"
		if slotToUpdate == -1
			slotToUpdate = 0
		elseIf slotToUpdate == 1
			slotToUpdate = 2
		endIf
	endIf
	If !updateThrottle
		updateThrottle = true
		RegisterForSingleUpdate(0.8)
	EndIf
EndEvent

Event OnUpdate()
	debug.trace("iEquip_PlayerEventHandler OnUpdate called")
	updateThrottle = false
	if slotToUpdate == 0 || slotToUpdate == 1
		If poisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(slotToUpdate)
		endIf
		if RC.bRechargingEnabled && CM.isChargeMeterShown[slotToUpdate]
			if CM.chargeDisplayType > 0
				CM.updateMeterPercent(slotToUpdate)
			endIf
		endIf
	else
		If poisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(0)
			WC.checkAndUpdatePoisonInfo(1)
		endIf
		if RC.bRechargingEnabled
			if CM.chargeDisplayType > 0
				if CM.isChargeMeterShown[0]
					CM.updateMeterPercent(0)
				endIf
				if CM.isChargeMeterShown[1]
					CM.updateMeterPercent(1)
				endIf
			endIf
		endIf
	endIf
	slotToUpdate = -1
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  debug.trace("iEquip_PlayerEventHandler OnObjectEquipped called - akBaseObject: " + akBaseObject + " - " + akBaseObject.GetName())

endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemAdded called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	if akBaseItem as potion
		PO.onPotionAdded(akBaseItem)
	elseIf isBoundSpellEquipped && iEquip_AmmoExt.IsAmmoBound(akBaseItem as ammo)
		WC.addBoundAmmoToQueue(akBaseItem, akBaseItem.GetName())
	elseIf WC.isAmmoMode && akBaseItem as ammo
		i = 5
		while i < 7
			if WC.isCurrentlyEquipped(i, akBaseItem.GetName())
	    		WC.setSlotCount(0, PlayerRef.GetItemCount(akBaseItem))
        	endIf
        	i += 1
        endWhile
	else
		i = 0
		int itemType = akBaseItem.GetType()
		string itemName = akBaseItem.GetName()
		while i < 2
			if WC.isCurrentlyEquipped(i,itemName)
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
	elseIf WC.isAmmoMode && akBaseItem as ammo
		i = 5
		while i < 7
			if WC.isCurrentlyEquipped(i, akBaseItem.GetName())
	    		WC.setSlotCount(0, PlayerRef.GetItemCount(akBaseItem))
        	endIf
        	i += 1
        endWhile
	else
		i = 0
		int itemType = akBaseItem.GetType()
		string itemName = akBaseItem.GetName()
		while i < 2
			if WC.isCurrentlyEquipped(i,itemName)
				;Ammo, scrolls, torch or other throwing weapons
				if (itemType == 42 && !WC.isAmmoMode) || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
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
