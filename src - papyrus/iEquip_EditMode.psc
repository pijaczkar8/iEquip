ScriptName iEquip_EditMode Extends Quest

; - IMPORTS

import Game
import Utility
import StringUtil
import iEquip_UILIB
import iEquip_StringExt

; - SCRIPTS

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_ChargeMeters property CM auto
iEquip_TemperedItemHandler property TI auto

; - REFERENCES -

Spell property iEquip_SlowTimeSpell auto

; - WIDGET VARIABLES -

float[] afWidget_CurX
float[] afWidget_CurY
float[] afWidget_CurS
float[] afWidget_CurR
float[] afWidget_CurA
int[] aiWidget_CurD
int[] aiWidget_CurTC
string[] asWidget_CurTA

; - Bools -

bool[] property abWasCounterShown auto hidden
bool property isEditMode auto hidden
bool property preselectEnabledOnEnter auto hidden
bool bFirstCycleKeyPressed = true
bool bringToFrontFirstTime = true
bool bPotionSelectorOnLeft = true

; - Floats -

float CurrentVanityModeDelay

; - Ints -

int[] property aiPreviousCount auto hidden
int property iSelectedElement = -1 auto hidden
int property iEnabledPotionGroupCount auto hidden
int property previousLeftCount auto hidden
int property previousRightCount auto hidden
int[] iCustomColors
int[] iFirstElementInGroup
int iFirstElement
int iLastElement
int iHighlightColor = 0x0099FF
int iCurrentColorValue = 0xEAAB00
int iLastColorSelection
int iNextColorIndex
int iSelectedElementFront = -1
int MoveStep
int RotateStep
int AlphaStep
int RulersShown = 1

; - Strings -

string[] WidgetGroups
string[] sTextAlignment
string[] asCounterTextPath
string[] asPoisonNamePath
string HUD_MENU = "HUD Menu"
string WidgetRoot
string sRotation = "$iEquip_EM_clockwise"

; ######################
; ### PRESET VERSION ###

int function GetVersion()
    return 2
endFunction

; ######################
; ### INITIALIZATION ###

function OnInit()
    WidgetGroups = new String[6]
    WidgetGroups[1] = "Left"
    WidgetGroups[2] = "Right"
    WidgetGroups[3] = "Shout"
    WidgetGroups[4] = "Consumable"
    WidgetGroups[5] = "Poison"
    sTextAlignment = new string[3]
    sTextAlignment[0] = "Left"
    sTextAlignment[1] = "Center"
    sTextAlignment[2] = "Right"

    abWasCounterShown = new bool[5]
    aiPreviousCount = new int[5]

    asCounterTextPath = new string[5]
    asCounterTextPath[0] = ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text"
    asCounterTextPath[1] = ".widgetMaster.RightHandWidget.rightCount_mc.rightCount.text"
    asCounterTextPath[3] = ".widgetMaster.ConsumableWidget.consumableCount_mc.consumableCount.text"
    asCounterTextPath[4] = ".widgetMaster.PoisonWidget.poisonCount_mc.poisonCount.text"

    asPoisonNamePath = new string[2]
    asPoisonNamePath[0] = ".widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName.text"
    asPoisonNamePath[1] = ".widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName.text"

    iFirstElementInGroup = new int[6]
    iFirstElementInGroup[0] = 6  ; leftBg_mc
    iFirstElementInGroup[1] = 6  ; leftBg_mc
    iFirstElementInGroup[2] = 22 ; rightBg_mc
    iFirstElementInGroup[3] = 38 ; shoutBg_mc
    iFirstElementInGroup[4] = 45 ; consumableBg_mc
    iFirstElementInGroup[5] = 50 ; poisonBg_mc

    afWidget_CurX = new Float[54]
    afWidget_CurY = new Float[54]
    afWidget_CurS = new Float[54]
    afWidget_CurR = new Float[54]
    afWidget_CurA = new Float[54]
    aiWidget_CurD = new Int[54]
    asWidget_CurTA = new string[54]
    aiWidget_CurTC = new int[54]
    
    iCustomColors = new int[14]
    int iIndex = iCustomColors.length
    while iIndex > 0
        iIndex -= 1
        iCustomColors[iIndex] = -1
    endWhile
endFunction

function onVersionUpdate()
    iFirstElementInGroup[2] = 22 ; rightBg_mc
    iFirstElementInGroup[3] = 38 ; shoutBg_mc
    iFirstElementInGroup[4] = 45 ; consumableBg_mc
    iFirstElementInGroup[5] = 50 ; poisonBg_mc

    afWidget_CurX = new Float[54]
    afWidget_CurY = new Float[54]
    afWidget_CurS = new Float[54]
    afWidget_CurR = new Float[54]
    afWidget_CurA = new Float[54]
    aiWidget_CurD = new Int[54]
    asWidget_CurTA = new string[54]
    aiWidget_CurTC = new int[54]
endFunction

; #######################
; ### Toggle EditMode ###

function ToggleEditMode()
    WC.updateWidgetVisibility(false)
    
    Wait(0.2)
    
    if isEditMode
        DisableEditMode()
    else
        EnableEditmode()
    endIf
    
    WC.updateWidgetVisibility()
endFunction

function DisableEditMode()
    WidgetRoot = WC.WidgetRoot
    isEditMode = false

    HighlightElement(false)
    iSelectedElement = -1

    WC.resetWidgetsToPreviousState()
        
    ; Restore DropShadowFilter to all text elements when leaving Edit Mode
    if WC.bDropShadowEnabled
        UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false)
    endIf

    UI.InvokeFloat(HUD_MENU, WidgetRoot + ".tweenPotionSelectorAlpha", 0.0)
    if WC.iPosInd != 2
        UI.invokeBool(HUD_MENU, WidgetRoot + ".showQueuePositionIndicators", false)
    endIf
    UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
    
    ; Reset Vanity Camera delay back to previous value on leaving Edit Mode
    SetINIfloat("fAutoVanityModeDelay:Camera", CurrentVanityModeDelay)
    
    GetPlayer().RemoveSpell(iEquip_SlowTimeSpell)
    game.EnablePlayerControls()
    GetPlayer().SetDontMove(false)
    GetPlayer().GetActorBase().SetInvulnerable(false)
endFunction

function EnableEditmode()
    WidgetRoot = WC.WidgetRoot
    isEditMode = true

    ; Disable player controls
    game.DisablePlayerControls(false, true, true, true, true, true, true, true, 0)
    GetPlayer().SetDontMove()
    GetPlayer().GetActorBase().SetInvulnerable()

    ; Save and disable Vanity Camera whilst in Edit Mode
    CurrentVanityModeDelay = GetINIfloat("fAutoVanityModeDelay:Camera")
    SetINIfloat("fAutoVanityModeDelay:Camera", 9999999)

    ; StoreOpeningValues
    int iIndex   
    while iIndex < WC.asWidgetDescriptions.length
        afWidget_CurX[iIndex] = WC.afWidget_X[iIndex]
        afWidget_CurY[iIndex] = WC.afWidget_Y[iIndex]
        afWidget_CurS[iIndex] = WC.afWidget_S[iIndex]
        afWidget_CurR[iIndex] = WC.afWidget_R[iIndex]
        afWidget_CurA[iIndex] = WC.afWidget_A[iIndex]
        aiWidget_CurD[iIndex] = WC.aiWidget_D[iIndex]
        asWidget_CurTA[iIndex] = WC.asWidget_TA[iIndex]
        aiWidget_CurTC[iIndex] = WC.aiWidget_TC[iIndex]
        
        iIndex += 1
    endWhile
    
    iFirstElement = 0
    iLastElement = 5
    iSelectedElement = 0
    iSelectedElementFront = -1
    sRotation = "$iEquip_EM_clockwise"
    MoveStep = 10
    RotateStep = 15
    AlphaStep = 10
    
    ; Remove DropShadowFilter from all text elements before entering Edit Mode
    if WC.bDropShadowEnabled
        UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true)
    endIf
    
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", iHighlightColor)
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".EditModeGuide.setEditModeCurrentValueColor", iCurrentColorValue)
  
    if WC.bPreselectMode                    ; if we're currently in Preselect Mode exit now and re-enable with every element showing, just in case some slots were disabled
        preselectEnabledOnEnter = true
        PM.togglePreselectMode()
        Utility.WaitMenuMode(0.8)
    endIf

    PM.togglePreselectMode(true)

    UI.InvokeFloat(HUD_MENU, WidgetRoot + ".tweenPotionSelectorAlpha", WC.afWidget_A[49])

    LoadAllElements()
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", 0)
    HighlightElement(true)
    UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", true)
    
    if RulersShown == 1
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", false)
    elseIf RulersShown == 2
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", false)
    elseIf RulersShown == 3
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", true)
    else
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
        UI.setBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", false)
    endIf
    
    GetPlayer().AddSpell(iEquip_SlowTimeSpell, false)
endFunction

; SHOULD PROBABLY BE CLEANED UP AT SOME POINT -> MAKE IT PRETTY
function LoadAllElements()
    int i = WC.asWidgetDescriptions.length
    
    while i > 0
        i -= 1
        UI.SetBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[i] + "._visible", true)               ; Everything needs to be visible in Edit Mode
        UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[i] + "._alpha", WC.afWidget_A[i])
    endWhile

    UI.invokeBool(HUD_MENU, WidgetRoot + ".showQueuePositionIndicators", true)
    
    while i < 8
        if !WC.abIsNameShown[i] ; Show any currently hidden names
            WC.showName(i, true, false, 0.0)
        endIf

        if i < 5                ; Show left and right counters if not currently shown
            if i != 2           ; Skip shout as it is the only slot without a counter
                abWasCounterShown[i] = WC.abIsCounterShown[i]
            
                if abWasCounterShown[i]
                    aiPreviousCount[i] = UI.getString(HUD_MENU, WidgetRoot + asCounterTextPath[i]) as int
                else
                    WC.setCounterVisibility(i, true)
                endIf

                WC.setSlotCount(i, 99)
            endIf
            
            int iCount = jArray.count(WC.aiTargetQ[i])
            
            if i < 2            ; Show any currently hidden elements in the left and right hand slots
                if i == 0 && WC.bLeftIconFaded ; Check and fade in left icon if currently faded
                    WC.checkAndFadeLeftIcon(0,0)
                endIf
                ; Check and show left and right poison elements if not already displayed
                if !WC.abPoisonInfoDisplayed[i]
                    UI.SetString(HUD_MENU, WidgetRoot + asPoisonNamePath[i], "$iEquip_EM_somePoison")
                    CreateHandleIntStr(".updatePoisonIcon", i, "Drops3")
                endIf
                
                if !WC.abIsPoisonNameShown[i]
                    WC.showName(i, true, true, 0.0)
                endIf

                ; Check and show left and right attribute icons including those for the preselect slots
                CreateHandleIntStr(".updateAttributeIcons", i, "Both")
                CreateHandleIntStr(".updateAttributeIcons", i + 5, "Both")

                ; Show temper tier indicators
                TI.updateTemperTierIndicator(i, 3)
                TI.updateTemperTierIndicator(i + 5, 3)

            ; Handle empty shout,consumable and poison queues to ensure all elements show temporarily
            elseIf iCount < 1 || i == 3 && iCount == 3
                if i == 2
                    setTempItemInWidget(i, "Power", "$iEquip_EM_somePower") ; Power because the preselect slot will already be set to shout if queue is empty so let's have something different
                elseIf i == 3
                    if WC.bPotionGrouping
                        ; Check if there are any potion groups shown...
                        iEnabledPotionGroupCount = 0
                        if WC.findInQueue(3, "$iEquip_common_HealthPotions") > -1 && !(WC.abPotionGroupEmpty[0] && WC.PO.iEmptyPotionQueueChoice == 1)
                            iEnabledPotionGroupCount += 1
                        endIf
                        if WC.findInQueue(3, "$iEquip_common_MagickaPotions") > -1 && !(WC.abPotionGroupEmpty[1] && WC.PO.iEmptyPotionQueueChoice == 1)
                            iEnabledPotionGroupCount += 1
                        endIf
                        if WC.findInQueue(3, "$iEquip_common_StaminaPotions") > -1 && !(WC.abPotionGroupEmpty[2] && WC.PO.iEmptyPotionQueueChoice == 1)
                            iEnabledPotionGroupCount += 1
                        endIf
                        if iEnabledPotionGroupCount > 0
                            ; ...but faded out, and un-fade if needed
                            if WC.bConsumableIconFaded
                                WC.checkAndFadeConsumableIcon(false)
                            endIf
                        ; Otherwise set temp info in the widget    
                        else
                            setTempItemInWidget(i, "HealthPotion", "$iEquip_EM_somePotion")
                        endIf
                    endIf
                elseIf i == 4
                    ; Check if the poison icon is currently faded and fade back in if needed
                    if WC.bPoisonIconFaded
                        WC.checkAndFadePoisonIcon(false)
                    endIf
                    ; Set temp info in the widget
                    setTempItemInWidget(i, "Poison", "$iEquip_EM_somePoison") 
                endIf                
            endIf
        endIf
        
        i += 1
    endWhile
    
    UpdateEditModeGuide()
endFunction

function setTempItemInWidget(int Q, string iconName, string itemName)
    float fNameAlpha = WC.afWidget_A[WC.aiNameElements[Q]]
    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
    
    if fNameAlpha < 1
        fNameAlpha = 100
    endIf
    
    if(iHandle)
        UICallback.PushInt(iHandle, Q)
        UICallback.PushString(iHandle, iconName)
        UICallback.PushString(iHandle, itemName)
        UICallback.PushFloat(iHandle, fNameAlpha)
        UICallback.PushFloat(iHandle, WC.afWidget_A[WC.aiIconClips[Q]])
        UICallback.PushFloat(iHandle, WC.afWidget_S[WC.aiIconClips[Q]])
        UICallback.Send(iHandle)
    endIf
endFunction

; #######################
; ### Element Editing ###

; - Highlight -

function HighlightElement(bool bAdd)
    ;debug.trace("iEquip EditMode HighlightElement called")
    int[] iArgs = new int[3]
    iArgs[0] = WC.abWidget_isText[iSelectedElement] as int   ; Is text element
    iArgs[1] = iSelectedElement                              ; iSelectedElement                
    iArgs[2] = WC.aiWidget_TC[iSelectedElement]              ; Current text colour if text element
    
    if bAdd
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".highlightSelectedElement", iArgs)
    else
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".removeCurrentHighlight", iArgs)
        TweenElement(4, WC.afWidget_A[iSelectedElement], 0.01)
    endIf
endFunction

; - Depth -

function SwapIndexDepth(int[] iDepthIndex)
    ; Takes int array iDepthIndex[2] as param, and swaps the widget depth for the indexes
    int iTmp = WC.aiWidget_D[iDepthIndex[0]]

    WC.aiWidget_D[iDepthIndex[0]] = WC.aiWidget_D[iDepthIndex[1]]
    WC.aiWidget_D[iDepthIndex[1]] = iTmp
    UI.InvokeIntA(HUD_MENU, WidgetRoot + ".swapItemDepths", iDepthIndex)
endFunction

function SwapElementDepth()
    ; Swap depth of the two selected elements

    if bringToFrontFirstTime
        debug.MessageBox("$iEquip_EM_msg_firstBringToFront")
        bringToFrontFirstTime = False
    endIf

    if iSelectedElement != -1 && !WC.abWidget_isBg[iSelectedElement]
        if iSelectedElementFront == -1
            iSelectedElementFront = iSelectedElement
            debug.MessageBox("$iEquip_EM_msg_bringToFrontSelNext{" + WC.asWidgetDescriptions[iSelectedElement] + "}")
        else
            if WC.asWidgetGroup[iSelectedElementFront] == WC.asWidgetGroup[iSelectedElement]
                int[] iDepthIndex = new int[2]
                iDepthIndex[0] = iSelectedElementFront
                iDepthIndex[1] = iSelectedElement
                
                SwapIndexDepth(iDepthIndex)
            else
                debug.notification("$iEquip_EM_not_bringToFrontError")
            endIf
            
            iSelectedElementFront = -1
        endIf
    endIf
endFunction

function SetElementDepthOrder(int DepthIndexA, bool bSet = true)
    int DepthIndexB
   
    if bSet       ; SET
        DepthIndexB = WC.aiWidget_D[DepthIndexA]
        if DepthIndexA >= DepthIndexB
            DepthIndexB = -1
        endIf
    else          ; RESET
        ; Check that value is not default already
        if WC.aiWidget_D[DepthIndexA] != WC.aiWidget_DefD[DepthIndexA]
            int iIndex
            
            ; Find iIndex with default value for DepthIndexA
            while WC.aiWidget_D[iIndex] != WC.aiWidget_DefD[DepthIndexA]
                iIndex += 1
            endWhile
            DepthIndexB = iIndex
        else
            DepthIndexB = -1
        endIf 
    endIf
    
    if DepthIndexB != -1
        int[] iArgs = new int[2]
        iArgs[0] = DepthIndexA
        iArgs[1] = DepthIndexB
    
        SwapIndexDepth(iArgs)
    endIf
endFunction

; - Tween -

Function TweenElement(float attribute, float targetValue, float duration)
    float[] iArgs = new float[3]
    iArgs[0] = attribute     ; Attribute to change - 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 = _rotation, 4 = _alpha
    iArgs[1] = targetValue   ; Target value - sent from calling function as value after increment applied
    iArgs[2] = duration      ; Duration in seconds for tween to take
    
    UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenIt", iArgs)
EndFunction

; - Move -

function MoveElement(int iDirection)
    ; 0 = Up    1 = Down
    ; 2 = Left  3 = Right

    if iSelectedElement != -1
        float fDuration = 0.003 * MoveStep
    
        if iDirection < 2
            if iDirection == 0  ; Up
                WC.afWidget_Y[iSelectedElement] = WC.afWidget_Y[iSelectedElement] - MoveStep
            else                ; Down
                WC.afWidget_Y[iSelectedElement] = WC.afWidget_Y[iSelectedElement] + MoveStep
            endIf
        
            TweenElement(1, WC.afWidget_Y[iSelectedElement], fDuration)
        else
            if iDirection == 2  ; Left
                WC.afWidget_X[iSelectedElement] = WC.afWidget_X[iSelectedElement] - MoveStep
            else                ; Right
                WC.afWidget_X[iSelectedElement] = WC.afWidget_X[iSelectedElement] + MoveStep
            endIf
        
            TweenElement(0, WC.afWidget_X[iSelectedElement], fDuration)
        endIf
    endIf
endFunction

; - Scale -

function ScaleElement(int iScale)
    if iSelectedElement != -1
        float fDuration = 0.01 * MoveStep
    
        if iScale == 0      ; Up
            WC.afWidget_S[iSelectedElement] = WC.afWidget_S[iSelectedElement] + MoveStep
        else                ; Down
            WC.afWidget_S[iSelectedElement] = WC.afWidget_S[iSelectedElement] - MoveStep
            if WC.afWidget_S[iSelectedElement] < 10
                WC.afWidget_S[iSelectedElement] = 10
            endIf
        endIf
    
        TweenElement(2, WC.afWidget_S[iSelectedElement], fDuration)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iSelectedElement] as int) as String + "%")
    endIf
endFunction

; - Rotate -

function RotateElement()
    if iSelectedElement > 0
        float fDuration = 0.005 * RotateStep
        int iRotation = WC.afWidget_R[iSelectedElement] as int
        
        if fDuration < 0.125
            fDuration = 0.125
        endIf
    
        if sRotation == "$iEquip_EM_clockwise"
            iRotation = iRotation + RotateStep
       
            if iRotation >= 360
                iRotation = 0
            endIf
        else
            iRotation = iRotation - RotateStep
        
            if WC.afWidget_R[iSelectedElement] == 0
                iRotation = 360 - RotateStep
            elseIf iRotation < 0
                iRotation = 0
            endIf
        endIf
        
        WC.afWidget_R[iSelectedElement] = iRotation as float
        TweenElement(3, WC.afWidget_R[iSelectedElement], fDuration)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", iRotation as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_degrees"))
    endIf 
endFunction

; - Transparency -

function SetElementAlpha()
    if iSelectedElement != -1
        WC.afWidget_A[iSelectedElement] = WC.afWidget_A[iSelectedElement] - AlphaStep
        if WC.afWidget_A[iSelectedElement] < 0
            WC.afWidget_A[iSelectedElement] = 100
        endIf
        
        TweenElement(4, WC.afWidget_A[iSelectedElement], 0.01 * AlphaStep)
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iSelectedElement] as int) as String + "%")
    endIf
endFunction

; ########################
; ### Element Handling ###

; - Apply Color -

function ApplyElementColor (int iType, int iColor)
    if iColor > 0
        if iType == 0
                iHighlightColor = iColor
                UI.InvokeInt(HUD_MENU, WidgetRoot + ".setEditModeHighlightColor", iColor)
                HighlightElement(true)
        elseIf iType == 1
            iCurrentColorValue = iColor
            UI.InvokeInt(HUD_MENU, WidgetRoot + ".EditModeGuide.setEditModeCurrentValueColor", iColor)
        else
            WC.aiWidget_TC[iSelectedElement] = iColor
            int[] args = new int[2]
            args[0] = iSelectedElement
            args[1] = iColor
            UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
        endIf
    endIf
endFunction

function ToggleCycleRange()
    if bFirstCycleKeyPressed
        bFirstCycleKeyPressed = false
        showCyclingHelp()   
    endIf
    ; Toggle between cycling groups/single elements
    HighlightElement(false)
    
    if 0 <= iSelectedElement && iSelectedElement  <= 5           ; if group is selected, find first child
        iSelectedElement = iFirstElementInGroup[iSelectedElement]
        iFirstElement = 6
        iLastElement = 53
    else                                    ; else find parent group
        iSelectedElement = WidgetGroups.Find(WC.asWidgetGroup[iSelectedElement])
        iFirstElement = 0
        iLastElement = 5
    endIf
    
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iSelectedElement)
    HighlightElement(true)
    UpdateEditModeGuide()
endFunction

; - Cycle Elements -

function CycleElements(int iNextPrev)    
    if bFirstCycleKeyPressed
        bFirstCycleKeyPressed = false
        if WC.bShowTooltips
            showCyclingHelp()
        endIf 
    endIf
    HighlightElement(false)
    
    iSelectedElement += iNextPrev
    if iNextPrev == 1   ; Next
        if iSelectedElement > iLastElement
            iSelectedElement = iFirstElement
        endIf
    else                ; Previous
        if iSelectedElement < iFirstElement
            iSelectedElement = iLastElement
        endIf
    endIf
    
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".setCurrentClip", iSelectedElement)
    HighlightElement(true)
    UpdateEditModeGuide()
endFunction

function showCyclingHelp()
    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_EM_msg_cycleHelp"))
endFunction

; - Update Data -

function UpdateElementData(int iIndex, bool bUpdateAlpha = true)
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._x", WC.afWidget_X[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._y", WC.afWidget_Y[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._xscale", WC.afWidget_S[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._yscale", WC.afWidget_S[iIndex])
    UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._rotation", WC.afWidget_R[iIndex])
    
    if bUpdateAlpha
        UI.SetFloat(HUD_MENU, WidgetRoot + WC.asWidgetElements[iIndex] + "._alpha", WC.afWidget_A[iIndex])
    endIf
endFunction

function UpdateElementText(int[] iArgs, int iNewColor) 
    if iArgs[0] == 49                  ; potionSelector_mc - Only setting text colour here as alignment handled by .setPotionSelectorAlignment
        iArgs[1] = iNewColor
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", iArgs)
    else                                ; for every other text element update colour and alignment together
        if WC.asWidget_TA[iArgs[0]] == "Left"
            iArgs[1] = 0
        elseIf WC.asWidget_TA[iArgs[0]] == "Center"
            iArgs[1] = 1
        else
            iArgs[1] = 2
        endIf
        
        iArgs[2] = iNewColor
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColorAndAlignment", iArgs)
    endIf
endFunction

function UpdateEditModeGuide()
    if iSelectedElement != -1
        string tmpStr
        
        if iSelectedElement == 49 ; potionSelector_mc
            UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentInstructionText.text", iEquip_StringExt.LocalizeString("$iEquip_swf_potSelAlignInstTxt"))
        else
            UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentInstructionText.text", iEquip_StringExt.LocalizeString("$iEquip_swf_AlignmentInstructionText"))
        endIf
    
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.SelectedElementText.text", WC.asWidgetDescriptions[iSelectedElement])
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", MoveStep as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_pixels"))
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", RotateStep as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_degrees"))
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", AlphaStep as String + "%")
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", iEquip_StringExt.LocalizeString(sRotation))
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.ScaleText.text", (WC.afWidget_S[iSelectedElement] as int) as String + "%")
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationText.text", (WC.afWidget_R[iSelectedElement] as int) as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_degrees"))
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaText.text", (WC.afWidget_A[iSelectedElement] as int) as String + "%")
        
        if WC.abWidget_isText[iSelectedElement]
            if WC.asWidget_TA[iSelectedElement] == "Left"
                tmpStr = "$iEquip_EM_leftAligned"
            elseIf WC.asWidget_TA[iSelectedElement] == "Right"
                tmpStr = "$iEquip_EM_rightAligned"
            else
                tmpStr = "$iEquip_EM_centreAligned"
            endIf
        elseIf iSelectedElement == 49 ; potionSelector_mc
            if bPotionSelectorOnLeft
                tmpStr = "$iEquip_EM_potSelLeft"
            else
                tmpStr = "$iEquip_EM_potSelRight"
            endIf
        else
            tmpStr = ""
        endIf
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", tmpStr)
        
        if RulersShown == 1
            tmpStr = "$iEquip_EM_edgeGrid"
        elseIf RulersShown == 2
            tmpStr = "$iEquip_EM_fullGrid"
        elseIf RulersShown == 3
            tmpStr = "$iEquip_EM_fullGridWide"
        else
            tmpStr = "$iEquip_common_Hidden"
        endIf
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RulersText.text", tmpStr)
    endIf
endFunction

function UpdateElementsAll(bool bUpdateAlpha = true)
    int iIndex
    
    while iIndex < WC.asWidgetDescriptions.length        
        UpdateElementData(iIndex, bUpdateAlpha)
        iIndex += 1
    endWhile
    
    if !WC.bRefreshingWidget
        iIndex = 1
        int[] iArgs = new int[3]
    
        while iIndex < WC.asWidgetDescriptions.length
            if WC.abWidget_isText[iIndex] || iIndex == 49 ; potionSelector_mc
                iArgs[0] = iIndex
                UpdateElementText(iArgs, WC.aiWidget_TC[iIndex])
            endIf
            SetElementDepthOrder(iIndex)
            iIndex += 1
        endWhile
        
        if isEditMode
            HighlightElement(true)
        endIf
    endIf

endFunction

function UpdateAllTextFormatting()                      ; Only called from OnWidgetLoad
    int iIndex = 8                                      ; leftName_mc is the first text element so no need to start earlier
    int[] iArgs = new int[3]
    
    while iIndex < WC.asWidgetDescriptions.length
        if WC.abWidget_isText[iIndex] || iIndex == 49   ; potionSelector_mc
            iArgs[0] = iIndex
            UpdateElementText(iArgs, WC.aiWidget_TC[iIndex])
        endIf
        iIndex += 1
    endWhile
endFunction

; ####################
; ### Edit Toggles ###

function ToggleTextAlignment()
    if iSelectedElement == 49 ;potionSelector_mc
        togglePotionSelectorAlignment()
    elseIf WC.abWidget_isText[iSelectedElement]
        string tmpStr
        int[] iArgs = new int[2]
        iArgs[0] = iSelectedElement
        
        TweenElement(5, 0, 0.15)                                 ; Fade out before changing alignment
        
        if WC.asWidget_TA[iArgs[0]] == "Left"
            iArgs[1] = 1
            tmpStr = "$iEquip_EM_centreAligned"
        elseIf WC.asWidget_TA[iArgs[0]] == "Center"
            iArgs[1] = 2
            tmpStr = "$iEquip_EM_rightAligned"
        else
            iArgs[1] = 0
            tmpStr = "$iEquip_EM_leftAligned"
        endIf
    
        UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextAlignment", iArgs)
        WC.asWidget_TA[iSelectedElement] = sTextAlignment[iArgs[1]]
        
        TweenElement(5, WC.afWidget_A[iSelectedElement], 0.15)   ; Fade back in
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", tmpStr)
    endIf
endfunction

function togglePotionSelectorAlignment()
    string tmpStr
    bPotionSelectorOnLeft = !bPotionSelectorOnLeft
    
    TweenElement(5, 0, 0.15)                                 ; Fade out before changing alignment
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setPotionSelectorAlignment", bPotionSelectorOnLeft)
    TweenElement(5, WC.afWidget_A[iSelectedElement], 0.15)   ; Fade back in
    
    if bPotionSelectorOnLeft
        tmpStr = "$iEquip_EM_potSelLeft"
    else
        tmpStr = "$iEquip_EM_potSelRight"
    endIf
    
    UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlignmentText.text", tmpStr)
endFunction

function ToggleRulers()
    RulersShown += 1

    if RulersShown == 1
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", true)
    elseIf RulersShown == 2
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Rulers._visible", false)
        Wait(0.3)
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", true)
    elseIf RulersShown == 3
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.Grid._visible", false)
        Wait(0.3)
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", true)
    else
        UI.SetBool(HUD_MENU, WidgetRoot + ".EditModeGuide.GridWide._visible", false)
        RulersShown = 0
    endIf
    
    UpdateEditModeGuide()
endFunction

function IncrementStep(int iStep)
    if iStep == 0                    ; MoveStep
        if MoveStep == 1
            MoveStep = 10
        elseIf MoveStep == 10
            MoveStep = 50
        elseIf MoveStep == 50
            MoveStep = 100
        elseIf MoveStep == 100
            MoveStep = 1
        endIf
        
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.MoveIncrementText.text", MoveStep as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_pixels"))
    elseIf iStep == 1                ; RotateStep
        if RotateStep == 15
            RotateStep = 45
        elseIf RotateStep == 45
            RotateStep = 90
        elseIf RotateStep == 90
            RotateStep = 1
        elseIf RotateStep == 1
            RotateStep = 5
        else
            RotateStep = 15
        endIf
        
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotateIncrementText.text", RotateStep as String + " " + iEquip_StringExt.LocalizeString("$iEquip_EM_degrees"))
    else                            ; AlphaStep
        if AlphaStep == 10
            AlphaStep = 20
        elseIf AlphaStep == 20
            AlphaStep = 5
        else
            AlphaStep = 10
        endIf
        
        UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.AlphaIncrementText.text", AlphaStep as String + "%")
    endIf
endFunction

function ToggleRotation()
    if sRotation == "$iEquip_EM_clockwise"
        sRotation = "$iEquip_EM_counterClockwise"
    else
        sRotation = "$iEquip_EM_clockwise"
    endIf
    
    UI.SetString(HUD_MENU, WidgetRoot + ".EditModeGuide.RotationDirectionText.text", sRotation)
endFunction

; #############
; ### Menus ###

function ShowPresetList()
    bool bDontExit = true
    
    while bDontExit
        string[] sPresetList = JMap.allKeysPArray(JValue.readFromDirectory(WC.WidgetPresetPath, WC.FileExt))
    
        if 0 < sPresetList.length
            int i = 0
            
            while(i < sPresetList.length)
                sPresetList[i] = Substring(sPresetList[i], 0, Find(sPresetList[i], "."))
                i += 1
            endWhile
        
            int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowList("$iEquip_EM_lbl_presetListTitle", sPresetList, 0, 0)
            
            if MenuReturnArgs[1] == 0       ; Load preset
				int jPreset = jValue.readFromFile(WC.WidgetPresetPath + sPresetList[MenuReturnArgs[0]] + WC.FileExt)
				int jPresetVersion = jMap.getInt(jPreset, "Version")
				
				if (jPresetVersion == GetVersion())
					LoadPreset(jPreset)
					Debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_EM_not_layoutSwitched") + " " + sPresetList[MenuReturnArgs[0]] + WC.FileExt)
				elseIf (jPresetVersion == 1 && GetVersion == 2)
					int j = 1
					
					while j < 9
						int jTmpObj
						int k = 50

						if j == 1
							jTmpObj = jMap.getObj(jPreset, "_X")
							while k < 54
								jArray.addFlt(jTmpObj, WC.afWidget_DefX[k])
								k += 1
							endWhile
							
						elseIf j == 2
							jTmpObj = jMap.getObj(jPreset, "_Y")
							while k < 54
								jArray.addFlt(jTmpObj, WC.afWidget_DefY[k])
								k += 1
							endWhile
							
						elseIf j == 3
							jTmpObj = jMap.getObj(jPreset, "_S")
							while k < 54
								jArray.addFlt(jTmpObj, WC.afWidget_DefS[k])
								k += 1
							endWhile
							
						elseIf j == 4
							jTmpObj = jMap.getObj(jPreset, "_R")
							while k < 54
								jArray.addFlt(jTmpObj, WC.afWidget_DefR[k])
								k += 1
							endWhile
							
						elseIf j == 5
							jTmpObj = jMap.getObj(jPreset, "_A")
							while k < 54
								jArray.addFlt(jTmpObj, WC.afWidget_DefA[k])
								k += 1
							endWhile
							
						elseIf j == 6
							jTmpObj = jMap.getObj(jPreset, "_D")
							while k < 54
								jArray.addInt(jTmpObj, WC.afWidget_DefD[k])
								k += 1
							endWhile
							
						elseIf j == 7
							jTmpObj = jMap.getObj(jPreset, "_TC")
							while k < 54
								jArray.addInt(jTmpObj, WC.afWidget_DefTC[k])
								k += 1
							endWhile
							
						elseIf j == 8
							jTmpObj = jMap.getObj(jPreset, "_TA")
							while k < 54
								jArray.addStr(jTmpObj, WC.afWidget_DefTA[k])
								k += 1
							endWhile
							
						endIf
						
						jArray.swapItems(jTmpObj, 15, 50)
						jArray.swapItems(jTmpObj, 21, 51)
						jArray.swapItems(jTmpObj, 31, 52)
						jArray.swapItems(jTmpObj, 37, 53)
						
						j += 1
					endWhile
					
					Debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_EM_not_layoutSwitched") + " " + sPresetList[MenuReturnArgs[0]] + WC.FileExt)
					LoadPreset(jPreset)
				else
					Debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_common_LoadPresetError"))
				endIf
				
				jValue.zeroLifetime(jPreset)
                bDontExit = false
            elseIf MenuReturnArgs[1] == 1   ; Delete preset
                bDontExit = true
                JContainers.removeFileAtPath(WC.WidgetPresetPath + sPresetList[MenuReturnArgs[0]] + WC.FileExt)
            elseIf MenuReturnArgs[1] == 2   ; Delete preset cancelled
                bDontExit = true
            else                            ; Exit
                bDontExit = false
            endIf
        else
            Debug.Notification("$iEquip_EM_not_noPresets")
            bDontExit = false
        endIf
    endWhile
endFunction

function ShowColorSelection(int iType)
    string sText
    int iColor
    int iDefColor
    iLastColorSelection = iType
    
    if iType == 0       ; Highlight colour
        sText = "$iEquip_EM_lbl_showColorTitle1"
        iColor = iHighlightColor
        iDefColor = 0x0099FF
    elseIf iType == 1   ; Current item info text colour
        sText = "$iEquip_EM_lbl_showColorTitle2"
        iColor = iCurrentColorValue
        iDefColor = 0xEAAB00
    elseIf (WC.abWidget_isText[iSelectedElement] || iSelectedElement == 49) ; Selected text colour
        sText = "$iEquip_EM_lbl_showColorTitle3"
        iColor = WC.aiWidget_TC[iSelectedElement]
        iDefColor = 0xFFFFFF
    else
        sText = ""
    endIf
    
    ; Show color menu
    if sText != ""
        int[] MenuReturnArgs = ((Self as Form) as iEquip_UILIB).ShowColorMenu(sText, iColor, iDefColor, iCustomColors)
        
        if MenuReturnArgs[1] == 0               ; Selected Color
            ApplyElementColor(iType, MenuReturnArgs[0])
        elseIf MenuReturnArgs[1] == 1           ; Custom Color
            string sInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("$iEquip_EM_lbl_enterHex", "RRGGBB")
            
            if sInput != "" && sInput != "RRGGBB"
                iCustomColors[iNextColorIndex] = HexStringToInt(sInput)
                ApplyElementColor(iType, iCustomColors[iNextColorIndex])
                iNextColorIndex = (iNextColorIndex + 1) % iCustomColors.length
            endIf
        endIf
    endIf
endFunction

function DeleteCustomColor(int iDeleteIndex)
    ; Deletes color index and sorts remaining slots
    int iArrayIndexes = iCustomColors.length - 1
    iCustomColors[iDeleteIndex] = -1
    
    while iDeleteIndex < iArrayIndexes
        iCustomColors[iDeleteIndex] = iCustomColors[iDeleteIndex + 1]
        iDeleteIndex += 1
    endWhile

    iNextColorIndex = (iNextColorIndex - 1) % iCustomColors.length
    ShowColorSelection(iLastColorSelection)
endFunction

; #############################
; ### Preset Saving/Loading ###

; - Save -

function SavePreset()
    string textInput = ((Self as Form) as iEquip_UILIB).ShowTextInput("$iEquip_EM_lbl_namePreset", "")
    
    if textInput != ""
        int jSavePreset = jMap.object()

		jMap.setInt(jSavePreset, "Version", GetVersion())
        jMap.setObj(jSavePreset, "_X", jArray.objectWithFloats(WC.afWidget_X))
        jMap.setObj(jSavePreset, "_Y", jArray.objectWithFloats(WC.afWidget_Y))
        jMap.setObj(jSavePreset, "_S", jArray.objectWithFloats(WC.afWidget_S))
        jMap.setObj(jSavePreset, "_R", jArray.objectWithFloats(WC.afWidget_R))
        jMap.setObj(jSavePreset, "_A", jArray.objectWithFloats(WC.afWidget_A))
        jMap.setObj(jSavePreset, "_D", jArray.objectWithInts(WC.aiWidget_D))
        jMap.setObj(jSavePreset, "_TC", jArray.objectWithInts(WC.aiWidget_TC))
        jMap.setObj(jSavePreset, "_TA", jArray.objectWithStrings(WC.asWidget_TA))
		jMap.setInt(jSavePreset, "potionSelectorAlignment", bPotionSelectorOnLeft as int)
		jMap.setInt(jSavePreset, "chargeDisplayType", CM.iChargeDisplayType)
		jMap.setInt(jSavePreset, "backgroundStyle", WC.iBackgroundStyle)

        jValue.writeTofile(jSavePreset, WC.WidgetPresetPath + textInput + WC.FileExt)
        jValue.zeroLifetime(jSavePreset)
        Debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_EM_not_savedAs") + " " + textInput + WC.FileExt)
    endIf
endFunction

; - Load -

function LoadPreset(int jPreset)
    int[] abWidget_V_temp = new int[54]

    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_X"), WC.afWidget_X, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_Y"), WC.afWidget_Y, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_S"), WC.afWidget_S, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_R"), WC.afWidget_R, 0, -1, 0, 0)
    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_A"), WC.afWidget_A, 0, -1, 0, 0)
    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_D"), WC.aiWidget_D, 0, -1, 0, 0)
    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_TC"), WC.aiWidget_TC, 0, -1, 0, 0)
    JArray.writeToStringPArray(JMap.getObj(jPreset, "_TA"), WC.asWidget_TA, 0, -1, 0, 0)
	bPotionSelectorOnLeft = jMap.getInt(jPreset, "potionSelectorAlignment") as bool
	CM.iChargeDisplayType = jMap.getInt(jPreset, "chargeDisplayType")
	WC.iBackgroundStyle = jMap.getInt(jPreset, "backgroundStyle")
    
    WC.updateWidgetVisibility(false)
    Wait(0.2)
    if isEditMode
	   UpdateEditModeGuide()
    endIf
    UpdateElementsAll()
	
    if CM.iChargeDisplayType > 0
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ;SkyHUD Alt Charge Meter
	else
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 100)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 100)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 100)
	endIf

    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setPotionSelectorAlignment", bPotionSelectorOnLeft)

    if !isEditMode                          ; The only time this will be the case is if the user has selected Reset Layout in the MCM, and we're loading the default layout preset
        WC.bRefreshingWidget = true
        bool bWasPreselectMode = WC.bPreselectMode
        WC.bPreselectMode = false
        bool[] args = new bool[5]
        args[0] = (WC.bAmmoMode && !WC.AM.bSimpleAmmoMode)
        args[3] = (WC.bAmmoMode && !WC.AM.bSimpleAmmoMode)
        UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
        WC.refreshWidgetOnLoad()
        WC.bRefreshingWidget = false
        if !WC.EH.bPlayerIsABeast
            WC.checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipType"))
        endIf

        if bWasPreselectMode
            PM.togglePreselectMode(false, true)
        endIf
    else
        WC.updatePotionSelector(true)
        UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", WC.iBackgroundStyle)
    endIf
    Wait(0.1)
    WC.updateWidgetVisibility()
endFunction

; #####################
; ### Reset/Discard ###

; - Discard -

function DiscardChanges()
    ; Confirmation messagebox
    if WC.showTranslatedMessage(9, iEquip_StringExt.LocalizeString("$iEquip_msg_confDiscard"))
        Int iIndex
        
        WC.updateWidgetVisibility(false)
        Wait(0.2)
        
        while iIndex < WC.asWidgetDescriptions.length
            WC.afWidget_X[iIndex] = afWidget_CurX[iIndex]
            WC.afWidget_Y[iIndex] = afWidget_CurY[iIndex]
            WC.afWidget_S[iIndex] = afWidget_CurS[iIndex]
            WC.afWidget_R[iIndex] = afWidget_CurR[iIndex]
            WC.afWidget_A[iIndex] = afWidget_CurA[iIndex]
            WC.aiWidget_D[iIndex] = aiWidget_CurD[iIndex]
            WC.aiWidget_TC[iIndex] = aiWidget_CurTC[iIndex]
            WC.asWidget_TA[iIndex] = asWidget_CurTA[iIndex]
            iIndex += 1
        endWhile
        
        UpdateElementsAll()
        UpdateEditModeGuide()
        WC.updateWidgetVisibility()
    endIf
endFunction

; - Reset  -

function ResetElementIndex(int[] iArgs, int iIndex)
    WC.afWidget_X[iIndex] = WC.afWidget_DefX[iIndex]
    WC.afWidget_Y[iIndex] = WC.afWidget_DefY[iIndex]
    WC.afWidget_S[iIndex] = WC.afWidget_DefS[iIndex]
    WC.afWidget_R[iIndex] = WC.afWidget_DefR[iIndex]
    WC.afWidget_A[iIndex] = WC.afWidget_DefA[iIndex]
    
    if WC.abWidget_isText[iIndex]
        WC.asWidget_TA[iIndex] = WC.asWidget_DefTA[iIndex]
        iArgs[0] = iIndex
        UpdateElementText(iArgs, 0xFFFFFF)
    endIf

    UpdateElementData(iIndex, false)
    SetElementDepthOrder(iIndex, false)
endFunction

function ResetElement()
    if iSelectedElement > 0
        int theMessage
        string theString
    
        if WC.abWidget_isParent[iSelectedElement]
            theMessage = 8 ;iEquip_ConfirmResetParent
            theString = iEquip_StringExt.LocalizeString("$iEquip_msg_confReset")
        else
            theMessage = 7 ;iEquip_ConfirmReset
            theString = iEquip_StringExt.LocalizeString("$iEquip_msg_confResetParent")
        endIf
        
        ; Confirm choice
        if WC.showTranslatedMessage(theMessage, theString) == 1
            int[] iArgs = new int[3]
            HighlightElement(false)
            TweenElement(5, 0, 0.15)
            Wait(0.15)
            
            ; Reset element and children
            ResetElementIndex(iArgs, iSelectedElement)
            if WC.abWidget_isParent[iSelectedElement]
                int iIndex = 6
                
                while iIndex < WC.asWidgetDescriptions.length
                    if WC.asWidgetGroup[iIndex] == WC.asWidgetGroup[iSelectedElement]
                        ResetElementIndex(iArgs, iIndex)
                    endIf
                    iIndex += 1
                endWhile
            endIf
            
            TweenElement(5, WC.afWidget_A[iSelectedElement], 0.2)
            UpdateEditModeGuide()
            HighlightElement(true)
        endIf
    endIf
endFunction

; #####################
; ### MISCELLANEOUS ###

; - CreateCallbackHandle -

bool function CreateHandleIntStr(string func, int i, string str)
    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + func)
    if(iHandle)
        UICallback.PushInt(iHandle, i)
        UICallback.PushString(iHandle, str)
        UICallback.Send(iHandle)
        
        return true
    else
        return false
    endIf
endFunction

; - HexToInt -

int function HexStringToInt(string sHex)
    int iDec
    int iPlace = 1
    int iIndex = 6
    
    while iIndex > 0
        iIndex -= 1
        string sChar = SubString(sHex, iIndex, 1)
        int iSubNumber
        
        if IsDigit(sChar)
            iSubNumber = sChar as int
        Else
            iSubNumber = AsOrd(sChar) - 55
        endIf
        
        iDec += iSubNumber * iPlace
        iPlace *= 16
    endWhile
    
    Return iDec
endFunction
