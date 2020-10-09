ScriptName iEquip_ThrowingPoisonMagicEffect extends activemagiceffect Hidden

spell property deliverySpell auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	;debug.trace("iEquip_ThrowingPoisonMagicEffect OnEffectStart - " + akTarget.GetDisplayName() + " - " + akTarget as ObjectReference + " is about to cast " + deliverySpell.GetName() + " on themselves")
	; Might consider adding coughing or choking sound effects here and a slightly randomised delay before applying the poison
	deliverySpell.Cast(akTarget, akTarget)
endEvent
