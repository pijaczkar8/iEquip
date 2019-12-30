
Scriptname iEquip_TorchScript extends Quest

import UI
import Utility
import iEquip_FormExt
import iEquip_StringExt
import iEquip_InventoryExt

iEquip_WidgetCore property WC auto
iEquip_ChargeMeters property CM auto
iEquip_ProMode property PM auto
iEquip_AmmoMode property AM auto
iEquip_PotionScript property PO auto

Actor property PlayerRef auto
Faction property PlayerFaction auto

spell property Candlelight auto

light property Torch01 auto
light property iEquipTorch auto
light property iEquipDroppedTorch auto

ObjectReference[] property aDroppedTorches auto hidden
int iCurrentDroppedTorchesIndex

spell property iEquip_TorchTimerSpell auto
ActiveMagicEffect property TorchTimer auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

float property fMaxTorchDuration = 240.0 auto hidden
float property fTorchRadius auto hidden
float property fDefaultRadius auto hidden

form property realTorchForm auto hidden

float fCurrentTorchLife

bool bFirstUpdateForCurrentTorch = true
bool property bSettingLightRadius auto hidden
;bool bSettingDuration

bool property bJustToggledTorch auto hidden
bool property bToggleTorchEquipRH = true auto hidden

bool property bJustCalledQuickLight auto hidden
bool property bQuickLightEquipRH = true auto hidden

bool bJustDroppedTorch

bool bPreviously2HOrRanged
int previousItemHandle = 0xFFFF
form previousItemForm
int previousLeftHandIndex = -1
string previousLeftHandName

bool bFirstRun = true

; MCM Properties
bool property bQuickLightPreferMagic auto hidden
bool property bQuickLightUseMagicIfNoTorch auto hidden
bool property bQuickLightConsumePotion auto hidden
bool property bShowTorchMeter = true auto hidden
int property iTorchMeterFillColor = 0xFFF8AC auto hidden
int property iTorchMeterFillColorDark = 0x686543 auto hidden
string property sTorchMeterFillDirection = "left" auto hidden
float property fTorchDuration = 235.0 auto hidden
bool property bFiniteTorchLife = true auto hidden
bool property bTorchDurationSettingChanged auto hidden
bool property bTorchRadiusSettingChanged auto hidden
bool property bautoReEquipTorch = true auto hidden
bool property bRealisticReEquip = true auto hidden
float property fRealisticReEquipDelay = 2.0 auto hidden
bool property bReduceLightAsTorchRunsOut auto hidden
bool property bDropLitTorchesEnabled auto hidden
int property iDropLitTorchBehavior = 0 auto hidden
bool property bSettingsChanged auto hidden

function initialise(bool bEnabled)
	;debug.trace("iEquip_TorchScript initialise start")
	if bEnabled
		GoToState("")
		WidgetRoot = WC.WidgetRoot
		RegisterForMenu("Journal Menu")
		realTorchForm = Torch01
		if !aDroppedTorches
			aDroppedTorches = new ObjectReference[4]
		endIf
		fTorchRadius = iEquip_FormExt.GetLightRadius(Torch01) as float
		if bFirstRun
			bFirstRun = false
			fDefaultRadius = fTorchRadius
		endIf
		fMaxTorchDuration = iEquip_FormExt.GetLightDuration(Torch01) as float - 5.0 	; Actual light duration minus 5s to allow time for torch meter flash on empty before unequipping
		if fMaxTorchDuration < fTorchDuration
			fTorchDuration = fMaxTorchDuration
		endIf

		if fCurrentTorchLife > fTorchDuration || fCurrentTorchLife == 0.0
			fCurrentTorchLife = fTorchDuration
		endIf
	else
		UnregisterForAllMenus()
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		if fDefaultRadius > 0 && iEquip_FormExt.GetLightRadius(Torch01) as float != fDefaultRadius
			iEquip_FormExt.SetLightRadius(Torch01, fDefaultRadius as int)
		endIf
		GoToState("DISABLED")
	endIf
	;debug.trace("iEquip_TorchScript initialise end")
endFunction

event OnMenuClose(string MenuName)											; This is purely to handle custom torch duration and/or radius set in the MCM
	;debug.trace("iEquip_TorchScript OnMenuClose start - " + MenuName + ", bTorchDurationSettingChanged: " + bTorchDurationSettingChanged)
	if bTorchDurationSettingChanged || bTorchRadiusSettingChanged
		;bSettingDuration = true
		if bTorchRadiusSettingChanged
			iEquip_FormExt.SetLightRadius(Torch01, fTorchRadius as int)
		endIf
		if PlayerRef.GetEquippedItemType(0) == 11 && !PlayerRef.GetEquippedObject(0) == iEquipTorch as form		; If the player currently has a torch equipped we need to unequip it, check and change fCurrentTorchLife if required, and re-equip it
			;debug.trace("iEquip_TorchScript OnMenuClose - player has a torch equipped")
			form torchForm = PlayerRef.GetEquippedObject(0)
			while IsInMenuMode()
				Wait(0.1)
			endWhile
			if bTorchRadiusSettingChanged
				bTorchRadiusSettingChanged = false
				if torchForm == Torch01 
					bSettingLightRadius = true
				endIf
			endIf
			PlayerRef.UnequipItemEx(torchForm)
			Wait(1.0)
			If fCurrentTorchLife > fTorchDuration
				;debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fTorchDuration: " + fTorchDuration + ", setting current torch life to new duration")
				fCurrentTorchLife = fTorchDuration
			endIf
			PlayerRef.EquipItemEx(torchForm, 0, false, false)
		elseIf fCurrentTorchLife > fTorchDuration 				; Otherwise we just need to adjust fCurrentTorchLife if required ready for the next equip
			;debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fTorchDuration: " + fTorchDuration + ", setting current torch life to new duration")
			fCurrentTorchLife = fTorchDuration
		endIf
		Wait(0.5)
		;bSettingDuration = false
		bTorchDurationSettingChanged = false
	endIf
endEvent

function onTorchRemoved(form torchForm)
	;debug.trace("iEquip_TorchScript onTorchRemoved start - torchForm: " + torchForm)
	if !PlayerRef.GetEquippedItemType(0) == 11 && torchForm != iEquipTorch
		fCurrentTorchLife = fTorchDuration
		iEquip_FormExt.SetLightRadius(iEquipTorch, fTorchRadius as int)
		iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, fTorchRadius as int)
		bFirstUpdateForCurrentTorch = true
		;debug.trace("iEquip_TorchScript onTorchRemoved - WC.asCurrentlyEquipped[0]: " + WC.asCurrentlyEquipped[0] + ", torchForm.GetName(): " + torchForm.GetName())
		if !bJustDroppedTorch && WC.asCurrentlyEquipped[0] == torchForm.GetName() && bautoReEquipTorch && PlayerRef.GetItemCount(torchForm) > 0
			if bRealisticReEquip
				Wait(fRealisticReEquipDelay)
			endIf
			PlayerRef.EquipItemEx(torchForm)
		endIf
		bJustDroppedTorch = false
	endIf
	;debug.trace("iEquip_TorchScript onTorchRemoved end")
endfunction

function onTorchEquipped()
	;debug.trace("iEquip_TorchScript onTorchEquipped start - bSettingLightRadius: " + bSettingLightRadius)
	if bSettingLightRadius
		Wait(1.0) ; Just in case the unequipped event is received after this one
		bSettingLightRadius = false
	else
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		bool bIsEverlight = Game.GetModName(equippedTorch.GetFormID() / 0x1000000) == "Undriel_Everlight.esp"

		if !bIsEverlight
			iEquip_TorchTimerSpell.SetNthEffectDuration(0, fCurrentTorchLife as int)
			PlayerRef.AddSpell(iEquip_TorchTimerSpell, false)

			if equippedTorch != iEquipTorch
				realTorchForm = equippedTorch
				fTorchRadius = iEquip_FormExt.GetLightRadius(equippedTorch) as float
				fMaxTorchDuration = iEquip_FormExt.GetLightDuration(equippedTorch) as float - 5.0
			endIf
			;debug.trace("iEquip_TorchScript onTorchEquipped - equippedTorch: " + equippedTorch + " - " + equippedTorch.GetName() + ", fMaxTorchDuration: " + fMaxTorchDuration + ", fTorchRadius: " + fTorchRadius + ", fCurrentTorchLife: " + fCurrentTorchLife)

			if fCurrentTorchLife < 30.0
				if bReduceLightAsTorchRunsOut
					
					int newRadius = (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int
					
					iEquip_FormExt.SetLightRadius(iEquipTorch, newRadius)
					iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, newRadius)
					if !PlayerRef.IsWeaponDrawn()
						bSettingLightRadius = true
						if PlayerRef.GetItemCount(iEquipTorch) < 1
							PlayerRef.AddItem(iEquipTorch, 1, true)
						endIf
		            	PlayerRef.EquipItemEx(iEquipTorch, 0, false, false)
		            endIf
				endIf
				RegisterForSingleUpdate(fCurrentTorchLife - ((fCurrentTorchLife / 5) as int * 5))
			else
				RegisterForSingleUpdate(fCurrentTorchLife - 30.1)
			endIf
			
			if bShowTorchMeter	; Show torch meter if enabled
				if CM.abIsChargeMeterShown[0]
					;updateTorchMeterVisibility(false)
					CM.updateChargeMeterVisibility(0, false)
					WaitMenuMode(0.2)
				endIf
				showTorchMeter()
			endIf
		else
			realTorchForm = equippedTorch
			fTorchRadius = iEquip_FormExt.GetLightRadius(equippedTorch) as float
		endIf
	endIf
	;debug.trace("iEquip_TorchScript onTorchEquipped end")
endfunction

function onTorchUnequipped()
	;debug.trace("iEquip_TorchScript onTorchUnequipped start - bSettingLightRadius: " + bSettingLightRadius + ", bSettingDuration: " + bSettingDuration + ", fCurrentTorchLife: " + fCurrentTorchLife)
	if !bSettingLightRadius
		if bFiniteTorchLife
			fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		else
			fCurrentTorchLife = fTorchDuration
		endIf
		;debug.trace("iEquip_TorchScript onTorchUnequipped - fCurrentTorchLife set to: " + fCurrentTorchLife)
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		UnregisterForUpdate()
		stopTorchMeterAnim()

		if PlayerRef.GetItemCount(iEquipTorch) > 0
			PlayerRef.RemoveItem(iEquipTorch, PlayerRef.GetItemCount(iEquipTorch), true)
		endIf
	endIf
	WaitMenuMode(0.5)
	WC.EH.GotoState("")
	;debug.trace("iEquip_TorchScript onTorchUnequipped end")
endfunction

function onTorchTimerExpired()
	;debug.trace("iEquip_TorchScript onTorchTimerExpired start")
	
	;debug.trace("iEquip_TorchScript onTorchTimerExpired end")
endFunction

event OnUpdate()
	;debug.trace("iEquip_TorchScript OnUpdate start - fCurrentTorchLife: " + fCurrentTorchLife + ", bFirstUpdateForCurrentTorch: " + bFirstUpdateForCurrentTorch)
	
	if bFirstUpdateForCurrentTorch
		fCurrentTorchLife = 29.9
		bFirstUpdateForCurrentTorch = false
	else
		fCurrentTorchLife -= 5.0
	endIf

	PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)	; Remove and reapply the spell to reset the timer so it gives the correct time elapsed value to remove from fCurrentTorchLife if the torch is unequipped during the burnout sequence
	PlayerRef.AddSpell(iEquip_TorchTimerSpell, false)

	if PlayerRef.GetEquippedItemType(0) == 11 ; Torch
		
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		
		if bReduceLightAsTorchRunsOut && fCurrentTorchLife > 0.0
			int newRadius = (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int
			;debug.trace("iEquip_TorchScript OnUpdate - setting torch light radius to " + newRadius)
			
			iEquip_FormExt.SetLightRadius(iEquipTorch, newRadius)
			iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, newRadius)
			
			if !((PlayerRef as objectReference).GetAnimationVariableBool("IsCastingRight") || (PlayerRef as objectReference).GetAnimationVariableBool("IsAttacking") || (PlayerRef as objectReference).GetAnimationVariableBool("IsBlocking") || (PlayerRef as objectReference).GetAnimationVariableBool("IsBashing"))

				bSettingLightRadius = true
				
				if PlayerRef.GetItemCount(iEquipTorch) < 1
					PlayerRef.AddItem(iEquipTorch, 1, true)
				endIf
	        	
	        	PlayerRef.EquipItemEx(iEquipTorch, 0, false, false)
	            
	            if PlayerRef.IsWeaponDrawn()
	            	int countdown = 100
	            	while !(PlayerRef as objectReference).GetAnimationVariableBool("IsEquipping") && countdown > 0
					     countdown -= 1
					     WaitMenuMode(0.015)
					     ;debug.trace("Waiting for Equip")
					endWhile

					while (PlayerRef as objectReference).GetAnimationVariableBool("IsEquipping")
					     WaitMenuMode(0.015)
					     Debug.SendAnimationEvent(PlayerRef, "WeapEquip_Out")
					     ;debug.trace("WeapEquip_Out Sent")
					endWhile
	            endIf
	        endIf
		endIf
		
		if fCurrentTorchLife <= 0.0
			if bShowTorchMeter
				startTorchMeterFlash()
				Wait(2.0)
				updateTorchMeterVisibility(false)
			endIf
			iEquip_FormExt.SetLightRadius(iEquipTorch, fTorchRadius as int)
			iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, fTorchRadius as int)
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.RemoveItem(iEquipTorch, 1, true)	; Remove the fadeable torch
			PlayerRef.RemoveItem(realTorchForm)			; Remove the real torch which will trigger the timer reset and re-equip
		else
			RegisterForSingleUpdate(5.0)
		endIf
	
	endIf
	;debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

; Called when adjusting the base torch radius from the MCM - affects all carried torches, including those carried by NPCs
function setBaseTorchRadius()
	iEquip_FormExt.SetLightRadius(Torch01, fTorchRadius as int)
	if PlayerRef.GetEquippedObject(0) == Torch01
		bSettingLightRadius = true
		PlayerRef.UnequipItemEx(Torch01)
		PlayerRef.EquipItemEx(Torch01)
	endIf
endFunction

function quickLight()

	form currentItemForm = PlayerRef.GetEquippedObject(0)
	int currentItemType = PlayerRef.GetEquippedItemType(0)
	bool torchEquipped = currentItemType == 11	; Torch - this covers any torch, including the iEquipTorch used during the burnout sequence
	bool candlelightEquipped = (currentItemType == 9 && (currentItemForm as spell) == Candlelight)
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
		
		if previousItemHandle != 0xFFFF
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

			if AM.bAmmoMode
				AM.toggleAmmoMode(true, true)
				if !AM.bSimpleAmmoMode
					bool[] args = new bool[3]
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
					args = new bool[4]
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
				endIf
			endIf

			if currentItemType == 10 ; Shield
				targetSlot = 2
			else
				targetSlot = bPreviously2HOrRanged as int
			endIf

			previousItemHandle = iEquip_InventoryExt.GetRefHandleFromWornObject(targetSlot)
			previousItemForm = currentItemForm
			bJustCalledQuickLight = true

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

; Simple Drop Lit Torches - Courtesy of, and with full permission from, Snotgurg

Function DropTorch()
	;debug.trace("iEquip_TorchScript DropTorch start")
	if bDropLitTorchesEnabled
		bJustDroppedTorch = true
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		int remainingTorches = PlayerRef.GetItemCount(realTorchForm) - 1
		int queueLength = JArray.count(WC.aiTargetQ[0])
		if remainingTorches == 0
			WC.bJustDroppedTorch = true
			queueLength -= 1
		endIf

		PlayerRef.UnequipItemEx(equippedTorch)

		if equippedTorch == iEquipTorch || (fCurrentTorchLife < 30.0 && bReduceLightAsTorchRunsOut)			; Switch to using the one with the display name so if the player wants to pick it up again it will have the same name/value/weight displayed as Torch01
			equippedTorch = iEquipDroppedTorch
		endIf

		ObjectReference DroppedTorch = PlayerRef.PlaceAtMe(equippedTorch, 1, false, true)

		ObjectReference TorchToDelete = aDroppedTorches[iCurrentDroppedTorchesIndex]
		if TorchToDelete
			TorchToDelete.Delete()
			TorchToDelete.Disable()
		endIf	
		aDroppedTorches[iCurrentDroppedTorchesIndex] = DroppedTorch
		iCurrentDroppedTorchesIndex += 1
		if iCurrentDroppedTorchesIndex == 4
			iCurrentDroppedTorchesIndex = 0
		endIf

		DroppedTorch.SetActorOwner(PlayerRef.GetActorBase())
		DroppedTorch.SetFactionOwner(PlayerFaction)
		
		Float OffsetX = 48.0 * Math.Sin(PlayerRef.GetAngleZ() - 15)
		Float OffsetY = 48.0 * Math.Cos(PlayerRef.GetAngleZ() - 15)
		Float OffsetZ = PlayerRef.GetHeight() - 32.0
		If (PlayerRef.IsSneaking())
			OffsetZ = PlayerRef.GetHeight() - 72.0
		EndIf

		If (DroppedTorch.is3DLoaded())
			DroppedTorch.MoveTo(PlayerRef, OffsetX, OffsetY, OffsetZ, false)
		Else
			DroppedTorch.MoveToIfUnloaded(PlayerRef, OffsetX, OffsetY, OffsetZ)
		EndIf

		DroppedTorch.EnableNoWait()

		Int Tries = 0 
		While(Tries < 10 && (!DroppedTorch.is3DLoaded() || !DroppedTorch.IsEnabled()))
			Wait(0.05)
			Tries += 1
		EndWhile
		
		DroppedTorch.ApplyHavokImpulse(0,0,1,5)

		PlayerRef.RemoveItem(realTorchForm, 1, true, None)
		
		if equippedTorch == iEquipDroppedTorch
			PlayerRef.RemoveItem(iEquipTorch, 1, true, None)
		endIf

		; iDropLitTorchBehaviour - 0: Do Nothing, 1: Torch/Nothing, 2: Torch/Cycle, 3: Cycle, 4: QuickShield
		if iDropLitTorchBehavior == 0 || (iDropLitTorchBehavior == 1 && remainingTorches < 1) || ((iDropLitTorchBehavior == 2 || iDropLitTorchBehavior == 3) && queueLength == 0)	; Do Nothing and set left hand to empty
			WC.setSlotToEmpty(0, false, true)
		elseIf iDropLitTorchBehavior == 1 || (iDropLitTorchBehavior == 2 && remainingTorches > 0)																					; Equip another torch
			Wait(fRealisticReEquipDelay)
			PlayerRef.EquipItemEx(realTorchForm, 0)
		elseIf iDropLitTorchBehavior < 4																																			; Cycle left hand
			WC.cycleSlot(0, false, true)
		else 																																										; QuickShield
			PM.QuickShield(false, true)
		endIf
	endIf
	;debug.trace("iEquip_TorchScript DropTorch end")
EndFunction

; Meter functions

function showTorchMeter(bool checkTimer = false)
	;debug.trace("iEquip_TorchScript showTorchMeter start - checkTimer: " + checkTimer)

	if checkTimer	; Will only be true if called from refreshWidgetOnLoad
		float fTimeRemaining = fCurrentTorchLife - TorchTimer.GetTimeElapsed()
		;debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife: " + fCurrentTorchLife + ", time remaining: " + fTimeRemaining)
		if fTimeRemaining > fTorchDuration || fTimeRemaining < 0.0
			fCurrentTorchLife = fTorchDuration
		else
			fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		endIf
		;debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife set to: " + fCurrentTorchLife)
	endIf

	float currPercent

	;debug.trace("iEquip_TorchScript showTorchMeter - setting currPercent from fTorchDuration")
	currPercent = 1.0 / fTorchDuration * fCurrentTorchLife

	;debug.trace("iEquip_TorchScript showTorchMeter - currPercent: " + currPercent)

	; Set the fill direction if different to the regular left enchantment meter fill direction setting
	if sTorchMeterFillDirection != CM.asMeterFillDirection[0]
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterFillDirection")	
		if(iHandle)
			UICallback.PushInt(iHandle, 0)
			UICallback.PushString(iHandle, sTorchMeterFillDirection)
			UICallback.Send(iHandle)
		endIf
	endIf

	; Set the starting fill level for the meter
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterPercent")
	If(iHandle)
		;debug.trace("iEquip_TorchScript showTorchMeter - got handle for .setChargeMeterPercent")
		UICallback.PushInt(iHandle, 0)
		UICallback.PushFloat(iHandle, currPercent)
		UICallback.PushInt(iHandle, iTorchMeterFillColor)
		UICallback.PushBool(iHandle, true)	; Enables gradient fill
		UICallback.PushInt(iHandle, iTorchMeterFillColorDark)
		UICallback.PushBool(iHandle, true)
		UICallback.Send(iHandle)
	endIf

	; Show the meter if not currently visible
	if !CM.abIsChargeMeterShown[0]
		updateTorchMeterVisibility(true)
	endIf

	; Start the meter fill tween
	startTorchMeterAnim()

	;debug.trace("iEquip_TorchScript showTorchMeter end")
endFunction

function startTorchMeterAnim()
	;debug.trace("iEquip_TorchScript startTorchMeterAnim start - duration: " + fCurrentTorchLife)
	UI.InvokeFloat(HUD_MENU, WidgetRoot + ".leftMeter.startFillTween", fCurrentTorchLife)
	;debug.trace("iEquip_TorchScript startTorchMeterAnim end")
endFunction

function stopTorchMeterAnim()
	;debug.trace("iEquip_TorchScript stopChargeMeterAnim start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.stopFillTween")
	;debug.trace("iEquip_TorchScript stopChargeMeterAnim end")
endFunction

function startTorchMeterFlash()
	;debug.trace("iEquip_TorchScript startTorchMeterFlash start")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushInt(iHandle, 0xFF0000)
		UICallback.PushBool(iHandle, true)
		UICallback.Send(iHandle)
	endIf
	;debug.trace("iEquip_TorchScript startTorchMeterFlash end")
endFunction

function updateTorchMeterVisibility(bool show)
	;debug.trace("iEquip_TorchScript updateTorchMeterVisibility start - show: " + show)
	
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenChargeMeterAlpha")
	
	If(iHandle)
		float targetAlpha
		if show
			;Just in case the torch meter and the queue position indicator occupy the same screen space hide the position indicator first (does nothing if not currently shown)
			UI.invokeInt(HUD_MENU, WidgetRoot + ".hideQueuePositionIndicator", 0)
			UI.setBool(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc._visible", true)
			targetAlpha = WC.afWidget_A[13]
			CM.abIsChargeMeterShown[0] = true
			CM.bTorchMeterShown = true
		else
			targetAlpha = 0.0
			CM.abIsChargeMeterShown[0] = false
			CM.bTorchMeterShown = false
		endIf
		
		UICallback.PushInt(iHandle, 0)
		UICallback.PushFloat(iHandle, targetAlpha)
		UICallback.Send(iHandle)
		
		if !show
			UI.setBool(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc._visible", false)
		endIf
	endIf
	;debug.trace("iEquip_TorchScript updateTorchMeterVisibility end")
endFunction

function updateTorchMeterOnSettingsChanged()
	;debug.trace("iEquip_TorchScript updateTorchMeterOnSettingsChanged start")
	stopTorchMeterAnim()
	if CM.abIsChargeMeterShown[0]
		updateTorchMeterVisibility(false)
		WaitMenuMode(0.2)
	endIf
	showTorchMeter()
	bSettingsChanged = false
	;debug.trace("iEquip_TorchScript updateTorchMeterOnSettingsChanged end")
endFunction

auto state DISABLED
	event OnBeginState()
		UnregisterForUpdate()
	endEvent

	function onTorchRemoved(form torchForm)
	endfunction

	function onTorchEquipped()
	endfunction

	function onTorchUnequipped()
	endfunction

	event OnUpdate()
	endEvent
endState

; Deprecated variables
float fLastMaxDuration
bool bTorchValuesChanged
bool bSetInitialValues = true