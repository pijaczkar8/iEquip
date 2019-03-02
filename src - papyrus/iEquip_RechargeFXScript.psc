
Scriptname iEquip_RechargeFXScript extends ReferenceAlias Hidden

Actor Property PlayerRef Auto
SPELL Property iEquip_RechargeFXSpell  Auto

bool bIsSpellEquipped
 
function showRechargeFX()
	debug.trace("iEquip_RechargeFXScript showRechargeFX called")
	if !bIsSpellEquipped	
		PlayerRef.AddSpell(iEquip_RechargeFXSpell, false)
		Self.RegisterForSingleUpdate(2.0)
		bIsSpellEquipped = true
	endIf
endFunction

event OnUpdate()
	debug.trace("iEquip_RechargeFXScript OnUpdate called")
	if bIsSpellEquipped
		PlayerRef.RemoveSpell(iEquip_RechargeFXSpell)
		bIsSpellEquipped = false
	endIf
endEvent
