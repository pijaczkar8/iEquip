Scriptname iEquip_MCM_qsh extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions

string[] asMagicSchools

int iCurrentQSPreferredMagicSchoolChoice = 2

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
	
	jArray.addInt(jPageObj, PM.bQuickShieldEnabled as int)
	jArray.addInt(jPageObj, PM.bQuickShield2HSwitchAllowed as int)
	jArray.addInt(jPageObj, PM.bQuickShieldPreferMagic as int)
	jArray.addInt(jPageObj, iCurrentQSPreferredMagicSchoolChoice)
	jArray.addInt(jPageObj, PM.bQuickShieldUnequipLeftIfNotFound as int)
	jArray.addInt(jPageObj, PM.iPreselectQuickShield)
	
    return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
	PM.bQuickShieldEnabled = jArray.getInt(jPageObj, 7)
	PM.bQuickShield2HSwitchAllowed = jArray.getInt(jPageObj, 8)
	PM.bQuickShieldPreferMagic = jArray.getInt(jPageObj, 9)
	iCurrentQSPreferredMagicSchoolChoice = jArray.getInt(jPageObj, 10)
    PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
	PM.bQuickShieldUnequipLeftIfNotFound = jArray.getInt(jPageObj, 11)
	PM.iPreselectQuickShield = jArray.getInt(jPageObj, 12)
endFunction

function drawPage()
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
