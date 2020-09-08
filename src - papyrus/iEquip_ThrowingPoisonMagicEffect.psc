ScriptName iEquip_ThrowingPoisonMagicEffect extends activemagiceffect Hidden

spell property deliverySpell auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	debug.trace("iEquip_ThrowingPoisonMagicEffect OnEffectStart - " + akTarget.GetDisplayName() + " - " + akTarget as ObjectReference + " is about to cast " + deliverySpell.GetName() + " on themselves")
	deliverySpell.Cast(akCaster, akTarget)
endEvent
