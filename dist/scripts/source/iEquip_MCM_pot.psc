Scriptname iEquip_MCM_pot extends iEquip_MCM_helperfuncs

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
            fillMenu(MCM.iHealthPotionsFirstChoice, MCM.potionEffects, 0)
        elseIf currentEvent == "Accept"
            if MCM.iHealthPotionsFirstChoice != currentVar as int
                if MCM.iHealthPotionsSecondChoice == currentVar as int
                    MCM.iHealthPotionsSecondChoice = MCM.iHealthPotionsFirstChoice
                else
                    MCM.iHealthPotionsThirdChoice = MCM.iHealthPotionsFirstChoice
                endif
                
                MCM.iHealthPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pot_men_hPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iHealthPotionsFirstChoice)
            fillMenu(potionOptions.find(MCM.potionEffects[MCM.iHealthPotionsSecondChoice]), potionOptions, potionOptions.find(MCM.potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iHealthPotionsFirstChoice)
        
            MCM.iHealthPotionsSecondChoice = MCM.potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            MCM.iHealthPotionsThirdChoice = MCM.potionEffects.find(potionOptions[0])
            
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
            fillMenu(MCM.iStaminaPotionsFirstChoice, MCM.potionEffects, 0)
        elseIf currentEvent == "Accept"
            if MCM.iStaminaPotionsFirstChoice != currentVar as int
                if MCM.iStaminaPotionsSecondChoice == currentVar as int
                    MCM.iStaminaPotionsSecondChoice = MCM.iStaminaPotionsFirstChoice
                else
                    MCM.iStaminaPotionsThirdChoice = MCM.iStaminaPotionsFirstChoice
                endif
                
                MCM.iStaminaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_sPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iStaminaPotionsFirstChoice)
            fillMenu(potionOptions.find(MCM.potionEffects[MCM.iStaminaPotionsSecondChoice]), potionOptions, potionOptions.find(MCM.potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iStaminaPotionsFirstChoice)
        
            MCM.iStaminaPotionsSecondChoice = MCM.potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            MCM.iStaminaPotionsThirdChoice = MCM.potionEffects.find(potionOptions[0])
            
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
            fillMenu(MCM.iMagickaPotionsFirstChoice, MCM.potionEffects, 0)
        elseIf currentEvent == "Accept"
            if MCM.iMagickaPotionsFirstChoice != currentVar as int
                if MCM.iMagickaPotionsSecondChoice == currentVar as int
                    MCM.iMagickaPotionsSecondChoice = MCM.iMagickaPotionsFirstChoice
                else
                    MCM.iMagickaPotionsThirdChoice = MCM.iMagickaPotionsFirstChoice
                endif
                
                MCM.iMagickaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_mPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iMagickaPotionsFirstChoice)
            fillMenu(potionOptions.find(MCM.potionEffects[MCM.iMagickaPotionsSecondChoice]), potionOptions, potionOptions.find(MCM.potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(MCM.potionEffects, MCM.iMagickaPotionsFirstChoice)
        
            MCM.iMagickaPotionsSecondChoice = MCM.potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            MCM.iMagickaPotionsThirdChoice = MCM.potionEffects.find(potionOptions[0])
        
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
            fillMenu(MCM.emptyPotionQueueChoice, MCM.emptyPotionQueueOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.emptyPotionQueueChoice = currentVar as int
            MCM.SetMenuOptionValueST(MCM.emptyPotionQueueOptions[MCM.emptyPotionQueueChoice])
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
