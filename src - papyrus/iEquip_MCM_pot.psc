Scriptname iEquip_MCM_pot extends iEquip_MCM_helperfuncs

iEquip_PotionScript Property POT Auto

string[] potionEffects
string[] emptyPotionQueueOptions

; #############
; ### SETUP ###

function initData()
    potionEffects = new String[3]
    potionEffects[0] = "Restore"
    potionEffects[1] = "Fortify"
    potionEffects[2] = "Regenerate"
    
    emptyPotionQueueOptions = new String[2]
    emptyPotionQueueOptions[0] = "Fade Icon"
    emptyPotionQueueOptions[1] = "Hide Icon"
endFunction

function drawPage()
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Health Potion Options")
    MCM.AddToggleOptionST("pot_tgl_enblHealthGroup", "Enable Health Potion Grouping", MCM.bHealthPotionGrouping)
            
    if MCM.bHealthPotionGrouping
        MCM.AddMenuOptionST("pot_men_hPrefEffect", "Preferred Effect", potionEffects[POT.iHealthPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_hPrefEffect2", "2nd Choice", potionEffects[POT.iHealthPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_hPrefEffect3", "3rd Choice", potionEffects[POT.iHealthPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseHealth", "Always use strongest potion first", MCM.bUseStrongestHealthPotion)
    else
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Stamina Potion Options")
    MCM.AddToggleOptionST("pot_tgl_enblStaminaGroup", "Enable Stamina Potion Grouping", MCM.bStaminaPotionGrouping)
            
    if MCM.bStaminaPotionGrouping
        MCM.AddMenuOptionST("pot_men_sPrefEffect", "Preferred Effect", potionEffects[POT.iStaminaPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_sPrefEffect2", "2nd Choice", potionEffects[POT.iStaminaPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_sPrefEffect3", "3rd Choice", potionEffects[POT.iStaminaPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseStamina", "Always use strongest potion first", MCM.bUseStrongestStaminaPotion)
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Magicka Potion Options")
    MCM.AddToggleOptionST("pot_tgl_enblMagickaGroup", "Enable Magicka Potion Grouping", MCM.bMagickaPotionGrouping)
            
    if MCM.bMagickaPotionGrouping
        MCM.AddMenuOptionST("pot_men_mPrefEffect", "Preferred Effect", potionEffects[POT.iMagickaPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_mPrefEffect2", "2nd Choice", potionEffects[POT.iMagickaPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_mPrefEffect3", "3rd Choice", potionEffects[POT.iMagickaPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseMagicka", "Always use strongest potion first", MCM.bUseStrongestMagickaPotion)
    else
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Widget Options")
    MCM.AddMenuOptionST("pot_men_whenNoPotions", "When no potions left...", emptyPotionQueueOptions[MCM.emptyPotionQueueChoice])
    MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "Warning flash when last potion used", MCM.bFlashPotionWarning)
endFunction

; ###############
; ### Potions ###
; ###############

; -------------------------
; - Health Potion Options -
; -------------------------

State pot_tgl_enblHealthGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Rather than having individual health potions in your consumables queue this adds a single Health Potions item to the queue. iEquip then curates a list of all health potions currently in your inventory and consumption is based on the settings below.")
        elseIf currentEvent == "Select"
            MCM.bHealthPotionGrouping = !MCM.bHealthPotionGrouping
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bHealthPotionGrouping = true
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_hPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred health potion effect.  When you long press your consumables key to consume a health potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(POT.iHealthPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if POT.iHealthPotionsFirstChoice != currentVar as int
                if POT.iHealthPotionsSecondChoice == currentVar as int
                    POT.iHealthPotionsSecondChoice = POT.iHealthPotionsFirstChoice
                else
                    POT.iHealthPotionsThirdChoice = POT.iHealthPotionsFirstChoice
                endif
                
                POT.iHealthPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pot_men_hPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, POT.iHealthPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[POT.iHealthPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, POT.iHealthPotionsFirstChoice)
        
            POT.iHealthPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            POT.iHealthPotionsThirdChoice = potionEffects.find(potionOptions[0])
            
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_hPrefEffect3
endState

State pot_tgl_alwaysUseHealth
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose to always consume the strongest or weakest Health Potion of whichever effect is found based on your order of preference and whatever you have in your inventory at the time")
        elseIf currentEvent == "Select"
            MCM.bUseStrongestHealthPotion = !MCM.bUseStrongestHealthPotion
            MCM.SetToggleOptionValueST(MCM.bUseStrongestHealthPotion)
        elseIf currentEvent == "Default"
            MCM.bUseStrongestHealthPotion = true 
            MCM.SetToggleOptionValueST(MCM.bUseStrongestHealthPotion)
        endIf
    endEvent
endState
            
; --------------------------
; - Stamina Potion Options -
; --------------------------

State pot_tgl_enblStaminaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Rather than having individual stamina potions in your consumables queue this adds a single Stamina Potions item to the queue. iEquip then curates a list of all stamina potions currently in your inventory and consumption is based on the settings below.")
        elseIf currentEvent == "Select"
            MCM.bStaminaPotionGrouping = !MCM.bStaminaPotionGrouping
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bStaminaPotionGrouping = true
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_sPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred stamina potion effect.  When you long press your consumables key to consume a stamina potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(POT.iStaminaPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if POT.iStaminaPotionsFirstChoice != currentVar as int
                if POT.iStaminaPotionsSecondChoice == currentVar as int
                    POT.iStaminaPotionsSecondChoice = POT.iStaminaPotionsFirstChoice
                else
                    POT.iStaminaPotionsThirdChoice = POT.iStaminaPotionsFirstChoice
                endif
                
                POT.iStaminaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_sPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, POT.iStaminaPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[POT.iStaminaPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, POT.iStaminaPotionsFirstChoice)
        
            POT.iStaminaPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            POT.iStaminaPotionsThirdChoice = potionEffects.find(potionOptions[0])
            
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_sPrefEffect3
endState

State pot_tgl_alwaysUseStamina
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose to always consume the strongest or weakest Stamina Potion of whichever effect is found based on your order of preference and whatever you have in your inventory at the time")
        elseIf currentEvent == "Select"
            MCM.bUseStrongestStaminaPotion = !MCM.bUseStrongestStaminaPotion
            MCM.SetToggleOptionValueST(MCM.bUseStrongestStaminaPotion)
        elseIf currentEvent == "Default"
            MCM.bUseStrongestStaminaPotion = true 
            MCM.SetToggleOptionValueST(MCM.bUseStrongestStaminaPotion)
        endIf
    endEvent
endState

; --------------------------
; - Magicka Potion Options -
; --------------------------

State pot_tgl_enblMagickaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Rather than having individual magicka potions in your consumables queue this adds a single Magicka Potions item to the queue. iEquip then curates a list of all magicka potions currently in your inventory and consumption is based on the settings below.")
        elseIf currentEvent == "Select"
            MCM.bMagickaPotionGrouping = !MCM.bMagickaPotionGrouping
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bMagickaPotionGrouping = true
            MCM.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_mPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred magicka potion effect.  When you long press your consumables key to consume a magicka potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(POT.iMagickaPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if POT.iMagickaPotionsFirstChoice != currentVar as int
                if POT.iMagickaPotionsSecondChoice == currentVar as int
                    POT.iMagickaPotionsSecondChoice = POT.iMagickaPotionsFirstChoice
                else
                    POT.iMagickaPotionsThirdChoice = POT.iMagickaPotionsFirstChoice
                endif
                
                POT.iMagickaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_mPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, POT.iMagickaPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[POT.iMagickaPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, POT.iMagickaPotionsFirstChoice)
        
            POT.iMagickaPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            POT.iMagickaPotionsThirdChoice = potionEffects.find(potionOptions[0])
        
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_mPrefEffect3
endState

State pot_tgl_alwaysUseMagicka
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose to always consume the strongest or weakest Magicka Potion of whichever effect is found based on your order of preference and whatever you have in your inventory at the time")
        elseIf currentEvent == "Select"
            MCM.bUseStrongestMagickaPotion = !MCM.bUseStrongestMagickaPotion
            MCM.SetToggleOptionValueST(MCM.bUseStrongestMagickaPotion)
        elseIf currentEvent == "Default"
            MCM.bUseStrongestMagickaPotion = true 
            MCM.SetToggleOptionValueST(MCM.bUseStrongestMagickaPotion)
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State pot_men_whenNoPotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("When you run out of health, stamina or magicka potions you can choose to either fade out the icon for the relevant potion group, or hide it in which case it will not appear while cycling until you have more potions back in your inventory")
        elseIf currentEvent == "Open"
            fillMenu(MCM.emptyPotionQueueChoice, emptyPotionQueueOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.emptyPotionQueueChoice = currentVar as int
            MCM.SetMenuOptionValueST(emptyPotionQueueOptions[MCM.emptyPotionQueueChoice])
            MCM.bEmptyPotionQueueChoiceChanged = true
        endIf
    endEvent
endState

State pot_tgl_warningOnLastPotion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The potion icon will flash twice when the final health, stamina or magicka potion in your inventory is used before fading or hiding")
        elseIf currentEvent == "Select"
            MCM.bFlashPotionWarning = !MCM.bFlashPotionWarning
            MCM.SetToggleOptionValueST(MCM.bFlashPotionWarning)
        elseIf currentEvent == "Default"
            MCM.bFlashPotionWarning = true 
            MCM.SetToggleOptionValueST(MCM.bFlashPotionWarning)
        endIf
    endEvent
endState
