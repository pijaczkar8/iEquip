ScriptName iEquip_KeyHandler extends Quest
;This script sets up and handles all the key assignments and keypress actions

import Input
Import UI

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_RechargeScript Property RC Auto
iEquip_MCM Property MCM Auto

Actor Property PlayerRef  Auto

Int WaitingKeyCode = 0
Int iMultiTap = 0

;Main gameplay keys
Int Property iEquip_shoutKey = 21 Auto ;Y
Int Property iEquip_leftKey = 34 Auto ;G
Int Property iEquip_rightKey = 35 Auto ;H
Int Property iEquip_consumableKey = 48 Auto ;B
Int Property iEquip_utilityKey = 29 Auto ;Left Ctrl - Active in all modes

;Edit Mode Keys
Int Property iEquip_EditNextKey = 55 Auto ;Num *
Int Property iEquip_EditPrevKey = 181 Auto ;Num /
Int Property iEquip_EditUpKey = 200 Auto ;Up arrow
Int Property iEquip_EditDownKey = 208 Auto ;Down arrow
Int Property iEquip_EditRightKey = 205 Auto ;Right arrow
Int Property iEquip_EditLeftKey = 203 Auto ;Left arrow
Int Property iEquip_EditScaleUpKey = 78 Auto ;Num +
Int Property iEquip_EditScaleDownKey = 74 Auto ;Num -
Int Property iEquip_EditDepthKey  = 72 Auto ;Num 8
Int Property iEquip_EditRotateKey  = 79 Auto ;Num 1
Int Property iEquip_EditTextKey = 80 Auto ;Num 2
Int Property iEquip_EditAlphaKey = 81 Auto ;Num 3
Int Property iEquip_EditRulersKey = 75 Auto ;Num 4
Int Property iEquip_EditResetKey = 82 Auto ;Num 0
Int Property iEquip_EditLoadPresetKey = 76 Auto ;Num 5
Int Property iEquip_EditSavePresetKey = 77 Auto ;Num 6
Int Property iEquip_EditDiscardKey = 83 Auto ;Num .

Int Property KEY_J = 36 Auto ;J
Int Property KEY_ESCAPE = 1 Auto ;Esc
Int Property KEY_NUM5 = 76 Auto ;Num 5
Int Property KEY_ENTER = 28 Auto ;Enter
Int Property KEY_DOWN_ARROW = 208 Auto ;Down Arrow

bool extraLongKeyPress = false
bool isUtilityKeyHeld = false

string previousState = ""

function GameLoaded()
	GotoState("")
	self.RegisterForMenu("InventoryMenu")
	self.RegisterForMenu("MagicMenu")
	self.RegisterForMenu("FavoritesMenu")
	self.RegisterForMenu("Journal Menu")
	self.RegisterForMenu("LootMenu")
	UnregisterForAllKeys() ;Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
	isUtilityKeyHeld = false
endFunction

event OnMenuOpen(string currentMenu)
	if (currentMenu == "InventoryMenu" || currentMenu == "MagicMenu" || currentMenu == "FavoritesMenu"|| currentMenu == "Journal Menu") ;If in inventory or magic menu switch states so cycle hotkeys now assign selected item to the relevant queue array
		RegisterForMenuKeys()
		debug.trace("iEquip KeyHandler OnMenuOpen called, currentMenu: " + currentMenu)
		previousState = GetState()
		GotoState("ININVENTORYMENU")
	elseIf currentMenu == "LootMenu"
		
	endIf
endEvent

event OnMenuClose(string a_MenuName)
	GotoState("")
endEvent

function blockControls()
	debug.trace("iEquip KeyHandler blockControls called - current state: " + GetState())
	previousState = GetState()
	GotoState("PROCESSING")
endFunction

function releaseControls()
	debug.trace("iEquip KeyHandler releaseControls called - previous state: " + previousState)
	previousState = GetState()
	GotoState(previousState)
endFunction

event OnKeyDown(int KeyCode)
	;Handle extra long keypress actions and combo key held actions here so functions are called as soon as delay it met rather than waiting for onKeyUp
	debug.trace("iEquip KeyHandler OnKeyDown called, KeyCode = " + KeyCode + ", WC.isPreselectMode: " + WC.isPreselectMode)
	extraLongKeyPress = false
	float i = 0
	
	if KeyCode == iEquip_utilityKey ;Combo key for cycling backwards through the queues
		isUtilityKeyHeld = true

	elseIf KeyCode == iEquip_shoutKey || KeyCode == iEquip_consumableKey || KeyCode == iEquip_leftKey || KeyCode == iEquip_rightKey
		While i < MCM.pressAndHoldDelay
			debug.trace("iEquip_KeyHandler OnKeyDown counter = " + i)
			Utility.Wait(0.1)
			if Input.IsKeyPressed(KeyCode)
				debug.trace("iEquip KeyHandler OnKeyDown, isKeyPressed KeyCode = " + KeyCode)
				i += 0.1
			else
				return
			endIf
		endWhile
		if KeyCode == iEquip_consumableKey && WC.isPreselectMode
			WC.togglePreselectMode()
		elseIf KeyCode == iEquip_leftKey || KeyCode == iEquip_rightKey
			if WC.isPreselectMode
				WC.equipAllPreselectedItems()
			else
				WC.togglePreselectMode()
			endIf
		endIf
		extraLongKeyPress = true
		debug.trace("iEquip_KeyHandler OnKeyDown extraLongKeyPress: " + extraLongKeyPress)
	endIf
endEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
	debug.trace("iEquip KeyHandler OnKeyUp called, KeyCode: " + KeyCode + ", HoldTime: " + HoldTime)
	if KeyCode == iEquip_utilityKey
			isUtilityKeyHeld = false
		endIf

	if utility.IsInMenuMode() || extraLongKeyPress || HoldTime > (MCM.pressAndHoldDelay) ;Extra long keypress actions handled by OnKeyDown so OnKeyUp blocked if extra long press already registered
		debug.trace("iEquip_KeyHandler OnKeyUp extraLongKeyPress: " + extraLongKeyPress)
		return 
	endIf

	If HoldTime < MCM.longPressDelay	;If not longpress.
		If EM.isEditMode && KeyCode != iEquip_EditRotateKey && KeyCode != iEquip_EditAlphaKey && KeyCode != iEquip_EditRulersKey;If in Edit Mode bypass the multitap listener except for the three keys which require it
			DoSingleTapActions(KeyCode)
			return ;Return out here as we don't need anything else and avoids Edit Mode loop on exiting Edit Mode
		elseIf WaitingKeyCode != 0 && KeyCode != WaitingKeyCode	  ;The player pressed a different key, so force the current one to process if there is one
			;Stop the previous registration.
			UnregisterForUpdate()
			;Fully process the last key pressed.
			OnUpdate()
		endIf
		If iMultiTap == 0		;This is the first time the key has been pressed.
			WaitingKeyCode = KeyCode
			iMultiTap = 1
			self.RegisterForSingleUpdate(MCM.multiTapDelay) ;Tell the update function a key has been pressed.
		ElseIf iMultiTap == 1		;This is the second time the key has been pressed
			iMultiTap = 2
			self.RegisterForSingleUpdate(MCM.multiTapDelay) ;Reset the update function so we can wait and make sure it's not a triple tap.
		ElseIf iMultiTap == 2		;This is the third time the key has been pressed
			iMultiTap = 3
			RegisterForSingleUpdate(0.01)	;Basically, force update to immediately. No need to wait for more multi-taps.
		EndIf
	Else
		WaitingKeyCode = KeyCode
		iMultiTap = -1	;Use -1 for long-press.
		RegisterForSingleUpdate(0.01)		;Basically, update immediately for long-press. No need to wait for multi-tap.
	EndIf
EndEvent

Event OnUpdate()
	debug.trace("iEquip KeyHandler OnUpdate called")
	If iMultiTap == 0	;There's nothing to process. Check this first to get out as fast as possible.
		Return
	ElseIf iMultiTap == -1	;Long press
		DoLongPressActions(WaitingKeyCode)
	ElseIf iMultiTap == 1  ;Single tap
		DoSingleTapActions(WaitingKeyCode)
	ElseIf iMultiTap == 2  ; Double tap
		DoDoubleTapActions(WaitingKeyCode)
	ElseIf iMultiTap == 3  ;Triple tap
		DoTripleTapActions(WaitingKeyCode)
	Else
		;Somehow, we're updating without any of the above being true, so throw an error.
		;
	EndIf
	WaitingKeyCode = 0
	iMultiTap = 0
EndEvent

Function DoSingleTapActions(Int KeyCode)
	debug.trace("iEquip KeyHandler DoSingleTapActions called on " + KeyCode)
	GotoState("PROCESSING")
	
	;Handle Edit Mode Keys only if in Edit Mode
	if EM.isEditMode
		if KeyCode == iEquip_EditLeftKey
			EM.MoveLeft()
		elseIf KeyCode == iEquip_EditRightKey
			EM.MoveRight()
		elseIf KeyCode == iEquip_EditUpKey
			EM.MoveUp()
		elseIf KeyCode == iEquip_EditDownKey
			EM.MoveDown()
		elseIf KeyCode == iEquip_EditScaleUpKey
			EM.ScaleUp()
		elseIf KeyCode == iEquip_EditScaleDownKey
			EM.ScaleDown()
		elseIf KeyCode == iEquip_EditRotateKey
			EM.Rotate()
		elseIf KeyCode == iEquip_EditAlphaKey
			EM.SetAlpha()
		elseIf KeyCode == iEquip_EditDepthKey
			if EM.BringToFrontEnabled
				EM.BringToFront()
			else
				debug.messagebox("Bring To Front is currently disabled in the MCM\n\nIf you want to be able to change layer order for overlapping widget elements turn Bring To Front on first")
			endIf
		elseIf KeyCode == iEquip_EditTextKey
			int iIndex = EM.SelectedItem - 1
			if EM.isTextElement(iIndex)
				EM.SetTextAlignment()
			endIf
		elseIf KeyCode == iEquip_EditNextKey
			EM.cycleEditModeElements(1)
		elseIf KeyCode == iEquip_EditPrevKey
			EM.cycleEditModeElements(0)
		elseIf KeyCode == iEquip_EditResetKey
			EM.ResetItem()
		elseIf KeyCode == iEquip_EditLoadPresetKey
			EM.showEMPresetListMenu()
		elseIf KeyCode == iEquip_EditSavePresetKey
			EM.showEMTextInputMenu(0)
		elseIf KeyCode == iEquip_EditRulersKey
			EM.ToggleRulers()
		elseIf KeyCode == iEquip_EditDiscardKey
			EM.DiscardChanges()
		elseIf KeyCode == iEquip_utilityKey
			ToggleEditMode()
		endIf
		
	elseIf KeyCode == iEquip_leftKey
		int RHItemType = PlayerRef.GetEquippedItemType(1)
		if WC.isAmmoMode || (WC.isPreselectMode && (RHItemType == 7 || RHItemType == 12))
			WC.cycleAmmo(isUtilityKeyHeld)
		else
			WC.cycleSlot(0, isUtilityKeyHeld)
    	endIf

	elseIf KeyCode == iEquip_rightKey
		WC.cycleSlot(1, isUtilityKeyHeld)

	elseIf KeyCode == iEquip_shoutKey && WC.shoutEnabled
			WC.cycleSlot(2, isUtilityKeyHeld)

	elseIf KeyCode == iEquip_consumableKey
		if WC.consumablesEnabled
			WC.cycleSlot(3, isUtilityKeyHeld)
		elseIf WC.poisonsEnabled
			WC.cycleSlot(4, isUtilityKeyHeld)
    	endIf

    elseIf KeyCode == iEquip_utilityKey
		WC.openUtilityMenu()
	endIf

	GotoState("")
EndFunction

Function DoDoubleTapActions(Int KeyCode)
	debug.trace("iEquip KeyHandler DoDoubleTapActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	
	if EM.isEditMode
		if KeyCode == iEquip_EditRotateKey
			EM.ToggleRotateDirection()
		;elseIf KeyCode == iEquip_EditAlphaKey
			;EM.SetVisibility()
		elseIf KeyCode == iEquip_EditRulersKey
			EM.initColorPicker(1) ;Current item info color
		endIf
	elseIf KeyCode == iEquip_utilityKey
		int i = MCM.utilityKeyDoublePress
		if i == 1
			WC.openQueueManagerMenu()
		elseIf i == 2
			ToggleEditMode()
		elseIf i == 3
			openiEquipMCM()
		endIf
	elseIf KeyCode == iEquip_consumableKey
		if WC.consumablesEnabled && WC.poisonsEnabled
			WC.cycleSlot(4, isUtilityKeyHeld)
    	endIf
    elseIf KeyCode == iEquip_leftKey
    	int RHItemType = PlayerRef.GetEquippedItemType(1)
		if WC.isAmmoMode || (WC.isPreselectMode && (RHItemType == 7 || RHItemType == 12))
			WC.cycleSlot(0, isUtilityKeyHeld)
    	elseIf WC.poisonsEnabled
    		WC.applyPoison(0)
    	endIf
    elseIf KeyCode == iEquip_rightKey && WC.poisonsEnabled
    	WC.applyPoison(1)
    endIf
	GotoState("")
EndFunction

Function DoTripleTapActions(Int KeyCode)
	debug.trace("iEquip KeyHandler DoTripleTapActions called on " + KeyCode as String)
	GotoState("PROCESSING")
		if KeyCode == iEquip_leftKey && MCM.bProModeEnabled && MCM.bQuickShieldEnabled
			WC.quickShield()
		elseIf KeyCode == iEquip_rightKey && MCM.bProModeEnabled && MCM.bQuickRangedEnabled
			WC.quickRanged()
		elseIf KeyCode == iEquip_consumableKey && MCM.bProModeEnabled && MCM.bQuickHealEnabled
			WC.quickHeal()
		endIf
	GotoState("")
EndFunction

Function DoLongPressActions(Int KeyCode)
	debug.trace("iEquip KeyHandler DoLongPressActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	
	if KeyCode == iEquip_consumableKey
		if WC.consumablesEnabled
			WC.consumeItem()
		endIf
	
	elseIf EM.isEditMode
		If KeyCode == iEquip_EditLeftKey || KeyCode == iEquip_EditRightKey || KeyCode == iEquip_EditUpKey || KeyCode == iEquip_EditDownKey || KeyCode == iEquip_EditScaleUpKey || KeyCode == iEquip_EditScaleDownKey
			EM.ToggleStep(0)
		elseIf KeyCode == iEquip_EditRotateKey
			EM.ToggleStep(1)
		elseIf KeyCode == iEquip_EditAlphaKey
			EM.ToggleStep(2)
		elseIf KeyCode == iEquip_EditTextKey
			int iIndex = EM.SelectedItem - 1
			if EM.isTextElement(iIndex)
				EM.initColorPicker(2) ;Text color
			endIf
		elseIf KeyCode == iEquip_EditRulersKey
			EM.initColorPicker(0) ;Highlight color
		endIf

	elseIf WC.isPreselectMode
		If KeyCode == iEquip_leftKey
			WC.equipPreselectedItem(0) 
		elseIf KeyCode == iEquip_rightKey
			WC.equipPreselectedItem(1)
		elseIf KeyCode == iEquip_shoutKey
			if WC.shoutEnabled && MCM.bShoutPreselectEnabled
				WC.equipPreselectedItem(2)
	   		endIf
	   	endIf

	elseIf KeyCode == iEquip_leftKey
		if WC.isAmmoMode
			WC.toggleAmmoMode(false, false)
		else
			RC.rechargeWeapon(0)
		endIf

	elseIf KeyCode == iEquip_rightKey
		RC.rechargeWeapon(1)

	endIf

	GotoState("")
EndFunction

function ToggleEditMode()
	debug.trace("iEquip KeyHandler ToggleEditMode called")
	if !EM.isEditMode
		UnregisterForGameplayKeys()
		RegisterForEditModeKeys()
	else
		UnregisterForEditModeKeys()
		RegisterForGameplayKeys()
	endIf
	EM.ToggleEditMode()
endFunction

function RegisterForGameplayKeys()
	debug.trace("iEquip KeyHandler RegisterForGameplayKeys called")
	RegisterForKey(iEquip_shoutKey)
	RegisterForKey(iEquip_leftKey)
	RegisterForKey(iEquip_rightKey)
	RegisterForKey(iEquip_consumableKey)
	RegisterForKey(iEquip_utilityKey)
EndFunction

function UnregisterForGameplayKeys()
	debug.trace("iEquip KeyHandler UnregisterForGameplayKeys called")
	UnregisterForKey(iEquip_shoutKey)
	UnregisterForKey(iEquip_consumableKey)
	UnregisterForKey(iEquip_leftKey)
	UnregisterForKey(iEquip_rightKey)
	UnregisterForKey(iEquip_utilityKey)
EndFunction

function RegisterForMenuKeys()
	debug.trace("iEquip KeyHandler RegisterForMenuKeys called")
	RegisterForKey(iEquip_shoutKey)
	RegisterForKey(iEquip_leftKey)
	RegisterForKey(iEquip_rightKey)
	RegisterForKey(iEquip_consumableKey)
EndFunction

function RegisterForEditModeKeys()
	debug.trace("iEquip KeyHandler RegisterForEditModeKeys called")
	RegisterForKey(iEquip_EditLeftKey)
	RegisterForKey(iEquip_EditRightKey)
	RegisterForKey(iEquip_EditUpKey)
	RegisterForKey(iEquip_EditDownKey)
	RegisterForKey(iEquip_EditScaleUpKey)
	RegisterForKey(iEquip_EditScaleDownKey)
	RegisterForKey(iEquip_EditNextKey)
	RegisterForKey(iEquip_EditPrevKey)
	RegisterForKey(iEquip_EditResetKey)
	RegisterForKey(iEquip_EditLoadPresetKey)
	RegisterForKey(iEquip_EditSavePresetKey)
	RegisterForKey(iEquip_EditRotateKey)
	RegisterForKey(iEquip_EditDepthKey)
	RegisterForKey(iEquip_EditAlphaKey)
	RegisterForKey(iEquip_EditTextKey)
	RegisterForKey(iEquip_EditRulersKey)
	RegisterForKey(iEquip_EditDiscardKey)
	RegisterForKey(iEquip_utilityKey)
endFunction

function UnregisterForEditModeKeys()
	debug.trace("iEquip KeyHandler UnregisterForEditModeKeys called")
	UnregisterForKey(iEquip_EditLeftKey)
	UnregisterForKey(iEquip_EditRightKey)
	UnregisterForKey(iEquip_EditUpKey)
	UnregisterForKey(iEquip_EditDownKey)
	UnregisterForKey(iEquip_EditScaleUpKey)
	UnregisterForKey(iEquip_EditScaleDownKey)
	UnregisterForKey(iEquip_EditNextKey)
	UnregisterForKey(iEquip_EditPrevKey)
	UnregisterForKey(iEquip_EditResetKey)
	UnregisterForKey(iEquip_EditLoadPresetKey)
	UnregisterForKey(iEquip_EditSavePresetKey)
	UnregisterForKey(iEquip_EditRotateKey)
	UnregisterForKey(iEquip_EditDepthKey)
	UnregisterForKey(iEquip_EditAlphaKey)
	UnregisterForKey(iEquip_EditTextKey)
	UnregisterForKey(iEquip_EditRulersKey)
	UnregisterForKey(iEquip_EditDiscardKey)
	UnRegisterForKey(iEquip_utilityKey)
endFunction

;Disallow keys and group usage while processing
state PROCESSING
	event OnKeyDown(int KeyCode)
	endEvent
	
	event OnKeyUp(int KeyCode, float HoldTime)
	endEvent
endState

state ININVENTORYMENU	
	event OnKeyDown(int KeyCode)
		Debug.Trace("iEquip KeyHandler ININVENTORYMENU OnKeyDown called on " + KeyCode)
		GotoState("PROCESSING")
		If KeyCode == iEquip_leftKey
			WC.AddToQueue(0)

		elseIf KeyCode == iEquip_rightKey
			WC.AddToQueue(1)

		elseIf KeyCode == iEquip_shoutKey
			WC.AddToQueue(2)

		elseIf KeyCode == iEquip_consumableKey
			WC.AddToQueue(3)
		
		EndIf
		GotoState("ININVENTORYMENU")
	endEvent
	
	event OnKeyUp(int KeyCode, float HoldTime)
	endEvent
endState

;/Function UnbindSkyrimHotkeys()
    Int i = 0
    While (i < 8)
        Game.UnbindObjectHotkey(i)
        i += 1
    EndWhile
EndFunction/;

function openiEquipMCM()
	if !Game.IsMenuControlsEnabled() || Utility.IsInMenuMode() || UI.IsTextInputEnabled() || UI.IsMenuOpen("Dialogue Menu") || (UI.IsMenuOpen("Crafting Menu")) ; || UI.IsMenuOpen("Console"))
		return
	endif
	self.RegisterForMenu("Journal Menu")
	float actionDelay = 0.005
	Input.TapKey(KEY_J) ;Should open the Journal Menu
	Utility.WaitMenuMode(actionDelay)
	float elapsedTime
	float startTime = Utility.GetCurrentRealTime()
	bool continueWait = true
	while continueWait
		if !UI.IsMenuOpen("Journal Menu")
			Utility.WaitMenuMode(0.1)
			if !UI.IsMenuOpen("Journal Menu")
				Input.TapKey(KEY_ESCAPE)
				Utility.WaitMenuMode(actionDelay)
			else
				continueWait = false
			endIf
		else
			continueWait = false
		endIf
		elapsedTime = Utility.GetCurrentRealTime() - startTime
		if (elapsedTime >= 2.5)
			continueWait = false
		endIf
	EndWhile
	if !UI.IsMenuOpen("Journal Menu")
		return
	endIf
	Utility.WaitMenuMode(actionDelay)
	Input.TapKey(KEY_NUM5) ;Should take us to the Settings Tab
	Utility.WaitMenuMode(actionDelay)
	int i = 0
	int n = 3 ;Should take us to Mod Configelay Menu entry in the Settings List
	while i < n
		Input.TapKey(KEY_DOWN_ARROW)
		Utility.WaitMenuMode(actionDelay)
		i += 1
	EndWhile
	Input.TapKey(KEY_ENTER)
	Utility.WaitMenuMode(actionDelay)
	i = 0
	n = 128
	string modName = ""
	bool iEquipFound = false
	while i < n && !iEquipFound
		Input.TapKey(KEY_DOWN_ARROW)
		Utility.WaitMenuMode(0.05)
		modName = UI.GetString("Journal Menu", "_root.ConfigPanelFader.configPanel._modList.selectedEntry.text")
		if modName == "iEquip"
			iEquipFound = true
		endIf
		i += 1
	EndWhile
	if !iEquipFound
		return
	else
		Input.TapKey(KEY_ENTER)
	endIf
endFunction

function CloseAndReopeniEquipMCM()
	if UI.IsMenuOpen("Journal Menu")
		Input.TapKey(KEY_ESCAPE)
		Utility.WaitMenuMode(0.5)
		Input.TapKey(KEY_ENTER)
	endIf
endFunction

