
scriptName iEquip_PotionScript extends Quest

import _Q2C_Functions
import stringUtil
import iEquip_Utility
import UI

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

actor property PlayerRef auto

String HUD_MENU
String WidgetRoot

int[] potionQ
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

bool isCACOLoaded = false
MagicEffect[] CACO_RestoreEffects

bool addedToQueue = false
int queueToSort = -1 ;Only used if potion added by onPotionAdded

event OnInit()
    debug.trace("iEquip_PotionScript OnInit called")
    GotoState("")
    HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot
	potionQ = new int[9]
    InitialisePotionQueueArrays()
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
endEvent

;Called from OnPlayerLoadGame on the PlayerEventHandler script
function onGameLoaded()
    debug.trace("iEquip_PotionScript GameLoaded called")
    HUD_MENU = WC.HUD_MENU
    WidgetRoot = WC.WidgetRoot
    
    WC.potionGroupEmpty[0] = true
    WC.potionGroupEmpty[1] = true
    WC.potionGroupEmpty[2] = true

    consummateEffects = new MagicEffect[3]
    consummateEffects[0] = AlchRestoreHealthAll
    consummateEffects[1] = AlchRestoreStaminaAll
    consummateEffects[2] = AlchRestoreMagickaAll

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
    debug.trace("iEquip_PotionScript GameLoaded - isCACOLoaded: " + isCACOLoaded)
    findAndSortPotions()
endFunction

function InitialisePotionQueueArrays()
    debug.trace("iEquip_PotionScript InitialisePotionQArrays called")
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

function findAndSortPotions()
    debug.trace("iEquip_PotionScript findAndSortPotions called")
    ;Count the number of potion items currently in the players inventory
    int numFound = GetNumItemsOfType(PlayerRef, 46)
    ;If any potions found
    if numFound > 0
        int i = 0
        int count
        int iIndex
        int[] openingQSizes = new int[9]
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
            if jArray.count(potionQ[i]) > openingQSizes[i]
                sortPotionQueue(i)
            endIf
            i += 1
        endWhile
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
endFunction

function onPotionAdded(form newPotion)
    debug.trace("iEquip_PotionScript onPotionAdded called - newPotion: " + newPotion.GetName())
    checkAndAddToPotionQueue(newPotion as potion)
    if addedToQueue && queueToSort != -1
        sortPotionQueue(queueToSort)
    endIf
endFunction

function onPotionRemoved(form removedPotion)
    debug.trace("iEquip_PotionScript onPotionRemoved called - removedPotion: " + removedPotion.GetName())
    GotoState("PROCESSING")
    potion thePotion = removedPotion as potion
    if !(thePotion.isPoison() || thePotion.isFood())
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
		    if PlayerRef.GetItemCount(removedPotion) < 1
		        int foundPotion = findInPotionQueue(Q, removedPotion)
		        if foundPotion != -1
		            removePotionFromQueue(Q, foundPotion)
		        endIf
		    endIf
		endIf
    endIf
    GotoState("")
endFunction

function removePotionFromQueue(int Q, int targetPotion)
    debug.trace("iEquip_PotionScript removePotionFromQueue called - Q: " + Q + ", targetPotion: " + targetPotion)
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
        ;debug.trace("iEquip_PotionScript getPotionGroupCount - currently checking Q: " + Q + ", queueLength: " + queueLength)
        while i < queueLength
            currentCount = count
            count += PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(targetArray, i), "Form"))
            ;debug.trace("iEquip_PotionScript getPotionGroupCount - " + (count - currentCount) + " potions found in index " + i + " in potion queue " + Q)
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
    debug.trace("iEquip_PotionScript checkAndAddToPotionQueue called - foundPotion: " + foundPotion.GetName())
    ;Check the nth potion isn't a poison or a food and if not build JMap objects for each
    addedToQueue = false
    if !(foundPotion.isPoison() || foundPotion.isFood())
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
            ;Check it isn't already in the chosen queue and add it if not
            if findInPotionQueue(Q, foundPotion as form) != -1
                debug.trace("iEquip_PotionScript checkAndAddToPotionQueue -" + foundPotion.GetName() + " is already in the " + strongestEffects[Q] as String + " queue")
            else
                int index = foundPotion.GetCostliestEffectIndex()
                float effectMagnitude
                if contains(foundPotion.GetName(), "onsummate")
                	effectMagnitude = 9999.0 ;Ensures consummate potions are always the strongest in the Restore queues
                else
                	effectMagnitude = foundPotion.GetNthEffectMagnitude(index)
                endIf
                int potionObj = jMap.object()
                jMap.setForm(potionObj, "Form", foundPotion as form)
                jMap.setFlt(potionObj, "Strength", effectMagnitude)
                jArray.addObj(potionQ[Q], potionObj)
                debug.trace("iEquip_PotionScript checkAndAddToPotionQueue -" + foundPotion.GetName() + " added to the " + strongestEffects[Q] as String + " queue")
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

int function findInPotionQueue(int Q, form potionToFind)
    debug.trace("iEquip_PotionScript findInPotionQueue called - Q: " + Q + ", potionToFind: " + potionToFind)
    int i = 0
    int foundAt = -1
    while i < jArray.count(potionQ[Q]) && foundAt == -1
        if potionToFind == jMap.getForm(jArray.getObj(potionQ[Q], i), "Form")
            foundAt = i            
        endIf
        i += 1
    endwhile
    debug.trace("iEquip_PotionScript findInPotionQueue - returning " + foundAt)
    return foundAt
endFunction

function sortPotionQueue(int Q)
    debug.trace("iEquip_PotionScript sortPotionQueue called - Q: " + Q)
    ;This should sort strongest to weakest by the float value held in the Strength key on each object in the array
    bool swap = true
    int targetArray = potionQ[Q]
    int queueLength = jArray.count(targetArray)
    int passes = queueLength ;- 1
    int i = 0
    while passes > 0 && swap
        swap = false
        while i < passes
            if jMap.getFlt(jArray.getObj(targetArray, i), "Strength") < jMap.getFlt(jArray.getObj(targetArray, i + 1), "Strength")
                swap = true
                jArray.swapItems(targetArray, i, i + 1)
            endIf
            i += 1
        endWhile
        passes -= 1
    endWhile
    i = 0
    while i < queueLength
        debug.trace("iEquip_PotionScript - sortPotionQueue, sorted " + strongestEffects[Q] as string + " array - i: " + i + ", " + jMap.getForm(jArray.getObj(targetArray, i), "Form").GetName() + ", Strength: " + jMap.getFlt(jArray.getObj(targetArray, i), "Strength"))
        i += 1
    endWhile
    queueToSort = -1 ;Reset
endFunction

function selectAndConsumePotion(int potionGroup)
    debug.trace("iEquip_PotionScript selectAndConsumePotion called - potionGroup: " + potionGroup)
    form potionToConsume
    int targetPotion = 0
    bool useStrongest
    int Q = -1
    if potionGroup == 0
        Q = 0 + MCM.iHealthPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 0 + MCM.iHealthPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 0 + MCM.iHealthPotionsThirdChoice
                if jArray.count(potionQ[Q]) < 1
                    debug.notification("You do not appear to have any health potions left")
                    Q = -1
                endIf
            endIf
        endIf
        useStrongest = MCM.bUseStrongestHealthPotion
    elseIf potionGroup == 1
        Q = 3 + MCM.iStaminaPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 3 + MCM.iStaminaPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 3 + MCM.iStaminaPotionsThirdChoice
                if jArray.count(potionQ[Q]) < 1
                    debug.notification("You do not appear to have any stamina potions left")
                    Q = -1
                endIf
            endIf
        endIf
        useStrongest = MCM.bUseStrongestStaminaPotion
    elseIf potionGroup == 2
        Q = 6 + MCM.iMagickaPotionsFirstChoice
        if jArray.count(potionQ[Q]) < 1
            Q = 6 + MCM.iMagickaPotionsSecondChoice
            if jArray.count(potionQ[Q]) < 1
                Q = 6 + MCM.iMagickaPotionsThirdChoice
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
    int Q = 0 + MCM.iHealthPotionsFirstChoice
    int count = jArray.count(potionQ[Q])
    bool found = false 
    if count < 1 && MCM.bQuickHealUseSecondChoice
        Q = 0 + MCM.iHealthPotionsSecondChoice
        count = jArray.count(potionQ[Q])
    endIf
    if count > 0
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