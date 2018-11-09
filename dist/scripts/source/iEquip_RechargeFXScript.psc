
Scriptname iEquip_RechargeFXScript extends ReferenceAlias Hidden

Actor Property PlayerRef Auto
SPELL Property iEquip_RechargeFXSpell  Auto

bool isSpellEquipped = false
 
function showRechargeFX()
	debug.trace("iEquip_RechargeFXScript showRechargeFX called")
	if !isSpellEquipped	
		PlayerRef.AddSpell(iEquip_RechargeFXSpell, false)
		Self.RegisterForSingleUpdate(2.0)
		isSpellEquipped = true
	endIf
endFunction

event OnUpdate()
	debug.trace("iEquip_RechargeFXScript OnUpdate called")
	if isSpellEquipped
		PlayerRef.RemoveSpell(iEquip_RechargeFXSpell)
		isSpellEquipped = false
	endIf
endEvent
