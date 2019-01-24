ScriptName iEquip_SpellExt


; @brief Returns whether the given spell is a healing spell.
; @param a_spell The spell to check.
; @return Returns true if the given spell is a healing spell, else returns false.
Bool Function IsHealingSpell(Spell a_spell) Global Native


; @brief Returns whether the given spell is a bound spell.
; @param a_spell The spell to check.
; @return Returns true if the given spell is a bound spell, else returns false.
Bool Function IsBoundSpell(Spell a_spell) Global Native


; @brief Returns the weapon type of the weapon summoned by the bound spell.
; @param a_spell The spell to check.
; @return The type of the weapon summoned by the bound spell.
; VALID TYPES:
; -1 - Not Found
; 00 - Hand-to-hand melee
; 01 - One-handed sword
; 02 - One-handed dagger
; 03 - One-handed axe
; 04 - One-handed mace
; 05 - Two-handed sword
; 06 - Two-handed axe
; 07 - Bow
; 08 - Staff
; 09 - Crossbow
Int Function GetBoundSpellWeapType(Spell a_spell) Global Native
