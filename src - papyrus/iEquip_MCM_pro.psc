Scriptname iEquip_MCM_pro extends iEquip_MCM_Page

iEquip_ProMode Property PM Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef  Auto
Sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions
string[] QHEquipOptions
string[] QRPreferredWeaponType
string[] QRSwitchOutOptions
string[] QBuffOptions

int iCurrentQSPreferredMagicSchoolChoice = 2
int iCurrentQRPreferredMagicSchoolChoice = 2

bool bQuickRestoreAdvancedSettings

; #############
; ### SETUP ###

function initData()
    QSPreferredMagicSchool = new String[5]
    QSPreferredMagicSchool[0] = "$iEquip_common_alteration"
    QSPreferredMagicSchool[1] = "$iEquip_common_conjuration"
    QSPreferredMagicSchool[2] = "$iEquip_common_destruction"
    QSPreferredMagicSchool[3] = "$iEquip_common_illusion"
    QSPreferredMagicSchool[4] = "$iEquip_common_restoration"
    
    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "$iEquip_MCM_pro_opt_disabled"
    preselectQuickFunctionOptions[1] = "$iEquip_MCM_pro_opt_preselect"
    preselectQuickFunctionOptions[2] = "$iEquip_MCM_pro_opt_equip"
    
    QHEquipOptions = new String[4]
    QHEquipOptions[0] = "$iEquip_MCM_pro_opt_left"
    QHEquipOptions[1] = "$iEquip_MCM_pro_opt_right"
    QHEquipOptions[2] = "$iEquip_MCM_pro_opt_both"
    QHEquipOptions[3] = "$iEquip_MCM_pro_opt_whereFound"
    
    QRPreferredWeaponType = new String[4]
    QRPreferredWeaponType[0] = "$iEquip_MCM_pro_opt_bow"
    QRPreferredWeaponType[1] = "$iEquip_MCM_pro_opt_crossbow"
    QRPreferredWeaponType[2] = "$iEquip_MCM_pro_opt_boundBow"
    QRPreferredWeaponType[3] = "$iEquip_MCM_pro_opt_boundCrossbow"

    QRSwitchOutOptions = new String[5]
    QRSwitchOutOptions[0] = "$iEquip_MCM_pro_opt_disabled"
    QRSwitchOutOptions[1] = "$iEquip_MCM_pro_opt_switch"
    QRSwitchOutOptions[2] = "$iEquip_MCM_pro_opt_2h"
    QRSwitchOutOptions[3] = "$iEquip_MCM_pro_opt_1h"
    QRSwitchOutOptions[4] = "$iEquip_MCM_pro_opt_spell"

    QBuffOptions = new string[4]
    QBuffOptions[0] = "$iEquip_MCM_pro_opt_eitherBuff"
    QBuffOptions[1] = "$iEquip_MCM_pro_opt_fortifyOnly"
    QBuffOptions[2] = "$iEquip_MCM_pro_opt_regenOnly"
    QBuffOptions[3] = "$iEquip_MCM_pro_opt_bothBuffs"
endFunction

function drawPage()
    if MCM.bEnabled && !MCM.bFirstEnabled
        if bStillToEnableProMode
            MCM.AddTextOptionST("pro_txt_dragEastr", "", "$iEquip_MCM_pro_txt_dragEastrA")
        else
            MCM.AddToggleOptionST("pro_tgl_enblProMode", "$iEquip_MCM_pro_lbl_enblProMode", WC.bProModeEnabled)
            MCM.AddTextOptionST("pro_txt_whatProMode", "$iEquip_MCM_pro_lbl_whatIsProMode", "")
        endIf
        
        if WC.bProModeEnabled
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_preselectOpts")
            MCM.AddTextOptionST("pro_txt_whatPreselect", "$iEquip_MCM_pro_lbl_whatPreselect", "")
            MCM.AddToggleOptionST("pro_tgl_enblPreselect", "$iEquip_MCM_pro_lbl_enblPreselect", PM.bPreselectEnabled)
                    
            if PM.bPreselectEnabled
                MCM.AddToggleOptionST("pro_tgl_enblShoutPreselect", "$iEquip_MCM_pro_lbl_enblShoutPreselect", PM.bShoutPreselectEnabled)
                MCM.AddToggleOptionST("pro_tgl_swapPreselectItm", "$iEquip_MCM_pro_lbl_swapPreselectItm", PM.bPreselectSwapItemsOnEquip)
                MCM.AddToggleOptionST("pro_tgl_eqpAllExitPreselectMode", "$iEquip_MCM_pro_lbl_eqpAllExitPreselectMode", PM.bTogglePreselectOnEquipAll)
            endIf
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_quickShieldOpts")
            MCM.AddTextOptionST("pro_txt_whatQuickshield", "$iEquip_MCM_pro_lbl_whatQuickshield", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickshield", "$iEquip_MCM_pro_lbl_enblQuickshield", PM.bQuickShieldEnabled)
                    
            if PM.bQuickShieldEnabled
                MCM.AddToggleOptionST("pro_tgl_with2hReqp", "$iEquip_MCM_pro_lbl_with2hReqp", PM.bQuickShield2HSwitchAllowed)
                MCM.AddToggleOptionST("pro_tgl_prefShieldMag", "$iEquip_MCM_pro_lbl_prefMag", PM.bQuickShieldPreferMagic)
                        
                if PM.bQuickShieldPreferMagic
                    MCM.AddMenuOptionST("pro_men_rightHandspllTyp", "$iEquip_MCM_pro_lbl_rightHandspllTyp", QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
                endIf         
                MCM.AddToggleOptionST("pro_tgl_ifNotFound", "$iEquip_MCM_pro_lbl_ifNotFound", PM.bQuickShieldUnequipLeftIfNotFound)
                MCM.AddMenuOptionST("pro_men_inPreselectQuickshieldMode", "$iEquip_MCM_pro_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickShield])
            endIf
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_quickRestoreOpts")
            MCM.AddTextOptionST("pro_txt_whatQuickRestore", "$iEquip_MCM_pro_lbl_whatQuickRestore", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickRestore", "$iEquip_MCM_pro_lbl_enblQuickRestore", PM.bQuickRestoreEnabled)
            
            if PM.bQuickRestoreEnabled
                ;QuickHeal
                MCM.AddToggleOptionST("pro_tgl_enblQuickheal", "$iEquip_MCM_pro_lbl_enblQuickheal", PM.bQuickHealEnabled) 
                ;QuickMagicka
                MCM.AddToggleOptionST("pro_tgl_enblQuickMagicka", "$iEquip_MCM_pro_lbl_enblQuickMagicka", PM.bQuickMagickaEnabled) 
                ;QuickStamina
                MCM.AddToggleOptionST("pro_tgl_enblQuickStamina", "$iEquip_MCM_pro_lbl_enblQuickStamina", PM.bQuickStaminaEnabled)        
                ;Core settings
                MCM.AddSliderOptionST("pro_sld_QuickRestoreThreshold", "$iEquip_MCM_pro_lbl_QuickRestoreThreshold", PM.fQuickRestoreThreshold*100, "{0} %")
                MCM.AddToggleOptionST("pro_tgl_quickBuff", "$iEquip_MCM_pro_lbl_quickBuff", PM.bQuickBuffEnabled)
                if PM.bQuickBuffEnabled
                    MCM.AddMenuOptionST("pro_men_buffsToApply", "$iEquip_MCM_pro_lbl_buffsToApply", QBuffOptions[PO.iQuickBuffsToApply])
                endIf
                ;QuickHeal Options
                if PM.bQuickHealEnabled
                    MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_quickHealOpts")
                    MCM.AddToggleOptionST("pro_tgl_prefHealMag", "$iEquip_MCM_pro_lbl_prefMag", PM.bQuickHealPreferMagic)
                    MCM.AddToggleOptionST("pro_tgl_useFallback", "$iEquip_MCM_pro_lbl_useFallback", PM.bQuickHealUseFallback)
                            
                    if PM.bQuickHealPreferMagic
                        MCM.AddMenuOptionST("pro_men_alwysEqpSpll", "$iEquip_MCM_pro_lbl_alwysEqpSpll", QHEquipOptions[PM.iQuickHealEquipChoice])
                    endIf

                    MCM.AddToggleOptionST("pro_tgl_swtchBck", "$iEquip_MCM_pro_lbl_swtchBck", PM.bQuickHealSwitchBackEnabled)
                    
                    if PM.bQuickHealSwitchBackEnabled
                        MCM.AddToggleOptionST("pro_tgl_swtchBckRest", "$iEquip_MCM_pro_lbl_swtchBckRest", PM.bQuickHealSwitchBackAndRestore)
                    endIf
                endIf

            endIf
                    
            MCM.SetCursorPosition(1)
                    
            MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_quickRangedOpts")
            MCM.AddTextOptionST("pro_txt_whatQuickranged", "$iEquip_MCM_pro_lbl_whatQuickranged", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "$iEquip_MCM_pro_lbl_enblQuickranged", PM.bQuickRangedEnabled)
                    
            if PM.bQuickRangedEnabled
                MCM.AddMenuOptionST("pro_men_prefWepTyp", "$iEquip_MCM_pro_lbl_prefWepTyp", QRPreferredWeaponType[PM.iQuickRangedPreferredWeaponType])
                MCM.AddMenuOptionST("pro_men_swtchOut", "$iEquip_MCM_pro_lbl_swtchOut", QRSwitchOutOptions[PM.iQuickRangedSwitchOutAction])

                if PM.iQuickRangedSwitchOutAction == 4
                    MCM.AddMenuOptionST("pro_men_prefMagSchl", "$iEquip_MCM_pro_lbl_prefMagSchl", QSPreferredMagicSchool[iCurrentQRPreferredMagicSchoolChoice])
                endIf
               
                MCM.AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "$iEquip_MCM_pro_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
            endIf
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("$iEquip_MCM_pro_lbl_quickDCOpts")
            MCM.AddTextOptionST("pro_txt_whatQuickdualcast", "$iEquip_MCM_pro_lbl_whatQuickdualcast", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickdualcast", "$iEquip_MCM_pro_lbl_enblQuickdualcast", WC.bQuickDualCastEnabled)
                    
            if WC.bQuickDualCastEnabled
                MCM.AddTextOption("$iEquip_MCM_pro_lbl_enableQDCSchools", "")
                MCM.AddToggleOptionST("pro_tgl_altSpll", "$iEquip_MCM_pro_lbl_altSpll", WC.abQuickDualCastSchoolAllowed[0])
                MCM.AddToggleOptionST("pro_tgl_conjSpll", "$iEquip_MCM_pro_lbl_conjSpll", WC.abQuickDualCastSchoolAllowed[1])
                MCM.AddToggleOptionST("pro_tgl_destSpll", "$iEquip_MCM_pro_lbl_destSpll", WC.abQuickDualCastSchoolAllowed[2])
                MCM.AddToggleOptionST("pro_tgl_illSpll", "$iEquip_MCM_pro_lbl_illSpll", WC.abQuickDualCastSchoolAllowed[3])
                MCM.AddToggleOptionST("pro_tgl_restSpll", "$iEquip_MCM_pro_lbl_restSpll", WC.abQuickDualCastSchoolAllowed[4])
                MCM.AddToggleOptionST("pro_tgl_reqBothQue", "$iEquip_MCM_pro_lbl_reqBothQue", PM.bQuickDualCastMustBeInBothQueues)
            endIf
        endIf
    endIf
endFunction

; ################
; ### Pro Mode ###
; ################

State pro_txt_dragEastr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("??????")
        elseIf currentEvent == "Select"
            if iProModeEasterEggCounter >= 0
                string msg
            
                if iProModeEasterEggCounter == 5
                    msg = "$iEquip_MCM_pro_txt_dragEastrB"
                elseIf iProModeEasterEggCounter == 4
                    msg = "$iEquip_MCM_pro_txt_dragEastrC"
                elseIf iProModeEasterEggCounter == 3
                    msg = "$iEquip_MCM_pro_txt_dragEastrD"
                elseIf iProModeEasterEggCounter == 2
                    msg = "$iEquip_MCM_pro_txt_dragEastrE"
                elseIf iProModeEasterEggCounter == 1
                    msg = "$iEquip_MCM_pro_txt_dragEastrF"
                elseIf iProModeEasterEggCounter == 0
                    msg = "$iEquip_MCM_pro_txt_dragEastrG"
                endIf
                
                MCM.SetTextOptionValueST(msg)
                iProModeEasterEggCounter -= 1
            else
                ; Wohoo, let's play an epic tune
                UILevelUp.Play(PlayerRef)
                bStillToEnableProMode = false
                WC.bProModeEnabled = true
                
                MCM.ShowMessage("$iEquip_MCM_pro_msg_dragEastr", false, "$OK")
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pro_tgl_enblProMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblProMode")
        elseIf currentEvent == "Select"
            WC.bProModeEnabled = !WC.bProModeEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bProModeEnabled = false 
            PM.bQuickShieldEnabled = false
            WC.bQuickDualCastEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_txt_whatProMode
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("$iEquip_MCM_pro_txt_whatProMode", false, "$iEquip_common_msg_Exit")
        endIf
    endEvent    
endState
        
; ---------------------
; - Preselect Options -
; ---------------------

State pro_txt_whatPreselect
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_preselect1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_preselect2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    MCM.ShowMessage("$iEquip_help_preselect3", false, "$OK")
                endIf
            endIf
        endIf
    endEvent    
endState

State pro_tgl_enblPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblPreselect")
        elseIf currentEvent == "Select"
            PM.bPreselectEnabled = !PM.bPreselectEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bPreselectEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_enblShoutPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblShoutPreselect")
        elseIf currentEvent == "Select"
            PM.bShoutPreselectEnabled = !PM.bShoutPreselectEnabled
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        elseIf currentEvent == "Default"
            PM.bShoutPreselectEnabled = true
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        endIf
    endEvent
endState

State pro_tgl_swapPreselectItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_swapPreselectItm")
        elseIf currentEvent == "Select"
            PM.bPreselectSwapItemsOnEquip = !PM.bPreselectSwapItemsOnEquip
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        elseIf currentEvent == "Default"
            PM.bPreselectSwapItemsOnEquip = false
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        endIf
    endEvent
endState

State pro_tgl_eqpAllExitPreselectMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_eqpAllExitPreselectMode")
        elseIf currentEvent == "Select"
            PM.bTogglePreselectOnEquipAll = !PM.bTogglePreselectOnEquipAll
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        elseIf currentEvent == "Default"
            PM.bTogglePreselectOnEquipAll = false
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        endIf
    endEvent
endState

; -----------------------
; - QuickShield Options -
; -----------------------

State pro_txt_whatQuickshield
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_quickshield1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_quickshield2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    MCM.ShowMessage("$iEquip_help_quickshield3", false, "$OK")
                endIf
            endIf
        endIf
    endEvent   
endState

State pro_tgl_enblQuickshield
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickshield")
        elseIf currentEvent == "Select"
            PM.bQuickShieldEnabled = !PM.bQuickShieldEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickShieldEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_with2hReqp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_with2hReqp")
        elseIf currentEvent == "Select"
            PM.bQuickShield2HSwitchAllowed = !PM.bQuickShield2HSwitchAllowed
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        elseIf currentEvent == "Default"
            PM.bQuickShield2HSwitchAllowed = true
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        endIf
    endEvent
endState

State pro_tgl_prefShieldMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_prefShieldMag")
        elseIf currentEvent == "Select"
            PM.bQuickShieldPreferMagic = !PM.bQuickShieldPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickShieldPreferMagic = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_rightHandspllTyp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_rightHandspllTyp")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iCurrentQSPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            iCurrentQSPreferredMagicSchoolChoice = currentVar as int
        
            if iCurrentQSPreferredMagicSchoolChoice == 0
                PM.sQuickShieldPreferredMagicSchool = "Alteration"
            elseIf iCurrentQSPreferredMagicSchoolChoice == 1
                PM.sQuickShieldPreferredMagicSchool = "Conjuration"
            elseIf iCurrentQSPreferredMagicSchoolChoice == 2
                PM.sQuickShieldPreferredMagicSchool = "Destruction"
            elseIf iCurrentQSPreferredMagicSchoolChoice == 3
                PM.sQuickShieldPreferredMagicSchool = "Illusion"
            elseIf iCurrentQSPreferredMagicSchoolChoice == 4
                PM.sQuickShieldPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_tgl_ifNotFound
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_ifNotFound")
        elseIf currentEvent == "Select"
			PM.bQuickShieldUnequipLeftIfNotFound = !PM.bQuickShieldUnequipLeftIfNotFound
			MCM.SetToggleOptionValueST(PM.bQuickShieldUnequipLeftIfNotFound)
		elseIf currentEvent == "Default"
            PM.bQuickShieldUnequipLeftIfNotFound = false
            MCM.SetToggleOptionValueST(PM.bQuickShieldUnequipLeftIfNotFound)
        endIf
    endEvent
endState

State pro_men_inPreselectQuickshieldMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_inPreselectQuickshieldMode")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickShield, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickShield = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickShield])
        endIf
    endEvent
endState

; ---------------------
; - QuickRestore Options -
; ---------------------

State pro_txt_whatQuickRestore
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("$iEquip_help_quickRestore1", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                if MCM.ShowMessage("$iEquip_help_quickRestore2", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                    if MCM.ShowMessage("$iEquip_help_quickRestore3", true, "$iEquip_common_msg_NextPage", "$iEquip_common_msg_Exit")
                        MCM.ShowMessage("$iEquip_help_quickRestore4", false, "$iEquip_common_msg_Exit")
                    endIf
                endIf
            endIf
        endIf
    endEvent
endState

State pro_tgl_enblQuickRestore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickRestore")
        elseIf currentEvent == "Select"
            PM.bQuickRestoreEnabled = !PM.bQuickRestoreEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickRestoreEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_enblQuickheal
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickheal")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickHealEnabled)
            PM.bQuickHealEnabled = !PM.bQuickHealEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_enblQuickMagicka
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickMagicka")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickMagickaEnabled)
            PM.bQuickMagickaEnabled = !PM.bQuickMagickaEnabled
            MCM.SetToggleOptionValueST(PM.bQuickMagickaEnabled)
        endIf
    endEvent
endState

State pro_tgl_enblQuickStamina
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickStamina")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickStaminaEnabled)
            PM.bQuickStaminaEnabled = !PM.bQuickStaminaEnabled
            MCM.SetToggleOptionValueST(PM.bQuickStaminaEnabled)
        endIf
    endEvent
endState

State pro_sld_QuickRestoreThreshold
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_QuickRestoreThreshold")
        elseIf currentEvent == "Open"
            MCM.fillSlider(PM.fQuickRestoreThreshold*100, 5.0, 100.0, 5.0, 70.0)
        elseIf currentEvent == "Accept"
            PM.fQuickRestoreThreshold = currentVar/100
            MCM.SetSliderOptionValueST(PM.fQuickRestoreThreshold*100, "{0} %")
        endIf
    endEvent
endState

State pro_tgl_quickBuff
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_quickBuff")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickBuffEnabled)
            PM.bQuickBuffEnabled = !PM.bQuickBuffEnabled
            MCM.SetToggleOptionValueST(PM.bQuickBuffEnabled)
        endIf
    endEvent
endState

State pro_men_buffsToApply
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_buffsToApply")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PO.iQuickBuffsToApply, QBuffOptions, 3)
        elseIf currentEvent == "Accept"
            PO.iQuickBuffsToApply = currentVar as int
            MCM.SetMenuOptionValueST(QBuffOptions[PO.iQuickBuffsToApply])
        endIf
    endEvent
endState

State pro_tgl_prefHealMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_prefHealMag")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealPreferMagic)
            PM.bQuickHealPreferMagic = !PM.bQuickHealPreferMagic
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_useFallback
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_useFallback")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealUseFallback)
            PM.bQuickHealUseFallback = !PM.bQuickHealUseFallback
            MCM.SetToggleOptionValueST(PM.bQuickHealUseFallback)
        endIf
    endEvent
endState

State pro_men_alwysEqpSpll
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_alwysEqpSpll")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickHealEquipChoice, QHEquipOptions, 3)
        elseIf currentEvent == "Accept"
            PM.iQuickHealEquipChoice = currentVar as int
            MCM.SetMenuOptionValueST(QHEquipOptions[PM.iQuickHealEquipChoice])
        endIf
    endEvent
endState

State pro_tgl_swtchBck
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_swtchBck")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickHealSwitchBackEnabled)
            PM.bQuickHealSwitchBackEnabled = !PM.bQuickHealSwitchBackEnabled
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackEnabled)
        endIf
    endEvent
endState

State pro_tgl_swtchBckRest
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_swtchBckRest")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickHealSwitchBackAndRestore)
            PM.bQuickHealSwitchBackAndRestore = !PM.bQuickHealSwitchBackAndRestore
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackAndRestore)
        endIf
    endEvent
endState

; -----------------------
; - QuickRanged Options -
; -----------------------

State pro_txt_whatQuickranged
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("$iEquip_help_quickranged", false, "$OK")
        endIf
    endEvent
endState

State pro_tgl_enblQuickranged
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickranged")
        elseIf currentEvent == "Select"
            PM.bQuickRangedEnabled = !PM.bQuickRangedEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickRangedEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_prefWepTyp
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedPreferredWeaponType, QRPreferredWeaponType, 0)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedPreferredWeaponType = currentVar as int
            MCM.SetMenuOptionValueST(QRPreferredWeaponType[PM.iQuickRangedPreferredWeaponType])
        endIf
    endEvent
endState

State pro_men_swtchOut
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedSwitchOutAction, QRSwitchOutOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedSwitchOutAction = currentVar as int
            MCM.SetMenuOptionValueST(QRSwitchOutOptions[PM.iQuickRangedSwitchOutAction])
        endIf
    endEvent
endState

State pro_men_prefMagSchl
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(iCurrentQRPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            iCurrentQRPreferredMagicSchoolChoice = currentVar as int
        
            if iCurrentQRPreferredMagicSchoolChoice == 0
                PM.sQuickRangedPreferredMagicSchool = "Alteration"
            elseIf iCurrentQRPreferredMagicSchoolChoice == 1
                PM.sQuickRangedPreferredMagicSchool = "Conjuration"
            elseIf iCurrentQRPreferredMagicSchoolChoice == 2
                PM.sQuickRangedPreferredMagicSchool = "Destruction"
            elseIf iCurrentQRPreferredMagicSchoolChoice == 3
                PM.sQuickRangedPreferredMagicSchool = "Illusion"
            elseIf iCurrentQRPreferredMagicSchoolChoice == 4
                PM.sQuickRangedPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[iCurrentQRPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickrangedMode
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickRanged, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickRanged = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
        endIf
    endEvent
endState

; -------------------------
; - QuickDualCast Options -
; -------------------------      

State pro_txt_whatQuickdualcast
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("$iEquip_help_quickdualcast", false, "$OK")
        endIf
    endEvent
endState  

State pro_tgl_enblQuickdualcast
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblQuickdualcast")
        elseIf currentEvent == "Select"
            WC.bQuickDualCastEnabled = !WC.bQuickDualCastEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bQuickDualCastEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_altSpll
    event OnBeginState()
    	if currentEvent == "Select"
			WC.abQuickDualCastSchoolAllowed[0] = !WC.abQuickDualCastSchoolAllowed[0] 
			MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[0])
		elseIf currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[0] = false
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[0])
        endIf
    endEvent
endState

State pro_tgl_conjSpll
    event OnBeginState()
        if currentEvent == "Select"
			WC.abQuickDualCastSchoolAllowed[1] = !WC.abQuickDualCastSchoolAllowed[1] 
			MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[1])
		elseIf currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[1] = false
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[1])
        endIf
    endEvent
endState

State pro_tgl_destSpll
    event OnBeginState()
        if currentEvent == "Select"
			WC.abQuickDualCastSchoolAllowed[2] = !WC.abQuickDualCastSchoolAllowed[2] 
			MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[2])
		elseIf currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[2] = false
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[2])
        endIf
    endEvent
endState

State pro_tgl_illSpll
    event OnBeginState()
        if currentEvent == "Select"
			WC.abQuickDualCastSchoolAllowed[3] = !WC.abQuickDualCastSchoolAllowed[3]
			MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[3])
		elseIf currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[3] = false
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[3])
        endIf
    endEvent
endState

State pro_tgl_restSpll
    event OnBeginState()
        if currentEvent == "Select"
			WC.abQuickDualCastSchoolAllowed[4] = !WC.abQuickDualCastSchoolAllowed[4] 
			MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[4])
		elseIf currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[4] = false
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[4])
        endIf
    endEvent
endState

State pro_tgl_reqBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_reqBothQue")
        elseIf currentEvent == "Select"
            PM.bQuickDualCastMustBeInBothQueues = !PM.bQuickDualCastMustBeInBothQueues
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        elseIf currentEvent == "Default"
            PM.bQuickDualCastMustBeInBothQueues = false
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        endIf
    endEvent
endState
