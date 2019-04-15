
Scriptname iEquip_TorchScript extends Quest

import UI
import Utility
import iEquip_FormExt

iEquip_WidgetCore Property WC Auto
iEquip_ChargeMeters Property CM Auto

Actor Property PlayerRef Auto

light property Torch01 auto

spell property iEquip_TorchTimerSpell auto
ActiveMagicEffect property TorchTimer auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

float fTorchDuration = 240.0
float fTorchRadius

bool bGetInitialValues = true

float fCurrentTorchLife

bool bFirstUpdateForCurrentTorch = true
bool bSettingLightRadius
bool bTweenPaused

; MCM Properties
bool property bShowTorchMeter = true auto hidden
int property iTorchMeterFillColor = 0xFFF8AC auto hidden
int property iTorchMeterFillColorDark = 0x686543 auto hidden
string property sTorchMeterFillDirection = "left" auto hidden
bool property bAutoReEquipTorch = true auto hidden
bool property bRealisticReEquip = true auto hidden
float property fRealisticReEquipDelay = 2.0 auto hidden
bool property bFiniteTorchLife = true auto hidden
bool property bReduceLightAsTorchRunsOut auto hidden
bool property bSettingsChanged auto hidden

function initialise(bool bEnabled)
	debug.trace("iEquip_TorchScript initialise start")
	if bEnabled
		GoToState("")
		WidgetRoot = WC.WidgetRoot
		if bGetInitialValues
			fTorchDuration = iEquip_FormExt.GetLightDuration(Torch01) as float
			fTorchRadius = iEquip_FormExt.GetLightRadius(Torch01) as float
			bGetInitialValues = false
		endIf
		if fCurrentTorchLife == 0.0
			fCurrentTorchLife = fTorchDuration
		endIf
		RegisterForAllMenus()
	else
		PlayerRef.RemoveSpell(iEquip_TorchTimerSpell)
		UnregisterForAllMenus()
		GoToState("DISABLED")
	endIf
	debug.trace("iEquip_TorchScript initialise end")
endFunction

function onTorchRemoved(form torchForm)
	debug.trace("iEquip_TorchScript onTorchRemoved start")
	if !PlayerRef.GetEquippedItemType(0) == 11
		fCurrentTorchLife = fTorchDuration
		bFirstUpdateForCurrentTorch = true
		if WC.asCurrentlyEquipped[0] == torchForm.GetName() && bAutoReEquipTorch && PlayerRef.GetItemCount(torchForm) > 0
			if bRealisticReEquip
				Utility.Wait(fRealisticReEquipDelay)
			endIf
			PlayerRef.EquipItemEx(torchForm)
		endIf
	endIf
	debug.trace("iEquip_TorchScript onTorchRemoved end")
endfunction

function onTorchEquipped()
	debug.trace("iEquip_TorchScript onTorchEquipped start")
	if bSettingLightRadius
		bSettingLightRadius = false
	else
		iEquip_TorchTimerSpell.SetNthEffectDuration(0, fCurrentTorchLife as int)
		PlayerRef.AddSpell(iEquip_TorchTimerSpell, false)

		form equippedTorch = PlayerRef.GetEquippedObject(0)
		iEquip_FormExt.ResetLightRadius(equippedTorch)
		fTorchDuration = iEquip_FormExt.GetLightDuration(equippedTorch) as float
		fTorchRadius = iEquip_FormExt.GetLightRadius(equippedTorch) as float

		debug.trace("iEquip_TorchScript onTorchEquipped - equippedTorch: " + equippedTorch + " - " + equippedTorch.GetName() + ", fTorchDuration: " + fTorchDuration + ", fTorchRadius: " + fTorchRadius + ", fCurrentTorchLife: " + fCurrentTorchLife)

		if fCurrentTorchLife < 30.0
			if bReduceLightAsTorchRunsOut
				bSettingLightRadius = true
				PlayerRef.UnequipItemEx(equippedTorch)
				iEquip_FormExt.SetLightRadius(equippedTorch, (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int)
				PlayerRef.EquipItemEx(equippedTorch)
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
	debug.trace("iEquip_TorchScript onTorchUnequipped start")
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
	
	debug.trace("iEquip_TorchScript onTorchTimerExpired end")
endFunction

event OnUpdate()
	debug.trace("iEquip_TorchScript OnUpdate start - fCurrentTorchLife: " + fCurrentTorchLife)
	
	if bFirstUpdateForCurrentTorch
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
			PlayerRef.UnequipItemEx(equippedTorch)
			iEquip_FormExt.SetLightRadius(equippedTorch, (fTorchRadius * (fCurrentTorchLife / 5 + 1) as int * 0.15) as int)
			PlayerRef.EquipItemEx(equippedTorch)
		endIf
		
		if fCurrentTorchLife <= 0.0
			if bShowTorchMeter
				startTorchMeterFlash()
				updateTorchMeterVisibility(false)
			endIf
			PlayerRef.UnequipItemEx(equippedTorch)
			PlayerRef.RemoveItem(equippedTorch)
		else
			RegisterForSingleUpdate(5.0)
		endIf
	
	endIf
	debug.trace("iEquip_TorchScript OnUpdate end")
endEvent

; Meter functions

function showTorchMeter(bool checkTimer = false)
	debug.trace("iEquip_TorchScript showTorchMeter start - checkTimer: " + checkTimer)

	if checkTimer	; Will only be true if called from refreshWidgetOnLoad
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife: " + fCurrentTorchLife + ", elapsed time: " + TorchTimer.GetTimeElapsed())
		fCurrentTorchLife -= TorchTimer.GetTimeElapsed()
		debug.trace("iEquip_TorchScript showTorchMeter - fCurrentTorchLife set to: " + fCurrentTorchLife)
	endIf

	float currPercent = 1.0 / fTorchDuration * fCurrentTorchLife

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

event OnMenuOpen(string _sCurrentMenu)
	if PlayerRef.GetEquippedItemType(0) == 11 && bShowTorchMeter
		UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.pauseFillTween")
		bTweenPaused = true
	endIf
endEvent

event OnMenuClosed(string _sCurrentMenu)
	if bTweenPaused && !Utility.IsInMenuMode()
		UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.resumeFillTween")
		bTweenPaused = false
	endIf
endEvent

function startTorchMeterAnim()
	debug.trace("iEquip_TorchScript startTorchMeterAnim start")
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
		UICallback.PushInt(iHandle, -1)
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

function RegisterForAllMenus()
    RegisterForMenu("BarterMenu")
    RegisterForMenu("Book Menu")
    RegisterForMenu("Console")
    RegisterForMenu("Console Native UI Menu")
    RegisterForMenu("ContainerMenu")
    RegisterForMenu("Crafting Menu")
    ;RegisterForMenu("Credits Menu")
    ;RegisterForMenu("Cursor Menu")
    ;RegisterForMenu("Debug Text Menu")
    RegisterForMenu("Dialogue Menu")
    ;RegisterForMenu("Fader Menu")
    RegisterForMenu("FavoritesMenu")
    RegisterForMenu("GiftMenu")
    ;RegisterForMenu("HUD Menu")
    RegisterForMenu("InventoryMenu")
    RegisterForMenu("Journal Menu")
    ;RegisterForMenu("Kinect Menu")
    RegisterForMenu("LevelUp Menu")
    RegisterForMenu("Loading Menu")
    RegisterForMenu("Lockpicking Menu")
    RegisterForMenu("MagicMenu")
    RegisterForMenu("Main Menu")
    RegisterForMenu("MapMenu")
    RegisterForMenu("MessageBoxMenu")
    ;RegisterForMenu("Mist Menu")
    ;RegisterForMenu("Overlay Interaction Menu")
    ;RegisterForMenu("Overlay Menu")
    ;RegisterForMenu("Quantity Menu")
    RegisterForMenu("RaceSex Menu")
    RegisterForMenu("Sleep/Wait Menu")
    RegisterForMenu("StatsMenu")
    ;RegisterForMenu("TitleSequence Menu")
    ;RegisterForMenu("Top Menu")
    RegisterForMenu("Training Menu")
    RegisterForMenu("Tutorial Menu")
    RegisterForMenu("TweenMenu")
endfunction

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
