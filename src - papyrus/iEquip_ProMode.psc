
Scriptname iEquip_ProMode extends Quest

Import UI
Import UICallback
Import Utility
import _Q2C_Functions
import iEquip_ActorExt
import iEquip_FormExt
import iEquip_SpellExt
import iEquip_StringExt

iEquip_WidgetCore Property WC Auto
iEquip_AmmoMode Property AM Auto
iEquip_PotionScript Property PO Auto
iEquip_TemperedItemHandler Property TI Auto

String HUD_MENU = "HUD Menu"
String WidgetRoot

bool property bPreselectMode auto hidden
bool bPreselectModeFirstLook = true
bool bEquippingAllPreselectedItems
bool bTogglingPreselectOnEquipAll
bool bOverrideTogglePreselectOnEquipAll
bool bAllEquipped
bool[] property abPreselectSlotEnabled auto hidden
bool bAmmoModePreselectModeFirstLook = true

bool property bWaitingForAmmoModeAnimation Auto Hidden
bool bAmmoModeActiveOnTogglePreselect
bool property bBlockQuickDualCast auto hidden

bool property bCurrentlyQuickRanged auto hidden
bool property bCurrentlyQuickHealing auto hidden
bool property bQuickHealActionTaken auto hidden
int iQuickHealSlotsEquipped = -1
int iPreviousLeftHandIndex
int iPreviousRightHandIndex

;MCM Properties
bool property bQuickShieldEnabled auto hidden
bool property bQuickRangedEnabled auto hidden
bool property bQuickRestoreEnabled auto hidden
float property fQuickRestoreThreshold = 0.7 auto hidden
bool property bQuickHealEnabled = true auto hidden
bool property bQuickHealUseFallback = true auto hidden
bool property bQuickStaminaEnabled = true auto hidden
bool property bQuickMagickaEnabled = true auto hidden
bool property bQuickBuffEnabled = true auto hidden
int property iQuickBuffControl = 1 auto hidden
float property fQuickBuff2ndPressDelay = 4.0 auto hidden
bool property bPreselectEnabled auto hidden
bool property bShoutPreselectEnabled = true auto hidden
bool property bPreselectSwapItemsOnEquip auto hidden
bool property bTogglePreselectOnEquipAll auto hidden
bool property bQuickShield2HSwitchAllowed = true auto hidden
bool property bQuickShieldUnequipLeftIfNotFound auto hidden
int property iPreselectQuickShield = 1 auto hidden
bool property bQuickShieldPreferMagic auto hidden
string property sQuickShieldPreferredMagicSchool = "Destruction" auto hidden
int property iPreselectQuickRanged = 1 auto hidden
int property iQuickRangedPreferredWeaponType auto hidden
int property iQuickRangedSwitchOutAction = 1 auto hidden
string property sQuickRangedPreferredMagicSchool = "Destruction" auto hidden
bool property bQuickDualCastMustBeInBothQueues auto hidden
bool property bQuickHealPreferMagic auto hidden
int property iQuickHealEquipChoice = 2 auto hidden
bool property bQuickHealSwitchBackEnabled = true auto hidden
bool property bQuickHealSwitchBackAndRestore = true auto hidden

actor property PlayerRef auto

float fTimeOfLastQuickRestore

int[] aiNameElements

event OnInit()
	debug.trace("iEquip_ProMode OnInit start")
	aiNameElements = new int[3]
	aiNameElements[0] = 18 ;leftPreselectName_mc
	aiNameElements[1] = 32 ;rightPreselectName_mc
	aiNameElements[2] = 40 ;shoutPreselectName_mc

	abPreselectSlotEnabled = new bool[3]
	abPreselectSlotEnabled[0] = true
	abPreselectSlotEnabled[1] = true
	abPreselectSlotEnabled[2] = true
	debug.trace("iEquip_ProMode OnInit end")
endEvent

function OnWidgetLoad()
	debug.trace("iEquip_ProMode OnWidgetLoad start")
	WidgetRoot = WC.WidgetRoot
	bPreselectMode = false
	bTogglingPreselectOnEquipAll = false
	fTimeOfLastQuickRestore = 0.0
	debug.trace("iEquip_ProMode OnWidgetLoad end")
endFunction

function togglePreselectMode(bool togglingEditModeOrRefreshing = false, bool enablingOnLoad = false)
	debug.trace("iEquip_ProMode togglePreselectMode start")
	if bPreselectEnabled || togglingEditModeOrRefreshing
		bPreselectMode = !bPreselectMode
		WC.bPreselectMode = bPreselectMode
		bool[] args = new bool[5]
		if bPreselectMode
			;bReadyForPreselectAnim = false
			Self.RegisterForModEvent("iEquip_ReadyForPreselectAnimation", "ReadyForPreselectAnimation")
			int Q
			if AM.bAmmoMode
				bAmmoModeActiveOnTogglePreselect = true
				Q = 1 ;Skip updating left hand preselect if currently in ammo mode as it's already set
			endIf
			while Q < 3
				int queueLength = JArray.count(WC.aiTargetQ[Q])
				;if any of the queues have less than 3 items in it then there is either nothing to preselect (1 item in queue) or you'd just be doing the same as regularly cycling two items so no need for preselect, therefore disable preselect elements for that slot
				if queueLength < 2 && !togglingEditModeOrRefreshing
					WC.aiCurrentlyPreselected[Q] = -1
				else
					if togglingEditModeOrRefreshing && queueLength < 2
						float fNameAlpha = WC.afWidget_A[aiNameElements[Q]]
						if fNameAlpha < 1
							fNameAlpha = 100
						endIf
						int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
						If(iHandle)
							UICallback.PushInt(iHandle, Q + 5)
							if Q == 2
								UICallback.PushString(iHandle, "Shout")
								UICallback.PushString(iHandle, "$iEquip_PM_lbl_EMdummyShout")
							else
								UICallback.PushString(iHandle, "Sword")
								UICallback.PushString(iHandle, "$iEquip_PM_lbl_EMdummySword")
							endIf
							UICallback.PushFloat(iHandle, fNameAlpha)
							;UICallback.PushFloat(iHandle, WC.afWidget_A[WC.aiIconClips[Q]])
							;UICallback.PushFloat(iHandle, WC.afWidget_S[WC.aiIconClips[Q]])
							UICallback.Send(iHandle)
						endIf
					elseIf !(Q == 2 && !bShoutPreselectEnabled)
						if !enablingOnLoad
							;Otherwise if enabled, set left, right and shout preselect to next item in each queue, play power up sound, update widget and show preselect elements
							WC.aiCurrentlyPreselected[Q] = WC.aiCurrentQueuePosition[Q] + 1
							if WC.aiCurrentlyPreselected[Q] == queueLength
								WC.aiCurrentlyPreselected[Q] = 0
							endIf
						endIf
						debug.trace("iEquip_ProMode togglePreselectMode, bPreselectMode: " + bPreselectMode + ", Q: " + Q + ", aiCurrentlyPreselected[" + Q + "]: " + WC.aiCurrentlyPreselected[Q])
						WC.updateWidget(Q, WC.aiCurrentlyPreselected[Q])
					endIf
				endIf
				Q += 1
			endwhile

			abPreselectSlotEnabled[0] = (((WC.aiCurrentlyPreselected[0] != -1) && JArray.count(WC.aiTargetQ[0]) > 1) || togglingEditModeOrRefreshing)
			abPreselectSlotEnabled[1] = ((WC.aiCurrentlyPreselected[1] != -1) || togglingEditModeOrRefreshing)
			;Also if shout preselect has been turned off in the MCM or hidden in Edit Mode make sure it stays hidden before showing the preselect group
			abPreselectSlotEnabled[2] = ((WC.bShoutEnabled && bShoutPreselectEnabled && (WC.aiCurrentlyPreselected[2] != -1)) || togglingEditModeOrRefreshing)

			;Add showLeft/showRight with check for number of items in queue must be greater than 1 (ie if only 1 in queue then nothing to preselect)
			args[0] = abPreselectSlotEnabled[0] ;Show left
			args[1] = abPreselectSlotEnabled[1] ;Show right
			args[2] = abPreselectSlotEnabled[2] ;Show shout if not hidden in edit mode or bShoutPreselectEnabled disabled in MCM
			args[3] = AM.bAmmoMode
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			debug.trace("iEquip_ProMode togglePreselectMode, left slot enabled: " + args[0] + ", right slot enabled: " + args[1] + ", shout slot enabled: " + args[2] + ", ammo mode: " + AM.bAmmoMode)
			PreselectModeAnimateIn()

			if bPreselectModeFirstLook && !WC.bRefreshingWidget && !WC.EM.isEditMode
				if WC.bShowTooltips
					Utility.WaitMenuMode(1.0)
					Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstLook"))
				endIf
				bPreselectModeFirstLook = false
				if (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2) && bAmmoModePreselectModeFirstLook
					if WC.bShowTooltips
						Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstRanged"))
					endIf
					bAmmoModePreselectModeFirstLook = false
				endIf
			endIf
		else
			;Hide preselect widget elements
			PreselectModeAnimateOut()
			if AM.bAmmoMode || (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2)
				args[0] = true ;Show left
			endIf
			args[3] = AM.bAmmoMode
			Utility.WaitMenuMode(2.0)
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			Self.UnregisterForModEvent("iEquip_ReadyForPreselectAnimation")
		endIf
	endIf
	debug.trace("iEquip_ProMode togglePreselectMode end")
endFunction

function PreselectModeAnimateIn()
	debug.trace("iEquip_ProMode PreselectModeAnimateIn start")
	bool[] args = new bool[3]
	if !AM.bAmmoMode
		args[0] = abPreselectSlotEnabled[0] ;Only animate the left icon if not already shown in ammo mode
	endIf
	args[1] = abPreselectSlotEnabled[2]
	args[2] = abPreselectSlotEnabled[1]
	UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn", args)
	if WC.bNameFadeoutEnabled
		int i
		while i < 3
			if i < 2
				WC.updateAttributeIcons(i, WC.aiCurrentlyPreselected[i])
			endIf
			if !WC.abIsNameShown[i]
				WC.showName(i)
			endIf
			i += 1
		endwhile
		if abPreselectSlotEnabled[0] && WC.bLeftRightNameFadeEnabled
			WC.LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if abPreselectSlotEnabled[1] && WC.bLeftRightNameFadeEnabled
			WC.RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if abPreselectSlotEnabled[2] && WC.bShoutNameFadeEnabled
			WC.SPNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
	debug.trace("iEquip_ProMode PreselectModeAnimateIn end")
endFunction

function PreselectModeAnimateOut()
	debug.trace("iEquip_ProMode PreselectModeAnimateOut start")
	if !bTogglingPreselectOnEquipAll
		bool[] args = new bool[3]
		args[0] = abPreselectSlotEnabled[1]
		args[1] = abPreselectSlotEnabled[2]
		if !(AM.bAmmoMode || (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2))
			args[2] = abPreselectSlotEnabled[0] ;Only animate out left slot if we don't currently have a ranged weapon equipped in the right hand or are in ammo mode as we still need it to show in regular mode
		endIf
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf
	int i
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
	debug.trace("iEquip_ProMode PreselectModeAnimateOut end")
endFunction

function cyclePreselectSlot(int Q, int queueLength, bool Reverse = false, bool animate = true, bool onKeyPress = false)
	debug.trace("iEquip_ProMode cyclePreselectSlot start")
	debug.trace("iEquip_ProMode cyclePreselectSlot - Q: " + Q + ", queueLength: " + queueLength + ", reverse: " + Reverse + ", animate: " + animate)
	if queueLength > 2
		int targetIndex
		if Reverse
			targetIndex = WC.aiCurrentlyPreselected[Q] - 1
			if targetIndex == WC.aiCurrentQueuePosition[Q] && !(Q == 0 && AM.bAmmoMode) ;Can't preselect the item you already have equipped in the widget so move on another index
				targetIndex -= 1
			endIf
			if targetIndex < 0
				targetIndex = queueLength - 1
				if targetIndex == WC.aiCurrentQueuePosition[Q] && !(Q == 0 && AM.bAmmoMode) ;Have to recheck again in case aiCurrentQueuePosition[Q] == queueLength - 1
					targetIndex -= 1
				endIf
			endIf
		else
			targetIndex = WC.aiCurrentlyPreselected[Q] + 1
			if targetIndex == WC.aiCurrentQueuePosition[Q] && !(Q == 0 && AM.bAmmoMode) ;Can't preselect the item you already have equipped in the widget so move on another index
				targetIndex += 1
			endIf
			if targetIndex >= queueLength
				targetIndex = 0
				if targetIndex == WC.aiCurrentQueuePosition[Q] && !(Q == 0 && AM.bAmmoMode) ;Have to recheck again in case aiCurrentQueuePosition[Q] == 0
					targetIndex += 1
				endIf
			endIf
		endIf
		if WC.bShowPositionIndicators && (onKeyPress || WC.bPermanentPositionIndicators)
			WC.abCyclingQueue[Q] = false
			WC.updateQueuePositionIndicator(Q, queueLength, WC.aiCurrentQueuePosition[Q], targetIndex)
			if !WC.bPermanentPositionIndicators
				if Q == 0
					WC.LHPosUpdate.registerForFadeoutUpdate()
				elseIf Q == 1
					WC.RHPosUpdate.registerForFadeoutUpdate()
				else
					WC.SPosUpdate.registerForFadeoutUpdate()
				endIf
			endIf
		endIf
		WC.aiCurrentlyPreselected[Q] = targetIndex
		if animate
			WC.updateWidget(Q, targetIndex, false, true)
		endIf
	endIf
	debug.trace("iEquip_ProMode cyclePreselectSlot end")
endFunction

function equipPreselectedItem(int Q)
	debug.trace("iEquip_ProMode equipPreselectedItem start")
	debug.trace("iEquip_ProMode equipPreselectedItem - Q: " + Q + ", bEquippingAllPreselectedItems: " + bEquippingAllPreselectedItems)

    int iHandle
	int itemToEquip = WC.aiCurrentlyPreselected[Q]
	int targetArray = WC.aiTargetQ[Q]
	int targetObject = jArray.getObj(targetArray, itemToEquip)
	form targetItem = jMap.getForm(targetObject, "iEquipForm")
	int itemType = jMap.getInt(targetObject, "iEquipType")
	
	if (itemType == 7 || itemType == 9)
		AM.checkAndRemoveBoundAmmo(itemType)
		if (!(WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2) || AM.switchingRangedWeaponType(itemType) || AM.iAmmoListSorting == 3)
			AM.selectAmmoQueue(itemType)
		endIf
	endIf
	string currIcon =  jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[Q]), "iEquipIcon")
    string currPIcon = jMap.getStr(targetObject, "iEquipIcon")
	string newName = jMap.getStr(targetObject, "iEquipName")
	string newIcon = currPIcon
    ;if we've chosen to swap items when equipping preselect then set the new preselect index to the currently equipped item ready to animate into the preselect slot
    if bPreselectSwapItemsOnEquip || jArray.count(targetArray) == 2
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
		;while !bReadyForPreselectAnim
		;	Utility.WaitMenuMode(0.01)
		;endwhile
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Which slot we're updating
			UICallback.PushString(iHandle, currIcon) ;Current icon
			UICallback.PushString(iHandle, newIcon) ;New icon
			UICallback.PushString(iHandle, newName) ;New name
			UICallback.PushString(iHandle, currPIcon) ;Current preselect icon
			UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipIcon")) ;New preselect icon
			UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipName")) ;New preselect name
			UICallback.Send(iHandle)
		endIf
		if WC.bNameFadeoutEnabled
			if Q == 0 && WC.bLeftRightNameFadeEnabled
				WC.LNUpdate.registerForNameFadeoutUpdate()
				WC.LPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 1 && WC.bLeftRightNameFadeEnabled
				WC.RNUpdate.registerForNameFadeoutUpdate()
				WC.RPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 2 && WC.bShoutNameFadeEnabled
				WC.SNUpdate.registerForNameFadeoutUpdate()
				WC.SPNUpdate.registerForNameFadeoutUpdate()	
			endIf
		endIf
	endIf
	;if we're in ammo mode whilst in Preselect Mode and either we're equipping the left preselected item, or we're equipping the right and it's not another ranged weapon we need to turn ammo mode off
	if (AM.bAmmoMode && (Q == 0 || (Q == 1 && !(itemType == 7 || itemType == 9)))) || (!AM.bAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9)))
		AM.toggleAmmoMode(abPreselectSlotEnabled[0], (itemType == 5 || itemType == 6)) ;Toggle ammo mode off/on without the animation (unless the left Preselect slot isn't currently showing), and without re-equipping if RH is equipping 2H
		Utility.WaitMenuMode(0.05)
		if Q == 1 && !AM.bAmmoMode ;if we're equipping the right preselected item and it's not another ranged weapon we'll just have toggled ammo mode off without animation, now we need to remove the ammo from the left slot and replace it with the current left hand item
			if abPreselectSlotEnabled[0]
				if bAmmoModeActiveOnTogglePreselect && !bEquippingAllPreselectedItems ;if we were in ammo mode when we toggled Preselect Mode then use the equipPreselected animation, otherwise use updateWidget
					bAmmoModeActiveOnTogglePreselect = false ;Reset
					targetArray = WC.aiTargetQ[0]
					targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
				    newName = jMap.getStr(targetObject, "iEquipName")
					newIcon = jMap.getStr(targetObject, "iEquipIcon")
				    currIcon =  jMap.getStr(AM.getCurrentAmmoObject(), "iEquipIcon")
				    currPIcon = newIcon
				    cyclePreselectSlot(0, jArray.count(targetArray), false, false)
					targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
					iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
					if(iHandle)
						UICallback.PushInt(iHandle, 0)
						UICallback.PushString(iHandle, currIcon)
						UICallback.PushString(iHandle, newIcon)
						UICallback.PushString(iHandle, newName)
						UICallback.PushString(iHandle, currPIcon)
						UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipIcon"))
						UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipName"))
						UICallback.Send(iHandle)
					endIf
				else
					WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
				endIf
			else
				bAmmoModeActiveOnTogglePreselect = false ;Reset
			endIf
			if WC.bUnequipAmmo && PlayerRef.isEquipped(AM.currentAmmoForm as Ammo)
				PlayerRef.UnequipItemEx(AM.currentAmmoForm as Ammo)
			endIf
			if WC.bNameFadeoutEnabled && WC.bLeftRightNameFadeEnabled
				WC.LNUpdate.registerForNameFadeoutUpdate()
				if abPreselectSlotEnabled[0]
					WC.LPNUpdate.registerForNameFadeoutUpdate()
				endIf
			endIf
			if abPreselectSlotEnabled[0]
				targetObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
				int leftItemType = jMap.getInt(targetObject, "iEquipType")
				form leftItem = jMap.getForm(targetObject, "iEquipForm")
				if WC.itemRequiresCounter(0, leftItemType , jMap.getStr(targetObject, "iEquipName"))
					WC.setSlotCount(0, PlayerRef.GetItemCount(leftItem))
					WC.setCounterVisibility(0, true)
				elseif WC.abIsCounterShown[0]
					WC.setCounterVisibility(0, false)
				endIf
				if !(itemType == 5 || itemType == 6 || (itemType == 22 && (targetItem as Spell).GetEquipType() == WC.EquipSlots[3])) ;As long as the item which triggered toggling out of bAmmoMode isn't a 2H weapon or spell we can now re-equip the left hand
					if leftItemType == 22
						PlayerRef.EquipSpell(leftItem as Spell, 0)
				    elseif leftItemType == 26
				    	PlayerRef.EquipItem(leftItem as Armor)
					else
					    PlayerRef.EquipItemEx(leftItem, 2, false, false)
					endIf
				endIf
			endIf
		endIf

	elseif AM.bAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9) && AM.switchingRangedWeaponType(itemType))
		AM.checkAndEquipAmmo(false, true)
	endIf

	if Q == 1 && itemType == 0
		WC.goUnarmed()
	elseIf Q == 2 && targetItem ;Shout/Power
	    if itemType == 22
	        PlayerRef.EquipSpell(targetItem as Spell, 2)
	    else
	        PlayerRef.EquipShout(targetItem as Shout)
	    endIf
	else ;Left or right hand
		WC.bPreselectSwitchingHands = false ;Reset just in case
		;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
	    int iEquipSlotId = 1
	    int otherHand = (Q + 1) % 2
	    if Q == 0
	    	iEquipSlotId = 2
	    endIf
		;Unequip current item
		WC.UnequipHand(Q)
		;if equipping the left hand will cause a 2H or ranged weapon to be unequipped in the right hand, or the one handed weapon you are about to equip is already equipped in the other hand and you only have one of it then cycle the main slot and equip a suitable 1H item
		if (Q == 0 && (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1)) || (targetItem == PlayerRef.GetEquippedObject(otherHand) && itemType != 22 && PlayerRef.GetItemCount(targetItem) < 2)
			if !bEquippingAllPreselectedItems
	        	WC.bPreselectSwitchingHands = true
	        endif
	        ;if any of the above checks are met then unequip the opposite hand first (possibly not required)
	        WC.UnequipHand(otherHand)
	        Utility.WaitMenuMode(0.1)
	    ;if we are re-equipping from an unarmed state
	    elseIf WC.bGoneUnarmed || WC.b2HSpellEquipped
	    	WC.bGoneUnarmed = false
			WC.b2HSpellEquipped = false
	    	;If we're equipping anything other than a ranged weapon or another 2H spell we need to reshow the correct item in the other hand
	    	if !(Q == 1 && (itemType == 7 || itemType == 9 || (itemType == 22 && (targetItem as spell).GetEquipType() == WC.EquipSlots[3])))
	    		;If the item being equipped is a 2H weapon we only need to update the left widget before switching and fading it out
	    		if itemType == 5 || itemType == 6
	    			WC.reequipOtherHand(0, false)
    			;Otherwise if we're equipping a 1H item in the right hand we can now re-equip the previous left hand item
    			elseif Q == 1
    				WC.reequipOtherHand(otherHand)
    			;Or if we're equipping the left hand we need to cycle the right slot to find a 1H item	
	    		else
	    			WC.bPreselectSwitchingHands = true
	    			WC.cycleSlot(1, false, true)
	    			WC.bPreselectSwitchingHands = false
		    	endIf
	    	endIf
		endIf
		;Then equip the new item
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
			if Q == 1 && (targetItem as spell).GetEquipType() == WC.EquipSlots[3]
				WC.aiCurrentQueuePosition[Q] = itemToEquip
				WC.asCurrentlyEquipped[Q] = newName
				WC.updateLeftSlotOn2HSpellEquipped()
				debug.trace("iEquip_ProMode equipPreselectedItem - should have updated left slot to 2H spell")
			endIf
		elseif (Q == 1 && itemType == 42) ;Ammo in the right hand queue, so in this case grenades and other throwing weapons
	    	PlayerRef.EquipItem(targetItem as Ammo, false, true)
	    elseif (Q == 0 && itemType == 26) ;Shield in the left hand queue
	    	PlayerRef.EquipItem(targetItem as Armor, false, true)
		else
		    PlayerRef.EquipItemEx(targetItem, iEquipSlotId, false, false)
		endIf
		;if we're not bEquippingAllPreselectedItems and you have just unequipped the opposite hand cycle the normal queue in the unequipped hand. cycleSlot will check for preselectSwitchingHands and skip the currently preselected item if it is the next in the main queue.
		if WC.bPreselectSwitchingHands
			Utility.WaitMenuMode(0.1)
			WC.cycleSlot(otherHand, false)
			WC.bPreselectSwitchingHands = false
		endIf
	endIf
	WC.aiCurrentQueuePosition[Q] = itemToEquip
	WC.asCurrentlyEquipped[Q] = newName
	if WC.bShowPositionIndicators && WC.bPermanentPositionIndicators
		WC.abCyclingQueue[Q] = false
		WC.updateQueuePositionIndicator(Q, jArray.count(targetArray), WC.aiCurrentQueuePosition[Q], WC.aiCurrentlyPreselected[Q])
	endIf
	Utility.WaitMenuMode(0.05)
	if Q < 2 && !WC.bGoneUnarmed
		if WC.itemRequiresCounter(Q)
			WC.setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
			WC.setCounterVisibility(Q, true)
		else
			WC.setCounterVisibility(Q, false)
		endIf
		WC.checkAndUpdatePoisonInfo(Q)
		if !(Q == 0 && targetItem as light)
			WC.CM.checkAndUpdateChargeMeter(Q)
		endIf
		if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0
			TI.checkAndUpdateTemperLevelInfo(Q)
		endIf
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
				if WC.bShowTooltips
					Utility.WaitMenuMode(1.8)
					Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstRanged"))
				endIf
				bAmmoModePreselectModeFirstLook = false
			endIf
		endIf
	endIf
	debug.trace("iEquip_ProMode equipPreselectedItem end")
endFunction

function updateAnimationTargetValues()
	debug.trace("iEquip_ProMode updateAnimationTargetValues start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	debug.trace("iEquip_ProMode updateAnimationTargetValues end")
endFunction

function equipAllPreselectedItems(bool handsOnly = false)
	debug.trace("iEquip_ProMode equipAllPreselectedItems start")
	bOverrideTogglePreselectOnEquipAll = handsOnly
	bEquippingAllPreselectedItems = true
	
	string[] leftData
	string[] rightData
	string[] shoutData
	int targetArray
	form leftTargetItem = jMap.getForm(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentlyPreselected[0]), "iEquipForm")
	int itemCount = PlayerRef.GetItemCount(leftTargetItem)
	int targetObject = jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentlyPreselected[1])
	form rightTargetItem = jMap.getForm(targetObject, "iEquipForm")
	int rightHandItemType = jMap.getInt(targetObject, "iEquipType")
		
	if bTogglePreselectOnEquipAll
		leftData = new string[3]
		rightData = new string[3]
		shoutData = new string[3]
	else
		leftData = new string[5]
		rightData = new string[5]
		shoutData = new string[5]
	endIf

	;Equip preselected shout unless !bShoutPreselectEnabled
	if !handsOnly && abPreselectSlotEnabled[2]
		targetArray = WC.aiTargetQ[2]
		;Store currently equipped item icons and preselected item icons and names for each slot if enabled
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[2])
		shoutData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[2]), "iEquipIcon")
		shoutData[1] = jMap.getStr(targetObject, "iEquipIcon")
		shoutData[2] = jMap.getStr(targetObject, "iEquipName")
		equipPreselectedItem(2)
		if !bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[2])
			;equipPreselectedItem has now cycled to the next preselect slot without updating the widget so store new preselected item icon and name
			shoutData[3] = jMap.getStr(targetObject, "iEquipIcon")
			shoutData[4] = jMap.getStr(targetObject, "iEquipName")
			Utility.WaitMenuMode(0.2)
		endIf
	endIf

	;Equip right hand first so any 2H/Ranged weapons take priority and equipping left hand can be blocked
	if abPreselectSlotEnabled[1]
		targetArray = WC.aiTargetQ[1]
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[1])
		rightData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[1]), "iEquipIcon")
		rightData[1] = jMap.getStr(targetObject, "iEquipIcon")
		rightData[2] = jMap.getStr(targetObject, "iEquipName")
		equipPreselectedItem(1)
		if !bTogglePreselectOnEquipAll || handsOnly
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[1])
			rightData[3] = jMap.getStr(targetObject, "iEquipIcon")
			rightData[4] = jMap.getStr(targetObject, "iEquipName")
			Utility.WaitMenuMode(0.2)
		endIf
	endIf
	targetObject = jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1])
	rightHandItemType = jMap.getInt(targetObject, "iEquipType")

	bool equipLeft
	if abPreselectSlotEnabled[0] && !(abPreselectSlotEnabled[1] && ((WC.ai2HWeaponTypes.Find(rightHandItemType) > -1) || rightHandItemType == 0 || (rightHandItemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3) || (leftTargetItem == rightTargetItem && itemCount < 2 && rightHandItemType != 22)))
		equipLeft = true
		targetArray = WC.aiTargetQ[0]
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
		leftData[0] = jMap.getStr(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[0]), "iEquipIcon")
		leftData[1] = jMap.getStr(targetObject, "iEquipIcon")
		leftData[2] = jMap.getStr(targetObject, "iEquipName")
		equipPreselectedItem(0)
		if !bTogglePreselectOnEquipAll || handsOnly
			targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[0])
			leftData[3] = jMap.getStr(targetObject, "iEquipIcon")
			leftData[4] = jMap.getStr(targetObject, "iEquipName")
		endIf
	endIf

	bAllEquipped = false
	Self.RegisterForModEvent("iEquip_EquipAllComplete", "EquipAllComplete")
	int iHandle
	if bTogglePreselectOnEquipAll && !handsOnly
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItemsAndTogglePreselect")
	else
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItems")
	endIf
	if(iHandle)
		UICallback.Pushbool(iHandle, equipLeft)
		UICallback.Pushbool(iHandle, abPreselectSlotEnabled[1])
		UICallback.Pushbool(iHandle, (abPreselectSlotEnabled[2] && !handsOnly))
		UICallback.PushStringA(iHandle, leftData)
		UICallback.PushStringA(iHandle, rightData)
		UICallback.PushStringA(iHandle, shoutData)
		UICallback.Send(iHandle)
	endIf
	while !bAllEquipped
		Utility.WaitMenuMode(0.01)
	endwhile
	if abPreselectSlotEnabled[1]
		WC.checkAndFadeLeftIcon(1, rightHandItemType)
	endIf
	if WC.bNameFadeoutEnabled
		if equipLeft && WC.bLeftRightNameFadeEnabled
			WC.LNUpdate.registerForNameFadeoutUpdate()
			WC.LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if abPreselectSlotEnabled[1] && WC.bLeftRightNameFadeEnabled
			WC.RNUpdate.registerForNameFadeoutUpdate()
			WC.RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if abPreselectSlotEnabled[2] && WC.bShoutNameFadeEnabled && !handsOnly
			WC.SNUpdate.registerForNameFadeoutUpdate()
			WC.SPNUpdate.registerForNameFadeoutUpdate()	
		endIf
	endIf
	bEquippingAllPreselectedItems = false
	if WC.bEnableGearedUp
		WC.refreshGearedUp()
	endIf
	if AM.bAmmoMode && bAmmoModePreselectModeFirstLook
		if WC.bShowTooltips
			Utility.WaitMenuMode(1.0)
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstRanged"))
		endIf
		bAmmoModePreselectModeFirstLook = false
	endIf
	debug.trace("iEquip_ProMode equipAllPreselectedItems end")
endFunction

event EquipAllComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_ProMode EquipAllComplete start")
	If(sEventName == "iEquip_EquipAllComplete")
		bAllEquipped = true
		Self.UnregisterForModEvent("iEquip_EquipAllComplete")
	endIf
	if bTogglePreselectOnEquipAll && !bOverrideTogglePreselectOnEquipAll
		bTogglingPreselectOnEquipAll = true
		togglePreselectMode()
	endIf
	debug.trace("iEquip_ProMode EquipAllComplete end")
endEvent

;The forceSwitch bool is set to true when quickShield is called by WC.removeItemFromQueue when a previously equipped shield has been removed, so we're only looking for a shield, not a ward
function quickShield(bool forceSwitch = false, bool onTorchDropped = false)
	debug.trace("iEquip_ProMode quickShield start")
	;if right hand or ranged weapon in right hand and bQuickShield2HSwitchAllowed not enabled then return out
	if (!bQuickShieldEnabled && !onTorchDropped) || (!forceSwitch && (((WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1) && !bQuickShield2HSwitchAllowed) || (bPreselectMode && iPreselectQuickShield == 0)))
		return
	endIf
	int i
	int targetArray = WC.aiTargetQ[0]
	int leftCount = jArray.count(targetArray)
	int found = -1
	int foundType
	int targetObject
	bool rightHandHasSpell = ((PlayerRef.GetEquippedItemType(1) == 9) && !(jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipType") == 42))
	debug.trace("iEquip_ProMode quickShield() - RH current item: " + WC.asCurrentlyEquipped[1] + ", RH item type: " + (PlayerRef.GetEquippedItemType(1)))
	;if player currently has a spell equipped in the right hand or we've enabled Prefer Magic in the MCM search for a ward spell first
	if !forceSwitch && (rightHandHasSpell || bQuickShieldPreferMagic)
		while i < leftCount && found == -1
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 22 && iEquip_FormExt.IsSpellWard(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm") as spell)
				found = i
				foundType = 22
			endIf
			i += 1
		endwhile
		;if we haven't found a ward look for a shield
		if found == -1
			i = 0
			while i < leftCount && found == -1
				if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 26
					found = i
					foundType = 26
				endIf
				i += 1
			endwhile
		endIf
	;Otherwise look for a shield first
	else
		while i < leftCount && found == -1
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 26
				found = i
				foundType = 26
			endIf
			i += 1
		endwhile
		;And if we haven't found a shield then look for a ward
		if found == -1 && !forceSwitch
			i = 0
			while i < leftCount && found == -1
				if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 22 && iEquip_FormExt.IsSpellWard(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm") as spell)
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
				bCurrentlyQuickRanged = false
				AM.toggleAmmoMode((!bPreselectMode || abPreselectSlotEnabled[0]), true)
				;And if we're not in Preselect Mode we need to hide the left preselect elements
				if !bPreselectMode && !AM.bSimpleAmmoMode
					bool[] args = new bool[3]
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
				endIf
				ammo targetAmmo = AM.currentAmmoForm as Ammo
				if WC.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
					PlayerRef.UnequipItemEx(targetAmmo)
				endIf
			endIf
			WC.aiCurrentQueuePosition[0] = found
			WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(targetArray, found), "iEquipName")
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
				Utility.WaitMenuMode(0.3)
				WC.checkAndFadeLeftIcon(0, foundType)
			endIf
			bool switchRightHand
			if (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1) || (foundType == 22 && bQuickShieldPreferMagic && !rightHandHasSpell) || WC.bGoneUnarmed || WC.b2HSpellEquipped
				switchRightHand = true
				if !WC.bGoneUnarmed
					WC.UnequipHand(1)
				endIf
			endIf	
			WC.UnequipHand(0)
			form targetForm = jMap.getForm(jArray.getObj(targetArray, found), "iEquipForm")
			if foundType == 22
				PlayerRef.EquipSpell(targetForm as Spell, 0)
			elseif foundType == 26
				PlayerRef.EquipItemEx(targetForm as Armor)
			endIf
			WC.setCounterVisibility(0, false)
			WC.hidePoisonInfo(0)
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
		if forceSwitch || onTorchDropped
			;If we've forced quickShield because a previously equipped shield was removed from the player, or we've just dropped a lit torch and we haven't been able to find another in the left queue we now need to cycle the left queue
			WC.cycleSlot(0, false, true)
		else
			if bQuickShieldUnequipLeftIfNotFound && (PlayerRef.GetEquippedObject(1) as weapon) && !(WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1)
				WC.UnequipHand(0)
				WC.setSlotToEmpty(0, true, true)
			else
				debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_QSNotFound"))
			endIf
		endIf
	endIf
	debug.trace("iEquip_ProMode quickShield end")
endFunction

function quickShieldSwitchRightHand(int foundType, bool rightHandHasSpell)
	debug.trace("iEquip_ProMode quickShieldSwitchRightHand start")
	debug.trace("iEquip_ProMode QuickShieldSwitchRightHand - foundType: " + foundType + ", bQuickShieldPreferMagic: " + bQuickShieldPreferMagic + ", rightHandHasSpell: " + rightHandHasSpell)
	int i
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
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getStr(targetObject, "iEquipSchool") == sQuickShieldPreferredMagicSchool
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
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getStr(targetObject, "iEquipSchool") == "Destruction"
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
				itemType = jMap.getInt(targetObject, "iEquipType")
				if itemType > 0 && itemType < 4 || (itemType == 4 && !(jMap.getStr(targetObject, "iEquipIcon") == "Grenade")) || itemType == 8
					found = i
				endIf
				i += 1
			endwhile
		endIf
	;Otherwise look for any 1h item or destruction spell	
	else
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			itemType = jMap.getInt(targetObject, "iEquipType")
			if itemType > 0 && itemType < 4 || (itemType == 4 && !(jMap.getStr(targetObject, "iEquipIcon") == "Grenade")) || itemType == 8 || (itemType == 22 && jMap.getStr(targetObject, "iEquipSchool") == "Destruction")
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
			WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "iEquipName")
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
			if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0
				TI.checkAndUpdateTemperLevelInfo(1)
			endIf
			itemType = jMap.getInt(targetObject, "iEquipType")
			form formToEquip = jMap.getForm(jArray.getObj(WC.aiTargetQ[1], found), "iEquipForm")
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
		WC.bGoneUnarmed = false
		WC.b2HSpellEquipped = false
	endIf
	debug.trace("iEquip_ProMode quickShieldSwitchRightHand end")
endFunction

;The forceSwitch bool is set to true when quickRanged is called by WC.removeItemFromQueue when a previously equipped ranged weapon has been removed, so we also set typeToFind to start by searching for another ranged weapon of the same type
function quickRanged()
	debug.trace("iEquip_ProMode quickRanged start")
	;if you already have a ranged weapon equipped or if you're in Preselect Mode and have disabled quickRanged in Preselect Mode then do nothing
    if bQuickRangedEnabled
        if bCurrentlyQuickRanged
            quickRangedSwitchOut()
        else
            if !(AM.bAmmoMode || (bPreselectMode && iPreselectQuickRanged == 0))
                bool actionTaken
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
                if actionTaken
                	WC.bGoneUnarmed = false
                	WC.b2HSpellEquipped = false
                else	
                    debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_QRNoRanged"))
                endIf
            endIf
        endIf
    endIf
    debug.trace("iEquip_ProMode quickRanged end")
endFunction

bool function quickRangedFindAndEquipWeapon(int typeToFind = -1, bool setCurrentlyQuickRangedFlag = true)
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon start")

	bool actionTaken
	int preferredType = 7 ;Bow
	int secondChoice = 9 ;Crossbow
	if typeToFind == 9 || (typeToFind != 7 && (iQuickRangedPreferredWeaponType == 1 || iQuickRangedPreferredWeaponType == 3))
		preferredType = 9
		secondChoice = 7
	endIf
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon preferredType: " + preferredType + ", secondChoice: " + secondChoice)
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon - number of ammo for preferredType (AM.aiTargetQ[" + (preferredType == 9) as int + "]: " + jArray.count(AM.aiTargetQ[(preferredType == 9) as int]))
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon - number of ammo for secondChoice (AM.aiTargetQ[" + (secondChoice == 9) as int + "]: " + jArray.count(AM.aiTargetQ[(secondChoice == 9) as int]))
	int i
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int found = -1
	;First check we've actually got ammo for our preferred weapon type
	if jArray.count(AM.aiTargetQ[(preferredType == 9) as int]) > 0
		;Now look for our first choice ranged weapon type
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getInt(targetObject, "iEquipType") == preferredType
				found = i
			endIf
			i += 1
		endwhile
		if found == -1
			debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon preferredType weapon not found")
		else
			debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon preferredType weapon found at index " + found)
		endIf
	endIf
	;if we haven't found our first choice ranged weapon type now look for the alternative
	if found == -1
		if jArray.count(AM.aiTargetQ[(secondChoice == 9) as int]) > 0
			i = 0
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getInt(targetObject, "iEquipType") == secondChoice
					found = i
				endIf
				i += 1
			endwhile
		endIf
		if found == -1
			debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon secondChoice weapon not found")
		else
			debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon secondChoice weapon found at index " + found)
		endIf
	endIf
	if found != -1
		;if we're not in Preselect Mode, or we've selected Preselect Mode Equip in the MCM
		if !bPreselectMode || iPreselectQuickRanged == 2
			;Store current right hand index before switching in case user calls quickRangedSwitchOut() - we don't need left index as toggling out of ammo mode by switching right will take care of that.
			iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
			bool foundWeaponIsPoisoned = WC.isWeaponPoisoned(1, found, true)
			if WC.abPoisonInfoDisplayed[1] && !foundWeaponIsPoisoned
				WC.hidePoisonInfo(1)
				if WC.abIsCounterShown[1]
					WC.setCounterVisibility(1, false)
				endIf
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(1, 7)
				Utility.WaitMenuMode(0.3)
			endIf
			WC.aiCurrentQueuePosition[1] = found
			targetObject = jArray.getObj(WC.aiTargetQ[1], found)
			AM.selectAmmoQueue(jMap.getInt(targetObject, "iEquipType"))
			WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "iEquipName")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			WC.updateWidget(1, found, true)
			;If we're in Preselect mode we need to do a couple of things here
			;If we're already in ammo mode and we're here because our previous ranged weapon was removed or we ran out of ammo for it so we need to equip the new weapon and update the additional info
			if bPreselectMode || AM.bAmmoMode
				;if we're in Preselect Mode we need to toggle Ammo Mode here without the animation so it updates the left slot to show ammo
				if !AM.bAmmoMode
					AM.toggleAmmoMode(abPreselectSlotEnabled[0], false)
				endIf
				PlayerRef.EquipItemEx(jMap.getForm(targetObject, "iEquipForm"), 1, false, false)
				;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
				if bPreselectMode && WC.aiCurrentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
				if foundWeaponIsPoisoned
					WC.checkAndUpdatePoisonInfo(1)
				elseif WC.abIsCounterShown[1]
					WC.setCounterVisibility(1, false)
				endIf
				WC.CM.checkAndUpdateChargeMeter(1)
				if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0
					TI.checkAndUpdateTemperLevelInfo(1)
				endIf
				if WC.bEnableGearedUp
					WC.refreshGearedUp()
				endIf
			;if we're not in Preselect Mode or Ammo Mode we can now equip as normal which will toggle Ammo Mode
			else
				WC.checkAndEquipShownHandItem(1, false, false, true)
			endIf
			if setCurrentlyQuickRangedFlag && !(iQuickRangedSwitchOutAction == 0)
				bCurrentlyQuickRanged = true
			endIf
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon end")
	return actionTaken
endFunction

bool function quickRangedFindAndEquipSpell()
	debug.trace("iEquip_ProMode quickRangedFindAndEquipSpell start")

	bool actionTaken
	string preferredType = iEquip_StringExt.LocalizeString("$iEquip_common_BoundBow")
	string secondChoice = iEquip_StringExt.LocalizeString("$iEquip_common_BoundCrossbow")
	if iQuickRangedPreferredWeaponType == 3 || iQuickRangedPreferredWeaponType == 1
		preferredType = iEquip_StringExt.LocalizeString("$iEquip_common_BoundCrossbow")
		secondChoice = iEquip_StringExt.LocalizeString("$iEquip_common_BoundBow")
	endIf
	int i
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int found = -1
	;Look for our first choice bound ranged weapon spell
	while i < rightCount && found == -1
		targetObject = jArray.getObj(targetArray, i)
		if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getStr(targetObject, "iEquipName") == preferredType
			found = i
		endIf
		i += 1
	endwhile
	;if we haven't found our first choice bound ranged weapon spell now look for the alternative
	if found == -1
		i = 0
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getStr(targetObject, "iEquipName") == secondChoice
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
			if WC.abIsCounterShown[1]
				WC.setCounterVisibility(1, false)
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(1, 22)
			endIf
			WC.aiCurrentQueuePosition[1] = found
			WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(targetArray, found), "iEquipName")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			WC.updateWidget(1, found, true)
			;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
			if bPreselectMode && (WC.aiCurrentlyPreselected[1] == found)
				cyclePreselectSlot(1, rightCount, false)
			endIf
			WC.checkAndEquipShownHandItem(1, false)
			if !(iQuickRangedSwitchOutAction == 0)
				bCurrentlyQuickRanged = true
			endIf
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	debug.trace("iEquip_ProMode quickRangedFindAndEquipSpell end")
	return actionTaken
endFunction

function quickRangedSwitchOut(bool force1H = false)
	debug.trace("iEquip_ProMode quickRangedSwitchOut start")
	bCurrentlyQuickRanged = false
	debug.trace("iEquip_ProMode quickRangedSwitchOut called - iQuickRangedSwitchOutAction: " + iQuickRangedSwitchOutAction)
	int targetIndex = -1
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int i
	if iQuickRangedSwitchOutAction == 1 && !force1H ;Switch Back
		targetIndex = iPreviousRightHandIndex
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction: 1, targetIndex: " + targetIndex)
	elseif force1H || iQuickRangedSwitchOutAction == 2 || iQuickRangedSwitchOutAction == 3 ;Two Handed or One Handed
		int[] preferredType
		int[] secondChoice
		if iQuickRangedSwitchOutAction == 2 && !force1H
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
			found = preferredType.Find(jMap.getInt(targetObject, "iEquipType"))
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
				found = secondChoice.Find(jMap.getInt(targetObject, "iEquipType"))
				if found != -1
					targetIndex = i
				endIf
				i += 1
			endwhile
		endIf
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction = 2 or 3, targetIndex: " + targetIndex)
	endIf
	if iQuickRangedSwitchOutAction == 4 || (force1H && targetIndex == -1) ;Spell
		;if we've selected a preferred magic school look for that type of spell first
		if sQuickRangedPreferredMagicSchool != "" && sQuickRangedPreferredMagicSchool != "Destruction"
			while i < rightCount && targetIndex == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getStr(targetObject, "iEquipIcon") == sQuickRangedPreferredMagicSchool
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
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getStr(targetObject, "iEquipIcon") == "Destruction"
					targetIndex = i
				endIf
				i += 1
			endwhile
		endIf
		debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction: 4, targetIndex: " + targetIndex)
	endIf
	debug.trace("iEquip_ProMode quickRangedSwitchOut - final targetIndex: " + targetIndex)
	targetObject = jArray.getObj(targetArray, targetIndex)
	WC.aiCurrentQueuePosition[1] = targetIndex
	WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "iEquipName")
	WC.updateWidget(1, targetIndex, true)
	if bPreselectMode
		WC.bBlockSwitchBackToBoundSpell = true
		AM.toggleAmmoMode(abPreselectSlotEnabled[0], false)
		form formToEquip = jMap.getForm(targetObject, "iEquipForm")
		PlayerRef.EquipItemEx(formToEquip, 1, false, false)
		WC.checkAndUpdatePoisonInfo(1)
		WC.CM.checkAndUpdateChargeMeter(1)
		if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0
			TI.checkAndUpdateTemperLevelInfo(1)
		endIf
		if WC.aiCurrentlyPreselected[1] == targetIndex
			cyclePreselectSlot(1, jArray.count(targetArray), false)
		endIf
		if WC.ai2HWeaponTypes.Find(jMap.getInt(targetObject, "iEquipType")) == -1
			targetArray = WC.aiTargetQ[0]
			PlayerRef.EquipItemEx(jMap.getForm(jArray.getObj(targetArray, WC.aiCurrentQueuePosition[0]), "iEquipForm"), 2, false, false)
			WC.checkAndUpdatePoisonInfo(0)
			WC.CM.checkAndUpdateChargeMeter(0)
			if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0
				TI.checkAndUpdateTemperLevelInfo(0)
			endIf
			if WC.aiCurrentlyPreselected[0] == WC.aiCurrentQueuePosition[0]
				cyclePreselectSlot(0, jArray.count(targetArray), false)
			endIf
		endIf
		WC.bBlockSwitchBackToBoundSpell = false
	else
		WC.checkAndEquipShownHandItem(1, false)
	endIf
	debug.trace("iEquip_ProMode quickRangedSwitchOut end")
endFunction

function quickDualCastOnDoubleTap(int Q)
	debug.trace("iEquip_ProMode quickDualCastOnDoubleTap start - Q: " + Q)
	spell equippedSpell = PlayerRef.GetEquippedSpell(Q)
	if WC.EquipSlots.Find(equippedSpell.GetEquipType()) == 2 && equippedSpell != PlayerRef.GetEquippedSpell((Q + 1) % 2)	; If it's an 'Either Hand' spell and isn't already equipped in the other hand
		bool success = quickDualCastEquipSpellInOtherHand(Q, equippedSpell as form, equippedSpell.GetName(), jMap.getStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipIcon"), true)
	endIf
	debug.trace("iEquip_ProMode quickDualCastOnDoubleTap end")
endFunction

bool function quickDualCastEquipSpellInOtherHand(int Q, form spellToEquip, string spellName, string spellIcon, bool onDoubleTapSpell = false)
	debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand start - Q: " + Q + ", " + spellName + ", icon: " + spellIcon + ", onDoubleTapSpell: " + onDoubleTapSpell)
	debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand - bBlockQuickDualCast: " + bBlockQuickDualCast)
	if bBlockQuickDualCast
		bBlockQuickDualCast = false
		return false
	else
		int otherHand = (Q + 1) % 2
		int nameElement = 22 ;rightName_mc
		int iconElement = 21 ;rightIcon_mc
		if Q == 0
			nameElement = 8 ;leftName_mc
			iconElement = 7 ;leftIcon_mc
		endIf
		int otherHandIndex = WC.findInQueue(otherHand, spellName)
		if !bQuickDualCastMustBeInBothQueues || otherHandIndex > -1 || onDoubleTapSpell
			WC.EH.bJustQuickDualCast = true
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
				UICallback.PushFloat(iHandle, WC.afWidget_A[iconElement])
				UICallback.PushFloat(iHandle, WC.afWidget_S[iconElement])
				while bWaitingForAmmoModeAnimation
					Utility.WaitMenuMode(0.005)
				endwhile
				UICallback.Send(iHandle)
			endIf
			WC.checkAndUpdatePoisonInfo(otherHand)
			WC.CM.checkAndUpdateChargeMeter(otherHand)
			if WC.bNameFadeoutEnabled && !WC.abIsNameShown[otherHand]
				WC.showName(otherHand)
			endIf
			WC.setCounterVisibility(otherHand, false)
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
	debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand end")
endFunction

function quickRestore()
	debug.trace("iEquip_ProMode quickRestore start")
	if bQuickRestoreEnabled

		bool bPlayerIsInCombat = PlayerRef.IsInCombat()
		bool bIn2ndPressWindow = (Utility.GetCurrentRealTime() - fTimeOfLastQuickRestore) < fQuickBuff2ndPressDelay
		bool bDoBoth = iQuickBuffControl == 0 || (iQuickBuffControl == 2 && !bPlayerIsInCombat)
		bool bQuickBuff = bDoBoth || ((iQuickBuffControl == 1 || (iQuickBuffControl == 2 && bPlayerIsInCombat)) && bIn2ndPressWindow)
		bool bQuickRestore = bDoBoth || !bQuickBuff

		float currAV

		debug.trace("iEquip_ProMode quickRestore - bPlayerIsInCombat: " + bPlayerIsInCombat + ", bIn2ndPressWindow: " + bIn2ndPressWindow + ", bDoBoth: " + bDoBoth + ", bQuickBuff: " + bQuickBuff + ", bQuickRestore: " + bQuickRestore + ", fQuickRestoreThreshold: " + fQuickRestoreThreshold)

		if bQuickRestore
			fTimeOfLastQuickRestore = Utility.GetCurrentRealTime()
		endIf

		if bQuickHealEnabled
	        debug.trace("iEquip_ProMode quickRestore - bQuickHealEnabled: " + bQuickHealEnabled)
	        if bCurrentlyQuickHealing
	        	debug.trace("iEquip_ProMode quickRestore - bCurrentlyQuickHealing, switching back")
	            quickHealSwitchBack(bPlayerIsInCombat)
	        
	        elseIf bQuickRestore
	        	;ToDo - remove the next few lines of debug code
		    	;float currHAV = PlayerRef.GetActorValue("Health")
		    	;float currHAVDamage = iEquip_ActorExt.GetAVDamage(PlayerRef, 24)
		    	;float currHAVMax = currHAV + currHAVDamage
	    		;debug.trace("iEquip_ProMode quickRestore - bQuickHealEnabled: " + bQuickHealEnabled + ", current health: " + currHAV + ", current damage: " + currHAVDamage + ", current max: " + currHAVMax + ", current %: " + (currHAV / currHAVMax))
	        	debug.trace("iEquip_ProMode quickRestore - calling quickHeal")
	        	quickHeal()
	        endIf

	        if bQuickBuff
	        	If PO.getPotionTypeCount(1) > 0 || PO.getPotionTypeCount(2) > 0
		        	debug.trace("iEquip_ProMode quickRestore - calling quickBuff health")
					PO.quickBuffFindAndConsumePotions(0)
				else
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noHealthBuffPotions"))
				endIf
			endIf
	    endIf

	    if bQuickStaminaEnabled
	    	currAV = PlayerRef.GetActorValue("Stamina")
	    	;ToDo - remove the next few lines of debug code
	    	;float currSAV = PlayerRef.GetActorValue("Stamina")
	    	;float currSAVDamage = iEquip_ActorExt.GetAVDamage(PlayerRef, 26)
	    	;float currSAVMax = currSAV + currSAVDamage
    		;debug.trace("iEquip_ProMode quickRestore - bQuickStaminaEnabled: " + bQuickStaminaEnabled + ", current stamina: " + currSAV + ", current damage: " + currSAVDamage + ", current max: " + currSAVMax + ", current %: " + (currSAV / currSAVMax))
    		;if bQuickRestore && ((currSAV / currSAVMax) <= fQuickRestoreThreshold)
    		if bQuickRestore && (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, 26)) <= fQuickRestoreThreshold)
		    	debug.trace("iEquip_ProMode quickRestore - calling selectAndConsumePotion for Stamina")
		    	PO.selectAndConsumePotion(2, 0) ;Stamina
		    else
		    	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_StaminaFull"))
		    endIf
			
			if bQuickBuff
				If PO.getPotionTypeCount(7) > 0 || PO.getPotionTypeCount(8) > 0
					debug.trace("iEquip_ProMode quickRestore - calling quickBuff stamina")
					PO.quickBuffFindAndConsumePotions(2)
				else
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noStaminaBuffPotions"))
				endIf
			endIf
	    endIf

	    if bQuickMagickaEnabled
	    	currAV = PlayerRef.GetActorValue("Magicka")
	    	;ToDo - remove the next few lines of debug code
	    	;float currMAV = PlayerRef.GetActorValue("Magicka")
	    	;float currMAVDamage = iEquip_ActorExt.GetAVDamage(PlayerRef, 25)
	    	;float currMAVMax = currMAV + currMAVDamage
    		;debug.trace("iEquip_ProMode quickRestore - bQuickMagickaEnabled: " + bQuickMagickaEnabled + ", current magicka: " + currMAV + ", current damage: " + currMAVDamage + ", current max: " + currMAVMax + ", current %: " + (currMAV / currMAVMax))
    		;if bQuickRestore && ((currMAV / currMAVMax) <= fQuickRestoreThreshold)
	    	if bQuickRestore && (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, 25)) <= fQuickRestoreThreshold)
		    	debug.trace("iEquip_ProMode quickRestore - calling selectAndConsumePotion for Magicka")
		    	PO.selectAndConsumePotion(1, 0) ;Magicka
		    else
		    	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_MagickaFull"))
		    endIf
			
			if bQuickBuff
				If PO.getPotionTypeCount(4) > 0 || PO.getPotionTypeCount(5) > 0
					debug.trace("iEquip_ProMode quickRestore - calling quickBuff magicka")
					PO.quickBuffFindAndConsumePotions(1)
				else
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noMagickaBuffPotions"))
				endIf
			endIf
	    endIf
	endIf
    debug.trace("iEquip_ProMode quickRestore end")
endFunction

function quickHeal()
	debug.trace("iEquip_ProMode quickHeal start")
    bQuickHealActionTaken = false
    if bQuickHealPreferMagic
        quickHealFindAndEquipSpell()
    elseIf PO.getPotionTypeCount(0) > 0
    	if (PlayerRef.GetActorValue("Health") / (PlayerRef.GetActorValue("Health") + iEquip_ActorExt.GetAVDamage(PlayerRef, 24)) <= fQuickRestoreThreshold)
	    	PO.selectAndConsumePotion(0, 0, true)
	   	else
			debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_HealthFull"))
			bQuickHealActionTaken = true
	    endIf
	endIf
    	
    if !bQuickHealActionTaken && bQuickHealUseFallback
        if bQuickHealPreferMagic
        	If PO.getPotionTypeCount(0) > 0
	        	if (PlayerRef.GetActorValue("Health") / (PlayerRef.GetActorValue("Health") + iEquip_ActorExt.GetAVDamage(PlayerRef, 24)) <= fQuickRestoreThreshold)
	            	PO.selectAndConsumePotion(0, 0, true)
	            else
	            	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_PrefMagicHealthFull"))
	            endIf
	        endIf
        else
            quickHealFindAndEquipSpell()
        endIf
    endIf
    debug.trace("iEquip_ProMode quickHeal end")
endFunction

function quickHealFindAndEquipSpell()
	debug.trace("iEquip_ProMode quickHealFindAndEquipSpell start")
	int i
	int Q
	int count
	int targetIndex = -1
	int containingQ
	int targetArray = WC.aiTargetQ[Q]
	int targetObject
	while Q < 2 && targetIndex == -1
		count = jArray.count(targetArray)
		while i < count && targetIndex == -1
			targetObject = jArray.getObj(targetArray, i)
			if jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_SpellExt.IsHealingSpell(jMap.getForm(targetObject, "iEquipForm") as spell)
				targetIndex = i
				containingQ = Q
			endIf
			i += 1
		endwhile
		i = 0
		Q += 1
	endWhile
	debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - spell found at targetIndex: " + targetIndex + " in containingQ: " + containingQ + ", iQuickHealEquipChoice: " + iQuickHealEquipChoice)
	if targetIndex != -1
		int iEquipSlot = iQuickHealEquipChoice
		bool equippingOtherHand
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
			int otherHand = (containingQ + 1) % 2
			quickHealEquipSpell(containingQ, containingQ, targetIndex)
			quickHealEquipSpell(otherHand, containingQ, targetIndex, true)
		endIf
		bQuickHealActionTaken = true
	endIf
	debug.trace("iEquip_ProMode quickHealFindAndEquipSpell end")
endFunction

function quickHealEquipSpell(int iEquipSlot, int Q, int iIndex, bool dualCasting = false, bool equippingOtherHand = false)
	debug.trace("iEquip_ProMode quickHealEquipSpell start")
	debug.trace("iEquip_ProMode quickHealEquipSpell - equipping healing spell to iEquipSlot: " + iEquipSlot + ", spell found in Q " + Q + " at index " + iIndex)
	if WC.abPoisonInfoDisplayed[iEquipSlot]
		WC.hidePoisonInfo(iEquipSlot)
	endIf
	if WC.CM.abIsChargeMeterShown[iEquipSlot]
		WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
	endIf
	if WC.abIsCounterShown[iEquipSlot]
		WC.setCounterVisibility(iEquipSlot, false)
	endIf
	if WC.bLeftIconFaded
		WC.checkAndFadeLeftIcon(1, 22)
	endIf
	int spellObject = jArray.getObj(WC.aiTargetQ[Q], iIndex)
	string spellName = jMap.getStr(spellObject, "iEquipName")
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
		PlayerRef.EquipSpell(jMap.getForm(spellObject, "iEquipForm") as Spell, iEquipSlot)
		int nameElement = 22 ;rightName_mc
		int iconElement = 21 ;rightIcon_mc
		if Q == 0
			nameElement = 8 ;leftName_mc
			iconElement = 7 ;leftIcon_mc
		endIf
		Float fNameAlpha = WC.afWidget_A[nameElement]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		if(iHandle)
			UICallback.PushInt(iHandle, iEquipSlot)
			UICallback.PushString(iHandle, jMap.getStr(spellObject, "iEquipIcon"))
			UICallback.PushString(iHandle, spellName)
			UICallback.PushFloat(iHandle, fNameAlpha)
			UICallback.PushFloat(iHandle, WC.afWidget_A[iconElement])
			UICallback.PushFloat(iHandle, WC.afWidget_S[iconElement])
			while bWaitingForAmmoModeAnimation
				Utility.WaitMenuMode(0.005)
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
	debug.trace("iEquip_ProMode quickHealEquipSpell end")
endFunction

function quickHealSwitchBack(bool bPlayerIsInCombat)
	debug.trace("iEquip_ProMode quickHealSwitchBack start")
	bCurrentlyQuickHealing = false
	WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
	WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
	int Q = iQuickHealSlotsEquipped
	if Q < 2
		WC.updateWidget(Q, WC.aiCurrentQueuePosition[Q], true) ;True overrides bPreselectMode to make sure we're updating the main slot if we're in Preselect
		WC.checkAndEquipShownHandItem(Q)
	elseIf Q == 2
		WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
		int rightHandItemType = jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipType")
		if rightHandItemType != 5 && rightHandItemType != 6 && rightHandItemType != 7 && rightHandItemType != 9
			WC.checkAndEquipShownHandItem(0)
		endIf
		WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
		WC.checkAndEquipShownHandItem(1)
	else
		debug.trace("iEquip_ProMode quickHealSwitchBack - Something went wrong!")
	endIf
	if bQuickHealSwitchBackAndRestore && bPlayerIsInCombat
		PO.selectAndConsumePotion(1, 0) ;Magicka potions
	endIf
	iQuickHealSlotsEquipped = -1 ;Reset
	debug.trace("iEquip_ProMode quickHealSwitchBack end")
endFunction
