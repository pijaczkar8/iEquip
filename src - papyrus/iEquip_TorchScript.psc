
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

Actor property PlayerRef auto
Faction property PlayerFaction auto

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
float fLastMaxDuration
bool bTorchValuesChanged
float fTorchRadius

form property realTorchForm auto hidden

float fCurrentTorchLife

bool bSetInitialValues = true

bool bFirstUpdateForCurrentTorch = true
bool property bSettingLightRadius auto hidden
bool bSettingDuration
bool bFinalUpdateReceived

bool property bJustToggledTorch auto hidden
bool property bToggleTorchEquipRH = true auto hidden
bool bJustDroppedTorch

bool bPreviously2HOrRanged
int previousItemHandle = 0xFFFF
form previousItemForm
int previousLeftHandIndex = -1
string previousLeftHandName

; MCM Properties
bool property bShowTorchMeter = true auto hidden
int property iTorchMeterFillColor = 0xFFF8AC auto hidden
int property iTorchMeterFillColorDark = 0x686543 auto hidden
string property sTorchMeterFillDirection = "left" auto hidden
float property fTorchDuration = 235.0 auto hidden
bool property bFiniteTorchLife = true auto hidden
bool property bTorchDurationSettingChanged auto hidden
bool property bautoReEquipTorch = true auto hidden
bool property bRealisticReEquip = true auto hidden
float property fRealisticReEquipDelay = 2.0 auto hidden
bool property bReduceLightAsTorchRunsOut auto hidden
bool property bDropLitTorchesEnabled auto hidden
int property iDropLitTorchBehavior = 0 auto hidden
bool property bSettingsChanged auto hidden

function initialise(bool bEnabled)
	debug.trace("iEquip_TorchScript initialise start")
	if bEnabled
		GoToState("")
		WidgetRoot = WC.WidgetRoot
		RegisterForMenu("Journal Menu")
		realTorchForm = Torch01
		if !aDroppedTorches
			aDroppedTorches = new ObjectReference[4]
		endIf
		fTorchRadius = iEquip_FormExt.GetLightRadius(Torch01) as float
		fMaxTorchDuration = iEquip_FormExt.GetLightDuration(Torch01) as float - 5.0 	; Actual light duration minus 5s to allow time for torch meter flash on empty before unequipping
		if bSetInitialValues || fMaxTorchDuration < fTorchDuration
			fTorchDuration = fMaxTorchDuration
		endIf
		if fMaxTorchDuration != fLastMaxDuration
			fLastMaxDuration = fMaxTorchDuration
			if bSetInitialValues
				bSetInitialValues = false
			else
				bTorchValuesChanged = true
			endIf
		endIf
		if fCurrentTorchLife > fTorchDuration || fCurrentTorchLife == 0.0
			fCurrentTorchLife = fTorchDuration
		endIf
	else
		UnregisterForAllMenus()
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		GoToState("DISABLED")
	endIf
	debug.trace("iEquip_TorchScript initialise end")
endFunction

event OnMenuClose(string MenuName)											; This is purely to handle custom torch durations set in the MCM
	debug.trace("iEquip_TorchScript OnMenuClose start - " + MenuName + ", bTorchDurationSettingChanged: " + bTorchDurationSettingChanged)
	if bTorchDurationSettingChanged
		bSettingDuration = true
		if PlayerRef.GetEquippedItemType(0) == 11 && !PlayerRef.GetEquippedObject(0) == iEquipTorch as form		; If the player currently has a torch equipped we need to unequip it, check and change fCurrentTorchLife if required, and re-equip it
			debug.trace("iEquip_TorchScript OnMenuClose - player has a torch equipped")
			form torchForm = PlayerRef.GetEquippedObject(0)
			while Utility.IsInMenuMode()
				Utility.Wait(0.1)
			endWhile
			PlayerRef.UnequipItemEx(torchForm)
			Utility.Wait(1.0)
			If fCurrentTorchLife > fTorchDuration
				debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fTorchDuration: " + fTorchDuration + ", setting current torch life to new duration")
				fCurrentTorchLife = fTorchDuration
			endIf
			PlayerRef.EquipItemEx(torchForm, 0, false, false)
		elseIf fCurrentTorchLife > fTorchDuration 				; Otherwise we just need to adjust fCurrentTorchLife if required ready for the next equip
			debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fTorchDuration: " + fTorchDuration + ", setting current torch life to new duration")
			fCurrentTorchLife = fTorchDuration
		endIf
		Utility.Wait(0.5)
		bSettingDuration = false
		bTorchDurationSettingChanged = false
	endIf
endEvent

function onTorchRemoved(form torchForm)
	debug.trace("iEquip_TorchScript onTorchRemoved start")
	if !PlayerRef.GetEquippedItemType(0) == 11 && torchForm != iEquipTorch
		fCurrentTorchLife = fTorchDuration
		iEquip_FormExt.SetLightRadius(iEquipTorch, fTorchRadius as int)
		iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, fTorchRadius as int)
		bFirstUpdateForCurrentTorch = true
		debug.trace("iEquip_TorchScript onTorchRemoved - WC.asCurrentlyEquipped[0]: " + WC.asCurrentlyEquipped[0] + ", torchForm.GetName(): " + torchForm.GetName())
		if !bJustDroppedTorch && WC.asCurrentlyEquipped[0] == torchForm.GetName() && bautoReEquipTorch && PlayerRef.GetItemCount(torchForm) > 0
			if bRealisticReEquip
				Utility.Wait(fRealisticReEquipDelay)
			endIf
			PlayerRef.EquipItemEx(torchForm)
		endIf
		bJustDroppedTorch = false
	endIf
	debug.trace("iEquip_TorchScript onTorchRemoved end")
endfunction

function onTorchEquipped()
	debug.trace("iEquip_TorchScript onTorchEquipped start - bSettingLightRadius: " + bSettingLightRadius)
	if bSettingLightRadius
		Utility.Wait(1.0) ; Just in case the unequipped event is received after this one
		bSettingLightRadius = false
	else
		iEquip_TorchTimerSpell.SetNthEffectDuration(0, fCurrentTorchLife as int)
		PlayerRef.AddSpell(iEquip_TorchTimerSpell, false)

		form equippedTorch = PlayerRef.GetEquippedObject(0)
		if equippedTorch != iEquipTorch
			realTorchForm = equippedTorch
			fMaxTorchDuration = iEquip_FormExt.GetLightDuration(equippedTorch) as float - 5.0
			fTorchRadius = iEquip_FormExt.GetLightRadius(equippedTorch) as float
		endIf
		debug.trace("iEquip_TorchScript onTorchEquipped - equippedTorch: " + equippedTorch + " - " + equippedTorch.GetName() + ", fMaxTorchDuration: " + fMaxTorchDuration + ", fTorchRadius: " + fTorchRadius + ", fCurrentTorchLife: " + fCurrentTorchLife)

		if fCurrentTorchLife < 30.0
			if bReduceLightAsTorchRunsOut
				
				int newRadius = (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int
				
				iEquip_FormExt.SetLightRadius(iEquipTorch, newRadius)
				iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, newRadius)
				;PlayerRef.SetActorValue("Paralysis", 1)
				if !PlayerRef.IsWeaponDrawn()
					bSettingLightRadius = true
					if PlayerRef.GetItemCount(iEquipTorch) < 1
						PlayerRef.AddItem(iEquipTorch, 1, true)
					endIf
	            	PlayerRef.EquipItemEx(iEquipTorch, 0, false, false)
	            endIf
				;PlayerRef.SetActorValue("Paralysis", 0)
				;Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
				;Debug.SendAnimationEvent(PlayerRef, "WeapEquip_Out")
			endIf
			RegisterForSingleUpdate(fCurrentTorchLife - ((fCurrentTorchLife / 5) as int * 5))
		else
			RegisterForSingleUpdate(fCurrentTorchLife - 30.1)
		endIf
		
		if bShowTorchMeter	; Show torch meter if enabled
			if CM.abIsChargeMeterShown[0]
				updateTorchMeterVisibility(false)
				Utility.WaitMenuMode(0.2)
			endIf
			showTorchMeter()
		endIf
	endIf
	debug.trace("iEquip_TorchScript onTorchEquipped end")
endfunction

function onTorchUnequipped()
	debug.trace("iEquip_TorchScript onTorchUnequipped start - bSettingLightRadius: " + bSettingLightRadius + ", bSettingDuration: " + bSettingDuration)
	if !bSettingLightRadius
		debug.trace("iEquip_TorchScript onTorchUnequipped - fCurrentTorchLife: " + fCurrentTorchLife + ", elapsed time: " + TorchTimer.GetTimeElapsed())
		if bFiniteTorchLife
			fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		else
			fCurrentTorchLife = fTorchDuration
		endIf
		debug.trace("iEquip_TorchScript onTorchUnequipped - fCurrentTorchLife set to: " + fCurrentTorchLife)
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		UnregisterForUpdate()
		stopTorchMeterAnim()
		;if bShowTorchMeter && CM.abIsChargeMeterShown[0]
		;	updateTorchMeterVisibility(false)
		;endIf
		if PlayerRef.GetItemCount(iEquipTorch) > 0
			PlayerRef.RemoveItem(iEquipTorch, PlayerRef.GetItemCount(iEquipTorch), true)
		endIf
	endIf
	debug.trace("iEquip_TorchScript onTorchUnequipped end")
endfunction

function onTorchTimerExpired()
	debug.trace("iEquip_TorchScript onTorchTimerExpired start")
	;/Utility.Wait(1.0)			; Just in case the torch radius updates have stuck for some reason.
	if !bFinalUpdateReceived && !bSettingLightRadius && !bSettingDuration
		if PlayerRef.GetEquippedItemType(0) == 11 ; Torch
			form equippedTorch = PlayerRef.GetEquippedObject(0)
			if bShowTorchMeter
				startTorchMeterFlash()
				Utility.Wait(2.0)
				updateTorchMeterVisibility(false)
			endIf
			iEquip_FormExt.SetLightRadius(equippedTorch, fTorchRadius as int)
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.RemoveItem(equippedTorch)
		endIf
	endIf/;
	debug.trace("iEquip_TorchScript onTorchTimerExpired end")
endFunction

event OnUpdate()
	debug.trace("iEquip_TorchScript OnUpdate start - fCurrentTorchLife: " + fCurrentTorchLife + ", bFirstUpdateForCurrentTorch: " + bFirstUpdateForCurrentTorch)
	
	if bFirstUpdateForCurrentTorch
		bFinalUpdateReceived = false
		fCurrentTorchLife = 29.9
		bFirstUpdateForCurrentTorch = false
	else
		fCurrentTorchLife -= 5.0
	endIf

	if PlayerRef.GetEquippedItemType(0) == 11 ; Torch
		
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		
		if bReduceLightAsTorchRunsOut && fCurrentTorchLife > 0.0
			int newRadius = (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int
			debug.trace("iEquip_TorchScript OnUpdate - setting torch light radius to " + newRadius)
			
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
		
		if fCurrentTorchLife <= 0.0
			bFinalUpdateReceived = true
			if bShowTorchMeter
				startTorchMeterFlash()
				Utility.Wait(2.0)
				updateTorchMeterVisibility(false)
			endIf
			iEquip_FormExt.SetLightRadius(iEquipTorch, fTorchRadius as int)
			iEquip_FormExt.SetLightRadius(iEquipDroppedTorch, fTorchRadius as int)
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.RemoveItem(iEquipTorch, 1, true)	; Remove the fadable torch
			PlayerRef.RemoveItem(realTorchForm)			; Remove the real torch which will trigger the timer reset and re-equip
		else
			RegisterForSingleUpdate(5.0)
		endIf
	
	endIf
	debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

function toggleTorch()

	form currentItemForm = PlayerRef.GetEquippedObject(0)
	int currentItemType = PlayerRef.GetEquippedItemType(0)
	bool torchEquipped = currentItemType == 11	; Torch - this covers any torch, including the iEquipTorch used during the burnout sequence
	int targetSlot
	
	debug.trace("iEquip_TorchScript toggleTorch start - torch equipped: " + torchEquipped + ", currentItemForm: " + currentItemForm + ", currentItemType: " + currentItemType + ", bPreviously2HOrRanged: " + bPreviously2HOrRanged)
	debug.trace("iEquip_TorchScript toggleTorch - previousLeftHandIndex: " + previousLeftHandIndex + ", previousLeftHandName: " + previousLeftHandName + ", previousItemForm: " + previousItemForm + ", previousItemHandle: " + previousItemHandle)

	if torchEquipped
		
		WC.setCounterVisibility(0, false)
		if bShowTorchMeter
			updateTorchMeterVisibility(false)
		endIf

		PlayerRef.UnequipItemEx(currentItemForm)

		if bPreviously2HOrRanged
			targetSlot = 1	; Right hand
			WC.aiCurrentQueuePosition[0] = previousLeftHandIndex
			WC.asCurrentlyEquipped[0] = previousLeftHandName
			WC.updateWidget(0, previousLeftHandIndex, true)
		elseIf previousItemForm as Armor
			targetSlot = 0	; Default, for shields only
		else
			targetSlot = 2	; Left hand
		endIf

		bJustToggledTorch = true
		
		if previousItemHandle != 0xFFFF
			iEquip_InventoryExt.EquipItem(previousItemForm, previousItemHandle, PlayerRef, targetSlot)
		elseIf previousItemForm
			PlayerRef.EquipItemEx(previousItemForm, targetSlot)
		else
			WC.setSlotToEmpty(0, true, jArray.count(WC.aiTargetQ[0]) > 0)
		endIf

	elseIf PlayerRef.GetItemCount(realTorchForm) > 0
		
		WC.hidePoisonInfo(0)

		if WC.ai2HWeaponTypesAlt.Find(currentItemType) > -1
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
		bJustToggledTorch = true
		PlayerRef.EquipItemEx(realTorchForm) ; This should then be caught by EH.onObjectEquipped and trigger all the relevant widget/torch/RH stuff as required
	
	else
		debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_TO_not_noTorch"))
	endIf
	debug.trace("iEquip_TorchScript toggleTorch end")
endFunction

; Simple Drop Lit Torches - Courtesy of, and with full permission from, Snotgurg

Function DropTorch()
	debug.trace("iEquip_TorchScript DropTorch start")
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
			Utility.Wait(0.05)
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
			Utility.Wait(fRealisticReEquipDelay)
			PlayerRef.EquipItemEx(realTorchForm, 0)
		elseIf iDropLitTorchBehavior < 4																																			; Cycle left hand
			WC.cycleSlot(0, false, true)
		else 																																										; QuickShield
			PM.QuickShield(false, true)
		endIf
	endIf
	debug.trace("iEquip_TorchScript DropTorch end")
EndFunction

; Meter functions

function showTorchMeter(bool checkTimer = false)
	debug.trace("iEquip_TorchScript showTorchMeter start - checkTimer: " + checkTimer)

	if checkTimer	; Will only be true if called from refreshWidgetOnLoad
		float fTimeRemaining = fCurrentTorchLife - TorchTimer.GetTimeElapsed()
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife: " + fCurrentTorchLife + ", time remaining: " + fTimeRemaining)
		if fTimeRemaining > fTorchDuration || fTimeRemaining < 0.0
			fCurrentTorchLife = fTorchDuration
		else
			fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		endIf
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife set to: " + fCurrentTorchLife)
	endIf

	float currPercent

	debug.trace("iEquip_TorchScript showTorchMeter - setting currPercent from fTorchDuration")
	currPercent = 1.0 / fTorchDuration * fCurrentTorchLife

	debug.trace("iEquip_TorchScript showTorchMeter - currPercent: " + currPercent)

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
		debug.trace("iEquip_TorchScript showTorchMeter - got handle for .setChargeMeterPercent")
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

	debug.trace("iEquip_TorchScript showTorchMeter end")
endFunction

function startTorchMeterAnim()
	debug.trace("iEquip_TorchScript startTorchMeterAnim start - duration: " + fCurrentTorchLife)
	UI.InvokeFloat(HUD_MENU, WidgetRoot + ".leftMeter.startFillTween", fCurrentTorchLife)
	debug.trace("iEquip_TorchScript startTorchMeterAnim end")
endFunction

function stopTorchMeterAnim()
	debug.trace("iEquip_TorchScript stopChargeMeterAnim start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.stopFillTween")
	debug.trace("iEquip_TorchScript stopChargeMeterAnim end")
endFunction

function startTorchMeterFlash()
	debug.trace("iEquip_TorchScript startTorchMeterFlash start")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushInt(iHandle, 0xFF0000)
		UICallback.PushBool(iHandle, true)
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_TorchScript startTorchMeterFlash end")
endFunction

function updateTorchMeterVisibility(bool show)
	debug.trace("iEquip_TorchScript updateTorchMeterVisibility start - show: " + show)
	
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
	debug.trace("iEquip_TorchScript updateChargeMeterVisibility end")
endFunction

function updateTorchMeterOnSettingsChanged()
	debug.trace("iEquip_TorchScript updateTorchMeterOnSettingsChanged start")
	stopTorchMeterAnim()
	if CM.abIsChargeMeterShown[0]
		updateTorchMeterVisibility(false)
		Utility.WaitMenuMode(0.2)
	endIf
	showTorchMeter()
	bSettingsChanged = false
	debug.trace("iEquip_TorchScript updateTorchMeterOnSettingsChanged end")
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
