ScriptName iEquip_ActorExt


; @brief Retrieves the ammo the actor has equipped.
; @param a_actor The actor to check for ammo.
; @return Returns the equipped ammo if the actor has any. Returns NONE if no ammo is equipped.
Ammo Function GetEquippedAmmo(Actor a_actor) Global Native


; @brief Force equips the item with the specified FormID and applied poison to the specified slot.
; @param a_actor The actor to equip the item to.
; @param a_item The item to equip.
; @param a_slotID The slot ID to equip the item to.
; @param a_enchantment The form of the enchantment applied to the item.
; @param a_preventUnequip Prevents the actor from unequipping the item.
; @param a_equipSound Plays the equip sound when the item is equipped.
Function EquipEnchantedItemEx(Actor a_actor, Form a_item, Int a_slotID, Enchantment a_enchantment, Bool a_preventUnequip = False, Bool a_equipSound = True) Native Global


; @brief Force equips the item with the specified FormID and applied poison to the specified slot.
; @param a_actor The actor to equip the item to.
; @param a_item The item to equip.
; @param a_slotID The slot ID to equip the item to.
; @param a_poison The form of the poison applied to the item.
; @param a_count The count of the poison charges applied to the item.
; @param a_preventUnequip Prevents the actor from unequipping the item.
; @param a_equipSound Plays the equip sound when the item is equipped.
Function EquipPoisonedItemEx(Actor a_actor, Form a_item, Int a_slotID, Potion a_poison, Int a_count = 1, Bool a_preventUnequip = False, Bool a_equipSound = True) Native Global


; @brief Force equips the item with the specified FormID, poison, and enchantment to the specified slot.
; @param a_actor The actor to equip the item to.
; @param a_item The item to equip.
; @param a_slotID The slot ID to equip the item to.
; @param a_enchantment The Form of the enchantment applied to the weapon.
; @param a_poison The Form of the poison applied to the weapon.
; @param a_count The count of the poison charges applied to the item.
; @param a_preventUnequip Prevents the actor from unequipping the item.
; @param a_equipSound Plays the equip sound when the item is equipped.
; @notes Same usage notes apply from EquipEnchantedItemEx().
Function EquipEnchantedAndPoisonedItemEx(Actor a_actor, Form a_item, Int a_slotID, Enchantment a_enchantment, Potion a_poison, Int a_count = 1, Bool a_preventUnequip = False, Bool a_equipSound = True) Native Global


; @brief Returns the damage dealt to the specified actor value
; @param a_actor The actor to fetch the actor value from
; @param a_actorValue The actor value to calculate
; @return Returns 0.0 on error, else returns the damage dealt to the actor value as a function of its maximum - current
; @notes Valid actor values:
; Anything in the range [0, 163]
; 24 - Health
; 25 - Magicka
; 26 - Stamina
Float Function GetAVDamage(Actor a_actor, Int a_actorValue) Native Global


; @brief Returns the base race of the specified actor
; @param a_actor The actor to fetch the base race from
; @return Returns NONE on error, else returns the base race of the specified actor
Race Function GetBaseRace(Actor a_actor) Native Global


; @brief Returns the magnitude of the active magic effect on the specified actor
; @param a_actor The actor the magic effect is applied to
; @param a_mgef The magic effect to retrieve the magnitude of
; @return Returns 0.0 on error, else returns the magnitude of the specified magic effect
Float Function GetMagicEffectMagnitude(Actor a_actor, MagicEffect a_mgef) Native Global