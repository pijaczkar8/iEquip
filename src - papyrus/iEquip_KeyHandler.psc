ScriptName iEquip_KeyHandler extends Quest
;This script sets up and handles all the key assignments and keypress actions

import Input
Import UI

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_ProMode Property PM Auto
iEquip_MCM Property MCM Auto
iEquip_RechargeScript Property RC Auto
iEquip_HelpMenu Property HM Auto

Actor Property PlayerRef  Auto
Message Property iEquip_UtilityMenu Auto
Perk Property Enchanter00 Auto ;Used if Requiem detected - Requiem renames this perk to REQ_Perk_Enchanting_EnchantersInsight1

;Main gameplay keys
Int Property iShoutKey = 21 Auto Hidden ;Y
Int Property iLeftKey = 34 Auto Hidden ;G
Int Property iRightKey = 35 Auto Hidden ;H
Int Property iConsumableKey = 48 Auto Hidden ;B
Int Property iUtilityKey = 29 Auto Hidden ;Left Ctrl - Active in all modes

;Optional hotkeys
Int Property iOptConsumeKey = -1 Auto Hidden
Int Property iOptDirQueueKey = -1 Auto Hidden

;Edit Mode Keys
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
bool Property bAllowKeyPress = true Auto Hidden
bool bIsUtilityKeyHeld = false
bool bIsQueueMenuComboKeyKeyHeld = false
bool bNotInLootMenu = true
bool bIsRequiemLoaded = false

; Ints
int Property iUtilityKeyDoublePress = 0 Auto Hidden
Int iWaitingKeyCode = 0
Int iMultiTap = 0

; MCM settings
bool property bConsumeItemHotkeyEnabled = false auto hidden
bool property bQueueMenuComboKeyEnabled = false auto hidden
bool property bPreselectEnabled = false auto hidden
bool property bQuickShieldEnabled = false auto hidden
bool property bQuickRangedEnabled = false auto hidden
bool property bQuickHealEnabled = false auto hidden

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
    self.RegisterForMenu("Journal Menu")
    self.RegisterForMenu("LootMenu")
    
    UnregisterForAllKeys() ;Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
    
    bIsUtilityKeyHeld = false
    bNotInLootMenu = true

    if Game.GetModByName("Requiem.esp") != 255
        bIsRequiemLoaded = true
    else
        bIsRequiemLoaded = false
    endIf
endFunction

event OnMenuOpen(string MenuName)
    if MenuName == "LootMenu"
        bNotInLootMenu = false
    else
        sPreviousState = GetState()
        GotoState("INVENTORYMENU")
        
        UnregisterForUpdate()
        iWaitingKeyCode = 0
        iMultiTap = 0
        
        RegisterForGameplayKeys()
    endIf
endEvent

event OnMenuClose(string MenuName)
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
    if KeyCode == iUtilityKey && !bIsQueueMenuComboKeyKeyHeld
        bIsUtilityKeyHeld = true
    elseIf KeyCode == iOptDirQueueKey && bQueueMenuComboKeyEnabled && !bIsUtilityKeyHeld
        bIsQueueMenuComboKeyKeyHeld = true
        GoToState("QUEUEMENUCOMBOKEYHELD")
    endIf

    if bAllowKeyPress
        if KeyCode != iWaitingKeyCode && iWaitingKeyCode != 0
            ; The player pressed a different key, so force the current one to process if there is one
            UnregisterForUpdate()
            OnUpdate()
        endIf
        iWaitingKeyCode = KeyCode
    
        if iMultiTap == 0 ; This is the first time the key has been pressed
            RegisterForSingleUpdate(fLongPressDelay)
        elseIf iMultiTap == 1 ;This is the second time the key has been pressed.
            iMultiTap = 2
            RegisterForSingleUpdate(fMultiTapDelay)
        elseIf iMultiTap == 2 ; This is the third time the key has been pressed
            iMultiTap = 3
            RegisterForSingleUpdate(0.0)
        endIf
    endif
endEvent

event OnKeyUp(Int KeyCode, Float HoldTime)
    debug.trace("iEquip KeyHandler OnKeyUp called KeyCode: "+KeyCode+", HoldTime: "+HoldTime)
    if KeyCode == iUtilityKey
        bIsUtilityKeyHeld = false
    elseIf KeyCode == iOptDirQueueKey
        bIsQueueMenuComboKeyKeyHeld = false
    endIf

    if bAllowKeyPress
        if KeyCode == iWaitingKeyCode && iMultiTap == 0
            iMultiTap = 1
            RegisterForSingleUpdate(fMultiTapDelay)
        endIf
    endIf
endEvent

function runUpdate()
    ;Handle widget visibility update on any registered key press
    WC.updateWidgetVisibility()
        
    if iMultiTap == 0  ; Long press
            if iWaitingKeyCode == iConsumableKey
                if bNotInLootMenu && WC.bConsumablesEnabled && !bConsumeItemHotkeyEnabled
                    WC.consumeItem()
                endIf
            
            elseIf PM.bPreselectMode
                if iWaitingKeyCode == iLeftKey || iWaitingKeyCode == iRightKey
                    if bIsUtilityKeyHeld
                        PM.equipAllPreselectedItems()
                    else
                        if iWaitingKeyCode == iLeftKey
                            PM.equipPreselectedItem(0) 
                        else
                            PM.equipPreselectedItem(1)
                        endIf
                    endIf
                elseIf iWaitingKeyCode == iShoutKey
                    if bNotInLootMenu && PM.bShoutPreselectEnabled && WC.bShoutEnabled
                        PM.equipPreselectedItem(2)
                    endIf
                endIf
                
            elseIf iWaitingKeyCode == iLeftKey
                if AM.bAmmoMode
                    AM.toggleAmmoMode(false, false)
                else
                    if bIsRequiemLoaded && !PlayerRef.HasPerk(Enchanter00)
                        debug.notification("$iEquip_RequiemEnchantingPerkMissing")
                    else
                        RC.rechargeWeapon(0)
                    endIf
                endIf
            elseIf iWaitingKeyCode == iRightKey
                if bIsRequiemLoaded && !PlayerRef.HasPerk(Enchanter00)
                    debug.notification("$iEquip_RequiemEnchantingPerkMissing")
                else
                    RC.rechargeWeapon(1)
                endIf
            endIf
        
    elseIf iMultiTap == 1  ; Single tap
        If iWaitingKeyCode == iLeftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            if AM.bAmmoMode || (PM.bPreselectMode && (RHItemType == 7 || RHItemType == 12))
                AM.cycleAmmo(bIsUtilityKeyHeld)
            else
                WC.cycleSlot(0, bIsUtilityKeyHeld)
            endIf

        elseIf iWaitingKeyCode == iRightKey
            WC.cycleSlot(1, bIsUtilityKeyHeld)

        elseIf iWaitingKeyCode == iShoutKey
            if bNotInLootMenu && WC.bShoutEnabled
                WC.cycleSlot(2, bIsUtilityKeyHeld)
            endIf
                
        elseIf iWaitingKeyCode == iConsumableKey
            if bNotInLootMenu
                if WC.bConsumablesEnabled
                    WC.cycleSlot(3, bIsUtilityKeyHeld)
                elseIf WC.bPoisonsEnabled
                    WC.cycleSlot(4, bIsUtilityKeyHeld)
                endIf
            endIf

        elseIf iWaitingKeyCode == iOptConsumeKey 
            if bConsumeItemHotkeyEnabled && bNotInLootMenu && WC.bConsumablesEnabled
                WC.consumeItem()
            endIf

        elseIf iWaitingKeyCode == iUtilityKey
            ;0 = Exit, 1 = Queue Menu, 2 = Edit Mode, 3 = Help, 4 = Refresh Widget
            int iAction = iEquip_UtilityMenu.Show() 
            
            if iAction != 0 ;Exit
                if iAction == 1
                    WC.openQueueManagerMenu()
                elseif iAction == 2
                    toggleEditMode()
                elseif iAction == 3
                    ;HM.openHelpMenu()
                    debug.MessageBox("This feature is currently disabled")
                elseif iAction == 4
                    WC.refreshWidget()
                endIf
            endIf
        endIf
        
    elseIf iMultiTap == 2  ; Double tap
        if iWaitingKeyCode == iConsumableKey
            if bNotInLootMenu && WC.bConsumablesEnabled && WC.bPoisonsEnabled
                WC.cycleSlot(4, bIsUtilityKeyHeld)
            endIf
        elseIf iWaitingKeyCode == iLeftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            
            if AM.bAmmoMode || (PM.bPreselectMode && (RHItemType == 7 || RHItemType == 12))
                WC.cycleSlot(0, bIsUtilityKeyHeld)
            elseIf WC.bPoisonsEnabled
                WC.applyPoison(0)
            endIf
        elseIf iWaitingKeyCode == iRightKey && WC.bPoisonsEnabled
            WC.applyPoison(1)
        endIf
        
    elseIf WC.bProModeEnabled && iMultiTap == 3  ;Triple tap
        if iWaitingKeyCode == iShoutKey && bPreselectEnabled && bNotInLootMenu
            PM.togglePreselectMode()
        elseIf iWaitingKeyCode == iLeftKey && bQuickShieldEnabled
            PM.quickShield()
        elseIf iWaitingKeyCode == iRightKey && bQuickRangedEnabled
            PM.quickRanged()
        elseIf iWaitingKeyCode == iConsumableKey && bQuickHealEnabled && bNotInLootMenu
            PM.quickHeal()
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
        if iMultiTap == 0   ; Long press
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
            
        elseIf iMultiTap == 1  ;Single tap
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

;Direct Queue Menu Combo Key Held
state QUEUEMENUCOMBOKEYHELD
    event OnKeyUp(Int KeyCode, Float HoldTime)
        debug.trace("iEquip_KeyHandler OnKeyUp called in QUEUEMENUCOMBOKEYHELD state")
        if KeyCode == iUtilityKey
            bIsUtilityKeyHeld = false
        elseIf KeyCode == iOptDirQueueKey
            bIsQueueMenuComboKeyKeyHeld = false
            Gotostate("")
        endIf

        if bAllowKeyPress
            if KeyCode == iWaitingKeyCode && iMultiTap == 0
                iMultiTap = 1                
                RegisterForSingleUpdate(fMultiTapDelay)
            endIf
        endIf
    endEvent

    function runUpdate()
        debug.trace("iEquip_KeyHandler runUpdate called in QUEUEMENUCOMBOKEYHELD state - iMultiTap == " + iMultiTap)
        ;Handle widget visibility update on any registered key press
        WC.updateWidgetVisibility()
        if iMultiTap == 1  ;Single tap
            if iWaitingKeyCode == iLeftKey
                WC.openQueueManagerMenu(1)
            elseIf iWaitingKeyCode == iRightKey
                WC.openQueueManagerMenu(2)
            elseIf iWaitingKeyCode == iShoutKey
                WC.openQueueManagerMenu(3)
            elseIf iWaitingKeyCode == iConsumableKey
                WC.openQueueManagerMenu(4)
            endIf
            
        elseIf iMultiTap == 2  ; Double tap
            if iWaitingKeyCode == iConsumableKey
                WC.openQueueManagerMenu(5)
            endIf
            
        endIf
    endFunction
endState

; -----------------
; - MISCELLANEOUS -
; -----------------

function ToggleEditMode()
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
    
    EM.ToggleEditMode()
endFunction

function updateKeyMaps()
    UnregisterForAllKeys()
    
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
    
    if EM.isEditMode
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
    if bQueueMenuComboKeyEnabled
        RegisterForKey(iOptDirQueueKey)
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
