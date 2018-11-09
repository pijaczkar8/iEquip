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