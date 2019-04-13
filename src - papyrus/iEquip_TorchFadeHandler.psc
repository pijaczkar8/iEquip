Scriptname iEquip_TorchFadeHandler extends Quest

import iEquip_FormExt

Actor Property PlayerRef Auto

float fOriginalRadius
float fCurrentRadius
float fOriginalDuration
float fRemainingTorchLife

function registerForTorchFade(form equippedTorch, float fTorchRadius, float fTorchDuration, float fCurrentTorchLife)
	if fCurrentTorchLife < 30.0
		iEquip_FormExt.SetLightRadius(equippedTorch, fOriginalRadius * ((((fCurrentTorchLife / 5) as int) + 1) * 0.15))
		RegisterForSingleUpdate(fCurrentTorchLife - (((fCurrentTorchLife / 5) as int) * 5))
	else
		RegisterForSingleUpdate(fCurrentTorchLife - 30.1)
endFunction

function UnregisterForTorchFadeUpdate()
	UnregisterForUpdate()
endFunction

event OnUpdate()

endEvent

