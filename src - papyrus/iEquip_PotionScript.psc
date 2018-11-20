
scriptName iEquip_PotionScript extends Quest

import _Q2C_Functions
import AhzMoreHudIE
import stringUtil
import UI

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

actor property PlayerRef auto

String HUD_MENU
String WidgetRoot

int[] potionQ
int consumableQ
int poisonQ

MagicEffect[] strongestEffects
MagicEffect Property AlchRestoreHealth Auto ;0003eb15
MagicEffect Property AlchFortifyHealth Auto ;0003eaf3
MagicEffect Property AlchFortifyHealRate Auto ;0003eb06
MagicEffect Property AlchRestoreStamina Auto ;0003eb16
MagicEffect Property AlchFortifyStamina Auto ;0003eaf9
MagicEffect Property AlchFortifyStaminaRate Auto ;0003eb08
MagicEffect Property AlchRestoreMagicka Auto ;0003eb17
MagicEffect Property AlchFortifyMagicka Auto ;0003eaf8
MagicEffect Property AlchFortifyMagickaRate Auto ;0003eb07

MagicEffect[] consummateEffects
MagicEffect Property AlchRestoreHealthAll Auto ;000ffa03
MagicEffect Property AlchRestoreStaminaAll Auto ;000ffa05
MagicEffect Property AlchRestoreMagickaAll Auto ;000ffa04

MagicEffect[] poisonEffects
MagicEffect Property AlchDamageHealth Auto ;0003eb42
MagicEffect Property AlchDamageHealthDuration Auto ;0010aa4a
MagicEffect Property AlchDamageHealthRavage Auto ;00073f26
MagicEffect Property AlchDamageMagicka Auto ;0003a2b6
MagicEffect Property AlchDamageMagickaDuration Auto ;0010de5f
MagicEffect Property AlchDamageMagickaRate Auto ;00073f2B
MagicEffect Property AlchDamageMagickaRavage Auto ;00073f27
MagicEffect Property AlchDamageSpeed Auto ;00073f25
MagicEffect Property AlchDamageStamina Auto ;0003a2b6
MagicEffect Property AlchDamageStaminaDuration Auto ;0010de5f
MagicEffect Property AlchDamageStaminaRate Auto ;00073f2B
MagicEffect Property AlchDamageStaminaRavage Auto ;00073f27
MagicEffect Property AlchInfluenceAggUp Auto ;00073f29
MagicEffect Property AlchInfluenceAggUpCombo Auto ;000ff9f8
MagicEffect Property AlchInfluenceAggUpComboCOPY0000 Auto ;0010fdd4
MagicEffect Property AlchInfluenceConfDown Auto ;00073f20
MagicEffect Property AlchParalysis Auto ;00073f30
MagicEffect Property AlchWeaknessFire Auto ;00073f2D
MagicEffect Property AlchWeaknessFrost Auto ;00073f2E
MagicEffect Property AlchWeaknessMagic Auto ;00073f51
MagicEffect Property AlchWeaknessPoison Auto ;00090042
MagicEffect Property AlchWeaknessShock Auto ;00073f2F

int Property iHealthPotionsFirstChoice = 0 Auto Hidden
int Property iHealthPotionsSecondChoice = 1 Auto Hidden
int Property iHealthPotionsThirdChoice = 2 Auto Hidden
int Property iStaminaPotionsFirstChoice = 0 Auto Hidden
int Property iStaminaPotionsSecondChoice = 1 Auto Hidden
int Property iStaminaPotionsThirdChoice = 2 Auto Hidden
int Property iMagickaPotionsFirstChoice = 0 Auto Hidden
int Property iMagickaPotionsSecondChoice = 1 Auto Hidden
int Property iMagickaPotionsThirdChoice = 2 Auto Hidden

String[] poisonIconNames

bool isCACOLoaded = false
MagicEffect[] CACO_RestoreEffects

bool moreHUDLoaded = false

bool addedToQueue = false
int queueToSort = -1 ;Only used if potion added by onPotionAdded

bool property settingsChanged = false auto hidden
bool property autoAddPoisons = true auto hidden
bool property autoAddConsumables = true auto hidden

bool _initialised = false
bool loadedByOnInit = false

event OnInit()
    debug.trace("iEquip_PotionScript OnInit called")
    GotoState("")
    _initialised = false
    HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	potionQ = new int[9]
    strongestEffects = new MagicEffect[9]
    strongestEffects[0] = AlchRestoreHealth
    strongestEffects[1] = AlchFortifyHealth
    strongestEffects[2] = AlchFortifyHealRate
    strongestEffects[3] = AlchRestoreStamina
    strongestEffects[4] = AlchFortifyStamina
    strongestEffects[5] = AlchFortifyStaminaRate
    strongestEffects[6] = AlchRestoreMagicka
    strongestEffects[7] = AlchFortifyMagicka
    strongestEffects[8] = AlchFortifyMagickaRate

    consummateEffects = new MagicEffect[3]
    consummateEffects[0] = AlchRestoreHealthAll
    consummateEffects[1] = AlchRestoreStaminaAll
    consummateEffects[2] = AlchRestoreMagickaAll

    poisonEffects = new MagicEffect[22]
    poisonEffects[0] = AlchDamageHealth
	poisonEffects[1] = AlchDamageHealthDuration
	poisonEffects[2] = AlchDamageHealthRavage
	poisonEffects[3] = AlchDamageMagicka
	poisonEffects[4] = AlchDamageMagickaDuration
	poisonEffects[5] = AlchDamageMagickaRate
	poisonEffects[6] = AlchDamageMagickaRavage
	poisonEffects[7] = AlchDamageSpeed
	poisonEffects[8] = AlchDamageStamina
	poisonEffects[9] = AlchDamageStaminaDuration
	poisonEffects[10] = AlchDamageStaminaRate
	poisonEffects[11] = AlchDamageStaminaRavage
	poisonEffects[12] = AlchInfluenceAggUp
	poisonEffects[13] = AlchInfluenceAggUpCombo
	poisonEffects[14] = AlchInfluenceAggUpComboCOPY0000
	poisonEffects[15] = AlchInfluenceConfDown
	poisonEffects[16] = AlchParalysis
	poisonEffects[17] = AlchWeaknessFire
	poisonEffects[18] = AlchWeaknessFrost
	poisonEffects[19] = AlchWeaknessMagic
	poisonEffects[20] = AlchWeaknessPoison
	poisonEffects[21] = AlchWeaknessShock

	poisonIconNames = new String[22]
    poisonIconNames[0] = "PoisonHealth"
	poisonIconNames[1] = "PoisonHealth"
	poisonIconNames[2] = "PoisonHealth"
	poisonIconNames[3] = "PoisonMagicka"
	poisonIconNames[4] = "PoisonMagicka"
	poisonIconNames[5] = "PoisonMagicka"
	poisonIconNames[6] = "PoisonMagicka"
	poisonIconNames[7] = "PoisonStamina"
	poisonIconNames[8] = "PoisonStamina"
	poisonIconNames[9] = "PoisonStamina"
	poisonIconNames[10] = "PoisonStamina"
	poisonIconNames[11] = "PoisonStamina"
	poisonIconNames[12] = "PoisonFrenzy"
	poisonIconNames[13] = "PoisonFrenzy"
	poisonIconNames[14] = "PoisonFrenzy"
	poisonIconNames[15] = "PoisonFear"
	poisonIconNames[16] = "PoisonParalysis"
	poisonIconNames[17] = "PoisonWeaknessFire"
	poisonIconNames[18] = "PoisonWeaknessFrost"
	poisonIconNames[19] = "PoisonWeaknessMagic"
	poisonIconNames[20] = "PoisonWeaknessPoison"
	poisonIconNames[21] = "PoisonWeaknessShock"

    CACO_RestoreEffects = new MagicEffect[9]
    if Game.GetModByName("Complete Alchemy & Cooking Overhaul.esp") != 255
        isCACOLoaded = true
        CACO_RestoreEffects[0] = Game.GetFormFromFile(0x001AA0B6, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreHealth_1sec
        CACO_RestoreEffects[1] = Game.GetFormFromFile(0x001AA0B7, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreHealth_5sec
        CACO_RestoreEffects[2] = Game.GetFormFromFile(0x001AA0B8, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreHealth_10sec
        CACO_RestoreEffects[3] = Game.GetFormFromFile(0x001B42BB, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreStamina_1sec
        CACO_RestoreEffects[4] = Game.GetFormFromFile(0x001B42BC, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreStamina_5sec
        CACO_RestoreEffects[5] = Game.GetFormFromFile(0x001B42BD, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreStamina_10sec
        CACO_RestoreEffects[6] = Game.GetFormFromFile(0x001B42BE, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreMagicka_1sec
        CACO_RestoreEffects[7] = Game.GetFormFromFile(0x001B42BF, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreMagicka_5sec
        CACO_RestoreEffects[8] = Game.GetFormFromFile(0x001B42C0, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect ;AlchRestoreMagicka_10sec
    endIf
    debug.trace("iEquip_PotionScript OnInit finished - isCACOLoaded: " + isCACOLoaded)
    _initialised = true
    loadedByOnInit = true
endEvent

;Called from OnPlayerLoadGame on the PlayerEventHandler script
function onGameLoaded()
    debug.trace("iEquip_PotionScript GameLoaded called")
    while !_initialised
        Utility.Wait(0.01)
    endWhile
    HUD_MENU = WC.HUD_MENU
    WidgetRoot = WC.WidgetRoot
    moreHUDLoaded = WC.moreHUDLoaded
    WC.waitingForPotionQueues = true
    
    WC.potionGroupEmpty[0] = true
    WC.potionGroupEmpty[1] = true
    WC.potionGroupEmpty[2] = true

    if !loadedByOnInit
        CACO_RestoreEffects = new MagicEffect[9]
        if Game.GetModByName("Complete Alchemy & Cooking Overhaul.esp") != 255
            isCACOLoaded = true
            CACO_RestoreEffects[0] = Game.GetFormFromFile(0x001AA0B6, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[1] = Game.GetFormFromFile(0x001AA0B7, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[2] = Game.GetFormFromFile(0x001AA0B8, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[3] = Game.GetFormFromFile(0x001B42BB, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[4] = Game.GetFormFromFile(0x001B42BC, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[5] = Game.GetFormFromFile(0x001B42BD, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[6] = Game.GetFormFromFile(0x001B42BE, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[7] = Game.GetFormFromFile(0x001B42BF, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
            CACO_RestoreEffects[8] = Game.GetFormFromFile(0x001B42C0, "Complete Alchemy & Cooking Overhaul.esp") as MagicEffect
        else
            isCACOLoaded = false
        endIf
    endIf
    debug.trace("iEquip_PotionScript GameLoaded - isCACOLoaded: " + isCACOLoaded)
    findAndSortPotions()
endFunction

function InitialisePotionQueueArrays(int consQ, int poisQ)
    debug.trace("iEquip_PotionScript InitialisePotionQArrays called")
    consumableQ = consQ
    poisonQ = poisQ
    if objHealthRestoreQ == 0
        objHealthRestoreQ = JArray.object()
        potionQ[0] = objHealthRestoreQ
    endIf
    if objHealthFortifyQ == 0
        objHealthFortifyQ = JArray.object()
        potionQ[1] = objHealthFortifyQ
    endIf
    if objHealthRegenQ == 0
        objHealthRegenQ = JArray.object()
        potionQ[2] = objHealthRegenQ
    endIf
    if objStaminaRestoreQ == 0
        objStaminaRestoreQ = JArray.object()
        potionQ[3] = objStaminaRestoreQ
    endIf
    if objStaminaFortifyQ == 0
        objStaminaFortifyQ = JArray.object()
        potionQ[4] = objStaminaFortifyQ
    endIf
    if objStaminaRegenQ == 0
        objStaminaRegenQ = JArray.object()
        potionQ[5] = objStaminaRegenQ
    endIf
    if objMagickaRestoreQ == 0
        objMagickaRestoreQ = JArray.object()
        potionQ[6] = objMagickaRestoreQ
    endIf
    if objMagickaFortifyQ == 0
        objMagickaFortifyQ = JArray.object()
        potionQ[7] = objMagickaFortifyQ
    endIf
    if objMagickaRegenQ == 0
        objMagickaRegenQ = JArray.object()
        potionQ[8] = objMagickaRegenQ
    endIf
    int i = 0
    while i < 9
    	debug.trace("iEquip_PotionScript InitialisePotionQArrays - potionQ["+i+"] contains " + potionQ[i])
    	i += 1
    endWhile
endfunction

int property objHealthRestoreQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "healthRestoreQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "healthRestoreQ", objObject)
    endFunction
endProperty

int property objHealthFortifyQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "healthFortifyQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "healthFortifyQ", objObject)
    endFunction
endProperty

int property objHealthRegenQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "healthRegenQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "healthRegenQ", objObject)
    endFunction
endProperty

int property objStaminaRestoreQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "staminaRestoreQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "staminaRestoreQ", objObject)
    endFunction
endProperty

int property objStaminaFortifyQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "staminaFortifyQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "staminaFortifyQ", objObject)
    endFunction
endProperty

int property objStaminaRegenQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "staminaRegenQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "staminaRegenQ", objObject)
    endFunction
endProperty

int property objMagickaRestoreQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "magickaRestoreQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "magickaRestoreQ", objObject)
    endFunction
endProperty

int property objMagickaFortifyQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "magickaFortifyQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "magickaFortifyQ", objObject)
    endFunction
endProperty

int property objMagickaRegenQ
    int function get()
        return JMap.getObj(WC.iEquipQHolderObj, "magickaRegenQ")
    endFunction
    function set(int objObject)
        JMap.setObj(WC.iEquipQHolderObj, "magickaRegenQ", objObject)
    endFunction
endProperty

function initialisemoreHUDArray()
	debug.trace("iEquip_PotionScript initialisemoreHUDArray called")
    int jItemIDs = jArray.object()
    int jIconNames = jArray.object()
    int Q = 0
    
    while Q < 9
        int queueLength = JArray.count(potionQ[Q])
        int i = 0
        debug.trace("iEquip_PotionScript initialisemoreHUDArray - Q" + Q + " contains " + queueLength + " potions")
        
        while i < queueLength
            form itemForm = jMap.getForm(jArray.getObj(potionQ[Q], i), "Form")
	        if !itemForm
				jArray.eraseIndex(potionQ[Q], i)
				queueLength -= 1
			endIf
            int itemID = jMap.getInt(jArray.getObj(potionQ[Q], i), "itemID")
            debug.trace("iEquip_PotionScript initialisemoreHUDArray Q: " + Q + ", i: " + i + ", itemID: " + itemID + ", " + jMap.getStr(jArray.getObj(potionQ[Q], i), "Name"))
            if itemID == 0
            	itemID = WC.createItemID(itemForm.GetName(), itemForm.GetFormID())
            	jMap.setInt(jArray.getObj(potionQ[Q], i), "itemID", itemID)
            endIf
	        if itemID != 0
	            jArray.addInt(jItemIDs, jMap.getInt(jArray.getObj(potionQ[Q], i), "itemID"))
	            jArray.addStr(jIconNames, "iEquipQ.png")
	        endIf
	        i += 1
        endWhile

        Q += 1
    endWhile
    debug.trace("iEquip_PotionScript initialisemoreHUDArray - jItemIds contains " + jArray.count(jItemIDs) + " entries")
    debug.trace("iEquip_PotionScript initialisemoreHUDArray - jIconNames contains " + jArray.count(jIconNames) + " entries")
    if jArray.count(jItemIDs) > 0
        int[] itemIDs = utility.CreateIntArray(jArray.count(jItemIDs))
        string[] iconNames = utility.CreateStringArray(jArray.count(jIconNames))
        jArray.writeToIntegerPArray(jItemIDs, itemIDs)
        jArray.writeToStringPArray(jIconNames, iconNames)
        debug.trace("iEquip_PotionScript initialisemoreHUDArray - itemIDs contains " + itemIDs.Length + " entries with " + itemIDs[0] + " in index 0")
        debug.trace("iEquip_PotionScript initialisemoreHUDArray - iconNames contains " + iconNames.Length + " entries with " + iconNames[0] + " in index 0")
        AhzMoreHudIE.AddIconItems(itemIDs, iconNames)
    endIf
endFunction

function findAndSortPotions()
    debug.trace("iEquip_PotionScript findAndSortPotions called")
    ;Count the number of potion items currently in the players inventory
    int numFound = GetNumItemsOfType(PlayerRef, 46)
    ;If any potions found
    if numFound > 0
        int i = 0
        int count
        int iIndex
        int[] openingQSizes = new int[10]
        while i < 9
            iIndex = 0
            count = jArray.count(potionQ[i])
            ;Check and remove any potions which are no longer in the players inventory (fallback as there shouldn't be any!)
            while iIndex < count
                if PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(potionQ[i], iIndex), "Form")) < 1
                    removePotionFromQueue(i, iIndex)
                endIf
                iIndex += 1
            endWhile
            ;Store the opening potion queue lengths for comparison later
            openingQSizes[i] = jArray.count(potionQ[i])
            i += 1
        endWhile
        openingQSizes[9] = jArray.count(poisonQ)
        i = 0
        potion foundPotion
        ;Add each potion to the relevant queue
        while i < numFound
            foundPotion = GetNthFormOfType(PlayerRef, 46, i) as potion
            checkAndAddToPotionQueue(foundPotion)
            i += 1
        endWhile
        ;Now check if anything has been added to each potion queue and resort each if required
        i = 0
        while i < 9
            debug.trace("iEquip_PotionScript findAndSortPotions - potionQ: " + i + ", openingQSizes: " + openingQSizes[i] + ", new count: " + jArray.count(potionQ[i]))
            if jArray.count(potionQ[i]) > openingQSizes[i]
                sortPotionQueue(i)
            endIf
            i += 1
        endWhile
        if jArray.count(poisonQ) > openingQSizes[9]
            sortPoisonQueue()
        endIf 
        ;Finally get the group counts and update the potionGroupEmpty bool array
        i = 0
        while i < 3
            numFound = getPotionGroupCount(i)
            if numFound > 0
                WC.potionGroupEmpty[i] = false
                debug.trace("iEquip_PotionScript findAndSortPotions - potionGroup: " + i + ", numFound: " + numFound + ", potionGroupEmpty[" + i + "]: " + WC.potionGroupEmpty[i])
            endIf
            i += 1
        endWhile
    else
        debug.trace("iEquip_PotionScript findAndSortPotions - No health, stamina or magicka potions found in players inventory")
    endIf
    WC.waitingForPotionQueues = false
endFunction

function onPotionAdded(form newPotion)
    debug.trace("iEquip_PotionScript onPotionAdded called - newPotion: " + newPotion.GetName())
    checkAndAddToPotionQueue(newPotion as potion)
    if addedToQueue && queueToSort != -1
    	if queueToSort == poisonQ
    		sortPoisonQueue()
    	elseIf queueToSort != consumableQ
        	sortPotionQueue(queueToSort)
        endIf
    endIf
endFunction

function onPotionRemoved(form removedPotion)
    debug.trace("iEquip_PotionScript onPotionRemoved called - removedPotion: " + removedPotion.GetName())
    GotoState("PROCESSING")
    potion thePotion = removedPotion as potion
    int targetArray
    int foundPotion
    int itemCount = PlayerRef.GetItemCount(removedPotion)
    if thePotion.isPoison()
        if itemCount < 1
            targetArray = WC.getTargetQ(4)
            foundPotion = findInQueue(targetArray, removedPotion)
            if foundPotion != -1
                if moreHUDLoaded
                    AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(targetArray, foundPotion), "itemID"))
                endIf
                jArray.eraseIndex(targetArray, foundPotion)
            endIf
        endIf
        if WC.isCurrentlyEquipped(4, removedPotion.GetName())
            if itemCount > 0
                WC.setSlotCount(4, itemCount)
            else
                WC.cycleSlot(4)
            endIf
        endIf
    elseIf thePotion.isFood()
        if itemCount < 1
            targetArray = WC.getTargetQ(3)
            foundPotion = findInQueue(targetArray, removedPotion)
            if foundPotion != -1
                if moreHUDLoaded
                    AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(targetArray, foundPotion), "itemID"))
                endIf
                jArray.eraseIndex(targetArray, foundPotion)
            endIf
        endIf
        if WC.isCurrentlyEquipped(3, removedPotion.GetName())
            if itemCount > 0
                WC.setSlotCount(3, itemCount)
            else
                WC.cycleSlot(3)
            endIf
        endIf
    else
        int Q = getPotionQueue(thePotion)
        if Q >= 0
	        int group
	        string potionGroup
	        if Q < 3
		        group = 0
		        potionGroup = "Health Potions"
		    elseIf Q < 6
		        group = 1
		        potionGroup = "Stamina Potions"
		    else
		        group = 2
		        potionGroup = "Magicka Potions"
		    endIf
		    if WC.isCurrentlyEquipped(3, potionGroup)
            	WC.setSlotCount(3, getPotionGroupCount(group))
            endIf
		endIf
        if itemCount < 1
            foundPotion = findInQueue(potionQ[Q], removedPotion)
            if foundPotion != -1
                removePotionFromQueue(Q, foundPotion)
            endIf
        endIf
    endIf
    GotoState("")
endFunction

function removePotionFromQueue(int Q, int targetPotion)
    debug.trace("iEquip_PotionScript removePotionFromQueue called - Q: " + Q + ", targetPotion: " + targetPotion)
    if moreHUDLoaded
        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(potionQ[Q], targetPotion), "itemID"))
    endIf
    ;First we need to remove the potion from the relevant queue
    jArray.eraseIndex(potionQ[Q], targetPotion)
    ;Now we need to check to see if any potions remain in the three potion queues within the potion group we've just removed from
    string potionGroup
    if Q < 3
        Q = 0
        potionGroup = "Health Potions"
    elseIf Q < 6
        Q = 1
        potionGroup = "Stamina Potions"
    else
        Q = 2
        potionGroup = "Magicka Potions"
    endIf
    ;If all three arrays in the group are empty then we need to update the widget accordingly
    if getPotionGroupCount(Q) < 1
        ;Flag the group as empty in WidgetCore for cycling
        WC.potionGroupEmpty[Q] = true
        ;Check if it's the currently shown item in the consumable slot
        if WC.isCurrentlyEquipped(3, potionGroup)
            debug.trace("iEquip_PotionScript removePotionFromQueue - potion group is currently shown")
            ;Check and flash empty warning if enabled
            if MCM.bFlashPotionWarning
                debug.trace("iEquip_PotionScript removePotionFromQueue - should be flashing empty warning now - Q: " + Q)
                UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", Q)
                Utility.Wait(1.4)
            endIf
            ;Finally check if we're fading icon or cycling to next slot
            if MCM.emptyPotionQueueChoice == 0 ;Fade icon
                debug.trace("iEquip_PotionScript removePotionFromQueue - should be fading now")
                WC.checkAndFadeConsumableIcon(true)
            else
                debug.trace("iEquip_PotionScript removePotionFromQueue - should be cycling forward now")
                WC.cycleSlot(3)
            endIf
        endIf
    endIf
endFunction

int function getPotionGroupCount(int potionGroup)
    debug.trace("iEquip_PotionScript getPotionGroupCount called - potionGroup: " + potionGroup)
    int count
    int Q = potionGroup * 3
    int maxQ = Q + 3
    int i = 0
    int queueLength
    int targetArray
    int currentCount
    while Q < maxQ
        targetArray = potionQ[Q]
        queueLength = jArray.count(targetArray)
        debug.trace("iEquip_PotionScript getPotionGroupCount - currently checking Q: " + Q + ", queueLength: " + queueLength)
        while i < queueLength
            currentCount = count
            count += PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(targetArray, i), "Form"))
            debug.trace("iEquip_PotionScript getPotionGroupCount - " + (count - currentCount) + " potions found in index " + i + " in potion queue " + Q)
            i += 1
        endWhile
        i = 0
        Q += 1
    endWhile
    debug.trace("iEquip_PotionScript getPotionGroupCount returning count: " + count)
    return count
endFunction

int function getPotionQueue(potion potionToCheck)
    debug.trace("iEquip_PotionScript getPotionQueue called")
    int index = potionToCheck.GetCostliestEffectIndex()
    magicEffect strongestEffect = potionToCheck.GetNthEffectMagicEffect(index)
    debug.trace("iEquip_PotionScript getPotionQueue -" + potionToCheck.GetName() + " CostliestEffectIndex: " + index + ", strongest magic effect: " + strongestEffect as string)
    ;Decide which potion queue it should be added to
    int Q = strongestEffects.find(strongestEffect) ;Returns -1 if not found
    ;If it's not a regular effect check for a consummate effect
    if Q < 0
    	Q = consummateEffects.find(strongestEffect) * 3 ;Puts consummate potions into the Restore queues (0,3,6)
    endIf
    ;If we've not found a vanilla effect check if CACO is loaded and if so check for a CACO restore effect
    if Q < 0 && isCACOLoaded
        Q = CACO_RestoreEffects.find(strongestEffect) ;Returns -1 if not found
        if Q != -1
            if Q < 3
                Q = 0
            elseIf Q < 6
                Q = 3
            elseIf Q < 9
                Q = 6
            endIf
        endIf
    endIf
    ;If it's not a health, stamina or magicka potion then there's nothing to do here
    if Q < 0
        debug.trace("iEquip_PotionScript getPotionQueue -" + potionToCheck.GetName() + " does not appear to be a health, stamina or magicka potion")
    endIf
    debug.trace("iEquip_PotionScript getPotionQueue - returning: Q = " + Q)
    return Q
endFunction

function checkAndAddToPotionQueue(potion foundPotion)
    ;Check if the nth potion is a poison or a food and switch functions if required
    addedToQueue = false
    if foundPotion.isPoison()
        if autoAddPoisons
            checkAndAddToPoisonQueue(foundPotion)
        endIf
    elseIf foundPotion.isFood()
        if autoAddConsumables
            checkAndAddToConsumableQueue(foundPotion)
        endIf
    else
        debug.trace("iEquip_PotionScript checkAndAddToPotionQueue called - foundPotion: " + foundPotion.GetName())
        int Q = getPotionQueue(foundPotion)
        int group
        string potionGroup
        if Q < 3
	        group = 0
	        potionGroup = "Health Potions"
	    elseIf Q < 6
	        group = 1
	        potionGroup = "Stamina Potions"
	    else
	        group = 2
	        potionGroup = "Magicka Potions"
	    endIf
        if Q != -1
            form potionForm = foundPotion as form
            ;Check it isn't already in the chosen queue and add it if not
            if findInQueue(potionQ[Q], potionForm) != -1
                debug.trace("iEquip_PotionScript checkAndAddToPotionQueue -" + foundPotion.GetName() + " is already in the " + strongestEffects[Q].GetName() + " queue")
            else
                int index = foundPotion.GetCostliestEffectIndex()
                float effectMagnitude
                if stringutil.Find(foundPotion.GetName(), "consummate", 0) > -1
                	effectMagnitude = 9999.0 ;Ensures consummate potions are always the strongest in the Restore queues
                else
                	effectMagnitude = foundPotion.GetNthEffectMagnitude(index)
                endIf
                string potionName = foundPotion.GetName()
                int itemID = WC.createItemID(potionName, potionForm.GetFormID())
                int potionObj = jMap.object()
                jMap.setForm(potionObj, "Form", potionForm)
                jMap.setStr(potionObj, "Name", potionName)
                jMap.setFlt(potionObj, "Strength", effectMagnitude)
                jMap.setInt(potionObj, "itemID", itemID)
                jArray.addObj(potionQ[Q], potionObj)
                if moreHUDLoaded
                    AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
                endIf
                debug.trace("iEquip_PotionScript checkAndAddToPotionQueue -" + foundPotion.GetName() + " added to the " + strongestEffects[Q].GetName() + " queue")
                addedToQueue = true
                queueToSort = Q
                WC.potionGroupEmpty[group] = false
            endIf
            if WC.isCurrentlyEquipped(3, potionGroup)
            	WC.setSlotCount(3, getPotionGroupCount(group))
            	if WC.consumableIconFaded
            		WC.checkAndFadeConsumableIcon(false)
            	endIf
            endIf
        endIf
    endIf
endFunction

function checkAndAddToPoisonQueue(potion foundPoison)
    string poisonName = foundPoison.GetName()
    debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue called - foundPoison: " + poisonName)
    form poisonForm = foundPoison as form
    if findInQueue(poisonQ, poisonForm) != -1
        debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue -" + poisonName + " is already in the poison queue")
        if WC.isCurrentlyEquipped(4, poisonName)
	    	WC.setSlotCount(4, PlayerRef.GetItemCount(poisonForm))
        endIf
    elseIf !(jArray.count(poisonQ) == MCM.maxQueueLength && MCM.bHardLimitQueueSize)
    	int poisonFormID = poisonForm.GetFormID()
        int itemID = WC.createItemID(poisonName, poisonFormID)
	    int poisonObj = jMap.object()
	    jMap.setForm(poisonObj, "Form", poisonForm)
	    jMap.setInt(poisonObj, "formID", poisonFormID)
	    jMap.setInt(poisonObj, "itemID", itemID)
	    jMap.setStr(poisonObj, "Name", poisonName)
		jMap.setStr(poisonObj, "Icon", getPoisonIcon(foundPoison))
	    jArray.addObj(poisonQ, poisonObj)
        if moreHUDLoaded
            AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
        endIf
	    debug.trace("iEquip_PotionScript checkAndAddToPoisonQueue - Form: " + poisonForm + ", " + poisonName + " added to the poison queue")
	    addedToQueue = true
        queueToSort = poisonQ
	endIf
endFunction

function checkAndAddToConsumableQueue(potion foundConsumable)
    string consumableName = foundConsumable.GetName()
    debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue called - foundConsumable: " + consumableName)
    form consumableForm = foundConsumable as form
    if findInQueue(consumableQ, consumableForm) != -1
        debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue -" + consumableName + " is already in the consumable queue")
        if WC.isCurrentlyEquipped(3, consumableName)
	    	WC.setSlotCount(3, PlayerRef.GetItemCount(consumableForm))
        endIf
    elseIf !(jArray.count(consumableQ) == MCM.maxQueueLength && MCM.bHardLimitQueueSize)
    	int consumableFormID = consumableForm.GetFormID()
        int itemID = WC.createItemID(consumableName, consumableFormID)
	    int consumableObj = jMap.object()
	    jMap.setForm(consumableObj, "Form", consumableForm)
	    jMap.setInt(consumableObj, "formID", consumableFormID)
	    jMap.setInt(consumableObj, "itemID", itemID)
	    jMap.setStr(consumableObj, "Name", consumableName)
		jMap.setStr(consumableObj, "Icon", getConsumableIcon(foundConsumable))
	    jArray.addObj(consumableQ, consumableObj)
        if moreHUDLoaded
            AhzMoreHudIE.AddIconItem(itemID, "iEquipQ.png")
        endIf
	    debug.trace("iEquip_PotionScript checkAndAddToConsumableQueue - Form: " + consumableForm + ", " + consumableName + " added to the consumable queue")
	endIf
endFunction

int function findInQueue(int Q, form formToFind)
    debug.trace("iEquip_PotionScript findInQueue called - Q: " + Q + ", formToFind: " + formToFind)
    int i = 0
    int foundAt = -1
    while i < jArray.count(Q) && foundAt == -1
        if formToFind == jMap.getForm(jArray.getObj(Q, i), "Form")
            foundAt = i            
        endIf
        i += 1
    endwhile
    debug.trace("iEquip_PotionScript findInQueue - returning " + foundAt)
    return foundAt
endFunction

string function getPoisonIcon(potion foundPoison)
    string IconName
    if stringutil.Find(foundPoison.GetName(), "wax", 0) > -1
        IconName = "PoisonWax"
    elseIf stringutil.Find(foundPoison.GetName(), "oil", 0) > -1
        IconName = "PoisonOil"
    else
        MagicEffect strongestEffect = foundPoison.GetNthEffectMagicEffect(foundPoison.GetCostliestEffectIndex())
        int i = poisonEffects.Find(strongestEffect)
        if i == -1
        	IconName = "Poison"
        else
        	IconName = poisonIconNames[i]
        endIf
    endIf
    debug.trace("iEquip_PotionScript getPoisonIcon returning IconName as " + IconName)
    return IconName
endFunction

string function getConsumableIcon(potion foundConsumable)
	string IconName
	if foundConsumable.GetUseSound() == Game.GetForm(0x0010E2EA) ;NPCHumanEatSoup
    	IconName = "Soup"
    elseif foundConsumable.GetUseSound() == Game.GetForm(0x000B6435) ;ITMPotionUse
    	IconName = "Drink"
    else
    	IconName = "Food"
    endIf
    return IconName
endFunction

function sortPotionQueue(int Q)
    debug.trace("iEquip_PotionScript sortPotionQueue called - Q: " + Q)
    ;This should sort strongest to weakest by the float value held in the Strength key on each object in the array
    int targetArray = potionQ[Q]
    int n = jArray.count(targetArray)
    int i
    string theKey = "Strength"
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
    i = 0
    n = jArray.count(targetArray)
    while i < n
        debug.trace("iEquip_PotionScript - sortPotionQueue, sorted " + strongestEffects[Q].GetName() + " array - i: " + i + ", " + jMap.getForm(jArray.getObj(targetArray, i), "Form").GetName() + ", Strength: " + jMap.getFlt(jArray.getObj(targetArray, i), "Strength"))
        i += 1
    endWhile
    queueToSort = -1 ;Reset
EndFunction

function sortPoisonQueue()
    debug.trace("iEquip_PotionScript sortPoisonQueue called")
    form currentlyShownPoison = jMap.getForm(jArray.getObj(poisonQ, WC.getCurrentQueuePosition(4)), "Form")
    int queueLength = jArray.count(poisonQ)
    int tempPoisonQ = jArray.objectWithSize(queueLength)
    int i = 0
    
    while i < queueLength
        jArray.setStr(tempPoisonQ, i, jMap.getStr(jArray.getObj(poisonQ, i), "Name"))
        i += 1
    endWhile
    
    jArray.sort(tempPoisonQ)
    i = 0
    int iIndex
    while i < queueLength
        string poisonName = jArray.getStr(tempPoisonQ, i)
        iIndex = 0
        
        while poisonName != jMap.getStr(jArray.getObj(poisonQ, iIndex), "Name")
            iIndex += 1
        endWhile
        jArray.swapItems(poisonQ, i, iIndex)

        i += 1
    endWhile
    
    i = 0
    while i < queueLength
        debug.trace("iEquip_PotionScript sortPoisonQueue - poison queue sorted, poison in index " + i + ": " + jMap.getStr(jArray.getObj(poisonQ, i), "Name"))
        i += 1
    endWhile
    
    iIndex = findInQueue(poisonQ, currentlyShownPoison)
    if WC.getCurrentQueuePosition(4) == -1 || !currentlyShownPoison || iIndex == -1
        iIndex = 0
    endIf
    
    WC.setCurrentQueuePosition(4, iIndex)
endFunction

function selectAndConsumePotion(int potionGroup)
    debug.trace("iEquip_PotionScript selectAndConsumePotion called - potionGroup: " + potionGroup)
    form potionToConsume
    int targetPotion = 0
    bool useStrongest
    int Q = -1
    if potionGroup == 0
        Q = 0 + iHealthPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 0 + iHealthPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 0 + iHealthPotionsThirdChoice
                if jArray.count(potionQ[Q]) < 1
                    debug.notification("You do not appear to have any health potions left")
                    Q = -1
                endIf
            endIf
        endIf
        useStrongest = MCM.bUseStrongestHealthPotion
    elseIf potionGroup == 1
        Q = 3 + iStaminaPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 3 + iStaminaPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 3 + iStaminaPotionsThirdChoice
                if jArray.count(potionQ[Q]) < 1
                    debug.notification("You do not appear to have any stamina potions left")
                    Q = -1
                endIf
            endIf
        endIf
        useStrongest = MCM.bUseStrongestStaminaPotion
    elseIf potionGroup == 2
        Q = 6 + iMagickaPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 6 + iMagickaPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 6 + iMagickaPotionsThirdChoice
                if jArray.count(potionQ[Q]) < 1
                    debug.notification("You do not appear to have any magicka potions left")
                    Q = -1
                endIf
            endIf
        endIf
        useStrongest = MCM.bUseStrongestMagickaPotion
    endIf
    if Q == -1
        return
    endIf
    ;If MCM setting for given potion type is Use Weakest First then set the target to the last potion in the queue
    if !useStrongest
        targetPotion = jArray.count(potionQ[Q]) - 1
    endIf
    potionToConsume = jMap.getForm(jArray.getObj(potionQ[Q], targetPotion), "Form")
    if potionToConsume != None
        ;Consume the potion
        PlayerRef.EquipItemEx(potionToConsume)
        debug.notification(potionToConsume.GetName() + " consumed")
    endIf
endFunction

bool function quickHealFindAndConsumePotion()
    debug.trace("iEquip_PotionScript quickHealFindAndConsumePotion called")
    ;Check we've actually still got entries in the first and second choice health potion queues
    int Q = 0 + iHealthPotionsFirstChoice
    int count = jArray.count(potionQ[Q])
    bool found = false 
    if count < 1 && MCM.bQuickHealUseSecondChoice
        Q = 0 + iHealthPotionsSecondChoice
        count = jArray.count(potionQ[Q])
    endIf
    if count > 0
        found = true
        form potionToConsume = jMap.getForm(jArray.getObj(potionQ[Q], 0), "Form")
        PlayerRef.EquipItemEx(potionToConsume)
        debug.notification(potionToConsume.GetName() + " consumed")
    endIf
    return found
endFunction

state PROCESSING
    function onPotionRemoved(form removedPotion)
        ;Blocking in case of OnItemRemoved firing twice
    endFunction
endState