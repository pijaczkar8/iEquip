Scriptname iEquip_MCM_amm extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto
iEquip_AmmoMode property AM auto

string[] ammoSortingOptions
string[] whenNoAmmoLeftOptions
string[] ammoModeOptions

string[] ammoIconOptions

string[] QRPreferredMagicSchool
string[] preselectQuickFunctionOptions
string[] QRPreferredWeaponType
string[] QREquipOptions
string[] QROtherHandOptions
string[] QRSwitchOutOptions
string[] asMagicSchools

string[] preselectQuickFunctionOptions

int iCurrentQRPreferredMagicSchoolChoice = 2

; #############
; ### SETUP ###

function initData()
    ammoIconOptions = new String[3]
    ammoIconOptions[0] = "$iEquip_MCM_ui_opt_Single"
    ammoIconOptions[1] = "$iEquip_MCM_ui_opt_Triple"
    ammoIconOptions[2] = "$iEquip_MCM_ui_opt_Quiver"

	ammoSortingOptions = new string[4]
    ammoSortingOptions[0] = "$iEquip_MCM_gen_opt_Unsorted"
    ammoSortingOptions[1] = "$iEquip_MCM_gen_opt_ByDamage"
    ammoSortingOptions[2] = "$iEquip_MCM_gen_opt_Alphabetically"
    ammoSortingOptions[3] = "$iEquip_MCM_gen_opt_ByQuantity"

    whenNoAmmoLeftOptions = new string[4]
    whenNoAmmoLeftOptions[0] = "$iEquip_MCM_gen_opt_DoNothing"
    whenNoAmmoLeftOptions[1] = "$iEquip_MCM_gen_opt_SwitchNothing"
    whenNoAmmoLeftOptions[2] = "$iEquip_MCM_gen_opt_SwitchCycle"
    whenNoAmmoLeftOptions[3] = "$iEquip_MCM_gen_opt_Cycle"

    ammoModeOptions = new string[2]
    ammoModeOptions[0] = "$iEquip_MCM_gen_opt_advAM"
    ammoModeOptions[1] = "$iEquip_MCM_gen_opt_simpleAM"

    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "$iEquip_MCM_common_opt_disabled"
    preselectQuickFunctionOptions[1] = "$iEquip_MCM_pro_opt_preselect"
    preselectQuickFunctionOptions[2] = "$iEquip_MCM_pro_opt_equip"

    QRPreferredWeaponType = new String[6]
    QRPreferredWeaponType[0] = "$iEquip_MCM_pro_opt_bow"
    QRPreferredWeaponType[1] = "$iEquip_MCM_pro_opt_crossbow"
    QRPreferredWeaponType[2] = "$iEquip_MCM_pro_opt_boundBow"
    QRPreferredWeaponType[3] = "$iEquip_MCM_pro_opt_boundCrossbow"
    QRPreferredWeaponType[4] = "$iEquip_MCM_pro_opt_rangedSpell"
    QRPreferredWeaponType[5] = "$iEquip_MCM_pro_opt_rangedStaff"

    QREquipOptions = new String[2]
    QREquipOptions[0] = "$iEquip_MCM_pro_opt_left"
    QREquipOptions[1] = "$iEquip_MCM_pro_opt_right"

    QROtherHandOptions = new String[5]
    QROtherHandOptions[0] = "$iEquip_MCM_gen_opt_DoNothing"
    QROtherHandOptions[1] = "$iEquip_MCM_pro_opt_dualCast"
    QROtherHandOptions[2] = "$iEquip_MCM_pro_opt_spellStaff"
    QROtherHandOptions[3] = "$iEquip_MCM_pro_opt_wardSpell"
    QROtherHandOptions[4] = "$iEquip_MCM_pro_opt_weapon"

    QRSwitchOutOptions = new String[5]
    QRSwitchOutOptions[0] = "$iEquip_MCM_common_opt_disabled"
    QRSwitchOutOptions[1] = "$iEquip_MCM_pro_opt_switch"
    QRSwitchOutOptions[2] = "$iEquip_MCM_pro_opt_2h"
    QRSwitchOutOptions[3] = "$iEquip_MCM_pro_opt_1h"
    QRSwitchOutOptions[4] = "$iEquip_MCM_pro_opt_spell"

    QRPreferredMagicSchool = new String[5]
    QRPreferredMagicSchool[0] = "$iEquip_common_alteration"
    QRPreferredMagicSchool[1] = "$iEquip_common_conjuration"
    QRPreferredMagicSchool[2] = "$iEquip_common_destruction"
    QRPreferredMagicSchool[3] = "$iEquip_common_illusion"
    QRPreferredMagicSchool[4] = "$iEquip_common_restoration"

    asMagicSchools = new string[5]
    asMagicSchools[0] = "Alteration"
    asMagicSchools[1] = "Conjuration"
    asMagicSchools[2] = "Destruction"
    asMagicSchools[3] = "Illusion"
    asMagicSchools[4] = "Restoration"

    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "$iEquip_MCM_common_opt_disabled"
    preselectQuickFunctionOptions[1] = "$iEquip_MCM_pro_opt_preselect"
    preselectQuickFunctionOptions[2] = "$iEquip_MCM_pro_opt_equip"
endFunction

int function saveData()             ; Save page data and return jObject
	int jPageObj = jArray.object()

    jArray.addInt(jPageObj, AM.bSimpleAmmoMode as int)
    jArray.addInt(jPageObj, AM.iAmmoListSorting)
    jArray.addInt(jPageObj, AM.iActionOnLastAmmoUsed)

    jArray.addInt(jPageObj, AM.iAmmoIconStyle)
    
    jArray.addInt(jPageObj, WC.bUnequipAmmo as int)
		
	jArray.addInt(jPageObj, PM.bQuickRangedEnabled as int)
	jArray.addInt(jPageObj, PM.iQuickRangedPreferredWeaponType)
	jArray.addInt(jPageObj, PM.iQuickRangedSwitchOutAction)
	jArray.addInt(jPageObj, iCurrentQRPreferredMagicSchoolChoice)
	jArray.addInt(jPageObj, PM.iPreselectQuickRanged)
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

    AM.bSimpleAmmoMode = jArray.getInt(jPageObj, 4)
    AM.iAmmoListSorting = jArray.getInt(jPageObj, 5)
    AM.iActionOnLastAmmoUsed = jArray.getInt(jPageObj, 6)
    AM.iAmmoIconStyle = jArray.getInt(jPageObj, 11)
    WC.bUnequipAmmo = jArray.getInt(jPageObj, 12)

	PM.bQuickRangedEnabled = jArray.getInt(jPageObj, 27)
	PM.iQuickRangedPreferredWeaponType = jArray.getInt(jPageObj, 28)
	PM.iQuickRangedSwitchOutAction = jArray.getInt(jPageObj, 29)
	iCurrentQRPreferredMagicSchoolChoice = jArray.getInt(jPageObj, 30)
    PM.sQuickRangedPreferredMagicSchool = asMagicSchools[iCurrentQRPreferredMagicSchoolChoice]
	PM.iPreselectQuickRanged = jArray.getInt(jPageObj, 31)
	PM.bQuickRangedGiveMeAnythingGoddamit = jArray.getInt(jPageObj, 41)
	PM.iQuickRanged1HPreferredHand = jArray.getInt(jPageObj, 42)
	PM.abQuickRangedSpellSchoolAllowed[0] = jArray.getInt(jPageObj, 43)
	PM.abQuickRangedSpellSchoolAllowed[1] = jArray.getInt(jPageObj, 44)
	PM.abQuickRangedSpellSchoolAllowed[2] = jArray.getInt(jPageObj, 45)
	PM.abQuickRangedSpellSchoolAllowed[3] = jArray.getInt(jPageObj, 46)
	PM.abQuickRangedSpellSchoolAllowed[4] = jArray.getInt(jPageObj, 47)
	PM.iQuickRanged1HOtherHandAction = jArray.getInt(jPageObj, 48)

endFunction

function drawPage()

	MCM.AddEmptyOption()
	MCM.AddHeaderOption("<font color='#C1A57A'>$iEquip_MCM_gen_lbl_AmmoMode</font>")
	MCM.AddTextOptionST("gen_txt_AmmoModeChoice", "$iEquip_MCM_gen_lbl_AmmoModeChoice", ammoModeOptions[AM.bSimpleAmmoMode as int])
	MCM.AddMenuOptionST("gen_men_ammoLstSrt", "$iEquip_MCM_gen_lbl_ammoLstSrt", ammoSortingOptions[AM.iAmmoListSorting])
	MCM.AddMenuOptionST("gen_men_whenNoAmmoLeft", "$iEquip_MCM_gen_lbl_whenNoAmmoLeft", whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])

    MCM.AddMenuOptionST("ui_men_ammoIcoStyle", "$iEquip_MCM_ui_lbl_ammoIcoStyle", ammoIconOptions[AM.iAmmoIconStyle])	

    MCM.AddToggleOptionST("gen_tgl_autoUnqpAmmo", "$iEquip_MCM_gen_lbl_autoUnqpAmmo", WC.bUnequipAmmo)
				
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
			MCM.AddMenuOptionST("pro_men_prefMagSchl", "$iEquip_MCM_pro_lbl_prefMagSchl", QRPreferredMagicSchool[iCurrentQRPreferredMagicSchoolChoice])
		endIf
	   
		MCM.AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "$iEquip_MCM_pro_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
	else
		MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "<font color='#ff7417'>$iEquip_MCM_pro_lbl_enblQuickranged</font>", PM.bQuickRangedEnabled)
	endIf

endFunction

; ------------------------
; - Ammo Mode Options -
; ------------------------ 

State gen_txt_AmmoModeChoice
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_AmmoModeChoice")
        elseIf currentEvent == "Select"
            AM.bSimpleAmmoMode = !AM.bSimpleAmmoMode
            MCM.SetTextOptionValueST(ammoModeOptions[AM.bSimpleAmmoMode as int])
        endIf
    endEvent
endState

State gen_men_ammoLstSrt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_gen_txt_ammoLstSrt")
        elseIf currentEvent == "Open"
            MCM.fillMenu(AM.iAmmoListSorting, ammoSortingOptions, 0)
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
            MCM.fillMenu(AM.iActionOnLastAmmoUsed, whenNoAmmoLeftOptions, 2)
        elseIf currentEvent == "Accept"
            AM.iActionOnLastAmmoUsed = currentVar as int
            MCM.SetMenuOptionValueST(whenNoAmmoLeftOptions[AM.iActionOnLastAmmoUsed])
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
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_QRprefWepTyp")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedPreferredWeaponType, QRPreferredWeaponType, 0)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedPreferredWeaponType = currentVar as int
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_gimmeAnything
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_gimmeAnything")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickRangedGiveMeAnythingGoddamit)
            PM.bQuickRangedGiveMeAnythingGoddamit = !PM.bQuickRangedGiveMeAnythingGoddamit
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_QR_prefHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_prefHand")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRanged1HPreferredHand, QREquipOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iQuickRanged1HPreferredHand = currentVar as int
            if PM.iQuickRanged1HPreferredHand == 0 && PM.iQuickRanged1HOtherHandAction == 3
            	MCM.ShowMessage("$iEquip_MCM_pro_msg_QRprefHandQS", false, "$OK")
            	PM.iQuickRanged1HOtherHandAction = 0
            	MCM.ForcePageReset()
            else
            	MCM.SetMenuOptionValueST(QREquipOptions[PM.iQuickRanged1HPreferredHand])
            endIf
        endIf
    endEvent
endState

State pro_tgl_QR_altSpll
    event OnBeginState()
    	if (currentEvent == "Select") || (currentEvent == "Default" && PM.abQuickRangedSpellSchoolAllowed[0])
            PM.abQuickRangedSpellSchoolAllowed[0] = !PM.abQuickRangedSpellSchoolAllowed[0]            
            MCM.SetToggleOptionValueST(PM.abQuickRangedSpellSchoolAllowed[0])
        endIf
    endEvent
endState

State pro_tgl_QR_conjSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && PM.abQuickRangedSpellSchoolAllowed[1])
            PM.abQuickRangedSpellSchoolAllowed[1] = !PM.abQuickRangedSpellSchoolAllowed[1]            
            MCM.SetToggleOptionValueST(PM.abQuickRangedSpellSchoolAllowed[1])
        endIf
    endEvent
endState

State pro_tgl_QR_destSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && !PM.abQuickRangedSpellSchoolAllowed[2])
            PM.abQuickRangedSpellSchoolAllowed[2] = !PM.abQuickRangedSpellSchoolAllowed[2]            
            MCM.SetToggleOptionValueST(PM.abQuickRangedSpellSchoolAllowed[2])
        endIf
    endEvent
endState

State pro_tgl_QR_illSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && PM.abQuickRangedSpellSchoolAllowed[3])
            PM.abQuickRangedSpellSchoolAllowed[3] = !PM.abQuickRangedSpellSchoolAllowed[3]            
            MCM.SetToggleOptionValueST(PM.abQuickRangedSpellSchoolAllowed[3])
        endIf
    endEvent
endState

State pro_tgl_QR_restSpll
    event OnBeginState()
        if (currentEvent == "Select") || (currentEvent == "Default" && PM.abQuickRangedSpellSchoolAllowed[4])
            PM.abQuickRangedSpellSchoolAllowed[4] = !PM.abQuickRangedSpellSchoolAllowed[4]            
            MCM.SetToggleOptionValueST(PM.abQuickRangedSpellSchoolAllowed[4])
        endIf
    endEvent
endState

State pro_men_QR_otherHand
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_otherHand")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRanged1HOtherHandAction, QROtherHandOptions, 1)
        elseIf currentEvent == "Accept"
            if currentVar as int == 3 && PM.iQuickRanged1HPreferredHand == 0
            	if MCM.ShowMessage("$iEquip_MCM_pro_msg_QRprefHandQS2", true, "$OK", "$Cancel")
            		PM.iQuickRanged1HOtherHandAction = 3
	            	PM.iQuickRanged1HPreferredHand = 1
	            	MCM.ForcePageReset()
	            endIf
            else
            	PM.iQuickRanged1HOtherHandAction = currentVar as int
            	MCM.SetMenuOptionValueST(QROtherHandOptions[PM.iQuickRanged1HOtherHandAction])
            endIf
        endIf
    endEvent
endState

State pro_men_swtchOut
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_QRswtchOut")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedSwitchOutAction, QRSwitchOutOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedSwitchOutAction = currentVar as int
            MCM.ForcePageReset()
        endIf
    endEvent
endState

State pro_men_prefMagSchl
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_QRprefMagSchl")
        elseIf currentEvent == "Open"
            MCM.fillMenu(iCurrentQRPreferredMagicSchoolChoice, QRPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            iCurrentQRPreferredMagicSchoolChoice = currentVar as int
            PM.sQuickRangedPreferredMagicSchool = asMagicSchools[iCurrentQRPreferredMagicSchoolChoice]
            
            MCM.SetMenuOptionValueST(QRPreferredMagicSchool[iCurrentQRPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickrangedMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_QRInPreselectMode")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickRanged, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickRanged = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
        endIf
    endEvent
endState

State ui_men_ammoIcoStyle
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_ui_txt_ammoIcoStyle")
        elseIf currentEvent == "Open"
            MCM.fillMenu(AM.iAmmoIconStyle, ammoIconOptions, 0)
        elseIf currentEvent == "Accept"
            AM.iAmmoIconStyle = currentVar as int
            WC.bAmmoIconChanged = true
            MCM.SetMenuOptionValueST(ammoIconOptions[AM.iAmmoIconStyle])
        endIf 
    endEvent
endState