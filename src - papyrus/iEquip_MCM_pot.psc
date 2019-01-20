Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_PotionScript Property PO Auto

string[] potionEffects
string[] emptyPotionQueueOptions

; #############
; ### SETUP ###

function initData()
    potionEffects = new String[3]
    potionEffects[0] = "$iEquip_MCM_pot_opt_restore"
    potionEffects[1] = "$iEquip_MCM_pot_opt_fortify"
    potionEffects[2] = "$iEquip_MCM_pot_opt_regen"
    
    emptyPotionQueueOptions = new String[2]
    emptyPotionQueueOptions[0] = "$iEquip_MCM_pot_opt_fadeicon"
    emptyPotionQueueOptions[1] = "$iEquip_MCM_pot_opt_hideIcon"
endFunction

function drawPage()
    if MCM.bEnabled
        MCM.AddHeaderOption("$iEquip_MCM_pot_lbl_potOpts")
        MCM.AddToggleOptionST("pot_tgl_enblPotionGroup", "$iEquip_MCM_pot_lbl_enblPotionGroup", WC.bPotionGrouping)
                
        if WC.bPotionGrouping
            MCM.AddMenuOptionST("pot_men_PrefEffect", "$iEquip_MCM_pot_lbl_PrefEffect", potionEffects[PO.iPotionsFirstChoice])
            MCM.AddMenuOptionST("pot_men_PrefEffect2", "$iEquip_MCM_pot_lbl_PrefEffect2", potionEffects[PO.iPotionsSecondChoice])
            MCM.AddTextOptionST("pot_txt_PrefEffect3", "$iEquip_MCM_pot_lbl_PrefEffect3", potionEffects[PO.iPotionsThirdChoice])
            MCM.AddToggleOptionST("pot_tgl_alwaysUse", "$iEquip_MCM_pot_lbl_alwaysUse", PO.bUseStrongestPotion)
        endIf
        
        MCM.SetCursorPosition(1)
        MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
        MCM.AddMenuOptionST("pot_men_whenNoPotions", "$iEquip_MCM_pot_lbl_whenNoPotions", emptyPotionQueueOptions[PO.iEmptyPotionQueueChoice])
        MCM.AddToggleOptionST("pot_tgl_warningOnLastPotion", "$iEquip_MCM_pot_lbl_warningOnLastPotion", PO.bFlashPotionWarning)
    endIf
endFunction

; ###############
; ### Potions ###
; ###############

; ------------------
; - Potion Options -
; ------------------

State pot_tgl_enblPotionGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_help_potionGroups")
        elseIf currentEvent == "Select"
            WC.bPotionGrouping = !WC.bPotionGrouping
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bPotionGrouping = true
            WC.bPotionGroupingOptionsChanged = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_men_PrefEffect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_PrefEffect")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iPotionsFirstChoice, potionEffects, 0)
        elseIf currentEvent == "Accept"
            if PO.iPotionsFirstChoice != currentVar as int
                if PO.iPotionsSecondChoice == currentVar as int
                    PO.iPotionsSecondChoice = PO.iPotionsFirstChoice
                else
                    PO.iPotionsThirdChoice = PO.iPotionsFirstChoice
                endif
                
                PO.iPotionsFirstChoice = currentVar as int
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pot_men_PrefEffect2
    event OnBeginState()
        if currentEvent == "Open"
            string[] potionOptions = MCM.cutStrArray(potionEffects, PO.iPotionsFirstChoice)
            MCM.fillMenu(potionOptions.find(potionEffects[PO.iPotionsSecondChoice]), potionOptions, potionOptions.find(potionEffects[1]))
        elseIf currentEvent == "Accept"
            string[] potionOptions = MCM.cutStrArray(potionEffects, PO.iPotionsFirstChoice)
        
            PO.iPotionsSecondChoice = potionEffects.find(potionOptions[currentVar as int])
            potionOptions = MCM.cutStrArray(potionOptions, currentVar as int)
            PO.iPotionsThirdChoice = potionEffects.find(potionOptions[0])
            
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_PrefEffect3
endState

State pot_tgl_alwaysUse
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_alwaysUse")
        elseIf currentEvent == "Select"
            PO.bUseStrongestPotion = !PO.bUseStrongestPotion
            MCM.SetToggleOptionValueST(PO.bUseStrongestPotion)
        elseIf currentEvent == "Default"
            PO.bUseStrongestPotion = true 
            MCM.SetToggleOptionValueST(PO.bUseStrongestPotion)
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State pot_men_whenNoPotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_whenNoPotions")
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
            MCM.SetInfoText("$iEquip_MCM_pot_txt_warningOnLastPotion")
        elseIf currentEvent == "Select"
            PO.bFlashPotionWarning = !PO.bFlashPotionWarning
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        elseIf currentEvent == "Default"
            PO.bFlashPotionWarning = true 
            MCM.SetToggleOptionValueST(PO.bFlashPotionWarning)
        endIf
    endEvent
endState
