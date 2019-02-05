
Scriptname iEquip_AmmoMode extends Quest

Import UI
Import UICallback
Import Utility
import _Q2C_Functions
import iEquip_StringExt
import iEquip_AmmoExt
import iEquip_FormExt
import iEquip_WeaponExt

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_PlayerEventHandler property EH auto

actor property PlayerRef auto
FormList property iEquip_AmmoItemsFLST auto

string property sAmmoIconSuffix auto hidden
int property iAmmoListSorting = 1 auto hidden
int property iActionOnLastAmmoUsed = 1 auto hidden

bool property bAmmoMode auto hidden
bool bReadyForAmmoModeAnim
bool property bAmmoModePending auto hidden

int property Q auto hidden
int[] property aiTargetQ auto hidden
bool[] abNeedsSorting

int[] property aiCurrentAmmoIndex auto hidden
string[] property asCurrentAmmo auto hidden
form property currentAmmoForm auto hidden

int ilastSortType

bool incrementDamage
bool bBoundAmmoAdded
bool[] property abBoundAmmoInQueue auto hidden
string[] asBoundAmmoNames
string[] asBoundAmmoIcons

string[] asAmmoIcons

String HUD_MENU = "HUD Menu"
String WidgetRoot

event onInit()
	debug.trace("iEquip_AmmoMode onInit start")
	aiTargetQ = new int[2]
	aiCurrentAmmoIndex = new int[2]
	asCurrentAmmo = new string[2]
	abNeedsSorting = new bool[2]
	abBoundAmmoInQueue = new bool[2]

	asBoundAmmoNames = new string[2]
	asBoundAmmoNames[0] = iEquip_StringExt.LocalizeString("$iEquip_common_BoundArrow")
	asBoundAmmoNames[1] = iEquip_StringExt.LocalizeString("$iEquip_common_BoundBolt")

	asBoundAmmoIcons = new string[2]
	asBoundAmmoIcons[0] = "BoundArrow"
	asBoundAmmoIcons[1] = "BoundBolt"

	asAmmoIcons = new string[2]
	asAmmoIcons[0] = "Arrow"
	asAmmoIcons[1] = "Bolt"
	debug.trace("iEquip_AmmoMode onInit end")
endEvent

function OnWidgetLoad()
	debug.trace("iEquip_AmmoMode OnWidgetLoad start")
	WidgetRoot = WC.WidgetRoot
	if aiTargetQ[0] == 0
        aiTargetQ[0] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "arrowQ", aiTargetQ[0])
    endIf
    if aiTargetQ[1] == 0
        aiTargetQ[1] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "boltQ", aiTargetQ[1])
    endIf
    if WC.isEnabled
    	updateAmmoLists()
    endIf
    debug.trace("iEquip_AmmoMode OnWidgetLoad end")
endFunction

;This function is normally the first thing called in the Ammo Mode sequence
function selectAmmoQueue(int weaponType)
	debug.trace("iEquip_AmmoMode selectAmmoQueue start")
	debug.trace("iEquip_AmmoMode selectAmmoQueue - weaponType: " + weaponType)
	Q = ((weaponType == 9) as int)
	if iAmmoListSorting == 2 || iAmmoListSorting == 4
		selectLastUsedAmmo(Q)
	else
		selectBestAmmo(Q)
	endIf
	debug.trace("iEquip_AmmoMode sortAmmoQueue end")
endFunction

int function getCurrentAmmoObject()
	debug.trace("iEquip_AmmoMode getCurrentAmmoObject start")
	debug.trace("iEquip_AmmoMode getCurrentAmmoObject end")
	return jArray.getObj(aiTargetQ[Q], aiCurrentAmmoIndex[Q])
endFunction

function onAmmoAdded(form addedAmmo)
	debug.trace("iEquip_AmmoMode onAmmoAdded start")
	debug.trace("iEquip_AmmoMode onAmmoAdded - addedAmmo: " + addedAmmo.GetName())
	int isBolt = (addedAmmo as ammo).isBolt() as int
	int count = jArray.count(aiTargetQ[isBolt])
	if bAmmoMode && currentAmmoForm == addedAmmo && count > 1
    	setSlotCount(PlayerRef.GetItemCount(addedAmmo))
    elseif !isAlreadyInAmmoQueue(addedAmmo, aiTargetQ[isBolt])
    	AddToAmmoQueue(addedAmmo, addedAmmo.GetName(), isBolt)
    	count = jArray.count(aiTargetQ[isBolt])
    	if count > 1
    		abNeedsSorting[isBolt] = true
    		sortAmmoLists()
    	else
    		selectBestAmmo(isBolt)
    	endIf
    	;If we've just added ammo to a previously empty queue
    	if count == 1 && Q == isBolt
    		debug.trace("iEquip_AmmoMode onAmmoAdded - just added ammo to an empty queue, Q: " + Q + ", isBolt: " + isBolt + ", bAmmoModePending: " + bAmmoModePending + ", bAmmoMode: " + bAmmoMode)
    		;If we equipped a ranged weapon without any suitable ammo and we still have it equipped we can now toggle ammo mode
    		if bAmmoModePending
    			toggleAmmoMode()
    		endIf
    	endIf
    endIf
    debug.trace("iEquip_AmmoMode onAmmoAdded end")
endFunction

function onAmmoRemoved(form removedAmmo)
	debug.trace("iEquip_AmmoMode onAmmoRemoved start")
	debug.trace("iEquip_AmmoMode onAmmoRemoved - removedAmmo: " + removedAmmo.GetName())
	;If we've still got at least one of it left check if it's the current ammo and update the count
	if PlayerRef.GetItemCount(removedAmmo) > 0
		if bAmmoMode && currentAmmoForm == removedAmmo
	    	setSlotCount(PlayerRef.GetItemCount(removedAmmo))
	    endIf
	;Otherwise if we've removed the last of this ammo check if it's in the relevant ammo queue and remove it
	elseIf iEquip_AmmoItemsFLST.HasForm(removedAmmo)
		int isBolt = (removedAmmo as ammo).isBolt() as int
		int targetQ = aiTargetQ[isBolt]
		int i
		bool found
		while i < JArray.count(targetQ) && !found
			found = (removedAmmo == jMap.getForm(jArray.getObj(targetQ, i), "iEquipForm"))
			if found
				removeAmmoFromQueue(isBolt, i)
				;If we're in ammo mode and the ammo we've just removed matches the currently equipped ammo
				if bAmmoMode && (currentAmmoForm == removedAmmo)
					;If we've got at least one other type of ammo equip it now
					if JArray.count(targetQ) > 0
						checkAndEquipAmmo(false, true)
					;Otherwise check what is to happen when last ammo used up
					else
						bool switchedRangedWeapon
						if iActionOnLastAmmoUsed == 1 || iActionOnLastAmmoUsed == 2 ;If we've chosen one of the Switch Type options first check for a ranged weapon of a different type
							int typeToFind = 7
							if !isBolt
								typeToFind = 9
							endIf
							switchedRangedWeapon = PM.quickRangedFindAndEquipWeapon(typeToFind, false)
						endIf
						; If we haven't found an alternative ranged weapon, or we've selected Do Nothing...
						if iActionOnLastAmmoUsed == 0 || (iActionOnLastAmmoUsed == 1 && !switchedRangedWeapon)
							WC.setSlotToEmpty(0)
						; ...or Cycle / Switch Out
						elseIf iActionOnLastAmmoUsed == 3 || (iActionOnLastAmmoUsed == 2 && !switchedRangedWeapon)
							if PM.bCurrentlyQuickRanged
								PM.quickRanged()
							else
								PM.quickRangedSwitchOut(true)
							endIf
						endIf
					endIf
				endIf
			else
				i += 1
			endIf
		endWhile
	endIf
	debug.trace("iEquip_AmmoMode onAmmoRemoved end")
endFunction

function toggleAmmoMode(bool toggleWithoutAnimation = false, bool toggleWithoutEquipping = false)
	debug.trace("iEquip_AmmoMode toggleAmmoMode start")
	debug.trace("iEquip_AmmoMode toggleAmmoMode - toggleWithoutAnimation: " + toggleWithoutAnimation + ", toggleWithoutEquipping: " + toggleWithoutEquipping + ", bAmmoModePending: " + bAmmoModePending)
	if !bAmmoMode && jArray.count(aiTargetQ[Q]) < 1
		debug.trace("iEquip_AmmoMode toggleAmmoMode - no ammo for the selected weapon, setting bAmmoModePending to true")
		debug.Notification("$iEquip_AM_not_noAmmo")
		WC.checkAndFadeLeftIcon(1, 5)
		bAmmoModePending = true
	else
		bAmmoMode = !bAmmoMode
		WC.bAmmoMode = bAmmoMode
		bReadyForAmmoModeAnim = false
		Self.RegisterForModEvent("iEquip_ReadyForAmmoModeAnimation", "ReadyForAmmoModeAnimation")
		;Toggle in
		if bAmmoMode
			bAmmoModePending = false ;Reset
			if WC.bLeftIconFaded ;In case we're coming from bAmmoModePending and it's still faded out
				WC.checkAndFadeLeftIcon(0, 0)
				Utility.WaitMenuMode(0.3)
			endIf
			;Hide the left hand poison elements if currently shown
			if WC.abPoisonInfoDisplayed[0]
				WC.hidePoisonInfo(0)
			endIf
			if WC.CM.abIsChargeMeterShown[0]
				WC.CM.updateChargeMeterVisibility(0, false)
			endIf
			;Now unequip the left hand to avoid any strangeness when switching ranged weapons in bAmmoMode unless we currently have a bound ranged weapon equipped
			if !toggleWithoutEquipping && !((PlayerRef.GetEquippedItemType(1) == 7 || PlayerRef.GetEquippedItemType(1) == 12) && iEquip_WeaponExt.IsWeaponBound(PlayerRef.GetEquippedObject(1) as weapon))
				WC.UnequipHand(0)
			endIf
			;Prepare and run the animation
			if !toggleWithoutAnimation
				UI.invokebool(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", true)
				while !bReadyForAmmoModeAnim
					Utility.WaitMenuMode(0.01)
				endwhile
				AmmoModeAnimateIn()
			endIf
			if WC.bPreselectMode
				;Equip the ammo and update the left hand slot in the widget
				checkAndEquipAmmo(false, true, true)
				;Show the counter if previously hidden
				if !WC.abIsCounterShown[0]
					WC.setCounterVisibility(0, true)
				endIf
			endIf
		;Toggle out
		else
			if !toggleWithoutAnimation
				UI.invokebool(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", false)
				while !bReadyForAmmoModeAnim
					Utility.WaitMenuMode(0.01)
				endwhile
				AmmoModeAnimateOut(toggleWithoutEquipping)
			endIf
		endIf
		Self.UnregisterForModEvent("iEquip_ReadyForAmmoModeAnimation")
	endIf
	debug.trace("iEquip_AmmoMode toggleAmmoMode end")
endFunction

event ReadyForAmmoModeAnimation(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_AmmoMode ReadyForAmmoModeAnimation start")
	If(sEventName == "iEquip_ReadyForAmmoModeAnimation")
		bReadyForAmmoModeAnim = true
	endIf
	debug.trace("iEquip_AmmoMode ReadyForAmmoModeAnimation end")
endEvent

function AmmoModeAnimateIn()
	debug.trace("iEquip_AmmoMode AmmoModeAnimateIn start")		
	;Get icon name and item name data for the item currently showing in the left hand slot and the ammo to be equipped
	int ammoObject = jArray.getObj(aiTargetQ[Q], aiCurrentAmmoIndex[Q])
	string[] widgetData = new string[4]
	if jArray.count(WC.aiTargetQ[0]) > 0
		widgetData[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipIcon")
		widgetData[1] = WC.asCurrentlyEquipped[0]
	else
		widgetData[0] = "Fist"
		widgetData[1] = "$iEquip_common_Unarmed"
	endIf
	widgetData[2] = jMap.getStr(ammoObject, "iEquipIcon") + sAmmoIconSuffix
	widgetData[3] = asCurrentAmmo[Q]
	;Set the left preselect index to whatever is currently equipped in the left hand ready for cycling the preselect slot in ammo mode
	WC.aiCurrentlyPreselected[0] = WC.aiCurrentQueuePosition[0]
	;Update the left hand widget - will animate the current left item to the left preselect slot and animate in the ammo to the main left slot
	Self.RegisterForModEvent("iEquip_AmmoModeAnimationComplete", "onAmmoModeAnimationComplete")
	PM.bWaitingForAmmoModeAnimation = true
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".ammoModeAnimateIn", widgetData)
	WC.bCyclingLHPreselectInAmmoMode = true
	WC.updateAttributeIcons(0, WC.aiCurrentlyPreselected[0], false, true)
	;If we've just equipped a bound weapon the ammo will already be equipped, otherwise go ahead and equip the ammo
	if bBoundAmmoAdded
		bBoundAmmoAdded = false ;Reset
	else
		checkAndEquipAmmo(false, true, false)
	endIf
	;Update the left hand counter
	WC.setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(ammoObject, "iEquipForm")))
	;Show the counter if previously hidden
	if !WC.abIsCounterShown[0]
		WC.setCounterVisibility(0, true)
	endIf
	;Show the names if previously faded out on timer	
	if WC.bNameFadeoutEnabled
		if !WC.abIsNameShown[0] ;Left Name
			WC.showName(0)
		endIf
		if !WC.abIsNameShown[5] ;Left Preselect Name
			WC.showName(5)
		endIf
	endIf
	debug.trace("iEquip_AmmoMode AmmoModeAnimateIn end")
endFunction

function AmmoModeAnimateOut(bool toggleWithoutEquipping = false)
	debug.trace("iEquip_AmmoMode AmmoModeAnimateOut start")
	WC.hideAttributeIcons(5)
	int leftPreselectObject = -1
	string[] widgetData = new string[3]
	if jArray.count(aiTargetQ[Q]) < 1
		widgetData[0] = "Empty"
	else	
		widgetData[0] = jMap.getStr(jArray.getObj(aiTargetQ[Q], aiCurrentAmmoIndex[Q]), "iEquipIcon") + sAmmoIconSuffix
	endIf
	bool mainQueueIsEmpty = (jArray.count(WC.aiTargetQ[0]) < 1)
	;Get icon and item name for item currently showing in the left preselect slot ready to update the main slot
	if !mainQueueIsEmpty
		leftPreselectObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentlyPreselected[0])
		widgetData[1] = jMap.getStr(leftPreselectObject, "iEquipIcon")
		widgetData[2] = jMap.getStr(leftPreselectObject, "iEquipName")
	else
		widgetData[1] = "Fist"
		widgetData[2] = "$iEquip_common_Unarmed"
	endIf
	;Update the widget - will throw away the ammo and animate the icon from preselect back to main position
	Self.RegisterForModEvent("iEquip_AmmoModeAnimationComplete", "onAmmoModeAnimationComplete")
	PM.bWaitingForAmmoModeAnimation = true
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".ammoModeAnimateOut", widgetData)
	if mainQueueIsEmpty
		if (jArray.count(WC.aiTargetQ[1]) < 2)
			WC.UnequipHand(1)
			WC.setSlotToEmpty(1, true, true)
		else
			WC.cycleSlot(1, false, true)
		endIf
	else
		;Update the main slot index
		if !WC.bPreselectMode
			WC.aiCurrentQueuePosition[0] = WC.aiCurrentlyPreselected[0]
			WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipName")
		endIf
		;And re-equip the left hand item, which should in turn force a re-equip on the right hand to a 1H item, as long as we've not just toggled out of ammo mode as a result of us equipping a 2H weapon in the right hand
		if !toggleWithoutEquipping
			WC.cycleHand(0, WC.aiCurrentQueuePosition[0], jMap.getForm(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipForm"))
		endIf
	endIf
	;Show the left name if previously faded out on timer
	if WC.bNameFadeoutEnabled && !WC.abIsNameShown[0] ;Left Name
		WC.showName(0)
	endIf
	;Hide the left hand counter again if the new left hand item doesn't need it
	if mainQueueIsEmpty || (!WC.itemRequiresCounter(0) && !WC.isWeaponPoisoned(0, WC.aiCurrentQueuePosition[0], true))
		WC.setCounterVisibility(0, false)
	;Otherwise update the counter for the new left hand item
	else
		if WC.itemRequiresCounter(0) && leftPreselectObject != -1
			WC.setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(leftPreselectObject, "iEquipForm")))
		elseif WC.isWeaponPoisoned(0, WC.aiCurrentQueuePosition[0], true)
			WC.checkAndUpdatePoisonInfo(0)
		endIf
	endIf
	if !mainQueueIsEmpty
		WC.CM.checkAndUpdateChargeMeter(0)
	endIf
	debug.trace("iEquip_AmmoMode AmmoModeAnimateOut end")
endFunction

event onAmmoModeAnimationComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_AmmoMode onAmmoModeAnimationComplete start")
	If(sEventName == "iEquip_AmmoModeAnimationComplete")
		PM.bWaitingForAmmoModeAnimation = false
		Self.UnregisterForModEvent("iEquip_AmmoModeAnimationComplete")
	endIf
	debug.trace("iEquip_AmmoMode onAmmoModeAnimationComplete end")
endEvent

function cycleAmmo(bool reverse, bool ignoreEquipOnPause = false)
	debug.trace("iEquip_AmmoMode cycleAmmo start")
	int queueLength = jArray.count(aiTargetQ[Q])
	int targetIndex
	;No need for any checking here at all, we're just cycling ammo so just cycle and equip
	if reverse
		targetIndex = aiCurrentAmmoIndex[Q] - 1
		if targetIndex < 0
			targetIndex = queueLength - 1
		endIf
	else
		targetIndex = aiCurrentAmmoIndex[Q] + 1
		if targetIndex == queueLength
			targetIndex = 0
		endIf
	endIf
	if targetIndex != aiCurrentAmmoIndex[Q]
		aiCurrentAmmoIndex[Q] = targetIndex
		checkAndEquipAmmo(reverse, ignoreEquipOnPause)
	endIf
	debug.trace("iEquip_AmmoMode cycleAmmo end")
endFunction

function selectBestAmmo(int thisQ)
	debug.trace("iEquip_AmmoMode selectBestAmmo start")
	aiCurrentAmmoIndex[thisQ] = 0
	asCurrentAmmo[thisQ] = jMap.getStr(jArray.getObj(aiTargetQ[thisQ], 0), "iEquipName")
	if bAmmoMode && (thisQ == Q)
		checkAndEquipAmmo(false, true)
	endIf
	debug.trace("iEquip_AmmoMode selectBestAmmo end")
endFunction

function selectLastUsedAmmo(int thisQ)
	debug.trace("iEquip_AmmoMode selectLastUsedAmmo start")
	int i
	bool found
	if asCurrentAmmo[thisQ] != ""
		while i < jArray.count(aiTargetQ[thisQ]) && !found
			if asCurrentAmmo[thisQ] != jMap.getStr(jArray.getObj(aiTargetQ[thisQ], i), "iEquipName")
				i += 1
			else
				found = true
			endIf
		endwhile
	endIf
	;if the last used ammo isn't found in the newly sorted queue then set the queue position to 0 and update the name ready for updateWidget
	if !found
		aiCurrentAmmoIndex[thisQ] = 0
		asCurrentAmmo[thisQ] = jMap.getStr(jArray.getObj(aiTargetQ[thisQ], 0), "iEquipName")
	;if the last used ammo is found in the newly sorted queue then set the queue position to the index where it was found
	else
		aiCurrentAmmoIndex[thisQ] = i
	endIf
	debug.trace("iEquip_AmmoMode selectLastUsedAmmo end")
endFunction

function checkAndEquipAmmo(bool reverse, bool ignoreEquipOnPause, bool animate = true, bool equip = true)
	debug.trace("iEquip_AmmoMode checkAndEquipAmmo start")
	debug.trace("iEquip_AmmoMode checkAndEquipAmmo - reverse: " + reverse + ", ignoreEquipOnPause: " + ignoreEquipOnPause + ", animate: " + animate)
	currentAmmoForm = jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentAmmoIndex[Q]), "iEquipForm")
	int ammoCount = PlayerRef.GetItemCount(currentAmmoForm)
	;Check we've still got the at least one of the target ammo, if not remove it from the queue and advance the queue again
	if ammoCount < 1
		removeAmmoFromQueue(Q, aiCurrentAmmoIndex[Q])
		cycleAmmo(reverse, ignoreEquipOnPause)
	;Otherwise update the widget and either register for the EquipOnPause update or equip immediately
	else
		if animate
			int ammoObject = jArray.getObj(aiTargetQ[Q], aiCurrentAmmoIndex[Q])
			asCurrentAmmo[Q] = jMap.getStr(ammoObject, "iEquipName")

			float fNameAlpha = WC.afWidget_A[8]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			;Update the widget
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			If(iHandle)
				UICallback.PushInt(iHandle, 0) ;Left hand widget
				UICallback.PushString(iHandle, jMap.getStr(ammoObject, "iEquipIcon") + sAmmoIconSuffix) ;New icon
				UICallback.PushString(iHandle, asCurrentAmmo[Q]) ;New name
				UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
				UICallback.Send(iHandle)
			endIf
			;Update the left hand counter
			setSlotCount(ammoCount)
			if !WC.abIsCounterShown[0]
				WC.setCounterVisibility(0, true)
			endIf
			if WC.bNameFadeoutEnabled && !WC.abIsNameShown[0] ;Left Name
				WC.showName(0)
			endIf
		endIf
		;Equip the ammo
		if equip
			if !ignoreEquipOnPause && WC.bEquipOnPause
				WC.LHUpdate.registerForEquipOnPauseUpdate(Reverse, true)
			else
				debug.trace("iEquip_AmmoMode checkAndEquipAmmo - about to equip " + asCurrentAmmo[Q])
				PlayerRef.EquipItemEx(currentAmmoForm as Ammo)
			endIf
		endIf
	endIf
	debug.trace("iEquip_AmmoMode checkAndEquipAmmo end")
endFunction

function removeAmmoFromQueue(int isBolt, int i)
	debug.trace("iEquip_AmmoMode removeAmmoFromQueue start")
	iEquip_AmmoItemsFLST.RemoveAddedForm(jMap.getForm(jArray.getObj(aiTargetQ[isBolt], i), "iEquipForm"))
	EH.updateEventFilter(iEquip_AmmoItemsFLST)
	jArray.eraseIndex(aiTargetQ[isBolt], i)
	if aiCurrentAmmoIndex[isBolt] > i ;if the item being removed is before the currently equipped item in the queue update the index for the currently equipped item
		aiCurrentAmmoIndex[isBolt] = aiCurrentAmmoIndex[isBolt] - 1
	elseif aiCurrentAmmoIndex[isBolt] == i ;if you have removed the currently equipped item then if it was the last in the queue advance to index 0 and cycle the slot
		if aiCurrentAmmoIndex[isBolt] == jArray.count(aiTargetQ[isBolt])
			aiCurrentAmmoIndex[isBolt] = 0
		endIf
	endIf
	debug.trace("iEquip_AmmoMode removeAmmoFromQueue end")
endFunction

function setSlotCount(int count)
	debug.trace("iEquip_AmmoMode setSlotCount start")
	debug.trace("iEquip_AmmoMode setSlotCount - count: " + count)
	int[] widgetData = new int[2]
	widgetData[1] = count
	UI.invokeIntA(HUD_MENU, WidgetRoot + ".updateCounter", widgetData)
	debug.trace("iEquip_AmmoMode setSlotCount end")
endFunction

bool function switchingRangedWeaponType(int itemType)
	debug.trace("iEquip_AmmoMode switchingRangedWeaponType start")
	debug.trace("iEquip_AmmoMode switchingRangedWeaponType end")
	return Q != ((itemType == 9) as int)
endFunction

function equipAmmo()
	debug.trace("iEquip_AmmoMode equipAmmo start")
	PlayerRef.EquipItemEx(currentAmmoForm as Ammo)
	debug.trace("iEquip_AmmoMode equipAmmo end")
endFunction

function onBoundRangedWeaponEquipped(int weaponType)
	debug.trace("iEquip_AmmoMode onBoundRangedWeaponEquipped start")
	Q = (weaponType == 9) as int
	int i = 100 ;Max wait while is 1 sec
	while !bBoundAmmoAdded && i > 0
		Utility.WaitMenuMode(0.01)
		i -= 1
	endWhile
	debug.trace("iEquip_WidgetCore onBoundWeaponEquipped - bBoundAmmoAdded: " + bBoundAmmoAdded + ", breakout count: " + (100 - i)) 
	;If the bound ammo has not been detected and added to the queue we just need to assume it's there and add a dummy to the queue so it can be displayed in the widget
	if !bBoundAmmoAdded
		int boundAmmoObj = jMap.object()
		jMap.setStr(boundAmmoObj, "iEquipIcon", asBoundAmmoIcons[Q])
		jMap.setStr(boundAmmoObj, "iEquipName", asBoundAmmoNames[Q])
		jArray.addObj(aiTargetQ[Q], boundAmmoObj)
		;Set the current queue position and name to the last index (ie the newly added bound ammo)
		aiCurrentAmmoIndex[Q] = jArray.count(aiTargetQ[Q]) - 1
		asCurrentAmmo[Q] = asBoundAmmoNames[Q]
		bBoundAmmoAdded = true
	endIf
	toggleAmmoMode()
	debug.trace("iEquip_AmmoMode onBoundRangedWeaponEquipped end")
endFunction

function addBoundAmmoToQueue(form boundAmmo, string ammoName)
	debug.trace("iEquip_AmmoMode addBoundAmmoToQueue start")
	debug.trace("iEquip_AmmoMode addBoundAmmoToQueue - ammoName: " + ammoName)
	Q = (boundAmmo as ammo).isBolt() as int
	;If we've already added a dummy object to the ammo queue we only need to add the form
	int targetObject = jArray.getObj(aiTargetQ[Q], jArray.count(aiTargetQ[Q]) - 1)
	currentAmmoForm = boundAmmo
	if jMap.getStr(targetObject, "iEquipName") == "$iEquip_common_BoundArrow" || jMap.getStr(targetObject, "iEquipName") == "$iEquip_common_BoundBolt"
		;debug.trace("iEquip_AmmoMode addBoundAmmoToQueue - adding Form to dummy object")
		jMap.setForm(targetObject, "iEquipForm", boundAmmo)
		;Check and update the name if needed ie Arcane Archery equips bound ammo with names matching the weapon type such as Fire Arrow, etc
		if jMap.getStr(targetObject, "iEquipName") != ammoName
			jMap.setStr(targetObject, "iEquipName", ammoName)
		endIf
	;Otherwise create a new jMap object for the ammo and add it to the relevant ammo queue
	else
		int boundAmmoObj = jMap.object()
		jMap.setForm(boundAmmoObj, "iEquipForm", boundAmmo)
		;Check for special arrows (ie Arcane Archery Fire Arrows, etc) and set icon to the magic arrows if so, if not set it to the bound ammo icon
		string ammoIcon = getAmmoIcon(boundAmmo, ammoName, Q)
		if ammoIcon == asAmmoIcons[Q]
			ammoIcon = asBoundAmmoIcons[Q]
		endIf
		debug.trace("iEquip_AmmoMode addBoundAmmoToQueue - adding new bound ammo object, ammoName: " + ammoName + ", icon: " + ammoIcon)
		jMap.setStr(boundAmmoObj, "iEquipIcon", ammoIcon)
		jMap.setStr(boundAmmoObj, "iEquipName", ammoName)
		;Set the current queue position and name to the last index (ie the newly added bound ammo)
		jArray.addObj(aiTargetQ[Q], boundAmmoObj)
		aiCurrentAmmoIndex[Q] = jArray.count(aiTargetQ[Q]) - 1 ;We've just added a new object to the queue so this is correct
		asCurrentAmmo[Q] = ammoName
		bBoundAmmoAdded = true
		abBoundAmmoInQueue[Q] = true
	endIf
	debug.trace("iEquip_AmmoMode addBoundAmmoToQueue end")
endFunction

function checkAndRemoveBoundAmmo(int weaponType)
	debug.trace("iEquip_AmmoMode checkAndRemoveBoundAmmo start")
	Q = (weaponType == 9) as int
	int targetIndex = jArray.count(aiTargetQ[Q]) - 1
	if iEquip_AmmoExt.IsAmmoBound(jMap.getForm(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipForm") as ammo)
		jArray.eraseIndex(aiTargetQ[Q], targetIndex)
	endIf
	abBoundAmmoInQueue[Q] = false
	debug.trace("iEquip_AmmoMode checkAndRemoveBoundAmmo end")
endFunction

;Functions previously in AmmoScript

function updateAmmoLists()
	debug.trace("iEquip_AmmoMode updateAmmoLists start")
	int i
	int aB
	int count
	form ammoForm
	while aB < 2
		;First check if anything needs to be removed from either queue
		count = jArray.count(aiTargetQ[aB])
		if iAmmoListSorting == 3
			jArray.clear(aiTargetQ[aB])
			iEquip_AmmoItemsFLST.Revert()
			EH.updateEventFilter(iEquip_AmmoItemsFLST)
		else
			i = 0
			while i < count && count > 0
				ammoForm = jMap.getForm(jArray.getObj(aiTargetQ[aB], i), "iEquipForm")
				if !ammoForm || PlayerRef.GetItemCount(ammoForm) < 1
					iEquip_AmmoItemsFLST.RemoveAddedForm(ammoForm)
					EH.updateEventFilter(iEquip_AmmoItemsFLST)
					jArray.eraseIndex(aiTargetQ[aB], i)
					count -= 1
					i -= 1
				endIf
				i += 1
			endWhile
		endIf
		aB += 1
	endWhile
	;Scan player inventory for all ammo and add it if not already found in the queue
	count = GetNumItemsOfType(PlayerRef, 42)
	debug.trace("iEquip_AmmoMode updateAmmoLists - Number of ammo types found in inventory: " + count)
	i = 0
	String AmmoName
	int isBolt
	while i < count && count > 0
		ammoForm = GetNthFormOfType(PlayerRef, 42, i)
		isBolt = (ammoForm as Ammo).isBolt() as int
		AmmoName = ammoForm.GetName()
		;Make sure we're not trying to add Throwing Weapons
		if !((iEquip_FormExt.IsJavelin(ammoForm) && ammoName != "Javelin") || iEquip_FormExt.IsSpear(ammoForm) || iEquip_FormExt.IsGrenade(ammoForm) || iEquip_FormExt.IsThrowingKnife(ammoForm) || iEquip_FormExt.IsThrowingAxe(ammoForm))
			if !isAlreadyInAmmoQueue(ammoForm, aiTargetQ[isBolt])
				AddToAmmoQueue(ammoForm, AmmoName, isBolt)
				abNeedsSorting[isBolt as int] = true
			endIf
		endIf
		i += 1
	endWhile
	if iAmmoListSorting == 3 || (!iAmmoListSorting == 0 && (abNeedsSorting[0] || abNeedsSorting[1] || iAmmoListSorting != ilastSortType)) ;iAmmoListSorting == 0 is Unsorted
		sortAmmoLists()
	endIf
	iLastSortType = iAmmoListSorting
	debug.trace("iEquip_AmmoMode updateAmmoLists end")
endFunction

function sortAmmoLists()
	debug.trace("iEquip_AmmoMode sortAmmoLists start")
	int i
	while i < 2
		if abNeedsSorting[i]
			if iAmmoListSorting == 1 ;By damage, highest first
				sortAmmoQueue("iEquipDamage", aiTargetQ[i], i)
			elseIf iAmmoListSorting == 2 ;By name alphabetically
				sortAmmoQueueByName(aiTargetQ[i], i)
			elseIf iAmmoListSorting == 3 ;By quantity, most first
				sortAmmoQueue("iEquipCount", aiTargetQ[i], i)
			endIf
			abNeedsSorting[i] = false
		endIf
		i += 1
	endWhile
	debug.trace("iEquip_AmmoMode sortAmmoLists end")
endFunction

function updateAmmoListsOnSettingChange()
	debug.trace("iEquip_AmmoMode updateAmmoListsOnSettingChange start")
	int i
	bool[] boundAmmoRemoved = new bool[2]
	int tempBoundAmmoObj
	while i < 2
		;First we need to check if we currently have Bound Ammo in the queue - if we do store it and remove it from the queue
		int queueLength = jArray.count(aiTargetQ[i])
		int targetObject = jArray.getObj(aiTargetQ[i], queueLength - 1)
		if iEquip_AmmoExt.IsAmmoBound(jMap.getForm(targetObject, "iEquipForm") as ammo)
			tempBoundAmmoObj = targetObject
			jArray.eraseIndex(aiTargetQ[i], queueLength - 1)
			boundAmmoRemoved[i] = true
		endIf
		i += 1
	endWhile
	;Now prepare the ammo queues with the new sorting option
	updateAmmoLists()
	;And if we previously set aside bound ammo we can now re-add it to the end of the queue and reselect it
	i = 0
	while i < 2
		if boundAmmoRemoved[i]
			jArray.addObj(aiTargetQ[i], tempBoundAmmoObj)
			aiCurrentAmmoIndex[i] = jArray.count(aiTargetQ[i]) - 1
			asCurrentAmmo[i] = jMap.getStr(tempBoundAmmoObj, "iEquipName")
		endIf
		i += 1
	endWhile
	if bAmmoMode
		checkAndEquipAmmo(false, false)
	endIf
	debug.trace("iEquip_AmmoMode updateAmmoListsOnSettingChange end")
endFunction

bool function isAlreadyInAmmoQueue(form itemForm, int targetQ)
	debug.trace("iEquip_AmmoMode isAlreadyInAmmoQueue start")
	debug.trace("iEquip_AmmoMode isAlreadyInAmmoQueue - itemForm: " + itemForm)
	bool found
	int i
	while i < JArray.count(targetQ) && !found
		found = (itemform == jMap.getForm(jArray.getObj(targetQ, i), "iEquipForm"))
		i += 1
	endWhile
	debug.trace("iEquip_AmmoMode isAlreadyInQueue() - returning found: " + found)
	debug.trace("iEquip_AmmoMode isAlreadyInAmmoQueue end")
	return found
endFunction

function AddToAmmoQueue(form ammoForm, string ammoName, int isBolt)
	debug.trace("iEquip_AmmoMode AddToAmmoQueue start")
	;Add to the formlist
	iEquip_AmmoItemsFLST.AddForm(ammoForm)
	EH.updateEventFilter(iEquip_AmmoItemsFLST)
	;Create the ammo object
	int AmmoItem = jMap.object()
	jMap.setForm(AmmoItem, "iEquipForm", ammoForm)
	jMap.setStr(AmmoItem, "iEquipIcon", getAmmoIcon(ammoForm,AmmoName, isBolt))
	jMap.setStr(AmmoItem, "iEquipName", AmmoName)
	if incrementDamage
		incrementDamage = false
		jMap.setFlt(AmmoItem, "iEquipDamage", (ammoForm as ammo).GetDamage() + 1.0) ;If we've suffixed the ammo icon name in getAmmoIcon because it's enchanted ammo then +1 the damage so they sort ahead of the base ammo
	else
		jMap.setFlt(AmmoItem, "iEquipDamage", (ammoForm as ammo).GetDamage())
	endIf
	jMap.setInt(AmmoItem, "iEquipCount", PlayerRef.GetItemCount(AmmoForm))
	;Add it to the relevant ammo queue
	jArray.addObj(aiTargetQ[isBolt], AmmoItem)
	debug.trace("iEquip_AmmoMode AddToAmmoQueue end")
endFunction

String function getAmmoIcon(form ammoForm, string AmmoName, int isBolt)
	debug.trace("iEquip_AmmoMode getAmmoIcon start")
	debug.trace("iEquip_AmmoMode getAmmoIcon - AmmoName: " + AmmoName)
	String iconName
	if iEquip_FormExt.IsSpear(ammoForm) || iEquip_FormExt.IsJavelin(ammoForm)
		iconName = "Spear"
	else
		;Set base icon string
		iconName = asAmmoIcons[isBolt]
		;Check if it is likely to have an additional effect
		if iEquip_FormExt.HasFire(ammoForm)
			iconName += "Fire"
			incrementDamage = true
		elseIf iEquip_FormExt.HasIce(ammoForm)
			iconName += "Ice"
			incrementDamage = true
		elseIf iEquip_FormExt.HasShock(ammoForm)
			iconName += "Shock"
			incrementDamage = true
		elseIf iEquip_FormExt.HasPoison(ammoForm)
			iconName += "Poison"
			incrementDamage = true
		endIf
	endIf
	debug.trace("iEquip_AmmoMode getAmmoIcon returning iconName: " + iconName)
	debug.trace("iEquip_AmmoMode getAmmoIcon end")
	return iconName
endFunction

function sortAmmoQueueByName(int targetQ, int thisQ)
	debug.trace("iEquip_AmmoMode sortAmmoQueueByName start")
	int queueLength = jArray.count(targetQ)
	int tempAmmoQ = jArray.objectWithSize(queueLength)
	int i
	string ammoName
	while i < queueLength
		ammoName = jMap.getStr(jArray.getObj(targetQ, i), "iEquipName")
		jArray.setStr(tempAmmoQ, i, ammoName)
		i += 1
	endWhile
	jArray.sort(tempAmmoQ)
	i = 0
	int iIndex
	bool found
	while i < queueLength
		ammoName = jArray.getStr(tempAmmoQ, i)
		iIndex = 0
		found = false
		while iIndex < queueLength && !found
			if ammoName != jMap.getStr(jArray.getObj(targetQ, iIndex), "iEquipName")
				iIndex += 1
			else
				found = true
			endIf
		endWhile
		if i != iIndex
			jArray.swapItems(targetQ, i, iIndex)
		endIf
		i += 1
	endWhile
	;/i = 0
    while i < queueLength
        debug.trace("iEquip_AmmoMode - sortAmmoQueueByName, sorted order: " + i + ", " + jMap.getForm(jArray.getObj(targetQ, i), "iEquipForm").GetName())
        i += 1
    endWhile/;
	selectLastUsedAmmo(thisQ)
	debug.trace("iEquip_AmmoMode sortAmmoQueueByName end")
endFunction

function sortAmmoQueue(string theKey, int targetQ, int thisQ)
	debug.trace("iEquip_AmmoMode sortAmmoQueue start")
    debug.trace("iEquip_AmmoMode sortAmmoQueue - Sort by: " + theKey)
    int n = jArray.count(targetQ)
    int i
    While (n > 1)
        i = 1
        n -= 1
        While (i <= n)
            Int j = i 
            int k = (j - 1) / 2
            While (jMap.getFlt(jArray.getObj(targetQ, j), theKey) < jMap.getFlt(jArray.getObj(targetQ, k), theKey))
                jArray.swapItems(targetQ, j, k)
                j = k
                k = (j - 1) / 2
            EndWhile
            i += 1
        EndWhile
        jArray.swapItems(targetQ, 0, n)
    EndWhile
    i = 0
    while i < n
        debug.trace("iEquip_AmmoMode - sortAmmoQueue, sorted order: " + i + ", " + jMap.getForm(jArray.getObj(targetQ, i), "iEquipForm").GetName() + ", " + theKey + ": " + jMap.getFlt(jArray.getObj(targetQ, i), theKey))
        i += 1
    endWhile
    selectBestAmmo(thisQ)
    debug.trace("iEquip_AmmoMode sortAmmoQueue end")
EndFunction
