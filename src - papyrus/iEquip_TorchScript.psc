
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
	debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

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
