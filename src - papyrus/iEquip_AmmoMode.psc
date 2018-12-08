
Scriptname iEquip_AmmoMode extends Quest

Import UI
Import UICallback
Import Utility
import _Q2C_Functions
Import iEquip_AmmoExt
import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_ProMode Property PM Auto
iEquip_PlayerEventHandler Property EH Auto

actor property PlayerRef auto
FormList Property iEquip_AmmoItemsFLST Auto

string Property sAmmoIconSuffix = "" Auto Hidden
int Property iAmmoListSorting = 1 Auto Hidden

bool property bAmmoMode = false auto hidden
bool bReadyForAmmoModeAnim = false
bool bBoundAmmoAdded = false
bool property bBoundAmmoInArrowQueue = false auto hidden
bool property bBoundAmmoInBoltQueue = false auto hidden

int[] aiTargetQ
int iAmmoQ

int property Q auto hidden
int[] property aiCurrentAmmoIndex auto hidden
string[] property asCurrentAmmo auto hidden
form property currentAmmoForm auto hidden

int iLastArrowSortType = 0
int iLastBoltSortType = 0

String HUD_MENU = "HUD Menu"
String WidgetRoot

event onInit()
	aiTargetQ = new int[2]
	aiTargetQ[0] = 0
	aiTargetQ[1] = 0

	aiCurrentAmmoIndex = new int[2]
	aiCurrentAmmoIndex[0] = 0
	aiCurrentAmmoIndex[1] = 0

	asCurrentAmmo = new string[2]
	asCurrentAmmo[0] = ""
	asCurrentAmmo[1] = ""
endEvent

function OnWidgetLoad()
	WidgetRoot = WC.WidgetRoot
	if aiTargetQ[0] == 0
        aiTargetQ[0] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "arrowQ", aiTargetQ[0])
    endIf
    if aiTargetQ[1] == 0
        aiTargetQ[1] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "boltQ", aiTargetQ[1])
    endIf
endFunction

;This function is normally the first thing called in the Ammo Mode sequence
function prepareAmmoQueue(int weaponType)
	debug.trace("iEquip_AmmoMode prepareAmmoQueue called, weaponType: " + weaponType)
	Q = (weaponType == 9) as int
	iAmmoQ = aiTargetQ[Q]
	updateAmmoList() ;force re-sorting by quantity
endFunction

int function getCurrentAmmoObject()
	return jArray.getObj(iAmmoQ, aiCurrentAmmoIndex[Q])
endFunction

function toggleAmmoMode(bool toggleWithoutAnimation = false, bool toggleWithoutEquipping = false)
	debug.trace("iEquip_AmmoMode toggleAmmoMode called, toggleWithoutAnimation: " + toggleWithoutAnimation + ", toggleWithoutEquipping" + toggleWithoutEquipping)
	if !bAmmoMode && jArray.count(iAmmoQ) < 1
		debug.Notification("You do not appear to have any ammo to equip for this type of weapon")
	else
		bAmmoMode = !bAmmoMode
		WC.bAmmoMode = bAmmoMode
		bReadyForAmmoModeAnim = false
		Self.RegisterForModEvent("iEquip_ReadyForAmmoModeAnimation", "ReadyForAmmoModeAnimation")
		if bAmmoMode
			;Hide the left hand poison elements if currently shown
			if WC.abPoisonInfoDisplayed[0]
				WC.hidePoisonInfo(0)
			endIf
			if WC.CM.abIsChargeMeterShown[0]
				WC.CM.updateChargeMeterVisibility(0, false)
			endIf
			;Now unequip the left hand to avoid any strangeness when switching ranged weapons in bAmmoMode
			if !(WC.asCurrentlyEquipped[1] == "Bound Bow" || WC.asCurrentlyEquipped[1] == "Bound Crossbow")
				WC.UnequipHand(0)
			endIf
			;Prepare and run the animation
			if !toggleWithoutAnimation
				UI.invokebool(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", true)
				while !bReadyForAmmoModeAnim
					Utility.Wait(0.01)
				endwhile
				AmmoModeAnimateIn()
			endIf
			if WC.bPreselectMode
				;Equip the ammo and update the left hand slot in the widget
				checkAndEquipAmmo(false, true, true)
				;Show the counter if previously hidden
				if !WC.isCounterShown(0)
					WC.setCounterVisibility(0, true)
				endIf
			endIf
		else
			if !toggleWithoutAnimation
				UI.invokebool(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", false)
				while !bReadyForAmmoModeAnim
					Utility.Wait(0.01)
				endwhile
				AmmoModeAnimateOut(toggleWithoutEquipping)
			endIf
		endIf
		Self.UnregisterForModEvent("iEquip_ReadyForAmmoModeAnimation")
	endIf
endFunction

event ReadyForAmmoModeAnimation(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_AmmoMode ReadyForAmmoModeAnimation called")
	If(sEventName == "iEquip_ReadyForAmmoModeAnimation")
		bReadyForAmmoModeAnim = true
	endIf
endEvent

function AmmoModeAnimateIn()
	debug.trace("iEquip_AmmoMode AmmoModeAnimateIn called")		
	;Get icon name and item name data for the item currently showing in the left hand slot and the ammo to be equipped
	int ammoObject = jArray.getObj(iAmmoQ, aiCurrentAmmoIndex[Q])
	string[] widgetData = new string[4]
	widgetData[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "Icon")
	widgetData[1] = WC.asCurrentlyEquipped[0]
	widgetData[2] = jMap.getStr(ammoObject, "Icon") + sAmmoIconSuffix
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
	WC.setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(ammoObject, "Form")))
	;Show the counter if previously hidden
	if !WC.isCounterShown(0)
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
endFunction

function AmmoModeAnimateOut(bool toggleWithoutEquipping = false)
	debug.trace("iEquip_AmmoMode AmmoModeAnimateOut called")
	WC.hideAttributeIcons(5)
	;Get icon and item name for item currently showing in the left preselect slot ready to update the main slot
	int leftPreselectObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentlyPreselected[0])
	string[] widgetData = new string[3]
	widgetData[0] = jMap.getStr(jArray.getObj(iAmmoQ, aiCurrentAmmoIndex[Q]), "Icon") + sAmmoIconSuffix
	widgetData[1] = jMap.getStr(leftPreselectObject, "Icon")
	widgetData[2] = jMap.getStr(leftPreselectObject, "Name")
	;Update the widget - will throw away the ammo and animate the icon from preselect back to main position
	Self.RegisterForModEvent("iEquip_AmmoModeAnimationComplete", "onAmmoModeAnimationComplete")
	PM.bWaitingForAmmoModeAnimation = true
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".ammoModeAnimateOut", widgetData)
	;Update the main slot index
	int leftObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
	if !WC.bPreselectMode
		WC.aiCurrentQueuePosition[0] = WC.aiCurrentlyPreselected[0]
		WC.asCurrentlyEquipped[0] = jMap.getStr(leftObject, "Name")
	endIf
	;And re-equip the left hand item, which should in turn force a re-equip on the right hand to a 1H item, as long as we've not just toggled out of ammo mode as a result of us equipping a 2H weapon in the right hand
	if !toggleWithoutEquipping
		WC.cycleHand(0, WC.aiCurrentQueuePosition[0], jMap.getForm(leftObject, "Form"))
	endIf
	;Show the left name if previously faded out on timer
	if WC.bNameFadeoutEnabled && !WC.abIsNameShown[0] ;Left Name
		WC.showName(0)
	endIf
	;Hide the left hand counter again if the new left hand item doesn't need it
	if !WC.itemRequiresCounter(0) && !WC.isWeaponPoisoned(0, WC.aiCurrentQueuePosition[0], true)
		WC.setCounterVisibility(0, false)
	;Otherwise update the counter for the new left hand item
	else
		if WC.itemRequiresCounter(0)
			WC.setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(leftPreselectObject, "Form")))
		elseif WC.isWeaponPoisoned(0, WC.aiCurrentQueuePosition[0], true)
			WC.checkAndUpdatePoisonInfo(0)
		endIf
	endIf
	WC.CM.checkAndUpdateChargeMeter(0)
endFunction

event onAmmoModeAnimationComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_AmmoMode onAmmoModeAnimationComplete called")
	If(sEventName == "iEquip_AmmoModeAnimationComplete")
		PM.bWaitingForAmmoModeAnimation = false
		Self.UnregisterForModEvent("iEquip_AmmoModeAnimationComplete")
	endIf
endEvent

function cycleAmmo(bool reverse, bool ignoreEquipOnPause = false)
	debug.trace("iEquip_AmmoMode cycleAmmo called")
	int queueLength = jArray.count(iAmmoQ)
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
endFunction

function selectBestAmmo()
	debug.trace("iEquip_AmmoMode selectBestAmmo called")
	aiCurrentAmmoIndex[Q] = 0
	asCurrentAmmo[Q] = jMap.getStr(jArray.getObj(iAmmoQ, 0), "Name")
endFunction

function selectLastUsedAmmo()
	debug.trace("iEquip_AmmoMode selectLastUsedAmmo called")
	string ammoName = asCurrentAmmo[Q]
	int queueLength = jArray.count(iAmmoQ)
	int iIndex = 0
	bool found = false
	while iIndex < queueLength && !found
		if ammoName != jMap.getStr(jArray.getObj(iAmmoQ, iIndex), "Name")
			iIndex += 1
		else
			found = true
		endIf
	endwhile
	;if the last used ammo isn't found in the newly sorted queue then set the queue position to 0 and update the name ready for updateWidget
	if !found
		aiCurrentAmmoIndex[Q] = 0
		asCurrentAmmo[Q] = jMap.getStr(jArray.getObj(iAmmoQ, 0), "Name")
	;if the last used ammo is found in the newly sorted queue then set the queue position to the index where it was found
	else
		aiCurrentAmmoIndex[Q] = iIndex
	endIf
endFunction

function checkAndEquipAmmo(bool reverse, bool ignoreEquipOnPause, bool animate = true, bool equip = true)
	debug.trace("iEquip_AmmoMode checkAndEquipAmmo called - reverse: " + reverse + ", ignoreEquipOnPause: " + ignoreEquipOnPause + ", animate: " + animate)
	int targetIndex = aiCurrentAmmoIndex[Q]
	currentAmmoForm = jMap.getForm(jArray.getObj(iAmmoQ, targetIndex), "Form")
	int ammoCount = PlayerRef.GetItemCount(currentAmmoForm)
	;Check we've still got the at least one of the target ammo, if not remove it from the queue and advance the queue again
	if ammoCount < 1
		removeAmmoFromQueue(targetIndex)
		cycleAmmo(reverse, ignoreEquipOnPause)
	;Otherwise update the widget and either register for the EquipOnPause update or equip immediately
	else
		if animate
			int ammoObject = jArray.getObj(iAmmoQ, targetIndex)
			asCurrentAmmo[Q] = jMap.getStr(ammoObject, "Name")

			float fNameAlpha = WC.afWidget_A[8]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			;Update the widget
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			If(iHandle)
				UICallback.PushInt(iHandle, 0) ;Left hand widget
				UICallback.PushString(iHandle, jMap.getStr(ammoObject, "Icon") + sAmmoIconSuffix) ;New icon
				UICallback.PushString(iHandle, asCurrentAmmo[Q]) ;New name
				UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
				UICallback.Send(iHandle)
			endIf
			;Update the left hand counter
			setSlotCount(ammoCount)
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
endFunction

function removeAmmoFromQueue(int iIndex)
	debug.trace("iEquip_AmmoMode removeItemFromQueue called")
	iEquip_AmmoItemsFLST.RemoveAddedForm(jMap.getForm(jArray.getObj(iAmmoQ, iIndex), "Form"))
	EH.updateEventFilter(iEquip_AmmoItemsFLST)
	jArray.eraseIndex(iAmmoQ, iIndex)
	if aiCurrentAmmoIndex[Q] > iIndex ;if the item being removed is before the currently equipped item in the queue update the index for the currently equipped item
		aiCurrentAmmoIndex[Q] = aiCurrentAmmoIndex[Q] - 1
	elseif aiCurrentAmmoIndex[Q] == iIndex ;if you have removed the currently equipped item then if it was the last in the queue advance to index 0 and cycle the slot
		if aiCurrentAmmoIndex[Q] == jArray.count(iAmmoQ)
			aiCurrentAmmoIndex[Q] = 0
		endIf
	endIf
endFunction

function updateAmmoCounterOnBowShot(Ammo akAmmo)
	debug.trace("iEquip_AmmoMode updateAmmoCounterOnBowShot called")
	form theAmmo = jMap.getForm(jArray.getObj(iAmmoQ, aiCurrentAmmoIndex[Q]), "Form")
	if akAmmo == theAmmo as Ammo
		int ammoCount = PlayerRef.GetItemCount(theAmmo)
		if ammoCount < 1
			removeAmmoFromQueue(aiCurrentAmmoIndex[Q])
			checkAndEquipAmmo(false, true)
		else
			setSlotCount(ammoCount)
		endIf
	endIf
endFunction

function updateAmmoCounterOnCrossbowShot()
	debug.trace("iEquip_AmmoMode updateAmmoCounterOnCrossbowShot called")
	int ammoCount = PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(iAmmoQ, aiCurrentAmmoIndex[Q]), "Form"))
	;debug.trace("iEquip_AmmoMode updateAmmoCounterOnCrossbowShot - ammoCount: " + ammoCount)
	if ammoCount != UI.GetString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text") as int
		if ammoCount < 1
			removeAmmoFromQueue(aiCurrentAmmoIndex[Q])
			checkAndEquipAmmo(false, true)
		else
			setSlotCount(ammoCount)
		endIf
	endIf
endfunction

function setSlotCount(int count)
	debug.trace("iEquip_AmmoMode setSlotCount called - count: " + count)
	int[] widgetData = new int[2]
	widgetData[0] = 0
	widgetData[1] = count
	UI.invokeIntA(HUD_MENU, WidgetRoot + ".updateCounter", widgetData)
endFunction

bool function switchingRangedWeaponType(int itemType)
	int currRangedWeaponType = PlayerRef.GetEquippedItemType(1)
	if currRangedWeaponType == 12
		currRangedWeaponType = 9
	endIf
	return (itemType != currRangedWeaponType)
endFunction

function equipAmmo()
	debug.trace("iEquip_AmmoMode equipAmmo called")
	PlayerRef.EquipItemEx(currentAmmoForm as Ammo)
endFunction

function onBoundRangedWeaponEquipped(int weaponType)
	Q = (weaponType == 9) as int
	iAmmoQ = aiTargetQ[Q]
	string ammoName = "Bound Arrow"
	string ammoIcon = "BoundArrow"
	if weaponType == 9
		ammoName = "Bound Bolt"
		ammoIcon = "BoundBolt"
	endIf
	int breakout = 100 ;Max wait while is 1 sec
	while !bBoundAmmoAdded && breakout > 0
		Utility.Wait(0.01)
		breakout -= 1
	endWhile
	debug.trace("iEquip_WidgetCore onBoundWeaponEquipped - bBoundAmmoAdded: " + bBoundAmmoAdded + ", breakout count: " + (100 - breakout)) 
	;If the bound ammo has not been detected and added to the queue we just need to assume it's there and add a dummy to the queue so it can be displayed in the widget
	if !bBoundAmmoAdded
		int boundAmmoObj = jMap.object()
		jMap.setStr(boundAmmoObj, "Icon", ammoIcon)
		jMap.setStr(boundAmmoObj, "Name", ammoName)
		jArray.addObj(iAmmoQ, boundAmmoObj)
		;Set the current queue position and name to the last index (ie the newly added bound ammo)
		aiCurrentAmmoIndex[Q] = jArray.count(iAmmoQ) - 1
		asCurrentAmmo[Q] = ammoName
		bBoundAmmoAdded = true
	endIf
	toggleAmmoMode()
endFunction

function addBoundAmmoToQueue(form boundAmmo, string ammoName)
	debug.trace("iEquip_AmmoMode addBoundAmmoToQueue called - ammoName: " + ammoName)
	string ammoIcon = "BoundArrow"
	;Check if it's a Bound Crossbow rather than a Bow and change name and target queue if so
	if stringutil.Find(WC.asCurrentlyEquipped[1], "cross", 0) > -1
		ammoIcon = "BoundBolt"
	endIf
	;If we've already added a dummy object to the ammo queue we only need to add the form
	int targetObject = jArray.getObj(iAmmoQ, jArray.count(iAmmoQ) - 1)
	currentAmmoForm = boundAmmo
	if stringutil.Find(jMap.getStr(targetObject, "Name"), "bound", 0) > -1
		;debug.trace("iEquip_AmmoMode addBoundAmmoToQueue - adding Form to dummy object")
		jMap.setForm(targetObject, "Form", boundAmmo)
	;Otherwise create a new jMap object for the ammo and add it to the relevant ammo queue
	else
		;debug.trace("iEquip_AmmoMode addBoundAmmoToQueue - adding new bound ammo object")
		int boundAmmoObj = jMap.object()
		jMap.setForm(boundAmmoObj, "Form", boundAmmo)
		jMap.setStr(boundAmmoObj, "Icon", ammoIcon)
		jMap.setStr(boundAmmoObj, "Name", ammoName)
		;Set the current queue position and name to the last index (ie the newly added bound ammo)
		jArray.addObj(iAmmoQ, boundAmmoObj)
		aiCurrentAmmoIndex[Q] = jArray.count(iAmmoQ) - 1 ;We've just added a new object to the queue so this is correct
		asCurrentAmmo[Q] = ammoName
		bBoundAmmoAdded = true
		if Q == 0
			bBoundAmmoInArrowQueue = true
		else
			bBoundAmmoInBoltQueue = true
		endIf
	endIf
endFunction

function checkAndRemoveBoundAmmo(int weaponType)
	debug.trace("iEquip_AmmoMode checkAndRemoveBoundAmmo called")
	iAmmoQ = aiTargetQ[(weaponType == 9) as int]
	int targetIndex = jArray.count(iAmmoQ) - 1
	if iEquip_AmmoExt.IsAmmoBound(jMap.getForm(jArray.getObj(iAmmoQ, targetIndex), "Form") as ammo)
		jArray.eraseIndex(iAmmoQ, targetIndex)
		if iAmmoListSorting == 2 || iAmmoListSorting == 4
			selectLastUsedAmmo()
		else
			selectBestAmmo()
		endIf
	endIf
	if weaponType == 7
		bBoundAmmoInArrowQueue = false
	else
		bBoundAmmoInBoltQueue = false
	endIf
endFunction

;Functions previously in AmmoScript

function updateAmmoList()
	debug.trace("iEquip_AmmoMode updateAmmoList() called")
	;First check if anything needs to be removed
	int count = jArray.count(iAmmoQ)
	int initialCount = count
	form ammoForm
	if iAmmoListSorting == 3
		jArray.clear(iAmmoQ)
	endIf
	debug.trace("iEquip_AmmoMode updateAmmoList() - " + count + " found in the queue, crossbow equipped: " + Q as bool)
	int i = 0
	while i < count && count > 0
		ammoForm = jMap.getForm(jArray.getObj(iAmmoQ, i), "Form")
		if !ammoForm || PlayerRef.GetItemCount(ammoForm) < 1
			iEquip_AmmoItemsFLST.RemoveAddedForm(ammoForm)
			EH.updateEventFilter(iEquip_AmmoItemsFLST)
			jArray.eraseIndex(iAmmoQ, i)
			count -= 1
			i -= 1
		endIf
		i += 1
	endWhile
	;Scan player inventory for all ammo and add it if not already found in the queue
	bool needsSorting = false
	count = GetNumItemsOfType(PlayerRef, 42)
	debug.trace("iEquip_AmmoMode updateAmmoList() - Number of ammo types found in inventory: " + count)
	i = 0
	String AmmoName
	while i < count && count > 0
		ammoForm = GetNthFormOfType(PlayerRef, 42, i)
		AmmoName = ammoForm.GetName()
		;The Javelin check is to get the Spears by Soolie javelins which are classed as arrows/bolts and all of which have more descriptive names than simply Javelin, which is from Throwing Weapons and is an equippable throwing weapon
		if (Q == 0 && stringutil.Find(AmmoName, "arrow", 0) > -1) || (Q == 1 && stringutil.Find(AmmoName, "bolt", 0) > -1) || (stringutil.Find(AmmoName, "Javelin", 0) > -1 && AmmoName != "Javelin")
			;Make sure we're only adding arrows to the arrow queue or bolts to the bolt queue
			if (Q == 0 && !(ammoForm as Ammo).isBolt()) || (Q == 1 && (ammoForm as Ammo).isBolt())
				if !isAlreadyInAmmoQueue(ammoForm)
					iEquip_AmmoItemsFLST.AddForm(ammoForm)
					EH.updateEventFilter(iEquip_AmmoItemsFLST)
					AddToAmmoQueue(ammoForm as Ammo, AmmoName)
					needsSorting = true
				endIf
			endIf
		endIf
		i += 1
	endWhile
	int lastSortType = iLastArrowSortType
	if Q == 1
		lastSortType = iLastBoltSortType
	endIf
	debug.trace("iEquip_AmmoMode updateAmmoList() - needsSorting: " + needsSorting)
	if iAmmoListSorting == 3 || (!iAmmoListSorting == 0 && (needsSorting || iAmmoListSorting != lastSortType)) ;iAmmoListSorting == 0 is Unsorted
		sortAmmoList()
	endIf
	if Q == 1
		iLastBoltSortType = iAmmoListSorting
	else
		iLastArrowSortType = iAmmoListSorting
	endIf
endFunction

function updateAmmoListOnSettingChange(int weaponType)
	;First we need to check if we currently have Bound Ammo in the queue - if we do store it and remove it from the queue
	bool boundAmmoRemoved = false
	int tempBoundAmmoObj
	int queueLength = jArray.count(iAmmoQ)
	int targetObject = jArray.getObj(iAmmoQ, queueLength - 1)
	if stringutil.Find(jMap.getStr(targetObject, "Name"), "bound", 0) > -1
		tempBoundAmmoObj = targetObject
		jArray.eraseIndex(iAmmoQ, queueLength - 1)
		boundAmmoRemoved = true
	endIf
	;Now prepare the ammo queue with the new sorting option
	prepareAmmoQueue(weaponType)
	;And if we previously set aside bound ammo we can now re-add it to the end of the queue and reselect it
	if boundAmmoRemoved
		jArray.addObj(iAmmoQ, tempBoundAmmoObj)
		aiCurrentAmmoIndex[Q] = jArray.count(iAmmoQ) - 1
		asCurrentAmmo[Q] = jMap.getStr(tempBoundAmmoObj, "Name")
	endIf
	checkAndEquipAmmo(false, false)
endFunction

bool function isAlreadyInAmmoQueue(form itemForm)
	debug.trace("iEquip_AmmoWidget isAlreadyInQueue() called - itemForm: " + itemForm)
	bool found = false
	int i = 0
	while i < JArray.count(iAmmoQ) && !found
		found = (itemform == jMap.getForm(jArray.getObj(iAmmoQ, i), "Form"))
		i += 1
	endWhile
	debug.trace("iEquip_AmmoWidget isAlreadyInQueue() - returning found: " + found)
	return found
endFunction

function AddToAmmoQueue(Ammo AmmoForm, string AmmoName)
	debug.trace("iEquip_AmmoMode AddToAmmoQueue() called")
	;Create the ammo object
	int AmmoItem = jMap.object()
	jMap.setForm(AmmoItem, "Form", AmmoForm as Form)
	jMap.setStr(AmmoItem, "Icon", getAmmoIcon(AmmoName))
	jMap.setStr(AmmoItem, "Name", AmmoName)
	jMap.setFlt(AmmoItem, "Damage", AmmoForm.GetDamage())
	jMap.setInt(AmmoItem, "Count", PlayerRef.GetItemCount(AmmoForm))
	;Add it to the relevant ammo queue
	jArray.addObj(iAmmoQ, AmmoItem)
endFunction

String function getAmmoIcon(string AmmoName)
	debug.trace("iEquip_AmmoMode getAmmoIcon() called - Q: " + Q + ", AmmoName: " + AmmoName)
	String iconName = ""
	;Set base icon
	if Q == 0
		iconName = "Arrow"
	else
		iconName = "Bolt"
	endIf
	;If this all looks a little strange it is because StringUtil find() is case sensitive so where possible I've ommitted the first letter to catch for example Spear and spear with pear
	if stringutil.Find(AmmoName, "spear", 0) > -1 || stringutil.Find(AmmoName, "javelin", 0) > -1
		iconName = "Spear"
	endIf
	;Check if it is likely to have an additional effect - bit hacky checking the name but I've no idea how to check for attached magic effects!
	if iconName != "Spear"
		if stringutil.Find(AmmoName, "fire", 0) > -1 || stringutil.Find(AmmoName, "torch", 0) > -1 || stringutil.Find(AmmoName, "burn", 0) > -1 || stringutil.Find(AmmoName, "incendiary", 0) > -1
			iconName += "Fire"
		elseIf stringutil.Find(AmmoName, "frost", 0) > -1 || stringutil.Find(AmmoName, "ice", 0) > -1 || stringutil.Find(AmmoName, "freez", 0) > -1 || stringutil.Find(AmmoName, "cold", 0) > -1
			iconName += "Ice"
		elseIf stringutil.Find(AmmoName, "shock", 0) > -1 || stringutil.Find(AmmoName, "spark", 0) > -1 || stringutil.Find(AmmoName, "electr", 0) > -1
			iconName += "Shock"
		elseIf stringutil.Find(AmmoName, "poison", 0) > -1
			iconName += "Poison"
		endIf
	endIf
	debug.trace("iEquip_AmmoMode getAmmoIcon() returning iconName: " + iconName)
	return iconName
endFunction

function sortAmmoList()
	debug.trace("iEquip_AmmoMode sortAmmoList() called - Sort: " + iAmmoListSorting)
	if iAmmoListSorting == 1 ;By damage, highest first
		sortAmmoQueue("Damage")
	elseIf iAmmoListSorting == 2 ;By name alphabetically
		sortAmmoQueueByName()
	elseIf iAmmoListSorting == 3 ;By quantity, most first
		sortAmmoQueue("Count")
	endIf
endFunction

function sortAmmoQueueByName()
	debug.trace("iEquip_AmmoMode sortAmmoQueueByName() called")
	int queueLength = jArray.count(iAmmoQ)
	int tempAmmoQ = jArray.objectWithSize(queueLength)
	int i = 0
	string ammoName
	while i < queueLength
		ammoName = jMap.getStr(jArray.getObj(iAmmoQ, i), "Name")
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
			if ammoName != jMap.getStr(jArray.getObj(iAmmoQ, iIndex), "Name")
				iIndex += 1
			else
				found = true
			endIf
		endWhile
		if i != iIndex
			jArray.swapItems(iAmmoQ, i, iIndex)
		endIf
		i += 1
	endWhile
	selectLastUsedAmmo()
endFunction

function sortAmmoQueue(string theKey)
    debug.trace("iEquip_AmmoMode sortAmmoQueue called - Sort by: " + theKey)
    int n = jArray.count(iAmmoQ)
    int i
    While (n > 1)
        i = 1
        n -= 1
        While (i <= n)
            Int j = i 
            int k = (j - 1) / 2
            While (jMap.getFlt(jArray.getObj(iAmmoQ, j), theKey) < jMap.getFlt(jArray.getObj(iAmmoQ, k), theKey))
                jArray.swapItems(iAmmoQ, j, k)
                j = k
                k = (j - 1) / 2
            EndWhile
            i += 1
        EndWhile
        jArray.swapItems(iAmmoQ, 0, n)
    EndWhile
    ;/i = 0
   	n = jArray.count(iAmmoQ)
    while i < n
        debug.trace("iEquip_AmmoMode - sortAmmoQueue, sorted order: " + i + ", " + jMap.getForm(jArray.getObj(iAmmoQ, i), "Form").GetName() + ", " + theKey + ": " + jMap.getFlt(jArray.getObj(iAmmoQ, i), theKey))
        i += 1
    endWhile/;
    selectBestAmmo()
EndFunction
