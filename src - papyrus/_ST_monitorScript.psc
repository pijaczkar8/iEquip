Scriptname _ST_monitorScript extends activemagiceffect  
{ Script monitoring actors with TCS functionality using the MonitorAbility spell. }

; Spells
Spell property CandlelightSpell auto
Spell property MagelightSpell auto
Spell property MagelightSpellDummy auto
Spell property MagelightSpellShadow auto
Spell property MonitorAbility auto ; this script cloak

; Properties
bool property isShadowTorchEquipped = false auto
Light property Torch01 auto
Formlist property actorsWithShadowLights auto
_ST_Handler property Handler auto
Actor Player
Actor thisActor
bool torchEquipped = false
bool ignoreUnequip = false
bool effectsAdded = false

event OnPlayerLoadGame() ; Just in case this is on an existing save and the effect is already active on the player
	; iEquip
	if thisActor == Player
		Self.RegisterForModEvent("iEquip_ResetTCS", "iEquipRequestsReset")
	endIf
endEvent

event OnEffectStart(Actor akTarget, Actor akCaster)
	thisActor = akTarget
	Player = Game.GetPlayer()
	AddInventoryEventFilter(Torch01)
	RegisterFilters()
	; iEquip
	if thisActor == Player
		Self.RegisterForModEvent("iEquip_ResetTCS", "iEquipRequestsReset")
	endIf
endEvent

event OnEffectFinish(Actor akTarget, Actor akCaster)
	Handler.DispelCandlelight(akTarget, false)
	Handler.RemoveAllTorchesFrom(akTarget)
	Handler.RemoveFromActorFormlist(akTarget)
	RemoveInventoryEventFilter(Torch01)
	RemoveInventoryEventFilter(Handler.TorchLight600)
	RemoveInventoryEventFilter(Handler.TorchLight600bright)
	RemoveInventoryEventFilter(Handler.TorchLight600Shadow)
	RemoveInventoryEventFilter(Handler.TorchLight600Shadowbright)
	RemoveInventoryEventFilter(Handler.TorchLight900)
	RemoveInventoryEventFilter(Handler.TorchLight900bright)
	RemoveInventoryEventFilter(Handler.TorchLight900Shadow)
	RemoveInventoryEventFilter(Handler.TorchLight900Shadowbright)
	RemoveInventoryEventFilter(Handler.TorchLight1200)
	RemoveInventoryEventFilter(Handler.TorchLight1200bright)
	RemoveInventoryEventFilter(Handler.TorchLight1200Shadow)
	RemoveInventoryEventFilter(Handler.TorchLight1200Shadowbright)

	if (thisActor == Player)
		UnregisterForControl("Activate")
	endIf
endEvent

function RegisterFilters()
	AddInventoryEventFilter(Handler.TorchLight600)
	AddInventoryEventFilter(Handler.TorchLight600bright)
	AddInventoryEventFilter(Handler.TorchLight600Shadow)
	AddInventoryEventFilter(Handler.TorchLight600Shadowbright)
	AddInventoryEventFilter(Handler.TorchLight900)
	AddInventoryEventFilter(Handler.TorchLight900bright)
	AddInventoryEventFilter(Handler.TorchLight900Shadow)
	AddInventoryEventFilter(Handler.TorchLight900Shadowbright)
	AddInventoryEventFilter(Handler.TorchLight1200)
	AddInventoryEventFilter(Handler.TorchLight1200bright)
	AddInventoryEventFilter(Handler.TorchLight1200Shadow)
	AddInventoryEventFilter(Handler.TorchLight1200Shadowbright)

	if (thisActor == Player)
		RegisterForControl("Activate")
	endIf

	effectsAdded = true
endFunction

event OnDying(Actor akKiller)
	thisActor.DispelSpell(MonitorAbility)
endEvent

; iEquip
event iEquipRequestsReset(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	if thisActor == Player && sEventName == "iEquip_ResetTCS"
		torchEquipped = false
		isShadowTorchEquipped = false
	endIf
endEvent

event OnObjectEquipped (Form akBaseObject, ObjectReference akReference)
	if (!Handler.ToggleModEnable)
		return
	endIf

	if (!effectsAdded)
		RegisterFilters()
	endIf

	if (akBaseObject as light == Torch01 && Handler.TorchModuleOn)
		if (thisActor == Player && Handler.playerEnableTorch) || (thisActor != Player && Handler.npcEnableTorch)
			; Prevent re-equipping the torch (player only)
			if (thisActor == Player && torchEquipped)
				Utility.Wait(0.1)
				thisActor.unequipitem(Torch01, false, true)
				torchEquipped = false
				isShadowTorchEquipped = false
			else
				; Update the new value by sending the old value, also equip proper torch
				isShadowTorchEquipped = Handler.equipTorch(thisActor, isShadowTorchEquipped)
				torchEquipped = true

				modifyActorList() ; make continous checks
			endIf
		endIf

		return
	; If it isn't any of the other torches
	elseIf ((akBaseObject as light != Handler.GetCurrentTorchStatic()) && (akBaseObject as light != Handler.GetCurrentTorchShadows()))
		torchEquipped = false
	endIf
	
	; Remove vanilla spells
	if ((thisActor == Player) && (akBaseObject as spell == MagelightSpell) && Handler.MagelightModuleOn)
		Player.RemoveSpell(MagelightSpell)
		Player.Addspell(MagelightSpellDummy, false)
	elseIf ((thisActor == Player) && (akBaseObject as spell == CandlelightSpell) && Handler.CandlelightModuleOn)
		Player.RemoveSpell(CandlelightSpell)
		Player.Addspell(Handler.CandlelightDummy, false)
	endIf
endEvent

event OnObjectUnequipped (Form akBaseObject, ObjectReference akReference)
	if (ignoreUnequip)
		ignoreUnequip = false
	elseIf (akBaseObject as light == Handler.GetCurrentTorchShadows())
		isShadowTorchEquipped = false
		modifyActorList()
	endIf
endEvent

function modifyActorList ()
	if (isShadowTorchEquipped)
		actorsWithShadowLights.addForm(thisActor)
		RegisterForSingleUpdate(Handler.ActorUpdateInterval)
	elseIf (Handler.isAnyTorchEquipped(thisActor))
		actorsWithShadowLights.RemoveAddedForm(thisActor)
		RegisterForSingleUpdate(Handler.updateReApply)
	endIf
endFunction

; ***********
; Candlelight related. NOTE: Actor is added to the actorFormlist on EffectStart.
; ***********
event OnSpellCast(Form akSpell)
	if (!Handler.ToggleModEnable)
		return
	endIf

	if (akSpell as Spell == Handler.CandlelightDummy && Handler.CandlelightModuleOn)
		RegisterForSingleUpdate(Handler.ActorUpdateInterval)	; to maybe disable it later
	elseIf (akSpell as Spell == CandlelightSpell && Handler.CandlelightModuleOn && (thisActor != Player))
		thisActor.DispelSpell(CandlelightSpell) ; dispel default candlelight spell

		if (Handler.castCandlelight(thisActor, isShadowTorchEquipped))
			RegisterForSingleUpdate(Handler.ActorUpdateInterval)	; to maybe disable it later
		endIf
	elseIf (akSpell as Spell == MagelightSpellDummy && thisActor == Player) ; magelight
		Handler.castMagelight(Player, isShadowTorchEquipped)
	endIf
endEvent


; ***********
; Remove all invisible torches from the actor when there are no torch01 in the inventory. This is particularly necessary for
; NPC's since they will auto-equip torches in their inventory, invisible or not. Though, Torch01 will always have the higher
; priority (i hope).
; ***********
event OnItemRemoved(Form akBaseItem, int aiItmCount, ObjectReference akItmRef, ObjectReference akDestCont)
	if (akBaseItem == Torch01 && thisActor.GetItemCount(Torch01) == 0)
		Handler.RemoveAllTorchesFrom(thisActor)
	elseIf(akBaseItem == Handler.GetCurrentTorchShadows() || akBaseItem == Handler.GetCurrentTorchStatic())
		thisActor.RemoveItem(Torch01, 1, true)

		if (thisActor == Player)
			Debug.Notification("Your torch burned out.")
		endIf
	endIf
endEvent

; ***********
; Quick light option, hold 'Activate' to cast candlelight.
; ***********
event OnControlUp(string control, float HoldTime)
	if (Handler.CandlelightHoldActivate && (control == "Activate") && (game.GetCurrentCrosshairRef() == none) && (HoldTime >= 2))
		Handler.CandlelightDummy.Cast(thisActor)
	endIf
endEvent

; ***********
; Check if actor is using a shadow torch atm, then check if they are far away from the
; player or if the player is around too many shadow casting light sources.
; ***********
event OnUpdate()
	if (thisActor == Player && !Handler.TogglePlayerUpdate)
		return
	endIf

	if (Handler.ToggleShadowsTorch && Handler.isAnyTorchEquipped(thisActor)) ; Torch check
		int allowed = Handler.runCheck(thisActor)

		if (isShadowTorchEquipped && allowed == 0)  ; Check if shadowtorch can still be used by this actor
			Handler.unequipShadows(thisActor)		; Re-equip all
			isShadowTorchEquipped = false
		elseIf (allowed == 1)  ; Check if we can re apply shadows
			if (thisActor != player)
				ignoreUnequip = true
				thisActor.UnequipItem(Handler.GetCurrentTorchShadows(), false, true) ; Hotfix: Resets double lights bug
			endIf
			thisActor.EquipItem(Handler.GetCurrentTorchShadows(), false, true)
			isShadowTorchEquipped = true
		endIf

		modifyActorList()
	elseIf (Handler.ToggleShadowsCandlelight && Handler.hasCandlelightShadows(thisActor))  ; Candlelight check
		if Player.GetDistance(thisActor) > 4096 || Handler.runCheck(thisActor) == 0
			Handler.DispelCandlelight(thisActor, true)
		endIf
	elseIf(Handler.ToggleWLLantern && thisActor.HasSpell(Handler.CurrLanternSpellShadow)) ; WL check
		if (Handler.runCheck(thisActor) == 0) ; If too many lights
			; remove the current lantern effect and replace it with the corresponding static effect
			thisActor.RemoveSpell(Handler.CurrLanternSpellShadow)
			thisActor.AddSpell(Handler.CurrLanternSpellStatic, false)
			RegisterForSingleUpdate(Handler.updateReApply) 
		else
			RegisterForSingleUpdate(Handler.ActorUpdateInterval)
		endIf
	elseIf(Handler.ToggleWLLantern && thisActor.HasSpell(Handler.CurrLanternSpellStatic)) ; If static light from WL
		if (Handler.runCheck(thisActor) == 1)
			thisActor.RemoveSpell(Handler.CurrLanternSpellStatic)
			thisActor.AddSpell(Handler.CurrLanternSpellShadow, false)
			RegisterForSingleUpdate(Handler.ActorUpdateInterval) 
		else
			RegisterForSingleUpdate(Handler.updateReApply)
		endIf
	endIf

	if (!isShadowTorchEquipped && !Handler.hasCandlelightShadows(thisActor) && !Handler.HasLanternFX(thisActor))
		Handler.RemoveFromActorFormlist(thisActor)
	endIf
endEvent
