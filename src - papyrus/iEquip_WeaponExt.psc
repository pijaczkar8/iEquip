ScriptName iEquip_WeaponExt


; @brief Gets the weapon equipped in the given hand on the given actor.
; @param a_actor The actor to check.
; @param a_hand The hand to check.
; @return Returns a weapon if equipped in the given hand. Returns NONE otherwise.
; VALID HANDS:
; 1 - Right hand
; 2 - Left hand
Weapon Function GetEquippedWeapon(Actor a_actor, Int a_hand) Native Global


; @brief Checks if the given weapon is a bound weapon or not.
; @param a_weap The weapon to check.
; @return Returns true if the weapon is bound. Returns false if the weapon is invalid or not bound.
Bool Function IsWeaponBound(Weapon a_weap) Native Global
