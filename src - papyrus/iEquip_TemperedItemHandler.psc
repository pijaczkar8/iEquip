scriptname iEquip_TemperedItemHandler extends quest

import UI
Import WornObject

iEquip_WidgetCore Property WC Auto

Actor Property PlayerRef Auto

string HUD_MENU = "HUD Menu"
string property WidgetRoot auto hidden

string[] asTemperLevelNames
float[] afTemperLevelMax

event OnInit()
	debug.trace("iEquip_TemperedItemHandler OnInit start")

	afTemperLevelMax = new float[7]
	afTemperLevelMax[0] = 1.0					; Untempered - same value in vanilla and Requiem, no reason to think any other mod would change it from 1.0 (100% of normal base health)
	asTemperLevelNames = new string[7]
	updateTemperLevelArrays()
	
	debug.trace("iEquip_TemperedItemHandler OnInit end")
endEvent

event OnPlayerLoadGame()
	debug.trace("iEquip_TemperedItemHandler OnPlayerLoadGame start")
	updateTemperLevelArrays()					; Just in case any new mods have been added which alter the temper levels or names.  Doesn't support Improvement Names Customized, which doesn't alter the game settings
	debug.trace("iEquip_TemperedItemHandler OnPlayerLoadGame end")
endEvent

function updateTemperLevelArrays()
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays start")
	int i = 1
	string sValue
	string sName
	while i < 8
		sValue = "fHealthDataValue" + i as string
		sName = "sHealthDataPrefixWeap" + i as string
		afTemperLevelMax[i] = Game.GetGameSettingFloat(sValue)
		asTemperLevelNames[i] = Game.GetGameSettingString(sName)
		debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level " + i + ", maxValue: " + afTemperLevelMax[i] + ", level name: " + asTemperLevelNames[i])
		i += 1
	endWhile
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays end")
endFunction

function setTemperLevelFade(int Q)

endFunction

function setTemperLevelName(int Q)

endFunction

function checkAndUpdateTemperLevelInfo(int Q)

	string TemperedLevelSuffix
	int currentTemperLevelPercent
	float fItemHealth = WornObject.GetItemHealthPercent(PlayerRef, Q, 0)
	
	if fItemHealth > afTemperLevelMax[0] 	; First check if the item has been improved

		int i = 1 							; Now if it has find which level range it is currently within
		while fItemHealth > afTemperLevelMax[i] && i < 7
			i += 1
		endWhile
		
		if i == 7 							; If it has been tempered past Legendary set it to full and suffix it Legendary+
			TemperedLevelSuffix = asTemperLevelNames[5] + "+"
			currentTemperLevelPercent = 100
		else 								; Otherwise calculate the current % value within the level range and retrieve the temper level string
			currentTemperLevelPercent = Round((fItemHealth - afTemperLevelMax[i-1]) / (afTemperLevelMax[i] - afTemperLevelMax[i-1]) * 100)
			TemperedLevelSuffix = asTemperLevelNames[i]
		endIf
	
	else									; Untempered
		TemperedLevelSuffix = ""
		currentTemperLevelPercent = 100
	endIf
	
endFunction

function removeTemperFade(int Q)

endFunction

Int Function Round(Float i)
	If (i - (i as Int)) < 0.5
		Return (i as Int)
	Else
		Return (Math.Ceiling(i) as Int)
	EndIf
EndFunction

Float Function RoundToTens(Float Value)
	Float Rounded = ((Value * 10.0) as Int / 10.0)
	If Rounded < 1.0
		Rounded = 1.0
	EndIf
	Return Rounded
EndFunction

;/ Code snippets from Loot & Degradation _edquestscript.psc

If ArmorSlot == 0
	CurrentItem = targ.GetEquippedObject(WeaponSlot)
Else
	CurrentItem = targ.GetWornForm(ArmorSlot)
EndIf

Event OnGetUp(ObjectReference akFurniture)
	If akFurniture.HasKeyword(CraftingSmithingSharpeningWheel) || akFurniture.HasKeyword(CraftingSmithingArmorTable)
		Whetstone = False
		UpdateAllGearHealth()
		_EDSKConfigQuest.SetContextual()
	EndIf
EndEvent
/;