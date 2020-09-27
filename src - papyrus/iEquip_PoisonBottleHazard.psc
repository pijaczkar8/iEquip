Scriptname iEquip_PoisonBottleHazard extends ObjectReference Hidden

hazard property fHazard auto
actor property PlayerRef auto

event OnLoad()

	float ForceAngle = self.GetAngleZ() + self.GetHeadingAngle(PlayerRef) - 180 			; This makes sure the havok impulse is applied directly away from the bearing to the player
	float ForceMagnitude = self.GetDistance(PlayerRef) / 100								; This adjusts the amount of force applied depending on how far the bottle has been thrown
	
	if ForceMagnitude > 14.0																; This applies Min/Max value caps to the force
		ForceMagnitude = 14.0
	elseIf ForceMagnitude < 4.0
		ForceMagnitude = 4.0
	endIf
	
	self.ApplyHavokImpulse(Math.Sin(ForceAngle), Math.Cos(ForceAngle), 1, ForceMagnitude)	; This applies the havok impulse causing the bottle to smash apart
	self.placeatme(fHazard)																	; This places the relevant poison hazard, which plays the haze effect and delivers the poison spell

	RegisterForSingleUpdate(60)
endEvent

event OnUpdate()																			; This cleans up the debris after 60 seconds
	self.delete()
	self.disable()
endEvent

