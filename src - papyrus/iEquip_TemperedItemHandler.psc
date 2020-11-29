scriptname iEquip_TemperedItemHandler extends quest

import UI
import UICallback
Import WornObject
import iEquip_InventoryExt

iEquip_WidgetCore Property WC Auto

Actor Property PlayerRef Auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

string[] asTemperLevelNames
string[] asDamagedLevelNames
string[] asDamagedLevelNamesDefault
float[] afDamageLevelMax
float[] afTemperLevelMax
int[] property aiTemperedItemTypes auto hidden

string[] property asNamePaths auto hidden
int[] property aiNameElements auto hidden

; MCM Properties
bool property bFadeIconOnDegrade = true auto hidden
int property iTemperNameFormat = 1 auto hidden
bool property bUseAltTemperLevelNames auto hidden
bool property bTemperInfoBelowName auto hidden
int property iColoredIconStyle = 1 auto Hidden
int property iColoredIconLevels = 1 auto hidden
bool property bShowTemperTierIndicator auto hidden
int property iTemperTierDisplayChoice = 0 auto hidden
bool property bShowFadedTiers = true auto hidden

bool bFirstRun = true
bool bUpdate = true
bool bOriginalLevelNamesArrayCreated

bool bLootAndDegradationLoaded
_edquestscript property LDQuest auto

function initialise()
	;debug.trace("iEquip_TemperedItemHandler initialise start")

	WidgetRoot = WC.WidgetRoot

	bLootAndDegradationLoaded = Game.GetModByName("LootandDegradation.esp") != 255
	if bLootAndDegradationLoaded
		LDQuest = Quest.GetQuest("_EDQuest") as _edquestscript
	endIf

	if bFirstRun || bUpdate
		afTemperLevelMax = new float[6]
		
		asTemperLevelNames = new string[7]
		asTemperLevelNames[0] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Honed")

		asDamagedLevelNames = new string[5]
		asDamagedLevelNames[0] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Ruined")
		asDamagedLevelNames[1] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Broken")
		asDamagedLevelNames[2] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Damaged")
		asDamagedLevelNames[3] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Chipped")
		asDamagedLevelNames[4] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Blemished")

		asDamagedLevelNamesDefault = asDamagedLevelNames

		afDamageLevelMax = new float[5]
		afDamageLevelMax[0] = 0.2
		afDamageLevelMax[1] = 0.4
		afDamageLevelMax[2] = 0.6
		afDamageLevelMax[3] = 0.8
		afDamageLevelMax[4] = 0.95
		
		asNamePaths = new string[7]
		asNamePaths[0] = ".widgetMaster.LeftHandWidget.leftName_mc.leftName.text"
		asNamePaths[1] = ".widgetMaster.RightHandWidget.rightName_mc.rightName.text"
		asNamePaths[5] = ".widgetMaster.LeftHandWidget.leftPreselectName_mc.leftPreselectName.text"
		asNamePaths[6] = ".widgetMaster.RightHandWidget.rightPreselectName_mc.rightPreselectName.text"

		aiNameElements = new int[7]
		aiNameElements[0] = 8
		aiNameElements[1] = 25
		aiNameElements[5] = 20
		aiNameElements[6] = 37
		
		aiTemperedItemTypes = new int[9]
		aiTemperedItemTypes[0] = 1		; Swords
		aiTemperedItemTypes[1] = 2		; Daggers
		aiTemperedItemTypes[2] = 3		; War Axes
		aiTemperedItemTypes[3] = 4		; Maces
		aiTemperedItemTypes[4] = 5		; Greatswords
		aiTemperedItemTypes[5] = 6		; Battleaxes & Warhammers
		aiTemperedItemTypes[6] = 7		; Bows
		aiTemperedItemTypes[7] = 9		; Crossbows
		aiTemperedItemTypes[8] = 26		; Shields
		
		bFirstRun = false
		bUpdate = false
	endIf

	updateTemperLevelArrays()
	
	;debug.trace("iEquip_TemperedItemHandler initialise end")
endFunction

function onVersionUpdate()
	aiNameElements[1] = 25
	aiNameElements[5] = 20
	aiNameElements[6] = 37
endFunction

function updateTemperLevelArrays()
	;debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays start")
	int i = 1
	int j
	string sValue
	string sName

	if !bUseAltTemperLevelNames
		asTemperLevelNames[0] = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Honed")
	endIf

	while i < 7

		if !bUseAltTemperLevelNames
			sName = "sHealthDataPrefixWeap" + i as string
			asTemperLevelNames[i] = Game.GetGameSettingString(sName)
		endIf

		j = i - 1
		sValue = "fHealthDataValue" + i as string
		afTemperLevelMax[j] = Game.GetGameSettingFloat(sValue)

		i += 1
	endWhile

	; Next section is for debugging only, comment out when testing is complete
	;debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level 0, range: 1.0 - " + afTemperLevelMax[0] + " (Untempered)")
	;i = 1
	;while i < 6
		;j = i - 1
		;debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level " + i + ", range: " + afTemperLevelMax[j] + " - " + afTemperLevelMax[i] + ", level name: " + asTemperLevelNames[i])
		;i += 1
	;endWhile
	;debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level 6, range: " + afTemperLevelMax[5] + "+, level name: " + asTemperLevelNames[6])
	;debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays end")
endFunction

string function getTemperLevelName(int level)
	return asTemperLevelNames[level]
endFunction

function setCustomTemperLevelName(int level, string newName)
	if newName != "" || level == 0 		; Allow users to set an empty string only for the 'Honed' level (1.0-1.1) in case they don't want a mismatch between the widget and the Inventory menu
		asTemperLevelNames[level] = newName
	endIf
endFunction

string function getDamageLevelName(int level)
	return asDamagedLevelNames[level]
endFunction

int function getDamageLevelMax(int level)
	return (afDamageLevelMax[level] * 100) as int
endFunction

string function getDefaultDamageLevelName(int level)
	return asDamagedLevelNamesDefault[level]
endFunction

function setCustomDamageLevelName(int level, string newName)
	asDamagedLevelNames[level] = newName
endFunction

function resetDefaultDamageLevelNames()
	asDamagedLevelNames = asDamagedLevelNamesDefault
endFunction

function checkAndUpdateTemperLevelInfo(int Q)
	;debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo start - Q: " + Q)

	int targetObject = jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q])

	if aiTemperedItemTypes.Find(jMap.getInt(targetObject, "iEquipType")) != -1
		
		string temperLevelName
		int currentTemperLevelPercent = 100 		; Fully white. Change below if required
		float fItemHealth
		
		if Q == 0 && PlayerRef.GetEquippedShield()
			fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 512)
		else
			fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 0)
		endIf

		;debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo - fItemHealth: " + fItemHealth)
		
		int i

		if fItemHealth < 1.0						; First check if the item is degraded below vanilla 1.0 (only mods like Item Durability and Loot & Degradation do this)
			while i < 5 && fItemHealth > afDamageLevelMax[i]
				i += 1
			endWhile
			if i < 5
				temperLevelName = asDamagedLevelNames[i]
			endIf
			currentTemperLevelPercent = Round(fItemHealth * 100)

			i = 0

			; Added support for multiple damage levels mirroring Item Durability's damaged tiers - "0;0.2;Ruined;0.2;0.4;Broken;0.4;0.6;Damaged;0.6;0.8;Chipped;0.8;0.95;Blemished" - tier names can be changed through the MCM

		elseIf fItemHealth == 1.0 || afTemperLevelMax.Find(fItemHealth) != -1
			if fItemHealth != 1.0					; If it's 1.0 (Untempered) we don't need to set a temperLevelName string, otherwise if it matches exactly one of the other tier values set the name
				i = afTemperLevelMax.Find(fItemHealth) + 1
				temperLevelName = asTemperLevelNames[i]
			endIf

		else 					 					; Otherwise find which level range it is currently within
													
			while i < 6 && fItemHealth >= afTemperLevelMax[i]
				i += 1
			endWhile
			
			temperLevelName = asTemperLevelNames[i] ; Retrieve the temper level string
			
			if i < 6								; If it has been tempered to Legendary (6) leave the icon set at fully white, otherwise calculate the current % value within the level range and retrieve the temper level string
				float TemperLevelMin = 1.0
				if i > 0
					int j = i - 1
					TemperLevelMin = afTemperLevelMax[j]
				endIf
				
				if bLootAndDegradationLoaded && !WC.bIsRequiemLoaded && LDQuest.DecayChance > 0 			; If Loot & Degradation is loaded, and it's degradation feature is enabled, and we're not using Requiem use L&D's micro counter to set the % so it matches L&D
					currentTemperLevelPercent = Round((fItemHealth - ((fItemHealth * 10.0) as Int / 10.0)) / 0.00099 * 100.0)
					if currentTemperLevelPercent > 100
						float tmpVal = currentTemperLevelPercent / 100
						currentTemperLevelPercent = Round((tmpVal - (tmpVal as int)) * 100)
					endIf
				else 																						; Otherwise use the actual item health % within the current tier
					currentTemperLevelPercent = Round((fItemHealth - TemperLevelMin) / (afTemperLevelMax[i] - TemperLevelMin) * 100)
				endIf
			endIf
		endIf

		;debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo start - temperLevelName: " + temperLevelName + ", currentTemperLevelPercent: " + currentTemperLevelPercent + "%")
		updateIcon(Q, currentTemperLevelPercent, targetObject)
		setTemperLevelName(Q, fItemHealth, temperLevelName, currentTemperLevelPercent, targetObject)
		jMap.setInt(targetObject, "lastKnownItemHealth", currentTemperLevelPercent)
		updateTemperTierIndicator(Q, i)
		jMap.setInt(targetObject, "lastKnownTemperTier", i)
	
	endIf
	;debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo end")
endFunction

function updateIcon(int Q, int temperLevelPercent, int targetObject)
	;debug.trace("iEquip_TemperedItemHandler updateIcon start - Q: " + Q + ", " + temperLevelPercent + "%")

	string newIcon = jMap.getStr(targetObject, "iEquipBaseIcon")	; Retrieve the original base icon name
	int temperLvl = RoundToTens(temperLevelPercent)

	;debug.trace("iEquip_TemperedItemHandler updateIcon - checking we've got a value rounded to the nearest 10, temperLvl: " + temperLvl)

	if WC.aUniqueItems.Find(jMap.getForm(targetObject, "iEquipForm") as weapon) == -1
		if bFadeIconOnDegrade && temperLvl < 100																		; If we have enabled icon fade on degrade
			newIcon += temperLvl as string																				; First append the current item percent rounded to the nearest 10%

			if iColoredIconStyle > 0 && temperLvl < 50																	; Now if we've enabled coloured icons and item health rounded to tens is 40% or below

				if (iColoredIconLevels == 0 && temperLevelPercent < 41 && temperLevelPercent > 20) || (iColoredIconLevels == 1  && temperLevelPercent < 31 && temperLevelPercent > 20) || (iColoredIconLevels == 2  && temperLevelPercent < 31 && temperLevelPercent > 10) || (iColoredIconLevels == 3 && temperLevelPercent < 21 && temperLevelPercent > 10)	; Check the level setting and append the 'a' for amber level
					newIcon += "a"
				elseIf (temperLvl < 30 && iColoredIconLevels < 2 && temperLevelPercent < 21) || (temperLvl < 20 && iColoredIconLevels > 1 && temperLevelPercent < 11)			; Or 'r' for red level
					newIcon += "r"
				endIf

				if iColoredIconStyle == 2																				; And finally if we've selected to colour the full icon and not just the unfaded lower section append 'f' for full
					newIcon += "f"
				endIf

			endIf
		endIf
	endIf

	if newIcon != jMap.getStr(targetObject, "iEquipIcon")

		;debug.trace("iEquip_TemperedItemHandler updateIcon - about to update the icon to: " + newIcon)

		jMap.setStr(targetObject, "iEquipIcon", newIcon)				; Update the icon name in the queue object so it shows correctly while cycling (it'll be updated again at next equip)

		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIcon")											; And update the widget
		if(iHandle)
			;debug.trace("iEquip_TemperedItemHandler updateIcon - got iHandle")
			UICallback.PushInt(iHandle, Q)
			UICallback.PushString(iHandle, newIcon)
			UICallback.Send(iHandle)
		endIf

	endIf
	;debug.trace("iEquip_TemperedItemHandler setTemperLevelFade end")
endFunction

function updateTemperTierIndicator(int Q, int tier = 0)
	;debug.trace("iEquip_TemperedItemHandler updateTemperTierIndicator start - Q: " + Q + ", tier: " + tier + ", bShowTemperTierIndicator: " + bShowTemperTierIndicator + ", iTemperTierDisplayChoice: " + iTemperTierDisplayChoice + ", bShowFadedTiers: " + bShowFadedTiers + ", Edit Mode: " + WC.EM.isEditMode)
	if !bShowTemperTierIndicator && !WC.EM.isEditMode
		tier = 0
	endIf

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateTemperTierIndicator")
	if(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, tier)
		UICallback.PushInt(iHandle, iTemperTierDisplayChoice)
		UICallback.PushBool(iHandle, bShowFadedTiers)
		UICallback.Send(iHandle)
	endIf
	;debug.trace("iEquip_TemperedItemHandler updateTemperTierIndicator end")
endFunction

function setTemperLevelName(int Q, float fItemHealth, string temperLevelName, int temperLevelPercent, int targetObject)
	;debug.trace("iEquip_TemperedItemHandler setTemperLevelName start - Q: " + Q + ", " + temperLevelName)
	
	string tempName = jMap.getStr(targetObject, "iEquipBaseName")
	bool isLegendary = temperLevelName == asTemperLevelNames[6]
	
	if tempName != ""
		if temperLevelName == ""
			jMap.setStr(targetObject, "temperedNameForQueueMenu", tempName)
		else
			jMap.setStr(targetObject, "temperedNameForQueueMenu", tempName + " (" + temperLevelName + ")")
		endIf
		
		if iTemperNameFormat > 0 && temperLevelName != ""												; Iron Sword
			
			if iTemperNameFormat < 9 && bTemperInfoBelowName
				if iTemperNameFormat == 1 || (isLegendary && iTemperNameFormat == 2)					; Iron Sword
					tempName = tempName + "\n(" + temperLevelName + ")"									; (Fine)

				elseIf iTemperNameFormat == 2															; Iron Sword
					tempName = tempName + "\n(" + temperLevelName + ", " + temperLevelPercent + "%)"	; (Fine, 60%)

				elseIf iTemperNameFormat == 3 || iTemperNameFormat == 6	|| isLegendary					; Iron Sword
					tempName = tempName + "\n" + temperLevelName										; Fine

				elseIf iTemperNameFormat == 4 || iTemperNameFormat == 7									; Iron Sword
					tempName = tempName + "\n" + temperLevelName + " (" + temperLevelPercent + "%)"		; Fine (60%)

				elseIf iTemperNameFormat == 5															; Iron Sword
					tempName = tempName + "\n" + temperLevelName + ", " + temperLevelPercent + "%"		; Fine, 60%

				elseIf iTemperNameFormat == 8															; Iron Sword
					tempName = tempName + "\n" + temperLevelName + " - " + temperLevelPercent + "%" 	; Fine - 60%
				endIf
			else
				if iTemperNameFormat == 1 || (isLegendary && iTemperNameFormat == 2)
					tempName = tempName + " (" + temperLevelName + ")"									; Iron Sword (Fine)
				elseIf iTemperNameFormat == 2
					tempName = tempName + " (" + temperLevelName + ", " + temperLevelPercent + "%)"		; Iron Sword (Fine, 60%)
				elseIf iTemperNameFormat == 3 || (isLegendary && iTemperNameFormat < 6)
					tempName = tempName + " - " + temperLevelName										; Iron Sword - Fine
				elseIf iTemperNameFormat == 4
					tempName = tempName + " - " + temperLevelName + " (" + temperLevelPercent + "%)"	; Iron Sword - Fine (60%)
				elseIf iTemperNameFormat == 5
					tempName = tempName + " - " + temperLevelName + ", " + temperLevelPercent + "%"		; Iron Sword - Fine, 60%
				elseIf iTemperNameFormat == 6 || (isLegendary && iTemperNameFormat < 9)
					tempName = tempName + ", " + temperLevelName										; Iron Sword, Fine
				elseIf iTemperNameFormat == 7
					tempName = tempName + ", " + temperLevelName + " (" + temperLevelPercent + "%)"		; Iron Sword, Fine (60%)
				elseIf iTemperNameFormat == 8
					tempName = tempName + ", " + temperLevelName + " - " + temperLevelPercent + "%"		; Iron Sword, Fine - 60%
				elseIf iTemperNameFormat == 9 || isLegendary
					tempName = temperLevelName + " " + tempName											; Fine Iron Sword
				elseIf iTemperNameFormat == 10
					tempName = temperLevelName + " " + tempName	+ " (" + temperLevelPercent + "%)"		; Fine Iron Sword (60%)
				elseIf iTemperNameFormat == 11
					tempName = temperLevelName + " " + tempName	+ ", " + temperLevelPercent + "%"		; Fine Iron Sword, 60%
				else
					tempName = temperLevelName + " " + tempName	+ " - " + temperLevelPercent + "%"		; Fine Iron Sword - 60%
				endIf
			endIf
		endIf
		
		if tempName != jMap.getStr(targetObject, "lastDisplayedName")
			
			;debug.trace("iEquip_TemperedItemHandler setTemperLevelName - setting name string to `" + tempName + "`")
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateDisplayedText")
			If(iHandle)
				UICallback.PushInt(iHandle, aiNameElements[Q])
				UICallback.PushString(iHandle, tempName)
				UICallback.Send(iHandle)
			endIf
			jMap.setStr(targetObject, "lastDisplayedName", tempName)
		endIf

	endIf
	;debug.trace("iEquip_TemperedItemHandler setTemperLevelName end")
endFunction

int function Round(float i)
	if (i - (i as int)) < 0.5
		return (i as int)
	endIf
	return Math.Ceiling(i)
endFunction

int Function RoundToTens(int i)
    int rounded = i % 10
    
    if rounded >= 5
        return (i + 10 - rounded)
    endIf
    return (i - rounded)
endFunction
