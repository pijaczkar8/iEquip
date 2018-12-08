ScriptName iEquip_WidgetVisUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto

Actor property PlayerRef auto

bool property bWaitingForWidgetFadeoutUpdate = false auto hidden

function registerForWidgetFadeoutUpdate()
	debug.trace("iEquip_WidgetVisUpdateScript registerForWidgetFadeoutUpdate called")
	RegisterForSingleUpdate(WC.fWidgetFadeoutDelay)
	bWaitingForWidgetFadeoutUpdate = true
endFunction

function unregisterForWidgetFadeoutUpdate()
	debug.trace("iEquip_WidgetVisUpdateScript unregisterForWidgetFadeoutUpdate called")
	UnregisterForUpdate()
	bWaitingForWidgetFadeoutUpdate = false
endFunction

event OnUpdate()
	debug.trace("iEquip_WidgetVisUpdateScript OnUpdate called")
	if bWaitingForWidgetFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForWidgetFadeoutUpdate = false
		if (!WC.bAlwaysVisibleWhenWeaponsDrawn || !PlayerRef.IsWeaponDrawn()) && !WC.EM.isEditMode;Check again in case weapons have been drawn during update delay
			WC.updateWidgetVisibility(false, WC.fWidgetFadeoutDuration) ;Hide widget
		endIf
	endIf
endEvent