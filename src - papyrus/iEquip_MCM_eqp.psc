Scriptname iEquip_MCM_eqp extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto
iEquip_KeyHandler Property KH Auto
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
    autoEquipOptions[1] = "$iEquip_MCM_gen_opt_anyTime"
    autoEquipOptions[2] = "$iEquip_MCM_gen_opt_weapDrawn"
    autoEquipOptions[3] = "$iEquip_MCM_gen_opt_combatOnly"

    whenToAutoEquipOptions = new string[3]
    whenToAutoEquipOptions[0] = "$iEquip_MCM_gen_opt_alwaysEquip"
    whenToAutoEquipOptions[1] = "$iEquip_MCM_gen_opt_equipIfBetter"
    whenToAutoEquipOptions[2] = "$iEquip_MCM_gen_opt_equipIfUnarmed"

    currItemEnchOptions = new string[3]
    currItemEnchOptions[0] = "$iEquip_MCM_gen_opt_dontEquip"
    currItemEnchOptions[1] = "$iEquip_MCM_gen_opt_equipIfNoCharge"
    currItemEnchOptions[2] = "$iEquip_MCM_gen_opt_alwaysEquip"

    currItemPoisOptions = new string[2]
    currItemPoisOptions[0] = "$iEquip_MCM_gen_opt_dontEquip"
    currItemPoisOptions[1] = "$iEquip_MCM_gen_opt_alwaysEquip"

    QSPreferredMagicSchool = new String[5]
    QSPreferredMagicSchool[0] = "$iEquip_common_alteration"
    QSPreferredMagicSchool[1] = "$iEquip_common_conjuration"
    QSPreferredMagicSchool[2] = "$iEquip_common_destruction"
    QSPreferredMagicSchool[3] = "$iEquip_common_illusion"
    QSPreferredMagicSchool[4] = "$iEquip_common_restoration"
    
    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "$iEquip_MCM_common_opt_disabled"
    preselectQuickFunctionOptions[1] = "$iEquip_MCM_pro_opt_preselect"
    preselectQuickFunctionOptions[2] = "$iEquip_MCM_pro_opt_equip"
    
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
	
    jArray.addInt(jPageObj, WC.bEnableGearedUp as int)

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

    WC.iAutoEquipEnabled = jArray.getInt(jPageObj, 20)
    WC.iAutoEquip = jArray.getInt(jPageObj, 21)
    WC.iCurrentItemEnchanted = jArray.getInt(jPageObj, 22)
    WC.iCurrentItemPoisoned = jArray.getInt(jPageObj, 23)
    WC.bAutoEquipHardcore = jArray.getInt(jPageObj, 24)
    WC.bAutoEquipDontDropFavorites = jArray.getInt(jPageObj, 25)

    WC.bEnableGearedUp = jArray.getInt(jPageObj, 11)

    PM.bQuickShieldEnabled = jArray.getInt(jPageObj, 7)
    PM.bQuickShield2HSwitchAllowed = jArray.getInt(jPageObj, 8)
    PM.bQuickShieldPreferMagic = jArray.getInt(jPageObj, 9)
    iCurrentQSPreferredMagicSchoolChoice = jArray.getInt(jPageObj, 10)
    PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
    PM.bQuickShieldUnequipLeftIfNotFound = jArray.getInt(jPageObj, 11)
    PM.iPreselectQuickShield = jArray.getInt(jPageObj, 12)

    WC.bQuickDualCastEnabled = jArray.getInt(jPageObj, 32)
    WC.abQuickDualCastSchoolAllowed[0] = jArray.getInt(jPageObj, 33)
    WC.abQuickDualCastSchoolAllowed[1] = jArray.getInt(jPageObj, 34)
    WC.abQuickDualCastSchoolAllowed[2] = jArray.getInt(jPageObj, 35)
    WC.abQuickDualCastSchoolAllowed[3] = jArray.getInt(jPageObj, 36)
    WC.abQuickDualCastSchoolAllowed[4] = jArray.getInt(jPageObj, 37)
    PM.bQuickDualCastMustBeInBothQueues = jArray.getInt(jPageObj, 38)

endFunction

function drawPage()

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_AutoEquip</font>")
    MCM.AddMenuOptionST("gen_men_enableAutoEquip", "$iEquip_MCM_gen_lbl_enableAutoEquip", autoEquipOptions[WC.iAutoEquipEnabled])

    if WC.iAutoEquipEnabled > 0
        MCM.AddMenuOptionST("gen_men_whenToAutoEquip", "$iEquip_MCM_gen_lbl_whenToAutoEquip", whenToAutoEquipOptions[WC.iAutoEquip])
        MCM.AddMenuOptionST("gen_men_currItemEnch", "$iEquip_MCM_gen_lbl_currItemEnch", currItemEnchOptions[WC.iCurrentItemEnchanted])
        MCM.AddMenuOptionST("gen_men_currItemPois", "$iEquip_MCM_gen_lbl_currItemPois", currItemPoisOptions[WC.iCurrentItemPoisoned])
        MCM.AddToggleOptionST("gen_tgl_autoEquipHardcore", "$iEquip_MCM_gen_lbl_autoEquipHardcore", WC.bAutoEquipHardcore)
        if WC.bAutoEquipHardcore
            MCM.AddToggleOptionST("gen_tgl_dontDropFavorites", "$iEquip_MCM_gen_lbl_dontDropFavorites", WC.bAutoEquipDontDropFavorites)
        endIf
    endIf

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_VisGear</font>")
    MCM.AddToggleOptionST("gen_tgl_enblAllGeard", "$iEquip_MCM_gen_lbl_enblAllGeard", WC.bEnableGearedUp)

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pro_lbl_quickShieldOpts</font>")
    MCM.AddTextOptionST("pro_txt_whatQuickshield", "<font color='#a6bffe'>$iEquip_MCM_pro_lbl_whatQuickshield</font>", "")
    
    if PM.bQuickShieldEnabled
        MCM.AddToggleOptionST("pro_tgl_enblQuickshield", "<font color='#c7ea46'>$iEquip_MCM_pro_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
        MCM.AddToggleOptionST("pro_tgl_with2hReqp", "$iEquip_MCM_pro_lbl_with2hReqp", PM.bQuickShield2HSwitchAllowed)
        MCM.AddToggleOptionST("pro_tgl_prefShieldMag", "$iEquip_MCM_pro_lbl_prefMag", PM.bQuickShieldPreferMagic)
                
        if PM.bQuickShieldPreferMagic
            MCM.AddMenuOptionST("pro_men_rightHandspllTyp", "$iEquip_MCM_pro_lbl_rightHandspllTyp", QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf         
        MCM.AddToggleOptionST("pro_tgl_ifNotFound", "$iEquip_MCM_pro_lbl_ifNotFound", PM.bQuickShieldUnequipLeftIfNotFound)
        MCM.AddMenuOptionST("pro_men_inPreselectQuickshieldMode", "$iEquip_MCM_pro_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickShield])
    else
        MCM.AddToggleOptionST("pro_tgl_enblQuickshield", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
    endIf

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pro_lbl_quickDCOpts</font>")
    MCM.AddTextOptionST("pro_txt_whatQuickdualcast", "<font color='#a6bffe'>$iEquip_MCM_pro_lbl_whatQuickdualcast</font>", "")

    if WC.bQuickDualCastEnabled
        MCM.AddToggleOptionST("pro_tgl_enblQuickdualcast", "<font color='#c7ea46'>$iEquip_MCM_pro_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
        MCM.AddTextOption("$iEquip_MCM_pro_lbl_enableQDCSchools", "")
        MCM.AddToggleOptionST("pro_tgl_altSpll", "$iEquip_MCM_pro_lbl_altSpll", WC.abQuickDualCastSchoolAllowed[0])
        MCM.AddToggleOptionST("pro_tgl_conjSpll", "$iEquip_MCM_pro_lbl_conjSpll", WC.abQuickDualCastSchoolAllowed[1])
        MCM.AddToggleOptionST("pro_tgl_destSpll", "$iEquip_MCM_pro_lbl_destSpll", WC.abQuickDualCastSchoolAllowed[2])
        MCM.AddToggleOptionST("pro_tgl_illSpll", "$iEquip_MCM_pro_lbl_illSpll", WC.abQuickDualCastSchoolAllowed[3])
        MCM.AddToggleOptionST("pro_tgl_restSpll", "$iEquip_MCM_pro_lbl_restSpll", WC.abQuickDualCastSchoolAllowed[4])
        MCM.AddToggleOptionST("pro_tgl_reqBothQue", "$iEquip_MCM_pro_lbl_reqBothQue", PM.bQuickDualCastMustBeInBothQueues)
    else
        MCM.AddToggleOptionST("pro_tgl_enblQuickdualcast", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
    endIf

endFunction

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
            PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_tgl_ifNotFound
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_ifNotFound")
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
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[0])
            WC.abQuickDualCastSchoolAllowed[0] = !WC.abQuickDualCastSchoolAllowed[0]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[0])
        endIf
    endEvent
endState

State pro_tgl_conjSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[1])
            WC.abQuickDualCastSchoolAllowed[1] = !WC.abQuickDualCastSchoolAllowed[1]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[1])
        endIf
    endEvent
endState

State pro_tgl_destSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[2])
            WC.abQuickDualCastSchoolAllowed[2] = !WC.abQuickDualCastSchoolAllowed[2]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[2])
        endIf
    endEvent
endState

State pro_tgl_illSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[3])
            WC.abQuickDualCastSchoolAllowed[3] = !WC.abQuickDualCastSchoolAllowed[3]            
            MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[3])
        endIf
    endEvent
endState

State pro_tgl_restSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && WC.abQuickDualCastSchoolAllowed[4])
            WC.abQuickDualCastSchoolAllowed[4] = !WC.abQuickDualCastSchoolAllowed[4]            
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