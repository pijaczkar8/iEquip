Scriptname iEquip_TorchTimerEffectScript extends activemagiceffect Hidden 

iEquip_TorchScript property TO Auto

Float function getElapsedTime()
	return self.GetTimeElapsed()
endFunction

Event OnEffectStart(Actor akTarget, Actor akCaster)
	debug.trace("iEquip_TorchTimerEffectScript OnEffectStart start")
	TO.TorchTimer = self
	debug.trace("iEquip_TorchTimerEffectScript OnEffectStart end")
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	debug.trace("iEquip_TorchTimerEffectScript OnEffectFinish start")
	TO.onTorchTimerExpired()
	debug.trace("iEquip_TorchTimerEffectScript OnEffectFinish end")
endEvent

