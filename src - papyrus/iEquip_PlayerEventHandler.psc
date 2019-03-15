
Scriptname iEquip_PlayerEventHandler extends ReferenceAlias

Import iEquip_FormExt
import iEquip_ActorExt
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

Race PlayerBaseRace

Race Property ArgonianRace auto
Race Property ArgonianRaceVampire auto
Race Property BretonRace auto
Race Property BretonRaceVampire auto
Race Property DarkElfRace auto
Race Property DarkElfRaceVampire auto
Race Property HighElfRace auto
Race Property HighElfRaceVampire auto
Race Property ImperialRace auto
Race Property ImperialRaceVampire auto
Race Property KhajiitRace auto
Race Property KhajiitRaceVampire auto
Race Property NordRace auto
Race Property NordRaceVampire auto
Race Property OrcRace auto
Race Property OrcRaceVampire auto
Race Property RedguardRace auto
Race Property RedguardRaceVampire auto
Race Property WoodElfRace auto
Race Property WoodElfRaceVampire auto

Race[] Property aPlayerBaseRaces auto Hidden
Race[] Property aPlayerBaseVampireRaces auto Hidden

bool bPlayerRaceConfirmed

; Werewolf reference - Vanilla - populated in CK
race property WerewolfBeastRace auto
; Vampire Lord reference - Dawnguard - populated in OnInit or OnPlayerLoadGame
race property DLC1VampireBeastRace auto hidden
; Lich reference - Undeath - populated in OnInit or OnPlayerLoadGame
race property NecroLichRace auto hidden

FormList property iEquip_AllCurrentItemsFLST Auto
FormList property iEquip_AmmoItemsFLST Auto
FormList property iEquip_PotionItemsFLST Auto

Formlist[] property blackListFLSTs auto hidden

Formlist Property iEquip_LeftHandBlacklistFLST Auto
Formlist Property iEquip_RightHandBlacklistFLST Auto
Formlist Property iEquip_GeneralBlacklistFLST Auto ;Shout, Consumable and Poison Queues

FormList Property iEquip_OnObjectEquippedFLST Auto

bool property bPoisonSlotEnabled = true auto hidden
bool bIsBoundSpellEquipped
bool property bWaitingForEnchantedWeaponDrawn auto hidden
bool bWaitingForAnimationUpdate
bool bWaitingForOnObjectEquippedUpdate
bool processingQueuedForms

bool property bIsThunderchildLoaded auto hidden
bool property bIsWintersunLoaded auto hidden
bool property bIsDawnguardLoaded auto hidden
bool property bIsUndeathLoaded auto hidden
bool property bPlayerIsMeditating auto hidden
bool property bDualCasting auto hidden
bool property bGoingUnarmed auto hidden
int dualCastCounter

bool property bAutoAddNewItems = true auto hidden
bool property bAutoAddShouts = true auto hidden
bool property bAutoAddPowers = true auto hidden

bool property bPlayerIsABeast auto hidden
bool property bPlayerIsAVampire auto hidden
bool property bWaitingForTransform auto hidden

int iSlotToUpdate = -1
int[] itemTypesToProcess

Event OnInit()
	debug.trace("iEquip_PlayerEventHandler OnInit start")
    
    aPlayerBaseRaces = new race [10]
    aPlayerBaseRaces[0] = ArgonianRace
    aPlayerBaseRaces[1] = BretonRace
    aPlayerBaseRaces[2] = DarkElfRace
    aPlayerBaseRaces[3] = HighElfRace
    aPlayerBaseRaces[4] = ImperialRace
    aPlayerBaseRaces[5] = KhajiitRace
    aPlayerBaseRaces[6] = NordRace
    aPlayerBaseRaces[7] = OrcRace
    aPlayerBaseRaces[8] = RedguardRace
    aPlayerBaseRaces[9] = WoodElfRace

    aPlayerBaseVampireRaces = new race [10]
    aPlayerBaseVampireRaces[0] = ArgonianRaceVampire
    aPlayerBaseVampireRaces[1] = BretonRaceVampire
    aPlayerBaseVampireRaces[2] = DarkElfRaceVampire
    aPlayerBaseVampireRaces[3] = HighElfRaceVampire
    aPlayerBaseVampireRaces[4] = ImperialRaceVampire
    aPlayerBaseVampireRaces[5] = KhajiitRaceVampire
    aPlayerBaseVampireRaces[6] = NordRaceVampire
    aPlayerBaseVampireRaces[7] = OrcRaceVampire
    aPlayerBaseVampireRaces[8] = RedguardRaceVampire
    aPlayerBaseVampireRaces[9] = WoodElfRaceVampire

    itemTypesToProcess = new int[6]
	itemTypesToProcess[0] = 22 ;Spells or shouts
	itemTypesToProcess[1] = 23 ;Scrolls
	itemTypesToProcess[2] = 31 ;Torches
	itemTypesToProcess[3] = 41 ;Weapons
	itemTypesToProcess[4] = 42 ;Ammo
	itemTypesToProcess[5] = 119 ;Powers

	blackListFLSTs = new formlist[3]
	blackListFLSTs[0] = iEquip_LeftHandBlacklistFLST
	blackListFLSTs[1] = iEquip_RightHandBlacklistFLST
	blackListFLSTs[2] = iEquip_GeneralBlacklistFLST

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
		PlayerRace = PlayerRef.GetRace()
		PlayerBaseRace = iEquip_ActorExt.GetBaseRace(PlayerRef)
		BM.initialise()
		BM.PlayerBaseRace = PlayerBaseRace
		bPlayerIsABeast = (BM.arBeastRaces.Find(PlayerRace) > -1)
		debug.trace("iEquip_PlayerEventHandler initialise - current PlayerRace: " + PlayerRace.GetName() + ", original race: " + PlayerBaseRace.GetName() + ", bPlayerIsABeast: " + bPlayerIsABeast)
		Utility.SetINIBool("bDisableGearedUp:General", True)
		WC.refreshVisibleItems()
		If WC.bEnableGearedUp
			Utility.SetINIBool("bDisableGearedUp:General", False)
			WC.refreshVisibleItems()
		EndIf
		if bPlayerIsABeast
			registerForBMEvents()
		elseIf PlayerRace == PlayerBaseRace || aPlayerBaseVampireRaces.Find(PlayerRace) == aPlayerBaseRaces.Find(PlayerBaseRace) ;Use this once ActorExt function is fixed
			registerForCoreAnimationEvents()
			registerForCoreActorActions()
		endIf
		BW.initialise()
		PO.initialise()
		updateAllEventFilters()
	else
		gotoState("DISABLED")
		UnregisterForAllEvents()
	endIf
	debug.trace("iEquip_PlayerEventHandler initialise end")
endFunction

function registerForCoreAnimationEvents()
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
	RegisterForAnimationEvent(PlayerRef, "bashStop")
	;Listeners for the beast form transformation sAttributes
	RegisterForAnimationEvent(PlayerRef, "SetRace")
	RegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
	RegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	RegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	RegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	RegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
endFunction

function registerForCoreActorActions()
	;RegisterForActorAction(1) ;Spell cast - spells and staves
	RegisterForActorAction(2) ;Spell fire - spells and staves
	RegisterForActorAction(7) ;Draw Begin - weapons only, not spells
	RegisterForActorAction(8) ;Draw End - weapons and spells
	RegisterForActorAction(10) ;Sheathe End - weapons and spells
endFunction

function unregisterForCoreAnimationEvents()
	if bIsThunderchildLoaded || bIsWintersunLoaded
		UnRegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
		UnRegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnter") ;ToDo - correct animation event names need to be added here!
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnterInstant")
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateExit")
	endIf
	UnRegisterForAnimationEvent(PlayerRef, "weaponSwing")
	UnRegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	UnRegisterForAnimationEvent(PlayerRef, "arrowRelease")
	UnRegisterForAnimationEvent(PlayerRef, "bashStop")
	;Listeners for the beast form transformation sAttributes
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
endFunction

; Register for all of the animation events we care about for beast mode
Function registerForBMEvents()
	RegisterForAnimationEvent(PlayerRef, "SetRace")
    RegisterForAnimationEvent(PlayerRef, "GroundStart")
    RegisterForAnimationEvent(PlayerRef, "LevitateStart")
    RegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    RegisterForAnimationEvent(PlayerRef, "LandStart")
    RegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
    RegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
    RegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	RegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	RegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	RegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
EndFunction

; Unregister for the beast mode animation events we registered for.
Function unregisterForBMEvents()
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
   	UnRegisterForAnimationEvent(PlayerRef, "GroundStart")
   	UnRegisterForAnimationEvent(PlayerRef, "LevitateStart")
    UnRegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    UnRegisterForAnimationEvent(PlayerRef, "LandStart")
   	UnRegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
   	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
   	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
EndFunction

function unregisterForAllEvents()
	;Core animation events
	if bIsThunderchildLoaded || bIsWintersunLoaded
		UnRegisterForAnimationEvent(PlayerRef, "IdleChairSitting")
		UnRegisterForAnimationEvent(PlayerRef, "idleChairGetUp")
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnter") ;ToDo - correct animation event names need to be added here!
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnterInstant")
		;UnRegisterForAnimationEvent(PlayerRef, "IdleGreybeardMeditateExit")
	endIf
	UnRegisterForAnimationEvent(PlayerRef, "weaponSwing")
	UnRegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	UnRegisterForAnimationEvent(PlayerRef, "arrowRelease")
	UnRegisterForAnimationEvent(PlayerRef, "bashStop")
	;Beast Mode animation events
	UnRegisterForAnimationEvent(PlayerRef, "SetRace")
	UnRegisterForAnimationEvent(PlayerRef, "GroundStart")
   	UnRegisterForAnimationEvent(PlayerRef, "LevitateStart")
    UnRegisterForAnimationEvent(PlayerRef, "LiftoffStart")
    UnRegisterForAnimationEvent(PlayerRef, "LandStart")
   	UnRegisterForAnimationEvent(PlayerRef, "TransformToHuman" )
   	UnRegisterForAnimationEvent(PlayerREF, "Soundplay.NPCWerewolfTransformation")
   	UnRegisterForAnimationEvent(PlayerRef, "WerewolfTransformation ")
	UnRegisterForAnimationEvent(PlayerRef, "VampireLordChangePlayer ")
	UnRegisterForAnimationEvent(PlayerRef, "pa_VampireLordChangePlayer")
	UnRegisterForAnimationEvent(PlayerRef, "RemoveCharacterControllerFromWorld")
   	;Actor actions
   	;UnregisterForActorAction(1)
   	UnregisterForActorAction(2)
   	UnregisterForActorAction(7)
	UnregisterForActorAction(8)
	UnregisterForActorAction(10)
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
		;/if bIsBoundSpellEquipped
			RegisterForActorAction(2) ;Spell fire
		else
			UnregisterForActorAction(2)
		endIf/;
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
	debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete start")
	debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - current state: " + GetState())
	if UI.IsMenuOpen("RaceSex Menu")
		PlayerRace = PlayerRef.GetRace()
	else
		race newRace = PlayerRef.GetRace()
		debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - current PlayerRace: " + PlayerRace.GetName() + ", newRace: " + newRace.GetName() + ", original race: " + PlayerBaseRace.GetName())
		race baseRace = iEquip_ActorExt.GetBaseRace(PlayerRef)
		debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - baseRace: " + baseRace.GetName())
		if WC.isEnabled && WC.bEnableGearedUp
			Utility.SetINIbool("bDisableGearedUp:General", !(newRace == PlayerRace))
			WC.refreshVisibleItems()
		endIf
		if PlayerRace != newRace
			PlayerRace = newRace
			bPlayerIsAVampire = (aPlayerBaseRaces.Find(PlayerBaseRace) == aPlayerBaseVampireRaces.Find(PlayerRace))
			bPlayerIsABeast = BM.arBeastRaces.Find(PlayerRace) > -1
			KH.bPlayerIsABeast = bPlayerIsABeast
			if bPlayerIsABeast
				debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - bPlayerIsABeast: " + bPlayerIsABeast)
				gotoState("BEASTMODE")
				unregisterForCoreAnimationEvents()
				registerForBMEvents()
			elseIf (PlayerRace == PlayerBaseRace) || bPlayerIsAVampire
				debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - bPlayerIsAVampire: " + bPlayerIsAVampire)
				unregisterForBMEvents()
				registerForCoreAnimationEvents()
				gotoState("")
			else ;If we're not one of the supported beast races, and we're not in our original form then we must be an unsupported transformation so unregister for all events and block all relevant OnXxx events
				debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - player is in an unsupported form")
				unregisterForAllEvents()
				gotoState("DISABLED")
			endIf
			if WC.isEnabled
				BM.onPlayerTransform(PlayerRace, bPlayerIsAVampire)
			endIf
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete - new state: " + GetState())
	debug.trace("iEquip_PlayerEventHandler OnRaceSwitchComplete end")
EndEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	debug.trace("iEquip_PlayerEventHandler OnActorAction start")	
	debug.trace("iEquip_PlayerEventHandler OnActorAction - actionType: " + actionType + ", slot: " + slot)
	if akActor == PlayerRef
		if actionType == 2 ;Spell Cast/Spell Fire
			;Check if the action has come from a hand with a staff currently equipped
			if PlayerRef.GetEquippedItemType(slot) == 8
				if RC.bRechargingEnabled && CM.iChargeDisplayType > 0 && CM.abIsChargeMeterShown[iSlotToUpdate]
					CM.updateMeterPercent(iSlotToUpdate)
				endIf
			else
				;Otherwise check if we've just cast Bound Shield (weapons are handled in BoundWeaponEventsListener)
				Utility.WaitMenuMode(0.3)
				if PlayerRef.GetEquippedShield() && PlayerRef.GetEquippedShield().GetName() == WC.asCurrentlyEquipped[0]
					WC.onBoundWeaponEquipped(26, 0)
					iEquip_AllCurrentItemsFLST.AddForm(PlayerRef.GetEquippedShield() as form)
					updateEventFilter(iEquip_AllCurrentItemsFLST)
				endIf
			endIf
		elseIf actionType == 7 ;Draw Begin
			debug.trace("iEquip_PlayerEventHandler OnActorAction - weapon drawn, bIsWidgetShown: " + WC.bIsWidgetShown)
			WVis.unregisterForWidgetFadeoutUpdate() ;Unregister first in case it's just about to fade out
			if !WC.bIsWidgetShown
				WC.updateWidgetVisibility()
			endIf
		elseIf actionType == 8 ;Draw End
			debug.trace("iEquip_PlayerEventHandler OnActorAction - weapon drawn, bIsWidgetShown: " + WC.bIsWidgetShown)
			WVis.unregisterForWidgetFadeoutUpdate()
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
    if EventName == "Soundplay.NPCWerewolfTransformation"
    	BM.OnWerewolfTransformationStart()
    ;ToDo - update meditation animation event names
    ;if (EventName == "IdleGreybeardMeditateEnter" || EventName == "IdleGreybeardMeditateEnterInstant") && (PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x06CAED, "Thunderchild - Epic Shout Package.esp") as MagicEffect) || PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x023dd5, "Wintersun - Faiths of Skyrim.esp") as MagicEffect))
    elseIf (EventName == "IdleChairSitting") && (PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x06CAED, "Thunderchild - Epic Shout Package.esp") as MagicEffect) || PlayerRef.HasMagicEffect(Game.GetFormFromFile(0x023dd5, "Wintersun - Faiths of Skyrim.esp") as MagicEffect))
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
	if !WC.bAddingItemsOnFirstEnable && !bGoingUnarmed && !processingQueuedForms
		if akBaseObject as spell && bDualCasting
			dualCastCounter -=1
			if dualCastCounter == 0
				bDualCasting = false
			endIf
		else
			int itemType = akBaseObject.GetType()
			if itemTypesToProcess.Find(itemType) > -1 || (itemType == 26 && (akBaseObject as Armor).GetSlotMask() == 512)
				iEquip_OnObjectEquippedFLST.AddForm(akBaseObject)
				if !bWaitingForTransform
					bWaitingForOnObjectEquippedUpdate = true
					registerForSingleUpdate(0.5)
				endIf
			endIf
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnObjectEquipped end")
endEvent

Event OnUpdate()
	debug.trace("iEquip_PlayerEventHandler OnUpdate start")	
	debug.trace("iEquip_PlayerEventHandler OnUpdate - bWaitingForAnimationUpdate: " + bWaitingForAnimationUpdate + ", bWaitingForOnObjectEquippedUpdate: " + bWaitingForOnObjectEquippedUpdate + ", bWaitingForTransform: " + bWaitingForTransform)
	if bWaitingForAnimationUpdate
		bWaitingForAnimationUpdate = false
		updateWidgetOnWeaponSwing()
	endIf
	if bWaitingForOnObjectEquippedUpdate
		bWaitingForOnObjectEquippedUpdate = false
		if !bWaitingForTransform
			processQueuedForms()
		endIf
	endIf
	debug.trace("iEquip_PlayerEventHandler OnUpdate end")	
EndEvent

function updateWidgetOnWeaponSwing()
	debug.trace("iEquip_PlayerEventHandler updateWidgetOnWeaponSwing start")
	if iSlotToUpdate == 0 || iSlotToUpdate == 1
		If bPoisonSlotEnabled
			WC.checkAndUpdatePoisonInfo(iSlotToUpdate)
		endIf
		if RC.bRechargingEnabled && CM.iChargeDisplayType > 0 && CM.abIsChargeMeterShown[iSlotToUpdate]
			CM.updateMeterPercent(iSlotToUpdate)
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
	int i
	form queuedForm
	while i < iEquip_OnObjectEquippedFLST.GetSize()
		queuedForm = iEquip_OnObjectEquippedFLST.GetAt(i)
		debug.trace("iEquip_PlayerEventHandler processQueuedForms - i: " + i + ", queuedForm: " + queuedForm + " - " + queuedForm.GetName())
		;Check the item is still equipped, and if it is in the left, right or shout slots which is all we're interested in here. Blocked if equipped item is a bound weapon or an item from Throwing Weapons Lite (to avoid weirdness...)
		if !(iEquip_WeaponExt.IsWeaponBound(queuedForm as weapon)) && !(Game.GetModName(queuedForm.GetFormID() / 0x1000000) == "JZBai_ThrowingWpnsLite.esp") && !(Game.GetModName(queuedForm.GetFormID() / 0x1000000) == "Bound Shield.esp")
			int equippedSlot = -1
			if PlayerRef.GetEquippedObject(0) == queuedForm
				;Now we need to check if we've just equipped the same 1H item/spell in both left and right hand at the same time
				if PlayerRef.GetEquippedObject(1) == queuedForm
					equippedSlot = 3 ;We'll use 3 to indicate the same 1H item has been found in both hands so we can update both queues and widget slots
				else
					equippedSlot = 0 ;Left
				endIf
			elseIf PlayerRef.GetEquippedObject(1) == queuedForm
				equippedSlot = 1 ;Right
			elseIf PlayerRef.GetEquippedObject(2) == queuedForm
				equippedSlot = 2 ;Shout/Power
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
				if bPlayerIsABeast
					if equippedSlot == 3
						BM.updateSlotOnObjectEquipped(0, queuedForm, itemType, iEquipSlot)
						BM.updateSlotOnObjectEquipped(1, queuedForm, itemType, iEquipSlot)
					else
						BM.updateSlotOnObjectEquipped(equippedSlot, queuedForm, itemType, iEquipSlot)
					endIf
				elseIf equippedSlot == 3
					updateSlotOnObjectEquipped(0, queuedForm, itemType, iEquipSlot)
					updateSlotOnObjectEquipped(1, queuedForm, itemType, iEquipSlot)
				else
					updateSlotOnObjectEquipped(equippedSlot, queuedForm, itemType, iEquipSlot)
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

function updateSlotOnObjectEquipped(int equippedSlot, form queuedForm, int itemType, int iEquipSlot)
	debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped start")
	debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped - equippedSlot: " + equippedSlot)
	bool actionTaken
	int targetIndex
	bool blockCall
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
	;Check that the queuedForm isn't blacklisted for the slot it's been equipped to
	if !blackListFLSTs[equippedSlot].HasForm(queuedForm)
		;If it isn't already contained in the AllCurrentItems formlist, or it is but findInQueue has returned -1 meaning it's a 1H item contained in the other hand queue
		if !actionTaken && ((equippedSlot < 2 && bAutoAddNewItems) || (equippedSlot == 2 && ((itemType == 22 && bAutoAddShouts) || (itemType == 119 && bAutoAddPowers))))
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
				jMap.setInt(iEquipItem, "iEquipAutoAdded", 1)
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
						AhzMoreHudIE.RemoveIconItem(itemID)
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
	debug.trace("iEquip_PlayerEventHandler updateSlotOnObjectEquipped end")
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
		bool actionTaken
		while i < 3 && !actionTaken
			string itemName = akBaseItem.GetName()
			foundAt = WC.findInQueue(i, itemName)
			if foundAt != -1
				;If it's a shout or power remove it straight away
				if i == 2
					WC.removeItemFromQueue(i, foundAt)
					actionTaken = true
				else
					int otherHand = (i + 1) % 2
					int itemType = akBaseItem.GetType()
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

state BEASTMODE
	event OnActorAction(int actionType, Actor akActor, Form source, int slot)
		debug.trace("iEquip_PlayerEventHandler OnActorAction BEASTMODE start")	
		debug.trace("iEquip_PlayerEventHandler OnActorAction BEASTMODE - actionType: " + actionType + ", slot: " + slot)
		if akActor == PlayerRef
			if actionType == 7 ;Draw Begin
				if !WC.bIsWidgetShown && !bWaitingForTransform
					WC.updateWidgetVisibility()
				endIf
			elseIf actionType == 8 ;Draw End
				if !WC.bIsWidgetShown && !bWaitingForTransform ;In case we're drawing a spell which won't have been caught by Draw Begin
					WC.updateWidgetVisibility()
				endIf
			elseIf actionType == 10 && WC.bIsWidgetShown && WC.bWidgetFadeoutEnabled ;Sheathe End
				WVis.registerForWidgetFadeoutUpdate()
			endIf
		endIf
		debug.trace("iEquip_PlayerEventHandler OnActorAction BEASTMODE end")
	endEvent

	event OnAnimationEvent(ObjectReference aktarg, string EventName)
		debug.trace("iEquip_PlayerEventHandler OnAnimationEvent BEASTMODE start")
	    debug.trace("iEquip_PlayerEventHandler OnAnimationEvent BEASTMODE received - EventName: " + EventName)
	    if EventName == "LandStart"
	    	BM.showClaws()
	    elseIf EventName == "LiftoffStart"
	    	BM.showPreviousItems()
	    endIf
	    debug.trace("iEquip_PlayerEventHandler OnAnimationEvent BEASTMODE end")
	endEvent

	;event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	;endEvent
endState

auto state DISABLED
	event OnActorAction(int actionType, Actor akActor, Form source, int slot)
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
