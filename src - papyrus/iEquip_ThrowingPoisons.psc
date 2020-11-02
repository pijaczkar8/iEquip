
Scriptname iEquip_ThrowingPoisons extends Quest

import UI
import iEquip_StringExt
import iEquip_InventoryExt
import PO3_SKSEFunctions

iEquip_WidgetCore property WC auto
iEquip_ChargeMeters property CM auto
iEquip_ProMode property PM auto
iEquip_AmmoMode property AM auto
iEquip_PotionScript property PO auto

Actor property PlayerRef auto
perk property Poisoner auto

weapon property iEquip_ThrowingPoisonWeapon auto
projectile property iEquip_ThrowingPoisonProjectile auto

spell property iEquip_ThrowPoison auto
magiceffect property iEquip_ThrowingPoison_ProjExpl auto

spell property iEquip_ApplyThrownPoisonA auto
spell property iEquip_ApplyThrownPoisonB auto
spell property iEquip_ApplyThrownPoisonC auto
spell property iEquip_ApplyThrownPoisonD auto
spell property iEquip_ApplyThrownPoisonE auto

spell[] aDeliverySpells

explosion property iEquip_ThrowingPoisonExplosionA auto
explosion property iEquip_ThrowingPoisonExplosionB auto
explosion property iEquip_ThrowingPoisonExplosionC auto
explosion property iEquip_ThrowingPoisonExplosionD auto
explosion property iEquip_ThrowingPoisonExplosionE auto

explosion[] aExplosions

hazard property iEquip_ThrowingPoisonHazardA auto
hazard property iEquip_ThrowingPoisonHazardB auto
hazard property iEquip_ThrowingPoisonHazardC auto
hazard property iEquip_ThrowingPoisonHazardD auto
hazard property iEquip_ThrowingPoisonHazardE auto

hazard[] aHazards

string HUD_MENU = "HUD Menu"
string WidgetRoot

; MCM Properties
bool property bThrowingPoisonsEnabled auto hidden
int property iThrowingPoisonBehavior = 0 auto hidden 				; 0 = Throw & Switch Back, 1 = Keypress Toggles (keep throwing poisons until pressed again to switch back)
int property iThrowingPoisonHand = 1 auto hidden					; 0 = Left Hand, 1 = Right Hand
float property fThrowingPoisonEffectsMagMult = 0.6 auto hidden
float property fPoisonHazardRadius = 6.0 auto hidden
int property iNumPoisonHazards = 5 auto hidden
float property fPoisonHazardDuration = 5.0 auto hidden
float property fThrowingPoisonProjectileGravity = 1.2 auto hidden

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

int targetPoison

potion currentPoison
potion property thrownPoison auto hidden

string[] asMindAlteringEffects

int iIndex

bool bCreateArrays = true

bool bLastOfCurrentPoison
bool bLastPoisonInQueue

event OnInit()
	createArrays()
	GoToState("DISABLED")
endEvent

function createArrays()
	aiHandEquipSlots = new int[2]
	aiHandEquipSlots[0] = 2
	aiHandEquipSlots[1] = 1

	asMindAlteringEffects = new string[5]
	asMindAlteringEffects[0] = "Calm"
	asMindAlteringEffects[1] = "Demoralize"
	asMindAlteringEffects[2] = "Frenzy"
	asMindAlteringEffects[3] = "Paralysis"
	asMindAlteringEffects[4] = "TurnUndead"

	aDeliverySpells = new spell[5]
	aDeliverySpells[0] = iEquip_ApplyThrownPoisonA
	aDeliverySpells[1] = iEquip_ApplyThrownPoisonB
	aDeliverySpells[2] = iEquip_ApplyThrownPoisonC
	aDeliverySpells[3] = iEquip_ApplyThrownPoisonD
	aDeliverySpells[4] = iEquip_ApplyThrownPoisonE

	aExplosions = new explosion[5]
	aExplosions[0] = iEquip_ThrowingPoisonExplosionA
	aExplosions[1] = iEquip_ThrowingPoisonExplosionB
	aExplosions[2] = iEquip_ThrowingPoisonExplosionC
	aExplosions[3] = iEquip_ThrowingPoisonExplosionD
	aExplosions[4] = iEquip_ThrowingPoisonExplosionE

	aHazards = new hazard[5]
	aHazards[0] = iEquip_ThrowingPoisonHazardA
	aHazards[1] = iEquip_ThrowingPoisonHazardB
	aHazards[2] = iEquip_ThrowingPoisonHazardC
	aHazards[3] = iEquip_ThrowingPoisonHazardD
	aHazards[4] = iEquip_ThrowingPoisonHazardE

	bCreateArrays = false
endFunction

function OnWidgetLoad()
	;debug.trace("iEquip_ThrowingPoisons OnWidgetLoad start")
	WidgetRoot = WC.WidgetRoot
		
	if bCreateArrays
		createArrays()
	endIf

	if WC.bPowerOfThreeExtenderLoaded && bThrowingPoisonsEnabled
		RegisterForMenu("InventoryMenu")
		updateSpellsOnLoad()
		GoToState("")
	else
		UnregisterForAllMenus()
		GoToState("DISABLED")
	endIf
	;debug.trace("iEquip_ThrowingPoisons OnWidgetLoad end")
endFunction

function enableThrowingPoisons()
	RegisterForMenu("InventoryMenu")
	GoToState("")
endFunction

function updateSpellsOnLoad() 							; Just in case values and effects haven't persisted through save/load
	;debug.trace("iEquip_ThrowingPoisons updateSpellsOnLoad start")
	updateProjectileGravity()
	iEquip_ThrowingPoison_ProjExpl.SetExplosion(aExplosions[iIndex])
	updatePoisonEffectsOnSpell()
	updateHazardRadius()
	updateHazardDuration()
	updateHazardLimit()
	;debug.trace("iEquip_ThrowingPoisons updateSpellsOnLoad end")
endFunction

function updateHazardRadius()
	;debug.trace("iEquip_ThrowingPoisons updateHazardRadius start - fPoisonHazardRadius: " + fPoisonHazardRadius)
	int i
	while i < 5
		SetHazardRadius(aHazards[i], fPoisonHazardRadius)
		i += 1
	endWhile
	;debug.trace("iEquip_ThrowingPoisons updateHazardRadius end")
endFunction

function updateHazardDuration()
	;debug.trace("iEquip_ThrowingPoisons updateHazardDuration start - fPoisonHazardDuration: " + fPoisonHazardDuration)
	int i
	while i < 5
		SetHazardLifetime(aHazards[i], fPoisonHazardDuration)
		i += 1
	endWhile
	;debug.trace("iEquip_ThrowingPoisons updateHazardDuration end")
endFunction

function updateHazardLimit()
	;debug.trace("iEquip_ThrowingPoisons updateHazardLimit start - iNumPoisonHazards: " + iNumPoisonHazards)
	int i
	while i < 5
		SetHazardLimit(aHazards[i], iNumPoisonHazards)
		i += 1
	endWhile
	;debug.trace("iEquip_ThrowingPoisons updateHazardLimit end")
endFunction

function updateProjectileGravity()
	;debug.trace("iEquip_ThrowingPoisons updateProjectileGravity start - fThrowingPoisonProjectileGravity: " + fThrowingPoisonProjectileGravity)
	SetProjectileGravity(iEquip_ThrowingPoisonProjectile, fThrowingPoisonProjectileGravity)
	;debug.trace("iEquip_ThrowingPoisons updateProjectileGravity end")
endFunction

function updatePoisonEffectsOnSpell()
	;debug.trace("iEquip_ThrowingPoisons updatePoisonEffectsOnSpell start")
	if currentPoison
		;debug.trace("iEquip_ThrowingPoisons updatePoisonEffectsOnSpell - currentPoison: " + currentPoison.GetName())
		removeCurrentEffectsFromSpell()
		addPoisonEffectsToSpell()
	endIf
	;debug.trace("iEquip_ThrowingPoisons updatePoisonEffectsOnSpell end")
endFunction

; For reference from PO3_SKSEFunctions - Function RemoveMagicEffectFromSpell(Spell akSpell, MagicEffect mgef, float magnitude, int area, int duration, float cost = 0.0) global native

function removeCurrentEffectsFromSpell()
	;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell start")
	spell targetSpell = aDeliverySpells[iIndex]
	;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell - targetSpell: " + targetSpell.GetName())
	int i = targetSpell.GetNumEffects()
	if i > 1
		magicEffect effectToRemove
		;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell - about to remove " + (i - 1) + " effect(s) from spell")
		while i > 1  ; It's 1 so we never try to remove the base effect in index 0 (the 0 magnitude DamageHealth effect which needed to be there in the CK to allow me to save the spell!)
		;while i > 0
			i -= 1
			effectToRemove = targetSpell.GetNthEffectMagicEffect(i)
			;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell - about to remove " + effectToRemove.GetName())
			RemoveMagicEffectFromSpell(targetSpell, effectToRemove, targetSpell.GetNthEffectMagnitude(i), targetSpell.GetNthEffectArea(i), targetSpell.GetNthEffectDuration(i))
		endWhile
		;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell end - should have just removed all current effects, current number of effects = " + targetSpell.GetNumEffects())
	else
		;debug.trace("iEquip_ThrowingPoisons removeCurrentEffectsFromSpell - spell only has the empty effect so nothing to remove")
	endIf
endFunction

; For reference from PO3_SKSEFunctions - Function AddMagicEffectToSpell(Spell akSpell, MagicEffect mgef, float magnitude, int area, int duration, float cost = 0.0, String[] conditionList = None) global native

function addPoisonEffectsToSpell()
	;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell start")
	int i
	magicEffect effectToAdd
	float fMagnitude
	int iDuration
	string[] conditionList = new string[1]

	;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell - about to add " + currentPoison.GetNumEffects() + " new effects to spell")
	while i < currentPoison.GetNumEffects()
		effectToAdd = currentPoison.GetNthEffectMagicEffect(i)
		;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell - about to process " + effectToAdd.GetName() + ", base magnitude: " + currentPoison.GetNthEffectMagnitude(i) + ", base duration: " + currentPoison.GetNthEffectDuration(i))
		if asMindAlteringEffects.Find(GetEffectArchetypeAsString(effectToAdd)) == -1				; If it is not a mind altering effect then the multiplier affects the effect magnitude
			;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell - this is not a mind altering effect so adjusting magnitude")
			fMagnitude = currentPoison.GetNthEffectMagnitude(i) * fThrowingPoisonEffectsMagMult
			iDuration = currentPoison.GetNthEffectDuration(i)
		else 																						; If it is a mind altering effect (fear, frenzy, paralysis, calm, turn undead) then the multiplier affects the effect duration
			;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell - this is a mind altering effect so adjusting duration")
			fMagnitude = currentPoison.GetNthEffectMagnitude(i)
			iDuration = (currentPoison.GetNthEffectDuration(i) * fThrowingPoisonEffectsMagMult) as int
		endIf
		;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell - about to add " + effectToAdd.GetName() + " to " + aDeliverySpells[iIndex].GetName() + ", magnitude: " + fMagnitude + ", duration: " + iDuration + ", area: " + currentPoison.GetNthEffectArea(i))
		AddMagicEffectToSpell(aDeliverySpells[iIndex], effectToAdd, fMagnitude, currentPoison.GetNthEffectArea(i), iDuration, 0.0, conditionList)
		i += 1
	endWhile
	;debug.trace("iEquip_ThrowingPoisons addPoisonEffectsToSpell end - should have just added the new effects, current number of effects = " + aDeliverySpells[iIndex].GetNumEffects())
endFunction

function OnThrowingPoisonKeyPressed()
	;debug.trace("iEquip_ThrowingPoisons OnThrowingPoisonKeyPressed start - iThrowingPoisonBehavior: " + iThrowingPoisonBehavior)
	bFirstPoison = true
	if jArray.count(WC.aiTargetQ[4]) < 1				; No poisons left in the poison queue
		debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TP_not_noPoisons"))
	elseIf iThrowingPoisonBehavior == 0					; Throw & Switch Back
		if bPoisonEquipped 								; If we haven't thrown the poison yet...
			if currentPoison != jMap.getForm(jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4]), "iEquipForm") as potion 	; If we have cycled the poison slot without throwing the equipped poison switch to the new one and update the widget
				equipPoison()
			else 																													; Otherwise switch back to the previously equipped item(s)
				switchBack()
			endIf
		else 											; We don't currently have a poison equipped so save current item(s) and equip one now
			saveCurrentItemsForSwitchBack()
			equipPoison()
		endIf
	else 												; Toggle throwing poisons
		toggleThrowingPoisons()
	endIf
	;debug.trace("iEquip_ThrowingPoisons OnThrowingPoisonKeyPressed end")
endFunction

function toggleThrowingPoisons()
	;debug.trace("iEquip_ThrowingPoisons toggleThrowingPoisons start - bKeepThrowing: " + bKeepThrowing)
	bKeepThrowing = !bKeepThrowing
	if bKeepThrowing 						; We don't currently have a poison equipped so save current item(s) and equip one now
		saveCurrentItemsForSwitchBack()
		equipPoison()
	elseIf bPoisonEquipped
		if currentPoison != jMap.getForm(jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4]), "iEquipForm") as potion 		; If we have cycled the poison slot without throwing the equipped poison switch to the new one and update the widget
			bKeepThrowing = true 																									; And set bKeepThrowing back to true
			equipPoison()
		else
			switchBack() 																											; Otherwise switch back to the previously equipped item(s)
		endIf
	endIf
	;debug.trace("iEquip_ThrowingPoisons toggleThrowingPoisons end")
endFunction

function equipPoison()
	;debug.trace("iEquip_ThrowingPoisons equipPoison start - iIndex: " + iIndex)
	targetPoison = jArray.getObj(WC.aiTargetQ[4], WC.aiCurrentQueuePosition[4])
	potion newPoison = jMap.getForm(targetPoison, "iEquipForm") as potion
	
	if newPoison
		;debug.trace("iEquip_ThrowingPoisons equipPoison - newPoison: " + newPoison.GetName())
		if !currentPoison || currentPoison != newPoison 						; If we're throwing a different poison to last time update the magiceffects on the spell
			
			if currentPoison
				;debug.trace("iEquip_ThrowingPoisons equipPoison - we're equipping a different one to " + currentPoison.GetName())
				iIndex += 1
				if iIndex == 5
					iIndex = 0
				endIf
			else
				;debug.trace("iEquip_ThrowingPoisons equipPoison - we're equipping a poison for the first time")
			endIf

			currentPoison = newPoison
			;debug.trace("iEquip_ThrowingPoisons equipPoison - currentPoison now: " + currentPoison.GetName() + " , iIndex now: " + iIndex)
			iEquip_ThrowingPoison_ProjExpl.SetExplosion(aExplosions[iIndex])
			updatePoisonEffectsOnSpell()		
		endIf
		
		if !bPoisonEquipped
			PlayerRef.AddItem(iEquip_ThrowingPoisonWeapon, 1, true) 				; Add the throwing poison weapon
			
			if WC.bPlayerIsMounted 													; If the player is on horseback (vanilla) make sure we equip to the right hand
				targetHand = 1
			else
				targetHand = iThrowingPoisonHand
			endIf

			if AM.bAmmoMode 														; Exit Ammo Mode if we need to which will re-equip the left hand if the poison is going to the right hand
				exitAmmoMode()
			endIf

			bPoisonEquipped = true
			
			PlayerRef.EquipItemEx(iEquip_ThrowingPoisonWeapon, aiHandEquipSlots[targetHand])
		endIf

		SetPoison(iEquip_ThrowingPoisonWeapon as form, GetRefHandleFromWornObject(iThrowingPoisonHand), currentPoison, 1) 	; Poison the dummy weapon so the player can't apply and waste through the inventory menu

		updateWidget()															; Hide all additional widget elements and copy the poison icon and name currently displayed in the poison slot to the equipped hand

		;/if bPreviously2H && bFirstPoison										; If we were wielding a 2H weapon (without CGO) equip something 1H in the other hand
			equipOtherHand()
		endIf/;
		
	else 																		; Something went wrong and we haven't been able to get the poison form, so switch back to the previously equipped item(s)
		bKeepThrowing = false
		
		if bPoisonEquipped
			switchBack(false)
		endIf
	endIf
	;debug.trace("iEquip_ThrowingPoisons equipPoison end")
endFunction

function equipOtherHand()
	; Don't know if I actually want to do anything here or not...
endFunction

function exitAmmoMode()
	;debug.trace("iEquip_ThrowingPoisons exitAmmoMode start")
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
	;debug.trace("iEquip_ThrowingPoisons exitAmmoMode end")
endFunction

function updateWidget()
	;debug.trace("iEquip_ThrowingPoisons updateWidget start")
	WC.hidePoisonInfo(targetHand, true)
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

	string iconName = "ThrowingPoisonRight"
	if targetHand == 0
		iconName = "ThrowingPoisonLeft"
	endIf
	
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	if(iHandle)
		UICallback.PushInt(iHandle, targetHand)
		UICallback.PushString(iHandle, iconName)
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

function unequipPoison()
	;debug.trace("iEquip_ThrowingPoisons unequipPoison start")
	bJustUnequippedThrowingPoison = true
	PlayerRef.UnequipItemEx(iEquip_ThrowingPoisonWeapon)
	PlayerRef.RemoveItem(iEquip_ThrowingPoisonWeapon, 1, true)
	bPoisonEquipped = false
	;debug.trace("iEquip_ThrowingPoisons unequipPoison end")
endFunction

function OnThrowingPoisonUnequipped(bool onWeaponsSheathed = false)					; Only ever called from PlayerEventHandler OnObjectUnequipped if it has been unequipped manually by the player, or OnPlayerMount if the player currently has a Throwing Poison equipped in the left hand
	;debug.trace("iEquip_ThrowingPoisons OnThrowingPoisonUnequipped start")
	PlayerRef.RemoveItem(iEquip_ThrowingPoisonWeapon, 1, true)
	if onWeaponsSheathed
		switchBack(false)
	endIf
	bPoisonEquipped = false
	bKeepThrowing = false
	;debug.trace("iEquip_ThrowingPoisons OnThrowingPoisonUnequipped end")
endFunction

function onPoisonRemoved(potion removedPoison) 										; Only ever called from PlayerEventHandler OnObjectRemoved if the player has manually removed the last one of a poison from inventory and we currently have a throwing poison equipped
	if removedPoison == currentPoison
		if jArray.count(WC.aiTargetQ[4]) > 0 && bKeepThrowing
			equipPoison()
		else
			switchBack()
		endIf
	endIf
endFunction

function onPoisonThrown()
	;debug.trace("iEquip_ThrowingPoisons onPoisonThrown start - explosion currently set on iEquip_ThrowingPoison_ProjExpl: " + iEquip_ThrowingPoison_ProjExpl.GetExplosion().GetName())
	unequipPoison()										; Do this first so the bottle doesn't remain visible in the player's hand at the same time as the projectile bottle appears

	iEquip_ThrowPoison.Cast(PlayerRef)
	
	bLastOfCurrentPoison = PlayerRef.GetItemCount(currentPoison as form) == 1
	bLastPoisonInQueue = jArray.count(WC.aiTargetQ[4]) == 1 && bLastOfCurrentPoison

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
	;debug.trace("iEquip_ThrowingPoisons onPoisonThrown end")
endFunction

function saveCurrentItemsForSwitchBack()
	;debug.trace("iEquip_ThrowingPoisons saveCurrentItemsForSwitchBack start")
	int targetObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
	
	fPreviousLeftHandForm = PlayerRef.GetEquippedObject(0)
	if fPreviousLeftHandForm && (fPreviousLeftHandForm == jMap.getForm(targetObject, "iEquipForm") && jMap.getInt(targetObject, "iEquipTempItem") == 0)
		iPreviousLeftHandIndex = WC.aiCurrentQueuePosition[0]
	else
		iPreviousLeftHandIndex = -1
	endIf

	targetObject = jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1])

	fPreviousRightHandForm = PlayerRef.GetEquippedObject(1)
	if fPreviousRightHandForm && (fPreviousRightHandForm == jMap.getForm(targetObject, "iEquipForm") && jMap.getInt(targetObject, "iEquipTempItem") == 0)
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


function switchBack(bool unequip = true, bool switchingHands = false)
	;debug.trace("iEquip_ThrowingPoisons switchBack start")
	if unequip
		unequipPoison()
	endIf

	int Q = targetHand

	if switchingHands
		Q = (Q + 1) % 2
	endIf
	
	if bPreviously2H
		Q = 2
	endIf

	if Q != 1 && iPreviousLeftHandIndex != -1
		WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
		WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], iPreviousLeftHandIndex), "iEquipName")
	endIf

	if Q > 0 && iPreviousRightHandIndex != -1
		WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
		WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(WC.aiTargetQ[1], iPreviousRightHandIndex), "iEquipName")
	endIf
	
	if bPreviouslyUnarmed && !switchingHands
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
				if !unequip
					WC.UnequipHand(Q)
				endIf
				WC.setSlotToEmpty(Q, false, jArray.count(WC.aiTargetQ[Q]) > 0)
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
	bKeepThrowing = false
	;debug.trace("iEquip_ThrowingPoisons switchBack end")
endFunction

function switchHands()
	;debug.trace("iEquip_ThrowingPoisons switchHands start")
	if !(WC.bPlayerIsMounted && iThrowingPoisonHand == 0)

		targetHand = iThrowingPoisonHand
		int prevHand = (iThrowingPoisonHand + 1) % 2

		bJustUnequippedThrowingPoison = true
		PlayerRef.UnequipItemEx(iEquip_ThrowingPoisonWeapon)
		PlayerRef.EquipItemEx(iEquip_ThrowingPoisonWeapon, aiHandEquipSlots[iThrowingPoisonHand])
		updateWidget()
		
		if bPreviously2H
			WC.setSlotToEmpty(prevHand, false, jArray.count(WC.aiTargetQ[prevHand]) > 0)
		else
			switchBack(false, true)
		endIf
	else
		switchBack(true, true)
	endIf
	;debug.trace("iEquip_ThrowingPoisons switchHands end")
endFunction

auto state DISABLED
	
	event OnBeginState()
		if bPoisonEquipped
			switchBack()
		endIf
	endEvent

	function OnThrowingPoisonKeyPressed()
		if !WC.bPowerOfThreeExtenderLoaded
			debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TP_not_poExtenderNoLoaded"))
		endIf
	endFunction

endState
