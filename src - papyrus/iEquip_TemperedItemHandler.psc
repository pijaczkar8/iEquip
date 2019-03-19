scriptname iEquip_TemperedItemHandler extends quest

import UI
Import WornObject
import Game

iEquip_WidgetCore Property WC Auto

Actor Property PlayerRef Auto

string HUD_MENU = "HUD Menu"
string property WidgetRoot auto hidden

;bool bIsRequiemLoaded

string[] asTemperLevelNames
;string[] asRequiemTemperLevelNames

float[] afTemperLevelMax

event OnInit()
	debug.trace("iEquip_TemperedItemHandler OnInit start")

	afTemperLevelMax = new float[7]
	asTemperLevelNames = new string[7]
	updateTemperLevelArrays()
	
	debug.trace("iEquip_TemperedItemHandler OnInit end")
endEvent

event OnPlayerLoadGame()
	debug.trace("iEquip_TemperedItemHandler OnPlayerLoadGame start")
	updateTemperLevelArrays()
	debug.trace("iEquip_TemperedItemHandler OnPlayerLoadGame end")
endEvent

function updateTemperLevelArrays()
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays start")
	if Game.GetModByName("Requiem.esp") != 255
		afTemperLevelMax[0] = 0.5
	else
		afTemperLevelMax[0] = 1.0
	endIf

	int i = 1
	string sValue
	string sName
	while i < 8
		sValue = "fHealthDataValue" + i as string
		sName = "sHealthDataPrefix" + i as string
		afTemperLevelMax[i] = GetGameSettingString(sValue)
		asTemperLevelNames[i] = GetGameSettingString(sName)
		debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays - checking temper levels, Level " + i + ", maxValue: " + afTemperLevelMax[i] + ", level name: " + asTemperLevelNames[i])
		i += 1
	endWhile
	debug.trace("iEquip_TemperedItemHandler updateTemperLevelArrays end")
endFunction

;/ Code snippets from Loot & Degradation _edquestscript.psc

If RequiemInstalled
			MaxHealth = 3.1				;6	Master
		Else
			MaxHealth = 1.6
		EndIf
		If Person
			If RequiemInstalled
				If Level < 1000			;1	Apprentice
					MaxHealth = 0.5			;2000
				ElseIf Level < 3000		;2	Journeyman
					MaxHealth = 1.0			;4000
				ElseIf Level < 7000		;3	Adept
					MaxHealth = 1.5			;8000
				ElseIf Level < 15000	;4	Expert
					MaxHealth = 2.0			;16000
				ElseIf Level < 31000	;5	Artisan
					MaxHealth = 2.5
				EndIf

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

Bool Function ExamineItem(Int WeaponSlot = 1, Int ArmorSlot = 0)
	Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
	Form CurrentItem
	If ArmorSlot == 0
		CurrentItem = targ.GetEquippedObject(WeaponSlot)
	Else
		CurrentItem = targ.GetWornForm(ArmorSlot)
	EndIf
	If CurrentItem
		If CurrentHealth < 1.1
			Debug.Notification(CurrentItem.GetName() + ": " + UntemperedState)
		Else
			If RequiemInstalled
				Debug.Notification(CurrentItem.GetName() + ": " + Round((CurrentHealth - ((CurrentHealth * 10.0) as Int / 10.0)) / 0.00099 * 100.0) + "%" + ofText + (RoundToTens(CurrentHealth) * 100) as Int + "%")
			Else
				String TemperedState
				If CurrentHealth < 1.2
					TemperedState = FineState
				ElseIf CurrentHealth < 1.3
					TemperedState = SuperiorState
				ElseIf CurrentHealth < 1.4
					TemperedState = ExquisiteState
				ElseIf CurrentHealth < 1.5
					TemperedState = FlawlessState
				ElseIf CurrentHealth < 1.6
					TemperedState = EpicState
				ElseIf CurrentHealth < 1.7
					TemperedState = LegendaryState
				Else
					TemperedState = LegendaryState + "+"
				EndIf
				Debug.Notification(CurrentItem.GetName() + ": " + Round((CurrentHealth - ((CurrentHealth * 10.0) as Int / 10.0)) / 0.00099 * 100.0) + "%" + TemperedState)
			EndIf
		EndIf
		Return True
	EndIf
	Return False
EndFunction

Well-Made 1.0 - 2.1
High-Grade 2.1 - 3.3
First-Rate 3.3 - 4.5
Exquisite 4.6 - 5.7
Master Work 5.7 - 6.9
Legendary 6.9 - No upper limit

If RequiemInstalled
	MaxHealth = 3.1				;6	Master
EndIf

If RequiemInstalled
	If Level < 1000			;1	Apprentice
		MaxHealth = 0.5			;2000
	ElseIf Level < 3000		;2	Journeyman
		MaxHealth = 1.0			;4000
	ElseIf Level < 7000		;3	Adept
		MaxHealth = 1.5			;8000
	ElseIf Level < 15000	;4	Expert
		MaxHealth = 2.0			;16000
	ElseIf Level < 31000	;5	Artisan
		MaxHealth = 2.5
	EndIf
endIf

String Function WidgetState(Float Health)
	String TemperedState
	If Health == 0.0
		TemperedState = "-1"
	ElseIf Health < 1.1
		TemperedState = ""
	Else
		If RequiemInstalled
			TemperedState = ((RoundToTens(Health) * 100) as Int) as String + "%"
		Else
			If Health < 1.2
				TemperedState = FineState
			ElseIf Health < 1.3
				TemperedState = SuperiorState
			ElseIf Health < 1.4
				TemperedState = ExquisiteState
			ElseIf Health < 1.5
				TemperedState = FlawlessState
			ElseIf Health < 1.6
				TemperedState = EpicState
			ElseIf Health < 1.7
				TemperedState = LegendaryState
			Else
				TemperedState = LegendaryState + "+"
			EndIf
		EndIf
	EndIf
	Return TemperedState
EndFunction

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
			TemperLevelSuffix = asTemperLevelNames[5] + "+"
			currentTemperLevelPercent = 100
		else 								; Otherwise calculate the current % value within the level range and retrieve the temper level string
			currentTemperLevelPercent = Round((fItemHealth - afTemperLevelMax[i-1]) / (afTemperLevelMax[i] - afTemperLevelMax[i-1]) * 100)
			TemperLevelSuffix = asTemperLevelNames[i]
		endIf
	
	else									; Untempered
		TemperLevelSuffix = ""
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
