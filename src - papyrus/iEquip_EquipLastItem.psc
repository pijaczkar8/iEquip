; Equip Last Item by VictorF - An iEquip Add-On

Scriptname iEquip_EquipLastItem extends ReferenceAlias

iEquip_WidgetCore Property WC auto
iEquip_PotionScript Property PO auto

Actor Property PlayerRef Auto
Keyword Property ArmorShield Auto
Sound Property vSpellLearned Auto
int property shieldMask = 0x200 autoreadonly

EquipSlot RightHand
EquipSlot LeftHand
EquipSlot EitherHand
EquipSlot BothHands
EquipSlot VoiceSlot

Form[] addedItems
bool[] persistent
ObjectReference[] addedRefs

int startIndex
int currentIndex

bool bEnabled

bool property DEST auto

int property defaultBehavior = 0 autoreadonly
int property forceRight = 1 autoreadonly
int property forceLeft = 2 autoreadonly

;weapons, ammo and shields
bool property handle1HWeapons = true auto hidden
bool property handle2HWeapons = true auto hidden
bool property handleBowsXBows = true auto hidden
bool property handleAmmo = true auto hidden
bool property handleStaves = true auto hidden
bool property handleShields = true auto hidden
;armor
bool property handleLightArmor = true auto hidden
bool property handleHeavyArmor = true auto hidden
bool property handleClothing = true auto hidden
;potions
bool property handlePotions = true auto hidden
bool property handlePoisons = true auto hidden
bool property handleFood = true auto hidden
;books
bool property handleSpellTomes = true auto hidden
bool property handlePersistentBooks = false auto hidden
;other
bool property handleScrolls = true auto hidden
bool property handleIngredients = true auto hidden

float property queueTimeout = 30.0 auto

bool clearWhenDone

function initialise()
	DefaultObjectManager defaultObjects = Game.GetFormFromFile(0x31, "Skyrim.esm") as DefaultObjectManager
	RightHand = defaultObjects.getForm("RHEQ") as EquipSlot
	LeftHand = defaultObjects.getForm("LHEQ") as EquipSlot
	EitherHand = defaultObjects.getForm("EHEQ") as EquipSlot
	BothHands = Game.GetFormFromFile(0x13F45, "Skyrim.esm") as EquipSlot
	VoiceSlot = defaultObjects.getForm("VOEQ") as EquipSlot

	addedItems = new Form[128]
	persistent = new bool[128]
	addedRefs = new ObjectReference[128]
	
	GameLoaded()
endFunction

bool property isEnabled
	bool function Get()
		Return bEnabled
	endFunction
	
	function Set(bool enabled)
        bEnabled = enabled
		if bEnabled
			GoToState("WAITING")
		else
			GoToState("DISABLED")
		endIf
	endFunction
EndProperty

function GameLoaded()
	if bEnabled
		goToState("WAITING")
	else
		goToState("DISABLED")
	endIf
endFunction

Form Property lastItem
	Form function get()
		;debug.trace("iEquip_EquipLastItem - Requested item: " + addedItems[currentIndex].getName())
		registerForSingleUpdate(queueTimeout)
		return addedItems[currentIndex]
	endFunction
endProperty

bool Property lastItemPersist
	bool function get()
		return persistent[currentIndex]
	endFunction
endProperty

ObjectReference Property lastItemRef
	ObjectReference function get()
		return addedRefs[currentIndex]
	endFunction
endProperty

state WAITING
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		goToState("ACTIVE")
		bool add = false
		if(akBaseItem as Weapon)
			int wt = (akBaseItem as Weapon).getWeaponType()
			add = (handle1HWeapons && (wt >= 1 && wt <= 4)) || (handle2HWeapons && (wt == 5 || wt == 6)) || (handleBowsXBows && (wt == 7 || wt == 9)) || (handleStaves && wt == 8)
		elseif(akBaseItem as Ammo)
			add = handleAmmo
		elseif(akBaseItem as Armor)
			int weight = (akBaseItem as Armor).getWeightClass()
			bool notShield = Math.LogicalAnd(shieldMask, (akBaseItem as Armor).getSlotMask()) == 0
			add = (notShield || handleShields) && ((handleLightArmor && weight == 0) || (handleHeavyArmor && weight == 1) || (handleClothing && weight == 2))
		elseif(akBaseItem as Potion)
			bool isFood = (akBaseItem as Potion).isFood()
			bool isPoison = (akBaseItem as Potion).isPoison()
			bool isPotion = !isFood && !isPoison
			add = (handlePotions && isPotion) || (handlePoisons && isPoison) || (handleFood && isFood)
		elseif(akBaseItem as Book)
			add = (handleSpellTomes && (akBaseItem as Book).getSpell()) || (handlePersistentBooks && akItemReference)
		elseif(akBaseItem as Scroll)
			add = handleScrolls
		elseif(akBaseItem as Ingredient)
			add = handleIngredients
		endIf
		if(add)
			addItemToQueue(akBaseItem, akItemReference)
		endIf

		goToState("WAITING")
	endEvent
endState

state ACTIVE
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;player did something too fast, clear lastItem on exit state
		;debug.trace("iEquip_EquipLastItem - Triggered OnItemAdded in ACTIVE state with " + akBaseItem.getName())
		clearWhenDone = true
	endEvent
	
	Event OnEndState()
		if(clearWhenDone)
			clearWhenDone = false
			clearLastItem()
		endIf
	endEvent
endState

state DISABLED
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	endEvent
endState

Event OnUpdate()
	goToState("ACTIVE")
	restartQueue()
	goToState("WAITING")
endEvent

function addItemToQueue(Form akBaseItem, ObjectReference akItemReference = None)
	currentIndex = (currentIndex + 1) % 128
	persistent[currentIndex] = akItemReference != None
	addedRefs[currentIndex] = akItemReference
	addedItems[currentIndex] = akBaseItem
	;if(lastItemPersist) ;not sure if this is necessary
	;	lastItem = lastItemRef.getBaseObject()
	;endIf
	if(currentIndex == startIndex)
		startIndex = (startIndex + 1) % 128
	endIf
	;debug.trace("iEquip_EquipLastItem - Added item " + akBaseItem.getName() + " at index " + currentIndex + ".")
	registerForSingleUpdate(queueTimeout)
endFunction

function clearLastItem()
	;debug.trace("iEquip_EquipLastItem - Clearing queue.")
	addedItems[currentIndex] = None
	persistent[currentIndex] = false
	addedRefs[currentIndex] = None
	while (addedItems[currentIndex] == None && currentIndex != startIndex)
		currentIndex = (currentIndex - 1) % 128
	endWhile
	;debug.trace("iEquip_EquipLastItem - Cleared. Current index: " + currentIndex)
endFunction

function restartQueue()
	startIndex = currentIndex
	addedItems[currentIndex] = None
	persistent[currentIndex] = false
	addedRefs[currentIndex] = None
endFunction

function useLast(bool useLeft)
	if lastItem ;check if last item hasn't been cleared
		bool cleanupWhenDone = true
		if(PlayerRef.getItemCount(lastItem) > 0 || PlayerRef.hasSpell(lastItem as Spell))
			if(lastItem as Weapon) ;weapon - pass to iequip
				Weapon lastWeapon = lastItem as Weapon
				int force = defaultBehavior
				int wt = lastWeapon.getWeaponType()
				if((wt >= 1 && wt <= 4) || wt == 8) ; one-handed weapons
					if(useLeft)
						force = forceLeft
					else
						force = forceRight
					endIf
				elseif(wt == 5 || wt == 6) ; two handed weapons
					if(WC.bIsCGOLoaded && useLeft)
						force = forceLeft
					else
						force = forceRight
					endIf
				elseif(wt == 7 || wt == 9)
					force = forceRight
				endIf
				WC.onWeaponOrShieldAdded(lastItem, force)
			elseif(lastItem as Armor && lastItem.hasKeyword(ArmorShield)) ;shield - pass to iequip
				WC.onWeaponOrShieldAdded(lastItem, forceLeft)
			elseif(lastItem as Armor || lastItem as Ammo || lastItem as Ingredient) ;simple item - just equip directly
				PlayerRef.equipItem(lastItem)
			elseif(lastItem as Book) ;only persistent books or spell tomes added, read or add spell to player and queue
				Book lastBook = lastItem as Book
				Spell s = lastBook.getSpell()
				if(s) ; the book is a spell tome
					if(DEST); Parapets says can't emit DEST event from papyrus, so ignore that case for now.
					; patch in other mods directly here
					else ; handle spell tome. 
						if !PlayerRef.HasSpell(s) ;code taken from DEST
							PlayerRef.RemoveItem(lastBook, 1, abSilent = true)
							string sSpellAdded = Game.GetGameSettingString("sSpellAdded")
							string sText = sSpellAdded + ": " + s.GetName()
							vSpellLearned.play(PlayerRef)
							PlayerRef.AddSpell(s, abVerbose = false)
							debug.notification(sText)
							addItemToQueue(s)
							clearWhenDone = false
						else
							string sAlreadyKnown = Game.GetGameSettingString("sAlreadyKnown")
							string sText = sAlreadyKnown + " " + s.GetName()
							debug.notification(sText)
						endif
					endIf
				else ; persistent book, most likely from quest, just activate it
					lastItemRef.activate(PlayerRef)
				endif
			elseif(lastItem as Spell) ;"wait but spells aren't items" lies. deception.
				Spell lastSpell = lastItem as Spell
				EquipSlot usedSlot = lastSpell.getEquipType()
				if(usedSlot == RightHand || (usedSlot == EitherHand && !useLeft) || usedSlot == BothHands)
					PlayerRef.equipSpell(lastSpell, 1)
				elseif(usedSlot == LeftHand || usedSlot == EitherHand)
					PlayerRef.equipSpell(lastSpell, 0)
				elseif(usedSlot == VoiceSlot)
					PlayerRef.equipSpell(lastSpell, 2)
				endIf
			elseif(lastItem as Scroll) ; equip to hand by equip type, same as spells.
				Scroll lastScroll = lastItem as Scroll
				EquipSlot usedSlot = lastScroll.getEquipType()
				if(usedSlot == RightHand || (usedSlot == EitherHand && !useLeft) || usedSlot == BothHands)
					PlayerRef.EquipItemEx(lastScroll, 1)
				elseif(usedSlot == LeftHand || usedSlot == EitherHand)
					PlayerRef.EquipItemEx(lastScroll, 2)
				endIf
			elseif(lastItem as Potion);use potions, queue and cycle to poisons
				Potion lastPotion = lastItem as Potion
				if(lastPotion.isPoison()); hand poisons off to iequip because it has way more features than i do
					PO.checkAndAddToPoisonQueue(lastPotion)
					PO.sortPoisonQueue()
					WC.jumpToPoisonQueueIndex(lastPotion.GetName(), lastPotion)
				else
					PlayerRef.equipItem(lastPotion)
				endIf
			endIf
		endIf
		if(cleanupWhenDone)
			clearLastItem()
		endIf
	else
		debug.notification("The added items queue is empty.")
	endIf
endFunction