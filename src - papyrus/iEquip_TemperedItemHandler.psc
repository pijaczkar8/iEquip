scriptname iEquip_TemperedItemHandler extends quest

import UI
Import WornObject

iEquip_WidgetCore Property WC Auto

Actor Property PlayerRef Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------
string HUD_MENU = "HUD Menu"
string property WidgetRoot auto hidden

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
/;

function checkAndUpdateTemperLevelInfo(int Q, bool bIsShield)

endFunction

function removeTemperFade(int Q)

endFunction
