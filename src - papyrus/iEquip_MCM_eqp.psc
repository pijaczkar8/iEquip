Scriptname iEquip_MCM_eqp extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto

string[] autoEquipOptions
string[] whenToAutoEquipOptions
string[] currItemEnchOptions
string[] currItemPoisOptions

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions

string[] asMagicSchools

int iCurrentQSPreferredMagicSchoolChoice = 2

; #############
; ### SETUP ###

function initData()
    
    autoEquipOptions = new string[4]
    autoEquipOptions[0] = "$iEquip_MCM_common_opt_disabled"
    autoEquipOptions[1] = "$iEquip_MCM_eqp_opt_anyTime"
    autoEquipOptions[2] = "$iEquip_MCM_eqp_opt_weapDrawn"
    autoEquipOptions[3] = "$iEquip_MCM_eqp_opt_combatOnly"

    whenToAutoEquipOptions = new string[3]
    whenToAutoEquipOptions[0] = "$iEquip_MCM_eqp_opt_alwaysEquip"
    whenToAutoEquipOptions[1] = "$iEquip_MCM_eqp_opt_equipIfBetter"
    whenToAutoEquipOptions[2] = "$iEquip_MCM_eqp_opt_equipIfUnarmed"

    currItemEnchOptions = new string[3]
    currItemEnchOptions[0] = "$iEquip_MCM_eqp_opt_dontEquip"
    currItemEnchOptions[1] = "$iEquip_MCM_eqp_opt_equipIfNoCharge"
    currItemEnchOptions[2] = "$iEquip_MCM_eqp_opt_alwaysEquip"

    currItemPoisOptions = new string[2]
    currItemPoisOptions[0] = "$iEquip_MCM_eqp_opt_dontEquip"
    currItemPoisOptions[1] = "$iEquip_MCM_eqp_opt_alwaysEquip"

    QSPreferredMagicSchool = new String[5]
    QSPreferredMagicSchool[0] = "$iEquip_common_alteration"
    QSPreferredMagicSchool[1] = "$iEquip_common_conjuration"
    QSPreferredMagicSchool[2] = "$iEquip_common_destruction"
    QSPreferredMagicSchool[3] = "$iEquip_common_illusion"
    QSPreferredMagicSchool[4] = "$iEquip_common_restoration"
    
    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "$iEquip_MCM_common_opt_disabled"
    preselectQuickFunctionOptions[1] = "$iEquip_MCM_common_opt_preselect"
    preselectQuickFunctionOptions[2] = "$iEquip_MCM_common_opt_equip"
    
    asMagicSchools = new string[5]
    asMagicSchools[0] = "Alteration"
    asMagicSchools[1] = "Conjuration"
    asMagicSchools[2] = "Destruction"
    asMagicSchools[3] = "Illusion"
    asMagicSchools[4] = "Restoration"

endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()

    jArray.addInt(jPageObj, WC.iAutoEquipEnabled)
    jArray.addInt(jPageObj, WC.iAutoEquip)
    jArray.addInt(jPageObj, WC.iCurrentItemEnchanted)
    jArray.addInt(jPageObj, WC.iCurrentItemPoisoned)
    jArray.addInt(jPageObj, WC.bAutoEquipHardcore as int)
    jArray.addInt(jPageObj, WC.bAutoEquipDontDropFavorites as int)
	
    jArray.addInt(jPageObj, PM.bQuickShieldEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickShield2HSwitchAllowed as int)
    jArray.addInt(jPageObj, PM.bQuickShieldPreferMagic as int)
    jArray.addInt(jPageObj, iCurrentQSPreferredMagicSchoolChoice)
    jArray.addInt(jPageObj, PM.bQuickShieldUnequipLeftIfNotFound as int)
    jArray.addInt(jPageObj, PM.iPreselectQuickShield)

    jArray.addInt(jPageObj, WC.bQuickDualCastEnabled as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[0] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[1] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[2] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[3] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[4] as int)
    jArray.addInt(jPageObj, PM.bQuickDualCastMustBeInBothQueues as int)
    
	return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj

    WC.iAutoEquipEnabled = jArray.getInt(jPageObj, 0)
    WC.iAutoEquip = jArray.getInt(jPageObj, 1)
    WC.iCurrentItemEnchanted = jArray.getInt(jPageObj, 2)
    WC.iCurrentItemPoisoned = jArray.getInt(jPageObj, 3)
    WC.bAutoEquipHardcore = jArray.getInt(jPageObj, 4)
    WC.bAutoEquipDontDropFavorites = jArray.getInt(jPageObj, 5)

    PM.bQuickShieldEnabled = jArray.getInt(jPageObj, 6)
    PM.bQuickShield2HSwitchAllowed = jArray.getInt(jPageObj, 7)
    PM.bQuickShieldPreferMagic = jArray.getInt(jPageObj, 8)
    iCurrentQSPreferredMagicSchoolChoice = jArray.getInt(jPageObj, 9)
    PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
    PM.bQuickShieldUnequipLeftIfNotFound = jArray.getInt(jPageObj, 10)
    PM.iPreselectQuickShield = jArray.getInt(jPageObj, 11)

    WC.bQuickDualCastEnabled = jArray.getInt(jPageObj, 12)
    WC.abQuickDualCastSchoolAllowed[0] = jArray.getInt(jPageObj, 13)
    WC.abQuickDualCastSchoolAllowed[1] = jArray.getInt(jPageObj, 14)
    WC.abQuickDualCastSchoolAllowed[2] = jArray.getInt(jPageObj, 15)
    WC.abQuickDualCastSchoolAllowed[3] = jArray.getInt(jPageObj, 16)
    WC.abQuickDualCastSchoolAllowed[4] = jArray.getInt(jPageObj, 17)
    PM.bQuickDualCastMustBeInBothQueues = jArray.getInt(jPageObj, 18)

endFunction

function drawPage()

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_eqp_lbl_AutoEquip</font>")
    MCM.AddMenuOptionST("eqp_men_enableAutoEquip", "$iEquip_MCM_eqp_lbl_enableAutoEquip", autoEquipOptions[WC.iAutoEquipEnabled])

    if WC.iAutoEquipEnabled > 0
        MCM.AddMenuOptionST("eqp_men_whenToAutoEquip", "$iEquip_MCM_eqp_lbl_whenToAutoEquip", whenToAutoEquipOptions[WC.iAutoEquip])
        MCM.AddMenuOptionST("eqp_men_currItemEnch", "$iEquip_MCM_eqp_lbl_currItemEnch", currItemEnchOptions[WC.iCurrentItemEnchanted])
        MCM.AddMenuOptionST("eqp_men_currItemPois", "$iEquip_MCM_eqp_lbl_currItemPois", currItemPoisOptions[WC.iCurrentItemPoisoned])
        MCM.AddToggleOptionST("eqp_tgl_autoEquipHardcore", "$iEquip_MCM_eqp_lbl_autoEquipHardcore", WC.bAutoEquipHardcore)
        if WC.bAutoEquipHardcore
            MCM.AddToggleOptionST("eqp_tgl_dontDropFavorites", "$iEquip_MCM_eqp_lbl_dontDropFavorites", WC.bAutoEquipDontDropFavorites)
        endIf
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_eqp_lbl_quickShieldOpts</font>")
    MCM.AddTextOptionST("eqp_txt_whatQuickshield", "<font color='#a6bffe'>$iEquip_MCM_eqp_lbl_whatQuickshield</font>", "")
    
    if PM.bQuickShieldEnabled
        MCM.AddToggleOptionST("eqp_tgl_enblQuickshield", "<font color='#c7ea46'>$iEquip_MCM_eqp_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
        MCM.AddToggleOptionST("eqp_tgl_with2hReqp", "$iEquip_MCM_eqp_lbl_with2hReqp", PM.bQuickShield2HSwitchAllowed)
        MCM.AddToggleOptionST("eqp_tgl_prefShieldMag", "$iEquip_MCM_common_lbl_prefMag", PM.bQuickShieldPreferMagic)
                
        if PM.bQuickShieldPreferMagic
            MCM.AddMenuOptionST("eqp_men_rightHandspllTyp", "$iEquip_MCM_eqp_lbl_rightHandspllTyp", QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf         
        MCM.AddToggleOptionST("eqp_tgl_ifNotFound", "$iEquip_MCM_eqp_lbl_ifNotFound", PM.bQuickShieldUnequipLeftIfNotFound)
        MCM.AddMenuOptionST("eqp_men_inPreselectQuickshieldMode", "$iEquip_MCM_common_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickShield])
    else
        MCM.AddToggleOptionST("eqp_tgl_enblQuickshield", "<font color='#ff7417'>$iEquip_MCM_eqp_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
    endIf

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_eqp_lbl_dualEquipSpells</font>")
    MCM.AddTextOptionST("eqp_txt_whatDualEquipSpells", "<font color='#a6bffe'>$iEquip_MCM_eqp_lbl_whatQuickdualcast</font>", "")

    if WC.bQuickDualCastEnabled
        MCM.AddToggleOptionST("eqp_tgl_enblDualEquipSpells", "<font color='#c7ea46'>$iEquip_MCM_eqp_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
        MCM.AddTextOption("$iEquip_MCM_eqp_lbl_enableQDCSchools", "")
        MCM.AddToggleOptionST("eqp_tgl_altSpll", "$iEquip_MCM_common_lbl_altSpll", WC.abQuickDualCastSchoolAllowed[0])
        MCM.AddToggleOptionST("eqp_tgl_conjSpll", "$iEquip_MCM_common_lbl_conjSpll", WC.abQuickDualCastSchoolAllowed[1])
        MCM.AddToggleOptionST("eqp_tgl_destSpll", "$iEquip_MCM_common_lbl_destSpll", WC.abQuickDualCastSchoolAllowed[2])
        MCM.AddToggleOptionST("eqp_tgl_illSpll", "$iEquip_MCM_common_lbl_illSpll", WC.abQuickDualCastSchoolAllowed[3])
        MCM.AddToggleOptionST("eqp_tgl_restSpll", "$iEquip_MCM_common_lbl_restSpll", WC.abQuickDualCastSchoolAllowed[4])
        MCM.AddToggleOptionST("eqp_tgl_reqBothQue", "$iEquip_MCM_eqp_lbl_reqBothQue", PM.bQuickDualCastMustBeInBothQueues)
    else
        MCM.AddToggleOptionST("eqp_tgl_enblDualEquipSpells", "<font color='#ff7417'>$iEquip_MCM_eqp_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
    endIf

endFunction

; ------------------------
; - Auto-Equipping Options -
; ------------------------ 

State eqp_men_enableAutoEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_enableAutoEquip")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iAutoEquipEnabled, autoEquipOptions, 0)
        elseIf currentEvent == "Accept"
            bool reset
            if (WC.iAutoEquipEnabled > 0 && currentVar as int == 0) || (WC.iAutoEquipEnabled == 0 && currentVar as int > 0)
                reset = true
            endIf
            WC.iAutoEquipEnabled = currentVar as int
            if reset
                MCM.forcePageReset()
            else
                MCM.SetMenuOptionValueST(autoEquipOptions[WC.iAutoEquipEnabled])
            endIf
        endIf
    endEvent
endState

State eqp_men_whenToAutoEquip
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_whenToAutoEquip")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iAutoEquip, whenToAutoEquipOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iAutoEquip = currentVar as int
            MCM.SetMenuOptionValueST(whenToAutoEquipOptions[WC.iAutoEquip])
        endIf
    endEvent
endState

State eqp_men_currItemEnch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_currItemEnch")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iCurrentItemEnchanted, currItemEnchOptions, 0)
        elseIf currentEvent == "Accept"
            WC.iCurrentItemEnchanted = currentVar as int
            MCM.SetMenuOptionValueST(currItemEnchOptions[WC.iCurrentItemEnchanted])
        endIf
    endEvent
endState

State eqp_men_currItemPois
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_currItemPois")
        elseIf currentEvent == "Open"
            MCM.fillMenu(WC.iCurrentItemPoisoned, currItemPoisOptions, 1)
        elseIf currentEvent == "Accept"
            WC.iCurrentItemPoisoned = currentVar as int
            MCM.SetMenuOptionValueST(currItemPoisOptions[WC.iCurrentItemPoisoned])
        endIf
    endEvent
endState

State eqp_tgl_autoEquipHardcore
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_autoEquipHardcore")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && WC.bAutoEquipHardcore)
            WC.bAutoEquipHardcore = !WC.bAutoEquipHardcore
            MCM.forcePageReset()
        endIf
    endEvent
endState

State eqp_tgl_dontDropFavorites
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_dontDropFavorites")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !WC.bAutoEquipDontDropFavorites)
            WC.bAutoEquipDontDropFavorites = !WC.bAutoEquipDontDropFavorites
            MCM.SetToggleOptionValueST(WC.bAutoEquipDontDropFavorites)
        endIf
    endEvent
endState

; -----------------------
; - QuickShield Options -
; -----------------------

State eqp_txt_whatQuickshield
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

State eqp_tgl_enblQuickshield
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_enblQuickshield")
        elseIf currentEvent == "Select"
            PM.bQuickShieldEnabled = !PM.bQuickShieldEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickShieldEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State eqp_tgl_with2hReqp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_with2hReqp")
        elseIf currentEvent == "Select"
            PM.bQuickShield2HSwitchAllowed = !PM.bQuickShield2HSwitchAllowed
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        elseIf currentEvent == "Default"
            PM.bQuickShield2HSwitchAllowed = true
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        endIf
    endEvent
endState

State eqp_tgl_prefShieldMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_prefShieldMag")
        elseIf currentEvent == "Select"
            PM.bQuickShieldPreferMagic = !PM.bQuickShieldPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickShieldPreferMagic = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State eqp_men_rightHandspllTyp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_rightHandspllTyp")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iCurrentQSPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            iCurrentQSPreferredMagicSchoolChoice = currentVar as int
            PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State eqp_tgl_ifNotFound
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_ifNotFound")
        else
            if currentEvent == "Select"
                PM.bQuickShieldUnequipLeftIfNotFound = !PM.bQuickShieldUnequipLeftIfNotFound
            elseIf currentEvent == "Default"
                PM.bQuickShieldUnequipLeftIfNotFound = false
            endIf
            MCM.SetToggleOptionValueST(PM.bQuickShieldUnequipLeftIfNotFound)
        endIf
    endEvent
endState

State eqp_men_inPreselectQuickshieldMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_inPreselectQuickshieldMode")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickShield, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickShield = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickShield])
        endIf
    endEvent
endState

; -------------------------
; - DualEquipSpells Options -
; -------------------------      

State eqp_txt_whatDualEquipSpells
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("$iEquip_help_quickdualcast", false, "$OK")
        endIf
    endEvent
endState  

State eqp_tgl_enblDualEquipSpells
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_enblQuickdualcast")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && WC.bQuickDualCastEnabled)
            WC.bQuickDualCastEnabled = !WC.bQuickDualCastEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State eqp_tgl_altSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[0])
            WC.abQuickDualCastSchoolAllowed[0] = !WC.abQuickDualCastSchoolAllowed[0]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[0])
        endIf
    endEvent
endState

State eqp_tgl_conjSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[1])
            WC.abQuickDualCastSchoolAllowed[1] = !WC.abQuickDualCastSchoolAllowed[1]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[1])
        endIf
    endEvent
endState

State eqp_tgl_destSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[2])
            WC.abQuickDualCastSchoolAllowed[2] = !WC.abQuickDualCastSchoolAllowed[2]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[2])
        endIf
    endEvent
endState

State eqp_tgl_illSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[3])
            WC.abQuickDualCastSchoolAllowed[3] = !WC.abQuickDualCastSchoolAllowed[3]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[3])
        endIf
    endEvent
endState

State eqp_tgl_restSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[4])
            WC.abQuickDualCastSchoolAllowed[4] = !WC.abQuickDualCastSchoolAllowed[4]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[4])
        endIf
    endEvent
endState

State eqp_tgl_reqBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_reqBothQue")
        elseIf currentEvent == "Select"
            PM.bQuickDualCastMustBeInBothQueues = !PM.bQuickDualCastMustBeInBothQueues
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        elseIf currentEvent == "Default"
            PM.bQuickDualCastMustBeInBothQueues = false
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        endIf
    endEvent
endState