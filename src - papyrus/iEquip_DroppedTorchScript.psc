Scriptname iEquip_DroppedTorchScript extends ObjectReference

iEquip_TorchScript property TO auto

MiscObject property iEquipBurntOutTorch auto
Actor property PlayerRef auto
Faction property PlayerFaction auto

event OnLoad()
	RegisterForSingleUpdate(30.0)
endEvent

event OnUpdate()

	ObjectReference BurntOutTorch = Self.PlaceAtMe(iEquipBurntOutTorch, 1, false, true)

	BurntOutTorch.SetActorOwner(PlayerRef.GetActorBase())
	BurntOutTorch.SetFactionOwner(PlayerFaction)

	If (BurntOutTorch.is3DLoaded())
		BurntOutTorch.MoveTo(Self)
	Else
		BurntOutTorch.MoveToIfUnloaded(Self)
		BurntOutTorch.SetAngle(Self.GetAngleX(), Self.GetAngleY(), Self.GetAngleZ())
	EndIf

	BurntOutTorch.EnableNoWait()

	;/Int Tries = 0 
	While(Tries < 10 && (!BurntOutTorch.is3DLoaded() || !BurntOutTorch.IsEnabled()))
		Utility.Wait(0.05)
		Tries += 1
	EndWhile/;

	Self.Delete()	
	Self.Disable()
	TO.aDroppedTorches[TO.aDroppedTorches.Find(Self)] = BurntOutTorch

endEvent
