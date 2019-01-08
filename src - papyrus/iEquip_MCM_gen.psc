Scriptname iEquip_MCM_gen extends iEquip_MCM_helperfuncs

iEquip_WidgetCore Property WC Auto
iEquip_KeyHandler Property KH Auto
iEquip_AmmoMode Property AM Auto

sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] ammoSortingOptions
string[] whenNoAmmoLeftOptions

; #############
; ### SETUP ###

function initData()
    ammoSortingOptions = new String[4]
    ammoSortingOptions[0] = "$iEquip_MCM_gen_opt_Unsorted"
    ammoSortingOptions[1] = "$iEquip_MCM_gen_opt_ByDamage"
    ammoSortingOptions[2] = "$iEquip_MCM_gen_opt_Alphabetically"
    ammoSortingOptions[3] = "$iEquip_MCM_gen_opt_ByQuantity"

    whenNoAmmoLeftOptions = new String[4]
    whenNoAmmoLeftOptions[0] = "$iEquip_MCM_gen_opt_DoNothing"
    whenNoAmmoLeftOptions[1] = "$iEquip_MCM_gen_opt_SwitchNothing"
    whenNoAmmoLeftOptions[2] = "$iEquip_MCM_gen_opt_SwitchCycle"
    whenNoAmmoLeftOptions[3] = "$iEquip_MCM_gen_opt_Cycle"
endFunction

function drawPage()
    MCM.AddToggleOptionST("gen_tgl_onOff", "$iEquip_MCM_gen_lbl_onOff", MCM.bEnabled)
           
    if !MCM.bIsFirstEnabled && MCM.bEnabled
                
        if bStillToEnableProMode
            MCM.AddTextOptionST("gen_txt_dragEastr", "", "$iEquip_MCM_gen_txt_dragEastrA")
        else
            MCM.AddToggleOptionST("gen_tgl_enblProMode", "$iEquip_MCM_gen_lbl_enblProMode", WC.bProModeEnabled)
        endIf
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("$iEquip_MCM_common_lbl_WidgetOptions")
        MCM.AddToggleOptionST("gen_tgl_enblShoutSlt", "$iEquip_MCM_gen_lbl_enblShoutSlt", WC.bShoutEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblConsumSlt", "$iEquip_MCM_gen_lbl_enblConsumSlt", WC.bConsumablesEnabled)
        MCM.AddToggleOptionST("gen_tgl_enblPoisonSlt", "$iEquip_MCM_gen_lbl_enblPoisonSlt", WC.bPoisonsEnabled)
                
        MCM.AddEmptyOption()
        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_VisGear")
        MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "$iEquip_MCM_gen_lbl_enblAllGeard", WC.bEnableGearedUp)
        MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "$iEquip_MCM_gen_lbl_autoUnqpAmmo", WC.bUnequipAmmo)

        MCM.SetCursorPosition(1)
                
        MCM.AddHeaderOption("$iEquip_MCM_gen_lbl_Cycling")
        MCM.AddToggleOptionST("gen_tgl_eqpPaus", "$iEquip_MCM_gen_lbl_eqpPaus", WC.bEquipOnPause)
                
        if WC.bEquipOnPause
            MCM.AddSliderOptionST("gen_sld_eqpPausDelay", "$iEquip_MCM_gen_lbl_eqpPausDelay", WC.fEquipOnPauseDelay, "{0} s")
        endIf
                
        MCM.AddToggleOptionST("gen_tgl_showAtrIco", "$iEquip_MCM_gen_lbl_showAtrIco", WC.bShowAttributeIcons)
        MCM.AddMenuOptionST("gen_men_ammoLstSrt", "$iEquip_MCM_gen_lbl_ammoLstSrt", ammoSortingOptions[AM.iAmmoListSorting])
        MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "$iEquip_MCM_gen_lbl_whenNoAmmoLeft", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
        if WC.findInQueue(1, "$iEquip_common_Unarmed") == -1
            MCM.AddTextOptionST("gen_txt_addFists", "$iEquip_MCM_gen_lbl_AddUnarmed", "")
        endIf
    endIf
endFunction

; ########################
; ### General Settings ###
; ########################

State gen_tgl_onOff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_onOff_SE")
        elseIf currentEvent == "Select"
            if MCM.bIsFirstEnabled
                ;MCM.ShowMessage("$iEquip_MCM_gen_msg_onOff", False, "$OK")
                MCM.bEnabled = true
                KH.openiEquipMCM(true)
            else
                MCM.bEnabled = !MCM.bEnabled
                MCM.forcePageReset()
            endIf
        elseIf currentEvent == "Default"
            MCM.bEnabled = false 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_txt_dragEastr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("??????")
        elseIf currentEvent == "Select"
            if iProModeEasterEggCounter >= 0
                string msg
            
                if iProModeEasterEggCounter == 5
                    msg = "$iEquip_MCM_gen_txt_dragEastrB"
                elseIf iProModeEasterEggCounter == 4
                    msg = "$iEquip_MCM_gen_txt_dragEastrC"
                elseIf iProModeEasterEggCounter == 3
                    msg = "$iEquip_MCM_gen_txt_dragEastrD"
                elseIf iProModeEasterEggCounter == 2
                    msg = "$iEquip_MCM_gen_txt_dragEastrE"
                elseIf iProModeEasterEggCounter == 1
                    msg = "$iEquip_MCM_gen_txt_dragEastrF"
                elseIf iProModeEasterEggCounter == 0
                    msg = "$iEquip_MCM_gen_txt_dragEastrG"
                endIf
                
                MCM.SetTextOptionValueST(msg)
                iProModeEasterEggCounter -= 1
            else
                ; Wohoo, let's play an epic tune
                UILevelUp.Play(MCM.PlayerRef)
                MCM.ShowMessage("$iEquip_MCM_gen_msg_dragEastr", false, "$OK")
                bStillToEnableProMode = false
                WC.bProModeEnabled = true
                ;MCM.ShowMessage("$iEquip_MCM_gen_msg_dragEastr_SE", False, "$OK")
                KH.openiEquipMCM(true)
            endIf
        endIf
    endEvent
endState

State gen_tgl_enblProMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblProMode")
        elseIf currentEvent == "Select"
            WC.bProModeEnabled = !WC.bProModeEnabled
            MCM.SetToggleOptionValueST(WC.bProModeEnabled)
        elseIf currentEvent == "Default"
            MCM.ShowMessage("$iEquip_MCM_gen_msg_enblProMode", false, "$OK")
            WC.bProModeEnabled = false 
            KH.bQuickShieldEnabled = false
            WC.bQuickDualCastEnabled = false
            KH.openiEquipMCM(true)
        endIf
    endEvent
endState
            
; ------------------
; - Widget Options -
; ------------------

State gen_tgl_enblShoutSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblShoutSlt")
        elseIf currentEvent == "Select"
            WC.bShoutEnabled = !WC.bShoutEnabled
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bShoutEnabled = true 
            MCM.SetToggleOptionValueST(WC.bShoutEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblConsumSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblConsumSlt")
        elseIf currentEvent == "Select"
            WC.bConsumablesEnabled = !WC.bConsumablesEnabled
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bConsumablesEnabled = true 
            MCM.SetToggleOptionValueST(WC.bConsumablesEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

State gen_tgl_enblPoisonSlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblPoisonSlt")
        elseIf currentEvent == "Select"
            WC.bPoisonsEnabled = !WC.bPoisonsEnabled
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
        elseIf currentEvent == "Default"
            WC.bPoisonsEnabled = true 
            MCM.SetToggleOptionValueST(WC.bPoisonsEnabled)
            WC.bSlotEnabledOptionsChanged = true
        endIf
    endEvent
endState

; ------------------------
; - Visible Gear Options -
; ------------------------        

State gen_tgl_enblAllGeard
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_enblAllGeard")
        elseIf currentEvent == "Select"
            WC.bEnableGearedUp = !WC.bEnableGearedUp
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        elseIf currentEvent == "Default"
            WC.bEnableGearedUp = true 
            MCM.SetToggleOptionValueST(WC.bEnableGearedUp)
            WC.bGearedUpOptionChanged = true
        endIf
    endEvent
endState

State gen_tgl_autoUnqpAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_autoUnqpAmmo")
        elseIf currentEvent == "Select"
            WC.bUnequipAmmo = !WC.bUnequipAmmo
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
        elseIf currentEvent == "Default"
            WC.bUnequipAmmo = true 
            MCM.SetToggleOptionValueST(WC.bUnequipAmmo)
        endIf
    endEvent
endState

; ---------------------
; - Cycling Behaviour -
; ---------------------

State gen_tgl_eqpPaus
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_eqpPaus")
        elseIf currentEvent == "Select"
            WC.bEquipOnPause = !WC.bEquipOnPause
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEquipOnPause = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State gen_sld_eqpPausDelay
    event OnBeginState()
        if currentEvent == "Open"
            fillSlider(WC.fEquipOnPauseDelay, 0.8, 10.0, 0.1, 2.0)
        elseIf currentEvent == "Accept"
            WC.fEquipOnPauseDelay = currentVar
            MCM.SetSliderOptionValueST(WC.fEquipOnPauseDelay, "{1} s")
        endIf
    endEvent
endState

State gen_tgl_showAtrIco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_showAtrIco")
        elseIf currentEvent == "Select"
            WC.bShowAttributeIcons = !WC.bShowAttributeIcons
            MCM.SetToggleOptionValueST(WC.bShowAttributeIcons)
            WC.bAttributeIconsOptionChanged = true
        endIf
    endEvent
endState

State gen_men_ammoLstSrt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_ammoLstSrt")
        elseIf currentEvent == "Open"
            fillMenu(AM.iAmmoListSorting, ammoSortingOptions, 0)
        elseIf currentEvent == "Accept"
            AM.iAmmoListSorting = currentVar as int
            MCM.SetMenuOptionValueST(ammoSortingOptions[AM.iAmmoListSorting])
            WC.bAmmoSortingChanged = true
        endIf
    endEvent
endState

State gen_men_whenNoAmmoLeft
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_whenNoAmmoLeft")
        elseIf currentEvent == "Open"
            fillMenu(AM.iActionOnLastAmmoUsed, whenNoAmmoLeftOptions, 2)
        elseIf currentEvent == "Accept"
            AM.iActionOnLastAmmoUsed = currentVar as int
            MCM.SetMenuOptionValueST(whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
        endIf
    endEvent
endState

State gen_txt_addFists
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_addFists")
        elseIf currentEvent == "Select"
            WC.addFists()
            MCM.forcePageReset()
        endIf
    endEvent
endState
