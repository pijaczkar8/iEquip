Scriptname iEquip_SlowTime Extends ReferenceAlias

SPELL Property iEquip_SlowTimeSpell  Auto

bool isSpellEquipped = false 
 
function slowTime()
	if !isSpellEquipped	
		Game.GetPlayer().AddSpell(iEquip_SlowTimeSpell, false)
	else
		Game.GetPlayer().RemoveSpell(iEquip_SlowTimeSpell)
	endIf
	isSpellEquipped = !isSpellEquipped
endFunction  
 