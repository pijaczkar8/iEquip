
Scriptname iEquip_TorchScript extends Quest

import UI
import Utility
import iEquip_FormExt

iEquip_WidgetCore property WC auto
iEquip_ChargeMeters property CM auto
iEquip_ProMode property PM auto

Actor property PlayerRef auto
Faction property PlayerFaction auto

light property Torch01 auto

spell property iEquip_TorchTimerSpell auto
ActiveMagicEffect property TorchTimer auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

float fTorchDuration = 235.0
float fTorchRadius

bool bGetInitialValues = true

float fCurrentTorchLife

bool bFirstUpdateForCurrentTorch = true
bool bSettingLightRadius
bool bSettingDuration
bool bFinalUpdateReceived
bool bJustDroppedTorch

; MCM Properties
bool property bShowTorchMeter = true auto hidden
int property iTorchMeterFillColor = 0xFFF8AC auto hidden
int property iTorchMeterFillColorDark = 0x686543 auto hidden
string property sTorchMeterFillDirection = "left" auto hidden
bool property bCustomTorchDuration auto hidden
float property fCustomTorchDuration = 235.0 auto hidden
bool property bCustomDurationSettingsChanged auto hidden
bool property bautoReEquipTorch = true auto hidden
bool property bRealisticReEquip = true auto hidden
float property fRealisticReEquipDelay = 2.0 auto hidden
bool property bFiniteTorchLife = true auto hidden
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
		if bGetInitialValues
			fTorchDuration = iEquip_FormExt.GetLightDuration(Torch01) as float - 5.0 	; Actual light duration minus 5s to allow time for torch meter flash on empty before unequipping
			fTorchRadius = iEquip_FormExt.GetLightRadius(Torch01) as float
			bGetInitialValues = false
		endIf
		if fCurrentTorchLife == 0.0
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
	debug.trace("iEquip_TorchScript OnMenuClose start - " + MenuName + ", bCustomDurationSettingsChanged: " + bCustomDurationSettingsChanged)
	if bCustomDurationSettingsChanged
		if bCustomTorchDuration && fCustomTorchDuration < fTorchDuration 	; If the default duration for the torch is shorter then the MCM setting then do nothing and continue to use the default value
			debug.trace("iEquip_TorchScript OnMenuClose - setting custom torch duration")
			bSettingDuration = true
			if PlayerRef.GetEquippedItemType(0) == 11						; If the player currently has a torch equipped we need to unequip it, check and change fCurrentTorchLife if required, and re-equip it
				debug.trace("iEquip_TorchScript OnMenuClose - player has a torch equipped")
				form torchForm = PlayerRef.GetEquippedObject(0)
				while Utility.IsInMenuMode()
					Utility.Wait(0.1)
				endWhile
				PlayerRef.UnequipItemEx(torchForm)
				Utility.Wait(1.0)
				If fCurrentTorchLife > fCustomTorchDuration
					debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fCustomTorchDuration: " + fCustomTorchDuration + ", setting current torch life to new duration")
					fCurrentTorchLife = fCustomTorchDuration
				endIf
				PlayerRef.EquipItemEx(torchForm, 0, false, false)
			elseIf fCurrentTorchLife > fCustomTorchDuration 				; Otherwise we just need to adjust fCurrentTorchLife if required ready for the next equip
				debug.trace("iEquip_TorchScript OnMenuClose - fCurrentTorchLife: " + fCurrentTorchLife + ", fCustomTorchDuration: " + fCustomTorchDuration + ", setting current torch life to new duration")
				fCurrentTorchLife = fCustomTorchDuration
			endIf
			Utility.Wait(0.5)
			bSettingDuration = false
		endIf
		bCustomDurationSettingsChanged = false
	endIf
endEvent

function onTorchRemoved(form torchForm)
	debug.trace("iEquip_TorchScript onTorchRemoved start")
	if !PlayerRef.GetEquippedItemType(0) == 11
		if bCustomTorchDuration && fCustomTorchDuration < fTorchDuration
			fCurrentTorchLife = fCustomTorchDuration
		else
			fCurrentTorchLife = fTorchDuration
		endIf
		iEquip_FormExt.SetLightRadius(torchForm, fTorchRadius as int)
		bFirstUpdateForCurrentTorch = true
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
	debug.trace("iEquip_TorchScript onTorchEquipped start")
	if bSettingLightRadius
		Utility.Wait(1.0) ; Just in case the unequipped event is received after this one
		bSettingLightRadius = false
	else
		iEquip_TorchTimerSpell.SetNthEffectDuration(0, fCurrentTorchLife as int)
		PlayerRef.AddSpell(iEquip_TorchTimerSpell, false)

		form equippedTorch = PlayerRef.GetEquippedObject(0)
		;iEquip_FormExt.ResetLightRadius(equippedTorch)
		fTorchDuration = iEquip_FormExt.GetLightDuration(equippedTorch) as float - 5.0
		fTorchRadius = iEquip_FormExt.GetLightRadius(equippedTorch) as float

		debug.trace("iEquip_TorchScript onTorchEquipped - equippedTorch: " + equippedTorch + " - " + equippedTorch.GetName() + ", fTorchDuration: " + fTorchDuration + ", fTorchRadius: " + fTorchRadius + ", fCurrentTorchLife: " + fCurrentTorchLife)

		if fCurrentTorchLife < 30.0
			if bReduceLightAsTorchRunsOut
				bSettingLightRadius = true
				iEquip_FormExt.SetLightRadius(equippedTorch, (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int)
				PlayerRef.UnequipItemEx(equippedTorch)
				PlayerRef.EquipItemEx(equippedTorch, 0, false, false)
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
		fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		debug.trace("iEquip_TorchScript onTorchUnequipped - fCurrentTorchLife set to: " + fCurrentTorchLife)
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		UnregisterForUpdate()
		stopTorchMeterAnim()
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
	debug.trace("iEquip_TorchScript OnUpdate start - fCurrentTorchLife: " + fCurrentTorchLife)
	
	if bFirstUpdateForCurrentTorch
		bFinalUpdateReceived = false
		fCurrentTorchLife = 29.9
		bFirstUpdateForCurrentTorch = false
	else
		fCurrentTorchLife -= 5.0
	endIf

	if PlayerRef.GetEquippedItemType(0) == 11 ; Torch
		
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		
		if bReduceLightAsTorchRunsOut
			debug.trace("iEquip_TorchScript OnUpdate - setting torch light radius to " + (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int)
			bSettingLightRadius = true
			iEquip_FormExt.SetLightRadius(equippedTorch, (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int)
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.EquipItemEx(equippedTorch, 0, false, false)
		endIf
		
		if fCurrentTorchLife <= 0.0
			bFinalUpdateReceived = true
			if bShowTorchMeter
				startTorchMeterFlash()
				Utility.Wait(2.0)
				updateTorchMeterVisibility(false)
			endIf
			iEquip_FormExt.SetLightRadius(equippedTorch, fTorchRadius as int)
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.RemoveItem(equippedTorch)
		else
			RegisterForSingleUpdate(5.0)
		endIf
	
	endIf
	debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

; Simple Drop Lit Torches - Courtesy of, and with full permission from, Snotgurg

Function DropTorch()
	if bDropLitTorchesEnabled
		bJustDroppedTorch = true
		WC.bJustDroppedTorch = true
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		int remainingTorches = PlayerRef.GetItemCount(equippedTorch) - 1
		int queueLength = JArray.count(WC.aiTargetQ[0])
		if remainingTorches == 0
			queueLength -= 1
		endIf

		PlayerRef.UnequipItemEx(equippedTorch)
		PlayerRef.RemoveItem(equippedTorch, 1, true, None)

		ObjectReference DroppedTorch = PlayerRef.PlaceAtMe(equippedTorch, 1, false, true)

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

		if iDropLitTorchBehavior == 0 || (iDropLitTorchBehavior == 1 && remainingTorches < 1) || (iDropLitTorchBehavior == 2 || iDropLitTorchBehavior == 3 && queueLength == 0)		; Do Nothing and set left hand to empty
			WC.setSlotToEmpty(0, false, true)
		elseIf iDropLitTorchBehavior == 1 || (iDropLitTorchBehavior == 2 && remainingTorches > 0)																					; Equip another torch
			Utility.Wait(fRealisticReEquipDelay)
			PlayerRef.EquipItemEx(equippedTorch, 0)
		elseIf iDropLitTorchBehavior < 4																																			; Cycle left hand
			WC.cycleSlot(0, false, true)
		else 																																										; QuickShield
			PM.QuickShield(false, true)
		endIf
	endIf
EndFunction

; Meter functions

function showTorchMeter(bool checkTimer = false)
	debug.trace("iEquip_TorchScript showTorchMeter start - checkTimer: " + checkTimer)

	if checkTimer	; Will only be true if called from refreshWidgetOnLoad
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife: " + fCurrentTorchLife + ", elapsed time: " + TorchTimer.GetTimeElapsed())
		fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife set to: " + fCurrentTorchLife)
	endIf

	float currPercent

	if bCustomTorchDuration && fCustomTorchDuration < fTorchDuration
		debug.trace("iEquip_TorchScript showTorchMeter - setting currPercent from fCustomTorchDuration")
		currPercent = 1.0 / fCustomTorchDuration * fCurrentTorchLife
	else
		debug.trace("iEquip_TorchScript showTorchMeter - setting currPercent from fTorchDuration")
		currPercent = 1.0 / fTorchDuration * fCurrentTorchLife
	endIf 

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
	UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.resumeFillTween") ; Just in case
	debug.trace("iEquip_TorchScript startTorchMeterAnim end")
endFunction

function stopTorchMeterAnim()
	debug.trace("iEquip_TorchScript stopChargeMeterAnim start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.resumeFillTween") ; Just in case
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
		else
			targetAlpha = 0.0
			CM.abIsChargeMeterShown[0] = false
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
