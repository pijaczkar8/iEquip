ScriptName iEquip_ActorExt


; @brief Retrieves the ammo the actor has equipped.
; @param a_actor The actor to check for ammo.
; @return Returns the equipped ammo if the actor has any. Returns NONE if no ammo is equipped.
Ammo Function GetEquippedAmmo(Actor a_actor) Global Native

; @brief Returns the damage dealt to the specified actor value.
; @param a_actor The actor to fetch the actor value from.
; @param a_actorValue The actor value to calculate.
; @return Returns 0.0 on error, else returns the damage dealt to the actor value as a function of its maximum - current.
; @notes Valid actor values:
; Anything in the range [0, 163]
; 24 - Health
; 25 - Magicka
; 26 - Stamina
Float Function GetAVDamage(Actor a_actor, Int a_actorValue) Native Global


; @brief Returns the base race of the specified actor.
; @param a_actor The actor to fetch the base race from.
; @return Returns NONE on error, else returns the base race of the specified actor.
Race Function GetBaseRace(Actor a_actor) Native Global


; @brief Returns the magnitude of the active magic effect on the specified actor.
; @param a_actor The actor the magic effect is applied to.
; @param a_mgef The magic effect to retrieve the magnitude of.
; @return Returns 0.0 on error, else returns the magnitude of the specified magic effect.
Float Function GetMagicEffectMagnitude(Actor a_actor, MagicEffect a_mgef) Native Global
