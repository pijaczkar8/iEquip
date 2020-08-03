
scriptName iEquip_PotionScript extends Quest

;import _Q2C_Functions
import AhzMoreHudIE
import iEquip_StringExt
import iEquip_FormExt
import iEquip_ActorExt
import iEquip_ObjectReferenceExt
import UI

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_PlayerEventHandler property EH auto

actor property PlayerRef auto

FormList property iEquip_AllCurrentItemsFLST auto
FormList property iEquip_PotionItemsFLST auto
Formlist property iEquip_GeneralBlacklistFLST auto ;To block individual potions and poisons previously manually removed through the queue menus from being auto-added again. Does not affect Potion Groups

String HUD_MENU = "HUD Menu"
String WidgetRoot

bool bIsFirstRun = true

int[] aiPotionQ
int iConsumableQ
int iPoisonQ

MagicEffect[] aStrongestEffects
MagicEffect property AlchRestoreHealth auto ;0003eb15
MagicEffect property AlchFortifyHealth auto ;0003eaf3
MagicEffect property AlchFortifyHealRate auto ;0003eb06
MagicEffect property AlchRestoreMagicka auto ;0003eb17
MagicEffect property AlchFortifyMagicka auto ;0003eaf8
MagicEffect property AlchFortifyMagickaRate auto ;0003eb07
MagicEffect property AlchRestoreStamina auto ;0003eb16
MagicEffect property AlchFortifyStamina auto ;0003eaf9
MagicEffect property AlchFortifyStaminaRate auto ;0003eb08

MagicEffect[] aConsummateEffects
MagicEffect property AlchRestoreHealthAll auto ;000ffa03
MagicEffect property AlchRestoreMagickaAll auto ;000ffa04
MagicEffect property AlchRestoreStaminaAll auto ;000ffa05

MagicEffect[] aPoisonEffects
MagicEffect property AlchDamageHealth auto ;0003eb42
MagicEffect property AlchDamageHealthDuration auto ;0010aa4a
MagicEffect property AlchDamageHealthRavage auto ;00073f26
MagicEffect property AlchDamageMagicka auto ;0003a2b6
MagicEffect property AlchDamageMagickaDuration auto ;0010de5f
MagicEffect property AlchDamageMagickaRate auto ;00073f2B
MagicEffect property AlchDamageMagickaRavage auto ;00073f27
MagicEffect property AlchDamageSpeed auto ;00073f25
MagicEffect property AlchDamageStamina auto ;0003a2b6
MagicEffect property AlchDamageStaminaDuration auto ;0010de5f
MagicEffect property AlchDamageStaminaRate auto ;00073f2B
MagicEffect property AlchDamageStaminaRavage auto ;00073f27
MagicEffect property AlchInfluenceAggUp auto ;00073f29
MagicEffect property AlchInfluenceAggUpCombo auto ;000ff9f8
MagicEffect property AlchInfluenceAggUpComboCOPY0000 auto ;0010fdd4
MagicEffect property AlchInfluenceConfDown auto ;00073f20
MagicEffect property AlchParalysis auto ;00073f30
MagicEffect property AlchWeaknessFire auto ;00073f2D
MagicEffect property AlchWeaknessFrost auto ;00073f2E
MagicEffect property AlchWeaknessMagic auto ;00073f51
MagicEffect property AlchWeaknessPoison auto ;00090042
MagicEffect property AlchWeaknessShock auto ;00073f2F

; Skooma Keywords
keyword VendorItemIllicitDrug
keyword REQ_KW_VendorItem_BlackMarket

string[] asPotionGroups
String[] asPoisonIconNames
string[] asActorValues
int[] aiActorValues

int property iPotionSelectChoice = 1 auto hidden ; 0 = Always use strongest, 1 = Smart Select, 2 = Always Use Weakest
float property fSmartSelectThreshold = 0.4 auto hidden
int property iQuickBuffsToApply = 3 auto hidden

bool bIsCACOLoaded
MagicEffect[] aCACO_RestoreEffects
bool bIsPAFLoaded
MagicEffect[] aPAF_RestoreEffects
string[] asEffectNames

bool bMoreHUDLoaded

bool bIsEnderalLoaded
MagicEffect[] aEnderal_RestoreEffects

bool bIsRequiemLoaded

bool bAddedToQueue
int iQueueToSort = -1 ;Only used if potion added by onPotionAdded
float fTempStrength
int iTempDuration
bool bQueueSortedBy3sStrength
float fActiveEffectMagnitude

bool property bautoAddPoisons = true auto hidden
bool property bautoAddPotions = true auto hidden
bool property bCheckOtherEffects = true auto hidden
bool property bExcludeRestoreAllEffects auto hidden
bool property bautoAddConsumables = true auto hidden
bool property bQuickRestoreUseSecondChoice = true auto Hidden
bool property bFlashPotionWarning = true auto hidden
int property iEmptyPotionQueueChoice auto hidden
bool property bEnableRestorePotionWarnings = true auto hidden
bool property bNotificationOnLowRestorePotions = true auto hidden
bool property bBlockIfRestEffectActive = true auto hidden
bool property bSuspendChecksInCombat = true auto hidden
bool property bBlockIfBuffEffectActive = true auto hidden
int property iNotificationLevel = 2 auto hidden

bool bInitialised

event OnInit()
    ;debug.trace("iEquip_PotionScript OnInit start")
    GotoState("")
    
    aiPotionQ = new int[9]
    aStrongestEffects = new MagicEffect[9]
    aStrongestEffects[0] = AlchRestoreHealth
    aStrongestEffects[1] = AlchFortifyHealth
    aStrongestEffects[2] = AlchFortifyHealRate
    aStrongestEffects[3] = AlchRestoreMagicka
    aStrongestEffects[4] = AlchFortifyMagicka
    aStrongestEffects[5] = AlchFortifyMagickaRate
    aStrongestEffects[6] = AlchRestoreStamina
    aStrongestEffects[7] = AlchFortifyStamina
    aStrongestEffects[8] = AlchFortifyStaminaRate

    aConsummateEffects = new MagicEffect[3]
    aConsummateEffects[0] = AlchRestoreHealthAll
    aConsummateEffects[1] = AlchRestoreMagickaAll
    aConsummateEffects[2] = AlchRestoreStaminaAll

    aPoisonEffects = new MagicEffect[22]
    aPoisonEffects[0] = AlchDamageHealth
    aPoisonEffects[1] = AlchDamageHealthDuration
    aPoisonEffects[2] = AlchDamageHealthRavage
    aPoisonEffects[3] = AlchDamageMagicka
    aPoisonEffects[4] = AlchDamageMagickaDuration
    aPoisonEffects[5] = AlchDamageMagickaRate
    aPoisonEffects[6] = AlchDamageMagickaRavage
    aPoisonEffects[7] = AlchDamageSpeed
    aPoisonEffects[8] = AlchDamageStamina
    aPoisonEffects[9] = AlchDamageStaminaDuration
    aPoisonEffects[10] = AlchDamageStaminaRate
    aPoisonEffects[11] = AlchDamageStaminaRavage
    aPoisonEffects[12] = AlchInfluenceAggUp
    aPoisonEffects[13] = AlchInfluenceAggUpCombo
    aPoisonEffects[14] = AlchInfluenceAggUpComboCOPY0000
    aPoisonEffects[15] = AlchInfluenceConfDown
    aPoisonEffects[16] = AlchParalysis
    aPoisonEffects[17] = AlchWeaknessFire
    aPoisonEffects[18] = AlchWeaknessFrost
    aPoisonEffects[19] = AlchWeaknessMagic
    aPoisonEffects[20] = AlchWeaknessPoison
    aPoisonEffects[21] = AlchWeaknessShock

    asPoisonIconNames = new String[22]
    asPoisonIconNames[0] = "PoisonHealth"
    asPoisonIconNames[1] = "PoisonHealth"
    asPoisonIconNames[2] = "PoisonHealth"
    asPoisonIconNames[3] = "PoisonMagicka"
    asPoisonIconNames[4] = "PoisonMagicka"
    asPoisonIconNames[5] = "PoisonMagicka"
    asPoisonIconNames[6] = "PoisonMagicka"
    asPoisonIconNames[7] = "PoisonStamina"
    asPoisonIconNames[8] = "PoisonStamina"
    asPoisonIconNames[9] = "PoisonStamina"
    asPoisonIconNames[10] = "PoisonStamina"
    asPoisonIconNames[11] = "PoisonStamina"
    asPoisonIconNames[12] = "PoisonFrenzy"
    asPoisonIconNames[13] = "PoisonFrenzy"
    asPoisonIconNames[14] = "PoisonFrenzy"
    asPoisonIconNames[15] = "PoisonFear"
    asPoisonIconNames[16] = "PoisonParalysis"
    asPoisonIconNames[17] = "PoisonWeaknessFire"
    asPoisonIconNames[18] = "PoisonWeaknessFrost"
    asPoisonIconNames[19] = "PoisonWeaknessMagic"
    asPoisonIconNames[20] = "PoisonWeaknessPoison"
    asPoisonIconNames[21] = "PoisonWeaknessShock"

    asActorValues = new string[3]
    asActorValues[0] = "Health"
    asActorValues[1] = "Magicka"
    asActorValues[2] = "Stamina"

    aiActorValues = new int[3]
    aiActorValues[0] = 24 ;Health
    aiActorValues[1] = 25 ;Magicka
    aiActorValues[2] = 26 ;Stamina

    asPotionGroups = new string[3]
    asPotionGroups[0] = "$iEquip_common_HealthPotions"
    asPotionGroups[1] = "$iEquip_common_MagickaPotions"
    asPotionGroups[2] = "$iEquip_common_StaminaPotions"

    asEffectNames = new string[9]
    asEffectNames[0] = "$iEquip_PO_restoreHealth"
    asEffectNames[1] = "$iEquip_PO_fortifyHealth"
    asEffectNames[2] = "$iEquip_PO_regenHealth"
    asEffectNames[3] = "$iEquip_PO_restoreMagicka"
    asEffectNames[4] = "$iEquip_PO_fortifyMagicka"
    asEffectNames[5] = "$iEquip_PO_regenMagicka"
    asEffectNames[6] = "$iEquip_PO_restoreStamina"
    asEffectNames[7] = "$iEquip_PO_fortifyStamina"
    asEffectNames[8] = "$iEquip_PO_regenStamina"

   
    bInitialised = true
    ;debug.trace("iEquip_PotionScript OnInit end")
endEvent

; Called from WidgetCore ENABLED OnBeginState
function InitialisePotionQueueArrays(int jHolderObj, int consQ, int poisQ)
    ;debug.trace("iEquip_PotionScript InitialisePotionQueueArrays start")
    iConsumableQ = consQ
    iPoisonQ = poisQ
    aiPotionQ[0] = JArray.object()
    JMap.setObj(jHolderObj, "healthRestoreQ", aiPotionQ[0])
    aiPotionQ[1] = JArray.object()
    JMap.setObj(jHolderObj, "healthFortifyQ", aiPotionQ[1])
    aiPotionQ[2] = JArray.object()
    JMap.setObj(jHolderObj, "healthRegenQ", aiPotionQ[2])
    aiPotionQ[3] = JArray.object()
    JMap.setObj(jHolderObj, "magickaRestoreQ", aiPotionQ[3])
    aiPotionQ[4] = JArray.object()
    JMap.setObj(jHolderObj, "magickaFortifyQ", aiPotionQ[4])
    aiPotionQ[5] = JArray.object()
    JMap.setObj(jHolderObj, "magickaRegenQ", aiPotionQ[5])
    aiPotionQ[6] = JArray.object()
    JMap.setObj(jHolderObj, "staminaRestoreQ", aiPotionQ[6])
    aiPotionQ[7] = JArray.object()
    JMap.setObj(jHolderObj, "staminaFortifyQ", aiPotionQ[7])
    aiPotionQ[8] = JArray.object()
    JMap.setObj(jHolderObj, "staminaRegenQ", aiPotionQ[8])
    ;debug.trace("iEquip_PotionScript InitialisePotionQueueArrays end")
endfunction

; Called from PlayerEventHandler OnPlayerLoadGame
function initialise()
    ;debug.trace("iEquip_PotionScript initialise start")
    while !bInitialised
        Utility.WaitMenuMode(0.01)
    endWhile
    WidgetRoot = WC.WidgetRoot
    bMoreHUDLoaded = WC.bMoreHUDLoaded
    WC.abPotionGroupEmpty[0] = true
    WC.abPotionGroupEmpty[1] = true
    WC.abPotionGroupEmpty[2] = true

    int i

    aCACO_RestoreEffects = new MagicEffect[9]
    if Game.GetModByName("Complete Alchemy & Cooking Overhaul.esp") != 255
        bIsCACOLoaded = true
        aCACO_RestoreEffects[0] = Game.GetFormFromFile(0x001AA0B6, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[1] = Game.GetFormFromFile(0x001AA0B7, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[2] = Game.GetFormFromFile(0x001AA0B8, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[3] = Game.GetFormFromFile(0x001B42BE, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[4] = Game.GetFormFromFile(0x001B42BF, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[5] = Game.GetFormFromFile(0x001B42C0, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[6] = Game.GetFormFromFile(0x001B42BB, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[7] = Game.GetFormFromFile(0x001B42BC, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        aCACO_RestoreEffects[8] = Game.GetFormFromFile(0x001B42BD, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        VendorItemIllicitDrug = Game.GetFormFromFile(0x00A08E48, "Complete Alchemy & Cooking Overhaul.esp") as keyword
    else
        bIsCACOLoaded = false
        while i < 9
            aCACO_RestoreEffects[i] = none
            i += 1
        endWhile
        VendorItemIllicitDrug = none
    endIf
    
    aPAF_RestoreEffects = new MagicEffect[6]
    if Game.GetModByName("PotionAnimatedFix.esp") != 255
        bIsPAFLoaded = true
        aPAF_RestoreEffects[0] = Game.GetFormFromFile(0x006B2D4, "PotionAnimatedFix.esp") as MagicEffect
        aPAF_RestoreEffects[1] = Game.GetFormFromFile(0x00754DB, "PotionAnimatedFix.esp") as MagicEffect
        aPAF_RestoreEffects[2] = Game.GetFormFromFile(0x00754DC, "PotionAnimatedFix.esp") as MagicEffect
        aPAF_RestoreEffects[3] = Game.GetFormFromFile(0x00754DD, "PotionAnimatedFix.esp") as MagicEffect
        aPAF_RestoreEffects[4] = Game.GetFormFromFile(0x00754DE, "PotionAnimatedFix.esp") as MagicEffect
        aPAF_RestoreEffects[5] = Game.GetFormFromFile(0x00754DF, "PotionAnimatedFix.esp") as MagicEffect
    else
        bIsPAFLoaded = false
        i = 0
        while i < 6
            aPAF_RestoreEffects[i] = none
            i += 1
        endWhile
    endIf
    
    aEnderal_RestoreEffects = new MagicEffect[3]
    if Game.GetModByName("Enderal - Forgotten Stories.esm") != 255
        bIsEnderalLoaded = true
        aEnderal_RestoreEffects[0] = Game.GetFormFromFile(0x000028C3, "Skyrim.esm") as MagicEffect  ; 00E_AlchRestoreHealth
        aEnderal_RestoreEffects[1] = Game.GetFormFromFile(0x000028DD, "Skyrim.esm") as MagicEffect  ; 00E_AlchRestoreMagicka
        aEnderal_RestoreEffects[2] = Game.GetFormFromFile(0x000028DC, "Skyrim.esm") as MagicEffect  ; 00E_AlchRestoreStamina
    else
        bIsEnderalLoaded = false
    endIf
    
    if Game.GetModByName("Requiem.esp") != 255
        bIsRequiemLoaded = true
        REQ_KW_VendorItem_BlackMarket = Game.GetFormFromFile(0x00444D86, "Requiem.esp") as keyword
    else
        bIsRequiemLoaded = false
        REQ_KW_VendorItem_BlackMarket = none
    endIf
    ;debug.trace("iEquip_PotionScript initialise - bIsCACOLoaded: " + bIsCACOLoaded + ", bIsPAFLoaded: " + bIsPAFLoaded)
    findAndSortPotions()
endFunction

; Called from WidgetCore initialisemoreHUDArray
function initialisemoreHUDArray()
    ;debug.trace("iEquip_PotionScript initialisemoreHUDArray start")
    int jItemIDs = jArray.object()
    int jIconNames = jArray.object()
    int Q = 0
    
    while Q < 9
        int queueLength = JArray.count(aiPotionQ[Q])
        int i = 0
        ;debug.trace("iEquip_PotionScript initialisemoreHUDArray - Q" + Q + " contains " + queueLength + " potions")
        
        while i < queueLength
            form itemForm = jMap.getForm(jArray.getObj(aiPotionQ[Q], i), "iEquipForm")
            if !itemForm
                jArray.eraseIndex(aiPotionQ[Q], i)
                queueLength -= 1
            endIf
            int itemID = jMap.getInt(jArray.getObj(aiPotionQ[Q], i), "iEquipItemID")
            ;debug.trace("iEquip_PotionScript initialisemoreHUDArray Q: " + Q + ", i: " + i + ", itemID: " + itemID + ", " + jMap.getStr(jArray.getObj(aiPotionQ[Q], i), "iEquipName"))
            if itemID == 0
                itemID = CalcCRC32Hash(itemForm.GetName(), Math.LogicalAND(itemForm.GetFormID(), 0x00FFFFFF))
                jMap.setInt(jArray.getObj(aiPotionQ[Q], i), "iEquipItemID", itemID)
            endIf
            if itemID != 0
                jArray.addInt(jItemIDs, jMap.getInt(jArray.getObj(aiPotionQ[Q], i), "iEquipItemID"))
                jArray.addStr(jIconNames, "iEquipQ.png")
            endIf
            i += 1
        endWhile

        Q += 1
    endWhile
    ;debug.trace("iEquip_PotionScript initialisemoreHUDArray - jItemIds contains " + jArray.count(jItemIDs) + " entries")
    ;debug.trace("iEquip_PotionScript initialisemoreHUDArray - jIconNames contains " + jArray.count(jIconNames) + " entries")
    if jArray.count(jItemIDs) > 0
        int[] itemIDs = utility.CreateIntArray(jArray.count(jItemIDs))
        string[] iconNames = utility.CreateStringArray(jArray.count(jIconNames))
        jArray.writeToIntegerPArray(jItemIDs, itemIDs)
        jArray.writeToStringPArray(jIconNames, iconNames)
        ;debug.trace("iEquip_PotionScript initialisemoreHUDArray - itemIDs contains " + itemIDs.Length + " entries with " + itemIDs[0] + " in index 0")
        ;debug.trace("iEquip_PotionScript initialisemoreHUDArray - iconNames contains " + iconNames.Length + " entries with " + iconNames[0] + " in index 0")
        AhzMoreHudIE.AddIconItems(itemIDs, iconNames)
    endIf
    ;debug.trace("iEquip_PotionScript initialisemoreHUDArray end")
endFunction

function findAndSortPotions()
    ;Count the number of potion items currently in the players inventory
    int numFound = GetNumItemsOfType(PlayerRef, 46)
    ;debug.trace("iEquip_PotionScript findAndSortPotions start - there are " + numFound + " potions in the player's inventory")
    ;If any potions found
    if numFound > 0
        int i = 0
        int count
        int iIndex
        int[] openingQSizes = new int[10]
        while i < 9
            iIndex = 0
            count = jArray.count(aiPotionQ[i])
            ;Check and remove any potions which are no longer in the players inventory (fallback as there shouldn't be any!)
            while iIndex < count
                form potionForm = jMap.getForm(jArray.getObj(aiPotionQ[i], iIndex), "iEquipForm")
                if !potionForm || PlayerRef.GetItemCount(potionForm) < 1
                    if potionForm
                        iEquip_PotionItemsFLST.RemoveAddedForm(potionForm)
                        EH.updateEventFilter(iEquip_PotionItemsFLST)
                    endIf
                    removePotionFromQueue(i, iIndex)
                    count -= 1
                else
                    iIndex += 1
                endIf
            endWhile
            ;Store the opening potion queue lengths for comparison later
            openingQSizes[i] = jArray.count(aiPotionQ[i])
            i += 1
        endWhile
        openingQSizes[9] = jArray.count(iPoisonQ)
        i = 0
        potion foundPotion
        ;Add each potion to the relevant queue
        while i < numFound
            foundPotion = GetNthFormOfType(PlayerRef, 46, i) as potion
            if foundPotion
                ;debug.trace("iEquip_PotionScript findAndSortPotions - " + i + " is a " + foundPotion.GetName())
                checkAndAddToPotionQueue(foundPotion, true)
            endIf
            i += 1
        endWhile
        ;Now check if anything has been added to each potion queue and resort each if required
        i = 0
        while i < 9
            ;debug.trace("iEquip_PotionScript findAndSortPotions - aiPotionQ: " + i + ", openingQSizes: " + openingQSizes[i] + ", new count: " + jArray.count(aiPotionQ[i]))
            if jArray.count(aiPotionQ[i]) > openingQSizes[i]
                sortPotionQueue(i, "iEquipStrengthTotal")
            endIf
            i += 1
        endWhile
        if jArray.count(iPoisonQ) > openingQSizes[9]
            sortPoisonQueue()
        endIf 
        ;Finally get the group counts and update the potionGroupEmpty bool array
        i = 0
        while i < 3
            numFound = getPotionGroupCount(i)
            if numFound > 0
                WC.abPotionGroupEmpty[i] = false
                ;debug.trace("iEquip_PotionScript findAndSortPotions - potionGroup: " + i + ", numFound: " + numFound + ", potionGroupEmpty[" + i + "]: " + WC.abPotionGroupEmpty[i])
            endIf
            i += 1
        endWhile
    else
        ;debug.trace("iEquip_PotionScript findAndSortPotions - No health, stamina or magicka potions found in players inventory")
    endIf
    bIsFirstRun = false
    ;debug.trace("iEquip_PotionScript findAndSortPotions end")
endFunction

function onPotionAdded(form newPotion)
    ;debug.trace("iEquip_PotionScript onPotionAdded start - newPotion: " + newPotion.GetName())
    checkAndAddToPotionQueue(newPotion as potion)
    if bAddedToQueue && iQueueToSort != -1
        if iQueueToSort == iPoisonQ
            sortPoisonQueue()
        elseIf iQueueToSort != iConsumableQ
            sortPotionQueue(iQueueToSort, "iEquipStrengthTotal")
        endIf
    endIf
    ;debug.trace("iEquip_PotionScript onPotionAdded end")
endFunction

function onPotionRemoved(form removedPotion)
    ;debug.trace("iEquip_PotionScript onPotionRemoved start - removedPotion: " + removedPotion.GetName())
    GotoState("PROCESSING")
    potion thePotion = removedPotion as potion
    int foundPotion
    int itemCount = PlayerRef.GetItemCount(removedPotion)
    if thePotion.isPoison()
        ;debug.trace("iEquip_PotionScript onPotionRemoved - removedPotion is a poison")
        if itemCount < 1
            foundPotion = findInQueue(iPoisonQ, removedPotion)
            if foundPotion != -1
                WC.removeItemFromQueue(4, foundPotion, false, false, true, false)
            endIf
        elseIf WC.asCurrentlyEquipped[4] == removedPotion.GetName()
            WC.setSlotCount(4, itemCount)
        endIf
    else
    	;Check and remove from the main consumable queue first
    	if itemCount < 1
            foundPotion = findInQueue(iConsumableQ, removedPotion)
            if foundPotion != -1
                WC.removeItemFromQueue(3, foundPotion, false, false, true, false)
            endIf
        elseIf WC.asCurrentlyEquipped[3] == removedPotion.GetName()
            WC.setSlotCount(3, itemCount)
        endIf
    	;Then check and remove from the potion groups
    	if !thePotion.IsFood()
	        int Q = getPotionQueue(thePotion)
	        if Q >= 0
	            int group ; Q < 3 defaults to 0
	            if Q > 2
                    if Q < 6
    	                group = 1
    	            else
    	                group = 2
    	            endIf
                endIf
                string potionGroup = asPotionGroups[group]
	            if WC.asCurrentlyEquipped[3] == potionGroup
	                WC.setSlotCount(3, getPotionGroupCount(group))
                    if WC.bPotionSelectorShown
                        WC.updatePotionSelector()
                    endIf
	            endIf
	        endIf
	        if itemCount < 1
	            iEquip_PotionItemsFLST.RemoveAddedForm(removedPotion)
	            EH.updateEventFilter(iEquip_PotionItemsFLST)
                if Q != -1
	               foundPotion = findInQueue(aiPotionQ[Q], removedPotion)
    	            if foundPotion != -1
    	                removePotionFromQueue(Q, foundPotion)
    	            endIf
                endIf
	        endIf
	    endIf
    endIf
    GotoState("")
    ;debug.trace("iEquip_PotionScript onPotionRemoved end")
endFunction

function removePotionFromQueue(int Q, int targetPotion)
    ;debug.trace("iEquip_PotionScript removePotionFromQueue start - Q: " + Q + ", targetPotion: " + targetPotion)
    if bMoreHUDLoaded
        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipItemID"))
    endIf
    ;First we need to remove the potion from the relevant queue
    jArray.eraseIndex(aiPotionQ[Q], targetPotion)
    ;Now we need to check to see if any potions remain in the three potion queues within the potion group we've just removed from
    if Q < 3
        Q = 0
    elseIf Q < 6
        Q = 1
    else
        Q = 2
    endIf
    string potionGroup = asPotionGroups[Q]
    int count = getPotionGroupCount(Q)
    ;If all three arrays in the group are empty then we need to update the widget accordingly
    if count < 1
        ;Flag the group as empty in WidgetCore for cycling
        WC.abPotionGroupEmpty[Q] = true
    endIf
    ;Check if it's the currently shown item in the consumable slot
    if WC.asCurrentlyEquipped[3] == potionGroup
        ;debug.trace("iEquip_PotionScript removePotionFromQueue - potion group is currently shown")
        if WC.abPotionGroupEmpty[Q]
            ;Check and flash empty warning if enabled
            if bFlashPotionWarning
                ;debug.trace("iEquip_PotionScript removePotionFromQueue - should be flashing empty warning now - Q: " + Q)
                UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", Q)
                Utility.WaitMenuMode(1.4)
            endIf
            ;Finally check if we're fading icon or cycling to next slot
            if iEmptyPotionQueueChoice == 0 ;Fade icon
                ;debug.trace("iEquip_PotionScript removePotionFromQueue - should be fading now")
                WC.checkAndFadeConsumableIcon(true)
            elseIf iEmptyPotionQueueChoice == 1 ;Hide icon
                ;debug.trace("iEquip_PotionScript removePotionFromQueue - should be cycling forward now")
                WC.cycleSlot(3)
            endIf
        else
            WC.setSlotCount(3, count)
        endIf
    endIf
    ;debug.trace("iEquip_PotionScript removePotionFromQueue end")
endFunction

function removeRestoreAllPotionsFromGroups()
    ;debug.trace("iEquip_PotionScript removeRestoreAllPotionsFromQueues start")
    int Q
    while Q < 7
        int count = jArray.count(aiPotionQ[Q])
        int i = 0
        while i < count
            if jMap.getFlt(jArray.getObj(aiPotionQ[Q], i), "iEquipStrengthTotal") > 9000
                if bautoAddPotions && findInQueue(iConsumableQ, jMap.getForm(jArray.getObj(aiPotionQ[Q], i), "iEquipForm")) == -1
                    jArray.addObj(iConsumableQ, jArray.getObj(aiPotionQ[Q], i))
                endIf
                removePotionFromQueue(Q, i)
                count -= 1
            else
                i += 1
            endIf
        endWhile
        Q += 3
    endWhile
    ;debug.trace("iEquip_PotionScript removeRestoreAllPotionsFromQueues end")
endFunction

function removeGroupedPotionsFromConsumableQueue(int potionGroup)
    ;debug.trace("iEquip_PotionScript removeGroupedPotionsFromConsumableQueue start")
    int Q = potionGroup * 3
    int maxQ = Q + 3
    int i
    int queueLength
    int targetArray
    while Q < maxQ
        targetArray = aiPotionQ[Q]
        queueLength = jArray.count(targetArray)
        while i < queueLength
            if findInQueue(iConsumableQ, jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm")) != -1
                jArray.eraseIndex(iConsumableQ, i)
                queueLength -= 1
            else
                i += 1
            endIf
        endWhile
        i = 0
        Q += 1
    endWhile
    ;debug.trace("iEquip_PotionScript removeGroupedPotionsFromConsumableQueue end")
endFunction

function addIndividualPotionsToQueue(int potionGroup)
    ;debug.trace("iEquip_PotionScript addIndividualPotionsToQueue start")
    int Q = potionGroup * 3
    int maxQ = Q + 3
    int i
    int queueLength
    int targetArray
    while Q < maxQ
        targetArray = aiPotionQ[Q]
        queueLength = jArray.count(targetArray)
        while i < queueLength
            if findInQueue(iConsumableQ, jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm")) == -1
                jArray.addObj(iConsumableQ, jArray.getObj(targetArray, i))
            endIf
            i += 1
        endWhile
        i = 0
        Q += 1
    endWhile
    ;debug.trace("iEquip_PotionScript addIndividualPotionsToQueue end")
endFunction

int function getPotionGroupCount(int potionGroup)
    ;debug.trace("iEquip_PotionScript getPotionGroupCount start - potionGroup: " + potionGroup)
    int count
    int Q = potionGroup * 3
    int maxQ = Q + 3
    int i = 0
    int queueLength
    int targetArray
    int currentCount
    while Q < maxQ
        targetArray = aiPotionQ[Q]
        queueLength = jArray.count(targetArray)
        ;debug.trace("iEquip_PotionScript getPotionGroupCount - currently checking Q: " + Q + ", queueLength: " + queueLength)
        while i < queueLength
            currentCount = count
            count += PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm"))
            ;debug.trace("iEquip_PotionScript getPotionGroupCount - " + (count - currentCount) + " potions found in index " + i + " in potion queue " + Q)
            i += 1
        endWhile
        i = 0
        Q += 1
    endWhile
    ;debug.trace("iEquip_PotionScript getPotionGroupCount returning count: " + count)
    return count
endFunction

int function getCountForSelector(int potionGroup, int potionType)
    ;debug.trace("iEquip_PotionScript getCountForSelector start")
    int i
    int count
    int Q = aiPotionQ[(potionGroup*3) + potionType]
    int queueLength = jArray.count(Q)
    while i < queueLength
        count += PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(Q, i), "iEquipForm"))
        i += 1
    endWhile
    ;debug.trace("iEquip_PotionScript getCountForSelector end - potionGroup: " + potionGroup + ", potionType: " + potionType + ", count: " + count)
    return count
endFunction

int function getRestoreCount(int potionGroup)
    ;debug.trace("iEquip_PotionScript getRestoreCount start - potionGroup: " + potionGroup)
    int count
    int targetArray = aiPotionQ[potionGroup * 3]
    int queueLength = jArray.count(targetArray)
    int i
    while i < queueLength
        count += PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm"))
        i += 1
    endWhile
    ;debug.trace("iEquip_PotionScript getRestoreCount returning count: " + count)
    return count
endFunction

int function getPotionTypeCount(int Q)
    return jArray.count(aiPotionQ[Q])
endFunction

int function getPotionQueue(potion potionToCheck, bool bAdding = false)
    ;debug.trace("iEquip_PotionScript getPotionQueue start")
    int selectedEffIndx = potionToCheck.GetCostliestEffectIndex()
    magicEffect effectToCheck = potionToCheck.GetNthEffectMagicEffect(selectedEffIndx)
    int Q = checkEffects(effectToCheck)
    ;debug.trace("iEquip_PotionScript getPotionQueue - " + potionToCheck.GetName() + " CostliestEffectIndex: " + selectedEffIndx + ", strongest magic effect: " + effectToCheck as string)
    
    ; If the strongest effect isn't a restore/fortify/regen effect then if the potion has more than one effect check if any of the other effects are
    if Q < 0
        int numEffects = potionToCheck.GetNumEffects()
        ;debug.trace("iEquip_PotionScript getPotionQueue - costliest effect isn't a health, magicka or stamina effect, checking for additional effects - numEffects: " + numEffects + ", other index: " + (!selectedEffIndx as bool) as int)
        if numEffects == 2      ; If potion has two effects then check the other for any restore/fortify/regen effect
            selectedEffIndx = (!selectedEffIndx as bool) as int
            effectToCheck = potionToCheck.GetNthEffectMagicEffect(selectedEffIndx)
            Q = checkEffects(effectToCheck)
            
        elseIf numEffects > 2   ; If potion has > 2 effects we need to check all the others first for a restore effect, and if none found recheck for a fortify/regen effect
            bool bFirstRun = true
            int strongestEffIndx = selectedEffIndx
            selectedEffIndx = 0
            
            while selectedEffIndx < numEffects
                if selectedEffIndx != strongestEffIndx
                    effectToCheck = potionToCheck.GetNthEffectMagicEffect(selectedEffIndx)
                    
                    Q = checkEffects(effectToCheck, bFirstRun)  ; Checking for restore
                    if Q != -1  ; If found exit loop
                        numEffects = -1
                    else
                        selectedEffIndx += 1
                    endIf
                else
                    selectedEffIndx += 1
                endIf
                
                ;If we haven't found a restore effect on first run, reset the while loop and run again to check for fortify or regen effects
                if bFirstRun && selectedEffIndx == numEffects
                    bFirstRun = false
                    selectedEffIndx = 0
                endIf
            endWhile
        endIf
    endIf
    ;If it doesn't have a health, magicka or stamina restore/fortify/regen effect then there's nothing to do here
    if Q < 0
        ;debug.trace("iEquip_PotionScript getPotionQueue -" + potionToCheck.GetName() + " does not appear to be a health, stamina or magicka potion")
    ;Otherwise store the strength and duration in the temp variables
    elseIf bAdding
        fTempStrength = potionToCheck.GetNthEffectMagnitude(selectedEffIndx)
        iTempDuration = potionToCheck.GetNthEffectDuration(selectedEffIndx)
    endIf
    
    ;debug.trace("iEquip_PotionScript getPotionQueue - returning: Q = " + Q)
    return Q
endFunction

int function checkEffects(magicEffect effectToCheck, bool restoreOnly = false)
    int Q = aStrongestEffects.find(effectToCheck)       ; Returns -1 if not found
    ; If it's not a regular effect check for a consummate effect
    if Q < 0
        Q = aConsummateEffects.find(effectToCheck)      ; Puts ultimate/consummate potions into the Restore queues (0,3,6)
        if Q != -1
            Q = Q * 3
        endIf
    endIf
    ; If we've not found a vanilla effect check if CACO is loaded and if so check for a CACO restore effect
    if Q < 0 && bIsCACOLoaded
        Q = aCACO_RestoreEffects.find(effectToCheck)    ; Returns -1 if not found
        ;debug.trace("iEquip_PotionScript checkEffects - checking for a CACO restore effect, Q = " + Q)
        if Q != -1
            if Q < 3                                    ; AlchRestoreHealth_1sec, AlchRestoreHealth_5sec, AlchRestoreHealth_10sec
                Q = 0                                   ; Health Restore
            elseIf Q < 6                                ; AlchRestoreMagicka_1sec, AlchRestoreMagicka_5sec, AlchRestoreMagicka_10sec
                Q = 3                                   ; Magicka Restore
            elseIf Q < 9                                ; AlchRestoreStamina_1sec, AlchRestoreStamina_5sec, AlchRestoreStamina_10sec
                Q = 6                                   ; Stamina Restore
            endIf
        endIf
        ;debug.trace("iEquip_PotionScript checkEffects - CACO restore effect, final Q value = " + Q)
    endIf
    ; Check if PotionAnimatedFix is loaded and check for one of its DUPLICATE restore effects
    if Q < 0 && bIsPAFLoaded
        Q = aPAF_RestoreEffects.find(effectToCheck)
        ;debug.trace("iEquip_PotionScript checkEffects - checking for a PAF restore effect, Q = " + Q)
        if Q != -1
            if Q < 2                                    ; AlchRestoreHealthDUPLICATE001 or AlchRestoreHealthAllDUPLICATE001
                Q = 0                                   ; Health Restore
            elseIf Q < 4                                ; AlchRestoreMagickaDUPLICATE001 or AlchRestoreMagickaAllDUPLICATE001
                Q = 3                                   ; Magicka Restore
            else                                        ; AlchRestoreStaminaDUPLICATE001 or AlchRestoreStaminaAllDUPLICATE001
                Q = 6                                   ; Stamina Restore
            endIf
        endIf
        ;debug.trace("iEquip_PotionScript checkEffects - PAF restore effect, final Q value = " + Q)
    endIf
    ; Finally if there's still no match check if we're playing Enderal
    if Q < 0 && bIsEnderalLoaded
        Q = aEnderal_RestoreEffects.find(effectToCheck)
        if Q != -1
            Q = Q * 3
        endIf
    endIf

    if restoreOnly && !(Q == 0 || Q == 3 || Q == 6)
        Q = -1
    endIf

    return Q
endFunction

function checkAndAddToPotionQueue(potion foundPotion, bool bOnLoad = false)
    ;debug.trace("iEquip_PotionScript checkAndAddToPotionQueue start")
    ;Check if the nth potion is a poison or a food and switch functions if required
    bAddedToQueue = false
    if foundPotion.isPoison()
        if bautoAddPoisons && !iEquip_GeneralBlacklistFLST.HasForm(foundPotion as form) && (bIsFirstRun || !bOnLoad)
            checkAndAddToPoisonQueue(foundPotion)
        endIf

    elseIf foundPotion.isFood()
        if bautoAddConsumables && !iEquip_GeneralBlacklistFLST.HasForm(foundPotion as form) && (bIsFirstRun || !bOnLoad)
            checkAndAddToConsumableQueue(foundPotion)
        endIf

    else
        ;debug.trace("iEquip_PotionScript checkAndAddToPotionQueue - foundPotion: " + foundPotion.GetName())
        int Q = getPotionQueue(foundPotion, true)

        ; Exclude Skooma from groups if CACO or Requiem loaded to avoid unintended negative effects including possibility of death (Requiem)!  Will still be added directly to the consumables queue if enabled.
        if (bIsCACOLoaded && foundPotion.HasKeyword(VendorItemIllicitDrug)) || (bIsRequiemLoaded && foundPotion.HasKeyword(REQ_KW_VendorItem_BlackMarket))
            Q = -1
        endIf

        int group ; Q < 3 defaults to 0
        if Q > 2
            if Q < 6
                group = 1
            else
                group = 2
            endIf
        endIf
        
        string potionGroup = asPotionGroups[group]
        ;Check it isn't already in the chosen queue and add it if not. This needs to be done regardless of whether potion groups are enabled or not, so they remain populated in case the user later wishes to enable them
        form potionForm = foundPotion as form
        bool bIsRestoreAllPotion        
        if Q > -1 && findInQueue(aiPotionQ[Q], potionForm) == -1
            bool isRestore = (Q == 0 || Q == 3 || Q == 6)
            string potionName = foundPotion.GetName()
            int itemID = CalcCRC32Hash(potionName, Math.LogicalAND(potionForm.GetFormID(), 0x00FFFFFF))
            int potionObj = jMap.object()
            ;Calculate the various strengths for comparison during selection
            float effectStrength
            float effectStrength3s
            float effectStrengthTotal
            int effectDuration
            if fTempStrength > 0
                effectStrength = fTempStrength
                effectDuration = iTempDuration
                fTempStrength = 0.0 ;reset
                iTempDuration = 0
            else
                int i = foundPotion.GetCostliestEffectIndex()
                effectStrength = foundPotion.GetNthEffectMagnitude(i)
                effectDuration = foundPotion.GetNthEffectDuration(i)
            endIf
            if isRestore && effectDuration > 1
                effectStrengthTotal = effectStrength * effectDuration
                effectStrength3s = effectStrength * 3
            else
                effectStrengthTotal = effectStrength
                effectStrength3s = effectStrength
            endIf
            if effectStrengthTotal > 9000
                bIsRestoreAllPotion = true
            endIf
            ;Create the potion object and add it to the queue
            jMap.setForm(potionObj, "iEquipForm", potionForm)
            jMap.setStr(potionObj, "iEquipName", potionName)
            jMap.setStr(potionObj, "iEquipIcon", getPotionIcon(foundPotion))
            jMap.setFlt(potionObj, "iEquipStrength", effectStrength)
            jMap.setFlt(potionObj, "iEquipStrength3s", effectStrength3s)
            jMap.setFlt(potionObj, "iEquipStrengthTotal", effectStrengthTotal)
            jMap.setInt(potionObj, "iEquipDuration", effectDuration)
            jMap.setInt(potionObj, "iEquipItemID", itemID)
            jArray.addObj(aiPotionQ[Q], potionObj)
            ;Add the potion to the formlist and update the event filter
            iEquip_PotionItemsFLST.AddForm(potionForm)
        	EH.updateEventFilter(iEquip_PotionItemsFLST)
            ;Add it to moreHUDIE of loaded
            if bMoreHUDLoaded
                AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
            endIf
            ;debug.trace("iEquip_PotionScript checkAndAddToPotionQueue -" + potionName + " added to the " + aStrongestEffects[Q].GetName() + " queue")
            bAddedToQueue = true
            iQueueToSort = Q
            WC.abPotionGroupEmpty[group] = false
        endIf
        ;If it isn't a grouped potion, or if potion grouping is disabled then if bautoAddPotions is enabled add it directly to the consumable queue
        if bautoAddPotions && (Q == -1 || !WC.bPotionGrouping || !WC.abPotionGroupEnabled[group] || (bIsRestoreAllPotion && bExcludeRestoreAllEffects)) && !iEquip_GeneralBlacklistFLST.HasForm(foundPotion as form) && (bIsFirstRun || !bOnLoad)
	        checkAndAddToConsumableQueue(foundPotion, true)
        elseIf WC.asCurrentlyEquipped[3] == potionGroup
            WC.setSlotCount(3, getPotionGroupCount(group))
            if WC.bConsumableIconFaded
                WC.checkAndFadeConsumableIcon(false)
            endIf
        endIf

    endIf
    ;debug.trace("iEquip_PotionScript checkAndAddToPotionQueue end")
endFunction

function checkAndAddToPoisonQueue(potion foundPoison)
    string poisonName = foundPoison.GetName()
    ;debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue start - foundPoison: " + poisonName)
    form poisonForm = foundPoison as form
    if findInQueue(iPoisonQ, poisonForm) != -1
        ;debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue -" + poisonName + " is already in the poison queue")
        if WC.asCurrentlyEquipped[4] == poisonName
            WC.setSlotCount(4, PlayerRef.GetItemCount(poisonForm))
        endIf
    ;elseIf !(jArray.count(iPoisonQ) == WC.iMaxQueueLength && WC.bHardLimitQueueSize)
    else
        int poisonFormID = poisonForm.GetFormID()
        int itemID = CalcCRC32Hash(poisonName, Math.LogicalAND(poisonFormID, 0x00FFFFFF))
        int poisonObj = jMap.object()
        jMap.setForm(poisonObj, "iEquipForm", poisonForm)
        jMap.setInt(poisonObj, "iEquipFormID", poisonFormID)
        jMap.setInt(poisonObj, "iEquipItemID", itemID)
        jMap.setStr(poisonObj, "iEquipName", poisonName)
        jMap.setStr(poisonObj, "iEquipIcon", getPoisonIcon(foundPoison))
        jArray.addObj(iPoisonQ, poisonObj)
        iEquip_AllCurrentItemsFLST.AddForm(poisonForm)
        EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
        if bMoreHUDLoaded
            AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
        endIf
        ;If the poison queue was previously empty update the widget to show what we've just added
        if jArray.count(iPoisonQ) == 1
            if WC.iBackgroundStyle > 0
                int[] args = new int[2]
                args[0] = 4
                args[1] = WC.iBackgroundStyle
                UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)   ; Reshow the background if it was previously hidden
            endIf
            WC.aiCurrentQueuePosition[4] = 0
            WC.asCurrentlyEquipped[4] = poisonName
            if WC.bPoisonIconFaded
                WC.checkAndFadePoisonIcon(false)
                Utility.WaitMenuMode(0.3)
            endIf
            WC.updateWidget(4, 0, false, true)
            WC.setSlotCount(4, PlayerRef.GetItemCount(poisonForm))
        endIf
        ;debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue - Form: " + poisonForm + ", " + poisonName + " added to the poison queue")
        bAddedToQueue = true
        iQueueToSort = iPoisonQ
    endIf
    ;debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue end")
endFunction

function checkAndAddToConsumableQueue(potion foundConsumable, bool isPotion = false)
    string consumableName = foundConsumable.GetName()
    ;debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue start - foundConsumable: " + consumableName)
    form consumableForm = foundConsumable as form
    if findInQueue(iConsumableQ, consumableForm) != -1
        ;debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue -" + consumableName + " is already in the consumable queue")
        if WC.asCurrentlyEquipped[3] == consumableName
            WC.setSlotCount(3, PlayerRef.GetItemCount(consumableForm))
        endIf
    ;elseIf !(jArray.count(iConsumableQ) == WC.iMaxQueueLength && WC.bHardLimitQueueSize)
    else
        int consumableFormID = consumableForm.GetFormID()
        int itemID = CalcCRC32Hash(consumableName, Math.LogicalAND(consumableFormID, 0x00FFFFFF))
        int consumableObj = jMap.object()
        jMap.setForm(consumableObj, "iEquipForm", consumableForm)
        jMap.setInt(consumableObj, "iEquipFormID", consumableFormID)
        jMap.setInt(consumableObj, "iEquipItemID", itemID)
        jMap.setStr(consumableObj, "iEquipName", consumableName)
        if isPotion
        	jMap.setStr(consumableObj, "iEquipIcon", getPotionIcon(foundConsumable))
        else
        	jMap.setStr(consumableObj, "iEquipIcon", getConsumableIcon(foundConsumable))
        endIf
        jArray.addObj(iConsumableQ, consumableObj)
        iEquip_AllCurrentItemsFLST.AddForm(consumableForm)
        EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
        if bMoreHUDLoaded
            AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
        endIf
        int count = jArray.count(iConsumableQ)
        int enabledPotionGroups
        int groupHasPotions
        if WC.bPotionGrouping
            int i = 0
            while i < 3
                if WC.abPotionGroupEnabled[i]
                    enabledPotionGroups += 1
                    if !WC.abPotionGroupEmpty[i]
                        groupHasPotions += 1
                    endIf
                endIf
                i += 1
            endWhile
        endIf    
        if count == 1 || ((count - enabledPotionGroups == 1) && groupHasPotions == 0)
            if WC.iBackgroundStyle > 0
                int[] args = new int[2]
                args[0] = 3
                args[1] = WC.iBackgroundStyle
                UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)   ; Reshow the background if it was previously hidden
            endIf
            WC.aiCurrentQueuePosition[3] = count - 1
            WC.asCurrentlyEquipped[3] = consumableName
            if WC.bConsumableIconFaded
                WC.checkAndFadeConsumableIcon(false)
                Utility.WaitMenuMode(0.3)
            endIf
            WC.updateWidget(3, count - 1, false, true)
            WC.setSlotCount(3, PlayerRef.GetItemCount(consumableForm))
        endIf
        ;debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue - Form: " + consumableForm + ", " + consumableName + " added to the consumable queue")
    endIf
    ;debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue end")
endFunction

int function findInQueue(int Q, form formToFind)
    ;debug.trace("iEquip_PotionScript findInQueue start - Q: " + Q + ", formToFind: " + formToFind)
    int i = 0
    int foundAt = -1
    while i < jArray.count(Q) && foundAt == -1
        if formToFind == jMap.getForm(jArray.getObj(Q, i), "iEquipForm")
            foundAt = i            
        endIf
        i += 1
    endwhile
    ;debug.trace("iEquip_PotionScript findInQueue - returning " + foundAt)
    return foundAt
endFunction

string function getPoisonIcon(potion foundPoison)
    ;debug.trace("iEquip_PotionScript getPoisonIcon start")
    string IconName
    if iEquip_FormExt.isWax(foundPoison as form)
        IconName = "PoisonWax"
    elseIf iEquip_FormExt.isOil(foundPoison as form)
        IconName = "PoisonOil"
    else
        MagicEffect strongestEffect = foundPoison.GetNthEffectMagicEffect(foundPoison.GetCostliestEffectIndex())
        int i = aPoisonEffects.Find(strongestEffect)
        if i == -1
            IconName = "Poison"
        else
            IconName = asPoisonIconNames[i]
        endIf
    endIf
    ;debug.trace("iEquip_PotionScript getPoisonIcon returning IconName as " + IconName)
    return IconName
endFunction

string function getConsumableIcon(potion foundConsumable)
    ;debug.trace("iEquip_PotionScript getConsumableIcon start")
    string IconName
    if foundConsumable.GetUseSound() == Game.GetForm(0x0010E2EA) ;NPCHumanEatSoup
        IconName = "Soup"
    elseif foundConsumable.GetUseSound() == Game.GetForm(0x000B6435) ;ITMPotionUse
        IconName = "Drink"
    else
        IconName = "Food"
    endIf
    ;debug.trace("iEquip_PotionScript getConsumableIcon end")
    return IconName
endFunction

string function getPotionIcon(potion foundPotion)
	;debug.trace("iEquip_PotionScript getPotionIcon start")
	string IconName
	string pStr = foundPotion.GetNthEffectMagicEffect(foundPotion.GetCostliestEffectIndex()).GetName()
    if(pStr == "Health" || pStr == "Restore Health" || pStr == "Health Restoration" || pStr == "Regenerate Health" || pStr == "Health Regeneration" || pStr == "Fortify Health" || pStr == "Health Fortification")
        IconName = "HealthPotion"
    elseif(pStr == "Magicka " || pStr == "Restore Magicka" || pStr == "Magicka Restoration" || pStr == "Regenerate Magicka" || pStr == "Magicka Regeneration" || pStr == "Fortify Magicka" || pStr == "Magicka Fortification")
        IconName = "MagickaPotion" 
    elseif(pStr == "Stamina " || pStr == "Restore Stamina" || pStr == "Stamina Restoration" || pStr == "Regenerate Stamina" || pStr == "Stamina Regeneration" || pStr == "Fortify Stamina" || pStr == "Stamina Fortification")
        IconName = "StaminaPotion" 
    elseif(pStr == "Resist Fire")
        IconName = "FireResistPotion" 
    elseif(pStr == "Resist Shock")
        IconName = "ShockResistPotion" 
    elseif(pStr == "Resist Frost")
        IconName = "FrostResistPotion"
    else
    	IconName = "Potion"
    endIf
	;debug.trace("iEquip_PotionScript getPotionIcon end")
	return IconName
endFunction

function sortPotionQueue(int Q, string theKey)
    ;debug.trace("iEquip_PotionScript sortPotionQueue start - Q: " + Q)
    ;This should sort strongest to weakest by the float value held in the Strength key on each object in the array
    int targetArray = aiPotionQ[Q]
    jArray.unique(targetArray)
    int n = jArray.count(targetArray)
    int i
    While (n > 1)
        i = 1
        n -= 1
        While (i <= n)
            Int j = i 
            int k = (j - 1) / 2
            While (jMap.getFlt(jArray.getObj(targetArray, j), theKey) < jMap.getFlt(jArray.getObj(targetArray, k), theKey))
                jArray.swapItems(targetArray, j, k)
                j = k
                k = (j - 1) / 2
            EndWhile
            i += 1
        EndWhile
        jArray.swapItems(targetArray, 0, n)
    EndWhile
    ;/i = 0
    n = jArray.count(targetArray)
    while i < n
        ;debug.trace("iEquip_PotionScript - sortPotionQueue, sorted " + aStrongestEffects[Q].GetName() + " array - i: " + i + ", " + jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm").GetName() + ", "+theKey+": " + jMap.getFlt(jArray.getObj(targetArray, i), theKey))
        i += 1
    endWhile/;
    iQueueToSort = -1 ;Reset
    if theKey == "iEquipStrength3s"
        bQueueSortedBy3sStrength = true
    else
        bQueueSortedBy3sStrength = false
    endIf
    ;debug.trace("iEquip_PotionScript sortPotionQueue end")
EndFunction

function sortPoisonQueue()
    ;debug.trace("iEquip_PotionScript sortPoisonQueue start")
    form currentlyShownPoison = jMap.getForm(jArray.getObj(iPoisonQ, WC.aiCurrentQueuePosition[4]), "iEquipForm")
    int queueLength = jArray.count(iPoisonQ)
    int tempPoisonQ = jArray.objectWithSize(queueLength)
    int i
    
    while i < queueLength
        jArray.setStr(tempPoisonQ, i, jMap.getStr(jArray.getObj(iPoisonQ, i), "iEquipName"))
        i += 1
    endWhile
    
    jArray.sort(tempPoisonQ)
    i = 0
    int iIndex
    while i < queueLength
        string poisonName = jArray.getStr(tempPoisonQ, i)
        iIndex = 0
        
        while poisonName != jMap.getStr(jArray.getObj(iPoisonQ, iIndex), "iEquipName")
            iIndex += 1
        endWhile
        jArray.swapItems(iPoisonQ, i, iIndex)

        i += 1
    endWhile
    
    iIndex = findInQueue(iPoisonQ, currentlyShownPoison)
    if WC.aiCurrentQueuePosition[4] == -1 || !currentlyShownPoison || iIndex == -1
        iIndex = 0
    endIf
    
    WC.setCurrentQueuePosition(4, iIndex)
    ;debug.trace("iEquip_PotionScript sortPoisonQueue end")
endFunction

function selectAndConsumePotion(int potionGroup, int potionType, bool bQuickHealing = false)
    
    string sTargetAV = asActorValues[potionGroup]
    int iTargetAV = aiActorValues[potionGroup]
    float currAVDamage = iEquip_ActorExt.GetAVDamage(PlayerRef, iTargetAV)
    int Q = (potionGroup * 3) + potionType
    bool isRestore = (Q == 0 || Q == 3 || Q == 6)
    
    ;debug.trace("iEquip_PotionScript selectAndConsumePotion start - potionGroup: " + potionGroup + ", potionType: " + potionType + ", bQuickHealing: " + bQuickHealing + ", targetAV: " + sTargetAV)
    ;debug.trace("iEquip_PotionScript selectAndConsumePotion - GetAVDamage: " + currAVDamage + ", GetActorValue: " + PlayerRef.GetActorValue(sTargetAV))
    
    if isRestore && currAVDamage == 0 && iNotificationLevel == 2
        debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PO_not_AVFull{"+sTargetAV+"}"))

    else
        ;debug.trace("iEquip_PotionScript selectAndConsumePotion - potionQ selected: " + Q + ", iPotionSelectChoice: " + iPotionSelectChoice + ", in combat: " + PlayerRef.IsInCombat())
        int count = jArray.count(aiPotionQ[Q])
        if count > 0
            int targetPotion ;Default value is 0 which is the array index for the strongest potion of the type requested. If iPotionSelectChoice is 0 (Use Strongest) this will stay at 0 unless we fail the active effects checks below
        	
        	if isRestore ;If we're looking for a restore potion we need to check the MCM setting for SmartSelect/Strongest/Weakest, otherwise default to strongest for fortify/regen
                ;ToDo - remove the next few lines of debug
                float currAV = PlayerRef.GetActorValue(sTargetAV)
                ;float currAVMax = currAV + currAVDamage
                ;;debug.trace("iEquip_PotionScript selectAndConsumePotion - current AV: " + currAV + ", current max: " + currAVMax + ", current %: " + (currAV/currAVMax) + ", threshold: " + fSmartSelectThreshold + ", in combat: " + PlayerRef.IsInCombat())
                bool bInCombat = PlayerRef.IsInCombat()
                ;bool bBelowThreshold = ((currAV/currAVMax) <= fSmartSelectThreshold)
                bool bBelowThreshold = currAV/(currAV + currAVDamage) <= fSmartSelectThreshold
                bool bEffectActive = bBlockIfRestEffectActive && isEffectAlreadyActive(Q, isRestore)
                bool bSkipEffectCheck = bInCombat && bSuspendChecksInCombat && bBelowThreshold
                ;debug.trace("iEquip_PotionScript selectAndConsumePotion - bBelowThreshold: " + bBelowThreshold + ", bEffectActive: " + bEffectActive + ", bSkipEffectCheck: " + bSkipEffectCheck)
                if bEffectActive && !bSkipEffectCheck
                    targetPotion = -1

	            elseIf iPotionSelectChoice == 2 ;Use weakest 
	                targetPotion = selectRestorePotionBy3sMag(Q, false) ;Select weakest based on magnitude over first 3 secs
	            
                elseIf iPotionSelectChoice == 1 ;SmartSelect
                    if bInCombat
                        if bBelowThreshold
                            targetPotion = selectRestorePotionBy3sMag(Q, true) ;Select fastest acting based on magnitude over first 3 secs
                        else
                            targetPotion = smartSelectRestorePotion(Q, currAVDamage) ;Select best fit to fully restore stat (or as much of it as possible)
                        endIf
                    else ;If we're not in combat select the weakest/slowest potion
                        targetPotion = selectRestorePotionBy3sMag(Q, false) ;Select weakest based on magnitude over first 3 secs
                    endIf
	            endIf

                if bEffectActive && bSkipEffectCheck ;Finally if we're skipping the active effect check we need to make sure to only consume another OT potion if the selected potion effect is stronger than the currently active effect
                    int targetObject = jArray.getObj(aiPotionQ[Q], targetPotion)
                    ;debug.trace("iEquip_PotionScript selectAndConsumePotion - current effect magnitude: " + fActiveEffectMagnitude + ", new duration: " + jMap.getInt(targetObject, "iEquipDuration") + ", new strength: " + jMap.getFlt(targetObject, "iEquipStrength"))
                    if jMap.getInt(targetObject, "iEquipDuration") > 1 && jMap.getFlt(targetObject, "iEquipStrength") <= fActiveEffectMagnitude
                        targetPotion = -1
                        if bQuickHealing
                            PM.bQuickHealActionTaken = true
                        endIf
                    endIf
                endIf
            
            elseIf bBlockIfBuffEffectActive && isEffectAlreadyActive(Q, false) ;If we're looking for a fortify/regen potion we only need to run the active effect check as we're always going to want the strongest buff, which is what targetPotion defaults to
                targetPotion = -1
	        endIf

            if targetPotion > -1
                form potionToConsume = jMap.getForm(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipForm")
                if potionToConsume
                    ;debug.trace("iEquip_PotionScript selectAndConsumePotion - selected potion in index " + targetPotion + " is " + potionToConsume + ", " + potionToConsume.GetName())
                    ; Consume the potion
                    PlayerRef.EquipItemEx(potionToConsume)
                    if iNotificationLevel > 0
                        debug.notification(potionToConsume.GetName() + " " + iEquip_StringExt.LocalizeString("$iEquip_PO_PotionConsumed"))
                    endIf
                    if isRestore
                        if bQuickHealing
                            PM.bQuickHealActionTaken = true
                        endIf
                    	int restoreCount = getRestoreCount(potionGroup)
                    	if restoreCount < 6
                    		warnOnLowRestorePotionCount(restoreCount, potionGroup)
                    	endIf
                    endIf
                endIf
            endIf
            if bQueueSortedBy3sStrength
                sortPotionQueue(Q, "iEquipStrengthTotal") ;Resort the queue by total magnitude ready for next time
                bQueueSortedBy3sStrength = false
            endIf
        elseIf iNotificationLevel > 0
            debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PO_not_noneLeft{"+sTargetAV+"}"))
        endIf
    endIf
    ;debug.trace("iEquip_PotionScript selectAndConsumePotion end")
endFunction

int function smartSelectRestorePotion(int Q, float currAVDamage)
    int targetPotion
    int queueLength = jArray.Count(aiPotionQ[Q])
    ;debug.trace("iEquip_PotionScript smartSelectRestorePotion - looking for the best fit restore potion in Q " + Q + ", current stat damage is " + currAVDamage + ", strongest potion has a magnitude of " + jMap.getFlt(jArray.getObj(aiPotionQ[Q], 0), "iEquipStrengthTotal"))
    if jMap.getFlt(jArray.getObj(aiPotionQ[Q], 0), "iEquipStrengthTotal") > currAVDamage && queueLength > 1 ;If the strongest potion in the queue has a greater strength than required to fully restore the target AV then check through the array until we find the best fit 
        int i = 1
        ;debug.trace("iEquip_PotionScript smartSelectRestorePotion - queueLength: " + queueLength + ", strongest potion magnitude is greater than currAVDamage, looking for a better fit")
        while i < queueLength
            ;debug.trace("iEquip_PotionScript smartSelectRestorePotion - magnitude of potion in index " + i + ": " + jMap.getFlt(jArray.getObj(aiPotionQ[Q], i), "iEquipStrengthTotal"))
            if jMap.getFlt(jArray.getObj(aiPotionQ[Q], i), "iEquipStrengthTotal") < currAVDamage
                if (currAVDamage - jMap.getFlt(jArray.getObj(aiPotionQ[Q], i), "iEquipStrengthTotal")) > (jMap.getFlt(jArray.getObj(aiPotionQ[Q], i - 1), "iEquipStrengthTotal") - currAVDamage)
                    targetPotion = i - 1
                else
                    targetPotion = i
                endIf
                i = queueLength
            elseIf i == queueLength - 1
                targetPotion = i
                i = queueLength
            else
                i += 1
            endIf
        endWhile
    endIf
    ;debug.trace("iEquip_PotionScript smartSelectRestorePotion - selected potion in index " + targetPotion + " is a " + jMap.getStr(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipName") + " with a strength of " + jMap.getFlt(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipStrengthTotal"))
    return targetPotion
endFunction

int function selectRestorePotionBy3sMag(int Q, bool bFastActing)
    ;debug.trace("iEquip_PotionScript selectRestorePotionBy3sMag - Q " + Q + ", bFastActing: " + bFastActing)
    sortPotionQueue(Q, "iEquipStrength3s")
    int targetPotion
    if !bFastActing
        targetPotion = jArray.count(aiPotionQ[Q]) - 1
    endIf
    ;debug.trace("iEquip_PotionScript selectRestorePotionBy3sMag - selected potion in index " + targetPotion + " is a " + jMap.getStr(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipName") + " with a 3s magnitude of " + jMap.getFlt(jArray.getObj(aiPotionQ[Q], targetPotion), "iEquipStrength3s"))
    return targetPotion
endFunction

function quickBuffFindAndConsumePotions(int potionGroup)
    ;debug.trace("iEquip_PotionScript quickBuffFindAndConsumePotions start - potionGroup: " + potionGroup + ", iQuickBuffsToApply: " + iQuickBuffsToApply)

    int Q = (potionGroup * 3) + 1 ;Fortify
    int count = jArray.count(aiPotionQ[Q])
    form potionToConsume
    bool bFortifyConsumed

    ;Fortify first if MCM conditions are met, we have at least one fortify potion for the given group, and we don't currently have the effect active
    if iQuickBuffsToApply != 2 && count > 0 && !(bBlockIfBuffEffectActive && isEffectAlreadyActive(Q, false))
        ;debug.trace("iEquip_PotionScript quickBuffFindAndConsumePotions - about to consume a fortify potion")
		potionToConsume = jMap.getForm(jArray.getObj(aiPotionQ[Q], 0), "iEquipForm")
        if potionToConsume
            ; Consume the potion
            PlayerRef.EquipItemEx(potionToConsume)
            if iNotificationLevel > 0
                debug.notification(potionToConsume.GetName() + " " + iEquip_StringExt.LocalizeString("$iEquip_PO_PotionConsumed"))
            endIf
        	bFortifyConsumed = true
        endIf
    endIf

    Q = (potionGroup * 3) + 2 ;Regen
    count = jArray.count(aiPotionQ[Q])

    ;Now do the same checks for regen remembering if iQuickBuffsToApply is set to Either to check if we've already found and consumed a fortify potion
    if !(iQuickBuffsToApply == 1 || (iQuickBuffsToApply == 0 && bFortifyConsumed)) && count > 0 && !(bBlockIfBuffEffectActive && isEffectAlreadyActive(Q, false))
        ;debug.trace("iEquip_PotionScript quickBuffFindAndConsumePotions - about to consume a regen potion")
		potionToConsume = jMap.getForm(jArray.getObj(aiPotionQ[Q], 0), "iEquipForm")
        if potionToConsume
            ; Consume the potion
            PlayerRef.EquipItemEx(potionToConsume)
            if iNotificationLevel > 0
                debug.notification(potionToConsume.GetName() + " " + iEquip_StringExt.LocalizeString("$iEquip_PO_PotionConsumed"))
            endIf
        endIf
    endIf
    
    ;debug.trace("iEquip_PotionScript quickBuffFindAndConsumePotions end")
endFunction

bool function isEffectAlreadyActive(int Q, bool bIsRestore)
	;debug.trace("iEquip_PotionScript isEffectAlreadyActive start")
    fActiveEffectMagnitude = 0.0 ;Reset
    ;Check for the main potion effect corresponding to the queue from which the potion is being selected
    fActiveEffectMagnitude = iEquip_ActorExt.GetMagicEffectMagnitude(PlayerRef, aStrongestEffects[Q])
    ;If it's a restore potion then if we haven't found one of the main restore effects we now need to check for the alternative supported effects
    if fActiveEffectMagnitude == 0.0 && bIsRestore
    	;Check for the consummate effects first
    	fActiveEffectMagnitude = iEquip_ActorExt.GetMagicEffectMagnitude(PlayerRef, aConsummateEffects[Q/3])
    	;If we've still not found one check if CACO is loaded and check against the CACO restore over time effects - three possible effects
    	if fActiveEffectMagnitude == 0.0 && bIsCACOLoaded
    		int currQ = Q
    		while currQ < (Q + 3) && fActiveEffectMagnitude == 0.0
    			fActiveEffectMagnitude = iEquip_ActorExt.GetMagicEffectMagnitude(PlayerRef, aCACO_RestoreEffects[currQ])
    			currQ += 1
    		endWhile
    	endIf
    	;Finally if still no match check if Potions Animated Fix is loaded and check against the PAF restore effects - two possible effects
    	if fActiveEffectMagnitude == 0.0 && bIsPAFLoaded
    		fActiveEffectMagnitude = iEquip_ActorExt.GetMagicEffectMagnitude(PlayerRef, aPAF_RestoreEffects[Q])
    		if fActiveEffectMagnitude == 0.0
    			fActiveEffectMagnitude = iEquip_ActorExt.GetMagicEffectMagnitude(PlayerRef, aPAF_RestoreEffects[Q+1])
    		endIf
    	endIf
    endIf

    bool bAlreadyActive = fActiveEffectMagnitude > 0.0

    if bAlreadyActive && iNotificationLevel == 2
    	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PO_not_EffectActive{"+asEffectNames[Q]+"}"))
    endIf

    ;debug.trace("iEquip_PotionScript isEffectAlreadyActive - returning: " + bAlreadyActive + ", fActiveEffectMagnitude: " + fActiveEffectMagnitude)
    return bAlreadyActive
endFunction

function warnOnLowRestorePotionCount(int restoreCount, int potionGroup)
    ;debug.trace("iEquip_PotionScript warnOnLowRestorePotionCount start")
    if bEnableRestorePotionWarnings
	    string sPotionGroup = asPotionGroups[potionGroup]
	    ;If we've just dropped into one of the early warning thresholds and the consumable widget is currently displaying the Potion Group for the restore potion we've just consumed check and flash
	    if (restoreCount == 5 || restoreCount == 2) && bFlashPotionWarning && WC.asCurrentlyEquipped[3] == sPotionGroup
	        UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", potionGroup)
	    endIf
	    ;Display the early warning notification
	    if bNotificationOnLowRestorePotions
	        string sWarning
	        if restoreCount == 0 && getPotionGroupCount(potionGroup) > 0 ;No need for a notification if the entire potion group is empty as this will be handled elsewhere
	            sWarning = iEquip_StringExt.LocalizeString("$iEquip_PO_not_allOutOfRestorePotions{" + sPotionGroup + "}")
	        elseIf restoreCount == 2
	            sWarning = iEquip_StringExt.LocalizeString("$iEquip_PO_not_nearlyOutOfRestorePotions{" + sPotionGroup + "}")
	        elseIf restoreCount == 5
	            sWarning = iEquip_StringExt.LocalizeString("$iEquip_PO_not_notManyRestorePotionsLeft{" + sPotionGroup + "}")
	        endIf
	        debug.notification(sWarning)
	    endIf
	endIf
    ;NB - the count colour will already have been set through WC.setSlotCount()
    ;debug.trace("iEquip_PotionScript warnOnLowRestorePotionCount end")
endFunction

state PROCESSING
    function onPotionRemoved(form removedPotion)
        ;Blocking in case of OnItemRemoved firing twice
    endFunction
endState