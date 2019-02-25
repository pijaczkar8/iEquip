ScriptName iEquip_WidgetVisUpdateScript Extends Quest Hidden

iEquip_WidgetCore Property WC Auto

Actor property PlayerRef auto

bool bWaitingForWidgetFadeoutUpdate

function registerForWidgetFadeoutUpdate()
	RegisterForSingleUpdate(WC.fWidgetFadeoutDelay)
	bWaitingForWidgetFadeoutUpdate = true
endFunction

function unregisterForWidgetFadeoutUpdate()
	bWaitingForWidgetFadeoutUpdate = false
	UnregisterForUpdate()
endFunction

event OnUpdate()
	if bWaitingForWidgetFadeoutUpdate ;Failsafe bool to block OnUpdate if triggered from another script on the quest
		bWaitingForWidgetFadeoutUpdate = false
		if (!WC.bAlwaysVisibleWhenWeaponsDrawn || !PlayerRef.IsWeaponDrawn()) && !WC.EM.isEditMode;Check again in case weapons have been drawn during update delay
			WC.updateWidgetVisibility(false, WC.fWidgetFadeoutDuration) ;Hide widget
		endIf
	endIf
endEvent