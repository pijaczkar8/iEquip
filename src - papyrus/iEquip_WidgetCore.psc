
Scriptname iEquip_WidgetCore extends SKI_WidgetBase

Import Input
Import Form
Import UI
Import UICallback
Import Utility
Import iEquip_UILIB
import _Q2C_Functions
import AhzMoreHudIE
Import WornObject
Import iEquip_WeaponExt

;Script Properties
iEquip_ChargeMeters property CM auto
iEquip_EditMode property EM auto
iEquip_MCM property MCM auto
iEquip_KeyHandler property KH auto
iEquip_AmmoMode property AM auto
iEquip_ProMode property PM auto
iEquip_PotionScript property PO auto
;iEquip_HelpMenu property HM auto
iEquip_PlayerEventHandler property EH auto
iEquip_AddedItemHandler property AD auto
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

FormList Property iEquip_AllCurrentItemsFLST Auto
FormList Property iEquip_RemovedItemsFLST Auto

int property voiceEquipSlot = 0x00025BEE AutoReadOnly ; hex code of the FormID for the Voice EquipSlot

Keyword property MagicDamageFire auto
Keyword property MagicDamageFrost auto
Keyword property MagicDamageShock auto

; Arrays used by queue functions
int[] property aiCurrentQueuePosition auto hidden ;Array containing the current index for each queue
string[] property asCurrentlyEquipped auto hidden ;Array containing the itemName for whatever is currently equipped in each queue
int[] property aiCurrentlyPreselected auto hidden ;Array containing current preselect queue positions
;int[] aiIndexOnStartCycle ;Array into which we store the currently equipped index for slots 0-2 when we start cycling, resets when checkAndEquipShownHandItem is called - allows us to skip currently equipped item when cycling

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

bool bEnabled = false
bool property bJustEnabled = false auto hidden
bool property bIsFirstLoad = true auto hidden
bool bIsFirstEnabled = true
bool bIsFirstInventoryMenu = true
bool bIsFirstMagicMenu = true
bool bIsFirstFailedToAdd = true
bool property bLoading = false auto hidden
bool property bShowQueueConfirmationMessages = true auto hidden
bool property bLoadedbyOnWidgetInit auto hidden
bool bRefreshingWidgetOnLoad = false

;Ammo Mode properties and variables
bool property bAmmoMode = false auto hidden
bool bJustLeftAmmoMode = false
bool bAmmoModeFirstLook = true

bool property bEditModeEnabled = true auto hidden

;Auto Unequip Ammo
bool property bUnequipAmmo = true auto hidden

;Geared Up properties and variables
bool property bEnableGearedUp = false auto hidden
Race property PlayerRace auto hidden
bool bDrawn
Form boots
float property fEquipOnPauseDelay = 2.0 auto hidden

bool property bHealthPotionGrouping = true auto hidden
bool property bStaminaPotionGrouping = true auto hidden
bool property bMagickaPotionGrouping = true auto hidden

bool property bProModeEnabled = false auto hidden
bool property bPreselectMode = false auto hidden
bool property bQuickDualCastEnabled = false auto hidden
bool property bQuickDualCastDestruction = false auto hidden
bool property bQuickDualCastIllusion = false auto hidden
bool property bQuickDualCastAlteration = false auto hidden
bool property bQuickDualCastRestoration = false auto hidden
bool property bQuickDualCastConjuration = false auto hidden

bool property bRefreshQueues = False auto hidden
bool property bFadeOptionsChanged = False auto hidden
bool property bAmmoIconChanged = False auto hidden
bool property bAmmoSortingChanged = False auto hidden
bool property bGearedUpOptionChanged = false auto hidden
bool property bSlotEnabledOptionsChanged = false auto hidden

int property iMaxQueueLength = 12 auto hidden
bool property bReduceMaxQueueLengthPending = false auto hidden
bool property bHardLimitQueueSize = true auto hidden
bool property bHardLimitEnabledPending = false auto hidden
bool property bAllowWeaponSwitchHands = false auto hidden
bool property bAllowSingleItemsInBothQueues = false auto hidden
bool property bAutoAddNewItems = true auto hidden
bool property bEnableRemovedItemCaching = true auto hidden
int property iMaxCachedItems = 60 auto hidden

float property fWidgetFadeoutDelay = 20.0 auto hidden
float property fWidgetFadeoutDuration = 1.5 auto hidden
bool property bAlwaysVisibleWhenWeaponsDrawn = true auto hidden
bool property bIsWidgetShown = false auto hidden

float property fMainNameFadeoutDelay = 5.0 auto hidden
float property fPoisonNameFadeoutDelay = 5.0 auto hidden
float property fPreselectNameFadeoutDelay = 5.0 auto hidden
float property fNameFadeoutDuration = 1.5 auto hidden

bool property bBackgroundStyleChanged = false auto hidden
bool property bFadeLeftIconWhen2HEquipped = true auto hidden
float property fLeftIconFadeAmount = 70.0 auto hidden

bool property bDropShadowEnabled = true auto hidden
bool property bDropShadowSettingChanged = false auto hidden

bool property bEmptyPotionQueueChoiceChanged = false auto hidden
bool property bPotionGroupingOptionsChanged = false auto hidden

bool property bAllowPoisonSwitching = true auto hidden
bool property bAllowPoisonTopUp = true auto hidden
int property iPoisonChargeMultiplier = 1 auto hidden
int property iPoisonChargesPerVial = 1 auto hidden
int property iShowPoisonMessages = 0 auto hidden
int property iPoisonIndicatorStyle = 1 auto hidden
bool property bPoisonIndicatorStyleChanged = false auto hidden

bool property bShowAttributeIcons = true auto hidden
bool property bAttributeIconsOptionChanged = false auto hidden

int[] property aiTargetQ auto hidden
string[] asQueueName
bool[] abQueueWasEmpty

string[] asItemNames
string[] asWeaponTypeNames

int iQueueMenuCurrentQueue = -1
bool bJustUsedQueueMenuDirectAccess = false

string sCurrentMenu = ""
string sEntryPath = ""

bool property bShoutEnabled = true auto hidden
bool property bConsumablesEnabled = true auto hidden
bool property bPoisonsEnabled = true auto hidden

int property iBackgroundStyle = 0 auto hidden

bool[] property abIsCounterShown auto hidden
int[] aiCounterClips
bool property bLeftIconFaded = false auto hidden

bool property bWidgetFadeoutEnabled = false auto hidden
bool property bNameFadeoutEnabled = false auto hidden
bool[] property abIsNameShown auto hidden
int[] property aiNameElements auto hidden
bool property bFirstPressShowsName = true auto hidden

bool[] property abIsPoisonNameShown auto hidden
int[] property aiPoisonNameElements auto hidden
bool[] property abPoisonInfoDisplayed auto hidden

string[] asPotionGroups
bool[] property abPotionGroupEmpty auto hidden
bool property bConsumableIconFaded = false auto hidden
bool bFirstAttemptToDeletePotionGroup = true

bool property bPoisonIconFaded = false auto hidden

string[] asBound2HWeapons
bool property bBlockSwitchBackToBoundSpell = false auto hidden

bool property bMoreHUDLoaded = false auto hidden
string[] property asMoreHUDIcons auto hidden
bool property bWaitingForPotionQueues = false auto hidden

int iRemovedItemsCacheObj = 0
int iItemsForIDGenerationObj = 0
int property iEquipQHolderObj = 0 auto hidden

bool bReverse ;Used if bEquipOnPause is enabled
bool bWaitingForEquipOnPauseUpdate = false
bool property bCyclingLHPreselectInAmmoMode = false auto hidden

bool bSwitchingHands = false
bool property bPreselectSwitchingHands = false auto hidden
bool bSkipOtherHandCheck = false
bool property bGoneUnarmed = false auto hidden

bool bWaitingForFlash = false
bool bItemsWaitingForID = false
bool bGotID = false
int iReceivedID = 0

bool property bEquipOnPause = true auto hidden

string function GetWidgetType()
	Return "iEquip_WidgetCore"
endFunction

string function GetWidgetSource()
	Return "iEquip/iEquipWidget.swf"
endFunction

Event OnWidgetInit()
	PopulateWidgetArrays()
	PlayerRace = PlayerRef.GetRace()
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
	
	int i = 0
	while i < 8
		abIsNameShown[i] = true
		if i < 5
			aiTargetQ[i] = 0
			aiCurrentQueuePosition[i] = -1
			asCurrentlyEquipped[i] = ""
			if i < 3
				aiCurrentlyPreselected[i] = -1
				abQueueWasEmpty[i] = true
				abPotionGroupEmpty[i] = true
				abIsCounterShown[i] = false
				if i < 2
					abIsPoisonNameShown[i] = false
					abPoisonInfoDisplayed[i] = false
				endIf
			else
				abIsCounterShown[i] = true
			endIf
		endIf
		i += 1
	endwhile

	asQueueName = new string[5]
	asQueueName[0] = "left hand queue"
	asQueueName[1] = "right hand queue"
	asQueueName[2] = "shout queue"
	asQueueName[3] = "consumable queue"
	asQueueName[4] = "poison queue"

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

	asBound2HWeapons = new string[5]
	asBound2HWeapons[0] = "Bound Bow"
	asBound2HWeapons[1] = "Bound Crossbow"
	asBound2HWeapons[2] = "Bound Greatsword"
	asBound2HWeapons[3] = "Bound Battleaxe"
	asBound2HWeapons[4] = "Bound Warhammer"

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
	asPotionGroups[0] = "Health Potions"
	asPotionGroups[1] = "Stamina Potions"
	asPotionGroups[2] = "Magicka Potions"

	asMoreHUDIcons = new string[4]
	asMoreHUDIcons[0] = "iEquipQL.png" ;Left
	asMoreHUDIcons[1] = "iEquipQR.png" ;Right
	asMoreHUDIcons[2] = "iEquipQ.png" ;Q - for shout/consumable/poison queues
	asMoreHUDIcons[3] = "iEquipQB.png" ;Both - for items in both left and right queues

	bLoadedbyOnWidgetInit = true
	initDataObjects()
	Utility.Wait(0.1)
	PO.InitialisePotionQueueArrays(aiTargetQ[3], aiTargetQ[4])
	addPotionGroups()
	addFists()
	KH.GameLoaded()
EndEvent

function CheckDependencies()
	bMoreHUDLoaded = AhzMoreHudIE.GetVersion() > 0
	if bMoreHUDLoaded && bEnabled
		initialisemoreHUDArray()
	endIf
endFunction

Event OnWidgetLoad()
	debug.trace("iEquip_WidgetCore OnWidgetLoad called")

	EM.iSelectedElement = -1
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
	CM.OnWidgetLoad(HUD_MENU, WidgetRoot, aiTargetQ[0], aiTargetQ[1])
	
	CheckDependencies()

    OnWidgetReset()
    ; Determine if the widget should be displayed
    UpdateWidgetModes()
    ;Make sure to hide Edit Mode and bPreselectMode elements, leaving left shown if in bAmmoMode
	UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	bool[] args = new bool[5]
	if bAmmoMode
		args[0] = true
	else
		args[0] = false ;Hide left
	endIf
	args[1] = false ;Hide right
	args[2] = false ;Hide shout
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
			Utility.Wait(0.5)
			checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "Type"))
		endIf
	endIf

	if isEnabled
		KH.RegisterForGameplayKeys()
		debug.notification("iEquip controls unlocked and ready to use")
	endIf
	bLoading = False
	debug.trace("iEquip_WidgetCore OnWidgetLoad finished")
endEvent

Event OnWidgetReset()
	debug.trace("iEquip_WidgetCore OnWidgetReset called")
    RequireExtend = false
	parent.OnWidgetReset()
	EM.UpdateElementsAll()
	debug.trace("iEquip_WidgetCore OnWidgetReset finished")
EndEvent

function refreshWidgetOnLoad()
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad() called")
	bRefreshingWidgetOnLoad = true
	bLeftIconFaded = false
	int Q = 0
	form fItem
	int potionGroup = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "Name"))
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
						fItem = jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "Form")
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
	endIf
	;just to make sure!
	UI.setbool(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
	bRefreshingWidgetOnLoad = false
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad() finished")
endFunction

;ToDo - This function is still to finish/review
function refreshWidget()
	debug.trace("iEquip_WidgetCore refreshWidget called")
	;Hide the widget first
	KH.bAllowKeyPress = false
	updateWidgetVisibility(false)
	debug.notification("Refreshing iEquip widget...")
	;Toggle preselect mode now (we exit again later)
	if !bPreselectMode
		PM.togglePreselectMode()
		Utility.Wait(3.0)
	endIf
	;Reset visibility and alpha on every element
	int i = 0
	while i < asWidgetDescriptions.Length
		UI.SetBool(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._visible", abWidget_V[i])
		UI.setFloat(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._alpha", afWidget_A[i])
		i += 1
	endwhile
	;Exit Preselect Mode now
	PM.togglePreselectMode()
	Utility.Wait(3.0)
	;Check what the items and shout the player currently has equipped and find them in the queues
	i = 0
	form equippedForm
	bool rangedWeaponEquipped = false
	bool[] slotEmpty = new bool[3]
	while i < 3
		slotEmpty[i] = false
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
				asCurrentlyEquipped[i] = jMap.getStr(jArray.getObj(aiTargetQ[i], foundAt), "Name")
			;Otherwise unequip and re-equip the item which should then cause EH.OnObjectEquipped to add it in to the relevant queue and update the widget accordingly
			elseIf i < 2
				UnequipHand(i)
				Utility.Wait(0.2)
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
		Utility.Wait(3.0)
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
	Utility.Wait(1.5)
	checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "Type"))
	;Reset consumable count and fade
	int potionGroup = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "Name"))
	int count
	if potionGroup == -1
		count = PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "Form"))
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
		setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[4], aiCurrentQueuePosition[4]), "Form")))
		if bConsumableIconFaded
			checkAndFadePoisonIcon(false)
		endIf
	endIf
	;Check and show or hide left and right counters
	if !bAmmoMode
		i = 0
		while i < 2
			if itemRequiresCounter(i, jMap.getInt(jArray.getObj(aiTargetQ[i], aiCurrentQueuePosition[i]), "Type")) || abPoisonInfoDisplayed[i]
				setSlotCount(i, PlayerRef.GetItemCount(equippedForm))
				;Show the counter if currently hidden
				if !abIsCounterShown[i]
					setCounterVisibility(i, true)
				endIf
			;The item doesn't require a counter so hide it if it's currently shown
			elseif abIsCounterShown[i]
				setCounterVisibility(i, false)
			endIf
			i += 1
		endwhile
	;We're in Ammo Mode so we need to make sure only the left counter is shown
	else
		if !abIsCounterShown[0]
			setCounterVisibility(0, true)
		endIf
		;And hide the right hand counter unless the current ranged weapon is poisoned
		if abIsCounterShown[1] && !abPoisonInfoDisplayed[1]
			setCounterVisibility(1, false)
		elseIf abPoisonInfoDisplayed[1] && !abIsCounterShown[1]
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
	debug.Notification("iEquip widget refresh complete")
	debug.trace("iEquip_WidgetCore refreshWidget finished")
endFunction

;Called from EditMode when toggling back out
function resetWidgetsToPreviousState()
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
        PM.togglePreselectMode()
		EM.preselectEnabledOnEnter = false
	endIf
	;Reset enchantment meters and soulgems
	CM.updateChargeMeters(true)
endFunction

function initDataObjects()
    debug.trace("iEquip_WidgetCore initDataObjects called")
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
    debug.trace("iEquip_WidgetCore initDataObjects finished")
endFunction

function initialisemoreHUDArray()
	debug.trace("iEquip_WidgetCore initialisemoreHUDArray called")

    int jItemIDs = jArray.object()
    int jIconNames = jArray.object()
    int Q = 0
    
    while Q < 5
        int queueLength = JArray.count(aiTargetQ[Q])
        debug.trace("iEquip_WidgetCore initialisemoreHUDArray processing Q: " + Q + ", queueLength: " + queueLength)
        int i = 0
        if Q == 3
        	i = 3 ;Skip the potion groups in the consumables queue
        endIf
        
        while i < queueLength
        	;Clear out any empty indices for good measure
        	if !jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "Name")
        		jArray.eraseIndex(aiTargetQ[Q], i)
        		queueLength -= 1
        	endIf
            int itemID = jMap.getInt(jArray.getObj(aiTargetQ[Q], i), "itemID")
            debug.trace("iEquip_WidgetCore initialisemoreHUDArray Q: " + Q + ", i: " + i + ", itemID: " + itemID + ", " + jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "Name"))
            if itemID == 0
            	itemID = createItemID(jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "Name"), (jMap.getForm(jArray.getObj(aiTargetQ[Q], i), "Form")).GetFormID())
            	jMap.setInt(jArray.getObj(aiTargetQ[Q], i), "itemID", itemID)
            endIf
            if itemID != 0
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
endFunction

function addPotionGroups()
	debug.trace("iEquip_WidgetCore addPotionGroups called")
	int healthPotionGroup = jMap.object()
	int staminaPotionGroup = jMap.object()
	int magickaPotionGroup = jMap.object()

	jMap.setInt(healthPotionGroup, "Type", 46)
	jMap.setStr(healthPotionGroup, "Name", "Health Potions")
	jMap.setStr(healthPotionGroup, "Icon", "HealthPotion")
	jArray.addObj(aiTargetQ[3], healthPotionGroup)

	jMap.setInt(staminaPotionGroup, "Type", 46)
	jMap.setStr(staminaPotionGroup, "Name", "Stamina Potions")
	jMap.setStr(staminaPotionGroup, "Icon", "StaminaPotion")
	jArray.addObj(aiTargetQ[3], staminaPotionGroup)

	jMap.setInt(magickaPotionGroup, "Type", 46)
	jMap.setStr(magickaPotionGroup, "Name", "Magicka Potions")
	jMap.setStr(magickaPotionGroup, "Icon", "MagickaPotion")
	jArray.addObj(aiTargetQ[3], magickaPotionGroup)
endFunction

function addFists()
	debug.trace("iEquip_WidgetCore addFists called")
	if findInQueue(1, "Fist") == -1
		int Fists = jMap.object()
		jMap.setInt(Fists, "Type", 0)
		jMap.setStr(Fists, "Name", "Unarmed")
		jMap.setStr(Fists, "Icon", "Fist")
		jArray.addObj(aiTargetQ[1], Fists)
	endIf
endFunction

event OnMenuOpen(string _sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuOpen called - current menu: " + _sCurrentMenu)
	sCurrentMenu = _sCurrentMenu
	if (sCurrentMenu == "InventoryMenu" || sCurrentMenu == "MagicMenu" || sCurrentMenu == "FavoritesMenu") ;if in inventory or magic menu switch states so cycle hotkeys now assign selected item to the relevant queue array
		if  bIsFirstInventoryMenu
			debug.MessageBox("Adding to your iEQUIP queues\n\nTo add items, spells, powers or shouts to your iEquip queues you simply need to highlight an item in your inventory or spellbook (you don't need to equip it) and press the hotkey for the slot you want to add it to.")
			bIsFirstInventoryMenu = false
		endIf
		if sCurrentMenu == "InventoryMenu" || sCurrentMenu == "MagicMenu"
			sEntryPath = "_root.Menu_mc.inventoryLists.itemList.selectedEntry."
		elseif sCurrentMenu == "FavoritesMenu"
			sEntryPath = "_root.MenuHolder.Menu_mc.itemList.selectedEntry."
		endIf
	elseif sCurrentMenu == "Journal Menu"
		sEntryPath = "_root.ConfigPanelFader.configPanel._modList.selectedEntry."
	endIf
	;Geared Up
	if bEnableGearedUp && PlayerRef.GetRace() == PlayerRace
		if PlayerRef.IsWeaponDrawn() || PlayerRef.GetAnimationVariablebool("IsEquipping")
			Utility.SetINIbool("bDisableGearedUp:General", true)
			refreshVisibleItems()
			Utility.Wait(0.1)
			Utility.SetINIbool("bDisableGearedUp:General", false)
			refreshVisibleItems()
		endIf
	endIf
endEvent

event OnMenuClose(string _sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuClose called - current menu: " + _sCurrentMenu + ", bJustEnabled: " + bJustEnabled + ", bItemsWaitingForID: " + bItemsWaitingForID)
	if (_sCurrentMenu == "InventoryMenu" || _sCurrentMenu == "MagicMenu" || _sCurrentMenu == "FavoritesMenu") && bItemsWaitingForID ;&& !utility.IsInMenuMode()
		findAndFillMissingItemIDs()
		bItemsWaitingForID = false
	endIf
	sCurrentMenu = ""
	sEntryPath = ""
endEvent

function refreshGearedUp()
	debug.trace("iEquip_WidgetCore refreshGearedUp called")
	Utility.SetINIbool("bDisableGearedUp:General", True)
	refreshVisibleItems()
	Utility.Wait(0.05)
	Utility.SetINIbool("bDisableGearedUp:General", False)
	refreshVisibleItems()
endFunction

function refreshVisibleItems()
	debug.trace("iEquip_WidgetCore refreshVisibleItems called")
	if !PlayerRef.IsOnMount()
		PlayerRef.QueueNiNodeUpdate()
	else
		boots = PlayerRef.GetWornForm(0x00000080)
		if boots
			PlayerRef.UnequipItem(boots, false, true)
			Utility.Wait(0.1)
			PlayerRef.EquipItem(boots, false, true)
		else
			PlayerRef.AddItem(Shoes, 1, true)
			PlayerRef.EquipItem(Shoes, false, true)
			Utility.Wait(0.1)
			PlayerRef.UnequipItem(Shoes, false, true)
			PlayerRef.RemoveItem(Shoes, 1, true)
		endIf
	endIf
endFunction

function updateWidgetVisibility(bool show = true, float fDuration = 0.2)
	debug.trace("iEquip_WidgetCore updateWidgetVisibility called - show: " + show + ", bIsWidgetShown: " + bIsWidgetShown)
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
endFunction

bool property isEnabled
{Set this property true to enable the widget}
	bool function Get()
		Return bEnabled
	endFunction
	
	function Set(bool enabled)
		bEnabled = enabled
		EH.OniEquipEnabled(enabled)
		AD.OniEquipEnabled(enabled)
		if (Ready)
			if bEnabled
				bWaitingForPotionQueues = true
				PO.findAndSortPotions()
				while bWaitingForPotionQueues
					Utility.Wait(0.01)
				EndWhile
				AM.updateAmmoLists()
				CheckDependencies()
				if bIsFirstEnabled
					UI.invoke(HUD_MENU, WidgetRoot + ".setWidgetToEmpty")
					; Add anything currently equipped in left, right and shout slots
					addCurrentItemsOnFirstEnable()
					; Update consumable and poison slots to show Health Potions and first poison if any present
					int Q = 3
					while Q < 5
						if jArray.count(aiTargetQ[Q]) > 0
							aiCurrentQueuePosition[Q] = 0
							asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], 0), "Name")
							updateWidget(Q, 0, false, true)
							if Q == 3
						    	setSlotCount(3, PO.getPotionGroupCount(0))
						    	if abPotionGroupEmpty[0]
						    		checkAndFadeConsumableIcon(true)
						    	endIf
						    else
						        setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[4], 0), "Form")))
						    endIf
						    setCounterVisibility(Q, true)
						endIf
						Q += 1
					endWhile
				endIf
				bool[] args = new bool[4]
				args[0] = false ;Hide left
				args[1] = false ;Hide right
				args[2] = false ;Hide shout
				args[3] = false ;Ammo Mode
				UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
				UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
				UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
				if bDropShadowEnabled
					UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false) ;Show
				else
					UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true) ;Remove
				endIf
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
				if CM.iChargeDisplayType > 0
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
					UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ;SkyHUD alt charge meter
				endIf
				self.RegisterForMenu("InventoryMenu")
				self.RegisterForMenu("MagicMenu")
				self.RegisterForMenu("FavoritesMenu")
				self.RegisterForMenu("ContainerMenu")
				self.RegisterForMenu("Journal Menu")
				iEquip_MessageQuest.Start()
				KH.RegisterForGameplayKeys()
				debug.notification("iEquip controls unlocked and ready to use")
			else
				self.UnregisterForAllMenus()
				KH.UnregisterForAllKeys()
				iEquip_MessageQuest.Stop()
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 100)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 100) ;SkyHUD alt charge meter
			endIf
			updateWidgetVisibility() ;Just in case you were in Edit Mode when you disabled because ToggleEditMode won't have done this
			UI.setbool(HUD_MENU, WidgetRoot + "._visible", bEnabled)
		endIf
		if bEnabled && bIsFirstEnabled
			ResetWidgetArrays()
			bIsFirstEnabled = false
			if bJustEnabled
				Utility.Wait(1.5)
		        debug.MessageBox("Adding items to iEquip\n\nBefore you can use iEquip for the first time you need to choose your gear for each slot.  Simply open your Inventory, Magic or Favorites menu and follow the instructions there.\n\nEnjoy using iEquip!")
		        bJustEnabled = false	
		    endIf
		endIf
	endFunction
EndProperty

function addCurrentItemsOnFirstEnable()
	debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable called")
	int Q = 0
	form equippedItem
	string itemName
	int itemID
	int itemType
	while Q < 3
		equippedItem = PlayerRef.GetEquippedObject(Q)
		if equippedItem
			itemName = equippedItem.getName()
			itemID = createItemID(itemName, equippedItem.GetFormID())
			itemType = equippedItem.GetType()
			if itemType == 41 ;if it is a weapon get the weapon type
	        	itemType = (equippedItem as Weapon).GetWeaponType()
	        endIf
	        if Q == 0 && (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
	        	Q += 1
	        endIf
			int iEquipItem = jMap.object()
			jMap.setForm(iEquipItem, "Form", equippedItem)
			jMap.setInt(iEquipItem, "ID", itemID)
			jMap.setInt(iEquipItem, "Type", itemType)
			jMap.setStr(iEquipItem, "Name", itemName)
			jMap.setStr(iEquipItem, "Icon", GetItemIconName(equippedItem, itemType, itemName))
			if Q < 2
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
			aiCurrentQueuePosition[Q] = 0
			asCurrentlyEquipped[Q] = itemName
			if Q < 2 || bShoutEnabled
				updateWidget(Q, 0, false, true)
			endIf
			;And run the rest of the hand equip cycle without actually equipping to toggle ammo mode if needed and update count, poison and charge info
			if Q < 2
				checkAndEquipShownHandItem(Q, false, true)
			endIf
		endIf
		Q += 1
	endWhile
endFunction

function PopulateWidgetArrays()
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
	AddWidget("Complete widget", ".widgetMaster", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, false, "")
	;Main sub-widgets
	AddWidget("Left Hand Widget", ".widgetMaster.LeftHandWidget", 0, 0, 0, 0, 0, -1, 0, None, true, true, false, false, "Left")
	AddWidget("Right Hand Widget", ".widgetMaster.RightHandWidget", 0, 0, 0, 0, 0, 1, 0, None, true, true, false, false, "Right")
	AddWidget("Shout Widget", ".widgetMaster.ShoutWidget", 0, 0, 0, 0, 0, 2, 0, None, true, true, false, false, "Shout")
	AddWidget("Consumable Widget", ".widgetMaster.ConsumableWidget", 0, 0, 0, 0, 0, 3, 0, None, true, true, false, false, "Consumable")
	AddWidget("Poison Widget", ".widgetMaster.PoisonWidget", 0, 0, 0, 0, 0, 4, 0, None, true, true, false, false, "Poison")
	;Left Hand widget components
	AddWidget("Left Hand Background", ".widgetMaster.LeftHandWidget.leftBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Left")
	AddWidget("Left Hand Icon", ".widgetMaster.LeftHandWidget.leftIcon_mc", 0, 0, 0, 0, 0, 6, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Item Name", ".widgetMaster.LeftHandWidget.leftName_mc", 0, 0, 0, 0, 0, 7, 16777215, "Right", true, false, true, false, "Left")
	AddWidget("Left Hand Item Count", ".widgetMaster.LeftHandWidget.leftCount_mc", 0, 0, 0, 0, 0, 8, 16777215, "Center", true, false, true, false, "Left")
	AddWidget("Left Hand Poison Icon", ".widgetMaster.LeftHandWidget.leftPoisonIcon_mc", 0, 0, 0, 0, 0, 9, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Poison Name", ".widgetMaster.LeftHandWidget.leftPoisonName_mc", 0, 0, 0, 0, 0, 10, 12646509, "Right", true, false, true, false, "Left")
	AddWidget("Left Hand Attribute Icons", ".widgetMaster.LeftHandWidget.leftAttributeIcons_mc", 0, 0, 0, 0, 0, 11, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Enchantment Meter", ".widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc", 0, 0, 0, 0, 0, 12, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Soul Gem Icon", ".widgetMaster.LeftHandWidget.leftSoulgem_mc", 0, 0, 0, 0, 0, 13, 0, None, true, false, false, false, "Left")
	;Left Hand Preselect widget components
	AddWidget("Left Hand Preselect Background", ".widgetMaster.LeftHandWidget.leftPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Left")
	AddWidget("Left Hand Preselect Icon", ".widgetMaster.LeftHandWidget.leftPreselectIcon_mc", 0, 0, 0, 0, 0, 15, 0, None, true, false, false, false, "Left")
	AddWidget("Left Hand Preselect Item Name", ".widgetMaster.LeftHandWidget.leftPreselectName_mc", 0, 0, 0, 0, 0, 16, 16777215, "Right", true, false, true, false, "Left")
	AddWidget("Left Hand Preselect Attribute Icons", ".widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 17, 0, None, true, false, false, false, "Left")
	;Right Hand widget components
	AddWidget("Right Hand Background", ".widgetMaster.RightHandWidget.rightBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Right")
	AddWidget("Right Hand Icon", ".widgetMaster.RightHandWidget.rightIcon_mc", 0, 0, 0, 0, 0, 19, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Item Name", ".widgetMaster.RightHandWidget.rightName_mc", 0, 0, 0, 0, 0, 20, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("Right Hand Item Count", ".widgetMaster.RightHandWidget.rightCount_mc", 0, 0, 0, 0, 0, 21, 16777215, "Center", true, false, true, false, "Right")
	AddWidget("Right Hand Poison Icon", ".widgetMaster.RightHandWidget.rightPoisonIcon_mc", 0, 0, 0, 0, 0, 22, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Poison Name", ".widgetMaster.RightHandWidget.rightPoisonName_mc", 0, 0, 0, 0, 0, 23, 12646509, "Left", true, false, true, false, "Right")
	AddWidget("Right Hand Attribute Icons", ".widgetMaster.RightHandWidget.rightAttributeIcons_mc", 0, 0, 0, 0, 0, 24, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Enchantment Meter", ".widgetMaster.RightHandWidget.rightEnchantmentMeter_mc", 0, 0, 0, 0, 0, 25, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Soul Gem Icon", ".widgetMaster.RightHandWidget.rightSoulgem_mc", 0, 0, 0, 0, 0, 26, 0, None, true, false, false, false, "Right")
	;Right Hand Preselect widget components
	AddWidget("Right Hand Preselect Background", ".widgetMaster.RightHandWidget.rightPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Right")
	AddWidget("Right Hand Preselect Icon", ".widgetMaster.RightHandWidget.rightPreselectIcon_mc", 0, 0, 0, 0, 0, 28, 0, None, true, false, false, false, "Right")
	AddWidget("Right Hand Preselect Item Name", ".widgetMaster.RightHandWidget.rightPreselectName_mc", 0, 0, 0, 0, 0, 29, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("Right Hand Preselect Attribute Icons", ".widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 30, 0, None, true, false, false, false, "Right")
	;Shout widget components
	AddWidget("Shout Background", ".widgetMaster.ShoutWidget.shoutBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Shout")
	AddWidget("Shout Icon", ".widgetMaster.ShoutWidget.shoutIcon_mc", 0, 0, 0, 0, 0, 32, 0, None, true, false, false, false, "Shout")
	AddWidget("Shout Name", ".widgetMaster.ShoutWidget.shoutName_mc", 0, 0, 0, 0, 0, 33, 16777215, "Center", true, false, true, false, "Shout")
	;Shout Preselect widget components
	AddWidget("Shout Preselect Background", ".widgetMaster.ShoutWidget.shoutPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Shout")
	AddWidget("Shout Preselect Icon", ".widgetMaster.ShoutWidget.shoutPreselectIcon_mc", 0, 0, 0, 0, 0, 35, 0, None, true, false, false, false, "Shout")
	AddWidget("Shout Preselect Name", ".widgetMaster.ShoutWidget.shoutPreselectName_mc", 0, 0, 0, 0, 0, 36, 16777215, "Center", true, false, true, false, "Shout")
	;Consumable widget components
	AddWidget("Consumable Background", ".widgetMaster.ConsumableWidget.consumableBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Consumable")
	AddWidget("Consumable Icon", ".widgetMaster.ConsumableWidget.consumableIcon_mc", 0, 0, 0, 0, 0, 38, 0, None, true, false, false, false, "Consumable")
	AddWidget("Consumable Name", ".widgetMaster.ConsumableWidget.consumableName_mc", 0, 0, 0, 0, 0, 39, 16777215, "Right", true, false, true, false, "Consumable")
	AddWidget("Consumable Count", ".widgetMaster.ConsumableWidget.consumableCount_mc", 0, 0, 0, 0, 0, 40, 16777215, "Center", true, false, true, false, "Consumable")
	;Poison widget components
	AddWidget("Poison Background", ".widgetMaster.PoisonWidget.poisonBg_mc", 0, 0, 0, 0, 0, -1, 0, None, false, false, false, true, "Poison")
	AddWidget("Poison Icon", ".widgetMaster.PoisonWidget.poisonIcon_mc", 0, 0, 0, 0, 0, 42, 0, None, true, false, false, false, "Poison")
	AddWidget("Poison Name", ".widgetMaster.PoisonWidget.poisonName_mc", 0, 0, 0, 0, 0, 43, 16777215, "Left", true, false, true, false, "Poison")
	AddWidget("Poison Count", ".widgetMaster.PoisonWidget.poisonCount_mc", 0, 0, 0, 0, 0, 44, 16777215, "Center", true, false, true, false, "Poison")
	
endFunction

function AddWidget( string sDescription, string sPath, float fX, float fY, float fS, float fR, float fA, int iD, int iTC, string sTA, bool bV, bool bIsParent, bool bIsText, bool bIsBg, string sGroup)
	int iIndex = 0
	while iIndex < asWidgetDescriptions.Length && asWidgetDescriptions[iIndex] != ""
		iIndex += 1
	endWhile
	if iIndex >= asWidgetDescriptions.Length
		Debug.MessageBox("iEquip: Failed to add widget to arrays (" + sDescription + ")")
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
endFunction

function getAndStoreDefaultWidgetValues()
	afWidget_DefX = new float[46]
	afWidget_DefY = new float[46]
	afWidget_DefS = new float[46]
	afWidget_DefR = new float[46]
	afWidget_DefA = new float[46]
	aiWidget_DefD = new int[46]
	asWidget_DefTA = new string[46]
	aiWidget_DefTC = new int[46]
	abWidget_DefV = new bool[46]
	int iIndex = 0
	string Element = ""
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
endFunction

function ResetWidgetArrays()
	int iIndex = 0
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
endFunction

function setCurrentQueuePosition(int Q, int iIndex)
	debug.trace("iEquip_WidgetCore setCurrentQueuePosition called - Q: " + Q + ", iIndex: " + iIndex)
	if iIndex == -1
		iIndex = 0
	endIf
	aiCurrentQueuePosition[Q] = iIndex
	asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "Name")
endFunction

bool function itemRequiresCounter(int Q, int itemType = -1, string itemName = "")
	debug.trace("iEquip_WidgetCore itemRequiresCounter called")
	bool requiresCounter = false
	int itemObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	if itemType == -1
		itemType = jMap.getInt(itemObject, "Type")
	endIf
	if itemName == ""
		itemName = jMap.getStr(itemObject, "Name")
	endIf
	debug.trace("iEquip_WidgetCore itemRequiresCounter itemType: " + itemType + ", itemName: " + itemName)
	if itemType == 42 || itemType == 23 || itemType == 31 ;Ammo (which takes in Throwing Weapons), scroll, torch
		requiresCounter = true
    elseif itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb", 0) > -1) ;Looking for CACO grenades here which are classed as maces
    	requiresCounter = true
    else
    	requiresCounter = false
    endIf
    debug.trace("iEquip_WidgetCore itemRequiresCounter returning " + requiresCounter)
    return requiresCounter
endFunction

function setSlotCount(int Q, int count)
	debug.trace("iEquip_WidgetCore setSlotCount called - Q: " + Q + ", count: " + count)
	int[] widgetData = new int[2]
	widgetData[0] = Q
	widgetData[1] = count
	UI.invokeIntA(HUD_MENU, WidgetRoot + ".updateCounter", widgetData)
endFunction

;-----------------------------------------------------------------------------------------------------------------------
;QUEUE FUNCTIONALITY CODE
;-----------------------------------------------------------------------------------------------------------------------

function cycleSlot(int Q, bool Reverse = false, bool ignoreEquipOnPause = false, bool onItemRemoved = false)
	debug.trace("iEquip_WidgetCore cycleSlot called, Q: " + Q + ", Reverse: " + Reverse)
	debug.trace("iEquip_WidgetCore cycleSlot - abIsNameShown[Q]: " + abIsNameShown[Q])
	;Q: 0 = Left hand, 1 = Right hand, 2 = Shout, 3 = Consumables, 4 = Poisons

	;Check if queue contains anything and return out if not
	int targetArray = aiTargetQ[Q]
	int queueLength = JArray.count(targetArray)
	debug.trace("iEquip_WidgetCore cycleSlot - queueLength: " + queueLength)
	if queueLength == 0
		debug.notification("Your " + asQueueName[Q] + " is currently empty")
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

	elseIf queueLength > 1 || onItemRemoved || (Q < 3 && abQueueWasEmpty[Q])
		if Q < 3
			abQueueWasEmpty[Q] = false
		elseIf Q == 3
			CFUpdate.unregisterForConsumableFadeUpdate()
		endIf
		;Hide the slot counter, poison info and charge meter if currently shown
		if Q < 2 
			if abIsCounterShown[Q]
				setCounterVisibility(Q, false)
			endIf
			if abPoisonInfoDisplayed[Q]
				hidePoisonInfo(Q)
			endIf
			if CM.abIsChargeMeterShown[Q]
				CM.updateChargeMeterVisibility(Q, false)
			endIf
		endIf
		;Make sure we're starting from the correct index, in case somehow the queue has been amended without the aiCurrentQueuePosition array being updated
		if asCurrentlyEquipped[Q] != ""
			aiCurrentQueuePosition[Q] = findInQueue(Q, asCurrentlyEquipped[Q])
		endIf
		;In the unlikely event that the item currently shown in the widget has not been found in the queue array then start cycling from index 0
		if aiCurrentQueuePosition[Q] == -1
			aiCurrentQueuePosition[Q] = 0
		endIf
		;Check if we're moving forwards or backwards in the queue
		int move = 1
		if Reverse
			move = -1
		endIf
		int	targetIndex
		int otherHand = 0
	    if Q == 0
	    	otherHand = 1
	    endIf
	    form targetItem
	    string targetName
		if queueLength > 1
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
		    	targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")
		    	bool hideEmptyPotionGroups = (PO.iEmptyPotionQueueChoice == 1)
			    if Q == 3
		            while (targetName == "Health Potions" && (!bHealthPotionGrouping || (hideEmptyPotionGroups && abPotionGroupEmpty[0]))) || (targetName == "Stamina Potions" && (!bStaminaPotionGrouping || (hideEmptyPotionGroups && abPotionGroupEmpty[1]))) || (targetName == "Magicka Potions" && (!bMagickaPotionGrouping || (hideEmptyPotionGroups && abPotionGroupEmpty[2])))
		                targetIndex = targetIndex + move
		                if targetIndex < 0 && Reverse
		                    targetIndex = queueLength - 1
		                elseif targetIndex == queueLength && !Reverse
		                    targetIndex = 0
		                endIf
		                targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")
		            endWhile
			    elseIf Q < 3
			    	targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "Form")
			        while Q < 2 && targetItem == PlayerRef.GetEquippedObject(otherHand) && (PlayerRef.GetItemCount(targetItem) < 2) && !bAllowWeaponSwitchHands
			            targetIndex = targetIndex + move
			            if targetIndex < 0 && Reverse
			                targetIndex = queueLength - 1
			            elseif targetIndex == queueLength && !Reverse
			                targetIndex = 0
			            endIf
			            targetItem = jMap.getForm(jArray.getObj(targetArray, targetIndex), "Form")
			            targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")
			        endWhile
			    else
			        debug.trace("Error Occured")
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
		int targetObject = jArray.getObj(targetArray, targetIndex)
		int itemType
		bool isPotionGroup = false
		if Q == 3 && stringutil.Find(targetName, "Potions", 0) > -1
			isPotionGroup = true
			targetItem = none
		else
			targetItem = jMap.getForm(targetObject, "Form")
		endIf
		if Q < 2
			itemType = jMap.getInt(targetObject, "Type")
			if bSwitchingHands || bPreselectSwitchingHands
				debug.trace("iEquip_WidgetCore cycleSlot - Q: " + Q + ", bSwitchingHands: " + bSwitchingHands)
				;if we're forcing the left hand to switch equipped items because we're switching left to right, make sure we don't leave the left hand unarmed
				if Q == 1
					AM.bAmmoModePending = false
					; Check if initial target item is 2h or ranged, or if it is a 1h item but you only have one of it and you've just equipped it in the other hand, or if it is unarmed
					int itemCount = PlayerRef.GetItemCount(targetItem)
					if (itemType == 0 || itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9) || ((asCurrentlyEquipped[0] == jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")) && itemCount < 2)
						int newTarget = targetIndex + 1
						if newTarget >= queueLength
							newTarget = 0
						endIf
						bool matchFound = false
						; if it is then starting from the currently equipped index search forward for a 1h item
						while newTarget != targetIndex && !matchFound
							targetObject = jArray.getObj(targetArray, newTarget)
							targetItem = jMap.getForm(targetObject, "Form")
							itemType = jMap.getInt(targetObject, "Type")
							itemCount = PlayerRef.GetItemCount(targetItem)
							; if the new target item is 2h or ranged, or if it is a 1h item but you only have one of it and it's already equipped in the other hand, or it is unarmed then move on again
							if (itemType == 0 || itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9) || ((asCurrentlyEquipped[0] == jMap.getStr(targetObject, "Name")) && itemCount < 2)
								newTarget += 1
								;if we have reached the final index in the array then loop to the start and keep counting forward until we reach the original starting point
								if newTarget == queueLength
									newTarget = 0
								endIf				
							else
								matchFound = true
							endIf
						endwhile
						; if no suitable items found in either search then don't re-equip anything 
						if !matchFound
							return
						else
							targetIndex = newTarget ; if a 1h item has been found then set it as the new targetIndex
						endIf
					endIf
				endIf
			endIf
			if bSwitchingHands || bPreselectSwitchingHands
				ignoreEquipOnPause = true
			endIf
		endIf
		if Q == 4 && bPoisonIconFaded
			checkAndFadePoisonIcon(false)
			Utility.Wait(0.3)
		endIf
		;Update the widget to the next queued item immediately then register for bEquipOnPause update or call cycle functions straight away
		aiCurrentQueuePosition[Q] = targetIndex
		asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")
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
			checkAndEquipShownShoutOrConsumable(Q, Reverse, targetIndex, targetItem, isPotionGroup)
		endIf
		debug.trace("iEquip_WidgetCore cycleSlot ends")
	endIf
endFunction

function checkAndEquipShownHandItem(int Q, bool Reverse = false, bool equippingOnAutoAdd = false, bool calledByQuickRanged = false)
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem called - Q: " + Q + ", Reverse: " + Reverse + ", equippingOnAutoAdd: " + equippingOnAutoAdd)
	int targetIndex = aiCurrentQueuePosition[Q]
	int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    Form targetItem = jMap.getForm(targetObject, "Form")
    int itemType = jMap.getInt(targetObject, "Type")
    PM.bCurrentlyQuickRanged = false
    PM.bCurrentlyQuickHealing = false
    if itemType == 7 || itemType == 9
    	AM.checkAndRemoveBoundAmmo(itemType)
    endIf
    bool doneHere = false
    if !equippingOnAutoAdd
	    ;if we're equipping Fists
	    if Q == 1 && itemType == 0
			goUnarmed()
			doneHere = true  
	    ;if you already have the item/shout equipped in the slot you are cycling then do nothing
	    elseif (targetItem == PlayerRef.GetEquippedObject(Q)) || targetItem == None
	    	doneHere = true
		;if somehow the item has been removed from the player and we haven't already caught it remove it from queue and advance queue again
		elseif !playerStillHasItem(targetItem)
			iEquip_AllCurrentItemsFLST.RemoveAddedForm(targetItem)
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			if bEnableRemovedItemCaching
				AddItemToLastRemovedCache(Q, targetIndex)
			endIf
			if bMoreHUDLoaded
		        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "itemID"))
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
	if !doneHere
		debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - player still has item, Q: " + Q + ", aiCurrentQueuePosition: " + aiCurrentQueuePosition[Q] + ", itemName: " + jMap.getStr(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "Name"))
		;if we're about to equip a ranged weapon and we're not already in Ammo Mode or we're switching ranged weapon type set the ammo queue to the first ammo in the array and then animate in if needed
		debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - bAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
		if Q == 1
			;if we're equipping a ranged weapon
			if (itemType == 7 || itemType == 9)
				;Firstly we need to update the relevant ammo list.  We'll update the widget once the weapon is equipped
				bool skipSetCount = false
				if !bAmmoMode
					if bLeftIconFaded
						checkAndFadeLeftIcon(1, 7)
						Utility.Wait(0.2)
					endIf
					if !calledByQuickRanged
						AM.selectAmmoQueue(itemType)
					endIf
				elseif (AM.switchingRangedWeaponType(itemType) || AM.iAmmoListSorting == 3)  && !calledByQuickRanged
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
					AM.toggleAmmoMode() ;Animate in
				endIf
				if !isWeaponPoisoned(1, aiCurrentQueuePosition[1]) && abIsCounterShown[1]
					setCounterVisibility(1, false)
				endIf
			;if we're already in Ammo Mode and about to equip something in the right hand which is not another ranged weapon then we need to toggle out of Ammo Mode
			elseIf bAmmoMode
				;Animate out without equipping the left hand item, we'll handle this later once right hand re-equipped
				AM.toggleAmmoMode(false, true)
				;if we've still got the shown ammo equipped and have enabled Unequip Ammo in the MCM then unequip it now
				ammo currentAmmo = AM.currentAmmoForm as Ammo
				if currentAmmo != none && PlayerRef.isEquipped(currentAmmo) && bUnequipAmmo
					PlayerRef.UnequipItemEx(currentAmmo)
				endIf
				bJustLeftAmmoMode = true
			endIf
			;if we're equipping a 2H item in the right hand from bGoneUnarmed then we need to update the left slot back to the item prior to going unarmed before fading the left icon if required
			if bGoneUnarmed && (itemType == 5 || itemType == 6)
	    		updateWidget(0, aiCurrentQueuePosition[0])
	    		targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
	    		if itemRequiresCounter(0, jMap.getInt(targetObject, "Type"))
					setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "Form")))
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
				if !abIsCounterShown[Q]
					setCounterVisibility(Q, true)
				endIf
			;The new item doesn't require a counter to hide it if it's currently shown
			elseif abIsCounterShown[Q]
				setCounterVisibility(Q, false)
			endIf
		endIf
		;Now that we've passed all the checks we can carry on and equip
		cycleHand(Q, targetIndex, targetItem, itemType, equippingOnAutoAdd)
		Utility.Wait(0.2)
		if bJustLeftAmmoMode
			bJustLeftAmmoMode = false
			Utility.Wait(0.3)
		endIf
		checkAndFadeLeftIcon(Q, itemType)
	endIf
endFunction

function checkAndFadeLeftIcon(int Q, int itemType)
	debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon called - Q: " + Q + ", itemType: " + itemType + ", bFadeLeftIconWhen2HEquipped: " + bFadeLeftIconWhen2HEquipped + ", bLeftIconFaded: " + bLeftIconFaded)
	;if we're equipping 2H or ranged then check and fade left icon
	float[] widgetData = new float[6]
	if Q == 1 && bFadeLeftIconWhen2HEquipped && (itemType == 5 || itemType == 6) && !bLeftIconFaded
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01))
		widgetData[0] = afWidget_A[6] * adjustment ;leftBg_mc
		widgetData[1] = afWidget_A[7] * adjustment ;leftIcon_mc
		if abIsNameShown[0]
			widgetData[2] = afWidget_A[8] * adjustment ;leftName_mc
		else
			widgetData[2] = 0
		endIf
		if abIsCounterShown[0]
			widgetData[3] = afWidget_A[9] * adjustment ;leftCount_mc
		else
			widgetData[3] = 0
		endIf
		if isWeaponPoisoned(0, aiCurrentQueuePosition[0])
			widgetData[4] = afWidget_A[10] * adjustment ;leftPoisonIcon_mc
			if abIsPoisonNameShown[0]
				widgetData[5] = afWidget_A[11] * adjustment ;leftPoisonName_mc
			else
				widgetData[5] = 0
			endIf
		else
			widgetData[4] = 0
			widgetData[5] = 0
		endIf
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		bLeftIconFaded = true
	;For anything else check if it is currently faded and if so fade it back in
	elseif Q < 2 && bLeftIconFaded && !AM.bAmmoModePending
		widgetData[0] = afWidget_A[6]
		widgetData[1] = afWidget_A[7]
		if abIsNameShown[0]
			widgetData[2] = afWidget_A[8]
		else
			widgetData[2] = 0
		endIf
		if abIsCounterShown[0]
			widgetData[3] = afWidget_A[9]
		else
			widgetData[3] = 0
		endIf
		if isWeaponPoisoned(0, aiCurrentQueuePosition[0])
			widgetData[4] = afWidget_A[10]
			if abIsPoisonNameShown[0]
				widgetData[5] = afWidget_A[11]
			else
				widgetData[5] = 0
			endIf
		else
			widgetData[4] = 0
			widgetData[5] = 0
		endIf
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		bLeftIconFaded = false
	endIf
endFunction

function checkAndEquipShownShoutOrConsumable(int Q, bool Reverse, int targetIndex, form targetItem, bool isPotionGroup)
	debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable called - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", isPotionGroup: " + isPotionGroup)
	if (targetItem && targetItem != none && !playerStillHasItem(targetItem)) || (Q == 3 && targetItem == none && !isPotionGroup)
		if bEnableRemovedItemCaching
			AddItemToLastRemovedCache(Q, targetIndex)
		endIf
		if bMoreHUDLoaded
	        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "itemID"))
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
endFunction

function checkAndFadeConsumableIcon(bool fadeOut)
	debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon called - fadeOut: " + fadeOut + ", bConsumableIconFaded: " + bConsumableIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01)) ;Use same value as left icon fade for consistency
		widgetData[0] = afWidget_A[38] * adjustment ;consumableBg_mc
		widgetData[1] = afWidget_A[39] * adjustment ;consumableIcon_mc
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[40] * adjustment ;consumableName_mc
		else
			widgetData[2] = 0.0
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
		else
			widgetData[2] = 0.0
		endIf
		widgetData[3] = afWidget_A[41]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		bConsumableIconFaded = false
	endIf
endFunction

function checkAndFadePoisonIcon(bool fadeOut)
	debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon called - fadeOut: " + fadeOut + ", bPoisonIconFaded: " + bPoisonIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (fLeftIconFadeAmount * 0.01)) ;Use same value as left icon fade for consistency
		widgetData[0] = afWidget_A[42] * adjustment ;poisonBg_mc
		widgetData[1] = afWidget_A[43] * adjustment ;poisonIcon_mc
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[44] * adjustment ;poisonName_mc
		else
			widgetData[2] = 0.0
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
		else
			widgetData[2] = 0.0
		endIf
		widgetData[3] = afWidget_A[45]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenPoisonIconAlpha", widgetData)
		bPoisonIconFaded = false
	endIf
endFunction

function setCounterVisibility(int Q, bool show)
	debug.trace("iEquip_WidgetCore setCounterVisibility called - Q: " + Q + ", show: " + show)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetCounterAlpha")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which counter _mc we're fading out
		if show
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
endFunction

function updateSlotsEnabled()
	debug.trace("iEquip_WidgetCore updateSlotsEnabled called - bShoutEnabled: " + bShoutEnabled + ", bConsumablesEnabled: " + bConsumablesEnabled + ", bPoisonsEnabled: " + bPoisonsEnabled)
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", bShoutEnabled)
	abWidget_V[3] = bShoutEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ConsumableWidget._visible", bConsumablesEnabled)
	abWidget_V[4] = bConsumablesEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget._visible", bPoisonsEnabled)
	abWidget_V[5] = bPoisonsEnabled
	EH.bPoisonSlotEnabled = bPoisonsEnabled
	;Hide poison indicators, counts and names
	if !bPoisonsEnabled
		int i = 0
		while i < 2
			if abPoisonInfoDisplayed[i]
				hidePoisonInfo(i)
			endIf
			i += 1
		endwhile
	endIf
endFunction

function updateWidget(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	debug.trace("iEquip_WidgetCore updateWidget called - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bPreselectSwitchingHands: " + bPreselectSwitchingHands + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	;if we are in Preselect Mode make sure we update the preselect icon and name, otherwise update the main icon and name
	string sIcon
	string sName
	int targetObject
	int Slot = Q

	if bRefreshingWidgetOnLoad && Q > 4
		debug.trace("iEquip_WidgetCore updateWidget - 1st option")
		targetObject = jArray.getObj(aiTargetQ[Q - 5], iIndex)
	elseif (bPreselectMode && !overridePreselect && !bPreselectSwitchingHands && Q <= 2) || bCyclingLHPreselectInAmmoMode
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
	sIcon = jMap.getStr(targetObject, "Icon")
	sName = jMap.getStr(targetObject, "Name")
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
endFunction

function setSlotToEmpty(int Q, bool hidePoisonCount = true, bool leaveFlag = false)
	debug.trace("iEquip_WidgetCore setSlotToEmpty called - Q: "+Q+", hidePoisonCount: "+hidePoisonCount+", LeaveFlag: "+LeaveFlag)
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
			UICallback.PushString(iHandle, "Unarmed") ;New name
		else
			debug.trace("iEquip_WidgetCore setSlotToEmpty - should be setting "+asQueueName[Q]+" to Empty")
			UICallback.PushString(iHandle, "Empty") ;New icon
			UICallback.PushString(iHandle, "") ;New name
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
		UICallback.Send(iHandle)
	endIf
	if Q != 3 || (!bHealthPotionGrouping && !bStaminaPotionGrouping && !bMagickaPotionGrouping)
		asCurrentlyEquipped[Q] = ""
	endIf
	; Hide any additional elements currently displayed
	if Q < 2
		if abPoisonInfoDisplayed[Q]
			hidePoisonInfo(Q, true)
		endIf
		if CM.abIsChargeMeterShown[Q]
			CM.updateChargeMeterVisibility(Q, false)
		endIf
		if abIsCounterShown[Q]
			setCounterVisibility(Q, false)
		endIf
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
endFunction

function handleEmptyPoisonQueue()
	debug.trace("iEquip_WidgetCore handleEmptyPoisonQueue called")
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
		Utility.Wait(1.2)
	endIf
	if PO.iEmptyPotionQueueChoice == 0 ;Fade icon
		checkAndFadePoisonIcon(true)
	else
		setSlotToEmpty(4, false)
	endIf
endFunction

function checkIfBoundSpellEquipped()
	debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped called")
	bool boundSpellEquipped = false
	string spellName
	int hand = 0
	while hand < 2
		if PlayerRef.GetEquippedItemType(hand) == 9 && PlayerRef.GetEquippedSpell(hand)
			spellName = (PlayerRef.GetEquippedSpell(hand)).GetName()
			if stringutil.Find(spellName, "bound", 0) > -1
				boundSpellEquipped = true
			endIf
		endIf
		hand += 1
	endWhile
	;If the player has a 'Bound' spell equipped in either hand the event handler script registers for ActorAction 2 - Spell Fire, if not it unregisters for the action
	EH.boundSpellEquipped = boundSpellEquipped
endFunction

;Called from iEquip_PlayerEventHandler when OnActorAction receives actionType 2 (should only ever happen when the player has a 'Bound' spell equipped in either hand)
function onBoundWeaponEquipped(Int weaponType, Int hand)
	debug.trace("iEquip_WidgetCore onBoundWeaponEquipped called")
	;weapon equippedWeapon = PlayerRef.GetEquippedObject(hand) as Weapon	
	string iconName = "Bound"
	if weaponType == 6 && (PlayerRef.GetEquippedObject(hand) as Weapon).IsWarhammer()
        iconName += "Warhammer"
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
endFunction

function onBoundWeaponUnequipped(weapon a_weap, int hand)
	debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped called - bBlockSwitchBackToBoundSpell: " + bBlockSwitchBackToBoundSpell)
	if bBlockSwitchBackToBoundSpell
		bBlockSwitchBackToBoundSpell = false
	else
		if PlayerRef.GetEquippedItemType(hand) == 9 && (PlayerRef.GetEquippedObject(hand)).GetName() == a_weap.GetName()
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
			;Switch back to the spell icon from the bound weapon icon without updating the name as it should be the same anyway
			if(iHandle)
				UICallback.PushInt(iHandle, hand) ;Target icon to update: left = 0, right  = 1
				UICallback.PushString(iHandle, "Conjuration") ;New icon label name
				UICallback.Send(iHandle)
			endIf
			if bAmmoMode
				AM.toggleAmmoMode()
			endIf
			if bLeftIconFaded
				checkAndFadeLeftIcon(hand, 9)
			endIf
		else
			debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped - couldn't match removed bound weapon to an equipped spell")
		endIf
	endIf
endFunction

function showName(int Q, bool fadeIn = true, bool targetingPoisonName = false, float fadeoutDuration = 0.3)
	debug.trace("iEquip_WidgetCore showName called, Q: " + Q + ", fadeIn: " + fadeIn + ", targetingPoisonName: " + targetingPoisonName + ", fadeoutDuration: " + fadeoutDuration) 

	float fNameAlpha
	if !fadeIn
		fNameAlpha = 0
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
endFunction

function updateAttributeIcons(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	debug.trace("iEquip_WidgetCore updateAttributeIcons called - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
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
endFunction

function hideAttributeIcons(int Q)
	debug.trace("iEquip_WidgetCore hideAttributeIcons called - Q: "+ Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		UICallback.PushString(iHandle, "hidden") ;New attributes
		UICallback.Send(iHandle)
	endif
endFunction

int function findInQueue(int Q, string itemToFind)
	debug.trace("iEquip_WidgetCore findInQueue called")
	int iIndex = 0
	bool found = false
	while iIndex < jArray.count(aiTargetQ[Q]) && !found
		if itemToFind != jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "Name")
			iIndex += 1
		else
			found = true
		endIf
	endwhile
	if found
		return iIndex
	else
		return -1
	endIf
endFunction

function removeItemFromQueue(int Q, int iIndex, bool purging = false, bool cyclingAmmo = false, bool onItemRemoved = false, bool addToCache = true)
	debug.trace("iEquip_WidgetCore removeItemFromQueue called - Q: " + Q + ", iIndex: " + iIndex + ", purging: " + purging + ", cyclingAmmo: " + cyclingAmmo + ", onItemRemoved: " + onItemRemoved + ", addToCache: " + addToCache)
	if bEnableRemovedItemCaching && addToCache && !purging
		AddItemToLastRemovedCache(Q, iIndex)
	endIf
	if bMoreHUDLoaded
		int otherHand = 1
		if Q == 1
			otherHand = 0
		endIf
		AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "itemID"))
		if Q < 2 && findInQueue(otherHand, jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "Name")) != -1
			AhzMoreHudIE.AddIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "itemID"), asMoreHUDIcons[otherHand])
        endIf
    endIf
    int itemType = jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "Type")
	jArray.eraseIndex(aiTargetQ[Q], iIndex)
	int queueLength = jArray.count(aiTargetQ[Q])
	int enabledPotionGroupCount = 0
	if Q == 3
		if bHealthPotionGrouping && !(abPotionGroupEmpty[0] && PO.iEmptyPotionQueueChoice == 1)
			enabledPotionGroupCount += 1
		endIf
		if bStaminaPotionGrouping && !(abPotionGroupEmpty[1] && PO.iEmptyPotionQueueChoice == 1)
			enabledPotionGroupCount += 1
		endIf
		if bMagickaPotionGrouping && !(abPotionGroupEmpty[2] && PO.iEmptyPotionQueueChoice == 1)
			enabledPotionGroupCount += 1
		endIf
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
				bool actionTaken = false
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
		if Q == 4 && (bHealthPotionGrouping || bStaminaPotionGrouping || bMagickaPotionGrouping)
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
endFunction

function reduceMaxQueueLength()
	debug.trace("iEquip_WidgetCore reduceMaxQueueLength called")
	if iMaxQueueLength < 3 && bPreselectMode
		PM.togglePreselectMode()
	endIf
	int i = 0
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
endFunction

function AddItemToLastRemovedCache(int Q, int iIndex)
	debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache called")
	if jArray.count(iRemovedItemsCacheObj) == iMaxCachedItems ;Max number of removed items to cache for re-adding
		iEquip_RemovedItemsFLST.RemoveAddedForm(jMap.getForm(jArray.getObj(iRemovedItemsCacheObj, 0), "Form"))
		jArray.eraseIndex(iRemovedItemsCacheObj, 0)
	endIf
	int objToCache = jArray.getObj(aiTargetQ[Q], iIndex)
	jMap.setInt(objToCache, "PrevQ", Q)
	jArray.addObj(iRemovedItemsCacheObj, objToCache)
	iEquip_RemovedItemsFLST.AddForm(jMap.getForm(objToCache, "Form"))
endFunction

function addBackCachedItem(form addedForm)
	debug.trace("iEquip_WidgetCore addBackCachedItem called")
	int iIndex = 0
	int targetObject
	bool found = false
	while iIndex < jArray.count(iRemovedItemsCacheObj) && !found
		targetObject = jArray.getObj(iRemovedItemsCacheObj, iIndex)
		if addedForm == jMap.getForm(targetObject, "Form")
			int Q
			int itemType = jMap.getInt(targetObject, "Type")
			;Check if the re-added item has been equipped in either hand and set that as the target queue
			if PlayerRef.GetEquippedObject(0) == addedForm && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
				Q = 0
			elseIf PlayerRef.GetEquippedObject(1) == addedForm
				Q = 1
			;Otherwise add the item back into the queue it was previously removed from
			else
				Q = jMap.getInt(targetObject, "PrevQ")
			endIf
			jArray.addObj(aiTargetQ[Q], targetObject)
			;Remove the form from the RemovedItems formlist
			iEquip_RemovedItemsFLST.RemoveAddedForm(jMap.getForm(targetObject, "Form"))
			;Add it back into the AllCurrentItems formlist
			iEquip_AllCurrentItemsFLST.AddForm(jMap.getForm(targetObject, "Form"))
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			;Add it back to the moreHUD array
			if bMoreHUDLoaded
				AhzMoreHudIE.AddIconItem(jMap.getInt(targetObject, "itemID"), asMoreHUDIcons[jMap.getInt(targetObject, "PrevQ")])
    		endIf
			;Remove the cached object from the cache jArray
			jArray.eraseIndex(iRemovedItemsCacheObj, iIndex)
			found = true
		else
			iIndex += 1
		endIf
	endwhile
endFunction

bool function playerStillHasItem(form itemForm)
	debug.trace("iEquip_WidgetCore playerStillHasItem called - itemForm: " + itemForm)
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
    return stillHasItem
endFunction

function cycleHand(int Q, int targetIndex, form targetItem, int itemType = -1, bool equippingOnAutoAdd = false)
    ;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
    debug.trace("iEquip_WidgetCore cycleHand called - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", itemType: " + itemType)
   	int iEquipSlotId = 1
    int otherHand = 0
    bool justSwitchedHands = false
    bool previously2H = false
    bool targetWeaponIs2hOrRanged = (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
    bBlockSwitchBackToBoundSpell = true
    int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    if itemType == -1
    	itemType = jMap.getInt(targetObject, "Type")
    endIf
    ;Hide the attribute icons ready to show full poison and enchantment elements if required
    hideAttributeIcons(Q)
    
    if Q == 0
    	iEquipSlotId = 2
    	otherHand = 1
    else
    	previously2H = RightHandWeaponIs2h()
    endIf
	debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", iEquipSlotId = " + iEquipSlotId + ", otherHand = " + otherHand + ", bSwitchingHands = " + bSwitchingHands + ", bGoneUnarmed = " + bGoneUnarmed)
	;if we're switching hands we can reset to false now, and we don't need to unequip here because we already did so when we started switching hands
	if bSwitchingHands
		bSwitchingHands = false
		justSwitchedHands = true
	elseif !bGoneUnarmed && !equippingOnAutoAdd
		;Otherwise unequip current item
		UnequipHand(Q)
	endIf
	;if we're switching the left hand and it is going to cause a 2h or ranged weapon to be unequipped from the right hand then we need to ensure a suitable 1h item is equipped in its place
    if (Q == 0 && RightHandWeaponIs2hOrRanged()) || (bGoneUnarmed && !targetWeaponIs2hOrRanged) || targetWeaponIs2hOrRanged
    	if !targetWeaponIs2hOrRanged
    		bSwitchingHands = true
    	endIf
    	debug.trace("iEquip_WidgetCore cycleHand - Q == 0 && RightHandWeaponIs2hOrRanged: " + RightHandWeaponIs2hOrRanged() + ", bGoneUnarmed: " + bGoneUnarmed + ", itemType: " + itemType + ", bSwitchingHands: " + bSwitchingHands)
    	if !bGoneUnarmed
    		UnequipHand(otherHand)
    	endIf
    endif
    ;if we are re-equipping from an unarmed state
    if bGoneUnarmed
		bGoneUnarmed = false
	endIf
	if !equippingOnAutoAdd
		;if target item is a spell equip straight away
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
			if bProModeEnabled && bQuickDualCastEnabled && !justSwitchedHands && !bPreselectMode
				string spellSchool = jMap.getStr(jArray.getObj(aiTargetQ[Q], targetIndex), "Icon")
				string spellName = targetItem.GetName()
				if (spellSchool == "Destruction" && bQuickDualCastDestruction) || (spellSchool == "Alteration" && bQuickDualCastAlteration) || (spellSchool == "Illusion" && bQuickDualCastIllusion) || (spellSchool == "Restoration" && bQuickDualCastRestoration) || (spellSchool == "Conjuration" && bQuickDualCastConjuration && (asBound2HWeapons.find(spellName) == -1))
					debug.trace("iEquip_WidgetCore cycleHand - about to QuickDualCast")
					if PM.quickDualCastEquipSpellInOtherHand(Q, targetItem, jMap.getStr(targetObject, "Name"), spellSchool)
						bSwitchingHands = false ;Just in case equipping the original spell triggered bSwitchingHands then as long as we have successfully dual equipped the spell we can cancel bSwitchingHands now
					endIf
				endIf
			endIf
		else
			;if item is anything other than a spell check if it is already equipped, possibly in the other hand, and there is only 1 of it
			int itemCount = PlayerRef.GetItemCount(targetItem)
		    if (targetItem == PlayerRef.GetEquippedObject(otherHand)) && itemCount < 2
		    	debug.trace("iEquip_WidgetCore cycleHand - targetItem found in other hand and only one of them")
		    	;if it is already equipped and player has allowed switching hands then unequip the other hand first before equipping the target item in this hand
		        if bAllowWeaponSwitchHands
		        	bSwitchingHands = true
		        	debug.trace("iEquip_WidgetCore cycleHand - bSwitchingHands: " + bSwitchingHands)
		        	UnequipHand(otherHand)
		        else
		        	debug.notification(jMap.getStr(targetObject, "Name") + " is already equipped in your other hand")
		        	return
		        endIf
		    endIf
		    ;Equip target item
		    debug.trace("iEquip_WidgetCore cycleHand - about to equip " + jMap.getStr(targetObject, "Name") + " into slot " + Q)
		    Utility.Wait(0.1)
		    if (Q == 1 && itemType == 42) ;Ammo in the right hand queue, so in this case grenades and other throwing weapons
		    	PlayerRef.EquipItemEx(targetItem as Ammo)
		    elseif ((Q == 0 && itemType == 26) || jMap.getStr(targetObject, "Name") == "Rocket Launcher") ;Shield in the left hand queue
		    	PlayerRef.EquipItemEx(targetItem as Armor)
		    else
		    	int itemID = jMap.getInt(targetObject, "itemID")
		    	if itemID != 0
		    		PlayerRef.EquipItemByID(targetItem, itemID, iEquipSlotID)
		    	else
		    		PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
		    	endIf
		    endIf
		endIf
		Utility.Wait(0.2)
	endIf
	checkAndUpdatePoisonInfo(Q)
	CM.checkAndUpdateChargeMeter(Q)
	checkIfBoundSpellEquipped()
	if (itemType == 7 || itemType == 9) && bAmmoModeFirstLook
		Utility.Wait(0.5)
		Debug.MessageBox("iEQUIP Ammo Mode\n\nYou have equipped a ranged weapon for the first time using iEquip and you will see that the left hand widget is now showing the first ammo in your ammo queue. if you have enabled ammo sorting in the MCM then this will either be the ammo with the highest base damage, or the first alphabetically\nThe smaller icon shows the item you will re-equip when you unequip your ranged weapon.")
		Debug.MessageBox("iEQUIP Ammo Mode Controls\n\nSingle press left hotkey cycles the ammo\n\nDouble press left hotkey cycles the left hand item shown in the smaller icon ready for re-equipping\n\nCycling your right hand will return the left hand widget to the regular state, or you can longpress the left hotkey to re-equip the left hand item shown and swap your ranged weapon for a 1H item in the right hand")
		bAmmoModeFirstLook = false
	endIf
	;if we've just equipped a 1H item in RH forcing toggleAmmoMode, now we can re-equip the left hand making sure to block QuickDualCast
	if Q == 1 && (bJustLeftAmmoMode || previously2H) && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
		targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
		int leftType = jMap.getInt(targetObject, "Type")
		PM.bBlockQuickDualCast = (leftType == 22)
		debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", bJustLeftAmmoMode: " + bJustLeftAmmoMode + ", about to equip left hand item of type: " + leftType + ", blockQuickDualCast: " + PM.bBlockQuickDualCast)
		cycleHand(0, aiCurrentQueuePosition[0], jMap.getForm(targetObject, "Form"))
    ;if we unequipped the other hand now equip the next item
    elseif bSwitchingHands
    	debug.trace("iEquip_WidgetCore cycleHand - bSwitchingHands = " + bSwitchingHands + ", calling cycleSlot(" + otherHand + ", false)")
    	Utility.Wait(0.1)
		cycleSlot(otherHand, false)
	endIf
	if bEnableGearedUp
		refreshGearedUp()
	endIf
	bBlockSwitchBackToBoundSpell = false
	debug.trace("iEquip_WidgetCore cycleHand finished")
endFunction

bool function RightHandWeaponIs2hOrRanged(int itemType = -1)
	if itemType == 9
		itemType = 12
	elseIf itemType == -1
		itemType = PlayerRef.GetEquippedItemType(1)
	endIf
	debug.trace("iEquip_WidgetCore RightHandWeaponIs2hOrRanged - itemType: " + itemType)
	return (itemType == 5 || itemType == 6 || itemType == 7 || itemType == 12) ;GetEquippedItemType returns 12 rather than 9 for Crossbow
endFunction

bool function RightHandWeaponIs2h(int itemType = -1)
	if itemType == -1
		itemType = PlayerRef.GetEquippedItemType(1)
	endIf
	debug.trace("iEquip_WidgetCore RightHandWeaponIs2h - itemType: " + itemType)
	return (itemType == 5 || itemType == 6)
endFunction

bool function RightHandWeaponIsRanged(int itemType = -1)
	if itemType == 9
		itemType = 12
	elseIf itemType == -1
		itemType = PlayerRef.GetEquippedItemType(1)
	endIf
	debug.trace("iEquip_WidgetCore RightHandWeaponIsRanged - itemType: " + itemType)
	return (itemType == 7 || itemType == 12) ;GetEquippedItemType returns 12 rather than 9 for Crossbow
endFunction

function goUnarmed()
	debug.trace("iEquip_WidgetCore goUnarmed called")
	bBlockSwitchBackToBoundSpell = true
	UnequipHand(1)
	Utility.Wait(0.1)
	UnequipHand(0)
	;And now we need to update the left hand widget
	float fNameAlpha = afWidget_A[aiNameElements[0]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushString(iHandle, "Fist")
		UICallback.PushString(iHandle, "Unarmed")
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
		args[0] = false
		args[1] = false
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		aiCurrentQueuePosition[0] = aiCurrentlyPreselected[0]
		asCurrentlyEquipped[0] = jMap.getStr(jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0]), "Name")
	endIf
	bGoneUnarmed = true
	int i = 0
	while i < 2
		hideAttributeIcons(i)
		if abIsCounterShown[i]
			setCounterVisibility(i, false)
		endIf
		if abPoisonInfoDisplayed[i]
			hidePoisonInfo(i)
		endIf
		if CM.abIsChargeMeterShown[i]
			CM.updateChargeMeterVisibility(i, false)
		endIf
		i += 1
	endwhile
	ammo targetAmmo = AM.currentAmmoForm as Ammo
	if bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
	if bEnableGearedUp
		refreshGearedUp()
	endIf
	bBlockSwitchBackToBoundSpell = false
endFunction

function cycleShout(int Q, int targetIndex, form targetItem)
    debug.trace("iEquip_WidgetCore cycleShout called")
    int itemType = jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "Type")
    if itemType == 22
        PlayerRef.EquipSpell(targetItem as Spell, 2)
    else
        PlayerRef.EquipShout(targetItem as Shout)
    endIf
endFunction

function cycleConsumable(form targetItem, int targetIndex, bool isPotionGroup)
    int potionGroupIndex
    if isPotionGroup
    	potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], targetIndex), "Name"))
    endIf
    debug.trace("iEquip_WidgetCore cycleConsumable called - potionGroupIndex: " + potionGroupIndex + ", bConsumableIconFaded: " + bConsumableIconFaded)
    int count
    if isPotionGroup
    	count = PO.getPotionGroupCount(potionGroupIndex)
    elseIf(targetItem)
        count = PlayerRef.GetItemCount(targetItem)
    endIf
    setSlotCount(3, count)
    If bConsumableIconFaded && (!isPotionGroup || !abPotionGroupEmpty[potionGroupIndex])
    	Utility.Wait(0.3)
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
endFunction

function handleConsumableIconFadeAndFlash(int potionGroupIndex)
	debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash - potionGroup is empty, flash potion warning")
	if bConsumableIconFaded
		checkAndFadeConsumableIcon(false)
		;Utility.Wait(0.3)
	endIf
    UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", potionGroupIndex)
    Utility.Wait(1.4)
	checkAndFadeConsumableIcon(true)
endFunction

function cyclePoison(form targetItem)
   	debug.trace("iEquip_WidgetCore cyclePoison called")
	if bPoisonIconFaded
		checkAndFadePoisonIcon(false)
	endIf
    setSlotCount(4, PlayerRef.GetItemCount(targetItem))
endFunction

;Uses the equipped item / potion in the consumable slot
function consumeItem()
    debug.trace("iEquip_WidgetCore consumeItem called")
    int potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "Name"))
    if potionGroupIndex != -1
    	PO.selectAndConsumePotion(potionGroupIndex)
    	setSlotCount(3, PO.getPotionGroupCount(potionGroupIndex))
    else
	    form itemForm = jMap.getForm(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "Form")
	    if(itemForm != None)
	    	PlayerRef.EquipItemEx(itemForm)
	    	int count = PlayerRef.GetItemCount(itemForm)
	    	if count < 1
	    		removeItemFromQueue(3, aiCurrentQueuePosition[3])
	    	else
	    		setSlotCount(3, count)
	    	endIf
	    endIf
	endIf
endFunction

int function showMessageWithCancel(string theString)
	debug.trace("iEquip_WidgetCore showMessageWithCancel called")
	iEquip_MessageObjectReference = playerREF.PlaceAtMe(iEquip_MessageObject)
	iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
	iEquip_MessageAlias.GetReference().GetBaseObject().SetName(theString)
	int iButton = iEquip_OKCancel.Show()
	iEquip_MessageAlias.Clear()
	iEquip_MessageObjectReference.Disable()
	iEquip_MessageObjectReference.Delete()
	return iButton
endFunction

function applyPoison(int Q)
	debug.trace("iEquip_WidgetCore applyPoison called")
	int targetObject = jArray.getObj(aiTargetQ[4], aiCurrentQueuePosition[4])
	Potion poisonToApply = jMap.getForm(targetObject, "Form") as Potion
	if !poisonToApply
		return
	endIf
	bool ApplyWithoutUpdatingWidget = false
	string messageString
	int iButton
	string newPoison = jMap.getStr(targetObject, "Name")
	bool isLeftHand = true
	string handName = "left"
	if Q == 1
		isLeftHand = false
		handName = "right"
	endIf
	Weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
	string weaponName
	if currentWeapon
		weaponName = currentWeapon.GetName()
	endIf
	if (!currentWeapon)
		debug.notification("You don't currently have a weapon in your " + handName + " hand to poison")
		return
	elseif currentWeapon != jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "Form") as Weapon
		messagestring = "The " + weaponName + " in your " + handName + " hand doesn't appear to match what's currently showing in iEquip. Do you wish to carry on and apply " + newPoison + " to it anyway?"
		iButton = showMessageWithCancel(messageString)
		if iButton != 0
			return
		endIf
		ApplyWithoutUpdatingWidget = true
	endIf

	Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
	if currentPoison && (currentPoison != none)
		string currentPoisonName = currentPoison.GetName()
		if currentPoison != poisonToApply
			if !bAllowPoisonSwitching
				debug.notification("Your " + weaponName + " is already poisoned with " + currentPoisonName)
				return
			else
				if iShowPoisonMessages < 2
					messagestring = "Your " + weaponName + " is already poisoned with " + currentPoisonName + ". Would you like to clean it and apply " + newPoison + " instead?"
					iButton = showMessageWithCancel(messageString)
					if iButton != 0
						return
					endIf
				endIf
				_Q2C_Functions.WornRemovePoison(PlayerRef, Q)
			endIf	
		elseif iShowPoisonMessages < 2
			messagestring = "Your " + weaponName + " is already poisoned with " + currentPoisonName + ". Would you like to add more poison?"
			iButton = showMessageWithCancel(messageString)
			if iButton != 0
				return
			endIf
		endIf
	elseif iShowPoisonMessages == 0
		messagestring = "Would you like to apply " + newPoison + " to your " + weaponName + "?"
		iButton = showMessageWithCancel(messageString)
		if iButton != 0
			return
		endIf
	endIf
	
	int ConcentratedPoisonMultiplier = iPoisonChargeMultiplier
	if ConcentratedPoisonMultiplier == 1 && PlayerRef.HasPerk(ConcentratedPoison)
		ConcentratedPoisonMultiplier = 2
	endIf
	int chargesToApply
	if stringutil.Find(newPoison, "wax", 0) > -1 || stringutil.Find(newPoison, "oil", 0) > -1
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
	int count = PlayerRef.GetItemCount(poisonToApply)
	if count > 0
		setSlotCount(4, count)
	endIf
	if !ApplyWithoutUpdatingWidget
		checkAndUpdatePoisonInfo(Q)
		CM.checkAndUpdateChargeMeter(Q)
	endIf
	;Play sound
	iEquip_ITMPoisonUse.Play(PlayerRef)
	;Add Poison FX to weapon
	if Q == 0
		PLFX.ShowPoisonFX()
	else
		PRFX.ShowPoisonFX()
	endIf
endFunction

;Convenience function
function hidePoisonInfo(int Q, bool forceHide = false)
	debug.trace("iEquip_WidgetCore hidePoisonInfo called")
	checkAndUpdatePoisonInfo(Q, true, forceHide)
endFunction

function checkAndUpdatePoisonInfo(int Q, bool cycling = false, bool forceHide = false)
	int targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	int itemType = jMap.getInt(targetObject, "Type")
	Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
	Form equippedItem = PlayerRef.GetEquippedObject(Q)
	if !forceHide && !equippedItem && !bGoneUnarmed && !(Q == 0 && itemType == 26)
		return
	endIf
	debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo called - Q: " + Q + ", cycling: " + cycling + ", itemType: " + itemType + ", currentPoison: " + currentPoison)
	;if item isn't poisoned remove the poisoned flag
	if equippedItem && (equippedItem == jMap.getForm(targetObject, "Form"))
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
			if !(itemRequiresCounter(Q, jMap.getInt(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "Type"))) && abIsCounterShown[Q]
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
		if abIsCounterShown[Q]
			setCounterVisibility(Q, false)
		endIf
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
endFunction

bool function isPoisonable(int itemType)
	return ((itemType > 0 && itemType < 8) || itemType == 9)
endFunction

bool function isWeaponPoisoned(int Q, int iIndex, bool cycling = false)
	bool isPoisoned = false
	;if we're checking the left hand item but we currently have a 2H or ranged weapon equipped, or if we're cycling we need to check the object data for the last know poison info
	if cycling || (Q == 0 && RightHandWeaponIs2hOrRanged())
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
	return isPoisoned
endFunction

;Unequips item in hand
function UnequipHand(int Q)
    debug.trace("iEquip_WidgetCore UnequipHand called on " + Q)
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
endFunction

;/Here we are creating JMap objects for each queue item, containing all of the data we will need later on when cycling the widgets and equipping/unequipping
including formID, itemID, display name, itemType, isEnchanted, etc. These JMap objects are then placed into one of the JArray queue objects.
This means that when we cycle later on none of this has to be done on the fly saving time when time is of the essence/;

function addToQueue(int Q)
	debug.trace("iEquip_WidgetCore addToQueue() called")
	;Q - 0 = Left Hand, 1 = Right Hand, 2 = Shout, 3 = Consumable/Poison
	int itemFormID
	form itemForm
	int itemType
	int itemID = -1
	bool isEnchanted = false
	bool isPoisoned = false
	string itemName = ""

	if !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("CustomMenu") && !((Self as form) as iEquip_uilib).IsMenuOpen()
		itemFormID = UI.GetInt(sCurrentMenu, sEntryPath + "formId")
		itemID = UI.GetInt(sCurrentMenu, sEntryPath + "itemId")
		itemName = UI.GetString(sCurrentMenu, sEntryPath + "text")
		itemForm = game.GetFormEx(itemFormID)
		itemID = UI.GetInt(sCurrentMenu, sEntryPath + "itemId")
		itemName = UI.GetString(sCurrentMenu, sEntryPath + "text")
	endIf
	if itemForm && itemForm != None
		debug.trace("iEquip_WidgetCore addToQueue - itemForm: " + itemForm + ", " + itemForm.GetName() + ", itemFormID: " + itemFormID)
		itemType = itemForm.GetType()
		if itemType == 41 || itemType == 26 ;Weapons and shields only
			isEnchanted = UI.Getbool(sCurrentMenu, sEntryPath + "isEnchanted")
		endIf
		if isItemValidForSlot(Q, itemForm, itemType, itemName)
			if itemName == ""
				itemName = itemForm.getName()
			endIf
			if Q == 3
				Potion P = itemForm as Potion
				if P.isPoison()
					Q = 4
				endIf
			endIf
			if !isAlreadyInQueue(Q, itemForm, itemID)
				bool foundInOtherHandQueue = false
				if Q < 2
					if Q == 0
						foundInOtherHandQueue = isAlreadyInQueue(1, itemForm, itemID)
					elseif Q == 1
						foundInOtherHandQueue = isAlreadyInQueue(0, itemForm, itemID)
					endIf
				endIf
				if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2) && !bAllowSingleItemsInBothQueues
					debug.MessageBox("You currently only have one " + itemName + " and it is already in the other hand queue")
					return
				endIf
				if itemID < 1
					queueItemForIDGenerationOnMenuClose(Q, jArray.count(aiTargetQ[Q]), itemName, itemFormID)
				endIf
				bool success = false
				if itemType == 41 ;if it is a weapon get the weapon type
					Weapon W = itemForm as Weapon
		        	itemType = W.GetWeaponType()
		        endIf
				string itemIcon = GetItemIconName(itemForm, itemType, itemName)
				debug.trace("iEquip_WidgetCore addToQueue(): Adding " + itemName + " to the " + asQueueName[Q] + ", formID = " + itemform + ", itemID = " + itemID as string + ", icon = " + itemIcon + ", isEnchanted = " + isEnchanted)
				int iEquipItem = jMap.object()
				if jArray.count(aiTargetQ[Q]) < iMaxQueueLength
					if bShowQueueConfirmationMessages
						iEquip_MessageObjectReference = playerREF.PlaceAtMe(iEquip_MessageObject)
						iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
						if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2)
							iEquip_MessageAlias.GetReference().GetBaseObject().SetName("You currently only have one " + itemName + " and it is already in the other hand queue. Do you want to add it to the " + asQueueName[Q] + " as well?")
						else
							iEquip_MessageAlias.GetReference().GetBaseObject().SetName("Would you like to add " + itemName + " to the " + asQueueName[Q] + "?")
						endIf
						int iButton = iEquip_ConfirmAddToQueue.Show()
						iEquip_MessageAlias.Clear()
		   	 			iEquip_MessageObjectReference.Disable()
		    			iEquip_MessageObjectReference.Delete()
						if iButton != 0
							return
						endIf
					endIf
					jMap.setForm(iEquipItem, "Form", itemForm)
					if itemID
						jMap.setInt(iEquipItem, "ID", itemID) ;Store SKSE itemID for non-spell items so we can use EquipItemByID to handle user enchanted/created/renamed items
					endIf
					jMap.setInt(iEquipItem, "Type", itemType)
					jMap.setStr(iEquipItem, "Name", itemName)
					jMap.setStr(iEquipItem, "Icon", itemIcon)
					if Q < 2
						jMap.setInt(iEquipItem, "isEnchanted", isEnchanted as int)
						jMap.setInt(iEquipItem, "isPoisoned", isPoisoned as int)
					endIf
					;Add any other info required for each item here - spell school, costliest effect, etc
					jArray.addObj(aiTargetQ[Q], iEquipItem)
					iEquip_AllCurrentItemsFLST.AddForm(itemForm)
					EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
					success = true
				else
					debug.notification("The " + asQueueName[Q] + " is full")
				endIf
				if success
					debug.notification(itemName + " was added to the " + asQueueName[Q])
				endIf
			else
				debug.notification(itemName + " has already been added to the " + asQueueName[Q])
			endIf
		else
			if bIsFirstFailedToAdd
				debug.MessageBox("You are trying to add the wrong type of item or spell to one of your iEquip queues.\n\nRULES\nLeft hand queue - 1H weapons, unarmed, staffs, spells, scrolls, torch, shield\nRight hand queue - Any weapon, spells, scrolls\nShout queue - shouts, powers\nConsumable queue - potions, food, drink\nPoison queue - poisons")
				bIsFirstFailedToAdd = false
			else
				debug.notification(itemName + " cannot be added to the " + asQueueName[Q])
			endIf
		endIf
	endIf
endFunction

function queueItemForIDGenerationOnMenuClose(int Q, int iIndex, string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore queueItemForIDGenerationOnMenuClose called - Q: " + Q + ", iIndex: " + iIndex + ", itemFormID: " + itemFormID + ", itemName: " + itemName)
	int queuedItem = jMap.object()
	jMap.setInt(queuedItem, "Q", Q)
	jMap.setInt(queuedItem, "Index", iIndex)
	jMap.setStr(queuedItem, "Name", itemName)
	jMap.setInt(queuedItem, "formID", itemFormID)
	jArray.addObj(iItemsForIDGenerationObj, queuedItem)
	bItemsWaitingForID = true
endFunction

function findAndFillMissingItemIDs()
	int count = jArray.count(iItemsForIDGenerationObj)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs called - number of items to generate IDs for: " + count)
	int i = 0
	int itemID
	int Q
	int iIndex
	int targetObject
	while i < count
		targetObject = jArray.getObj(iItemsForIDGenerationObj, i)
		itemID = createItemID(jMap.getStr(targetObject, "Name"), jMap.getInt(targetObject, "formID"))
		if itemID != 0
			Q = jMap.getInt(targetObject, "Q")
			iIndex = jMap.getInt(targetObject, "Index")
			jMap.setInt(jArray.getObj(aiTargetQ[Q], iIndex), "itemID", itemID)
			if bMoreHUDLoaded
				string moreHUDIcon
				if Q < 2
					int otherHand = 1
					if Q == 1
						otherHand =0
					endIf
					if isAlreadyInQueue(otherHand, jMap.getForm(jArray.getObj(aiTargetQ[Q], iIndex), "Form"), itemID)
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
		Utility.Wait(0.05)
		i += 1
	endwhile
	bItemsWaitingForID = false
	jArray.clear(iItemsForIDGenerationObj)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs - final check (count should be 0) - count: " + jArray.count(iItemsForIDGenerationObj))
endFunction

int function createItemID(string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore createItemID called - itemFormID: " + itemFormID + ", itemName: " + itemName)
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
		Utility.Wait(0.001)
		breakout -= 1
	endwhile
	return iReceivedID
endFunction

event itemIDReceivedFromFlash(string sEventName, string sStringArg, float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore itemIDReceivedFromFlash - sStringArg: " + sStringArg + ", fNumArg" + fNumArg)
	If(sEventName == "iEquip_GotItemID")
		iReceivedID = sStringArg as Int
		bGotID = true
	endIf
endEvent 

bool function isItemValidForSlot(int Q, form itemForm, int itemType, string itemName)
	debug.trace("iEquip_WidgetCore isItemValidForSlot() called, slot:" + Q as string + ", itemType:" + itemType as string)
	bool isValid = false
	EquipSlot iEquipSlotType
	int iEquipSlotTypeID
	if itemType == 22
    	Spell S = itemForm as Spell
    	iEquipSlotType = S.GetEquipType()
		iEquipSlotTypeID = (iEquipSlotType as form).GetFormID()
	endIf

	if Q == 0 ;Left Hand
		if itemType == 41 ;Weapon
			Weapon W = itemForm as Weapon
        	int WeaponType = W.GetWeaponType()
        	if WeaponType <= 4 || WeaponType == 8 ;Fists, 1H weapons and Staffs only
        		isValid = true
        	endIf
    	elseif (itemType == 22 && iEquipSlotTypeID != voiceEquipSlot && itemName != "Bound Bow" && itemName != "Bound Crossbow") || itemType == 23 || itemType == 31 || (itemType == 26 && (itemForm as Armor).GetSlotMask() == 512) ;Spell, Scroll, Torch, Shield
    		isValid = true
    	endIf
    elseif Q == 1 ;Right Hand
    	if itemType == 41 || (itemType == 22 && iEquipSlotTypeID != voiceEquipSlot) || itemType == 23 || (itemType == 26 && itemName == "Rocket Launcher") ;Any weapon, Spell, Scroll, oh and the Rocket Launcher from Junks Guns because Kojak...
    		isValid = true
    	elseif itemType == 42 ;Ammo - looking for throwing weapons here, and these can only be equipped in the right hand
        	if !(stringutil.Find(itemName, "arrow", 0) > -1 || stringutil.Find(itemName, "bolt", 0) > -1 || itemName == "Javelin") ;Javelin is the display name for those from Throwing Weapons Lite/Redux, the javelins from Spears by Soolie all have more descriptive names than just 'javelin' and they are treated as arrows or bolts so can't be right hand equipped
        		iEquip_MessageObjectReference = playerREF.PlaceAtMe(iEquip_MessageObject)
				iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
				iEquip_MessageAlias.GetReference().GetBaseObject().SetName("Are these " + itemName + "s classed as throwing weapons?\n\nPlease note that the javelins from Spears by Soolie are classed as arrows or bolts and should not be added here.\n\nWould you like to proceed and add " + itemName + "s to the " + asQueueName[Q] + "?")
				int iButton = iEquip_ConfirmAddToQueue.Show()
				iEquip_MessageAlias.Clear()
   	 			iEquip_MessageObjectReference.Disable()
    			iEquip_MessageObjectReference.Delete()
				if iButton != 0
					isValid = false
				else
        			isValid = true
        		endIf
        	endIf
    	endIf
    elseif Q == 2 ;Shout
    	if (itemType == 22 && iEquipSlotTypeID == voiceEquipSlot) || itemType == 119 ;Power, Shout
    		isValid = true
    	endIf
    elseif Q == 3 ;Consumable/Poison
    	if itemType == 46 ;Potion
    		isValid = true
    	endIf
    endIf
    debug.trace("iEquip_WidgetCore isItemValidForSlot() returning " + isValid as string)
    return isValid
endFunction

bool function isAlreadyInQueue(int Q, form itemForm, int itemID)
	debug.trace("iEquip_WidgetCore isAlreadyInQueue() called - Q: " + Q + ", itemForm: " + itemForm + ", itemID: " + itemID)
	bool found = false
	int i = 0
	int targetArray = aiTargetQ[Q]
	int targetObject
	while i < JArray.count(targetArray) && !found
		targetObject = jArray.getObj(targetArray, i)
		if itemID && itemID > 0
		    found = (itemID == jMap.getInt(targetObject, "ID"))
		   ; debug.trace("iEquip_WidgetCore isAlreadyInQueue() called - i: " + i + ", found: " + found)
		else
		    found = (itemform == jMap.getForm(targetObject, "Form"))
		endIf
		i += 1
	endwhile
return found
endFunction

string function GetItemIconName(form itemForm, int itemType, string itemName)
    debug.trace("iEquip_WidgetCore GetItemIconString() called - itemType: " + itemType + ", itemName: " + itemName)
    string IconName = "Empty"

    if itemType < 13 ;It is a weapon
        Weapon W = itemForm as Weapon
        IconName = asWeaponTypeNames[itemType]
        ;2H axes and maces have the same ID for some reason, so we have to differentiate them
        if itemType == 6 && W.IsWarhammer()
            IconName = "Warhammer"
        ;if this all looks a little strange it is because StringUtil find() is case sensitive so where possible I've ommitted the first letter to catch for example Spear and spear with pear
        elseif itemType == 1 && stringutil.Find(itemName, "spear", 0) > -1 ;Looking for spears here from Spears by Soolie which are classed as 1H swords
        	IconName = "Spear"
        elseif itemType == 4 && (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb", 0) > -1) ;Looking for CACO grenades here which are classed as maces
        	IconName = "Grenade"
        endIf

    elseif itemType == 26 && (itemForm as Armor).GetSlotMask() == 512 ;Shield
    	IconName = "Shield"

    elseif itemType == 23
    	IconName = "Scroll"

    elseif itemType == 31
    	IconName = "Torch"

    elseif itemType == 119
    	IconName = "Shout"
    
    elseif itemType == 22 ;Is a spell
    	iconName = "Spellbook"
        Spell S = itemForm as Spell
        EquipSlot iEquipSlotType = S.GetEquipType()
		int iEquipSlotTypeID = (iEquipSlotType as form).GetFormID()
    	if iEquipSlotTypeID == voiceEquipSlot
    		IconName = "Power"
    	else
        	int sIndex = S.GetCostliestEffectIndex()
        	MagicEffect sEffect = S.GetNthEffectMagicEffect(sIndex)
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

    elseif itemType == 42 ;Ammo - Throwing weapons
    	if stringutil.Find(itemName, "spear", 0) > -1 || stringutil.Find(itemName, "javelin", 0) > -1
			IconName = "Spear"
		elseif (stringutil.Find(itemName, "grenade", 0) > -1 || stringutil.Find(itemName, "flask", 0) > -1 || stringutil.Find(itemName, "pot", 0) > -1 || stringutil.Find(itemName, "bomb", 0) > -1)
			IconName = "Grenade"
		elseif stringutil.Find(itemName, "Axe", 0) > -1
			IconName = "ThrowingAxe"
		elseif stringutil.Find(itemName, "knife", 0) > -1 || stringutil.Find(itemName, "dagger", 0) > -1
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
	        int pIndex = P.GetCostliestEffectIndex()
	        MagicEffect pEffect = P.GetNthEffectMagicEffect(pIndex)
	        string pStr = pEffect.GetName()
	        debug.trace("iEquip_WidgetCore GetItemIconString() - pIndex: " + pIndex + ", pEffect: " + pEffect + ", pStr: " + pStr)
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
    debug.trace("iEquip_WidgetCore GetItemIconString() returning IconName as " + IconName)
    return IconName
endFunction

;Called by MCM if user has disabled Allow Single Items In Both Queues to remove duplicate 1h items from the right hand queue
function purgeQueue()
	debug.trace("iEquip_WidgetCore purgeQueue() called")
	int i = 0
	int targetArray = aiTargetQ[1]
	int count = jArray.count(targetArray)
	debug.trace("iEquip_WidgetCore purgeQueue() - " + count + " items in right hand queue")
	form itemForm
	int itemType
	int itemID
	int targetObject
	while i < count
		targetObject = jArray.getObj(targetArray, i)
		itemForm = jMap.getForm(targetObject, "Form")
		itemType = jMap.getInt(targetObject, "Type")
		itemID = jMap.getInt(targetObject, "ID")
		if !itemID || itemID <= 0
			itemID = -1
		endIf
		debug.trace("iEquip_WidgetCore purgeQueue() - index: " + i + ", itemForm: " + itemForm + ", itemID: " + itemID)
		if isAlreadyInQueue(0, itemForm, itemID) && PlayerRef.GetItemCount(itemForm) < 2 && itemType != 22
			removeItemFromQueue(1, i, true)
			count -= 1
			i -= 1
		endIf
		i += 1
	endwhile	
endFunction

function openQueueManagerMenu(int Q = -1)
	debug.trace("iEquip_WidgetCore openQueueManagerMenu() called")
	if Q == -1
		Q = iEquip_QueueManagerMenu.Show() ;0 = Exit, 1 = Left hand queue, 2 = Right hand queue, 3 = Shout queue, 4 = Consumable queue, 5 = Poison queue
	else
		bJustUsedQueueMenuDirectAccess = true
	endIf
	if Q > 0
		Q -= 1
		int queueLength = jArray.count(aiTargetQ[Q])
		if queueLength < 1
			debug.MessageBox("Your " + asQueueName[Q] + " is currently empty")
			recallQueueMenu()
		else
			int i = 0
			;Remove any empty indices before creating the menu arrays
			while i < queueLength
				if !JMap.getStr(jArray.getObj(aiTargetQ[Q], i), "Name")
					jArray.eraseIndex(aiTargetQ[Q], i)
					queueLength -= 1
				endIf
				i += 1
			endWhile
			iQueueMenuCurrentQueue = Q
			initQueueMenu(Q, queueLength)
		endIf
	endIf
endFunction

function initQueueMenu(int Q, int queueLength, bool update = false, int iIndex = -1)
	int targetArray = aiTargetQ[Q]
	string[] iconNames = Utility.CreateStringArray(queueLength)
	string[] itemNames = Utility.CreateStringArray(queueLength)
	bool[] enchFlags = Utility.CreateBoolArray(queueLength)
	bool[] poisonFlags = Utility.CreateBoolArray(queueLength)
	int i = 0
	while i < queueLength
		iconNames[i] = JMap.getStr(jArray.getObj(targetArray, i), "Icon")
		itemNames[i] = JMap.getStr(jArray.getObj(targetArray, i), "Name")
		enchFlags[i] = (JMap.getInt(jArray.getObj(targetArray, i), "isEnchanted") == 1)
		poisonFlags[i] = (JMap.getInt(jArray.getObj(targetArray, i), "isPoisoned") == 1)
		i += 1
	endWhile
	if update
		QueueMenu_RefreshList(iconNames, itemNames, enchFlags, poisonFlags, iIndex)
	else
		string title = "You currently have " + queueLength + " items in your " + asQueueName[Q]
		((Self as Form) as iEquip_UILIB).ShowQueueMenu(title, iconNames, itemNames, enchFlags, poisonFlags, 0, 0, bJustUsedQueueMenuDirectAccess)
	endIf
endFunction

function recallQueueMenu()
	debug.trace("iEquip_WidgetCore recallQueueMenu() called")
	if bJustUsedQueueMenuDirectAccess
		bJustUsedQueueMenuDirectAccess = false
	else
		Utility.Wait(0.05)
		openQueueManagerMenu()
	endIf
endFunction

function recallPreviousQueueMenu()
	initQueueMenu(iQueueMenuCurrentQueue, jArray.count(aiTargetQ[iQueueMenuCurrentQueue]))
endFunction

function QueueMenuSwap(int upDown, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuSwap() called")
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
endFunction

function QueueMenuRemoveFromQueue(int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuRemoveFromQueue() called")
	int targetArray = aiTargetQ[iQueueMenuCurrentQueue]
	int targetObject = jArray.getObj(targetArray, iIndex)
	string itemName = JMap.getStr(targetObject, "Name")
	if !(stringutil.Find(itemName, "Potions", 0) > -1)
		bool keepInFLST = false
		int itemID = JMap.getInt(targetObject, "itemID")
		form itemForm = JMap.getForm(targetObject, "Form")
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
        	EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
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
		QueueMenuUpdate(queueLength, iIndex)
	elseIf bFirstAttemptToDeletePotionGroup
		bFirstAttemptToDeletePotionGroup = false
		((Self as Form) as iEquip_UILIB).closeQueueMenu()
		debug.MessageBox("Potion Groups cannot be deleted.  To remove them from your consumables queue please use the MCM Potions page do disable them.")
		initQueueMenu(iQueueMenuCurrentQueue, jArray.count(aiTargetQ[iQueueMenuCurrentQueue]))
	endIf
endFunction

function QueueMenuUpdate(int iCount, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuUpdate() called")
	string title
	if iCount <= 0
		title = "Your " + asQueueName[iQueueMenuCurrentQueue] + " is currently empty"
	else
		title = "You currently have " + iCount + " items in your " + asQueueName[iQueueMenuCurrentQueue]
	endIf
	QueueMenu_RefreshTitle(title)
	initQueueMenu(iQueueMenuCurrentQueue, iCount, true, iIndex)
endFunction

function QueueMenuClearQueue()
	debug.trace("iEquip_WidgetCore QueueMenuClearQueue() called")
	if iQueueMenuCurrentQueue == 3
		jArray.eraseRange(aiTargetQ[iQueueMenuCurrentQueue], 3, -1)
	else
		jArray.clear(aiTargetQ[iQueueMenuCurrentQueue])
	endIf
	if iQueueMenuCurrentQueue == 4
		handleEmptyPoisonQueue()
	else
		setSlotToEmpty(iQueueMenuCurrentQueue)
	endIf
	debug.MessageBox("Your " + asQueueName[iQueueMenuCurrentQueue] + " has been cleared")
	recallQueueMenu()
endFunction

function ApplyChanges()
	debug.trace("iEquip_WidgetCore ApplyChanges called")
	int i
	if bSlotEnabledOptionsChanged
		updateSlotsEnabled()
	endIf
	if bBackgroundStyleChanged
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
	endIf
	if bDropShadowSettingChanged && !EM.isEditMode
		if bDropShadowEnabled
			UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", false) ;Show drop shadow
		else
			UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true) ;Remove drop shadow
		endIf
	endIf
	if bFadeOptionsChanged
		updateWidgetVisibility()
		i = 0
        while i < 8
            showName(i, true) ;Reshow all the names and either register or unregister for updates
            i += 1
        endwhile
    endIf
    if bRefreshQueues
    	purgeQueue()
    endIf
    if bReduceMaxQueueLengthPending
    	reduceMaxQueueLength()
    endIf
    if bGearedUpOptionChanged
    	Utility.SetINIbool("bDisableGearedUp:General", True)
		refreshVisibleItems()
		if bEnableGearedUp
			Utility.SetINIbool("bDisableGearedUp:General", False)
			refreshVisibleItems()
		endIf
    endIf
    ammo targetAmmo = AM.currentAmmoForm as ammo
    if !bAmmoMode && bUnequipAmmo && targetAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
    if !bProModeEnabled && bPreselectMode
    	bPreselectMode = false
    endIf
    if bAmmoMode
	    if bAmmoSortingChanged
	    	AM.updateAmmoListsOnSettingChange()
	    endIf
	    if bAmmoIconChanged
	    	AM.checkAndEquipAmmo(false, false, true, false)
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
	endIf
	if bPoisonIndicatorStyleChanged
		i = 0
		while i < 2
			if abPoisonInfoDisplayed[i]
				checkAndUpdatePoisonInfo(i)
			endIf
			i += 1
		endwhile
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
	    if (asCurrentlyEquipped[3] == "Health Potions" && !bHealthPotionGrouping) || (asCurrentlyEquipped[3] == "Stamina Potions" && !bStaminaPotionGrouping) || (asCurrentlyEquipped[3] == "Magicka Potions" && !bMagickaPotionGrouping)
	        cycleSlot(3)
	    endIf
	endIf
endFunction
