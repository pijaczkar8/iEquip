
Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_FormExt
Import Utility
import AhzMoreHudIE

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_BeastMode Property BM Auto
iEquip_KeyHandler Property KH Auto
iEquip_PotionScript Property PO Auto
iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_BoundWeaponEventsListener Property BW Auto
iEquip_WidgetVisUpdateScript property WVis auto

Actor Property PlayerRef Auto
Race property PlayerRace auto hidden

; Werewolf reference - Vanilla - populated in CK
race property WerewolfBeastRace auto
; Vampire Lord reference - Dawnguard - populated in OnInit or OnPlayerLoadGame
race property DLC1VampireBeastRace auto hidden
; Lich reference - Undeath - populated in OnInit or OnPlayerLoadGame
race property NecroLichRace auto hidden

FormList property iEquip_AllCurrentItemsFLST Auto
FormList property iEquip_AmmoItemsFLST Auto
FormList property iEquip_PotionItemsFLST Auto

FormList Property iEquip_OnObjectEquippedFLST Auto

bool property bPoisonSlotEnabled = true auto hidden
bool bIsBoundSpellEquipped = false
bool property bWaitingForEnchantedWeaponDrawn = false auto hidden
bool bWaitingForAnimationUpdate = false
bool bWaitingForOnObjectEquippedUpdate = false
bool processingQueuedForms = false

bool property bIsThunderchildLoaded = false auto hidden
bool property bIsWintersunLoaded = false auto hidden
bool property bIsDawnguardLoaded = false auto hidden
bool property bIsUndeathLoaded = false auto hidden
bool property bPlayerIsMeditating = false auto hidden
bool property bDualCasting = false auto hidden
int dualCastCounter = 0

bool property bPlayerIsABeast = false auto hidden

int iSlotToUpdate = -1
int[] itemTypesToProcess

Event OnInit()
	debug.trace("iEquip_PlayerEventHandler OnInit start")
    PlayerRace = PlayerRef.GetRace()
    bPlayerIsABeast = (BM.arBeastRaces.Find(PlayerRace) > -1)
    itemTypesToProcess = new int[6]
	itemTypesToProcess[0] = 22 ;Spells or shouts
	itemTypesToProcess[1] = 23 ;Scrolls
	itemTypesToProcess[2] = 31 ;Torches
	itemTypesToProcess[3] = 41 ;Weapons
	itemTypesToProcess[4] = 42 ;Ammo
	itemTypesToProcess[5] = 119 ;Powers
	debug.trace("iEquip_PlayerEventHandler OnInit end")
endEvent

Event OnPlayerLoadGame()
	debug.trace("iEquip_PlayerEventHandler OnPlayerLoadGame start")	
	initialise(WC.isEnabled)
	debug.trace("iEquip_PlayerEventHandler OnPlayerLoadGame end")
endEvent

function initialise(bool enabled)
	debug.trace("iEquip_PlayerEventHandler initialise start")	
	if enabled
		gotoState("")
		Utility.SetINIBool("bDisableGearedUp:General", True)
		WC.refreshVisibleItems()
		If WC.bEnableGearedUp
			Utility.SetINIBool("bDisableGearedUp:General", False)
			WC.refreshVisibleItems()
		EndIf
		if bIsThunderchildLoaded || bIsWintersunLoaded
			RegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
			RegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
			;RegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnter") ;ToDo - correct animation event names need to be added here!
			;RegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnterInstant")
			;RegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateExit")
		endIf
		RegisterForAnimationEvent(PlayerRef, "weaponSwing")
		RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
		RegisterForAnimationEvent(PlayerRef, "arrowRelease")
		RegisterForActorAction(7) ;Draw Begin - weapons only, not spells
		RegisterForActorAction(8) ;Draw End - weapons and spells
		RegisterForActorAction(10) ;Sheathe End - weapons and spells
		BW.initialise()
		PO.initialise()
		updateAllEventFilters()
	else
		gotoState("DISABLED")
	endIf
	debug.trace("iEquip_PlayerEventHandler initialise end")
endFunction

bool Property boundSpellEquipped
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get start")
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Get end")
		return bIsBoundSpellEquipped
	endFunction

	function Set(Bool equipped)
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set start")	
		bIsBoundSpellEquipped = equipped
		BW.bIsBoundSpellEquipped = equipped
		if bIsBoundSpellEquipped
			RegisterForActorAction(2) ;Spell fire
		else
			UnregisterForActorAction(2)
		endIf
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set called - bIsBoundSpellEquipped: " + equipped)
		debug.trace("iEquip_PlayerEventHandler boundSpellEquipped Set end")
	endFunction
endProperty

bool property bJustQuickDualCast
	bool function Get()
		debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Get start")
		debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Get end")
		return bDualCasting
	endFunction

	function set(bool dualCasting)
		debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Set start")	
		bDualCasting = dualCasting
		if dualCasting
			dualCastCounter = 2
		else
			dualCastCounter = 0
		endIf
		debug.trace("iEquip_PlayerEventHandler bJustQuickDualCast Set end")
	endFunction
endProperty

function updateAllEventFilters()
	debug.trace("iEquip_PlayerEventHandler updateAllEventFilters start")
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(iEquip_AllCurrentItemsFLST)
	AddInventoryEventFilter(iEquip_AmmoItemsFLST)
	AddInventoryEventFilter(iEquip_PotionItemsFLST)
	debug.trace("iEquip_PlayerEventHandler updateAllEventFilters end")
endFunction

function updateEventFilter(formlist listToUpdate)
	debug.trace("iEquip_PlayerEventHandler updateEventFilter start")
	RemoveInventoryEventFilter(listToUpdate)
	AddInventoryEventFilter(listToUpdate)
	debug.trace("iEquip_PlayerEventHandler updateEventFilter end")
endFunction

Event OnRaceSwitchComplete()
	debug.trace("iEquip_WidgetCore OnRaceSwitchComplete start")
	if UI.IsMenuOpen("RaceSex Menu")
		PlayerRace = PlayerRef.GetRace()
	else
		race newRace = PlayerRef.GetRace()
		if WC.isEnabled && WC.bEnableGearedUp
			Utility.SetINIbool("bDisableGearedUp:General", !(newRace == PlayerRace))
			WC.refreshVisibleItems()
		endIf
		if PlayerRace != newRace
			PlayerRace = newRace
			if bPlayerIsABeast || PlayerRace == WerewolfBeastRace || (bIsDawnguardLoaded && PlayerRace == DLC1VampireBeastRace) || (bIsUndeathLoaded && PlayerRace == NecroLichRace)
				bPlayerIsABeast = (BM.arBeastRaces.Find(PlayerRace) > -1)
				if WC.isEnabled
					BM.onPlayerTransform(PlayerRace)
				endIf
			endIf
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete end")
EndEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	debug.trace("iEquip_PlayerEventHandler OnActorAction start")	
	debug.trace("iEquip_PlayerEventHandler OnActorAction - actionType: " + actionType + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 2 ;Spell Fire, only received if bound spell equipped, and we're only looking for bound shield here, weapons are handled in BoundWeaponEventsListener
			Utility.WaitMenuMode(0.3)
			if PlayerRef.GetEquippedShield() && PlayerRef.GetEquippedShield().GetName() == WC.asCurrentlyEquipped[0]
				WC.onBoundWeaponEquipped(26, 0)
				iEquip_AllCurrentItemsFLST.AddForm(PlayerRef.GetEquippedShield() as form)
				updateEventFilter(iEquip_AllCurrentItemsFLST)
			endIf
		elseIf actionType == 7 ;Draw Begin
			if !WC.bIsWidgetShown
				WC.updateWidgetVisibility()
			endIf
		elseIf actionType == 8 ;Draw End
			if !WC.bIsWidgetShown ;In case we're drawing a spell which won't have been caught by Draw Begin
				WC.updateWidgetVisibility()
			endIf
			if bWaitingForEnchantedWeaponDrawn
				CM.updateChargeMetersOnWeaponsDrawn()
				bWaitingForEnchantedWeaponDrawn = false
			endIf
		elseIf actionType == 10 && WC.bIsWidgetShown && WC.bWidgetFadeoutEnabled ;Sheathe End
			WVis.registerForWidgetFadeoutUpdate()
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnActorAction end")
endEvent

Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	debug.trace("iEquip_PlayerEventHandler OnAnimationEvent start")	
    debug.trace("iEquip_PlayerEventHandler OnAnimationEvent received - EventName: " + EventName)
    ;ToDo - update meditation animation event names
    ;if (EventName == "IdleGreybeardMeditateEnter" || EventName == "IdleGreybeardMeditateEnterInstant") && (PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x06CAED, "Thunderchild - Epic Shout Package.esp") as MagicEffect) || PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x023dd5, "Wintersun - Faiths of Skyrim.esp") as MagicEffect))
    if (EventName == "IdleChairSitting") && (PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x06CAED, "Thunderchild - Epic Shout Package.esp") as MagicEffect) || PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x023dd5, "Wintersun - Faiths of Skyrim.esp") as MagicEffect))
    	bPlayerIsMeditating = true
    	debug.trace("Look Ma, I'm meditating!")
    	KH.bAllowKeyPress = false
    elseIf bPlayerIsMeditating && EventName == "idleChairGetUp"
    	bPlayerIsMeditating = false
    	debug.trace("OK Ma, I'm done meditating!")
    	KH.bAllowKeyPress = true
    else
	    int iTmp = 2 
	    if EventName == "weaponLeftSwing"
	        iTmp = 1
	    endIf    
	    if (iSlotToUpdate == -1 || (iSlotToUpdate + iTmp == 2))
	        iSlotToUpdate += iTmp
	        if !bWaitingForAnimationUpdate
	            bWaitingForAnimationUpdate = true
	            RegisterForSingleUpdate(0.8)
	        endIf
	    endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnAnimationEvent end")
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	debug.trace("iEquip_PlayerEventHandler OnObjectEquipped start")	
	debug.trace("iEquip_PlayerEventHandler OnObjectEquipped - just equipped " + akBaseObject.GetName() + ", WC.bAddingItemsOnFirstEnable: " + WC.bAddingItemsOnFirstEnable + ", processingQueuedForms: " + processingQueuedForms + ", bJustQuickDualCast: " + bJustQuickDualCast)
	if !WC.bAddingItemsOnFirstEnable && !processingQueuedForms
		if akBaseObject as spell && bDualCasting
			dualCastCounter -=1
			if dualCastCounter == 0
				bDualCasting = false
			endIf
		else
			int itemType = akBaseObject.GetType()
			if itemTypesToProcess.Find(itemType) > -1 || (itemType == 26 && (akBaseObject as Armor).GetSlotMask() == 512)
				bWaitingForOnObjectEquippedUpdate = true
				iEquip_OnObjectEquippedFLST.AddForm(akBaseObject)
				registerForSingleUpdate(0.5)
			endIf
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnObjectEquipped end")
endEvent

Event OnUpdate()
	debug.trace("iEquip_PlayerEventHandler OnUpdate start")	
	debug.trace("iEquip_PlayerEventHandler OnUpdate - bWaitingForAnimationUpdate: " + bWaitingForAnimationUpdate + ", bWaitingForOnObjectEquippedUpdate: " + bWaitingForOnObjectEquippedUpdate)
	if bWaitingForAnimationUpdate
		bWaitingForAnimationUpdate = false
		updateWidgetOnWeaponSwing()
	endIf
	if bWaitingForOnObjectEquippedUpdate
		bWaitingForOnObjectEquippedUpdate = false
		processQueuedForms()
	endIf
	debug.trace("iEquip_PlayerEventHandler OnUpdate end")	
EndEvent

function updateWidgetOnWeaponSwing()
	debug.trace("iEquip_PlayerEventHandler updateWidgetOnWeaponSwing start")
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
	debug.trace("iEquip_PlayerEventHandler updateWidgetOnWeaponSwing end")
endFunction

;This event handles auto-adding newly equipped items to the left, right and shout slots
function processQueuedForms()
	debug.trace("iEquip_PlayerEventHandler processQueuedForms start")	
	debug.trace("iEquip_PlayerEventHandler processQueuedForms - number of forms to process: " + iEquip_OnObjectEquippedFLST.GetSize())
	processingQueuedForms = true
	int i = 0
	form queuedForm
	while i < iEquip_OnObjectEquippedFLST.GetSize()
		queuedForm = iEquip_OnObjectEquippedFLST.GetAt(i)
		debug.trace("iEquip_PlayerEventHandler processQueuedForms - i: " + i + ", queuedForm: " + queuedForm + " - " + queuedForm.GetName())
		;Check the item is still equipped, and if it is in the left, right or shout slots which is all we're interested in here. Blocked if equipped item is a bound weapon or an item from Throwing Weapons Lite (to avoid weirdness...)
		if !(iEquip_WeaponExt.IsWeaponBound(queuedForm as weapon)) && !(Game.GetModName(queuedForm.GetFormID() / 0x1000000) == "JZBai_ThrowingWpnsLite.esp") && !(Game.GetModName(queuedForm.GetFormID() / 0x1000000) == "Bound Shield.esp")
			int equippedSlot = -1
			if PlayerRef.GetEquippedObject(0) == queuedForm
				equippedSlot = 0
			elseIf PlayerRef.GetEquippedObject(1) == queuedForm
				equippedSlot = 1
			elseIf PlayerRef.GetEquippedObject(2) == queuedForm
				equippedSlot = 2
			endIf
			;If the item has been equipped in the left, right or shout slot
			if equippedSlot != -1
				debug.trace("iEquip_PlayerEventHandler processQueuedForms - " + queuedForm.GetName() + " found in equippedSlot: " + equippedSlot)
				int itemType = queuedForm.GetType()
				int iEquipSlot
				;If it's a 2H or ranged weapon or a BothHands spell we'll receive the event for slot 0 so we need to make sure we add it to the right hand queue instead
				if itemType == 22
					iEquipSlot = WC.EquipSlots.Find((queuedForm as spell).GetEquipType())
				elseIf itemType == 41
					itemType = (queuedForm as Weapon).GetWeaponType()
				endIf
				if (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9 || (itemType == 22 && iEquipSlot == 3))
					equippedSlot = 1
				endIf
				bool actionTaken = false
				int targetIndex
				bool blockCall = false
				bool formFound = iEquip_AllCurrentItemsFLST.HasForm(queuedForm)
				string itemName = queuedForm.GetName()
				;Check if we've just manually equipped an item that is already in an iEquip queue
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
						actionTaken = true
					endIf
				endIf
				debug.trace("iEquip_PlayerEventHandler processQueuedForms - equippedSlot: " + equippedSlot + ", formFound: " + formFound + ", targetIndex: " + targetIndex + ", blockCall: " + blockCall)
				;If it isn't already contained in the AllCurrentItems formlist, or it is but findInQueue has returned -1 meaning it's a 1H item contained in the other hand queue
				if !actionTaken && WC.bAutoAddNewItems
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
						debug.trace("iEquip_PlayerEventHandler processQueuedForms - freeSpace: " + freeSpace + ", equippedSlot: " + equippedSlot)
						int itemID = WC.createItemID(itemName, queuedForm.GetFormID())
						int iEquipItem = jMap.object()
						string itemIcon = WC.GetItemIconName(queuedForm, itemType, itemName)
						jMap.setForm(iEquipItem, "iEquipForm", queuedForm)
						jMap.setInt(iEquipItem, "iEquipItemID", itemID)
						jMap.setInt(iEquipItem, "iEquipType", itemType)
						jMap.setStr(iEquipItem, "iEquipName", itemName)
						jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
						if equippedSlot < 2
							if itemType == 22
								if itemIcon == "DestructionFire" || itemIcon == "DestructionFrost" || itemIcon == "DestructionShock"
									jMap.setStr(iEquipItem, "iEquipSchool", "Destruction")
								else
									jMap.setStr(iEquipItem, "iEquipSchool", itemIcon)
								endIf
								jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
							endIf
							;These will be set correctly by WC.CycleHand() and associated functions
							jMap.setInt(iEquipItem, "isEnchanted", 0)
							jMap.setInt(iEquipItem, "isPoisoned", 0)
						endIf
						jArray.addObj(WC.aiTargetQ[equippedSlot], iEquipItem)
						;If it's not already in the AllItems formlist because it's in the other hand queue add it now
						if !formFound
							iEquip_AllCurrentItemsFLST.AddForm(queuedForm)
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
		i += 1
	endWhile
	iEquip_OnObjectEquippedFLST.Revert()
	debug.trace("iEquip_PlayerEventHandler processQueuedForms - all added forms processed, iEquip_OnObjectEquippedFLST count: " + iEquip_OnObjectEquippedFLST.GetSize() + " (should be 0)")
	processingQueuedForms = false
	debug.trace("iEquip_PlayerEventHandler processQueuedForms end")
endFunction

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved start")	
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved - akBaseItem: " + akBaseItem + " - " + akBaseItem.GetName() + ", aiItemCount: " + aiItemCount + ", akItemReference: " + akItemReference)
	int i
	;Handle potions/consumales/poisons and ammo in AmmoMode first
	if akBaseItem as potion
		PO.onPotionRemoved(akBaseItem)
	elseIf akBaseItem as ammo
		AM.onAmmoRemoved(akBaseItem)
	;Check if a Bound Shield has just been unequipped
	elseIf (akBaseItem.GetType() == 26) && (akBaseItem.GetName() == WC.asCurrentlyEquipped[0]) && (jMap.getInt(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipType") == 22)
		WC.onBoundWeaponUnequipped(0, true)
		iEquip_AllCurrentItemsFLST.RemoveAddedForm(akBaseItem)
		updateEventFilter(iEquip_AllCurrentItemsFLST)
    ;Otherwise handle anything else in left, right or shout queue other than bound weapons
	elseIf !((akBaseItem as weapon) && iEquip_WeaponExt.IsWeaponBound(akBaseItem as weapon))
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
					if WC.asCurrentlyEquipped[i] == itemName && (itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_FormExt.IsGrenade(akBaseItem)) && itemCount > 0)
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
	debug.trace("iEquip_PlayerEventHandler OnItemRemoved end")
endEvent

auto state DISABLED
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
