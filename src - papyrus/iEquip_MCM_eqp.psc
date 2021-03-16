Scriptname iEquip_MCM_eqp extends iEquip_MCM_Page

import iEquip_StringExt

iEquip_ProMode Property PM Auto
iEquip_EquipLastItem Property EL Auto
iEquip_KeyHandler Property KH Auto

int mcmUnmapFLAG

string[] autoEquipOptions
string[] whenToAutoEquipOptions
string[] currItemEnchOptions
string[] currItemPoisOptions

string[] QSPreferredType
string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions

string[] asMagicSchools

int iCurrentQSPreferredMagicSchoolChoice = 2

; #############
; ### SETUP ###

function initData()
    mcmUnmapFLAG = MCM.OPTION_FLAG_WITH_UNMAP
    
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

    QSPreferredType = new string[3]
    QSPreferredType[0] = "$iEquip_MCM_eqp_opt_shield"
    QSPreferredType[1] = "$iEquip_MCM_eqp_opt_ward"
    QSPreferredType[2] = "$iEquip_MCM_eqp_opt_matchToRightHand"

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
	
    jArray.addInt(jPageObj, EL.isEnabled as int)
    jArray.addInt(jPageObj, KH.iEquipLastItemKey)
    jArray.addFlt(jPageObj, EL.fQueueTimeout)
    jArray.addInt(jPageObj, EL.bHandle1HWeapons as int)
    jArray.addInt(jPageObj, EL.bHandle2HWeapons as int)
    jArray.addInt(jPageObj, EL.bHandleRanged as int)
    jArray.addInt(jPageObj, EL.bHandleAmmo as int)
    jArray.addInt(jPageObj, EL.bHandleStaves as int)
    jArray.addInt(jPageObj, EL.bHandleShields as int)
    jArray.addInt(jPageObj, EL.bHandleLightArmor as int)
    jArray.addInt(jPageObj, EL.bHandleHeavyArmor as int)
    jArray.addInt(jPageObj, EL.bHandleClothing as int)
    jArray.addInt(jPageObj, EL.bHandlePotions as int)
    jArray.addInt(jPageObj, EL.bHandlePoisons as int)
    jArray.addInt(jPageObj, EL.bHandleFood as int)
    jArray.addInt(jPageObj, EL.bHandleSpellTomes as int)
    jArray.addInt(jPageObj, EL.bHandlePersistentBooks as int)
    jArray.addInt(jPageObj, EL.bHandleScrolls as int)
    jArray.addInt(jPageObj, EL.bHandleIngredients as int)

    jArray.addInt(jPageObj, PM.bQuickShieldEnabled as int)
    jArray.addInt(jPageObj, PM.bQuickShield2HSwitchAllowed as int)
    jArray.addInt(jPageObj, PM.iQuickShieldPreferredItemType as int)
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

    if presetVersion < 162
        PM.bQuickShieldEnabled = jArray.getInt(jPageObj, 6)
        PM.bQuickShield2HSwitchAllowed = jArray.getInt(jPageObj, 7)
        PM.iQuickShieldPreferredItemType = jArray.getInt(jPageObj, 8)
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
    else
        EL.isEnabled = jArray.getInt(jPageObj, 6)
        KH.iEquipLastItemKey = jArray.getInt(jPageObj, 7)
        EL.fQueueTimeout = jArray.getFlt(jPageObj, 8)
        EL.bHandle1HWeapons = jArray.getInt(jPageObj, 9)
        EL.bHandle2HWeapons = jArray.getInt(jPageObj, 10)
        EL.bHandleRanged = jArray.getInt(jPageObj, 11)
        EL.bHandleAmmo = jArray.getInt(jPageObj, 12)
        EL.bHandleStaves = jArray.getInt(jPageObj, 13)
        EL.bHandleShields = jArray.getInt(jPageObj, 14)
        EL.bHandleLightArmor = jArray.getInt(jPageObj, 15)
        EL.bHandleHeavyArmor = jArray.getInt(jPageObj, 16)
        EL.bHandleClothing = jArray.getInt(jPageObj, 17)
        EL.bHandlePotions = jArray.getInt(jPageObj, 18)
        EL.bHandlePoisons = jArray.getInt(jPageObj, 19)
        EL.bHandleFood = jArray.getInt(jPageObj, 20)
        EL.bHandleSpellTomes = jArray.getInt(jPageObj, 21)
        EL.bHandlePersistentBooks = jArray.getInt(jPageObj, 22)
        EL.bHandleScrolls = jArray.getInt(jPageObj, 23)
        EL.bHandleIngredients = jArray.getInt(jPageObj, 24)

        PM.bQuickShieldEnabled = jArray.getInt(jPageObj, 25)
        PM.bQuickShield2HSwitchAllowed = jArray.getInt(jPageObj, 26)
        PM.iQuickShieldPreferredItemType = jArray.getInt(jPageObj, 27)
        iCurrentQSPreferredMagicSchoolChoice = jArray.getInt(jPageObj, 28)
        PM.sQuickShieldPreferredMagicSchool = asMagicSchools[iCurrentQSPreferredMagicSchoolChoice]
        PM.bQuickShieldUnequipLeftIfNotFound = jArray.getInt(jPageObj, 29)
        PM.iPreselectQuickShield = jArray.getInt(jPageObj, 30)

        WC.bQuickDualCastEnabled = jArray.getInt(jPageObj, 31)
        WC.abQuickDualCastSchoolAllowed[0] = jArray.getInt(jPageObj, 32)
        WC.abQuickDualCastSchoolAllowed[1] = jArray.getInt(jPageObj, 33)
        WC.abQuickDualCastSchoolAllowed[2] = jArray.getInt(jPageObj, 34)
        WC.abQuickDualCastSchoolAllowed[3] = jArray.getInt(jPageObj, 35)
        WC.abQuickDualCastSchoolAllowed[4] = jArray.getInt(jPageObj, 36)
        PM.bQuickDualCastMustBeInBothQueues = jArray.getInt(jPageObj, 37)
    endIf
endFunction

function drawPage()

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_eqp_lbl_AutoEquip</font>")

    if WC.iAutoEquipEnabled > 0
        MCM.AddMenuOptionST("eqp_men_enableAutoEquip", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_eqp_lbl_enableAutoEquip</font>", autoEquipOptions[WC.iAutoEquipEnabled])
        MCM.AddMenuOptionST("eqp_men_whenToAutoEquip", "$iEquip_MCM_eqp_lbl_whenToAutoEquip", whenToAutoEquipOptions[WC.iAutoEquip])
        MCM.AddMenuOptionST("eqp_men_currItemEnch", "$iEquip_MCM_eqp_lbl_currItemEnch", currItemEnchOptions[WC.iCurrentItemEnchanted])
        MCM.AddMenuOptionST("eqp_men_currItemPois", "$iEquip_MCM_eqp_lbl_currItemPois", currItemPoisOptions[WC.iCurrentItemPoisoned])
        MCM.AddToggleOptionST("eqp_tgl_autoEquipHardcore", "$iEquip_MCM_eqp_lbl_autoEquipHardcore", WC.bAutoEquipHardcore)
        if WC.bAutoEquipHardcore
            MCM.AddToggleOptionST("eqp_tgl_dontDropFavorites", "$iEquip_MCM_eqp_lbl_dontDropFavorites", WC.bAutoEquipDontDropFavorites)
        endIf
    else
        MCM.AddMenuOptionST("eqp_men_enableAutoEquip", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_eqp_lbl_enableAutoEquip</font>", autoEquipOptions[WC.iAutoEquipEnabled])
    endIf
    
    ;MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_eqp_lbl_EquipLastItem</font>")

    if EL.isEnabled
        MCM.AddToggleOptionST("eqp_tgl_enableEquipLastItem", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_eqp_lbl_enableEquipLastItem</font>", EL.isEnabled)
        MCM.AddKeyMapOptionST("eqp_key_equipLastItemKey", "$iEquip_MCM_eqp_lbl_equipLastItemKey", KH.iEquipLastItemKey, mcmUnmapFLAG)
        MCM.AddSliderOptionST("eqp_sld_equipLastItemTimeout", "$iEquip_MCM_eqp_lbl_equipLastItemTimeout", EL.fQueueTimeout, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        MCM.AddTextOptionST("eqp_txt_itemsToHandle", "$iEquip_MCM_eqp_lbl_itemsToHandle", "")
        MCM.AddToggleOptionST("eqp_tgl_handle1H", "$iEquip_MCM_eqp_lbl_handle1H", EL.bHandle1HWeapons)
        MCM.AddToggleOptionST("eqp_tgl_handle2H", "$iEquip_MCM_eqp_lbl_handle2H", EL.bHandle2HWeapons)
        MCM.AddToggleOptionST("eqp_tgl_handleRanged", "$iEquip_MCM_eqp_lbl_handleRanged", EL.bHandleRanged)
        MCM.AddToggleOptionST("eqp_tgl_handleAmmo", "$iEquip_MCM_eqp_lbl_handleAmmo", EL.bHandleAmmo)
        MCM.AddToggleOptionST("eqp_tgl_handleStaves", "$iEquip_MCM_eqp_lbl_handleStaves", EL.bHandleStaves)
        MCM.AddToggleOptionST("eqp_tgl_handleShields", "$iEquip_MCM_eqp_lbl_handleShields", EL.bHandleShields)
        MCM.AddToggleOptionST("eqp_tgl_handleLightArmor", "$iEquip_MCM_eqp_lbl_handleLightArmor", EL.bHandleLightArmor)
        MCM.AddToggleOptionST("eqp_tgl_handleHeavyArmor", "$iEquip_MCM_eqp_lbl_handleHeavyArmor", EL.bHandleHeavyArmor)
        MCM.AddToggleOptionST("eqp_tgl_handleClothing", "$iEquip_MCM_eqp_lbl_handleClothing", EL.bHandleClothing)
        MCM.AddToggleOptionST("eqp_tgl_handlePotions", "$iEquip_MCM_eqp_lbl_handlePotions", EL.bHandlePotions)
        MCM.AddToggleOptionST("eqp_tgl_handlePoisons", "$iEquip_MCM_eqp_lbl_handlePoisons", EL.bHandlePoisons)
        MCM.AddToggleOptionST("eqp_tgl_handleFood", "$iEquip_MCM_eqp_lbl_handleFood", EL.bHandleFood)
        MCM.AddToggleOptionST("eqp_tgl_handleSpellTomes", "$iEquip_MCM_eqp_lbl_handleSpellTomes", EL.bHandleSpellTomes)
        MCM.AddToggleOptionST("eqp_tgl_handlePersistentBooks", "$iEquip_MCM_eqp_lbl_handlePersistentBooks", EL.bHandlePersistentBooks)
        MCM.AddToggleOptionST("eqp_tgl_handleScrolls", "$iEquip_MCM_eqp_lbl_handleScrolls", EL.bHandleScrolls)
        MCM.AddToggleOptionST("eqp_tgl_handleIngredients", "$iEquip_MCM_eqp_lbl_handleIngredients", EL.bHandleIngredients)
    else
        MCM.AddToggleOptionST("eqp_tgl_enableEquipLastItem", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_eqp_lbl_enableEquipLastItem</font>", EL.isEnabled)
    endIf

    MCM.SetCursorPosition(1)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_eqp_lbl_quickShieldOpts</font>")
    MCM.AddTextOptionST("eqp_txt_whatQuickshield", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_eqp_lbl_whatQuickshield</font>", "")
    
    if PM.bQuickShieldEnabled
        MCM.AddToggleOptionST("eqp_tgl_enblQuickshield", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_eqp_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
        MCM.AddToggleOptionST("eqp_tgl_with2hReqp", "$iEquip_MCM_eqp_lbl_with2hReqp", PM.bQuickShield2HSwitchAllowed)
        MCM.AddMenuOptionST("eqp_men_quickShieldItemType", "$iEquip_MCM_eqp_lbl_quickShieldItemType", QSPreferredType[PM.iQuickShieldPreferredItemType])
        MCM.AddToggleOptionST("eqp_tgl_quickShieldUseAlt", "$iEquip_MCM_eqp_lbl_quickShieldUseAlt", PM.bQuickShieldUseAlt)
                
        if PM.iQuickShieldPreferredItemType == 1
            MCM.AddMenuOptionST("eqp_men_rightHandspllTyp", "$iEquip_MCM_eqp_lbl_rightHandspllTyp", QSPreferredMagicSchool[iCurrentQSPreferredMagicSchoolChoice])
        endIf         
        MCM.AddToggleOptionST("eqp_tgl_ifNotFound", "$iEquip_MCM_eqp_lbl_ifNotFound", PM.bQuickShieldUnequipLeftIfNotFound)
        MCM.AddMenuOptionST("eqp_men_inPreselectQuickshieldMode", "$iEquip_MCM_common_lbl_inPreselect", preselectQuickFunctionOptions[PM.iPreselectQuickShield])
    else
        MCM.AddToggleOptionST("eqp_tgl_enblQuickshield", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_eqp_lbl_enblQuickshield</font>", PM.bQuickShieldEnabled)
    endIf

    MCM.AddEmptyOption()
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_eqp_lbl_dualEquipSpells</font>")
    MCM.AddTextOptionST("eqp_txt_whatDualEquipSpells", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_eqp_lbl_whatQuickdualcast</font>", "")

    if WC.bQuickDualCastEnabled
        MCM.AddToggleOptionST("eqp_tgl_enblDualEquipSpells", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_eqp_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
        MCM.AddTextOption("$iEquip_MCM_eqp_lbl_enableQDCSchools", "")
        MCM.AddToggleOptionST("eqp_tgl_altSpll", "$iEquip_MCM_common_lbl_altSpll", WC.abQuickDualCastSchoolAllowed[0])
        MCM.AddToggleOptionST("eqp_tgl_conjSpll", "$iEquip_MCM_common_lbl_conjSpll", WC.abQuickDualCastSchoolAllowed[1])
        MCM.AddToggleOptionST("eqp_tgl_destSpll", "$iEquip_MCM_common_lbl_destSpll", WC.abQuickDualCastSchoolAllowed[2])
        MCM.AddToggleOptionST("eqp_tgl_illSpll", "$iEquip_MCM_common_lbl_illSpll", WC.abQuickDualCastSchoolAllowed[3])
        MCM.AddToggleOptionST("eqp_tgl_restSpll", "$iEquip_MCM_common_lbl_restSpll", WC.abQuickDualCastSchoolAllowed[4])
        MCM.AddToggleOptionST("eqp_tgl_reqBothQue", "$iEquip_MCM_eqp_lbl_reqBothQue", PM.bQuickDualCastMustBeInBothQueues)
    else
        MCM.AddToggleOptionST("eqp_tgl_enblDualEquipSpells", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_eqp_lbl_enblQuickdualcast</font>", WC.bQuickDualCastEnabled)
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

; ---------------------------
; - Equip Last Item Options -
; ---------------------------

State eqp_tgl_enableEquipLastItem
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_enableEquipLastItem")
        elseIf currentEvent == "Select"
            EL.isEnabled = !EL.isEnabled
            MCM.forcePageReset()
        endIf
    endEvent
endState

State eqp_key_equipLastItemKey
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_equipLastItemKey")
        elseIf currentEvent == "Change"
            KH.iEquipLastItemKey = currentVar as int            
            WC.bUpdateKeyMaps = true
            MCM.SetKeyMapOptionValueST(KH.iLeftKey)
        endIf
    endEvent
endState

State eqp_sld_equipLastItemTimeout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_equipLastItemTimeout")
        elseIf currentEvent == "Open"
            MCM.fillSlider(EL.fQueueTimeout, 5.0, 120.0, 5.0, 30.0)
        elseIf currentEvent == "Accept"
            EL.fQueueTimeout = currentVar
            MCM.SetSliderOptionValueST(EL.fQueueTimeout, "{1} " + iEquip_StringExt.LocalizeString("$iEquip_MCM_common_seconds"))
        endIf
    endEvent
endState

State eqp_tgl_handle1H
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handle1H")
        elseIf currentEvent == "Select"
            EL.bHandle1HWeapons = !EL.bHandle1HWeapons
        endIf
    endEvent
endState

State eqp_tgl_handle2H
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handle2H")
        elseIf currentEvent == "Select"
            EL.bHandle2HWeapons = !EL.bHandle2HWeapons
        endIf
    endEvent
endState

State eqp_tgl_handleRanged
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleRanged")
        elseIf currentEvent == "Select"
            EL.bHandleRanged = !EL.bHandleRanged
        endIf
    endEvent
endState

State eqp_tgl_handleAmmo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleAmmo")
        elseIf currentEvent == "Select"
            EL.bHandleAmmo = !EL.bHandleAmmo
        endIf
    endEvent
endState

State eqp_tgl_handleStaves
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleStaves")
        elseIf currentEvent == "Select"
            EL.bHandleStaves = !EL.bHandleStaves
        endIf
    endEvent
endState

State eqp_tgl_handleShields
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleShields")
        elseIf currentEvent == "Select"
            EL.bHandleShields = !EL.bHandleShields
        endIf
    endEvent
endState

State eqp_tgl_handleLightArmor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleLightArmor")
        elseIf currentEvent == "Select"
            EL.bHandleLightArmor = !EL.bHandleLightArmor
        endIf
    endEvent
endState

State eqp_tgl_handleHeavyArmor
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleHeavyArmor")
        elseIf currentEvent == "Select"
            EL.bHandleHeavyArmor = !EL.bHandleHeavyArmor
        endIf
    endEvent
endState

State eqp_tgl_handleClothing
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleClothing")
        elseIf currentEvent == "Select"
            EL.bHandleClothing = !EL.bHandleClothing
        endIf
    endEvent
endState

State eqp_tgl_handlePotions
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handlePotions")
        elseIf currentEvent == "Select"
            EL.bHandlePotions = !EL.bHandlePotions
        endIf
    endEvent
endState

State eqp_tgl_handlePoisons
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handlePoisons")
        elseIf currentEvent == "Select"
            EL.bHandlePoisons = !EL.bHandlePoisons
        endIf
    endEvent
endState

State eqp_tgl_handleFood
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleFood")
        elseIf currentEvent == "Select"
            EL.bHandleFood = !EL.bHandleFood
        endIf
    endEvent
endState

State eqp_tgl_handleSpellTomes
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleSpellTomes")
        elseIf currentEvent == "Select"
            EL.bHandleSpellTomes = !EL.bHandleSpellTomes
        endIf
    endEvent
endState

State eqp_tgl_handlePersistentBooks
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handlePersistentBooks")
        elseIf currentEvent == "Select"
            EL.bHandlePersistentBooks = !EL.bHandlePersistentBooks
        endIf
    endEvent
endState

State eqp_tgl_handleScrolls
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleScrolls")
        elseIf currentEvent == "Select"
            EL.bHandleScrolls = !EL.bHandleScrolls
        endIf
    endEvent
endState

State eqp_tgl_handleIngredients
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_handleIngredients")
        elseIf currentEvent == "Select"
            EL.bHandleIngredients = !EL.bHandleIngredients
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
        endIf
    endEvent
endState

State eqp_tgl_with2hReqp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_with2hReqp")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickShield2HSwitchAllowed)
            PM.bQuickShield2HSwitchAllowed = !PM.bQuickShield2HSwitchAllowed
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        endIf
    endEvent
endState

State eqp_men_quickShieldItemType
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_quickShieldItemType")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickShieldPreferredItemType, QSPreferredType, 0)
        elseIf currentEvent == "Accept"
            PM.iQuickShieldPreferredItemType = currentVar as int         
            MCM.SetMenuOptionValueST(QSPreferredType[PM.iQuickShieldPreferredItemType])
        endIf
    endEvent
endState

State eqp_tgl_quickShieldUseAlt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_eqp_txt_quickShieldUseAlt")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !PM.bQuickShieldUseAlt)
            PM.bQuickShieldUseAlt = !PM.bQuickShieldUseAlt
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
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
        elseIf currentEvent == "Select" || (currentEvent == "Default" && PM.bQuickShieldUnequipLeftIfNotFound)
            PM.bQuickShieldUnequipLeftIfNotFound = !PM.bQuickShieldUnequipLeftIfNotFound
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