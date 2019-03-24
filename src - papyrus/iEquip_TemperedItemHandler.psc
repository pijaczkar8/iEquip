scriptname iEquip_TemperedItemHandler extends quest

import UI
import UICallback
Import WornObject

iEquip_WidgetCore Property WC Auto

Actor Property PlayerRef Auto

string HUD_MENU = "HUD Menu"
string WidgetRoot

string[] asTemperLevelNames
float[] afTemperLevelMax
int[] property aiTemperedItemTypes auto hidden

string[] property asNamePaths auto hidden

; MCM Properties
bool property bFadeIconOnDegrade = true auto hidden
int property iTemperNameFormat = 1 auto hidden
int property iColoredIconStyle = 1 auto Hidden
int property iColoredIconLevels = 1 auto hidden

bool bFirstRun = true

function initialise()
	debug.trace("iEquip_TemperedItemHandler initialise start")

	WidgetRoot = WC.WidgetRoot

	if bFirstRun
		afTemperLevelMax = new float[6]
		afTemperLevelMax[0] = 1.0					; Untempered - same value in vanilla and Requiem, no reason to think any other mod would change it from 1.0 (100% of normal base health)
		
		asTemperLevelNames = new string[7]
		
		asNamePaths = new string[7]
		asNamePaths[0] = ".widgetMaster.LeftHandWidget.leftName_mc.leftName.text"
		asNamePaths[1] = ".widgetMaster.RightHandWidget.rightName_mc.rightName.text"
		asNamePaths[5] = ".widgetMaster.LeftHandWidget.leftPreselectName_mc.leftPreselectName.text"
		asNamePaths[6] = ".widgetMaster.RightHandWidget.rightPreselectName_mc.rightPreselectName.text"
		
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
	endIf
	
	updateTemperLevelArrays()
	
	debug.trace("iEquip_TemperedItemHandler initialise end")
endFunction

function updateTemperLevelArrays()
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays start")
	int i = 1
	int j
	string sValue
	string sName
	while i < 7

		sName = "sHealthDataPrefixWeap" + i as string
		asTemperLevelNames[i] = Game.GetGameSettingString(sName)

		if i > 1
			j = i - 1
			sValue = "fHealthDataValue" + i as string
			afTemperLevelMax[j] = Game.GetGameSettingFloat(sValue)
		endIf

		debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level " + i + ", maxValue: " + afTemperLevelMax[j] + ", level name: " + asTemperLevelNames[i])
		i += 1
	endWhile
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays end")
endFunction

;/int function getTemperLevelPercent(int Q, float fItemHealth)
	debug.trace("iEquip_TemperedItemHandler getTemperLevelPercent start - Q: " + Q)
	int currentTemperLevelPercent
	
	if fItemHealth > afTemperLevelMax[0] 	; First check if the item has been improved

		int i = 1 							; Now if it has find which level range it is currently within
		while fItemHealth > afTemperLevelMax[i] && i < 7
			i += 1
		endWhile
		
		if i == 7 							; If it has been tempered past Legendary set it to full
			currentTemperLevelPercent = 100
		else								; Otherwise calculate the current % value within the level range
			int j = i - 1
			currentTemperLevelPercent = Round((fItemHealth - afTemperLevelMax[j]) / (afTemperLevelMax[i] - afTemperLevelMax[j]) * 100)
		endIf
	else									; Untempered
		currentTemperLevelPercent = 100
	endIf
	debug.trace("iEquip_TemperedItemHandler getTemperLevelPercent - returning: " + currentTemperLevelPercent + "%")
	return currentTemperLevelPercent
endFunction

string function gettemperLevelName(int Q, float fItemHealth)
	debug.trace("iEquip_TemperedItemHandler gettemperLevelName start - Q: " + Q)
	string temperLevelName
	
	if fItemHealth > afTemperLevelMax[0] 	; First check if the item has been improved

		int i = 1 							; Now if it has find which level range it is currently within
		while fItemHealth > afTemperLevelMax[i] && i < 7
			i += 1
		endWhile
		
		if i == 7 							; If it has been tempered past Legendary suffix it Legendary+ (or whatever the upper level name happens to be)
			temperLevelName = asTemperLevelNames[5] + "+"
		else 								; Otherwise retrieve the temper level string
			temperLevelName = asTemperLevelNames[i]
		endIf
	
	else									; Untempered
		temperLevelName = ""
	endIf
	debug.trace("iEquip_TemperedItemHandler gettemperLevelName - returning: " + temperLevelName)
	return temperLevelName
endFunction/;

function checkAndUpdateTemperLevelInfo(int Q)
	debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo start - Q: " + Q)

	if aiTemperedItemTypes.Find(jMap.getInt(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipType")) != -1
		
		string temperLevelName
		int currentTemperLevelPercent
		float fItemHealth
		
		if Q == 0 && PlayerRef.GetEquippedShield()
			fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 512)
		else
			fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 0)
		endIf

		debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo - fItemHealth: " + fItemHealth)
		
		if fItemHealth < afTemperLevelMax[0]		; First check if the item is degraded below vanilla 1.0 (only mods like Loot & Degradation do this)
			temperLevelName = iEquip_StringExt.LocalizeString("$iEquip_TI_lbl_Damaged")
			currentTemperLevelPercent = Round(fItemHealth * 100)

		elseIf fItemHealth > afTemperLevelMax[0] 	; Next check if the item has been improved

			int i = 1								; Now if it has find which level range it is currently within
			while fItemHealth > afTemperLevelMax[i] && i < 6
				i += 1
			endWhile
			
			temperLevelName = asTemperLevelNames[i]
			
			if i == 6								; If it has been tempered to Legendary set it to full
				currentTemperLevelPercent = 100
			else 									; Otherwise calculate the current % value within the level range and retrieve the temper level string
				int j = i - 1
				currentTemperLevelPercent = Round((fItemHealth - afTemperLevelMax[j]) / (afTemperLevelMax[i] - afTemperLevelMax[j]) * 100)
			endIf
		
		else										; Untempered
			temperLevelName = ""
			currentTemperLevelPercent = 100
		endIf

		debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo start - temperLevelName: " + temperLevelName + ", currentTemperLevelPercent: " + currentTemperLevelPercent + "%")

		updateIcon(Q, currentTemperLevelPercent)
		setTemperLevelName(Q, fItemHealth, temperLevelName, currentTemperLevelPercent)
		jMap.setInt(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "lastKnownItemHealth", currentTemperLevelPercent)
	
	endIf
	debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo end")
endFunction

function updateIcon(int Q, int temperLevelPercent)
	debug.trace("iEquip_TemperedItemHandler updateIcon start - Q: " + Q + ", " + temperLevelPercent + "%")
	
	string newIcon = jMap.getStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipBaseIcon")	; Retrieve the original base icon name
	int temperLvl = RoundToTens(temperLevelPercent)

	debug.trace("iEquip_TemperedItemHandler updateIcon - checking we've got a value rounded to the nearest 10, temperLvl: " + temperLvl)

	if bFadeIconOnDegrade																							; If we have enabled icon fade on degrade
		newIcon += temperLvl as string																				; First append the current item percent rounded to the nearest 10%

		if iColoredIconStyle > 0 && temperLvl < 50																	; Now if we've enabled coloured icons and item health rounded to tens is 40% or below

			if (temperLvl == 40 && iColoredIconLevels == 0) || (temperLvl == 30 &&  iColoredIconLevels < 3) || (temperLvl == 20 &&  iColoredIconLevels == 3)	; Check the level setting and append the 'a' for amber level
				newIcon += "a"
			elseIf (temperLvl < 30 && iColoredIconLevels < 2) || (temperLvl < 20 && iColoredIconLevels > 1)			; Or 'r' for red level
				newIcon += "r"
			endIf

			if iColoredIconStyle == 2																				; And finally if we've selected to colour the full icon and not just the unfaded lower section append 'f' for full
				newIcon += "f"
			endIf

		endIf
	endIf

	jMap.setStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipIcon", newIcon)				; Update the icon name in the queue object so it shows correctly while cycling (it'll be updated again at next equip)

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIcon")											; And update the widget
	if(iHandle)
		debug.trace("iEquip_TemperedItemHandler updateIcon - got iHandle")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushString(iHandle, newIcon)
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_TemperedItemHandler setTemperLevelFade end")
endFunction

function setTemperLevelName(int Q, float fItemHealth, string temperLevelName, int temperLevelPercent)
	debug.trace("iEquip_TemperedItemHandler setTemperLevelName start - Q: " + Q + ", " + temperLevelName)
	
	string tempName = jMap.getStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipBaseName")
	
	if temperLevelName == ""
		jMap.setStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "temperedNameForQueueMenu", tempName)
	else
		jMap.setStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "temperedNameForQueueMenu", tempName + " (" + temperLevelName + ")")
	endIf
	
	if iTemperNameFormat > 0 && temperLevelName != ""											; Iron Sword
		if iTemperNameFormat == 1
			tempName = tempName + " (" + temperLevelName + ")"									; Iron Sword (Fine)
		elseIf iTemperNameFormat == 2
			tempName = tempName + " (" + temperLevelName + ", " + temperLevelPercent + "%)"		; Iron Sword (Fine, 60%)
		elseIf iTemperNameFormat == 3
			tempName = tempName + " - " + temperLevelName										; Iron Sword - Fine
		elseIf iTemperNameFormat == 4
			tempName = tempName + " - " + temperLevelName + " (" + temperLevelPercent + "%)"	; Iron Sword - Fine (60%)
		elseIf iTemperNameFormat == 5
			tempName = tempName + " - " + temperLevelName + " ," + temperLevelPercent + "%"		; Iron Sword - Fine, 60%
		elseIf iTemperNameFormat == 6
			tempName = tempName + ", " + temperLevelName										; Iron Sword, Fine
		elseIf iTemperNameFormat == 7
			tempName = tempName + ", " + temperLevelName + " (" + temperLevelPercent + "%)"		; Iron Sword, Fine (60%)
		elseIf iTemperNameFormat == 8
			tempName = tempName + ", " + temperLevelName + " - " + temperLevelPercent + "%"		; Iron Sword, Fine - 60%
		elseIf iTemperNameFormat == 9	
			tempName = temperLevelName + " " + tempName											; Fine Iron Sword
		elseIf iTemperNameFormat == 10
			tempName = temperLevelName + " " + tempName	+ " (" + temperLevelPercent + "%)"		; Fine Iron Sword (60%)
		elseIf iTemperNameFormat == 11
			tempName = temperLevelName + " " + tempName	+ ", " + temperLevelPercent + "%"		; Fine Iron Sword, 60%
		else
			tempName = temperLevelName + " " + tempName	+ " - " + temperLevelPercent + "%"		; Fine Iron Sword - 60%
		endIf
	endIf
	debug.trace("iEquip_TemperedItemHandler setTemperLevelName - setting name string to `" + tempName + "`")
	UI.SetString(HUD_MENU, WidgetRoot + asNamePaths[Q], tempName)
	jMap.setStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "lastDisplayedName", tempName)
	debug.trace("iEquip_TemperedItemHandler setTemperLevelName end")
endFunction

int function Round(float i)
	if (i - (i as int)) < 0.5
		return (i as int)
	else
		return (Math.Ceiling(i) as int)
	endIf
endFunction

int Function RoundToTens(int i)
	float j = i / 10
	if (j - (j as int)) < 0.5
		return (j as int) * 10
	else
		return (Math.Ceiling(j) as int) * 10
	endIf
EndFunction
