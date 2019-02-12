Scriptname iEquip_BeastMode extends Quest

import UI
import UICallback
import Utility
import iEquip_StringExt

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_AmmoMode property AM auto
iEquip_ChargeMeters property CM auto
iEquip_KeyHandler property KH auto
iEquip_PlayerEventHandler property EH auto
iEquip_LeftHandEquipUpdateScript property LHUpdate auto
iEquip_RightHandEquipUpdateScript property RHUpdate auto

actor property PlayerRef auto

; Werewolf reference - Vanilla - populated in CK
race property WerewolfBeastRace auto

race[] property arBeastRaces auto hidden

formlist property iEquip_BeastModeItemsFLST auto

int property currRace auto hidden
int[] aiBMQueues

int[] aiCurrentBMQueuePosition
string[] asCurrentlyEquipped

bool b2HSpellEquipped

bool bConsumableSlotEnabled
bool bPoisonSlotEnabled
bool bShoutSlotEnabled
bool bProModeEnabled
bool bPreselectEnabled

bool[] property abShowInTransformedState auto hidden

String HUD_MENU = "HUD Menu"
String WidgetRoot

event OnInit()
	debug.trace("iEquip_BeastMode OnInit start")
	
	arBeastRaces = new race[3]
	arBeastRaces[0] = WerewolfBeastRace

	aiBMQueues = new int[9]
	aiCurrentBMQueuePosition = new int[9]
	asCurrentlyEquipped = new string[9]
	abShowInTransformedState = new bool[3]

	int i
	while i < 9
		if i < 3
			abShowInTransformedState[i] = true
		endIf
		aiCurrentBMQueuePosition[i] = -1
		i += 1
	endWhile

	debug.trace("iEquip_BeastMode OnInit end")
endEvent

function initialise()
	debug.trace("iEquip_BeastMode initialise start")
	WidgetRoot = WC.WidgetRoot
	initialiseQueueArrays()
	debug.trace("iEquip_BeastMode initialise end")
endFunction

function initialiseQueueArrays()
    debug.trace("iEquip_BeastMode initialiseQueueArrays start")
    if aiBMQueues[0] == 0
        aiBMQueues[0] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "werewolfLeftQ", aiBMQueues[0])
    endIf
    if aiBMQueues[1] == 0
        aiBMQueues[1] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "werewolfRightQ", aiBMQueues[1])
    endIf
    if aiBMQueues[2] == 0
        aiBMQueues[2] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "werewolfPowerQ", aiBMQueues[2])
    endIf
    if aiBMQueues[3] == 0
        aiBMQueues[3] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "vampireLordLeftQ", aiBMQueues[3])
    endIf
    if aiBMQueues[4] == 0
        aiBMQueues[4] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "vampireLordRightQ", aiBMQueues[4])
    endIf
    if aiBMQueues[5] == 0
        aiBMQueues[5] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "vampireLordPowerQ", aiBMQueues[5])
    endIf
    if aiBMQueues[6] == 0
        aiBMQueues[6] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "lichLeftQ", aiBMQueues[6])
    endIf
    if aiBMQueues[7] == 0
        aiBMQueues[7] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "lichRightQ", aiBMQueues[7])
    endIf
    if aiBMQueues[8] == 0
        aiBMQueues[8] = JArray.object()
        JMap.setObj(WC.iEquipQHolderObj, "lichPowerQ", aiBMQueues[8])
    endIf
    debug.trace("iEquip_BeastMode initialiseQueueArrays end")
endfunction

function onPlayerTransform(race newRace)
	debug.trace("iEquip_BeastMode onPlayerTransform start")
	KH.bAllowKeyPress = false
	EH.bWaitingForTransform = true
	WC.updateWidgetVisibility(false)
	currRace = arBeastRaces.Find(newRace)
	if currRace == -1
		;Player is no longer one of the supported beast races so we assume they have transformed back
		resetWidgetOnTransformBack()
		WC.updateWidgetVisibility()
		;Any MCM changes not relevant to beast mode will still be pending so run them now
		WC.ApplyChanges()
		KH.bAllowKeyPress = true
	else
		;Store pre-transformation states
		bConsumableSlotEnabled = WC.bConsumablesEnabled
		bPoisonSlotEnabled = WC.bPoisonsEnabled
		bShoutSlotEnabled = WC.bShoutEnabled
		bProModeEnabled = WC.bProModeEnabled
		bPreselectEnabled = WC.bPreselectMode
		;Toggle out of Preselect Mode if active
		if WC.bPreselectMode
			PM.togglePreselectMode()
		endIf
		;Next toggle out of Ammo Mode to hide the left Preselect slot
		if AM.bAmmoMode
			AM.toggleAmmoMode(false, true)
		endIf
		;Now hide the consumable and poison slots and show the shout slot if previously hidden
		WC.bConsumablesEnabled = false
		WC.bPoisonsEnabled = false
		WC.bShoutEnabled = true
		WC.updateSlotsEnabled()
		int i
		int queueLength
		while i < 3
			;Check the current queue items for the current beast race and remove any the player no longer has (should handle spell/power changes on level progression)
			int targetQ = aiBMQueues[(currRace * 3) + i]
			queueLength = jArray.count(targetQ)
			if queueLength > 0
				int j
				form targetForm
				while j < queueLength
					targetForm = jMap.getForm(jArray.getObj(targetQ, j), "iEquipForm")
					if !WC.playerStillHasItem(targetForm)
						iEquip_BeastModeItemsFLST.RemoveAddedForm(targetForm)
						jArray.eraseIndex(targetQ, j)
					else
						j += 1
					endIf
				endWhile
			endIf
			;Hide the attribute, poison, count and charge info
			if i < 2
				WC.hideAttributeIcons(i)
				WC.setCounterVisibility(i, false)
				WC.hidePoisonInfo(i)
				if CM.abIsChargeMeterShown[i]
					CM.updateChargeMeterVisibility(i, false)
				endIf
			endIf
			;Reset beast mode queue position ready to allow processQueuedForms to update the widget
			aiCurrentBMQueuePosition[(currRace * 3) + i] = -1
			asCurrentlyEquipped[(currRace * 3) + i] = ""
			if WC.bNameFadeoutEnabled && !WC.abIsNameShown[i]
				WC.showName(i)
			endIf
			i += 1
		endWhile
		;If we're a werewolf then show claws in both hand slots
		if currRace == 0
			showClaws()
		endIf
		;Release the queued forms to update the widget
		EH.processQueuedForms()
		;And finally if vis is enabled for this beast form show the widget and unlock controls
		if abShowInTransformedState[currRace]
			WC.updateWidgetVisibility()
			KH.bAllowKeyPress = true
		endIf
	endIf
	EH.bWaitingForTransform = false
	debug.trace("iEquip_BeastMode onPlayerTransform end")
endFunction

function updateWidgetVisOnSettingsChanged()
	debug.trace("iEquip_BeastMode updateWidgetVisOnSettingsChanged end")
	if WC.bIsWidgetShown
		if !abShowInTransformedState[currRace]
			WC.updateWidgetVisibility(false)
			KH.bAllowKeyPress = false
		endIf
	elseIf abShowInTransformedState[currRace]
		WC.updateWidgetVisibility()
		KH.bAllowKeyPress = true
	endIf
	debug.trace("iEquip_BeastMode updateWidgetVisOnSettingsChanged end")
endFunction

function resetWidgetOnTransformBack()
	debug.trace("iEquip_BeastMode resetWidgetOnTransformBack start")
	;Return the consumable, poison and shout slots to their previous state
	WC.bConsumablesEnabled = bConsumableSlotEnabled
	WC.bPoisonsEnabled = bPoisonSlotEnabled
	WC.bShoutEnabled = bShoutSlotEnabled
	WC.updateSlotsEnabled()
	;ReEquip the shout/power that was equipped before the transformation and update the widget as it isn't re-equipped during the transformation
	WC.cycleShout(2, WC.aiCurrentQueuePosition[2], jMap.getForm(jArray.getObj(WC.aiTargetQ[2], WC.aiCurrentQueuePosition[2]), "iEquipForm"))
	WC.updateWidget(2, WC.aiCurrentQueuePosition[2])
	;If we were previously unarmed then return the widget to that state
	if WC.bGoneUnarmed
		int i
		while i < 2
			float fNameAlpha = afWidget_A[aiNameElements[i]]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			If(iHandle)
				UICallback.PushInt(iHandle, i)
				UICallback.PushString(iHandle, "Fist")
				UICallback.PushString(iHandle, "$iEquip_common_Unarmed")
				UICallback.PushFloat(iHandle, fNameAlpha)
				UICallback.Send(iHandle)
			endIf
			i += 1
		endWhile
	;Otherwise reset the widget and queue positions accordingly and allow processQueuedForms to the widget fully as items are re-equipped
	else
		;First, reset left slot to show previous left item in case we are re-equipping a ranged or 2H weapon ready for Ammo Mode or left icon fade
		WC.updateWidget(0, WC.aiCurrentQueuePosition[0])
		;Next reset the left (if last equipped item wasn't a shield as it hasn't been unequipped) and right queues to force processQueuedForms to run in full
		if jMap.getInt(jArray.getObj(WC.aiTargetQ[0], WC.aiCurrentQueuePosition[0]), "iEquipType") != 26
			WC.aiCurrentQueuePosition[0] = -1
			WC.asCurrentlyEquipped[0] = ""
		endIf
		WC.aiCurrentQueuePosition[1] = -1
		WC.asCurrentlyEquipped[1] = ""
	;Now release the queued forms which should then fully update the widget, handling left icon fade if 2H or Ammo Mode if ranged, along with poison/count/charge info
	EH.processQueuedForms()
	;And finally toggle back into Preselect if it was active before transformation
	if bPreselectEnabled
		PM.togglePreselectMode()
	endIf
	debug.trace("iEquip_BeastMode resetWidgetOnTransformBack end")
endFunction

function updateSlotOnObjectEquipped(int equippedSlot, form queuedForm, int itemType, int iEquipSlot)
	debug.trace("iEquip_BeastMode updateSlotOnObjectEquipped start")
	debug.trace("iEquip_BeastMode updateSlotOnObjectEquipped - equippedSlot: " + equippedSlot)
	int targetQ = (currRace * 3) + equippedSlot
	bool blockCall
	bool actionTaken
	int targetIndex
	bool formFound = iEquip_BeastModeItemsFLST.HasForm(queuedForm)
	string itemName = queuedForm.GetName()
	;Check if we've just manually equipped an item that is already in an iEquip queue
	if formFound
		;If it's been found in the queue for the equippedSlot it's been equipped to
		targetIndex = findInQueue(aiBMQueues[targetQ], itemName)
		if targetIndex != -1
			;If it's already shown in the widget do nothing
			if aiCurrentBMQueuePosition[targetQ] != targetIndex
				aiCurrentBMQueuePosition[targetQ] = targetIndex
				asCurrentlyEquipped[targetQ] = itemName
				WC.updateWidgetBM(equippedSlot, jMap.getStr(jArray.getObj(aiBMQueues[targetQ], targetIndex), "iEquipIcon"), itemName)
			else
				blockCall = true
			endIf
			actionTaken = true
		endIf
	endIf
	debug.trace("iEquip_BeastMode updateSlotOnObjectEquipped - equippedSlot: " + equippedSlot + ", formFound: " + formFound + ", targetIndex: " + targetIndex)
	;If it isn't already contained in the BeastModeItems formlist, or it is but findInQueue has returned -1 meaning it is already contained in the other hand queue
	if !actionTaken
		int iEquipItem = jMap.object()
		string itemIcon = WC.GetItemIconName(queuedForm, itemType, itemName)
		jMap.setForm(iEquipItem, "iEquipForm", queuedForm)
		jMap.setInt(iEquipItem, "iEquipType", itemType)
		jMap.setStr(iEquipItem, "iEquipName", itemName)
		jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
		if equippedSlot < 2 && itemType == 22
			jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
		endIf
		jArray.addObj(aiBMQueues[targetQ], iEquipItem)
		;If it's not already in the BeastModeItems formlist add it now
		if !formFound
			iEquip_BeastModeItemsFLST.AddForm(queuedForm)
		endIf
		targetIndex = jArray.count(aiBMQueues[targetQ]) - 1
		;Now update the widget to show the equipped item
		aiCurrentBMQueuePosition[targetQ] = targetIndex
		asCurrentlyEquipped[targetQ] = itemName
		WC.updateWidgetBM(equippedSlot, jMap.getStr(jArray.getObj(aiBMQueues[targetQ], targetIndex), "iEquipIcon"), itemName)
	endIf
	if !blockCall && equippedSlot < 2
		checkAndEquipShownHandItem(equippedSlot, true)
	endIf
	debug.trace("iEquip_BeastMode updateSlotOnObjectEquipped end")
endFunction

int function findInQueue(int Q, string itemToFind)
	debug.trace("iEquip_BeastMode findInQueue start")
	int i
	bool found
	while i < jArray.count(Q) && !found
		if itemToFind != jMap.getStr(jArray.getObj(Q, i), "iEquipName")
			i += 1
		else
			found = true
		endIf
	endwhile
	debug.trace("iEquip_BeastMode findInQueue end")
	if found
		return i
	else
		return -1
	endIf
endFunction

function cycleSlot(int Q, bool Reverse = false)
	;Q: 0 = Left hand, 1 = Right hand, 2 = Shout
	int targetQ = (currRace * 3) + Q
	int targetArray = aiBMQueues[targetQ]
	int queueLength = JArray.count(targetArray)
	debug.trace("iEquip_WidgetCore cycleSlot - queueLength: " + queueLength)
	if WC.bFirstPressShowsName && !WC.abIsNameShown[Q]
		WC.showName(Q)

	elseIf queueLength > 1
		int	targetIndex
		form targetItem
	    string targetName
		
		;Make sure we're starting from the correct index, in case somehow the queue has been amended without the aiCurrentBMQueuePosition array being updated
		if asCurrentlyEquipped[targetQ] != ""
			aiCurrentBMQueuePosition[targetQ] = findInQueue(targetArray, asCurrentlyEquipped[targetQ])
		endIf
		
		if queueLength > 1
			;Check if we're moving forwards or backwards in the queue
			int move = 1
			if Reverse
				move = -1
			endIf
			;Set the initial target index
			targetIndex = aiCurrentBMQueuePosition[targetQ] + move
			;Check if we're cycling past the first or last items in the queue and jump to the start/end as required
			if targetIndex < 0 && Reverse
				targetIndex = queueLength - 1
			elseif targetIndex == queueLength && !Reverse
				targetIndex = 0
			endIf
	    	targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
	    	targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "iEquipForm")
		else
			targetIndex = 0
		endIf
		;Update the widget to the next queued item immediately then register for bEquipOnPause update or call cycle functions straight away
		aiCurrentBMQueuePosition[targetQ] = targetIndex
		asCurrentlyEquipped[targetQ] = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
		WC.updateWidgetBM(Q, jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipIcon"), targetName)
		
		if Q < 2
			;if bEquipOnPause is enabled then use the bEquipOnPause updates
			if WC.bEquipOnPause
				if Q == 0
					LHUpdate.registerForEquipOnPauseUpdate(Reverse, false, true)
				elseif Q == 1
					RHUpdate.registerForEquipOnPauseUpdate(Reverse, true)
				endIf
			;Otherwise carry on and equip/cycle
			else
				checkAndEquipShownHandItem(Q, false)
			endIf
		else
			checkAndEquipShownPower(targetQ)
		endIf
		debug.trace("iEquip_BeastMode cycleSlot end")
	endIf
endFunction

function checkAndEquipShownHandItem(int hand, bool equippingOnAutoAdd = false)
	debug.trace("iEquip_BeastMode checkAndEquipShownHandItem start")
	int Q = (currRace * 3) + hand
   	int targetObject = jArray.getObj(aiBMQueues[Q], aiCurrentBMQueuePosition[Q])
    int itemType = jMap.getInt(targetObject, "iEquipType")
    form targetItem = jMap.getForm(targetObject, "iEquipForm")
    debug.trace("iEquip_BeastMode checkAndEquipShownHandItem - Q: " + Q + ", targetIndex: " + aiCurrentBMQueuePosition[Q] + ", targetItem: " + targetItem + ", itemType: " + itemType + ", equippingOnAutoAdd: " + equippingOnAutoAdd)
    ;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
   	int iEquipSlotId = 1
   	int otherHand = (hand + 1) % 2
   	if hand == 0
    	iEquipSlotId = 2
    endIf
	;if we're switching the left hand and it is going to cause a 2h or ranged weapon to be unequipped from the right hand then we need to ensure a suitable 1h item is equipped in its place
    bool previously2HSpell
    if b2HSpellEquipped
    	previously2HSpell = true
    endif
    ;In case we are re-equipping from a 2H spell state
	b2HSpellEquipped = false
	if !equippingOnAutoAdd
		WC.UnequipHand(hand)
		;if target item is a spell equip straight away
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, hand)
			if jMap.getInt(targetObject, "iEquipSlot") == 3 ; 2H spells
				updateOtherHandOn2HSpellEquipped(Q, hand, otherHand)
			endIf
		else
		    ;Equip target item
		    debug.trace("iEquip_BeastMode checkAndEquipShownHandItem - about to equip " + jMap.getStr(targetObject, "iEquipName") + " into slot " + hand)
		    Utility.WaitMenuMode(0.1)
	    	int itemID = jMap.getInt(targetObject, "iEquipItemID")
	    	if itemID as bool
	    		PlayerRef.EquipItemByID(targetItem, itemID, iEquipSlotID)
	    	else
	    		PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
	    	endIf
		endIf
		Utility.WaitMenuMode(0.2)
	;If we've just directly equipped and are auto adding a 2H spell now we need to show it in the left slot as well, which will also sit b2HSpellEquipped to true blocking cycleHand(0) below
	elseIf itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3
		updateOtherHandOn2HSpellEquipped(Q, hand, otherHand)
	endIf

	if previously2HSpell
		Utility.WaitMenuMode(0.1)
		reequipOtherHand(otherHand)
	endIf
	
	debug.trace("iEquip_BeastMode checkAndEquipShownHandItem end")
endFunction

function updateOtherHandOn2HSpellEquipped(int Q, int hand, int otherHand)
	debug.trace("iEquip_BeastMode updateOtherHandOn2HSpellEquipped start")
	;And now we need to update the left hand widget
	float fNameAlpha = WC.afWidget_A[WC.aiNameElements[0]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, otherHand)
		UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiBMQueues[Q], aiCurrentBMQueuePosition[hand]), "iEquipIcon")) ;Show the same icon and name in the left hand as already showing in the right
		UICallback.PushString(iHandle, asCurrentlyEquipped[Q])
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	if WC.bNameFadeoutEnabled
		WC.LNUpdate.registerForNameFadeoutUpdate()
	endIf
	b2HSpellEquipped = true
	debug.trace("iEquip_BeastMode updateOtherHandOn2HSpellEquipped end")
endFunction

function showClaws()
	debug.trace("iEquip_BeastMode showClaws start")
	int i
	float fNameAlpha
	int iHandle
	while i < 2
		fNameAlpha = WC.afWidget_A[WC.aiNameElements[i]]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		If(iHandle)
			debug.trace("iEquip_BeastMode showClaws - got iHandle, i: " + i)
			UICallback.PushInt(iHandle, i)
			UICallback.PushString(iHandle, "Claws")
			UICallback.PushString(iHandle, "$iEquip_common_Claws")
			UICallback.PushFloat(iHandle, fNameAlpha)
			UICallback.Send(iHandle)
		endIf
		;aiCurrentBMQueuePosition[(currRace * 3) + i] = -1
		;asCurrentlyEquipped[(currRace * 3) + i] = ""
		i += 1
	endWhile
	debug.trace("iEquip_BeastMode showClaws end")
endFunction

function showPreviousItems()
	debug.trace("iEquip_BeastMode showPreviousItems start")
	int i
	float fNameAlpha
	int iHandle
	int Q
	while i < 2
		Q = (currRace * 3) + i
		fNameAlpha = WC.afWidget_A[WC.aiNameElements[i]]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		If(iHandle)
			debug.trace("iEquip_BeastMode showClaws - got iHandle, i: " + i)
			UICallback.PushInt(iHandle, i)
			UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiBMQueues[Q], aiCurrentBMQueuePosition[Q]), "iEquipIcon"))
			UICallback.PushString(iHandle, asCurrentlyEquipped[Q])
			UICallback.PushFloat(iHandle, fNameAlpha)
			UICallback.Send(iHandle)
		endIf
		;aiCurrentBMQueuePosition[(currRace * 3) + i] = -1
		;asCurrentlyEquipped[(currRace * 3) + i] = ""
		i += 1
	endWhile
	debug.trace("iEquip_BeastMode showPreviousItems end")
endFunction

function reequipOtherHand(int otherHand)
	debug.trace("iEquip_BeastMode reequipOtherHand start")
	int Q = (currRace * 3) + otherHand
	int targetObject = jArray.getObj(aiBMQueues[Q], aiCurrentBMQueuePosition[Q])
	float fNameAlpha = WC.afWidget_A[WC.aiNameElements[otherHand]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, otherHand)
		UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipIcon"))
		UICallback.PushString(iHandle, asCurrentlyEquipped[Q])
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	;cycleHand(Q, aiCurrentQueuePosition[Q], jMap.getForm(targetObject, "iEquipForm"), jMap.getInt(targetObject, "iEquipType"))
	debug.trace("iEquip_BeastMode reequipOtherHand end")
endFunction

function checkAndEquipShownPower(int Q)
    debug.trace("iEquip_BeastMode checkAndEquipShownPower start")
    int targetObject = jArray.getObj(aiBMQueues[Q], aiCurrentBMQueuePosition[Q])
    int itemType = jMap.getInt(targetObject, "iEquipType")
    form targetItem = jMap.getForm(targetObject, "iEquipForm")
    if itemType == 22
        PlayerRef.EquipSpell(targetItem as Spell, 2)
    else
        PlayerRef.EquipShout(targetItem as Shout)
    endIf
    debug.trace("iEquip_BeastMode checkAndEquipShownPower end")
endFunction