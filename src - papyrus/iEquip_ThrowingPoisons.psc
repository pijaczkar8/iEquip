
Scriptname iEquip_ThrowingPoisons extends Quest

import UI
import iEquip_StringExt
import PO3_SKSEFunctions

iEquip_WidgetCore property WC auto
iEquip_ChargeMeters property CM auto
iEquip_ThrowingPoisons property PM auto
iEquip_AmmoMode property AM auto
iEquip_PotionScript property PO auto

Actor property PlayerRef auto

weapon property iEquip_ThrowingPoisonWeapon auto
spell property iEquip_ThrowingPoisonSpell auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

; MCM Properties
int property iThrowingPoisonBehavior = 1 auto hidden 	; 0 = Disabled, 1 = Throw & Switch Back, 2 = Keypress Toggles (keep throwing poisons until pressed again to switch back)
int property iThrowingPoisonHand = 1 auto hidden		; 0 = Left Hand, 1 = Right Hand

bool property bKeepThrowing auto hidden
bool property bPoisonEquipped auto hidden

int iPreviousLeftHandIndex
int iPreviousRightHandIndex
form fPreviousLeftHandForm
form fPreviousRightHandForm
int iPreviousRHType
bool bPreviously2H
bool bPreviouslyUnarmed

int[] aiHandEquipSlots

potion currentPoison

event OnInit()
	aiHandEquipSlots = new int[2]
	aiHandEquipSlots[0] = 2
	aiHandEquipSlots[1] = 1
endEvent

function OnWidgetLoad()
	;debug.trace("iEquip_TorchScript initialise start")
	if WC.bPowerOfThreeExtenderLoaded
		GoToState("")
		WidgetRoot = WC.WidgetRoot
		RegisterForMenu("InventoryMenu")
		
	else
		UnregisterForAllMenus()
		
		GoToState("DISABLED")
	endIf
	;debug.trace("iEquip_TorchScript initialise end")
endFunction

event OnMenuOpen(string MenuName)

endEvent

event OnMenuClose(string MenuName)

endEvent

function OnThrowingPoisonKeyPressed()
	if jArray.count(WC.aiTargetQ[4]) < 1				; No poisons left in the poison queue
		debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TP_not_noPoisons"))
	elseIf iThrowingPoisonBehavior == 1					; Throw & Switch Back
		equipPoison()
	else 												; Toggle throwing poisons
		toggleThrowingPoisons()
	endIf
endFunction

function toggleThrowingPoisons()
	bKeepThrowing = !bKeepThrowing
	if bKeepThrowing
		equipPoison()
	elseIf bPoisonEquipped
		switchBack()
	endIf
endFunction

function equipPoison()
	potion newPoison = jMap.getForm(jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4]), "iEquipForm") as potion
	if newPoison
		if currentPoison != newPoison
			currentPoison = newPoison
			removeCurrentEffectsFromSpell()
			addPoisonEffectsToSpell()
		endIf
	else
		bKeepThrowing = false
		if bPoisonEquipped
			switchBack()
		endIf
	endIf
endFunction

; For reference from PO3_SKSEFunctions - Function RemoveMagicEffectFromSpell(Spell akSpell, MagicEffect mgef, float magnitude, int area, int duration, float cost = 0.0) global native

function removeCurrentEffectsFromSpell()
	int i
	magicEffect effectToRemove
	while i < iEquip_ThrowingPoisonSpell.GetNumEffects()
		effectToRemove = iEquip_ThrowingPoisonSpell.GetNthEffectMagicEffect(i)
		RemoveMagicEffectFromSpell(iEquip_ThrowingPoisonSpell, effectToRemove, iEquip_ThrowingPoisonSpell.GetNthEffectMagnitude(i), iEquip_ThrowingPoisonSpell.GetNthEffectArea(i), iEquip_ThrowingPoisonSpell.GetNthEffectDuration(i))
		i += 1
	endWhile
endFunction

; For reference from PO3_SKSEFunctions - Function AddMagicEffectToSpell(Spell akSpell, MagicEffect mgef, float magnitude, int area, int duration, float cost = 0.0, String[] conditionList = None) global native

function addPoisonEffectsToSpell()
	int i
	magicEffect effectToAdd
	while i < currentPoison.GetNumEffects()
		effectToAdd = currentPoison.GetNthEffectMagicEffect(i)
		AddMagicEffectToSpell(iEquip_ThrowingPoisonSpell, effectToAdd, currentPoison.GetNthEffectMagnitude(i), currentPoison.GetNthEffectArea(i), currentPoison.GetNthEffectDuration(i))
		i += 1
	endWhile
endFunction

function unequipPoison()

endFunction

function onPoisonThrown()
	
	bool bLastOfCurrentPoison = PlayerRef.GetItemCount(currentPoison as form) == 1
	bool bLastPoisonInQueue = jArray.count(WC.aiTargetQ[4]) == 1 && bLastOfCurrentPoison

	PlayerRef.RemoveItem(currentPoison, 1, true)		; Remove one item from the player.  This will also trigger the poison queue to update the count and cycle forwards if the last of the current poison has just been thrown.

	if bKeepThrowing && !bLastPoisonInQueue
		if bLastOfCurrentPoison
			Utility.WaitMenuMode(0.5)					; Allow for OnItemRemoved to remove the current poison from the queue and cycle on to the next				
		endIf
		equipPoison()
	else
		switchBack()
	endIf
endFunction

function saveCurrentItemsForSwitchBack()
	;debug.trace("iEquip_ThrowingPoisons saveCurrentItemsForSwitchBack start")
	
	fPreviousLeftHandForm = PlayerRef.GetEquippedObject(0)
	if fPreviousLeftHandForm && (fPreviousLeftHandForm == jMap.getForm(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipForm"))
		iPreviousLeftHandIndex = WC.aiCurrentQueuePosition[0]
	else
		iPreviousLeftHandIndex = -1
	endIf

	fPreviousRightHandForm = PlayerRef.GetEquippedObject(1)
	if fPreviousRightHandForm && (fPreviousRightHandForm == jMap.getForm(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipForm"))
		iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
	else
		iPreviousRightHandIndex = -1
	endIf

	if fPreviousRightHandForm
		iPreviousRHType = fPreviousRightHandForm.GetType()
		if fPreviousRightHandForm as weapon
			iPreviousRHType = (fPreviousRightHandForm as weapon).GetWeaponType()
		endIf
		bPreviously2H = (WC.ai2HWeaponTypes.Find(iPreviousRHType) > -1 && !(iPreviousRHType < 7 && WC.bIsCGOLoaded)) || (iPreviousRHType == 22 && (fPreviousRightHandForm as spell).GetEquipType() == WC.EquipSlots[3])
	else
		bPreviously2H = false
	endIf

	bPreviouslyUnarmed = (fPreviousRightHandForm == none && fPreviousLeftHandForm == none) || (fPreviousRightHandForm == WC.EH.Unarmed)
	;debug.trace("iEquip_ThrowingPoisons saveCurrentItemsForSwitchBack end")
endFunction


function switchBack()
	;debug.trace("iEquip_ThrowingPoisons switchBack start")
	bPoisonEquipped = false

	if iPreviousLeftHandIndex != -1
		WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
		WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], iPreviousLeftHandIndex), "iEquipName")
	endIf

	if iPreviousRightHandIndex != -1
		WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
		WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(WC.aiTargetQ[1], iPreviousRightHandIndex), "iEquipName")
	endIf
	
	int Q = iThrowingPoisonHand
	
	if bPreviously2H
		Q = 2
	endIf
	
	if bPreviouslyUnarmed
		if iPreviousRightHandIndex != -1 && WC.asCurrentlyEquipped[1] == "$iEquip_common_Unarmed"
			WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
		endIf
		WC.goUnarmed()
	elseIf Q < 2
		if (Q == 0 && iPreviousLeftHandIndex != -1) || (Q == 1 && iPreviousRightHandIndex != -1)
			WC.updateWidget(Q, WC.aiCurrentQueuePosition[Q], true) ; True overrides bPreselectMode to make sure we're updating the main slot if we're in Preselect
			WC.checkAndEquipShownHandItem(Q)
		else
			form previousItemForm
			if Q == 0
				previousItemForm = fPreviousLeftHandForm
			else
				previousItemForm = fPreviousRightHandForm
			endIf

			if previousItemForm == none
				WC.UnequipHand(Q)
			elseIf previousItemForm as spell
				PlayerRef.EquipSpell(previousItemForm as Spell, aiHandEquipSlots.Find(Q))
			else
				PlayerRef.EquipItemEx(previousItemForm, aiHandEquipSlots.Find(Q))
			endIf
		endIf
	elseIf Q == 2
		if iPreviousLeftHandIndex != -1
			WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
			if iPreviousRHType == 7 || iPreviousRHType == 9
				Utility.WaitMenuMode(0.4)
			endIf
		endIf
		if iPreviousRightHandIndex != -1
			WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
			WC.checkAndEquipShownHandItem(1)
		else
			if fPreviousRightHandForm == none
				WC.UnequipHand(1)
			elseIf fPreviousRightHandForm as spell
				PlayerRef.EquipSpell(fPreviousRightHandForm as Spell, 1)
			else
				PlayerRef.EquipItemEx(fPreviousRightHandForm, 1)
			endIf
		endIf
	else
		;debug.trace("iEquip_ThrowingPoisons switchBack - Something went wrong!")
	endIf

	;debug.trace("iEquip_ThrowingPoisons switchBack end")
endFunction

;/function quickLight()

	form currentItemForm = PlayerRef.GetEquippedObject(0)
	int currentItemType = PlayerRef.GetEquippedItemType(0)
	bool torchEquipped = currentItemType == 11	; Torch - this covers any torch, including the iEquipTorch used during the burnout sequence
	int targetSlot
	
	;debug.trace("iEquip_TorchScript quickLight start - torch equipped: " + torchEquipped + ", currentItemForm: " + currentItemForm + ", currentItemType: " + currentItemType + ", bPreviously2HOrRanged: " + bPreviously2HOrRanged)
	;debug.trace("iEquip_TorchScript quickLight - previousLeftHandIndex: " + previousLeftHandIndex + ", previousLeftHandName: " + previousLeftHandName + ", previousItemForm: " + previousItemForm + ", previousItemHandle: " + previousItemHandle)

	if torchEquipped || candlelightEquipped
		
		if torchEquipped
			WC.setCounterVisibility(0, false)
			if bShowTorchMeter
				updateTorchMeterVisibility(false)
			endIf

			bSettingLightRadius = false
			UnregisterForUpdate()	; Cancel any pending updates

			PlayerRef.UnequipItemEx(currentItemForm)
		else
			PlayerRef.UnequipSpell(Candlelight, 0)
		endIf

		if bPreviously2HOrRanged
			targetSlot = 1		; Right hand
			WC.aiCurrentQueuePosition[0] = previousLeftHandIndex
			WC.asCurrentlyEquipped[0] = previousLeftHandName
			WC.updateWidget(0, previousLeftHandIndex, true)
		elseIf previousItemForm as Armor || previousItemForm as spell
			targetSlot = 0		; Default, for shields only, 0 for spells with EquipSpell (left)
		else
			targetSlot = 2		; Left hand
		endIf

		bJustCalledQuickLight = true

		if WC.bPlayerIsMounted
			WC.KH.UnregisterForLeftKey()
			WC.fadeLeftIcon(true)
		elseIf previousItemHandle != 0xFFFF
			iEquip_InventoryExt.EquipItem(previousItemForm, previousItemHandle, PlayerRef, targetSlot)
		elseIf previousItemForm
			if previousItemForm as spell
				PlayerRef.EquipSpell(previousItemForm as Spell, targetSlot)
			else
				PlayerRef.EquipItemEx(previousItemForm, targetSlot)
			endIf
		else
			WC.setSlotToEmpty(0, true, jArray.count(WC.aiTargetQ[0]) > 0)
		endIf

	else
		bool playerHasATorch = PlayerRef.GetItemCount(realTorchForm) > 0
		bool playerKnowsSpell = PlayerRef.HasSpell(Candlelight)

		if playerHasATorch || playerKnowsSpell
		
			WC.hidePoisonInfo(0)

			if WC.ai2HWeaponTypesAlt.Find(currentItemType) > -1 && !(currentItemType < 7 && WC.bIsCGOLoaded)
				bPreviously2HOrRanged = true
				previousLeftHandIndex = WC.aiCurrentQueuePosition[0]
				previousLeftHandName = WC.asCurrentlyEquipped[0]
			else
				bPreviously2HOrRanged = false
			endIf

			bJustCalledQuickLight = true

			if AM.bAmmoMode
				AM.toggleAmmoMode(true, true)
				if !AM.bSimpleAmmoMode
					bool[] args = new bool[3]
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
					args = new bool[4]
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
				endIf
			elseIf WC.bPlayerIsMounted
				WC.KH.RegisterForLeftKey()
			endIf

			if currentItemType == 10 ; Shield
				targetSlot = 2
			else
				targetSlot = bPreviously2HOrRanged as int
			endIf

			previousItemHandle = iEquip_InventoryExt.GetRefHandleFromWornObject(targetSlot)
			previousItemForm = currentItemForm

			if playerKnowsSpell && (bQuickLightPreferMagic || (!playerHasATorch && bQuickLightUseMagicIfNoTorch)) && (PlayerRef.GetActorValue("Magicka") > Candlelight.GetEffectiveMagickaCost(PlayerRef) || (PO.getRestoreCount(1) > 0 && bQuickLightConsumePotion))
				if PlayerRef.GetActorValue("Magicka") < Candlelight.GetEffectiveMagickaCost(PlayerRef)
					PO.selectAndConsumePotion(1, 0)
				endIf
				PlayerRef.EquipSpell(Candlelight, 0)
			elseIf playerHasATorch
				PlayerRef.EquipItemEx(realTorchForm) ; This should then be caught by EH.onObjectEquipped and trigger all the relevant widget/torch/RH stuff as required
			endIf
		else
			debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TO_not_noTorch"))
		endIf
	endIf
	;debug.trace("iEquip_TorchScript quickLight end")
endFunction

function quickHealFindAndEquipSpell()
	;debug.trace("iEquip_ThrowingPoisons quickHealFindAndEquipSpell start")
	int i
	int Q
	int count
	int targetIndex = -1
	int containingQ
	int targetObject
	while Q < 2 && targetIndex == -1
		count = jArray.count(WC.aiTargetQ[Q])
		while i < count && targetIndex == -1
			targetObject = jArray.getObj(WC.aiTargetQ[Q], i)
			if jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_SpellExt.IsHealingSpell(jMap.getForm(targetObject, "iEquipForm") as spell) && (jMap.getForm(targetObject, "iEquipForm") as spell).GetNthEffectMagicEffect((jMap.getForm(targetObject, "iEquipForm") as spell).GetCostliestEffectIndex()).GetDeliveryType() == 0  ; Make sure it's a Self delivery type healing spell
				targetIndex = i
				containingQ = Q
			endIf
			i += 1
		endwhile
		i = 0
		Q += 1
	endWhile
	;debug.trace("iEquip_ThrowingPoisons quickHealFindAndEquipSpell - spell found at targetIndex: " + targetIndex + " in containingQ: " + containingQ + ", iQuickHealEquipChoice: " + iQuickHealEquipChoice)
	if targetIndex != -1
		int iEquipSlot = iQuickHealEquipChoice
		bool equippingOtherHand
		if iEquipSlot < 2 && iEquipSlot != containingQ
			equippingOtherHand = true
		elseIf iEquipSlot == 3 ;Equip spell where it is found
			iEquipSlot = containingQ
		endIf
		;debug.trace("iEquip_ThrowingPoisons quickHealFindAndEquipSpell - iEquipSlot: " + iEquipSlot + ", bQuickHealSwitchBackEnabled: " + bQuickHealSwitchBackEnabled)
		if bQuickHealSwitchBackEnabled
			saveCurrentItemsForSwitchBack()
			bCurrentlyQuickHealing = true
			;debug.trace("iEquip_ThrowingPoisons quickHealFindAndEquipSpell - current queue positions stored for switch back, iPreviousLeftHandIndex: " + iPreviousLeftHandIndex + ", iPreviousRightHandIndex: " + iPreviousRightHandIndex)
		endIf
		iQuickSlotsEquipped = iEquipSlot
		if iEquipSlot < 2
			quickHealEquipSpell(iEquipSlot, containingQ, targetIndex, equippingOtherHand)
		else
			quickHealEquipSpell(1, containingQ, targetIndex, containingQ == 0, true)
			quickHealEquipSpell(0, containingQ, targetIndex, containingQ == 1)
		endIf
		bCurrentlyQuickRanged = false
		bQuickHealActionTaken = true
	endIf
	;debug.trace("iEquip_ThrowingPoisons quickHealFindAndEquipSpell end")
endFunction

function quickHealEquipSpell(int iEquipSlot, int Q, int iIndex, bool equippingOtherHand = false, bool dualCasting = false)
	;debug.trace("iEquip_ThrowingPoisons quickHealEquipSpell start - equipping healing spell to iEquipSlot: " + iEquipSlot + ", spell found in Q " + Q + " at index " + iIndex)

	if AM.bAmmoMode
		bCurrentlyQuickRanged = false
		AM.toggleAmmoMode((!bPreselectMode || !abPreselectSlotEnabled[0]), !(iEquipSlot == 1 && !dualCasting)) 	; If we're toggling out of ammo mode only equip left if we're equipping the healing spell in only the right hand
		;And if we're not in Preselect Mode we need to hide the left preselect elements
		if !bPreselectMode && !AM.bSimpleAmmoMode
			bool[] args = new bool[3]
			args[2] = true
			UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		endIf
		ammo targetAmmo = AM.currentAmmoForm as Ammo
		if WC.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
			PlayerRef.UnequipItemEx(targetAmmo)
		endIf
	endIf
	
	WC.hidePoisonInfo(iEquipSlot)
	WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
	WC.setCounterVisibility(iEquipSlot, false)
	WC.checkAndFadeLeftIcon(1, 22)
	
	int spellObject = jArray.getObj(WC.aiTargetQ[Q], iIndex)
	string spellName = jMap.getStr(spellObject, "iEquipName")

	if !equippingOtherHand
		WC.aiCurrentQueuePosition[iEquipSlot] = iIndex
		WC.asCurrentlyEquipped[iEquipSlot] = spellName
		;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
		WC.updateWidget(iEquipSlot, iIndex, true)
		;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
		if bPreselectMode && (WC.aiCurrentlyPreselected[iEquipSlot] == iIndex)
			cyclePreselectSlot(iEquipSlot, jArray.count(WC.aiTargetQ[iEquipSlot]), false)
		endIf
		WC.checkAndEquipShownHandItem(iEquipSlot, false)
	else
		WC.EH.bJustQuickDualCast = true
		WC.bBlockSwitchBackToBoundSpell = true
		int foundIndex = WC.findInQueue(iEquipSlot, spellName)
		PlayerRef.EquipSpell(jMap.getForm(spellObject, "iEquipForm") as Spell, iEquipSlot)
		int nameElement = 25 ;rightName_mc
		int iconElement = 24 ;rightIcon_mc
		if Q == 0
			nameElement = 8 ;leftName_mc
			iconElement = 7 ;leftIcon_mc
		endIf
		Float fNameAlpha = WC.afWidget_A[nameElement]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		if(iHandle)
			UICallback.PushInt(iHandle, iEquipSlot)
			UICallback.PushString(iHandle, jMap.getStr(spellObject, "iEquipIcon"))
			UICallback.PushString(iHandle, spellName)
			UICallback.PushFloat(iHandle, fNameAlpha)
			UICallback.PushFloat(iHandle, WC.afWidget_A[iconElement])
			UICallback.PushFloat(iHandle, WC.afWidget_S[iconElement])
			while bWaitingForAmmoModeAnimation
				Utility.WaitMenuMode(0.005)
			endwhile
			UICallback.Send(iHandle)
		endIf
		if WC.bNameFadeoutEnabled && !WC.abIsNameShown[iEquipSlot]
			WC.showName(iEquipSlot)
		endIf
		WC.hidePoisonInfo(iEquipSlot, true)
		WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
		WC.setCounterVisibility(iEquipSlot, false)
		if foundIndex > -1
			WC.aiCurrentQueuePosition[iEquipSlot] = foundIndex
			WC.asCurrentlyEquipped[iEquipSlot] = spellName
		endIf
		WC.bBlockSwitchBackToBoundSpell = false
	endIf
	;debug.trace("iEquip_ThrowingPoisons quickHealEquipSpell end")
endFunction/;



auto state DISABLED
	event OnBeginState()
		if bPoisonEquipped
			unequipPoison()
			switchBack()
		endIf
	endEvent


endState
