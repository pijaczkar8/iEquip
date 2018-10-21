Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_Utility

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef Auto
bool Property poisonSlotEnabled = true Auto
bool isCrossbowEquipped = false
bool isBoundSpellEquipped = false
bool updateThrottle
int slotToUpdate = -1

Event OnInit()
	gotoState("DISABLED")
endEvent

function OniEquipEnabled(bool enabled)
	debug.trace("iEquip_PlayerEventHandler OniEquipEnabled called - Self.GetReference returns: " + Self.GetReference() + ", Game.GetPlayer returns: " + Game.GetPlayer())
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
		PO.onGameLoaded()
	else
		gotoState("DISABLED")
	endIf
endEvent

bool Property crossbowEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Get() called")
		return isCrossbowEquipped
	endFunction

	function Set(Bool equipped)
		isCrossbowEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler crossbowEquipped Set() called - isCrossbowEquipped: " + equipped)
		if isCrossbowEquipped
			RegisterForActorAction(6)
		else
			UnregisterForActorAction(6)
		endIf
	endFunction
endProperty

bool Property boundSpellEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get() called")
		return isBoundSpellEquipped
	endFunction

	function Set(Bool equipped)
		isBoundSpellEquipped = equipped
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set() called - isBoundSpellEquipped: " + equipped)
		if isBoundSpellEquipped
			RegisterForActorAction(2)
		else
			UnregisterForActorAction(2)
		endIf
	endFunction
endProperty

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	debug.trace("iEquip_PlayerEventHandler OnActorAction called - actionType: " + actionType + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 6
			WC.updateAmmoCounterOnCrossbowShot()
		elseIf actionType == 2
			Utility.Wait(0.2)
			WC.checkIfBoundWeaponEquipped(slot)
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
	If poisonSlotEnabled && !updateThrottle
		updateThrottle = true
		RegisterForSingleUpdate(0.8)
	EndIf
EndEvent

Event OnUpdate()
	debug.trace("iEquip_PlayerEventHandler OnUpdate called")
	updateThrottle = false
	if slotToUpdate == 0 || slotToUpdate == 1
		WC.checkAndUpdatePoisonInfo(slotToUpdate)
	else
		WC.checkAndUpdatePoisonInfo(0)
		WC.checkAndUpdatePoisonInfo(1)
	endIf
	slotToUpdate = -1
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  debug.trace("iEquip_PlayerEventHandler OnObjectEquipped called - akBaseObject: " + akBaseObject + " - " + akBaseObject.GetName())

endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemAdded called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	if akBaseItem as potion
		PO.onPotionAdded(akBaseItem)
	elseIf akBaseItem as ammo && isBoundSpellEquipped
		string ammoName = akBaseItem.GetName()
		if contains(ammoName, "ound")
			WC.addBoundAmmoToQueue(akBaseItem, ammoName)
		endIf
	endIf
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	if akBaseItem as potion
		PO.onPotionRemoved(akBaseItem)
	elseIf akBaseItem as weapon && contains(akBaseItem.GetName(), "ound")
		WC.onBoundWeaponUnequipped(akBaseItem.GetName())
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
