Scriptname iEquip_WidgetCore extends SKI_WidgetBase

Import Input
Import Form
Import UI
Import UICallback
Import Utility
Import iEquip_Utility
Import iEquip_UILIB
import _Q2C_Functions
Import WornObject

Actor Property PlayerRef Auto

Weapon Property iEquip_Unarmed1H Auto  
Weapon Property iEquip_Unarmed2H Auto

Sound Property iEquip_ITMPoisonUse Auto

iEquip_EditMode Property EM Auto
iEquip_MCM Property MCM Auto
iEquip_KeyHandler Property KH Auto
iEquip_AmmoScript Property AM Auto
iEquip_PotionScript Property PO Auto
;iEquip_HelpMenu Property HM Auto
iEquip_PlayerEventHandler Property EH Auto
iEquip_LeftHandEquipUpdateScript Property LHUpdate Auto
iEquip_RightHandEquipUpdateScript Property RHUpdate Auto
iEquip_LeftNameUpdateScript Property LNUpdate Auto
iEquip_LeftPoisonNameUpdateScript Property LPoisonNUpdate Auto
iEquip_LeftPreselectNameUpdateScript Property LPNUpdate Auto
iEquip_RightNameUpdateScript Property RNUpdate Auto
iEquip_RightPoisonNameUpdateScript Property RPoisonNUpdate Auto
iEquip_RightPreselectNameUpdateScript Property RPNUpdate Auto
iEquip_ShoutNameUpdateScript Property SNUpdate Auto
iEquip_ShoutPreselectNameUpdateScript Property SPNUpdate Auto
iEquip_ConsumableNameUpdateScript Property CNUpdate Auto
iEquip_PoisonNameUpdateScript Property PNUpdate Auto
iEquip_ApplyPoisonFXScript Property PFX Auto

; Arrays used by queue functions
int[] currentQueuePosition ;Array containing the current index for each queue
string[] currentlyEquipped ;Array containing the itemName for whatever is currently equipped in each queue
int[] currentlyPreselected ;Array containing current preselect queue positions
int[] indexOnStartCycle ;Array into which we store the currently equipped index for slots 0-2 when we start cycling, resets when checkAndEquipShownHandItem is called - allows us to skip currently equipped item when cycling

;  Variables
String[] Property asWidgetDescriptions Auto
String[] Property asWidgetElements Auto
String[] Property asWidget_TA Auto
String[] Property asWidget_DefTA Auto
String[] Property asWidgetGroup Auto

Float[] Property afWidget_X Auto
Float[] Property afWidget_Y Auto
Float[] Property afWidget_S Auto
Float[] Property afWidget_R Auto
Float[] Property afWidget_A Auto

int[] Property aiWidget_D Auto
int[] Property aiWidget_TC Auto

Float[] Property afWidget_DefX Auto
Float[] Property afWidget_DefY Auto
Float[] Property afWidget_DefS Auto
Float[] Property afWidget_DefR Auto
Float[] Property afWidget_DefA Auto
int[] Property aiWidget_DefTC Auto
int[] Property aiWidget_DefD Auto

bool[] Property abWidget_V Auto
bool[] Property abWidget_DefV Auto
bool[] Property abWidget_isParent Auto
bool[] Property abWidget_isText Auto
bool[] Property abWidget_isBg Auto

int consumableCount
int poisonCount
int CurrentlyUpdating

bool iEquip_Enabled = false
bool Property isFirstLoad = true Auto
bool isFirstEnabled = true
bool isFirstInventoryMenu = true
bool isFirstMagicMenu = true
bool isFirstFailedToAdd = true
bool WaitingForFlash = false
bool Property Loading = false Auto
bool Property showQueueConfirmationMessages = true Auto
bool Property loadedbyOnWidgetInit Auto Hidden
bool RefreshingWidgetOnLoad = false
bool waitingForAmmoModeAnimation = false

int[] targetQ
string[] queueName

String[] itemNames
String[] weaponTypeNames
int Property voiceEquipSlot = 0x00025BEE AutoReadOnly ; hex code of the FormID for the Voice EquipSlot

Quest Property iEquip_MessageQuest Auto ; populated by CK
ReferenceAlias Property iEquip_MessageAlias Auto ; populated by CK, but Alias is filled by script, not by CK
MiscObject Property iEquip_MessageObject Auto ; populated by CK
ObjectReference Property iEquip_MessageObjectReference Auto ; populated by script
Message Property iEquip_ConfirmAddToQueue Auto
Message Property iEquip_OKCancel Auto
Message Property iEquip_UtilityMenu Auto
Message Property iEquip_QueueManagerMenu Auto
int queueMenuCurrentQueue = -1

string currentMenu = ""
string entryPath = ""

bool Property shoutEnabled = true Auto
bool Property consumablesEnabled = true Auto
bool Property poisonsEnabled = true Auto

bool PreselectMode = false
bool PreselectModeFirstLook = true
bool leftPreselectShown = true
bool shoutPreselectShown = true
bool rightPreselectShown = true
bool togglingPreselectOnEquipAll = false

bool blockQuickDualCast = false
bool blockSwitchBackToBoundSpell = false

bool currentlyQuickRanged = false
bool currentlyQuickHealing = false
int quickHealSlotsEquipped = -1
int previousLeftHandIndex
int previousRightHandIndex

bool AmmoMode = false
bool AmmoModeFirstLook = true
bool AmmoModePreselectModeFirstLook = true
int ammoQ ;Holds the targetQ[] index for the JC int value for the current ammo queue - objArrowQ or objBoltQ
bool ReadyForAmmoModeAnim = false
bool toggleAmmoModeWithoutAnimation = false
bool toggleAmmoModeWithoutEquipping = false
bool justLeftAmmoMode = false
bool ammoModeActiveOnTogglePreselect = false

bool Property leftCounterShown = false Auto
bool Property rightCounterShown = false Auto
bool leftIconFaded = false

bool Property widgetFadeoutEnabled = false Auto
bool Property nameFadeoutEnabled = false Auto
bool[] Property isNameShown Auto
int[] nameElements
bool Property firstPressShowsName = true Auto

bool[] Property isPoisonNameShown Auto
int[] Property poisonNameElements Auto
bool[] poisonInfoDisplayed
string tempLeftPoisonName
int tempLeftPoisonCharges

string[] potionGroups
bool[] Property potionGroupEmpty Auto
bool Property consumableIconFaded = false Auto
bool firstAttemptToDeletePotionGroup = true

;Geared Up properties and variables
Armor Property Shoes Auto
Race PlayerRace
bool bDrawn
Form boots

bool Property EquipOnPause
	bool function Get()
		return MCM.bEquipOnPause
	endFunction
endProperty

string function GetWidgetType()
	Return "iEquip_WidgetCore"
endFunction

Event OnWidgetInit()
	PopulateWidgetArrays()
	PlayerRace = PlayerRef.GetRace()
	bDrawn = PlayerRef.IsWeaponDrawn()
	targetQ = new int[7]
	currentQueuePosition = new int[7] ;Array containing the current index for each queue - left, right, shout, potion, poison, arrow, bolt
	currentlyEquipped = new string[7] ;Array containing the itemName for whatever is currently equipped in each queue
	int i = 0
	while i < 5
		currentQueuePosition[i] = -1
		currentlyEquipped[i] = ""
		i += 1
	endwhile
	currentlyPreselected = new int[3] ;Array containing current preselect queue positions
	i = 0
	while i < 3
		currentlyPreselected[i] = -1
		i += 1
	endwhile
	queueName = new string[5]
	queueName[0] = "left hand queue"
	queueName[1] = "right hand queue"
	queueName[2] = "shout queue"
	queueName[3] = "consumable queue"
	queueName[4] = "poison queue"

	isNameShown = new bool[8]
	isNameShown[0] = true ;Left name
	isNameShown[1] = true ;Right name
	isNameShown[2] = true ;Shout name
	isNameShown[3] = true ;Consumable name
	isNameShown[4] = true ;Poison name
	isNameShown[5] = true ;Left preselect name
	isNameShown[6] = true ;Right preselect name
	isNameShown[7] = true ;Shout preselect name

	nameElements = new int[8]
	nameElements[0] = 8
	nameElements[1] = 21
	nameElements[2] = 34
	nameElements[3] = 40
	nameElements[4] = 44
	nameElements[5] = 17
	nameElements[6] = 30
	nameElements[7] = 37

	isPoisonNameShown = new bool[2]
	isPoisonNameShown[0] = false
	isPoisonNameShown[1] = false

	poisonNameElements = new int[2]
	poisonNameElements[0] = 11
	poisonNameElements[1] = 24

	poisonInfoDisplayed = new bool[2]
	poisonInfoDisplayed[0] = false
	poisonInfoDisplayed[1] = false

	potionGroups = new string[3]
	potionGroups[0] = "Health Potions"
	potionGroups[1] = "Stamina Potions"
	potionGroups[2] = "Magicka Potions"

	potionGroupEmpty = new bool[3]
	potionGroupEmpty[0] = true
	potionGroupEmpty[1] = true
	potionGroupEmpty[2] = true

	indexOnStartCycle = new int[3] ;Array containing the index of slots 0-2 on commencing cycling
	indexOnStartCycle[0] = -1
	indexOnStartCycle[1] = -1
	indexOnStartCycle[2] = -1

	loadedbyOnWidgetInit = true
	initDataObjects()
	addPotionGroups()
	KH.GameLoaded()
EndEvent

string function GetWidgetSource()
	Return "iEquip/iEquipWidget.swf"
endFunction

Event OnWidgetLoad()
	debug.trace("iEquip_WidgetCore OnWidgetLoad called")
	MCM.iEquip_Reset = false
	EM.SelectedItem = 0
	EM.isEditMode = false
	KH.GameLoaded()
	PreselectMode = false
	cyclingLHPreselectInAmmoMode = false
	GotoState("")
	Loading = true
	if !loadedbyOnWidgetInit
		initDataObjects()
	endIf
	loadedbyOnWidgetInit = false
	; Don't call the parent event since it will display the widget regardless of the "Shown" property.
    ;parent.OnWidgetLoad()
    OnWidgetReset()
    ; Determine if the widget should be displayed
    UpdateWidgetModes()
    ;Make sure to hide Edit Mode and PreselectMode elements, leaving left shown if in AmmoMode
	UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
	bool[] args = new bool[5]
	if isAmmoMode
		args[0] = true
		args[3] = EM.BackgroundsShown
	else
		args[0] = false ;Hide left
		args[3] = true ;Hide backgrounds - set to true but other three then take over and hide them anyway
	endIf
	args[1] = false ;Hide right
	args[2] = false ;Hide shout
	args[4] = isAmmoMode
	UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
    ; Use RunOnce bool here - if first load hide everything and show messagebox
	if isFirstLoad
		getAndStoreDefaultWidgetValues()
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", false)
		isFirstLoad = false
	else
		;updateShown() - switch to updateShown once implemented, still with isFirstLoad
		if !isFirstEnabled
			refreshWidgetOnLoad()
		endIf
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", iEquip_Enabled)
		showWidget()
		if iEquip_Enabled
			UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
			Utility.Wait(0.5)
			checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type"))
		endIf
	endIf

	if isEnabled
		KH.RegisterForGameplayKeys()
		debug.notification("iEquip controls unlocked and ready to use")
	endIf
	Loading = False
	debug.trace("iEquip_WidgetCore OnWidgetLoad finished")
endEvent

Event OnWidgetReset()
	debug.trace("iEquip_WidgetCore OnWidgetReset called")
    RequireExtend = false
	parent.OnWidgetReset()
	updateConfig()
	debug.trace("iEquip_WidgetCore OnWidgetReset finished")
EndEvent

; Shows the widget if the control mode is set to always,
function updateConfig()
	debug.trace("iEquip_WidgetCore updateConfig called")
	; Cleanup
	EM.UpdateWidgets()
	
	;/if(_controlMode == "always" && _shown)
		showWidget()
	else
		hideWidget()
		_displayed = false
		RegisterForKey(_hotkey)
		if(_controlMode != "periodically")
			_period = "none"
		endIf
	endIf/;
	debug.trace("iEquip_WidgetCore updateConfig finished")
endFunction

function refreshWidgetOnLoad()
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad() called")
	RefreshingWidgetOnLoad = true
	leftIconFaded = false
	int Q = 0
	form fItem
	bool inAmmoMode = isAmmoMode
	int potionGroup = potionGroups.find(jMap.getStr(jArray.getObj(targetQ[3], currentQueuePosition[3]), "Name"))
	while Q < 8
		isNameShown[Q] = true
		if Q < 5
			if Q < 2
				checkAndUpdatePoisonInfo(Q)
			endIf
			if Q == 0 && inAmmoMode
				updateWidget(Q, currentQueuePosition[ammoQ])
			else
				updateWidget(Q, currentQueuePosition[Q])
			endIf
			if (Q == 0 && leftCounterShown) || (Q == 1 && rightCounterShown) || Q > 2
				if Q == 0 && inAmmoMode
					fItem = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form")
				else
					fItem = jMap.getForm(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "Form")
				endIf
				if Q == 3 && potionGroup != -1
					int count = PO.getPotionGroupCount(potionGroup)
					setSlotCount(3, count)
					if count < 1
						checkAndFadeConsumableIcon(true)
					elseIf consumableIconFaded
						checkAndFadeConsumableIcon(false)
					endIf
				elseIf fItem && fItem != none && !(Q < 2 && poisonInfoDisplayed[Q])
					setSlotCount(Q, PlayerRef.GetItemCount(fItem))
				endIf
			endIf
		else
			updateWidget(Q, currentlyPreselected[Q - 5])
		endIf
		Q += 1
	endwhile
	;just to make sure!
	UI.setbool(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
	RefreshingWidgetOnLoad = false
	debug.trace("iEquip_WidgetCore refreshWidgetOnLoad() finished")
endFunction

;ToDo - This function is still to finish/review
function refreshWidget()
	debug.trace("iEquip_WidgetCore refreshWidget called")
	;Hide the widget first
	KH.blockControls()
	hideWidget()
	debug.notification("Refreshing iEquip widget...")
	;Reset alpha values on every element
	int iIndex = 6 ;Six is the first individual widget element in the array
	while iIndex < asWidgetDescriptions.Length
		UI.setFloat(HUD_MENU, WidgetRoot + asWidgetElements[iIndex] + "._alpha", afWidget_A[iIndex])
		iIndex += 1
	endwhile
	;Check what the items and shout the player currently has equipped and find them in the queues
	iIndex = 0
	int Q = 0
	form equippedForm
	while Q < 3
		equippedForm = PlayerRef.GetEquippedObject(Q)
		currentQueuePosition[Q] = findInQueue(Q, equippedForm.GetName())
		if currentQueuePosition[Q] == -1
			currentQueuePosition[Q] = 0
		endIf
		currentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "Name")
		Q += 1
	endwhile
	;if we're in Preselect Mode exit now
	if isPreselectMode
		togglePreselectMode()
		Utility.Wait(3.0)
		debug.notification("Exiting Preselect Mode...")
	endIf
	;if we're in ammo mode check if we actually should be
	if isAmmoMode && !RightHandWeaponIsRanged()
		toggleAmmoMode()
		Utility.Wait(3.0)
		debug.notification("Resetting Ammo Mode...")
	endIf
	;Now we need to refresh the names and icons for each slot to show what is currently equipped
	refreshWidgetOnLoad()
	;We can now check if we need to fade the left icon if we've got a 2H weapon equipped
	Utility.Wait(1.5)
	debug.notification("Resetting icons and names...")
	int itemType = jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type")
	checkAndFadeLeftIcon(1, itemType)
	;Check and show or hide left and right counters - counts have already been updated in refreshWidgetOnLoad
	if !isAmmoMode
		Q = 0
		while Q < 2
			itemType = jMap.getInt(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "Type")
			if itemRequiresCounter(Q, itemType)
				;Show the counter if currently hidden
				if !isCounterShown(Q)
					setCounterVisibility(Q, true)
				endIf
			;The item doesn't require a counter so hide it if it's currently shown
			elseif isCounterShown(Q)
				setCounterVisibility(Q, false)
			endIf
			Q += 1
		endwhile
	;We're in Ammo Mode so we need to make sure only the left counter is shown
	else
		if !isCounterShown(0)
			setCounterVisibility(0, true)
		endIf
		setCounterVisibility(1, false)
	endIf
	updateSlotsEnabled()
	;Show the widget
	showWidget()
	;And finally re-register for fadeouts if required
	if nameFadeoutEnabled
		LNUpdate.registerForNameFadeoutUpdate()
		RNUpdate.registerForNameFadeoutUpdate()
		if shoutEnabled
			SNUpdate.registerForNameFadeoutUpdate()
		endIf
		if consumablesEnabled
			CNUpdate.registerForNameFadeoutUpdate()
		endIf
		if poisonsEnabled
			PNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
	KH.releaseControls()
	debug.Notification("iEquip widget refresh complete")
	debug.trace("iEquip_WidgetCore refreshWidget finished")
endFunction

function initDataObjects()
	InitialiseiEquipDataObject()
	InitialiseiEquipQHolderObject()
	InitialiseQArrays()
	CreateWeaponTypeArray()
endFunction

function InitialiseiEquipDataObject()
	if iEquipDataObj == 0
		iEquipDataObj = JMap.object()
	endIf
endFunction

function InitialiseiEquipQHolderObject()
	if iEquipQHolderObj == 0
		iEquipQHolderObj = Jmap.object()
	endIf
endFunction

function InitialiseQArrays()
	if objLeftQ == 0
		objLeftQ = JArray.object()
		targetQ[0] = objLeftQ
	endIf
	if objRightQ == 0
		objRightQ = JArray.object()
		targetQ[1] = objRightQ
	endIf
	if objShoutQ == 0
		objShoutQ = JArray.object()
		targetQ[2] = objShoutQ
	endIf
	if objConsumableQ == 0
		objConsumableQ = JArray.object()
		targetQ[3] = objConsumableQ
	endIf
	if objPoisonQ == 0
		objPoisonQ = JArray.object()
		targetQ[4] = objPoisonQ
	endIf
	if objArrowQ == 0
		objArrowQ = JArray.object()
		targetQ[5] = objArrowQ
	endIf
	if objBoltQ == 0
		objBoltQ = JArray.object()
		targetQ[6] = objBoltQ
	endIf
	if objLastRemovedCache == 0
		objLastRemovedCache = JArray.object()
	endIf
	if objItemsForIDGeneration == 0
		objItemsForIDGeneration = JArray.object()
	endIf
endFunction

function CreateWeaponTypeArray()
	weaponTypeNames = new string[10]
	weaponTypeNames[0] = "Fist"
	weaponTypeNames[1] = "Sword"
	weaponTypeNames[2] = "Dagger"
	weaponTypeNames[3] = "Waraxe"
	weaponTypeNames[4] = "Mace"
	weaponTypeNames[5] = "Greatsword"
	weaponTypeNames[6] = "Battleaxe"
	weaponTypeNames[7] = "Bow"
	weaponTypeNames[8] = "Staff"
	weaponTypeNames[9] = "Crossbow"
endFunction

int property iEquipDataObj
	int function get()
		return JDB.solveObj(".iEquip_Data")
	endFunction
	function set(int objObject)
		JDB.setObj("iEquip_Data", objObject)
	endFunction
endProperty

int property iEquipQHolderObj
	int function get()
		return JMap.getObj(iEquipDataObj, "iEquipQHolder")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipDataObj, "iEquipQHolder", objObject)
	endFunction
endProperty

int property objLeftQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "leftQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "leftQ", objObject)
	endFunction
endProperty

int property objRightQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "rightQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "rightQ", objObject)
	endFunction
endProperty

int property objShoutQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "shoutQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "shoutQ", objObject)
	endFunction
endProperty

int property objConsumableQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "consumableQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "consumableQ", objObject)
	endFunction
endProperty

int property objPoisonQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "poisonQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "poisonQ", objObject)
	endFunction
endProperty

int property objArrowQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "arrowQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "arrowQ", objObject)
	endFunction
endProperty

int property objBoltQ
	int function get()
		return JMap.getObj(iEquipQHolderObj, "boltQ")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "boltQ", objObject)
	endFunction
endProperty

int property objLastRemovedCache
	int function get()
		return JMap.getObj(iEquipQHolderObj, "lastRemovedCache")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "lastRemovedCache", objObject)
	endFunction
endProperty

int property objItemsForIDGeneration
	int function get()
		return JMap.getObj(iEquipQHolderObj, "itemsForIDGeneration")
	endFunction
	function set(int objObject)
		JMap.setObj(iEquipQHolderObj, "itemsForIDGeneration", objObject)
	endFunction
endProperty

function addPotionGroups()
	debug.trace("iEquip_WidgetCore addPotionGroups called")
	int healthPotionGroup = jMap.object()
	int staminaPotionGroup = jMap.object()
	int magickaPotionGroup = jMap.object()
	int consumableQ = targetQ[3]

	jMap.setInt(healthPotionGroup, "Type", 46)
	jMap.setStr(healthPotionGroup, "Name", "Health Potions")
	jMap.setStr(healthPotionGroup, "Icon", "HealthPotion")
	jArray.addObj(consumableQ, healthPotionGroup)

	jMap.setInt(staminaPotionGroup, "Type", 46)
	jMap.setStr(staminaPotionGroup, "Name", "Stamina Potions")
	jMap.setStr(staminaPotionGroup, "Icon", "StaminaPotion")
	jArray.addObj(consumableQ, staminaPotionGroup)

	jMap.setInt(magickaPotionGroup, "Type", 46)
	jMap.setStr(magickaPotionGroup, "Name", "Magicka Potions")
	jMap.setStr(magickaPotionGroup, "Icon", "MagickaPotion")
	jArray.addObj(consumableQ, magickaPotionGroup)
endFunction

event OnMenuOpen(string sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuOpen called - current menu: " + sCurrentMenu)
	currentMenu = sCurrentMenu
	if (currentMenu == "InventoryMenu" || currentMenu == "MagicMenu" || currentMenu == "FavoritesMenu") ;if in inventory or magic menu switch states so cycle hotkeys now assign selected item to the relevant queue array
		if  isFirstInventoryMenu
			debug.MessageBox("Adding to your iEQUIP queues\n\nTo add items, spells, powers or shouts to your iEquip queues you simply need to highlight an item in your inventory or spellbook (you don't need to equip it) and press the hotkey for the slot you want to add it to.")
			isFirstInventoryMenu = false
		endIf
		if currentMenu == "InventoryMenu" || currentMenu == "MagicMenu"
			entryPath = "_root.Menu_mc.inventoryLists.itemList.selectedEntry."
		elseif currentMenu == "FavoritesMenu"
			entryPath = "_root.MenuHolder.Menu_mc.itemList.selectedEntry."
		endIf
	elseif currentMenu == "Journal Menu"
		entryPath = "_root.ConfigPanelFader.configPanel._modList.selectedEntry."
	endIf
	;Geared Up
	if MCM.bEnableGearedUp && PlayerRef.GetRace() == PlayerRace
		if PlayerRef.IsWeaponDrawn() || PlayerRef.GetAnimationVariablebool("IsEquipping")
			Utility.SetINIbool("bDisableGearedUp:General", true)
			refreshVisibleItems()
			Utility.Wait(0.1)
			Utility.SetINIbool("bDisableGearedUp:General", false)
			refreshVisibleItems()
		endIf
	endIf
endEvent

event OnMenuClose(string sCurrentMenu)
	debug.trace("iEquip_WidgetCore OnMenuClose called - current menu: " + sCurrentMenu + ", MCM.justEnabled: " + MCM.justEnabled + ", itemsWaitingForID: " + itemsWaitingForID)
	if sCurrentMenu == "Journal Menu" && MCM.justEnabled
        debug.MessageBox("Adding items to iEquip\n\nBefore you can use iEquip for the first time you need to choose your gear for each slot.  Simply open your Inventory, Magic or Favorites menu and follow the instructions there.\n\nEnjoy using iEquip!")
        MCM.justEnabled = false		
	elseif (sCurrentMenu == "InventoryMenu" || CurrentMenu == "MagicMenu" || CurrentMenu == "FavoritesMenu") && itemsWaitingForID ;&& !utility.IsInMenuMode()
		findAndFillMissingItemIDs()
		itemsWaitingForID = false
	endIf
	currentMenu = ""
	entryPath = ""
endEvent

Event OnRaceSwitchComplete()
	debug.trace("iEquip_WidgetCore OnRaceSwitchComplete called")
	if UI.IsMenuOpen("RaceSex Menu")
		PlayerRace = PlayerRef.GetRace()
	elseif MCM.bEnableGearedUp
		if PlayerRef.GetRace() == PlayerRace
			Utility.SetINIbool("bDisableGearedUp:General", false)
			refreshVisibleItems()
		else
			Utility.SetINIbool("bDisableGearedUp:General", true)
			refreshVisibleItems()
		endIf
	endIf
EndEvent

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

;/ Shows the widget for _displayTime seconds.
function showTimed()
	showWidget()
	Utility.Wait(_displayTime)
	; The control mode might have changed, so check again.
	if(_controlMode == "timedHotkey" || _controlMode == "periodically")
		hideWidget()
	endIf
endFunction/;

; Shows the widget if it should be shown, hides it otherwise.
;/function updateShown()
	if(_shown && (_controlMode == "always" || (_controlMode == "toggledHotkey" && _displayed)))
		showWidget()
	else
		hideWidget()
	endIf
endFunction/;

; Shows the widget.
function showWidget()
	if(Ready)
		UpdateWidgetModes()
		FadeTo(100, 0.2)
	endIf
endFunction

; Hides the widget.
function hideWidget()
	if(Ready)
		FadeTo(0, 0.2)
	endIf
endFunction

bool Property isEnabled
{Set this property true to enable the widget}
	bool function Get()
		Return iEquip_Enabled
	endFunction
	
	function Set(bool enabled)
		iEquip_Enabled = enabled
		EH.OniEquipEnabled(enabled)
		if (Ready)
			if iEquip_Enabled
				PO.findAndSortPotions()
				if isFirstEnabled
					EM.BackgroundsShown = false
					UI.invoke(HUD_MENU, WidgetRoot + ".setWidgetToEmpty")
				endIf
				bool[] args = new bool[4]
				args[0] = false ;Hide left
				args[1] = false ;Hide right
				args[2] = false ;Hide shout
				args[3] = false ;Hide backgrounds
				UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
				UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
				UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
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
			endIf
			showWidget() ;Just in case you were in Edit Mode when you disabled because ToggleEditMode won't have done this
			UI.setbool(HUD_MENU, WidgetRoot + "._visible", iEquip_Enabled)
		endIf
		if iEquip_Enabled && isFirstEnabled
			ResetWidgetArrays()
			isFirstEnabled = false
		endIf
	endFunction
EndProperty

function PopulateWidgetArrays()
	asWidgetDescriptions = new String[46]
	asWidgetElements = new String[46]
	asWidget_TA = new String[46]
	asWidgetGroup = new String[46]
	
	afWidget_X = new Float[46]
	afWidget_Y = new Float[46]
	afWidget_S = new Float[46]
	afWidget_R = new Float[46]
	afWidget_A = new Float[46]
	
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

function AddWidget( string sDescription, string sPath, Float fX, Float fY, Float fS, Float fR, Float fA, int iD, int iTC, string sTA, bool bV, bool bIsParent, bool bIsText, bool bIsBg, string sGroup)
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
	afWidget_DefX = new Float[46]
	afWidget_DefY = new Float[46]
	afWidget_DefS = new Float[46]
	afWidget_DefR = new Float[46]
	afWidget_DefA = new Float[46]
	aiWidget_DefD = new int[46]
	asWidget_DefTA = new String[46]
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

function LoadWidgetPreset(string SelectedPreset)
	int jLoadPreset = jValue.readFromFile(EM.WidgetPresetPath + SelectedPreset)
	int jafWidget_X = JMap.getObj(jLoadPreset, "_X")
	int jafWidget_Y = JMap.getObj(jLoadPreset, "_Y")
	int jafWidget_S = JMap.getObj(jLoadPreset, "_S")
	int jafWidget_R = JMap.getObj(jLoadPreset, "_R")
	int jafWidget_A = JMap.getObj(jLoadPreset, "_A")
	int jaiWidget_D = JMap.getObj(jLoadPreset, "_D")
	int jaiWidget_TC = JMap.getObj(jLoadPreset, "_TC")
	int jasWidget_TA = JMap.getObj(jLoadPreset, "_TA")
	int jabWidget_V = JMap.getObj(jLoadPreset, "_V")
	
	int[] abWidget_V_temp = new int[46]

	JArray.writeToFloatPArray(jafWidget_X, afWidget_X, 0, -1, 0, 0)
	JArray.writeToFloatPArray(jafWidget_Y, afWidget_Y, 0, -1, 0, 0)
	JArray.writeToFloatPArray(jafWidget_S, afWidget_S, 0, -1, 0, 0)
	JArray.writeToFloatPArray(jafWidget_R, afWidget_R, 0, -1, 0, 0)
	JArray.writeToFloatPArray(jafWidget_A, afWidget_A, 0, -1, 0, 0)
	JArray.writeToIntegerPArray(jaiWidget_D, aiWidget_D, 0, -1, 0, 0)
	JArray.writeToIntegerPArray(jaiWidget_TC, aiWidget_TC, 0, -1, 0, 0)
	JArray.writeToStringPArray(jasWidget_TA, asWidget_TA, 0, -1, 0, 0)
	JArray.writeToIntegerPArray(jabWidget_V, abWidget_V_temp, 0, -1, 0, 0)
	int iIndex = 0
	while iIndex < asWidgetDescriptions.Length
		abWidget_V[iIndex] = abWidget_V_temp[iIndex] as bool
		iIndex += 1
	endwhile
	hideWidget()
	Utility.Wait(0.2)
	EM.UpdateWidgets()
	Utility.Wait(0.1)
	showWidget()
	Debug.Notification("Widget layout switched to " + SelectedPreset)
endFunction

bool function isCurrentlyEquipped(int Q, string itemName)
	return currentlyEquipped[Q] == itemName
endFunction

function togglePreselectMode()
	debug.trace("iEquip_WidgetCore togglePreselectMode called")
	isPreselectMode = !isPreselectMode
endFunction

bool Property isPreselectMode
	bool function Get()
		debug.trace("iEquip_WidgetCore isPreselectMode Get called")
		return PreselectMode
	endFunction

	function Set(bool enabled)
		debug.trace("iEquip_WidgetCore isPreselectMode Set called")
		PreselectMode = enabled
		bool[] args = new bool[5]
		if PreselectMode
			Self.RegisterForModEvent("iEquip_ReadyForPreselectAnimation", "ReadyForPreselectAnimation")
			int Q = 0
			if isAmmoMode
				ammoModeActiveOnTogglePreselect = true
				Q = 1 ;Skip updating left hand preselect if currently in ammo mode as it's already set
			endIf
			while Q < 3
				int count = JArray.count(targetQ[Q])
				;if any of the queues have less than 3 items in it then there is either nothing to preselect (1 item in queue) or you'd just be doing the same as regularly cycling two items so no need for preselect, therefore disable preselect elements for that slot
				if count < 3
					currentlyPreselected[Q] = -1
				else
					;Otherwise if enabled, set left, right and shout preselect to next item in each queue, play power up sound, update widget and show preselect elements
					currentlyPreselected[Q] = currentQueuePosition[Q] + 1
					if currentlyPreselected[Q] == count
						currentlyPreselected[Q] = 0
					endIf
					debug.trace("iEquip_WidgetCore isPreselectMode Set(), PreselectMode: " + PreselectMode + ", Q: " + Q + ", currentlyPreselected[" + Q + "]: " + currentlyPreselected[Q])
					updateWidget(Q, currentlyPreselected[Q])
				endIf
				Q += 1
			endwhile

			leftPreselectShown = true
			if currentlyPreselected[0] == -1
				leftPreselectShown = false
			endIf
			rightPreselectShown = true
			if currentlyPreselected[1] == -1
				rightPreselectShown = false
			endIf
			;Also if shout preselect has been turned off in the MCM or hidden in Edit Mode make sure it stays hidden before showing the preselect group
			shoutPreselectShown = true
			if !shoutEnabled || !MCM.bShoutPreselectEnabled || currentlyPreselected[2] == -1
				shoutPreselectShown = false
			endIf

			;Add showLeft/showRight with check for number of items in queue must be greater than 1 (ie if only 1 in queue then nothing to preselect)
			args[0] = leftPreselectShown ;Show left
			args[1] = rightPreselectShown ;Show right
			args[2] = shoutPreselectShown ;Show shout if not hidden in edit mode or shoutPreselectEnabled disabled in MCM
			args[3] = EM.enableBackgrounds ;Show backgrounds if enabled
			args[4] = isAmmoMode
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			PreselectModeAnimateIn()
			if PreselectModeFirstLook && !EM.isEditMode
				Utility.Wait(1.0)
				Debug.MessageBox("iEQUIP Preselect Mode\n\nYou should now see up to three new slots in the iEQUIP widget for the left hand, right hand and shout slots, as long as you have more than two items in the queue and haven't hidden or disabled the main slots in Edit Mode or the MCM\nYour hotkeys will now cycle the preselect slots rather than the main slots, and long press will then equip the preselected item.\nPress and hold the left or right keys to equip all preselected items in one go.\nPress and hold the consumable key to exit Preselect Mode")
				PreselectModeFirstLook = false
				if RightHandWeaponIsRanged() && AmmoModePreselectModeFirstLook
					Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
					AmmoModePreselectModeFirstLook = false
				endIf
			endIf
		else
			;Hide preselect widget elements
			PreselectModeAnimateOut()
			if isAmmoMode || RightHandWeaponIsRanged()
				args[0] = true
				args[3] = EM.BackgroundsShown
			else
				args[0] = false ;Hide left
				args[3] = true ;Hide backgrounds - set to true but other three then take over and hide them anyway
			endIf
			args[1] = false ;Hide right
			args[2] = false ;Hide shout
			args[4] = isAmmoMode
			Utility.Wait(2.0)
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			Self.UnregisterForModEvent("iEquip_ReadyForPreselectAnimation")
		endIf
	endFunction
endProperty

function PreselectModeAnimateIn()
	bool[] args = new bool[3]
	if isAmmoMode
		args[0] = false ;Don't animate the left icon if already shown in ammo mode
	else
		args[0] = leftPreselectShown
	endIf
	args[1] = shoutPreselectShown
	args[2] = rightPreselectShown
	UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn", args)
	if nameFadeoutEnabled
		int i = 0
		while i < 3
			if i < 2
				updateAttributeIcons(i, currentlyPreselected[i])
			endIf
			if !isNameShown[i]
				showName(i)
			endIf
			i += 1
		endwhile
		if leftPreselectShown
			LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if rightPreselectShown
			RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if shoutPreselectShown
			SPNUpdate.registerForNameFadeoutUpdate()
		endIf
	endIf
endFunction

function PreselectModeAnimateOut()
	debug.trace("iEquip_WidgetCore PreselectModeAnimateOut called")
	bool inAmmoMode = isAmmoMode
	if !togglingPreselectOnEquipAll
		bool[] args = new bool[3]
		args[0] = rightPreselectShown
		args[1] = shoutPreselectShown
		args[2] = leftPreselectShown
		if inAmmoMode || RightHandWeaponIsRanged()
			args[2] = false ;Stop left slot from animating out if we currently have a ranged weapon equipped in the right hand or are in ammo mode as we still need it to show in regular mode
		endIf
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf
	int i = 0
	while i < 3
		if (i == 0 && !inAmmoMode) || i == 1
			hideAttributeIcons(i + 5)
		endIf
		if nameFadeoutEnabled && !isNameShown[i]
			showName(i)
		endIf
		i += 1
	endwhile
	if togglingPreselectOnEquipAll
		togglingPreselectOnEquipAll = false
	endIf
endFunction

function toggleAmmoMode(bool toggleWithoutAnimation = false, bool toggleWithoutEquipping = false)
	debug.trace("iEquip_WidgetCore toggleAmmoMode called, toggleWithoutAnimation: " + toggleWithoutAnimation + ", toggleWithoutEquipping" + toggleWithoutEquipping)
	if !AmmoMode && jArray.count(targetQ[ammoQ]) < 1
		debug.Notification("You do not appear to have any ammo to equip for this type of weapon")
	else
		toggleAmmoModeWithoutAnimation = toggleWithoutAnimation
		toggleAmmoModeWithoutEquipping = toggleWithoutEquipping
		isAmmoMode = !isAmmoMode
	endIf
endFunction

bool Property isAmmoMode
	bool function Get()
		debug.trace("iEquip_WidgetCore isAmmoMode Get called")
		return AmmoMode
	endFunction

	function Set(bool enabled)
		debug.trace("iEquip_WidgetCore isAmmoMode Set called, enabled: " + enabled + ", toggleAmmoModeWithoutAnimation: " + toggleAmmoModeWithoutAnimation + ", toggleAmmoModeWithoutEquipping: " + toggleAmmoModeWithoutEquipping)
		AmmoMode = enabled
		ReadyForAmmoModeAnim = false
		Self.RegisterForModEvent("iEquip_ReadyForAmmoModeAnimation", "ReadyForAmmoModeAnimation")
		bool[] widgetData = new bool[2]
		if AmmoMode
			;Hide the left hand poison elements if currently shown
			if poisonInfoDisplayed[0]
				hidePoisonInfo(0)
			endIf
			;Now unequip the left hand to avoid any strangeness when switching ranged weapons in AmmoMode
			if !(currentlyEquipped[1] == "Bound Bow" || currentlyEquipped[1] == "Bound Crossbow")
				UnequipHand(0)
			endIf
			;Prepare and run the animation
			if !toggleAmmoModeWithoutAnimation
				widgetData[0] = true ;Animate In
				widgetData[1] = EM.BackgroundsShown
				debug.trace("iEquip_WidgetCore isAmmoMode Set() about to call .prepareForAmmoModeAnimation, widgetData: " + widgetData)
				UI.invokeboolA(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", widgetData)
				while !ReadyForAmmoModeAnim
					Utility.Wait(0.01)
				endwhile
				AmmoModeAnimateIn()
			endIf
			if isPreselectMode
				;Equip the ammo and update the left hand slot in the widget
				checkAndEquipAmmo(false, true, true)
				;Show the counter if previously hidden
				if !isCounterShown(0)
					setCounterVisibility(0, true)
				endIf
			endIf
		else
			if !toggleAmmoModeWithoutAnimation
				;Switch back to left hand weapon
				widgetData[0] = false ;Animate Out
				widgetData[1] = EM.BackgroundsShown
				UI.invokeboolA(HUD_MENU, WidgetRoot + ".prepareForAmmoModeAnimation", widgetData)
				while !ReadyForAmmoModeAnim
					Utility.Wait(0.01)
				endwhile
				AmmoModeAnimateOut()
			endIf
		endIf
		Self.UnregisterForModEvent("iEquip_ReadyForAmmoModeAnimation")
	endFunction
endProperty

event ReadyForAmmoModeAnimation(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore ReadyForAmmoModeAnimation called")
	If(sEventName == "iEquip_ReadyForAmmoModeAnimation")
		ReadyForAmmoModeAnim = true
	endIf
endEvent

function AmmoModeAnimateIn()
	debug.trace("iEquip_WidgetCore AmmoModeAnimateIn called")		
	;Get icon name and item name data for the item currently showing in the left hand slot and the ammo to be equipped
	int ammoObject = jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ])
	string ammoIcon = jMap.getStr(ammoObject, "Icon")
	if MCM.ammoIconSuffix != ""
		ammoIcon += MCM.ammoIconSuffix
	endIf
	int leftHandObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
	currentlyEquipped[0] = jMap.getStr(leftHandObject, "Name")
	string[] widgetData = new string[4]
	widgetData[0] = jMap.getStr(leftHandObject, "Icon")
	widgetData[1] = currentlyEquipped[0]
	widgetData[2] = ammoIcon
	widgetData[3] = currentlyEquipped[ammoQ]
	;Set the left preselect index to whatever is currently equipped in the left hand ready for cycling the preselect slot in ammo mode
	currentlyPreselected[0] = currentQueuePosition[0]
	;Update the left hand widget - will animate the current left item to the left preselect slot and animate in the ammo to the main left slot
	debug.trace("iEquip_WidgetCore AmmoModeAnimateIn about to call .ammoModeAnimateIn, widgetData: " + widgetData)
	Self.RegisterForModEvent("iEquip_AmmoModeAnimationComplete", "onAmmoModeAnimationComplete")
	waitingForAmmoModeAnimation = true
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".ammoModeAnimateIn", widgetData)
	cyclingLHPreselectInAmmoMode = true
	updateAttributeIcons(0, currentlyPreselected[0], false, true)
	;If we've just equipped a bound weapon the ammo will already be equipped, otherwise go ahead and equip the ammo
	if boundAmmoAdded
		boundAmmoAdded = false ;Reset
	else
		checkAndEquipAmmo(true, true, false)
	endIf
	;Update the left hand counter
	setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(ammoObject, "Form")))
	;Show the counter if previously hidden
	if !isCounterShown(0)
		setCounterVisibility(0, true)
	endIf
	;Show the names if previously faded out on timer	
	if nameFadeoutEnabled
		if !isNameShown[0] ;Left Name
			showName(0)
		endIf
		if !isNameShown[5] ;Left Preselect Name
			showName(5)
		endIf
	endIf
endFunction

function AmmoModeAnimateOut()
	debug.trace("iEquip_WidgetCore AmmoModeAnimateOut called")
	hideAttributeIcons(5)
	;Get icon and item name for item currently showing in the left preselect slot ready to update the main slot
	string[] widgetData = new string[3]
	string ammoIcon = jMap.getStr(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Icon")
	if MCM.ammoIconSuffix != ""
		ammoIcon += MCM.ammoIconSuffix
	endif 
	int leftPreselectObject = jArray.getObj(targetQ[0], currentlyPreselected[0])
	widgetData[0] = ammoIcon
	widgetData[1] = jMap.getStr(leftPreselectObject, "Icon")
	widgetData[2] = jMap.getStr(leftPreselectObject, "Name")
	;Update the widget - will throw away the ammo and animate the icon from preselect back to main position
	Self.RegisterForModEvent("iEquip_AmmoModeAnimationComplete", "onAmmoModeAnimationComplete")
	waitingForAmmoModeAnimation = true
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".ammoModeAnimateOut", widgetData)
	;Update the main slot index
	int leftObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
	if !isPreselectMode
		currentQueuePosition[0] = currentlyPreselected[0]
		currentlyEquipped[0] = jMap.getStr(leftObject, "Name")
	endIf
	;And re-equip the left hand item, which should in turn force a re-equip on the right hand to a 1H item, as long as we've not just toggled out of ammo mode as a result of us equipping a 2H weapon in the right hand
	if !toggleAmmoModeWithoutEquipping
		cycleHand(0, currentQueuePosition[0], jMap.getForm(leftObject, "Form"))
	endIf
	;Show the left name if previously faded out on timer
	if nameFadeoutEnabled && !isNameShown[0] ;Left Name
		showName(0)
	endIf
	;Hide the left hand counter again if the new left hand item doesn't need it
	if !itemRequiresCounter(0) && !isWeaponPoisoned(0, currentQueuePosition[0], true)
		setCounterVisibility(0, false)
	;Otherwise update the counter for the new left hand item
	else
		if itemRequiresCounter(0)
			setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(leftPreselectObject, "Form")))
		elseif isWeaponPoisoned(0, currentQueuePosition[0], true)
			checkAndUpdatePoisonInfo(0)
		endIf
	endIf
endFunction

event onAmmoModeAnimationComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore onAmmoModeAnimationComplete called")
	If(sEventName == "iEquip_AmmoModeAnimationComplete")
		waitingForAmmoModeAnimation = false
		Self.UnregisterForModEvent("iEquip_AmmoModeAnimationComplete")
	endIf
endEvent

function cycleAmmo(bool reverse, bool ignoreEquipOnPause = false)
	debug.trace("iEquip_WidgetCore cycleAmmo called")
	int queueLength = jArray.count(targetQ[ammoQ])
	int targetIndex
	;No need for any checking here at all, we're just cycling ammo so just cycle and equip
	if reverse
		targetIndex = currentQueuePosition[ammoQ] - 1
		if targetIndex < 0
			targetIndex = queueLength - 1
		endIf
	else
		targetIndex = currentQueuePosition[ammoQ] + 1
		if targetIndex == queueLength
			targetIndex = 0
		endIf
	endIf
	if targetIndex != currentQueuePosition[ammoQ]
		currentQueuePosition[ammoQ] = targetIndex
		checkAndEquipAmmo(reverse, ignoreEquipOnPause)
	endIf
endFunction

function selectBestAmmo()
	debug.trace("iEquip_WidgetCore selectBestAmmo called")
	currentQueuePosition[ammoQ] = 0
	currentlyEquipped[ammoQ] = jMap.getStr(jArray.getObj(targetQ[ammoQ], 0), "Name")
endFunction

function selectLastUsedAmmo()
	debug.trace("iEquip_WidgetCore selectLastUsedAmmo called")
	string ammoName = currentlyEquipped[ammoQ]
	int queueLength = jArray.count(targetQ[ammoQ])
	int iIndex = 0
	bool found = false
	while iIndex < queueLength && !found
		if ammoName != jMap.getStr(jArray.getObj(targetQ[ammoQ], iIndex), "Name")
			iIndex += 1
		else
			found = true
		endIf
	endwhile
	;if the last used ammo isn't found in the newly sorted queue then set the queue position to 0 and update the name ready for updateWidget
	if !found
		currentQueuePosition[ammoQ] = 0
		currentlyEquipped[ammoQ] = jMap.getStr(jArray.getObj(targetQ[ammoQ], 0), "Name")
	;if the last used ammo is found in the newly sorted queue then set the queue position to the index where it was found
	else
		currentQueuePosition[ammoQ] = iIndex
	endIf
endFunction

function checkAndEquipAmmo(bool reverse, bool ignoreEquipOnPause, bool animate = true, bool equip = true)
	debug.trace("iEquip_WidgetCore checkAndEquipAmmo called - reverse: " + reverse + ", ignoreEquipOnPause: " + ignoreEquipOnPause + ", animate: " + animate)
	int targetIndex = currentQueuePosition[ammoQ]
	int ammoCount = PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(targetQ[ammoQ], targetIndex), "Form"))
	;Check we've still got the at least one of the target ammo, if not remove it from the queue and advance the queue again
	if ammoCount < 1
		removeItemFromQueue(ammoQ, targetIndex, false, true)
		cycleAmmo(reverse, ignoreEquipOnPause)
	;Otherwise update the widget and either register for the EquipOnPause update or equip immediately
	else
		if animate
			int ammoObject = jArray.getObj(targetQ[ammoQ], targetIndex)
			currentlyEquipped[ammoQ] = jMap.getStr(ammoObject, "Name")
			string ammoIcon = jMap.getStr(ammoObject, "Icon")
			if MCM.ammoIconSuffix != ""
				ammoIcon += MCM.ammoIconSuffix
			endIf

			float fNameAlpha = afWidget_A[nameElements[0]]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			;Update the widget
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			If(iHandle)
				UICallback.PushInt(iHandle, 0) ;Left hand widget
				UICallback.PushString(iHandle, ammoIcon) ;New icon
				UICallback.PushString(iHandle, currentlyEquipped[ammoQ]) ;New name
				UICallback.PushFloat(iHandle, fNameAlpha) ;Current item name alpha value
				UICallback.Send(iHandle)
			endIf
			;Update the left hand counter
			setSlotCount(0, ammoCount)
			if nameFadeoutEnabled && !isNameShown[0] ;Left Name
				showName(0)
			endIf
		endIf
		;Equip the ammo
		if equip
			if !ignoreEquipOnPause && EquipOnPause
				LHUpdate.registerForEquipOnPauseUpdate(Reverse, true)
			else
				debug.trace("iEquip_WidgetCore checkAndEquipAmmo - about to equip " + currentlyEquipped[ammoQ])
				equipAmmo()
			endIf
		endIf
	endIf
endFunction

function updateAmmoCounterOnBowShot(Ammo akAmmo)
	debug.trace("iEquip_WidgetCore updateAmmoCounterOnBowShot called")
	form currentAmmo = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form")
	if akAmmo == currentAmmo as Ammo
		int ammoCount = PlayerRef.GetItemCount(currentAmmo)
		if ammoCount < 1
			removeItemFromQueue(ammoQ, currentQueuePosition[ammoQ], false, true)
			checkAndEquipAmmo(false, true)
		else
			setSlotCount(0, ammoCount)
		endIf
	endIf
endFunction

function updateAmmoCounterOnCrossbowShot()
	debug.trace("iEquip_WidgetCore updateAmmoCounterOnCrossbowShot called")
	form currentAmmo = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form")
	int currentlyDisplayedCount = UI.GetString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftCount_mc.leftCount.text") as int
	debug.trace("iEquip_WidgetCore updateAmmoCounterOnCrossbowShot - currentAmmo: " + currentAmmo + ", currentlyDisplayedCount" + currentlyDisplayedCount)
	Utility.Wait(0.5)
	int ammoCount = PlayerRef.GetItemCount(currentAmmo)
	debug.trace("iEquip_WidgetCore updateAmmoCounterOnCrossbowShot - ammoCount: " + ammoCount)
	if ammoCount != currentlyDisplayedCount
		if ammoCount < 1
			removeItemFromQueue(ammoQ, currentQueuePosition[ammoQ], false, true)
			checkAndEquipAmmo(false, true)
		else
			setSlotCount(0, ammoCount)
		endIf
	endIf
endfunction

bool function switchingRangedWeaponType(int itemType)
	int currRangedWeaponType = PlayerRef.GetEquippedItemType(1)
	if currRangedWeaponType == 12
		currRangedWeaponType = 9
	endIf
	return (itemType != currRangedWeaponType)
endFunction

function prepareAmmoQueue(int weaponType)
	debug.trace("iEquip_WidgetCore prepareAmmoQueue called, weaponType: " + weaponType)
	ammoQ = 5 ;objArrowQ
	bool isCrossbow = false
	if weaponType == 9
		ammoQ = 6 ;objBoltQ
		isCrossbow = true
	endIf 
	AM.updateAmmoList(targetQ[ammoQ], isCrossbow, (MCM.AmmoListSorting == 3)) ;force re-sorting by quantity
endFunction

function equipAmmo()
	debug.trace("iEquip_WidgetCore equipAmmo called")
	PlayerRef.EquipItemEx(jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form") as Ammo)
endFunction

bool function itemRequiresCounter(int Q, int itemType = -1, string itemName = "")
	debug.trace("iEquip_WidgetCore itemRequiresCounter called")
	bool requiresCounter = false
	int itemObject = jArray.getObj(targetQ[Q], currentQueuePosition[Q])
	if itemType == -1
		itemType = jMap.getInt(itemObject, "Type")
	endIf
	if itemName == ""
		itemName = jMap.getStr(itemObject, "Name")
	endIf
	if itemType == 42 || itemType == 23 || itemType == 31 ;Ammo (which takes in Throwing Weapons), scroll, torch
		requiresCounter = true
    elseif itemType == 4 && (contains(itemName, "renade") || contains(itemName, "lask") || contains(itemName, "Pot") || contains(itemName, "pot") || contains(itemName, "omb")) ;Looking for CACO grenades here which are classed as maces
    	requiresCounter = true
    else
    	requiresCounter = false
    endIf
    debug.trace("iEquip_WidgetCore itemRequiresCounter returning " + requiresCounter)
    return requiresCounter
endFunction

bool function isCounterShown(int Q)
	debug.trace("iEquip_WidgetCore isCounterShown called")
	if Q == 0
		return leftCounterShown
	elseif Q == 1
		return rightCounterShown
	else
		return true
	endIf
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

bool bReverse ;Used if EquipOnPause is enabled
bool WaitingForEquipOnPauseUpdate = false
bool cyclingLHPreselectInAmmoMode = false

function cycleSlot(int Q, bool Reverse = false)
	debug.trace("iEquip_WidgetCore cycleSlot called, Q: " + Q + ", Reverse: " + Reverse)
	debug.trace("iEquip_WidgetCore cycleSlot - isNameShown[Q]: " + isNameShown[Q])
	;Q: 0 = Left hand, 1 = Right hand, 2 = Shout, 3 = Consumables, 4 = Poisons

	;Check if queue contains anything and return out if not
	int queueLength = JArray.count(targetQ[Q])
	if queueLength == 0
		debug.notification("Your " + queueName[Q] + " is currently empty")
		return
	;if Preselect Mode is enabled then left/right/shout needs to cycle the preselect slot not the main widget. if shout preselect is disabled cycle main shout slot
	elseif (PreselectMode && !preselectSwitchingHands && (Q < 2 || (Q == 2 && MCM.bShoutPreselectEnabled))) || (Q == 0 && isAmmoMode)
		;if preselect name not shown then first cycle press shows name without advancing the queue
		debug.trace("iEquip_WidgetCore cycleSlot - isNameShown[Q + 5]: " + isNameShown[Q + 5])
		if firstPressShowsName && !isNameShown[Q + 5]
			showName(Q + 5)
			return
		else
			if Q == 0 && isAmmoMode
				cyclingLHPreselectInAmmoMode = true
			endIf
			cyclePreselectSlot(Q, queueLength, Reverse)
			return
		endIf
	;if name not shown then first cycle press shows name without advancing the queue
	elseif firstPressShowsName && !preselectSwitchingHands && !isNameShown[Q] && currentlyEquipped[Q] != ""
		showName(Q)
		return
	endIf
	;Hide the slot counter if currently shown
	if Q < 2 
		if isCounterShown(Q)
			setCounterVisibility(Q, false)
		endIf
		if poisonInfoDisplayed[Q]
			hidePoisonInfo(Q)
		endIf
	endIf
	;Make sure we're starting from the correct index, in case somehow the queue has been amended without the currentQueuePosition array being updated
	if currentlyEquipped[Q] != ""
		currentQueuePosition[Q] = findInQueue(Q, currentlyEquipped[Q])
	endIf
	;In the unlikely event that the item currently shown in the widget has not been found in the queue array then start cycling from index 0
	if currentQueuePosition[Q] == -1
		currentQueuePosition[Q] = 0
	endIf
	;Store starting index
	if Q < 3 && indexOnStartCycle[Q] == -1
		indexOnStartCycle[Q] = currentQueuePosition[Q]
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
    string targetName
	if queueLength > 1
		;Set the initial target index
		targetIndex = currentQueuePosition[Q] + move
		;Check if we're cycling past the first or last items in the queue and jump to the start/end as required
		if targetIndex < 0 && Reverse
			targetIndex = queueLength - 1
		elseif targetIndex == queueLength && !Reverse
			targetIndex = 0
		endIf
		;Check we're not trying to select the currently equipped item - only becomes relevant if we cycle through the entire queue or change direction and cycle back past where we started from (excludes potion and poison queues), or equip the same 1H item which is currently equipped in the other hand and 1H switchign disallowed, or we're in the consumables queue and we're checking for empty potion groups
		if Q < 4
	    	targetName = jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Name")
	    	bool hideEmptyPotionGroups = (MCM.emptyPotionQueueChoice == 1)
		    if Q == 3
		        ;if MCM.emptyPotionQueueChoice == 1
		            while (targetName == "Health Potions" && (!MCM.bHealthPotionGrouping || (hideEmptyPotionGroups && potionGroupEmpty[0]))) || (targetName == "Stamina Potions" && (!MCM.bStaminaPotionGrouping || (hideEmptyPotionGroups && potionGroupEmpty[1]))) || (targetName == "Magicka Potions" && (!MCM.bMagickaPotionGrouping || (hideEmptyPotionGroups && potionGroupEmpty[2])))
		                targetIndex = targetIndex + move
		                if targetIndex < 0 && Reverse
		                    targetIndex = queueLength - 1
		                elseif targetIndex == queueLength && !Reverse
		                    targetIndex = 0
		                endIf
		                targetName = jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Name")
		            endWhile
		        ;endIf
		    elseIf Q < 3
		        while (targetIndex == indexOnStartCycle[Q] && MCM.bSkipCurrentItemWhenCycling) || Q < 2 && (jMap.getForm(jArray.getObj(targetQ[Q], targetIndex), "Form") == PlayerRef.GetEquippedObject(otherHand) && PlayerRef.GetItemCount(targetItem) < 2 && !MCM.bAllowWeaponSwitchHands)
		            targetIndex = targetIndex + move
		            if targetIndex < 0 && Reverse
		                targetIndex = queueLength - 1
		            elseif targetIndex == queueLength && !Reverse
		                targetIndex = 0
		            endIf
		            targetName = jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Name")
		        endWhile
		    else
		        debug.trace("Error Occured")
		    endIf
	    endIf
		;if we're switching because of a hand to hand swap in EquipPreselectedItem then if the targetIndex matches the currently preselected item skip past it when advancing the main queue.
		if preselectSwitchingHands && targetIndex == currentlyPreselected[Q]
			targetIndex += 1
			if targetIndex == queueLength
				targetIndex = 0
			endIf
		endIf
	else
		targetIndex = 0
	endIf
	int targetObject = jArray.getObj(targetQ[Q], targetIndex)
	form targetItem
	int itemType
	bool isPotionGroup = false
	if Q == 3 && contains(targetName, "Potions")
		isPotionGroup = true
		targetItem = none
	else
		targetItem = jMap.getForm(targetObject, "Form")
	endIf
	bool ignoreEquipOnPause = false
	if Q < 2
		itemType = jMap.getInt(targetObject, "Type")
		if switchingHands || preselectSwitchingHands
			debug.trace("iEquip_WidgetCore cycleSlot - Q: " + Q + ", switchingHands: " + switchingHands)
			;if we're forcing the left hand to switch equipped items because we're switching left to right, make sure we don't leave the left hand unarmed
			if Q == 0
				if itemType == 0 || targetItem == iEquip_Unarmed1H
					targetIndex += 1
					if targetIndex == queueLength
						targetIndex = 0
					endIf
				endIf
			;if we are forcing the right hand to switch equipped items, either because we're switching right to left, or because equipping the left hand is forcing a 2h or ranged weapon to be unequipped then we need to make sure we are re-equipping a 1h weapon in the right hand
			elseif Q == 1
				; Check if initial target item is 2h or ranged, or if it is a 1h item but you only have one of it and you've just equipped it in the other hand, or if it is unarmed
				int itemCount = PlayerRef.GetItemCount(targetItem)
				if (itemType == 0 || targetItem == iEquip_Unarmed1H || targetItem == iEquip_Unarmed2H || itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9) || ((currentlyEquipped[0] == jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Name")) && itemCount < 2)
					int newTarget = targetIndex + 1
					if newTarget >= queueLength
						newTarget = 0
					endIf
					bool matchFound = false
					; if it is then starting from the currently equipped index search forward for a 1h item
					while newTarget != targetIndex && !matchFound
						targetObject = jArray.getObj(targetQ[Q], newTarget)
						targetItem = jMap.getForm(targetObject, "Form")
						itemType = jMap.getInt(targetObject, "Type")
						itemCount = PlayerRef.GetItemCount(targetItem)
						; if the new target item is 2h or ranged, or if it is a 1h item but you only have one of it and it's already equipped in the other hand, or it is unarmed then move on again
						if (itemType == 0 || targetItem == iEquip_Unarmed1H || targetItem == iEquip_Unarmed2H || itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9) || ((currentlyEquipped[0] == jMap.getStr(targetObject, "Name")) && itemCount < 2)
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
		if switchingHands || preselectSwitchingHands
			ignoreEquipOnPause = true
		endIf
	endIf
	;Update the widget to the next queued item immediately then register for EquipOnPause update or call cycle functions straight away
	currentQueuePosition[Q] = targetIndex
	currentlyEquipped[Q] = jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Name")
	updateWidget(Q, targetIndex, false, true)
	
	if Q < 2
		;if EquipOnPause is enabled and you are cycling left/right/shout, and we're not ignoring EquipOnPause because we're switching hands, then use the EquipOnPause updates
		if !ignoreEquipOnPause && EquipOnPause
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
endFunction

function checkAndEquipShownHandItem(int Q, bool Reverse = false)
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem called")
	int targetIndex = currentQueuePosition[Q]
	int targetObject = jArray.getObj(targetQ[Q], currentQueuePosition[Q])
    Form targetItem = jMap.getForm(targetObject, "Form")
    int itemType = jMap.getInt(targetObject, "Type")
    if currentlyQuickRanged
    	currentlyQuickRanged = false
    elseIf currentlyQuickHealing
    	currentlyQuickHealing = false
    endIf
    indexOnStartCycle[Q] = -1 ;Reset ready for next cycle
    ;if we're equipping Fists 2H
    if Q == 1 && targetItem == iEquip_Unarmed2H
		goUnarmed()
		return  
    ;if you already have the item/shout equipped in the slot you are cycling then do nothing
    elseif (targetItem == PlayerRef.GetEquippedObject(Q)) || targetItem == None
    	return
	;if somehow the item has been removed from the player and we haven't already caught it remove it from queue and advance queue again
	elseif !playerStillHasItem(targetItem)
		AddItemToLastRemovedCache(Q, targetIndex)
		jArray.eraseIndex(targetQ[Q], targetIndex)
		;if you are cycling backwards you have just removed the previous item in the queue so the currentQueuePosition needs to be updated before calling cycleSlot again
		if Reverse
			currentQueuePosition[Q] = currentQueuePosition[Q] - 1
		endIf
		cycleSlot(Q, Reverse)
		return
	endIf
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - player still has item, Q: " + Q + ", currentQueuePosition: " + currentQueuePosition[Q] + ", itemName: " + jMap.getStr(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "Name"))
	;if we're about to equip a ranged weapon and we're not already in Ammo Mode or we're switching ranged weapon type set the ammo queue to the first ammo in the array and then animate in if needed
	bool inAmmoMode = isAmmoMode
	debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - inAmmoMode: " + inAmmoMode + ", isPreselectMode: " + isPreselectMode)
	if Q == 1
		;if we're equipping a ranged weapon
		int ammoObject = jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ])
		if (itemType == 7 || itemType == 9)
			;Firstly we need to update the relevant ammo list.  We'll update the widget once the weapon is equipped
			checkAndRemoveBoundAmmo(itemType)
			if !inAmmoMode
				if leftIconFaded
					checkAndFadeLeftIcon(1, 7)
					Utility.Wait(0.2)
				endIf
				prepareAmmoQueue(itemType)
			elseif switchingRangedWeaponType(itemType) || MCM.AmmoListSorting == 3
				prepareAmmoQueue(itemType)
				checkAndEquipAmmo(false, true, false)
			endIf
			if itemType == 9
				EH.crossbowEquipped = true
			endIf
			;if we are already in Ammo Mode or Preselect Mode we're switching from a bow to a crossbow or vice versa so we need to update the ammo widget
			if inAmmoMode || isPreselectMode
				updateWidget(0, currentQueuePosition[ammoQ])
				setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(ammoObject, "Form")))
			else
				toggleAmmoMode() ;Animate in
			endIf
			if !isWeaponPoisoned(1, currentQueuePosition[1]) && isCounterShown(1)
				setCounterVisibility(1, false)
			endIf
		;if we're already in Ammo Mode and about to equip something in the right hand which is not another ranged weapon then we need to toggle out of Ammo Mode
		elseif inAmmoMode
			;Animate out without equipping the left hand item, we'll handle this later once right hand re-equipped
			toggleAmmoMode(false, true)
			;if we've still got the shown ammo equipped and have enabled Unequip Ammo in the MCM then unequip it now
			if PlayerRef.isEquipped(jMap.getForm(ammoObject, "Form") as Ammo) && MCM.bUnequipAmmo
				PlayerRef.UnequipItemEx(jMap.getForm(ammoObject, "Form") as Ammo)
			endIf
			justLeftAmmoMode = true
		endIf
		if itemType != 9
			EH.crossbowEquipped = false
		endIf
		;if we're equipping a 2H item in the right hand from goneUnarmed then we need to update the left slot back to the item prior to going unarmed before fading the left icon if required
		if goneUnarmed && (itemType == 5 || itemType == 6)
    		updateWidget(0, currentQueuePosition[0])
    		targetObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
    		if itemRequiresCounter(0, jMap.getInt(targetObject, "Type"))
				setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "Form")))
				setCounterVisibility(0, true)
			endIf
    	endIf
	endIf
	;if we're cyling left or right and not in Ammo Mode check if new item requires a counter
	if !isAmmoMode
		if itemRequiresCounter(Q, itemType)
			;Update the item count
			setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
			;Show the counter if currently hidden
			if !isCounterShown(Q)
				setCounterVisibility(Q, true)
			endIf
		;The new item doesn't require a counter to hide it if it's currently shown
		elseif isCounterShown(Q)
			setCounterVisibility(Q, false)
		endIf
	endIf
	;Now that we've passed all the checks we can carry on and equip
	cycleHand(Q, targetIndex, targetItem, itemType)
	Utility.Wait(0.2)
	if justLeftAmmoMode
		justLeftAmmoMode = false
		Utility.Wait(0.3)
	endIf
	checkAndFadeLeftIcon(Q, itemType)
endFunction

function checkAndFadeLeftIcon(int Q, int itemType)
	debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon called - Q: " + Q + ", itemType: " + itemType + ", MCM.bFadeLeftIconWhen2HEquipped: " + MCM.bFadeLeftIconWhen2HEquipped + ", leftIconFaded: " + leftIconFaded)
	;if we're equipping 2H or ranged then check and fade left icon
	float[] widgetData = new float[6]
	if Q == 1 && MCM.bFadeLeftIconWhen2HEquipped && (itemType == 5 || itemType == 6) && !leftIconFaded
		float adjustment = (1 - (MCM.leftIconFadeAmount * 0.01))
		widgetData[0] = afWidget_A[6] * adjustment ;leftBg_mc
		widgetData[1] = afWidget_A[7] * adjustment ;leftIcon_mc
		if isNameShown[0]
			widgetData[2] = afWidget_A[8] * adjustment ;leftName_mc
		else
			widgetData[2] = 0
		endIf
		if leftCounterShown
			widgetData[3] = afWidget_A[9] * adjustment ;leftCount_mc
		else
			widgetData[3] = 0
		endIf
		if isWeaponPoisoned(0, currentQueuePosition[0])
			widgetData[4] = afWidget_A[10] * adjustment ;leftPoisonIcon_mc
			if isPoisonNameShown[0]
				widgetData[5] = afWidget_A[11] * adjustment ;leftPoisonName_mc
			else
				widgetData[5] = 0
			endIf
		else
			widgetData[4] = 0
			widgetData[5] = 0
		endIf
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		leftIconFaded = true
	;For anything else check if it is currently faded and if so fade it back in
	elseif Q < 2 && leftIconFaded
		widgetData[0] = afWidget_A[6]
		widgetData[1] = afWidget_A[7]
		if isNameShown[0]
			widgetData[2] = afWidget_A[8]
		else
			widgetData[2] = 0
		endIf
		if leftCounterShown
			widgetData[3] = afWidget_A[9]
		else
			widgetData[3] = 0
		endIf
		if isWeaponPoisoned(0, currentQueuePosition[0])
			widgetData[4] = afWidget_A[10]
			if isPoisonNameShown[0]
				widgetData[5] = afWidget_A[11]
			else
				widgetData[5] = 0
			endIf
		else
			widgetData[4] = 0
			widgetData[5] = 0
		endIf
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
		leftIconFaded = false
	endIf
endFunction

function checkAndEquipShownShoutOrConsumable(int Q, bool Reverse, int targetIndex, form targetItem, bool isPotionGroup)
	debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable called - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", isPotionGroup: " + isPotionGroup)
	if (targetItem && targetItem != none && !playerStillHasItem(targetItem)) || (Q == 3 && targetItem == none && !isPotionGroup)
		AddItemToLastRemovedCache(Q, targetIndex)
		jArray.eraseIndex(targetQ[Q], targetIndex)
		;if you are cycling backwards you have just removed the previous item in the queue so the currentQueuePosition needs to be updated before calling cycleSlot again
		if Reverse
			currentQueuePosition[Q] = currentQueuePosition[Q] - 1
		endIf
		cycleSlot(Q, Reverse)
	else
		if Q == 2 && shoutEnabled && !(targetItem == PlayerRef.GetEquippedShout())
			indexOnStartCycle[2] = -1 ;Reset ready for next cycle
			cycleShout(Q, targetIndex, targetItem)
		elseif Q == 3 && consumablesEnabled
			cycleConsumable(targetItem, targetIndex)
		elseif Q == 4 && poisonsEnabled
			cyclePoison(targetItem)
		else
			debug.trace("iEquip_WidgetCore - Something went wrong!")
		endIf
	endIf
endFunction

function checkAndFadeConsumableIcon(bool fadeOut)
	debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon called - fadeOut: " + fadeOut + ", consumableIconFaded: " + consumableIconFaded)
	;if we're equipping 2H or ranged then check and fade left icon
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (MCM.leftIconFadeAmount * 0.01)) ;Use same value as left icon fade for consistency
		widgetData[0] = afWidget_A[38] * adjustment ;consumableBg_mc
		widgetData[1] = afWidget_A[39] * adjustment ;consumableIcon_mc
		if isNameShown[3]
			widgetData[2] = afWidget_A[40] * adjustment ;consumableName_mc
		else
			widgetData[2] = 0.0
		endIf
		widgetData[3] = afWidget_A[41]  * adjustment ;consumableCount_mc
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		consumableIconFaded = true
	;For anything else fade it back in (we've already checked if it needs fading or not before calling this function)
	else
		widgetData[0] = afWidget_A[38]
		widgetData[1] = afWidget_A[39]
		if isNameShown[3]
			widgetData[2] = afWidget_A[40]
		else
			widgetData[2] = 0.0
		endIf
		widgetData[3] = afWidget_A[41]
		debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon - fading in, widgetData: " + widgetData)
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		consumableIconFaded = false
	endIf
endFunction

function setCounterVisibility(int Q, bool show)
	debug.trace("iEquip_WidgetCore setCounterVisibility called - Q: " + Q + ", show: " + show)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetCounterAlpha")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which counter _mc we're fading out
		if show
			Float targetAlpha
			if Q == 0
				targetAlpha = afWidget_A[9] ;Left count alpha
				leftCounterShown = true
			elseif Q == 1
				targetAlpha = afWidget_A[22] ;Right count alpha
				rightCounterShown = true
			endIf
			if targetAlpha < 1
				targetAlpha = 100
			endIf
			UICallback.PushFloat(iHandle, targetAlpha) ;Target alpha
		else
			if Q == 0
				leftCounterShown = false
			else
				rightCounterShown = false
			endIf
			UICallback.PushFloat(iHandle, 0) ;Target alpha
		endIf
		UICallback.PushFloat(iHandle, 0.15) ;Fade duration
		UICallback.Send(iHandle)
	endIf
endFunction

function cyclePreselectSlot(int Q, int queueLength, bool Reverse, bool animate = true)
	debug.trace("iEquip_WidgetCore cyclePreselectSlot called")
	int targetIndex
	if Reverse
		targetIndex = currentlyPreselected[Q] - 1
		if targetIndex == currentQueuePosition[Q] ;Can't preselect the item you already have equipped in the widget so move on another index
			targetIndex -= 1
		endIf
		if targetIndex < 0
			targetIndex = queueLength - 1
			if targetIndex == currentQueuePosition[Q] ;Have to recheck again in case currentQueuePosition[Q] == queueLength - 1
				targetIndex -= 1
			endIf
		endIf
	else
		targetIndex = currentlyPreselected[Q] + 1
		if targetIndex == currentQueuePosition[Q] ;Can't preselect the item you already have equipped in the widget so move on another index
			targetIndex += 1
		endIf
		if targetIndex == queueLength
			targetIndex = 0
			if targetIndex == currentQueuePosition[Q] ;Have to recheck again in case currentQueuePosition[Q] == 0
				targetIndex += 1
			endIf
		endIf
	endIf
	currentlyPreselected[Q] = targetIndex
	if animate
		updateWidget(Q, targetIndex, false, true)
	endIf
endFunction

function updateSlotsEnabled()
	debug.trace("iEquip_WidgetCore updateSlotsEnabled called - shoutEnabled: " + shoutEnabled + ", consumablesEnabled: " + consumablesEnabled + ", poisonsEnabled: " + poisonsEnabled)
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", shoutEnabled)
	abWidget_V[3] = shoutEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ConsumableWidget._visible", consumablesEnabled)
	abWidget_V[4] = consumablesEnabled
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget._visible", poisonsEnabled)
	abWidget_V[5] = poisonsEnabled
	EH.poisonSlotEnabled = poisonsEnabled
	;Hide poison indicators, counts and names
	if !poisonsEnabled
		int i = 0
		while i < 2
			if poisonInfoDisplayed[i]
				hidePoisonInfo(i)
			endIf
			i += 1
		endwhile
	endIf
endFunction

function updateWidget(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	debug.trace("iEquip_WidgetCore updateWidget called - Q: " + Q + ", iIndex: " + iIndex + ", isPreselectMode: " + isPreselectMode + ", isAmmoMode: " + isAmmoMode + ", overridePreselect: " + overridePreselect + ", preselectSwitchingHands: " + preselectSwitchingHands + ", cyclingLHPreselectInAmmoMode: " + cyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	;if we are in Preselect Mode make sure we update the preselect icon and name, otherwise update the main icon and name
	string sIcon
	string sName
	bool inAmmoMode = isAmmoMode
	int targetObject
	int Slot = Q

	if RefreshingWidgetOnLoad && Q > 4
		debug.trace("iEquip_WidgetCore updateWidget - 1st option")
		targetObject = jArray.getObj(targetQ[Q - 5], iIndex)
	elseif (isPreselectMode && !overridePreselect && !preselectSwitchingHands && Q <= 2) || cyclingLHPreselectInAmmoMode
		debug.trace("iEquip_WidgetCore updateWidget - 2nd option")
		Slot += 5
		targetObject = jArray.getObj(targetQ[Q], currentlyPreselected[Q])
	elseif Q == 0 && inAmmoMode
		debug.trace("iEquip_WidgetCore updateWidget - 3rd option")
		targetObject = jArray.getObj(targetQ[ammoQ], iIndex)
	else
		debug.trace("iEquip_WidgetCore updateWidget - 4th option")
		targetObject = jArray.getObj(targetQ[Q], iIndex)
	endIf
	sIcon = jMap.getStr(targetObject, "Icon")
	sName = jMap.getStr(targetObject, "Name")
	if Q == 0 && inAmmoMode && MCM.ammoIconSuffix != ""
		sIcon += MCM.ammoIconSuffix
	endIf

	float fNameAlpha = afWidget_A[nameElements[Slot]]
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

	if nameFadeoutEnabled
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

function checkIfBoundSpellEquipped()
	debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped called")
	bool boundSpellEquipped = false
	string spellName
	int hand = 0
	while hand < 2
		if PlayerRef.GetEquippedItemType(hand) == 9
			spellName = (PlayerRef.GetEquippedSpell(hand)).GetName()
			if contains(spellName, "Bound") || contains(spellName, "bound")
				boundSpellEquipped = true
			endIf
		endIf
		hand += 1
	endWhile
	;If the player has a 'Bound' spell equipped in either hand the event handler script registers for ActorAction 2 - Spell Fire, if not it unregisters for the action
	EH.boundSpellEquipped = boundSpellEquipped
endFunction

;Called from iEquip_PlayerEventHandler when OnActorAction receives actionType 2 (should only ever happen when the player has a 'Bound' spell equipped in either hand)
function checkIfBoundWeaponEquipped(int hand)
	debug.trace("iEquip_WidgetCore checkIfBoundWeaponEquipped called")
	bool isBoundWeapon = false
	form equippedObject = PlayerRef.GetEquippedObject(hand)
	if equippedObject as weapon
		if contains(equippedObject.GetName(), "ound")
			isBoundWeapon = true
		endIf
	endIf
	debug.trace("iEquip_WidgetCore checkIfBoundWeaponEquipped - isBoundWeapon: " + isBoundWeapon)
	if isBoundWeapon
		string iconName = "Bound"
		weapon equippedWeapon = equippedObject as Weapon
		int weaponType = equippedWeapon.GetWeaponType()
		if weaponType == 6 && equippedWeapon.IsWarhammer()
	        iconName += "Warhammer"
	    else
			iconName += weaponTypeNames[weaponType]
	    endIf
	    debug.trace("iEquip_WidgetCore checkIfBoundWeaponEquipped - iconName: " + iconName + ", weaponType: " + weaponType)
	    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
		;Replace the spell icon with the correct bound weapon icon without updating the name as it should be the same anyway
		if(iHandle)
			UICallback.PushInt(iHandle, hand) ;Target icon to update: left = 0, right  = 1
			UICallback.PushString(iHandle, iconName) ;New icon label name
			UICallback.Send(iHandle)
		endIf
		;Now if we've equipped a bound ranged weapon we need to toggle Ammo Mode and show bound ammo in the left slot
	    if weaponType == 7 || weaponType == 9 ;Bound Bow or Bound Crossbow
	    	ammoQ = 5
	    	string ammoName = "Bound Arrow"
	    	string ammoIcon = "BoundArrow"
	    	if weaponType == 9
	    		ammoQ = 6
	    		ammoName = "Bound Bolt"
	    		ammoIcon = "BoundBolt"
	    	endIf
	    	int breakout = 100 ;Max wait while is 1 sec
	    	while !boundAmmoAdded && breakout > 0
	    		Utility.Wait(0.01)
	    		breakout -= 1
	    	endWhile
	    	debug.trace("iEquip_WidgetCore checkIfBoundWeaponEquipped - boundAmmoAdded: " + boundAmmoAdded) 
	    	;If the bound ammo has not been detected and added to the queue we just need to assume it's there and add a dummy to the queue so it can be displayed in the widget
	    	if !boundAmmoAdded
	    		int boundAmmoObj = jMap.object()
				jMap.setStr(boundAmmoObj, "Icon", ammoIcon)
				jMap.setStr(boundAmmoObj, "Name", ammoName)
				;Set the current queue position and name to the last index (ie the newly added bound ammo)
				jArray.addObj(targetQ[ammoQ], boundAmmoObj)
				currentQueuePosition[ammoQ] = jArray.count(targetQ[ammoQ]) - 1
				currentlyEquipped[ammoQ] = ammoName
				boundAmmoAdded = true
	    	endIf
	    	toggleAmmoMode()
		endIf
	endIf
endFunction

function onBoundWeaponUnequipped(string weaponName)
	debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped called")
	if blockSwitchBackToBoundSpell
		blockSwitchBackToBoundSpell = false
	else
		int hand = -1
		;Check if we've got a bound spell equipped in either hand matching the bound weapon which has just been removed
		if PlayerRef.GetEquippedItemType(1) == 9 && (PlayerRef.GetEquippedObject(1)).GetName() == weaponName
			hand = 1
		elseIf PlayerRef.GetEquippedItemType(0) == 9 && (PlayerRef.GetEquippedObject(0)).GetName() == weaponName
			hand = 0
		endIf
		if hand != -1
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
			;Switch back to the spell icon from the bound weapon icon without updating the name as it should be the same anyway
			if(iHandle)
				UICallback.PushInt(iHandle, hand) ;Target icon to update: left = 0, right  = 1
				UICallback.PushString(iHandle, "Conjuration") ;New icon label name
				UICallback.Send(iHandle)
			endIf
			if isAmmoMode
				toggleAmmoMode()
			endIf
		else
			debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped - couldn't match removed bound weapon to an equipped spell")
		endIf
	endIf
endFunction

bool boundAmmoAdded = false

function addBoundAmmoToQueue(form boundAmmo, string ammoName)
	debug.trace("iEquip_WidgetCore addBoundAmmoToQueue called - ammoName: " + ammoName)
	string ammoIcon = "BoundArrow"
	ammoQ = 5
	;Check if it's a Bound Crossbow rather than a Bow and change name and target queue if so
	if contains(currentlyEquipped[1], "ross") ;Saves having to check for both Cross and cross!
		ammoIcon = "BoundBolt"
		ammoQ = 6
	endIf
	int queueLength = jArray.count(targetQ[ammoQ])
	;If we've already added a dummy object to the ammo queue we only need to add the form
	int targetObject = jArray.getObj(targetQ[ammoQ], queueLength - 1)
	string lastAmmoInQueue = jMap.getStr(targetObject, "Name")
	debug.trace("iEquip_WidgetCore addBoundAmmoToQueue - lastAmmoInQueue: " + lastAmmoInQueue)
	if contains(lastAmmoInQueue, "Bound") || contains(lastAmmoInQueue, "bound")
		debug.trace("iEquip_WidgetCore addBoundAmmoToQueue - adding Form to dummy object")
		jMap.setForm(targetObject, "Form", boundAmmo)
	;Otherwise create a new jMap object for the ammo and add it to the relevant ammo queue
	else
		debug.trace("iEquip_WidgetCore addBoundAmmoToQueue - adding new bound ammo object")
		int boundAmmoObj = jMap.object()
		jMap.setForm(boundAmmoObj, "Form", boundAmmo)
		jMap.setStr(boundAmmoObj, "Icon", ammoIcon)
		jMap.setStr(boundAmmoObj, "Name", ammoName)
		;Set the current queue position and name to the last index (ie the newly added bound ammo)
		jArray.addObj(targetQ[ammoQ], boundAmmoObj)
		currentQueuePosition[ammoQ] = jArray.count(targetQ[ammoQ]) - 1 ;We've just added a new object to the queue so this is correct
		currentlyEquipped[ammoQ] = ammoName
		boundAmmoAdded = true
	endIf
endFunction

function checkAndRemoveBoundAmmo(int weaponType)
	debug.trace("iEquip_WidgetCore checkAndRemoveBoundAmmo called")
	ammoQ = 5
	if weaponType == 9
		ammoQ = 6
	endIf
	int targetArray = targetQ[ammoQ]
	int targetIndex = jArray.count(targetArray) - 1
	string lastAmmoInQueue = jMap.getStr(jArray.getObj(targetArray, targetIndex), "Name")
	if contains(lastAmmoInQueue, "ound")
		debug.trace("iEquip_WidgetCore checkAndRemoveBoundAmmo removing " + lastAmmoInQueue + "s from queue")
		jArray.eraseIndex(targetArray, targetIndex)
		int sorting = MCM.AmmoListSorting
		if sorting == 2 || sorting == 4
			selectLastUsedAmmo()
		else
			selectBestAmmo()
		endIf
	endIf
endFunction

function showName(int Q, bool fadeIn = true, bool targetingPoisonName = false, float fadeoutDuration = 0.3)
	debug.trace("iEquip_WidgetCore showName called, Q: " + Q + ", fadeIn: " + fadeIn + ", targetingPoisonName: " + targetingPoisonName + ", fadeoutDuration: " + fadeoutDuration) 

	float fNameAlpha
	if !fadeIn
		fNameAlpha = 0
		if targetingPoisonName
			isPoisonNameShown[Q] = false
		else
			isNameShown[Q] = false
		endIf
	else
		if targetingPoisonName
			fNameAlpha = afWidget_A[poisonNameElements[Q]]
		else
			fNameAlpha = afWidget_A[nameElements[Q]]
		endIf
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		if Q == 0 && leftIconFaded
			if targetingPoisonName
				fNameAlpha = afWidget_A[11] * (1 - (MCM.leftIconFadeAmount * 0.01))
			else
				fNameAlpha = afWidget_A[8] * (1 - (MCM.leftIconFadeAmount * 0.01))
			endIf
		endIf
		if targetingPoisonName
			isPoisonNameShown[Q] = true
		else
			isNameShown[Q] = true
		endIf
	endIf

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetNameAlpha")
	if(iHandle)
		if targetingPoisonName
			UICallback.PushInt(iHandle, poisonNameElements[Q]) ;Which _mc we're fading out
		else
			UICallback.PushInt(iHandle, nameElements[Q]) ;Which _mc we're fading out
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha) ;Target alpha which for FadeOut is 0
		UICallback.PushFloat(iHandle, fadeoutDuration) ;FadeOut duration
		UICallback.Send(iHandle)
	endIf

	if nameFadeoutEnabled
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
	debug.trace("iEquip_WidgetCore updateAttributeIcons called - Q: " + Q + ", iIndex: " + iIndex + ", isPreselectMode: " + isPreselectMode + ", isAmmoMode: " + isAmmoMode + ", overridePreselect: " + overridePreselect + ", cyclingLHPreselectInAmmoMode: " + cyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	if MCM.bShowAttributeIcons
		string sAttributes
		bool isPoisoned
		bool isEnchanted
		bool inAmmoMode = isAmmoMode
		bool inPreselectMode = isPreselectMode
		int targetObject = -1
		int Slot = Q
		if RefreshingWidgetOnLoad && Q > 4 && Q < 7
			if inPreselectMode
				;debug.trace("iEquip_WidgetCore updateAttributeIcons - 1st option")
				targetObject = jArray.getObj(targetQ[Q - 5], iIndex)
				;isPoisoned = jMap.getInt(targetObject, "isPoisoned") as bool
				;isEnchanted = jMap.getInt(targetObject, "isEnchanted") as bool
			;else
				;debug.trace("iEquip_WidgetCore updateAttributeIcons - 2nd option")
				;isPoisoned = false
				;isEnchanted = false
			endIf
		elseif (inPreselectMode && !overridePreselect && !preselectSwitchingHands && Q <= 2) || cyclingLHPreselectInAmmoMode
			;debug.trace("iEquip_WidgetCore updateAttributeIcons - 3rd option")
			Slot += 5
			targetObject = jArray.getObj(targetQ[Q], currentlyPreselected[Q])
			;isPoisoned = jMap.getInt(targetObject, "isPoisoned") as bool
			;isEnchanted = jMap.getInt(targetObject, "isEnchanted") as bool
			cyclingLHPreselectInAmmoMode = false
		;elseif Q == 0 && inAmmoMode
			;debug.trace("iEquip_WidgetCore updateAttributeIcons - 4th option")
			;isPoisoned = false
			;isEnchanted = false
		else
			if Q < 2
				;debug.trace("iEquip_WidgetCore updateAttributeIcons - 5th option")
				targetObject = jArray.getObj(targetQ[Q], iIndex)
				;isPoisoned = jMap.getInt(targetObject, "isPoisoned") as bool
				;isEnchanted = jMap.getInt(targetObject, "isEnchanted") as bool
			endIf
		endIf
		if targetObject == -1 || (Q == 0 && inAmmoMode)
			isPoisoned = false
			isEnchanted = false
		else
			isPoisoned = jMap.getInt(targetObject, "isPoisoned") as bool
			isEnchanted = jMap.getInt(targetObject, "isEnchanted") as bool
		endIf

		if (cycling && ((Slot == 0 && !inAmmoMode) || Slot == 1)) || (Slot == 5 || Slot == 6)
			if isPoisoned
				if isEnchanted
					sAttributes = "Both"
				else
					sAttributes = "Poisoned"
				endIf
			elseif isEnchanted
				sAttributes = "Enchanted"
			else
				sAttributes = "Hidden"
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
		cyclingLHPreselectInAmmoMode = false
	endIf
endFunction

function hideAttributeIcons(int Q)
	debug.trace("iEquip_WidgetCore hideAttributeIcons called - Q: "+ Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) ;Which slot we're updating
		UICallback.PushString(iHandle, "Hidden") ;New attributes
		UICallback.Send(iHandle)
	endif
endFunction

int function findInQueue(int Q, string itemToFind)
	debug.trace("iEquip_WidgetCore findInQueue called")
	int iIndex = 0
	bool found = false
	while iIndex < jArray.count(targetQ[Q]) && !found
		if itemToFind != jMap.getStr(jArray.getObj(targetQ[Q], iIndex), "Name")
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

function removeItemFromQueue(int Q, int iIndex, bool purging = false, bool cyclingAmmo = false)
	debug.trace("iEquip_WidgetCore removeItemFromQueue called")
	if MCM.bEnableRemovedItemCaching && !purging
		AddItemToLastRemovedCache(Q, iIndex)
	endIf
	jArray.eraseIndex(targetQ[Q], iIndex)
	if currentQueuePosition[Q] > iIndex ;if the item being removed is before the currently equipped item in the queue update the index for the currently equipped item
		currentQueuePosition[Q] = currentQueuePosition[Q] - 1
	elseif currentQueuePosition[Q] == iIndex ;if you have removed the currently equipped item then if it was the last in the queue advance to index 0 and cycle the slot
		if currentQueuePosition[Q] == jArray.count(targetQ[Q])
			currentQueuePosition[Q] = 0
		endIf
		if !cyclingAmmo
			cycleSlot(Q, false)
		endIf
	endIf
endFunction

function AddItemToLastRemovedCache(int Q, int iIndex)
	debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache called")
	if jArray.count(objLastRemovedCache) == MCM.maxCachedItems ;Max number of removed items to cache for re-adding
		jArray.eraseIndex(objLastRemovedCache, 0)
	endIf
	int objToCache = jArray.getObj(targetQ[Q], iIndex)
	jMap.setInt(objToCache, "PrevQ", Q)
	jArray.addObj(objLastRemovedCache, objToCache)
endFunction

bool function playerStillHasItem(form itemForm)
	debug.trace("iEquip_WidgetCore playerStillHasItem called - itemForm: " + itemForm)
    int itemType = itemForm.GetType()
    int itemCount
    ; This is a Spell or Shout and can't be counted like an item
    if (itemType == 22 || itemType == 119)
    	debug.trace("iEquip_WidgetCore playerStillHasItem returning " + PlayerRef.HasSpell(itemForm))
        return PlayerRef.HasSpell(itemForm)
    ; This is an inventory item
    else 
        itemCount = PlayerRef.GetItemCount(itemForm)
        if (itemCount < 1)
        	debug.trace("iEquip_WidgetCore playerStillHasItem returning false as itemCount = " + itemCount)
            return false
        endIf
    endIf
    debug.trace("iEquip_WidgetCore playerStillHasItem returning true")
    return true
endFunction

bool switchingHands = false
bool preselectSwitchingHands = false
bool skipOtherHandCheck = false
bool goneUnarmed = false

function cycleHand(int Q, int targetIndex, form targetItem, int itemType = -1)
    ;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
    debug.trace("iEquip_WidgetCore cycleHand called - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", itemType: " + itemType)
   	int iEquipSlotId = 1
    int otherHand = 0
    bool justSwitchedHands = false
    bool previously2H = false
    blockSwitchBackToBoundSpell = true
    int targetObject = jArray.getObj(targetQ[Q], targetIndex)
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
	debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", iEquipSlotId = " + iEquipSlotId + ", otherHand = " + otherHand + ", switchingHands = " + switchingHands + ", goneUnarmed = " + goneUnarmed)
	;if we're switching hands we can reset to false now, and we don't need to unequip here because we already did so when we started switching hands
	if switchingHands
		switchingHands = false
		justSwitchedHands = true
	elseif !goneUnarmed
		;Otherwise unequip current item
		UnequipHand(Q)
	endIf
	;if we're switching the left hand and it is going to cause a 2h or ranged weapon to be unequipped from the right hand then we need to ensure a suitable 1h item is equipped in its place
    if (Q == 0 && RightHandWeaponIs2hOrRanged()) || (goneUnarmed && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9))
    	switchingHands = true
    	debug.trace("iEquip_WidgetCore cycleHand - Q == 0 && RightHandWeaponIs2hOrRanged: " + RightHandWeaponIs2hOrRanged() + ", goneUnarmed: " + goneUnarmed + ", itemType: " + itemType + ", switchingHands: " + switchingHands)
    	if !goneUnarmed
    		UnequipHand(otherHand)
    	endIf
    endif
    ;if we are re-equipping from an unarmed state
    if goneUnarmed
		goneUnarmed = false
	endIf
	;if target item is a spell equip straight away
	if itemType == 22
		PlayerRef.EquipSpell(targetItem as Spell, Q)
		if MCM.bProModeEnabled && MCM.bQuickDualCastEnabled && !justSwitchedHands && !isPreselectMode
			string spellSchool = jMap.getStr(jArray.getObj(targetQ[Q], targetIndex), "Icon")
			string spellName = targetItem.GetName()
			if (spellSchool == "Destruction" && MCM.bQuickDualCastDestruction) || (spellSchool == "Alteration" && MCM.bQuickDualCastAlteration) || (spellSchool == "Illusion" && MCM.bQuickDualCastIllusion) || (spellSchool == "Restoration" && MCM.bQuickDualCastRestoration) || (spellSchool == "Conjuration" && !(spellName == "Bound Bow" || spellName == "Bound Crossbow") && MCM.bQuickDualCastConjuration) ;Add check for dual cast modifications if possible
				debug.trace("iEquip_WidgetCore cycleHand - about to QuickDualCast")
				if quickDualCastEquipSpellInOtherHand(Q, targetItem, jMap.getStr(targetObject, "Name"), spellSchool)
					switchingHands = false ;Just in case equipping the original spell triggered switchingHands then as long as we have successfully dual equipped the spell we can cancel switchingHands now
				endIf
			endIf
		endIf
	else
		;if item is anything other than a spell check if it is already equipped, possibly in the other hand, and there is only 1 of it
		int itemCount = PlayerRef.GetItemCount(targetItem)
	    if (targetItem == PlayerRef.GetEquippedObject(otherHand)) && itemCount < 2
	    	debug.trace("iEquip_WidgetCore cycleHand - targetItem found in other hand and only one of them")
	    	;if it is already equipped and player has allowed switching hands then unequip the other hand first before equipping the target item in this hand
	        if MCM.bAllowWeaponSwitchHands
	        	switchingHands = true
	        	debug.trace("iEquip_WidgetCore cycleHand - switchingHands: " + switchingHands)
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
	    	if itemID && itemID > 0
	    		;EquipItemById(Form item, int itemId, int iEquipSlot, bool preventUnequip, bool equipSound)
	    		PlayerRef.EquipItemByID(targetItem, itemID, iEquipSlotID)
	    	else
	    		PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
	    	endIf
	    endIf
	endIf
	Utility.Wait(0.2)
	checkAndUpdatePoisonInfo(Q)
	checkIfBoundSpellEquipped()
	if (itemType == 7 || itemType == 9) && AmmoModeFirstLook
		Utility.Wait(0.5)
		Debug.MessageBox("iEQUIP Ammo Mode\n\nYou have equipped a ranged weapon for the first time using iEquip and you will see that the left hand widget is now showing the first ammo in your ammo queue. if you have enabled ammo sorting in the MCM then this will either be the ammo with the highest base damage, or the first alphabetically\nThe smaller icon shows the item you will re-equip when you unequip your ranged weapon.")
		Debug.MessageBox("iEQUIP Ammo Mode Controls\n\nSingle press left hotkey cycles the ammo\n\nDouble press left hotkey cycles the left hand item shown in the smaller icon ready for re-equipping\n\nCycling your right hand will return the left hand widget to the regular state, or you can longpress the left hotkey to re-equip the left hand item shown and swap your ranged weapon for a 1H item in the right hand")
		AmmoModeFirstLook = false
	endIf
	;if we've just equipped a 1H item in RH forcing toggleAmmoMode, now we can re-equip the left hand making sure to block QuickDualCast
	if Q == 1 && (justLeftAmmoMode || previously2H) && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9)
		targetObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
		int leftType = jMap.getInt(targetObject, "Type")
		blockQuickDualCast = (leftType == 22)
		debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", justLeftAmmoMode: " + justLeftAmmoMode + ", about to equip left hand item of type: " + leftType + ", blockQuickDualCast: " + blockQuickDualCast)
		cycleHand(0, currentQueuePosition[0], jMap.getForm(targetObject, "Form"))
    ;if we unequipped the other hand now equip the next item
    elseif switchingHands
    	debug.trace("iEquip_WidgetCore cycleHand - switchingHands = " + switchingHands + ", calling cycleSlot(" + otherHand + ", false)")
    	Utility.Wait(0.1)
		cycleSlot(otherHand, false)
	endIf
	if MCM.bEnableGearedUp
		refreshGearedUp()
	endIf
	debug.trace("iEquip_WidgetCore cycleHand finished")
endFunction

bool function RightHandWeaponIs2hOrRanged(int itemType = -1)
	if itemType == -1
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
	if itemType == -1
		itemType = PlayerRef.GetEquippedItemType(1)
	endIf
	debug.trace("iEquip_WidgetCore RightHandWeaponIsRanged - itemType: " + itemType)
	return (itemType == 7 || itemType == 12) ;GetEquippedItemType returns 12 rather than 9 for Crossbow
endFunction

function quickShield()
	debug.trace("iEquip_WidgetCore quickShield called")
	;if right hand or ranged weapon in right hand and MCM.QuickShield2HSwitchAllowed not enabled then return out
	bool inPreselectMode = isPreselectMode
	if (RightHandWeaponIs2hOrRanged() && !MCM.bQuickShield2HSwitchAllowed) || (inPreselectMode && MCM.preselectQuickShield == 0)
		return
	endIf
	int i = 0
	int targetArray = targetQ[0]
	int leftCount = jArray.count(targetArray)
	int found = -1
	int foundType
	int targetObject
	string spellName
	bool rightHandHasSpell = ((PlayerRef.GetEquippedItemType(1) == 9) && !(jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type") == 42))
	debug.trace("iEquip_WidgetCore quickShield() - RH current item: " + currentlyEquipped[1] + ", RH item type: " + (PlayerRef.GetEquippedItemType(1)))
	bool preferMagic = MCM.bQuickShieldPreferMagic
	;if player currently has a spell equipped in the right hand or we've enabled Prefer Magic in the MCM search for a ward spell first
	if rightHandHasSpell || preferMagic
		while i < leftCount && found == -1
			spellName = jMap.getStr(jArray.getObj(targetArray, i), "Name")
			if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 22 && (contains(spellName, " Ward") || contains(spellName, " ward"))
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
				if jMap.getInt(jArray.getObj(targetArray, i), "Type") == 22 && (contains(spellName, " Ward") || contains(spellName, " ward"))
					found = i
					foundType = 22
				endIf
				i += 1
			endwhile
		endIf
	endIf
	if found != -1
		if !inPreselectMode || MCM.preselectQuickShield == 2
			;if we're in ammo mode we need to toggle out without equipping or animating
			if isAmmoMode
				toggleAmmoMode(true, true)
				;And if we're not in Preselect Mode we need to hide the left preselect elements
				if !inPreselectMode
					bool[] args = new bool[3]
					args[0] = false
					args[1] = false
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
				endIf
				ammo targetAmmo = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form") as Ammo
				if MCM.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
					PlayerRef.UnequipItemEx(targetAmmo)
				endIf
			endIf
			currentQueuePosition[0] = found
			currentlyEquipped[0] = jMap.getStr(jArray.getObj(targetArray, found), "Name")
			if inPreselectMode
				updateWidget(0, found, true)
				;if for some reason the found shield/ward being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				if currentlyPreselected[0] == found
					cyclePreselectSlot(0, leftCount, false)
				endIf
			else
				updateWidget(0, found)
			endIf
			if leftIconFaded
				Utility.Wait(0.3)
				checkAndFadeLeftIcon(0, foundType)
			endIf
			bool switchRightHand = false
			if RightHandWeaponIs2hOrRanged() || (foundType == 22 && preferMagic && !rightHandHasSpell) || goneUnarmed
				switchRightHand = true
				if !goneUnarmed
					UnequipHand(1)
				endIf
			endIf	
			UnequipHand(0)
			form targetForm = jMap.getForm(jArray.getObj(targetArray, found), "Form")
			if foundType == 22
				PlayerRef.EquipSpell(targetForm as Spell, 0)
			elseif foundType == 26
				PlayerRef.EquipItemEx(targetForm as Armor)
			endIf
			if isCounterShown(0)
				setCounterVisibility(0, false)
			endIf
			hidePoisonInfo(0)
			if switchRightHand
				quickShieldSwitchRightHand(inPreselectMode, foundType, preferMagic, rightHandHasSpell)
			endIf
			checkIfBoundSpellEquipped()
			if MCM.bEnableGearedUp
				refreshGearedUp()
			endIf
		else
			currentlyPreselected[0] = found
			updateWidget(0, found)
		endIf
	else
		debug.notification("iEquip QuickShield did not find a shield or ward in your left hand queue")
	endIf
endFunction

function quickShieldSwitchRightHand(bool inPreselectMode, int foundType, bool preferMagic, bool rightHandHasSpell)
	debug.trace("iEquip_WidgetCore QuickShieldSwitchRightHand called - foundType: " + foundType + ", preferMagic: " + preferMagic + ", rightHandHasSpell: " + rightHandHasSpell)
	int i = 0
	int targetArray = targetQ[1]
	int rightCount = jArray.count(targetArray)
	int found = -1
	int targetObject
	int itemType
	string itemName
	if foundType == 22 && preferMagic && !rightHandHasSpell
		string preferredSchool = MCM.quickShieldPreferredMagicSchool
		;if we've selected a preferred magic school look for that type of spell first
		if preferredSchool != "" && preferredSchool != "Destruction"
			while i < rightCount && found == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == preferredSchool
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
					if !(contains(itemName, "renade") || contains(itemName, "lask") || contains(itemName, "Pot") || contains(itemName, "pot") || contains(itemName, "omb"))
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
				if !(contains(itemName, "renade") || contains(itemName, "lask") || contains(itemName, "Pot") || contains(itemName, "pot") || contains(itemName, "omb"))
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
		if !inPreselectMode || MCM.preselectQuickShield == 2
			blockSwitchBackToBoundSpell = true
			targetObject = jArray.getObj(targetQ[1], found)
			currentQueuePosition[1] = found
			currentlyEquipped[1] = jMap.getStr(targetObject, "Name")
			if inPreselectMode
				updateWidget(1, found, true)
				;if for some reason the found item being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
				if currentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
			else
				updateWidget(1, found)
			endIf
			checkAndUpdatePoisonInfo(1)
			itemType = jMap.getInt(targetObject, "Type")
			form formToEquip = jMap.getForm(jArray.getObj(targetQ[1], found), "Form")
			if itemType == 22
				PlayerRef.EquipSpell(formToEquip as Spell, 1)
			else
				PlayerRef.EquipItemEx(formToEquip, 1)
			endIf
		;if in Preselect Mode then update the right hand preselect slot
		else
			currentlyPreselected[1] = found
			updateWidget(6, found)
		endIf
		if goneUnarmed
			goneUnarmed = false
		endIf
	endIf
endFunction

function quickRanged()
	debug.trace("iEquip_WidgetCore quickRanged called")
	;if you already have a ranged weapon equipped or if you're in Preselect Mode and have disabled quickRanged in Preselect Mode then do nothing
	if currentlyQuickRanged
		quickRangedSwitchOut()
	else
		bool inPreselectMode = isPreselectMode
		if !(isAmmoMode || (inPreselectMode && MCM.preselectQuickRanged == 0))
			bool preferMagic = (MCM.quickRangedPreferredWeaponType > 1)
			bool actionTaken = false
			if preferMagic
				actionTaken = quickRangedFindAndEquipSpell(inPreselectMode)
			else
				actionTaken = quickRangedFindAndEquipWeapon(inPreselectMode)
			endIf
			if !actionTaken
				if preferMagic
					actionTaken = quickRangedFindAndEquipWeapon(inPreselectMode)
				else
					actionTaken = quickRangedFindAndEquipSpell(inPreselectMode)
				endIf
			endIf
			if !actionTaken
				debug.notification("iEquip couldn't find a ranged weapon or bound spell to equip")
			endIf
		endIf
	endIf
endFunction

bool function quickRangedFindAndEquipWeapon(bool inPreselectMode)
	debug.trace("iEquip_WidgetCore quickRangedFindAndEquipWeapon called")

	bool actionTaken = false
	int preferredWeaponType = MCM.quickRangedPreferredWeaponType
	int preferredType = 7 ;Bow
	int secondChoice = 9 ;Crossbow
	if preferredWeaponType == 1 || preferredWeaponType == 3
		preferredType = 9
		secondChoice = 7
	endIf
	int i = 0
	int targetArray = targetQ[1]
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
		if !inPreselectMode || MCM.preselectQuickRanged == 2
			;Store current right hand index before switching in case user calls quickRangedSwitchOut() - we don't need left index as toggling out of ammo mode by switching right will take care of that.
			previousRightHandIndex = currentQueuePosition[1]
			bool foundWeaponIsPoisoned = isWeaponPoisoned(1, found, true)
			if poisonInfoDisplayed[1] && !foundWeaponIsPoisoned
				hidePoisonInfo(1)
				if isCounterShown(1)
					setCounterVisibility(1, false)
				endIf
			endIf
			if leftIconFaded
				checkAndFadeLeftIcon(1, 7)
				Utility.Wait(0.3)
			endIf
			currentQueuePosition[1] = found
			targetObject = jArray.getObj(targetQ[1], found)
			currentlyEquipped[1] = jMap.getStr(targetObject, "Name")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			updateWidget(1, found, true)
			;if for some reason the found weapon being QuickEquipped is also the currently preselected item then advance the preselect queue by 1 as well
			if inPreselectMode
				;if we're in Preselect Mode we need to toggle Ammo Mode here without the animation so it updates the left slot to show ammo
				toggleAmmoMode(true, false)
				PlayerRef.EquipItemEx(jMap.getForm(targetObject, "Form"), 1, false, false)
				;if the ranged weapon we're about to equip matches the right preselected item then cycle the preselect slot
				if currentlyPreselected[1] == found
					cyclePreselectSlot(1, rightCount, false)
				endIf
				if foundWeaponIsPoisoned
					checkAndUpdatePoisonInfo(1)
				elseif isCounterShown(1)
					setCounterVisibility(1, false)
				endIf
				if MCM.bEnableGearedUp
					refreshGearedUp()
				endIf
			;if we're not in Preselect Mode we can now equip as normal which will toggle Ammo Mode
			else
				checkAndEquipShownHandItem(1, false)
			endIf
			currentlyQuickRanged = true
		;Otherwise update the Preselect Mode preselect slot
		else
			currentlyPreselected[1] = found
			updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	return actionTaken
endFunction

bool function quickRangedFindAndEquipSpell(bool inPreselectMode)
	debug.trace("iEquip_WidgetCore quickRangedFindAndEquipWeapon called")

	bool actionTaken = false
	int preferredWeaponType = MCM.quickRangedPreferredWeaponType
	string preferredType = "Bound Bow"
	string secondChoice = "Bound Crossbow"
	if preferredWeaponType == 3 || preferredWeaponType == 1
		preferredType = "Bound Crossbow"
		secondChoice = "Bound Bow"
	endIf
	int i = 0
	int targetArray = targetQ[1]
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
		if !inPreselectMode || MCM.preselectQuickRanged == 2
			;Store current right hand index before switching in case user calls quickRangedSwitchOut() - we don't need left index as toggling out of ammo mode by switching right will take care of that.
			previousRightHandIndex = currentQueuePosition[1]
			if poisonInfoDisplayed[1]
				hidePoisonInfo(1)
			endIf
			if isCounterShown(1)
				setCounterVisibility(1, false)
			endIf
			if leftIconFaded
				checkAndFadeLeftIcon(1, 22)
			endIf
			currentQueuePosition[1] = found
			currentlyEquipped[1] = jMap.getStr(jArray.getObj(targetArray, found), "Name")
			;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
			updateWidget(1, found, true)
			;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
			if inPreselectMode && (currentlyPreselected[1] == found)
				cyclePreselectSlot(1, rightCount, false)
			endIf
			checkAndEquipShownHandItem(1, false)
			currentlyQuickRanged = true
		;Otherwise update the Preselect Mode preselect slot
		else
			currentlyPreselected[1] = found
			updateWidget(1, found)
		endIf
		actionTaken = true
	endIf
	return actionTaken
endFunction

function quickRangedSwitchOut()
	debug.trace("iEquip_WidgetCore quickRangedSwitchOut called")
	currentlyQuickRanged = false
	int iAction = MCM.quickRangedSwitchOutAction
	debug.trace("iEquip_WidgetCore quickRangedSwitchOut called - iAction: " + iAction)
	int targetIndex = -1
	int targetArray = targetQ[1]
	int targetObject
	int rightCount = jArray.count(targetArray)
	int i = 0
	if iAction == 1 ;Switch Back
		targetIndex = previousRightHandIndex
		debug.trace("iEquip_WidgetCore quickRangedSwitchOut doing iAction: 1, targetIndex: " + targetIndex)
	elseif iAction == 2 || iAction == 3 ;Two Handed or One Handed
		int[] preferredType
		int[] secondChoice
		if iAction == 2
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
		debug.trace("iEquip_WidgetCore quickRangedSwitchOut doing iAction = 2 or 3, targetIndex: " + targetIndex)
	elseif iAction == 4 ;Spell
		string preferredSchool = MCM.quickRangedPreferredMagicSchool
		;if we've selected a preferred magic school look for that type of spell first
		if preferredSchool != "" && preferredSchool != "Destruction"
			while i < rightCount && targetIndex == -1
				targetObject = jArray.getObj(targetArray, i)
				if jMap.getInt(targetObject, "Type") == 22 && jMap.getStr(targetObject, "Icon") == preferredSchool
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
		debug.trace("iEquip_WidgetCore quickRangedSwitchOut doing iAction: 4, targetIndex: " + targetIndex)
	else
		return
	endIf
	debug.trace("iEquip_WidgetCore quickRangedSwitchOut - final targetIndex: " + targetIndex)
	targetObject = jArray.getObj(targetArray, targetIndex)
	currentQueuePosition[1] = targetIndex
	currentlyEquipped[1] = jMap.getStr(targetObject, "Name")
	updateWidget(1, targetIndex, true)
	if isPreselectMode
		blockSwitchBackToBoundSpell = true
		toggleAmmoMode(true, false)
		form formToEquip = jMap.getForm(targetObject, "Form")
		PlayerRef.EquipItemEx(formToEquip, 1, false, false)
		checkAndUpdatePoisonInfo(1)
		if currentlyPreselected[1] == targetIndex
			cyclePreselectSlot(1, jArray.count(targetArray), false)
		endIf
		if !RightHandWeaponIs2hOrRanged(jMap.getInt(targetObject, "Type"))
			targetArray = targetQ[0]
			PlayerRef.EquipItemEx(jMap.getForm(jArray.getObj(targetArray, currentQueuePosition[0]), "Form"), 2, false, false)
			checkAndUpdatePoisonInfo(0)
			if currentlyPreselected[0] == currentQueuePosition[0]
				cyclePreselectSlot(0, jArray.count(targetArray), false)
			endIf
		endIf
	else
		checkAndEquipShownHandItem(1, false)
	endIf
endFunction

bool function quickDualCastEquipSpellInOtherHand(int Q, form spellToEquip, string spellName, string spellIcon)
	debug.trace("iEquip_WidgetCore quickDualCastEquipSpellInOtherHand called - blockQuickDualCast: " + blockQuickDualCast)
	if blockQuickDualCast
		blockQuickDualCast = false
		return false
	else
		int otherHand = 0
		if Q == 0
			otherHand = 1
		endIf
		int otherHandIndex = -1
		bool dualCastAllowed = true
		if MCM.bQuickDualCastMustBeInBothQueues
			otherHandIndex = findInQueue(otherHand, spellName)
			dualCastAllowed = (otherHandIndex > -1)
		endIf
		if dualCastAllowed
			blockSwitchBackToBoundSpell = true
			PlayerRef.EquipSpell(spellToEquip as Spell, otherHand)
			Float fNameAlpha = afWidget_A[nameElements[otherHand]]
			if fNameAlpha < 1
				fNameAlpha = 100
			endIf
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
			if(iHandle)
				UICallback.PushInt(iHandle, otherHand)
				UICallback.PushString(iHandle, spellIcon)
				UICallback.PushString(iHandle, spellName)
				UICallback.PushFloat(iHandle, fNameAlpha)
				while waitingForAmmoModeAnimation
					Utility.Wait(0.005)
				endwhile
				UICallback.Send(iHandle)
			endIf
			checkAndUpdatePoisonInfo(otherHand)
			if nameFadeoutEnabled && !isNameShown[otherHand]
				showName(otherHand)
			endIf
			if isCounterShown(otherHand)
				setCounterVisibility(otherHand, false)
			endIf
			if otherHandIndex > -1
				currentQueuePosition[otherHand] = otherHandIndex
				currentlyEquipped[otherHand] = spellName
			endIf
			return true
		else
			return false
		endIf
	endIf
endFunction

function quickHeal()
	debug.trace("iEquip_WidgetCore quickHeal called")
	if currentlyQuickHealing
		quickHealSwitchBack()
	else
		bool actionTaken = false
		if MCM.bQuickHealPreferMagic
			actionTaken = quickHealFindAndEquipSpell()
		else
			actionTaken = PO.quickHealFindAndConsumePotion()
		endIf
		if !actionTaken
			if MCM.bQuickHealPreferMagic
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
	debug.trace("iEquip_WidgetCore quickHealFindAndEquipSpell called")
	bool actionTaken = false
	int i = 0
	int Q = 0
	int count
	int targetIndex = -1
	int containingQ
	string spellName
	int targetArray = targetQ[Q]
	int targetObject
	while Q < 2 && targetIndex == -1
		count = jArray.count(targetArray)
		while i < count && targetIndex == -1
			targetObject = jArray.getObj(targetArray, i)
			if jMap.getInt(targetObject, "Type") == 22
				spellName = jMap.getStr(targetObject, "Name")
				if contains(spellName, "Heal") || contains(spellName, "heal")
					targetIndex = i
					containingQ = Q
				endIf
			endIf
			i += 1
		endwhile
		i = 0
		Q += 1
	endWhile
	debug.trace("iEquip_WidgetCore quickHealFindAndEquipSpell - spell found at targetIndex: " + targetIndex + " in containingQ: " + containingQ + ", quickHealEquipChoice: " + MCM.quickHealEquipChoice)
	if targetIndex != -1
		int iEquipSlot = MCM.quickHealEquipChoice
		bool equippingOtherHand = false
		if iEquipSlot < 2 && iEquipSlot != containingQ
			equippingOtherHand = true
		elseIf iEquipSlot == 3 ;Equip spell where it is found
			iEquipSlot = containingQ
		endIf
		debug.trace("iEquip_WidgetCore quickHealFindAndEquipSpell - iEquipSlot: " + iEquipSlot + ", bQuickHealSwitchBackEnabled: " + MCM.bQuickHealSwitchBackEnabled)
		if MCM.bQuickHealSwitchBackEnabled
			previousLeftHandIndex = currentQueuePosition[0]
			previousRightHandIndex = currentQueuePosition[1]
			currentlyQuickHealing = true
		endIf
		quickHealSlotsEquipped = iEquipSlot
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
	debug.trace("iEquip_WidgetCore quickHealEquipSpell called - equipping healing spell to iEquipSlot: " + iEquipSlot + ", spell found in Q " + Q + " at index " + iIndex)
	if poisonInfoDisplayed[iEquipSlot]
		hidePoisonInfo(iEquipSlot)
	endIf
	if isCounterShown(iEquipSlot)
		setCounterVisibility(iEquipSlot, false)
	endIf
	if leftIconFaded
		checkAndFadeLeftIcon(1, 22)
	endIf
	int spellObject = jArray.getObj(targetQ[Q], iIndex)
	string spellName = jMap.getStr(spellObject, "Name")
	if !dualCasting && !equippingOtherHand
		currentQueuePosition[iEquipSlot] = iIndex
		currentlyEquipped[iEquipSlot] = spellName
		;Update the main right hand widget, if in Preselect Mode skipping the Preselect Mode check so we don't update the preselect slot
		updateWidget(iEquipSlot, iIndex, true)
		;If we're in Preselect Mode and the spell we're about to equip matches the right preselected item then cycle the preselect slot
		if isPreselectMode && (currentlyPreselected[iEquipSlot] == iIndex)
			cyclePreselectSlot(iEquipSlot, jArray.count(targetQ[iEquipSlot]), false)
		endIf
		checkAndEquipShownHandItem(iEquipSlot, false)
		currentlyQuickHealing = true
	else
		blockSwitchBackToBoundSpell = true
		int foundIndex = findInQueue(iEquipSlot, spellName)
		PlayerRef.EquipSpell(jMap.getForm(spellObject, "Form") as Spell, iEquipSlot)
		Float fNameAlpha = afWidget_A[nameElements[iEquipSlot]]
		if fNameAlpha < 1
			fNameAlpha = 100
		endIf
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		if(iHandle)
			UICallback.PushInt(iHandle, iEquipSlot)
			UICallback.PushString(iHandle, jMap.getStr(spellObject, "Icon"))
			UICallback.PushString(iHandle, spellName)
			UICallback.PushFloat(iHandle, fNameAlpha)
			while waitingForAmmoModeAnimation
				Utility.Wait(0.005)
			endwhile
			UICallback.Send(iHandle)
		endIf
		if nameFadeoutEnabled && !isNameShown[iEquipSlot]
			showName(iEquipSlot)
		endIf
		if foundIndex > -1
			currentQueuePosition[iEquipSlot] = foundIndex
			currentlyEquipped[iEquipSlot] = spellName
		endIf
	endIf
endFunction

function quickHealSwitchBack()
	debug.trace("iEquip_WidgetCore quickHealSwitchBack called")
	currentlyQuickHealing = false
	int iEquipSlot = MCM.quickHealEquipChoice
	currentQueuePosition[0] = previousLeftHandIndex
	currentQueuePosition[1] = previousRightHandIndex
	int Q = quickHealSlotsEquipped
	if Q < 2
		updateWidget(Q, currentQueuePosition[Q], true) ;True overrides PreselectMode to make sure we're updating the main slot if we're in Preselect
		checkAndEquipShownHandItem(Q)
	elseIf Q == 2
		updateWidget(0, currentQueuePosition[0], true)
		int rightHandItemType = jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type")
		if rightHandItemType != 5 && rightHandItemType != 6 && rightHandItemType != 7 && rightHandItemType != 9
			checkAndEquipShownHandItem(0)
		endIf
		updateWidget(1, currentQueuePosition[1], true)
		checkAndEquipShownHandItem(1)
	else
		debug.trace("iEquip_WidgetCore quickHealSwitchBack - Something went wrong!")
	endIf
	quickHealSlotsEquipped = -1 ;Reset
endFunction

function goUnarmed()
	debug.trace("iEquip_WidgetCore goUnarmed called")
	blockSwitchBackToBoundSpell = true
	UnequipHand(1)
	Utility.Wait(0.1)
	UnequipHand(0)
	;And now we need to update the left hand widget
	Float fNameAlpha = afWidget_A[nameElements[0]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushString(iHandle, "Fist")
		UICallback.PushString(iHandle, "Fists")
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.Send(iHandle)
	endIf
	if nameFadeoutEnabled
		LNUpdate.registerForNameFadeoutUpdate()
	endIf
	debug.trace("iEquip_WidgetCore goUnarmed - isAmmoMode: " + isAmmoMode + ", isPreselectMode: " + isPreselectMode)
	if isAmmoMode && !isPreselectMode
		toggleAmmoMode(true, true)
		bool[] args = new bool[3]
		args[0] = false
		args[1] = false
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		currentQueuePosition[0] = currentlyPreselected[0]
		currentlyEquipped[0] = jMap.getStr(jArray.getObj(targetQ[0], currentQueuePosition[0]), "Name")
	endIf
	goneUnarmed = true
	int i = 0
	while i < 2
		hideAttributeIcons(i)
		if isCounterShown(i)
			setCounterVisibility(i, false)
		endIf
		if poisonInfoDisplayed[i]
			hidePoisonInfo(i)
		endIf
		i += 1
	endwhile
	ammo targetAmmo = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form") as Ammo
	if MCM.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
	if MCM.bEnableGearedUp
		refreshGearedUp()
	endIf
endFunction

function cycleShout(int Q, int targetIndex, form targetItem)
    debug.trace("iEquip_WidgetCore cycleShout called")
    int itemType = jMap.getInt(jArray.getObj(targetQ[Q], targetIndex), "Type")
    if itemType == 22
        PlayerRef.EquipSpell(targetItem as Spell, 2)
    else
        PlayerRef.EquipShout(targetItem as Shout)
    endIf
endFunction

function cycleConsumable(form targetItem, int targetIndex)
    int potionGroupIndex = isPotionGroup(targetIndex)
    debug.trace("iEquip_WidgetCore cycleConsumable called - potionGroupIndex: " + potionGroupIndex + ", consumableIconFaded: " + consumableIconFaded)
    int count
    if potionGroupIndex != -1
    	count = PO.getPotionGroupCount(potionGroupIndex)
    elseIf(targetItem)
        count = PlayerRef.GetItemCount(targetItem)
    endIf
    setSlotCount(3, count)
    If consumableIconFaded
    	Utility.Wait(0.3)
    	checkAndFadeConsumableIcon(false)
    endIf
    if potionGroupIndex != -1 && potionGroupEmpty[potionGroupIndex]
    	debug.trace("iEquip_WidgetCore cycleConsumable - potionGroup is empty, flash potion warning: " + MCM.bFlashPotionWarning)
    	if MCM.bFlashPotionWarning
            UI.InvokeInt(HUD_MENU, WidgetRoot + ".runPotionFlashAnimation", potionGroupIndex)
            Utility.Wait(1.4)
        endIf
    	checkAndFadeConsumableIcon(true)
   	endIf
endFunction

int function isPotionGroup(int targetIndex)
	string targetName = jMap.getStr(jArray.getObj(targetQ[3], targetIndex), "Name")
	return potionGroups.find(targetName)
endFunction

function cyclePoison(form targetItem)
   	debug.trace("iEquip_WidgetCore cyclePoison called")
    if(targetItem)
        setSlotCount(4, PlayerRef.GetItemCount(targetItem as Potion))
        setCounterVisibility(4, true)
    endIf
endFunction

;Uses the equipped item / potion in the consumable slot
function consumeItem()
    debug.trace("iEquip_WidgetCore consumeItem called")
    int potionGroupIndex = isPotionGroup(currentQueuePosition[3])
    if potionGroupIndex != -1
    	PO.selectAndConsumePotion(potionGroupIndex)
    	setSlotCount(3, PO.getPotionGroupCount(potionGroupIndex))
    else
	    form itemForm = jMap.getForm(jArray.getObj(targetQ[3], currentQueuePosition[3]), "Form")
	    if(itemForm != None)
	    	PlayerRef.EquipItemEx(itemForm)
	    	int count = PlayerRef.GetItemCount(itemForm)
	    	if count < 1
	    		removeItemFromQueue(3, currentQueuePosition[3])
	    	else
	    		setSlotCount(3, count)
	    	endIf
	    endIf
	endIf
endFunction

Perk Property ConcentratedPoison  Auto
Sound Property RemovePoison Auto


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
	int targetObject = jArray.getObj(targetQ[4], currentQueuePosition[4])
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
	elseif currentWeapon != jMap.getForm(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "Form") as Weapon
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
			if !MCM.bAllowPoisonSwitching
				debug.notification("Your " + weaponName + " is already poisoned with " + currentPoisonName)
				return
			else
				if MCM.showPoisonMessages < 2
					messagestring = "Your " + weaponName + " is already poisoned with " + currentPoisonName + ". Would you like to clean it and apply " + newPoison + " instead?"
					iButton = showMessageWithCancel(messageString)
					if iButton != 0
						return
					endIf
				endIf
				_Q2C_Functions.WornRemovePoison(PlayerRef, Q)
				;RemovePoison.Play(PlayerRef)
				;Utility.Wait(0.8)
			endIf	
		elseif MCM.showPoisonMessages < 2
			messagestring = "Your " + weaponName + " is already poisoned with " + currentPoisonName + ". Would you like to add more poison?"
			iButton = showMessageWithCancel(messageString)
			if iButton != 0
				return
			endIf
		endIf
	elseif MCM.showPoisonMessages == 0
		messagestring = "Would you like to apply " + newPoison + " to your " + weaponName + "?"
		iButton = showMessageWithCancel(messageString)
		if iButton != 0
			return
		endIf
	endIf
	
	int ConcentratedPoisonMultiplier = MCM.poisonChargeMultiplier
	if ConcentratedPoisonMultiplier == 1 && PlayerRef.HasPerk(ConcentratedPoison)
		ConcentratedPoisonMultiplier = 2
	endIf
	int chargesToApply
	if contains(newPoison, "Wax") || contains(newPoison, "wax") || contains(newPoison, "Oil") || contains(newPoison, "oil")
		chargesToApply = 10 * ConcentratedPoisonMultiplier
	else
		chargesToApply = MCM.poisonChargesPerVial * ConcentratedPoisonMultiplier
	endIf
	int newCharges = -1
	if currentPoison == poisonToApply
		chargesToApply += _Q2C_Functions.WornGetPoisonCharges(PlayerRef, Q)
		debug.trace("iEquip_WidgetCore applyPoison - about to top up the " + newPoison + " on your " + weaponName + " to " + chargesToApply + " charges")
		newCharges = _Q2C_Functions.WornSetPoisonCharges(PlayerRef, Q, chargesToApply)
	else
		debug.trace("iEquip_WidgetCore applyPoison - about to apply " + chargesToApply + " charges of " + newPoison + " to your " + weaponName)
		newCharges = _Q2C_Functions.WornSetPoison(PlayerRef, Q, poisonToApply, chargesToApply)
	endIf
	;Remove one item from the player
	PlayerRef.RemoveItem(poisonToApply, 1, true)
	;Flag the item as poisoned
	jMap.setInt(jArray.getObj(targetQ[Q], currentQueuePosition[Q]), "isPoisoned", 1)
	int count = PlayerRef.GetItemCount(poisonToApply)
	if count < 1
		removeItemFromQueue(4, currentQueuePosition[4])
	else
		setSlotCount(4, count)
	endIf
	if !ApplyWithoutUpdatingWidget
		checkAndUpdatePoisonInfo(Q)
	endIf
	;Play sound
	iEquip_ITMPoisonUse.Play(PlayerRef)
	;Add Poison FX to weapon
	PFX.ShowPoisonFX(Q)
endFunction

;Convenience function
function hidePoisonInfo(int Q)
	debug.trace("iEquip_WidgetCore hidePoisonInfo called")
	checkAndUpdatePoisonInfo(Q, true)
endFunction

function checkAndUpdatePoisonInfo(int Q, bool cycling = false)
	int targetObject = jArray.getObj(targetQ[Q], currentQueuePosition[Q])
	int itemType = jMap.getInt(targetObject, "Type")
	Potion currentPoison = _Q2C_Functions.WornGetPoison(PlayerRef, Q)
	Form equippedItem = PlayerRef.GetEquippedObject(Q)
	if !equippedItem && !goneUnarmed && !(Q == 0 && itemType == 26)
		return
	endIf
	debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo called - Q: " + Q + ", cycling: " + cycling + ", itemType: " + itemType + ", currentPoison: " + currentPoison)
	;if item isn't poisoned remove the poisoned flag
	if equippedItem && (equippedItem == jMap.getForm(targetObject, "Form")) && !currentPoison
		jMap.setInt(targetObject, "isPoisoned", 0)
	endIf
	float targetAlpha
	string iconName
	int iHandle
	int[] args
	;if the currently equipped item isn't poisonable, or if it isn't currently poisoned check and remove poison info is showing
	if cycling || !isPoisonable(itemType) || !currentPoison || (Q == 0 && isAmmoMode)
		if poisonInfoDisplayed[Q]
			;Hide the poison icon
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
			if(iHandle)
				UICallback.PushInt(iHandle, Q) ;Which slot we're updating
				UICallback.PushString(iHandle, "Hidden") ;New icon
				UICallback.Send(iHandle)
			endIf
			;Hide the poison name
			if isPoisonNameShown[Q]
				showName(Q, false, true, 0.15)
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
			poisonInfoDisplayed[Q] = false
		else
			return
		endIf
	;Otherwise update the poison name, count and icon
	else
		string poisonName = currentPoison.GetName()
		int charges = _Q2C_Functions.WornGetPoisonCharges(PlayerRef, Q)
		;Update the poison icon
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
		if MCM.poisonIndicatorStyle == 0
			iconName = "Hidden"
		elseif MCM.poisonIndicatorStyle < 3
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
			if isPoisonNameShown[Q]
				showName(Q, false, true, 0.15)
			endIf
			UI.SetString(HUD_MENU, WidgetRoot + poisonNamePath, poisonName)
		endIf
		if !isPoisonNameShown[Q]
			showName(Q, true, true, 0.15)
		endIf
		;Hide the counter, it'll be shown again below if needed
		if isCounterShown(Q)
			setCounterVisibility(Q, false)
		endIf
		;Update poison counter
		if MCM.poisonIndicatorStyle < 2 ;Count Only or Single Drop & Count
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
		poisonInfoDisplayed[Q] = true
	endIf
endFunction

bool function isPoisonable(int itemType)
	bool poisonable = ((itemType > 0 && itemType < 8) || itemType == 9)
	debug.trace("iEquip_WidgetCore isPoisonable called on itemType: " + itemType + ", isPoisonable: " + poisonable)
	return poisonable
endFunction

bool function isWeaponPoisoned(int Q, int iIndex, bool cycling = false)
	bool isPoisoned = false
	;if we're checking the left hand item but we currently have a 2H or ranged weapon equipped, or if we're cycling we need to check the object data for the last know poison info
	if cycling || (Q == 0 && RightHandWeaponIs2hOrRanged())
		isPoisoned = jMap.getInt(jArray.getObj(targetQ[Q], iIndex), "isPoisoned") as bool
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

bool equippingAllPreselectedItems = false
bool ReadyForPreselectAnim = false
bool allEquipped = false

function equipPreselectedItem(int Q)
	debug.trace("iEquip_WidgetCore equipPreselectedItem called - Q: " + Q + ", equippingAllPreselectedItems: " + equippingAllPreselectedItems)
	if !equippingAllPreselectedItems
		ReadyForPreselectAnim = false
		UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	endIf
	int itemToEquip = currentlyPreselected[Q]
	int targetArray = targetQ[Q]
	int targetObject = jArray.getObj(targetArray, currentlyPreselected[Q])
	form targetItem = jMap.getForm(targetObject, "Form")
	int itemType = jMap.getInt(targetObject, "Type")
	if (itemType == 7 || itemType == 9)
		checkAndRemoveBoundAmmo(itemType)
		if (!RightHandWeaponIsRanged() || switchingRangedWeaponType(itemType) || MCM.AmmoListSorting == 3)
			prepareAmmoQueue(itemType)
		endIf
	endIf
	string newName = jMap.getStr(targetObject, "Name")
	string newIcon = jMap.getStr(targetObject, "Icon")
	int count = jArray.count(targetArray)
	targetObject = jArray.getObj(targetArray, currentQueuePosition[Q])
    string currIcon =  jMap.getStr(targetObject, "Icon")
    string currPIcon = jMap.getStr(targetObject, "Icon")
    ;if we've chosen to swap items when equipping preselect then set the new preselect index to the currently equipped item ready to animate into the preselect slot
    if MCM.bPreselectSwapItemsOnEquip
		currentlyPreselected[Q] = currentQueuePosition[Q]
    ;Otherwise advance preselect queue
	else
    	cyclePreselectSlot(Q, count, false, false)
    endIf
    ;Update the attribute icons for the new item in the preselect slot
    updateAttributeIcons(Q, currentlyPreselected[Q], false, true)
    ;Do widget animation here if not equippingAllPreselectedItems
    if !equippingAllPreselectedItems
		targetObject = jArray.getObj(targetArray, currentlyPreselected[Q])
		string newPIcon = jMap.getStr(targetObject, "Icon")
		string newPName = jMap.getStr(targetObject, "Name")
		while !ReadyForPreselectAnim
			Utility.Wait(0.01)
		endwhile
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Which slot we're updating
			UICallback.PushString(iHandle, currIcon) ;Current icon
			UICallback.PushString(iHandle, newIcon) ;New icon
			UICallback.PushString(iHandle, newName) ;New name
			UICallback.PushString(iHandle, currPIcon) ;Current preselect icon
			UICallback.PushString(iHandle, newPIcon) ;New preselect icon
			UICallback.PushString(iHandle, newPName) ;New preselect name
			UICallback.Send(iHandle)
		endIf
		if nameFadeoutEnabled
			if Q == 0
				LNUpdate.registerForNameFadeoutUpdate()
				LPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 1
				RNUpdate.registerForNameFadeoutUpdate()
				RPNUpdate.registerForNameFadeoutUpdate()
			elseif Q == 2
				SNUpdate.registerForNameFadeoutUpdate()
				SPNUpdate.registerForNameFadeoutUpdate()	
			endIf
		endIf
	endIf
	;if we're in ammo mode whilst in Preselect Mode and either we're equipping the left preselected item, or we're equipping the right and it's not another ranged weapon we need to turn ammo mode off
	bool inAmmoMode = isAmmoMode
	if (inAmmoMode && (Q == 0 || Q == 1 && !(itemType == 7 || itemType == 9))) || (!inAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9)))
		toggleAmmoMode(true, (itemType == 5 || itemType == 6)) ;Toggle ammo mode off/on without the animation, and without re-equipping if RH is equipping 2H
		Utility.Wait(0.05)
		if Q == 1 && !isAmmoMode ;if we're equipping the right preselected item and it's not another ranged weapon we'll just have toggled ammo mode off without animation, now we need to remove the ammo from the left slot and replace it with the current left hand item
			if ammoModeActiveOnTogglePreselect && !equippingAllPreselectedItems ;if we were in ammo mode when we toggled Preselect Mode then use the equipPreselected animation, otherwise use updateWidget
				ammoModeActiveOnTogglePreselect = false ;Reset
				int leftItemToEquip = currentlyPreselected[0]
				targetArray = targetQ[0]
				int leftCount = jArray.count(targetArray)
			    string leftCurrIcon =  jMap.getStr(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Icon")
			    string leftCurrPIcon = jMap.getStr(jArray.getObj(targetQ[0], currentlyPreselected[0]), "Icon")
			    cyclePreselectSlot(0, leftCount, false, false)
			    targetObject = jArray.getObj(targetArray, leftItemToEquip)
			    string leftNewName = jMap.getStr(targetObject, "Name")
				string leftNewIcon = jMap.getStr(targetObject, "Icon")
				targetObject = jArray.getObj(targetArray, currentlyPreselected[0])
				string leftNewPIcon = jMap.getStr(targetObject, "Icon")
				string leftNewPName = jMap.getStr(targetObject, "Name")
				int iHandleLeft = UICallback.Create(HUD_MENU, WidgetRoot + ".equipPreselectedItem")
				if(iHandleLeft)
					UICallback.PushInt(iHandleLeft, 0)
					UICallback.PushString(iHandleLeft, leftCurrIcon)
					UICallback.PushString(iHandleLeft, leftNewIcon)
					UICallback.PushString(iHandleLeft, leftNewName)
					UICallback.PushString(iHandleLeft, leftCurrPIcon)
					UICallback.PushString(iHandleLeft, leftNewPIcon)
					UICallback.PushString(iHandleLeft, leftNewPName)
					UICallback.Send(iHandleLeft)
				endIf
			else
				updateWidget(0, currentQueuePosition[0], true)
			endIf
			ammo targetAmmo = jMap.getForm(jArray.getObj(targetQ[ammoQ], currentQueuePosition[ammoQ]), "Form") as Ammo
			if MCM.bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
				PlayerRef.UnequipItemEx(targetAmmo)
			endIf
			if nameFadeoutEnabled
				LNUpdate.registerForNameFadeoutUpdate()
				LPNUpdate.registerForNameFadeoutUpdate()
			endIf
			targetObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
			int leftItemType = jMap.getInt(targetObject, "Type")
			form leftItem = jMap.getForm(targetObject, "Form")
			string leftName = jMap.getStr(targetObject, "Name")
			if itemRequiresCounter(0, leftItemType , leftName)
				setSlotCount(0, PlayerRef.GetItemCount(leftItem))
				setCounterVisibility(0, true)
			elseif isCounterShown(0)
				setCounterVisibility(0, false)
			endIf
			if !(itemType == 5 || itemType == 6) ;As long as the item which triggered toggling out of ammoMode isn't a 2H weapon we can now re-equip the left hand
				if leftItemType == 22
					PlayerRef.EquipSpell(leftItem as Spell, 0)
			    elseif leftItemType == 26
			    	PlayerRef.EquipItem(leftItem as Armor)
				else
				    PlayerRef.EquipItemEx(leftItem, 2, false, false)
				endIf
			endIf
		endIf

	elseif inAmmoMode && (Q == 1 && (itemType == 7 || itemType == 9) && switchingRangedWeaponType(itemType))
		checkAndEquipAmmo(false, true)
	endIf

	if Q == 1 && targetItem == iEquip_Unarmed2H
		goUnarmed()
		return
	endIf

    if Q == 2 && targetItem != none ;Shout/Power
	    if itemType == 22
	        PlayerRef.EquipSpell(targetItem as Spell, 2)
	    else
	        PlayerRef.EquipShout(targetItem as Shout)
	    endIf
	else ;Left or right hand
		preselectSwitchingHands = false ;Reset just in case
		;When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
	    int iEquipSlotId = 1
	    int otherHand = 0
	    if Q == 0
	    	iEquipSlotId = 2
	    	otherHand = 1
	    endIf
		;Unequip current item
		UnequipHand(Q)
		;if equipping the left hand will cause a 2H or ranged weapon to be unequipped in the right hand, or the one handed weapon you are about to equip is already equipped in the other hand and you only have one of it then cycle the main slot and equip a suitable 1H item
		int itemCount = PlayerRef.GetItemCount(targetItem)
		if (Q == 0 && RightHandWeaponIs2hOrRanged()) || (targetItem == PlayerRef.GetEquippedObject(otherHand) && itemType != 22 && itemCount < 2) || (goneUnarmed && !(itemType == 5 || itemType == 6 || itemType == 7 || itemType == 9))
			if !equippingAllPreselectedItems
	        	preselectSwitchingHands = true
	        endif
	        ;if any of the above checks are met then unequip the opposite hand first (possibly not required)
	        UnequipHand(otherHand)
	        Utility.Wait(0.1)
	    endIf
	    ;if we are re-equipping from an unarmed state
	    if goneUnarmed
	    	;if we're equipping a preselected 2H weapon in the right hand then update the left hand slot to show the last equipped item prior to going unarmed
	    	if itemType == 5 || itemType == 6
	    		updateWidget(0, currentQueuePosition[0])
	    		checkAndUpdatePoisonInfo(0)
	    		targetObject = jArray.getObj(targetQ[0], currentQueuePosition[0])
	    		if itemRequiresCounter(0, jMap.getInt(targetObject, "Type"))
					setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "Form")))
					setCounterVisibility(0, true)
				endIf
	    	endIf
			goneUnarmed = false
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
		;if we're not equippingAllPreselectedItems and you have just unequipped the opposite hand cycle the normal queue in the unequipped hand. cycleSlot will check for preselectSwitchingHands and skip the currently preselected item if it is the next in the main queue.
		if preselectSwitchingHands
			Utility.Wait(0.1)
			cycleSlot(otherHand, false)
			preselectSwitchingHands = false
		endIf
	endIf
	currentQueuePosition[Q] = itemToEquip
	currentlyEquipped[Q] = newName
	Utility.Wait(0.05)
	if Q < 2
		if itemRequiresCounter(Q)
			setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
			setCounterVisibility(Q, true)
		elseif isCounterShown(Q)
			setCounterVisibility(Q, false)
		endIf
		checkAndUpdatePoisonInfo(Q)
		checkIfBoundSpellEquipped()
		if !equippingAllPreselectedItems
			checkAndFadeLeftIcon(Q, itemType)
			if currentlyPreselected[0] == currentQueuePosition[0]
				cyclePreselectSlot(0, jArray.count(targetQ[0]), false)
			endIf
			if currentlyPreselected[1] == currentQueuePosition[1]
				cyclePreselectSlot(1, jArray.count(targetQ[1]), false)
			endIf
			if MCM.bEnableGearedUp
				refreshGearedUp()
			endIf
			if isAmmoMode && AmmoModePreselectModeFirstLook
				Utility.Wait(1.8)
				Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
				AmmoModePreselectModeFirstLook = false
			endIf
		endIf
	endIf
endFunction

event ReadyForPreselectAnimation(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore ReadyForPreselectAnimation called")
	If(sEventName == "iEquip_ReadyForPreselectAnimation")
		ReadyForPreselectAnim = true
	endIf
endEvent

function equipAllPreselectedItems()
	debug.trace("iEquip_WidgetCore equipAllPreselectedItems() called")
	equippingAllPreselectedItems = true
	ReadyForPreselectAnim = false
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	form leftTargetItem = jMap.getForm(jArray.getObj(targetQ[0], currentlyPreselected[0]), "Form")
	int targetObject = jArray.getObj(targetQ[1], currentlyPreselected[1])
	int targetArray
	form rightTargetItem = jMap.getForm(targetObject, "Form")
	int rightHandItemType = jMap.getInt(targetObject, "Type")
	if (rightHandItemType != 5 && rightHandItemType != 6 && rightHandItemType != 7 && rightHandItemType != 9)
		checkAndFadeLeftIcon(1, rightHandItemType)
	endIf
	Utility.Wait(0.3)
	UI.Invoke(HUD_MENU, WidgetRoot + ".prepareForPreselectAnimation")
	int itemCount = PlayerRef.GetItemCount(leftTargetItem)
	string[] leftData
	string[] rightData
	string[] shoutData
	if MCM.bTogglePreselectOnEquipAll
		leftData = new string[3]
		rightData = new string[3]
		shoutData = new string[3]
	else
		leftData = new string[5]
		rightData = new string[5]
		shoutData = new string[5]
	endIf
	;Equip preselected shout first unless !shoutPreselectEnabled
	if shoutPreselectShown
		targetArray - targetQ[2]
		;Store currently equipped item icons and preselected item icons and names for each slot if enabled
		targetObject = jArray.getObj(targetArray, currentQueuePosition[2])
		shoutData[0] = jMap.getStr(targetObject, "Icon")
		shoutData[1] = shoutData[0]
		shoutData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(2)
		if !MCM.bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, currentlyPreselected[2])
			;equipPreselectedItem has now cycled to the next preselect slot without updating the widget so store new preselected item icon and name
			shoutData[3] = jMap.getStr(targetObject, "Icon")
			shoutData[4] = jMap.getStr(targetObject, "Name")
			Utility.Wait(0.2)
		endIf
	else
		;if !shoutPreselectEnabled clear array indices
		shoutData[0] = ""
		shoutData[1] = ""
		shoutData[2] = ""
		if !MCM.bTogglePreselectOnEquipAll
			shoutData[3] = ""
			shoutData[4] = ""
		endIf
	endIf
	;Equip right hand first so any 2H/Ranged weapons take priority and equipping left hand can be blocked
	if rightPreselectShown
		targetArray = targetQ[1]
		targetObject = jArray.getObj(targetArray, currentQueuePosition[1])
		rightData[0] = jMap.getStr(targetObject, "Icon")
		rightData[1] = rightData[0]
		rightData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(1)
		if !MCM.bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, currentlyPreselected[1])
			rightData[3] = jMap.getStr(targetObject, "Icon")
			rightData[4] = jMap.getStr(targetObject, "Name")
			Utility.Wait(0.2)
		endIf
	else
		rightData[0] = ""
		rightData[1] = ""
		rightData[2] = ""
		if !MCM.bTogglePreselectOnEquipAll
			rightData[3] = ""
			rightData[4] = ""
		endIf
	endIf
	rightHandItemType = jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type")
	bool equipLeft = true
	if leftPreselectShown && !(rightPreselectShown && ((rightHandItemType == 5 || rightHandItemType == 6 || rightHandItemType == 7 || rightHandItemType == 9) || (leftTargetItem == rightTargetItem && itemCount < 2 && rightHandItemType != 22)))
		targetArray = targetQ[0]
		targetObject = jArray.getObj(targetArray, currentQueuePosition[0])
		leftData[0] = jMap.getStr(targetObject, "Icon")
		leftData[1] = leftData[0]
		leftData[2] = jMap.getStr(targetObject, "Name")
		equipPreselectedItem(0)
		if !MCM.bTogglePreselectOnEquipAll
			targetObject = jArray.getObj(targetArray, currentlyPreselected[0])
			leftData[3] = jMap.getStr(targetObject, "Icon")
			leftData[4] = jMap.getStr(targetObject, "Name")
		endIf
	else
		equipLeft = false
		leftData[0] = ""
		leftData[1] = ""
		leftData[2] = ""
		if !MCM.bTogglePreselectOnEquipAll
			leftData[3] = ""
			leftData[4] = ""
		endIf
	endIf
    if goneUnarmed
		goneUnarmed = false
	endIf
	while !ReadyForPreselectAnim
		Utility.Wait(0.01)
	endwhile
	allEquipped = false
	Self.RegisterForModEvent("iEquip_EquipAllComplete", "EquipAllComplete")
	int iHandle
	if MCM.bTogglePreselectOnEquipAll
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItemsAndTogglePreselect")
	else
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".equipAllPreselectedItems")
	endIf
	if(iHandle)
		UICallback.Pushbool(iHandle, equipLeft)
		UICallback.Pushbool(iHandle, rightPreselectShown)
		UICallback.Pushbool(iHandle, shoutPreselectShown)
		UICallback.PushStringA(iHandle, leftData)
		UICallback.PushStringA(iHandle, rightData)
		UICallback.PushStringA(iHandle, shoutData)
		UICallback.Send(iHandle)
	endIf
	while !allEquipped
		Utility.Wait(0.01)
	endwhile
	if rightPreselectShown
		checkAndFadeLeftIcon(1, rightHandItemType)
	endIf
	if nameFadeoutEnabled
		if equipLeft
			LNUpdate.registerForNameFadeoutUpdate()
			LPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if rightPreselectShown
			RNUpdate.registerForNameFadeoutUpdate()
			RPNUpdate.registerForNameFadeoutUpdate()
		endIf
		if shoutPreselectShown
			SNUpdate.registerForNameFadeoutUpdate()
			SPNUpdate.registerForNameFadeoutUpdate()	
		endIf
	endIf
	equippingAllPreselectedItems = false
	if MCM.bEnableGearedUp
		refreshGearedUp()
	endIf
	if isAmmoMode && AmmoModePreselectModeFirstLook
		Utility.Wait(1.0)
		Debug.MessageBox("iEquip Ammo Mode\n\nYou have equipped a ranged weapon in your right hand in Preselect Mode for the first time.  You will see that the main left hand slot is now displaying your current ammo.\n\nControls while ammo shown\n\nSingle press left hotkey cycles ammo\nDouble press left hotkey cycles preselect slot\nLongpress left hotkey equips the left preselected item and switches the right hand to a suitable 1H item.")
		AmmoModePreselectModeFirstLook = false
	endIf
endFunction

event EquipAllComplete(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore EquipAllComplete called")
	If(sEventName == "iEquip_EquipAllComplete")
		allEquipped = true
		Self.UnregisterForModEvent("iEquip_EquipAllComplete")
	endIf
	if MCM.bTogglePreselectOnEquipAll
		togglingPreselectOnEquipAll = true
		togglePreselectMode()
	endIf
endEvent

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
	
	;KH.blockControls()

	if !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("CustomMenu") && !((Self as form) as iEquip_uilib).IsMenuOpen()
		itemFormID = UI.GetInt(currentMenu, entryPath + "formId")
		itemForm = game.GetFormEx(itemFormID)
	endIf
	if itemForm && itemForm != None
		itemType = itemForm.GetType()
		if itemType == 41 || itemType == 26 ;Weapons and shields only
			isEnchanted = UI.Getbool(currentMenu, entryPath + "isEnchanted")
		endIf
		itemID = UI.GetInt(currentMenu, entryPath + "itemId")
		itemName = UI.GetString(currentMenu, entryPath + "text")
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
				if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2) && !MCM.bAllowSingleItemsInBothQueues
					debug.MessageBox("You currently only have one " + itemName + " and it is already in the other hand queue")
					return
				endIf
				;if Q < 2 && (itemType == 41 || itemType == 26) && !itemID
				if itemID < 1
					queueItemForIDGenerationOnMenuClose(Q, jArray.count(targetQ[Q]), itemName, itemFormID)
				endIf
				bool success = false
				if itemType == 41 ;if it is a weapon get the weapon type
					Weapon W = itemForm as Weapon
		        	itemType = W.GetWeaponType()
		        	;debug.Notification(itemName + " , weapon type: " + itemType)
		        endIf
				string itemIcon = GetItemIconName(itemForm, itemType, itemName)
				debug.trace("iEquip_WidgetCore addToQueue(): Adding " + itemName + " to the " + queueName[Q] + ", formID = " + itemform + ", itemID = " + itemID as string + ", icon = " + itemIcon + ", isEnchanted = " + isEnchanted)
				int iEquipItem = jMap.object()
				if jArray.count(targetQ[Q]) < MCM.maxQueueLength
					if showQueueConfirmationMessages
						iEquip_MessageObjectReference = playerREF.PlaceAtMe(iEquip_MessageObject)
						iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
						if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2)
							iEquip_MessageAlias.GetReference().GetBaseObject().SetName("You currently only have one " + itemName + " and it is already in the other hand queue. Do you want to add it to the " + queueName[Q] + " as well?")
						else
							iEquip_MessageAlias.GetReference().GetBaseObject().SetName("Would you like to add " + itemName + " to the " + queueName[Q] + "?")
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
					jArray.addObj(targetQ[Q], iEquipItem)
					success = true
				else
					debug.notification("The " + queueName[Q] + " is full")
				endIf
				if success
					debug.notification(itemName + " was added to the " + queueName[Q])
				endIf
			else
				debug.notification(itemName + " has already been added to the " + queueName[Q])
			endIf
		else
			if isFirstFailedToAdd
				debug.MessageBox("You are trying to add the wrong type of item or spell to one of your iEquip queues.\n\nRULES\nLeft hand queue - 1H weapons, unarmed, staffs, spells, scrolls, torch, shield\nRight hand queue - Any weapon, spells, scrolls\nShout queue - shouts, powers\nConsumable queue - potions, food, drink\nPoison queue - poisons")
				isFirstFailedToAdd = false
			else
				debug.notification(itemName + " cannot be added to the " + queueName[Q])
			endIf
		endIf
	endIf
endFunction

bool itemsWaitingForID = false

function queueItemForIDGenerationOnMenuClose(int Q, int iIndex, string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore queueItemForIDGenerationOnMenuClose called - Q: " + Q + ", iIndex: " + iIndex + ", itemFormID: " + itemFormID + ", itemName: " + itemName)
	int queuedItem = jMap.object()
	jMap.setInt(queuedItem, "Q", Q)
	jMap.setInt(queuedItem, "Index", iIndex)
	jMap.setStr(queuedItem, "Name", itemName)
	jMap.setInt(queuedItem, "formID", itemFormID)
	jArray.addObj(objItemsForIDGeneration, queuedItem)
	itemsWaitingForID = true
endFunction

function findAndFillMissingItemIDs()
	int count = jArray.count(objItemsForIDGeneration)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs called - number of items to generate IDs for: " + count)
	int i = 0
	int itemID
	int Q
	int iIndex
	int targetObject
	while i < count
		targetObject = jArray.getObj(objItemsForIDGeneration, i)
		itemID = createItemID(jMap.getStr(targetObject, "Name"), jMap.getInt(targetObject, "formID"))
		if itemID && itemID > 0
			Q = jMap.getInt(targetObject, "Q")
			iIndex = jMap.getInt(targetObject, "Index")
			jMap.setInt(jArray.getObj(targetQ[Q], iIndex), "itemID", itemID)
		endIf
		Utility.Wait(0.05)
		i += 1
	endwhile
	itemsWaitingForID = false
	;jArray.eraseRange(objItemsForIDGeneration, 0, count - 1)
	jArray.clear(objItemsForIDGeneration)
	debug.trace("iEquip_WidgetCore findAndFillMissingItemIDs - final check (count should be 0) - count: " + jArray.count(objItemsForIDGeneration))
endFunction

bool gotID = false
int receivedID = -1

int function createItemID(string itemName, int itemFormID)
	debug.trace("iEquip_WidgetCore createItemID called - itemFormID: " + itemFormID + ", itemName: " + itemName)
	RegisterForModEvent("iEquip_GotItemID", "itemIDReceivedFromFlash")
	;Reset
	gotID = false
	receivedID = -1
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".generateItemID")
	If(iHandle)
		UICallback.PushString(iHandle, itemName) ;Display name
		UICallback.PushInt(iHandle, itemFormID) ;formID
		UICallback.Send(iHandle)
	endIf
	int breakout = 1000 ;Wait up to 1 sec for return from flash, if not return -1
	while !gotID && breakout > 0
		Utility.Wait(0.001)
		breakout -= 1
	endwhile
	return receivedID
endFunction

event itemIDReceivedFromFlash(string sEventName, string sStringArg, Float fNumArg, Form kSender)
	debug.trace("iEquip_WidgetCore itemIDReceivedFromFlash - sStringArg: " + sStringArg + ", fNumArg" + fNumArg)
	If(sEventName == "iEquip_GotItemID")
		receivedID = sStringArg as Int
		gotID = true
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
        	if !(contains(itemName, "Arrow") || contains(itemName, "arrow") || contains(itemName, "Bolt") || contains(itemName, "bolt") || itemName == "Javelin") ;Javelin is the display name for those from Throwing Weapons Lite/Redux, the javelins from Spears by Soolie all have more descriptive names than just 'javelin' and they are treated as arrows or bolts so can't be right hand equipped
        		iEquip_MessageObjectReference = playerREF.PlaceAtMe(iEquip_MessageObject)
				iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
				iEquip_MessageAlias.GetReference().GetBaseObject().SetName("Are these " + itemName + "s classed as throwing weapons?\n\nPlease note that the javelins from Spears by Soolie are classed as arrows or bolts and should not be added here.\n\nWould you like to proceed and add " + itemName + "s to the " + queueName[Q] + "?")
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
	int targetArray = targetQ[Q]
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
        IconName = weaponTypeNames[itemType]
        ;2H axes and maces have the same ID for some reason, so we have to differentiate them
        if itemType == 6 && W.IsWarhammer()
            IconName = "Warhammer"
        ;if this all looks a little strange it is because StringUtil find() is case sensitive so where possible I've ommitted the first letter to catch for example Spear and spear with pear
        elseif itemType == 1 && contains(itemName, "pear") ;Looking for spears here from Spears by Soolie which are classed as 1H swords
        	IconName = "Spear"
        elseif itemType == 4 && (contains(itemName, "renade") || contains(itemName, "lask") || contains(itemName, "Pot") || contains(itemName, "pot") || contains(itemName, "omb")) ;Looking for CACO grenades here which are classed as maces
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
        endIf

    elseif itemType == 42 ;Ammo - Throwing weapons
    	if contains(itemName, "pear") || contains(itemName, "avelin")
			IconName = "Spear"
		elseif contains(itemName, "renade") || contains(itemName, "lask") || contains(itemName, "Pot") || contains(itemName, "pot") || contains(itemName, "omb")
			IconName = "Grenade"
		elseif contains(itemName, "Axe")
			IconName = "ThrowingAxe"
		elseif contains(itemName, "nife") || contains(itemName, "agger")
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
	int targetArray = targetQ[1]
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

function openUtilityMenu()
	int iAction = iEquip_UtilityMenu.Show() ;0 = Exit, 1 = Queue Menu, 2 = Edit Mode, 3 = MCM, 4 = Refresh Widget
	if iAction == 0 ;Exit
		return
	elseif iAction == 1
		openQueueManagerMenu()
	elseif iAction == 2
		KH.ToggleEditMode()
	elseif iAction == 3
		KH.openiEquipMCM()
	elseif iAction == 4
		;HM.openHelpMenu()
	elseif iAction == 5
		refreshWidget()
	endIf
endFunction

function openQueueManagerMenu()
	debug.trace("iEquip_WidgetCore openQueueManagerMenu() called")
	int Q = iEquip_QueueManagerMenu.Show() ;0 = Exit, 1 = Left hand queue, 2 = Right hand queue, 3 = Shout queue, 4 = Consumable queue, 5 = Poison queue
	if Q == 0 ;Exit
		return
	else
		Q -= 1
		int i = jArray.count(targetQ[Q])
		if i <= 0
			debug.MessageBox("Your " + queueName[Q] + " is currently empty")
			recallQueueMenu()
			return
		else
			queueMenuCurrentQueue = Q
			string title = "You currently have " + i + " items in your " + queueName[Q]
			String[] iconNameList = createIconNameListArray()
			String[] list = createQueueListArray()
			bool[] enchFlags = createEnchFlagsArray()
			bool[] poisonFlags = createPoisonFlagsArray()
			((Self as Form) as iEquip_UILIB).ShowQueueMenu(title, iconNameList, list, enchFlags, poisonFlags, 0, 0)
		endIf
	endIf
endFunction

String[] function createIconNameListArray()
	debug.trace("iEquip_WidgetCore createIconNameListArray() called")
	int Q = queueMenuCurrentQueue
	int targetArray = targetQ[Q]
	int i = jArray.count(targetArray)
	String[] list = Utility.CreateStringArray(i)
	int iIndex = 0
	while iIndex < i
		list[iIndex] = JMap.getStr(jArray.getObj(targetArray, iIndex), "Icon")
		;debug.trace("iEquip_WidgetCore createIconNameListArray(): " + list[iIndex] + " retrieved from list[] at index " + iIndex as string)
		iIndex += 1
	endwhile
	return list
endFunction

String[] function createQueueListArray()
	debug.trace("iEquip_WidgetCore createQueueListArray() called")
	int Q = queueMenuCurrentQueue
	int targetArray = targetQ[Q]
	int i = jArray.count(targetArray)
	String[] list = Utility.CreateStringArray(i)
	int iIndex = 0
	while iIndex < i
		list[iIndex] = JMap.getStr(jArray.getObj(targetArray, iIndex), "Name")
		;debug.trace("iEquip_WidgetCore createQueueListArray(): " + list[iIndex] + " retrieved from list[] at index " + iIndex as string)
		iIndex += 1
	endwhile
	return list
endFunction

bool[] function createEnchFlagsArray()
	debug.trace("iEquip_WidgetCore createEnchFlagsArray() called")
	int Q = queueMenuCurrentQueue
	int targetArray = targetQ[Q]
	int i = jArray.count(targetArray)
	bool[] list = Utility.CreateboolArray(i)
	int iIndex = 0
	while iIndex < i
		list[iIndex] = false
		if (JMap.getInt(jArray.getObj(targetArray, iIndex), "isEnchanted")) as bool == true
			list[iIndex] = true
		endIf
		;debug.trace("iEquip_WidgetCore createEnchFlagsArray(): " + list[iIndex] + " retrieved from list[] at index " + iIndex as string)
		iIndex += 1
	endwhile
	return list
endFunction

bool[] function createPoisonFlagsArray()
	debug.trace("iEquip_WidgetCore createPoisonFlagsArray() called")
	int Q = queueMenuCurrentQueue
	int targetArray = targetQ[Q]
	int i = jArray.count(targetArray)
	bool[] list = Utility.CreateboolArray(i)
	int iIndex = 0
	while iIndex < i
		list[iIndex] = false
		if (JMap.getInt(jArray.getObj(targetArray, iIndex), "isPoisoned")) as bool == true
			list[iIndex] = true
		endIf
		;debug.trace("iEquip_WidgetCore createPoisonFlagsArray(): " + list[iIndex] + " retrieved from list[] at index " + iIndex as string)
		iIndex += 1
	endwhile
	return list
endFunction

function recallQueueMenu()
	debug.trace("iEquip_WidgetCore recallQueueMenu() called")
	Utility.Wait(0.05)
	openQueueManagerMenu()
endFunction

function recallPreviousQueueMenu()
	int i = jArray.count(targetQ[queueMenuCurrentQueue])
	string title = "You currently have " + i + " items in your " + queueName[queueMenuCurrentQueue]
	String[] iconNameList = createIconNameListArray()
	String[] list = createQueueListArray()
	bool[] enchFlags = createEnchFlagsArray()
	bool[] poisonFlags = createPoisonFlagsArray()
	((Self as Form) as iEquip_UILIB).ShowQueueMenu(title, iconNameList, list, enchFlags, poisonFlags, 0, 0)
endFunction

function QueueMenuSwap(int upDown, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuSwap() called")
	;upDown - 0 = Move Up, 1 = Move Down
	int targetArray = targetQ[queueMenuCurrentQueue]
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
	int targetArray = targetQ[queueMenuCurrentQueue]
	string itemName = JMap.getStr(jArray.getObj(targetArray, iIndex), "Name")
	if !(contains(itemName, "Potions"))
		jArray.eraseIndex(targetArray, iIndex)
		int i = jArray.count(targetArray)
		if iIndex >= i
			iIndex -= 1
		endIf
		QueueMenuUpdate(i, iIndex)
	elseIf firstAttemptToDeletePotionGroup
		firstAttemptToDeletePotionGroup = false
		((Self as Form) as iEquip_UILIB).closeQueueMenu()
		debug.MessageBox("Potion Groups cannot be deleted.  To remove them from your consumables queue please use the MCM Potions page do disable them.")
		recallPreviousQueueMenu()
	endIf
endFunction

function QueueMenuUpdate(int iCount, int iIndex)
	debug.trace("iEquip_WidgetCore QueueMenuUpdate() called")
	string title
	if iCount <= 0
		title = "Your " + queueName[queueMenuCurrentQueue] + " is currently empty"
	else
		title = "You currently have " + iCount + " items in your " + queueName[queueMenuCurrentQueue]
	endIf
	QueueMenu_RefreshTitle(title)
	String[] iconNameList = createIconNameListArray()
	String[] list = createQueueListArray()
	bool[] enchFlags = createEnchFlagsArray()
	bool[] poisonFlags = createPoisonFlagsArray()
	QueueMenu_RefreshList(iconNameList, list, enchFlags, poisonFlags, iIndex)
endFunction

function QueueMenuClearQueue()
	debug.trace("iEquip_WidgetCore QueueMenuClearQueue() called")
	jArray.clear(targetQ[queueMenuCurrentQueue])
	debug.MessageBox("Your " + queueName[queueMenuCurrentQueue] + " has been cleared")
	recallQueueMenu()
endFunction

function ApplyMCMSettings()
	debug.trace("iEquip_WidgetCore ApplyMCMSettings called")
	
	if isEnabled
		if MCM.restartingMCM
			;KH.openiEquipMCM()
		elseif MCM.iEquip_Reset
			EM.ResetDefaults()
		else
			if MCM.ShowMessages
				debug.Notification("Applying iEquip settings...")
			endIf
			ApplyChanges()
			if EM.isEditMode
				EM.updateEditModeButtons()
				EM.LoadEditModeWidgets()
			endIf
		endIf
	else
		debug.Notification("iEquip disabled...")
	endIf
endFunction

function ApplyChanges()
	debug.trace("iEquip_WidgetCore ApplyChanges called")
	int i
	if MCM.slotEnabledOptionsChanged
		updateSlotsEnabled()
	endIf
	if MCM.fadeOptionsChanged
		i = 0
        while i < 8
            showName(i, true) ;Reshow all the names and either register or unregister for updates
            i += 1
        endwhile
        MCM.fadeOptionsChanged = false
    endIf
    if MCM.refreshQueues
    	purgeQueue()
    endIf
    if MCM.gearedUpOptionChanged
    	MCM.gearedUpOptionChanged = false
    	Utility.SetINIbool("bDisableGearedUp:General", True)
		refreshVisibleItems()
		if MCM.bEnableGearedUp
			Utility.SetINIbool("bDisableGearedUp:General", False)
			refreshVisibleItems()
		endIf
    endIf
    int targetArray = targetQ[ammoQ]
    ammo targetAmmo = jMap.getForm(jArray.getObj(targetArray, currentQueuePosition[ammoQ]), "Form") as ammo
    if !isAmmoMode && MCM.bUnequipAmmo && targetAmmo && PlayerRef.isEquipped(targetAmmo)
		PlayerRef.UnequipItemEx(targetAmmo)
	endIf
    if !MCM.bProModeEnabled && isPreselectMode
    	togglePreselectMode()
    endIf
    if isAmmoMode
	    if MCM.ammoSortingChanged
	    	;First we need to check if we currently have Bound Ammo in the queue - if we do store it and remove it from the queue
	    	bool boundAmmoRemoved = false
	    	int tempBoundAmmoObj
	    	int queueLength = jArray.count(targetArray)
	    	int targetObject = jArray.getObj(targetArray, queueLength - 1)
	    	string lastAmmoInQueue = jMap.getStr(targetObject, "Name")
	    	if contains(lastAmmoInQueue, "Bound") || contains(lastAmmoInQueue, "bound")
	    		tempBoundAmmoObj = targetObject
	    		jArray.eraseIndex(targetArray, queueLength - 1)
	    		boundAmmoRemoved = true
	    	endIf
	    	;Now prepare the ammo queue with the new sorting option
	    	prepareAmmoQueue(jMap.getInt(jArray.getObj(targetQ[1], currentQueuePosition[1]), "Type"))
	    	;And if we previously set aside bound ammo we can now re-add it to the end of the queue and reselect it
	    	if boundAmmoRemoved
	    		jArray.addObj(targetArray, tempBoundAmmoObj)
	    		currentQueuePosition[ammoQ] = jArray.count(targetArray) - 1
				currentlyEquipped[ammoQ] = jMap.getStr(tempBoundAmmoObj, "Name")
			endIf
	    	checkAndEquipAmmo(false, false)
	    endIf
	    if MCM.ammoIconChanged
	    	checkAndEquipAmmo(false, false, true, false)
	    endIf
	endIf
	if isPreselectMode || MCM.bAttributeIconsOptionChanged
		i = 0
		while i < 2
			if MCM.bShowAttributeIcons
				updateAttributeIcons(i, 0)
			else
				hideAttributeIcons(i + 5)
			endIf
			i += 1
		endwhile
		MCM.bAttributeIconsOptionChanged = false
	endIf
	if MCM.poisonIndicatorStyleChanged
		MCM.poisonIndicatorStyleChanged = false
		i = 0
		while i < 2
			if poisonInfoDisplayed[i]
				checkAndUpdatePoisonInfo(i)
			endIf
			i += 1
		endwhile
	endIf
	if MCM.bPotionGroupingOptionsChanged
		MCM.bPotionGroupingOptionsChanged = false
	    if (currentlyEquipped[3] == "Health Potions" && !MCM.bHealthPotionGrouping) || (currentlyEquipped[3] == "Stamina Potions" && !MCM.bStaminaPotionGrouping) || (currentlyEquipped[3] == "Magicka Potions" && !MCM.bMagickaPotionGrouping)
	        cycleSlot(3)
	    endIf
	endIf
endFunction
