ScriptName iEquip_PotionSelectorUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto

bool bWaitingForFadeUpdate

function registerForPotionSelectorFadeUpdate(float fDelay)
	RegisterForSingleUpdate(fDelay)
	bWaitingForFadeUpdate = true
endFunction

function unregisterForPotionSelectorFadeUpdate()
	UnregisterForUpdate()
	bWaitingForFadeUpdate = false
endFunction

event OnUpdate()
	if bWaitingForFadeUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForFadeUpdate = false
		WC.updatePotionSelector(true) ;updatePotionSelector(bool bHide = false)
	endIf
endEvent