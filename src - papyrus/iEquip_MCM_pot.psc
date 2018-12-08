Scriptname iEquip_MCM_pot extends iEquip_MCM_helperfuncs

iEquip_PotionScript Property PO Auto

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
    MCM.AddToggleOptionST("pot_tgl_enblHealthGroup", "Enable Health Potion Grouping", MCM.WC.bHealthPotionGrouping)
            
    if MCM.WC.bHealthPotionGrouping
        MCM.AddMenuOptionST("pot_men_hPrefEffect", "Preferred Effect", potionEffects[PO.iHealthPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_hPrefEffect2", "2nd Choice", potionEffects[PO.iHealthPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_hPrefEffect3", "3rd Choice", potionEffects[PO.iHealthPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseHealth", "Always use strongest potion first", MCM.PO.bUseStrongestHealthPotion)
    else
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Stamina Potion Options")
    MCM.AddToggleOptionST("pot_tgl_enblStaminaGroup", "Enable Stamina Potion Grouping", MCM.WC.bStaminaPotionGrouping)
            
    if MCM.WC.bStaminaPotionGrouping
        MCM.AddMenuOptionST("pot_men_sPrefEffect", "Preferred Effect", potionEffects[PO.iStaminaPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_sPrefEffect2", "2nd Choice", potionEffects[PO.iStaminaPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_sPrefEffect3", "3rd Choice", potionEffects[PO.iStaminaPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseStamina", "Always use strongest potion first", MCM.PO.bUseStrongestStaminaPotion)
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Magicka Potion Options")
    MCM.AddToggleOptionST("pot_tgl_enblMagickaGroup", "Enable Magicka Potion Grouping", MCM.WC.bMagickaPotionGrouping)
            
    if MCM.WC.bMagickaPotionGrouping
        MCM.AddMenuOptionST("pot_men_mPrefEffect", "Preferred Effect", potionEffects[PO.iMagickaPotionsFirstChoice])
        MCM.AddMenuOptionST("pot_men_mPrefEffect2", "2nd Choice", potionEffects[PO.iMagickaPotionsSecondChoice])
        MCM.AddTextOptionST("pot_txt_mPrefEffect3", "3rd Choice", potionEffects[PO.iMagickaPotionsThirdChoice])
        MCM.AddToggleOptionST("pot_tgl_alwaysUseMagicka", "Always use strongest potion first", MCM.PO.bUseStrongestMagickaPotion)
    else
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
        MCM.AddEmptyOption()
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Widget Options")
    MCM.AddMenuOptionST("pot_men_whenNoPotions", "When no potions left...", emptyPotionQueueOptions[MCM.PO.iEmptyPotionQueueChoice])
    MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "Warning flash when last potion used", MCM.PO.bFlashPotionWarning)
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
            MCM.WC.bHealthPotionGrouping = !MCM.WC.bHealthPotionGrouping
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.bHealthPotionGrouping = true
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_hPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred health potion effect.  When you long press your consumables key to consume a health potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(PO.iHealthPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if PO.iHealthPotionsFirstChoice != currentVar as int
                if PO.iHealthPotionsSecondChoice == currentVar as int
                    PO.iHealthPotionsSecondChoice = PO.iHealthPotionsFirstChoice
                else
                    PO.iHealthPotionsThirdChoice = PO.iHealthPotionsFirstChoice
                endif
                
                PO.iHealthPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pot_men_hPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, PO.iHealthPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[PO.iHealthPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, PO.iHealthPotionsFirstChoice)
        
            PO.iHealthPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            PO.iHealthPotionsThirdChoice = potionEffects.find(potionOptions[0])
            
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
            MCM.PO.bUseStrongestHealthPotion = !MCM.PO.bUseStrongestHealthPotion
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestHealthPotion)
        elseIf currentEvent == "Default"
            MCM.PO.bUseStrongestHealthPotion = true 
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestHealthPotion)
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
            MCM.WC.bStaminaPotionGrouping = !MCM.WC.bStaminaPotionGrouping
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.bStaminaPotionGrouping = true
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_sPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred stamina potion effect.  When you long press your consumables key to consume a stamina potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(PO.iStaminaPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if PO.iStaminaPotionsFirstChoice != currentVar as int
                if PO.iStaminaPotionsSecondChoice == currentVar as int
                    PO.iStaminaPotionsSecondChoice = PO.iStaminaPotionsFirstChoice
                else
                    PO.iStaminaPotionsThirdChoice = PO.iStaminaPotionsFirstChoice
                endif
                
                PO.iStaminaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_sPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, PO.iStaminaPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[PO.iStaminaPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, PO.iStaminaPotionsFirstChoice)
        
            PO.iStaminaPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            PO.iStaminaPotionsThirdChoice = potionEffects.find(potionOptions[0])
            
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
            MCM.PO.bUseStrongestStaminaPotion = !MCM.PO.bUseStrongestStaminaPotion
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestStaminaPotion)
        elseIf currentEvent == "Default"
            MCM.PO.bUseStrongestStaminaPotion = true 
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestStaminaPotion)
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
            MCM.WC.bMagickaPotionGrouping = !MCM.WC.bMagickaPotionGrouping
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.WC.bMagickaPotionGrouping = true
            MCM.WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_mPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred magicka potion effect.  When you long press your consumables key to consume a magicka potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            fillMenu(PO.iMagickaPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if PO.iMagickaPotionsFirstChoice != currentVar as int
                if PO.iMagickaPotionsSecondChoice == currentVar as int
                    PO.iMagickaPotionsSecondChoice = PO.iMagickaPotionsFirstChoice
                else
                    PO.iMagickaPotionsThirdChoice = PO.iMagickaPotionsFirstChoice
                endif
                
                PO.iMagickaPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endif
    endEvent
endState

State pot_men_mPrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = cutStrArray(potionEffects, PO.iMagickaPotionsFirstChoice)
            fillMenu(potionOptions.find(potionEffects[PO.iMagickaPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = cutStrArray(potionEffects, PO.iMagickaPotionsFirstChoice)
        
            PO.iMagickaPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = cutStrArray(potionOptions, currentVar as int)
            PO.iMagickaPotionsThirdChoice = potionEffects.find(potionOptions[0])
        
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
            MCM.PO.bUseStrongestMagickaPotion = !MCM.PO.bUseStrongestMagickaPotion
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestMagickaPotion)
        elseIf currentEvent == "Default"
            MCM.PO.bUseStrongestMagickaPotion = true 
            MCM.SetToggleOptionValueST(MCM.PO.bUseStrongestMagickaPotion)
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
            fillMenu(MCM.PO.iEmptyPotionQueueChoice, emptyPotionQueueOptions, 0)
        elseIf currentEvent == "Accept"
            MCM.PO.iEmptyPotionQueueChoice = currentVar as int
            MCM.SetMenuOptionValueST(emptyPotionQueueOptions[MCM.PO.iEmptyPotionQueueChoice])
            MCM.WC.bEmptyPotionQueueChoiceChanged = true
        endIf
    endEvent
endState

State pot_tgl_warningOnLastPotion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The potion icon will flash twice when the final health, stamina or magicka potion in your inventory is used before fading or hiding")
        elseIf currentEvent == "Select"
            MCM.PO.bFlashPotionWarning = !MCM.PO.bFlashPotionWarning
            MCM.SetToggleOptionValueST(MCM.PO.bFlashPotionWarning)
        elseIf currentEvent == "Default"
            MCM.PO.bFlashPotionWarning = true 
            MCM.SetToggleOptionValueST(MCM.PO.bFlashPotionWarning)
        endIf
    endEvent
endState
