Scriptname iEquip_MCM_inf extends iEquip_MCM_Page

import iEquip_StringExt
import StringUtil

iEquip_KeyHandler Property KH Auto
iEquip_EditMode Property EM Auto

string[] saPresets

string[] asTextColourOptions

string[] modStates

int mcmDisabledFLAG
int[] aiFlags
; #############
; ### SETUP ###

function initData()                  ; Initialize page specific data
	asTextColourOptions = new string[2]
	asTextColourOptions[0] = "$iEquip_common_Default"
	asTextColourOptions[1] = "$iEquip_MCM_inf_opt_paperColours"

	modStates = new string[2]
    modStates[0] = "$iEquip_MCM_common_notDetected"
    modStates[1] = "$iEquip_MCM_common_installed"

    mcmDisabledFLAG = MCM.OPTION_FLAG_DISABLED

    aiFlags = new int[2]
    aiFlags[0] = mcmDisabledFLAG

endFunction

int function saveData()             ; Save page data and return jObject
    return jArray.object()
endFunction

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj
endFunction

function drawPage()
	int jObj = JValue.readFromDirectory(WC.MCMSettingsPath, WC.FileExt)

    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_versions</font>")
    string versionStr = MCM.WC.getiEquipVersion() as string
    MCM.AddTextOptionST("inf_txt_iEquipVersion", "$iEquip_MCM_inf_lbl_version", GetNthChar(versionStr, 0) + "." + GetNthChar(versionStr, 2) + "." + GetNthChar(versionStr, 3))
    versionStr = MCM.GetVersion() as string
	MCM.AddTextOptionST("inf_txt_iEquipMCMVersion", "$iEquip_MCM_inf_lbl_versionMCM", GetNthChar(versionStr, 0) + "." + GetNthChar(versionStr, 1) + "." + GetNthChar(versionStr, 2))
	MCM.AddTextOptionST("inf_txt_iEquipUtilVersion", "$iEquip_MCM_inf_lbl_versioniEquipUtil", SKSE.GetPluginVersion("iEquipUtil"))
    ;+++Dependency checks
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_core</font>")
    MCM.AddTextOptionST("inf_txt_SKSEVersion", "$iEquip_MCM_inf_lbl_versionSKSE", SKSE.GetVersion() + "." + SKSE.GetVersionMinor() + "." + SKSE.GetVersionBeta())
    MCM.AddTextOptionST("inf_txt_JCVersion", "$iEquip_MCM_inf_lbl_versionJC", JContainers.APIVersion() + "." + JContainers.featureVersion())
    int version = SKSE.GetPluginVersion("powerofthree's Papyrus Extender")
    if version > 0
        MCM.AddTextOptionST("inf_txt_POVersion", "$iEquip_MCM_inf_lbl_versionPO", version)
    else
        MCM.AddTextOptionST("inf_txt_POVersion", "$iEquip_MCM_inf_lbl_versionPO", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_common_notDetected")
    endIf
    if SKSE.GetPluginVersion("Ahzaab's moreHUD Inventory Plugin") > 0
        versionStr = AhzMoreHudIE.GetVersion()
        MCM.AddTextOptionST("inf_txt_moreHUDIEVersion", "$iEquip_MCM_inf_lbl_versionMoreHUDIE", GetNthChar(versionStr, 0) + "." + GetNthChar(versionStr, 2) + "." + Substring(versionStr, 3))
    else
        MCM.AddTextOptionST("inf_txt_moreHUDIEVersion", "$iEquip_MCM_inf_lbl_versionMoreHUDIE", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_common_notDetected")
    endIf
    version = SKSE.GetPluginVersion("ConsoleUtilSSE")
    if version > 0
        MCM.AddTextOptionST("inf_txt_ConsUtilVersion", "$iEquip_MCM_inf_lbl_versionConsUtil", ConsoleUtil.GetVersion())
    else
        MCM.AddTextOptionST("inf_txt_ConsUtilVersion", "$iEquip_MCM_inf_lbl_versionConsUtil", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_common_notDetected")
    endIf
    ;+++Supported mods detected
    MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_supportedMods</font>")
    int modFound = (Game.GetModByName("Adamant.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ada", "$iEquip_MCM_inf_lbl_ada", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("NewArmoury.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_aa", "$iEquip_MCM_inf_lbl_aa", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("DSerArcheryGameplayOverhaul.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ago", "$iEquip_MCM_inf_lbl_ago", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Bound Armory Extravaganza.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_bae", "$iEquip_MCM_inf_lbl_bae", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Bound Shield.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_bs", "$iEquip_MCM_inf_lbl_bs", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("DSerCombatGameplayOverhaul.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_cgo", "$iEquip_MCM_inf_lbl_cgo", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Complete Alchemy & Cooking Overhaul.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_caco", "$iEquip_MCM_inf_lbl_caco", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Enderal - Forgotten Stories.esm") != 255) as int
    MCM.AddTextOptionST("inf_txt_end", "$iEquip_MCM_inf_lbl_end", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Undriel_Everlight.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_eve", "$iEquip_MCM_inf_lbl_eve", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Gamepad++.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_gpp", "$iEquip_MCM_inf_lbl_gpp", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("LegacyoftheDragonborn.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_lotd", "$iEquip_MCM_inf_lbl_lotd", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("LootandDegradation.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ld", "$iEquip_MCM_inf_lbl_ld", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Ordinator - Perks of Skyrim.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ord", "$iEquip_MCM_inf_lbl_ord", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("The Path of Transcendence.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_pot", "$iEquip_MCM_inf_lbl_pot", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("PotionAnimatedFix.esp") != 255 || Game.GetModByName("PotionAnimatedfx.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_paf", "$iEquip_MCM_inf_lbl_paf", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("RealisticTorches.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_rt", "$iEquip_MCM_inf_lbl_rt", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Requiem.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_req", "$iEquip_MCM_inf_lbl_req", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("JZBai_ThrowingWpnsLite.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_tw", "$iEquip_MCM_inf_lbl_tw", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Thunderchild - Epic Shout Package.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_tc", "$iEquip_MCM_inf_lbl_tc", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("TorchesCastShadows.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_tcs", "$iEquip_MCM_inf_lbl_tcs", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Undeath.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ud", "$iEquip_MCM_inf_lbl_ud", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("Wintersun - Faiths of Skyrim.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_ws", "$iEquip_MCM_inf_lbl_ws", modStates[modFound], aiFlags[modFound])
    modFound = (Game.GetModByName("ZIA_Complete Pack.esp") != 255) as int
    MCM.AddTextOptionST("inf_txt_zia", "$iEquip_MCM_inf_lbl_zia", modStates[modFound], aiFlags[modFound])

	MCM.SetCursorPosition(1)
	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_presets</font>")
	MCM.AddInputOptionST("inf_inp_savepreset", "$iEquip_MCM_inf_lbl_savepreset", "")
	if jMap.count(jObj) > 0
		MCM.AddMenuOptionST("inf_men_updatepreset", "$iEquip_MCM_inf_lbl_updatepreset", "")
		MCM.AddMenuOptionST("inf_men_loadpreset", "$iEquip_MCM_inf_lbl_loadpreset", "")
		MCM.AddMenuOptionST("inf_men_deletepreset", "$iEquip_MCM_inf_lbl_deletepreset", "")
	endIf
	jValue.zeroLifetime(jObj)
	
	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_maintenance</font>")
	MCM.AddTextOptionST("inf_txt_dumpJcontainer", "$iEquip_MCM_inf_lbl_dumpJcontainer", "")
	MCM.AddTextOptionST("inf_txt_rstLayout", "$iEquip_MCM_inf_lbl_rstLayout", "")
	MCM.AddTextOptionST("inf_txt_rstMCM", "$iEquip_MCM_inf_lbl_rstMCM", "")

	MCM.AddHeaderOption("<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_mcmColours</font>")
	MCM.AddTextOptionST("inf_txt_textColour", "$iEquip_MCM_inf_lbl_textColour", asTextColourOptions[MCM.bPaperColours as int])
	MCM.AddTextOptionST("inf_txt_headerColour", "<font color='"+MCM.headerColour+"'>$iEquip_MCM_inf_lbl_headerColour</font>", "")
	MCM.AddTextOptionST("inf_txt_helpColour", "<font color='"+MCM.helpColour+"'>$iEquip_MCM_inf_lbl_helpColour</font>", "")
	MCM.AddTextOptionST("inf_txt_enabledColour", "<font color='"+MCM.enabledColour+"'>$iEquip_MCM_inf_lbl_enabledColour</font>", "")
	MCM.AddTextOptionST("inf_txt_disabledColour", "<font color='"+MCM.disabledColour+"'>$iEquip_MCM_inf_lbl_disabledColour</font>", "")
endFunction

; ########################
; ### Information Page ###
; ########################

; ------------------
; - Version Checks -
; ------------------

State inf_txt_JCVersion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_JCVersion")
        endIf 
    endEvent
endState

State inf_txt_POVersion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_POVersion")
        endIf 
    endEvent
endState

State inf_txt_moreHUDIEVersion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_moreHUDIEVersion")
        endIf 
    endEvent
endState

State inf_txt_ConsUtilVersion
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ConsUtilVersion")
        endIf 
    endEvent
endState

; ------------------
; - Supported Mods -
; ------------------

State inf_txt_ada
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ada")
        endIf 
    endEvent
endState

State inf_txt_aa
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_aa")
        endIf 
    endEvent
endState

State inf_txt_ago
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ago")
        endIf 
    endEvent
endState

State inf_txt_bae
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_bae")
        endIf 
    endEvent
endState

State inf_txt_bs
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_bs")
        endIf 
    endEvent
endState

State inf_txt_cgo
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_cgo")
        endIf 
    endEvent
endState

State inf_txt_caco
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_caco")
        endIf 
    endEvent
endState

State inf_txt_end
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_end")
        endIf 
    endEvent
endState

State inf_txt_eve
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_eve")
        endIf 
    endEvent
endState

State inf_txt_gpp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_gpp")
        endIf 
    endEvent
endState

State inf_txt_lotd
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_lotd")
        endIf 
    endEvent
endState

State inf_txt_ld
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ld")
        endIf 
    endEvent
endState

State inf_txt_ord
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ord")
        endIf 
    endEvent
endState

State inf_txt_pot
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_pot")
        endIf 
    endEvent
endState

State inf_txt_paf
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_paf")
        endIf 
    endEvent
endState

State inf_txt_rt
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_rt")
        endIf 
    endEvent
endState

State inf_txt_req
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_req")
        endIf 
    endEvent
endState

State inf_txt_tw
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_tw")
        endIf 
    endEvent
endState

State inf_txt_tc
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_tc")
        endIf 
    endEvent
endState

State inf_txt_tcs
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_tcs")
        endIf 
    endEvent
endState

State inf_txt_ud
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ud")
        endIf 
    endEvent
endState

State inf_txt_ws
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_ws")
        endIf 
    endEvent
endState

State inf_txt_zia
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_zia")
        endIf 
    endEvent
endState


; -----------
; - Presets -
; -----------

State inf_inp_savepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_savepreset")
        elseIf currentEvent == "Open"
			MCM.SetInputDialogStartText(iEquip_StringExt.LocalizeString("$iEquip_MCM_inf_lbl_PresetName"))
        elseIf currentEvent == "Accept"
			MCM.savePreset(currentStrVar)
			MCM.ForcePageReset()
        endIf 
    endEvent
endState

State inf_men_updatepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_updatepreset")
        elseIf currentEvent == "Open"
			saPresets = MCM.getPresets("$iEquip_MCM_inf_lbl_noUpdate")
			MCM.fillMenu(0, saPresets, 0)
        elseIf currentEvent == "Accept"
			if (currentVar as int > 0)
				MCM.updatePreset(saPresets[currentVar as int])
			endIf
        endIf 
    endEvent
endState

State inf_men_loadpreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_loadpreset")
        elseIf currentEvent == "Open"
			saPresets = MCM.getPresets("$iEquip_MCM_inf_lbl_noLoad")
			MCM.fillMenu(0, saPresets, 0)
        elseIf currentEvent == "Accept"
			if (currentVar as int > 0)
				MCM.loadPreset(saPresets[currentVar as int])
				MCM.ForcePageReset()
			endIf
        endIf 
    endEvent
endState

State inf_men_deletepreset
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_deletepreset")
        elseIf currentEvent == "Open"
			saPresets = MCM.getPresets("$iEquip_MCM_inf_lbl_noDelete")
			MCM.fillMenu(0, saPresets, 0)
        elseIf currentEvent == "Accept"
			if (currentVar as int > 0)
				MCM.deletePreset(saPresets[currentVar as int])
				MCM.ForcePageReset()
			endIf
        endIf 
    endEvent
endState

; ---------------
; - Maintenance -
; ---------------

State inf_txt_dumpJcontainer
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_dumpJcontainer")
        elseIf currentEvent == "Select"
			jValue.writeTofile(WC.iEquipQHolderObj, "Data/iEquip/Debug/JCDebug.json")
			MCM.ShowMessage("$iEquip_MCM_inf_msg_queuesSavedToFile")
        endIf 
    endEvent
endState

State inf_txt_rstLayout
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_rstLayout")
        elseIf (currentEvent == "Select" && MCM.ShowMessage("$iEquip_MCM_inf_msg_rstLayout", true, "$iEquip_MCM_common_reset", "$iEquip_MCM_common_cancel"))
			if (MCM.bBusy)
				MCM.ShowMessage("$iEquip_common_LoadPresetBusy")
			else
				int jObj = JValue.readFromDirectory(WC.WidgetPresetPath, WC.FileExtDef)
				int jPreset = JMap.getObj(jObj, JMap.getNthKey(jObj, 0))

				if (jMap.getInt(jPreset, "Version") != EM.GetVersion())
					MCM.ShowMessage("$iEquip_common_LoadPresetError")
				else
					MCM.bBusy = true
					
					EM.LoadPreset(jPreset)
					
					MCM.bBusy = false
				endIf
			
				jValue.zeroLifetime(jObj)
			endIf
        endIf 
    endEvent
endState

State inf_txt_rstMCM
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_rstMCM")
        elseIf (currentEvent == "Select" && MCM.ShowMessage("$iEquip_MCM_inf_msg_rstMCM", true, "$iEquip_MCM_common_reset", "$iEquip_MCM_common_cancel"))
			int jObj = JValue.readFromDirectory(WC.MCMSettingsPath, WC.FileExtDef)
			string[] tmpStrArr = jMap.allKeysPArray(jObj)
			jValue.zeroLifetime(jObj)
			MCM.loadPreset(tmpStrArr[0], true)
        endIf 
    endEvent
endState

State inf_txt_textColour
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_inf_txt_textColours")
        elseIf currentEvent == "Select"
            MCM.bPaperColours = !MCM.bPaperColours
            MCM.ForcePageReset()
        endIf 
    endEvent
endState
