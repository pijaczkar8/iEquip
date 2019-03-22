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

bool bFirstRun = true

function initialise()
	debug.trace("iEquip_TemperedItemHandler OnInit start")

	WidgetRoot = WC.WidgetRoot

	if bFirstRun
		afTemperLevelMax = new float[7]
		afTemperLevelMax[0] = 1.0					; Untempered - same value in vanilla and Requiem, no reason to think any other mod would change it from 1.0 (100% of normal base health)
		
		asTemperLevelNames = new string[7]
		
		asNamePaths = new string[7]
		asNamePaths[0] = ".widgetMaster.LeftHandWidget.leftName_mc.leftName.text"
		asNamePaths[1] = ".widgetMaster.LeftHandWidget.leftPreselectName_mc.leftPreselectName.text"
		asNamePaths[5] = ".widgetMaster.RightHandWidget.rightName_mc.rightName.text"
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
	
	debug.trace("iEquip_TemperedItemHandler OnInit end")
endFunction

function updateTemperLevelArrays()
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays start")
	int i = 1
	string sValue
	string sName
	while i < 7
		sValue = "fHealthDataValue" + i as string
		sName = "sHealthDataPrefixWeap" + i as string
		afTemperLevelMax[i] = Game.GetGameSettingFloat(sValue)
		asTemperLevelNames[i] = Game.GetGameSettingString(sName)
		debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level " + i + ", maxValue: " + afTemperLevelMax[i] + ", level name: " + asTemperLevelNames[i])
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
		float fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 0)

		debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo - fItemHealth: " + fItemHealth)
		
		if fItemHealth > afTemperLevelMax[0] 	; First check if the item has been improved

			int i = 1 							; Now if it has find which level range it is currently within
			while fItemHealth > afTemperLevelMax[i] && i < 7
				i += 1
			endWhile
			
			if i == 7 							; If it has been tempered past Legendary set it to full and suffix it Legendary+
				temperLevelName = asTemperLevelNames[5] + "+"
				currentTemperLevelPercent = 100
			else 								; Otherwise calculate the current % value within the level range and retrieve the temper level string
				int j = i - 1
				currentTemperLevelPercent = Round((fItemHealth - afTemperLevelMax[j]) / (afTemperLevelMax[i] - afTemperLevelMax[j]) * 100)
				temperLevelName = asTemperLevelNames[i]
			endIf
		
		else									; Untempered
			temperLevelName = ""
			currentTemperLevelPercent = 100
		endIf

		debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo start - temperLevelName: " + temperLevelName + ", currentTemperLevelPercent: " + currentTemperLevelPercent + "%")

		if bFadeIconOnDegrade
			setTemperLevelFade(Q, currentTemperLevelPercent)
		endIf
		setTemperLevelName(Q, temperLevelName, currentTemperLevelPercent)
		jMap.setInt(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "lastKnownItemHealth", currentTemperLevelPercent)
	
	endIf
	debug.trace("iEquip_TemperedItemHandler checkAndUpdateTemperLevelInfo end")
endFunction

function setTemperLevelFade(int Q, int temperLevelPercent, bool force = false)
	debug.trace("iEquip_TemperedItemHandler setTemperLevelFade start - Q: " + Q + ", " + temperLevelPercent + "%")
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setTemperFade")
	if(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, temperLevelPercent)
		UICallback.PushBool(iHandle, force)
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_TemperedItemHandler setTemperLevelFade end")
endFunction

function setTemperLevelName(int Q, string temperLevelName, int temperLevelPercent)
	debug.trace("iEquip_TemperedItemHandler setTemperLevelName start - Q: " + Q + ", " + temperLevelName)
	
	string tempName = jMap.getStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipName")
	
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

;/ Code snippets from Loot & Degradation _edquestscript.psc

If ArmorSlot == 0
	CurrentItem = targ.GetEquippedObject(WeaponSlot)
Else
	CurrentItem = targ.GetWornForm(ArmorSlot)
EndIf

Float Function RoundToTens(Float Value)
	Float Rounded = ((Value * 10.0) as Int / 10.0)
	If Rounded < 1.0
		Rounded = 1.0
	EndIf
	Return Rounded
EndFunction
/;