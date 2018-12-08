Scriptname iEquip_ApplyPoisonFXScript extends ReferenceAlias Hidden

SPELL Property iEquip_ApplyPoisonFXSpell  Auto
Actor Property PlayerRef Auto

bool bIsSpellEquipped = false 
 
function showPoisonFX()
	debug.trace("iEquip_ApplyPoisonFXScript showPoisonFX called")
	if !bIsSpellEquipped	
		PlayerRef.AddSpell(iEquip_ApplyPoisonFXSpell, false)
		Self.RegisterForSingleUpdate(2.0)
		bIsSpellEquipped = true
	endIf
endFunction

event OnUpdate()
	debug.trace("iEquip_ApplyPoisonFXScript OnUpdate called")
	if bIsSpellEquipped
		PlayerRef.RemoveSpell(iEquip_ApplyPoisonFXSpell)
		bIsSpellEquipped = false
	endIf
endEvent
