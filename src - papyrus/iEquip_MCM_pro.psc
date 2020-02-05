Scriptname iEquip_MCM_pro extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef  Auto
Sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions

string[] QRPreferredWeaponType
string[] QREquipOptions
string[] QROtherHandOptions
string[] QRSwitchOutOptions

string[] asMagicSchools

int iCurrentQSPreferredMagicSchoolChoice = 2
int iCurrentQRPreferredMagicSchoolChoice = 2

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
	
	jArray.addInt(jPageObj, bStillToEnableProMode as int)
	jArray.addInt(jPageObj, iProModeEasterEggCounter)
	jArray.addInt(jPageObj, WC.bProModeEnabled as int)
	
	jArray.addInt(jPageObj, PM.bQuickShieldEnabled as int)
	jArray.addInt(jPageObj, PM.bQuickShield2HSwitchAllowed as int)
	jArray.addInt(jPageObj, PM.bQuickShieldPreferMagic as int)
	jArray.addInt(jPageObj, iCurrentQSPreferredMagicSchoolChoice)
	jArray.addInt(jPageObj, PM.bQuickShieldUnequipLeftIfNotFound as int)
	jArray.addInt(jPageObj, PM.iPreselectQuickShield)
	
	jArray.addInt(jPageObj, PM.bQuickRangedEnabled as int)
	jArray.addInt(jPageObj, PM.iQuickRangedPreferredWeaponType)
	jArray.addInt(jPageObj, PM.iQuickRangedSwitchOutAction)
	jArray.addInt(jPageObj, iCurrentQRPreferredMagicSchoolChoice)
	jArray.addInt(jPageObj, PM.iPreselectQuickRanged)
	
	jArray.addInt(jPageObj, WC.bQuickDualCastEnabled as int)
	jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[0] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[1] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[2] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[3] as int)
    jArray.addInt(jPageObj, WC.abQuickDualCastSchoolAllowed[4] as int)
	jArray.addInt(jPageObj, PM.bQuickDualCastMustBeInBothQueues as int)

	; New in v1.2

	jArray.addInt(jPageObj, PM.bQuickRangedGiveMeAnythingGoddamit as int)
	jArray.addInt(jPageObj, PM.iQuickRanged1HPreferredHand)
	jArray.addInt(jPageObj, PM.abQuickRangedSpellSchoolAllowed[0] as int)
	jArray.addInt(jPageObj, PM.abQuickRangedSpellSchoolAllowed[1] as int)
	jArray.addInt(jPageObj, PM.abQuickRangedSpellSchoolAllowed[2] as int)
	jArray.addInt(jPageObj, PM.abQuickRangedSpellSchoolAllowed[3] as int)
	jArray.addInt(jPageObj, PM.abQuickRangedSpellSchoolAllowed[4] as int)
	jArray.addInt(jPageObj, PM.iQuickRanged1HOtherHandAction)

    return jPageObj
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj

	WC.bProModeEnabled = jArray.getInt(jPageObj, 2)
	
	
	
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
	if bStillToEnableProMode
		MCM.AddTextOptionST("pro_txt_dragEastr", "", "$iEquip_MCM_pro_txt_dragEastrA")
	else
		MCM.AddTextOptionST("pro_txt_whatProMode", "<font color='#a6bffe'>$iEquip_MCM_pro_lbl_whatIsProMode</font>", "")
		if WC.bProModeEnabled
			MCM.AddToggleOptionST("pro_tgl_enblProMode", "<font color='#c7ea46'>$iEquip_MCM_pro_lbl_enblProMode</font>", WC.bProModeEnabled)
			MCM.AddToggleOptionST("pro_tgl_allowInvScan", "$iEquip_MCM_pro_lbl_allowInvScan", PM.bScanInventory)
			MCM.AddEmptyOption()

			
					
			MCM.AddEmptyOption()
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
					
			MCM.SetCursorPosition(1)
					
			MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_pro_lbl_quickRangedOpts</font>")
			MCM.AddTextOptionST("pro_txt_whatQuickranged", "<font color='#a6bffe'>$iEquip_MCM_pro_lbl_whatQuickranged</font>", "")

			if PM.bQuickRangedEnabled
				MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "<font color='#c7ea46'>$iEquip_MCM_pro_lbl_enblQuickranged</font>", PM.bQuickRangedEnabled)
				MCM.AddMenuOptionST("pro_men_prefWepTyp", "$iEquip_MCM_pro_lbl_prefWepTyp", QRPreferredWeaponType[PM.iQuickRangedPreferredWeaponType])
				MCM.AddToggleOptionST("pro_tgl_gimmeAnything", "$iEquip_MCM_pro_lbl_gimmeAnything", PM.bQuickRangedGiveMeAnythingGoddamit)

				if PM.iQuickRangedPreferredWeaponType > 3 || PM.bQuickRangedGiveMeAnythingGoddamit
					MCM.AddMenuOptionST("pro_men_QR_prefHand", "$iEquip_MCM_pro_lbl_prefHand", QREquipOptions[PM.iQuickRanged1HPreferredHand])
					
					if PM.iQuickRangedPreferredWeaponType == 4 || PM.bQuickRangedGiveMeAnythingGoddamit
						MCM.AddTextOption("$iEquip_MCM_pro_lbl_enableQRSchools", "")
						MCM.AddToggleOptionST("pro_tgl_QR_altSpll", "$iEquip_MCM_pro_lbl_altSpll", PM.abQuickRangedSpellSchoolAllowed[0])
						MCM.AddToggleOptionST("pro_tgl_QR_conjSpll", "$iEquip_MCM_pro_lbl_conjSpll", PM.abQuickRangedSpellSchoolAllowed[1])
						MCM.AddToggleOptionST("pro_tgl_QR_destSpll", "$iEquip_MCM_pro_lbl_destSpll", PM.abQuickRangedSpellSchoolAllowed[2])
						MCM.AddToggleOptionST("pro_tgl_QR_illSpll", "$iEquip_MCM_pro_lbl_illSpll", PM.abQuickRangedSpellSchoolAllowed[3])
						MCM.AddToggleOptionST("pro_tgl_QR_restSpll", "$iEquip_MCM_pro_lbl_restSpll", PM.abQuickRangedSpellSchoolAllowed[4])
					endIf

					MCM.AddMenuOptionST("pro_men_QR_otherHand", "$iEquip_MCM_pro_lbl_otherHand", QROtherHandOptions[PM.iQuickRanged1HOtherHandAction])
				endIf

				MCM.AddMenuOptionST("pro_men_swtchOut", "$iEquip_MCM_pro_lbl_swtchOut", QRSwitchOutOptions[PM.iQuickRangedSwitchOutAction])

				if PM.iQuickRangedSwitchOutAction == 4
					MCM.AddMenuOptionST("pro_men_prefMagSchl", "$iEquip_MCM_pro_lbl_prefMagSchl", QSPreferredMagicSchool[iCurrentQRPreferredMagicSchoolChoice])
				endIf
			   
				MCM.AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "$iEquip_MCM_pro_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
			else
				MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblQuickranged</font>", PM.bQuickRangedEnabled)
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
		else
			MCM.AddToggleOptionST("pro_tgl_enblProMode", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblProMode</font>", WC.bProModeEnabled)
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
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrB")
                    MCM.SetTextOptionValueST("<font color='#fda50f'>"+msg+"</font>")
                elseIf iProModeEasterEggCounter == 4
                    ;msg = "<font color='#ffdb00'>$iEquip_MCM_pro_txt_dragEastrC</font>"
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrC")
                    MCM.SetTextOptionValueST("<font color='#fda50f'>"+msg+"</font>")
                elseIf iProModeEasterEggCounter == 3
                    ;msg = "<font color='#ff7417'>$iEquip_MCM_pro_txt_dragEastrD</font>"
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrD")
                    MCM.SetTextOptionValueST("<font color='#ff7417'>"+msg+"</font>")
                elseIf iProModeEasterEggCounter == 2
                    ;msg = "<font color='#ff7417'>$iEquip_MCM_pro_txt_dragEastrE</font>"
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrE")
                    MCM.SetTextOptionValueST("<font color='#ff7417'>"+msg+"</font>")
                elseIf iProModeEasterEggCounter == 1
                    ;msg = "<font color='#ff0000'>$iEquip_MCM_pro_txt_dragEastrF</font>"
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrF")
                    MCM.SetTextOptionValueST("<font color='#ff0000'>"+msg+"</font>")
                elseIf iProModeEasterEggCounter == 0
                    ;msg = "$iEquip_MCM_pro_txt_dragEastrG"
                    ;MCM.SetTextOptionValueST("$iEquip_MCM_pro_txt_dragEastrG")
                    msg = iEquip_StringExt.LocalizeString("$iEquip_MCM_pro_txt_dragEastrG")
                    MCM.SetTextOptionValueST("<font color='#ff0000'>"+msg+"</font>")
                endIf
                
                ;MCM.SetTextOptionValueST(msg)
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

State pro_tgl_allowInvScan
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_allowInvScan")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bScanInventory)
            PM.bScanInventory = !PM.bScanInventory
            MCM.SetToggleOptionValueST(PM.bScanInventory)
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

State pro_tgl_swapPreselectAdv
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_swapPreselectAdv")
        elseIf currentEvent == "Select" || currentEvent == "Default" && !PM.bPreselectSwapItemsOnEquip
            PM.bPreselectSwapItemsOnEquip = !PM.bPreselectSwapItemsOnEquip
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

