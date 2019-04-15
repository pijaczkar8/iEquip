Scriptname iEquip_TorchTimerEffectScript extends activemagiceffect Hidden

import UI
import Utility

iEquip_WidgetCore property WC auto
iEquip_TorchScript property TO Auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

bool bTweenPaused

Float function getElapsedTime()
	return self.GetTimeElapsed()
endFunction

Event OnPlayerLoadGame()
	debug.trace("iEquip_TorchTimerEffectScript OnPlayerLoadGame start")
	WidgetRoot = WC.WidgetRoot
	TO.TorchTimer = self 	; Just in case this has been lost between save/reload
	debug.trace("iEquip_TorchTimerEffectScript OnPlayerLoadGame end")
endEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	debug.trace("iEquip_TorchTimerEffectScript OnEffectStart start")
	WidgetRoot = WC.WidgetRoot
	RegisterForAllMenus()
	TO.TorchTimer = self
	debug.trace("iEquip_TorchTimerEffectScript OnEffectStart end")
endEvent

Event OnMenuOpen(String MenuName)
	if TO.bShowTorchMeter
		; Check if time is paused in menu and if so pause the meter fill animation
	    Float TimePassed = GetTimeElapsed()
	    Utility.WaitMenuMode(0.2)
	    if TimePassed < (GetTimeElapsed() + 0.2)
	    	UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.pauseFillTween")
			bTweenPaused = true
	    endIf
	endIf
EndEvent

Event OnMenuClose(String MenuName)
    ; Resume the meter fill animation if it was stopped
    if bTweenPaused && !Utility.IsInMenuMode()
		UI.Invoke(HUD_MENU, WidgetRoot + ".leftMeter.resumeFillTween")
		bTweenPaused = false
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	debug.trace("iEquip_TorchTimerEffectScript OnEffectFinish start")
	TO.onTorchTimerExpired()
	UnregisterForAllMenus()
	debug.trace("iEquip_TorchTimerEffectScript OnEffectFinish end")
endEvent

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

