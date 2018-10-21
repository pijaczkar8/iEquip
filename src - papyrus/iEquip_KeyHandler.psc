ScriptName iEquip_KeyHandler extends Quest
;This script sets up and handles all the key assignments and keypress actions

import Input
Import UI

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

Actor Property PlayerRef  Auto

;Main gameplay keys
Int Property iEquip_shoutKey = 21 Auto Hidden ;Y
Int Property iEquip_leftKey = 34 Auto Hidden ;G
Int Property iEquip_rightKey = 35 Auto Hidden ;H
Int Property iEquip_consumableKey = 48 Auto Hidden ;B
Int Property iEquip_utilityKey = 29 Auto Hidden ;Left Ctrl - Active in all modes

;Edit Mode Keys
Int Property iEquip_EditNextKey = 55 Auto Hidden ;Num *
Int Property iEquip_EditPrevKey = 181 Auto Hidden ;Num /
Int Property iEquip_EditUpKey = 200 Auto Hidden ;Up arrow
Int Property iEquip_EditDownKey = 208 Auto Hidden ;Down arrow
Int Property iEquip_EditRightKey = 205 Auto Hidden ;Right arrow
Int Property iEquip_EditLeftKey = 203 Auto Hidden ;Left arrow
Int Property iEquip_EditScaleUpKey = 78 Auto Hidden ;Num +
Int Property iEquip_EditScaleDownKey = 74 Auto Hidden ;Num -
Int Property iEquip_EditDepthKey  = 72 Auto Hidden ;Num 8
Int Property iEquip_EditRotateKey  = 79 Auto Hidden ;Num 1
Int Property iEquip_EditTextKey = 80 Auto Hidden ;Num 2
Int Property iEquip_EditAlphaKey = 81 Auto Hidden ;Num 3
Int Property iEquip_EditRulersKey = 75 Auto Hidden ;Num 4
Int Property iEquip_EditResetKey = 82 Auto Hidden ;Num 0
Int Property iEquip_EditLoadPresetKey = 76 Auto Hidden ;Num 5
Int Property iEquip_EditSavePresetKey = 77 Auto Hidden ;Num 6
Int Property iEquip_EditDiscardKey = 83 Auto Hidden ;Num .

; Delays
float Property multiTapDelay = 0.3 Auto Hidden
float Property longPressDelay = 0.5 Auto Hidden
float Property pressAndHoldDelay = 1.0 Auto Hidden

; Bools
bool Property bAllowKeyPress = true Auto Hidden
bool bNotInLootMenu = true
bool isUtilityKeyHeld = false

; Ints
Int WaitingKeyCode = 0
Int iMultiTap = 0
int keySum = 0

; - ON LOAD
function GameLoaded()
	GotoState("")
    
	self.RegisterForMenu("InventoryMenu")
	self.RegisterForMenu("MagicMenu")
	self.RegisterForMenu("FavoritesMenu")
	self.RegisterForMenu("Journal Menu")
	self.RegisterForMenu("LootMenu")
    
	UnregisterForAllKeys() ;Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
    
    keySum = 0
    bNotInLootMenu = true
	isUtilityKeyHeld = false
endFunction

; - STATES

; Inventory menu state
state ININVENTORYMENU
    event OnUpdate()
    endEvent
    
	event OnKeyDown(int KeyCode)
		Debug.Trace("iEquip KeyHandler ININVENTORYMENU OnKeyDown called on " + KeyCode)
        checkKeysDown(KeyCode)
        
        if bAllowKeyPress
            bAllowKeyPress = false
        
            If KeyCode == iEquip_leftKey
                WC.AddToQueue(0)
            elseIf KeyCode == iEquip_rightKey
                WC.AddToQueue(1)
            elseIf KeyCode == iEquip_shoutKey
                WC.AddToQueue(2)
            elseIf KeyCode == iEquip_consumableKey
                WC.AddToQueue(3)		
            endIf
            
            bAllowKeyPress = true
        endIf
	endEvent
	
	event OnKeyUp(int KeyCode, float HoldTime)
        checkKeysUp(KeyCode)
	endEvent
endState

; Default states

event OnMenuOpen(string MenuName)
	if MenuName == "LootMenu"
        bNotInLootMenu = false
    else
        RegisterForKey(iEquip_shoutKey)
        RegisterForKey(iEquip_leftKey)
        RegisterForKey(iEquip_rightKey)
        RegisterForKey(iEquip_consumableKey)
        
		GotoState("ININVENTORYMENU")
	endIf
endEvent

event OnMenuClose(string MenuName)
    if MenuName == "LootMenu"
        bNotInLootMenu = true
    else
        GotoState("")
    endIf
endEvent

event OnKeyDown(int KeyCode)
	;Handle extra long keypress actions and combo key held actions here so functions are called as soon as delay it met rather than waiting for onKeyUp
	debug.trace("iEquip KeyHandler OnKeyDown called, KeyCode = " + KeyCode + ", WC.isPreselectMode: " + WC.isPreselectMode)
    if checkKeysDown(KeyCode)
        if bAllowKeyPress
            if keySum == iEquip_leftKey + iEquip_rightKey
                keySum = -2
                UnregisterForUpdate()
                WC.togglePreselectMode()
            else
                if KeyCode != WaitingKeyCode && WaitingKeyCode != 0 ;The player pressed a different key, so force the current one to process if there is one
                    UnregisterForUpdate()
                    OnUpdate()
                endIf
                WaitingKeyCode = KeyCode
            
                if iMultiTap == 0 ; This is fhte first time the key has been pressed
                    RegisterForSingleUpdate(pressAndHoldDelay)
                elseIf iMultiTap == 1 ;This is the second time the key has been pressed.
                    iMultiTap = 2
                    RegisterForSingleUpdate(multiTapDelay)
                elseIf iMultiTap == 2 ; This is the third time the key has been pressed
                    iMultiTap = 3
                    RegisterForSingleUpdate(0.0)
                endIf
            endIf
        endIf
    endif
endEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
	debug.trace("iEquip KeyHandler OnKeyUp called, KeyCode: " + KeyCode + ", HoldTime: " + HoldTime)
    
    if checkKeysUp(KeyCode) 
        if bAllowKeyPress
            if KeyCode == WaitingKeyCode && iMultiTap == 0 
                if HoldTime < pressAndHoldDelay ; If not a press & hold
                    float updateTime = 0.0
                
                    if HoldTime >= longPressDelay ;If longpress.
                        iMultiTap = -1
                    else ; Turns out the key is a multiTap
                        iMultiTap = 1
                        
                        If !EM.isEditMode || KeyCode == iEquip_EditRotateKey || KeyCode == iEquip_EditAlphaKey || KeyCode == iEquip_EditRulersKey
                            updateTime = multiTapDelay
                        endIf
                    endIf
                    
                    RegisterForSingleUpdate(updateTime)
                endIf
            endIf
        endIf
    endIf
endEvent

Event OnUpdate()
	debug.trace("iEquip KeyHandler OnUpdate called multiTap: "+iMultiTap)
    bAllowKeyPress = false
    
    if iMultiTap == -1   ; Longpress
        if WaitingKeyCode == iEquip_consumableKey
            if WC.consumablesEnabled
                WC.consumeItem()
            endIf

        elseIf EM.isEditMode
            if WaitingKeyCode == iEquip_EditAlphaKey
                EM.ToggleStep(2)
            elseIf WaitingKeyCode == iEquip_EditRotateKey
                EM.ToggleStep(1)
            elseIf (WaitingKeyCode == iEquip_EditLeftKey || WaitingKeyCode == iEquip_EditRightKey || WaitingKeyCode == iEquip_EditUpKey ||\
                    WaitingKeyCode == iEquip_EditDownKey || WaitingKeyCode == iEquip_EditScaleUpKey || WaitingKeyCode == iEquip_EditScaleDownKey)
                EM.ToggleStep(0)
            elseIf WaitingKeyCode == iEquip_EditTextKey
                if EM.isTextElement(EM.SelectedItem - 1)
                    EM.initColorPicker(2) ;Text color
                endIf
            elseIf WaitingKeyCode == iEquip_EditRulersKey
                EM.initColorPicker(0) ;Highlight color
            endIf

        elseIf WC.isPreselectMode
            If WaitingKeyCode == iEquip_leftKey
                WC.equipPreselectedItem(0) 
            elseIf WaitingKeyCode == iEquip_rightKey
                WC.equipPreselectedItem(1)
            elseIf WaitingKeyCode == iEquip_shoutKey
                if WC.shoutEnabled && MCM.bShoutPreselectEnabled
                    WC.equipPreselectedItem(2)
                endIf
            endIf

        elseIf WC.isAmmoMode && WaitingKeyCode == iEquip_leftKey
            WC.toggleAmmoMode(false, false)
        endIf
    elseIf iMultiTap == 0  ; LongpressHold
        if WC.isPreselectMode && WaitingKeyCode == keySum 
            WC.equipAllPreselectedItems()
        endIf
    elseIf iMultiTap == 1  ;Single tap
        if EM.isEditMode
            if WaitingKeyCode == iEquip_EditLeftKey
                EM.MoveLeft()
            elseIf WaitingKeyCode == iEquip_EditRightKey
                EM.MoveRight()
            elseIf WaitingKeyCode == iEquip_EditUpKey
                EM.MoveUp()
            elseIf WaitingKeyCode == iEquip_EditDownKey
                EM.MoveDown()
            elseIf WaitingKeyCode == iEquip_EditScaleUpKey
                EM.ScaleUp()
            elseIf WaitingKeyCode == iEquip_EditScaleDownKey
                EM.ScaleDown()
            elseIf WaitingKeyCode == iEquip_EditRotateKey
                EM.Rotate()
            elseIf WaitingKeyCode == iEquip_EditAlphaKey
                EM.SetAlpha()
            elseIf WaitingKeyCode == iEquip_EditDepthKey
                if EM.BringToFrontEnabled
                    EM.BringToFront()
                else
                    debug.messagebox("Bring To Front is currently disabled in the MCM\n\nIf you want to be able to change layer order for overlapping widget elements turn Bring To Front on first")
                endIf
            elseIf WaitingKeyCode == iEquip_EditTextKey
                if EM.isTextElement(EM.SelectedItem - 1)
                    EM.SetTextAlignment()
                endIf
            elseIf WaitingKeyCode == iEquip_EditNextKey
                EM.cycleEditModeElements(1)
            elseIf WaitingKeyCode == iEquip_EditPrevKey
                EM.cycleEditModeElements(0)
            elseIf WaitingKeyCode == iEquip_EditResetKey
                EM.ResetItem()
            elseIf WaitingKeyCode == iEquip_EditLoadPresetKey
                EM.showEMPresetListMenu()
            elseIf WaitingKeyCode == iEquip_EditSavePresetKey
                EM.showEMTextInputMenu(0)
            elseIf WaitingKeyCode == iEquip_EditRulersKey
                EM.ToggleRulers()
            elseIf WaitingKeyCode == iEquip_EditDiscardKey
                EM.DiscardChanges()
            elseIf WaitingKeyCode == iEquip_utilityKey
                ToggleEditMode()
            endIf
        
        elseIf WaitingKeyCode == iEquip_leftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            if WC.isAmmoMode || (WC.isPreselectMode && (RHItemType == 7 || RHItemType == 12))
                WC.cycleAmmo(isUtilityKeyHeld)
            else
                WC.cycleSlot(0, isUtilityKeyHeld)
            endIf

        elseIf WaitingKeyCode == iEquip_rightKey
            WC.cycleSlot(1, isUtilityKeyHeld)

        elseIf WaitingKeyCode == iEquip_shoutKey && WC.shoutEnabled
                WC.cycleSlot(2, isUtilityKeyHeld)

        elseIf WaitingKeyCode == iEquip_consumableKey
            if WC.consumablesEnabled
                WC.cycleSlot(3, isUtilityKeyHeld)
            elseIf WC.poisonsEnabled
                WC.cycleSlot(4, isUtilityKeyHeld)
            endIf
            
        elseIf WaitingKeyCode == iEquip_utilityKey
            WC.openUtilityMenu()
        endIf
        
    elseIf iMultiTap == 2  ; Double tap
        if EM.isEditMode
            if WaitingKeyCode == iEquip_EditRotateKey
                EM.ToggleRotateDirection()
            elseIf WaitingKeyCode == iEquip_EditAlphaKey
                EM.SetVisibility()
            elseIf WaitingKeyCode == iEquip_EditRulersKey
                EM.initColorPicker(1) ;Current item info color
            endIf
        elseIf WaitingKeyCode == iEquip_utilityKey
            int i = MCM.utilityKeyDoublePress
            
            if i == 1
                WC.openQueueManagerMenu()
            elseIf i == 2
                ToggleEditMode()
            elseIf i == 3
                openiEquipMCM()
            endIf
        elseIf WaitingKeyCode == iEquip_consumableKey
            if WC.consumablesEnabled && WC.poisonsEnabled
                WC.cycleSlot(4, isUtilityKeyHeld)
            endIf
        elseIf WaitingKeyCode == iEquip_leftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            
            if WC.isAmmoMode || (WC.isPreselectMode && (RHItemType == 7 || RHItemType == 12))
                WC.cycleSlot(0, isUtilityKeyHeld)
            elseIf WC.poisonsEnabled
                WC.applyPoison(0)
            endIf
        elseIf WaitingKeyCode == iEquip_rightKey && WC.poisonsEnabled
            WC.applyPoison(1)
        endIf
        
    elseIf iMultiTap == 3  ;Triple tap
        if MCM.bProModeEnabled
            if WaitingKeyCode == iEquip_leftKey && MCM.bQuickShieldEnabled
                WC.quickShield()
            elseIf WaitingKeyCode == iEquip_rightKey && MCM.bQuickRangedEnabled
                WC.quickRanged()
            elseIf WaitingKeyCode == iEquip_consumableKey && MCM.bQuickHealEnabled
                WC.quickHeal()
            endIf
        endIf
    endIf
    
    iMultiTap = 0
    WaitingKeyCode = 0
    bAllowKeyPress = true
endEvent

; - MISCELLANEOUS

bool function checkKeysDown(int KeyCode)
    if KeyCode == iEquip_utilityKey
        isUtilityKeyHeld = true
        if keySum < 0
            return false
        endIf
    elseIf KeyCode == iEquip_leftKey || iEquip_rightKey
        if keySum >= 0
            keySum += KeyCode
        else
            keySum -= 1
            return false
        endif
    endIf
    
    return true
endFunction

bool function checkKeysUp(int KeyCode)
    if KeyCode == iEquip_utilityKey
        isUtilityKeyHeld = false
        if keySum < 0
            return false
        endIf
    elseIf KeyCode == iEquip_leftKey || iEquip_rightKey
        if keySum >= 0
            keySum -= KeyCode
        else
            keySum += 1
            return false
        endif
    endIf
    
    return true
endFunction

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
endFunction

function UnregisterForGameplayKeys()
	debug.trace("iEquip KeyHandler UnregisterForGameplayKeys called")
	UnregisterForKey(iEquip_shoutKey)
	UnregisterForKey(iEquip_consumableKey)
	UnregisterForKey(iEquip_leftKey)
	UnregisterForKey(iEquip_rightKey)
	UnregisterForKey(iEquip_utilityKey)
endFunction

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

function openiEquipMCM()
	if Game.IsMenuControlsEnabled() && !Utility.IsInMenuMode() && !IsTextInputEnabled() && !IsMenuOpen("Dialogue Menu") && !IsMenuOpen("Crafting Menu")
        int key_j = GetMappedKey("Journal")
        int key_enter = GetMappedKey("Activate")
        int key_down = GetMappedKey("Back")
        
        float startTime = Utility.GetCurrentRealTime()
        float elapsedTime
        
        while elapsedTime <= 2.5
            if IsMenuOpen("Journal Menu")
                int i = 0
        
                TapKey(GetMappedKey("Hotkey5", 0x02)) ;Should take us to the Settings Tab <--- THIS DOESN'T WORK, NEED TO FIND AN ALTERNATIVE MAPPED KEY
                Utility.WaitMenuMode(0.005)
                
                while i < 2 ;Should take us to Mod Configelay Menu entry in the Settings List
                    TapKey(key_down)
                    Utility.WaitMenuMode(0.005)
                    i += 1
                EndWhile
                
                TapKey(key_enter)
                Utility.WaitMenuMode(0.005)
                
                i = 0
                
                while i < 128
                    TapKey(key_down)
                    Utility.WaitMenuMode(0.005)
                    
                    if GetString("Journal Menu", "_root.ConfigPanelFader.configPanel._modList.selectedEntry.text") == "iEquip"
                        TapKey(key_enter)
                        i = 128
                    else
                        i += 1
                    endIf
                endWhile
            
                elapsedTime = 2.6
            else
                TapKey(key_j)
                Utility.WaitMenuMode(0.1)
                elapsedTime = Utility.GetCurrentRealTime() - startTime
            endIf
        endWhile
	endif
endFunction

