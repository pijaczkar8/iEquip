ScriptName iEquip_KeyHandler extends Quest
{This script sets up and handles all the key assignments and keypress actions}

import Input
Import UI
import iEquip_StringExt

iEquip_EditMode property EM auto
iEquip_WidgetCore property WC auto
iEquip_AmmoMode property AM auto
iEquip_BeastMode property BM auto
iEquip_ProMode property PM auto
iEquip_RechargeScript property RC auto
iEquip_HelpMenu property HM auto
iEquip_TorchScript property TO auto
iEquip_ThrowingPoisons property TP auto

Actor property PlayerRef  auto

; Main gameplay keys
int property iLeftKey = 34 auto hidden ;G
int property iRightKey = 35 auto hidden ;H
int property iShoutKey = 21 auto hidden ;Y
int property iConsumableKey = 48 auto hidden ;B
int property iUtilityKey = 37 auto hidden ;K - Active in all modes

globalvariable property iEquipLeftKey auto
globalvariable property iEquipRightKey auto
globalvariable property iEquipShoutKey auto
globalvariable property iEquipConsumableKey auto
globalvariable property iEquipUtilityKey auto

; Optional hotkeys
int property iConsumeItemKey = -1 auto hidden
int property iCyclePoisonKey = -1 auto hidden
int property iQuickLightKey = -1 auto hidden
int property iQuickRestoreKey = -1 auto hidden
int property iQuickShieldKey = -1 auto hidden
int property iQuickRangedKey = -1 auto hidden
int property iThrowingPoisonsKey = -1 auto hidden

; Edit Mode Keys
int property iEditNextKey = 55 auto hidden ;Num *
int property iEditPrevKey = 181 auto hidden ;Num /
int property iEditUpKey = 200 auto hidden ;Up arrow
int property iEditDownKey = 208 auto hidden ;Down arrow
int property iEditRightKey = 205 auto hidden ;Right arrow
int property iEditLeftKey = 203 auto hidden ;Left arrow
int property iEditScaleUpKey = 78 auto hidden ;Num +
int property iEditScaleDownKey = 74 auto hidden ;Num -
int property iEditDepthKey  = 72 auto hidden ;Num 8
int property iEditRotateKey  = 79 auto hidden ;Num 1
int property iEditTextKey = 80 auto hidden ;Num 2
int property iEditAlphaKey = 81 auto hidden ;Num 3
int property iEditRulersKey = 75 auto hidden ;Num 4
int property iEditResetKey = 82 auto hidden ;Num 0
int property iEditLoadPresetKey = 76 auto hidden ;Num 5
int property iEditSavePresetKey = 77 auto hidden ;Num 6
int property iEditDiscardKey = 83 auto hidden ;Num .

; Delays
float property fMultiTapDelay = 0.3 auto hidden
float property fLongPressDelay = 0.6 auto hidden

; Bools
bool property bDisableAddToQueue auto hidden
bool property bNoUtilMenuInCombat auto hidden
bool property bExtendedKbControlsEnabled auto hidden
bool property bAllowKeyPress = true auto hidden
bool bIsUtilityKeyHeld
bool bUtilityKeyDownReceived
bool bIsUtilityMenu
bool _bPlayerIsABeast
bool property bIsGPPLoaded auto hidden
bool bGPPKeyHeld

; Ints
int iWaitingKeyCode = -1
int iMultiTap

int[] aiGPPComboKeys
int[] aiExtKbKeys
int[] aiSingleFunctionKeys

; Strings
string sPreviousState

; ------------------
; - GENERAL EVENTS -
; ------------------

event onInit()
    aiGPPComboKeys = new int[4]
    aiExtKbKeys = new int[6]
    aiSingleFunctionKeys = new int[6]
    int i
    while i < 6
        if i < 4
           aiGPPComboKeys[i] = -1
        endIf
        aiExtKbKeys[i] = -1
        aiSingleFunctionKeys[i] = -1
        i += 1
    endWhile
endEvent

function GameLoaded()
    ;debug.trace("iEquip_KeyHandler GameLoaded start")
    GotoState("")
    
    RegisterForMenus()
    
    UnregisterForAllKeys() ; Re-enabled by onWidgetLoad once widget is ready to prevent any wierdness with keys being pressed before the widget has refreshed
    updateExtKbKeysArray()

    SendModEvent("iEquip_KeyHandlerReady")
    
    iWaitingKeyCode = -1
    iMultiTap = 0
    bIsUtilityKeyHeld = false
    bGPPKeyHeld = false
    ;debug.trace("iEquip_KeyHandler GameLoaded end")
endFunction

function setKeysForGamepad()
    iLeftKey = 268                       ; Dpad Left
    iRightKey = 269                      ; DPad Right
    iShoutKey = 266                      ; DPad Up
    iConsumableKey = 267                 ; DPad Down
    iUtilityKey = 277                    ; B
    iEquipLeftKey.SetValueInt(iLeftKey)
    iEquipRightKey.SetValueInt(iRightKey)
    iEquipShoutKey.SetValueInt(iShoutKey)
    iEquipConsumableKey.SetValueInt(iConsumableKey)
    iEquipUtilityKey.SetValueInt(iUtilityKey)
    SendModEvent("iEquip_KeysUpdated")
endFunction

function RegisterForMenus()
    RegisterForMenu("BarterMenu")
    RegisterForMenu("Book Menu")
    RegisterForMenu("Console")
    RegisterForMenu("Console Native UI Menu")
    RegisterForMenu("ContainerMenu")
    RegisterForMenu("Crafting Menu")
    ;RegisterForMenu("Credits Menu")
    ;RegisterForMenu("Cursor Menu")
    RegisterForMenu("CustomMenu")
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
    RegisterForMenu("LootMenu")
    RegisterForMenu("Loot Menu")
    RegisterForMenu("MagicMenu")
    RegisterForMenu("Main Menu")
    RegisterForMenu("MapMenu")
    RegisterForMenu("MessageBoxMenu")
    ;RegisterForMenu("Mist Menu")
    ;RegisterForMenu("Overlay Interaction Menu")
    ;RegisterForMenu("Overlay Menu")
    RegisterForMenu("Quantity Menu")
    RegisterForMenu("RaceSex Menu")
    RegisterForMenu("Sleep/Wait Menu")
    RegisterForMenu("StatsMenu")
    ;RegisterForMenu("TitleSequence Menu")
    ;RegisterForMenu("Top Menu")
    RegisterForMenu("Training Menu")
    RegisterForMenu("Tutorial Menu")
    RegisterForMenu("TweenMenu")
endfunction

function registerForGPP(bool bGPPLoaded)
    ;debug.trace("iEquip_KeyHandler registerForGPP - bGPPLoaded: " + bGPPLoaded)
    bIsGPPLoaded = bGPPLoaded

    if bGPPLoaded
        Self.RegisterForModEvent("GPP_ComboKeysUpdated", "onGPPComboKeysUpdated")
        registerForGPPKeys()
    else
        unregisterForGPPKeys()
        Self.UnregisterForModEvent("GPP_ComboKeysUpdated")
    endIf
endFunction

event onGPPComboKeysUpdated(string sEventName, string sStringArg, Float fNumArg, Form kSender)
    ;debug.trace("iEquip_KeyHandler onGPPComboKeysUpdated")
    If(sEventName == "GPP_ComboKeysUpdated")
        registerForGPPKeys()
    endIf
    ;debug.trace("iEquip_KeyHandler onGPPComboKeysUpdated end")
endEvent

function registerForGPPKeys()
    ;debug.trace("iEquip_KeyHandler registerForGPPKeys")
    int i
    int hexBase = 0x00003DE2   ; esp

    if !Game.GetFormFromFile(hexBase, "Gamepad++.esp")
        ;debug.trace("iEquip_KeyHandler registerForGPPKeys - esl version detected")
        hexBase = 0x00000801    ; esl
    endIf
    
    unregisterForGPPKeys()
    
    while i < 4
        int tmpKey = (Game.GetFormFromFile(hexBase + i, "Gamepad++.esp") as GlobalVariable).GetValueInt()
        
        if (tmpKey != iUtilityKey && tmpKey != -1)
            aiGPPComboKeys[i] = tmpKey
            ;debug.trace("iEquip_KeyHandler registerForGPPKeys - about to register for GPP combo key " + i + ": " + tmpKey)
            RegisterForKey(tmpKey)
        endIf
        
        i += 1
    endWhile
endFunction

function unregisterForGPPKeys()
    int i
    while i < 4
        if aiGPPComboKeys[i] != -1 && aiGPPComboKeys[i] != iUtilityKey
            UnregisterForKey(aiGPPComboKeys[i])
        endIf
        aiGPPComboKeys[i] = -1
        i += 1
    endWhile
endFunction

function updateExtKbKeysArray()
    aiExtKbKeys[0] = iQuickLightKey
    if bExtendedKbControlsEnabled
        aiExtKbKeys[1] = iQuickShieldKey
        aiExtKbKeys[2] = iQuickRangedKey
        aiExtKbKeys[3] = iQuickRestoreKey
        aiExtKbKeys[4] = iCyclePoisonKey
        aiExtKbKeys[5] = iConsumeItemKey
    else
        aiExtKbKeys[1] = -1
        aiExtKbKeys[2] = -1
        aiExtKbKeys[3] = -1
        aiExtKbKeys[4] = -1
        aiExtKbKeys[5] = -1
    endIf
    aiSingleFunctionKeys = aiExtKbKeys
    aiSingleFunctionKeys[0] = iThrowingPoisonsKey
endFunction

bool property bPlayerIsABeast
    bool function Get()
        return _bPlayerIsABeast
    endFunction

    function Set(bool inBeastForm)
        ;debug.trace("iEquip_KeyHandler bPlayerIsABeast Set() start")
        _bPlayerIsABeast = inBeastForm
         ;debug.trace("iEquip_KeyHandler bPlayerIsABeast Set() - bPlayerIsABeast: " + inBeastForm)
        if inBeastForm
            gotoState("BEASTMODE")
        else
            gotoState("")
        endIf
        ;debug.trace("iEquip_KeyHandler bPlayerIsABeast Set() - state set to: " + GetState())
    endFunction
endProperty

event OnMenuOpen(string MenuName)
    ;debug.trace("iEquip_KeyHandler OnMenuOpen start - Menu being opened: "+MenuName)

    sPreviousState = GetState()
    UnregisterForKey(iUtilityKey)
    
    if (MenuName == "FavoritesMenu" || MenuName == "MagicMenu" || MenuName == "InventoryMenu")
        GotoState("INVENTORYMENU")
        if MenuName == "FavoritesMenu" && bIsGPPLoaded
            registerForGPPKeys()
        endIf
    else
        GoToState("DISABLED")
    endIf
    ;debug.trace("iEquip_KeyHandler OnMenuOpen - state set to: " + GetState())
    UnregisterForUpdate()
    iWaitingKeyCode = -1
    iMultiTap = 0

    ; Just in case
    bIsUtilityKeyHeld = false
    bGPPKeyHeld = false
    ;debug.trace("iEquip_KeyHandler OnMenuOpen end")
endEvent

event OnMenuClose(string MenuName)
    ;debug.trace("iEquip_KeyHandler OnMenuClose start - Menu being closed: "+MenuName+", IsInMenuMode: " + utility.IsInMenuMode() + ", previous state: " + sPreviousState)

    if MenuName == "MessageBoxMenu" && bIsUtilityMenu
        bIsUtilityMenu = false
        Utility.WaitMenuMode(0.5)
    endIf

    if !utility.IsInMenuMode() && !UI.IsMenuOpen("Dialogue Menu") && !UI.IsMenuOpen("Crafting Menu")
        if EM.isEditMode
            GoToState("EDITMODE")
        else
            RegisterForGameplayKeys()
            If _bPlayerIsABeast
                GoToState("BEASTMODE")
            else
                GoToState("")
            endIf
        endIf

        if Game.UsingGamepad() && iUtilityKey == 277
            UnregisterForKey(iUtilityKey)
            Utility.Wait(0.5)
            RegisterForKey(iUtilityKey)
        endIf
        
    else
        GotoState(sPreviousState)
    endIf
    
    bIsUtilityKeyHeld = false
    bGPPKeyHeld = false
    ;debug.trace("iEquip_KeyHandler OnMenuClose end - state set to: " + GetState())
endEvent

event OnUpdate()
    ;debug.trace("iEquip_KeyHandler OnUpdate start - multiTap: "+iMultiTap)
    bAllowKeyPress = false
    
    runUpdate()
    
    iMultiTap = 0
    iWaitingKeyCode = -1
    bAllowKeyPress = true
    ;debug.trace("iEquip_KeyHandler OnUpdate end")
endEvent

; ---------------------
; - DEFAULT BEHAVIOUR -
; ---------------------

event OnKeyDown(int KeyCode)
    ;debug.trace("iEquip_KeyHandler OnKeyDown start - KeyCode: " + KeyCode + ", iWaitingKeyCode: " + iWaitingKeyCode)
    
    if KeyCode == iUtilityKey
        bIsUtilityKeyHeld = true
        bUtilityKeyDownReceived = true
    elseIf bIsGPPLoaded && aiGPPComboKeys.Find(KeyCode) > -1
        bGPPKeyHeld = true
    endIf

    ;debug.trace("iEquip_KeyHandler OnKeyDown - bGPPKeyHeld: " + bGPPKeyHeld + ", bIsUtilityKeyHeld: " + bIsUtilityKeyHeld + ", bAllowKeyPress: " + bAllowKeyPress)

    if bAllowKeyPress && (!bGPPKeyHeld || (aiExtKbKeys.Find(KeyCode) > -1 || KeyCode == iQuickLightKey || KeyCode == iThrowingPoisonsKey))
        if KeyCode != iWaitingKeyCode && iWaitingKeyCode != -1
            if iWaitingKeyCode != iUtilityKey 
                ; The player pressed a different key, so force the current one to process if there is one
                UnregisterForUpdate()
                OnUpdate()
            else
                iMultiTap = 0
            endIf
        endIf
        iWaitingKeyCode = KeyCode
    
        if iMultiTap == 0       ; This is the first time the key has been pressed
            RegisterForSingleUpdate(fLongPressDelay)
        elseIf iMultiTap == 1   ; This is the second time the key has been pressed.
            iMultiTap = 2
            RegisterForSingleUpdate(fMultiTapDelay)
        elseIf iMultiTap == 2   ; This is the third time the key has been pressed
            iMultiTap = 3
            RegisterForSingleUpdate(0.0)
        endIf
    endif
    ;debug.trace("iEquip_KeyHandler OnKeyDown end")
endEvent

event OnKeyUp(int KeyCode, Float HoldTime)
    ;debug.trace("iEquip_KeyHandler OnKeyUp start - KeyCode: "+KeyCode+", HoldTime: "+HoldTime)
    
    if KeyCode == iUtilityKey
        bIsUtilityKeyHeld = false
    elseIf bGPPKeyHeld && aiGPPComboKeys.Find(KeyCode) > -1
        bGPPKeyHeld = false
        int i
        while i < 4 && !bGPPKeyHeld
            if aiGPPComboKeys[i] != -1
                bGPPKeyHeld = IsKeyPressed(aiGPPComboKeys[i])
            endIf
            i += 1
        endWhile
    endIf

    if bAllowKeyPress && KeyCode == iWaitingKeyCode && iMultiTap == 0
        iMultiTap = 1
        if aiSingleFunctionKeys.Find(KeyCode) != -1 || (KeyCode == iConsumableKey && bExtendedKbControlsEnabled && iCyclePoisonKey != -1 && iQuickRestoreKey != -1) || (KeyCode == iQuickLightKey && PlayerRef.GetEquippedItemType(0) != 11)
            RegisterForSingleUpdate(0.0)
        else
            RegisterForSingleUpdate(fMultiTapDelay)
        endIf
    endIf
    ;debug.trace("iEquip_KeyHandler OnKeyUp end")
endEvent

function runUpdate()
    ;debug.trace("iEquip_KeyHandler runUpdate start")
    ;Handle widget visibility update on any registered key press
    WC.updateWidgetVisibility()

    ;debug.trace("iEquip_KeyHandler runUpdate - is Loot Menu open: " + IsMenuOpen("Loot Menu") + ", is Loot Menu visible: " + UI.GetBool("Loot Menu", "_root.Menu_mc._visible"))
  
    if iMultiTap == 0 ; Long press
        if iWaitingKeyCode == iConsumableKey
            if !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true)
                WC.consumeItem()
            endIf
        elseIf iWaitingKeyCode == iShoutKey && !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true) && PM.bPreselectMode && WC.bShoutEnabled && PM.bShoutPreselectEnabled && PM.abPreselectSlotEnabled[2]
            PM.equipAllPreselectedItems()
        elseif iWaitingKeyCode == iLeftKey || iWaitingKeyCode == iRightKey
            if PM.bPreselectMode
                if bIsUtilityKeyHeld
                    RC.rechargeWeapon((iWaitingKeyCode == iRightKey) as int)
                elseIf WC.bPlayerIsMounted
                    PM.equipPreselectedItem(1)
                else
                    PM.equipAllPreselectedItems(true)
                endIf
            else
                if iWaitingKeyCode == iLeftKey && !WC.bPlayerIsMounted
                    if AM.bAmmoMode
                        if !AM.bSimpleAmmoMode
                            AM.toggleAmmoMode()
                        endIf
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
            if bUtilityKeyDownReceived ; This should stop the Utility Menu from triggering if player has just exited another menu using controller B as we won't have received the OnKeyDown event whilst in a menu
                if PlayerRef.IsInCombat() && bNoUtilMenuInCombat
                    debug.notification(iEquip_StringExt.LocalizeString("$iEquip_utilitymenu_notWithWeaponsDrawn"))
                else
                    bIsUtilityMenu = true
                    int iAction = WC.showTranslatedMessage(3, iEquip_StringExt.LocalizeString("$iEquip_utilitymenu_title"))
                    
                    if iAction != 0             ; Exit
                        if iAction == 1         ; Queue Menu
                            WC.openQueueManagerMenu()
                        elseif iAction == 2     ; Edit Mode
                            toggleEditMode()
                        else;if iAction == 3     ; Help Menu
                            HM.showHelpMenuMain()
                        endIf
                    endIf
                endIf
            endIf        
        elseIf iWaitingKeyCode == iLeftKey
            int RHItemType = PlayerRef.GetEquippedItemType(1)
            
            if AM.bAmmoMode || (PM.bPreselectMode && (RHItemType == 7 || RHItemType == 12))
                AM.cycleAmmo(bIsUtilityKeyHeld, false, true)
            elseIf !WC.bPlayerIsMounted
                WC.cycleSlot(0, bIsUtilityKeyHeld, false, false, true)
            endIf
        elseIf iWaitingKeyCode == iRightKey
            WC.cycleSlot(1, bIsUtilityKeyHeld, false, false, true)
        elseIf iWaitingKeyCode == iQuickLightKey
            TO.quickLight()
        elseIf iWaitingKeyCode == iThrowingPoisonsKey
            TP.OnThrowingPoisonKeyPressed()
        
        ; Extended Keyboard Controls
        elseIf iWaitingKeyCode == iConsumeItemKey && bExtendedKbControlsEnabled && WC.bConsumablesEnabled
            WC.consumeItem()
        elseIf iWaitingKeyCode == iCyclePoisonKey && bExtendedKbControlsEnabled && WC.bPoisonsEnabled
            WC.cycleSlot(4, bIsUtilityKeyHeld, false, false, true)
        elseIf iWaitingKeyCode == iQuickRestoreKey && bExtendedKbControlsEnabled
            PM.quickRestore()
        elseIf iWaitingKeyCode == iQuickShieldKey && bExtendedKbControlsEnabled && !WC.bPlayerIsMounted
            PM.quickShield()
        elseIf iWaitingKeyCode == iQuickRangedKey && bExtendedKbControlsEnabled
            PM.quickRanged()

        elseIf !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true)
            if iWaitingKeyCode == iShoutKey
                if WC.bShoutEnabled && !WC.bPlayerIsMounted
                    WC.cycleSlot(2, bIsUtilityKeyHeld, false, false, true)
                endIf
            elseIf iWaitingKeyCode == iConsumableKey
                if WC.bConsumablesEnabled
                    WC.cycleSlot(3, bIsUtilityKeyHeld, false, false, true)
                elseIf WC.bPoisonsEnabled
                    WC.cycleSlot(4, bIsUtilityKeyHeld, false, false, true)
                endIf
            endIf
        endIf
        
    elseIf iMultiTap == 2  ; Double tap
        int LHItemType
        if iWaitingKeyCode == iConsumableKey 
            if !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true) && WC.bConsumablesEnabled && (WC.bPoisonsEnabled && (!bExtendedKbControlsEnabled || iCyclePoisonKey == -1))
                WC.cycleSlot(4, bIsUtilityKeyHeld, false, false, true)
            endIf
        elseIf iWaitingKeyCode == iQuickLightKey && PlayerRef.GetEquippedItemType(0) == 11 ; Torch
            TO.DropTorch()
        elseif PM.bPreselectMode
            if iWaitingKeyCode == iLeftKey
                int RHItemType = PlayerRef.GetEquippedItemType(1)
                
                if bIsUtilityKeyHeld
                    if AM.bAmmoMode || RHItemType == 7 || RHItemType == 12
                        WC.cycleSlot(0, false, false, false, true)
                    else
                        LHItemType = PlayerRef.GetEquippedItemType(0)
                    
                        if LHItemType == 9 ; Spell
                            PM.quickDualCastOnDoubleTap(0)
                        elseIf LHItemType == 11 ; Torch
                            TO.DropTorch()
                        else
                            WC.applyPoison(0)
                        endIf
                    endIf
                elseIf PM.abPreselectSlotEnabled[0] && !WC.bPlayerIsMounted
                    ;debug.trace("iEquip_KeyHandler - in Preselect Mode, double tap left should be calling equipPreselectedItem")
                    PM.equipPreselectedItem(0)
                elseIf AM.bAmmoMode
                    ;debug.trace("iEquip_KeyHandler - in Preselect Mode, double tap left should be calling toggleAmmoMode")
                    AM.toggleAmmoMode()
                    WC.bPreselectSwitchingHands = false
                endIf
            else
                if bIsUtilityKeyHeld
                    if iWaitingKeyCode == iRightKey
                        if PlayerRef.GetEquippedItemType(1) == 9 ; Spell
                            PM.quickDualCastOnDoubleTap(1)
                        else
                            WC.applyPoison(1)
                        endIf
                    endIf
                else
                    if iWaitingKeyCode == iRightKey && (PM.abPreselectSlotEnabled[1] || AM.bAmmoMode)
                        PM.equipPreselectedItem(1)
                    elseIf iWaitingKeyCode == iShoutKey && !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true) && WC.bShoutEnabled && PM.bShoutPreselectEnabled && PM.abPreselectSlotEnabled[2]
                        PM.equipPreselectedItem(2)
                    endIf
                endIf
            endIf
        else
            if iWaitingKeyCode == iLeftKey
                if bIsUtilityKeyHeld
                    WC.openQueueManagerMenu(1)
                elseIf !AM.bAmmoMode
                    LHItemType = PlayerRef.GetEquippedItemType(0)
                
                    if LHItemType == 9 ; Spell
                        PM.quickDualCastOnDoubleTap(0)
                    elseIf LHItemType == 11 ; Torch
                        TO.DropTorch()
                    else
                        WC.applyPoison(0)
                    endIf
                elseIf !AM.bSimpleAmmoMode ;We're in ammo mode, so cycle the left preselect slot unless Simple Ammo Mode is enabled
                    WC.cycleSlot(0, bIsUtilityKeyHeld, false, false, true)
                endIf
            else
                if bIsUtilityKeyHeld
                    if iWaitingKeyCode == iRightKey
                        WC.openQueueManagerMenu(2)
                    elseIf iWaitingKeyCode == iShoutKey && !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true)
                        WC.openQueueManagerMenu(3)
                    endIf
                else
                    if iWaitingKeyCode == iRightKey
                        if PlayerRef.GetEquippedItemType(1) == 9 ; Spell
                            PM.quickDualCastOnDoubleTap(1)
                        else
                            WC.applyPoison(1)
                        endIf
                    endIf
                endIf
            endIf             
        endIf
        
    elseIf iMultiTap == 3  ; Triple tap
        if iWaitingKeyCode == iLeftKey && !WC.bPlayerIsMounted
            PM.quickShield()
        elseIf iWaitingKeyCode == iRightKey
            PM.quickRanged()
        elseIf !(IsMenuOpen("Loot Menu") && UI.GetBool("Loot Menu", "_root.Menu_mc._visible") == true)
            if iWaitingKeyCode == iConsumableKey
                PM.quickRestore()
            elseIf iWaitingKeyCode == iShoutKey
                PM.togglePreselectMode()
            endIf
        endIf
    endIf

    iWaitingKeyCode = -1
    bUtilityKeyDownReceived = false
    ;debug.trace("iEquip_KeyHandler runUpdate end")
endFunction

; --------------------
; - OTHER BEHAVIOURS -
; --------------------

;Beast Mode - while player is in werewolf, vampire lord or lich form
state BEASTMODE
    function runUpdate()
        ;debug.trace("iEquip_KeyHandler runUpdate BEASTMODE start")
        ;Handle widget visibility update on any registered key press
        WC.updateWidgetVisibility()
        ;There are only single press cycle actions in Beast Mode so treat any update as single press, and completely ignore utility/consumable/iOptHtKey/poison key presses
        if iWaitingKeyCode == iLeftKey
            BM.cycleSlot(0, bIsUtilityKeyHeld, true)
        
        elseIf iWaitingKeyCode == iRightKey
            BM.cycleSlot(1, bIsUtilityKeyHeld, true)
        
        elseIf iWaitingKeyCode == iShoutKey && !IsMenuOpen("LootMenu")
            BM.cycleSlot(2, bIsUtilityKeyHeld, true)
        endIf

        iWaitingKeyCode = -1
        ;debug.trace("iEquip_KeyHandler runUpdate BEASTMODE end")
    endFunction
endState

; - Inventory
state INVENTORYMENU
    event OnBeginState()
        UnregisterForAllKeys()
        if !bDisableAddToQueue
            RegisterForMenuKeys()
        endIf
    endEvent
    event OnKeyDown(int KeyCode)
        ;debug.trace("iEquip_KeyHandler OnKeyDown INVENTORYMENU start - keyCode: " + keyCode)
        if bIsGPPLoaded && aiGPPComboKeys.Find(KeyCode) > -1
            bGPPKeyHeld = true
        endIf
     
        ;debug.trace("iEquip_KeyHandler OnKeyDown INVENTORYMENU - bAllowKeyPress: " + bAllowKeyPress + ", bGPPKeyHeld: " + bGPPKeyHeld)
        if bAllowKeyPress && !bGPPKeyHeld && !UI.IsTextInputEnabled()
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
        ;debug.trace("iEquip_KeyHandler OnKeyDown INVENTORYMENU end")
    endEvent
endState

; - Editmode
state EDITMODE
    event OnBeginState()
        RegisterForEditModeKeys()
    EndEvent
    event OnKeyUp(int KeyCode, Float HoldTime)
        ;debug.trace("iEquip_KeyHandler OnKeyUp EDITMODE start - bAllowKeyPress: " + bAllowKeyPress + ", KeyCode: " + KeyCode)
        
        if bAllowKeyPress
            if KeyCode == iWaitingKeyCode && iMultiTap == 0
                float updateTime
                iMultiTap = 1
                
                If (KeyCode == iEditRotateKey || KeyCode == iEditRulersKey)
                    updateTime = fMultiTapDelay
                endIf
                
                RegisterForSingleUpdate(updateTime)
            endIf
        endIf
        ;debug.trace("iEquip_KeyHandler OnKeyUp EDITMODE end")
    endEvent

    function runUpdate()
        ;debug.trace("iEquip_KeyHandler runUpdate EDITMODE start")
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
            if iWaitingKeyCode == iUtilityKey
                ToggleEditMode()
            elseIf iWaitingKeyCode == iEditUpKey
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
            ;elseIf iWaitingKeyCode == iEditDepthKey
            ;    EM.SwapElementDepth()
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
            endIf
            
        elseIf iMultiTap == 2  ; Double tap
            if iWaitingKeyCode == iEditRotateKey
                EM.ToggleRotation()
            elseIf iWaitingKeyCode == iEditRulersKey
                EM.ShowColorSelection(1) ;Current item info color
            endIf
            
        endIf

        iWaitingKeyCode = -1
        ;debug.trace("iEquip_KeyHandler runUpdate EDITMODE end")
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
    ;debug.trace("iEquip KeyHandler toggleEditMode start")
    if EM.isEditMode
        GoToState("")
        bIsUtilityKeyHeld = false
    else
        GoToState("EDITMODE")
    endIf
    EM.ToggleEditMode()
    updateKeyMaps()
    ;debug.trace("iEquip_KeyHandler toggleEditMode end")
endFunction

function updateKeyMaps()
    ;debug.trace("iEquip_KeyHandler updateKeyMaps start")
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
        
        InvokeIntA(WC.HUD_MENU, WC.WidgetRoot + ".EditModeGuide.setEditModeButtons", keys)       
        RegisterForEditModeKeys()
    else
        RegisterForGameplayKeys()
    endIf
    iEquipLeftKey.SetValueInt(iLeftKey)
    iEquipRightKey.SetValueInt(iRightKey)
    iEquipShoutKey.SetValueInt(iShoutKey)
    iEquipConsumableKey.SetValueInt(iConsumableKey)
    iEquipUtilityKey.SetValueInt(iUtilityKey)
    SendModEvent("iEquip_KeysUpdated")
    if bIsGPPLoaded
        registerForGPPKeys()
    endIf
    ;debug.trace("iEquip_KeyHandler updateKeyMaps end")
endFunction

function resetEditModeKeys()
    ;debug.trace("iEquip_KeyHandler resetEditModeKeys start")
    iEditNextKey = 55
    iEditPrevKey = 181
    iEditUpKey = 200
    iEditDownKey = 208
    iEditRightKey = 205
    iEditLeftKey = 203
    iEditScaleUpKey = 78
    iEditScaleDownKey = 74
    iEditDepthKey = 72
    iEditRotateKey = 79
    iEditTextKey = 80
    iEditAlphaKey = 81
    iEditRulersKey = 75
    iEditResetKey = 82
    iEditLoadPresetKey = 76
    iEditSavePresetKey = 77
    iEditDiscardKey = 83
    ;debug.trace("iEquip_KeyHandler resetEditModeKeys end")
endFunction

function RegisterForGameplayKeys()
    ;debug.trace("iEquip_KeyHandler RegisterForGameplayKeys start")
    RegisterForKey(iShoutKey)
    RegisterForKey(iLeftKey)
    RegisterForKey(iRightKey)
    RegisterForKey(iConsumableKey)
    RegisterForKey(iUtilityKey)
    if iQuickLightKey != -1
        RegisterForKey(iQuickLightKey)
    endIf
    if iThrowingPoisonsKey != -1
        RegisterForKey(iThrowingPoisonsKey)
    endIf
    if bExtendedKbControlsEnabled
        if iConsumeItemKey != -1
            RegisterForKey(iConsumeItemKey)
        endIf
        if iCyclePoisonKey != -1
            RegisterForKey(iCyclePoisonKey)
        endIf
        if iQuickRestoreKey != -1
            RegisterForKey(iQuickRestoreKey)
        endIf
        if iQuickShieldKey != -1
            RegisterForKey(iQuickShieldKey)
        endIf
        if iQuickRangedKey != -1
            RegisterForKey(iQuickRangedKey)
        endIf
    endIf
    ;debug.trace("iEquip_KeyHandler RegisterForGameplayKeys end")
endFunction

; Called from EH when player dismounts to re-enable left slot actions
function RegisterForLeftKey()
    RegisterForKey(iLeftKey)
endFunction

; Called from EH when player mounts a horse to block all left slot actions
function UnregisterForLeftKey()
    UnregisterForKey(iLeftKey)
endFunction

function RegisterForMenuKeys()
    ;debug.trace("iEquip_KeyHandler RegisterForMenuKeys start")
    RegisterForKey(iShoutKey)
    RegisterForKey(iLeftKey)
    RegisterForKey(iRightKey)
    RegisterForKey(iConsumableKey)
    ;debug.trace("iEquip_KeyHandler RegisterForMenuKeys end")
endFunction

function RegisterForEditModeKeys()
    ;debug.trace("iEquip_KeyHandler RegisterForEditModeKeys start")
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
    ;RegisterForKey(iEditDepthKey)
    RegisterForKey(iEditAlphaKey)
    RegisterForKey(iEditTextKey)
    RegisterForKey(iEditRulersKey)
    RegisterForKey(iEditDiscardKey)
    RegisterForKey(iUtilityKey)
    ;debug.trace("iEquip_KeyHandler RegisterForEditModeKeys end")
endFunction
