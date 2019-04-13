ScriptName iEquip_FormExt


; @brief Registers the passed script to be notified when the player equips a bound weapon.
; @param a_thisForm The form to register for the event (i.e. Self).
Function RegisterForBoundWeaponEquippedEvent(Form a_thisForm) Global Native


; @brief Unregisters the passed script to no longer be notified when the player equips a bound weapon.
; @param a_thisForm The form to register for the event (i.e. Self).
Function UnregisterForBoundWeaponEquippedEvent(Form a_thisForm) Global Native


; @brief Registers the passed script to be notified when the player unequips a bound weapon.
; @param a_thisForm The form to register for the event (i.e. Self).
Function RegisterForBoundWeaponUnequippedEvent(Form a_thisForm) Global Native


; @brief Unregisters the passed script to no longer be notified when the player unequips a bound weapon.
; @param a_thisForm The form to register for the event (i.e. Self).
Function UnregisterForBoundWeaponUnequippedEvent(Form a_thisForm) Global Native


; @brief Returns the light duration of the given light.
; @param a_light The light to retrieve the light duration of.
; @return Returns -1 on error, else returns the light duration.
Int Function GetLightDuration(Form a_light) Global Native


; @brief Returns the light radius of the given light.
; @param a_light The light to retrieve the light radius of.
; @return Returns -1 on error, else returns the light radius.
Int Function GetLightRadius(Form a_light) Global Native


; @brief Sets the light radius of the given light.
; @param a_light The light to set the light radius of.
Function SetLightRadius(Form a_light, Int a_radius) Global Native


; @brief Resets the light radius of the given light.
; @param a_light The light to reset the light radius of.
Function ResetLightRadius(Form a_light) Global Native


; @brief Fires whenever the player equips a bound weapon.
; @param a_weaponType The type of weapon equipped.
; VALID TYPES:
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
; 10 - Hand-to-hand melee
; 11 - One-handed sword
; 12 - One-handed dagger
; 13 - One-handed axe
; 14 - One-handed mace
; 15 - Two-handed sword
; 16 - Two-handed axe
; 17 - Bow
; 18 - Staff
; 19 - Crossbow
; @param a_equipSlot The slot the weapon is equipped to.
; VALID SLOTS:
; 0 - ERROR
; 1 - Right hand
; 2 - Left hand
; 3 - Both hands
Event OnBoundWeaponEquipped(Int a_weaponType, Int a_equipSlot)
EndEvent


; @brief Fires whenever the player unequips a bound weapon.
; @param a_weap The weapon unequipped.
; @param a_unequipSlot The slot the weapon was unequipped from.
; VALID SLOTS:
; 0 - ERROR
; 1 - Right hand
; 2 - Left hand
; 3 - Both hands
Event OnBoundWeaponUnequipped(Weapon a_weap, Int a_unequipSlot)
EndEvent


; @brief Returns whether the given form is a spear.
; @param a_actor The form to check.
; @return Returns true if the given form is a spear, else returns false.
Bool Function IsSpear(Form a_form) Global Native


; @brief Returns whether the given form is a javelin.
; @param a_actor The form to check.
; @return Returns true if the given form is a javelin, else returns false.
Bool Function IsJavelin(Form a_form) Global Native


; @brief Returns whether the given form is a grenade.
; @param a_actor The form to check.
; @return Returns true if the given form is a grenade, else returns false.
Bool Function IsGrenade(Form a_form) Global Native


; @brief Returns whether the given form is a throwing axe.
; @param a_actor The form to check.
; @return Returns true if the given form is a throwing axe, else returns false.
Bool Function IsThrowingAxe(Form a_form) Global Native


; @brief Returns whether the given form is a throwing knife.
; @param a_actor The form to check.
; @return Returns true if the given form is a throwing knife, else returns false.
Bool Function IsThrowingKnife(Form a_form) Global Native


; @brief Returns whether the given form is a poison wax.
; @param a_actor The form to check.
; @return Returns true if the given form is a poison wax, else returns false.
Bool Function IsWax(Form a_form) Global Native


; @brief Returns whether the given form is a poison oil.
; @param a_actor The form to check.
; @return Returns true if the given form is a poison oil, else returns false.
Bool Function IsOil(Form a_form) Global Native


; @brief Returns whether the given form is a spell ward.
; @param a_actor The form to check.
; @return Returns true if the given form is a spell ward, else returns false.
Bool Function IsSpellWard(Form a_form) Global Native


; @brief Returns whether the given form has fire.
; @param a_actor The form to check.
; @return Returns true if the given form has fire, else returns false.
Bool Function HasFire(Form a_form) Global Native


; @brief Returns whether the given form has ice.
; @param a_actor The form to check.
; @return Returns true if the given form has ice, else returns false.
Bool Function HasIce(Form a_form) Global Native


; @brief Returns whether the given form has shock.
; @param a_actor The form to check.
; @return Returns true if the given form has shock, else returns false.
Bool Function HasShock(Form a_form) Global Native


; @brief Returns whether the given form has poison.
; @param a_actor The form to check.
; @return Returns true if the given form has poison, else returns false.
Bool Function HasPoison(Form a_form) Global Native


; @brief Returns whether the given form is a salve.
; @param a_actor The form to check.
; @return Returns true if the given form is a salve, else returns false.
Bool Function IsSalve(Form a_form) Global Native


; @brief Returns whether the given form is a bandage.
; @param a_actor The form to check.
; @return Returns true if the given form is a bandage, else returns false.
Bool Function IsBandage(Form a_form) Global Native
