Scriptname iEquip_MCM_pot extends iEquip_MCM_Page

iEquip_PotionScript Property PO Auto

string[] potionEffects
string[] emptyPotionQueueOptions
string[] potionSelectOptions

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

    potionSelectOptions = new String[3]
    potionSelectOptions[0] = "$iEquip_MCM_pot_opt_alwaysStrongest"
    potionSelectOptions[1] = "$iEquip_MCM_pot_opt_smartSelect"
    potionSelectOptions[2] = "$iEquip_MCM_pot_opt_alwaysWeakest"
endFunction

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        MCM.AddHeaderOption("$iEquip_MCM_pot_lbl_potOpts")
        MCM.AddToggleOptionST("pot_tgl_enblPotionGroup", "$iEquip_MCM_pot_lbl_enblPotionGroup", WC.bPotionGrouping)
                
        if WC.bPotionGrouping
            MCM.AddMenuOptionST("pot_men_PrefEffect", "$iEquip_MCM_pot_lbl_PrefEffect", potionEffects[PO.iPotionsFirstChoice])
            MCM.AddMenuOptionST("pot_men_PrefEffect2", "$iEquip_MCM_pot_lbl_PrefEffect2", potionEffects[PO.iPotionsSecondChoice])
            MCM.AddTextOptionST("pot_txt_PrefEffect3", "$iEquip_MCM_pot_lbl_PrefEffect3", potionEffects[PO.iPotionsThirdChoice])
            MCM.AddMenuOptionST("pot_men_PotionSelect", "$iEquip_MCM_pot_lbl_PotionSelect", potionSelectOptions[PO.iPotionSelectChoice])
            if PO.iPotionSelectChoice == 1 ; Smart Select
                MCM.AddSliderOptionST("pot_sld_StatThreshold", "$iEquip_MCM_pot_lbl_StatThreshold", PO.fSmartConsumeThreshold*100, "{0} %")
            endIf
            MCM.AddEmptyOption()
            if !WC.abPotionGroupEnabled[0]
                MCM.AddTextOptionST("pot_txt_addHealthGroup", "$iEquip_MCM_gen_lbl_addHealthGroup", "")
            endIf
            if !WC.abPotionGroupEnabled[1]
                MCM.AddTextOptionST("pot_txt_addStaminaGroup", "$iEquip_MCM_gen_lbl_addStaminaGroup", "")
            endIf
            if !WC.abPotionGroupEnabled[2]
                MCM.AddTextOptionST("pot_txt_addMagickaGroup", "$iEquip_MCM_gen_lbl_addMagickaGroup", "")
            endIf
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

State pot_men_PotionSelect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_PotionSelect")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iPotionSelectChoice, potionSelectOptions, 0)
        elseIf currentEvent == "Accept"
            PO.iPotionSelectChoice = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_sld_StatThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_StatThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PO.fSmartConsumeThreshold*100, 5.0, 100.0, 5.0, 40.0)
        elseIf currentEvent == "Accept"
            PO.fSmartConsumeThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PO.fSmartConsumeThreshold*100, "{0} %")
        endIf
    endEvent
endState

State pot_txt_addHealthGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addHealthGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(0)
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_addStaminaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addStaminaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(1)
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pot_txt_addMagickaGroup
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pot_txt_addMagickaGroup")
        elseIf currentEvent == "Select"
            WC.addPotionGroups(2)
            MCM.forcePageReset()
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
