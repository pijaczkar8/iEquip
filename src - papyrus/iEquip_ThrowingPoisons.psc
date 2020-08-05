
Scriptname iEquip_ThrowingPoisons extends Quest

import UI
import iEquip_StringExt
import PO3_SKSEFunctions

iEquip_WidgetCore property WC auto
iEquip_ChargeMeters property CM auto
iEquip_ProMode property PM auto
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
bool bFirstPoison
bool property bPoisonEquipped auto hidden

bool property bJustUnequippedThrowingPoison auto hidden

int iPreviousLeftHandIndex
int iPreviousRightHandIndex
form fPreviousLeftHandForm
form fPreviousRightHandForm
int iPreviousRHType
bool bPreviously2H
bool bPreviouslyUnarmed

int[] aiHandEquipSlots

int property targetHand = 1 auto hidden

potion currentPoison

int targetPoison

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

; Thinking I might need to do something here so that the 'equipped poison' can show as a weapon in the Inventory Menu and can be unequipped again from there - NB Should probably do the same with the iEquipTorch
; This might be as simple as allowing the weapon to show in the Inventory, and then using the OnObjectUnequipped event in PlayerEventHandler to catch it being unequipped and remove it from the player inventory

event OnMenuOpen(string MenuName)

endEvent

event OnMenuClose(string MenuName)

endEvent

function OnThrowingPoisonKeyPressed()
	bFirstPoison = true
	if jArray.count(WC.aiTargetQ[4]) < 1				; No poisons left in the poison queue
		debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TP_not_noPoisons"))
	elseIf iThrowingPoisonBehavior == 1					; Throw & Switch Back
		saveCurrentItemsForSwitchBack()
		equipPoison()
	else 												; Toggle throwing poisons
		toggleThrowingPoisons()
	endIf
endFunction

function toggleThrowingPoisons()
	bKeepThrowing = !bKeepThrowing
	if bKeepThrowing
		saveCurrentItemsForSwitchBack()
		equipPoison()
	elseIf bPoisonEquipped
		switchBack()
	endIf
endFunction

function equipPoison()
	targetPoison = jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4])
	potion newPoison = jMap.getForm(targetPoison, "iEquipForm") as potion
	
	if newPoison
		if !currentPoison || currentPoison != newPoison 						; If we're throwing a different poison to last time update the magiceffects on the spell
			currentPoison = newPoison
			removeCurrentEffectsFromSpell()
			addPoisonEffectsToSpell()
		endIf
		
		PlayerRef.AddItem(iEquip_ThrowingPoisonWeapon, 1, true) 				; Add the throwing poison weapon
		
		if WC.bPlayerIsMounted 													; If the player is on horseback (vanilla) make sure we equip to the right hand
			targetHand = 1
		else
			targetHand = iThrowingPoisonHand
		endIf

		if AM.bAmmoMode 														; Exit Ammo Mode if we need to which will re-equip the left hand if the poison is going to the right hand
			exitAmmoMode()
		endIf
		
		PlayerRef.EquipItemEx(iEquip_ThrowingPoisonWeapon, targetHand)

		updateWidget()															; Hide all additional widget elements and copy the poison icon and name currently displayed in the poison slot to the equipped hand

		bPoisonEquipped = true

		if bPreviously2H && bFirstPoison										; If we were wielding a 2H weapon (without CGO) equip something 1H in the other hand
			equipOtherHand()
		endIf
		
	else 																		; Something went wrong and we haven't been able to get the poison form, so switch back to the previously equipped item(s)
		bKeepThrowing = false
		
		if bPoisonEquipped
			switchBack(false)
		endIf
	endIf
endFunction

function equipOtherHand()
	; Don't know if I actually want to do anything here or not...
endFunction

function exitAmmoMode()
	PM.bCurrentlyQuickRanged = false
	AM.toggleAmmoMode((!PM.bPreselectMode || !PM.abPreselectSlotEnabled[0]), targetHand == 0) 	; If we're toggling out of ammo mode only equip left if we're equipping the throwing poison in the right hand

	if !PM.bPreselectMode && !AM.bSimpleAmmoMode 												; And if we're not in Preselect Mode we need to hide the left preselect elements
		bool[] args = new bool[3]
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf

	ammo targetAmmo = AM.currentAmmoForm as Ammo
	if WC.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
endFunction

function updateWidget()
	;debug.trace("iEquip_ThrowingPoisons updateWidget start")
	WC.hidePoisonInfo(targetHand)
	WC.CM.updateChargeMeterVisibility(targetHand, false)
	WC.setCounterVisibility(targetHand, false)
	WC.checkAndFadeLeftIcon(1, 4)
	
	int nameElement = 25 ;rightName_mc
	int iconElement = 24 ;rightIcon_mc
	if targetHand == 0
		nameElement = 8 ;leftName_mc
		iconElement = 7 ;leftIcon_mc
	endIf
	
	Float fNameAlpha = WC.afWidget_A[nameElement]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	if(iHandle)
		UICallback.PushInt(iHandle, targetHand)
		UICallback.PushString(iHandle, jMap.getStr(targetPoison, "iEquipIcon"))
		UICallback.PushString(iHandle, jMap.getStr(targetPoison, "iEquipName"))
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.PushFloat(iHandle, WC.afWidget_A[iconElement])
		UICallback.PushFloat(iHandle, WC.afWidget_S[iconElement])
		while PM.bWaitingForAmmoModeAnimation
			Utility.WaitMenuMode(0.005)
		endwhile
		UICallback.Send(iHandle)
	endIf
	
	if WC.bNameFadeoutEnabled && !WC.abIsNameShown[targetHand]
		WC.showName(targetHand)
	endIf
	;debug.trace("iEquip_ThrowingPoisons updateWidget end")
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
	PlayerRef.UnequipItemEx(iEquip_ThrowingPoisonWeapon)
	bJustUnequippedThrowingPoison = true
	PlayerRef.RemoveItem(iEquip_ThrowingPoisonWeapon, 1, true)
	bPoisonEquipped = false
endFunction

function OnThrowingPoisonUnequipped()					; Only ever called from PlayerEventHandler OnObjectUnequipped if it has been unequipped manually by the player
	PlayerRef.RemoveItem(iEquip_ThrowingPoisonWeapon, 1, true)
	bPoisonEquipped = false
	bKeepThrowing = false
endFunction

function onPoisonThrown()

	unequipPoison()										; Do this first so the bottle doesn't remain visible in the player's hand at the same time as the projectile bottle appears

	; Cast the spell here
	
	bool bLastOfCurrentPoison = PlayerRef.GetItemCount(currentPoison as form) == 1
	bool bLastPoisonInQueue = jArray.count(WC.aiTargetQ[4]) == 1 && bLastOfCurrentPoison

	PlayerRef.RemoveItem(currentPoison, 1, true)		; Remove one poison from the player's inventory.  This will also trigger the poison queue to update the count and cycle forwards if the last of the current poison has just been thrown.

	if bKeepThrowing && !bLastPoisonInQueue 			; If we have toggled Throwing Poisons rather than Throw & Switch back, as long as we have at least one poison left in the queue carry on and equip the next bottle
		if bLastOfCurrentPoison
			Utility.WaitMenuMode(0.5)					; Allow for OnItemRemoved to remove the current poison from the queue and cycle on to the next				
		endIf
		bFirstPoison = false
		equipPoison()
	else 												; If we've selected Throw & Switch Back, or if we've just thrown our last poison, switch back to the previous equipped item(s)
		switchBack(false)
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


function switchBack(bool unequip = true)
	;debug.trace("iEquip_ThrowingPoisons switchBack start")
	if unequip
		unequipPoison()
	endIf

	if iPreviousLeftHandIndex != -1
		WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
		WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], iPreviousLeftHandIndex), "iEquipName")
	endIf

	if iPreviousRightHandIndex != -1
		WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
		WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(WC.aiTargetQ[1], iPreviousRightHandIndex), "iEquipName")
	endIf
	
	int Q = targetHand
	
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


auto state DISABLED
	
	event OnBeginState()
		if bPoisonEquipped
			switchBack()
		endIf
	endEvent

	function OnThrowingPoisonKeyPressed()
	endFunction

endState
