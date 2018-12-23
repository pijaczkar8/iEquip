ScriptName iEquip_ConsumableFadeUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto

bool bWaitingForFadeUpdate = false
int potionGroupIndex

function registerForConsumableFadeUpdate(float fDelay, int iPotionGroupIndex)
	potionGroupIndex = iPotionGroupIndex
	RegisterForSingleUpdate(fDelay)
	bWaitingForFadeUpdate = true
endFunction

function unregisterForConsumableFadeUpdate()
	UnregisterForUpdate()
	bWaitingForFadeUpdate = false
endFunction

event OnUpdate()
	if bWaitingForFadeUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForFadeUpdate = false
		WC.handleConsumableIconFadeAndFlash(potionGroupIndex)
	endIf
endEvent