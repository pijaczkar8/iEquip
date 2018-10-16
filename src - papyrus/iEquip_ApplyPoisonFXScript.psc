Scriptname iEquip_ApplyPoisonFXScript extends ReferenceAlias Hidden

SPELL Property iEquip_ApplyPoisonFXSpell  Auto

bool isSpellEquipped = false 
 
function showPoisonFX(int Q)
	debug.trace("iEquip_ApplyPoisonFXScript showPoisonFX called")
	if !isSpellEquipped	
		Game.GetPlayer().AddSpell(iEquip_ApplyPoisonFXSpell, false)
		Self.RegisterForSingleUpdate(2.0)
		isSpellEquipped = true
	endIf
endFunction

event OnUpdate()
	debug.trace("iEquip_ApplyPoisonFXScript OnUpdate called")
	if isSpellEquipped
		Game.GetPlayer().RemoveSpell(iEquip_ApplyPoisonFXSpell)
		isSpellEquipped = false
	endIf
endEvent
