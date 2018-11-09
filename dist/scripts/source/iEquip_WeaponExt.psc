ScriptName iEquip_WeaponExt


; @brief Checks if the given weapon is a bound weapon or not.
; @param a_weap The weapon to check.
; @return Returns true if the weapon is bound. Returns false if the weapon is invalid or not bound.
Bool Function IsWeaponBound(Weapon a_weap) Native Global


; @brief Returns whether the given weapon is a grenade or not.
; @param a_weap The weapon to check.
; @return Returns true if the weapon is a grenade, else returns false.
Bool Function IsWeaponGrenade(Weapon a_weap) Global Native