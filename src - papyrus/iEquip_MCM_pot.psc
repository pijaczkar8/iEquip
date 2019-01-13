Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_WidgetCore Property WC Auto
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
    if MCM.bEnabled
        MCM.AddHeaderOption("Potion Options")
        MCM.AddToggleOptionST("pot_tgl_enblHealthGroup", "Enable Potion Grouping", WC.bHealthPotionGrouping)
                
        if WC.bHealthPotionGrouping
            MCM.AddMenuOptionST("pot_men_hPrefEffect", "Preferred Effect", potionEffects[PO.iHealthPotionsFirstChoice])
            MCM.AddMenuOptionST("pot_men_hPrefEffect2", "2nd Choice", potionEffects[PO.iHealthPotionsSecondChoice])
            MCM.AddTextOptionST("pot_txt_hPrefEffect3", "3rd Choice", potionEffects[PO.iHealthPotionsThirdChoice])
            MCM.AddToggleOptionST("pot_tgl_alwaysUseHealth", "Always use strongest potion first", PO.bUseStrongestHealthPotion)
        endIf
        
        MCM.SetCursorPosition(1)
        MCM.AddHeaderOption("Widget Options")
        MCM.AddMenuOptionST("pot_men_whenNoPotions", "When no potions left...", emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
        MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "Warning flash when last potion used", PO.bFlashPotionWarning)
    endIf
endFunction

; ###############
; ### Potions ###
; ###############

; ------------------
; - Potion Options -
; ------------------

State pot_tgl_enblHealthGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Rather than having individual health potions in your consumables queue this adds a single Health Potions item to the queue. iEquip then curates a list of all health potions currently in your inventory and consumption is based on the settings below.")
        elseIf currentEvent == "Select"
            WC.bHealthPotionGrouping = !WC.bHealthPotionGrouping
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bHealthPotionGrouping = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_hPrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose your preferred health potion effect.  When you long press your consumables key to consume a health potion iEquip will search the potion lists in order of preference set here.")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iHealthPotionsFirstChoice, potionEffects, 0)
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
            string[] potionOptions = MCM.cutStrArray(potionEffects, PO.iHealthPotionsFirstChoice)
            MCM.fillMenu(potionOptions.find(potionEffects[PO.iHealthPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = MCM.cutStrArray(potionEffects, PO.iHealthPotionsFirstChoice)
        
            PO.iHealthPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = MCM.cutStrArray(potionOptions, currentVar as int)
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
            PO.bUseStrongestHealthPotion = !PO.bUseStrongestHealthPotion
            MCM.SetToggleOptionValueST(PO.bUseStrongestHealthPotion)
        elseIf currentEvent == "Default"
            PO.bUseStrongestHealthPotion = true 
            MCM.SetToggleOptionValueST(PO.bUseStrongestHealthPotion)
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
            MCM.fillMenu(PO.iEmptyPotionQueueChoice, emptyPotionQueueOptions, 0)
        elseIf currentEvent == "Accept"
            PO.iEmptyPotionQueueChoice = currentVar as int
            MCM.SetMenuOptionValueST(emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
            WC.bEmptyPotionQueueChoiceChanged = true
        endIf
    endEvent
endState

State pot_tgl_warningOnLastPotion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The potion icon will flash twice when the final health, stamina or magicka potion in your inventory is used before fading or hiding")
        elseIf currentEvent == "Select"
            PO.bFlashPotionWarning = !PO.bFlashPotionWarning
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        elseIf currentEvent == "Default"
            PO.bFlashPotionWarning = true 
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        endIf
    endEvent
endState
