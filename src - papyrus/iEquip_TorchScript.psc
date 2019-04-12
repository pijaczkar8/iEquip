
Scriptname iEquip_TorchScript extends Quest

import iEquip_FormExt

iEquip_WidgetCore Property WC Auto
iEquip_ChargeMeters Property CM Auto
;iEquip_TorchFadeHandler Property TF Auto

Actor Property PlayerRef Auto

light property Torch01 auto
;light property iEquipTorch01 auto

float fTorchDuration
float fTorchRadius

float fGameTimeOnEquip
float fCurrentTorchLife
float property fSecondsInADay = 86400.0 autoReadonly hidden

; MCM Properties
bool property bShowTorchMeter = true auto hidden
int property iTorchMeterFillColor = 0xFFF8AC auto hidden
string property sTorchMeterFillDirection = "left" auto hidden
bool property bAutoReEquipTorch = true auto hidden
bool property bRealisticReEquip = true auto hidden
float property fRealisticReEquipDelay = 2.0 auto hidden
bool property bFiniteTorchLife = true auto hidden
bool property bReduceLightAsTorchRunsOut auto hidden

function initialise(bool bEnabled)
	debug.trace("iEquip_TorchScript initialise start")
	if bEnabled
		GoToState("")
		;/fTorchDuration = GetTorchDuration(Torch01)
		fTorchRadius = GetTorchRadius(Torch01)
		if fCurrentTorchLife == 0.0
			fCurrentTorchLife = fTorchDuration
		endIf/;
	else
		GoToState("DISABLED")
	endIf
	debug.trace("iEquip_TorchScript initialise end")
endFunction

function onTorchRemoved()
	debug.trace("iEquip_TorchScript onTorchRemoved start")
	fCurrentTorchLife = fTorchDuration
	if bAutoReEquipTorch && PlayerRef.GetItemCount(Torch01) > 0
		if bRealisticReEquip
			Utility.Wait(fRealisticReEquipDelay)
		endIf
		PlayerRef.EquipItemEx(Torch01)
	endIf
	debug.trace("iEquip_TorchScript onTorchRemoved end")
endfunction

function onTorchEquipped()
	debug.trace("iEquip_TorchScript onTorchEquipped start")
	fGameTimeOnEquip = Utility.GetCurrentGameTime()
	RegisterForSingleUpdate(fCurrentTorchLife)
	
	if bShowTorchMeter	; Show torch meter if enabled
		
	endIf
	
	if bReduceLightAsTorchRunsOut && fCurrentTorchLife < 30.0
		;TF.BeginTorchFade(fTorchRadius, fCurrentTorchLife)
	else
		;TF.UnregisterForTorchFadeUpdate()
		;ResetTorchRadius(Torch01)
	endIf
	debug.trace("iEquip_TorchScript onTorchEquipped end")
endfunction

function onTorchUnequipped()
	debug.trace("iEquip_TorchScript onTorchUnequipped start")
	stopTorchMeterAnim()
	fCurrentTorchLife = fCurrentTorchLife - (fSecondsInADay * (Utility.GetCurrentGameTime() - fGameTimeOnEquip))
	UnregisterForUpdate()
	debug.trace("iEquip_TorchScript onTorchUnequipped end")
endfunction

event OnUpdate()
	debug.trace("iEquip_TorchScript OnUpdate start")
	if PlayerRef.GetEquippedItemType(0) == 11 ; Torch
		form equippedTorch = PlayerRef.GetEquippedObject(0)
		PlayerRef.UnequipItemEx(equippedTorch)
		PlayerRef.RemoveItem(equippedTorch)
	endIf
	startTorchMeterFlash()
	updateTorchMeterVisibility(false)
	debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

; Meter functions

function showTorchMeter()
	debug.trace("iEquip_TorchScript showTorchMeter start")

	float currPercent = ((100 / fTorchDuration * fCurrentTorchLife) as int) as float

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
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, currPercent)
		UICallback.PushInt(iHandle, iTorchMeterFillColor)
		UICallback.PushBool(iHandle, true)	; Enables gradient fill
		UICallback.PushInt(iHandle, 0x686543)
		UICallback.PushBool(iHandle, true)
		UICallback.Send(iHandle)
	endIf

	; Show the meter if not currently visible
	if !abIsChargeMeterShown[Q]
		updateChargeMeterVisibility(Q, true)
	endIf

	; Start the meter fill tween
	startTorchMeterAnim()

	debug.trace("iEquip_TorchScript showTorchMeter end")
endFunction

function startTorchMeterAnim()
	debug.trace("iEquip_TorchScript startTorchMeterAnim start")
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".startTorchMeterFillTween", fCurrentTorchLife)
	debug.trace("iEquip_TorchScript startTorchMeterAnim end")
endIf

function stopChargeMeterAnim()
	debug.trace("iEquip_TorchScript stopChargeMeterAnim start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".stopTorchMeterFillTween")
	debug.trace("iEquip_TorchScript stopChargeMeterAnim end")
endIf

function startTorchMeterFlash()
	debug.trace("iEquip_TorchScript startTorchMeterFlash start")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushInt(iHandle, iFlashColor)
		UICallback.PushBool(iHandle, false)
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
			abIsChargeMeterShown[0] = true
		else
			targetAlpha = 0.0
			abIsChargeMeterShown[0] = false
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

auto state DISABLED
	event OnBeginState()
		UnregisterForUpdate()
	endEvent

	function onTorchRemoved()
	endfunction

	function onTorchEquipped()
	endfunction

	function onTorchUnequipped()
	endfunction

	event OnUpdate()
	endEvent
endState
