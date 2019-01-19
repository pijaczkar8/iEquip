ScriptName iEquip_KeyHandler extends Quest
{This script sets up and handles all the key assignments and keypress actions}

import Input
Import UI

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_ProMode Property PM Auto
iEquip_RechargeScript Property RC Auto
iEquip_HelpMenu Property HM Auto

Actor Property PlayerRef  Auto
Message Property iEquip_UtilityMenu Auto

; Main gameplay keys
Int Property iShoutKey = 21 Auto Hidden ;Y
Int Property iLeftKey = 34 Auto Hidden ;G
Int Property iRightKey = 35 Auto Hidden ;H
Int Property iConsumableKey = 48 Auto Hidden ;B
Int Property iUtilityKey = 37 Auto Hidden ;K - Active in all modes

; Optional hotkeys
Int Property iOptConsumeKey = -1 Auto Hidden

; Edit Mode Keys
Int Property iEditNextKey = 55 Auto Hidden ;Num *
Int Property iEditPrevKey = 181 Auto Hidden ;Num /
Int Property iEditUpKey = 200 Auto Hidden ;Up arrow
Int Property iEditDownKey = 208 Auto Hidden ;Down arrow
Int Property iEditRightKey = 205 Auto Hidden ;Right arrow
Int Property iEditLeftKey = 203 Auto Hidden ;Left arrow
Int Property iEditScaleUpKey = 78 Auto Hidden ;Num +
Int Property iEditScaleDownKey = 74 Auto Hidden ;Num -
Int Property iEditDepthKey  = 72 Auto Hidden ;Num 8
Int Property iEditRotateKey  = 79 Auto Hidden ;Num 1
Int Property iEditTextKey = 80 Auto Hidden ;Num 2
Int Property iEditAlphaKey = 81 Auto Hidden ;Num 3
Int Property iEditRulersKey = 75 Auto Hidden ;Num 4
Int Property iEditResetKey = 82 Auto Hidden ;Num 0
Int Property iEditLoadPresetKey = 76 Auto Hidden ;Num 5
Int Property iEditSavePresetKey = 77 Auto Hidden ;Num 6
Int Property iEditDiscardKey = 83 Auto Hidden ;Num .

; Delays
float Property fMultiTapDelay = 0.3 Auto Hidden
float Property fLongPressDelay = 0.6 Auto Hidden

; Bools
bool Property bConsumeItemHotkeyEnabled = false Auto Hidden
bool Property bAllowKeyPress = true Auto Hidden
bool bIsUtilityKeyHeld = false
bool bNotInLootMenu = true

; Ints
Int iWaitingKeyCode = 0
Int iMultiTap = 0

; Strings
string sPreviousState = ""

; ------------------
; - GENERAL EVENTS -
; ------------------

function GameLoaded()
    GotoState("")
    
    self.RegisterForMenu("InventoryMenu")
    self.RegisterForMenu("MagicMenu")
    self.RegisterForMenu("FavoritesMenu")
    self.RegisterForMenu("LootMenu")
    self.RegisterForMenu("CustomMenu")
    self.RegisterForMenu("Journal Menu")
    self.RegisterForMenu("Console")
    
    UnregisterForAllKeys() ;Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
    
    bIsUtilityKeyHeld = false
    bNotInLootMenu = true
endFunction

event OnMenuOpen(string MenuName)
    debug.trace("iEquip KeyHandler Menu being opened: "+MenuName)
    if MenuName == "LootMenu"
        bNotInLootMenu = false
    else
        sPreviousState = GetState()
        
        if (MenuName == "FavoritesMenu" || MenuName == "MagicMenu" || MenuName == "InventoryMenu")
            GotoState("INVENTORYMENU")
            RegisterForGameplayKeys()
        else
            GoToState("DISABLED")
        endIf
        
        UnregisterForUpdate()
        iWaitingKeyCode = 0
        iMultiTap = 0
    endIf
endEvent

event OnMenuClose(string MenuName)
    debug.trace("iEquip KeyHandler Menu being closed: "+MenuName)
    if MenuName == "LootMenu"
        bNotInLootMenu = true
    else     
        GotoState(sPreviousState)
    endIf
endEvent

event OnUpdate()
    debug.trace("iEquip KeyHandler OnUpdate called multiTap: "+iMultiTap)
    bAllowKeyPress = false
    
    runUpdate()
    
    iMultiTap = 0
    iWaitingKeyCode = 0
    bAllowKeyPress = true
endEvent

; ---------------------
; - DEFAULT BEHAVIOUR -
; ---------------------

event OnKeyDown(int KeyCode)
    debug.trace("iEquip KeyHandler OnKeyDown called KeyCode: "+KeyCode)
    if KeyCode == iUtilityKey
        bIsUtilityKeyHeld = true
    endIf

    if bAllowKeyPress
        if KeyCode != iWaitingKeyCode && iWaitingKeyCode != 0
            if iWaitingKeyCode != iUtilityKey 
                ; The player pressed a different key, so force the current one to process if there is one
                UnregisterForUpdate()
                OnUpdate()
            endIf
        endIf
        iWaitingKeyCode = KeyCode
    
        if iMultiTap == 0       ; This is the first time the key has been pressed
            RegisterForSingleUpdate(fLongPressDelay)
        elseIf iMultiTap == 1   ; This is the second time the key has been pressed.
            iMultiTap = 2
            RegisterForSingleUpdate(fMultiTapDelay)
        elseIf iMultiTap == 2   ; This is the third time the key has been pressed
            if WC.bProModeEnabled
                iMultiTap = 3
            endIf
            RegisterForSingleUpdate(0.0)
        endIf
    endif
endEvent

event OnKeyUp(Int KeyCode, Float HoldTime)
    debug.trace("iEquip KeyHandler OnKeyUp called KeyCode: "+KeyCode+", HoldTime: "+HoldTime)
    if KeyCode == iUtilityKey
        bIsUtilityKeyHeld = false
    endIf

    if bAllowKeyPress && KeyCode == iWaitingKeyCode && iMultiTap == 0
        iMultiTap = 1
        RegisterForSingleUpdate(fMultiTapDelay)
    endIf
endEvent

function runUpdate()
    ;Handle widget visibility update on any registered key press
    WC.updateWidgetVisibility()
        
    if iMultiTap == 0       ; Long press
            if iWaitingKeyCode == iConsumableKey
                if bNotInLootMenu && !bConsumeItemHotkeyEnabled
                    WC.consumeItem()
                endIf
            elseif iWaitingKeyCode == iLeftKey || iWaitingKeyCode == iRightKey
                if PM.bPreselectMode && bIsUtilityKeyHeld
                    PM.equipAllPreselectedItems()
                else
                    if iWaitingKeyCode == iLeftKey
                        if AM.bAmmoMode
                            AM.toggleAmmoMode(false, false)
                        else
                            RC.rechargeWeapon(0)
                        endIf
                    else
                        RC.rechargeWeapon(1)
                    endIf
                endIf
            endIf
            
    elseIf iMultiTap == 1   ; Single tap
        if iWaitingKeyCode == iUtilityKey
            int iAction = iEquip_UtilityMenu.Show() 
            
            if iAction != 0             ; Exit
                if iAction == 1         ; Queue Menu
                    WC.openQueueManagerMenu()
                elseif iAction == 2     ; Edit Mode
                    toggleEditMode()
                elseif iAction == 3     ; HM
                    ;HM.openHelpMenu()
                    debug.MessageBox("This feature is currently disabled")
                elseif iAction == 4     ; Refresh Widget
                    WC.refreshWidget()
                elseif iAction == 5     ; Debug option
                    jValue.writeTofile(WC.iEquipQHolderObj, "Data/iEquip/Debug/JCDebug.json")
                endIf
            endIf          
        elseIf iWaitingKeyCode == iLeftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            if AM.bAmmoMode || (PM.bPreselectMode && (RHItemType == 7 || RHItemType == 12))
                AM.cycleAmmo(bIsUtilityKeyHeld)
            else
                WC.cycleSlot(0, bIsUtilityKeyHeld)
            endIf
        elseIf iWaitingKeyCode == iRightKey
            WC.cycleSlot(1, bIsUtilityKeyHeld)
        elseIf bNotInLootMenu
            if iWaitingKeyCode == iShoutKey
                if WC.bShoutEnabled
                    WC.cycleSlot(2, bIsUtilityKeyHeld)
                endIf
            elseIf iWaitingKeyCode == iConsumableKey
                if WC.bConsumablesEnabled
                    WC.cycleSlot(3, bIsUtilityKeyHeld)
                elseIf WC.bPoisonsEnabled
                    WC.cycleSlot(4, bIsUtilityKeyHeld)
                endIf
            elseIf iWaitingKeyCode == iOptConsumeKey 
                if bConsumeItemHotkeyEnabled && WC.bConsumablesEnabled
                    WC.consumeItem()
                endIf
            endIf
        endIf
        
    elseIf iMultiTap == 2  ; Double tap
        if iWaitingKeyCode == iConsumableKey 
            if bNotInLootMenu && WC.bConsumablesEnabled && WC.bPoisonsEnabled
                WC.cycleSlot(4, bIsUtilityKeyHeld)
            endIf 
        elseif PM.bPreselectMode
            if iWaitingKeyCode == iLeftKey
                int RHItemType = PlayerRef.GetEquippedItemType(1)
                
                if bIsUtilityKeyHeld
                    PM.equipPreselectedItem(0)
                elseIf AM.bAmmoMode || RHItemType == 7 || RHItemType == 12
                    AM.cycleAmmo(bIsUtilityKeyHeld)
                else
                    WC.applyPoison(0)
                endIf
            else
                if bIsUtilityKeyHeld
                    if iWaitingKeyCode == iRightKey
                        PM.equipPreselectedItem(1)
                    elseIf iWaitingKeyCode == iShoutKey && bNotInLootMenu && PM.bShoutPreselectEnabled && WC.bShoutEnabled
                        PM.equipPreselectedItem(2)
                    endIf
                else
                    if iWaitingKeyCode == iRightKey
                        WC.applyPoison(1)
                    endIf
                endIf
            endIf
        else
            if iWaitingKeyCode == iLeftKey
                if bIsUtilityKeyHeld
                    WC.openQueueManagerMenu(1)
                elseIf AM.bAmmoMode
                    WC.cycleSlot(0, bIsUtilityKeyHeld)
                else
                    WC.applyPoison(0)
                endIf
            else
                if bIsUtilityKeyHeld
                    if iWaitingKeyCode == iRightKey
                        WC.openQueueManagerMenu(2)
                    elseIf iWaitingKeyCode == iShoutKey && bNotInLootMenu
                        WC.openQueueManagerMenu(3)
                    endIf
                else
                    if iWaitingKeyCode == iRightKey
                        WC.applyPoison(1)
                    endIf
                endIf
            endIf             
        endIf
        
    elseIf iMultiTap == 3  ; Triple tap
        if iWaitingKeyCode == iLeftKey
            PM.quickShield()
        elseIf iWaitingKeyCode == iRightKey
            PM.quickRanged()
        elseIf bNotInLootMenu
            if iWaitingKeyCode == iConsumableKey
                PM.quickHeal()
            elseIf iWaitingKeyCode == iShoutKey
                PM.togglePreselectMode()
            endIf
        endIf
    endIf
endFunction

; --------------------
; - OTHER BEHAVIOURS -
; --------------------

; - Inventory
state INVENTORYMENU
    event OnKeyDown(int KeyCode)
        if KeyCode == iUtilityKey
            bIsUtilityKeyHeld = true
        endIf
     
        if bAllowKeyPress
            bAllowKeyPress = false
        
            if KeyCode == iLeftKey
                WC.AddToQueue(0)
            elseIf KeyCode == iRightKey
                WC.AddToQueue(1)
            elseIf KeyCode == iShoutKey
                WC.AddToQueue(2)
            elseIf KeyCode == iConsumableKey
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
            if KeyCode == iWaitingKeyCode && iMultiTap == 0
                float updateTime = 0.0
                iMultiTap = 1
                
                If (KeyCode == iEditRotateKey || KeyCode == iEditRulersKey)
                    updateTime = fMultiTapDelay
                endIf
                
                RegisterForSingleUpdate(updateTime)
            endIf
        endIf
    endEvent

    function runUpdate()
        if iMultiTap == 0       ; Long press
            if iWaitingKeyCode == iEditNextKey || iWaitingKeyCode == iEditPrevKey
                EM.ToggleCycleRange()
            elseIf iWaitingKeyCode == iEditAlphaKey
                EM.IncrementStep(2)
            elseIf iWaitingKeyCode == iEditRotateKey
                EM.IncrementStep(1)
            elseIf (iWaitingKeyCode == iEditLeftKey || iWaitingKeyCode == iEditRightKey || iWaitingKeyCode == iEditUpKey ||\
                    iWaitingKeyCode == iEditDownKey || iWaitingKeyCode == iEditScaleUpKey || iWaitingKeyCode == iEditScaleDownKey)
                EM.IncrementStep(0)
            elseIf iWaitingKeyCode == iEditTextKey
                EM.ShowColorSelection(2) ;Text color
            elseIf iWaitingKeyCode == iEditRulersKey
                EM.ShowColorSelection(0) ;Highlight color
            endIf
            
        elseIf iMultiTap == 1   ; Single tap
            if iWaitingKeyCode == iEditUpKey
                EM.MoveElement(0)
            elseIf iWaitingKeyCode == iEditDownKey
                EM.MoveElement(1)
            elseIf iWaitingKeyCode == iEditLeftKey
                EM.MoveElement(2)
            elseIf iWaitingKeyCode == iEditRightKey
                EM.MoveElement(3)
            elseIf iWaitingKeyCode == iEditScaleUpKey
                EM.ScaleElement(0)
            elseIf iWaitingKeyCode == iEditScaleDownKey
                EM.ScaleElement(1)
            elseIf iWaitingKeyCode == iEditRotateKey
                EM.RotateElement()
            elseIf iWaitingKeyCode == iEditAlphaKey
                EM.SetElementAlpha()
            elseIf iWaitingKeyCode == iEditDepthKey
                EM.SwapElementDepth()
            elseIf iWaitingKeyCode == iEditTextKey
                EM.ToggleTextAlignment()
            elseIf iWaitingKeyCode == iEditNextKey
                EM.CycleElements(1)
            elseIf iWaitingKeyCode == iEditPrevKey
                EM.CycleElements(-1)
            elseIf iWaitingKeyCode == iEditResetKey
                EM.ResetElement()
            elseIf iWaitingKeyCode == iEditLoadPresetKey
                EM.ShowPresetList()
            elseIf iWaitingKeyCode == iEditSavePresetKey
                EM.SavePreset()
            elseIf iWaitingKeyCode == iEditRulersKey
                EM.ToggleRulers()
            elseIf iWaitingKeyCode == iEditDiscardKey
                EM.DiscardChanges()
            elseIf iWaitingKeyCode == iUtilityKey
                ToggleEditMode()
            endIf
            
        elseIf iMultiTap == 2  ; Double tap
            if iWaitingKeyCode == iEditRotateKey
                EM.ToggleRotation()
            elseIf iWaitingKeyCode == iEditRulersKey
                EM.ShowColorSelection(1) ;Current item info color
            endIf
            
        endIf
    endFunction
endState

; - Disabled
state DISABLED
    event OnBeginState()
        bAllowKeyPress = false
    endEvent
    
    event OnEndState()
        bAllowKeyPress = true
    endEvent
endState

; -----------------
; - MISCELLANEOUS -
; -----------------

function ToggleEditMode()
    debug.trace("iEquip KeyHandler toggleEditMode called")
    if EM.isEditMode
        GoToState("")
    else
        GoToState("EDITMODE")
    endIf
    EM.ToggleEditMode()
    updateKeyMaps()
endFunction

function updateKeyMaps()
    UnregisterForAllKeys()   
    if EM.isEditMode
        int[] keys = new int[18]
        keys[0] = iUtilityKey
        keys[1] = iEditPrevKey
        keys[2] = iEditNextKey
        keys[3] = iEditUpKey
        keys[4] = iEditDownKey
        keys[5] = iEditLeftKey
        keys[6] = iEditRightKey
        keys[7] = iEditScaleUpKey
        keys[8] = iEditScaleDownKey
        keys[9] = iEditRotateKey
        keys[10] = iEditAlphaKey
        keys[11] = iEditTextKey
        keys[12] = iEditDepthKey
        keys[13] = iEditRulersKey
        keys[14] = iEditResetKey
        keys[15] = iEditLoadPresetKey
        keys[16] = iEditSavePresetKey
        keys[17] = iEditDiscardKey
        
        InvokeIntA(WC.HUD_MENU, WC.WidgetRoot + ".setEditModeButtons", keys)       
        RegisterForEditModeKeys()
    else
        RegisterForGameplayKeys()
    endIf
endFunction

function resetEditModeKeys()
    iEditNextKey = 55
    iEditPrevKey = 181
    iEditUpKey = 200
    iEditDownKey = 208
    iEditLeftKey = 203
    iEditRightKey = 205
    iEditScaleUpKey = 78
    iEditScaleDownKey = 74
    iEditRotateKey = 80
    iEditAlphaKey = 81
    iEditDepthKey = 72
    iEditTextKey = 79
    iEditRulersKey = 77
    iEditResetKey = 82
    iEditLoadPresetKey = 75
    iEditSavePresetKey = 76
    iEditDiscardKey = 83
endFunction

function RegisterForGameplayKeys()
    debug.trace("iEquip KeyHandler RegisterForGameplayKeys called")
    RegisterForKey(iShoutKey)
    RegisterForKey(iLeftKey)
    RegisterForKey(iRightKey)
    RegisterForKey(iConsumableKey)
    RegisterForKey(iUtilityKey)
    if bConsumeItemHotkeyEnabled
        RegisterForKey(iOptConsumeKey)
    endIf
endFunction

function RegisterForEditModeKeys()
    debug.trace("iEquip KeyHandler RegisterForEditModeKeys called")
    RegisterForKey(iEditLeftKey)
    RegisterForKey(iEditRightKey)
    RegisterForKey(iEditUpKey)
    RegisterForKey(iEditDownKey)
    RegisterForKey(iEditScaleUpKey)
    RegisterForKey(iEditScaleDownKey)
    RegisterForKey(iEditNextKey)
    RegisterForKey(iEditPrevKey)
    RegisterForKey(iEditResetKey)
    RegisterForKey(iEditLoadPresetKey)
    RegisterForKey(iEditSavePresetKey)
    RegisterForKey(iEditRotateKey)
    RegisterForKey(iEditDepthKey)
    RegisterForKey(iEditAlphaKey)
    RegisterForKey(iEditTextKey)
    RegisterForKey(iEditRulersKey)
    RegisterForKey(iEditDiscardKey)
    RegisterForKey(iUtilityKey)
endFunction
