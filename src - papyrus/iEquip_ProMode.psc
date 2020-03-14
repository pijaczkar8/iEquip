
Scriptname iEquip_ProMode extends Quest

Import UI
Import UICallback
Import Utility
import iEquip_ActorExt
import iEquip_FormExt
import iEquip_InventoryExt
import iEquip_SpellExt
import iEquip_StringExt
import iEquip_ObjectReferenceExt

iEquip_WidgetCore property WC auto
iEquip_AmmoMode property AM auto
iEquip_PotionScript property PO auto
iEquip_TemperedItemHandler property TI auto
iEquip_PlayerEventHandler property EH auto

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

bool property bWaitingForAmmoModeAnimation auto hidden
bool bAmmoModeActiveOnTogglePreselect
bool property bBlockQuickDualCast auto hidden

bool property bCurrentlyQuickRanged auto hidden
bool property bCurrentlyQuickHealing auto hidden
bool property bQuickHealActionTaken auto hidden
int iQuickSlotsEquipped = -1

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
bool property bPreselectSwapItemsOnQuickAction = true auto hidden
bool property bTogglePreselectOnEquipAll auto hidden
bool property bQuickShield2HSwitchAllowed = true auto hidden
bool property bQuickShieldUseAlt = true auto hidden
bool property bQuickShieldUnequipLeftIfNotFound auto hidden
int property iPreselectQuickShield = 2 auto hidden
int property iQuickShieldPreferredItemType auto hidden
string property sQuickShieldPreferredMagicSchool = "Destruction" auto hidden
int property iPreselectQuickRanged = 2 auto hidden
int property iQuickRangedPreferredWeaponType auto hidden
int property iQuickRangedSwitchOutAction = 1 auto hidden
string property sQuickRangedPreferredMagicSchool = "Destruction" auto hidden
bool property bQuickDualCastMustBeInBothQueues auto hidden
bool property bQuickHealPreferMagic auto hidden
int property iQuickHealEquipChoice = 2 auto hidden
bool property bQuickHealSwitchBackEnabled = true auto hidden
bool property bQuickHealSwitchBackAndRestore = true auto hidden
bool property bScanInventory = true auto hidden

actor property PlayerRef auto

float fTimeOfLastQuickRestore

int[] aiNameElements
int[] aiHandEquipSlots

string[] asSpellSchools

event OnInit()
	;debug.trace("iEquip_ProMode OnInit start")
	aiNameElements = new int[3]
	aiNameElements[0] = 20 ;leftPreselectName_mc
	aiNameElements[1] = 37 ;rightPreselectName_mc
	aiNameElements[2] = 46 ;shoutPreselectName_mc

	aiHandEquipSlots = new int[2]
	aiHandEquipSlots[0] = 2
	aiHandEquipSlots[1] = 1

	abPreselectSlotEnabled = new bool[3]
	abPreselectSlotEnabled[0] = true
	abPreselectSlotEnabled[1] = true
	abPreselectSlotEnabled[2] = true
	;debug.trace("iEquip_ProMode OnInit end")

	asSpellSchools = new string[5]
	asSpellSchools[0] = "Alteration"
	asSpellSchools[1] = "Conjuration"
	asSpellSchools[2] = "Destruction"
	asSpellSchools[3] = "Illusion"
	asSpellSchools[4] = "Restoration"
endEvent

bool bInitialiseQRSpellSchoolsArray = true

function onVersionUpdate()
	aiNameElements[0] = 20 ;leftPreselectName_mc
	aiNameElements[1] = 37 ;rightPreselectName_mc
	aiNameElements[2] = 46 ;shoutPreselectName_mc

	aiHandEquipSlots = new int[2]
	aiHandEquipSlots[0] = 2
	aiHandEquipSlots[1] = 1

	asSpellSchools = new string[5]
	asSpellSchools[0] = "Alteration"
	asSpellSchools[1] = "Conjuration"
	asSpellSchools[2] = "Destruction"
	asSpellSchools[3] = "Illusion"
	asSpellSchools[4] = "Restoration"

	if bInitialiseQRSpellSchoolsArray
		abQuickRangedSpellSchoolAllowed = new bool[5]
		abQuickRangedSpellSchoolAllowed[2] = true	; Destruction spells enabled by default
		bInitialiseQRSpellSchoolsArray = false
	endIf

	iQuickShieldPreferredItemType = bQuickShieldPreferMagic as int
endFunction

function OnWidgetLoad()
	;debug.trace("iEquip_ProMode OnWidgetLoad start")
	WidgetRoot = WC.WidgetRoot
	bPreselectMode = false
	bTogglingPreselectOnEquipAll = false
	fTimeOfLastQuickRestore = 0.0
	;debug.trace("iEquip_ProMode OnWidgetLoad end")
endFunction

function togglePreselectMode(bool togglingEditModeOrRefreshing = false, bool enablingOnLoad = false)
	;debug.trace("iEquip_ProMode togglePreselectMode start")
	if bPreselectEnabled || togglingEditModeOrRefreshing
		bPreselectMode = !bPreselectMode
		WC.bPreselectMode = bPreselectMode
		bool[] args = new bool[5]
		if bPreselectMode
			int Q
			if AM.bAmmoMode && !AM.bSimpleAmmoMode
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
						;debug.trace("iEquip_ProMode togglePreselectMode, bPreselectMode: " + bPreselectMode + ", Q: " + Q + ", aiCurrentlyPreselected[" + Q + "]: " + WC.aiCurrentlyPreselected[Q])
						WC.updateWidget(Q, WC.aiCurrentlyPreselected[Q])
					endIf
				endIf
				Q += 1
			endwhile

			abPreselectSlotEnabled[0] = ((WC.aiCurrentlyPreselected[0] != -1) && JArray.count(WC.aiTargetQ[0]) > 1) || togglingEditModeOrRefreshing && !WC.bPlayerIsMounted
			abPreselectSlotEnabled[1] = (WC.aiCurrentlyPreselected[1] != -1) || togglingEditModeOrRefreshing
			;Also if shout preselect has been turned off in the MCM or hidden in Edit Mode make sure it stays hidden before showing the preselect group
			abPreselectSlotEnabled[2] = (WC.bShoutEnabled && bShoutPreselectEnabled && (WC.aiCurrentlyPreselected[2] != -1)) || togglingEditModeOrRefreshing

			;Add showLeft/showRight with check for number of items in queue must be greater than 1 (ie if only 1 in queue then nothing to preselect)
			args[0] = abPreselectSlotEnabled[0] ;Show left
			args[1] = abPreselectSlotEnabled[1] ;Show right
			args[2] = abPreselectSlotEnabled[2] ;Show shout if not hidden in edit mode or bShoutPreselectEnabled disabled in MCM
			args[3] = (AM.bAmmoMode && !AM.bSimpleAmmoMode)
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			;debug.trace("iEquip_ProMode togglePreselectMode, left slot enabled: " + args[0] + ", right slot enabled: " + args[1] + ", shout slot enabled: " + args[2] + ", ammo mode: " + AM.bAmmoMode)
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
			if (AM.bAmmoMode && !AM.bSimpleAmmoMode) || (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2)
				args[0] = true ;Show left
			endIf
			args[3] = (AM.bAmmoMode && !AM.bSimpleAmmoMode)
			Utility.WaitMenuMode(2.0)
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
		endIf
	endIf
	;debug.trace("iEquip_ProMode togglePreselectMode end")
endFunction

function PreselectModeAnimateIn()
	;debug.trace("iEquip_ProMode PreselectModeAnimateIn start")
	Self.RegisterForModEvent("iEquip_PreselectModeAnimationComplete", "onPreselectModeAnimationComplete")

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn")
	bool animateLeft = (!AM.bAmmoMode || AM.bSimpleAmmoMode)
	if(iHandle)
		UICallback.PushBool(iHandle, animateLeft)
		UICallback.PushBool(iHandle, abPreselectSlotEnabled[2])
		UICallback.PushBool(iHandle, abPreselectSlotEnabled[1])
		UICallback.PushFloat(iHandle, WC.afWidget_A[35]) ; rightPreselectBackground alpha
		UICallback.PushFloat(iHandle, WC.afWidget_A[36]) ; rightPreselectIcon alpha
		UICallback.PushFloat(iHandle, WC.afWidget_A[37]) ; rightPreselectName alpha
		UICallback.Send(iHandle)
	endIf

	int i
	while i < 3
		if abPreselectSlotEnabled[i]
			if i < 2
				WC.updateAttributeIcons(i, WC.aiCurrentlyPreselected[i])
				TI.updateTemperTierIndicator(i + 5, jMap.getInt(jArray.getObj(WC.aiTargetQ[i], WC.aiCurrentlyPreselected[i]), "lastKnownTemperTier", 0))
			endIf
			if !WC.abIsNameShown[i]
				WC.showName(i)
			endIf
		endIf
		i += 1
	endwhile

	if WC.bNameFadeoutEnabled
		if abPreselectSlotEnabled[0] && WC.bLeftRightNameFadeEnabled
			WC.LPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[5])
		endIf
		if abPreselectSlotEnabled[1] && WC.bLeftRightNameFadeEnabled
			WC.RPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[6])
		endIf
		if abPreselectSlotEnabled[2] && WC.bShoutNameFadeEnabled
			WC.SPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[7])
		endIf
	endIf
	;debug.trace("iEquip_ProMode PreselectModeAnimateIn end")
endFunction

event onPreselectModeAnimationComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	;debug.trace("iEquip_ProMode onPreselectModeAnimationComplete start")
	If(sEventName == "iEquip_PreselectModeAnimationComplete")
		updateAnimationTargetValues()
		Self.UnregisterForModEvent("iEquip_PreselectModeAnimationComplete")
	endIf
	;debug.trace("iEquip_ProMode onPreselectModeAnimationComplete end")
endEvent

function PreselectModeAnimateOut()
	;debug.trace("iEquip_ProMode PreselectModeAnimateOut start")
	if !bTogglingPreselectOnEquipAll
		bool[] args = new bool[3]
		args[0] = abPreselectSlotEnabled[1]
		args[1] = abPreselectSlotEnabled[2]
		if !((AM.bAmmoMode && !AM.bSimpleAmmoMode) || (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > 2))
			args[2] = abPreselectSlotEnabled[0] ;Only animate out left slot if we don't currently have a ranged weapon equipped in the right hand or are in ammo mode as we still need it to show in regular mode
		endIf
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf
	int i
	while i < 3
		if i == 0 && AM.bAmmoMode && !AM.bSimpleAmmoMode
			WC.bCyclingLHPreselectInAmmoMode = true
			WC.updateAttributeIcons(0, 0)
		elseIf i < 2
			WC.hideAttributeIcons(i + 5)
			TI.updateTemperTierIndicator(i + 5)
		endIf
		if WC.bNameFadeoutEnabled && !WC.abIsNameShown[i]
			WC.showName(i)
		endIf
		i += 1
	endwhile
	if bTogglingPreselectOnEquipAll
		bTogglingPreselectOnEquipAll = false
	endIf
	;debug.trace("iEquip_ProMode PreselectModeAnimateOut end")
endFunction

function cyclePreselectSlot(int Q, int queueLength, bool Reverse = false, bool animate = true, bool onKeyPress = false)
	;debug.trace("iEquip_ProMode cyclePreselectSlot start - Q: " + Q + ", queueLength: " + queueLength + ", reverse: " + Reverse + ", animate: " + animate)
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
		if WC.iPosInd > 0 && (onKeyPress || WC.iPosInd == 2)
			WC.abCyclingQueue[Q] = false
			WC.updateQueuePositionIndicator(Q, queueLength, WC.aiCurrentQueuePosition[Q], targetIndex)
			if WC.iPosInd != 2
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
	;debug.trace("iEquip_ProMode cyclePreselectSlot end")
endFunction

function equipPreselectedItem(int Q)
	;debug.trace("iEquip_ProMode equipPreselectedItem start - Q: " + Q + ", bEquippingAllPreselectedItems: " + bEquippingAllPreselectedItems)

	bCurrentlyQuickRanged = false
	bCurrentlyQuickHealing = false

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
    TI.updateTemperTierIndicator(Q + 5, jMap.getInt(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentlyPreselected[Q]), "lastKnownTemperTier", 0))
    ;Do widget animation here if not bEquippingAllPreselectedItems
    if !bEquippingAllPreselectedItems
		targetObject = jArray.getObj(targetArray, WC.aiCurrentlyPreselected[Q])

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
				WC.LNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q])
				WC.LPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q+5])
			elseif Q == 1 && WC.bLeftRightNameFadeEnabled
				WC.RNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q])
				WC.RPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q+5])
			elseif Q == 2 && WC.bShoutNameFadeEnabled
				WC.SNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q])
				WC.SPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q+5])	
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
				WC.LNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q])
				if abPreselectSlotEnabled[0]
					WC.LPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[Q+5])
				endIf
			endIf
			if abPreselectSlotEnabled[0]
				targetObject = jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0])
				int leftItemType = jMap.getInt(targetObject, "iEquipType")
				form leftItem = jMap.getForm(targetObject, "iEquipForm")
				if WC.itemRequiresCounter(0, leftItemType)
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
		if (Q == 0 && (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1) && !(PlayerRef.GetEquippedItemType(1) < 7 && WC.bIsCGOLoaded)) || (targetItem == PlayerRef.GetEquippedObject(otherHand) && itemType != 22 && PlayerRef.GetItemCount(targetItem) < 2)
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
		int refHandle
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
			if Q == 1 && (targetItem as spell).GetEquipType() == WC.EquipSlots[3]
				WC.aiCurrentQueuePosition[Q] = itemToEquip
				WC.asCurrentlyEquipped[Q] = newName
				WC.updateOtherHandOn2HSpellEquipped(0)
				;debug.trace("iEquip_ProMode equipPreselectedItem - should have updated left slot to 2H spell")
			endIf
		elseif (Q == 1 && itemType == 42) ;Ammo in the right hand queue, so in this case grenades and other throwing weapons
	    	PlayerRef.EquipItem(targetItem as Ammo, false, true)
	    elseif (Q == 0 && itemType == 26) ;Shield in the left hand queue
	    	refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
	    	if refHandle != 0xFFFF
	    		iEquip_InventoryExt.EquipItem(targetItem, refHandle, PlayerRef)
	    	else
	    		PlayerRef.EquipItemEx(targetItem as Armor)
	    	endIf
		else
			refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
			if refHandle != 0xFFFF
				iEquip_InventoryExt.EquipItem(targetItem, refHandle, PlayerRef, iEquipSlotId)
			else
		    	PlayerRef.EquipItemEx(targetItem, iEquipSlotId, false, false)
		    endIf
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
	if WC.iPosInd == 2
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
		if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
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

			if AM.bAmmoMode && bAmmoModePreselectModeFirstLook
				if WC.bShowTooltips
					Utility.WaitMenuMode(1.8)
					Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstRanged"))
				endIf
				bAmmoModePreselectModeFirstLook = false
			endIf
		endIf
	endIf
	;debug.trace("iEquip_ProMode equipPreselectedItem end")
endFunction

function updateAnimationTargetValues()
	;debug.trace("iEquip_ProMode updateAnimationTargetValues start")
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
endFunction

function equipAllPreselectedItems(bool handsOnly = false)
	;debug.trace("iEquip_ProMode equipAllPreselectedItems start")
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
		
	if bTogglePreselectOnEquipAll && !handsOnly
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

	bool equipLeft
	if abPreselectSlotEnabled[0] && !(abPreselectSlotEnabled[1] && ((WC.ai2HWeaponTypes.Find(rightHandItemType) > -1 && !(rightHandItemType < 7 && WC.bIsCGOLoaded)) || rightHandItemType == 0 || (rightHandItemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3) || (leftTargetItem == rightTargetItem && itemCount < 2 && rightHandItemType != 22)))
		equipLeft = true
		if abPreselectSlotEnabled[1]
			WC.UnequipHand(1)
		endIf
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
			WC.LNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[0])
			WC.LPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[5])
		endIf
		if abPreselectSlotEnabled[1] && WC.bLeftRightNameFadeEnabled
			WC.RNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[1])
			WC.RPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[6])
		endIf
		if abPreselectSlotEnabled[2] && WC.bShoutNameFadeEnabled && !handsOnly
			WC.SNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[2])
			WC.SPNUpdate.registerForNameFadeoutUpdate(WC.aiNameElements[7])	
		endIf
	endIf
	bEquippingAllPreselectedItems = false

	if AM.bAmmoMode && bAmmoModePreselectModeFirstLook
		if WC.bShowTooltips
			Utility.WaitMenuMode(1.0)
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_PM_msg_firstRanged"))
		endIf
		bAmmoModePreselectModeFirstLook = false
	endIf
	;debug.trace("iEquip_ProMode equipAllPreselectedItems end")
endFunction

event EquipAllComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	;debug.trace("iEquip_ProMode EquipAllComplete start")
	If(sEventName == "iEquip_EquipAllComplete")
		bAllEquipped = true
		Self.UnregisterForModEvent("iEquip_EquipAllComplete")
	endIf
	if bTogglePreselectOnEquipAll && !bOverrideTogglePreselectOnEquipAll
		bTogglingPreselectOnEquipAll = true
		togglePreselectMode()
	endIf
	;debug.trace("iEquip_ProMode EquipAllComplete end")
endEvent

;The forceSwitch bool is set to true when quickShield is called by WC.removeItemFromQueue when a previously equipped shield has been removed, so we're only looking for a shield, not a ward
function quickShield(bool forceSwitch = false, bool onTorchDropped = false, bool calledByQuickRanged = false)
	;debug.trace("iEquip_ProMode quickShield start - forceSwitch: " + forceSwitch + ", onTorchDropped: " + onTorchDropped)
	;if right hand or ranged weapon in right hand and bQuickShield2HSwitchAllowed not enabled then return out
	if (!bQuickShieldEnabled && !onTorchDropped && !calledByQuickRanged) || (!forceSwitch && (((WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1 && !(PlayerRef.GetEquippedItemType(1) < 7 && WC.bIsCGOLoaded)) && !bQuickShield2HSwitchAllowed) || (bPreselectMode && iPreselectQuickShield == 0)))
		return
	endIf
	int i
	int targetArray = WC.aiTargetQ[0]
	int leftCount = jArray.count(targetArray)
	int found = -1
	int foundType
	int targetObject
	bool rightHandHasSpell = ((PlayerRef.GetEquippedItemType(1) == 9) && !(jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipType") == 42))
	bool rightHandSpellIsPrefSchool
	if rightHandHasSpell
		rightHandSpellIsPrefSchool = WC.getSpellSchool(PlayerRef.GetEquippedSpell(1)) == sQuickShieldPreferredMagicSchool
	endIf
	;debug.trace("iEquip_ProMode quickShield() - RH current item: " + WC.asCurrentlyEquipped[1] + ", RH item type: " + (PlayerRef.GetEquippedItemType(1)))
	;if player currently has a spell equipped in the right hand or we've enabled Prefer Magic in the MCM search for a ward spell first
	if !forceSwitch && (iQuickShieldPreferredItemType == 1 || (iQuickShieldPreferredItemType == 2 && rightHandHasSpell))
		;debug.trace("iEquip_ProMode quickShield() - should be looking for a ward spell")
		;debug.trace("iEquip_ProMode quickShield() - leftCount: " + leftCount + ", current queue position: " + WC.aiCurrentQueuePosition[0] + ", bPreselectMode: " + bPreselectMode + ", ammo mode: " + AM.bAmmoMode)
		while i < leftCount && found == -1
			;debug.trace("iEquip_ProMode quickShield() - i: " + i + ", item name: " + jMap.getStr(jArray.getObj(targetArray, i), "iEquipName") + ", item type: " + jMap.getInt(jArray.getObj(targetArray, i), "iEquipType"))
			if jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 22
				;debug.trace("iEquip_ProMode quickShield() - is this a ward spell: " + iEquip_FormExt.IsSpellWard(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm")))
			endIf
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 22 && iEquip_FormExt.IsSpellWard(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm"))
				found = i
				foundType = 22
			endIf
			i += 1
		endwhile
		;if we haven't found a ward look for a shield
		if found == -1
			;debug.trace("iEquip_ProMode quickShield() - ward spell not found, should now be looking for a shield")
			i = 0
			while i < leftCount && found == -1
				if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 26
					found = i
					foundType = 26
				endIf
				i += 1
			endwhile
			if found == -1 && bScanInventory && scanInventoryForItemOfType(26)
				found = jArray.count(WC.aiTargetQ[0]) - 1
				foundType = 26
			endIf
		endIf
	;Otherwise look for a shield first
	else
		;debug.trace("iEquip_ProMode quickShield() - should be looking for a shield")
		while i < leftCount && found == -1
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 26
				found = i
				foundType = 26
			endIf
			i += 1
		endwhile
		if found == -1 && bScanInventory && scanInventoryForItemOfType(26)
			found = jArray.count(WC.aiTargetQ[0]) - 1
			foundType = 26
		endIf
		;And if we haven't found a shield then look for a ward
		if found == -1 && !forceSwitch
			;debug.trace("iEquip_ProMode quickShield() - shield not found, should now be looking for a ward spell")
			i = 0
			while i < leftCount && found == -1
				if !(bPreselectMode && i == WC.aiCurrentQueuePosition[0] && !AM.bAmmoMode) && jMap.getInt(jArray.getObj(targetArray, i), "iEquipType") == 22 && iEquip_FormExt.IsSpellWard(jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm"))
					found = i
					foundType = 22
				endIf
				i += 1
			endwhile
		endIf
	endIf
	if found != -1
		if !bPreselectMode || iPreselectQuickShield == 2
			if !calledByQuickRanged
				bCurrentlyQuickRanged = false
			endIf
			bCurrentlyQuickHealing = false
			;if we're in ammo mode we need to toggle out without equipping or animating
			if AM.bAmmoMode
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

			int tmpIndex = WC.aiCurrentQueuePosition[0]
			form targetForm = jMap.getForm(jArray.getObj(targetArray, found), "iEquipForm")
			
			bool is2HWardSpell
			if foundType == 22
				is2HWardSpell = (targetForm as spell).GetEquipType() == WC.EquipSlots[3]
			endIf

			WC.aiCurrentQueuePosition[0] = found
			WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(targetArray, found), "iEquipName")
			if bPreselectMode
				WC.updateWidget(0, found, true)
				if bPreselectSwapItemsOnQuickAction
					WC.aiCurrentlyPreselected[0] = tmpIndex
					WC.updateWidget(0, tmpIndex, false, true)
				;if for some reason the found shield/ward being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				elseIf WC.aiCurrentlyPreselected[0] == found
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
			
			if (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1 && !(PlayerRef.GetEquippedItemType(1) < 7 && WC.bIsCGOLoaded)) || (foundType == 22 && iQuickShieldPreferredItemType > 0 && !rightHandSpellIsPrefSchool && !is2HWardSpell) || WC.bGoneUnarmed || WC.b2HSpellEquipped
				switchRightHand = true
				if !WC.bGoneUnarmed
					WC.UnequipHand(1)
				endIf
			endIf	
			WC.UnequipHand(0)
			
			if foundType == 22
				PlayerRef.EquipSpell(targetForm as Spell, 0)
				if calledByQuickRanged
					iQuickSlotsEquipped = 2
				endIf
			elseif foundType == 26
				int refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
				if refHandle != 0xFFFF
		    		iEquip_InventoryExt.EquipItem(targetForm, refHandle, PlayerRef)
		    	else
		    		PlayerRef.EquipItemEx(targetForm as Armor)
		    	endIf
			endIf
			WC.setCounterVisibility(0, false)
			WC.hidePoisonInfo(0)
			if WC.CM.abIsChargeMeterShown[0]
				WC.CM.updateChargeMeterVisibility(0, false)
			endIf

			if switchRightHand
				quickShieldSwitchRightHand(foundType, rightHandHasSpell)
			elseIf is2HWardSpell
				WC.updateOtherHandOn2HSpellEquipped(1)					
			endIf
			WC.checkIfBoundSpellEquipped()

		else
			WC.aiCurrentlyPreselected[0] = found
			WC.updateWidget(0, found)
		endIf
	else
		if forceSwitch || onTorchDropped
			;If we've forced quickShield because a previously equipped shield was removed from the player, or we've just dropped a lit torch and we haven't been able to find another in the left queue we now need to cycle the left queue
			WC.cycleSlot(0, false, true)
		elseIf bQuickShieldUnequipLeftIfNotFound && (PlayerRef.GetEquippedObject(1) as weapon) && (WC.ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) == -1 || (PlayerRef.GetEquippedItemType(1) < 7 && WC.bIsCGOLoaded))
			WC.UnequipHand(0)
			WC.setSlotToEmpty(0, true, true)
		else
			debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_QSNotFound"))
		endIf
	endIf
	;debug.trace("iEquip_ProMode quickShield end")
endFunction

function quickShieldSwitchRightHand(int foundType, bool rightHandHasSpell)
	;debug.trace("iEquip_ProMode quickShieldSwitchRightHand start - foundType: " + foundType + ", bQuickShieldPreferMagic: " + bQuickShieldPreferMagic + ", rightHandHasSpell: " + rightHandHasSpell)
	int i
	int targetArray = WC.aiTargetQ[1]
	int rightCount = jArray.count(targetArray)
	int found = -1
	int targetObject
	int itemType
	string itemName
	if foundType == 22 && bQuickShieldPreferMagic && !rightHandHasSpell
		;if we've selected a preferred magic school look for that type of spell first
		if sQuickShieldPreferredMagicSchool != ""
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getInt(targetObject, "iEquipSlot") != 3 && jMap.getStr(targetObject, "iEquipSchool") == sQuickShieldPreferredMagicSchool
					found = i
				else
					i += 1
				endIf
			endwhile
			i = 0
		endIf
		;if we haven't found a spell from the preferred school, or if we haven't set a preferred school look for any 1H spell
		if found == -1
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "iEquipType") == 22 && jMap.getInt(targetObject, "iEquipSlot") != 3
					found = i
				else
					i += 1
				endIf
			endwhile
			i = 0
		endIf
		;Finally, if we haven't found a preferred school or other spell look for another 1H item
		if found == -1
			if WC.iLastRH1HItemIndex > -1 && jMap.getForm(jArray.getObj(WC.aiTargetQ[1], WC.iLastRH1HItemIndex), "iEquipForm") as weapon && WC.ai2HWeaponTypes.Find(jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.iLastRH1HItemIndex), "iEquipType")) == -1 	; The 2H type check is just in case queue order has changed or items have been removed since we last stored a RH 1H index
				found = WC.iLastRH1HItemIndex
			else
				while i < rightCount && found == -1
					targetObject = jArray.getObj(targetArray, i)
					itemType = jMap.getInt(targetObject, "iEquipType")
					if itemType > 0 && itemType < 4 || (itemType == 4 && !(jMap.getStr(targetObject, "iEquipIcon") == "Grenade")) || itemType == 8
						found = i
					else
						i += 1
					endIf
				endwhile
			endIf
		endIf
	;Otherwise look for any 1h item or spell	
	elseIf WC.iLastRH1HItemIndex > -1 && jMap.getForm(jArray.getObj(WC.aiTargetQ[1], WC.iLastRH1HItemIndex), "iEquipForm") as weapon && WC.ai2HWeaponTypes.Find(jMap.getInt(jArray.getObj(WC.aiTargetQ[1], WC.iLastRH1HItemIndex), "iEquipType")) == -1
		found = WC.iLastRH1HItemIndex
	else
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			itemType = jMap.getInt(targetObject, "iEquipType")
			if itemType > 0 && itemType < 4 || (itemType == 4 && !(jMap.getStr(targetObject, "iEquipIcon") == "Grenade")) || ((itemType == 5 || itemType == 6) && WC.bIsCGOLoaded) || itemType == 8 || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") != 3)
				found = i
			else
				i += 1
			endIf
		endwhile
	endIf
	if found > -1
		;if not in Preselect Mode or we've selected Preselect Mode QuickShield Equip update the widget and equip the found item/spell in the right hand
		if !bPreselectMode || iPreselectQuickShield == 2
			WC.bBlockSwitchBackToBoundSpell = true
			targetObject = jArray.getObj(WC.aiTargetQ[1], found)
			int tmpIndex = WC.aiCurrentQueuePosition[1]
			WC.aiCurrentQueuePosition[1] = found
			WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "iEquipName")
			if bPreselectMode
				WC.updateWidget(1, found, true)
				if bPreselectSwapItemsOnQuickAction
					WC.aiCurrentlyPreselected[1] = tmpIndex
					WC.updateWidget(1, tmpIndex, false, true)
				;if for some reason the found item being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				elseIf WC.aiCurrentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
			else
				WC.updateWidget(1, found)
			endIf
			WC.checkAndUpdatePoisonInfo(1)
			WC.CM.checkAndUpdateChargeMeter(1)
			if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
				TI.checkAndUpdateTemperLevelInfo(1)
			endIf
			itemType = jMap.getInt(targetObject, "iEquipType")
			form formToEquip = jMap.getForm(jArray.getObj(WC.aiTargetQ[1], found), "iEquipForm")
			if itemType == 22
				PlayerRef.EquipSpell(formToEquip as Spell, 1)
			else
				int refHandle = jMap.getInt(jArray.getObj(WC.aiTargetQ[1], found), "iEquipHandle", 0xFFFF)
				if refHandle != 0xFFFF
		    		iEquip_InventoryExt.EquipItem(formToEquip, refHandle, PlayerRef, 1)
		    	else
		    		PlayerRef.EquipItemEx(formToEquip, 1)
		    	endIf
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
	;debug.trace("iEquip_ProMode quickShieldSwitchRightHand end")
endFunction

bool bJustEquipped2HRangedSpell
bool property bQuickRangedGiveMeAnythingGoddamit auto hidden
bool[] property abQuickRangedSpellSchoolAllowed auto hidden
int property iQuickRanged1HPreferredHand = 1 auto hidden
int property iQuickRanged1HOtherHandAction auto hidden

function quickRanged()
	;debug.trace("iEquip_ProMode quickRanged start - bCurrentlyQuickRanged: " + bCurrentlyQuickRanged)

    if bQuickRangedEnabled
        if bCurrentlyQuickRanged
        	; Firstly check if we are actually still QuickRanged in case player has directly equipped something else in the meantime
        	bool stillRanged
        	int rightHandItemType = PlayerRef.GetEquippedItemType(1)
        	int leftHandItemType = PlayerRef.GetEquippedItemType(0)
        	if rightHandItemType == 7 || rightHandItemType == 12
        		stillRanged = true
        	;elseIf iQuickRanged1HPreferredHand == 1 && (rightHandItemType == 8 && IsStaffRanged(PlayerRef.GetEquippedObject(1)) || (rightHandItemType == 9 && IsSpellRanged(PlayerRef.GetEquippedObject(1))
        	elseIf iQuickRanged1HPreferredHand == 1 && (rightHandItemType == 8 || rightHandItemType == 9) && IsThrowingKnife(PlayerRef.GetEquippedObject(1))
        		stillRanged = true
        	;elseIf iQuickRanged1HPreferredHand == 0 && (leftHandItemType == 8 && IsStaffRanged(PlayerRef.GetEquippedObject(0)) || (leftHandItemType == 9 && IsSpellRanged(PlayerRef.GetEquippedObject(0))
        	elseIf iQuickRanged1HPreferredHand == 0 && (leftHandItemType == 8 || leftHandItemType == 9) && IsThrowingKnife(PlayerRef.GetEquippedObject(0))
        		stillRanged = true
        	endIf

        	if !stillRanged
        		bCurrentlyQuickRanged = false
        	endIf
        endIf

        if bCurrentlyQuickRanged
            quickRangedSwitchOut()
        else
        	bJustEquipped2HRangedSpell = false
        	bCurrentlyQuickHealing = false
			iQuickSlotsEquipped = -1

            if !(AM.bAmmoMode || (bPreselectMode && iPreselectQuickRanged == 0))
                bool actionTaken

                if iQuickRangedSwitchOutAction > 0
                	saveCurrentItemsForSwitchBack()
                endIf

                if iQuickRangedPreferredWeaponType > 3
                	actionTaken = quickRangedFindAndEquipSpellOrStaff()
                elseIf iQuickRangedPreferredWeaponType > 1
                    actionTaken = quickRangedFindAndEquipBoundSpell()
                else
                    actionTaken = quickRangedFindAndEquipWeapon()
                endIf

                if !actionTaken && bQuickRangedGiveMeAnythingGoddamit
                    if iQuickRangedPreferredWeaponType > 3 || iQuickRangedPreferredWeaponType < 2
	                	actionTaken = quickRangedFindAndEquipBoundSpell()
	                else
                        actionTaken = quickRangedFindAndEquipSpellOrStaff()
                    endIf
                endIf

                if !actionTaken && bQuickRangedGiveMeAnythingGoddamit
                    if iQuickRangedPreferredWeaponType > 1
	                	actionTaken = quickRangedFindAndEquipWeapon()
	                else
                        actionTaken = quickRangedFindAndEquipSpellOrStaff()
                    endIf
                endIf

                if actionTaken
                	WC.bGoneUnarmed = false
                	if !bJustEquipped2HRangedSpell
                		WC.b2HSpellEquipped = false
                	endIf
                else
                    debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_QRNoRanged"))
                endIf
            endIf
        endIf
    endIf
    ;debug.trace("iEquip_ProMode quickRanged end")
endFunction

bool function quickRangedFindAndEquipWeapon(int typeToFind = -1, bool setCurrentlyQuickRangedFlag = true)
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon start - typeToFind: " + typeToFind + ", setCurrentlyQuickRangedFlag: " + setCurrentlyQuickRangedFlag)

	bool actionTaken
	int preferredType = 7 ;Bow
	int secondChoice = 9 ;Crossbow
	if typeToFind == 9 || (typeToFind != 7 && (iQuickRangedPreferredWeaponType == 1 || iQuickRangedPreferredWeaponType == 3))
		preferredType = 9
		secondChoice = 7
	endIf
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
	endIf
	if found == -1 && bScanInventory && scanInventoryForItemOfType(41)
		found = jArray.count(WC.aiTargetQ[1]) - 1
	endIf
	if found != -1
		;if we're not in Preselect Mode, or we've selected Preselect Mode Equip in the MCM
		if !bPreselectMode || iPreselectQuickRanged == 2
			bCurrentlyQuickHealing = false
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
				int refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
				if refHandle != 0xFFFF
		    		iEquip_InventoryExt.EquipItem(jMap.getForm(targetObject, "iEquipForm"), refHandle, PlayerRef, 1)
		    	else
		    		PlayerRef.EquipItemEx(jMap.getForm(targetObject, "iEquipForm"), 1, false, false)
		    	endIf
		    	if bPreselectMode
			    	if bPreselectSwapItemsOnQuickAction
						WC.aiCurrentlyPreselected[1] = iPreviousRightHandIndex
						WC.updateWidget(1, iPreviousRightHandIndex, false, true)
					;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
					elseIf WC.aiCurrentlyPreselected[1] == found
						cyclePreselectSlot(1, rightCount, false)
					endIf
				endIf
				if foundWeaponIsPoisoned
					WC.checkAndUpdatePoisonInfo(1)
				elseif WC.abIsCounterShown[1]
					WC.setCounterVisibility(1, false)
				endIf
				WC.CM.checkAndUpdateChargeMeter(1)
				if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
					TI.checkAndUpdateTemperLevelInfo(1)
				endIf

			;if we're not in Preselect Mode or Ammo Mode we can now equip as normal which will toggle Ammo Mode
			else
				WC.checkAndEquipShownHandItem(1, false, false, true)
			endIf
			if setCurrentlyQuickRangedFlag && iQuickRangedSwitchOutAction > 0
				bCurrentlyQuickRanged = true
			endIf
			iQuickSlotsEquipped = 2
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipWeapon end")
	return actionTaken
endFunction

bool function quickRangedFindAndEquipBoundSpell()
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipBoundSpell start")

	bool actionTaken
	int preferredType = 7
	int secondChoice = 9
	if iQuickRangedPreferredWeaponType == 3 || iQuickRangedPreferredWeaponType == 1
		preferredType = 9
		secondChoice = 7
	endIf
	int i
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int found = -1
	;Look for our first choice bound ranged weapon spell
	while i < rightCount && found == -1
		targetObject = jArray.getObj(targetArray, i)
		if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_SpellExt.GetBoundSpellWeapType(jMap.getForm(targetObject, "iEquipForm") as spell) == preferredType
			found = i
		endIf
		i += 1
	endwhile
	;if we haven't found our first choice bound ranged weapon spell now look for the alternative
	if found == -1
		i = 0
		while i < rightCount && found == -1
			targetObject = jArray.getObj(targetArray, i)
			if !(bPreselectMode && i == WC.aiCurrentQueuePosition[1]) && jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_SpellExt.GetBoundSpellWeapType(jMap.getForm(targetObject, "iEquipForm") as spell) == secondChoice
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
			if bPreselectMode
		    	if bPreselectSwapItemsOnQuickAction
					WC.aiCurrentlyPreselected[1] = iPreviousRightHandIndex
					WC.updateWidget(1, iPreviousRightHandIndex, false, true)
				;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
				elseIf WC.aiCurrentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
			endIf
			WC.checkAndEquipShownHandItem(1, false)
			if iQuickRangedSwitchOutAction > 0
				bCurrentlyQuickRanged = true
			endIf
			iQuickSlotsEquipped = 1
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[1] = found
			WC.updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipBoundSpell end")
	return actionTaken
endFunction

; iQuickRanged1HOtherHandAction - 0 = Do nothing, 1 = Dual equip same spell, 2 = Another spell/staff, 3 = Ward Spell, 4 = 1H weapon

bool function quickRangedFindAndEquipSpellOrStaff()
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipSpellOrStaff start")
	bool actionTaken

	; Do preferred hand action first
	
	if iQuickRangedPreferredWeaponType > 1 && iQuickRangedPreferredWeaponType < 5
		actionTaken = quickRangedFindAndEquipSpell()
	else
		actionTaken = quickRangedFindAndEquipStaff()
	endIf

	if !actionTaken && bQuickRangedGiveMeAnythingGoddamit
		if iQuickRangedPreferredWeaponType > 1 && iQuickRangedPreferredWeaponType < 5
			actionTaken = quickRangedFindAndEquipStaff()
		else
			actionTaken = quickRangedFindAndEquipSpell()
		endIf
	endIf

	; Now if we've equipped the preferred hand carry out the preferred other hand action

	if actionTaken && iQuickRanged1HOtherHandAction > 0 && !bJustEquipped2HRangedSpell
		bool spellEquipped = PlayerRef.GetEquippedItemType(iQuickRanged1HPreferredHand) == 9
		if iQuickRanged1HOtherHandAction == 1													; Dual equip the same spell
			if spellEquipped
				quickDualCastOnDoubleTap(iQuickRanged1HPreferredHand)
				iQuickSlotsEquipped = 2
			endIf
		elseIf iQuickRanged1HOtherHandAction == 2												; Equip a different spell or staff, preferring the same type (spell or staff) if possible
			bool otherHandEquipped
			if spellEquipped
				otherHandEquipped = quickRangedFindAndEquipSpell(true)
				if !otherHandEquipped
					otherHandEquipped = quickRangedFindAndEquipStaff(true)
				endIf
			else
				otherHandEquipped = quickRangedFindAndEquipStaff(true)
				if !otherHandEquipped
					otherHandEquipped = quickRangedFindAndEquipSpell(true)
				endIf
			endIf
		elseIf iQuickRanged1HOtherHandAction == 3												; Equip a ward spell or shield (only if the preferred hand is the right hand) - NO INVENTORY SCANNING so only looks in queue items in the other hand
			if iQuickRanged1HPreferredHand == 1
				quickShield(false, false, true)
			endIf
		else 																					; Equip a 1H weapon (or 2H if using Combat Gameplay Overhaul) - NO INVENTORY SCANNING so only looks in queue items in the other hand
			quickRangedFindAndEquipWeaponInOtherHand()
		endIf
	endIf
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipSpellOrStaff end")
	return actionTaken
endFunction

bool function quickRangedFindAndEquipSpell(bool equippingOtherHand = false)
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipSpell start")
	bool actionTaken
	int Q = iQuickRanged1HPreferredHand
	int otherHand
	bool spellEquipped
	if equippingOtherHand
		otherHand = Q
		Q = (Q + 1) % 2
		spellEquipped = PlayerRef.GetEquippedItemType(otherHand) == 9
	endIf
	int i
	int targetArray = WC.aiTargetQ[Q]
	int targetObject
	int queueLength = jArray.count(targetArray)
	spell foundSpell
	
	;Look for a ranged spell in the preferred hand queue first
	while i < queueLength && foundSpell == none
		targetObject = jArray.getObj(targetArray, i)
		;if !(bPreselectMode && i == WC.aiCurrentQueuePosition[Q]) && jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_FormExt.IsSpellRanged(jMap.getForm(targetObject, "iEquipForm") as spell) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(jMap.getStr(targetObject, "iEquipSchool"))]
		; LE Only - the following line is a workaround due to missing IsSpellRanged function in LE version of iEquipUtil.  For SE uncomment the line above and comment out the following line
		if !(bPreselectMode && i == WC.aiCurrentQueuePosition[Q]) && jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_FormExt.IsThrowingKnife(jMap.getForm(targetObject, "iEquipForm")) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(jMap.getStr(targetObject, "iEquipSchool"))] && !(equippingOtherHand && spellEquipped && PlayerRef.GetEquippedSpell(otherHand) == jMap.getForm(targetObject, "iEquipForm") as spell)
			foundSpell = jMap.getForm(targetObject, "iEquipForm") as spell
		else
			i += 1
		endIf
	endwhile
	
	if foundSpell == none && bScanInventory

		int spellCount = PlayerRef.GetSpellCount()	; Check through players learned spells starting with the most recent
		spell spellToCheck
		
		while spellCount > 0 && foundSpell == none
			spellToCheck = PlayerRef.GetNthSpell(spellCount)
			;if iEquip_FormExt.IsSpellRanged(spellToCheck) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(WC.getSpellSchool(spellToCheck))]
			; LE Only - the following line is a workaround due to missing IsSpellRanged function in LE version of iEquipUtil.  For SE uncomment the line above and comment out the following line
			if iEquip_FormExt.IsThrowingKnife(spellToCheck) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(WC.getSpellSchool(spellToCheck))] && !(equippingOtherHand && spellEquipped && PlayerRef.GetEquippedSpell(otherHand) == spellToCheck)
				foundSpell = spellToCheck
			else
				spellCount -=1
			endIf
		endWhile

		if foundSpell == none						; If we haven't found a learned ranged spell then as a last resort check the player race starting spells
			spellCount = PlayerRef.GetActorBase().GetSpellCount()

			while spellCount > 0 && foundSpell == none
				spellToCheck = PlayerRef.GetActorBase().GetNthSpell(spellCount)
				;if iEquip_FormExt.IsSpellRanged(spellToCheck) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(WC.getSpellSchool(spellToCheck))]
				; LE Only - the following line is a workaround due to missing IsSpellRanged function in LE version of iEquipUtil.  For SE uncomment the line above and comment out the following line
				if iEquip_FormExt.IsThrowingKnife(spellToCheck) && abQuickRangedSpellSchoolAllowed[asSpellSchools.Find(WC.getSpellSchool(spellToCheck))] && !(equippingOtherHand && spellEquipped && PlayerRef.GetEquippedSpell(otherHand) == spellToCheck)
					foundSpell = spellToCheck
				else
					spellCount -=1
				endIf
			endWhile
		endIf

		if foundSpell
			addNonEquippedItemToQueue(Q, foundSpell as form, 22)
			i = queueLength
		endIf
	endIf

	if foundSpell != none
	
		bool is2HSpell = (foundSpell.GetEquipType() == WC.EquipSlots[3])

		if !bPreselectMode || iPreselectQuickRanged == 2

			if WC.abPoisonInfoDisplayed[Q]
				WC.hidePoisonInfo(Q)
			endIf
			if WC.abIsCounterShown[Q]
				WC.setCounterVisibility(Q, false)
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(Q, 22)
			endIf

			WC.aiCurrentQueuePosition[Q] = i
			WC.asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetArray, i), "iEquipName")
			WC.updateWidget(Q, i, true)

			if bPreselectMode
		    	if bPreselectSwapItemsOnQuickAction
		    		int previousIndex
		    		if Q == 0
		    			previousIndex = iPreviousLeftHandIndex
		    		else
		    			previousIndex = iPreviousRightHandIndex
		    		endIf
					WC.aiCurrentlyPreselected[Q] = previousIndex
					WC.updateWidget(Q, previousIndex, false, true)
				;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
				elseIf WC.aiCurrentlyPreselected[Q] == i
					cyclePreselectSlot(Q, queueLength, false)
				endIf
			endIf
			
			PlayerRef.EquipSpell(foundSpell, Q)
			
			if is2HSpell
				WC.updateOtherHandOn2HSpellEquipped((Q + 1) % 2)
				Q = 2
			endIf
			
			bJustEquipped2HRangedSpell = is2HSpell
			
			if iQuickRangedSwitchOutAction > 0
				bCurrentlyQuickRanged = true
				if equippingOtherHand
					iQuickSlotsEquipped = 2
				else	
					iQuickSlotsEquipped = Q
				endIf
			endIf
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[Q] = i
			WC.updateWidget(Q, i)
		endIf

		actionTaken = true
	endIf
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipSpell end")
	return actionTaken
endFunction

bool function quickRangedFindAndEquipStaff(bool equippingOtherHand = false)
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipStaff start")
	bool actionTaken
	int Q = iQuickRanged1HPreferredHand
	int otherHand
	bool staffEquipped
	if equippingOtherHand
		otherHand = Q
		Q = (Q + 1) % 2
		staffEquipped = PlayerRef.GetEquippedItemType(otherHand) == 8
	endIf
	int i
	int targetArray = WC.aiTargetQ[Q]
	int targetObject
	int queueLength = jArray.count(targetArray)
	form foundStaff
	;Look for our first choice bound ranged weapon spell
	while i < queueLength && foundStaff == none
		targetObject = jArray.getObj(targetArray, i)
		;if !(bPreselectMode && i == WC.aiCurrentQueuePosition[Q]) && jMap.getInt(targetObject, "iEquipType") == 8 && iEquip_FormExt.IsStaffRanged(jMap.getForm(targetObject, "iEquipForm"))
		; LE Only - the following line is a workaround due to missing IsStaffRanged function in LE version of iEquipUtil.  For SE uncomment the line above and comment out the following line
		if !(bPreselectMode && i == WC.aiCurrentQueuePosition[Q]) && jMap.getInt(targetObject, "iEquipType") == 8 && iEquip_FormExt.IsThrowingKnife(jMap.getForm(targetObject, "iEquipForm")) && !(equippingOtherHand && staffEquipped && (PlayerRef.GetEquippedObject(otherHand) == jMap.getForm(targetObject, "iEquipForm")) && (PlayerRef.GetItemCount(jMap.getForm(targetObject, "iEquipForm")) == 1))
			foundStaff = jMap.getForm(targetObject, "iEquipForm")
		else
			i += 1
		endIf
	endwhile
	
	if foundStaff == none && bScanInventory && scanInventoryForItemOfType(41, true, Q)
		i = queueLength
		foundStaff = jMap.getForm(jArray.getObj(targetArray, i), "iEquipForm")
	endIf

	if foundStaff != none
	
		if !bPreselectMode || iPreselectQuickRanged == 2

			if WC.abPoisonInfoDisplayed[Q]
				WC.hidePoisonInfo(Q)
			endIf
			if WC.abIsCounterShown[Q]
				WC.setCounterVisibility(Q, false)
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(Q, 8)
			endIf

			WC.aiCurrentQueuePosition[Q] = i
			WC.asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetArray, i), "iEquipName")
			WC.updateWidget(Q, i, true)

			if bPreselectMode
		    	if bPreselectSwapItemsOnQuickAction
		    		int previousIndex
		    		if Q == 0
		    			previousIndex = iPreviousLeftHandIndex
		    		else
		    			previousIndex = iPreviousRightHandIndex
		    		endIf
					WC.aiCurrentlyPreselected[Q] = previousIndex
					WC.updateWidget(Q, previousIndex, false, true)
				;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
				elseIf WC.aiCurrentlyPreselected[Q] == i
					cyclePreselectSlot(Q, queueLength, false)
				endIf
			endIf
			
			PlayerRef.EquipItemEx(foundStaff, aiHandEquipSlots[Q])
			
			if iQuickRangedSwitchOutAction > 0
				bCurrentlyQuickRanged = true
				if equippingOtherHand
					iQuickSlotsEquipped = 2
				else	
					iQuickSlotsEquipped = Q
				endIf
			endIf
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[Q] = i
			WC.updateWidget(Q, i)
		endIf

		actionTaken = true
	endIf
	;debug.trace("iEquip_ProMode quickRangedFindAndEquipStaff end")
	return actionTaken
endFunction

function quickRangedFindAndEquipWeaponInOtherHand()
	int i
	int Q = (iQuickRanged1HPreferredHand + 1) % 2
	int targetArray = WC.aiTargetQ[Q]
	int targetObject
	int itemType
	int queueLength = jArray.count(targetArray)
	form foundWeapon
	
	while i < queueLength && foundWeapon == none
		targetObject = jArray.getObj(targetArray, i)
		itemType = jMap.getInt(targetObject, "iEquipType")
		if !(bPreselectMode && i == WC.aiCurrentQueuePosition[Q]) && itemType > 0 && (itemType < 5 || (WC.bIsCGOLoaded && itemType < 7))
			foundWeapon = jMap.getForm(targetObject, "iEquipForm")
		else
			i += 1
		endIf
	endwhile

	if foundWeapon != none
		if !bPreselectMode || iPreselectQuickRanged == 2

			if WC.abPoisonInfoDisplayed[Q]
				WC.hidePoisonInfo(Q)
			endIf
			if WC.abIsCounterShown[Q]
				WC.setCounterVisibility(Q, false)
			endIf
			if WC.bLeftIconFaded
				WC.checkAndFadeLeftIcon(Q, itemType)
			endIf

			WC.aiCurrentQueuePosition[Q] = i
			WC.asCurrentlyEquipped[Q] = jMap.getStr(targetObject, "iEquipName")
			WC.updateWidget(Q, i, true)

			if bPreselectMode
		    	if bPreselectSwapItemsOnQuickAction
		    		int previousIndex
		    		if Q == 0
		    			previousIndex = iPreviousLeftHandIndex
		    		else
		    			previousIndex = iPreviousRightHandIndex
		    		endIf
					WC.aiCurrentlyPreselected[Q] = previousIndex
					WC.updateWidget(Q, previousIndex, false, true)
				;If we're in Preselect Mode check if we've equipping the currently preselected item and cycle that slot on if so
				elseIf WC.aiCurrentlyPreselected[Q] == i
					cyclePreselectSlot(Q, queueLength, false)
				endIf
			endIf
			
			PlayerRef.EquipItemEx(foundWeapon, aiHandEquipSlots[Q])
			
			if iQuickRangedSwitchOutAction > 0
				iQuickSlotsEquipped = 2
			endIf
		;Otherwise update the Preselect Mode preselect slot
		else
			WC.aiCurrentlyPreselected[Q] = i
			WC.updateWidget(Q, i)
		endIf
	endIf

endFunction

function quickRangedSwitchOut(bool force1H = false)
	;debug.trace("iEquip_ProMode quickRangedSwitchOut start - iQuickRangedSwitchOutAction: " + iQuickRangedSwitchOutAction)
	bCurrentlyQuickRanged = false
	int targetIndex = -1
	int targetArray = WC.aiTargetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int i
	if iQuickRangedSwitchOutAction == 1 && !force1H ;Switch Back
		;targetIndex = iPreviousRightHandIndex
		quickSwitchBack(false, true)
	else
		if force1H || iQuickRangedSwitchOutAction == 2 || iQuickRangedSwitchOutAction == 3 ;Two Handed or One Handed
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
			;debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction = 2 or 3, targetIndex: " + targetIndex)
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
			;debug.trace("iEquip_ProMode quickRangedSwitchOut doing iQuickRangedSwitchOutAction: 4, targetIndex: " + targetIndex)
		endIf
		;debug.trace("iEquip_ProMode quickRangedSwitchOut - final targetIndex: " + targetIndex)
		targetObject = jArray.getObj(targetArray, targetIndex)
		WC.aiCurrentQueuePosition[1] = targetIndex
		WC.asCurrentlyEquipped[1] = jMap.getStr(targetObject, "iEquipName")
		WC.updateWidget(1, targetIndex, true)
		if bPreselectMode
			WC.bBlockSwitchBackToBoundSpell = true
			AM.toggleAmmoMode(abPreselectSlotEnabled[0], false)
			form formToEquip = jMap.getForm(targetObject, "iEquipForm")
			int refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
			if refHandle != 0xFFFF
	    		iEquip_InventoryExt.EquipItem(formToEquip, refHandle, PlayerRef, 1)
	    	else
	    		PlayerRef.EquipItemEx(formToEquip, 1, false, false)
	    	endIf
			WC.checkAndUpdatePoisonInfo(1)
			WC.CM.checkAndUpdateChargeMeter(1)
			if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
				TI.checkAndUpdateTemperLevelInfo(1)
			endIf
			if WC.aiCurrentlyPreselected[1] == targetIndex
				cyclePreselectSlot(1, jArray.count(targetArray), false)
			endIf
			if WC.ai2HWeaponTypes.Find(jMap.getInt(targetObject, "iEquipType")) == -1
				targetArray = WC.aiTargetQ[0]
				targetObject = jArray.getObj(targetArray, WC.aiCurrentQueuePosition[0])
				refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
				if refHandle != 0xFFFF
		    		iEquip_InventoryExt.EquipItem(jMap.getForm(targetObject, "iEquipForm"), refHandle, PlayerRef, 2)
		    	else
		    		PlayerRef.EquipItemEx(jMap.getForm(targetObject, "iEquipForm"), 2, false, false)
		    	endIf
				WC.checkAndUpdatePoisonInfo(0)
				WC.CM.checkAndUpdateChargeMeter(0)
				if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
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
	endIf
	;debug.trace("iEquip_ProMode quickRangedSwitchOut end")
endFunction

function quickDualCastOnDoubleTap(int Q)
	;debug.trace("iEquip_ProMode quickDualCastOnDoubleTap start - Q: " + Q)
	int otherHand = (Q + 1) % 2
	spell equippedSpell = PlayerRef.GetEquippedSpell(Q)
	if WC.EquipSlots.Find(equippedSpell.GetEquipType()) == 2 && equippedSpell != PlayerRef.GetEquippedSpell(otherHand)	; If it's an 'Either Hand' spell and isn't already equipped in the other hand
		int tmpIndex = WC.aiCurrentQueuePosition[otherHand]
		if quickDualCastEquipSpellInOtherHand(Q, equippedSpell as form, equippedSpell.GetName(), jMap.getStr(jArray.getObj(WC.aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "iEquipIcon"), true) && bPreselectMode && bPreselectSwapItemsOnQuickAction
			WC.aiCurrentlyPreselected[otherHand] = tmpIndex
			WC.updateWidget(otherHand, tmpIndex, false, true)
		endIf
	endIf
	;debug.trace("iEquip_ProMode quickDualCastOnDoubleTap end")
endFunction

bool function quickDualCastEquipSpellInOtherHand(int Q, form spellToEquip, string spellName, string spellIcon, bool onDoubleTapSpell = false)
	;debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand start - Q: " + Q + ", " + spellName + ", icon: " + spellIcon + ", onDoubleTapSpell: " + onDoubleTapSpell + ", bBlockQuickDualCast: " + bBlockQuickDualCast)
	if bBlockQuickDualCast
		bBlockQuickDualCast = false
		return false
	else
		int otherHand = (Q + 1) % 2
		int nameElement = 25 ;rightName_mc
		int iconElement = 24 ;rightIcon_mc
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
			TI.updateTemperTierIndicator(otherHand)
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
	;debug.trace("iEquip_ProMode quickDualCastEquipSpellInOtherHand end")
endFunction

function quickRestore()
	;debug.trace("iEquip_ProMode quickRestore start")
	if bQuickRestoreEnabled

		bool bPlayerIsInCombat = PlayerRef.IsInCombat()
		bool bDoBoth
		bool bQuickBuff
		bool bRunningQuickBuffOnSecondPress = bQuickBuffEnabled && ((Utility.GetCurrentRealTime() - fTimeOfLastQuickRestore) < fQuickBuff2ndPressDelay && (iQuickBuffControl == 1 || (iQuickBuffControl == 2 && bPlayerIsInCombat)))

		if bQuickBuffEnabled
			bDoBoth = iQuickBuffControl == 0 || (iQuickBuffControl == 2 && !bPlayerIsInCombat)
			bQuickBuff = bDoBoth || bRunningQuickBuffOnSecondPress
		endIf

		if bDoBoth || bQuickBuff
			fTimeOfLastQuickRestore = Utility.GetCurrentRealTime() - fQuickBuff2ndPressDelay	; If we're running QuickBuff close the 2nd press window.  Will be re-opened again if we're running QR.
		endIf

		if bCurrentlyQuickHealing && !bRunningQuickBuffOnSecondPress

			if !((iQuickSlotsEquipped > 0 && (PlayerRef as objectReference).GetAnimationVariableBool("IsCastingRight")) || ((iQuickSlotsEquipped == 0 || iQuickSlotsEquipped == 2) && (PlayerRef as objectReference).GetAnimationVariableBool("IsCastingLeft")))
				quickSwitchBack(true, bPlayerIsInCombat)
			endIf

		else
			bool bQuickRestore = bDoBoth || !bQuickBuff

			float currAV

			;debug.trace("iEquip_ProMode quickRestore - bPlayerIsInCombat: " + bPlayerIsInCombat + ", bIn2ndPressWindow: " + ((Utility.GetCurrentRealTime() - fTimeOfLastQuickRestore) < fQuickBuff2ndPressDelay) + ", bDoBoth: " + bDoBoth + ", bQuickBuff: " + bQuickBuff + ", bQuickRestore: " + bQuickRestore + ", fQuickRestoreThreshold: " + fQuickRestoreThreshold)

			if bQuickRestore
				fTimeOfLastQuickRestore = Utility.GetCurrentRealTime()
			endIf

			if bQuickHealEnabled
		        ;debug.trace("iEquip_ProMode quickRestore - bQuickHealEnabled: " + bQuickHealEnabled)
		        if bQuickRestore
		        	;debug.trace("iEquip_ProMode quickRestore - calling quickHeal")
		        	quickHeal()
		        endIf

		        if bQuickBuff
		        	If PO.getPotionTypeCount(1) > 0 || PO.getPotionTypeCount(2) > 0
			        	;debug.trace("iEquip_ProMode quickRestore - calling quickBuff health")
						PO.quickBuffFindAndConsumePotions(0)
					elseIf PO.iNotificationLevel > 0
						debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noHealthBuffPotions"))
					endIf
				endIf
		    endIf

		    if bQuickStaminaEnabled
		    	currAV = PlayerRef.GetActorValue("Stamina")
	    		if bQuickRestore && (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, 26)) <= fQuickRestoreThreshold)
			    	;debug.trace("iEquip_ProMode quickRestore - calling selectAndConsumePotion for Stamina")
			    	PO.selectAndConsumePotion(2, 0) ;Stamina
			    elseIf PO.iNotificationLevel > 0
			    	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_StaminaFull"))
			    endIf
				
				if bQuickBuff
					If PO.getPotionTypeCount(7) > 0 || PO.getPotionTypeCount(8) > 0
						;debug.trace("iEquip_ProMode quickRestore - calling quickBuff stamina")
						PO.quickBuffFindAndConsumePotions(2)
					elseIf PO.iNotificationLevel > 0
						debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noStaminaBuffPotions"))
					endIf
				endIf
		    endIf

		    if bQuickMagickaEnabled
		    	currAV = PlayerRef.GetActorValue("Magicka")
		    	if bQuickRestore && (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, 25)) <= fQuickRestoreThreshold)
			    	;debug.trace("iEquip_ProMode quickRestore - calling selectAndConsumePotion for Magicka")
			    	PO.selectAndConsumePotion(1, 0) ;Magicka
			    elseIf PO.iNotificationLevel > 0
			    	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_MagickaFull"))
			    endIf
				
				if bQuickBuff
					If PO.getPotionTypeCount(4) > 0 || PO.getPotionTypeCount(5) > 0
						;debug.trace("iEquip_ProMode quickRestore - calling quickBuff magicka")
						PO.quickBuffFindAndConsumePotions(1)
					elseIf PO.iNotificationLevel > 0
						debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_noMagickaBuffPotions"))
					endIf
				endIf
		    endIf
		endIf
	endIf
    ;debug.trace("iEquip_ProMode quickRestore end")
endFunction

function quickHeal()
	;debug.trace("iEquip_ProMode quickHeal start")

    bQuickHealActionTaken = false
    if bQuickHealPreferMagic
        quickHealFindAndEquipSpell()
    elseIf PO.getPotionTypeCount(0) > 0
    	if (PlayerRef.GetActorValue("Health") / (PlayerRef.GetActorValue("Health") + iEquip_ActorExt.GetAVDamage(PlayerRef, 24)) <= fQuickRestoreThreshold)
	    	PO.selectAndConsumePotion(0, 0, true)
	   	elseIf PO.iNotificationLevel > 0
			debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_HealthFull"))
	    endIf
	    bQuickHealActionTaken = true
	endIf
    	
    if !bQuickHealActionTaken && bQuickHealUseFallback
        if bQuickHealPreferMagic
        	If PO.getPotionTypeCount(0) > 0
	        	if (PlayerRef.GetActorValue("Health") / (PlayerRef.GetActorValue("Health") + iEquip_ActorExt.GetAVDamage(PlayerRef, 24)) <= fQuickRestoreThreshold)
	            	PO.selectAndConsumePotion(0, 0, true)
	            elseIf PO.iNotificationLevel > 0
	            	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_PM_not_PrefMagicHealthFull"))
	            endIf
	        endIf
        else
            quickHealFindAndEquipSpell()
        endIf
    endIf
    ;debug.trace("iEquip_ProMode quickHeal end")
endFunction

function quickHealFindAndEquipSpell()
	;debug.trace("iEquip_ProMode quickHealFindAndEquipSpell start")
	int i
	int Q
	int count
	int targetIndex = -1
	int containingQ
	int targetObject
	while Q < 2 && targetIndex == -1
		count = jArray.count(WC.aiTargetQ[Q])
		while i < count && targetIndex == -1
			targetObject = jArray.getObj(WC.aiTargetQ[Q], i)
			if jMap.getInt(targetObject, "iEquipType") == 22 && iEquip_SpellExt.IsHealingSpell(jMap.getForm(targetObject, "iEquipForm") as spell) && GetNthEffectMagicEffect((jMap.getForm(targetObject, "iEquipForm") as spell).GetCostliestEffectIndex()).GetDeliveryType() == 0  ; Make sure it's a Self delivery type healing spell
				targetIndex = i
				containingQ = Q
			endIf
			i += 1
		endwhile
		i = 0
		Q += 1
	endWhile
	;debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - spell found at targetIndex: " + targetIndex + " in containingQ: " + containingQ + ", iQuickHealEquipChoice: " + iQuickHealEquipChoice)
	if targetIndex != -1
		int iEquipSlot = iQuickHealEquipChoice
		bool equippingOtherHand
		if iEquipSlot < 2 && iEquipSlot != containingQ
			equippingOtherHand = true
		elseIf iEquipSlot == 3 ;Equip spell where it is found
			iEquipSlot = containingQ
		endIf
		;debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - iEquipSlot: " + iEquipSlot + ", bQuickHealSwitchBackEnabled: " + bQuickHealSwitchBackEnabled)
		if bQuickHealSwitchBackEnabled
			saveCurrentItemsForSwitchBack()
			bCurrentlyQuickHealing = true
			;debug.trace("iEquip_ProMode quickHealFindAndEquipSpell - current queue positions stored for switch back, iPreviousLeftHandIndex: " + iPreviousLeftHandIndex + ", iPreviousRightHandIndex: " + iPreviousRightHandIndex)
		endIf
		iQuickSlotsEquipped = iEquipSlot
		if iEquipSlot < 2
			quickHealEquipSpell(iEquipSlot, containingQ, targetIndex, equippingOtherHand)
		else
			quickHealEquipSpell(1, containingQ, targetIndex, containingQ == 0, true)
			quickHealEquipSpell(0, containingQ, targetIndex, containingQ == 1)
		endIf
		bCurrentlyQuickRanged = false
		bQuickHealActionTaken = true
	endIf
	;debug.trace("iEquip_ProMode quickHealFindAndEquipSpell end")
endFunction

function quickHealEquipSpell(int iEquipSlot, int Q, int iIndex, bool equippingOtherHand = false, bool dualCasting = false)
	;debug.trace("iEquip_ProMode quickHealEquipSpell start - equipping healing spell to iEquipSlot: " + iEquipSlot + ", spell found in Q " + Q + " at index " + iIndex)

	if AM.bAmmoMode
		bCurrentlyQuickRanged = false
		AM.toggleAmmoMode((!bPreselectMode || !abPreselectSlotEnabled[0]), !(iEquipSlot == 1 && !dualCasting)) 	; If we're toggling out of ammo mode only equip left if we're equipping the healing spell in only the right hand
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
	
	WC.hidePoisonInfo(iEquipSlot)
	WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
	WC.setCounterVisibility(iEquipSlot, false)
	WC.checkAndFadeLeftIcon(1, 22)
	
	int spellObject = jArray.getObj(WC.aiTargetQ[Q], iIndex)
	string spellName = jMap.getStr(spellObject, "iEquipName")

	if !equippingOtherHand
		WC.aiCurrentQueuePosition[iEquipSlot] = iIndex
		WC.asCurrentlyEquipped[iEquipSlot] = spellName
		;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
		WC.updateWidget(iEquipSlot, iIndex, true)
		;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
		if bPreselectMode && (WC.aiCurrentlyPreselected[iEquipSlot] == iIndex)
			cyclePreselectSlot(iEquipSlot, jArray.count(WC.aiTargetQ[iEquipSlot]), false)
		endIf
		WC.checkAndEquipShownHandItem(iEquipSlot, false)
	else
		WC.EH.bJustQuickDualCast = true
		WC.bBlockSwitchBackToBoundSpell = true
		int foundIndex = WC.findInQueue(iEquipSlot, spellName)
		PlayerRef.EquipSpell(jMap.getForm(spellObject, "iEquipForm") as Spell, iEquipSlot)
		int nameElement = 25 ;rightName_mc
		int iconElement = 24 ;rightIcon_mc
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
		WC.hidePoisonInfo(iEquipSlot, true)
		WC.CM.updateChargeMeterVisibility(iEquipSlot, false)
		WC.setCounterVisibility(iEquipSlot, false)
		if foundIndex > -1
			WC.aiCurrentQueuePosition[iEquipSlot] = foundIndex
			WC.asCurrentlyEquipped[iEquipSlot] = spellName
		endIf
		WC.bBlockSwitchBackToBoundSpell = false
	endIf
	;debug.trace("iEquip_ProMode quickHealEquipSpell end")
endFunction

int iPreviousLeftHandIndex
int iPreviousRightHandIndex
form fPreviousLeftHandForm
form fPreviousRightHandForm
int iPreviousRHType
bool bPreviously2H
bool bPreviouslyUnarmed

function saveCurrentItemsForSwitchBack()
	;debug.trace("iEquip_ProMode saveCurrentItemsForSwitchBack start")
	
	fPreviousLeftHandForm = PlayerRef.GetEquippedObject(0)
	if fPreviousLeftHandForm && (fPreviousLeftHandForm == jMap.getForm(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipForm"))
		iPreviousLeftHandIndex = WC.aiCurrentQueuePosition[0]
	else
		iPreviousLeftHandIndex = -1
	endIf

	fPreviousRightHandForm = PlayerRef.GetEquippedObject(1)
	if fPreviousRightHandForm && (fPreviousRightHandForm == jMap.getForm(jArray.getObj(WC.aiTargetQ[1], WC.aiCurrentQueuePosition[1]), "iEquipForm"))
		iPreviousRightHandIndex = WC.aiCurrentQueuePosition[1]
	else
		iPreviousRightHandIndex = -1
	endIf

	if fPreviousRightHandForm
		iPreviousRHType = fPreviousRightHandForm.GetType()
		if fPreviousRightHandForm as weapon
			iPreviousRHType = (fPreviousRightHandForm as weapon).GetWeaponType()
		endIf
		bPreviously2H = (WC.ai2HWeaponTypes.Find(iPreviousRHType) > -1 && !(iPreviousRHType < 7 && WC.bIsCGOLoaded)) || (iPreviousRHType == 22 && (fPreviousRightHandForm as spell).GetEquipType() == WC.EquipSlots[3])
	else
		bPreviously2H = false
	endIf

	bPreviouslyUnarmed = (fPreviousRightHandForm == none && fPreviousLeftHandForm == none) || (fPreviousRightHandForm == EH.Unarmed)
	;;debug.trace("iEquip_ProMode saveCurrentItemsForSwitchBack - iPreviousLeftHandIndex: " + iPreviousLeftHandIndex + ", fPreviousLeftHandForm: " + fPreviousLeftHandForm.GetName())
	;;debug.trace("iEquip_ProMode saveCurrentItemsForSwitchBack - iPreviousRightHandIndex: " + iPreviousRightHandIndex + ", fPreviousRightHandForm: " + fPreviousRightHandForm.GetName() + ", bPreviouslyUnarmed: " + bPreviouslyUnarmed)
	;debug.trace("iEquip_ProMode saveCurrentItemsForSwitchBack end")
endFunction

function quickSwitchBack(bool bQuickHealing, bool bPlayerIsInCombat)
	;debug.trace("iEquip_ProMode quickSwitchBack start")
	;debug.trace("iEquip_ProMode quickSwitchBack - iPreviousLeftHandIndex: " + iPreviousLeftHandIndex + ", fPreviousLeftHandForm: " + fPreviousLeftHandForm.GetName())
	;debug.trace("iEquip_ProMode quickSwitchBack - iPreviousRightHandIndex: " + iPreviousRightHandIndex + ", fPreviousRightHandForm: " + fPreviousRightHandForm.GetName() + ", bPreviouslyUnarmed: " + bPreviouslyUnarmed + ", bPreviously2H: " + bPreviously2H)
	bCurrentlyQuickHealing = false

	if iPreviousLeftHandIndex != -1
		WC.aiCurrentQueuePosition[0] = iPreviousLeftHandIndex
		WC.asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(WC.aiTargetQ[0], iPreviousLeftHandIndex), "iEquipName")
	endIf

	if iPreviousRightHandIndex != -1
		WC.aiCurrentQueuePosition[1] = iPreviousRightHandIndex
		WC.asCurrentlyEquipped[1] = jMap.getStr(jArray.getObj(WC.aiTargetQ[1], iPreviousRightHandIndex), "iEquipName")
	endIf
	
	int Q = iQuickSlotsEquipped
	
	if bPreviously2H
		Q = 2
	endIf
	
	if bPreviouslyUnarmed
		if iPreviousRightHandIndex != -1 && WC.asCurrentlyEquipped[1] == "$iEquip_common_Unarmed"
			WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
		endIf
		WC.goUnarmed()
	elseIf Q < 2
		if (Q == 0 && iPreviousLeftHandIndex != -1) || (Q == 1 && iPreviousRightHandIndex != -1)
			WC.updateWidget(Q, WC.aiCurrentQueuePosition[Q], true) ; True overrides bPreselectMode to make sure we're updating the main slot if we're in Preselect
			WC.checkAndEquipShownHandItem(Q)
		else
			form previousItemForm
			if Q == 0
				previousItemForm = fPreviousLeftHandForm
			else
				previousItemForm = fPreviousRightHandForm
			endIf

			if previousItemForm == none
				WC.UnequipHand(Q)
			elseIf previousItemForm as spell
				PlayerRef.EquipSpell(previousItemForm as Spell, aiHandEquipSlots.Find(Q))
			else
				PlayerRef.EquipItemEx(previousItemForm, aiHandEquipSlots.Find(Q))
			endIf
		endIf
	elseIf Q == 2
		if iPreviousLeftHandIndex != -1
			WC.updateWidget(0, WC.aiCurrentQueuePosition[0], true)
			if !bPreviously2H
				WC.checkAndEquipShownHandItem(0)
			elseIf iPreviousRHType == 7 || iPreviousRHType == 9
				Utility.WaitMenuMode(0.4)
			endIf
		elseIf !bPreviously2H
			if fPreviousLeftHandForm == none
				WC.UnequipHand(0)
			elseIf fPreviousLeftHandForm as spell
				PlayerRef.EquipSpell(fPreviousLeftHandForm as Spell, 0)
			else
				PlayerRef.EquipItemEx(fPreviousLeftHandForm, 2)
			endIf
		endIf
		if iPreviousRightHandIndex != -1
			WC.updateWidget(1, WC.aiCurrentQueuePosition[1], true)
			WC.checkAndEquipShownHandItem(1)
		else
			if fPreviousRightHandForm == none
				WC.UnequipHand(1)
			elseIf fPreviousRightHandForm as spell
				PlayerRef.EquipSpell(fPreviousRightHandForm as Spell, 1)
			else
				PlayerRef.EquipItemEx(fPreviousRightHandForm, 1)
			endIf
		endIf
	else
		;debug.trace("iEquip_ProMode quickHealSwitchBack - Something went wrong!")
	endIf
	if bQuickHealing && bQuickHealSwitchBackAndRestore && bPlayerIsInCombat
		PO.selectAndConsumePotion(1, 0) ;Magicka potions
	endIf
	iQuickSlotsEquipped = -1 ;Reset
	;debug.trace("iEquip_ProMode quickSwitchBack end")
endFunction

bool function scanInventoryForItemOfType(int itemType, bool bFindStaff = false, int Q = -1, bool equippingOtherHand = false)
	;debug.trace("iEquip_ProMode scanInventoryAndAddItemOfType start - item type to find: " + itemType)
	; Possible itemType inputs are 26 - Armor (for shields) or 41 - Weapons (for ranged weapons)
	int numFound = GetNumItemsOfType(PlayerRef, itemType)
	int i
	bool found
	form formToCheck
	while i < numFound && !found
		formToCheck = GetNthFormOfType(PlayerRef, itemType, i)
		if (itemType == 26 && (formToCheck as armor).IsShield()) || (bFindStaff && (formToCheck as weapon).GetWeaponType() == 8 && iEquip_FormExt.IsThrowingKnife(formToCheck) && !((equippingOtherHand && PlayerRef.GetEquippedObject((Q + 1) % 2)) == formToCheck && PlayerRef.GetItemCount(formToCheck) == 1)) || (!bFindStaff && (itemType == 41 && (((formToCheck as weapon).GetWeaponType() == 7 && jArray.count(AM.aiTargetQ[0]) > 0) || ((formToCheck as weapon).GetWeaponType() == 9 && jArray.count(AM.aiTargetQ[1]) > 0))))
			found = true
		else
			i += 1
		endIf
	endWhile

	if itemType == 26 	; Shields to left hand queue
		Q = 0
	elseIf Q == -1 		; Q will only be -1 if we're looking for a ranged weapon so put into right hand queue
		Q = 1
	endIf

	if found
		addNonEquippedItemToQueue(Q, formToCheck, itemType)
	endIf

	;debug.trace("iEquip_ProMode scanInventoryAndAddItemOfType end - returning:" + found)
	return found
endFunction

; Used to add items found by inventory scanning to queue, only if we are adding it to show in a preselect slot without equipping it
function addNonEquippedItemToQueue(int Q, form formToAdd, int itemType = -1)
	;debug.trace("iEquip_ProMode addNonEquippedItemToQueue start - Q: " + Q + ", formToAdd: " + formToAdd + ", itemType: " + itemType)
	if itemType == -1
		itemType = formToAdd.GetType()
	endIf

	if itemType == 41
		itemType = (formToAdd as weapon).GetWeaponType()
	endIf
	
	string itemName = formToAdd.GetName()
	string itemIcon = WC.GetItemIconName(formToAdd, itemType, itemName)

	int iEquipItem = jMap.object()

	jMap.setForm(iEquipItem, "iEquipForm", formToAdd)
	jMap.setInt(iEquipItem, "iEquipType", itemType)
	jMap.setStr(iEquipItem, "iEquipName", itemName)
	jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)

	if itemType == 22
		jMap.setStr(iEquipItem, "iEquipSchool", WC.getSpellSchool(formToAdd as spell))
	else
		jMap.setStr(iEquipItem, "iEquipBaseName", itemName)
		jMap.setInt(iEquipItem, "iEquipautoAdded", 1)
		jMap.setStr(iEquipItem, "iEquipBaseIcon", itemIcon)
		jMap.setStr(iEquipItem, "lastDisplayedName", itemName)
		jMap.setInt(iEquipItem, "lastKnownItemHealth", 100)
		jMap.setInt(iEquipItem, "isEnchanted", 0)
		jMap.setInt(iEquipItem, "isPoisoned", 0)
	endIf
	
	jArray.addObj(WC.aiTargetQ[Q], iEquipItem)

	EH.iEquip_AllCurrentItemsFLST.AddForm(formToAdd)
	EH.updateEventFilter(EH.iEquip_AllCurrentItemsFLST)
	WC.abQueueWasEmpty[Q] = false
	;debug.trace("iEquip_ProMode addNonEquippedItemToQueue end")
endFunction

; Deprecated in v1.2
function quickHealSwitchBack(bool bPlayerIsInCombat)
endFunction

bool property bQuickShieldPreferMagic auto hidden
