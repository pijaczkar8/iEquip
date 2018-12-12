
Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_AmmoExt
Import iEquip_WeaponExt
Import iEquip_FormExt
Import StringUtil
import AhzMoreHudIE

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_PotionScript Property PO Auto
iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_BoundWeaponEventsListener Property BW Auto
iEquip_CachedItemHandler Property CH Auto
iEquip_WidgetVisUpdateScript property WVis auto

Actor Property PlayerRef Auto

FormList Property iEquip_AllCurrentItemsFLST Auto
FormList Property iEquip_AmmoItemsFLST Auto
FormList Property iEquip_PotionItemsFLST Auto

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
	CH.OniEquipEnabled(enabled)
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
		RegisterForActorAction(7) ;Draw Begin - weapons only, not spells
		RegisterForActorAction(8) ;Draw End - weapons and spells
		RegisterForActorAction(10) ;Sheathe End - weapons and spells
		BW.OniEquipEnabled()
		updateAllEventFilters()
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
		RegisterForActorAction(7)
		RegisterForActorAction(8)
		RegisterForActorAction(10)
		BW.bIsBoundSpellEquipped = bIsBoundSpellEquipped
		BW.onGameLoaded()
		PO.onGameLoaded()
		updateAllEventFilters()
	else
		gotoState("DISABLED")
	endIf
endEvent

function updateAllEventFilters()
	debug.trace("iEquip_PlayerEventHandler updateAllEventFilters called")
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(iEquip_AllCurrentItemsFLST)
	AddInventoryEventFilter(iEquip_AmmoItemsFLST)
	AddInventoryEventFilter(iEquip_PotionItemsFLST)
endFunction

function updateEventFilter(formlist listToUpdate)
	debug.trace("iEquip_PlayerEventHandler updateEventFilter called - listToUpdate: " + listToUpdate.GetName())
	RemoveInventoryEventFilter(listToUpdate)
	AddInventoryEventFilter(listToUpdate)
endFunction

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
		;/if bWaitingForPlayerToDrawEnchantedWeapon
			RegisterForActorAction(8) ;Draw End
		else
			UnregisterForActorAction(8)
		endIf/;
	endFunction
endProperty

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	debug.trace("iEquip_PlayerEventHandler OnActorAction called - actionType: " + actionType + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 6 ;Bow Release
			AM.updateAmmoCounterOnCrossbowShot()
		elseIf actionType == 7 ;Draw Begin
			if !WC.bIsWidgetShown
				WC.updateWidgetVisibility()
			endIf
		elseIf actionType == 8 ;Draw End
			if !WC.bIsWidgetShown ;In case we're drawing a spell which won't have been caught by Draw Begin
				WC.updateWidgetVisibility()
			endIf
			if waitForEnchantedWeaponDrawn
				CM.updateChargeMetersOnWeaponsDrawn()
				waitForEnchantedWeaponDrawn = false
			endIf
		elseIf actionType == 10 && WC.bIsWidgetShown && WC.bWidgetFadeoutEnabled ;Sheathe End
			WVis.registerForWidgetFadeoutUpdate()
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

;This event handles auto-adding newly equipped items to the left, right and shout slots
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	debug.trace("iEquip_PlayerEventHandler OnObjectEquipped called")
	if WC.bAutoAddNewItems
		int equippedSlot = -1
		if PlayerRef.GetEquippedObject(0) == akBaseObject
			equippedSlot = 0
		elseIf PlayerRef.GetEquippedObject(1) == akBaseObject
			equippedSlot = 1
		elseIf PlayerRef.GetEquippedObject(2) == akBaseObject
			equippedSlot = 2
		endIf
		debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - akBaseObject: " + akBaseObject + " - " + akBaseObject.GetName() + ", equippedSlot: " + equippedSlot)
		;If the item has been equipped in the left, right or shout slot
		if equippedSlot != -1
			int itemType
			;If it's a 2H or ranged weapon we'll receive the event for slot 0 so we need to make sure we add it to the right hand queue instead
			if equippedSlot == 0 && akBaseObject as Weapon
				itemType = (akBaseObject as Weapon).GetWeaponType()
				debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - itemType: " + itemType)
				if (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
					equippedSlot = 1
				endIf
			endIf
			bool blockCall = false
			bool formFound = iEquip_AllCurrentItemsFLST.HasForm(akBaseObject)
			string itemName = akBaseObject.GetName()
			;Check if we've just manually equipped an item that is already in this iEquip queue
			int targetIndex = -1
			if formFound
				;If it's been found in the queue for the equippedSlot it's been equipped to
				targetIndex = WC.findInQueue(equippedSlot, itemName)
				if targetIndex != -1
					;If it's already shown in the widget do nothing
					if WC.aiCurrentQueuePosition[equippedSlot] == targetIndex
						blockCall = true
					;Otherwise update the position and name, then update the widget
					else
						WC.aiCurrentQueuePosition[equippedSlot] = targetIndex
						WC.asCurrentlyEquipped[equippedSlot] = itemName
						if equippedSlot < 2 || WC.bShoutEnabled
							WC.updateWidget(equippedSlot, targetIndex, false, true)
						endIf
					endIf
				endIf
			endIf
			debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - equippedSlot: " + equippedSlot + ", formFound: " + formFound + ", targetIndex: " + targetIndex + ", blockCall: " + blockCall)
			;If it isn't already contained in the AllCurrentItems formlist, or it is but findInQueue has returned -1 meaning it's a 1H item contained in the other hand queue
			if !formFound || targetIndex == -1
				;First check if the target Q has space or can grow organically - ie bHardLimitQueueSize is disabled
				bool freeSpace = true
				targetIndex = jArray.count(WC.aiTargetQ[equippedSlot])
				if targetIndex >= WC.iMaxQueueLength
					if WC.bHardLimitQueueSize
						freeSpace = false
						blockCall = true
					else
						WC.iMaxQueueLength += 1
					endIf
				endIf
				if freeSpace
					;If there is space in the target queue create a new jMap object and add it to the queue
					debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - freeSpace: " + freeSpace + ", equippedSlot: " + equippedSlot)
					int itemID = WC.createItemID(itemName, akBaseObject.GetFormID())
					itemType = akBaseObject.GetType()
					if itemType == 41 ;if it is a weapon get the weapon type
			        	itemType = (akBaseObject as Weapon).GetWeaponType()
			        endIf
					int iEquipItem = jMap.object()
					jMap.setForm(iEquipItem, "Form", akBaseObject)
					jMap.setInt(iEquipItem, "ID", itemID)
					jMap.setInt(iEquipItem, "Type", itemType)
					jMap.setStr(iEquipItem, "Name", itemName)
					jMap.setStr(iEquipItem, "Icon", WC.GetItemIconName(akBaseObject, itemType, itemName))
					if equippedSlot < 2
						jMap.setInt(iEquipItem, "isEnchanted", 0)
						jMap.setInt(iEquipItem, "isPoisoned", 0)
					endIf
					jArray.addObj(WC.aiTargetQ[equippedSlot], iEquipItem)
					;If it's not already in the AllItems formlist because it's in the other hand queue add it now
					if !formFound
						iEquip_AllCurrentItemsFLST.AddForm(akBaseObject)
						updateEventFilter(iEquip_AllCurrentItemsFLST)
					endIf
					;Send to moreHUD if loaded
					if WC.bMoreHUDLoaded
						if formFound
							AhzMoreHudIE.AddIconItem(itemID, WC.asMoreHUDIcons[3]) ;Both queues
						else
							AhzMoreHudIE.AddIconItem(itemID, WC.asMoreHUDIcons[equippedSlot])
						endIf
					endIf
					;Now update the widget to show the equipped item
					WC.aiCurrentQueuePosition[equippedSlot] = targetIndex
					WC.asCurrentlyEquipped[equippedSlot] = itemName
					if equippedSlot < 2 || WC.bShoutEnabled
						WC.updateWidget(equippedSlot, targetIndex, false, true)
					endIf
				endIf
			endIf
			;And run the rest of the hand equip cycle without actually equipping to toggle ammo mode if needed and update count, poison and charge info
			if !blockCall && equippedSlot < 2
				WC.checkAndEquipShownHandItem(equippedSlot, false, true)
			endIf
		endIf
	endIf
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved called - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	;Handle potions/consumales/poisons and ammo in AmmoMode first
	if akBaseItem as potion
		PO.onPotionRemoved(akBaseItem)
	elseIf AM.bAmmoMode && akBaseItem as ammo
		if AM.currentAmmoForm.GetName() == akBaseItem.GetName()
	    	AM.setSlotCount(PlayerRef.GetItemCount(akBaseItem))
        endIf
    ;Otherwise handle anything else in left, right or shout queue
	else
		i = 0
		int foundAt
		bool actionTaken = false
		while i < 3 && !actionTaken
			string itemName = akBaseItem.GetName()
			foundAt = WC.findInQueue(i, itemName)
			if foundAt != -1
				;If it's a shout or power remove it straight away
				if i == 2
					WC.removeItemFromQueue(i, foundAt)
					actionTaken = true
				else
					int otherHand = 1
					int itemType = akBaseItem.GetType()
					if i == 1
						otherHand = 0
					endIf
					;Check if it's contained in the other hand queue as well
					int foundAtOtherHand = WC.findInQueue(otherHand, itemName)
					int itemCount = PlayerRef.GetItemCount(akBaseItem)
					;If it's ammo, scrolls, torch or other throwing weapons which require a counter update
					;if itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb")))
					if WC.asCurrentlyEquipped[i] == itemName && itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_WeaponExt.IsWeaponGrenade(akBaseItem as Weapon)) && itemCount > 0
						WC.setSlotCount(i, itemCount)
						actionTaken = true
					;Otherwise check if we've removed the last of the currently equipped item, or if we're currently dual wielding it and only have one left make sure we remove the correct one
					elseIf (itemCount == 1 && foundAtOtherHand != -1 && PlayerRef.GetEquippedObject(i) != akBaseItem) || itemCount == 0
						WC.removeItemFromQueue(i, foundAt, false, false, true)
						;If the removed item was in both queues and we've got none left remove from the other queue as well
						if foundAtOtherHand != -1 && (itemCount == 0 || (itemCount == 1 && PlayerRef.GetEquippedObject(i) == akBaseItem))
							WC.removeItemFromQueue(otherHand, foundAtOtherHand)
						endIf
						actionTaken = true
		    		endIf
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

	event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	endEvent
endState
