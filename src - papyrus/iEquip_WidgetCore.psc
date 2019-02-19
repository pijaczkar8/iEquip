
Scriptname iEquip_WidgetCore extends SKI_WidgetBase

import Input
import Form
import UI
import UICallback
import Utility
import iEquip_UILIB
import _Q2C_Functions
import AhzMoreHudIE
import WornObject
import iEquip_FormExt
import iEquip_StringExt
import iEquip_SpellExt

;Script Properties
iEquip_ChargeMeters property CM auto
iEquip_EditMode property EM auto
iEquip_KeyHandler property KH auto
iEquip_RechargeScript Property RC Auto
iEquip_AmmoMode property AM auto
iEquip_ProMode property PM auto
iEquip_BeastMode property BM auto
iEquip_PotionScript property PO auto
iEquip_PlayerEventHandler property EH auto
iEquip_BoundWeaponEventsListener Property BW Auto
iEquip_AddedItemHandler property AD auto
iEquip_MCM property MCM auto
iEquip_WidgetVisUpdateScript property WVis auto
iEquip_LeftHandEquipUpdateScript property LHUpdate auto
iEquip_RightHandEquipUpdateScript property RHUpdate auto
iEquip_LeftNameUpdateScript property LNUpdate auto
iEquip_LeftPoisonNameUpdateScript property LPoisonNUpdate auto
iEquip_LeftPreselectNameUpdateScript property LPNUpdate auto
iEquip_RightNameUpdateScript property RNUpdate auto
iEquip_RightPoisonNameUpdateScript property RPoisonNUpdate auto
iEquip_RightPreselectNameUpdateScript property RPNUpdate auto
iEquip_ShoutNameUpdateScript property SNUpdate auto
iEquip_ShoutPreselectNameUpdateScript property SPNUpdate auto
iEquip_ConsumableNameUpdateScript property CNUpdate auto
iEquip_ConsumableFadeUpdateScript property CFUpdate auto
iEquip_PoisonNameUpdateScript property PNUpdate auto
iEquip_ApplyPoisonLeftFXScript property PLFX auto
iEquip_ApplyPoisonRightFXScript property PRFX auto

;CK-filled Properties
Actor property PlayerRef auto
Armor property Shoes auto
Perk property ConcentratedPoison  auto
Sound property RemovePoison auto
Sound property iEquip_ITMPoisonUse auto
Quest property iEquip_MessageQuest auto ; populated by CK
ReferenceAlias property iEquip_MessageAlias auto ; populated by CK, but Alias is filled by script, not by CK
MiscObject property iEquip_MessageObject auto ; populated by CK
ObjectReference property iEquip_MessageObjectReference auto ; populated by script
Message property iEquip_ConfirmAddToQueue auto
Message property iEquip_OKCancel auto
Message property iEquip_QueueManagerMenu auto
Message property iEquip_UtilityMenu auto
Message property iEquip_OK auto

FormList Property iEquip_AllCurrentItemsFLST Auto
FormList Property iEquip_RemovedItemsFLST Auto

Keyword property MagicDamageFire auto
Keyword property MagicDamageFrost auto
Keyword property MagicDamageShock auto

; Arrays used by queue functions
int[] property aiCurrentQueuePosition auto hidden ;Array containing the current index for each queue
string[] property asCurrentlyEquipped auto hidden ;Array containing the itemName for whatever is currently equipped in each queue
int[] property aiCurrentlyPreselected auto hidden ;Array containing current preselect queue positions

;Widget Properties
string[] property asWidgetDescriptions auto hidden
string[] property asWidgetElements auto hidden
string[] property asWidget_TA auto hidden
string[] property asWidget_DefTA auto hidden
string[] property asWidgetGroup auto hidden
float[] property afWidget_X auto hidden
float[] property afWidget_Y auto hidden
float[] property afWidget_S auto hidden
float[] property afWidget_R auto hidden
float[] property afWidget_A auto hidden
int[] property aiWidget_D auto hidden
int[] property aiWidget_TC auto hidden
float[] property afWidget_DefX auto hidden
float[] property afWidget_DefY auto hidden
float[] property afWidget_DefS auto hidden
float[] property afWidget_DefR auto hidden
float[] property afWidget_DefA auto hidden
int[] property aiWidget_DefTC auto hidden
int[] property aiWidget_DefD auto hidden
bool[] property abWidget_V auto hidden
bool[] property abWidget_DefV auto hidden
bool[] property abWidget_isParent auto hidden
bool[] property abWidget_isText auto hidden
bool[] property abWidget_isBg auto hidden

int iConsumableCount
int iPoisonCount
int iCurrentlyUpdating

bool bEnabled
bool property bIsFirstLoad = true auto hidden
bool bIsFirstEnabled = true
bool property bAddingItemsOnFirstEnable auto hidden
bool bIsFirstInventoryMenu = true
bool bIsFirstMagicMenu = true
bool bIsFirstFailedToAdd = true
bool property bLoading auto hidden
bool property bShowTooltips = true auto hidden
bool property bShowQueueConfirmationMessages = true auto hidden
bool property bLoadedbyOnWidgetInit auto hidden
bool bRefreshingWidgetOnLoad
bool property bRefreshingWidget auto hidden

;Ammo Mode properties and variables
bool property bAmmoMode auto hidden
bool bJustLeftAmmoMode
bool bAmmoModeFirstLook = true

;Auto Unequip Ammo
bool property bUnequipAmmo = true auto hidden

;Geared Up properties and variables
bool property bEnableGearedUp auto hidden
bool bDrawn
Form boots
float property fEquipOnPauseDelay = 2.0 auto hidden

bool property bPotionGrouping = true auto hidden

bool property bProModeEnabled auto hidden
bool property bPreselectMode auto hidden
bool property bQuickDualCastEnabled auto hidden

string[] asSpellSchools
bool[] property abQuickDualCastSchoolAllowed auto hidden

bool property bRefreshQueues auto hidden
bool property bFadeOptionsChanged auto hidden
bool property bAmmoIconChanged auto hidden
bool property bAmmoSortingChanged auto hidden
bool property bGearedUpOptionChanged auto hidden
bool property bSlotEnabledOptionsChanged auto hidden

int property iMaxQueueLength = 12 auto hidden
bool property bReduceMaxQueueLengthPending auto hidden
bool property bHardLimitQueueSize = true auto hidden
bool property bHardLimitEnabledPending auto hidden
bool property bAllowWeaponSwitchHands auto hidden
bool property bAllowSingleItemsInBothQueues auto hidden
bool property bAutoAddNewItems = true auto hidden
bool property bEnableRemovedItemCaching = true auto hidden
int property iMaxCachedItems = 60 auto hidden

float property fWidgetFadeoutDelay = 20.0 auto hidden
float property fWidgetFadeoutDuration = 1.5 auto hidden
bool property bAlwaysVisibleWhenWeaponsDrawn = true auto hidden
bool property bIsWidgetShown auto hidden

float property fMainNameFadeoutDelay = 5.0 auto hidden
float property fPoisonNameFadeoutDelay = 5.0 auto hidden
float property fPreselectNameFadeoutDelay = 5.0 auto hidden
float property fNameFadeoutDuration = 1.5 auto hidden

bool property bBackgroundStyleChanged auto hidden
bool property bFadeLeftIconWhen2HEquipped = true auto hidden
float property fLeftIconFadeAmount = 70.0 auto hidden
bool property bFadeIconOnDegrade = true auto hidden
bool property bTemperFadeSettingChanged auto hidden

bool property bDropShadowEnabled = true auto hidden
bool property bDropShadowSettingChanged auto hidden

bool property bEmptyPotionQueueChoiceChanged auto hidden
bool[] property abPotionGroupAddedBack auto hidden
bool property bPotionGroupingOptionsChanged auto hidden
bool property bRestorePotionWarningSettingChanged auto hidden

bool property bAllowPoisonSwitching = true auto hidden
bool property bAllowPoisonTopUp = true auto hidden
int property iPoisonChargeMultiplier = 1 auto hidden
int property iPoisonChargesPerVial = 1 auto hidden
int property iShowPoisonMessages auto hidden
int property iPoisonIndicatorStyle = 1 auto hidden
bool property bPoisonIndicatorStyleChanged auto hidden
bool property bBeastModeOptionsChanged auto hidden

bool property bShowPositionIndicators = true auto hidden
int property iPositionIndicatorColor = 0xFFFFFF auto hidden
float property fPositionIndicatorAlpha = 0.6 auto hidden
bool property bPositionIndicatorSettingsChanged auto hidden

bool property bShowAttributeIcons = true auto hidden
bool property bAttributeIconsOptionChanged auto hidden

int[] property aiTargetQ auto hidden
string[] asQueueName
bool[] abQueueWasEmpty

EquipSlot[] property EquipSlots auto hidden

string[] asItemNames
string[] asWeaponTypeNames
int[] property ai2HWeaponTypes auto hidden
int[] property ai2HWeaponTypesAlt auto hidden

int iQueueMenuCurrentQueue = -1
bool bJustUsedQueueMenuDirectAccess

string sCurrentMenu
string sEntryPath

bool property bShoutEnabled = true auto hidden
bool property bConsumablesEnabled = true auto hidden
bool property bPoisonsEnabled = true auto hidden

int property iBackgroundStyle auto hidden

bool[] property abIsCounterShown auto hidden
int[] aiCounterClips
bool property bLeftIconFaded auto hidden

bool property bWidgetFadeoutEnabled auto hidden
bool property bNameFadeoutEnabled auto hidden
bool[] property abIsNameShown auto hidden
int[] property aiNameElements auto hidden
bool property bFirstPressShowsName = true auto hidden

bool[] property abIsPoisonNameShown auto hidden
int[] property aiPoisonNameElements auto hidden
bool[] property abPoisonInfoDisplayed auto hidden

bool[] property abPotionGroupEnabled auto hidden
string[] asPotionGroups
bool[] property abPotionGroupEmpty auto hidden
bool property bConsumableIconFaded auto hidden
bool bFirstAttemptToDeletePotionGroup = true

bool property bPoisonIconFaded auto hidden

bool property bBlockSwitchBackToBoundSpell auto hidden

bool property bMoreHUDLoaded auto hidden
string[] property asMoreHUDIcons auto hidden

int iRemovedItemsCacheObj
int iItemsForIDGenerationObj
int property iEquipQHolderObj auto hidden

bool bReverse ;Used if bEquipOnPause is enabled
bool bWaitingForEquipOnPauseUpdate
bool property bCyclingLHPreselectInAmmoMode auto hidden

bool bSwitchingHands
bool property bPreselectSwitchingHands auto hidden
bool bSkipOtherHandCheck
bool property bGoneUnarmed auto hidden
bool property b2HSpellEquipped auto hidden

bool bWaitingForFlash
bool bItemsWaitingForID
bool bGotID
int iReceivedID

bool property bEquipOnPause = true auto hidden

string function GetWidgetType()
	Return "iEquip_WidgetCore"
endFunction

string function GetWidgetSource()
	Return "iEquip/iEquipWidget.swf"
endFunction

Event OnWidgetInit()
	debug.trace("iEquip_WidgetCore OnWidgetInit start")
	PopulateWidgetArrays()
	bDrawn = PlayerRef.IsWeaponDrawn()

	abIsNameShown = new bool[8]
	aiTargetQ = new int[5]
	aiCurrentQueuePosition = new int[5] ;Array containing the current index for each queue - left, right, shout, potion, poison, arrow, bolt
	asCurrentlyEquipped = new string[5] ;Array containing the itemName for whatever is currently equipped in each queue
	aiCurrentlyPreselected = new int[3] ;Array containing current preselect queue positions
	abQueueWasEmpty = new bool[3]
	abPotionGroupEmpty = new bool[3]
	abIsCounterShown = new bool[5]
	abIsPoisonNameShown = new bool[2]
	abPoisonInfoDisplayed = new bool[2]
	abQuickDualCastSchoolAllowed = new bool[5]
	abPotionGroupEnabled = new bool[3]
	abPotionGroupAddedBack = new bool[3]
	
	int i
	while i < 8
		abIsNameShown[i] = true
		if i < 5
			aiCurrentQueuePosition[i] = -1
			if i < 3
				aiCurrentlyPreselected[i] = -1
				abQueueWasEmpty[i] = true
				abPotionGroupEmpty[i] = true
			endIf
		endIf
		i += 1
	endwhile

	asQueueName = new string[5]
	asQueueName[0] = "$iEquip_WC_common_leftQ"
	asQueueName[1] = "$iEquip_WC_common_rightQ"
	asQueueName[2] = "$iEquip_WC_common_shoutQ"
	asQueueName[3] = "$iEquip_WC_common_consQ"
	asQueueName[4] = "$iEquip_WC_common_poisonQ"

	aiNameElements = new int[8]
	aiNameElements[0] = 8
	aiNameElements[1] = 21
	aiNameElements[2] = 34
	aiNameElements[3] = 40
	aiNameElements[4] = 44
	aiNameElements[5] = 17
	aiNameElements[6] = 30
	aiNameElements[7] = 37

	asWeaponTypeNames = new string[10]
	asWeaponTypeNames[0] = "Fist"
	asWeaponTypeNames[1] = "Sword"
	asWeaponTypeNames[2] = "Dagger"
	asWeaponTypeNames[3] = "Waraxe"
	asWeaponTypeNames[4] = "Mace"
	asWeaponTypeNames[5] = "Greatsword"
	asWeaponTypeNames[6] = "Battleaxe"
	asWeaponTypeNames[7] = "Bow"
	asWeaponTypeNames[8] = "Staff"
	asWeaponTypeNames[9] = "Crossbow"

	asSpellSchools = new string[5]
	asSpellSchools[0] = "Alteration"
	asSpellSchools[1] = "Conjuration"
	asSpellSchools[2] = "Destruction"
	asSpellSchools[3] = "Illusion"
	asSpellSchools[4] = "Restoration"

	ai2HWeaponTypes = new int[4]
	ai2HWeaponTypes[0] = 5 ;Greatsword
	ai2HWeaponTypes[1] = 6 ;Waraxe/Warhammer
	ai2HWeaponTypes[2] = 7 ;Bow
	ai2HWeaponTypes[3] = 9 ;Crossbow

	ai2HWeaponTypesAlt = new int[4]
	ai2HWeaponTypesAlt[0] = 5 ;Greatsword
	ai2HWeaponTypesAlt[1] = 6 ;Waraxe/Warhammer
	ai2HWeaponTypesAlt[2] = 7 ;Bow
	ai2HWeaponTypesAlt[3] = 12 ;Crossbow

	aiCounterClips = new int[5]
	aiCounterClips[0] = 9
	aiCounterClips[1] = 22
	aiCounterClips[2] = -1
	aiCounterClips[3] = 41
	aiCounterClips[4] = 45

	aiPoisonNameElements = new int[2]
	aiPoisonNameElements[0] = 11
	aiPoisonNameElements[1] = 24

	asPotionGroups = new string[3]
	asPotionGroups[0] = "$iEquip_common_HealthPotions"
	asPotionGroups[1] = "$iEquip_common_MagickaPotions"
	asPotionGroups[2] = "$iEquip_common_StaminaPotions"

	asMoreHUDIcons = new string[4]
	asMoreHUDIcons[0] = "iEquipQL.png" ;Left
	asMoreHUDIcons[1] = "iEquipQR.png" ;Right
	asMoreHUDIcons[2] = "iEquipQ.png" ;Q - for shout/consumable/poison queues
	asMoreHUDIcons[3] = "iEquipQB.png" ;Both - for items in both left and right queues

	EquipSlots = new EquipSlot[5]
	EquipSlots[0] = Game.GetForm(0x00013F42) As EquipSlot ; LeftHand
	EquipSlots[1] = Game.GetForm(0x00013F43) As EquipSlot ; RightHand
	EquipSlots[2] = Game.GetForm(0x00013F44) As EquipSlot ; EitherHand
	EquipSlots[3] = Game.GetForm(0x00013F45) As EquipSlot ; BothHands
	EquipSlots[4] = Game.GetForm(0x00025BEE) As EquipSlot ; Voice

	bLoadedbyOnWidgetInit = true
	initDataObjects()
	Utility.WaitMenuMode(0.1)
	PO.InitialisePotionQueueArrays(aiTargetQ[3], aiTargetQ[4])
	addPotionGroups()
	addFists()
	KH.GameLoaded()
	debug.trace("iEquip_WidgetCore OnWidgetInit end")
EndEvent

function CheckDependencies()
	debug.trace("iEquip_WidgetCore CheckDependencies start")
	bMoreHUDLoaded = false
	if AhzMoreHudIE.GetVersion() > 0
		bMoreHUDLoaded = true
		initialisemoreHUDArray()
	endIf
    if Game.GetModByName("Requiem.esp") != 255
        RC.bIsRequiemLoaded = true
    else
        RC.bIsRequiemLoaded = false
    endIf
    race tempRace
    if Game.GetModByName("Dawnguard.esm") != 255
    	EH.bIsDawnguardLoaded = true
    	tempRace = Game.GetFormFromFile(0x0000283A, "Dawnguard.esm") as Race
		EH.DLC1VampireBeastRace = tempRace
		BM.arBeastRaces[1] = tempRace
	else
		EH.bIsDawnguardLoaded = false
		EH.DLC1VampireBeastRace = none
		BM.arBeastRaces[1] = none
	endIf
	if Game.GetModByName("Undeath.esp") != 255
		EH.bIsUndeathLoaded = true
		tempRace = Game.GetFormFromFile(0x0001772A, "Undeath.esp") as Race
		EH.NecroLichRace = tempRace
		BM.arBeastRaces[2] = tempRace
	else
		EH.bIsUndeathLoaded = false
		EH.NecroLichRace = none
		BM.arBeastRaces[2] = none
	endIf
	if Game.GetModByName("Thunderchild - Epic Shout Package.esp") != 255
        EH.bIsThunderchildLoaded = true
    else
        EH.bIsThunderchildLoaded = false
    endIf
    if Game.GetModByName("Wintersun - Faiths of Skyrim.esp") != 255
        EH.bIsWintersunLoaded = true
    else
        EH.bIsWintersunLoaded = false
    endIf
    debug.trace("iEquip_WidgetCore CheckDependencies end")
endFunction

Event OnWidgetLoad()
	debug.trace("iEquip_WidgetCore OnWidgetLoad start")

	EM.isEditMode = false
	bPreselectMode = false
	bCyclingLHPreselectInAmmoMode = false
	PM.bBlockQuickDualCast = false
	GotoState("")
	bLoading = true
	if !bLoadedbyOnWidgetInit
		initDataObjects()
		KH.GameLoaded()
	endIf
	bLoadedbyOnWidgetInit = false
	PM.OnWidgetLoad()
	AM.OnWidgetLoad()
	CM.OnWidgetLoad()
	
	CheckDependencies()

    OnWidgetReset()
    EM.UpdateElementsAll()
    ; Determine if the widget should be displayed
    UpdateWidgetModes()
    ;Make sure to hide Edit Mode and bPreselectMode elements, leaving left shown if in bAmmoMode
	UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	bool[] args = new bool[5]
	if bAmmoMode
		args[0] = true
	endIf
	args[3] = bAmmoMode
	UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
    ; Use RunOnce bool here - if first load hide everything and show messagebox
	if bIsFirstLoad
		getAndStoreDefaultWidgetValues()
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", false)
		bIsFirstLoad = false
	else
		if !bIsFirstEnabled
			refreshWidgetOnLoad()
		endIf
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", bEnabled)
		updateWidgetVisibility() ;Show the widget
		if bEnabled
			UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
			if CM.iChargeDisplayType > 0
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ;SkyHUD alt charge meter
			endIf
			Utility.WaitMenuMode(0.5)
			if !EH.bPlayerIsABeast
				checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipType"))
			endIf
		endIf
	endIf

	if isEnabled
		KH.RegisterForGameplayKeys()
		debug.notification("$iEquip_WC_not_controlsUnlocked")
	endIf
	bLoading = False
	debug.trace("iEquip_WidgetCore OnWidgetLoad end")
endEvent

Event OnWidgetReset()
	debug.trace("iEquip_WidgetCore OnWidgetReset start")
    RequireExtend = false
	parent.OnWidgetReset()
	debug.trace("iEquip_WidgetCore OnWidgetReset end")
EndEvent

function refreshWidgetOnLoad()
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad start")
	bRefreshingWidgetOnLoad = true
	bLeftIconFaded = false
	int Q
	form fItem
	int potionGroup = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipName"))
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
	if !bDropShadowEnabled
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true)
	endIf
	while Q < 8
		abIsNameShown[Q] = true
		if Q < 5
			if Q < 3 && (jArray.count(aiTargetQ[Q]) < 1 || !PlayerRef.GetEquippedObject(Q))
				setSlotToEmpty(Q, true, (jArray.count(aiTargetQ[Q]) > 0))
			else
				if Q < 2
					checkAndUpdatePoisonInfo(Q)
					CM.initChargeMeter(Q)
					CM.initSoulGem(Q)
				endIf
				if Q == 0 && bAmmoMode
					updateWidget(Q, AM.aiCurrentAmmoIndex[AM.Q])
				else
					updateWidget(Q, aiCurrentQueuePosition[Q])
				endIf
				if abIsCounterShown[Q]
					if Q == 0 && bAmmoMode
						fItem = AM.currentAmmoForm
					else
						fItem = jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipForm")
					endIf
					if Q == 3 && potionGroup != -1
						int count = PO.getPotionGroupCount(potionGroup)
						setSlotCount(3, count)
						if count < 1
							checkAndFadeConsumableIcon(true)
						elseIf bConsumableIconFaded
							checkAndFadeConsumableIcon(false)
						endIf
					elseIf Q == 4
						if jArray.count(aiTargetQ[4]) < 1
							handleEmptyPoisonQueue()
						else
							setSlotCount(4, PlayerRef.GetItemCount(fItem))
							if bConsumableIconFaded
								checkAndFadePoisonIcon(false)
							endIf
						endIf
					elseIf fItem && !(Q < 2 && abPoisonInfoDisplayed[Q])
						setSlotCount(Q, PlayerRef.GetItemCount(fItem))
					endIf
				endIf
			endIf
		else
			updateWidget(Q, aiCurrentlyPreselected[Q - 5])
		endIf
		Q += 1
	endwhile
	if bEnabled
		CM.updateChargeMeters(true)
		;And finally if we've loaded a save where the player is in beast form toggle the widget now
		if EH.bPlayerIsABeast
			BM.onPlayerTransform(PlayerRef.GetRace(), EH.bPlayerIsAVampire, true)
		else
			updateSlotsEnabled()
		endIf
	endIf
	;just to make sure!
	UI.setbool(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
	bRefreshingWidgetOnLoad = false
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad end")
endFunction

;ToDo - This function is still to finish/review
function refreshWidget()
	debug.trace("iEquip_WidgetCore refreshWidget start")
	bRefreshingWidget = true
	;Hide the widget first
	KH.bAllowKeyPress = false
	updateWidgetVisibility(false)
	debug.notification("$iEquip_WC_not_refreshingWidget")
	EM.UpdateElementsAll()
	;Toggle preselect mode now (we exit again later)
	if !bPreselectMode
		PM.togglePreselectMode()
		Utility.WaitMenuMode(3.0)
	endIf
	;Reset visibility and alpha on every element
	int i
	while i < asWidgetDescriptions.Length
		UI.SetBool(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._visible", abWidget_V[i])
		UI.setFloat(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._alpha", afWidget_A[i])
		i += 1
	endwhile
	;Exit Preselect Mode now
	PM.togglePreselectMode()
	Utility.WaitMenuMode(3.0)
	;Check what the items and shout the player currently has equipped and find them in the queues
	i = 0
	form equippedForm
	bool rangedWeaponEquipped
	bool[] slotEmpty = new bool[3]
	while i < 3
		int itemType 
		equippedForm = PlayerRef.GetEquippedObject(i)
		;If we have something equipped in the slot make sure it is correctly displayed
		if equippedForm
			if i == 0 && equippedForm as weapon
				itemType = (equippedForm as weapon).GetWeaponType()
				if itemType == 5 || itemType == 6
					i = 1
				elseIf itemType == 7 || itemType == 9
					rangedWeaponEquipped = true
					AM.selectAmmoQueue(itemType)
					i = 1
				endIf
			endIf
			int foundAt = findInQueue(i, equippedForm.GetName())
			;If we've found the item in the queue then set the queue position and name
			if foundAt != -1
				aiCurrentQueuePosition[i] = foundAt
				asCurrentlyEquipped[i] = jMap.getStr(jArray.getObj(aiTargetQ[i], foundAt), "iEquipName")
			;Otherwise unequip and re-equip the item which should then cause EH.OnObjectEquipped to add it in to the relevant queue and update the widget accordingly
			elseIf i < 2
				UnequipHand(i)
				Utility.WaitMenuMode(0.2)
				if (i == 1 && itemType == 42)
			    	PlayerRef.EquipItemEx(equippedForm as Ammo)
			    elseif (i == 0 && itemType == 26)
			    	PlayerRef.EquipItemEx(equippedForm as Armor)
			    else
			    	PlayerRef.EquipItemEx(equippedForm, i)
			    endIf
			else
				if itemType == 22
			        PlayerRef.EquipSpell(equippedForm as Spell, 2)
			    else
			        PlayerRef.EquipShout(equippedForm as Shout)
			    endIf
			endIf
		;Otherwise set the slot to empty
		else
			slotEmpty[i] = true
			setSlotToEmpty(i, (jArray.count(aiTargetQ[i]) > 0))
		endIf
		i += 1
	endwhile
	;if we're in ammo mode check if we actually should be
	if (bAmmoMode && !rangedWeaponEquipped) || (!bAmmoMode && rangedWeaponEquipped)
		AM.toggleAmmoMode()
		Utility.WaitMenuMode(3.0)
	endIf
	;Now we need to refresh the names and icons for each slot to show what is currently equipped
	i = 0
	while i < 5
		abIsNameShown[i] = true
		if i < 2
			checkAndUpdatePoisonInfo(i)
		endIf
		if i == 0 && bAmmoMode
			updateWidget(i, AM.aiCurrentAmmoIndex[AM.Q])
		elseIf !(i < 3 && slotEmpty[i])
			updateWidget(i, aiCurrentQueuePosition[i])
		endIf
		i += 1
	endwhile
	CM.updateChargeMeters(true)
	;We can now check if we need to fade the left icon if we've got a 2H weapon equipped
	Utility.WaitMenuMode(1.5)
	checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipType"))
	;Reset consumable count and fade
	int potionGroup = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipName"))
	int count
	if potionGroup == -1
		count = PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipForm"))
	else
		count = PO.getPotionGroupCount(potionGroup)
	endIf
	setSlotCount(3, count)
	if count < 1
		checkAndFadeConsumableIcon(true)
	elseIf bConsumableIconFaded
		checkAndFadeConsumableIcon(false)
	endIf
	;Reset poison count and fade
	if jArray.count(aiTargetQ[4]) < 1
		handleEmptyPoisonQueue()
	else
		setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[4], aiCurrentQueuePosition[4]), "iEquipForm")))
		if bConsumableIconFaded
			checkAndFadePoisonIcon(false)
		endIf
	endIf
	;Check and show or hide left and right counters
	if !bAmmoMode
		i = 0
		while i < 2
			if itemRequiresCounter(i, jMap.getInt(jArray.getObj(aiTargetQ[i], aiCurrentQueuePosition[i]), "iEquipType")) || abPoisonInfoDisplayed[i]
				setSlotCount(i, PlayerRef.GetItemCount(equippedForm))
				;Show the counter if currently hidden
				setCounterVisibility(i, true)
			;The item doesn't require a counter so hide it if it's currently shown
			else
				setCounterVisibility(i, false)
			endIf
			i += 1
		endwhile
	;We're in Ammo Mode so we need to make sure only the left counter is shown
	else
		setCounterVisibility(0, true)
		;And hide the right hand counter unless the current ranged weapon is poisoned
		if !abPoisonInfoDisplayed[1]
			setCounterVisibility(1, false)
		elseIf abPoisonInfoDisplayed[1]
			setCounterVisibility(1, true)
		endIf
	endIf
	;Make sure that any slots which whould be hidden are hidden
	updateSlotsEnabled()
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
	if !bDropShadowEnabled
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true)
	endIf
	;Show the widget
	updateWidgetVisibility()
	;And finally re-register for fadeouts if required
	if bNameFadeoutEnabled
		LNUpdate.registerForNameFadeoutUpdate()
		RNUpdate.registerForNameFadeoutUpdate()
		if bShoutEnabled
			SNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bConsumablesEnabled
			CNUpdate.registerForNameFadeoutUpdate()
		endIf
		if bPoisonsEnabled
			PNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
	KH.bAllowKeyPress = true
	bRefreshingWidget = false
	debug.Notification("$iEquip_WC_not_doneRefreshing")
	debug.trace("iEquip_WidgetCore refreshWidget end")
endFunction

;Called from EditMode when toggling back out
function resetWidgetsToPreviousState()
	debug.trace("iEquip_WidgetCore resetWidgetsToPreviousState start")
	int i = asWidgetDescriptions.Length
    ;Reset visiblity on all elements
	While i > 0
        i -= 1
		UI.SetBool(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._visible", abWidget_V[i])
	EndWhile

	i = 0
	while i < 8
		;Reset all names and reregister for fades if required
		showName(i, true, false, 0.0)
		if i < 5
			;Reset the counters
            if !EM.abWasCounterShown[i]
				setCounterVisibility(i, false)
			else
				setSlotCount(i, EM.aiPreviousCount[i])
			endIf
            if i < 2
                ; Check and fade in left icon if currently faded
                if i == 0 && bLeftIconFaded
                    checkAndFadeLeftIcon(0,0)
                endIf
                ;Reset poison elements
				if !abPoisonInfoDisplayed[i]
					hidePoisonInfo(i, true)
				else
					checkAndUpdatePoisonInfo(i)
				endIf
				;Reset attribute icons
				hideAttributeIcons(i)
				if bPreselectMode && EM.preselectEnabledOnEnter
					updateAttributeIcons(i, 0)
				endIf
            ; Handle empty shout,consumable and poison queues to ensure all temporary elements are removed
            elseIf jArray.count(aiTargetQ[i]) < 1 || i == 3 && jArray.count(aiTargetQ[i]) == 3
                if i == 2
                    setSlotToEmpty(i)
                elseIf i == 3
                    ; Check if there are any potion groups shown...
                    if EM.iEnabledPotionGroupCount > 0
                        ;...and handle fade if required
                        checkAndFadeConsumableIcon(true)
                    ; Otherwise set temp info in the widget    
                    else
                        setSlotToEmpty(i)
                    endIf
                elseIf i == 4
                    handleEmptyPoisonQueue()
                endIf                
            endIf
        endIf
    	i += 1
    endWhile
	;Reset Preselect Mode
	if EM.preselectEnabledOnEnter && bPreselectMode
        PM.togglePreselectMode(true)
		EM.preselectEnabledOnEnter = false
	endIf
	;Reset enchantment meters and soulgems
	CM.updateChargeMeters(true)
	debug.trace("iEquip_WidgetCore resetWidgetsToPreviousState end")
endFunction

function initDataObjects()
    debug.trace("iEquip_WidgetCore initDataObjects start")
    if iEquipQHolderObj == 0
        iEquipQHolderObj = JValue.retain(Jmap.object())
    endIf
    if aiTargetQ[0] == 0
        aiTargetQ[0] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "leftQ", aiTargetQ[0])
    endIf
    if aiTargetQ[1] == 0
        aiTargetQ[1] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "rightQ", aiTargetQ[1])
    endIf
    if aiTargetQ[2] == 0
        aiTargetQ[2] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "shoutQ", aiTargetQ[2])
    endIf
    if aiTargetQ[3] == 0
        aiTargetQ[3] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "consumableQ", aiTargetQ[3])
    endIf
    if aiTargetQ[4] == 0
        aiTargetQ[4] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "poisonQ", aiTargetQ[4])
    endIf
    if iRemovedItemsCacheObj == 0
        iRemovedItemsCacheObj = JArray.object()
        JMap.setObj(iEquipQHolderObj, "lastRemovedCache", iRemovedItemsCacheObj )
    endIf
    if iItemsForIDGenerationObj == 0
        iItemsForIDGenerationObj = JArray.object()
        JMap.setObj(iEquipQHolderObj, "iItemsForIDGenerationObj", iItemsForIDGenerationObj )
    endIf
    debug.trace("iEquip_WidgetCore initDataObjects end")
endFunction

function initialisemoreHUDArray()
	debug.trace("iEquip_WidgetCore initialisemoreHUDArray start")

    int jItemIDs = jArray.object()
    int jIconNames = jArray.object()
    int Q
    
    while Q < 5
        int queueLength = JArray.count(aiTargetQ[Q])
        debug.trace("iEquip_WidgetCore initialisemoreHUDArray processing Q: " + Q + ", queueLength: " + queueLength)
        int i
        
        while i < queueLength
        	;Clear out any empty indices for good measure
        	if !jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName")
        		jArray.eraseIndex(aiTargetQ[Q], i)
        		queueLength -= 1
        	endIf
        	;Make sure we skip the dummy Unarmed and Potion Group items
        	if Q == 1 || Q == 3
	        	bool isDummyItem = true
	        	while isDummyItem
	        		string itemName = jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName")
	        		if Q == 1
	        			isDummyItem = (itemName == "$iEquip_common_Unarmed")
	        		else
	        			isDummyItem = (asPotionGroups.Find(itemName) > -1)
	        		endIf
	        		if isDummyItem
	        			i += 1
	        		endIf
	        	endWhile
	        endIf
	        if i < queueLength
	            int itemID = jMap.getInt(jArray.getObj(aiTargetQ[Q], i), "iEquipItemID")
	            debug.trace("iEquip_WidgetCore initialisemoreHUDArray Q: " + Q + ", i: " + i + ", itemID: " + itemID + ", " + jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName"))
	            if itemID == 0
	            	itemID = createItemID(jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName"), (jMap.getForm(jArray.getObj(aiTargetQ[Q], i), "iEquipForm")).GetFormID())
	            	jMap.setInt(jArray.getObj(aiTargetQ[Q], i), "iEquipItemID", itemID)
	            endIf
	            if itemID as bool
		            int foundAt = -1
		            if !(i == 0 && Q == 0)
		            	foundAt = jArray.findInt(jItemIDs, itemID)
		            endIf
		            if Q == 1 && foundAt != -1
		            	debug.trace("iEquip_WidgetCore initialisemoreHUDArray - itemID " + itemID + " already found at index " + foundAt + ", updating icon name to " + asMoreHUDIcons[3])
		                jArray.setStr(jIconNames, foundAt, asMoreHUDIcons[3])
		            else
		            	debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding itemID " + itemID + " to jItemIDs")
		                jArray.addInt(jItemIDs, itemID)
		                if Q < 2
		                	debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding " + asMoreHUDIcons[Q] + " to jIconNames")
		                	jArray.addStr(jIconNames, asMoreHUDIcons[Q])
		                else
		                	debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding " + asMoreHUDIcons[2] + " to jIconNames")
		                	jArray.addStr(jIconNames, asMoreHUDIcons[2])
		                endIf
		            endIf
		        endIf
	            i += 1
	        endIf
        endWhile

        Q += 1
    endWhile
    debug.trace("iEquip_WidgetCore initialisemoreHUDArray - jItemIds contains " + jArray.count(jItemIDs) + " entries")
    debug.trace("iEquip_WidgetCore initialisemoreHUDArray - jIconNames contains " + jArray.count(jIconNames) + " entries")
    if jArray.count(jItemIDs) > 0
	    int[] itemIDs = utility.CreateIntArray(jArray.count(jItemIDs))
        string[] iconNames = utility.CreateStringArray(jArray.count(jIconNames))
	    jArray.writeToIntegerPArray(jItemIDs, itemIDs)
	    jArray.writeToStringPArray(jIconNames, iconNames)
	    debug.trace("iEquip_WidgetCore initialisemoreHUDArray - itemIDs contains " + itemIDs.Length + " entries with " + itemIDs[0] + " in index 0")
    	debug.trace("iEquip_WidgetCore initialisemoreHUDArray - iconNames contains " + iconNames.Length + " entries with " + iconNames[0] + " in index 0")
	    AhzMoreHudIE.AddIconItems(itemIDs, iconNames)
	endIf
    PO.initialisemoreHUDArray()
    debug.trace("iEquip_WidgetCore initialisemoreHUDArray end")
endFunction

function addPotionGroups(int groupToAdd = -1)
	debug.trace("iEquip_WidgetCore addPotionGroups start")
	debug.trace("iEquip_WidgetCore addPotionGroups - groupToAdd: " + groupToAdd)
	if groupToAdd == -1 || (groupToAdd == 0 && !abPotionGroupEnabled[0])
		int healthPotionGroup = jMap.object()
		jMap.setInt(healthPotionGroup, "iEquipType", 46)
		jMap.setStr(healthPotionGroup, "iEquipName", "$iEquip_common_HealthPotions")
		jMap.setStr(healthPotionGroup, "iEquipIcon", "HealthPotion")
		jArray.addObj(aiTargetQ[3], healthPotionGroup)
		abPotionGroupEnabled[0] = true
	endIf
	if groupToAdd == -1 || (groupToAdd == 1 && !abPotionGroupEnabled[1])
		int magickaPotionGroup = jMap.object()
		jMap.setInt(magickaPotionGroup, "iEquipType", 46)
		jMap.setStr(magickaPotionGroup, "iEquipName", "$iEquip_common_MagickaPotions")
		jMap.setStr(magickaPotionGroup, "iEquipIcon", "MagickaPotion")
		jArray.addObj(aiTargetQ[3], magickaPotionGroup)
		abPotionGroupEnabled[1] = true
	endIf
	if groupToAdd == -1 || (groupToAdd == 2 && !abPotionGroupEnabled[2])
		int staminaPotionGroup = jMap.object()
		jMap.setInt(staminaPotionGroup, "iEquipType", 46)
		jMap.setStr(staminaPotionGroup, "iEquipName", "$iEquip_common_StaminaPotions")
		jMap.setStr(staminaPotionGroup, "iEquipIcon", "StaminaPotion")
		jArray.addObj(aiTargetQ[3], staminaPotionGroup)
		abPotionGroupEnabled[2] = true
	endIf
	debug.trace("iEquip_WidgetCore addPotionGroups end")
endFunction

function removePotionGroups()
	debug.trace("iEquip_WidgetCore removePotionGroups start")
	int i
	while i < 3
		if abPotionGroupEnabled[i]
			int queueIndex = findInQueue(3, asPotionGroups[i])
			if queueIndex > -1
				jArray.eraseIndex(3, queueIndex)
			endIf
			int iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_PotionGroupRemoved{" + asPotionGroups[i] + "}"))
			if iButton == 0
				PO.addIndividualPotionsToQueue(i)
			endIf
		endIf
		i += 1
	endWhile
	debug.trace("iEquip_WidgetCore removePotionGroups end")
endFunction

function addFists()
	debug.trace("iEquip_WidgetCore addFists start")
	if findInQueue(1, "$iEquip_common_Unarmed") == -1
		int Fists = jMap.object()
		jMap.setInt(Fists, "iEquipType", 0)
		jMap.setStr(Fists, "iEquipName", "$iEquip_common_Unarmed")
		jMap.setStr(Fists, "iEquipIcon", "Fist")
		jArray.addObj(aiTargetQ[1], Fists)
	endIf
	debug.trace("iEquip_WidgetCore addFists end")
endFunction

event OnMenuOpen(string _sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuOpen start")
	debug.trace("iEquip_WidgetCore OnMenuOpen - current menu: " + _sCurrentMenu)
	sCurrentMenu = _sCurrentMenu
	if (sCurrentMenu == "InventoryMenu" || sCurrentMenu == "MagicMenu" || sCurrentMenu == "FavoritesMenu") ;if in inventory or magic menu switch states so cycle hotkeys now assign selected item to the relevant queue array
		if  bIsFirstInventoryMenu
			if bShowTooltips
				debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_inventoryFirstLook"))
			endIf
			bIsFirstInventoryMenu = false
		endIf
		if sCurrentMenu == "InventoryMenu" || sCurrentMenu == "MagicMenu"
			sEntryPath = "_root.Menu_mc.inventoryLists.itemList"
		elseif sCurrentMenu == "FavoritesMenu"
			sEntryPath = "_root.MenuHolder.Menu_mc.itemList"
		endIf
	;elseif sCurrentMenu == "Journal Menu"
		;sEntryPath = "_root.ConfigPanelFader.configPanel._modList"
	endIf
	;Geared Up
	if bEnableGearedUp && PlayerRef.GetRace() == EH.PlayerRace
		if PlayerRef.IsWeaponDrawn() || PlayerRef.GetAnimationVariablebool("IsEquipping")
			Utility.SetINIbool("bDisableGearedUp:General", true)
			refreshVisibleItems()
			Utility.WaitMenuMode(0.1)
			Utility.SetINIbool("bDisableGearedUp:General", false)
			refreshVisibleItems()
		endIf
	endIf
	debug.trace("iEquip_WidgetCore OnMenuOpen end")
endEvent

event OnMenuClose(string _sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuClose start")
	debug.trace("iEquip_WidgetCore OnMenuClose - current menu: " + _sCurrentMenu + ", bItemsWaitingForID: " + bItemsWaitingForID)
	if bItemsWaitingForID ;&& !utility.IsInMenuMode()
		findAndFillMissingItemIDs()
		bItemsWaitingForID = false
	endIf
	int i
	;Just in case user has decided to poison or recharge a currently equipped weapon through the Inventory Menu, yawn...
	while i < 2
		if PlayerRef.GetEquippedObject(i) as Weapon
			checkAndUpdatePoisonInfo(i)
			CM.checkAndUpdateChargeMeter(i)
		endIf
		i += 1
	endWhile
	sCurrentMenu = ""
	sEntryPath = ""
	debug.trace("iEquip_WidgetCore OnMenuClose end")
endEvent

function refreshGearedUp()
	debug.trace("iEquip_WidgetCore refreshGearedUp start")
	Utility.SetINIbool("bDisableGearedUp:General", True)
	refreshVisibleItems()
	Utility.WaitMenuMode(0.05)
	Utility.SetINIbool("bDisableGearedUp:General", False)
	refreshVisibleItems()
	debug.trace("iEquip_WidgetCore refreshGearedUp end")
endFunction

function refreshVisibleItems()
	debug.trace("iEquip_WidgetCore refreshVisibleItems start")
	if !PlayerRef.IsOnMount()
		PlayerRef.QueueNiNodeUpdate()
	else
		boots = PlayerRef.GetWornForm(0x00000080)
		if boots
			PlayerRef.UnequipItem(boots, false, true)
			Utility.WaitMenuMode(0.1)
			PlayerRef.EquipItem(boots, false, true)
		else
			PlayerRef.AddItem(Shoes, 1, true)
			PlayerRef.EquipItem(Shoes, false, true)
			Utility.WaitMenuMode(0.1)
			PlayerRef.UnequipItem(Shoes, false, true)
			PlayerRef.RemoveItem(Shoes, 1, true)
		endIf
	endIf
	debug.trace("iEquip_WidgetCore refreshVisibleItems end")
endFunction

function updateWidgetVisibility(bool show = true, float fDuration = 0.2)
	debug.trace("iEquip_WidgetCore updateWidgetVisibility start")
	debug.trace("iEquip_WidgetCore updateWidgetVisibility - show: " + show + ", bIsWidgetShown: " + bIsWidgetShown)
	if show
		if !bIsWidgetShown
			bIsWidgetShown = true
			;UpdateWidgetModes()
			FadeTo(100, 0.2)
		endif
		;Register for widget fadeout if enabled
		if bWidgetFadeoutEnabled && fWidgetFadeoutDelay > 0 && (!bAlwaysVisibleWhenWeaponsDrawn || !PlayerRef.IsWeaponDrawn()) && !EM.isEditMode
			WVis.registerForWidgetFadeoutUpdate()
		endIf
	elseIf bIsWidgetShown
		bIsWidgetShown = false
		FadeTo(0, fDuration)
	endIf
	debug.trace("iEquip_WidgetCore updateWidgetVisibility end")
endFunction

bool property isEnabled
{Set this property true to enable the widget}
	bool function Get()
		debug.trace("iEquip_WidgetCore isEnabled Get start")
		debug.trace("iEquip_WidgetCore isEnabled Get end")
		Return bEnabled
	endFunction
	
	function Set(bool enabled)
		debug.trace("iEquip_WidgetCore isEnabled Set start")
		if (Ready)
            bEnabled = enabled
            EH.initialise(bEnabled) ;Also triggers PO.initialise() which includes findAndSortPotions, and BW.initialise()
            AD.initialise(bEnabled)
            
			if bEnabled
                bool[] args = new bool[4]
            
                self.RegisterForMenu("InventoryMenu")
				self.RegisterForMenu("MagicMenu")
				self.RegisterForMenu("FavoritesMenu")
				self.RegisterForMenu("ContainerMenu")
				self.RegisterForMenu("Journal Menu")    
            
				AM.updateAmmoLists()
				if bIsFirstEnabled
                    bIsFirstEnabled = false
                    MCM.bFirstEnabled = false
                    
					UI.invoke(HUD_MENU, WidgetRoot + ".setWidgetToEmpty")
					; Add anything currently equipped in left, right and shout slots
					addCurrentItemsOnFirstEnable()
					; Update consumable and poison slots to show Health Potions and first poison if any present
					int Q = 3
					while Q < 5
						if jArray.count(aiTargetQ[Q]) > 0
							aiCurrentQueuePosition[Q] = 0
							asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], 0), "iEquipName")
							updateWidget(Q, 0, false, true)
							if Q == 3
						    	setSlotCount(3, PO.getPotionGroupCount(0))
						    	if abPotionGroupEmpty[0]
						    		checkAndFadeConsumableIcon(true)
						    	else
						    		setCounterVisibility(3, true)
						    	endIf
						    else
						        setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[4], 0), "iEquipForm")))
						        setCounterVisibility(4, true)
						    endIf
						endIf
						Q += 1
					endWhile
                    
                    ResetWidgetArrays()
                    Utility.WaitMenuMode(1.5)
                    if bShowTooltips
                    	debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_addingItems"))
                    endIf
				endIf
                
				UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
				UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
				UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
				UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", !bDropShadowEnabled)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
				if CM.iChargeDisplayType > 0
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ;SkyHUD alt charge meter
				endIf
				iEquip_MessageQuest.Start()
				KH.RegisterForGameplayKeys()
				debug.notification("$iEquip_WC_not_controlsUnlocked")
			else
				self.UnregisterForAllMenus()
				KH.UnregisterForAllKeys()
                
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 100) ;SkyHUD alt charge meter
                
                if EM.isEditMode
                    updateWidgetVisibility(false)
                    Wait(0.2)
                    EM.DisableEditMode()
                endIf
                
                iEquip_MessageQuest.Stop()
			endIf
			updateWidgetVisibility() ;Just in case you were in Edit Mode when you disabled because ToggleEditMode won't have done this
			UI.setbool(HUD_MENU, WidgetRoot + "._visible", bEnabled)
		endIf
		debug.trace("iEquip_WidgetCore isEnabled Set end")
	endFunction
EndProperty

function addCurrentItemsOnFirstEnable()
	debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable start")
	int Q
	form equippedItem
	string itemName
	string itemIcon
	int itemID
	int itemType
	int iEquipSlot
	while Q < 3
		equippedItem = PlayerRef.GetEquippedObject(Q)
		if equippedItem
			itemName = equippedItem.getName()
			itemID = createItemID(itemName, equippedItem.GetFormID())
			itemType = equippedItem.GetType()
			if itemType == 22
				iEquipSlot = EquipSlots.Find((equippedItem as spell).GetEquipType())
			elseIf itemType == 41 ;if it is a weapon get the weapon type
	        	itemType = (equippedItem as Weapon).GetWeaponType()
	        endIf
	        itemIcon = GetItemIconName(equippedItem, itemType, itemName)
	        if Q == 0 && (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9 || (itemType == 22 && iEquipSlot == 3))
	        	bAddingItemsOnFirstEnable = true
	        	;The following sequence is to reset both hands so no auto re-equipping/auto-adding goes on the first time this 2H item is unequipped
	        	UnequipHand(0)
	        	UnequipHand(1)
	        	Utility.WaitMenuMode(0.3)
	        	UnequipHand(0)
	        	UnequipHand(1)
	        	PlayerRef.EquipItemById(equippedItem, itemID, 1)
	        	Utility.WaitMenuMode(0.3)
	        	bAddingItemsOnFirstEnable = false
	        	Q = 1
	        endIf
			int iEquipItem = jMap.object()
			jMap.setForm(iEquipItem, "iEquipForm", equippedItem)
			jMap.setInt(iEquipItem, "iEquipItemID", itemID)
			jMap.setInt(iEquipItem, "iEquipType", itemType)
			jMap.setStr(iEquipItem, "iEquipName", itemName)
			jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
			if Q < 2
				if itemType == 22
					if itemIcon == "DestructionFire" || itemIcon == "DestructionFrost" || itemIcon == "DestructionShock"
						jMap.setStr(iEquipItem, "iEquipSchool", "Destruction")
					else
						jMap.setStr(iEquipItem, "iEquipSchool", itemIcon)
					endIf
					jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
				endIf
				;These will be set correctly by CycleHand() and associated functions
				jMap.setInt(iEquipItem, "isEnchanted", 0)
				jMap.setInt(iEquipItem, "isPoisoned", 0)
			endIf
			jArray.addObj(aiTargetQ[Q], iEquipItem)
			;Add to the AllItems formlist
			iEquip_AllCurrentItemsFLST.AddForm(equippedItem)
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			;Send to moreHUD if loaded
			if bMoreHUDLoaded
				if Q == 1 && AhzMoreHudIE.IsIconItemRegistered(itemID)
					AhzMoreHudIE.RemoveIconItem(itemID)
					AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[3]) ;Both queues
				else
					AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[Q])
				endIf
			endIf
			;Now update the widget to show the equipped item
			if Q == 1
				aiCurrentQueuePosition[Q] = 1 ;Make sure we show the equipped item and not the Unarmed shortcut we've already added in index 0
			else
				aiCurrentQueuePosition[Q] = 0
			endIf
			asCurrentlyEquipped[Q] = itemName
			if Q < 2 || bShoutEnabled
				updateWidget(Q, aiCurrentQueuePosition[Q], false, true)
			endIf
			;And run the rest of the hand equip cycle without actually equipping to toggle ammo mode if needed and update count, poison and charge info
			if Q < 2
				checkAndEquipShownHandItem(Q, false, true)
			endIf
		;Otherwise set left/right slots to Unarmed
		elseIf Q == 0
			setSlotToEmpty(0)
		elseIf Q == 1
			aiCurrentQueuePosition[Q] = 0
			asCurrentlyEquipped[Q] = "$iEquip_common_Unarmed"
			updateWidget(Q, aiCurrentQueuePosition[Q], false, true)
		endIf
		Q += 1
	endWhile
	;The only slots this should potentially leave as + Empty on a fresh start are the Shout and Poison slots
	debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable end")
endFunction

function PopulateWidgetArrays()
	debug.trace("iEquip_WidgetCore PopulateWidgetArrays start")
	asWidgetDescriptions = new string[46]
	asWidgetElements = new string[46]
	asWidget_TA = new string[46]
	asWidgetGroup = new string[46]
	
	afWidget_X = new float[46]
	afWidget_Y = new float[46]
	afWidget_S = new float[46]
	afWidget_R = new float[46]
	afWidget_A = new float[46]
	
	aiWidget_D = new int[46] ;Stored the index value of any Bring To Front target element ie the element to be sent behind
	aiWidget_TC = new int[46]
	
	abWidget_V = new bool[46]
	abWidget_isParent = new bool[46]
	abWidget_isText = new bool[46]
	abWidget_isBg = new bool[46]

	;AddWidget arguments - Description, Full Path, X position, Y position, Scale, Rotation, Alpha, Depth, Text Colour, Text Alignment, Visibility, isParent, isText, isBackground, Widget Group
	;Master widget
	AddWidget("$iEquip_WC_lbl_CompleteWidget", ".widgetMaster", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, false, "")
	;Main sub-widgets
	AddWidget("$iEquip_WC_lbl_LeftWidget", ".widgetMaster.LeftHandWidget", 0, 0, 0, 0, 0, -1, 0, None, true, true, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_RightWidget", ".widgetMaster.RightHandWidget", 0, 0, 0, 0, 0, 1, 0, None, true, true, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_ShoutWidget", ".widgetMaster.ShoutWidget", 0, 0, 0, 0, 0, 2, 0, None, true, true, false, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ConsWidget", ".widgetMaster.ConsumableWidget", 0, 0, 0, 0, 0, 3, 0, None, true, true, false, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_PoisonWidget", ".widgetMaster.PoisonWidget", 0, 0, 0, 0, 0, 4, 0, None, true, true, false, false, "Poison")
	;Left Hand widget components
	AddWidget("$iEquip_WC_lbl_LeftBg", ".widgetMaster.LeftHandWidget.leftBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Left")
	AddWidget("$iEquip_WC_lbl_LeftIcon", ".widgetMaster.LeftHandWidget.leftIcon_mc", 0, 0, 0, 0, 0, 6, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftName", ".widgetMaster.LeftHandWidget.leftName_mc", 0, 0, 0, 0, 0, 7, 16777215, "Right", true, false, true, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftCount", ".widgetMaster.LeftHandWidget.leftCount_mc", 0, 0, 0, 0, 0, 8, 16777215, "Center", true, false, true, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPoisIcon", ".widgetMaster.LeftHandWidget.leftPoisonIcon_mc", 0, 0, 0, 0, 0, 9, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPoisName", ".widgetMaster.LeftHandWidget.leftPoisonName_mc", 0, 0, 0, 0, 0, 10, 12646509, "Right", true, false, true, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftAttIcon", ".widgetMaster.LeftHandWidget.leftAttributeIcons_mc", 0, 0, 0, 0, 0, 11, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftMeter", ".widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc", 0, 0, 0, 0, 0, 12, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftGem", ".widgetMaster.LeftHandWidget.leftSoulgem_mc", 0, 0, 0, 0, 0, 13, 0, None, true, false, false, false, "Left")
	;Left Hand Preselect widget components
	AddWidget("$iEquip_WC_lbl_LeftPreBg", ".widgetMaster.LeftHandWidget.leftPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreIcon", ".widgetMaster.LeftHandWidget.leftPreselectIcon_mc", 0, 0, 0, 0, 0, 15, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreName", ".widgetMaster.LeftHandWidget.leftPreselectName_mc", 0, 0, 0, 0, 0, 16, 16777215, "Right", true, false, true, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreAtt", ".widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 17, 0, None, true, false, false, false, "Left")
	;Right Hand widget components
	AddWidget("$iEquip_WC_lbl_RightBg", ".widgetMaster.RightHandWidget.rightBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Right")
	AddWidget("$iEquip_WC_lbl_RightIcon", ".widgetMaster.RightHandWidget.rightIcon_mc", 0, 0, 0, 0, 0, 19, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightName", ".widgetMaster.RightHandWidget.rightName_mc", 0, 0, 0, 0, 0, 20, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightCount", ".widgetMaster.RightHandWidget.rightCount_mc", 0, 0, 0, 0, 0, 21, 16777215, "Center", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPoisIcon", ".widgetMaster.RightHandWidget.rightPoisonIcon_mc", 0, 0, 0, 0, 0, 22, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPoisName", ".widgetMaster.RightHandWidget.rightPoisonName_mc", 0, 0, 0, 0, 0, 23, 12646509, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightAttIcon", ".widgetMaster.RightHandWidget.rightAttributeIcons_mc", 0, 0, 0, 0, 0, 24, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightMeter", ".widgetMaster.RightHandWidget.rightEnchantmentMeter_mc", 0, 0, 0, 0, 0, 25, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightGem", ".widgetMaster.RightHandWidget.rightSoulgem_mc", 0, 0, 0, 0, 0, 26, 0, None, true, false, false, false, "Right")
	;Right Hand Preselect widget components
	AddWidget("$iEquip_WC_lbl_RightPreBg", ".widgetMaster.RightHandWidget.rightPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreIcon", ".widgetMaster.RightHandWidget.rightPreselectIcon_mc", 0, 0, 0, 0, 0, 28, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreName", ".widgetMaster.RightHandWidget.rightPreselectName_mc", 0, 0, 0, 0, 0, 29, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreAtt", ".widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 30, 0, None, true, false, false, false, "Right")
	;Shout widget components
	AddWidget("$iEquip_WC_lbl_ShoutBg", ".widgetMaster.ShoutWidget.shoutBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutIcon", ".widgetMaster.ShoutWidget.shoutIcon_mc", 0, 0, 0, 0, 0, 32, 0, None, true, false, false, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutName", ".widgetMaster.ShoutWidget.shoutName_mc", 0, 0, 0, 0, 0, 33, 16777215, "Center", true, false, true, false, "Shout")
	;Shout Preselect widget components
	AddWidget("$iEquip_WC_lbl_ShoutPreBg", ".widgetMaster.ShoutWidget.shoutPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutPreIcon", ".widgetMaster.ShoutWidget.shoutPreselectIcon_mc", 0, 0, 0, 0, 0, 35, 0, None, true, false, false, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutPreName", ".widgetMaster.ShoutWidget.shoutPreselectName_mc", 0, 0, 0, 0, 0, 36, 16777215, "Center", true, false, true, false, "Shout")
	;Consumable widget components
	AddWidget("$iEquip_WC_lbl_ConsBg", ".widgetMaster.ConsumableWidget.consumableBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsIcon", ".widgetMaster.ConsumableWidget.consumableIcon_mc", 0, 0, 0, 0, 0, 38, 0, None, true, false, false, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsName", ".widgetMaster.ConsumableWidget.consumableName_mc", 0, 0, 0, 0, 0, 39, 16777215, "Right", true, false, true, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsCount", ".widgetMaster.ConsumableWidget.consumableCount_mc", 0, 0, 0, 0, 0, 40, 16777215, "Center", true, false, true, false, "Consumable")
	;Poison widget components
	AddWidget("$iEquip_WC_lbl_PoisonBg", ".widgetMaster.PoisonWidget.poisonBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonIcon", ".widgetMaster.PoisonWidget.poisonIcon_mc", 0, 0, 0, 0, 0, 42, 0, None, true, false, false, false, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonName", ".widgetMaster.PoisonWidget.poisonName_mc", 0, 0, 0, 0, 0, 43, 16777215, "Left", true, false, true, false, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonCount", ".widgetMaster.PoisonWidget.poisonCount_mc", 0, 0, 0, 0, 0, 44, 16777215, "Center", true, false, true, false, "Poison")
	debug.trace("iEquip_WidgetCore PopulateWidgetArrays end")
endFunction

function AddWidget( string sDescription, string sPath, float fX, float fY, float fS, float fR, float fA, int iD, int iTC, string sTA, bool bV, bool bIsParent, bool bIsText, bool bIsBg, string sGroup)
	debug.trace("iEquip_WidgetCore AddWidget start")
	int iIndex
	while iIndex < asWidgetDescriptions.Length && asWidgetDescriptions[iIndex] != ""
		iIndex += 1
	endWhile
	if iIndex >= asWidgetDescriptions.Length
		Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_failedToAddWidget{" + sDescription + "}"))
	else
		asWidgetDescriptions[iIndex] = sDescription
		asWidgetElements[iIndex] = sPath
		afWidget_X[iIndex] = fX
		afWidget_Y[iIndex] = fY
		afWidget_S[iIndex] = fS
		afWidget_R[iIndex] = fR
		afWidget_A[iIndex] = fA
		aiWidget_D[iIndex] = iD
		aiWidget_TC[iIndex] = iTC
		asWidget_TA[iIndex] = sTA
		abWidget_V[iIndex] = bV
		abWidget_isParent[iIndex] = bIsParent
		abWidget_isText[iIndex] = bIsText
		abWidget_isBg[iIndex] = bIsBg
		asWidgetGroup[iIndex] = sGroup
	endIf
	debug.trace("iEquip_WidgetCore AddWidget end")
endFunction

function getAndStoreDefaultWidgetValues()
	debug.trace("iEquip_WidgetCore getAndStoreDefaultWidgetValues start")
	afWidget_DefX = new float[46]
	afWidget_DefY = new float[46]
	afWidget_DefS = new float[46]
	afWidget_DefR = new float[46]
	afWidget_DefA = new float[46]
	aiWidget_DefD = new int[46]
	asWidget_DefTA = new string[46]
	aiWidget_DefTC = new int[46]
	abWidget_DefV = new bool[46]
	int iIndex
	string Element
	while iIndex < asWidgetDescriptions.Length
		Element = WidgetRoot + asWidgetElements[iIndex]
		afWidget_X[iIndex] = UI.GetFloat(HUD_MENU, Element + "._x")
		afWidget_Y[iIndex] = UI.GetFloat(HUD_MENU, Element + "._y")
		afWidget_S[iIndex] = UI.GetFloat(HUD_MENU, Element + "._xscale")
		afWidget_R[iIndex] = UI.GetFloat(HUD_MENU, Element + "._rotation")
		afWidget_A[iIndex] = UI.GetFloat(HUD_MENU, Element + "._alpha")
		
		afWidget_DefX[iIndex] = afWidget_X[iIndex]
		afWidget_DefY[iIndex] = afWidget_Y[iIndex]
		afWidget_DefS[iIndex] = afWidget_S[iIndex]
		afWidget_DefR[iIndex] = afWidget_R[iIndex]
		afWidget_DefA[iIndex] = afWidget_A[iIndex]
		aiWidget_DefD[iIndex] = aiWidget_D[iIndex]
		asWidget_DefTA[iIndex] = asWidget_TA[iIndex]
		aiWidget_DefTC[iIndex] = aiWidget_TC[iIndex]
		abWidget_DefV[iIndex] = abWidget_V[iIndex]
		iIndex += 1
	endWhile
	debug.trace("iEquip_WidgetCore getAndStoreDefaultWidgetValues end")
endFunction

function ResetWidgetArrays()
	debug.trace("iEquip_WidgetCore ResetWidgetArrays start")
	int iIndex
	while iIndex < asWidgetDescriptions.Length
		afWidget_X[iIndex] = afWidget_DefX[iIndex]
		afWidget_Y[iIndex] = afWidget_DefY[iIndex]
		afWidget_S[iIndex] = afWidget_DefS[iIndex]
		afWidget_R[iIndex] = afWidget_DefR[iIndex]
		afWidget_A[iIndex] = afWidget_DefA[iIndex]
		aiWidget_D[iIndex] = aiWidget_DefD[iIndex]

		asWidget_TA[iIndex] = asWidget_DefTA[iIndex]
		abWidget_V[iIndex] = abWidget_DefV[iIndex]
		iIndex += 1
	endWhile
	debug.trace("iEquip_WidgetCore ResetWidgetArrays end")
endFunction

function setCurrentQueuePosition(int Q, int iIndex)
	debug.trace("iEquip_WidgetCore setCurrentQueuePosition start")
	debug.trace("iEquip_WidgetCore setCurrentQueuePosition - Q: " + Q + ", iIndex: " + iIndex)
	if iIndex == -1
		iIndex = 0
	endIf
	aiCurrentQueuePosition[Q] = iIndex
	asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipName")
	debug.trace("iEquip_WidgetCore setCurrentQueuePosition end")
endFunction

bool function itemRequiresCounter(int Q, int itemType = -1, string itemName = "")
	debug.trace("iEquip_WidgetCore itemRequiresCounter start")
	bool requiresCounter
	int itemObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	if itemType == -1
		itemType = jMap.getInt(itemObject, "iEquipType")
	endIf
	if itemName == ""
		itemName = jMap.getStr(itemObject, "iEquipName")
	endIf
	debug.trace("iEquip_WidgetCore itemRequiresCounter itemType: " + itemType + ", itemName: " + itemName)
	if itemType == 42 || itemType == 23 || itemType == 31 ;Ammo (which takes in Throwing Weapons), scroll, torch
		requiresCounter = true
    elseif itemType == 4 && iEquip_FormExt.isGrenade(jMap.getForm(itemObject, "iEquipForm")) ;Looking for CACO grenades here which are classed as maces
    	requiresCounter = true
    else
    	requiresCounter = false
    endIf
    debug.trace("iEquip_WidgetCore itemRequiresCounter returning " + requiresCounter)
    debug.trace("iEquip_WidgetCore itemRequiresCounter end")
    return requiresCounter
endFunction

function setSlotCount(int Q, int count)
	debug.trace("iEquip_WidgetCore setSlotCount start")
	debug.trace("iEquip_WidgetCore setSlotCount - Q: " + Q + ", count: " + count)
	;int[] widgetData = new int[2]
	;widgetData[0] = Q
	;widgetData[1] = count
	;UI.invokeIntA(HUD_MENU, WidgetRoot + ".updateCounter", widgetData)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateCounter")
	If(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		UICallback.PushInt(iHandle, count) ;New count
		if Q == 3 && PO.bEnableRestorePotionWarnings
			int iPotionGroup = asPotionGroups.Find(asCurrentlyEquipped[3])
			UICallback.PushBool(iHandle, iPotionGroup > -1) ;isPotionGroup so we can set the early warning colour if needed
			if iPotionGroup > -1
				UICallback.PushInt(iHandle, PO.getRestoreCount(iPotionGroup))
			else
				UICallback.PushInt(iHandle, 0)
			endIf
			UICallback.PushInt(iHandle, aiWidget_TC[41]) ;Consumable Count text colour, used to reset to white/Edit Mode set colour if count is above 5, otherwise colour is handled by ActionScript
		else
			UICallback.PushBool(iHandle, false) ;Default to false for anything other than a Potion Group in Q == 3
			UICallback.PushInt(iHandle, 0) ;Not needed if Q != 3
			UICallback.PushInt(iHandle, 0) ;Not needed if Q != 3
		endIf
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_WidgetCore setSlotCount end")
endFunction

;-----------------------------------------------------------------------------------------------------------------------
;QUEUE FUNCTIONALITY CODE
;-----------------------------------------------------------------------------------------------------------------------

function cycleSlot(int Q, bool Reverse = false, bool ignoreEquipOnPause = false, bool onItemRemoved = false)
	debug.trace("iEquip_WidgetCore cycleSlot start")
	debug.trace("iEquip_WidgetCore cycleSlot - Q: " + Q + ", Reverse: " + Reverse)
	debug.trace("iEquip_WidgetCore cycleSlot - abIsNameShown[Q]: " + abIsNameShown[Q])
	;Q: 0 = Left hand, 1 = Right hand, 2 = Shout, 3 = Consumables, 4 = Poisons

	;Check if queue contains anything and return out if not
	int targetArray = aiTargetQ[Q]
	int queueLength = JArray.count(targetArray)
	debug.trace("iEquip_WidgetCore cycleSlot - queueLength: " + queueLength)
	if queueLength == 0
		debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[Q] + "}"))
	;if Preselect Mode is enabled then left/right/shout needs to cycle the preselect slot not the main widget. if shout preselect is disabled cycle main shout slot
	elseif (bPreselectMode && !bPreselectSwitchingHands && (Q < 2 || (Q == 2 && PM.bShoutPreselectEnabled))) || (Q == 0 && bAmmoMode)
		;if preselect name not shown then first cycle press shows name without advancing the queue
		debug.trace("iEquip_WidgetCore cycleSlot - abIsNameShown[Q + 5]: " + abIsNameShown[Q + 5])
		if bFirstPressShowsName && !abIsNameShown[Q + 5]
			showName(Q + 5)
		else
			if Q == 0 && bAmmoMode
				bCyclingLHPreselectInAmmoMode = true
			endIf
			PM.cyclePreselectSlot(Q, queueLength, Reverse)
		endIf
	;if name not shown then first cycle press shows name without advancing the queue
	elseif bFirstPressShowsName && !bPreselectSwitchingHands && !abIsNameShown[Q] && asCurrentlyEquipped[Q] != ""
		showName(Q)

	elseIf queueLength > 1 || onItemRemoved || (Q < 3 && abQueueWasEmpty[Q]) || (Q == 0 && bGoneUnarmed || b2HSpellEquipped)
		int	targetIndex
		form targetItem
	    string targetName

		if Q < 3
			abQueueWasEmpty[Q] = false
			;Hide the slot counter, poison info and charge meter if currently shown
			if Q < 2 
				setCounterVisibility(Q, false)
				hidePoisonInfo(Q)
				if CM.abIsChargeMeterShown[Q]
					CM.updateChargeMeterVisibility(Q, false)
				endIf
			endIf
		elseIf Q == 3
			CFUpdate.unregisterForConsumableFadeUpdate()
		endIf
		
		;Make sure we're starting from the correct index, in case somehow the queue has been amended without the aiCurrentQueuePosition array being updated
		if asCurrentlyEquipped[Q] != ""
			aiCurrentQueuePosition[Q] = findInQueue(Q, asCurrentlyEquipped[Q])
		endIf
		
		if queueLength > 1
			;Check if we're moving forwards or backwards in the queue
			int move = 1
			if Reverse
				move = -1
			endIf
			;Set the initial target index
			targetIndex = aiCurrentQueuePosition[Q] + move
			;Check if we're cycling past the first or last items in the queue and jump to the start/end as required
			if targetIndex < 0 && Reverse
				targetIndex = queueLength - 1
			elseif targetIndex == queueLength && !Reverse
				targetIndex = 0
			endIf
			;Check we're not trying to select the currently equipped item - only becomes relevant if we cycle through the entire queue or change direction and cycle back past where we started from (excludes potion and poison queues), or equip the same 1H item which is currently equipped in the other hand and 1H switchign disallowed, or we're in the consumables queue and we're checking for empty potion groups
			if Q < 4
		    	targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
			    if Q == 3
                    while (asPotionGroups.Find(targetName) > -1 && (!bPotionGrouping || (PO.iEmptyPotionQueueChoice == 1 && abPotionGroupEmpty[asPotionGroups.Find(targetName)])))
                        targetIndex = targetIndex + move
                        if targetIndex < 0 && Reverse
                            targetIndex = queueLength - 1
                        elseif targetIndex == queueLength && !Reverse
                            targetIndex = 0
                        endIf
                        targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
                    endWhile
			    else
			    	if !(Q == 1 && jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName") == "$iEquip_common_Unarmed")
			    		targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "iEquipForm")
			    		if Q < 2 && !jMap.getInt(jArray.getObj(targetArray, targetIndex), "iEquipType") == 22 && !bAllowWeaponSwitchHands
			    			int otherHand = (Q + 1) % 2
					        while targetItem == PlayerRef.GetEquippedObject(otherHand) && (PlayerRef.GetItemCount(targetItem) < 2)
					            targetIndex = targetIndex + move
					            if targetIndex < 0 && Reverse
					                targetIndex = queueLength - 1
					            elseif targetIndex == queueLength && !Reverse
					                targetIndex = 0
					            endIf
					            targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "iEquipForm")
					            targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
					        endWhile
					    endIf
				    endIf
			    endIf
		    endIf
			;if we're switching because of a hand to hand swap in EquipPreselectedItem then if the targetIndex matches the currently preselected item skip past it when advancing the main queue.
			if bPreselectSwitchingHands && targetIndex == aiCurrentlyPreselected[Q]
				targetIndex += 1
				if targetIndex == queueLength
					targetIndex = 0
				endIf
			endIf
		else
			targetIndex = 0
		endIf

		if Q < 2 && (bSwitchingHands || bPreselectSwitchingHands)
			debug.trace("iEquip_WidgetCore cycleSlot - Q: " + Q + ", bSwitchingHands: " + bSwitchingHands)
			ignoreEquipOnPause = true
			;if we're forcing the left hand to switch equipped items because we're switching left to right, make sure we don't leave the left hand unarmed
			if Q == 1
				int targetObject = jArray.getObj(targetArray, targetIndex)
				int itemType = jMap.getInt(targetObject, "iEquipType")
				AM.bAmmoModePending = false
				; Check if initial target item is 2h or ranged, or if it is a 1h item but you only have one of it and you've just equipped it in the other hand, or if it is unarmed
				if (itemType == 0 || ai2HWeaponTypes.Find(itemType) > -1 || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3 || ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(jMap.getForm(targetObject, "iEquipForm") as spell)) > -1) || ((asCurrentlyEquipped[0] == jMap.getStr(targetObject, "iEquipName")) && PlayerRef.GetItemCount(targetItem) < 2))
					int newIndex = targetIndex + 1
					if newIndex == queueLength
						newIndex = 0
					endIf
					bool matchFound
					; if it is then starting from the currently equipped index search forward for a 1h item
					while newIndex != targetIndex && !matchFound
						targetObject = jArray.getObj(targetArray, newIndex)
						itemType = jMap.getInt(targetObject, "iEquipType")
						; if the new target item is 2h or ranged, or if it is a 1h item but you only have one of it and it's already equipped in the other hand, or it is unarmed then move on again
						if (itemType == 0 || ai2HWeaponTypes.Find(itemType) > -1 || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3 || ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(jMap.getForm(targetObject, "iEquipForm") as spell)) > -1) || ((asCurrentlyEquipped[0] == jMap.getStr(targetObject, "iEquipName")) && PlayerRef.GetItemCount(jMap.getForm(targetObject, "iEquipForm")) < 2))
							newIndex += 1
							;if we have reached the final index in the array then loop to the start and keep counting forward until we reach the original starting point
							if newIndex == queueLength
								newIndex = 0
							endIf				
						else
							matchFound = true
						endIf
					endwhile
					; if no suitable items found in either search then don't re-equip anything 
					if !matchFound
						return
					else
						targetIndex = newIndex ; if a 1h item has been found then set it as the new targetIndex
					endIf
				endIf
			endIf
		elseIf Q == 4 && bPoisonIconFaded
			checkAndFadePoisonIcon(false)
			Utility.WaitMenuMode(0.3)
		endIf
		;Update the widget to the next queued item immediately then register for bEquipOnPause update or call cycle functions straight away
		aiCurrentQueuePosition[Q] = targetIndex
		asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
		updateWidget(Q, targetIndex, false, true)
		
		if Q < 2
			;if bEquipOnPause is enabled and you are cycling left/right/shout, and we're not ignoring bEquipOnPause because we're switching hands, then use the bEquipOnPause updates
			if !ignoreEquipOnPause && bEquipOnPause
				if Q == 0
					LHUpdate.registerForEquipOnPauseUpdate(Reverse)
				elseif Q == 1
					RHUpdate.registerForEquipOnPauseUpdate(Reverse)
				endIf
			;Otherwise carry on and equip/cycle
			else
				checkAndEquipShownHandItem(Q, Reverse)
			endIf
		else
			bool isPotionGroup
			if Q == 3 && asPotionGroups.Find(targetName) > -1
				isPotionGroup = true
				targetItem = none
			else
				targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "iEquipForm")
			endIf
			checkAndEquipShownShoutOrConsumable(Q, Reverse, targetIndex, targetItem, isPotionGroup)
		endIf
		debug.trace("iEquip_WidgetCore cycleSlot end")
	endIf
endFunction

function checkAndEquipShownHandItem(int Q, bool Reverse = false, bool equippingOnAutoAdd = false, bool calledByQuickRanged = false)
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem start")
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - Q: " + Q + ", Reverse: " + Reverse + ", equippingOnAutoAdd: " + equippingOnAutoAdd + ", calledByQuickRanged: " + calledByQuickRanged)
	int targetIndex = aiCurrentQueuePosition[Q]
	int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    Form targetItem = jMap.getForm(targetObject, "iEquipForm")
    int itemType = jMap.getInt(targetObject, "iEquipType")
    PM.bCurrentlyQuickRanged = false
    PM.bCurrentlyQuickHealing = false
    if itemType == 7 || itemType == 9
    	AM.checkAndRemoveBoundAmmo(itemType)
    endIf
    bool doneHere
    if !equippingOnAutoAdd
	    ;if we're equipping Fists
	    if Q == 1 && itemType == 0
			goUnarmed()
			doneHere = true  
	    ;if you already have the item/shout equipped in the slot you are cycling then refresh the poison, charge and count info and hide the attribute icons
	    elseif (targetItem == PlayerRef.GetEquippedObject(Q))
	    	hideAttributeIcons(Q)
	    	checkAndUpdatePoisonInfo(Q)
			CM.checkAndUpdateChargeMeter(Q)
			if itemRequiresCounter(Q, itemType)
				setCounterVisibility(Q, true)
			endIf
	    	doneHere = true
		;if somehow the item has been removed from the player and we haven't already caught it remove it from queue and advance queue again
		elseif !playerStillHasItem(targetItem)
			iEquip_AllCurrentItemsFLST.RemoveAddedForm(targetItem)
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			if bEnableRemovedItemCaching
				AddItemToLastRemovedCache(Q, targetIndex)
			endIf
			if bMoreHUDLoaded
		        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipItemID"))
		    endIf
			jArray.eraseIndex(aiTargetQ[Q], targetIndex)
			;if you are cycling backwards you have just removed the previous item in the queue so the aiCurrentQueuePosition needs to be updated before calling cycleSlot again
			if Reverse
				aiCurrentQueuePosition[Q] = aiCurrentQueuePosition[Q] - 1
			endIf
			cycleSlot(Q, Reverse)
			doneHere = true
		endIf
	endIf
	if !doneHere && targetItem
		debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - player still has item, Q: " + Q + ", aiCurrentQueuePosition: " + aiCurrentQueuePosition[Q] + ", itemName: " + jMap.getStr(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipName"))
		;if we're about to equip a ranged weapon and we're not already in Ammo Mode or we're switching ranged weapon type set the ammo queue to the first ammo in the array and then animate in if needed
		debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - bAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
		if Q == 1
			;if we're equipping a ranged weapon
			if (itemType == 7 || itemType == 9)
				;Firstly we need to update the relevant ammo list.  We'll update the widget once the weapon is equipped
				bool skipSetCount
				if !bAmmoMode
					if bLeftIconFaded
						checkAndFadeLeftIcon(1, 7)
						Utility.WaitMenuMode(0.2)
					endIf
					if !calledByQuickRanged
						AM.selectAmmoQueue(itemType)
					endIf
				elseif (AM.switchingRangedWeaponType(itemType) || AM.iAmmoListSorting == 3) && !calledByQuickRanged
					AM.selectAmmoQueue(itemType)
					AM.checkAndEquipAmmo(false, true, false)
					skipSetCount = true
				endIf
				;if we are already in Ammo Mode or Preselect Mode we're switching from a bow to a crossbow or vice versa so we need to update the ammo widget
				if bAmmoMode || bPreselectMode
					updateWidget(0, AM.aiCurrentAmmoIndex[AM.Q])
					if !skipSetCount
						setSlotCount(0, PlayerRef.GetItemCount(AM.currentAmmoForm))
					endIf
				else
					AM.toggleAmmoMode(false, equippingOnAutoAdd) ;Animate in without any equipping/unequipping if equippingOnAutoAdd
				endIf
				if !isWeaponPoisoned(1, aiCurrentQueuePosition[1])
					setCounterVisibility(1, false)
				endIf
			;if we're already in Ammo Mode and about to equip something in the right hand which is not another ranged weapon then we need to toggle out of Ammo Mode
			elseIf bAmmoMode
				;Animate out without equipping the left hand item, we'll handle this later once right hand re-equipped
				AM.toggleAmmoMode(false, true)
				;if we've still got the shown ammo equipped and have enabled Unequip Ammo in the MCM then unequip it now
				ammo currentAmmo = AM.currentAmmoForm as Ammo
				if currentAmmo && PlayerRef.isEquipped(currentAmmo) && bUnequipAmmo
					PlayerRef.UnequipItemEx(currentAmmo)
				endIf
				bJustLeftAmmoMode = true
			endIf
			;if we're equipping a 2H item in the right hand from bGoneUnarmed then we need to update the left slot back to the item prior to going unarmed before fading the left icon if required
			if (bGoneUnarmed || b2HSpellEquipped) && (itemType == 5 || itemType == 6)
	    		updateWidget(0, aiCurrentQueuePosition[0])
	    		targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
	    		if itemRequiresCounter(0, jMap.getInt(targetObject, "iEquipType"))
					setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "iEquipForm")))
					setCounterVisibility(0, true)
				endIf
	    	endIf
		endIf
		;if we're cyling left or right and not in Ammo Mode check if new item requires a counter
		if !bAmmoMode
			if itemRequiresCounter(Q, itemType)
				;Update the item count
				setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
				;Show the counter if currently hidden
				setCounterVisibility(Q, true)
			;The new item doesn't require a counter to hide it if it's currently shown
			else
				setCounterVisibility(Q, false)
			endIf
		endIf
		;Now that we've passed all the checks we can carry on and equip
		cycleHand(Q, targetIndex, targetItem, itemType, equippingOnAutoAdd)
		Utility.WaitMenuMode(0.2)
		if bJustLeftAmmoMode
			bJustLeftAmmoMode = false
			Utility.WaitMenuMode(0.3)
		endIf
		checkAndFadeLeftIcon(Q, itemType)
	endIf
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem end")
endFunction

function checkAndFadeLeftIcon(int Q, int itemType)
	debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon start")
	debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon - Q: " + Q + ", itemType: " + itemType + ", bFadeLeftIconWhen2HEquipped: " + bFadeLeftIconWhen2HEquipped + ", bLeftIconFaded: " + bLeftIconFaded + ", AM.bAmmoModePending: " + AM.bAmmoModePending)
	;if we're equipping 2H or ranged then check and fade left icon
	float[] widgetData = new float[8]
	if Q == 1 && bFadeLeftIconWhen2HEquipped && (itemType == 5 || itemType == 6) && !bLeftIconFaded
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01))
		widgetData[0] = afWidget_A[6] * adjustment ;leftBg_mc
		widgetData[1] = afWidget_A[7] * adjustment ;leftIcon_mc
		if abIsNameShown[0]
			widgetData[2] = afWidget_A[8] * adjustment ;leftName_mc
		endIf
		if abIsCounterShown[0]
			widgetData[3] = afWidget_A[9] * adjustment ;leftCount_mc
		endIf
		if isWeaponPoisoned(0, aiCurrentQueuePosition[0])
			widgetData[4] = afWidget_A[10] * adjustment ;leftPoisonIcon_mc
			if abIsPoisonNameShown[0]
				widgetData[5] = afWidget_A[11] * adjustment ;leftPoisonName_mc
			endIf
		endIf
		if CM.abIsChargeMeterShown[0]
			if CM.iChargeDisplayType == 1
				widgetData[7] = afWidget_A[13] * adjustment ;leftEnchantmentMeter_mc
			else
				widgetData[6] = 1
				widgetData[7] = afWidget_A[14] * adjustment ;leftSoulgem_mc
			endIf
		endIf
		debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon - should be fading out")
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		bLeftIconFaded = true
	;For anything else check if it is currently faded and if so fade it back in
	elseif Q < 2 && bLeftIconFaded && !AM.bAmmoModePending
		widgetData[0] = afWidget_A[6]
		widgetData[1] = afWidget_A[7]
		if abIsNameShown[0]
			widgetData[2] = afWidget_A[8]
		endIf
		if abIsCounterShown[0]
			widgetData[3] = afWidget_A[9]
		endIf
		if isWeaponPoisoned(0, aiCurrentQueuePosition[0])
			widgetData[4] = afWidget_A[10]
			if abIsPoisonNameShown[0]
				widgetData[5] = afWidget_A[11]
			endIf
		endIf
		if CM.abIsChargeMeterShown[0]
			if CM.iChargeDisplayType == 1
				widgetData[7] = afWidget_A[13]
			else
				widgetData[6] = 1
				widgetData[7] = afWidget_A[14]
			endIf
		endIf
		debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon - should be fading in")
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		bLeftIconFaded = false
	endIf
	debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon end")
endFunction

function checkAndEquipShownShoutOrConsumable(int Q, bool Reverse, int targetIndex, form targetItem, bool isPotionGroup)
	debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable start")
	debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", isPotionGroup: " + isPotionGroup)
	if (targetItem && !playerStillHasItem(targetItem)) || (Q == 3 && !targetItem && !isPotionGroup)
		if bEnableRemovedItemCaching
			AddItemToLastRemovedCache(Q, targetIndex)
		endIf
		if bMoreHUDLoaded
	        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipItemID"))
	    endIf
		jArray.eraseIndex(aiTargetQ[Q], targetIndex)
		;if you are cycling backwards you have just removed the previous item in the queue so the aiCurrentQueuePosition needs to be updated before calling cycleSlot again
		if Reverse
			aiCurrentQueuePosition[Q] = aiCurrentQueuePosition[Q] - 1
		endIf
		cycleSlot(Q, Reverse)
	else
		if Q == 2 && bShoutEnabled && !(targetItem == PlayerRef.GetEquippedShout())
			;aiIndexOnStartCycle[2] = -1 ;Reset ready for next cycle
			cycleShout(Q, targetIndex, targetItem)
		elseif Q == 3 && bConsumablesEnabled
			cycleConsumable(targetItem, targetIndex, isPotionGroup)
		elseif Q == 4 && bPoisonsEnabled
			cyclePoison(targetItem)
		else
			debug.trace("iEquip_WidgetCore - Something went wrong!")
		endIf
	endIf
	debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable end")
endFunction

function checkAndFadeConsumableIcon(bool fadeOut)
	debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon start")
	debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon - fadeOut: " + fadeOut + ", bConsumableIconFaded: " + bConsumableIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01)) ;Use same value as left icon fade for consistency
		widgetData[0] = afWidget_A[38] * adjustment ;consumableBg_mc
		widgetData[1] = afWidget_A[39] * adjustment ;consumableIcon_mc
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[40] * adjustment ;consumableName_mc
		endIf
		widgetData[3] = afWidget_A[41]  * adjustment ;consumableCount_mc
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		bConsumableIconFaded = true
	;For anything else fade it back in (we've already checked if it needs fading or not before calling this function)
	else
		widgetData[0] = afWidget_A[38]
		widgetData[1] = afWidget_A[39]
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[40]
		endIf
		widgetData[3] = afWidget_A[41]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		bConsumableIconFaded = false
	endIf
	debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon end")
endFunction

function checkAndFadePoisonIcon(bool fadeOut)
	debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon start")
	debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon - fadeOut: " + fadeOut + ", bPoisonIconFaded: " + bPoisonIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01)) ;Use same value as left icon fade for consistency
		widgetData[0] = afWidget_A[42] * adjustment ;poisonBg_mc
		widgetData[1] = afWidget_A[43] * adjustment ;poisonIcon_mc
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[44] * adjustment ;poisonName_mc
		endIf
		widgetData[3] = afWidget_A[45]  * adjustment ;poisonCount_mc
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenPoisonIconAlpha", widgetData)
		bPoisonIconFaded = true
	;For anything else fade it back in (we've already checked if it needs fading or not before calling this function)
	else
		widgetData[0] = afWidget_A[42]
		widgetData[1] = afWidget_A[43]
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[44]
		endIf
		widgetData[3] = afWidget_A[45]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenPoisonIconAlpha", widgetData)
		bPoisonIconFaded = false
	endIf
	debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon end")
endFunction

function setCounterVisibility(int Q, bool show)
	debug.trace("iEquip_WidgetCore setCounterVisibility start")
	debug.trace("iEquip_WidgetCore setCounterVisibility - Q: " + Q + ", show: " + show)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetCounterAlpha")
	if iHandle && (show || abIsCounterShown[Q])
		UICallback.PushInt(iHandle, Q) ;Which counter _mc we're fading out
		if show && !abIsCounterShown[Q]
			float targetAlpha = afWidget_A[aiCounterClips[Q]] ;Left count alpha
			if targetAlpha < 1
				targetAlpha = 100
			endIf
			abIsCounterShown[Q] = true
			UICallback.PushFloat(iHandle, targetAlpha) ;Target alpha
		else
			abIsCounterShown[Q] = false
			UICallback.PushFloat(iHandle, 0) ;Target alpha
		endIf
		UICallback.PushFloat(iHandle, 0.15) ;Fade duration
		UICallback.Send(iHandle)
	endIf
	debug.trace("iEquip_WidgetCore setCounterVisibility end")
endFunction

function updateSlotsEnabled()
	debug.trace("iEquip_WidgetCore updateSlotsEnabled start")
	debug.trace("iEquip_WidgetCore updateSlotsEnabled - bShoutEnabled: " + bShoutEnabled + ", bConsumablesEnabled: " + bConsumablesEnabled + ", bPoisonsEnabled: " + bPoisonsEnabled)
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", bShoutEnabled)
	abWidget_V[3] = bShoutEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ConsumableWidget._visible", bConsumablesEnabled)
	abWidget_V[4] = bConsumablesEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget._visible", bPoisonsEnabled)
	abWidget_V[5] = bPoisonsEnabled
	EH.bPoisonSlotEnabled = bPoisonsEnabled
	;Hide poison indicators, counts and names
	if !bPoisonsEnabled
		hidePoisonInfo(0)
		hidePoisonInfo(1)
	endIf
	debug.trace("iEquip_WidgetCore updateSlotsEnabled end")
endFunction

function updateWidget(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	debug.trace("iEquip_WidgetCore updateWidget start")
	debug.trace("iEquip_WidgetCore updateWidget - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bPreselectSwitchingHands: " + bPreselectSwitchingHands + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	;if we are in Preselect Mode make sure we update the preselect icon and name, otherwise update the main icon and name
	string sIcon
	string sName
	int targetObject
	int Slot = Q

	if bRefreshingWidgetOnLoad && Q > 4
		debug.trace("iEquip_WidgetCore updateWidget - 1st option")
		targetObject = jArray.getObj(aiTargetQ[Q - 5], iIndex)
	elseif (bPreselectMode && !overridePreselect && !bPreselectSwitchingHands && (Q < 2 || Q == 2 && PM.bShoutPreselectEnabled)) || bCyclingLHPreselectInAmmoMode
		debug.trace("iEquip_WidgetCore updateWidget - 2nd option")
		Slot += 5
		targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentlyPreselected[Q])
	elseif Q == 0 && bAmmoMode
		debug.trace("iEquip_WidgetCore updateWidget - 3rd option")
		targetObject = AM.getCurrentAmmoObject()
	else
		debug.trace("iEquip_WidgetCore updateWidget - 4th option")
		targetObject = jArray.getObj(aiTargetQ[Q], iIndex)
	endIf
	sIcon = jMap.getStr(targetObject, "iEquipIcon")
	sName = jMap.getStr(targetObject, "iEquipName")
	if Q == 0 && bAmmoMode && !bCyclingLHPreselectInAmmoMode && AM.sAmmoIconSuffix != ""
		sIcon += AM.sAmmoIconSuffix
	endIf

	float fNameAlpha = afWidget_A[aiNameElements[Slot]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	debug.trace("iEquip_WidgetCore updateWidget about to call .updateWidget - Slot: " + Slot + ", sIcon: " + sIcon + ", sName: " + sName + ", fNameAlpha: " + fNameAlpha)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Slot) ;Which slot we're updating
		UICallback.PushString(iHandle, sIcon) ;New icon
		UICallback.PushString(iHandle, sName) ;New name
		UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
		UICallback.Send(iHandle)
	endIf

	if Q < 2 || Q == 5 || Q == 6
		updateAttributeIcons(Q, iIndex, overridePreselect, cycling)
	endIf

	if bNameFadeoutEnabled
		if Slot == 0
			LNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 1
			RNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 2
			SNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 3
			CNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 4
			PNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 5
			LPNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 6
			RPNUpdate.registerForNameFadeoutUpdate()
		elseif Slot == 7
			SPNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
	debug.trace("iEquip_WidgetCore updateWidget end")
endFunction

function updateWidgetBM(int Q, string sIcon, string sName)
	debug.trace("iEquip_WidgetCore updateWidgetBM start")

	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	debug.trace("iEquip_WidgetCore updateWidgetBM about to call .updateWidget - Slot: " + Q + ", sIcon: " + sIcon + ", sName: " + sName + ", fNameAlpha: " + fNameAlpha)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		UICallback.PushString(iHandle, sIcon) ;New icon
		UICallback.PushString(iHandle, sName) ;New name
		UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
		UICallback.Send(iHandle)
	endIf

	if bNameFadeoutEnabled
		if Q == 0
			LNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 1
			RNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 2
			SNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
	debug.trace("iEquip_WidgetCore updateWidgetBM end")
endFunction

function setSlotToEmpty(int Q, bool hidePoisonCount = true, bool leaveFlag = false)
	debug.trace("iEquip_WidgetCore setSlotToEmpty start")
	debug.trace("iEquip_WidgetCore setSlotToEmpty - Q: "+Q+", hidePoisonCount: "+hidePoisonCount+", LeaveFlag: "+LeaveFlag)
	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	; Set icon and name to empty
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		if (Q == 0 && !bAmmoMode) || Q == 1
			debug.trace("iEquip_WidgetCore setSlotToEmpty - should be setting "+asQueueName[Q]+" to Unarmed")
			UICallback.PushString(iHandle, "Fist") ;New icon
			UICallback.PushString(iHandle, "$iEquip_common_Unarmed") ;New name
		else
			debug.trace("iEquip_WidgetCore setSlotToEmpty - should be setting "+asQueueName[Q]+" to Empty")
			UICallback.PushString(iHandle, "Empty") ;New icon
			UICallback.PushString(iHandle, "") ;New name
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
		UICallback.Send(iHandle)
	endIf
	if (Q != 3 || !bPotionGrouping)
		asCurrentlyEquipped[Q] = ""
	endIf
	; Hide any additional elements currently displayed
	if Q < 2
		hidePoisonInfo(Q, true)
		if CM.abIsChargeMeterShown[Q]
			CM.updateChargeMeterVisibility(Q, false)
		endIf
		setCounterVisibility(Q, false)
		if Q == 1
			if bAmmoMode
				AM.toggleAmmoMode()
			elseIf bLeftIconFaded
				checkAndFadeLeftIcon(0, 0)
			endIf
		endIf
	elseIf Q == 3
		UI.SetString(HUD_MENU, WidgetRoot + ".widgetMaster.ConsumableWidget.consumableCount_mc.consumableCount.text", "")
	elseIf Q == 4 && hidePoisonCount
		UI.SetString(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget.poisonCount_mc.poisonCount.text", "")
	elseIf Q == 5 || Q == 6
		hideAttributeIcons(Q)
	endIf
	if Q < 3 && !leaveFlag
		abQueueWasEmpty[Q] = true
	endIf
	debug.trace("iEquip_WidgetCore setSlotToEmpty end")
endFunction

function handleEmptyPoisonQueue()
	debug.trace("iEquip_WidgetCore handleEmptyPoisonQueue start")
	float fNameAlpha = afWidget_A[aiNameElements[4]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	;Hide the count by setting it to an empty string
	UI.SetString(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget.poisonCount_mc.poisonCount.text", "")
	asCurrentlyEquipped[4] = ""
	; Set to generic poison icon and name to empty before flashing/fading/hiding
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 4) ;Which slot we're updating
		UICallback.PushString(iHandle, "Poison") ;New icon
		UICallback.PushString(iHandle, "") ;New name
		UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
		UICallback.Send(iHandle)
	endIf
	if PO.bFlashPotionWarning
		UI.Invoke(HUD_MENU, WidgetRoot + ".runPoisonFlashAnimation")
		Utility.WaitMenuMode(1.2)
	endIf
	if PO.iEmptyPotionQueueChoice == 0 ;Fade icon
		checkAndFadePoisonIcon(true)
	else
		setSlotToEmpty(4, false)
	endIf
	debug.trace("iEquip_WidgetCore handleEmptyPoisonQueue end")
endFunction

function checkIfBoundSpellEquipped()
	debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped start")
	bool boundSpellEquipped
	int hand
	while hand < 2
		if PlayerRef.GetEquippedItemType(hand) == 9 && (iEquip_SpellExt.IsBoundSpell(PlayerRef.GetEquippedSpell(hand)) || (Game.GetModName(PlayerRef.GetEquippedObject(hand).GetFormID() / 0x1000000) == "Bound Shield.esp"))
			boundSpellEquipped = true
		endIf
		hand += 1
	endWhile
	debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped called - boundSpellEquipped: " + boundSpellEquipped)
	;If the player has a bound spell equipped in either hand the event handler script registers for ActorAction 2 - Spell Fire, if not it unregisters for the action
	EH.boundSpellEquipped = boundSpellEquipped
	debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped end")
endFunction

;Called from iEquip_PlayerEventHandler when OnActorAction receives actionType 2 (should only ever happen when the player has a 'Bound' spell equipped in either hand)
function onBoundWeaponEquipped(Int weaponType, Int hand)
	debug.trace("iEquip_WidgetCore onBoundWeaponEquipped start")
	string iconName = "Bound"
	if weaponType == 6 && (PlayerRef.GetEquippedObject(hand) as Weapon).IsWarhammer()
        iconName += "Warhammer"
    elseIf weaponType == 26
    	iconName += "Shield"
    elseIf iEquip_FormExt.IsSpear(PlayerRef.GetEquippedObject(hand))
    	iconName += "Spear"
    else
		iconName += asWeaponTypeNames[weaponType]
    endIf
    debug.trace("iEquip_WidgetCore onBoundWeaponEquipped - iconName: " + iconName + ", weaponType: " + weaponType)
    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
	;Replace the spell icon with the correct bound weapon icon without updating the name as it should be the same anyway
	if(iHandle)
		UICallback.PushInt(iHandle, hand) ;Target icon to update: left = 0, right  = 1
		UICallback.PushString(iHandle, iconName) ;New icon label name
		UICallback.Send(iHandle)
	endIf
	;Now if we've equipped a bound ranged weapon we need to toggle Ammo Mode and show bound ammo in the left slot
    if weaponType == 7 || weaponType == 9 ;Bound Bow or Bound Crossbow
    	AM.onBoundRangedWeaponEquipped(weaponType)
    elseIf weaponType == 5 || weaponType == 6 ;Bound 2H weapon
    	checkAndFadeLeftIcon(hand, weaponType)
	endIf
	debug.trace("iEquip_WidgetCore onBoundWeaponEquipped end")
endFunction

function onBoundWeaponUnequipped(int hand, bool isBoundShield = false)
	debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped start")
	debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped - bBlockSwitchBackToBoundSpell: " + bBlockSwitchBackToBoundSpell)
	if bBlockSwitchBackToBoundSpell
		bBlockSwitchBackToBoundSpell = false
	else
		if PlayerRef.GetEquippedItemType(hand) == 9 && (iEquip_SpellExt.IsBoundSpell(PlayerRef.GetEquippedObject(hand) as spell) || isBoundShield) && (PlayerRef.GetEquippedObject(hand).GetName() == asCurrentlyEquipped[hand])
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
			;Switch back to the spell icon from the bound weapon icon without updating the name as it should be the same anyway
			if(iHandle)
				UICallback.PushInt(iHandle, hand) ;Target icon to update: left = 0, right  = 1
				UICallback.PushString(iHandle, "Conjuration") ;New icon label name
				UICallback.Send(iHandle)
			endIf
			if bAmmoMode
				AM.toggleAmmoMode(bPreselectMode && PM.abPreselectSlotEnabled[0])
			endIf
			if bLeftIconFaded
				checkAndFadeLeftIcon(hand, 9)
			endIf
		else
			debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped - couldn't match removed bound weapon to an equipped spell")
		endIf
	endIf
	debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped end")
endFunction

function showName(int Q, bool fadeIn = true, bool targetingPoisonName = false, float fadeoutDuration = 0.3)
	debug.trace("iEquip_WidgetCore showName start")
	debug.trace("iEquip_WidgetCore showName, Q: " + Q + ", fadeIn: " + fadeIn + ", targetingPoisonName: " + targetingPoisonName + ", fadeoutDuration: " + fadeoutDuration) 

	float fNameAlpha
	if !fadeIn
		if targetingPoisonName
			abIsPoisonNameShown[Q] = false
		else
			abIsNameShown[Q] = false
		endIf
	else
		if targetingPoisonName
			fNameAlpha = afWidget_A[aiPoisonNameElements[Q]]
		else
			fNameAlpha = afWidget_A[aiNameElements[Q]]
		endIf
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		if Q == 0 && bLeftIconFaded
			if targetingPoisonName
				fNameAlpha = afWidget_A[11] * (1 - (fLeftIconFadeAmount * 0.01))
			else
				fNameAlpha = afWidget_A[8] * (1 - (fLeftIconFadeAmount * 0.01))
			endIf
		endIf
		if targetingPoisonName
			abIsPoisonNameShown[Q] = true
		else
			abIsNameShown[Q] = true
		endIf
	endIf

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetNameAlpha")
	if(iHandle)
		if targetingPoisonName
			UICallback.PushInt(iHandle, aiPoisonNameElements[Q]) ;Which _mc we're fading out
		else
			UICallback.PushInt(iHandle, aiNameElements[Q]) ;Which _mc we're fading out
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha) ;Target alpha which for FadeOut is 0
		UICallback.PushFloat(iHandle, fadeoutDuration) ;FadeOut duration
		UICallback.Send(iHandle)
	endIf

	if bNameFadeoutEnabled && !EM.isEditMode
		if Q == 0
			if targetingPoisonName
				LPoisonNUpdate.registerForNameFadeoutUpdate()
			else
				LNUpdate.registerForNameFadeoutUpdate()
			endIf
		elseif Q == 1
			if targetingPoisonName
				RPoisonNUpdate.registerForNameFadeoutUpdate()
			else
				RNUpdate.registerForNameFadeoutUpdate()
			endIf
		elseif Q == 2
			SNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 3
			CNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 4
			PNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 5
			LPNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 6
			RPNUpdate.registerForNameFadeoutUpdate()
		elseif Q == 7
			SPNUpdate.registerForNameFadeoutUpdate()
		endIf
	else
		if Q == 0
			if targetingPoisonName
				LPoisonNUpdate.unregisterForNameFadeoutUpdate()
			else
				LNUpdate.unregisterForNameFadeoutUpdate()
			endIf
		elseif Q == 1
			if targetingPoisonName
				RPoisonNUpdate.unregisterForNameFadeoutUpdate()
			else
				RNUpdate.unregisterForNameFadeoutUpdate()
			endIf
		elseif Q == 2
			SNUpdate.unregisterForNameFadeoutUpdate()
		elseif Q == 3
			CNUpdate.unregisterForNameFadeoutUpdate()
		elseif Q == 4
			PNUpdate.unregisterForNameFadeoutUpdate()
		elseif Q == 5
			LPNUpdate.unregisterForNameFadeoutUpdate()
		elseif Q == 6
			RPNUpdate.unregisterForNameFadeoutUpdate()
		elseif Q == 7
			SPNUpdate.unregisterForNameFadeoutUpdate()
		endIf
	endIf
	debug.trace("iEquip_WidgetCore showName end")
endFunction

function updateAttributeIcons(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	debug.trace("iEquip_WidgetCore updateAttributeIcons start")
	debug.trace("iEquip_WidgetCore updateAttributeIcons - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	if bShowAttributeIcons
		string sAttributes
		bool isPoisoned
		bool isEnchanted
		int targetObject = -1
		int Slot = Q
		if bRefreshingWidgetOnLoad && Q > 4 && Q < 7
			if bPreselectMode
				;debug.trace("iEquip_WidgetCore updateAttributeIcons - 1st option")
				targetObject = jArray.getObj(aiTargetQ[Q - 5], iIndex)
			endIf
		elseif (bPreselectMode && !overridePreselect && !bPreselectSwitchingHands && Q <= 2) || bCyclingLHPreselectInAmmoMode
			;debug.trace("iEquip_WidgetCore updateAttributeIcons - 2nd option")
			Slot += 5
			targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentlyPreselected[Q])
			bCyclingLHPreselectInAmmoMode = false
		else
			if Q < 2
				;debug.trace("iEquip_WidgetCore updateAttributeIcons - 3rd option")
				targetObject = jArray.getObj(aiTargetQ[Q], iIndex)
			endIf
		endIf
		if targetObject == -1 || (Q == 0 && bAmmoMode)
			isPoisoned = false
			isEnchanted = false
		else
			isPoisoned = jMap.getInt(targetObject, "isPoisoned") as bool
			isEnchanted = jMap.getInt(targetObject, "isEnchanted") as bool
		endIf

		if (cycling && ((Slot == 0 && !bAmmoMode) || Slot == 1)) || (Slot == 5 || Slot == 6)
			if isPoisoned
				if isEnchanted
					sAttributes = "Both"
				else
					sAttributes = "Poisoned"
				endIf
			elseif isEnchanted
				sAttributes = "Enchanted"
			else
				sAttributes = "hidden"
			endIf
			debug.trace("iEquip_WidgetCore updateAttributeIcons - about to update icons in Slot " + Slot + " to " + sAttributes)
			int iHandle2 = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
			if(iHandle2)
				UICallback.PushInt(iHandle2, Slot) ;Which slot we're updating
				UICallback.PushString(iHandle2, sAttributes) ;New attributes
				UICallback.Send(iHandle2)
			endif
		endIf
	else
		bCyclingLHPreselectInAmmoMode = false
	endIf
	debug.trace("iEquip_WidgetCore updateAttributeIcons end")
endFunction

function hideAttributeIcons(int Q)
	debug.trace("iEquip_WidgetCore hideAttributeIcons start")
	debug.trace("iEquip_WidgetCore hideAttributeIcons - Q: "+ Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		UICallback.PushString(iHandle, "hidden") ;New attributes
		UICallback.Send(iHandle)
	endif
	debug.trace("iEquip_WidgetCore hideAttributeIcons end")
endFunction

int function findInQueue(int Q, string itemToFind)
	debug.trace("iEquip_WidgetCore findInQueue start")
	int iIndex
	bool found
	while iIndex < jArray.count(aiTargetQ[Q]) && !found
		if itemToFind != jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipName")
			iIndex += 1
		else
			found = true
		endIf
	endwhile
	debug.trace("iEquip_WidgetCore findInQueue end")
	if found
		return iIndex
	else
		return -1
	endIf
endFunction

function removeItemFromQueue(int Q, int iIndex, bool purging = false, bool cyclingAmmo = false, bool onItemRemoved = false, bool addToCache = true)
	debug.trace("iEquip_WidgetCore removeItemFromQueue start")
	debug.trace("iEquip_WidgetCore removeItemFromQueue - Q: " + Q + ", iIndex: " + iIndex + ", purging: " + purging + ", cyclingAmmo: " + cyclingAmmo + ", onItemRemoved: " + onItemRemoved + ", addToCache: " + addToCache)
	if bEnableRemovedItemCaching && addToCache && !purging
		AddItemToLastRemovedCache(Q, iIndex)
	endIf
	if bMoreHUDLoaded
		int otherHand = (Q + 1) % 2
		AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipItemID"))
		if Q < 2 && findInQueue(otherHand, jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipName")) != -1
			AhzMoreHudIE.AddIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipItemID"), asMoreHUDIcons[otherHand])
        endIf
    endIf
    int itemType = jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipType")
	jArray.eraseIndex(aiTargetQ[Q], iIndex)
	int queueLength = jArray.count(aiTargetQ[Q])
	int enabledPotionGroupCount = 0
	if Q == 3 && bPotionGrouping && PO.iEmptyPotionQueueChoice != 1
        int i 
        while i < 3
            if !abPotionGroupEmpty[i]
                enabledPotionGroupCount += 1
            endIf
            i += 1
        endWhile
	endIf
	debug.trace("iEquip_WidgetCore removeItemFromQueue - queueLength: " + queueLength + ", enabledPotionGroupCount: " + enabledPotionGroupCount)
	;In the case of the consumables queue count will never drop below 3 because of the Potion Group slots, so either count has to be greater than 3 or at least one of the Potion Groups needs to be shown, otherwise hide the consumable widget
	if (Q != 3 && queueLength > 0) || (Q == 3 && (queueLength > 3 || enabledPotionGroupCount > 0))
		if aiCurrentQueuePosition[Q] > iIndex ;if the item being removed is before the currently equipped item in the queue update the index for the currently equipped item
			debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] > iIndex")
			aiCurrentQueuePosition[Q] = aiCurrentQueuePosition[Q] - 1
		elseif aiCurrentQueuePosition[Q] == iIndex ;if you have removed the currently equipped item then if it was the last in the queue advance to index 0 and cycle the slot
			debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] == iIndex")
			if aiCurrentQueuePosition[Q] == queueLength
				debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] == queueLength")
				aiCurrentQueuePosition[Q] = 0
			endIf
			if !cyclingAmmo
				bool actionTaken
				if Q == 1 && (itemType == 7 || itemType == 9)
					 actionTaken = PM.quickRangedFindAndEquipWeapon(itemType, false)
				elseIf Q == 0 && itemType == 26
					PM.quickShield(true)
					actionTaken = true
				endIf
				if !actionTaken
					cycleSlot(Q, false, true, onItemRemoved)
				endIf
			endIf
		endIf
	;Handle empty queue
	else
		;Empty poison queue has to match the behaiour of the potion groups in the consumables queue, so if any grouping is enabled check for fade/flash settings and mirror them
		if (Q == 4 && bPotionGrouping)
			handleEmptyPoisonQueue()
		else
			aiCurrentQueuePosition[Q] = -1
			asCurrentlyEquipped[Q] = ""
			setSlotToEmpty(Q)
		endIf
	endIf
	if Q < 3 && bProModeEnabled
		if queueLength < 2
			setSlotToEmpty(Q + 5)
		elseIf aiCurrentlyPreselected[Q] == iIndex
			PM.cyclePreselectSlot(Q, jArray.count(aiTargetQ[Q]))
		endIf
	endIf
	debug.trace("iEquip_WidgetCore removeItemFromQueue end")
endFunction

function reduceMaxQueueLength()
	debug.trace("iEquip_WidgetCore reduceMaxQueueLength start")
	if iMaxQueueLength < 3 && bPreselectMode
		PM.togglePreselectMode()
	endIf
	int i
	int currentLength
	while i < 5
		currentLength = jArray.count(aiTargetQ[i])
		if currentLength > iMaxQueueLength
			if i < 3 || bHardLimitQueueSize
				jArray.eraseRange(aiTargetQ[i], iMaxQueueLength, -1)
			endIf
		endIf
		i += 1
	endWhile
	debug.trace("iEquip_WidgetCore reduceMaxQueueLength end")
endFunction

function AddItemToLastRemovedCache(int Q, int iIndex)
	debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache start")
	if jArray.count(iRemovedItemsCacheObj) == iMaxCachedItems ;Max number of removed items to cache for re-adding
		iEquip_RemovedItemsFLST.RemoveAddedForm(jMap.getForm(jArray.getObj(iRemovedItemsCacheObj, 0), "iEquipForm"))
		jArray.eraseIndex(iRemovedItemsCacheObj, 0)
	endIf
	int objToCache = jArray.getObj(aiTargetQ[Q], iIndex)
	jMap.setInt(objToCache, "PrevQ", Q)
	jArray.addObj(iRemovedItemsCacheObj, objToCache)
	iEquip_RemovedItemsFLST.AddForm(jMap.getForm(objToCache, "iEquipForm"))
	debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache end")
endFunction

function addBackCachedItem(form addedForm)
	debug.trace("iEquip_WidgetCore addBackCachedItem start")
	int iIndex
	int targetObject
	bool found
	while iIndex < jArray.count(iRemovedItemsCacheObj) && !found
		targetObject = jArray.getObj(iRemovedItemsCacheObj, iIndex)
		if addedForm == jMap.getForm(targetObject, "iEquipForm")
			int Q
			int itemType = jMap.getInt(targetObject, "iEquipType")
			;Check if the re-added item has been equipped in either hand and set that as the target queue
			if PlayerRef.GetEquippedObject(0) == addedForm && ai2HWeaponTypes.Find(itemType) == -1
				Q = 0
			elseIf PlayerRef.GetEquippedObject(1) == addedForm
				Q = 1
			;Otherwise add the item back into the queue it was previously removed from
			else
				Q = jMap.getInt(targetObject, "PrevQ")
			endIf
			jArray.addObj(aiTargetQ[Q], targetObject)
			;Remove the form from the RemovedItems formlist
			iEquip_RemovedItemsFLST.RemoveAddedForm(jMap.getForm(targetObject, "iEquipForm"))
			;Add it back into the AllCurrentItems formlist
			iEquip_AllCurrentItemsFLST.AddForm(jMap.getForm(targetObject, "iEquipForm"))
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			;Add it back to the moreHUD array
			if bMoreHUDLoaded
				AhzMoreHudIE.AddIconItem(jMap.getInt(targetObject, "iEquipItemID"), asMoreHUDIcons[jMap.getInt(targetObject, "PrevQ")])
    		endIf
			;Remove the cached object from the cache jArray
			jArray.eraseIndex(iRemovedItemsCacheObj, iIndex)
			found = true
		else
			iIndex += 1
		endIf
	endwhile
	debug.trace("iEquip_WidgetCore addBackCachedItem end")
endFunction

bool function playerStillHasItem(form itemForm)
	debug.trace("iEquip_WidgetCore playerStillHasItem start")
	debug.trace("iEquip_WidgetCore playerStillHasItem - itemForm: " + itemForm)
    int itemType = itemForm.GetType()
    bool stillHasItem
    ; This is a Spell or Shout and can't be counted like an item
    if (itemType == 22 || itemType == 119)
        stillHasItem = PlayerRef.HasSpell(itemForm)
    ; This is an inventory item
    else 
        stillHasItem = (PlayerRef.GetItemCount(itemForm) > 0)
    endIf
    debug.trace("iEquip_WidgetCore playerStillHasItem returning " + stillHasItem)
    debug.trace("iEquip_WidgetCore playerStillHasItem end")
    return stillHasItem
endFunction

function cycleHand(int Q, int targetIndex, form targetItem, int itemType = -1, bool equippingOnAutoAdd = false)
	debug.trace("iEquip_WidgetCore cycleHand start")
    debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", itemType: " + itemType + ", equippingOnAutoAdd: " + equippingOnAutoAdd)
   	
   	bool otherHandUnequipped
    bool justSwitchedHands
    bool previouslyUnarmedOr2HSpell

   	bBlockSwitchBackToBoundSpell = true
   	
   	int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    
    ;Set targetObjectIs2hOrRanged to true if the item we're about to equip is a 2H or ranged weapon
    if itemType == -1
    	itemType = jMap.getInt(targetObject, "iEquipType")
    endIf
    bool targetObjectIs2hOrRanged = (ai2HWeaponTypes.Find(itemType) > -1 || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3))
   	
   	;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
   	int iEquipSlotId = 1
   	if Q == 0
    	iEquipSlotId = 2
    endIf
    int otherHand = (Q + 1) % 2

    ;Get the current (or previous if equippingOnAutoAdd) right hand item type and set previously2H to true if it is/was a 2H weapon or 2H spell
    int currRHType
    if equippingOnAutoAdd
    	currRHType = jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipType")
    else
    	currRHType = PlayerRef.GetEquippedItemType(1)
    endIf
    bool previously2H = currRHType == 5 || currRHType == 6 || (equippingOnAutoAdd && currRHType == 22 && (jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipSlot") == 3)) || (!equippingOnAutoAdd && currRHType == 9 && (PlayerRef.GetEquippedObject(1) as spell).GetEquipType() == 3)
    
    ;Hide the attribute icons ready to show full poison and enchantment elements if required
    hideAttributeIcons(Q)

	debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", iEquipSlotId = " + iEquipSlotId + ", otherHand = " + otherHand + ", bSwitchingHands = " + bSwitchingHands + ", bGoneUnarmed = " + bGoneUnarmed + ", currRHType: " + currRHType + ", previously2H: " + previously2H)
	;if we're switching hands we can reset to false now, and we don't need to unequip here because we already did so when we started switching hands
	if bSwitchingHands
		bSwitchingHands = false
		justSwitchedHands = true
	;Otherwise unequip current item if we need to
	elseif !bGoneUnarmed && !equippingOnAutoAdd
		UnequipHand(Q)
	endIf
	;if we're switching the left hand and it is going to cause a 2h or ranged weapon to be unequipped from the right hand then we need to ensure a suitable 1h item is equipped in its place
    if (Q == 0 && ((equippingOnAutoAdd && ai2HWeaponTypes.Find(currRHType) > -1) || (!equippingOnAutoAdd && ai2HWeaponTypesAlt.Find(currRHType) > -1))) || (targetObjectIs2hOrRanged || (bGoneUnarmed || b2HSpellEquipped))
    	if !targetObjectIs2hOrRanged
    		bSwitchingHands = true
    	endIf
    	if bGoneUnarmed || b2HSpellEquipped
    		previouslyUnarmedOr2HSpell = true
    	endIf
    	debug.trace("iEquip_WidgetCore cycleHand - Q == 0 && RightHandWeaponIs2hOrRanged: " + (ai2HWeaponTypesAlt.Find(currRHType) > -1) + ", bGoneUnarmed: " + bGoneUnarmed + ", itemType: " + itemType + ", bSwitchingHands: " + bSwitchingHands)
    	if !bGoneUnarmed && !b2HSpellEquipped && !equippingOnAutoAdd && ai2HWeaponTypesAlt.Find(currRHType) == -1
    		UnequipHand(otherHand)
    		otherHandUnequipped = true
    	endIf
    endif
    ;In case we are re-equipping from an unarmed or 2H spell state
	bGoneUnarmed = false
	b2HSpellEquipped = false
	
	if !equippingOnAutoAdd
		;if target item is a spell equip straight away
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
			if jMap.getInt(targetObject, "iEquipSlot") == 3 ; 2H spells
				updateLeftSlotOn2HSpellEquipped()
			elseIf bProModeEnabled && bQuickDualCastEnabled && !justSwitchedHands && !bPreselectMode
				spell targetSpell = targetItem as spell
				string spellSchool = jMap.getStr(targetObject, "iEquipSchool")
				;Only allow QuickDualCast is the feature is enabled for this school, and if the equipped spell is GetEquipType == 2 (EitherHand), and as long as it's not a Bound 2H item or shield
				if abQuickDualCastSchoolAllowed[asSpellSchools.find(spellSchool)] && (jMap.getInt(targetObject, "iEquipSlot") == 2) && !((ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(targetSpell)) > -1) || (Game.GetModName(targetItem.GetFormID() / 0x1000000) == "Bound Shield.esp"))
					debug.trace("iEquip_WidgetCore cycleHand - about to QuickDualCast")
					if PM.quickDualCastEquipSpellInOtherHand(Q, targetItem, jMap.getStr(targetObject, "iEquipName"), spellSchool)
						bSwitchingHands = false ;Just in case equipping the original spell triggered bSwitchingHands then as long as we have successfully dual equipped the spell we can cancel bSwitchingHands now
					endIf
				endIf
			endIf
		else
			;if item is anything other than a spell check if it is already equipped, possibly in the other hand, and there is only 1 of it
			int itemCount = PlayerRef.GetItemCount(targetItem)
		    if !otherHandUnequipped && (targetItem == PlayerRef.GetEquippedObject(otherHand)) && itemCount < 2
		    	debug.trace("iEquip_WidgetCore cycleHand - targetItem found in other hand and only one of them")
		    	;if it is already equipped and player has allowed switching hands then unequip the other hand first before equipping the target item in this hand
		        if bAllowWeaponSwitchHands
		        	bSwitchingHands = true
		        	debug.trace("iEquip_WidgetCore cycleHand - bSwitchingHands: " + bSwitchingHands)
		        	UnequipHand(otherHand)
		        else
		        	debug.notification(jMap.getStr(targetObject, "iEquipName") + " " + iEquip_StringExt.LocalizeString("$iEquip_WC_not_inOtherhand"))
		        	return
		        endIf
		    endIf
		    ;Equip target item
		    debug.trace("iEquip_WidgetCore cycleHand - about to equip " + jMap.getStr(targetObject, "iEquipName") + " into slot " + Q)
		    Utility.WaitMenuMode(0.1)
		    if (Q == 1 && itemType == 42) ;Ammo in the right hand queue, so in this case grenades and other throwing weapons
		    	PlayerRef.EquipItemEx(targetItem as Ammo)
		    elseif ((Q == 0 && itemType == 26) || jMap.getStr(targetObject, "iEquipName") == "Rocket Launcher") ;Shield in the left hand queue
		    	PlayerRef.EquipItemEx(targetItem as Armor)
		    else
		    	int itemID = jMap.getInt(targetObject, "iEquipItemID")
		    	if itemID as bool
		    		PlayerRef.EquipItemByID(targetItem, itemID, iEquipSlotID)
		    	else
		    		PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
		    	endIf
		    endIf
		endIf
		Utility.WaitMenuMode(0.2)
	;If we've just directly equipped and are auto adding a 2H spell now we need to show it in the left slot as well, which will also sit b2HSpellEquipped to true blocking cycleHand(0) below
	elseIf itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3
		updateLeftSlotOn2HSpellEquipped()
	endIf
	checkIfBoundSpellEquipped()
	checkAndUpdatePoisonInfo(Q)
	CM.checkAndUpdateChargeMeter(Q, true)
	if (itemType == 7 || itemType == 9) && bAmmoModeFirstLook
		if bShowTooltips
			Utility.WaitMenuMode(0.5)
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AmmoModeFirstLook1"))
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AmmoModeFirstLook2"))
		endIf
		bAmmoModeFirstLook = false
	endIf
	;if we've just equipped a 1H item in RH forcing left hand to reequip, now we can re-equip the left hand making sure to block QuickDualCast
	if Q == 1 && jArray.count(aiTargetQ[0]) > 0 && (bJustLeftAmmoMode || previously2H) && (ai2HWeaponTypes.Find(itemType) == -1) && !b2HSpellEquipped
		targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
		PM.bBlockQuickDualCast = (jMap.getInt(targetObject, "iEquipType") == 22)
		debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", bJustLeftAmmoMode: " + bJustLeftAmmoMode + ", about to equip left hand item of type: " + jMap.getInt(targetObject, "iEquipType") + ", blockQuickDualCast: " + PM.bBlockQuickDualCast)
		cycleHand(0, aiCurrentQueuePosition[0], jMap.getForm(targetObject, "iEquipForm"))
    ;if we unequipped the other hand now equip the next item
    elseif bSwitchingHands
    	debug.trace("iEquip_WidgetCore cycleHand - bSwitchingHands = " + bSwitchingHands + ", calling cycleSlot(" + otherHand + ", false)")
    	if bPreselectMode
    		bSwitchingHands = false
    		bPreselectSwitchingHands = true
    	endIf
    	Utility.WaitMenuMode(0.1)
    	if Q == 1 && previouslyUnarmedOr2HSpell
    		reequipOtherHand(0)
    	else
			cycleSlot(otherHand, false, true)
		endIf
	endIf
	if bEnableGearedUp && !previouslyUnarmedOr2HSpell ;This will be actioned on the second pass when re-equipping a previous otherHand item
		refreshGearedUp()
	endIf
	EH.bJustQuickDualCast = false
	bBlockSwitchBackToBoundSpell = false
	debug.trace("iEquip_WidgetCore cycleHand end")
endFunction

function goUnarmed()
	debug.trace("iEquip_WidgetCore goUnarmed start")
	EH.bGoingUnarmed = true
	bBlockSwitchBackToBoundSpell = true
	UnequipHand(1)
	Utility.WaitMenuMode(0.1)
	;Now check if the game has just re-equipped any previous item in either hand and remove them as well
	if PlayerRef.GetEquippedObject(1)
		UnequipHand(1)
		Utility.WaitMenuMode(0.1)
	endIf
	if PlayerRef.GetEquippedObject(0)
		UnequipHand(0)
	endIf
	;And now we need to update the left hand widget
	float fNameAlpha = afWidget_A[aiNameElements[0]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushString(iHandle, "Fist")
		UICallback.PushString(iHandle, "$iEquip_common_Unarmed")
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	if bNameFadeoutEnabled
		LNUpdate.registerForNameFadeoutUpdate()
	endIf
	debug.trace("iEquip_WidgetCore goUnarmed - isAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
	if bAmmoMode && !bPreselectMode
		AM.toggleAmmoMode(true, true)
		bool[] args = new bool[3]
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		args = new bool[4]
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
	endIf
	bGoneUnarmed = true
	int i
	while i < 2
		hideAttributeIcons(i)
		setCounterVisibility(i, false)
		hidePoisonInfo(i)
		if CM.abIsChargeMeterShown[i]
			CM.updateChargeMeterVisibility(i, false)
		endIf
		i += 1
	endwhile
	if bLeftIconFaded
		checkAndFadeLeftIcon(0, 0)
	endIf
	ammo targetAmmo = AM.currentAmmoForm as Ammo
	if targetAmmo && bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
	if bEnableGearedUp
		refreshGearedUp()
	endIf
	EH.bGoingUnarmed = false
	bBlockSwitchBackToBoundSpell = false
	debug.trace("iEquip_WidgetCore goUnarmed end")
endFunction

function updateLeftSlotOn2HSpellEquipped()
	debug.trace("iEquip_WidgetCore updateLeftSlotOn2HSpellEquipped start")
	bBlockSwitchBackToBoundSpell = true
	;And now we need to update the left hand widget
	float fNameAlpha = afWidget_A[aiNameElements[0]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipIcon")) ;Show the same icon and name in the left hand as already showing in the right
		UICallback.PushString(iHandle, asCurrentlyEquipped[1])
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	if bNameFadeoutEnabled
		LNUpdate.registerForNameFadeoutUpdate()
	endIf
	debug.trace("iEquip_WidgetCore updateLeftSlotOn2HSpellEquipped - isAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
	if bAmmoMode && !bPreselectMode
		AM.toggleAmmoMode(true, true)
		bool[] args = new bool[3]
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		args = new bool[4]
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
	endIf
	b2HSpellEquipped = true
	hideAttributeIcons(0)
	setCounterVisibility(0, false)
	hidePoisonInfo(0)
	if CM.abIsChargeMeterShown[0]
		CM.updateChargeMeterVisibility(0, false)
	endIf
	ammo targetAmmo = AM.currentAmmoForm as Ammo
	if targetAmmo && bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
	if bEnableGearedUp
		refreshGearedUp()
	endIf
	bBlockSwitchBackToBoundSpell = false
	debug.trace("iEquip_WidgetCore updateLeftSlotOn2HSpellEquipped end")
endFunction

function reequipOtherHand(int Q, bool equip = true)
	debug.trace("iEquip_WidgetCore reequipOtherHand start")
	int targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushString(iHandle, jMap.getStr(targetObject, "iEquipIcon"))
		UICallback.PushString(iHandle, asCurrentlyEquipped[Q])
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	if equip
		cycleHand(Q, aiCurrentQueuePosition[Q], jMap.getForm(targetObject, "iEquipForm"), jMap.getInt(targetObject, "iEquipType"))
	endIf
	debug.trace("iEquip_WidgetCore reequipOtherHand end")
endFunction

function cycleShout(int Q, int targetIndex, form targetItem)
    debug.trace("iEquip_WidgetCore cycleShout start")
    int itemType = jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipType")
    if itemType == 22
        PlayerRef.EquipSpell(targetItem as Spell, 2)
    else
        PlayerRef.EquipShout(targetItem as Shout)
    endIf
    debug.trace("iEquip_WidgetCore cycleShout end")
endFunction

function cycleConsumable(form targetItem, int targetIndex, bool isPotionGroup)
	debug.trace("iEquip_WidgetCore cycleConsumable start")
    int potionGroupIndex
    if isPotionGroup
    	potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], targetIndex), "iEquipName"))
    endIf
    debug.trace("iEquip_WidgetCore cycleConsumable - potionGroupIndex: " + potionGroupIndex + ", bConsumableIconFaded: " + bConsumableIconFaded)
    int count
    if isPotionGroup
    	count = PO.getPotionGroupCount(potionGroupIndex)
    elseIf(targetItem)
        count = PlayerRef.GetItemCount(targetItem)
    endIf
    setSlotCount(3, count)
    If bConsumableIconFaded && (!isPotionGroup || !abPotionGroupEmpty[potionGroupIndex])
    	Utility.WaitMenuMode(0.3)
    	checkAndFadeConsumableIcon(false)
    endIf
    if isPotionGroup && abPotionGroupEmpty[potionGroupIndex] && PO.bFlashPotionWarning
    	float fDelay
    	if bEquipOnPause
    		fDelay = fEquipOnPauseDelay
    	else
    		fDelay = 0.6
    	endIf
    	CFUpdate.registerForConsumableFadeUpdate(fDelay, potionGroupIndex)	
   	endIf
   	debug.trace("iEquip_WidgetCore cycleConsumable end")
endFunction

function handleConsumableIconFadeAndFlash(int potionGroupIndex)
	debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash start")
	debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash - potionGroup is empty, flash potion warning")
	if bConsumableIconFaded
		checkAndFadeConsumableIcon(false)
		;Utility.WaitMenuMode(0.3)
	endIf
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", potionGroupIndex)
    Utility.WaitMenuMode(1.4)
    ;Just in case the user has picked up a potion in the second and a half the flash animation has been running...
    if PO.getPotionGroupCount(potionGroupIndex) < 1
		checkAndFadeConsumableIcon(true)
	endIf
	debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash end")
endFunction

function cyclePoison(form targetItem)
   	debug.trace("iEquip_WidgetCore cyclePoison start")
	if bPoisonIconFaded
		checkAndFadePoisonIcon(false)
	endIf
    setSlotCount(4, PlayerRef.GetItemCount(targetItem))
    debug.trace("iEquip_WidgetCore cyclePoison end")
endFunction

;Uses the equipped item / potion in the consumable slot - no need to set counts here as this is done through OnItemRemoved in PlayerEventHandler > PO.onPotionRemoved
function consumeItem()
    debug.trace("iEquip_WidgetCore consumeItem start")
    if bConsumablesEnabled
        int potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipName"))
        if potionGroupIndex != -1
            PO.selectAndConsumePotion(potionGroupIndex)
        else
            form itemForm = jMap.getForm(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipForm")
            if itemForm
                PlayerRef.EquipItemEx(itemForm)
            endIf
        endIf
    endIf
    debug.trace("iEquip_WidgetCore consumeItem end")
endFunction

int function showTranslatedMessage(int theMenu, string theString)
	debug.trace("iEquip_WidgetCore showTranslatedMessage start")
	debug.trace("iEquip_WidgetCore showTranslatedMessage - message type: " + theMenu)
	iEquip_MessageObjectReference = PlayerRef.PlaceAtMe(iEquip_MessageObject)
	iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
	iEquip_MessageAlias.GetReference().GetBaseObject().SetName(theString)
	int iButton
	if theMenu == 0
		iButton = iEquip_OKCancel.Show()
	elseIf theMenu == 1
		iButton = iEquip_ConfirmAddToQueue.Show()
	elseIf theMenu == 2
		iButton = iEquip_QueueManagerMenu.Show()
	elseIf theMenu == 3
		iButton = iEquip_UtilityMenu.Show()
	elseIf theMenu == 4
		iButton = iEquip_OK.Show()
	endIf
	iEquip_MessageAlias.Clear()
	iEquip_MessageObjectReference.Disable()
	iEquip_MessageObjectReference.Delete()
	debug.trace("iEquip_WidgetCore showTranslatedMessage end")
	return iButton
endFunction

function applyPoison(int Q)
	debug.trace("iEquip_WidgetCore applyPoison start")
    if bPoisonsEnabled
        int targetObject = jArray.getObj(aiTargetQ[4], aiCurrentQueuePosition[4])
        Potion poisonToApply = jMap.getForm(targetObject, "iEquipForm") as Potion
        if !poisonToApply
            return
        endIf
        bool ApplyWithoutUpdatingWidget
        int iButton
        string newPoison = jMap.getStr(targetObject, "iEquipName")
        bool isLeftHand = !(Q as bool)
        string handName = "$iEquip_common_left"
        if Q == 1
            handName = "$iEquip_common_right"
        endIf
        Weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
        string weaponName
        if currentWeapon
            weaponName = currentWeapon.GetName()
        endIf
        if (!currentWeapon)
            debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_noWeapon{" + handName + "}"))
            return
        elseif currentWeapon != jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipForm") as Weapon
            iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_ApplyToUnknownWeapon{" + weaponName + "}{" + handName + "}{" + newPoison + "}"))
            if iButton != 0
                return
            endIf
            ApplyWithoutUpdatingWidget = true
        endIf

        Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
        if currentPoison
            string currentPoisonName = currentPoison.GetName()
            if currentPoison != poisonToApply
                if !bAllowPoisonSwitching
                    debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_alreadyPoisioned{" + weaponName + "}{" + currentPoisonName + "}"))
                    return
                else
                    if iShowPoisonMessages < 2
                        iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_CleanApply{" + weaponName + "}{" + currentPoisonName + "}{" + newPoison + "}"))
                        if iButton != 0
                            return
                        endIf
                    endIf
                    _Q2C_Functions.WornRemovePoison(PlayerRef, Q)
                endIf	
            elseif iShowPoisonMessages < 2
                iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_TopUp{" + weaponName + "}{" + currentPoisonName + "}"))
                if iButton != 0
                    return
                endIf
            endIf
        elseif iShowPoisonMessages == 0
            iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_WouldYouLikeToApply{" + newPoison + "}{" + weaponName + "}"))
            if iButton != 0
                return
            endIf
        endIf
        
        int ConcentratedPoisonMultiplier = iPoisonChargeMultiplier
        if ConcentratedPoisonMultiplier == 1 && PlayerRef.HasPerk(ConcentratedPoison)
            ConcentratedPoisonMultiplier = 2
        endIf
        int chargesToApply
        if iEquip_FormExt.isWax(poisonToApply as form) || iEquip_FormExt.isOil(poisonToApply as form)
            chargesToApply = 10 * ConcentratedPoisonMultiplier
        else
            chargesToApply = iPoisonChargesPerVial * ConcentratedPoisonMultiplier
        endIf
        int newCharges = -1
        if currentPoison == poisonToApply
            chargesToApply += _Q2C_Functions.WornGetPoisonCharges(PlayerRef, Q)
            ;debug.trace("iEquip_WidgetCore applyPoison - about to top up the " + newPoison + " on your " + weaponName + " to " + chargesToApply + " charges")
            newCharges = _Q2C_Functions.WornSetPoisonCharges(PlayerRef, Q, chargesToApply)
        else
            ;debug.trace("iEquip_WidgetCore applyPoison - about to apply " + chargesToApply + " charges of " + newPoison + " to your " + weaponName)
            newCharges = _Q2C_Functions.WornSetPoison(PlayerRef, Q, poisonToApply, chargesToApply)
        endIf
        ;Remove one item from the player
        PlayerRef.RemoveItem(poisonToApply, 1, true)
        ;Flag the item as poisoned
        jMap.setInt(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "isPoisoned", 1)
        if !ApplyWithoutUpdatingWidget
            checkAndUpdatePoisonInfo(Q)
        endIf
        ;Play sound
        iEquip_ITMPoisonUse.Play(PlayerRef)
        ;Add Poison FX to weapon
        if Q == 0
            PLFX.ShowPoisonFX()
        else
            PRFX.ShowPoisonFX()
        endIf
    endIf
    debug.trace("iEquip_WidgetCore applyPoison end")
endFunction

;Convenience function
function hidePoisonInfo(int Q, bool forceHide = false)
	debug.trace("iEquip_WidgetCore hidePoisonInfo start")
	if abPoisonInfoDisplayed[Q] || forceHide
		checkAndUpdatePoisonInfo(Q, true, forceHide)
	endIf
	debug.trace("iEquip_WidgetCore hidePoisonInfo end")
endFunction

function checkAndUpdatePoisonInfo(int Q, bool cycling = false, bool forceHide = false)
	debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo start")
	int targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	int itemType = jMap.getInt(targetObject, "iEquipType")
	Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
	Form equippedItem = PlayerRef.GetEquippedObject(Q)
	if !forceHide && !equippedItem && !bGoneUnarmed && !(Q == 0 && (b2HSpellEquipped || itemType == 26))
		return
	endIf
	debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", cycling: " + cycling + ", itemType: " + itemType + ", currentPoison: " + currentPoison)
	;if item isn't poisoned remove the poisoned flag
	if equippedItem && (equippedItem == jMap.getForm(targetObject, "iEquipForm"))
		if currentPoison
			jMap.setInt(targetObject, "isPoisoned", 1)
		else
			jMap.setInt(targetObject, "isPoisoned", 0)
		endIf
	endIf
	float targetAlpha
	string iconName
	int iHandle
	int[] args
	;if the currently equipped item isn't poisonable, or if it isn't currently poisoned check and remove poison info is showing
	if cycling || !isPoisonable(itemType) || !currentPoison || (Q == 0 && bAmmoMode)
		if abPoisonInfoDisplayed[Q] || forceHide
			debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - should be hiding poison icon and name now")
			;Hide the poison icon
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
			if(iHandle)
				UICallback.PushInt(iHandle, Q) ;Which slot we're updating
				UICallback.PushString(iHandle, "hidden") ;New icon
				UICallback.Send(iHandle)
			endIf
			;Hide the poison name
			if abIsPoisonNameShown[Q]
				showName(Q, false, true, 0.15)
			endIf
			;Hide the counter if it's still showing and not needed
			if !(itemRequiresCounter(Q, jMap.getInt(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipType")))
				setCounterVisibility(Q, false)
			endIf
			;Reset the counter text colour
			args = new int[2]
			if Q == 0
				args[0] = 9 ;leftCount
				args[1] = aiWidget_TC[9] ;leftCount text colour
			else
				args[0] = 22 ;rightCount
				args[1] = aiWidget_TC[22] ;rightCount text colour
			endIf
			debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", about to set counter colour to " + args[1])
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
			abPoisonInfoDisplayed[Q] = false
		endIf
	;Otherwise update the poison name, count and icon
	else
		string poisonName = currentPoison.GetName()
		int charges = _Q2C_Functions.WornGetPoisonCharges(PlayerRef, Q)
		;Update the poison icon
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
		if iPoisonIndicatorStyle == 0
			iconName = "hidden"
		elseif iPoisonIndicatorStyle < 3
			iconName = "SingleDrop"
		elseif charges < 4
			iconName = "Drops" + charges as string
		else
			iconName = "MoreDrops"
		endIf
		debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - poisonName: " + poisonName + ", charges: " + charges + ", iconName: " + iconName)
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Which slot we're updating
			UICallback.PushString(iHandle, iconName) ;New icon
			UICallback.Send(iHandle)
		endIf
		;Update poison name
		string poisonNamePath
		if Q == 0
			poisonNamePath = ".widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName.text"
		elseif Q == 1
			poisonNamePath = ".widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName.text"
		endIf
		string currentlyDisplayedPoison = UI.GetString(HUD_MENU, WidgetRoot + poisonNamePath)
		debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - currentlyDisplayedPoison: " + currentlyDisplayedPoison + ", poisonName: " + poisonName)
		if currentlyDisplayedPoison != poisonName
			if abIsPoisonNameShown[Q]
				showName(Q, false, true, 0.15)
			endIf
			UI.SetString(HUD_MENU, WidgetRoot + poisonNamePath, poisonName)
		endIf
		if !abIsPoisonNameShown[Q]
			showName(Q, true, true, 0.15)
		endIf
		;Hide the counter, it'll be shown again below if needed
		setCounterVisibility(Q, false)
		;Update poison counter
		if iPoisonIndicatorStyle < 2 ;Count Only or Single Drop & Count
			;Set counter text colour to match poison name
			args = new int[2]
			if Q == 0
				args[0] = 9 ;leftCount
				args[1] = aiWidget_TC[11] ;leftPoisonName text colour
			else
				args[0] = 22 ;rightCount
				args[1] = aiWidget_TC[24] ;rightPoisonName text colour
			endIf
			debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", about to set counter colour to " + args[1])
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
			setSlotCount(Q, charges)
			;Re-show the counter
			setCounterVisibility(Q, true)
		endIf
		abPoisonInfoDisplayed[Q] = true
	endIf
	debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo end")
endFunction

bool function isPoisonable(int itemType)
	debug.trace("iEquip_WidgetCore isPoisonable start")
	debug.trace("iEquip_WidgetCore isPoisonable end")
	return ((itemType > 0 && itemType < 8) || itemType == 9)
endFunction

bool function isWeaponPoisoned(int Q, int iIndex, bool cycling = false)
	debug.trace("iEquip_WidgetCore isWeaponPoisoned start")
	bool isPoisoned
	;if we're checking the left hand item but we currently have a 2H or ranged weapon equipped, or if we're cycling we need to check the object data for the last know poison info
	if cycling || (Q == 0 && (ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1))
		isPoisoned = jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "isPoisoned") as bool
	;Otherwise we're checking an equipped item so we can check the actual data from the weapon
	else
		Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
		if currentPoison
			isPoisoned = true
		else
			isPoisoned = false
		endIf
	endIf
	debug.trace("iEquip_WidgetCore isWeaponPoisoned - Q: " + Q + ", iIndex: " + iIndex + ", isPoisoned: " + isPoisoned)
	debug.trace("iEquip_WidgetCore isWeaponPoisoned end")
	return isPoisoned
endFunction

;Unequips item in hand
function UnequipHand(int Q)
	debug.trace("iEquip_WidgetCore UnequipHand start")
    debug.trace("iEquip_WidgetCore UnequipHand - Q: " + Q)
    int QEx = 1
    if (Q == 0)
        QEx = 2 ; UnequipSpell and UnequipItemEx need different hand arguments
    endIf
    Armor equippedShield = PlayerRef.GetEquippedShield()
    Form equippedItem = PlayerRef.GetEquippedObject(Q)
    debug.trace("iEquip_WidgetCore UnequipHand - equippedShield: " + equippedShield + ", equippedItem: " + equippedItem)
    if Q == 0 && equippedShield
    	PlayerRef.UnequipItemEx(equippedShield)
    elseif equippedItem
        if (equippedItem as Spell)
            PlayerRef.UnequipSpell(equippedItem as Spell, Q)
        elseif (Q == 1 && equippedItem as Ammo)
        	PlayerRef.UnequipItemEx(equippedItem as Ammo)
        else
            PlayerRef.UnequipItemEx(equippedItem, QEx)
        endIf
    endIf
    debug.trace("iEquip_WidgetCore UnequipHand end")
endFunction

;/Here we are creating JMap objects for each queue item, containing all of the data we will need later on when cycling the widgets and equipping/unequipping
including formID, itemID, display name, itemType, isEnchanted, etc. These JMap objects are then placed into one of the JArray queue objects.
This means that when we cycle later on none of this has to be done on the fly saving time when time is of the essence/;

function addToQueue(int Q)
	debug.trace("iEquip_WidgetCore addToQueue start")
	;Q - 0 = Left Hand, 1 = Right Hand, 2 = Shout, 3 = Consumable/Poison
	int itemFormID
	int itemID
	form itemForm
	string itemName
	
	if !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("CustomMenu") && !((Self as form) as iEquip_uilib).IsMenuOpen()
		itemFormID = UI.GetInt(sCurrentMenu, sEntryPath + ".selectedEntry.formId")
		itemID = UI.GetInt(sCurrentMenu, sEntryPath + ".selectedEntry.itemId")
		itemName = UI.GetString(sCurrentMenu, sEntryPath + ".selectedEntry.text")
		itemForm = game.GetFormEx(itemFormID)
	endIf
	
	if itemForm
		int itemType
		int iEquipSlot
		bool isEnchanted
		bool isPoisoned
		itemType = itemForm.GetType()
		if itemType == 41 || itemType == 26 ;Weapons and shields only
			isEnchanted = UI.Getbool(sCurrentMenu, sEntryPath + ".selectedEntry.isEnchanted")
		elseIf itemType == 22
			iEquipSlot = EquipSlots.Find((itemForm as spell).GetEquipType())
			if iEquipSlot < 2 ;If the spell has a specific EquipSlot (LeftHand, RightHand) then add it to that queue
				Q = iEquipSlot
			elseIf iEquipSlot == 3 || (iEquip_SpellExt.GetBoundSpellWeapType(itemForm as spell) > -1) ;If the spell is a two handed spell or a bound 2H weapon spell add it to right hand queue
				Q = 1
			endIf
			if iEquip_FormExt.IsSpellWard(itemForm) ;The only exception to this is any mod added spells flagged in the json patch to be considered a ward, ie Bound Shield, which need to be added to the left queue
				Q = 0
			endIf
		endIf
		debug.trace("iEquip_WidgetCore addToQueue - passed the itemForm check")
		debug.trace("iEquip_WidgetCore addToQueue - itemForm: " + itemForm + ", " + itemForm.GetName() + ", should match itemName: " + itemName + ", itemID: " + itemID)
		if itemName == ""
			itemName = itemForm.getName()
		endIf
		if isItemValidForSlot(Q, itemForm, itemType, itemName)
			if Q == 3 && (itemForm as Potion).isPoison()
				Q = 4
			endIf
			bool isLightForm = (Math.LogicalAnd(itemFormID, 0xFF000000) == 0xFE000000)
			if isLightForm
				itemID = 0 ;Just in case we've got itemID by adding a lightForm item through Favorites Menu we need to remove it because the hash is invalid for light formIDs
			endIf
			;bool namesMatch = (itemName == itemForm.getName())

			if !isAlreadyInQueue(Q, itemForm, itemID)
				bool foundInOtherHandQueue
				if Q < 2
					foundInOtherHandQueue = isAlreadyInQueue((Q + 1) % 2, itemForm, itemID)
				endIf
				if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2) && !bAllowSingleItemsInBothQueues
					debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_InOtherQ{" + itemName + "}"))
					return
				endIf
				if itemID == 0 && !isLightForm ;itemID hashes won't work for light formIDs
					queueItemForIDGenerationOnMenuClose(Q, jArray.count(aiTargetQ[Q]), itemName, itemFormID)
				endIf
				bool success
				if itemType == 41 ;if it is a weapon get the weapon type
		        	itemType = (itemForm as Weapon).GetWeaponType()
		        endIf
				string itemIcon = GetItemIconName(itemForm, itemType, itemName)
				debug.trace("iEquip_WidgetCore addToQueue(): Adding " + itemName + " to the " + iEquip_StringExt.LocalizeString(asQueueName[Q]) + ", formID = " + itemform + ", itemID = " + itemID as string + ", icon = " + itemIcon + ", isEnchanted = " + isEnchanted)
				int iEquipItem = jMap.object()
				if jArray.count(aiTargetQ[Q]) < iMaxQueueLength
					if bShowQueueConfirmationMessages
						int iButton
						if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2)
							iButton = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AddToBoth{" + itemName + "}{" + asQueueName[Q] + "}"))
						else
							iButton = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AddToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
						endIf
						if iButton != 0
							return
						endIf
					endIf
					jMap.setForm(iEquipItem, "iEquipForm", itemForm)
					if itemID as bool
						jMap.setInt(iEquipItem, "iEquipItemID", itemID) ;Store SKSE itemID for non-spell items so we can use EquipItemByID to handle user enchanted/created/renamed items
					endIf
					jMap.setInt(iEquipItem, "iEquipType", itemType)
					jMap.setStr(iEquipItem, "iEquipName", itemName)
					jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
					if Q < 2
						if itemType == 22
							if itemIcon == "DestructionFire" || itemIcon == "DestructionFrost" || itemIcon == "DestructionShock"
								jMap.setStr(iEquipItem, "iEquipSchool", "Destruction")
							else
								jMap.setStr(iEquipItem, "iEquipSchool", itemIcon)
							endIf
							jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
						else
							jMap.setInt(iEquipItem, "isEnchanted", isEnchanted as int)
							jMap.setInt(iEquipItem, "isPoisoned", isPoisoned as int)
						endIf
					endIf
					;Add any other info required for each item here - spell school, costliest effect, etc
					jArray.addObj(aiTargetQ[Q], iEquipItem)
					iEquip_AllCurrentItemsFLST.AddForm(itemForm)
					EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
					;Remove added item from the relevant blackList
					if Q < 2
			        	EH.blackListFLSTs[Q].RemoveAddedForm(itemForm) ;iEquip_LeftHandBlacklistFLST or iEquip_RightHandBlacklistFLST
			        else
			        	EH.blackListFLSTs[2].RemoveAddedForm(itemForm) ;iEquip_GeneralBlacklistFLST
			        endIf
					success = true
				else
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_QIsFull{" + asQueueName[Q] + "}"))
				endIf
				if success
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AddedToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
				endIf
			else
				debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AlreadyAdded{" + itemName + "}{" + asQueueName[Q] + "}"))
			endIf
		else
			if bIsFirstFailedToAdd
				debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_failToAdd"))
				bIsFirstFailedToAdd = false
			else
				debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_CannotAdd{" + itemName + "}{"  + asQueueName[Q] + "}"))
			endIf
		endIf
	endIf
	debug.trace("iEquip_WidgetCore addToQueue end")
endFunction

function queueItemForIDGenerationOnMenuClose(int Q, int iIndex, string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore queueItemForIDGenerationOnMenuClose start")
	debug.trace("iEquip_WidgetCore queueItemForIDGenerationOnMenuClose - Q: " + Q + ", iIndex: " + iIndex + ", itemFormID: " + itemFormID + ", itemName: " + itemName)
	int queuedItem = jMap.object()
	jMap.setInt(queuedItem, "iEquipQ", Q)
	jMap.setInt(queuedItem, "iEquipIndex", iIndex)
	jMap.setStr(queuedItem, "iEquipName", itemName)
	jMap.setInt(queuedItem, "iEquipFormID", itemFormID)
	jArray.addObj(iItemsForIDGenerationObj, queuedItem)
	bItemsWaitingForID = true
	debug.trace("iEquip_WidgetCore queueItemForIDGenerationOnMenuClose end")
endFunction

function findAndFillMissingItemIDs()
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs start")
	int count = jArray.count(iItemsForIDGenerationObj)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs - number of items to generate IDs for: " + count)
	int i
	int itemID
	int Q
	int iIndex
	int targetObject
	while i < count
		targetObject = jArray.getObj(iItemsForIDGenerationObj, i)
		itemID = createItemID(jMap.getStr(targetObject, "iEquipName"), jMap.getInt(targetObject, "iEquipFormID"))
		if itemID as bool
			Q = jMap.getInt(targetObject, "iEquipQ")
			iIndex = jMap.getInt(targetObject, "iEquipIndex")
			jMap.setInt(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipItemID", itemID)
			if bMoreHUDLoaded
				string moreHUDIcon
				if Q < 2
					int otherHand = (Q + 1) % 2
					if isAlreadyInQueue(otherHand, jMap.getForm(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipForm"), itemID)
						moreHUDIcon = asMoreHUDIcons[3]
					else
	            		moreHUDIcon = asMoreHUDIcons[Q]
	            	endIf
	            else
	            	moreHUDIcon = asMoreHUDIcons[2]
	            endIf
	            if Q < 2 ;&& AhzMoreHudIE.IsIconItemRegistered(itemID)
	            	AhzMoreHudIE.RemoveIconItem(itemID) ;Does nothing if the itemID isn't registered so no need for the IsIconItemRegistered check
	            endIf
	            AhzMoreHudIE.AddIconItem(itemID, moreHUDIcon)
	        endIf
		endIf
		Utility.WaitMenuMode(0.05)
		i += 1
	endwhile
	bItemsWaitingForID = false
	jArray.clear(iItemsForIDGenerationObj)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs - final check (count should be 0) - count: " + jArray.count(iItemsForIDGenerationObj))
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs end")
endFunction

int function createItemID(string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore createItemID start")
	debug.trace("iEquip_WidgetCore createItemID - itemFormID: " + itemFormID + ", itemName: " + itemName)
	RegisterForModEvent("iEquip_GotItemID", "itemIDReceivedFromFlash")
	;Reset
	bGotID = false
	iReceivedID = 0
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".generateItemID")
	If(iHandle)
		UICallback.PushString(iHandle, itemName) ;Display name
		UICallback.PushInt(iHandle, itemFormID) ;formID
		UICallback.Send(iHandle)
	endIf
	int breakout = 1000 ;Wait up to 1 sec for return from flash, if not return -1
	while !bGotID && breakout > 0
		Utility.WaitMenuMode(0.001)
		breakout -= 1
	endwhile
	UnregisterForModEvent("iEquip_GotItemID")
	debug.trace("iEquip_WidgetCore createItemID end")
	return iReceivedID
endFunction

event itemIDReceivedFromFlash(string sEventName, string sStringArg, float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore itemIDReceivedFromFlash start")
	debug.trace("iEquip_WidgetCore itemIDReceivedFromFlash - sStringArg: " + sStringArg + ", fNumArg" + fNumArg)
	If(sEventName == "iEquip_GotItemID")
		iReceivedID = sStringArg as Int
		bGotID = true
	endIf
	debug.trace("iEquip_WidgetCore itemIDReceivedFromFlash end")
endEvent 

bool function isItemValidForSlot(int Q, form itemForm, int itemType, string itemName)
	debug.trace("iEquip_WidgetCore isItemValidForSlot start")
	debug.trace("iEquip_WidgetCore isItemValidForSlot - slot: " + Q + ", itemType: " + itemType)
	bool isValid
	bool isShout
	if itemType == 22
		isShout = ((itemForm as Spell).GetEquipType() == EquipSlots[4])
	endIf

	if Q == 0 ;Left Hand
		if itemType == 41 ;Weapon
        	int WeaponType = (itemForm as Weapon).GetWeaponType()
        	if WeaponType <= 4 || WeaponType == 8 ;Fists, 1H weapons and Staffs only
        		isValid = true
        	endIf
    	elseif (itemType == 22 && !isShout) || itemType == 23 || itemType == 31 || (itemType == 26 && (itemForm as Armor).GetSlotMask() == 512) ;Spell, Scroll, Torch, Shield
    		isValid = true
    	endIf
    elseif Q == 1 ;Right Hand
    	if itemType == 41 || (itemType == 22 && !isShout) || itemType == 23 || (itemType == 26 && itemName == "Rocket Launcher") ;Any weapon, Spell, Scroll, oh and the Rocket Launcher from Junks Guns because Kojak...
    		isValid = true
    	elseif itemType == 42 ;Ammo - looking for throwing weapons here, and these can only be equipped in the right hand
        	if (iEquip_FormExt.IsJavelin(itemForm) && itemName != "Javelin") || iEquip_FormExt.IsSpear(itemForm) || iEquip_FormExt.IsGrenade(itemForm) || iEquip_FormExt.IsThrowingKnife(itemForm) || iEquip_FormExt.IsThrowingAxe(itemForm) ;Javelin is the display name for those from Throwing Weapons Lite/Redux, the javelins from Spears by Soolie all have more descriptive names than just 'javelin' and they are treated as arrows or bolts so can't be right hand equipped
				int iButton = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_throwingWeapons{" + itemName + "}{" + itemName + "}{" + asQueueName[Q] + "}"))
				if iButton == 0
        			isValid = true
        		endIf
        	endIf
    	endIf
    elseif Q == 2 ;Shout
    	if (itemType == 22 && isShout) || itemType == 119 ;Power, Shout
    		isValid = true
    	endIf
    elseif Q == 3 ;Consumable/Poison
    	if itemType == 46 ;Potion
    		isValid = true
    	endIf
    endIf
    debug.trace("iEquip_WidgetCore isItemValidForSlot returning " + isValid)
    debug.trace("iEquip_WidgetCore isItemValidForSlot end")
    return isValid
endFunction

bool function isAlreadyInQueue(int Q, form itemForm, int itemID)
	debug.trace("iEquip_WidgetCore isAlreadyInQueue start")
	debug.trace("iEquip_WidgetCore isAlreadyInQueue - Q: " + Q + ", itemForm: " + itemForm + ", itemID: " + itemID)
	bool found
	int i
	int targetArray = aiTargetQ[Q]
	int targetObject
	while i < JArray.count(targetArray) && !found
		targetObject = jArray.getObj(targetArray, i)
		if itemID as bool
		    found = (itemID == jMap.getInt(targetObject, "iEquipItemID"))
		else
		    found = (itemform == jMap.getForm(targetObject, "iEquipForm"))
		endIf
		i += 1
	endwhile
	debug.trace("iEquip_WidgetCore isAlreadyInQueue end")
return found
endFunction

string function GetItemIconName(form itemForm, int itemType, string itemName)
	debug.trace("iEquip_WidgetCore GetItemIconName start")
    debug.trace("iEquip_WidgetCore GetItemIconName - itemType: " + itemType + ", itemName: " + itemName)
    string IconName = "Empty"

    if itemType < 13 ;It is a weapon
        ;Weapon W = itemForm as Weapon
        IconName = asWeaponTypeNames[itemType]
        ;2H axes and maces have the same ID for some reason, so we have to differentiate them
        if itemType == 6 && (itemForm as Weapon).IsWarhammer()
            IconName = "Warhammer"
        ;if this all looks a little strange it is because StringUtil find() is case sensitive so where possible I've ommitted the first letter to catch for example Spear and spear with pear
        elseif itemType == 1 && iEquip_FormExt.IsSpear(itemform) ;Looking for spears here from Spears by Soolie which are classed as 1H swords
        	IconName = "Spear"
        elseif itemType == 4 && iEquip_FormExt.IsGrenade(itemform) ;Looking for CACO grenades here which are classed as maces
        	IconName = "Grenade"
        endIf

    elseif itemType == 26 && (itemForm as Armor).GetSlotMask() == 512 ;Shield
    	IconName = "Shield"

    elseif itemType == 23
    	IconName = "Scroll"

    elseif itemType == 31
    	IconName = "Torch"

    elseif itemType == 119
    	if EH.bPlayerIsABeast && BM.currRace == 0 ;Werewolf
    		IconName = "Howl"
    	else
    		IconName = "Shout"
    	endIf
    
    elseif itemType == 22 ;Is a spell
        Spell S = itemForm as Spell

    	if S.GetEquipType() == EquipSlots[4]
    		IconName = "Power"
    		if EH.bPlayerIsABeast && BM.currRace > 0
    			if BM.currRace == 1 ;Vampire Lord
    				IconName += "Vamp"
    			else ;2 - Lich
    				IconName += "Lich"
    			endIf
    		endIf
    	else
        	MagicEffect sEffect = S.GetNthEffectMagicEffect(S.GetCostliestEffectIndex())
        	IconName = sEffect.GetAssociatedSkill()
        	if IconName == "Destruction"
        		debug.trace("iEquip_WidgetCore GetItemIconString - IconName: " + IconName + ", strongest magic effect: " + sEffect + ", " + (sEffect as form).GetName())
        		if sEffect.HasKeyword(MagicDamageFire)
        			IconName += "Fire"
        		elseIf sEffect.HasKeyword(MagicDamageFrost)
        			IconName += "Frost"
        		elseIf sEffect.HasKeyword(MagicDamageShock)
        			IconName += "Shock"
        		endIf
        	endIf
        endIf
        if !IconName
        	if EH.bPlayerIsABeast && BM.currRace > 0
        		if BM.currRace == 1 ;Vampire Lord
        			IconName = "SpellVamp"
        		else ;2 - Lich
        			IconName = "SpellLich"
        		endIf
        	else
        		IconName = "Spellbook"
        	endIf
        endIf

    elseif itemType == 42 ;Ammo - Throwing weapons
    	if iEquip_FormExt.IsSpear(itemform) || iEquip_FormExt.IsJavelin(itemform)
			IconName = "Spear"
		elseif iEquip_FormExt.IsGrenade(itemform)
			IconName = "Grenade"
		elseif iEquip_FormExt.IsThrowingAxe(itemform)
			IconName = "ThrowingAxe"
		elseif iEquip_FormExt.IsThrowingKnife(itemform)
			IconName = "ThrowingKnife"
		endIf
    
    elseif itemType == 46 ;Is a potion
        Potion P = itemForm as Potion
        if(P.IsPoison())
            IconName = "Poison"
        elseIf(P.IsFood()) ;Only way to differentiate between food and drink types is by checking their consume sound
        	if P.GetUseSound() == Game.GetForm(0x0010E2EA) ;NPCHumanEatSoup
            	IconName = "Soup"
            elseif P.GetUseSound() == Game.GetForm(0x000B6435) ;ITMPotionUse
            	IconName = "Drink"
            else
            	IconName = "Food"
            endIf
        else
	        ;int pIndex = P.GetCostliestEffectIndex()
	        ;MagicEffect pEffect = P.GetNthEffectMagicEffect(P.GetCostliestEffectIndex())
	        string pStr = P.GetNthEffectMagicEffect(P.GetCostliestEffectIndex()).GetName()
	        ;debug.trace("iEquip_WidgetCore GetItemIconString() - pIndex: " + pIndex + ", pEffect: " + pEffect + ", pStr: " + pStr)
	        if(pStr == "Health" || pStr == "Restore Health" || pStr == "Health Restoration" || pStr == "Regenerate Health" || pStr == "Health Regeneration" || pStr == "Fortify Health" || pStr == "Health Fortification")
	            IconName = "HealthPotion"
	        elseif(pStr == "Magicka " || pStr == "Restore Magicka" || pStr == "Magicka Restoration" || pStr == "Regenerate Magicka" || pStr == "Magicka Regeneration" || pStr == "Fortify Magicka" || pStr == "Magicka Fortification")
	            IconName = "MagickaPotion" 
	        elseif(pStr == "Stamina " || pStr == "Restore Stamina" || pStr == "Stamina Restoration" || pStr == "Regenerate Stamina" || pStr == "Stamina Regeneration" || pStr == "Fortify Stamina" || pStr == "Stamina Fortification")
	            IconName = "StaminaPotion" 
	        elseif(pStr == "Resist Fire")
	            IconName = "FireResistPotion" 
	        elseif(pStr == "Resist Shock")
	            IconName = "ShockResistPotion" 
	        elseif(pStr == "Resist Frost")
	            IconName = "FrostResistPotion"
	        else
	        	IconName = "Potion"
	        endIf
	    endIf
    endIf
    debug.trace("iEquip_WidgetCore GetItemIconName() returning IconName as " + IconName)
    debug.trace("iEquip_WidgetCore GetItemIconName end")
    return IconName
endFunction

;Called by MCM if user has disabled Allow Single Items In Both Queues to remove duplicate 1h items from the right hand queue
function purgeQueue()
	debug.trace("iEquip_WidgetCore purgeQueue start")
	int i
	int targetArray = aiTargetQ[1]
	int count = jArray.count(targetArray)
	debug.trace("iEquip_WidgetCore purgeQueue - " + count + " items in right hand queue")
	form itemForm
	int itemType
	int itemID
	int targetObject
	while i < count
		targetObject = jArray.getObj(targetArray, i)
		itemForm = jMap.getForm(targetObject, "iEquipForm")
		itemType = jMap.getInt(targetObject, "iEquipType")
		itemID = jMap.getInt(targetObject, "iEquipItemID")
		debug.trace("iEquip_WidgetCore purgeQueue - index: " + i + ", itemForm: " + itemForm + ", itemID: " + itemID)
		if isAlreadyInQueue(0, itemForm, itemID) && PlayerRef.GetItemCount(itemForm) < 2 && itemType != 22
			removeItemFromQueue(1, i, true)
			count -= 1
			i -= 1
		endIf
		i += 1
	endwhile
	debug.trace("iEquip_WidgetCore purgeQueue end")
endFunction

function openQueueManagerMenu(int Q = -1)
	debug.trace("iEquip_WidgetCore openQueueManagerMenu start")
	if Q == -1
		Q = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_queuemenu_title")) ;0 = Exit, 1 = Left hand queue, 2 = Right hand queue, 3 = Shout queue, 4 = Consumable queue, 5 = Poison queue
	else
		bJustUsedQueueMenuDirectAccess = true
	endIf
	if Q > 0
		Q -= 1
		int queueLength = jArray.count(aiTargetQ[Q])
		if queueLength < 1
			debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[Q] + "}"))
			recallQueueMenu()
		else
			int i
			;Remove any empty indices before creating the menu arrays
			while i < queueLength
				if !JMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName")
					jArray.eraseIndex(aiTargetQ[Q], i)
					queueLength -= 1
				endIf
				i += 1
			endWhile
			iQueueMenuCurrentQueue = Q
			initQueueMenu(Q, queueLength)
		endIf
	endIf
	debug.trace("iEquip_WidgetCore openQueueManagerMenu end")
endFunction

function initQueueMenu(int Q, int queueLength, bool update = false, int iIndex = -1)
	debug.trace("iEquip_WidgetCore initQueueMenu start")
	int targetArray = aiTargetQ[Q]
	string[] iconNames = Utility.CreateStringArray(queueLength)
	string[] itemNames = Utility.CreateStringArray(queueLength)
	bool[] enchFlags = Utility.CreateBoolArray(queueLength)
	bool[] poisonFlags = Utility.CreateBoolArray(queueLength)
	int i
	while i < queueLength
		iconNames[i] = JMap.getStr(jArray.getObj(targetArray, i), "iEquipIcon")
		itemNames[i] = JMap.getStr(jArray.getObj(targetArray, i), "iEquipName")
		enchFlags[i] = (JMap.getInt(jArray.getObj(targetArray, i), "isEnchanted") == 1)
		poisonFlags[i] = (JMap.getInt(jArray.getObj(targetArray, i), "isPoisoned") == 1)
		i += 1
	endWhile
	if update
		QueueMenu_RefreshList(iconNames, itemNames, enchFlags, poisonFlags, iIndex)
	else
		string title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_titleWithCount{" + queueLength + "}{" + asQueueName[Q] + "}")
		((Self as Form) as iEquip_UILIB).ShowQueueMenu(title, iconNames, itemNames, enchFlags, poisonFlags, 0, 0, bJustUsedQueueMenuDirectAccess)
	endIf
	debug.trace("iEquip_WidgetCore initQueueMenu end")
endFunction

function recallQueueMenu()
	debug.trace("iEquip_WidgetCore recallQueueMenu start")
	if bJustUsedQueueMenuDirectAccess
		bJustUsedQueueMenuDirectAccess = false
	else
		Utility.WaitMenuMode(0.05)
		openQueueManagerMenu()
	endIf
	debug.trace("iEquip_WidgetCore recallQueueMenu end")
endFunction

function recallPreviousQueueMenu()
	debug.trace("iEquip_WidgetCore recallPreviousQueueMenu start")
	initQueueMenu(iQueueMenuCurrentQueue, jArray.count(aiTargetQ[iQueueMenuCurrentQueue]))
	debug.trace("iEquip_WidgetCore recallPreviousQueueMenu end")
endFunction

function QueueMenuSwap(int upDown, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuSwap start")
	;upDown - 0 = Move Up, 1 = Move Down
	int targetArray = aiTargetQ[iQueueMenuCurrentQueue]
	int i = jArray.count(targetArray)
	if upDown == 0
		if iIndex != 0
			jArray.swapItems(targetArray, iIndex, iIndex - 1)
			iIndex -= 1
		endIf
	else
		if iIndex != (i - 1)
			jArray.swapItems(targetArray, iIndex, iIndex + 1)
			iIndex += 1
		endIf
	endIf
	QueueMenuUpdate(i, iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuSwap end")
endFunction

function QueueMenuRemoveFromQueue(int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuRemoveFromQueue start")
	int targetArray = aiTargetQ[iQueueMenuCurrentQueue]
	int targetObject = jArray.getObj(targetArray, iIndex)
	string itemName = JMap.getStr(targetObject, "iEquipName")
	if !(iQueueMenuCurrentQueue == 1 && itemName == "$iEquip_common_Unarmed") && !(iQueueMenuCurrentQueue == 3 && (asPotionGroups.Find(itemName) > -1))
		bool keepInFLST
		int itemID = JMap.getInt(targetObject, "iEquipItemID")
		form itemForm = JMap.getForm(targetObject, "iEquipForm")
		if bMoreHUDLoaded
			AhzMoreHudIE.RemoveIconItem(itemID)
		endIf
		if iQueueMenuCurrentQueue < 2
			int otherHandQueue = 1
			if iQueueMenuCurrentQueue == 1
				otherHandQueue = 0
			endIf
			if isAlreadyInQueue(otherHandQueue, itemForm, itemID)
				if bMoreHUDLoaded
					AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[otherHandQueue])
				endIf
				keepInFLST = true
			endIf
        endIf
        ;Add manually removed items to the relevant blackList
        if iQueueMenuCurrentQueue < 2
        	EH.blackListFLSTs[iQueueMenuCurrentQueue].AddForm(itemForm) ;iEquip_LeftHandBlacklistFLST or iEquip_RightHandBlacklistFLST
        else
        	EH.blackListFLSTs[2].AddForm(itemForm) ;iEquip_GeneralBlacklistFLST
        endIf
        if !keepInFLST
        	iEquip_AllCurrentItemsFLST.RemoveAddedForm(itemForm)
        	EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
        endIf
    endIf
	jArray.eraseIndex(targetArray, iIndex)
	int queueLength = jArray.count(targetArray)
	if iIndex >= queueLength
		iIndex -= 1
	endIf
	if queueLength < 1
		if iQueueMenuCurrentQueue == 4
			handleEmptyPoisonQueue()
		else
			setSlotToEmpty(iQueueMenuCurrentQueue)
		endIf
	endIf
	if (iQueueMenuCurrentQueue == 3 && (asPotionGroups.Find(itemName) > -1))
		abPotionGroupEnabled[asPotionGroups.Find(itemName)] = false
		((Self as Form) as iEquip_UILIB).closeQueueMenu()
		if bFirstAttemptToDeletePotionGroup
			bFirstAttemptToDeletePotionGroup = false
			if bShowTooltips
				int iButton = showTranslatedMessage(4, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_deletePotionGroup"))
			endIf
		endIf
		int iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_PotionGroupRemoved{" + itemName + "}"))
		if iButton == 0
			PO.addIndividualPotionsToQueue(asPotionGroups.Find(itemName))
		endIf
		initQueueMenu(iQueueMenuCurrentQueue, jArray.count(aiTargetQ[iQueueMenuCurrentQueue]))
	else
		QueueMenuUpdate(queueLength, iIndex)
	endIf
	debug.trace("iEquip_WidgetCore QueueMenuRemoveFromQueue end")
endFunction

function QueueMenuUpdate(int iCount, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuUpdate start")
	string title
	if iCount <= 0
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[iQueueMenuCurrentQueue] + "}")
	else
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_titleWithCount{" + iCount + "}{" + asQueueName[iQueueMenuCurrentQueue] + "}")
	endIf
	QueueMenu_RefreshTitle(title)
	initQueueMenu(iQueueMenuCurrentQueue, iCount, true, iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuUpdate end")
endFunction

function QueueMenuClearQueue()
	debug.trace("iEquip_WidgetCore QueueMenuClearQueue start")
	int targetArray = aiTargetQ[iQueueMenuCurrentQueue]
	int targetObject
	string itemName
	int count = jArray.count(aiTargetQ[iQueueMenuCurrentQueue]) - 1
	while count > -1
		targetObject = jArray.getObj(targetArray, count)
		itemName = JMap.getStr(targetObject, "iEquipName")
		if !(iQueueMenuCurrentQueue == 3 && (asPotionGroups.Find(itemName) > -1)) && !(iQueueMenuCurrentQueue == 1 && itemName == "$iEquip_common_Unarmed")
			bool keepInFLST
			int itemID = JMap.getInt(targetObject, "iEquipItemID")
			form itemForm = JMap.getForm(targetObject, "iEquipForm")
			if bMoreHUDLoaded
				AhzMoreHudIE.RemoveIconItem(itemID)
			endIf
			if iQueueMenuCurrentQueue < 2
				int otherHandQueue = 1
				if iQueueMenuCurrentQueue == 1
					otherHandQueue = 0
				endIf
				if isAlreadyInQueue(otherHandQueue, itemForm, itemID)
					if bMoreHUDLoaded
						AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[otherHandQueue])
					endIf
					keepInFLST = true
				endIf
	        endIf
	        if !keepInFLST
	        	iEquip_AllCurrentItemsFLST.RemoveAddedForm(itemForm)
	        endIf
	    endIf
	    count -= 1
	endWhile
	EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
	jArray.clear(aiTargetQ[iQueueMenuCurrentQueue])
	if iQueueMenuCurrentQueue == 3
        aiCurrentQueuePosition[3] = -1
        
        if bPotionGrouping
        	int i
        	while i < 3
        		if abPotionGroupEnabled[i]
        			abPotionGroupEnabled[i] = false
        			addPotionGroups(i)
        			if (!abPotionGroupEmpty[i] || PO.iEmptyPotionQueueChoice == 0)
                		aiCurrentQueuePosition[3] = aiCurrentQueuePosition[3] + 1
                	endIf
        		endIf
        		i += 1
        	endWhile
        endIf
	endIf
	if iQueueMenuCurrentQueue == 3 && (aiCurrentQueuePosition[3] != -1)
		updateWidget(3, aiCurrentQueuePosition[3])
		if abPotionGroupEmpty[aiCurrentQueuePosition[3]]
			Utility.WaitMenuMode(1.0)
			checkAndFadeConsumableIcon(true)
		endIf
	elseIf iQueueMenuCurrentQueue == 4
		handleEmptyPoisonQueue()
	else
		setSlotToEmpty(iQueueMenuCurrentQueue)
	endIf
	debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_QCleared{" + asQueueName[iQueueMenuCurrentQueue] + "}"))
	recallQueueMenu()
	debug.trace("iEquip_WidgetCore QueueMenuClearQueue end")
endFunction

function ApplyChanges()
	debug.trace("iEquip_WidgetCore ApplyChanges start")
	int i
    
	if bBackgroundStyleChanged
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
        bBackgroundStyleChanged = false
	endIf
	if bDropShadowSettingChanged && !EM.isEditMode
        UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", !bDropShadowEnabled)
        bDropShadowSettingChanged = false
	endIf
	if bFadeOptionsChanged
		updateWidgetVisibility()
		i = 0
        while i < 8
            showName(i, true) ;Reshow all the names and either register or unregister for updates
            i += 1
        endwhile
        bFadeOptionsChanged = false
    endIf
    if EH.bPlayerIsABeast
    	if bBeastModeOptionsChanged
    		BM.updateWidgetVisOnSettingsChanged()
    		bBeastModeOptionsChanged = false
    	endIf
    else
	    if bSlotEnabledOptionsChanged
			updateSlotsEnabled()
	        bSlotEnabledOptionsChanged = false
		endIf
	    if bRefreshQueues
	    	purgeQueue()
	        bRefreshQueues = false
	    endIf
	    if bReduceMaxQueueLengthPending
	    	reduceMaxQueueLength()
	        bReduceMaxQueueLengthPending = false
	    endIf
	    if bGearedUpOptionChanged
	    	Utility.SetINIbool("bDisableGearedUp:General", True)
			refreshVisibleItems()
			if bEnableGearedUp
				Utility.SetINIbool("bDisableGearedUp:General", False)
				refreshVisibleItems()
			endIf
	        bGearedUpOptionChanged = false
	    endIf
	    ammo targetAmmo = AM.currentAmmoForm as ammo
	    if !bAmmoMode && bUnequipAmmo && targetAmmo && PlayerRef.isEquipped(targetAmmo)
			PlayerRef.UnequipItemEx(targetAmmo)
		endIf
	    if bPreselectMode && (!PM.bPreselectEnabled || !bProModeEnabled)
	    	PM.togglePreselectMode()
	    endIf
	    if bAmmoMode
		    if bAmmoSortingChanged
		    	AM.updateAmmoListsOnSettingChange()
	            bAmmoSortingChanged = false
		    endIf
		    if bAmmoIconChanged
		    	AM.checkAndEquipAmmo(false, false, true, false)
	            bAmmoIconChanged = false
		    endIf
		endIf
		if bPreselectMode || bAttributeIconsOptionChanged
			i = 0
			while i < 2
				if bShowAttributeIcons
					updateAttributeIcons(i, 0)
				else
					hideAttributeIcons(i + 5)
				endIf
				i += 1
			endwhile
	        bAttributeIconsOptionChanged = false
		endIf
		if bPoisonIndicatorStyleChanged
			i = 0
			while i < 2
				if abPoisonInfoDisplayed[i]
					checkAndUpdatePoisonInfo(i)
				endIf
				i += 1
			endwhile
	        bPoisonIndicatorStyleChanged = false
		endIf
		if CM.bSettingsChanged
			CM.bSettingsChanged = false
			CM.updateChargeMeters(true) ;forceUpdate will make sure updateMeterPercent runs in full
			if CM.iChargeDisplayType > 0
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ;SkyHUD Alt Charge Meter
			else
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 100)
			endIf
		endIf
		if bPotionGroupingOptionsChanged
		    if !bPotionGrouping
		    	;If we've just turned potion grouping off remove any of the three groups still in the consumable queue and advance the widget if one of them is currently shown
		    	removePotionGroups()
		    	if (asPotionGroups.Find(asCurrentlyEquipped[3]) > -1)
		        	cycleSlot(3)
		        endIf
		    else
		    	i = 0
		    	while i < 3
		    		if abPotionGroupAddedBack[i]
		    			int iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_RemovePotionsFromConsumableQueue{" + asPotionGroups[i] + "}"))
		    			if iButton == 0
		    				PO.removeGroupedPotionsFromConsumableQueue(i)
		    			endIf
		    			abPotionGroupAddedBack[i] = false
		    		endIf
		    		i += 1
		    	endWhile
		    endIf
	        bPotionGroupingOptionsChanged = false
		endIf
		if bRestorePotionWarningSettingChanged
			bRestorePotionWarningSettingChanged = false
			int potionGroup = asPotionGroups.Find(asCurrentlyEquipped[3])
			if (potionGroup > -1)
	        	setSlotCount(3, PO.getPotionGroupCount(potionGroup))
	        endIf
		endIf
		if bPositionIndicatorSettingsChanged
			bPositionIndicatorSettingsChanged = false
			
		endIf
	    if EM.isEditMode
	        EM.LoadAllElements()
	    endIf
	endIf
    debug.trace("iEquip_WidgetCore ApplyChanges end")
endFunction
