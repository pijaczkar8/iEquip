
Scriptname iEquip_ProMode extends Quest

Import UI
Import UICallback
Import Utility
import _Q2C_Functions
import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_PotionScript Property PO Auto

String HUD_MENU = "HUD Menu"
String WidgetRoot

bool property bPreselectMode = false auto hidden
bool bPreselectModeFirstLook = true
bool bEquippingAllPreselectedItems = false
bool bTogglingPreselectOnEquipAll = false
bool bReadyForPreselectAnim = false
bool bAllEquipped = false
bool bLeftPreselectShown = true
bool bRightPreselectShown = true
bool bShoutPreselectShown = true
bool bAmmoModePreselectModeFirstLook = true

bool property bWaitingForAmmoModeAnimation = false Auto Hidden
bool bAmmoModeActiveOnTogglePreselect = false
bool property bBlockQuickDualCast = false auto hidden

bool property bCurrentlyQuickRanged = false auto hidden
bool property bCurrentlyQuickHealing = false auto hidden
int iQuickHealSlotsEquipped = -1
int iPreviousLeftHandIndex
int iPreviousRightHandIndex

;MCM Properties
bool property bShoutPreselectEnabled = true auto hidden
bool property bPreselectSwapItemsOnEquip = false auto hidden
bool property bTogglePreselectOnEquipAll = false auto hidden
bool property bQuickShield2HSwitchAllowed = true auto hidden
int property iPreselectQuickShield = 1 auto hidden
bool property bQuickShieldPreferMagic = false auto hidden
string property sQuickShieldPreferredMagicSchool = "Destruction" auto hidden
int property iPreselectQuickRanged = 1 auto hidden
int property iQuickRangedPreferredWeaponType = 0 auto hidden
int property iQuickRangedSwitchOutAction = 1 auto hidden
string property sQuickRangedPreferredMagicSchool = "Destruction" auto hidden
bool property bQuickDualCastMustBeInBothQueues = false auto hidden
bool property bQuickHealPreferMagic = false auto hidden
int property iQuickHealEquipChoice = 2 auto hidden
bool property bQuickHealSwitchBackEnabled = true auto hidden

actor property PlayerRef auto

function OnWidgetLoad()
	WidgetRoot = WC.WidgetRoot
endFunction

function togglePreselectMode()
	debug.trace("iEquip_ProMode togglePreselectMode Set called")
	bPreselectMode = !bPreselectMode
	WC.bPreselectMode = bPreselectMode
	bool[] args = new bool[5]
	if bPreselectMode
		Self.RegisterForModEvent("iEquip_ReadyForPreselectAnimation", "ReadyForPreselectAnimation")
		int Q = 0
		if AM.bAmmoMode
			bAmmoModeActiveOnTogglePreselect = true
			Q = 1 ;Skip updating left hand preselect if currently in ammo mode as it's already set
		endIf
		while Q < 3
			int iCount = JArray.count(WC.aiTargetQ[Q])
			;if any of the queues have less than 3 items in it then there is either nothing to preselect (1 item in queue) or you'd just be doing the same as regularly cycling two items so no need for preselect, therefore disable preselect elements for that slot
			if iCount < 3
				WC.aiCurrentlyPreselected[Q] = -1
			else
				;Otherwise if enabled, set left, right and shout preselect to next item in each queue, play power up sound, update widget and show preselect elements
				WC.aiCurrentlyPreselected[Q] = WC.aiCurrentQueuePosition[Q] + 1
				if WC.aiCurrentlyPreselected[Q] == iCount
					WC.aiCurrentlyPreselected[Q] = 0
				endIf
				debug.trace("iEquip_ProMode isPreselectMode Set(), bPreselectMode: " + bPreselectMode + ", Q: " + Q + ", aiCurrentlyPreselected[" + Q + "]: " + WC.aiCurrentlyPreselected[Q])
				WC.updateWidget(Q, WC.aiCurrentlyPreselected[Q])
			endIf
			Q += 1
		endwhile

		bLeftPreselectShown = true
		if WC.aiCurrentlyPreselected[0] == -1
			bLeftPreselectShown = false
		endIf
		bRightPreselectShown = true
		if WC.aiCurrentlyPreselected[1] == -1
			bRightPreselectShown = false
		endIf
		;Also if shout preselect has been turned off in the MCM or hidden in Edit Mode make sure it stays hidden before showing the preselect group
		bShoutPreselectShown = true
		if !WC.bShoutEnabled || !bShoutPreselectEnabled || WC.aiCurrentlyPreselected[2] == -1
			bShoutPreselectShown = false
		endIf

		;Add showLeft/showRight with check for number of items in queue must be greater than 1 (ie if only 1 in queue then nothing to preselect)
		args[0] = bLeftPreselectShown ;Show left
		args[1] = bRightPreselectShown ;Show right
		args[2] = bShoutPreselectShown ;Show shout if not hidden in edit mode or bShoutPreselectEnabled disabled in MCM
		;args[3] = EM.enableBackgrounds ;Show backgrounds if enabled
		args[3] = AM.bAmmoMode
		UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
		PreselectModeAnimateIn()
		if bPreselectModeFirstLook && !WC.EM.isEditMode
			Utility.Wait(1.0)
			Debug.MessageBox("iEQUIP Preselect Mode\n\nYou should now see up to three new slots in the iEQUIP widget for the left hand, right hand and shout slots, as long as you have more than two items in the queue and haven't hidden or disabled the main slots in Edit Mode or the MCM\nYour hotkeys will now cycle the preselect slots rather than the main slots, and long press will then equip the preselected item.\nPress and hold the left or right keys to equip all preselected items in one go.\nPress and hold the consumable key to exit Preselect Mode")
			bPreselectModeFirstLook = false
			if WC.RightHandWeaponIsRanged() && bAmmoModePreselectModeFirstLook
				Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
				bAmmoModePreselectModeFirstLook = false
			endIf
		endIf
	else
		;Hide preselect widget elements
		PreselectModeAnimateOut()
		if AM.bAmmoMode || WC.RightHandWeaponIsRanged()
			args[0] = true
		else
			args[0] = false ;Hide left
		endIf
		args[1] = false ;Hide right
		args[2] = false ;Hide shout
		args[3] = AM.bAmmoMode
		Utility.Wait(2.0)
		UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
		Self.UnregisterForModEvent("iEquip_ReadyForPreselectAnimation")
	endIf
endFunction

function PreselectModeAnimateIn()
	debug.trace("iEquip_ProMode PreselectModeAnimateIn called")
	bool[] args = new bool[3]
	if AM.bAmmoMode
		args[0] = false ;Don't animate the left icon if already shown in ammo mode
	else
		args[0] = bLeftPreselectShown
	endIf
	args[1] = bShoutPreselectShown
	args[2] = bRightPreselectShown
	UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn", args)
	if WC.bNameFadeoutEnabled
		int i = 0
		while i < 3
			if i < 2
				WC.updateAttributeIcons(i, WC.aiCurrentlyPreselected[i])
			endIf
			if !WC.abIsNameShown[i]
				WC.showName(i)
			endIf
			i += 1
		endwhile
		if bLeftPreselectShown
			WC.LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bRightPreselectShown
			WC.RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bShoutPreselectShown
			WC.SPNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
endFunction

function PreselectModeAnimateOut()
	debug.trace("iEquip_ProMode PreselectModeAnimateOut called")
	if !bTogglingPreselectOnEquipAll
		bool[] args = new bool[3]
		args[0] = bRightPreselectShown
		args[1] = bShoutPreselectShown
		args[2] = bLeftPreselectShown
		if AM.bAmmoMode || WC.RightHandWeaponIsRanged()
			args[2] = false ;Stop left slot from animating out if we currently have a ranged weapon equipped in the right hand or are in ammo mode as we still need it to show in regular mode
		endIf
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf
	int i = 0
	while i < 3
		if (i == 0 && !AM.bAmmoMode) || i == 1
			WC.hideAttributeIcons(i + 5)
		endIf
		if WC.bNameFadeoutEnabled && !WC.abIsNameShown[i]
			WC.showName(i)
		endIf
		i += 1
	endwhile
	if bTogglingPreselectOnEquipAll
		bTogglingPreselectOnEquipAll = false
	endIf
endFunction

function cyclePreselectSlot(int Q, int queueLength, bool Reverse, bool animate = true)
	debug.trace("iEquip_ProMode cyclePreselectSlot called")
	int targetIndex
	if Reverse
		targetIndex = WC.aiCurrentlyPreselected[Q] - 1
		if targetIndex == WC.aiCurrentQueuePosition[Q] ;Can't preselect the item you already have equipped in the widget so move on another index
			targetIndex -= 1
		endIf
		if targetIndex < 0
			targetIndex = queueLength - 1
			if targetIndex == WC.aiCurrentQueuePosition[Q] ;Have to recheck again in case aiCurrentQueuePosition[Q] == queueLength - 1
				targetIndex -= 1
			endIf
		endIf
	else
		targetIndex = WC.aiCurrentlyPreselected[Q] + 1
		if targetIndex == WC.aiCurrentQueuePosition[Q] ;Can't preselect the item you already have equipped in the widget so move on another index
			targetIndex += 1
		endIf
		if targetIndex == queueLength
			targetIndex = 0
			if targetIndex == WC.aiCurrentQueuePosition[Q] ;Have to recheck again in case aiCurrentQueuePosition[Q] == 0
				targetIndex += 1
			endIf
		endIf
	endIf
	WC.aiCurrentlyPreselected[Q] = targetIndex
	if animate
		WC.updateWidget(Q, targetIndex, false, true)
	endIf
endFunction

function equipPreselectedItem(int Q)
	debug.trace("iEquip_ProMode equipPreselectedItem called - Q: " + Q + ", bEquippingAllPreselectedItems: " + bEquippingAllPreselectedItems)
	if !bEquippingAllPreselectedItems
		bReadyForPreselectAnim = false
		UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	endIf
	if AM.bBoundAmmoInArrowQueue
    	AM.checkAndRemoveBoundAmmo(7)	
    endIf
    if AM.bBoundAmmoInBoltQueue
    	AM.checkAndRemoveBoundAmmo(9)
    endIf
    int iHandle
	int itemToEquip = WC.aiCurrentlyPreselected[Q]
	int targetArray = WC.aiTargetQ[Q]
	int targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[Q])
	form targetItem = jMap.getForm(targetObject, "Form")
	int itemType = jMap.getInt(targetObject, "Type")
	if (itemType == 7 || itemType == 9)
		;checkAndRemoveBoundAmmo(itemType)
		if (!WC.RightHandWeaponIsRanged() || AM.switchingRangedWeaponType(itemType) || AM.iAmmoListSorting == 3)
			AM.prepareAmmoQueue(itemType)
		endIf
	endIf
	string currIcon =  jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[Q]), "Icon")
    string currPIcon = jMap.getStr(targetObject, "Icon")
	string newName = jMap.getStr(targetObject, "Name")
	string newIcon = currPIcon
    ;if we've chosen to swap items when equipping preselect then set the new preselect index to the currently equipped item ready to animate into the preselect slot
    if bPreselectSwapItemsOnEquip
		WC.aiCurrentlyPreselected[Q] = WC.aiCurrentQueuePosition[Q]
    ;Otherwise advance preselect queue
	else
    	cyclePreselectSlot(Q, jArray.count(targetArray), false, false)
    endIf
    ;Update the attribute icons for the new item in the preselect slot
    WC.updateAttributeIcons(Q, WC.aiCurrentlyPreselected[Q], false, true)
    ;Do widget animation here if not bEquippingAllPreselectedItems
    if !bEquippingAllPreselectedItems
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[Q])
		while !bReadyForPreselectAnim
			Utility.Wait(0.01)
		endwhile
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Which slot we're updating
			UICallback.PushString(iHandle, currIcon) ;Current icon
			UICallback.PushString(iHandle, newIcon) ;New icon
			UICallback.PushString(iHandle, newName) ;New name
			UICallback.PushString(iHandle, currPIcon) ;Current preselect icon
			UICallback.PushString(iHandle, jMap.getStr(targetObject, "Icon")) ;New preselect icon
			UICallback.PushString(iHandle, jMap.getStr(targetObject, "Name")) ;New preselect name
			UICallback.Send(iHandle)
		endIf
		if WC.bNameFadeoutEnabled
			if Q == 0
				WC.LNUpdate.registerForNameFadeoutUpdate()
				WC.LPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 1
				WC.RNUpdate.registerForNameFadeoutUpdate()
				WC.RPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 2
				WC.SNUpdate.registerForNameFadeoutUpdate()
				WC.SPNUpdate.registerForNameFadeoutUpdate()	
			endIf
		endIf
	endIf
	;if we're in ammo mode whilst in Preselect Mode and either we're equipping the left preselected item, or we're equipping the right and it's not another ranged weapon we need to turn ammo mode off
	if (AM.bAmmoMode && (Q == 0 || Q == 1 && !(itemType == 7 || itemType == 9))) || (!AM.bAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9)))
		AM.toggleAmmoMode(true, (itemType == 5 || itemType == 6)) ;Toggle ammo mode off/on without the animation, and without re-equipping if RH is equipping 2H
		Utility.Wait(0.05)
		if Q == 1 && !AM.bAmmoMode ;if we're equipping the right preselected item and it's not another ranged weapon we'll just have toggled ammo mode off without animation, now we need to remove the ammo from the left slot and replace it with the current left hand item
			if bAmmoModeActiveOnTogglePreselect && !bEquippingAllPreselectedItems ;if we were in ammo mode when we toggled Preselect Mode then use the equipPreselected animation, otherwise use updateWidget
				bAmmoModeActiveOnTogglePreselect = false ;Reset
				int leftItemToEquip = WC.aiCurrentlyPreselected[0]
				targetArray = WC.aiTargetQ[0]
			    currIcon =  jMap.getStr(AM.getCurrentAmmoObject(), "Icon")
			    currPIcon = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentlyPreselected[0]), "Icon")
			    cyclePreselectSlot(0, jArray.count(targetArray), false, false)
			    targetObject = jArray.getObj(targetArray, leftItemToEquip)
			    newName = jMap.getStr(targetObject, "Name")
				newIcon = jMap.getStr(targetObject, "Icon")
				targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
				iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
				if(iHandle)
					UICallback.PushInt(iHandle, 0)
					UICallback.PushString(iHandle, currIcon)
					UICallback.PushString(iHandle, newIcon)
					UICallback.PushString(iHandle, newName)
					UICallback.PushString(iHandle, currPIcon)
					UICallback.PushString(iHandle, jMap.getStr(targetObject, "Icon"))
					UICallback.PushString(iHandle, jMap.getStr(targetObject, "Name"))
					UICallback.Send(iHandle)
				endIf
			else
				WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
			endIf
			ammo targetAmmo = AM.currentAmmoForm as Ammo
			if WC.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
				PlayerRef.UnequipItemEx(targetAmmo)
			endIf
			if WC.bNameFadeoutEnabled
				WC.LNUpdate.registerForNameFadeoutUpdate()
				WC.LPNUpdate.registerForNameFadeoutUpdate()
			endIf
			targetObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
			int leftItemType = jMap.getInt(targetObject, "Type")
			form leftItem = jMap.getForm(targetObject, "Form")
			if WC.itemRequiresCounter(0, leftItemType , jMap.getStr(targetObject, "Name"))
				WC.setSlotCount(0, PlayerRef.GetItemCount(leftItem))
				WC.setCounterVisibility(0, true)
			elseif WC.isCounterShown(0)
				WC.setCounterVisibility(0, false)
			endIf
			if !(itemType == 5 || itemType == 6) ;As long as the item which triggered toggling out of bAmmoMode isn't a 2H weapon we can now re-equip the left hand
				if leftItemType == 22
					PlayerRef.EquipSpell(leftItem as Spell, 0)
			    elseif leftItemType == 26
			    	PlayerRef.EquipItem(leftItem as Armor)
				else
				    PlayerRef.EquipItemEx(leftItem, 2, false, false)
				endIf
			endIf
		endIf

	elseif AM.bAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9) && AM.switchingRangedWeaponType(itemType))
		AM.checkAndEquipAmmo(false, true)
	endIf

	if Q == 1 && targetItem == WC.iEquip_Unarmed2H
		WC.goUnarmed()
		return
	endIf

    if Q == 2 && targetItem != none ;Shout/Power
	    if itemType == 22
	        PlayerRef.EquipSpell(targetItem as Spell, 2)
	    else
	        PlayerRef.EquipShout(targetItem as Shout)
	    endIf
	else ;Left or right hand
		WC.bPreselectSwitchingHands = false ;Reset just in case
		;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
	    int iEquipSlotId = 1
	    int otherHand = 0
	    if Q == 0
	    	iEquipSlotId = 2
	    	otherHand = 1
	    endIf
		;Unequip current item
		WC.UnequipHand(Q)
		;if equipping the left hand will cause a 2H or ranged weapon to be unequipped in the right hand, or the one handed weapon you are about to equip is already equipped in the other hand and you only have one of it then cycle the main slot and equip a suitable 1H item
		if (Q == 0 && WC.RightHandWeaponIs2hOrRanged()) || (targetItem == PlayerRef.GetEquippedObject(otherHand) && itemType != 22 && PlayerRef.GetItemCount(targetItem) < 2) || (WC.bGoneUnarmed && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9))
			if !bEquippingAllPreselectedItems
	        	WC.bPreselectSwitchingHands = true
	        endif
	        ;if any of the above checks are met then unequip the opposite hand first (possibly not required)
	        WC.UnequipHand(otherHand)
	        Utility.Wait(0.1)
	    endIf
	    ;if we are re-equipping from an unarmed state
	    if WC.bGoneUnarmed
	    	;if we're equipping a preselected 2H weapon in the right hand then update the left hand slot to show the last equipped item prior to going unarmed
	    	if itemType == 5 || itemType == 6
	    		WC.updateWidget(0, WC.aiCurrentQueuePosition[0])
	    		WC.checkAndUpdatePoisonInfo(0)
	    		WC.CM.checkAndUpdateChargeMeter(0)
	    		targetObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
	    		if WC.itemRequiresCounter(0, jMap.getInt(targetObject, "Type"))
					WC.setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "Form")))
					WC.setCounterVisibility(0, true)
				endIf
	    	endIf
			WC.bGoneUnarmed = false
		endIf
		;Then equip the new item
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
		elseif (Q == 1 && itemType == 42) ;Ammo in the right hand queue, so in this case grenades and other throwing weapons
	    	PlayerRef.EquipItem(targetItem as Ammo)
	    elseif (Q == 0 && itemType == 26) ;Shield in the left hand queue
	    	PlayerRef.EquipItem(targetItem as Armor)
		else
		    PlayerRef.EquipItemEx(targetItem, iEquipSlotId, false, false)
		endIf
		;if we're not bEquippingAllPreselectedItems and you have just unequipped the opposite hand cycle the normal queue in the unequipped hand. cycleSlot will check for preselectSwitchingHands and skip the currently preselected item if it is the next in the main queue.
		if WC.bPreselectSwitchingHands
			Utility.Wait(0.1)
			WC.cycleSlot(otherHand, false)
			WC.bPreselectSwitchingHands = false
		endIf
	endIf
	WC.aiCurrentQueuePosition[Q] = itemToEquip
	WC.asCurrentlyEquipped[Q] = newName
	Utility.Wait(0.05)
	if Q < 2
		if WC.itemRequiresCounter(Q)
			WC.setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
			WC.setCounterVisibility(Q, true)
		elseif WC.isCounterShown(Q)
			WC.setCounterVisibility(Q, false)
		endIf
		WC.checkAndUpdatePoisonInfo(Q)
		WC.CM.checkAndUpdateChargeMeter(Q)
		WC.checkIfBoundSpellEquipped()
		if !bEquippingAllPreselectedItems
			WC.checkAndFadeLeftIcon(Q, itemType)
			if WC.aiCurrentlyPreselected[0] == WC.aiCurrentQueuePosition[0]
				cyclePreselectSlot(0, jArray.count(WC.aiTargetQ[0]), false)
			endIf
			if WC.aiCurrentlyPreselected[1] == WC.aiCurrentQueuePosition[1]
				cyclePreselectSlot(1, jArray.count(WC.aiTargetQ[1]), false)
			endIf
			if WC.bEnableGearedUp
				WC.refreshGearedUp()
			endIf
			if AM.bAmmoMode && bAmmoModePreselectModeFirstLook
				Utility.Wait(1.8)
				Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
				bAmmoModePreselectModeFirstLook = false
			endIf
		endIf
	endIf
endFunction

event ReadyForPreselectAnimation(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_ProMode ReadyForPreselectAnimation called")
	If(sEventName == "iEquip_ReadyForPreselectAnimation")
		bReadyForPreselectAnim = true
	endIf
endEvent

function equipAllPreselectedItems()
	debug.trace("iEquip_ProMode equipAllPreselectedItems() called")
	bEquippingAllPreselectedItems = true
	bReadyForPreselectAnim = false
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	form leftTargetItem = jMap.getForm(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentlyPreselected[0]), "Form")
	int targetObject = jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentlyPreselected[1])
	int targetArray
	form rightTargetItem = jMap.getForm(targetObject, "Form")
	int rightHandItemType = jMap.getInt(targetObject, "Type")
	if (rightHandItemType != 5 && rightHandItemType != 6 && rightHandItemType != 7 && rightHandItemType != 9)
		WC.checkAndFadeLeftIcon(1, rightHandItemType)
	endIf
	Utility.Wait(0.3)
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	int itemCount = PlayerRef.GetItemCount(leftTargetItem)
	string[] leftData
	string[] rightData
	string[] shoutData
	if bTogglePreselectOnEquipAll
		leftData = new string[3]
		rightData = new string[3]
		shoutData = new string[3]
	else
		leftData = new string[5]
		rightData = new string[5]
		shoutData = new string[5]
	endIf
	;Equip preselected shout first unless !bShoutPreselectEnabled
	if bShoutPreselectShown
		targetArray = WC.aiTargetQ[2]
		;Store currently equipped item icons and preselected item icons and names for each slot if enabled
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[2])
		shoutData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[2]), "Icon")
		shoutData[1] = jMap.getStr(targetObject, "Icon")
		shoutData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(2)
		if !bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[2])
			;equipPreselectedItem has now cycled to the next preselect slot without updating the widget so store new preselected item icon and name
			shoutData[3] = jMap.getStr(targetObject, "Icon")
			shoutData[4] = jMap.getStr(targetObject, "Name")
			Utility.Wait(0.2)
		endIf
	else
		;if !bShoutPreselectEnabled clear array indices
		shoutData[0] = ""
		shoutData[1] = ""
		shoutData[2] = ""
		if !bTogglePreselectOnEquipAll
			shoutData[3] = ""
			shoutData[4] = ""
		endIf
	endIf
	;Equip right hand first so any 2H/Ranged weapons take priority and equipping left hand can be blocked
	if bRightPreselectShown
		targetArray = WC.aiTargetQ[1]
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[1])
		rightData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[1]), "Icon")
		rightData[1] = jMap.getStr(targetObject, "Icon")
		rightData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(1)
		if !bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[1])
			rightData[3] = jMap.getStr(targetObject, "Icon")
			rightData[4] = jMap.getStr(targetObject, "Name")
			Utility.Wait(0.2)
		endIf
	else
		rightData[0] = ""
		rightData[1] = ""
		rightData[2] = ""
		if !bTogglePreselectOnEquipAll
			rightData[3] = ""
			rightData[4] = ""
		endIf
	endIf
	rightHandItemType = jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "Type")
	bool equipLeft = true
	if bLeftPreselectShown && !(bRightPreselectShown && ((rightHandItemType == 5 || rightHandItemType == 6 || rightHandItemType == 7 || rightHandItemType == 9) || (leftTargetItem == rightTargetItem && itemCount < 2 && rightHandItemType != 22)))
		targetArray = WC.aiTargetQ[0]
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
		leftData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[0]), "Icon")
		leftData[1] = jMap.getStr(targetObject, "Icon")
		leftData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(0)
		if !bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
			leftData[3] = jMap.getStr(targetObject, "Icon")
			leftData[4] = jMap.getStr(targetObject, "Name")
		endIf
	else
		equipLeft = false
		leftData[0] = ""
		leftData[1] = ""
		leftData[2] = ""
		if !bTogglePreselectOnEquipAll
			leftData[3] = ""
			leftData[4] = ""
		endIf
	endIf
    if WC.bGoneUnarmed
		WC.bGoneUnarmed = false
	endIf
	while !bReadyForPreselectAnim
		Utility.Wait(0.01)
	endwhile
	bAllEquipped = false
	Self.RegisterForModEvent("iEquip_EquipAllComplete", "EquipAllComplete")
	int iHandle
	if bTogglePreselectOnEquipAll
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItemsAndTogglePreselect")
	else
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItems")
	endIf
	if(iHandle)
		UICallback.Pushbool(iHandle, equipLeft)
		UICallback.Pushbool(iHandle, bRightPreselectShown)
		UICallback.Pushbool(iHandle, bShoutPreselectShown)
		UICallback.PushStringA(iHandle, leftData)
		UICallback.PushStringA(iHandle, rightData)
		UICallback.PushStringA(iHandle, shoutData)
		UICallback.Send(iHandle)
	endIf
	while !bAllEquipped
		Utility.Wait(0.01)
	endwhile
	if bRightPreselectShown
		WC.checkAndFadeLeftIcon(1, rightHandItemType)
	endIf
	if WC.bNameFadeoutEnabled
		if equipLeft
			WC.LNUpdate.registerForNameFadeoutUpdate()
			WC.LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bRightPreselectShown
			WC.RNUpdate.registerForNameFadeoutUpdate()
			WC.RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bShoutPreselectShown
			WC.SNUpdate.registerForNameFadeoutUpdate()
			WC.SPNUpdate.registerForNameFadeoutUpdate()	
		endIf
	endIf
	bEquippingAllPreselectedItems = false
	if WC.bEnableGearedUp
		WC.refreshGearedUp()
	endIf
	if AM.bAmmoMode && bAmmoModePreselectModeFirstLook
		Utility.Wait(1.0)
		Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
		bAmmoModePreselectModeFirstLook = false
	endIf
endFunction

event EquipAllComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_ProMode EquipAllComplete called")
	If(sEventName == "iEquip_EquipAllComplete")
		bAllEquipped = true
		Self.UnregisterForModEvent("iEquip_EquipAllComplete")
	endIf
	if bTogglePreselectOnEquipAll
		bTogglingPreselectOnEquipAll = true
		togglePreselectMode()
	endIf
endEvent

function quickShield()
	debug.trace("iEquip_ProMode quickShield called")
	;if right hand or ranged weapon in right hand and bQuickShield2HSwitchAllowed not enabled then return out
	if (WC.RightHandWeaponIs2hOrRanged() && !bQuickShield2HSwitchAllowed) || (bPreselectMode && iPreselectQuickShield == 0)
		return
	endIf
	int i = 0
	int targetArray = WC.aiTargetQ[0]
	int leftCount = jArray.count(targetArray)
	int found = -1
	int foundType
	int targetObject
	string spellName
	bool rightHandHasSpell = ((PlayerRef.GetEquippedItemType(1) == 9) && !(jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "Type") == 42))
	debug.trace("iEquip_ProMode quickShield() - RH current item: " + WC.asCurrentlyEquipped[1] + ", RH item type: " + (PlayerRef.GetEquippedItemType(1)))
	;if player currently has a spell equipped in the right hand or we've enabled Prefer Magic in the MCM search for a ward spell first
	if rightHandHasSpell || bQuickShieldPreferMagic
		while i < leftCount && found == -1
			spellName = jMap.getStr(jArray.getObj(targetArray, i), "Name")
			if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 22 && stringutil.Find(spellName, " ward", 0) > -1
				found = i
				foundType = 22
			endIf
			i += 1
		endwhile
		;if we haven't found a ward look for a shield
		if found == -1
			i = 0
			while i < leftCount && found == -1
				if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 26
					found = i
					foundType = 26
				endIf
				i += 1
			endwhile
		endIf
	;Otherwise look for a shield first
	else
		while i < leftCount && found == -1
			if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 26
				found = i
				foundType = 26
			endIf
			i += 1
		endwhile
		;And if we haven't found a shield then look for a ward
		if found == -1
			i = 0
			while i < leftCount && found == -1
				spellName = jMap.getStr(jArray.getObj(targetArray, i), "Name")
				if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 22 && stringutil.Find(spellName, " ward", 0) > -1
					found = i
					foundType = 22
				endIf
				i += 1
			endwhile
		endIf
	endIf
	if found != -1
		if !bPreselectMode || iPreselectQuickShield == 2
			;if we're in ammo mode we need to toggle out without equipping or animating
			if AM.bAmmoMode
				AM.toggleAmmoMode(true, true)
				;And if we're not in Preselect Mode we need to hide the left preselect elements
				if !bPreselectMode
					bool[] args = new bool[3]
					args[0] = false
					args[1] = false
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
				endIf
				ammo targetAmmo = AM.currentAmmoForm as Ammo
				if WC.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
					PlayerRef.UnequipItemEx(targetAmmo)
				endIf
			endIf
			WC.aiCurrentQueuePosition[0] = found
			WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(targetArray, found), "Name")
			if bPreselectMode
				WC.updateWidget(0, found, true)
				;if for some reason the found shield/ward being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				if WC.aiCurrentlyPreselected[0] == found
					cyclePreselectSlot(0, leftCount, false)
				endIf
			else
				WC.updateWidget(0, found)
			endIf
			if WC.bLeftIconFaded
				Utility.Wait(0.3)
				WC.checkAndFadeLeftIcon(0, foundType)
			endIf
			bool switchRightHand = false
			if WC.RightHandWeaponIs2hOrRanged() || (foundType == 22 && bQuickShieldPreferMagic && !rightHandHasSpell) || WC.bGoneUnarmed
				switchRightHand = true
				if !WC.bGoneUnarmed
					WC.UnequipHand(1)
				endIf
			endIf	
			WC.UnequipHand(0)
			form targetForm = jMap.getForm(jArray.getObj(targetArray, found), "Form")
			if foundType == 22
				PlayerRef.EquipSpell(targetForm as Spell, 0)
			elseif foundType == 26
				PlayerRef.EquipItemEx(targetForm as Armor)
			endIf
			if WC.isCounterShown(0)
				WC.setCounterVisibility(0, false)
			endIf
			if WC.abPoisonInfoDisplayed[0]
				WC.hidePoisonInfo(0)
			endIf
			if WC.CM.abIsChargeMeterShown[0]
				WC.CM.updateChargeMeterVisibility(0, false)
			endIf
			if switchRightHand
				quickShieldSwitchRightHand(foundType, rightHandHasSpell)
			endIf
			WC.checkIfBoundSpellEquipped()
			if WC.bEnableGearedUp
				WC.refreshGearedUp()
			endIf
		else
			WC.aiCurrentlyPreselected[0] = found
			WC.updateWidget(0, found)
		endIf
	else
		debug.notification("iEquip QuickShield did not find a shield or ward in your left hand queue")
	endIf
endFunction

function quickShieldSwitchRightHand(int foundType, bool rightHandHasSpell)
	debug.trace("iEquip_ProMode QuickShieldSwitchRightHand called - foundType: " + foundType + ", bQuickShieldPreferMagic: " + bQuickShieldPreferMagic + ", rightHandHasSpell: " + rightHandHasSpell)
	int i = 0
	int targetArray = WC.aiTargetQ[1]
	int rightCount = jArray.count(targetArray)
	int found = -1
	int targetObject
	int itemType
	string itemName
	if foundType == 22 && bQuickShieldPreferMagic && !rightHandHasSpell
		;if we've selected a preferred magic school look for that type of spell first
		if sQuickShieldPreferredMagicSchool != "" && sQuickShieldPreferredMagicSchool != "Destruction"
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == sQuickShieldPreferredMagicSchool
					found = i
				endIf
				i += 1
			endwhile
			i = 0
		endIf
		;if we haven't found a spell from the preferred school, or if we haven't set a preferred school look for a destruction spell
		if found == -1
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == "Destruction"
					found = i
				endIf
				i += 1
			endwhile
			i = 0
		endIf
		;Finally, if we haven't found a preferred school or destruction spell look for another 1H item
		if found == -1
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				itemType = jMap.getInt(targetObject, "Type")
				if itemType == 4
					itemName = jMap.getStr(targetObject, "Name")
					if !(stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb", 0) > -1)
						found = i
					endIf
				elseif itemType > 0 && itemType < 4 || itemType == 8
					found = i
				endIf
				i += 1
			endwhile
		endIf
	;Otherwise look for any 1h item or destruction spell	
	else
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			itemType = jMap.getInt(targetObject, "Type")
			if itemType == 4
				itemName = jMap.getStr(targetObject, "Name")
				if !(stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb", 0) > -1)
					found = i
				endIf
			elseif itemType > 0 && itemType < 4 || itemType == 8
				found = i
			elseif itemType == 22 && jMap.getStr(targetObject, "Icon") == "Destruction"
				found = i
			else
				found = -1
			endIf
			i += 1
		endwhile
	endIf
	if found > -1
		;if not in Preselect Mode or we've selected Preselect Mode QuickShield Equip update the widget and equip the found item/spell in the right hand
		if !bPreselectMode || iPreselectQuickShield == 2
			WC.bBlockSwitchBackToBoundSpell = true
			targetObject = jArray.getObj(WC.aiTargetQ[1], found)
			WC.aiCurrentQueuePosition[1] = found
			WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "Name")
			if bPreselectMode
				WC.updateWidget(1, found, true)
				;if for some reason the found item being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				if WC.aiCurrentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
			else
				WC.updateWidget(1, found)
			endIf
			WC.checkAndUpdatePoisonInfo(1)
			WC.CM.checkAndUpdateChargeMeter(1)
			itemType = jMap.getInt(targetObject, "Type")
			form formToEquip = jMap.getForm(jArray.getObj(WC.aiTargetQ[1], found), "Form")
			if itemType == 22
				PlayerRef.EquipSpell(formToEquip as Spell, 1)
			else
				PlayerRef.EquipItemEx(formToEquip, 1)
			endIf
			WC.bBlockSwitchBackToBoundSpell = false
		;if in Preselect Mode then update the right hand preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(6, found)
		endIf
		if WC.bGoneUnarmed
			WC.bGoneUnarmed = false
		endIf
	endIf
endFunction

function quickRanged()
	debug.trace("iEquip_ProMode quickRanged called")
	;if you already have a ranged weapon equipped or if you're in Preselect Mode and have disabled quickRanged in Preselect Mode then do nothing
	if bCurrentlyQuickRanged
		quickRangedSwitchOut()
	else
		if !(AM.bAmmoMode || (bPreselectMode && iPreselectQuickRanged == 0))
			bool actionTaken = false
			if iQuickRangedPreferredWeaponType > 1
				actionTaken = quickRangedFindAndEquipSpell()
			else
				actionTaken = quickRangedFindAndEquipWeapon()
			endIf
			if !actionTaken
				if iQuickRangedPreferredWeaponType > 1
					actionTaken = quickRangedFindAndEquipWeapon()
				else
					actionTaken = quickRangedFindAndEquipSpell()
				endIf
			endIf
			if !actionTaken
				debug.notification("iEquip couldn't find a ranged weapon or bound spell to equip")
			endIf
		endIf
	endIf
endFunction

bool function quickRangedFindAndEquipWeapon()
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon called")

	bool actionTaken = false
	int preferredType = 7 ;Bow
	int secondChoice = 9 ;Crossbow
	if iQuickRangedPreferredWeaponType == 1 || iQuickRangedPreferredWeaponType == 3
		preferredType = 9
		secondChoice = 7
	endIf
	int i = 0
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int found = -1
	;Look for our first choice ranged weapon type
	while i < rightCount && found == -1
		targetObject = jArray.getObj(targetArray, i)
		if jMap.getInt(targetObject, "Type") == preferredType
			found = i
		endIf
		i += 1
	endwhile
	;if we haven't found our first choice ranged weapon type now look for the alternative
	if found == -1
		i = 0
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			if jMap.getInt(targetObject, "Type") == secondChoice
				found = i
			endIf
			i += 1
		endwhile
	endIf
	if found != -1
		;if we're not in Preselect Mode, or we've selected Preselect Mode Equip in the MCM
		if !bPreselectMode || iPreselectQuickRanged == 2
			;Store current right hand index before switching in case user calls quickRangedSwitchOut() - we don't need left index as toggling out of ammo mode by switching right will take care of that.
			iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
			bool foundWeaponIsPoisoned = WC.isWeaponPoisoned(1, found, true)
			if WC.abPoisonInfoDisplayed[1] && !foundWeaponIsPoisoned
				WC.hidePoisonInfo(1)
				if WC.isCounterShown(1)
					WC.setCounterVisibility(1, false)
				endIf
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(1, 7)
				Utility.Wait(0.3)
			endIf
			WC.aiCurrentQueuePosition[1] = found
			targetObject = jArray.getObj(WC.aiTargetQ[1], found)
			WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "Name")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			WC.updateWidget(1, found, true)
			;if for some reason the found weapon being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
			if bPreselectMode
				;if we're in Preselect Mode we need to toggle Ammo Mode here without the animation so it updates the left slot to show ammo
				AM.toggleAmmoMode(true, false)
				PlayerRef.EquipItemEx(jMap.getForm(targetObject, "Form"), 1, false, false)
				;if the ranged weapon we're about to equip matches the right preselected item then cycle the preselect slot
				if WC.aiCurrentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
				if foundWeaponIsPoisoned
					WC.checkAndUpdatePoisonInfo(1)
				elseif WC.isCounterShown(1)
					WC.setCounterVisibility(1, false)
				endIf
				WC.CM.checkAndUpdateChargeMeter(1)
				if WC.bEnableGearedUp
					WC.refreshGearedUp()
				endIf
			;if we're not in Preselect Mode we can now equip as normal which will toggle Ammo Mode
			else
				WC.checkAndEquipShownHandItem(1, false)
			endIf
			bCurrentlyQuickRanged = true
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	return actionTaken
endFunction

bool function quickRangedFindAndEquipSpell()
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon called")

	bool actionTaken = false
	string preferredType = "Bound Bow"
	string secondChoice = "Bound Crossbow"
	if iQuickRangedPreferredWeaponType == 3 || iQuickRangedPreferredWeaponType == 1
		preferredType = "Bound Crossbow"
		secondChoice = "Bound Bow"
	endIf
	int i = 0
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int found = -1
	;Look for our first choice bound ranged weapon spell
	while i < rightCount && found == -1
		targetObject = jArray.getObj(targetArray, i)
		if jMap.getStr(targetObject, "Name") == preferredType
			found = i
		endIf
		i += 1
	endwhile
	;if we haven't found our first choice bound ranged weapon spell now look for the alternative
	if found == -1
		i = 0
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			if jMap.getStr(targetObject, "Name") == secondChoice
				found = i
			endIf
			i += 1
		endwhile
	endIf
	
	if found != -1
		;if we're not in Preselect Mode, or we've selected Preselect Mode Equip in the MCM
		if !bPreselectMode || iPreselectQuickRanged == 2
			;Store current right hand index before switching in case user calls quickRangedSwitchOut() - we don't need left index as toggling out of ammo mode by switching right will take care of that.
			iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
			if WC.abPoisonInfoDisplayed[1]
				WC.hidePoisonInfo(1)
			endIf
			if WC.isCounterShown(1)
				WC.setCounterVisibility(1, false)
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(1, 22)
			endIf
			WC.aiCurrentQueuePosition[1] = found
			WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(targetArray, found), "Name")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			WC.updateWidget(1, found, true)
			;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
			if bPreselectMode && (WC.aiCurrentlyPreselected[1] == found)
				cyclePreselectSlot(1, rightCount, false)
			endIf
			WC.checkAndEquipShownHandItem(1, false)
			bCurrentlyQuickRanged = true
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	return actionTaken
endFunction

function quickRangedSwitchOut()
	debug.trace("iEquip_ProMode quickRangedSwitchOut called")
	bCurrentlyQuickRanged = false
	debug.trace("iEquip_ProMode quickRangedSwitchOut called - iQuickRangedSwitchOutAction: " + iQuickRangedSwitchOutAction)
	int targetIndex = -1
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int i = 0
	if iQuickRangedSwitchOutAction == 1 ;Switch Back
		targetIndex = iPreviousRightHandIndex
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction: 1, targetIndex: " + targetIndex)
	elseif iQuickRangedSwitchOutAction == 2 || iQuickRangedSwitchOutAction == 3 ;Two Handed or One Handed
		int[] preferredType
		int[] secondChoice
		if iQuickRangedSwitchOutAction == 2
			preferredType = new int[2]
			preferredType[0] = 5
			preferredType[1] = 6
			secondChoice = new int[4]
			secondChoice[0] = 1
			secondChoice[1] = 2
			secondChoice[2] = 3
			secondChoice[3] = 4
		else
			preferredType = new int[4]
			preferredType[0] = 1
			preferredType[1] = 2
			preferredType[2] = 3
			preferredType[3] = 4
			secondChoice = new int[2]
			secondChoice[0] = 5
			secondChoice[1] = 6
		endIf
		targetIndex = -1
		int found = -1
		;Look for our first choice weapon type
		while i < rightCount && targetIndex == -1
			targetObject = jArray.getObj(targetArray, i)
			found = preferredType.Find(jMap.getInt(targetObject, "Type"))
			if found != -1
				targetIndex = i
			endIf
			i += 1
		endwhile
		;if we haven't found our first choice weapon type now look for the alternative
		if targetIndex == -1
			i = 0
			while i < rightCount && targetIndex == -1
				targetObject = jArray.getObj(targetArray, i)
				found = secondChoice.Find(jMap.getInt(targetObject, "Type"))
				if found != -1
					targetIndex = i
				endIf
				i += 1
			endwhile
		endIf
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction = 2 or 3, targetIndex: " + targetIndex)
	elseif iQuickRangedSwitchOutAction == 4 ;Spell
		;if we've selected a preferred magic school look for that type of spell first
		if sQuickRangedPreferredMagicSchool != "" && sQuickRangedPreferredMagicSchool != "Destruction"
			while i < rightCount && targetIndex == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == sQuickRangedPreferredMagicSchool
					targetIndex = i
				endIf
				i += 1
			endwhile
		endIf
		;if we haven't found a spell from the preferred school, or if we haven't set a preferred school look for a destruction spell
		if targetIndex == -1
			i = 0
			while i < rightCount && targetIndex == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == "Destruction"
					targetIndex = i
				endIf
				i += 1
			endwhile
		endIf
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction: 4, targetIndex: " + targetIndex)
	else
		return
	endIf
	debug.trace("iEquip_ProMode quickRangedSwitchOut - final targetIndex: " + targetIndex)
	targetObject = jArray.getObj(targetArray, targetIndex)
	WC.aiCurrentQueuePosition[1] = targetIndex
	WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "Name")
	WC.updateWidget(1, targetIndex, true)
	if bPreselectMode
		WC.bBlockSwitchBackToBoundSpell = true
		AM.toggleAmmoMode(true, false)
		form formToEquip = jMap.getForm(targetObject, "Form")
		PlayerRef.EquipItemEx(formToEquip, 1, false, false)
		WC.checkAndUpdatePoisonInfo(1)
		WC.CM.checkAndUpdateChargeMeter(1)
		if WC.aiCurrentlyPreselected[1] == targetIndex
			cyclePreselectSlot(1, jArray.count(targetArray), false)
		endIf
		if !WC.RightHandWeaponIs2hOrRanged(jMap.getInt(targetObject, "Type"))
			targetArray = WC.aiTargetQ[0]
			PlayerRef.EquipItemEx(jMap.getForm(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[0]), "Form"), 2, false, false)
			WC.checkAndUpdatePoisonInfo(0)
			WC.CM.checkAndUpdateChargeMeter(0)
			if WC.aiCurrentlyPreselected[0] == WC.aiCurrentQueuePosition[0]
				cyclePreselectSlot(0, jArray.count(targetArray), false)
			endIf
		endIf
		WC.bBlockSwitchBackToBoundSpell = false
	else
		WC.checkAndEquipShownHandItem(1, false)
	endIf
endFunction

bool function quickDualCastEquipSpellInOtherHand(int Q, form spellToEquip, string spellName, string spellIcon)
	debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand called - bBlockQuickDualCast: " + bBlockQuickDualCast)
	if bBlockQuickDualCast
		bBlockQuickDualCast = false
		return false
	else
		int otherHand = 0
		int nameElement = 21
		if Q == 0
			otherHand = 1
			nameElement = 8
		endIf
		int otherHandIndex = -1
		bool dualCastAllowed = true
		if bQuickDualCastMustBeInBothQueues
			otherHandIndex = WC.findInQueue(otherHand, spellName)
			dualCastAllowed = (otherHandIndex > -1)
		endIf
		if dualCastAllowed
			WC.bBlockSwitchBackToBoundSpell = true
			PlayerRef.EquipSpell(spellToEquip as Spell, otherHand)
			Float fNameAlpha = WC.afWidget_A[nameElement]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			if(iHandle)
				UICallback.PushInt(iHandle, otherHand)
				UICallback.PushString(iHandle, spellIcon)
				UICallback.PushString(iHandle, spellName)
				UICallback.PushFloat(iHandle, fNameAlpha)
				while bWaitingForAmmoModeAnimation
					Utility.Wait(0.005)
				endwhile
				UICallback.Send(iHandle)
			endIf
			WC.checkAndUpdatePoisonInfo(otherHand)
			WC.CM.checkAndUpdateChargeMeter(otherHand)
			if WC.bNameFadeoutEnabled && !WC.abIsNameShown[otherHand]
				WC.showName(otherHand)
			endIf
			if WC.isCounterShown(otherHand)
				WC.setCounterVisibility(otherHand, false)
			endIf
			if otherHandIndex > -1
				WC.aiCurrentQueuePosition[otherHand] = otherHandIndex
				WC.asCurrentlyEquipped[otherHand] = spellName
			endIf
			WC.bBlockSwitchBackToBoundSpell = false
			return true
		else
			return false
		endIf
	endIf
endFunction

function quickHeal()
	debug.trace("iEquip_ProMode quickHeal called")
	if bCurrentlyQuickHealing
		quickHealSwitchBack()
	else
		bool actionTaken = false
		if bQuickHealPreferMagic
			actionTaken = quickHealFindAndEquipSpell()
		else
			actionTaken = PO.quickHealFindAndConsumePotion()
		endIf
		if !actionTaken
			if bQuickHealPreferMagic
				actionTaken = PO.quickHealFindAndConsumePotion()
			else
				actionTaken = quickHealFindAndEquipSpell()
			endIf
		endIf
		if !actionTaken
			debug.notification("iEquip couldn't find a healing potion or spell to equip")
		endIf
	endIf
endFunction

bool function quickHealFindAndEquipSpell()
	debug.trace("iEquip_ProMode quickHealFindAndEquipSpell called")
	bool actionTaken = false
	int i = 0
	int Q = 0
	int count
	int targetIndex = -1
	int containingQ
	string spellName
	int targetArray = WC.aiTargetQ[Q]
	int targetObject
	while Q < 2 && targetIndex == -1
		count = jArray.count(targetArray)
		while i < count && targetIndex == -1
			targetObject = jArray.getObj(targetArray, i)
			if jMap.getInt(targetObject, "Type") == 22
				spellName = jMap.getStr(targetObject, "Name")
				if stringutil.Find(spellName, "heal", 0) > -1
					targetIndex = i
					containingQ = Q
				endIf
			endIf
			i += 1
		endwhile
		i = 0
		Q += 1
	endWhile
	debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - spell found at targetIndex: " + targetIndex + " in containingQ: " + containingQ + ", iQuickHealEquipChoice: " + iQuickHealEquipChoice)
	if targetIndex != -1
		int iEquipSlot = iQuickHealEquipChoice
		bool equippingOtherHand = false
		if iEquipSlot < 2 && iEquipSlot != containingQ
			equippingOtherHand = true
		elseIf iEquipSlot == 3 ;Equip spell where it is found
			iEquipSlot = containingQ
		endIf
		debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - iEquipSlot: " + iEquipSlot + ", bQuickHealSwitchBackEnabled: " + bQuickHealSwitchBackEnabled)
		if bQuickHealSwitchBackEnabled
			iPreviousLeftHandIndex = WC.aiCurrentQueuePosition[0]
			iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
			bCurrentlyQuickHealing = true
		endIf
		iQuickHealSlotsEquipped = iEquipSlot
		if iEquipSlot < 2
			quickHealEquipSpell(iEquipSlot, containingQ, targetIndex, false, equippingOtherHand)
		else
			int otherHand = 0
			if containingQ == 0
				otherHand = 1
			endIf
			quickHealEquipSpell(containingQ, containingQ, targetIndex)
			quickHealEquipSpell(otherHand, containingQ, targetIndex, true)
		endIf
		actionTaken = true
	endIf
	return actionTaken
endFunction

function quickHealEquipSpell(int iEquipSlot, int Q, int iIndex, bool dualCasting = false, bool equippingOtherHand = false)
	debug.trace("iEquip_ProMode quickHealEquipSpell called - equipping healing spell to iEquipSlot: " + iEquipSlot + ", spell found in Q " + Q + " at index " + iIndex)
	if WC.abPoisonInfoDisplayed[iEquipSlot]
		WC.hidePoisonInfo(iEquipSlot)
	endIf
	if WC.CM.abIsChargeMeterShown[iEquipSlot]
		WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
	endIf
	if WC.isCounterShown(iEquipSlot)
		WC.setCounterVisibility(iEquipSlot, false)
	endIf
	if WC.bLeftIconFaded
		WC.checkAndFadeLeftIcon(1, 22)
	endIf
	int spellObject = jArray.getObj(WC.aiTargetQ[Q], iIndex)
	string spellName = jMap.getStr(spellObject, "Name")
	if !dualCasting && !equippingOtherHand
		WC.aiCurrentQueuePosition[iEquipSlot] = iIndex
		WC.asCurrentlyEquipped[iEquipSlot] = spellName
		;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
		WC.updateWidget(iEquipSlot, iIndex, true)
		;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
		if bPreselectMode && (WC.aiCurrentlyPreselected[iEquipSlot] == iIndex)
			cyclePreselectSlot(iEquipSlot, jArray.count(WC.aiTargetQ[iEquipSlot]), false)
		endIf
		WC.checkAndEquipShownHandItem(iEquipSlot, false)
		bCurrentlyQuickHealing = true
	else
		WC.bBlockSwitchBackToBoundSpell = true
		int foundIndex = WC.findInQueue(iEquipSlot, spellName)
		PlayerRef.EquipSpell(jMap.getForm(spellObject, "Form") as Spell, iEquipSlot)
		int nameElement = 21
		if iEquipSlot == 0
			nameElement = 8
		endIf
		Float fNameAlpha = WC.afWidget_A[nameElement]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		if(iHandle)
			UICallback.PushInt(iHandle, iEquipSlot)
			UICallback.PushString(iHandle, jMap.getStr(spellObject, "Icon"))
			UICallback.PushString(iHandle, spellName)
			UICallback.PushFloat(iHandle, fNameAlpha)
			while bWaitingForAmmoModeAnimation
				Utility.Wait(0.005)
			endwhile
			UICallback.Send(iHandle)
		endIf
		if WC.bNameFadeoutEnabled && !WC.abIsNameShown[iEquipSlot]
			WC.showName(iEquipSlot)
		endIf
		if foundIndex > -1
			WC.aiCurrentQueuePosition[iEquipSlot] = foundIndex
			WC.asCurrentlyEquipped[iEquipSlot] = spellName
		endIf
		WC.bBlockSwitchBackToBoundSpell = false
	endIf
endFunction

function quickHealSwitchBack()
	debug.trace("iEquip_ProMode quickHealSwitchBack called")
	bCurrentlyQuickHealing = false
	WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
	WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
	int Q = iQuickHealSlotsEquipped
	if Q < 2
		WC.updateWidget(Q, WC.aiCurrentQueuePosition[Q], true) ;True overrides bPreselectMode to make sure we're updating the main slot if we're in Preselect
		WC.checkAndEquipShownHandItem(Q)
	elseIf Q == 2
		WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
		int rightHandItemType = jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "Type")
		if rightHandItemType != 5 && rightHandItemType != 6 && rightHandItemType != 7 && rightHandItemType != 9
			WC.checkAndEquipShownHandItem(0)
		endIf
		WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
		WC.checkAndEquipShownHandItem(1)
	else
		debug.trace("iEquip_ProMode quickHealSwitchBack - Something went wrong!")
	endIf
	iQuickHealSlotsEquipped = -1 ;Reset
endFunction
