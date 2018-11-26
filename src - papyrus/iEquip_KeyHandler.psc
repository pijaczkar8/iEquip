ScriptName iEquip_KeyHandler extends Quest
;This script sets up and handles all the key assignments and keypress actions

import Input
Import UI

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto
iEquip_RechargeScript Property RC Auto
iEquip_HelpMenu Property HM Auto

Actor Property PlayerRef  Auto
Message Property iEquip_UtilityMenu Auto

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
bool Property bNormalSystemPageBehav = true Auto Hidden
bool isUtilityKeyHeld = false
bool bNotInLootMenu = true

; Ints
int Property utilityKeyDoublePress = 0 Auto Hidden
Int WaitingKeyCode = 0
Int iMultiTap = 0

; Strings
string previousState = ""

; ------------------
; - GENERAL EVENTS -
; ------------------

function GameLoaded()
	GotoState("")
    
	self.RegisterForMenu("InventoryMenu")
	self.RegisterForMenu("MagicMenu")
	self.RegisterForMenu("FavoritesMenu")
	self.RegisterForMenu("Journal Menu")
	self.RegisterForMenu("LootMenu")
    
	UnregisterForAllKeys() ;Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
    
	isUtilityKeyHeld = false
    bNotInLootMenu = true
endFunction

event OnMenuOpen(string MenuName)
	if MenuName == "LootMenu"
        bNotInLootMenu = false
    else
        previousState = GetState()
        GotoState("INVENTORYMENU")
        
        UnregisterForUpdate()
        WaitingKeyCode = 0
        iMultiTap = 0
        
        RegisterForGameplayKeys()
	endIf
endEvent

event OnMenuClose(string MenuName)
    if MenuName == "LootMenu"
        bNotInLootMenu = true
    else     
        GotoState(previousState)
    endIf
endEvent

event OnUpdate()
	debug.trace("iEquip KeyHandler OnUpdate called multiTap: "+iMultiTap)
    bAllowKeyPress = false
    
    runUpdate()
    
    iMultiTap = 0
    WaitingKeyCode = 0
    bAllowKeyPress = true
endEvent

; ---------------------
; - DEFAULT BEHAVIOUR -
; ---------------------

event OnKeyDown(int KeyCode)
    if KeyCode == iEquip_utilityKey
        isUtilityKeyHeld = true
    endIf

    if bAllowKeyPress
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
    endif
endEvent

event OnKeyUp(Int KeyCode, Float HoldTime)
    if KeyCode == iEquip_utilityKey
        isUtilityKeyHeld = false
    endIf

    if bAllowKeyPress
        if KeyCode == WaitingKeyCode && iMultiTap == 0
            float updateTime = 0.0
        
            if HoldTime >= longPressDelay ;If longpress.
                iMultiTap = -1
            else ; Turns out the key is a multiTap
                iMultiTap = 1
                updateTime = multiTapDelay
            endIf
            
            RegisterForSingleUpdate(updateTime)
        endIf
    endIf
endEvent

function runUpdate()
    if iMultiTap == -1   ; Longpress
        if WaitingKeyCode == iEquip_consumableKey
            if bNotInLootMenu && WC.consumablesEnabled
                WC.consumeItem()
            endIf
            
        elseIf WC.isPreselectMode
            if WaitingKeyCode == iEquip_leftKey
                WC.equipPreselectedItem(0) 
            elseIf WaitingKeyCode == iEquip_rightKey
                WC.equipPreselectedItem(1)
            elseIf WaitingKeyCode == iEquip_shoutKey
                if bNotInLootMenu && MCM.bShoutPreselectEnabled && WC.shoutEnabled
                    WC.equipPreselectedItem(2)
                endIf
            endIf
            
        elseIf WaitingKeyCode == iEquip_leftKey
            if WC.isAmmoMode 
                WC.toggleAmmoMode(false, false)
            else
                RC.rechargeWeapon(0)
            endIf
        elseIf WaitingKeyCode == iEquip_rightKey
            RC.rechargeWeapon(1)
        endIf
        
    elseIf iMultiTap == 0  ; LongpressHold
        if WC.isPreselectMode && (WaitingKeyCode == iEquip_leftKey ||  iEquip_rightKey)
            WC.equipAllPreselectedItems()
        endIf
        
    elseIf iMultiTap == 1  ;Single tap
        If WaitingKeyCode == iEquip_leftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            if WC.isAmmoMode || (WC.isPreselectMode && (RHItemType == 7 || RHItemType == 12))
                WC.cycleAmmo(isUtilityKeyHeld)
            else
                WC.cycleSlot(0, isUtilityKeyHeld)
            endIf

        elseIf WaitingKeyCode == iEquip_rightKey
            WC.cycleSlot(1, isUtilityKeyHeld)

        elseIf WaitingKeyCode == iEquip_shoutKey
            if bNotInLootMenu && WC.shoutEnabled
                WC.cycleSlot(2, isUtilityKeyHeld)
            endIf
                
        elseIf WaitingKeyCode == iEquip_consumableKey
            if bNotInLootMenu
                if WC.consumablesEnabled
                    WC.cycleSlot(3, isUtilityKeyHeld)
                elseIf WC.poisonsEnabled
                    WC.cycleSlot(4, isUtilityKeyHeld)
                endIf
            endIf
            
        elseIf WaitingKeyCode == iEquip_utilityKey
            ;0 = Exit, 1 = Queue Menu, 2 = Edit Mode, 3 = MCM, 4 = Refresh Widget
            int iAction = iEquip_UtilityMenu.Show() 
            
            if iAction != 0 ;Exit
                if iAction == 1
                    WC.openQueueManagerMenu()
                elseif iAction == 2
                    toggleEditMode()
                elseif iAction == 3
                    openiEquipMCM()
                elseif iAction == 4
                    ;HM.openHelpMenu()
                elseif iAction == 5
                    WC.refreshWidget()
                endIf
            endIf
        endIf
        
    elseIf iMultiTap == 2  ; Double tap
        If WaitingKeyCode == iEquip_utilityKey
            if utilityKeyDoublePress == 1
                WC.openQueueManagerMenu()
            elseIf utilityKeyDoublePress == 2
                toggleEditMode()
            elseIf utilityKeyDoublePress == 3
                openiEquipMCM()
            endIf
        elseIf WaitingKeyCode == iEquip_consumableKey
            if bNotInLootMenu && WC.consumablesEnabled && WC.poisonsEnabled
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
        
    elseIf MCM.bProModeEnabled && iMultiTap == 3  ;Triple tap
        if WaitingKeyCode == iEquip_shoutKey && MCM.bPreselectEnabled
            WC.isPreselectMode = !WC.isPreselectMode
        elseIf WaitingKeyCode == iEquip_leftKey && MCM.bQuickShieldEnabled
            WC.quickShield()
        elseIf WaitingKeyCode == iEquip_rightKey && MCM.bQuickRangedEnabled
            WC.quickRanged()
        elseIf WaitingKeyCode == iEquip_consumableKey && MCM.bQuickHealEnabled && bNotInLootMenu
            WC.quickHeal()
        endIf
    endIf
endFunction

; --------------------
; - OTHER BEHAVIOURS -
; --------------------

; - Inventory
state INVENTORYMENU
	event OnKeyDown(int KeyCode)
        if KeyCode == iEquip_utilityKey
            isUtilityKeyHeld = true
        endIf
     
        if bAllowKeyPress
            bAllowKeyPress = false
        
            if KeyCode == iEquip_leftKey
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
endState

; - Editmode
state EDITMODE
    event OnKeyUp(Int KeyCode, Float HoldTime)
        if bAllowKeyPress
            if KeyCode == WaitingKeyCode && iMultiTap == 0
                float updateTime = 0.0
            
                if HoldTime >= longPressDelay ;If longpress.
                    iMultiTap = -1
                else ; Turns out the key is a multiTap
                    iMultiTap = 1
                    
                    If (KeyCode == iEquip_EditRotateKey || KeyCode == iEquip_EditRulersKey)
                        updateTime = multiTapDelay
                    endIf
                endIf
                
                RegisterForSingleUpdate(updateTime)
            endIf
        endIf
    endEvent

    function runUpdate()
        if iMultiTap == 0   ; Press and hold
            if WaitingKeyCode == iEquip_EditNextKey || WaitingKeyCode == iEquip_EditPrevKey
                EM.toggleSelectionRange()
            elseIf WaitingKeyCode == iEquip_EditAlphaKey
                EM.toggleStep(2)
            elseIf WaitingKeyCode == iEquip_EditRotateKey
                EM.toggleStep(1)
            elseIf (WaitingKeyCode == iEquip_EditLeftKey || WaitingKeyCode == iEquip_EditRightKey || WaitingKeyCode == iEquip_EditUpKey ||\
                    WaitingKeyCode == iEquip_EditDownKey || WaitingKeyCode == iEquip_EditScaleUpKey || WaitingKeyCode == iEquip_EditScaleDownKey)
                EM.toggleStep(0)
            elseIf WaitingKeyCode == iEquip_EditTextKey
                if WC.abWidget_isText[EM.SelectedItem - 1]
                    EM.initColorPicker(2) ;Text color
                endIf
            elseIf WaitingKeyCode == iEquip_EditRulersKey
                EM.initColorPicker(0) ;Highlight color
            endIf
            
        elseIf iMultiTap == 1  ;Single tap
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
                if EM.bringToFrontEnabled
                    EM.bringToFront()
                else
                    debug.messagebox("Bring To Front is currently disabled in the MCM\n\nIf you want to be able to change layer order for overlapping widget elements turn Bring To Front on first")
                endIf
            elseIf WaitingKeyCode == iEquip_EditTextKey
                if WC.abWidget_isText[EM.SelectedItem - 1]
                    EM.setTextAlignment()
                endIf
            elseIf WaitingKeyCode == iEquip_EditNextKey
                EM.cycleEditModeElements(true)
            elseIf WaitingKeyCode == iEquip_EditPrevKey
                EM.cycleEditModeElements(false)
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
                toggleEditMode()
            endIf
            
        elseIf iMultiTap == 2  ; Double tap
            if WaitingKeyCode == iEquip_EditRotateKey
                EM.toggleRotateDirection()
            elseIf WaitingKeyCode == iEquip_EditRulersKey
                EM.initColorPicker(1) ;Current item info color
            endIf
            
        endIf
    endFunction
endState

; -----------------
; - MISCELLANEOUS -
; -----------------

function updateKeyMaps(int keycode)
    UnregisterForAllKeys()

    if EM.isEditMode
        RegisterForEditModeKeys()
    else
        RegisterForGameplayKeys()
    endIf
endFunction

function toggleEditMode()
	debug.trace("iEquip KeyHandler toggleEditMode called")
    UnregisterForAllKeys()
    
	if EM.isEditMode
        GoToState("")
		RegisterForGameplayKeys()
	else
        GoToState("EDITMODE")
		RegisterForEditModeKeys()
        updateEditModeKeys()
	endIf
    
	EM.toggleEditMode()
endFunction

function resetEditModeKeys()
    iEquip_EditNextKey = 55
    iEquip_EditPrevKey = 181
    iEquip_EditUpKey = 200
    iEquip_EditDownKey = 208
    iEquip_EditLeftKey = 203
    iEquip_EditRightKey = 205
    iEquip_EditScaleUpKey = 78
    iEquip_EditScaleDownKey = 74
    iEquip_EditRotateKey = 80
    iEquip_EditAlphaKey = 81
    iEquip_EditDepthKey = 72
    iEquip_EditTextKey = 79
    iEquip_EditRulersKey = 77
    iEquip_EditResetKey = 82
    iEquip_EditLoadPresetKey = 75
    iEquip_EditSavePresetKey = 76
    iEquip_EditDiscardKey = 83
endFunction

function updateEditModeKeys()
    int[] keys = new int[18]

    keys[0] = iEquip_UtilityKey
    keys[1] = iEquip_EditPrevKey
    keys[2] = iEquip_EditNextKey
    keys[3] = iEquip_EditUpKey
    keys[4] = iEquip_EditDownKey
    keys[5] = iEquip_EditLeftKey
    keys[6] = iEquip_EditRightKey
    keys[7] = iEquip_EditScaleUpKey
    keys[8] = iEquip_EditScaleDownKey
    keys[9] = iEquip_EditRotateKey
    keys[10] = iEquip_EditAlphaKey
    keys[11] = iEquip_EditTextKey
    keys[12] = iEquip_EditDepthKey
    keys[13] = iEquip_EditRulersKey
    keys[14] = iEquip_EditResetKey
    keys[15] = iEquip_EditLoadPresetKey
    keys[16] = iEquip_EditSavePresetKey
    keys[17] = iEquip_EditDiscardKey
    
    InvokeIntA(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeButtons", keys)
endFunction

function RegisterForGameplayKeys()
	debug.trace("iEquip KeyHandler RegisterForGameplayKeys called")
	RegisterForKey(iEquip_shoutKey)
	RegisterForKey(iEquip_leftKey)
	RegisterForKey(iEquip_rightKey)
	RegisterForKey(iEquip_consumableKey)
	RegisterForKey(iEquip_utilityKey)
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

function openiEquipMCM(bool inMCMSelect = false)
    int key_j = GetMappedKey("Journal")
    
    if inMCMSelect
        TapKey(key_j)
        Utility.WaitMenuMode(0.3)
        TapKey(key_j)
        Utility.WaitMenuMode(0.3)
        TapKey(key_j)
        Utility.WaitMenuMode(0.005)
        TapKey(key_j)
        Utility.Wait(0.5)
    endIf
    
    if Game.IsMenuControlsEnabled() && !Utility.IsInMenuMode() && !IsTextInputEnabled() &&\
       !IsMenuOpen("Dialogue Menu") && !IsMenuOpen("Crafting Menu")
        float startTime = Utility.GetCurrentRealTime()
        float elapsedTime
        int key_down = GetMappedKey("Back")
        int i = 0
        
        while elapsedTime <= 2.5
            if IsMenuOpen("Journal Menu")
                if bNormalSystemPageBehav ; Compatibility with open system page mod
                
                    ; Should take us to the Settings Tab
                     if Game.UsingGamepad()
                        TapKey(GetMappedKey("Left Attack/Block"))
                        key_down = 267
                    else
                        TapKey(76)
                    endIf
                    
                    Utility.WaitMenuMode(0.005)
                endIf
                
                while i < 3 ;Should take us to MCM Menu entry in the Settings List
                    TapKey(key_down)
                    Utility.WaitMenuMode(0.005)
                    i += 1
                EndWhile
                
                elapsedTime = 3.0
            else
                TapKey(key_j)
                Utility.WaitMenuMode(0.1)
                elapsedTime = Utility.GetCurrentRealTime() - startTime
            endIf
        endWhile
 
        if MCM.isFirstEnabled
            MCM.bEnabled = !MCM.bEnabled
            MCM.justEnabled = true
            MCM.isFirstEnabled = false
        endIf
        
        if elapsedTime == 3.0
            int key_enter = GetMappedKey("Activate")
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
        endIf
    endIf
endFunction
