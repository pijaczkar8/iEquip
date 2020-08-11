ScriptName iEquip_ThrowingPoisonMagicEffect extends activemagiceffect Hidden

iEquip_ThrowingPoisons property TP auto

Actor property PlayerRef auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	form fPoison = TP.thrownPoison as form

	TP.bBlockInventoryEvents = true
	PlayerRef.AddItem(fPoison, 1, true)
	PlayerRef.RemoveItem(fPoison, 1, false, akTarget)
endEvent