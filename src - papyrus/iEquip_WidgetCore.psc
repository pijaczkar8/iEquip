
Scriptname iEquip_WidgetCore extends SKI_WidgetBase

import Input
import Form
import UI
import UICallback
import Utility
import StringUtil
import iEquip_UILIB
import AhzMoreHudIE
import WornObject
import iEquip_FormExt
import iEquip_StringExt
import iEquip_SpellExt
import iEquip_ActorExt
import iEquip_WeaponExt
import iEquip_UIExt
import iEquip_InventoryExt
;import iEquip_MagicEffectExt
import ConsoleUtil

;Script Properties
iEquip_ChargeMeters property CM auto
iEquip_EditMode property EM auto
iEquip_KeyHandler property KH auto
iEquip_RechargeScript property RC auto
iEquip_AmmoMode property AM auto
iEquip_ProMode property PM auto
iEquip_BeastMode property BM auto
iEquip_PotionScript property PO auto
iEquip_ThrowingPoisons property TP auto
iEquip_TorchScript property TO auto
iEquip_PlayerEventHandler property EH auto
iEquip_BoundWeaponEventsListener property BW auto
iEquip_AddedItemHandler property AD auto
iEquip_TemperedItemHandler Property TI Auto
iEquip_MCM property MCM auto
iEquip_WidgetVisUpdateScript property WVis auto

iEquip_LeftHandEquipUpdateScript property LHUpdate auto
iEquip_RightHandEquipUpdateScript property RHUpdate auto
iEquip_LeftPosIndUpdateScript property LHPosUpdate auto
iEquip_RightPosIndUpdateScript property RHPosUpdate auto
iEquip_ShoutPosIndUpdateScript property SPosUpdate auto
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
iEquip_PotionSelectorUpdateScript property PSUpdate auto
iEquip_PoisonNameUpdateScript property PNUpdate auto
iEquip_SlowTimeEffectUpdateScript property STUpdate auto

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
Message property iEquip_ConfirmClearQueue auto
Message property iEquip_ConfirmDeletePreset auto
Message property iEquip_ConfirmReset auto
Message property iEquip_ConfirmResetParent auto
Message property iEquip_ConfirmDiscardChanges auto
message property iEquip_SavePresetOptions auto
Spell property PLFX Auto
Spell property PRFX Auto

Weapon[] property aUniqueItems auto hidden
string[] asUniqueItemIcons
Weapon property DBAlainAegisbane auto
Weapon property DA02Dagger auto
Weapon property TG07Chillrend001 auto
Weapon property TG07Chillrend002 auto
Weapon property TG07Chillrend003 auto
Weapon property TG07Chillrend004 auto
Weapon property TG07Chillrend005 auto
Weapon property TG07Chillrend006 auto
Weapon property DA09Dawnbreaker auto
Weapon property MG07DraugrMagicSword auto
Weapon property dunFolgunthurMikrulSword02 auto
Weapon property dunFolgunthurMikrulSword03 auto
Weapon property dunFolgunthurMikrulSword04 auto
Weapon property dunFolgunthurMikrulSword05 auto
Weapon property dunFolgunthurMikrulSword06 auto
Weapon property dunAnsilvundGhostblade auto
Weapon property FFRiften09Grimsever auto
Weapon property MGRKeening auto
Weapon property DA10MaceofMolagBal auto
Weapon property DA07MehrunesRazor auto
Weapon property T03Nettlebane auto
Weapon property NightingaleBlade01 auto
Weapon property NightingaleBlade02 auto
Weapon property NightingaleBlade03 auto
Weapon property NightingaleBlade04 auto
Weapon property NightingaleBlade05 auto
Weapon property NightingaleBladeNPC auto
Weapon property dunVolunruudPickaxe auto
Weapon property dunVolunruudOkin auto
Weapon property weapPickaxe auto
Weapon property dunRedEagleSwordBase auto
Weapon property dunRedEagleSwordUpgraded auto
Weapon property DA03RuefulAxe auto
Weapon property DA06Volendrung auto
Weapon property dunKatariahScimitar auto
Weapon property Axe01 auto
Weapon property dunHaltedStreamPoachersAxe auto
Weapon property C06BladeOfYsgramor auto

; Vanilla Chargen items

;/Armor Property ArmorIronBoots  Auto
Armor Property ArmorIronCuirass  Auto
Armor Property ArmorIronGauntlets  Auto
Armor Property ArmorIronHelmet  Auto
Armor Property ArmorIronShield  Auto
Armor Property ClothesPrisonerShoes  Auto
Armor Property ClothesPrisonerTunic  Auto
Armor Property PrisonerCuffsPlayer  Auto
Potion Property FortifySkillOneHanded01  Auto
Potion Property FortifySkillSneak01  Auto
Potion Property ResistFire25  Auto
Potion Property RestoreHealth01  Auto
Potion Property RestoreMagicka01  Auto
Potion Property RestoreStamina01  Auto
Weapon Property IronDagger  Auto
Weapon Property IronSword  Auto
Weapon Property IronWarAxe  Auto
Weapon Property LongBow  Auto
Book Property Book3ValuableDragonborn  Auto
MiscObject Property Gold001  Auto
MiscObject Property Lockpick  Auto
Light Property Torch01  Auto
MiscObject Property Lantern01 Auto
Ammo Property IronArrow  Auto/;

FormList property iEquip_AllCurrentItemsFLST auto
FormList property iEquip_RemovedItemsFLST auto
Formlist Property iEquip_LeftHandBlacklistFLST Auto
Formlist Property iEquip_RightHandBlacklistFLST Auto
Formlist Property iEquip_GeneralBlacklistFLST Auto ;Shout, Consumable and Poison Queues
FormList property iEquip_AmmoBlacklistFLST auto

FormList property DLC2DRAllowedSpells auto

FormList[] aBlacklistFLSTs
string[] asBlacklistNames

Keyword property MagicDamageFire auto
Keyword property MagicDamageFrost auto
Keyword property MagicDamageShock auto
Keyword property MagicCloak auto

SoundCategory _audioCategoryUI						; Used to mute equip sound when cycling shouts/powers

GlobalVariable Property iEquip_SlowTimeStrength Auto
Spell property iEquip_SlowTimeSpell auto

; Requiem
bool property bIsRequiemLoaded auto hidden
Keyword REQ_KW_PoisonSpell

; Archery Gameplay Overhaul
bool property bIsAGOLoaded auto hidden

; Legacy of the Dragonborn
bool property bIsLOTDLoaded auto hidden

; Ordinator
bool bIsOrdinatorLoaded

; Adamant
bool bIsAdamantLoaded

; Zim's Immersive Artifacts support
bool bIsZIALoaded
weapon[] aZIAAltUniques
string[] asZIAIconNames

; Animated Armoury support
Bool bIsAALoaded
Keyword property WeapTypePike auto hidden
Keyword property WeapTypeHalberd auto hidden
Keyword property WeapTypeQtrStaff auto hidden

; Arrays used by queue functions
int[] property aiCurrentQueuePosition auto hidden 	; Array containing the current index for each queue
string[] property asCurrentlyEquipped auto hidden 	; Array containing the itemName for whatever is currently equipped in each queue
int[] property aiCurrentlyPreselected auto hidden 	; Array containing current preselect queue positions

; Widget Properties
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
bool bIsFirstEnabled = true
bool property bAddingItemsOnFirstEnable auto hidden
bool bIsFirstInventoryMenu = true
bool bIsFirstMagicMenu = true
bool bIsFirstFailedToAdd = true
bool property bShowTooltips = true auto hidden
bool property bShowQueueConfirmationMessages = true auto hidden
bool property bRefreshingWidget auto hidden
bool property bUpdateKeyMaps auto hidden
bool property bMCMPresetLoaded auto hidden

; Ammo Mode properties and variables
bool property bAmmoMode auto hidden
bool bJustLeftAmmoMode
bool bAmmoModeFirstLook = true

; Auto Unequip Ammo
bool property bUnequipAmmo auto hidden

; Geared Up properties and variables
bool property bEnableGearedUp auto hidden
Form boots

float property fEquipOnPauseDelay = 1.6 auto hidden

bool property bPotionGrouping = true auto hidden
int property iPotionSelectorChoice auto hidden
float property fPotionSelectorFadeoutDelay = 3.0 auto hidden

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

bool property bAllowWeaponSwitchHands auto hidden
bool property bAllowSingleItemsInBothQueues auto hidden
bool property bEnableRemovedItemCaching = true auto hidden
int property iMaxCachedItems = 60 auto hidden
bool property bBlacklistEnabled auto hidden

int property iCurrentWidgetFadeoutChoice
	int function Get()
		if fWidgetFadeoutDuration == 3.0
			return 0
		elseIf fWidgetFadeoutDuration == 1.5
			return 1
		elseIf fWidgetFadeoutDuration == 0.5
			return 2
		else
			return 3
		endIf
	endFunction
	
	function Set(int iChoice)
		if iChoice == 0
			fWidgetFadeoutDuration = 3.0 ;Slow
		elseIf iChoice == 1
			fWidgetFadeoutDuration = 1.5 ;Normal
		elseIf iChoice == 2
			fWidgetFadeoutDuration = 0.5 ;Fast
		endIf
	endFunction
endProperty

float property fWidgetFadeoutDelay = 20.0 auto hidden
float property fWidgetFadeoutDuration = 1.5 auto hidden
bool property bAlwaysVisibleWhenWeaponsDrawn = true auto hidden
bool property bIsWidgetShown auto hidden
bool bFadingWidget
bool bFadeRequestQueued

int property iCurrentNameFadeoutChoice
	int function Get()
		if fNameFadeoutDuration == 3.0
			return 0
		elseIf fNameFadeoutDuration == 1.5
			return 1
		elseIf fNameFadeoutDuration == 0.5
			return 2
		else
			return 3
		endIf
	endFunction
	
	function Set(int iChoice)
		if iChoice == 0
			fNameFadeoutDuration = 3.0 ;Slow
		elseIf iChoice == 1
			fNameFadeoutDuration = 1.5 ;Normal
		elseIf iChoice == 2
			fNameFadeoutDuration = 0.5 ;Fast
		endIf
	endFunction
endProperty

float property fMainNameFadeoutDelay = 5.0 auto hidden
float property fPoisonNameFadeoutDelay = 5.0 auto hidden
float property fPreselectNameFadeoutDelay = 5.0 auto hidden
float property fNameFadeoutDuration = 1.5 auto hidden

bool property bBackgroundStyleChanged auto hidden
bool property bDontFadeBackgrounds auto hidden
bool property bFadeLeftIcon = true auto hidden
float property fLeftIconFadeAmount = 70.0 auto hidden
bool property bTemperDisplaySettingChanged auto hidden

bool property bDropShadowEnabled = true auto hidden
bool property bDropShadowSettingChanged auto hidden
float property fDropShadowAlpha = 0.85 auto hidden
float property fDropShadowAngle = 105.0 auto hidden
int property iDropShadowBlur = 2 auto hidden
float property fDropShadowDistance = 1.0 auto hidden
float property fDropShadowStrength = 4.0 auto hidden

bool[] property abPotionGroupAddedBack auto hidden
bool property bPotionGroupingOptionsChanged auto hidden
bool property bRestorePotionWarningSettingChanged auto hidden

int property iPoisonFX = 3 auto hidden
bool property bAllowPoisonSwitching = true auto hidden
bool property bAllowPoisonTopUp = true auto hidden
int property iPoisonChargeMultiplier = 2 auto hidden
int property iPoisonChargesPerVial = 1 auto hidden
int property iShowPoisonMessages auto hidden
int property iPoisonIndicatorStyle = 1 auto hidden
bool property bPoisonIndicatorStyleChanged auto hidden
bool property bBeastModeOptionsChanged auto hidden
bool property bThrowingPoisonsDisabled auto hidden
bool property bThrowingPoisonsHandChanged auto hidden

int property iPosInd = 1 auto hidden
int property iPositionIndicatorColor = 0xFFFFFF auto hidden
float property fPositionIndicatorAlpha = 100.0 auto hidden
int property iCurrPositionIndicatorColor = 0xCCCCCC auto hidden
float property fCurrPositionIndicatorAlpha = 100.0 auto hidden
bool property bPositionIndicatorSettingsChanged auto hidden
bool[] property abCyclingQueue auto hidden

bool property bShowAttributeIcons = true auto hidden
bool property bAttributeIconsOptionChanged auto hidden

int[] property aiTargetQ auto hidden
string[] asQueueName
bool[] property abQueueWasEmpty auto hidden

EquipSlot[] property EquipSlots auto hidden

string[] asItemNames
string[] asWeaponTypeNames
int[] property ai2HWeaponTypes auto hidden
int[] property ai2HWeaponTypesAlt auto hidden

int property iQueueMenuCurrentQueue = -1 auto hidden
int iQueueMenuCurrentArray = -1
bool property bFirstAttemptToClearAmmoQueue = true auto hidden
bool bFirstAttemptToEditAmmoQueue = true
bool bFirstAttemptToRemoveAmmo = true
bool bFirstAttemptToDeletePotionGroup = true
bool bJustUsedQueueMenuDirectAccess
bool property bBlacklistMenuShown auto hidden
form[] afCurrentBlacklistForms
string[] asAmmoSorting

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
bool property bLeftRightNameFadeEnabled = true auto hidden
bool property bShoutNameFadeEnabled = true auto hidden
bool property bConsPoisNameFadeEnabled = true auto hidden
bool[] property abIsNameShown auto hidden
int[] property aiNameElements auto hidden
int[] property aiIconClips auto hidden
bool property bFirstPressShowsName = true auto hidden

bool[] property abIsPoisonNameShown auto hidden
int[] property aiPoisonNameElements auto hidden
bool[] property abPoisonInfoDisplayed auto hidden

bool[] property abPotionGroupEnabled auto hidden
string[] asPotionGroups
string[] asActorValues
int[] aiActorValues
bool[] property abPotionGroupEmpty auto hidden
float property fconsIconFadeAmount = 70.0 auto hidden
bool property bConsumableIconFaded auto hidden
bool property bPotionSelectorShown auto hidden
int property iPotionTypeChoice auto hidden

bool property bPoisonIconFaded auto hidden

bool property bBlockSwitchBackToBoundSpell auto hidden

bool property bMoreHUDLoaded auto hidden
string[] property asMoreHUDIcons auto hidden

bool property bPowerOfThreeExtenderLoaded auto hidden

bool property bIsCGOLoaded auto hidden

bool bIsItemDurabilityLoaded

int iRemovedItemsCacheObj
int property iRefHandleArray auto hidden
int property iEquipQHolderObj auto hidden

bool bReverse
bool bWaitingForEquipOnPauseUpdate
bool property bCyclingLHPreselectInAmmoMode auto hidden

bool bSwitchingHands
bool property bPreselectSwitchingHands auto hidden
bool bSkipOtherHandCheck
bool property bGoneUnarmed auto hidden
bool property b2HSpellEquipped auto hidden
bool property bJustDroppedTorch auto hidden
int property iLastRH1HItemIndex = -1 auto hidden

bool property bEquipOnPause = true auto hidden
bool property bSlowTimeWhileCycling auto Hidden
int property iCycleSlowTimeStrength = 50 auto hidden
bool property bSkipRHUnarmedInCombat auto hidden

bool bGPPMessageShown

bool property bPlayerIsMounted auto hidden
bool property bDragonRiding auto hidden

string function GetWidgetType()
	Return "iEquip_WidgetCore"
endFunction

string function GetWidgetSource()
	Return "iEquip/iEquipWidget.swf"
endFunction

string property WidgetPresetPath = "Data/iEquip/Widget Presets/" autoReadonly
string property MCMSettingsPath = "Data/iEquip/MCM Settings/" autoReadOnly
string property FileExtDef = ".IEQD" autoReadOnly
string property FileExt = ".IEQP" autoReadonly

; ###############################
; ### Initialization & Checks ###

Event OnWidgetInit()
	;debug.trace("iEquip_WidgetCore OnWidgetInit start - current state: " + GetState())
	PopulateWidgetArrays()
	
	iCurrentWidgetFadeoutChoice = 1
	iCurrentNameFadeoutChoice = 1
	iPosInd = 1

	abIsNameShown = new bool[8]
	aiTargetQ = new int[5]
	aiCurrentQueuePosition = new int[5] ; Array containing the current index for each queue - left, right, shout, potion, poison, arrow, bolt
	asCurrentlyEquipped = new string[5] ; Array containing the itemName for whatever is currently equipped in each queue
	aiCurrentlyPreselected = new int[3] ; Array containing current preselect queue positions
	abQueueWasEmpty = new bool[5]
	abPotionGroupEmpty = new bool[3]
	abIsCounterShown = new bool[5]
	abIsPoisonNameShown = new bool[2]
	abPoisonInfoDisplayed = new bool[2]
	abQuickDualCastSchoolAllowed = new bool[5]
	abPotionGroupEnabled = new bool[3]
	abPotionGroupAddedBack = new bool[3]
	abCyclingQueue = new bool[3]
	
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

	asQueueName = new string[7]
	asQueueName[0] = "$iEquip_WC_common_leftQ"
	asQueueName[1] = "$iEquip_WC_common_rightQ"
	asQueueName[2] = "$iEquip_WC_common_shoutQ"
	asQueueName[3] = "$iEquip_WC_common_consQ"
	asQueueName[4] = "$iEquip_WC_common_poisonQ"
	asQueueName[5] = "$iEquip_WC_common_arrowQ"
	asQueueName[6] = "$iEquip_WC_common_boltQ"

	aiNameElements = new int[8]
	aiNameElements[0] = 8 	; leftName_mc
	aiNameElements[1] = 25 	; rightName_mc
	aiNameElements[2] = 42 	; shoutName_mc
	aiNameElements[3] = 49 	; consumableName_mc
	aiNameElements[4] = 54 	; poisonName_mc
	aiNameElements[5] = 20 	; leftPreselectName_mc
	aiNameElements[6] = 37 	; rightPreselectName_mc
	aiNameElements[7] = 46 	; shoutPreselectName_mc

	aiIconClips = new int[8]
	aiIconClips[0] = 7 		; leftIcon_mc
	aiIconClips[1] = 24 	; rightIcon_mc
	aiIconClips[2] = 41 	; shoutIcon_mc
	aiIconClips[3] = 48 	; consumableIcon_mc
	aiIconClips[4] = 53 	; poisonIcon_mc
	aiIconClips[5] = 19 	; leftPreselectIcon_mc
	aiIconClips[6] = 36 	; rightPreselectIcon_mc
	aiIconClips[7] = 45 	; shoutPreselectIcon_mc

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

	ai2HWeaponTypes = new int[4] 				; For use with weapon.GetWeaponType()
	ai2HWeaponTypes[0] = 5 ; Greatsword
	ai2HWeaponTypes[1] = 6 ; Waraxe/Warhammer
	ai2HWeaponTypes[2] = 7 ; Bow
	ai2HWeaponTypes[3] = 9 ; Crossbow

	ai2HWeaponTypesAlt = new int[4]				; For use with GetEquippedItemType()
	ai2HWeaponTypesAlt[0] = 5 	; Greatsword
	ai2HWeaponTypesAlt[1] = 6 	; Waraxe/Warhammer
	ai2HWeaponTypesAlt[2] = 7 	; Bow
	ai2HWeaponTypesAlt[3] = 12 	; Crossbow

	aiCounterClips = new int[5]
	aiCounterClips[0] = 9 	; leftCount_mc
	aiCounterClips[1] = 26 	; rightCount_mc
	aiCounterClips[2] = -1 	; No shout count
	aiCounterClips[3] = 50 	; consumableCount_mc
	aiCounterClips[4] = 55 	; poisonCount_mc

	aiPoisonNameElements = new int[2]
	aiPoisonNameElements[0] = 11 ; leftPoisonName_mc
	aiPoisonNameElements[1] = 28 ; rightPoisonName_mc

	asPotionGroups = new string[3]
	asPotionGroups[0] = "$iEquip_common_HealthPotions"
	asPotionGroups[1] = "$iEquip_common_MagickaPotions"
	asPotionGroups[2] = "$iEquip_common_StaminaPotions"

	asMoreHUDIcons = new string[4]
	asMoreHUDIcons[0] = "iEquipQL.png" 	; Left
	asMoreHUDIcons[1] = "iEquipQR.png" 	; Right
	asMoreHUDIcons[2] = "iEquipQ.png" 	; Q - for shout/consumable/poison queues
	asMoreHUDIcons[3] = "iEquipQB.png" 	; Both - for items in both left and right queues

	EquipSlots = new EquipSlot[5]
	EquipSlots[0] = Game.GetForm(0x00013F42) As EquipSlot ; LeftHand
	EquipSlots[1] = Game.GetForm(0x00013F43) As EquipSlot ; RightHand
	EquipSlots[2] = Game.GetForm(0x00013F44) As EquipSlot ; EitherHand
	EquipSlots[3] = Game.GetForm(0x00013F45) As EquipSlot ; BothHands
	EquipSlots[4] = Game.GetForm(0x00025BEE) As EquipSlot ; Voice

	_audioCategoryUI = Game.GetFormFromFile(0x00064451, "Skyrim.esm") as SoundCategory

	asActorValues = new string[3]
    asActorValues[0] = "Health"
    asActorValues[1] = "Magicka"
    asActorValues[2] = "Stamina"

    aiActorValues = new int[3]
    aiActorValues[0] = 24 ; Health
    aiActorValues[1] = 25 ; Magicka
    aiActorValues[2] = 26 ; Stamina

    aUniqueItems = new Weapon[50]
    aUniqueItems[0] = DBAlainAegisbane
	aUniqueItems[1] = DA02Dagger
	aUniqueItems[2] = TG07Chillrend001
	aUniqueItems[3] = TG07Chillrend002
	aUniqueItems[4] = TG07Chillrend003
	aUniqueItems[5] = TG07Chillrend004
	aUniqueItems[6] = TG07Chillrend005
	aUniqueItems[7] = TG07Chillrend006
	aUniqueItems[8] = DA09Dawnbreaker
	aUniqueItems[9] = MG07DraugrMagicSword
	aUniqueItems[10] = dunFolgunthurMikrulSword02
	aUniqueItems[11] = dunFolgunthurMikrulSword03
	aUniqueItems[12] = dunFolgunthurMikrulSword04
	aUniqueItems[13] = dunFolgunthurMikrulSword05
	aUniqueItems[14] = dunFolgunthurMikrulSword06
	aUniqueItems[15] = dunAnsilvundGhostblade
	aUniqueItems[16] = FFRiften09Grimsever
	aUniqueItems[17] = MGRKeening
	aUniqueItems[18] = DA10MaceofMolagBal
	aUniqueItems[19] = DA07MehrunesRazor
	aUniqueItems[20] = T03Nettlebane
	aUniqueItems[21] = NightingaleBlade01
	aUniqueItems[22] = NightingaleBlade02
	aUniqueItems[23] = NightingaleBlade03
	aUniqueItems[24] = NightingaleBlade04
	aUniqueItems[25] = NightingaleBlade05
	aUniqueItems[26] = NightingaleBladeNPC
	aUniqueItems[27] = dunVolunruudPickaxe
	aUniqueItems[28] = dunVolunruudOkin
	aUniqueItems[29] = weapPickaxe
	aUniqueItems[30] = dunRedEagleSwordBase
	aUniqueItems[31] = dunRedEagleSwordUpgraded
	aUniqueItems[32] = DA03RuefulAxe
	aUniqueItems[33] = DA06Volendrung
	aUniqueItems[34] = dunKatariahScimitar
	aUniqueItems[35] = Axe01
	aUniqueItems[36] = dunHaltedStreamPoachersAxe
	aUniqueItems[37] = C06BladeOfYsgramor

	asUniqueItemIcons = new string[50]
    asUniqueItemIcons[0] = "Aegisbane"
	asUniqueItemIcons[1] = "BladeOfSacrifice"
	asUniqueItemIcons[2] = "Chillrend"
	asUniqueItemIcons[3] = "Chillrend"
	asUniqueItemIcons[4] = "Chillrend"
	asUniqueItemIcons[5] = "Chillrend"
	asUniqueItemIcons[6] = "Chillrend"
	asUniqueItemIcons[7] = "Chillrend"
	asUniqueItemIcons[8] = "Dawnbreaker"
	asUniqueItemIcons[9] = "DrainheartSword"
	asUniqueItemIcons[10] = "GauldurBlackBlade"
	asUniqueItemIcons[11] = "GauldurBlackBlade"
	asUniqueItemIcons[12] = "GauldurBlackBlade"
	asUniqueItemIcons[13] = "GauldurBlackBlade"
	asUniqueItemIcons[14] = "GauldurBlackBlade"
	asUniqueItemIcons[15] = "Ghostblade"
	asUniqueItemIcons[16] = "Grimsever"
	asUniqueItemIcons[17] = "Keening"
	asUniqueItemIcons[18] = "MaceofMolagBal"
	asUniqueItemIcons[19] = "MehrunesRazor"
	asUniqueItemIcons[20] = "Nettlebane"
	asUniqueItemIcons[21] = "NightingaleBlade"
	asUniqueItemIcons[22] = "NightingaleBlade"
	asUniqueItemIcons[23] = "NightingaleBlade"
	asUniqueItemIcons[24] = "NightingaleBlade"
	asUniqueItemIcons[25] = "NightingaleBlade"
	asUniqueItemIcons[26] = "NightingaleBlade"
	asUniqueItemIcons[27] = "NotchedPickaxe"
	asUniqueItemIcons[28] = "Okin"
	asUniqueItemIcons[29] = "Pickaxe"
	asUniqueItemIcons[30] = "RedEaglesBane"
	asUniqueItemIcons[31] = "RedEaglesFury"
	asUniqueItemIcons[32] = "RuefulAxe"
	asUniqueItemIcons[33] = "Volendrung"
	asUniqueItemIcons[34] = "Windshear"
	asUniqueItemIcons[35] = "WoodcuttersAxe"
	asUniqueItemIcons[36] = "WoodcuttersAxe"
	asUniqueItemIcons[37] = "Wuuthrad"
	asUniqueItemIcons[38] = "AurielsBow"
	asUniqueItemIcons[39] = "HarkonsSword"
	asUniqueItemIcons[40] = "RuneHammer"
	asUniqueItemIcons[41] = "Zephyr"
	asUniqueItemIcons[42] = "WoodenSword"
	asUniqueItemIcons[43] = "AncientNordicPickaxe"
	asUniqueItemIcons[44] = "AncientNordicPickaxe"
	asUniqueItemIcons[45] = "BloodskaalBlade"
	asUniqueItemIcons[46] = "ChampionsCudgel"
	asUniqueItemIcons[47] = "MiraaksSword"
	asUniqueItemIcons[48] = "MiraaksSword"
	asUniqueItemIcons[49] = "MiraaksSword"

	aZIAAltUniques = new weapon[3]

	asZIAIconNames = new string[3]
	asZIAIconNames[0] = "Dawnbreaker"
	asZIAIconNames[1] = "Wuuthrad"
	asZIAIconNames[2] = "Volendrung"

	aBlacklistFLSTs = new formlist[7]
	aBlacklistFLSTs[0] = iEquip_LeftHandBlacklistFLST
	aBlacklistFLSTs[1] = iEquip_RightHandBlacklistFLST
	aBlacklistFLSTs[2] = iEquip_GeneralBlacklistFLST
	aBlacklistFLSTs[3] = iEquip_GeneralBlacklistFLST
	aBlacklistFLSTs[4] = iEquip_GeneralBlacklistFLST
	aBlacklistFLSTs[5] = iEquip_AmmoBlacklistFLST
	aBlacklistFLSTs[6] = iEquip_AmmoBlacklistFLST

	asBlacklistNames = new string[7]
	asBlacklistNames[0] = "$iEquip_WC_common_leftBlacklist"
	asBlacklistNames[1] = "$iEquip_WC_common_rightBlacklist"
	asBlacklistNames[2] = "$iEquip_WC_common_generalBlacklist"
	asBlacklistNames[3] = "$iEquip_WC_common_generalBlacklist"
	asBlacklistNames[4] = "$iEquip_WC_common_generalBlacklist"
	asBlacklistNames[5] = "$iEquip_WC_common_ammoBlacklist"
	asBlacklistNames[6] = "$iEquip_WC_common_ammoBlacklist"

	asAmmoSorting = new string[4]
	asAmmoSorting[0] = "$iEquip_WC_ammoSorting_manually"
	asAmmoSorting[1] = "$iEquip_WC_ammoSorting_byDamage"
	asAmmoSorting[2] = "$iEquip_WC_ammoSorting_alphabetically"
	asAmmoSorting[3] = "$iEquip_WC_ammoSorting_byQuantity"

	;debug.trace("iEquip_WidgetCore OnWidgetInit end")
EndEvent

; #######################
; ### Version Control ###

float fCurrentVersion						; First digit = Main version, 2nd digit = Incremental, 3rd digit = Hotfix.  For example main version 1.0, hotfix 03 would be 1.03

float function getiEquipVersion()
    return 1.50
endFunction

function checkVersion()

    float fThisVersion = getiEquipVersion()

    ;debug.trace("iEquip_WidgetCore checkVersion start, fCurrentVersion: " + fCurrentVersion + ", fThisVersion: " + fThisVersion + ", bIsFirstEnabled: " + bIsFirstEnabled)
    
    if fThisVersion < fCurrentVersion
    	;debug.trace("iEquip_WidgetCore checkVersion - older version")
        Debug.MessageBox("$iEquip_wc_msg_oldVersion")
    elseIf fThisVersion == fCurrentVersion
    	;debug.trace("iEquip_WidgetCore checkVersion - same version")
        ; Already latest version
    elseIf !bIsFirstEnabled
    	;debug.trace("iEquip_WidgetCore checkVersion - should be updating now")
        ; Let's update
        if fCurrentVersion < 1.23
        	aZIAAltUniques = new weapon[3]

			asZIAIconNames = new string[3]
			asZIAIconNames[0] = "Dawnbreaker"
			asZIAIconNames[1] = "Wuuthrad"
			asZIAIconNames[2] = "Volendrung"
		endIf

        if fCurrentVersion < 1.22		
        ; We're updating to the newer refHandle manager for the first time so we need to clear all existing handles in the queue objects and in iEquipUtil, then parse the inventory again to assign new handles under the new manager. 
        ; The queue objects will be updated with the newly assigned handles when each item is next equipped, other than any currently equipped items which will be updated during this initial process.
        	outWithTheOldInWithTheNew()
        endIf
        
        if fCurrentVersion < 1.1

			asQueueName = new string[7]
			asQueueName[0] = "$iEquip_WC_common_leftQ"
			asQueueName[1] = "$iEquip_WC_common_rightQ"
			asQueueName[2] = "$iEquip_WC_common_shoutQ"
			asQueueName[3] = "$iEquip_WC_common_consQ"
			asQueueName[4] = "$iEquip_WC_common_poisonQ"
			asQueueName[5] = "$iEquip_WC_common_arrowQ"
			asQueueName[6] = "$iEquip_WC_common_boltQ"

			aBlacklistFLSTs = new formlist[7]
			aBlacklistFLSTs[0] = iEquip_LeftHandBlacklistFLST
			aBlacklistFLSTs[1] = iEquip_RightHandBlacklistFLST
			aBlacklistFLSTs[2] = iEquip_GeneralBlacklistFLST
			aBlacklistFLSTs[3] = iEquip_GeneralBlacklistFLST
			aBlacklistFLSTs[4] = iEquip_GeneralBlacklistFLST
			aBlacklistFLSTs[5] = iEquip_AmmoBlacklistFLST
			aBlacklistFLSTs[6] = iEquip_AmmoBlacklistFLST

			asBlacklistNames = new string[7]
			asBlacklistNames[0] = "$iEquip_WC_common_leftBlacklist"
			asBlacklistNames[1] = "$iEquip_WC_common_rightBlacklist"
			asBlacklistNames[2] = "$iEquip_WC_common_generalBlacklist"
			asBlacklistNames[3] = "$iEquip_WC_common_generalBlacklist"
			asBlacklistNames[4] = "$iEquip_WC_common_generalBlacklist"
			asBlacklistNames[5] = "$iEquip_WC_common_ammoBlacklist"
			asBlacklistNames[6] = "$iEquip_WC_common_ammoBlacklist"

			asAmmoSorting = new string[4]
			asAmmoSorting[0] = "$iEquip_WC_ammoSorting_manually"
			asAmmoSorting[1] = "$iEquip_WC_ammoSorting_byDamage"
			asAmmoSorting[2] = "$iEquip_WC_ammoSorting_alphabetically"
			asAmmoSorting[3] = "$iEquip_WC_ammoSorting_byQuantity"

			self.RegisterForMenu("Crafting Menu")
			self.RegisterForMenu("Dialogue Menu")
			self.RegisterForMenu("BarterMenu")
        endIf

        if fCurrentVersion < 1.21

        	bFadeLeftIcon = bFadeLeftIconWhen2HEquipped

        	if iPoisonChargeMultiplier < 2
        		iPoisonChargeMultiplier = 2		; Should have been 2 by default (Concentrated Poison perk multiplier)
        	endIf

        	aiNameElements = new int[8]
			aiNameElements[0] = 8 	; leftName_mc
			aiNameElements[1] = 25 	; rightName_mc
			aiNameElements[2] = 42 	; shoutName_mc
			aiNameElements[3] = 49 	; consumableName_mc
			aiNameElements[4] = 54 	; poisonName_mc
			aiNameElements[5] = 20 	; leftPreselectName_mc
			aiNameElements[6] = 37 	; rightPreselectName_mc
			aiNameElements[7] = 46 	; shoutPreselectName_mc

			aiIconClips = new int[8]
			aiIconClips[0] = 7 		; leftIcon_mc
			aiIconClips[1] = 24 	; rightIcon_mc
			aiIconClips[2] = 41 	; shoutIcon_mc
			aiIconClips[3] = 48 	; consumableIcon_mc
			aiIconClips[4] = 53 	; poisonIcon_mc
			aiIconClips[5] = 19 	; leftPreselectIcon_mc
			aiIconClips[6] = 36 	; rightPreselectIcon_mc
			aiIconClips[7] = 45 	; shoutPreselectIcon_mc

			aiCounterClips[1] = 26 	; rightCount_mc
			aiCounterClips[3] = 50 	; consumableCount_mc
			aiCounterClips[4] = 55 	; poisonCount_mc

			aiPoisonNameElements[1] = 28 ; rightPoisonName_mc

			if asWidgetElements.Length < 56		; This is only here to ensure the array update doesn't run a second time, only relevant for beta testers with previous iterations of 1.2
				updateWidgetArrays()
			endIf

			EM.onVersionUpdate()
			TI.onVersionUpdate()
        	PM.onVersionUpdate()

        	; Geared Up has been removed in 1.2 so if currently enabled turn it off now
        	if bEnableGearedUp
        		bEnableGearedUp = false
        		Utility.SetINIbool("bDisableGearedUp:General", True)
				refreshVisibleItems()
			endIf
        endIf

        if fCurrentVersion < 1.5
        	PO.onVersionUpdate(fCurrentVersion)
        	RC.onVersionUpdate(fCurrentVersion)
        	handleAutoAddedItems()
        endIf

        Utility.Wait(3.0)									; Just to make sure the notification hasn't been and gone before you're fully loaded in
        debug.notification("$iEquip_wc_not_updating")		; Remember to change the version number in the strings files
    endIf
    fCurrentVersion = fThisVersion
    ;debug.trace("iEquip_WidgetCore checkVersion end")
endFunction

function outWithTheOldInWithTheNew()
	;debug.trace("iEquip_WidgetCore outWithTheOldInWithTheNew start")

	; First we need to iterate through the left and right hand queues and invalidate all currently stored refHandles by setting them all to 0xFFFF
	int Q
	int targetArray
	int targetObject
	int i
	while Q < 3
		targetArray = aiTargetQ[Q]
		while i < JArray.count(targetArray)
			if Q == 2
				jMap.removeKey(jArray.GetObj(targetArray, i), "iEquipHandle")	; Cleaning up
			else
				targetObject = jArray.GetObj(targetArray, i)
				if jMap.getForm(targetObject, "iEquipForm") as Weapon || jMap.getForm(targetObject, "iEquipForm") as Armor
					jMap.setInt(targetObject, "iEquipHandle", 0xFFFF)
				else
					jMap.removeKey(targetObject, "iEquipHandle")	; Cleaning up
				endIf
			endIf
			i += 1
		endWhile
		i = 0
		Q += 1
	endWhile

	; Next we need to wipe the papyrus refHandle array
	JArray.clear(iRefHandleArray)

	; Now we tell iEquipUtil to do the same thing
	ClearAllRefHandles()

	; We can now re-run ParseInventory to generate and assign new refHandles under the new refHandle manager for all weapons and armor in the player inventory
	ParseInventory()

	; Finally we can grab the refHandles from any currently equipped left/right hand items and update those queue objects if they match what's currently shown in the widget.
	; The rest will be updated the next time they are each equipped
	Q = 0
	form equippedItem
	
	while Q < 2
		equippedItem = PlayerRef.GetEquippedObject(Q)
		targetObject = jArray.GetObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
		
		if equippedItem && (equippedItem as Weapon || equippedItem as Armor) && equippedItem == jMap.getForm(targetObject, "iEquipForm")

	        int itemHandle = getHandle(Q, jMap.getInt(targetObject, "iEquipType"), jMap.getForm(targetObject, "iEquipForm"))

			if itemHandle != 0xFFFF
				JArray.AddInt(iRefHandleArray, itemHandle)
				JArray.unique(iRefHandleArray)
				jMap.setInt(targetObject, "iEquipHandle", itemHandle)
			endIf
		endIf
		Q += 1
	endWhile

	;debug.trace("iEquip_WidgetCore outWithTheOldInWithTheNew end")
endFunction

function handleAutoAddedItems()
	;debug.trace("iEquip_WidgetCore handleAutoAddedItems start")
	int Q
	int targetArray
	int targetObject
	int i
	form equippedItem
	while Q < 3
		equippedItem = PlayerRef.GetEquippedObject(Q)
		targetArray = aiTargetQ[Q]
		while i < JArray.count(targetArray)
			targetObject = jArray.GetObj(targetArray, i)
			if jMap.getInt(targetObject, "iEquipAutoAdded") == 1
				if bSkipAutoAddedItems && (!equippedItem || equippedItem != jMap.getForm(targetObject, "iEquipForm")) 		; If updating from an earlier version and bSkipAutoAddedItems = true then no need to keep auto-added items in the queues so remove them (unless they're the currently equipped item)
					removeItemFromQueue(Q, i, true)
				else
					jMap.removeKey(targetObject, "iEquipAutoAdded") 														; If bSkipAutoAddedItems = false or the item is currently equipped then leave the items in the queue but remove the iEquipAutoAdded key
					i += 1
				endIf
			else 
				i += 1
			endIf
		endWhile
		i = 0
		Q += 1
	endWhile
	;debug.trace("iEquip_WidgetCore handleAutoAddedItems end")
endFunction

; #########################
; ### DLC & Mod Support ###

function CheckDependencies()

	 if Game.GetModByName("Dawnguard.esm") != 255
    	BM.arBeastRaces[1] = Game.GetFormFromFile(0x0000283A, "Dawnguard.esm") as Race 	; DLC1VampireBeastRace
		aUniqueItems[38] = Game.GetFormFromFile(0x00000800, "Dawnguard.esm") as Weapon 	; DLC1AurielsBow
		aUniqueItems[39] = Game.GetFormFromFile(0x000067CF, "Dawnguard.esm") as Weapon 	; DLC1HarkonsSword
		aUniqueItems[40] = Game.GetFormFromFile(0x00011BAD, "Dawnguard.esm") as Weapon 	; DLC1DawnguardRuneHammer
		aUniqueItems[41] = Game.GetFormFromFile(0x0000CFB6, "Dawnguard.esm") as Weapon 	; DLC1LD_KatriaBow - Zephyr
	else
		BM.arBeastRaces[1] = none
		aUniqueItems[38] = none
		aUniqueItems[39] = none
		aUniqueItems[40] = none
		aUniqueItems[41] = none
	endIf

	if Game.GetModByName("Hearthfires.esm") != 255
		aUniqueItems[42] = Game.GetFormFromFile(0x00004D91, "Hearthfires.esm") as Weapon 	; BYOHWoodenSword
	else
		aUniqueItems[42] = none
	endIf

	if Game.GetModByName("Dragonborn.esm") != 255
		aUniqueItems[43] = Game.GetFormFromFile(0x000206F2, "Dragonborn.esm") as Weapon 	; DLC2RR03NordPickaxe - Ancient Nordic Pickaxe
		aUniqueItems[44] = Game.GetFormFromFile(0x000398E6, "Dragonborn.esm") as Weapon 	; DLC2AncientNordPickaxe - Ancient Nordic Pickaxe
		aUniqueItems[45] = Game.GetFormFromFile(0x0001AEA4, "Dragonborn.esm") as Weapon 	; DLC2BloodskaalBlade
		aUniqueItems[46] = Game.GetFormFromFile(0x0001A578, "Dragonborn.esm") as Weapon 	; DLC2RR01FalxWarhammer - Champions Cudgel
		aUniqueItems[47] = Game.GetFormFromFile(0x000397F6, "Dragonborn.esm") as Weapon 	; DLC2MKMiraakSword1
		aUniqueItems[48] = Game.GetFormFromFile(0x00039FB1, "Dragonborn.esm") as Weapon 	; DLC2MKMiraakSword2
		aUniqueItems[49] = Game.GetFormFromFile(0x00039FB4, "Dragonborn.esm") as Weapon 	; DLC2MKMiraakSword3

		DLC2DRAllowedSpells = Game.GetFormFromFile(0x00033C8A, "Dragonborn.esm") as formlist
	else
		aUniqueItems[43] = none
		aUniqueItems[44] = none
		aUniqueItems[45] = none
		aUniqueItems[46] = none
		aUniqueItems[47] = none
		aUniqueItems[48] = none
		aUniqueItems[49] = none

		DLC2DRAllowedSpells = none
	endIf

	; moreHUD Inventory Edition
	bMoreHUDLoaded = SKSE.GetPluginVersion("Ahzaab's moreHUD Inventory Plugin") > 0
	if bMoreHUDLoaded
		initialisemoreHUDArray()
	endIf

	; po3's Papyrus Extender
	bPowerOfThreeExtenderLoaded = SKSE.GetPluginVersion("powerofthree's Papyrus Extender") > 0

	; Gamepad++
	KH.registerForGPP(Game.GetModByName("Gamepad++.esp") != 255)

	; ConsoleUtil
	bConsoleUtilLoaded = SKSE.GetPluginVersion("ConsoleUtilSSE") > 0
	
    ; Requiem
    bIsRequiemLoaded = Game.GetModByName("Requiem.esp") != 255
    RC.bIsRequiemLoaded = bIsRequiemLoaded
    if bIsRequiemLoaded
    	REQ_KW_PoisonSpell = Game.GetFormFromFile(0x00AD3904, "Requiem.esp") as Keyword
    else
    	REQ_KW_PoisonSpell = none
    endIf

    ; Legacy of the Dragonborn
    bIsLOTDLoaded = Game.GetModByName("LegacyoftheDragonborn.esm") != 255

    ; Archery Gameplay Overhaul
    bIsAGOLoaded = Game.GetModByName("DSerArcheryGameplayOverhaul.esp") != 255

    ; Combat Gameplay Overhaul
    bool isCGOLoaded = Game.GetModByName("DSerCombatGameplayOverhaul.esp") != 255
    if bIsCGOLoaded && !isCGOLoaded
    	remove2HWeaponsFromLeftQueue()
    endIf
    bIsCGOLoaded = isCGOLoaded

    ; Ordinator
    bIsOrdinatorLoaded = Game.GetModByName("Ordinator - Perks of Skyrim.esp") != 255

    ; Item Durability
    bIsItemDurabilityLoaded = JContainers.fileExistsAtPath("Data/NetScriptFramework/Plugins/ItemDurability.dll")
    EH.bIsItemDurabilityFound = bIsItemDurabilityLoaded

    ; Adamant
    bIsAdamantLoaded = Game.GetModByName("Adamant.esp") != 255

    ; Thunderchild
    EH.bIsThunderchildLoaded = Game.GetModByName("Thunderchild - Epic Shout Package.esp") != 255

    ; Wintersun
    EH.bIsWintersunLoaded = Game.GetModByName("Wintersun - Faiths of Skyrim.esp") != 255

    ; Zim's Immersive Artifacts
    if Game.GetModByName("ZIA_Complete Pack.esp") != 255
    	bIsZIALoaded = true
    	aZIAAltUniques[0] = Game.GetFormFromFile(0x00016AB0, "ZIA_Complete Pack.esp") as weapon 	; 2H Dawnbreaker
    	aZIAAltUniques[1] = Game.GetFormFromFile(0x00007EDC, "ZIA_Complete Pack.esp") as weapon 	; 1H Wuuthrad
    	aZIAAltUniques[2] = Game.GetFormFromFile(0x001E21CB, "ZIA_Complete Pack.esp") as weapon 	; 1H Volendrung
    else
    	bIsZIALoaded = false
    	aZIAAltUniques[0] = none
    	aZIAAltUniques[1] = none
    	aZIAAltUniques[2] = none
    endIf

	; Animated Armory
	if Game.GetModByName("NewArmoury.esp") != 255
        bIsAALoaded = true
        WeapTypePike = Game.GetFormFromFile(0x000E457E, "NewArmoury.esp") as Keyword
		WeapTypeHalberd = Game.GetFormFromFile(0x000E4580, "NewArmoury.esp") as Keyword
		WeapTypeQtrStaff = Game.GetFormFromFile(0x000E4581, "NewArmoury.esp") as Keyword
    else
        bIsAALoaded = false
        WeapTypePike = none
		WeapTypeHalberd = none
		WeapTypeQtrStaff = none
    endIf

	; Undeath
	if Game.GetModByName("Undeath.esp") != 255
		BM.arBeastRaces[2] = Game.GetFormFromFile(0x0001772A, "Undeath.esp") as Race 		; NecroLichRace
	else
		BM.arBeastRaces[2] = none
	endIf

	; The Path of Transcendence
	if Game.GetModByName("The Path of Transcendence.esp") != 255
		BM.bPOTLoaded = true
		BM.arPOTBoneTyrantRaces[0] = Game.GetFormFromFile(0x00038354, "The Path of Transcendence.esp") as Race 	; POT_ArgonianRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[1] = Game.GetFormFromFile(0x00038355, "The Path of Transcendence.esp") as Race 	; POT_BretonRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[2] = Game.GetFormFromFile(0x00038356, "The Path of Transcendence.esp") as Race 	; POT_DarkElfRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[3] = Game.GetFormFromFile(0x00038357, "The Path of Transcendence.esp") as Race 	; POT_ImperialRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[4] = Game.GetFormFromFile(0x00038358, "The Path of Transcendence.esp") as Race 	; POT_NordRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[5] = Game.GetFormFromFile(0x00038359, "The Path of Transcendence.esp") as Race 	; POT_HighElfRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[6] = Game.GetFormFromFile(0x0003835A, "The Path of Transcendence.esp") as Race 	; POT_KhajiitRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[7] = Game.GetFormFromFile(0x0003835B, "The Path of Transcendence.esp") as Race 	; POT_RedguardRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[8] = Game.GetFormFromFile(0x0003835C, "The Path of Transcendence.esp") as Race 	; POT_OrcRaceBoneTyrant
		BM.arPOTBoneTyrantRaces[9] = Game.GetFormFromFile(0x0003835D, "The Path of Transcendence.esp") as Race 	; POT_WoodElfRaceBoneTyrant
	else
		BM.bPOTLoaded = false
		BM.arPOTBoneTyrantRaces[0] = none
		BM.arPOTBoneTyrantRaces[1] = none
		BM.arPOTBoneTyrantRaces[2] = none
		BM.arPOTBoneTyrantRaces[3] = none
		BM.arPOTBoneTyrantRaces[4] = none
		BM.arPOTBoneTyrantRaces[5] = none
		BM.arPOTBoneTyrantRaces[6] = none
		BM.arPOTBoneTyrantRaces[7] = none
		BM.arPOTBoneTyrantRaces[8] = none
		BM.arPOTBoneTyrantRaces[9] = none
	endIf
endFunction

; ##########################
; ### ENABLING/DISABLING ###

bool property isEnabled
	bool function Get()
		Return bEnabled
	endFunction
	
	function Set(bool enabled)
		;debug.trace("iEquip_WidgetCore isEnabled Set start - enabled: " + enabled)
		if (Ready)
            bEnabled = enabled
            
			if bEnabled
				GoToState("ENABLED")
			else
				GoToState("DISABLED")
			endIf
		endIf
	endFunction
EndProperty

state ENABLED
	event OnBeginState()
		;debug.trace("iEquip_WidgetCore ENABLED OnBeginState start")

		if bIsFirstEnabled
			getAndStoreDefaultWidgetValues()
		endIf
		
		iEquip_InventoryExt.ParseInventory()	; This initialises the ref handles for the players inventory

		;debug.trace("iEquip_WidgetCore ENABLED OnBeginState - passed ParseInventory()")
		
		iEquipQHolderObj = JValue.retain(JMap.object())
		aiTargetQ[0] = JArray.object()
		JMap.setObj(iEquipQHolderObj, "leftQ", aiTargetQ[0])
		aiTargetQ[1] = JArray.object()
		JMap.setObj(iEquipQHolderObj, "rightQ", aiTargetQ[1])
		aiTargetQ[2] = JArray.object()
		JMap.setObj(iEquipQHolderObj, "shoutQ", aiTargetQ[2])
		aiTargetQ[3] = JArray.object()
		JMap.setObj(iEquipQHolderObj, "consumableQ", aiTargetQ[3])
		aiTargetQ[4] = JArray.object()
		JMap.setObj(iEquipQHolderObj, "poisonQ", aiTargetQ[4])
        AM.aiTargetQ[0] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "arrowQ", AM.aiTargetQ[0])
        AM.aiTargetQ[1] = JArray.object()
        JMap.setObj(iEquipQHolderObj, "boltQ", AM.aiTargetQ[1])
		iRemovedItemsCacheObj = JArray.object()
		JMap.setObj(iEquipQHolderObj, "lastRemovedCache", iRemovedItemsCacheObj)
		iRefHandleArray = JArray.object()
		JMap.setObj(iEquipQHolderObj, "refHandleArray", iRefHandleArray)
		
		PO.InitialisePotionQueueArrays(iEquipQHolderObj, aiTargetQ[3], aiTargetQ[4])
		addPotionGroups()
		EH.initialise(bEnabled)					; This then also initialises BeastMode, BoundWeaponEventsListener, PotionScript, and TemperedItemHandler
        AD.initialise(bEnabled)
		
		self.RegisterForMenu("InventoryMenu")
		self.RegisterForMenu("MagicMenu")
		self.RegisterForMenu("FavoritesMenu")
		self.RegisterForMenu("ContainerMenu")
		self.RegisterForMenu("Journal Menu")
		self.RegisterForMenu("Crafting Menu")
		self.RegisterForMenu("Dialogue Menu")
		self.RegisterForMenu("BarterMenu")
		
		UI.invoke(HUD_MENU, WidgetRoot + ".setWidgetToEmpty")
		CheckDependencies()
		addFists(0)
		addFists(1)

		if KH.bIsGPPLoaded && Game.UsingGamepad()
			checkAndSetKeysForGamepadPlusPlus()
		endIf

		OnWidgetLoad()
		
		bIsFirstEnabled = false
		
		iEquip_MessageQuest.Start()
		if bShowTooltips
			Utility.Wait(1.5)
			debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_addingItems"))
		endIf

		;debug.trace("iEquip_WidgetCore ENABLED OnBeginState end")
	endEvent

	; Enabled events
	Event OnWidgetLoad()
		;debug.trace("iEquip_WidgetCore OnWidgetLoad start - current state: " + GetState())

		checkVersion()

		;bPlayerIsMounted = PlayerRef.IsOnMount()

		bool bPreselectEnabledOnLoad = bPreselectMode

		EM.isEditMode = false
		bPreselectMode = false
		bRefreshingWidget = true
		bCyclingLHPreselectInAmmoMode = false
		bSwitchingHands = false
		bPreselectSwitchingHands = false
		bFadingWidget = false	; Note - this will release any queued fade requests, however as we have just set bRefreshingWidget = true those requests will immediately terminate clearing the way for the updateWidgetVisibility call later in this function
		PM.bBlockQuickDualCast = false
		KH.GameLoaded()
		PM.OnWidgetLoad()
		AM.OnWidgetLoad()
		CM.OnWidgetLoad()
		TP.OnWidgetLoad()
		
		OnWidgetReset()

		; Determine if the widget should be displayed
		UpdateWidgetModes()
		; Make sure to hide Edit Mode and bPreselectMode elements, leaving left shown if in bAmmoMode
		UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
		
		bool[] args = new bool[5]
		
		if !bIsFirstEnabled
			self.RegisterForMenu("InventoryMenu")
			self.RegisterForMenu("MagicMenu")
			self.RegisterForMenu("FavoritesMenu")
			self.RegisterForMenu("ContainerMenu")
			self.RegisterForMenu("Journal Menu")
			self.RegisterForMenu("Crafting Menu")
			self.RegisterForMenu("Dialogue Menu")
			self.RegisterForMenu("BarterMenu")

			CheckDependencies()
			if KH.bIsGPPLoaded && Game.UsingGamepad() && !bGPPMessageShown
				checkAndSetKeysForGamepadPlusPlus()
			endIf
			EM.UpdateElementsAll()
			args[0] = (bAmmoMode && !AM.bSimpleAmmoMode)
			args[3] = (bAmmoMode && !AM.bSimpleAmmoMode)
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			refreshWidgetOnLoad()
			EM.UpdateAllTextFormatting()
		else
			int i
			while i < 2
				CM.initChargeMeter(i)
				CM.initSoulGem(i)
				CM.initRadialMeter(i)
				i += 1
			endWhile
			addCurrentItemsOnFirstEnable()
			if bAmmoMode
				args[0] = true
			endIf
			args[3] = bAmmoMode
			initQueuePositionIndicators()
            updatePotionSelector(true) ; Hide the potion selector
			UI.invokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
			UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
			UI.setbool(HUD_MENU, WidgetRoot + ".EditModeGuide._visible", false)
			updateTextFieldDropShadow()
		endIf
		bRefreshingWidget = false
		
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 0)
		if CM.iChargeDisplayType > 0
			UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 0)
			UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 0)
			UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 0) ; SkyHUD alt charge meter
		else
			CM.updateChargeMeters() ; This will hide the iEquip charge meters if they are turned off in the MCM
		endIf
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", true)
		updateWidgetVisibility() ; Show the widget
		
		Utility.WaitMenuMode(0.5)
		
		if !EH.bPlayerIsABeast
			if bPlayerIsMounted && !PlayerRef.IsOnMount() 	; Just in case the player has dismounted on load before the widget has had a chance to initialise
				EH.applyMountedRestrictions(false)
			else
				checkAndFadeLeftIcon(1, jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipType"))
			endIf
		endIf

		if !PlayerRef.IsOnMount()
			bDragonRiding = false 							; Again, just to be safe! Just in case the player has dismounted on load before the widget has had a chance to initialise
		endIf

		if bPreselectEnabledOnLoad
			PM.togglePreselectMode(false, true)
		endIf

		KH.RegisterForGameplayKeys()
		debug.notification("$iEquip_WC_not_controlsUnlocked")
		
		;debug.trace("iEquip_WidgetCore OnWidgetLoad finished")
	endEvent

	Event OnWidgetReset()
		;debug.trace("iEquip_WidgetCore OnWidgetReset called")
		RequireExtend = false
		parent.OnWidgetReset()
		;debug.trace("iEquip_WidgetCore OnWidgetReset finished")
	EndEvent
endState

Auto state DISABLED
	event OnBeginState()
		jValue.release(iEquipQHolderObj)
		bIsFirstEnabled = true
		EH.initialise(bEnabled)
        AD.initialise(bEnabled)
	
		self.UnregisterForAllMenus()
		KH.UnregisterForAllKeys()
		
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ArrowInfoInstance._alpha", 100)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomLeftLockInstance._alpha", 100)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.BottomRightLockInstance._alpha", 100)
		UI.setFloat(HUD_MENU, "_root.HUDMovieBaseInstance.ChargeMeterBaseAlt._alpha", 100) ; SkyHUD alt charge meter
		
		if EM.isEditMode
			updateWidgetVisibility(false)
			Wait(0.2)
			EM.DisableEditMode()
		endIf
		
		iEquip_MessageQuest.Stop()
		updateWidgetVisibility()
		UI.setbool(HUD_MENU, WidgetRoot + "._visible", false)
	endEvent

	; Disabled Events
	event OnWidgetLoad()
	endEvent
	
	event OnWidgetReset()
	endEvent
endState

function checkAndSetKeysForGamepadPlusPlus()
	if showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_setDefaultKeysForGPP")) == 0
		KH.iLeftKey = 268						; Dpad Left
		KH.iEquipLeftKey.SetValueInt(268)
		KH.iRightKey = 269						; DPad Right
		KH.iEquipRightKey.SetValueInt(269)
		KH.iShoutKey = 266						; DPad Up
		KH.iEquipShoutKey.SetValueInt(266)
		KH.iConsumableKey = 267					; DPad Down
		KH.iEquipConsumableKey.SetValueInt(267)
		KH.iUtilityKey = 277					; B
		KH.iEquipUtilityKey.SetValueInt(277)
		SendModEvent("iEquip_KeysUpdated")
	endIf
	bGPPMessageShown = true
endFunction

function refreshWidgetOnLoad()
	;debug.trace("iEquip_WidgetCore refreshWidgetOnLoad start")
	
	bLeftIconFaded = false
	int Q
	int potionGroup = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipName"))
	UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
	updatePotionSelector(true) ; Hide the potion selectors
	if bDropShadowEnabled
		updateTextFieldDropShadow()
	else
		UI.InvokeBool(HUD_MENU, WidgetRoot + ".handleTextFieldDropShadow", true)
	endIf
	initQueuePositionIndicators()
	
	int count
	bool doneHere
	
	while Q < 8
		abIsNameShown[Q] = true
		if Q < 5
			count = jArray.count(aiTargetQ[Q])
			if Q < 3 && (count < 1 || !PlayerRef.GetEquippedObject(Q))
				setSlotToEmpty(Q, true, (count > 0))
			else
				if Q < 3 && iPosInd == 2
					updateQueuePositionIndicator(Q, count, aiCurrentQueuePosition[Q], aiCurrentQueuePosition[Q])
				endIf

				if Q < 2
					CM.initChargeMeter(Q)
					CM.initSoulGem(Q)
					CM.initRadialMeter(Q)

					if TP.bPoisonEquipped && Q == TP.iThrowingPoisonHand
						TP.updateWidget()
						doneHere = true
					endIf
				endIf

				if !doneHere
					if Q == 0 && bAmmoMode
						updateWidget(Q, AM.aiCurrentAmmoIndex[AM.Q])
					else
						updateWidget(Q, aiCurrentQueuePosition[Q])
					endIf
					if Q < 2
						checkAndUpdatePoisonInfo(Q)
						TI.checkAndUpdateTemperLevelInfo(Q)
						
						if abIsCounterShown[Q]
							if !abPoisonInfoDisplayed[Q]
								if Q == 0 && bAmmoMode
									setSlotCount(Q, PlayerRef.GetItemCount(AM.currentAmmoForm))
								else
									setSlotCount(Q, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipForm")))
								endIf
							endIf
						else
							setCounterVisibility(Q, false)
						endIf
					
					elseIf Q == 3 && potionGroup != -1
						count = PO.getPotionGroupCount(potionGroup)
						setSlotCount(3, count)
						if count < 1
							checkAndFadeConsumableIcon(true)
						elseIf bConsumableIconFaded
							checkAndFadeConsumableIcon(false)
						endIf
					elseIf Q == 4
						if count < 1
							handleEmptyPoisonQueue()
						else
							setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipForm")))
							if bPoisonIconFaded
								checkAndFadePoisonIcon(false)
							endIf
						endIf			
					endIf
				else
					doneHere = false
				endIf
			endIf
		else
			updateWidget(Q, aiCurrentlyPreselected[Q - 5])
		endIf
		Q += 1
	endwhile
	
	CM.updateChargeMeters(true)

	if PlayerRef.GetEquippedItemType(0) == 11 && TO.bShowTorchMeter		
		TO.showTorchMeter(true)
	endIf

	if EH.bPlayerIsABeast
		BM.onPlayerTransform(PlayerRef.GetRace(), EH.bPlayerIsAVampireOrLich, true)
	else
		updateSlotsEnabled()
	endIf
	
	;debug.trace("iEquip_WidgetCore refreshWidgetOnLoad end")
endFunction

;Called from EditMode when toggling back out
function resetWidgetsToPreviousState()
	;debug.trace("iEquip_WidgetCore resetWidgetsToPreviousState start")
    																	; Reset visiblity on all elements
	int i = asWidgetDescriptions.Length
	while i > 0
        i -= 1
		UI.SetBool(HUD_MENU, WidgetRoot + asWidgetElements[i] + "._visible", abWidget_V[i])
	endWhile

	i = 0
																		; Reset all names and reregister for fades if required
	while i < 8
		showName(i, true, false, 0.0)
		if i < 5
																		; Reset the counters
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
                														; Reset poison elements
				if !abPoisonInfoDisplayed[i]
					hidePoisonInfo(i, true)
				else
					checkAndUpdatePoisonInfo(i)
				endIf

				TI.updateTemperTierIndicator(i)

				if !(i == 0 && bAmmoMode) && (TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator)
					TI.checkAndUpdateTemperLevelInfo(i)
				endIf
																		; Reset attribute icons
				hideAttributeIcons(i)
            															; Handle empty shout,consumable and poison queues to ensure all temporary elements are removed
            elseIf jArray.count(aiTargetQ[i]) < 1
                if i < 4
                    setSlotToEmpty(i)
                else
                	handleEmptyPoisonQueue()
                endIf
            															; Check if there are any potion groups shown...
            elseIf i == 3 && jArray.count(aiTargetQ[i]) >= EM.iEnabledPotionGroupCount && asPotionGroups.Find(asCurrentlyEquipped[3]) > -1 && PO.getPotionGroupCount(asPotionGroups.Find(asCurrentlyEquipped[3])) == 0
                														; ...and handle fade if required
                checkAndFadeConsumableIcon(true)
            endIf
        endIf
    	i += 1
    endWhile
																		; Reset Preselect Mode
	PM.togglePreselectMode(true)

	if EM.preselectEnabledOnEnter
		Utility.WaitMenuMode(0.8)
        PM.togglePreselectMode()
		EM.preselectEnabledOnEnter = false
	endIf
																		; Reset enchantment meters and soulgems
	CM.updateChargeMeters(true)
																		; Update the torch meter if needed
	if PlayerRef.GetEquippedItemType(0) == 11 && TO.bShowTorchMeter
		TO.updateTorchMeterOnSettingsChanged()
	endIf

	;debug.trace("iEquip_WidgetCore resetWidgetsToPreviousState end")
endFunction

function initQueuePositionIndicators()
	;debug.trace("iEquip_WidgetCore initQueuePositionIndicators start")
	int i
	while i < 3
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initQueuePositionIndicator")
		If(iHandle)
			UICallback.PushInt(iHandle, i)
			UICallback.PushInt(iHandle, iPositionIndicatorColor)
			UICallback.PushFloat(iHandle, fPositionIndicatorAlpha)
			UICallback.PushInt(iHandle, iCurrPositionIndicatorColor)
			UICallback.PushFloat(iHandle, fCurrPositionIndicatorAlpha)
			UICallback.PushInt(iHandle, jArray.count(aiTargetQ[i]))
			UICallback.PushInt(iHandle, aiCurrentQueuePosition[i])
			UICallback.Send(iHandle)
		endIf
		i += 1
	endWhile
	;debug.trace("iEquip_WidgetCore initQueuePositionIndicators end")
endFunction

function initialisemoreHUDArray()
	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray start")

    int jItemIDs = jArray.object()
    int jIconNames = jArray.object()
    int Q
    
    while Q < 5
        int queueLength = JArray.count(aiTargetQ[Q])
        ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray processing Q: " + Q + ", queueLength: " + queueLength)
        int i
        
        while i < queueLength
        	;Clear out any empty indices for good measure
        	if !jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName")
        		jArray.eraseIndex(aiTargetQ[Q], i)
        		queueLength -= 1
        	endIf
        	;Make sure we skip the dummy Unarmed and Potion Group items
        	if Q < 2 || Q == 3
	        	bool isDummyItem = true
	        	while isDummyItem
	        		string itemName = jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName")
	        		if Q < 2
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
	            ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray Q: " + Q + ", i: " + i + ", itemID: " + itemID + ", " + jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName"))
	            if itemID == 0
	            	itemID = CalcCRC32Hash(jMap.getStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName"), Math.LogicalAND((jMap.getForm(jArray.getObj(aiTargetQ[Q], i), "iEquipForm").GetFormID()), 0x00FFFFFF))
	            	jMap.setInt(jArray.getObj(aiTargetQ[Q], i), "iEquipItemID", itemID)
	            endIf
	            if itemID as bool
		            int foundAt = -1
		            if !(i == 0 && Q == 0)
		            	foundAt = jArray.findInt(jItemIDs, itemID)
		            endIf
		            if Q == 1 && foundAt != -1
		            	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - itemID " + itemID + " already found at index " + foundAt + ", updating icon name to " + asMoreHUDIcons[3])
		                jArray.setStr(jIconNames, foundAt, asMoreHUDIcons[3])
		            else
		            	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding itemID " + itemID + " to jItemIDs")
		                jArray.addInt(jItemIDs, itemID)
		                if Q < 2
		                	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding " + asMoreHUDIcons[Q] + " to jIconNames")
		                	jArray.addStr(jIconNames, asMoreHUDIcons[Q])
		                else
		                	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - adding " + asMoreHUDIcons[2] + " to jIconNames")
		                	jArray.addStr(jIconNames, asMoreHUDIcons[2])
		                endIf
		            endIf
		        endIf
	            i += 1
	        endIf
        endWhile

        Q += 1
    endWhile
    ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - jItemIds contains " + jArray.count(jItemIDs) + " entries")
    ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - jIconNames contains " + jArray.count(jIconNames) + " entries")
    if jArray.count(jItemIDs) > 0
	    int[] itemIDs = utility.CreateIntArray(jArray.count(jItemIDs))
        string[] iconNames = utility.CreateStringArray(jArray.count(jIconNames))
	    jArray.writeToIntegerPArray(jItemIDs, itemIDs)
	    jArray.writeToStringPArray(jIconNames, iconNames)
	    ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - itemIDs contains " + itemIDs.Length + " entries with " + itemIDs[0] + " in index 0")
    	;debug.trace("iEquip_WidgetCore initialisemoreHUDArray - iconNames contains " + iconNames.Length + " entries with " + iconNames[0] + " in index 0")
	    AhzMoreHudIE.AddIconItems(itemIDs, iconNames)
	endIf
    PO.initialisemoreHUDArray()
    ;debug.trace("iEquip_WidgetCore initialisemoreHUDArray end")
endFunction

function addPotionGroups(int groupToAdd = -1)
	;debug.trace("iEquip_WidgetCore addPotionGroups start - groupToAdd: " + groupToAdd)
	int potionGroup
	
	if groupToAdd == -1 || (groupToAdd == 0 && !abPotionGroupEnabled[0])
		potionGroup = jMap.object()
		jMap.setInt(potionGroup, "iEquipType", 46)
		jMap.setStr(potionGroup, "iEquipName", "$iEquip_common_HealthPotions")
		jMap.setStr(potionGroup, "iEquipIcon", "HealthPotion")
		jArray.addObj(aiTargetQ[3], potionGroup)
		abPotionGroupEnabled[0] = true
	endIf
	if groupToAdd == -1 || (groupToAdd == 1 && !abPotionGroupEnabled[1])
		potionGroup = jMap.object()
		jMap.setInt(potionGroup, "iEquipType", 46)
		jMap.setStr(potionGroup, "iEquipName", "$iEquip_common_MagickaPotions")
		jMap.setStr(potionGroup, "iEquipIcon", "MagickaPotion")
		jArray.addObj(aiTargetQ[3], potionGroup)
		abPotionGroupEnabled[1] = true
	endIf
	if groupToAdd == -1 || (groupToAdd == 2 && !abPotionGroupEnabled[2])
		potionGroup = jMap.object()
		jMap.setInt(potionGroup, "iEquipType", 46)
		jMap.setStr(potionGroup, "iEquipName", "$iEquip_common_StaminaPotions")
		jMap.setStr(potionGroup, "iEquipIcon", "StaminaPotion")
		jArray.addObj(aiTargetQ[3], potionGroup)
		abPotionGroupEnabled[2] = true
	endIf
	;debug.trace("iEquip_WidgetCore addPotionGroups end")
endFunction

function removePotionGroups()
	;debug.trace("iEquip_WidgetCore removePotionGroups start")
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
			abPotionGroupEnabled[i] = false
		endIf
		i += 1
	endWhile
	;debug.trace("iEquip_WidgetCore removePotionGroups end")
endFunction

function addFists(int Q)
	;debug.trace("iEquip_WidgetCore addFists start")
	if findInQueue(Q, "$iEquip_common_Unarmed") == -1
		int Fists = jMap.object()
		jMap.setInt(Fists, "iEquipType", 0)
		jMap.setStr(Fists, "iEquipName", "$iEquip_common_Unarmed")
		jMap.setStr(Fists, "iEquipIcon", "Fist")
		jArray.addObj(aiTargetQ[Q], Fists)
	endIf
	;debug.trace("iEquip_WidgetCore addFists end")
endFunction

event OnMenuOpen(string _sCurrentMenu)
	;debug.trace("iEquip_WidgetCore OnMenuOpen start - current menu: " + _sCurrentMenu)
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
	;debug.trace("iEquip_WidgetCore OnMenuOpen end")
endEvent

event OnMenuClose(string _sCurrentMenu)
	;debug.trace("iEquip_WidgetCore OnMenuClose start - current menu: " + _sCurrentMenu)
	int i
	form targetForm

	if _sCurrentMenu == "InventoryMenu"																				; Just in case user has decided to poison or recharge a currently equipped weapon through the Inventory Menu, yawn...
		int leftItemType = PlayerRef.GetEquippedItemType(0)
		if ai2HWeaponTypesAlt.Find(leftItemType) > -1 && !(leftItemType < 7 && bIsCGOLoaded)
			i = 1
		endIf
		
		while i < 2
			int targetObject = jArray.getObj(aiTargetQ[i], aiCurrentQueuePosition[i])
			form equippedItem = PlayerRef.GetEquippedObject(i)
			targetForm = jMap.GetForm(targetObject, "iEquipForm")
			int itemHandle = getHandle(i, -1, targetForm)
			if equippedItem && (equippedItem as Weapon || (i == 0 && equippedItem as armor && (equippedItem as armor).IsShield())) && equippedItem == targetForm && (itemHandle == 0xFFFF || itemHandle == jMap.GetInt(targetObject, "iEquipHandle", 0xFFFF))
				checkAndUpdatePoisonInfo(i)
				CM.checkAndUpdateChargeMeter(i)
				if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
					TI.checkAndUpdateTemperLevelInfo(i)
				endIf
			endIf
			i += 1
		endWhile

	elseIf _sCurrentMenu == "Journal Menu" && Game.GetModByName("Bound Armory Extravaganza.esp") != 255 			; If we've just left journal menu check and update any queue objects containing Bound Armory spells in case they've just been renamed in the BAE MCM
		int Q
		while Q < 2
			int count = jArray.count(aiTargetQ[Q])
			while i < count
				if jMap.getInt(jArray.getObj(aiTargetQ[Q], i), "iEquipType") == 22
					targetForm = jMap.getForm(jArray.getObj(aiTargetQ[Q], i), "iEquipForm")
					if Game.GetModName(Math.LogicalAnd(Math.RightShift(targetForm.GetFormID(), 24), 0xFF)) == "Bound Armory Extravaganza.esp"		; If it's a Bound Armory Spell
						string spellName = targetForm.GetName()														; Get the new spell name
						jMap.setStr(jArray.getObj(aiTargetQ[Q], i), "iEquipName", spellName)						; Update the queue object
						if aiCurrentQueuePosition[Q] == i && PlayerRef.GetEquippedSpell(Q) == targetForm 			; Now check if the spell is currently displayed and equipped
							int element = 8		; LeftName
							if Q == 1
								element = 22	; rightName
							endIf
							int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateDisplayedText") 			; And if so update the displayed name in the widget
							If(iHandle)
								UICallback.PushInt(iHandle, element)
								UICallback.PushString(iHandle, spellName)
								UICallback.Send(iHandle)
							endIf
							asCurrentlyEquipped[Q] = spellName
						endIf
					endIf
				endIf
				i += 1
			endWhile
			i = 0
			Q += 1
		endWhile
	endIf

	sCurrentMenu = ""
	sEntryPath = ""
	;debug.trace("iEquip_WidgetCore OnMenuClose end")
endEvent

function updateWidgetVisibility(bool show = true, float fDuration = 0.2, bool showForTorchMeterFlash = false)
	;debug.trace("iEquip_WidgetCore updateWidgetVisibility start - show: " + show + ", bIsWidgetShown: " + bIsWidgetShown)
	if !bFadeRequestQueued 							; Terminate the fade request if there is already one in progress and one pending
		bFadeRequestQueued = true					; Block any further fade requests while this one is pending
		while bFadingWidget 						; Wait for the previous fade to complete
			Utility.WaitMenuMode(0.1)
		endWhile
		bFadeRequestQueued = false					; Allow incoming fade requests
		if !bRefreshingWidget						; Terminate request if we're refreshWidgetOnLoad
			bFadingWidget = true					; Cause any incoming request to be queued pending completion of this request
			if show 								; If it is a show request and the widget isn't currently shown then start fade in
				if !bIsWidgetShown
					bIsWidgetShown = true
					FadeTo(100, fDuration)
					WaitMenuMode(fDuration)				; Wait for fade duration before continuing

					if CM.bTorchMeterShown && PlayerRef.GetEquippedObject(0).GetType() == 31 && !showForTorchMeterFlash
						TO.showTorchMeter(true)		; This should update the torch meter fill and kick start the animation again just in case the tween was stopped when the widget was hidden
					endIf
				endif
													; Register for widget fadeout if enabled and weapons drawn settings allow
				;debug.trace("iEquip_WidgetCore updateWidgetVisibility start - bWidgetFadeoutEnabled: " + bWidgetFadeoutEnabled + ", fWidgetFadeoutDelay: " + fWidgetFadeoutDelay + ", bAlwaysVisibleWhenWeaponsDrawn: " + bAlwaysVisibleWhenWeaponsDrawn + ", weapons drawn: " + PlayerRef.IsWeaponDrawn())
				if bWidgetFadeoutEnabled && fWidgetFadeoutDelay > 0 && (!bAlwaysVisibleWhenWeaponsDrawn || !PlayerRef.IsWeaponDrawn()) && !EM.isEditMode
					WVis.registerForWidgetFadeoutUpdate()
				else
					WVis.unregisterForWidgetFadeoutUpdate()
				endIf
			elseIf bIsWidgetShown					; If it is a hide request and the widget is currently shown then start fade out
				bIsWidgetShown = false
				FadeTo(0, fDuration)
				Utility.WaitMenuMode(fDuration)		; Wait for fade duration before continuing
			endIf
			bFadingWidget = false					; Release any pending request
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore updateWidgetVisibility end")
endFunction

function updateTextFieldDropShadow()
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateTextFieldDropShadow")
	If(iHandle)
		UICallback.PushFloat(iHandle, fDropShadowAlpha)
		UICallback.PushInt(iHandle, fDropShadowAngle as int)
		UICallback.PushInt(iHandle, iDropShadowBlur)
		UICallback.PushInt(iHandle, fDropShadowDistance as int)
		UICallback.PushInt(iHandle, fDropShadowStrength as int)
		UICallback.PushBool(iHandle, bDropShadowEnabled)
		UICallback.Send(iHandle)
	endIf
endFunction

function addCurrentItemsOnFirstEnable()
	;debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable start")
	int Q
	form equippedItem
	string itemName
	string itemBaseName
	string itemIcon
	int itemID
	int itemHandle = 0xFFFF
	int itemType
	int iEquipSlot
	
	while Q < 3
		equippedItem = PlayerRef.GetEquippedObject(Q)
		
		if equippedItem
			abQueueWasEmpty[Q] = false

			itemType = equippedItem.GetType()

			if itemType == 22
				iEquipSlot = EquipSlots.Find((equippedItem as spell).GetEquipType())
			elseIf itemType == 41 ; If it is a weapon get the weapon type
	        	itemType = (equippedItem as Weapon).GetWeaponType()
	        endIf

			itemHandle = getHandle(Q, itemType, equippedItem)

			;debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable - Q: " + Q + ", itemHandle received: " + itemHandle)

			if itemHandle != 0xFFFF
				JArray.AddInt(iRefHandleArray, itemHandle)
				JArray.unique(iRefHandleArray)
				itemName = iEquip_InventoryExt.GetLongName(equippedItem, itemHandle)
				itemBaseName = iEquip_InventoryExt.GetShortName(equippedItem, itemHandle)
				if bIsItemDurabilityLoaded
					int i = StringUtil.Find(itemBaseName, "[")
					if i != -1
						i = StringUtil.Find(itemBaseName, "(")
					endIf
					if i != -1
						itemBaseName = StringUtil.Substring(itemBaseName, 0, i - 1)
					endIf
				endIf
				;debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable - names from handle, itemName: " + itemName + ", itemBaseName: " + itemBaseName)
			endIf
			
			if itemName == ""
				itemName = equippedItem.GetName()
			endIf
			
			itemID = CalcCRC32Hash(itemName, Math.LogicalAND(equippedItem.GetFormID(), 0x00FFFFFF))
	        itemIcon = GetItemIconName(equippedItem, itemType, itemName)
	        
	        if Q == 0 && ((itemType == 5 || itemType == 6 && !bIsCGOLoaded) || itemType == 7 || itemType == 9 || (itemType == 22 && iEquipSlot == 3) || itemType == 31)
	        	bAddingItemsOnFirstEnable = true
	        	; The following sequence is to reset both hands so no auto re-equipping/auto-adding goes on the first time this 2H item is unequipped
	        	UnequipHand(0)
	        	if !itemType == 31
	        		UnequipHand(1)
	        	endIf
	        	Utility.WaitMenuMode(0.3)
	        	UnequipHand(0)
	        	if itemType == 31
	        		PlayerRef.EquipItemEx(equippedItem)
	        	else
		        	UnequipHand(1)
		        	if itemHandle != 0xFFFF
		        		iEquip_InventoryExt.EquipItem(equippedItem, itemHandle, PlayerRef, 1)
		        	else
		        		PlayerRef.EquipItemById(equippedItem, itemID, 1)
		        	endIf
		        	abQueueWasEmpty[0] = true
		        	abQueueWasEmpty[1] = false
		        	Q = 1
		        endIf
	        	Utility.WaitMenuMode(0.3)
	        	bAddingItemsOnFirstEnable = false
	        endIf
			
			int iEquipItem = jMap.object()
			jMap.setForm(iEquipItem, "iEquipForm", equippedItem)
			jMap.setInt(iEquipItem, "iEquipHandle", itemHandle)
			jMap.setInt(iEquipItem, "iEquipItemID", itemID)
			jMap.setInt(iEquipItem, "iEquipType", itemType)
			jMap.setStr(iEquipItem, "iEquipName", itemName)
			jMap.setStr(iEquipItem, "iEquipBaseName", itemBaseName)
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
					; These will be set correctly by CycleHand() and associated functions
					jMap.setStr(iEquipItem, "iEquipBaseIcon", itemIcon)
					jMap.setStr(iEquipItem, "lastDisplayedName", itemName)
					jMap.setInt(iEquipItem, "lastKnownItemHealth", 100)
					jMap.setInt(iEquipItem, "isEnchanted", 0)
					jMap.setInt(iEquipItem, "isPoisoned", 0)
				endIf
				aiCurrentQueuePosition[Q] = 1 ; Make sure we show the equipped item and not the Unarmed shortcut we've already added in index 0
			endIf
			asCurrentlyEquipped[Q] = itemName

			jArray.addObj(aiTargetQ[Q], iEquipItem)
			; Add to the AllItems formlist
			iEquip_AllCurrentItemsFLST.AddForm(equippedItem)
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			; Send to moreHUD if loaded
			if bMoreHUDLoaded
				if Q == 1 && AhzMoreHudIE.IsIconItemRegistered(itemID)
					AhzMoreHudIE.RemoveIconItem(itemID)
					AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[3]) ; Both queues
				else
					AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[Q])
				endIf
			endIf
			; Now update the widget to show the equipped item			
			if Q < 2
				updateWidget(Q, aiCurrentQueuePosition[Q], false, true)
				; And run the rest of the hand equip cycle without actually equipping to toggle ammo mode if needed and update count, poison and charge info
				checkAndEquipShownHandItem(Q, false, true)
			elseIf bShoutEnabled
				updateWidget(Q, aiCurrentQueuePosition[Q], false, true)
			endIf

		; Otherwise set left/right slots to Unarmed
		elseIf Q < 2
			asCurrentlyEquipped[Q] = "$iEquip_common_Unarmed"
			updateWidget(Q, 0, false, true)
		endIf
		itemName = ""
		itemBaseName = ""
		itemIcon = ""
		itemID = -1
		itemHandle = 0xFFFF
		itemType = -1
		iEquipSlot = -1
		Q += 1
	endWhile
	; The only slots this should potentially leave as + Empty on a fresh start are the Shout and Poison slots
	
	; Update consumable and poison slots to show Health Potions and first poison if any present
	Q = 3
	while Q < 5
		if jArray.count(aiTargetQ[Q]) > 0
			aiCurrentQueuePosition[Q] = 0
			asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], 0), "iEquipName")
			updateWidget(Q, 0, false, true)
			if Q == 3
				setSlotCount(3, PO.getPotionGroupCount(0))
				if abPotionGroupEmpty[0]
					checkAndFadeConsumableIcon(true)
				endIf
			else
				setSlotCount(4, PlayerRef.GetItemCount(jMap.getForm(jArray.getObj(aiTargetQ[4], 0), "iEquipForm")))
			endIf
			setCounterVisibility(Q, true)
		endIf
		Q += 1
	endWhile
	
	;debug.trace("iEquip_WidgetCore addCurrentItemsOnFirstEnable end")
endFunction

function updateWidgetArrays()
	
	; Store current values
	float[] afWidget_TmpX = afWidget_X
	float[] afWidget_TmpY = afWidget_Y
	float[] afWidget_TmpS = afWidget_S
	float[] afWidget_TmpR = afWidget_R
	float[] afWidget_TmpA = afWidget_A
	int[] aiWidget_TmpD = aiWidget_D
	string[] asWidget_TmpTA = asWidget_TA
	int[] aiWidget_TmpTC = aiWidget_TC
	bool[] abWidget_TmpV = abWidget_V
	
	; Overwrite the existing arrays 
	PopulateWidgetArrays()

	; Overwrite the default value arrays using the values from the new default layout preset
	getAndStoreDefaultWidgetValues(true)

	; Write back across the stored values, using the new default values for the four newly added elements
	int i
	int j
	while i < 56
		if (afWidget_TmpX.Length < 54 && (i == 16 || i == 22 || i == 33 || i == 39)) || (i == 15 || i == 32)
			afWidget_X[i] = afWidget_DefX[i]
			afWidget_Y[i] = afWidget_DefY[i]
			afWidget_S[i] = afWidget_DefS[i]
			afWidget_R[i] = afWidget_DefR[i]
			afWidget_A[i] = afWidget_DefA[i]
			aiWidget_D[i] = aiWidget_DefD[i]
			asWidget_TA[i] = asWidget_DefTA[i]
			aiWidget_TC[i] = aiWidget_DefTC[i]
			abWidget_V[i] = abWidget_DefV[i]
		else
			afWidget_X[i] = afWidget_TmpX[j]
			afWidget_Y[i] = afWidget_TmpY[j]
			afWidget_S[i] = afWidget_TmpS[j]
			afWidget_R[i] = afWidget_TmpR[j]
			afWidget_A[i] = afWidget_TmpA[j]
			aiWidget_D[i] = aiWidget_TmpD[j]
			asWidget_TA[i] = asWidget_TmpTA[j]
			aiWidget_TC[i] = aiWidget_TmpTC[j]
			abWidget_V[i] = abWidget_TmpV[j]
			j += 1
		endIf
		i += 1
	endWhile

endFunction

function PopulateWidgetArrays()
	;debug.trace("iEquip_WidgetCore PopulateWidgetArrays start")
	asWidgetDescriptions = new string[56]
	asWidgetElements = new string[56]
	asWidget_TA = new string[56]
	asWidgetGroup = new string[56]
	
	afWidget_X = new float[56]
	afWidget_Y = new float[56]
	afWidget_S = new float[56]
	afWidget_R = new float[56]
	afWidget_A = new float[56]
	
	aiWidget_D = new int[56] ;Stored the index value of any Bring To Front target element ie the element to be sent behind
	aiWidget_TC = new int[56]
	
	abWidget_V = new bool[56]
	abWidget_isParent = new bool[56]
	abWidget_isText = new bool[56]
	abWidget_isBg = new bool[56]

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
	AddWidget("$iEquip_WC_lbl_LeftRadialMeter", ".widgetMaster.LeftHandWidget.leftRadialMeter_mc", 0, 0, 0, 0, 0, 14, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftTierInd", ".widgetMaster.LeftHandWidget.leftTierIndicator_mc", 0, 0, 0, 0, 0, 15, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPosInd", ".widgetMaster.LeftHandWidget.leftPositionIndicator_mc", 0, 0, 0, 0, 0, 16, 0, None, true, false, false, false, "Left")
	;Left Hand Preselect widget components
	AddWidget("$iEquip_WC_lbl_LeftPreBg", ".widgetMaster.LeftHandWidget.leftPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreIcon", ".widgetMaster.LeftHandWidget.leftPreselectIcon_mc", 0, 0, 0, 0, 0, 18, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreName", ".widgetMaster.LeftHandWidget.leftPreselectName_mc", 0, 0, 0, 0, 0, 19, 16777215, "Right", true, false, true, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreAtt", ".widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 20, 0, None, true, false, false, false, "Left")
	AddWidget("$iEquip_WC_lbl_LeftPreTierInd", ".widgetMaster.LeftHandWidget.leftPreselectTierIndicator_mc", 0, 0, 0, 0, 0, 21, 0, None, true, false, false, false, "Left")
	;Right Hand widget components
	AddWidget("$iEquip_WC_lbl_RightBg", ".widgetMaster.RightHandWidget.rightBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Right")
	AddWidget("$iEquip_WC_lbl_RightIcon", ".widgetMaster.RightHandWidget.rightIcon_mc", 0, 0, 0, 0, 0, 23, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightName", ".widgetMaster.RightHandWidget.rightName_mc", 0, 0, 0, 0, 0, 24, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightCount", ".widgetMaster.RightHandWidget.rightCount_mc", 0, 0, 0, 0, 0, 25, 16777215, "Center", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPoisIcon", ".widgetMaster.RightHandWidget.rightPoisonIcon_mc", 0, 0, 0, 0, 0, 26, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPoisName", ".widgetMaster.RightHandWidget.rightPoisonName_mc", 0, 0, 0, 0, 0, 27, 12646509, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightAttIcon", ".widgetMaster.RightHandWidget.rightAttributeIcons_mc", 0, 0, 0, 0, 0, 28, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightMeter", ".widgetMaster.RightHandWidget.rightEnchantmentMeter_mc", 0, 0, 0, 0, 0, 29, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightGem", ".widgetMaster.RightHandWidget.rightSoulgem_mc", 0, 0, 0, 0, 0, 30, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightRadialMeter", ".widgetMaster.RightHandWidget.rightRadialMeter_mc", 0, 0, 0, 0, 0, 31, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightTierInd", ".widgetMaster.RightHandWidget.rightTierIndicator_mc", 0, 0, 0, 0, 0, 32, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPosInd", ".widgetMaster.RightHandWidget.rightPositionIndicator_mc", 0, 0, 0, 0, 0, 33, 0, None, true, false, false, false, "Right")
	;Right Hand Preselect widget components
	AddWidget("$iEquip_WC_lbl_RightPreBg", ".widgetMaster.RightHandWidget.rightPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreIcon", ".widgetMaster.RightHandWidget.rightPreselectIcon_mc", 0, 0, 0, 0, 0, 35, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreName", ".widgetMaster.RightHandWidget.rightPreselectName_mc", 0, 0, 0, 0, 0, 36, 16777215, "Left", true, false, true, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreAtt", ".widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc", 0, 0, 0, 0, 0, 37, 0, None, true, false, false, false, "Right")
	AddWidget("$iEquip_WC_lbl_RightPreTierInd", ".widgetMaster.RightHandWidget.rightPreselectTierIndicator_mc", 0, 0, 0, 0, 0, 38, 0, None, true, false, false, false, "Right")
	;Shout widget components
	AddWidget("$iEquip_WC_lbl_ShoutBg", ".widgetMaster.ShoutWidget.shoutBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutIcon", ".widgetMaster.ShoutWidget.shoutIcon_mc", 0, 0, 0, 0, 0, 40, 0, None, true, false, false, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutName", ".widgetMaster.ShoutWidget.shoutName_mc", 0, 0, 0, 0, 0, 41, 16777215, "Center", true, false, true, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutPosInd", ".widgetMaster.ShoutWidget.shoutPositionIndicator_mc", 0, 0, 0, 0, 0, 42, 0, None, true, false, false, false, "Shout")
	;Shout Preselect widget components
	AddWidget("$iEquip_WC_lbl_ShoutPreBg", ".widgetMaster.ShoutWidget.shoutPreselectBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutPreIcon", ".widgetMaster.ShoutWidget.shoutPreselectIcon_mc", 0, 0, 0, 0, 0, 44, 0, None, true, false, false, false, "Shout")
	AddWidget("$iEquip_WC_lbl_ShoutPreName", ".widgetMaster.ShoutWidget.shoutPreselectName_mc", 0, 0, 0, 0, 0, 45, 16777215, "Right", true, false, true, false, "Shout")
	;Consumable widget components
	AddWidget("$iEquip_WC_lbl_ConsBg", ".widgetMaster.ConsumableWidget.consumableBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsIcon", ".widgetMaster.ConsumableWidget.consumableIcon_mc", 0, 0, 0, 0, 0, 47, 0, None, true, false, false, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsName", ".widgetMaster.ConsumableWidget.consumableName_mc", 0, 0, 0, 0, 0, 48, 16777215, "Right", true, false, true, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_ConsCount", ".widgetMaster.ConsumableWidget.consumableCount_mc", 0, 0, 0, 0, 0, 49, 16777215, "Center", true, false, true, false, "Consumable")
	AddWidget("$iEquip_WC_lbl_potSelector", ".widgetMaster.ConsumableWidget.potionSelector_mc", 0, 0, 0, 0, 0, 50, 16777215, None, true, false, false, false, "Consumable")
	;Poison widget components
	AddWidget("$iEquip_WC_lbl_PoisonBg", ".widgetMaster.PoisonWidget.poisonBg_mc", 0, 0, 0, 0, 0, -1, 0, None, true, false, false, true, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonIcon", ".widgetMaster.PoisonWidget.poisonIcon_mc", 0, 0, 0, 0, 0, 52, 0, None, true, false, false, false, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonName", ".widgetMaster.PoisonWidget.poisonName_mc", 0, 0, 0, 0, 0, 53, 16777215, "Left", true, false, true, false, "Poison")
	AddWidget("$iEquip_WC_lbl_PoisonCount", ".widgetMaster.PoisonWidget.poisonCount_mc", 0, 0, 0, 0, 0, 54, 16777215, "Center", true, false, true, false, "Poison")

	;debug.trace("iEquip_WidgetCore PopulateWidgetArrays end")
endFunction

function AddWidget( string sDescription, string sPath, float fX, float fY, float fS, float fR, float fA, int iD, int iTC, string sTA, bool bV, bool bIsParent, bool bIsText, bool bIsBg, string sGroup)
	;debug.trace("iEquip_WidgetCore AddWidget start")
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
	;debug.trace("iEquip_WidgetCore AddWidget end")
endFunction

function getAndStoreDefaultWidgetValues(bool updateFromFile = false)
	;debug.trace("iEquip_WidgetCore getAndStoreDefaultWidgetValues start")
	afWidget_DefX = new float[56]
	afWidget_DefY = new float[56]
	afWidget_DefS = new float[56]
	afWidget_DefR = new float[56]
	afWidget_DefA = new float[56]
	aiWidget_DefD = new int[56]
	asWidget_DefTA = new string[56]
	aiWidget_DefTC = new int[56]
	abWidget_DefV = new bool[56]

	if updateFromFile
		int jObj = JValue.readFromDirectory(WidgetPresetPath, FileExtDef)
		int jPreset = JMap.getObj(jObj, JMap.getNthKey(jObj, 0))

		JArray.writeToFloatPArray(JMap.getObj(jPreset, "_X"), afWidget_DefX, 0, -1, 0, 0)
	    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_Y"), afWidget_DefY, 0, -1, 0, 0)
	    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_S"), afWidget_DefS, 0, -1, 0, 0)
	    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_R"), afWidget_DefR, 0, -1, 0, 0)
	    JArray.writeToFloatPArray(JMap.getObj(jPreset, "_A"), afWidget_DefA, 0, -1, 0, 0)
	    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_D"), aiWidget_DefD, 0, -1, 0, 0)
	    JArray.writeToIntegerPArray(JMap.getObj(jPreset, "_TC"), aiWidget_DefTC, 0, -1, 0, 0)
	    JArray.writeToStringPArray(JMap.getObj(jPreset, "_TA"), asWidget_DefTA, 0, -1, 0, 0)
	    int i
	    while i < 56
	    	abWidget_DefV[i] = true
	    	i += 1
	    endWhile

	    jValue.zeroLifetime(jObj)
	else
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
	endIf
	;debug.trace("iEquip_WidgetCore getAndStoreDefaultWidgetValues end")
endFunction

function ResetWidgetArrays()
	;debug.trace("iEquip_WidgetCore ResetWidgetArrays start")
	int iIndex
	while iIndex < asWidgetDescriptions.Length
		afWidget_X[iIndex] = afWidget_DefX[iIndex]
		afWidget_Y[iIndex] = afWidget_DefY[iIndex]
		afWidget_S[iIndex] = afWidget_DefS[iIndex]
		afWidget_R[iIndex] = afWidget_DefR[iIndex]
		afWidget_A[iIndex] = afWidget_DefA[iIndex]
		aiWidget_D[iIndex] = aiWidget_DefD[iIndex]
		asWidget_TA[iIndex] = asWidget_DefTA[iIndex]
		aiWidget_TC[iIndex] = aiWidget_DefTC[iIndex]
		abWidget_V[iIndex] = abWidget_DefV[iIndex]
		iIndex += 1
	endWhile
	;debug.trace("iEquip_WidgetCore ResetWidgetArrays end")
endFunction

int function getHandle(int Q, int itemType = -1, form targetForm)
	;debug.trace("iEquip_WidgetCore getHandle start - Q: " + Q + ", itemType: " + itemType)
	int itemHandle = 0xFFFF
	if Q < 2
		form equippedItem = PlayerRef.GetEquippedObject(Q)
		if equippedItem && equippedItem == targetForm && (equippedItem as weapon || equippedItem as armor)
			if itemType == -1
				;debug.trace("iEquip_WidgetCore getHandle - equippedItem: " + equippedItem + " (" + equippedItem.GetName() + ")")
				itemType = equippedItem.GetType()
				if itemType == 41 														; If it is a weapon get the weapon type
		        	itemType = (equippedItem as Weapon).GetWeaponType()
		        endIf
		        ;debug.trace("iEquip_WidgetCore getHandle - itemType: " + itemType)
			endIf
			if TI.aiTemperedItemTypes.Find(itemType) != -1
				if itemType == 26														; Shield
					Q = 2
				elseIf (itemType > 4 && itemType < 8) || itemType == 9					; 2H or ranged
					Q = 1
				endIf
				itemHandle = iEquip_InventoryExt.GetRefHandleFromWornObject(Q)
			endIf
		;else
			;debug.trace("iEquip_WidgetCore getHandle - nothing returned by GetEquippedObject")
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore getHandle end - returning itemHandle: " + itemHandle)
	return itemHandle
endFunction

function setCurrentQueuePosition(int Q, int iIndex)
	;debug.trace("iEquip_WidgetCore setCurrentQueuePosition start - Q: " + Q + ", iIndex: " + iIndex)
	if iIndex == -1
		iIndex = 0
	endIf
	aiCurrentQueuePosition[Q] = iIndex
	asCurrentlyEquipped[Q] = jMap.getStr(jArray.getObj(aiTargetQ[Q], iIndex), "iEquipName")
	;debug.trace("iEquip_WidgetCore setCurrentQueuePosition end")
endFunction

bool function itemRequiresCounter(int Q, int itemType = -1)
	;debug.trace("iEquip_WidgetCore itemRequiresCounter start")
	bool requiresCounter
	int itemObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
	if itemType == -1
		itemType = jMap.getInt(itemObject, "iEquipType")
	endIf

	if asCurrentlyEquipped[Q] != "" && ((itemType == 42 || itemType == 23 || itemType == 31) || (itemType == 4 && iEquip_FormExt.isGrenade(jMap.getForm(itemObject, "iEquipForm")))) ;Ammo (which takes in Throwing Weapons), scroll, torch, or CACO grenades here which are classed as maces
		requiresCounter = true
    endIf
    ;debug.trace("iEquip_WidgetCore itemRequiresCounter returning " + requiresCounter)
    return requiresCounter
endFunction

function setSlotCount(int Q, int count)
	;debug.trace("iEquip_WidgetCore setSlotCount start - Q: " + Q + ", count: " + count)
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
			UICallback.PushInt(iHandle, aiWidget_TC[50]) ;consumableCount_mc text colour, used to reset to white/Edit Mode set colour if count is above 5, otherwise colour is handled by ActionScript
		else
			UICallback.PushBool(iHandle, false) ;Default to false for anything other than a Potion Group in Q == 3
			UICallback.PushInt(iHandle, 0) ;Not needed if Q != 3
			UICallback.PushInt(iHandle, 0) ;Not needed if Q != 3
		endIf
		UICallback.Send(iHandle)
		if !abIsCounterShown[Q]
			setCounterVisibility(Q, true)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore setSlotCount end")
endFunction

;-----------------------------------------------------------------------------------------------------------------------
;QUEUE FUNCTIONALITY CODE
;-----------------------------------------------------------------------------------------------------------------------

int function confirmNewIndex(int targetIndex, int queueLength, bool reverse)
	if reverse
		if targetIndex < 0
			targetIndex = queueLength - 1
		endIf
	elseif targetIndex == queueLength
		targetIndex = 0
	endIf
	return targetIndex
endFunction

function cycleSlot(int Q, bool Reverse = false, bool ignoreEquipOnPause = false, bool onItemRemoved = false, bool onKeyPress = false)
	;debug.trace("iEquip_WidgetCore cycleSlot start - Q: " + Q + ", Reverse: " + Reverse + " ,abIsNameShown[Q]: " + abIsNameShown[Q])
	;Q: 0 = Left hand, 1 = Right hand, 2 = Shout, 3 = Consumables, 4 = Poisons

	if onKeyPress
		; Apply Slow Time effect if enabled
		addSlowTimeEffect(Q)

		bSwitchingHands = false
		bPreselectSwitchingHands = false
		if Q < 2
			PM.bCurrentlyQuickRanged = false
    		PM.bCurrentlyQuickHealing = false
    	endIf
	endIf
	
	int targetArray = aiTargetQ[Q]

	if Q < 3 && jMap.getInt(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipTempItem") == 1
		removeTempItemFromQueue(Q, aiCurrentQueuePosition[Q])
	endIf

	int queueLength = JArray.count(targetArray)
	;debug.trace("iEquip_WidgetCore cycleSlot - queueLength: " + queueLength)
	
	; Check if queue contains anything and return out if not
	if queueLength == 0
		debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[Q] + "}"))
	
	; If we're cycling the consumable slot and the potion type selector is currently shown cycle the selector instead of the main slot
	elseIf Q == 3 && bPotionSelectorShown
		cyclePotionSelector(Reverse)
	
	; If Preselect Mode is enabled then left/right/shout needs to cycle the preselect slot not the main widget. if shout preselect is disabled cycle main shout slot
	elseif (bPreselectMode && !bPreselectSwitchingHands && (Q < 2 || (Q == 2 && PM.bShoutPreselectEnabled))) || (Q == 0 && bAmmoMode)
		;if preselect name not shown then first cycle press shows name without advancing the queue
		;debug.trace("iEquip_WidgetCore cycleSlot - abIsNameShown[Q + 5]: " + abIsNameShown[Q + 5])
		if bFirstPressShowsName && !abIsNameShown[Q + 5]
			showName(Q + 5)
		else
			if Q == 0 && bAmmoMode
				bCyclingLHPreselectInAmmoMode = true
			endIf
			PM.cyclePreselectSlot(Q, queueLength, Reverse, true, onKeyPress)
		endIf
	
	; If name not shown then first cycle press shows name without advancing the queue
	elseif bFirstPressShowsName && !onItemRemoved && !bSwitchingHands && !bPreselectSwitchingHands && !abIsNameShown[Q] && asCurrentlyEquipped[Q] != ""
		showName(Q)

	elseIf queueLength > 1 || onItemRemoved || (Q < 3 && abQueueWasEmpty[Q]) || (Q == 0 && bGoneUnarmed || b2HSpellEquipped)
		int i
		int	targetIndex
		int targetObject = jArray.getObj(targetArray, aiCurrentQueuePosition[Q])
		form targetItem
	    string targetName

		if Q < 3
			if iBackgroundStyle > 0
				int[] args = new int[2]
				args[0] = Q
				args[1] = iBackgroundStyle
				UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)	; Reshow the background if it was previously hidden
			endIf
			abQueueWasEmpty[Q] = false
			; Hide the slot counter, poison info and charge meter if currently shown
			if Q < 2 
				setCounterVisibility(Q, false)
				hidePoisonInfo(Q)
				CM.updateChargeMeterVisibility(Q, false)
			endIf
		elseIf Q == 3
			CFUpdate.unregisterForConsumableFadeUpdate()
		endIf
		
		; Make sure we're starting from the correct index, in case somehow the queue has been amended without the aiCurrentQueuePosition array being updated
		if asCurrentlyEquipped[Q] != "" && asCurrentlyEquipped[Q] != jMap.getStr(targetObject, "iEquipName")
			if Q < 2
				aiCurrentQueuePosition[Q] = findInQueue(Q, asCurrentlyEquipped[Q], PlayerRef.GetEquippedObject(Q), getHandle(Q, -1, jMap.getForm(targetObject, "iEquipForm")))
			else
				aiCurrentQueuePosition[Q] = findInQueue(Q, asCurrentlyEquipped[Q])
			endIf
		endIf
		
		if queueLength > 1
			; Check if we're moving forwards or backwards in the queue
			int move = 1
			if Reverse
				move = -1
			endIf
			; Set the initial target index, then check if we're cycling past the first or last items in the queue and jump to the start/end as required
			targetIndex = confirmNewIndex(aiCurrentQueuePosition[Q] + move, queueLength, Reverse)

			; Now we need to apply any conditional cycling restrictions if required
			if Q < 4
				i = queueLength - 1
				targetObject = jArray.getObj(targetArray, targetIndex)
		    	targetName = jMap.getStr(targetObject, "iEquipName")
		    	
			    if Q == 3 					; If we're in the consumables queue check for empty potion groups
                    while i > 0 && (asPotionGroups.Find(targetName) > -1 && (!bPotionGrouping || (PO.iEmptyPotionQueueChoice == 1 && abPotionGroupEmpty[asPotionGroups.Find(targetName)])))
                        targetIndex = confirmNewIndex(targetIndex + move, queueLength, Reverse)
                        targetName = jMap.getStr(jArray.getObj(targetArray, targetIndex), "iEquipName")
                        i -= 1
                    endWhile
			    elseIf Q == 2 				
			    	; Nothing to do here, used to be skip auto added items, but we've removed that now
			    elseIf bPlayerIsMounted		; cycleSlot will only ever be called for Q == 1 if bPlayerIsMounted so no need check for Q here - we're skipping Unarmed in combat if required, auto-added items if required, spells, scrolls and staffs as not able to be used on horseback (vanilla)
			    	int itemType = jMap.getInt(targetObject, "iEquipType")
			    	while  i > 0 && ((bSkipRHUnarmedInCombat && targetName == "$iEquip_common_Unarmed" && PlayerRef.IsInCombat()) || itemType == 8 || itemType == 22 || itemType == 23)
			    		targetIndex = confirmNewIndex(targetIndex + move, queueLength, Reverse)
			    		targetObject = jArray.getObj(targetArray, targetIndex)
			    		targetName = jMap.getStr(targetObject, "iEquipName")
			    		itemType = jMap.getInt(targetObject, "iEquipType")
			    		i -= 1
			    	endWhile
			    elseIf bDragonRiding 		; For dragon riding we need to restrict the selectable items to staffs, scrolls and allowed spells only, as well as skipping Unarmed in combat if required, and auto-added items if required
			    	int itemType = jMap.getInt(targetObject, "iEquipType")
			    	targetItem = jMap.getForm(targetObject, "iEquipForm")
			    	while  i > 0 && ((Q == 1 && bSkipRHUnarmedInCombat && targetName == "$iEquip_common_Unarmed" && PlayerRef.IsInCombat()) && !(itemType == 8 || itemType == 23 || (itemType == 22 && DLC2DRAllowedSpells.HasForm(targetItem))))
			    		targetIndex = confirmNewIndex(targetIndex + move, queueLength, Reverse)
			    		targetObject = jArray.getObj(targetArray, targetIndex)
			    		targetItem = jMap.getForm(targetObject, "iEquipForm")
			    		targetName = jMap.getStr(targetObject, "iEquipName")
			    		itemType = jMap.getInt(targetObject, "iEquipType")
			    		i -= 1
			    	endWhile
			    else			    		; And finally if we're cycling one of the hand queues and none of the above apply, we need to check for 1H switching if the same 1H item which is currently equipped in the other hand, as well as skipping Unarmed in combat if required, and auto-added items if required
				    int itemType = jMap.getInt(targetObject, "iEquipType")
			    	targetItem = jMap.getForm(targetObject, "iEquipForm")
				    while  i > 0 && ((Q == 1 && bSkipRHUnarmedInCombat && targetName == "$iEquip_common_Unarmed" && PlayerRef.IsInCombat()) && (itemType != 22 && !bAllowWeaponSwitchHands && targetItem == PlayerRef.GetEquippedObject((Q + 1) % 2) && (PlayerRef.GetItemCount(targetItem) < 2)))
			    		targetIndex = confirmNewIndex(targetIndex + move, queueLength, Reverse)
			    		targetObject = jArray.getObj(targetArray, targetIndex)
			    		targetItem = jMap.getForm(targetObject, "iEquipForm")
			    		targetName = jMap.getStr(targetObject, "iEquipName")
			    		itemType = jMap.getInt(targetObject, "iEquipType")
			    		i -= 1
			    	endWhile
			    endIf
		    endIf
			; If we're switching because of a hand to hand swap in EquipPreselectedItem then if the targetIndex matches the currently preselected item skip past it when advancing the main queue.
			if bPreselectSwitchingHands && targetIndex == aiCurrentlyPreselected[Q]
				targetIndex = confirmNewIndex(targetIndex + 1, queueLength, false)
			endIf
		else
			targetIndex = 0
		endIf

		targetObject = jArray.getObj(targetArray, targetIndex)

		if Q < 2 && (bSwitchingHands || bPreselectSwitchingHands)
			;debug.trace("iEquip_WidgetCore cycleSlot - Q: " + Q + ", bSwitchingHands: " + bSwitchingHands)
			ignoreEquipOnPause = true
			; If we're forcing the left hand to switch equipped items because we're switching left to right, make sure we don't leave the left hand unarmed
			if Q == 1
				int itemType = jMap.getInt(targetObject, "iEquipType")
				i = 1
				AM.bAmmoModePending = false
				
				; Check if initial target item is 2h or ranged, or if it is a 1h item but you only have one of it and you've just equipped it in the other hand, or if it is unarmed. If it is then starting from the currently equipped index search forward for a 1h item
				
				while i < queueLength && (itemType == 0 || (ai2HWeaponTypes.Find(itemType) > -1 && !(itemType < 7 && bIsCGOLoaded)) || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3 || ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(jMap.getForm(targetObject, "iEquipForm") as spell)) > -1) || ((asCurrentlyEquipped[0] == jMap.getStr(targetObject, "iEquipName")) && PlayerRef.GetItemCount(targetItem) < 2))
					i += 1
					; If we've got back to the starting index without finding anything suitable then return out and don't re-equip anything 
					if i == queueLength
						return
					endIf
					targetIndex += 1
					; If we have reached the final index in the array then loop to the start and keep counting forward until we reach the original starting point
					if targetIndex == queueLength
						targetIndex = 0
					endIf
					targetObject = jArray.getObj(targetArray, targetIndex)
					itemType = jMap.getInt(targetObject, "iEquipType")
				endWhile
				
			endIf
		elseIf Q == 4 && bPoisonIconFaded
			checkAndFadePoisonIcon(false)
			Utility.WaitMenuMode(0.3)
		endIf
		; Show the queue position indicator if required (only if cycleSlot was called as a result of a cycle hotkey key press)
		if Q < 3 && onKeyPress
			if iPosInd > 0
				updateQueuePositionIndicator(Q, queueLength, aiCurrentQueuePosition[Q], targetIndex)
			endIf
			abCyclingQueue[Q] = true
		endIf
		; Update the widget to the next queued item immediately then register for bEquipOnPause update or call cycle functions straight away
		aiCurrentQueuePosition[Q] = targetIndex
		asCurrentlyEquipped[Q] = jMap.getStr(targetObject, "iEquipName")
		updateWidget(Q, targetIndex, false, true)
		
		if Q < 2
			PM.bCurrentlyQuickRanged = false
			PM.bCurrentlyQuickHealing = false
			; If bEquipOnPause is enabled and you are cycling left/right/shout, and we're not ignoring bEquipOnPause because we're switching hands, then use the bEquipOnPause updates
			if !ignoreEquipOnPause && bEquipOnPause
				if Q == 0
					LHUpdate.registerForEquipOnPauseUpdate(Reverse)
				else
					RHUpdate.registerForEquipOnPauseUpdate(Reverse)
				endIf
			; Otherwise carry on and equip/cycle
			else
				checkAndEquipShownHandItem(Q, Reverse)
				if onKeyPress && iPosInd > 0
					if Q == 0
						LHPosUpdate.registerForFadeoutUpdate()
					else
						RHPosUpdate.registerForFadeoutUpdate()
					endIf
				endIf
			endIf
		else
			bool isPotionGroup
			if Q == 3 && asPotionGroups.Find(targetName) > -1
				isPotionGroup = true
				targetItem = none
			else
				targetItem = jMap.getForm(targetObject, "iEquipForm")
			endIf
			checkAndEquipShownShoutOrConsumable(Q, Reverse, targetIndex, targetItem, isPotionGroup)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore cycleSlot end")
endFunction

bool property bConsoleUtilLoaded auto hidden
bool property bGTMSet auto hidden

function addSlowTimeEffect(int Q, bool bCyclingAmmo = false)
	if bSlowTimeWhileCycling && iCycleSlowTimeStrength > 0
		if bConsoleUtilLoaded
			bGTMSet = true
			float f = (100 - iCycleSlowTimeStrength) as float / 100
			if f == 0
				f = 0.001
			endIf
			ConsoleUtil.ExecuteCommand("sgtm " + f)
		elseIf !PlayerRef.HasSpell(iEquip_SlowTimeSpell)
			iEquip_SlowTimeStrength.SetValueInt(iCycleSlowTimeStrength)
			PlayerRef.AddSpell(iEquip_SlowTimeSpell, false)
		endIf
		if Q > 1 || bPreselectMode || (Q == 0 && bCyclingAmmo) || !bEquipOnPause
			STUpdate.registerForSlowTimeEffectUpdate()
		endIf
	endIf
endFunction

function removeSlowTimeEffect()
	if bGTMSet
		bGTMSet = false
		ConsoleUtil.ExecuteCommand("sgtm " + 1.0)
	else
		PlayerRef.RemoveSpell(iEquip_SlowTimeSpell)
	endIf
endFunction

function checkAndEquipShownHandItem(int Q, bool Reverse = false, bool equippingOnAutoAdd = false, bool calledByQuickRanged = false)
	;debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem start - Q: " + Q + ", Reverse: " + Reverse + ", equippingOnAutoAdd: " + equippingOnAutoAdd + ", calledByQuickRanged: " + calledByQuickRanged)
	; Hide the position indicator if not set to always show (if !bEquipOnPause we've registered for an update which will handle this)
	if bEquipOnPause
		int otherHand = (Q + 1) % 2
		if !abCyclingQueue[otherHand]
			removeSlowTimeEffect()
		endIf
		abCyclingQueue[Q] = false
		if iPosInd != 2
			UI.invokeInt(HUD_MENU, WidgetRoot + ".hideQueuePositionIndicator", Q)
		endIf
	endIf
	
	int targetIndex = aiCurrentQueuePosition[Q]
	int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    Form targetItem = jMap.getForm(targetObject, "iEquipForm")
    int itemType = jMap.getInt(targetObject, "iEquipType")
    int itemHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
    
    if itemType == 7 || itemType == 9
    	AM.checkAndRemoveBoundAmmo(itemType)
    endIf
    
    bool doneHere
    form currentObject = PlayerRef.GetEquippedObject(Q)
    
    if !equippingOnAutoAdd
	    ; If we're equipping Fists
	    if itemType == 0
	    	if Q == 0
	    		UnequipHand(0)
	    	else
				goUnarmed()
			endIf
			doneHere = true  

	    ; If you already have the item equipped in the slot you are cycling then refresh the poison, charge and count info and hide the attribute icons
	    elseif currentObject && itemHandle != 0xFFFF && (currentObject as weapon && itemHandle == iEquip_InventoryExt.GetRefHandleFromWornObject(Q)) || (currentObject as armor && itemHandle == iEquip_InventoryExt.GetRefHandleFromWornObject(2))
	    	hideAttributeIcons(Q)
	    	checkAndUpdatePoisonInfo(Q, false, false, itemHandle)
			CM.checkAndUpdateChargeMeter(Q)
			if TI.aiTemperedItemTypes.Find(itemType) > -1 && (TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator)
				TI.checkAndUpdateTemperLevelInfo(Q)
			endIf
			if itemRequiresCounter(Q, itemType)
				setCounterVisibility(Q, true)
			endIf
	    	doneHere = true
		; If somehow the item has been removed from the player and we haven't already caught it remove it from queue and advance queue again
		elseif !playerStillHasItem(targetItem, itemHandle)
			iEquip_AllCurrentItemsFLST.RemoveAddedForm(targetItem)
			EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
			if bEnableRemovedItemCaching
				AddItemToLastRemovedCache(Q, targetIndex)
			endIf
			if bMoreHUDLoaded
		        AhzMoreHudIE.RemoveIconItem(jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipItemID"))
		    endIf
			jArray.eraseIndex(aiTargetQ[Q], targetIndex)
			; If you are cycling backwards you have just removed the previous item in the queue so the aiCurrentQueuePosition needs to be updated before calling cycleSlot again
			if Reverse
				aiCurrentQueuePosition[Q] = aiCurrentQueuePosition[Q] - 1
			endIf
			cycleSlot(Q, Reverse)
			doneHere = true
		endIf
	endIf
	if !doneHere && targetItem
		;debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - player still has item, Q: " + Q + ", aiCurrentQueuePosition: " + aiCurrentQueuePosition[Q] + ", itemName: " + jMap.getStr(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipName"))
		; If we're about to equip a ranged weapon and we're not already in Ammo Mode or we're switching ranged weapon type set the ammo queue to the first ammo in the array and then animate in if needed
		;debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem - bAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
		if Q == 1
			; If we're equipping a ranged weapon
			if (itemType == 7 || itemType == 9)
				; Firstly we need to update the relevant ammo list.  We'll update the widget once the weapon is equipped
				bool skipSetCount
				if !bAmmoMode
					if bLeftIconFaded
						checkAndFadeLeftIcon(1, 7)
						Utility.WaitMenuMode(0.2)
					endIf
					if !calledByQuickRanged
						AM.selectAmmoQueue(itemType)
					endIf
				elseif AM.switchingRangedWeaponType(itemType) && !calledByQuickRanged
					AM.selectAmmoQueue(itemType)
					;AM.checkAndEquipAmmo(false, true, false)
					skipSetCount = true
				endIf
				; If we are already in Ammo Mode or Preselect Mode we're switching from a bow to a crossbow or vice versa so we need to update the ammo widget
				if bAmmoMode || bPreselectMode
					updateWidget(0, AM.aiCurrentAmmoIndex[AM.Q])
					if !skipSetCount
						setSlotCount(0, PlayerRef.GetItemCount(AM.currentAmmoForm))
					endIf
				else
					AM.toggleAmmoMode(false, equippingOnAutoAdd) ; Animate in without any equipping/unequipping if equippingOnAutoAdd
				endIf
				if !isWeaponPoisoned(1, aiCurrentQueuePosition[1])
					setCounterVisibility(1, false)
				endIf
			; If we're already in Ammo Mode and about to equip something in the right hand which is not another ranged weapon then we need to toggle out of Ammo Mode
			elseIf bAmmoMode
				; Animate out without equipping the left hand item, we'll handle this later once right hand re-equipped
				AM.toggleAmmoMode(false, true)
				; If we've still got the shown ammo equipped and have enabled Unequip Ammo in the MCM then unequip it now
				ammo currentAmmo = AM.currentAmmoForm as Ammo
				if currentAmmo && PlayerRef.isEquipped(currentAmmo) && bUnequipAmmo
					AM.unequipAmmo(currentAmmo)
				endIf
				bJustLeftAmmoMode = true
			endIf
			; If we're equipping a 2H item in the right hand from bGoneUnarmed then we need to update the left slot back to the item prior to going unarmed before fading the left icon if required
			if (bGoneUnarmed || b2HSpellEquipped) && (itemType == 5 || itemType == 6)
	    		updateWidget(0, aiCurrentQueuePosition[0])
	    		targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
	    		if itemRequiresCounter(0, jMap.getInt(targetObject, "iEquipType"))
					setSlotCount(0, PlayerRef.GetItemCount(jMap.getForm(targetObject, "iEquipForm")))
					setCounterVisibility(0, true)
				endIf
	    	endIf
		endIf
		; If we're cyling left or right and not in Ammo Mode check if new item requires a counter
		if !bAmmoMode
			if itemRequiresCounter(Q, itemType)
				; Update the item count
				setSlotCount(Q, PlayerRef.GetItemCount(targetItem))
				; Show the counter if currently hidden
				setCounterVisibility(Q, true)
			; The new item doesn't require a counter to hide it if it's currently shown
			else
				setCounterVisibility(Q, false)
			endIf
		endIf
		; Now that we've passed all the checks we can carry on and equip
		cycleHand(Q, targetIndex, targetItem, itemType, equippingOnAutoAdd)
		Utility.WaitMenuMode(0.2)
		if bJustLeftAmmoMode
			bJustLeftAmmoMode = false
			Utility.WaitMenuMode(0.3)
		endIf
		checkAndFadeLeftIcon(Q, itemType)
	endIf
	;debug.trace("iEquip_WidgetCore checkAndEquipShownHandItem end")
endFunction

function checkAndFadeLeftIcon(int Q, int itemType)
	;debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon start - Q: " + Q + ", itemType: " + itemType + ", bFadeLeftIcon: " + bFadeLeftIcon + ", bLeftIconFaded: " + bLeftIconFaded + ", AM.bAmmoModePending: " + AM.bAmmoModePending)
	
	if bFadeLeftIcon && !bLeftIconFaded && (Q == 1 && ((itemType == 5 || itemType == 6) && !bIsCGOLoaded)) || (bPlayerIsMounted && !bAmmoMode)
		fadeLeftIcon(true)						; If we're equipping 2H or ranged then check and fade left icon
	elseif Q < 2 && bLeftIconFaded && !(AM.bAmmoModePending || ((itemType == 5 || itemType == 6) && !bIsCGOLoaded) || (bPlayerIsMounted && bFadeLeftIcon && !bAmmoMode))
		fadeLeftIcon()							; For anything else check if it is currently faded and if so fade it back in
	endIf
	;debug.trace("iEquip_WidgetCore checkAndFadeLeftIcon end")
endFunction

bool property bWasSimpleAmmoMode auto hidden
bool bShoutSlotWasVisible

function onPlayerMount()
	bWasSimpleAmmoMode = AM.bSimpleAmmoMode

	if TP.bPoisonEquipped && TP.iThrowingPoisonHand == 0
		TP.OnThrowingPoisonUnequipped(true)
	endIf

	if bFadeLeftIcon && !bLeftIconFaded && !bAmmoMode
		fadeLeftIcon(true)						; Fade out
	endIf

	if bShoutEnabled && abWidget_V[3]
		UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", false)
		abWidget_V[3] = false
		bShoutSlotWasVisible = true
	else
		bShoutSlotWasVisible = false
	endIf

	if (bPreselectMode && PM.abPreselectSlotEnabled[0]) || (bAmmoMode && !AM.bSimpleAmmoMode)
		bool[] args = new bool[3]
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
	endIf

	AM.bSimpleAmmoMode = true
endFunction

function onPlayerDismount()
	;debug.trace("iEquip_WidgetCore onPlayerDismount start, bWasSimpleAmmoMode: " + bWasSimpleAmmoMode)
	AM.bSimpleAmmoMode = bWasSimpleAmmoMode

	if bLeftIconFaded && !AM.bAmmoModePending && !(bFadeLeftIcon && PlayerRef.GetEquippedObject(1) as weapon && (PlayerRef.GetEquippedWeapon().GetWeaponType() == 5 || PlayerRef.GetEquippedWeapon().GetWeaponType() == 6) && PlayerRef.GetEquippedWeapon().GetEquipType() == EquipSlots[3])
		fadeLeftIcon()							; Fade in
	endIf

	if bShoutEnabled && (bShoutSlotWasVisible || jArray.count(aiTargetQ[2]) > 0)
		;debug.trace("iEquip_WidgetCore onPlayerDismount - should be setting the shout slot back to visible now")
		UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", true)
		abWidget_V[3] = true
	endIf

	if (bPreselectMode && PM.abPreselectSlotEnabled[0]) || (bAmmoMode && !AM.bSimpleAmmoMode)

		;debug.trace("iEquip_WidgetCore onPlayerDismount - need to reshow left preselect slot")
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
		
		if(iHandle)
			;debug.trace("iEquip_WidgetCore onPlayerDismount - got iHandle")
			UICallback.PushInt(iHandle, 5) 													; Which slot we're updating
			if bPreselectMode || jArray.count(aiTargetQ[0]) > 0
				UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiTargetQ[0], aiCurrentlyPreselected[0]), "iEquipIcon"))
				UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiTargetQ[0], aiCurrentlyPreselected[0]), "iEquipName"))
			else
				UICallback.PushString(iHandle, "Fist")
				UICallback.PushString(iHandle, "$iEquip_common_Unarmed")
			endIf
			UICallback.PushFloat(iHandle, afWidget_A[aiNameElements[5]]) 					; Current item name alpha
			UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[5]]) 						; Current item icon alpha
			UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[5]]) 						; Current item icon scale
			UICallback.Send(iHandle)
		endIf
		
		;debug.trace("iEquip_WidgetCore onPlayerDismount - should be reshowing left preselect now")
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn")
		if(iHandle)
			UICallback.PushBool(iHandle, true)
			UICallback.PushBool(iHandle, false)
			UICallback.PushBool(iHandle, false)
			UICallback.PushFloat(iHandle, afWidget_A[35]) ; rightPreselectBackground alpha
			UICallback.PushFloat(iHandle, afWidget_A[36]) ; rightPreselectIcon alpha
			UICallback.PushFloat(iHandle, afWidget_A[37]) ; rightPreselectName alpha
			UICallback.Send(iHandle)
		endIf

		if bAmmoMode
			bCyclingLHPreselectInAmmoMode = true
		endIf

		updateAttributeIcons(0, aiCurrentlyPreselected[0])
		TI.updateTemperTierIndicator(5, jMap.getInt(jArray.getObj(aiTargetQ[0], aiCurrentlyPreselected[0]), "lastKnownTemperTier", 0))

		if bLeftRightNameFadeEnabled
			LPNUpdate.registerForNameFadeoutUpdate(aiNameElements[5])
		endIf
	endIf
endFunction

function fadeLeftIcon(bool fadeOut = false)
	float[] widgetData = new float[9]
	float adjustment = 1.0
	
	if fadeOut
		adjustment = (1 - (fLeftIconFadeAmount * 0.01))
	endIf
	
	if fadeOut && bDontFadeBackgrounds
		widgetData[0] = afWidget_A[6] ;leftBg_mc
	else
		widgetData[0] = afWidget_A[6] * adjustment ;leftBg_mc
	endIf
	
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
		elseIf CM.iChargeDisplayType == 2
			widgetData[6] = 1
			widgetData[7] = afWidget_A[14] * adjustment ;leftSoulgem_mc
		else
			widgetData[6] = 2
			widgetData[7] = afWidget_A[15] * adjustment ;leftRadialMeter_mc
		endIf
	endIf
	
	widgetData[8] = afWidget_A[16] * adjustment ;leftTierIndicator_mc
	
	UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenLeftIconAlpha", widgetData)
	bLeftIconFaded = fadeOut
endFunction

function checkAndEquipShownShoutOrConsumable(int Q, bool Reverse, int targetIndex, form targetItem, bool isPotionGroup)
	;debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable start - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", isPotionGroup: " + isPotionGroup)
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
			cycleShout(Q, targetIndex, targetItem)
		elseif Q == 3 && bConsumablesEnabled
			cycleConsumable(targetItem, targetIndex, isPotionGroup)
		elseif Q == 4 && bPoisonsEnabled
			cyclePoison(targetItem)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore checkAndEquipShownShoutOrConsumable end")
endFunction

function checkAndFadeConsumableIcon(bool fadeOut)
	;debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon start - fadeOut: " + fadeOut + ", bConsumableIconFaded: " + bConsumableIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		if PO.iEmptyPotionQueueChoice == 0 									; Fade
			float adjustment = (1 - (fconsIconFadeAmount * 0.01))
			if bDontFadeBackgrounds
				widgetData[0] = afWidget_A[47] 								; consumableBg_mc
			else
				widgetData[0] = afWidget_A[47] * adjustment 				; consumableBg_mc
			endIf
			widgetData[1] = afWidget_A[48] * adjustment 					; consumableIcon_mc
			if abIsNameShown[3]
				widgetData[2] = afWidget_A[49] * adjustment 				; consumableName_mc
			endIf
			widgetData[3] = afWidget_A[50]  * adjustment 					; consumableCount_mc
			UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
			bConsumableIconFaded = true
		endIf
	else 																	; For anything else fade it back in (we've already checked if it needs fading or not before calling this function)
		widgetData[0] = afWidget_A[47]
		widgetData[1] = afWidget_A[48]
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[49]
		endIf
		widgetData[3] = afWidget_A[50]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenConsumableIconAlpha", widgetData)
		bConsumableIconFaded = false
	endIf
	;debug.trace("iEquip_WidgetCore checkAndFadeConsumableIcon end")
endFunction

function checkAndFadePoisonIcon(bool fadeOut)
	;debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon start - fadeOut: " + fadeOut + ", bPoisonIconFaded: " + bPoisonIconFaded)
	float[] widgetData = new float[4]
	if fadeOut
		float adjustment = (1 - (fconsIconFadeAmount * 0.01)) 				; Use same value as consumable icon fade for consistency
		if bDontFadeBackgrounds
			widgetData[0] = afWidget_A[52]									; poisonBg_mc
		else
			widgetData[0] = afWidget_A[52] * adjustment 						; poisonBg_mc
		endIf
		widgetData[1] = afWidget_A[53] * adjustment 						; poisonIcon_mc
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[54] * adjustment 					; poisonName_mc
		endIf
		widgetData[3] = afWidget_A[55] * adjustment 						; poisonCount_mc
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenPoisonIconAlpha", widgetData)
		bPoisonIconFaded = true
																			; For anything else fade it back in (we've already checked if it needs fading or not before calling this function)
	else
		widgetData[0] = afWidget_A[52]
		widgetData[1] = afWidget_A[53]
		if abIsNameShown[3]
			widgetData[2] = afWidget_A[54]
		endIf
		widgetData[3] = afWidget_A[55]
		UI.InvokeFloatA(HUD_MENU, WidgetRoot + ".tweenPoisonIconAlpha", widgetData)
		bPoisonIconFaded = false
	endIf
	;debug.trace("iEquip_WidgetCore checkAndFadePoisonIcon end")
endFunction

function setCounterVisibility(int Q, bool show)
	;debug.trace("iEquip_WidgetCore setCounterVisibility start - Q: " + Q + ", show: " + show)
	if show || abIsCounterShown[Q] || bRefreshingWidget
		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenWidgetCounterAlpha")
		if iHandle
			UICallback.PushInt(iHandle, Q) 										; Which counter _mc we're fading out
			if show
				float targetAlpha = afWidget_A[aiCounterClips[Q]] 				; Get target count _mc alpha
				if targetAlpha < 1
					targetAlpha = 100
				endIf
				abIsCounterShown[Q] = true
				UICallback.PushFloat(iHandle, targetAlpha) 						; Target alpha
			else
				abIsCounterShown[Q] = false
				UICallback.PushFloat(iHandle, 0) 								; Target alpha = 0 to hide
			endIf
			UICallback.PushFloat(iHandle, 0.15) 								; Fade duration
			UICallback.Send(iHandle)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore setCounterVisibility end")
endFunction

function updateSlotsEnabled()
	;debug.trace("iEquip_WidgetCore updateSlotsEnabled start - bShoutEnabled: " + bShoutEnabled + ", bConsumablesEnabled: " + bConsumablesEnabled + ", bPoisonsEnabled: " + bPoisonsEnabled)
	bool bEnableShoutSlot = bShoutEnabled && !bPlayerIsMounted
	UI.Setbool(HUD_MENU, WidgetRoot + ".widgetMaster.ShoutWidget._visible", bEnableShoutSlot)
	abWidget_V[3] = bEnableShoutSlot
	if bShoutEnabled && bPlayerIsMounted
		bShoutSlotWasVisible = true
	endIf
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
	;debug.trace("iEquip_WidgetCore updateSlotsEnabled end")
endFunction

function updateQueuePositionIndicator(int Q, int count, int currPos, int newPos)
	;debug.trace("iEquip_WidgetCore updateQueuePositionIndicator start - Q: " + Q + ", count: " + count + ", currPos: " + currPos + ", newPos: " + newPos)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateQueuePositionIndicator")
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, count)
		UICallback.PushInt(iHandle, currPos)
		UICallback.PushInt(iHandle, newPos)
		UICallback.PushBool(iHandle, abCyclingQueue[Q])
		UICallback.PushBool(iHandle, bPreselectMode)
		if bPreselectMode
			UICallback.PushInt(iHandle, aiCurrentlyPreselected[Q])
		endIf
		UICallback.Send(iHandle)
	endIf
	;debug.trace("iEquip_WidgetCore updateQueuePositionIndicator end")
endFunction

function updatePotionSelector(bool bHide = false)
	;debug.trace("iEquip_WidgetCore updatePotionSelector start - bHide: " + bHide + ", bPotionSelectorShown: " + bPotionSelectorShown)
	;If we've just received the fadeout update then hide the selector and reset the currently selected type to restore
	if bHide
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".tweenPotionSelectorAlpha", 0.0)
		bPotionSelectorShown = false
		iPotionTypeChoice = 0
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".cyclePotionSelector", iPotionTypeChoice)
	;Otherwise update the counts as required
	else
		;Update the potion type counts
		int potionGroup = asPotionGroups.Find(asCurrentlyEquipped[3])

		string[] args = new string[3]
		args[0] = iEquip_StringExt.LocalizeString("$iEquip_WC_potionSelector_restore{" + PO.getCountForSelector(potionGroup, 0) + "}")
		args[1] = iEquip_StringExt.LocalizeString("$iEquip_WC_potionSelector_fortify{" + PO.getCountForSelector(potionGroup, 1) + "}")
		args[2] = iEquip_StringExt.LocalizeString("$iEquip_WC_potionSelector_regen{" + PO.getCountForSelector(potionGroup, 2) + "}")
		UI.InvokeStringA(HUD_MENU, WidgetRoot + ".updatePotionSelectorText", args)
		;If the selector isn't already shown then show it now
		if !bPotionSelectorShown
			UI.InvokeFloat(HUD_MENU, WidgetRoot + ".tweenPotionSelectorAlpha", afWidget_A[51])
			bPotionSelectorShown = true
			PSUpdate.registerForPotionSelectorFadeUpdate(fPotionSelectorFadeoutDelay)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore updatePotionSelector end")
endFunction

function updateWidget(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	;debug.trace("iEquip_WidgetCore updateWidget start - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bPreselectSwitchingHands: " + bPreselectSwitchingHands + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	;if we are in Preselect Mode make sure we update the preselect icon and name, otherwise update the main icon and name
	string sIcon
	string sName
	int targetObject
	int Slot = Q

	if bRefreshingWidget && Q > 4
		;debug.trace("iEquip_WidgetCore updateWidget - 1st option")
		targetObject = jArray.getObj(aiTargetQ[Q - 5], iIndex)
	elseif (bPreselectMode && !overridePreselect && !bPreselectSwitchingHands && (Q < 2 || Q == 2 && PM.bShoutPreselectEnabled)) || bCyclingLHPreselectInAmmoMode
		;debug.trace("iEquip_WidgetCore updateWidget - 2nd option")
		Slot += 5
		targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentlyPreselected[Q])
	elseif Q == 0 && bAmmoMode
		;debug.trace("iEquip_WidgetCore updateWidget - 3rd option")
		targetObject = AM.getCurrentAmmoObject()
	else
		;debug.trace("iEquip_WidgetCore updateWidget - 4th option")
		targetObject = jArray.getObj(aiTargetQ[Q], iIndex)
	endIf

	sIcon = jMap.getStr(targetObject, "iEquipIcon")
	if Q == 0 && bAmmoMode && !bCyclingLHPreselectInAmmoMode && AM.asAmmoIconSuffix[AM.iAmmoIconStyle] != ""
		sIcon += AM.asAmmoIconSuffix[AM.iAmmoIconStyle]
	endIf

	float fNameAlpha = afWidget_A[aiNameElements[Slot]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	if (Slot < 2 || Slot == 5 || Slot == 6) && TI.aiTemperedItemTypes.Find(jMap.getInt(targetObject, "iEquipType")) != -1
		sName =  jMap.getStr(targetObject, "lastDisplayedName")								; Last displayed name - includes renames and temper level if applicable
	endIf

	if sName == ""
		sName = jMap.getStr(targetObject, "iEquipName")										; New name
	endIf

	;debug.trace("iEquip_WidgetCore updateWidget about to call .updateWidget - Slot: " + Slot + ", sIcon: " + sIcon + ", sName: " + sName + ", fNameAlpha: " + fNameAlpha)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Slot) 													; Which slot we're updating
		UICallback.PushString(iHandle, sIcon) 												; New icon
		UICallback.PushString(iHandle, sName)
		UICallback.PushFloat(iHandle, fNameAlpha)											; Current item name alpha value
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[Slot]]) 						; Current item icon alpha value
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[Slot]]) 						; Current item icon scale value
		UICallback.Send(iHandle)
	endIf

	if Slot < 2 || Slot == 5 || Slot == 6
		updateAttributeIcons(Q, iIndex, overridePreselect, cycling)
		TI.updateTemperTierIndicator(Slot, jMap.getInt(targetObject, "lastKnownTemperTier"))
	endIf

	if bNameFadeoutEnabled
		if Slot == 0 && bLeftRightNameFadeEnabled
			LNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 1 && bLeftRightNameFadeEnabled
			RNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 2 && bShoutNameFadeEnabled
			SNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 3 && bConsPoisNameFadeEnabled
			CNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 4 && bConsPoisNameFadeEnabled
			PNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 5 && bLeftRightNameFadeEnabled
			LPNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 6 && bLeftRightNameFadeEnabled
			RPNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		elseif Slot == 7 && bShoutNameFadeEnabled
			SPNUpdate.registerForNameFadeoutUpdate(aiNameElements[slot])
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore updateWidget end")
endFunction

function updateWidgetBM(int Q, string sIcon, string sName)
	;debug.trace("iEquip_WidgetCore updateWidgetBM start")
	
	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	;debug.trace("iEquip_WidgetCore updateWidgetBM about to call .updateWidget - Slot: " + Q + ", sIcon: " + sIcon + ", sName: " + sName + ", fNameAlpha: " + fNameAlpha)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q) 								; Which slot we're updating
		UICallback.PushString(iHandle, sIcon) 						; New icon
		UICallback.PushString(iHandle, sName) 						; New name
		UICallback.PushFloat(iHandle, fNameAlpha) 					; Current item name alpha value
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[Q]]) 	; Current item icon alpha value
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[Q]]) 	; Current item icon scale value
		UICallback.Send(iHandle)
	endIf

	if bNameFadeoutEnabled
		if Q == 0 && bLeftRightNameFadeEnabled
			LNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 1 && bLeftRightNameFadeEnabled
			RNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 2 && bShoutNameFadeEnabled
			SNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore updateWidgetBM end")
endFunction

function setSlotToEmpty(int Q, bool hidePoisonCount = true, bool leaveFlag = false)
	;debug.trace("iEquip_WidgetCore setSlotToEmpty start - bIsFirstEnabled: " + bIsFirstEnabled)
	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	bool bLeaveBackground

	float adjustment = 1.0
	if Q == 0 && bPlayerIsMounted && bFadeLeftIcon && !bAmmoMode
		adjustment = (1 - (fLeftIconFadeAmount * 0.01))
	endIf

	; Set icon and name to empty
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q) 										; Which slot we're updating
		if (Q == 0 && !bAmmoMode) || Q == 1
			bLeaveBackground = true
			;debug.trace("iEquip_WidgetCore setSlotToEmpty - should be setting "+asQueueName[Q]+" to Unarmed")
			UICallback.PushString(iHandle, "Fist") 							; New icon
			UICallback.PushString(iHandle, "$iEquip_common_Unarmed") 		; New name
		else
			;debug.trace("iEquip_WidgetCore setSlotToEmpty - should be setting "+asQueueName[Q]+" to Empty")
			UICallback.PushString(iHandle, "Empty") 						; New icon
			UICallback.PushString(iHandle, " ") 							; New name
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha * adjustment)					; Current item name alpha value
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[Q]] * adjustment) 	; Current item icon alpha value
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[Q]]) 				; Current item icon scale value
		UICallback.Send(iHandle)
	endIf

	if !bLeaveBackground && iBackgroundStyle > 0
		int[] args = new int[2]
		args[0] = Q
		args[1] = 0
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)	; Set background to Hidden if not showing Fist
	endIf
	
	if (Q != 3 || !bPotionGrouping)
		asCurrentlyEquipped[Q] = ""
	endIf

	if Q < 2																; Hide any additional elements currently displayed
		hidePoisonInfo(Q, true)
		CM.updateChargeMeterVisibility(Q, false)
		setCounterVisibility(Q, false)
		if Q == 1
			if bAmmoMode
				if !TO.bJustCalledQuickLight
					AM.toggleAmmoMode()
				endIf
			elseIf bLeftIconFaded
				checkAndFadeLeftIcon(0, 0)
			endIf
		endIf
	elseIf Q == 3
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".updateDisplayedText", 50)		; consumableCount_mc
	elseIf Q == 4 && hidePoisonCount
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".updateDisplayedText", 55)		; poisonCount_mc

	elseIf Q == 5 || Q == 6
		hideAttributeIcons(Q)
		TI.updateTemperTierIndicator(Q)
	endIf
	if Q < 5 && !leaveFlag
		abQueueWasEmpty[Q] = true
	endIf
	;debug.trace("iEquip_WidgetCore setSlotToEmpty end")
endFunction

function handleEmptyPoisonQueue()
	;debug.trace("iEquip_WidgetCore handleEmptyPoisonQueue called")
	float fNameAlpha = afWidget_A[aiNameElements[4]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf
	
	;Hide the count by setting it to an empty string

	UI.InvokeInt(HUD_MENU, WidgetRoot + ".updateDisplayedText", 55)	; poisonCount_mc
	asCurrentlyEquipped[4] = ""
																	; Set to generic poison icon and name to empty before flashing/fading/hiding
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 4) 								; Which slot we're updating
		UICallback.PushString(iHandle, "Poison") 					; New icon
		UICallback.PushString(iHandle, " ") 							; New name
		UICallback.PushFloat(iHandle, fNameAlpha) 					; Current item name alpha value
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[4]]) 	; Current item icon alpha value
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[4]]) 	; Current item icon scale value
		UICallback.Send(iHandle)
	endIf
	if PO.bFlashPotionWarning
		UI.Invoke(HUD_MENU, WidgetRoot + ".runPoisonFlashAnimation")
		Utility.WaitMenuMode(1.2)
	endIf
	if PO.iEmptyPotionQueueChoice == 0 				; Fade icon
		checkAndFadePoisonIcon(true)
	else
		setSlotToEmpty(4, false)
	endIf
	;debug.trace("iEquip_WidgetCore handleEmptyPoisonQueue end")
endFunction

function checkIfBoundSpellEquipped()
	;debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped start")
	bool boundSpellEquipped
	int hand
	while hand < 2
		if PlayerRef.GetEquippedItemType(hand) == 9 && (iEquip_SpellExt.IsBoundSpell(PlayerRef.GetEquippedSpell(hand)) || (Game.GetModName(Math.LogicalAnd(Math.RightShift(PlayerRef.GetEquippedObject(hand).GetFormID(), 24), 0xFF)) == "Bound Shield.esp"))
			boundSpellEquipped = true
		endIf
		hand += 1
	endWhile
	;debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped called - boundSpellEquipped: " + boundSpellEquipped)
	; If the player has a bound spell equipped in either hand the event handler script registers for ActorAction 2 - Spell Fire, if not it unregisters for the action
	EH.boundSpellEquipped = boundSpellEquipped
	;debug.trace("iEquip_WidgetCore checkIfBoundSpellEquipped end")
endFunction

; Called from iEquip_PlayerEventHandler when OnActorAction receives actionType 2 (should only ever happen when the player has a 'Bound' spell equipped in either hand)
function onBoundWeaponEquipped(Int weaponType, Int hand)
	;debug.trace("iEquip_WidgetCore onBoundWeaponEquipped start")
	
	;if PlayerRef.GetEquippedObject(hand) as weapon && iEquip_WeaponExt.IsWeaponBound(PlayerRef.GetEquippedWeapon(hand)) && (PlayerRef.GetEquippedObject(hand).GetName() == asCurrentlyEquipped[hand])
		
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
	    ;debug.trace("iEquip_WidgetCore onBoundWeaponEquipped - iconName: " + iconName + ", weaponType: " + weaponType)
	    int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
														; Replace the spell icon with the correct bound weapon icon without updating the name as it should be the same anyway
		if(iHandle)
			UICallback.PushInt(iHandle, hand) 			; Target icon to update: left = 0, right  = 1
			UICallback.PushString(iHandle, iconName) 	; New icon label name
			UICallback.Send(iHandle)
		endIf
														; Now if we've equipped a bound ranged weapon we need to toggle Ammo Mode and show bound ammo in the left slot
	    if weaponType == 7 || weaponType == 9 			; Bound Bow or Bound Crossbow
	    	AM.onBoundRangedWeaponEquipped(weaponType)
	    elseIf weaponType == 5 || weaponType == 6 		; Bound 2H weapon
	    	checkAndFadeLeftIcon(hand, weaponType)
		endIf
	;endIf

	;debug.trace("iEquip_WidgetCore onBoundWeaponEquipped end")
endFunction

function onBoundWeaponUnequipped(int hand, bool isBoundShield = false)
	;debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped start - bBlockSwitchBackToBoundSpell: " + bBlockSwitchBackToBoundSpell)
	if bBlockSwitchBackToBoundSpell
		bBlockSwitchBackToBoundSpell = false
	else
		if PlayerRef.GetEquippedItemType(hand) == 9 && (iEquip_SpellExt.IsBoundSpell(PlayerRef.GetEquippedObject(hand) as spell) || isBoundShield) && (PlayerRef.GetEquippedObject(hand).GetName() == asCurrentlyEquipped[hand])

			hidePoisonInfo(hand) 								; In case we've poisoned the bound weapon we need to hide the poison info as we switch back to the spell icon
			
			int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateIconOnly")
																; Switch back to the spell icon from the bound weapon icon without updating the name as it should be the same anyway
			if(iHandle)
				UICallback.PushInt(iHandle, hand) 				; Target icon to update: left = 0, right  = 1
				UICallback.PushString(iHandle, "Conjuration") 	; New icon label name
				UICallback.Send(iHandle)
			endIf
			if bAmmoMode
				AM.toggleAmmoMode(bPreselectMode && PM.abPreselectSlotEnabled[0])
			endIf
			if bLeftIconFaded
				checkAndFadeLeftIcon(hand, 9)
			endIf
		;else
			;debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped - couldn't match removed bound weapon to an equipped spell")
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore onBoundWeaponUnequipped end")
endFunction

function showName(int Q, bool fadeIn = true, bool targetingPoisonName = false, float fadeoutDuration = 0.3)
	;debug.trace("iEquip_WidgetCore showName start - Q: " + Q + ", fadeIn: " + fadeIn + ", targetingPoisonName: " + targetingPoisonName + ", fadeoutDuration: " + fadeoutDuration)

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
				fNameAlpha = afWidget_A[11] * (1 - (fLeftIconFadeAmount * 0.01)) 	; leftPoisonName_mc
			else
				fNameAlpha = afWidget_A[8] * (1 - (fLeftIconFadeAmount * 0.01)) 	; leftName_mc
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
			UICallback.PushInt(iHandle, aiPoisonNameElements[Q]) 					; Which _mc we're fading out
		else
			UICallback.PushInt(iHandle, aiNameElements[Q]) 							; Which _mc we're fading out
		endIf
		UICallback.PushFloat(iHandle, fNameAlpha) 									; Target alpha which for FadeOut is 0
		UICallback.PushFloat(iHandle, fadeoutDuration) 								; FadeOut duration
		UICallback.Send(iHandle)
	endIf

	if bNameFadeoutEnabled && !EM.isEditMode
		if Q == 0 && bLeftRightNameFadeEnabled
			if targetingPoisonName
				LPoisonNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
			else
				LNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
			endIf
		elseif Q == 1 && bLeftRightNameFadeEnabled
			if targetingPoisonName
				RPoisonNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
			else
				RNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
			endIf
		elseif Q == 2 && bShoutNameFadeEnabled
			SNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 3 && bConsPoisNameFadeEnabled
			CNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 4 && bConsPoisNameFadeEnabled
			PNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 5 && bLeftRightNameFadeEnabled
			LPNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 6 && bLeftRightNameFadeEnabled
			RPNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
		elseif Q == 7 && bShoutNameFadeEnabled
			SPNUpdate.registerForNameFadeoutUpdate(aiNameElements[Q])
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
	;debug.trace("iEquip_WidgetCore showName end")
endFunction

function updateAttributeIcons(int Q, int iIndex, bool overridePreselect = false, bool cycling = false)
	;debug.trace("iEquip_WidgetCore updateAttributeIcons start - Q: " + Q + ", iIndex: " + iIndex + ", bPreselectMode: " + bPreselectMode + ", bAmmoMode: " + bAmmoMode + ", overridePreselect: " + overridePreselect + ", bCyclingLHPreselectInAmmoMode: " + bCyclingLHPreselectInAmmoMode + ", cycling: " + cycling)
	if bShowAttributeIcons
		string sAttributes
		bool isPoisoned
		bool isEnchanted
		int targetObject = -1
		int Slot = Q
		if bRefreshingWidget && Q > 4 && Q < 7
			if bPreselectMode
				targetObject = jArray.getObj(aiTargetQ[Q - 5], iIndex)
			endIf
		elseif (bPreselectMode && !overridePreselect && !bPreselectSwitchingHands && Q <= 2) || bCyclingLHPreselectInAmmoMode
			Slot += 5
			targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentlyPreselected[Q])
			bCyclingLHPreselectInAmmoMode = false
		else
			if Q < 2
				targetObject = jArray.getObj(aiTargetQ[Q], iIndex)
			endIf
		endIf
		if targetObject == -1 || (Slot == 0 && bAmmoMode)
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
			;debug.trace("iEquip_WidgetCore updateAttributeIcons - about to update icons in Slot " + Slot + " to " + sAttributes)
			int iHandle2 = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
			if(iHandle2)
				UICallback.PushInt(iHandle2, Slot) 				; Which slot we're updating
				UICallback.PushString(iHandle2, sAttributes) 	; New attributes
				UICallback.Send(iHandle2)
			endif
		endIf
	else
		bCyclingLHPreselectInAmmoMode = false
	endIf
	;debug.trace("iEquip_WidgetCore updateAttributeIcons end")
endFunction

function hideAttributeIcons(int Q)
	;debug.trace("iEquip_WidgetCore hideAttributeIcons start - Q: "+ Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateAttributeIcons")
	if(iHandle)
		UICallback.PushInt(iHandle, Q) 				; Which slot we're updating
		UICallback.PushString(iHandle, "hidden") 	; Hide attributes
		UICallback.Send(iHandle)
	endif
	;debug.trace("iEquip_WidgetCore hideAttributeIcons end")
endFunction

int function findInQueue(int Q, string itemToFind, form formToFind = none, int itemHandle = 0xFFFF)
	;debug.trace("iEquip_WidgetCore findInQueue start - Q: " + Q + ", formToFind: " + formToFind + ", itemToFind: " + itemToFind + ", itemHandle: " + itemHandle)
	int i
	bool found
	int targetQ = aiTargetQ[Q]
	int count = jArray.count(targetQ)
	int targetObj
	while i < count && !found
		targetObj = jArray.getObj(targetQ, i)
		if itemHandle != 0xFFFF && JArray.FindInt(iRefHandleArray, itemHandle) != -1
			;debug.trace("iEquip_WidgetCore findInQueue - seaching by handle")
			if itemHandle == jMap.getInt(targetObj, "iEquipHandle", 0xFFFF)
				found = true
			else
				i += 1
			endIf

		elseIf formToFind != none
			;debug.trace("iEquip_WidgetCore findInQueue - seaching by form")
			if formToFind == jMap.getForm(targetObj, "iEquipForm") && (itemHandle == 0xFFFF || jMap.getInt(targetObj, "iEquipHandle", 0xFFFF) == 0xFFFF)
				found = true
			else
				i += 1
			endIf

		else
			;debug.trace("iEquip_WidgetCore findInQueue - seaching by name")
			if itemToFind == jMap.getStr(targetObj, "iEquipName")
				found = true
			else
				i += 1
			endIf
		endIf
	endwhile
	if !found
		i = -1
	endIf
	;debug.trace("iEquip_WidgetCore findInQueue end - returning index: " + i)
	return i
endFunction

function removeTempItemFromQueue(int Q, int iIndex)
	int tempObj = jArray.getObj(aiTargetQ[Q], iIndex)
	form tempForm = jMap.getForm(tempObj, "iEquipForm")
	string tempName = jMap.getStr(tempObj, "iEquipName")
	int tempHandle = jMap.getInt(tempObj, "iEquipHandle", 0xFFFF)
	int otherQ
	if Q < 2
		otherQ = (Q + 1) % 2
	endIf

	if bMoreHUDLoaded
		int tempID = jMap.getInt(tempObj, "iEquipItemID")
		AhzMoreHudIE.RemoveIconItem(tempID)
		if Q < 2 && findInQueue(otherQ, tempName, tempForm, tempHandle) != -1
			AhzMoreHudIE.AddIconItem(tempID, asMoreHUDIcons[otherQ])
        endIf
    endIf
    
    jArray.eraseIndex(aiTargetQ[Q], iIndex)

    if Q == 2 || (findInQueue(Q, tempName, tempForm, tempHandle) == -1 && findInQueue(otherQ, tempName, tempForm, tempHandle) == -1)
    	iEquip_AllCurrentItemsFLST.RemoveAddedForm(tempForm)
		EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
    endIf
endFunction

function removeItemFromQueue(int Q, int iIndex, bool purging = false, bool cyclingAmmo = false, bool onItemRemoved = false, bool addToCache = true)
	;debug.trace("iEquip_WidgetCore removeItemFromQueue start - Q: " + Q + ", iIndex: " + iIndex + ", purging: " + purging + ", cyclingAmmo: " + cyclingAmmo + ", onItemRemoved: " + onItemRemoved + ", addToCache: " + addToCache)
	int targetQ = aiTargetQ[Q]
	int tempObj = jArray.getObj(targetQ, iIndex)

	if bEnableRemovedItemCaching && addToCache && !purging
		AddItemToLastRemovedCache(Q, iIndex)
	endIf
	if bMoreHUDLoaded
		int otherHand = (Q + 1) % 2
		AhzMoreHudIE.RemoveIconItem(jMap.getInt(tempObj, "iEquipItemID"))
		if Q < 2 && findInQueue(otherHand, jMap.getStr(tempObj, "iEquipName")) != -1
			AhzMoreHudIE.AddIconItem(jMap.getInt(tempObj, "iEquipItemID"), asMoreHUDIcons[otherHand])
        endIf
    endIf
    int itemType = jMap.getInt(tempObj, "iEquipType")
	jArray.eraseIndex(targetQ, iIndex)
	int queueLength = jArray.count(targetQ)
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
	;debug.trace("iEquip_WidgetCore removeItemFromQueue - queueLength: " + queueLength + ", enabledPotionGroupCount: " + enabledPotionGroupCount)
	; In the case of the consumables queue count will never drop below 3 because of the Potion Group slots, so either count has to be greater than 3 or at least one of the Potion Groups needs to be shown, otherwise hide the consumable widget
	if (Q != 3 && queueLength > 0) || (Q == 3 && (queueLength > 3 || enabledPotionGroupCount > 0))
		if aiCurrentQueuePosition[Q] > iIndex 			; If the item being removed is before the currently equipped item in the queue update the index for the currently equipped item
			;debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] > iIndex")
			aiCurrentQueuePosition[Q] = aiCurrentQueuePosition[Q] - 1
		elseif aiCurrentQueuePosition[Q] == iIndex 		; If you have removed the currently equipped item then if it was the last in the queue advance to index 0 and cycle the slot
			;debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] == iIndex")
			if aiCurrentQueuePosition[Q] == queueLength
				;debug.trace("iEquip_WidgetCore removeItemFromQueue - aiCurrentQueuePosition[Q] == queueLength")
				aiCurrentQueuePosition[Q] = 0
			endIf
			if !cyclingAmmo
				bool actionTaken
				if Q == 1 && (itemType == 7 || itemType == 9)
					 actionTaken = PM.quickRangedFindAndEquipWeapon(itemType, false)
				elseIf Q == 0
					if itemType == 26 ; Shield
						PM.quickShield(true)
						Utility.WaitMenuMode(0.5)
						if PlayerRef.GetEquippedShield()
							actionTaken = true
						endIf
					elseIf itemType == 31 && bJustDroppedTorch ; Torch
						bJustDroppedTorch = false
						actionTaken = true
					endIf
				endIf
				if !actionTaken
					cycleSlot(Q, false, true, onItemRemoved)
				endIf
			endIf
		endIf
	; Handle empty queue
	else
		; Empty poison queue has to match the behaiour of the potion groups in the consumables queue, so if any grouping is enabled check for fade/flash settings and mirror them
		if (Q == 4 && bPotionGrouping)
			handleEmptyPoisonQueue()
		else
			aiCurrentQueuePosition[Q] = -1
			asCurrentlyEquipped[Q] = ""
			setSlotToEmpty(Q)
		endIf
	endIf
	if Q < 3 && bPreselectMode
		if queueLength < 2
			setSlotToEmpty(Q + 5)
		elseIf aiCurrentlyPreselected[Q] == iIndex
			PM.cyclePreselectSlot(Q, jArray.count(targetQ))
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore removeItemFromQueue end")
endFunction



function AddItemToLastRemovedCache(int Q, int iIndex)
	;debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache start")
	int cacheSize = jArray.count(iRemovedItemsCacheObj)
	if cacheSize == iMaxCachedItems ; Max number of removed items to cache for re-adding
		form formToRemove = jMap.getForm(jArray.getObj(iRemovedItemsCacheObj, 0), "iEquipForm")
		int numForms = 1
		int i = 1
		while i < cacheSize
			if jMap.getForm(jArray.getObj(iRemovedItemsCacheObj, i), "iEquipForm") == formToRemove
				numForms += 1
			endIf
			i += 1
		endWhile
		if numForms == 1
			iEquip_RemovedItemsFLST.RemoveAddedForm(formToRemove)
		endIf
		jArray.eraseIndex(iRemovedItemsCacheObj, 0)
	endIf
	int objToCache = jArray.getObj(aiTargetQ[Q], iIndex)
	jMap.setInt(objToCache, "PrevQ", Q)
	jArray.addObj(iRemovedItemsCacheObj, objToCache)
	iEquip_RemovedItemsFLST.AddForm(jMap.getForm(objToCache, "iEquipForm"))
	;debug.trace("iEquip_WidgetCore AddItemToLastRemovedCache end")
endFunction

function addBackCachedItem(form addedForm)
	;debug.trace("iEquip_WidgetCore addBackCachedItem start")
	int iIndex
	int targetObject
	bool found
	while iIndex < jArray.count(iRemovedItemsCacheObj) && !found
		targetObject = jArray.getObj(iRemovedItemsCacheObj, iIndex)
		if addedForm == jMap.getForm(targetObject, "iEquipForm")
			int Q
			int itemType = jMap.getInt(targetObject, "iEquipType")
			;Check if the re-added item has been equipped in either hand and set that as the target queue
			if PlayerRef.GetEquippedObject(0) == addedForm && (ai2HWeaponTypes.Find(itemType) == -1 || (bIsCGOLoaded && itemType < 7))
				Q = 0
			elseIf PlayerRef.GetEquippedObject(1) == addedForm
				Q = 1
			;Otherwise add the item back into the queue it was previously removed from
			else
				Q = jMap.getInt(targetObject, "PrevQ")
			endIf
			if addedForm as weapon || (addedForm as armor && (addedForm as armor).isShield())
				jMap.setInt(targetObject, "iEquipHandle", 0xFFFF)		; The previous refHandle will have been invalidated when the item left the players inventory, and will be set to the new handle next time we equip the item
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
	;debug.trace("iEquip_WidgetCore addBackCachedItem end")
endFunction

; New in v1.5 - Battle Royale style auto equipping
int property iAutoEquipEnabled = 0 auto hidden 			; 0 = Disabled, 1 = Any time, 2 = Weapons drawn (Recommended), 3 = In combat only
int property iAutoEquip = 1 auto hidden 				; 0 = Always Equip, 1 = Equip if better than current, 2 = Equip if unarmed
int property iCurrentItemEnchanted auto hidden 			; 0 = Don't switch, 1 = Switch if no charge, 2 = Always switch
int property iCurrentItemPoisoned = 1 auto hidden 		; 0 = Don't switch, 1 = Always switch
bool property bAutoEquipHardcore auto hidden
bool property bAutoEquipDontDropFavorites = true auto hidden
bool property bJustDroppedCurrentItem auto hidden
form property fLastDroppedItem auto hidden

;/GetEquippedItemType returns:
0: Nothing (Hand to hand)
1: One-handed sword
2: One-handed dagger
3: One-handed axe
4: One-handed mace
5: Two-handed sword
6: Two-handed axe/mace
7: Bow
8: Staff
9: Magic spell
10: Shield
11: Torch
12: Crossbow/;

function onWeaponOrShieldAdded(form addedForm)
	;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded start - addedForm: " + addedForm.GetName() + ", iAutoEquipEnabled: " + iAutoEquipEnabled)
	if !EH.bPlayerIsABeast && (iAutoEquipEnabled == 1 || (iAutoEquipEnabled == 2 && PlayerRef.IsWeaponDrawn()) || (iAutoEquipEnabled == 3 && PlayerRef.IsInCombat()))

		int currLHItemType = PlayerRef.GetEquippedItemType(0)
		form currItem
		bool doEquip
		int indexToRemove = -1
		int targetHand

		if addedForm as armor														; Only shields will have been passed through from OnItemAdded
			;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - new shield added, currLHItemType: " + currLHItemType)

			if currLHItemType == 0 || (currLHItemType == 10 && ((iAutoEquip == 1 && (addedForm as armor).GetArmorRating() > (PlayerRef.GetEquippedShield().GetArmorRating() * WornObject.GetItemHealthPercent(PlayerRef, 0, 512))) || iAutoEquip == 0) && (PlayerRef.GetEquippedShield().GetEnchantment() == none || (iCurrentItemEnchanted == 2 || (iCurrentItemEnchanted == 1 && (addedForm as armor).GetEnchantment() != none && (addedForm as armor).GetArmorRating() > (PlayerRef.GetEquippedShield().GetArmorRating() * WornObject.GetItemHealthPercent(PlayerRef, 0, 512))))))

				doEquip = true

				if currLHItemType == 10
					indexToRemove = aiCurrentQueuePosition[0]
					currItem = PlayerRef.GetEquippedShield() as form
					;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - about to replace " + currItem.GetName())
				endIf
				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - should be equipping new shield now")
				PlayerRef.EquipItemEx(addedForm as Armor)
			endIf
		
		else
			;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - new weapon added")
			int currRHItemType = PlayerRef.GetEquippedItemType(1)
			weapon currLHWeapon = PlayerRef.GetEquippedWeapon(true)
			weapon currRHWeapon = PlayerRef.GetEquippedWeapon()
			int weaponType = (addedForm as weapon).GetWeaponType()
			bool currently2H
			if currRHWeapon
				currently2H = ai2HWeaponTypesAlt.Find(currRHItemType) != -1 && !(currRHItemType < 7 && bIsCGOLoaded)
			endIf
			int newWeaponDamage = (addedForm as weapon).GetBaseDamage()
			int rightWeaponDamage
			int leftWeaponDamage

			;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - currLHItemType: " + currLHItemType + ", currRHItemType: " + currRHItemType + ", new weapon type: " + weaponType + ", newWeaponDamage: " + newWeaponDamage)

			if currRHItemType > 0 && currRHItemType < 8 || currRHItemType == 12
				rightWeaponDamage = (currRHWeapon.GetBaseDamage() * WornObject.GetItemHealthPercent(PlayerRef, 1, 0)) as int
				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - currRHWeapon: " + currRHWeapon.GetName() + ", rightWeaponDamage: " + rightWeaponDamage)
			endIf

			if currLHItemType > 0 && (currLHItemType < 5 || (currLHItemType < 7 && bIsCGOLoaded))
				leftWeaponDamage = (currLHWeapon.GetBaseDamage() * WornObject.GetItemHealthPercent(PlayerRef, 0, 0)) as int
				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - currLHWeapon: " + currLHWeapon.GetName() + ", leftWeaponDamage: " + leftWeaponDamage)
			endIf

			bool emptyHanded

			if (weaponType == 7 || weaponType == 9)									; Bows and crossbows - will only be equipped if currently weilding a ranged weapon, or if both hands are empty
				
				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - handling new ranged weapon")
				if jArray.Count(AM.aiTargetQ[(weaponType == 9) as int]) > 0 && ((currLHItemType == 0 && currRHItemType == 0) || ((currRHItemType == 7 || currRHItemType == 12) && ((iAutoEquip == 1 && newWeaponDamage > rightWeaponDamage) || iAutoEquip == 0) && (iCurrentItemPoisoned == 1 || GetPoisonCount(currRHWeapon as form, GetRefHandleFromWornObject(1)) == 0) && (iCurrentItemEnchanted == 2 || currRHWeapon.GetEnchantment() == none || (iCurrentItemEnchanted == 1 && PlayerRef.GetActorValue("RightItemCharge") == 0.0 || ((addedForm as weapon).GetEnchantment() != none && newWeaponDamage > rightWeaponDamage)))))
					
					if currRHItemType > 0
						currItem = currRHWeapon as form
					endIf
					
					doEquip = true
					targetHand = 1
				
				endIf

			elseIf weaponType > 0 && weaponType < 7 								; 1H and 2H weapons (excluding fist weapons and staffs) - will only be equipped if replacing like for like (1H/2H) or if an empty hand is found

				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - handling new melee weapon")
				
				bool leftMatch
				if !currently2H
					leftMatch = currLHItemType == 0 || (((currLHItemType < 5 && weaponType < 5) || ((currLHItemType == 5 || currLHItemType == 6) && weaponType > 4)) && (GetPoisonCount(currLHWeapon as form, GetRefHandleFromWornObject(0)) == 0 || iCurrentItemPoisoned == 1) && (currLHWeapon.GetEnchantment() == none || iCurrentItemEnchanted == 2 || (iCurrentItemEnchanted == 1 && PlayerRef.GetActorValue("LeftItemCharge") == 0.0 || ((addedForm as weapon).GetEnchantment() != none && newWeaponDamage > leftWeaponDamage))))
				endIf

				bool rightMatch = currRHItemType == 0 || (((currRHItemType < 5 && weaponType < 5) || ((currRHItemType == 5 || currRHItemType == 6) && weaponType > 4)) && (GetPoisonCount(currRHWeapon as form, GetRefHandleFromWornObject(1)) == 0 || iCurrentItemPoisoned == 1) && (currRHWeapon.GetEnchantment() == none || iCurrentItemEnchanted == 2 || (iCurrentItemEnchanted == 1 && PlayerRef.GetActorValue("RightItemCharge") == 0.0 || ((addedForm as weapon).GetEnchantment() != none && newWeaponDamage > rightWeaponDamage))))

				int currDamage

				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - leftMatch: " + leftMatch + ", rightMatch: " + rightMatch)

				if leftMatch && rightMatch
					
					if rightWeaponDamage <= leftWeaponDamage
						targetHand = 1
					else
						targetHand = 2
					endIf

				elseIf rightMatch
					targetHand = 1

				elseIf leftMatch
					
					if bIsCGOLoaded || weaponType < 5	; This should stop 2H weapons being equipped in an empty left hand if CGO is not loaded
						targetHand = 2
					endIf
				endIf

				if targetHand == 1
					emptyHanded = currRHItemType == 0
					
					if !emptyHanded
						currDamage = rightWeaponDamage
					endIf
				elseIf targetHand == 2
					emptyHanded = currLHItemType == 0
					
					if !emptyHanded
						currDamage = leftWeaponDamage
					endIf
				endIf

				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - targetHand: " + targetHand + ", emptyHanded: " + emptyHanded + ", currDamage: " + currDamage)

				if targetHand > 0 && (emptyHanded || ((iAutoEquip == 1 && newWeaponDamage > currDamage) || iAutoEquip == 0))
					
					if !emptyHanded
						currItem = PlayerRef.GetEquippedObject((targetHand == 1) as int)
					endIf

					doEquip = true
					;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - doEquip: " + doEquip)
				endIf

			endIf

			if doEquip
				;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - should be equipping the " + addedForm.GetName() + " now")
				if weaponType == 5 || weaponType == 6 && bIsCGOLoaded && (addedForm as weapon).GetEquipType() == EquipSlots[3] ; BothHands
					; Give CGO enough time to change the equipSlot on 2H weapons to EitherHand
					int i
					while i < 20 && (addedForm as weapon).GetEquipType() != EquipSlots[2] ; EitherHand
						Utility.WaitMenuMode(0.05)
						i += 1
					endWhile
				endIf

				if !emptyHanded
					indexToRemove = aiCurrentQueuePosition[targetHand]
				endIf

				PlayerRef.EquipItemEx(addedForm, targetHand)

				if (weaponType == 7 && currRHItemType == 12) || (weaponType == 9 && currRHItemType == 7) 	; If we've just switched ranged weapon type then we'll also need to equip ammo for the new item
					AM.selectAmmoQueue(weaponType)
				endIf
			endIf

		endIf

		if doEquip && currItem && bAutoEquipHardcore && !(bAutoEquipDontDropFavorites && Game.isObjectFavorited(currItem))
			;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded - should be dropping the " + currItem.GetName() + " now")
			bJustDroppedCurrentItem = true
			fLastDroppedItem = currItem
			if indexToRemove != -1
				if bEnableRemovedItemCaching
					AddItemToLastRemovedCache(targetHand, indexToRemove)
				endIf
				jArray.eraseIndex(aiTargetQ[targetHand], indexToRemove)
			endIf
			DropItem(currItem)
		endIf

	endIf
	;debug.trace("iEquip_WidgetCore onWeaponOrShieldAdded end")
endFunction

function DropItem(form itemToDrop)
	;debug.trace("iEquip_WidgetCore DropItem start")
	objectreference droppedItem = PlayerRef.DropObject(itemToDrop, 1)

	;debug.trace("iEquip_WidgetCore Drop - droppedItem: " + droppedItem)
	
	Float OffsetX = 48.0 * Math.Sin(PlayerRef.GetAngleZ() - 15)
	Float OffsetY = 48.0 * Math.Cos(PlayerRef.GetAngleZ() - 15)
	Float OffsetZ
	If (PlayerRef.IsSneaking())
		OffsetZ = PlayerRef.GetHeight() - 72.0
	else
		OffsetZ = PlayerRef.GetHeight() - 32.0
	EndIf

	If (droppedItem.is3DLoaded())
		droppedItem.MoveTo(PlayerRef, OffsetX, OffsetY, OffsetZ, false)
	Else
		droppedItem.MoveToIfUnloaded(PlayerRef, OffsetX, OffsetY, OffsetZ)
	EndIf

	droppedItem.EnableNoWait()

	Int Tries = 0 
	While(Tries < 20 && (!droppedItem.is3DLoaded() || !droppedItem.IsEnabled()))
		Wait(0.05)
		Tries += 1
	EndWhile

	;debug.trace("iEquip_WidgetCore Drop - droppedItem is3Dloaded: " + droppedItem.is3DLoaded() + ", isEnabled: " + droppedItem.IsEnabled() + ", tries: " + Tries)
	
	droppedItem.SetMotionType(1) 				; Just in case the object has had havok disabled on it, to stop it hanging in mid-air
	droppedItem.ApplyHavokImpulse(0,0,1,5)

	droppedItem.SetActorOwner(PlayerRef.GetActorBase())
	droppedItem.SetFactionOwner(TO.PlayerFaction)

	;debug.trace("iEquip_WidgetCore Drop end")
endFunction

bool function playerStillHasItem(form itemForm, int itemHandle = 0xFFFF)
	;debug.trace("iEquip_WidgetCore playerStillHasItem start - itemForm: " + itemForm + ", itemHandle: " + itemHandle)
    int itemType = itemForm.GetType()
    bool stillHasItem
    ; This is a Spell or Shout and can't be counted like an item
    if (itemType == 22 || itemType == 119)
        stillHasItem = PlayerRef.HasSpell(itemForm)
    ; This is an inventory item
    elseIf itemHandle != 0xFFFF
    	stillHasItem = (JArray.FindInt(iRefHandleArray, itemHandle) != -1)
    else
        stillHasItem = (PlayerRef.GetItemCount(itemForm) > 0)
    endIf
    ;debug.trace("iEquip_WidgetCore playerStillHasItem returning " + stillHasItem)
    ;debug.trace("iEquip_WidgetCore playerStillHasItem end")
    return stillHasItem
endFunction

function cycleHand(int Q, int targetIndex, form targetItem, int itemType = -1, bool equippingOnAutoAdd = false)
	;debug.trace("iEquip_WidgetCore cycleHand start - Q: " + Q + ", targetIndex: " + targetIndex + ", targetItem: " + targetItem + ", itemType: " + itemType + ", equippingOnAutoAdd: " + equippingOnAutoAdd)
   	
   	bool otherHandUnequipped
    bool justSwitchedHands
    bool previouslyUnarmedOr2HSpell

   	bBlockSwitchBackToBoundSpell = true
   	
   	int targetObject = jArray.getObj(aiTargetQ[Q], targetIndex)
    
    if itemType == -1
    	itemType = jMap.getInt(targetObject, "iEquipType")
    endIf

    ; Set targetObjectIs2hOrRanged to true if the item we're about to equip is a 2H or ranged weapon
    bool targetObjectIs2hOrRanged = ((ai2HWeaponTypes.Find(itemType) > -1 && !(itemType < 7 && bIsCGOLoaded)) || (itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3))
   	
   	; When using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand, so we have to change the value for the left hand here 
   	int iEquipSlotId = 1
   	if Q == 0
    	iEquipSlotId = 2
    endIf

    int otherHand = (Q + 1) % 2

    ; Get the current (or previous if equippingOnAutoAdd) right hand item type and set previously2H to true if it is/was a 2H weapon or 2H spell
    int currRHType
    if equippingOnAutoAdd
    	currRHType = jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipType")
    else
    	currRHType = PlayerRef.GetEquippedItemType(1)
    endIf
    
    bool previously2H = ((currRHType == 5 || currRHType == 6) && !bIsCGOLoaded) || (equippingOnAutoAdd && currRHType == 22 && (jMap.getInt(jArray.getObj(aiTargetQ[1], aiCurrentQueuePosition[1]), "iEquipSlot") == 3)) || (!equippingOnAutoAdd && currRHType == 9 && EquipSlots.Find((PlayerRef.GetEquippedObject(1) as spell).GetEquipType()) == 3)
    
    ; Hide the attribute icons ready to show full poison and enchantment elements if required
    hideAttributeIcons(Q)

	;debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", iEquipSlotId = " + iEquipSlotId + ", otherHand = " + otherHand + ", bSwitchingHands = " + bSwitchingHands + ", bGoneUnarmed = " + bGoneUnarmed + ", currRHType: " + currRHType + ", previously2H: " + previously2H)
	; if we're switching hands we can reset to false now, and we don't need to unequip here because we already did so when we started switching hands
	if bSwitchingHands
		bSwitchingHands = false
		justSwitchedHands = true

	; Otherwise unequip current item if we need to
	elseIf (ai2HWeaponTypes.Find(itemType) > -1 && !(itemType < 7 && bIsCGOLoaded)) && !equippingOnAutoAdd && ai2HWeaponTypes.Find(currRHType) == -1
		UnequipHand(1)
		WaitMenuMode(0.4)
	endIf

	; if we're switching the left hand and it is going to cause a 2h or ranged weapon to be unequipped from the right hand then we need to ensure a suitable 1h item is equipped in its place, or we're about to equip a 2H/ranged item and we're currently unarmed or have a 2H spell equipped
    if (Q == 0 && (((equippingOnAutoAdd && ai2HWeaponTypes.Find(currRHType) > -1) || (!equippingOnAutoAdd && ai2HWeaponTypesAlt.Find(currRHType) > -1)) && !(currRHType < 7 && bIsCGOLoaded))) && !justSwitchedHands ;|| targetObjectIs2hOrRanged
    	if !targetObjectIs2hOrRanged
    		bSwitchingHands = true
    	endIf
    	if bGoneUnarmed || b2HSpellEquipped
    		previouslyUnarmedOr2HSpell = true
    	endIf
    endif
    ; In case we are re-equipping from an unarmed or 2H spell state
	bGoneUnarmed = false
	b2HSpellEquipped = false
	
	if !equippingOnAutoAdd
		; If we're about to equip a 1H item in RH forcing left hand to reequip, we need to re-equip the left hand first, making sure to block QuickDualCast, to avoid the right hand double draw animation
		if Q == 1 && jArray.count(aiTargetQ[0]) > 0 && (bJustLeftAmmoMode || previously2H) && !targetObjectIs2hOrRanged
			targetObject = jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0])
			PM.bBlockQuickDualCast = (jMap.getInt(targetObject, "iEquipType") == 22)
			bSwitchingHands = true
			;debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", bJustLeftAmmoMode: " + bJustLeftAmmoMode + ", about to equip left hand item of type: " + jMap.getInt(targetObject, "iEquipType") + ", blockQuickDualCast: " + PM.bBlockQuickDualCast)
			cycleHand(0, aiCurrentQueuePosition[0], jMap.getForm(targetObject, "iEquipForm"))
		endIf
		; If target item is a spell equip straight away
		if itemType == 22
			PlayerRef.EquipSpell(targetItem as Spell, Q)
			;debug.trace("iEquip_WidgetCore cycleHand - just equipped a spell, equip type: " + jMap.getInt(targetObject, "iEquipSlot") + ", bQuickDualCastEnabled: " + bQuickDualCastEnabled + ", justSwitchedHands: " + justSwitchedHands + ", bPreselectMode: " + bPreselectMode)
			if jMap.getInt(targetObject, "iEquipSlot") == 3 ; 2H spells
				updateOtherHandOn2HSpellEquipped(0)
			elseIf bQuickDualCastEnabled && !justSwitchedHands && !bPreselectMode
				spell targetSpell = targetItem as spell
				string spellSchool = jMap.getStr(targetObject, "iEquipSchool")
				;debug.trace("iEquip_WidgetCore cycleHand - spellSchool: " + spellSchool + ", QuickDualCast allowed: " + abQuickDualCastSchoolAllowed[asSpellSchools.find(spellSchool)])
				; Only allow QuickDualCast is the feature is enabled for this school, and if the equipped spell is GetEquipType == 2 (EitherHand), and as long as it's not a Bound 2H item or shield
				if abQuickDualCastSchoolAllowed[asSpellSchools.find(spellSchool)] && (jMap.getInt(targetObject, "iEquipSlot") == 2) && !(iEquip_FormExt.IsSpellWard(targetItem) || (ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(targetSpell)) > -1) || (Game.GetModName(Math.LogicalAnd(Math.RightShift(targetItem.GetFormID(), 24), 0xFF)) == "Bound Shield.esp"))
					;debug.trace("iEquip_WidgetCore cycleHand - about to QuickDualCast")
					if PM.quickDualCastEquipSpellInOtherHand(Q, targetItem, jMap.getStr(targetObject, "iEquipName"), jMap.getStr(targetObject, "iEquipIcon"))
						bSwitchingHands = false ; Just in case equipping the original spell triggered bSwitchingHands then as long as we have successfully dual equipped the spell we can cancel bSwitchingHands now
					endIf
				endIf
			endIf
		else
			; If item is anything other than a spell check if it is already equipped, possibly in the other hand, and there is only 1 of it
			int itemCount
			if targetItem
				itemCount = PlayerRef.GetItemCount(targetItem)
			endIf
		    if !otherHandUnequipped && (targetItem == PlayerRef.GetEquippedObject(otherHand)) && itemCount < 2
		    	;debug.trace("iEquip_WidgetCore cycleHand - targetItem found in other hand and only one of them")
		    	; If it is already equipped and player has allowed switching hands then unequip the other hand first before equipping the target item in this hand
		        if bAllowWeaponSwitchHands
		        	bSwitchingHands = true
		        	;debug.trace("iEquip_WidgetCore cycleHand - bSwitchingHands: " + bSwitchingHands)
		        	UnequipHand(otherHand)
		        else
		        	debug.notification(jMap.getStr(targetObject, "iEquipName") + " " + iEquip_StringExt.LocalizeString("$iEquip_WC_not_inOtherhand"))
		        	return
		        endIf
		    endIf
		    ; Equip target item
		    ;debug.trace("iEquip_WidgetCore cycleHand - about to equip " + jMap.getStr(targetObject, "iEquipName") + " into slot " + Q)
		    Utility.WaitMenuMode(0.1)
		    int refHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
		    if (Q == 1 && itemType == 42) 																		; Ammo in the right hand queue, so in this case grenades and other throwing weapons
		    	PlayerRef.EquipItemEx(targetItem as Ammo)
		    elseif ((Q == 0 && itemType == 26) || jMap.getStr(targetObject, "iEquipName") == "Rocket Launcher") ; Shield in the left hand queue
		    	if refHandle != 0xFFFF && !(PlayerRef.GetEquippedShield() && refHandle == iEquip_InventoryExt.GetRefHandleFromWornObject(2))
		    		iEquip_InventoryExt.EquipItem(targetItem, refHandle, PlayerRef)
		    		Utility.WaitMenuMode(0.2)
		    	endIf
		    	if PlayerRef.GetEquippedObject(Q) != targetItem
		    		PlayerRef.EquipItemEx(targetItem as Armor)
		    	endIf
		    elseIf targetItem as light
		    	;debug.trace("iEquip_WidgetCore cycleHand - this is a torch so equip using EquipItemEx")
		    	PlayerRef.EquipItemEx(targetItem, 0)
		    elseIf !(targetItem as weapon) || itemCount == 1													; If it's not a weapon, or we only have one of them there's no risk of equipping the wrong one so safe to use EquipItemEx
		    	;debug.trace("iEquip_WidgetCore cycleHand - not a weapon, or we only have one of these so equip using EquipItemEx")
		    	PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
		    else																								; If we have more than one of the item check if we have a valid refHandle and attempt to equip by handle
	    		if refHandle != 0xFFFF
	    			;debug.trace("iEquip_WidgetCore cycleHand - we have more than one of these and a refHandle so attempting to equip by handle")
	    			;debug.trace("iEquip_WidgetCore cycleHand - args being passed to EquipItem are targetItem: " + targetItem + ", refHandle: " + refHandle + ", PlayerRef: " + PlayerRef + ", equip slot: " + iEquipSlotId)
	    			iEquip_InventoryExt.EquipItem(targetItem, refHandle, PlayerRef, iEquipSlotId)
	    			Utility.WaitMenuMode(0.3)
	    		endIf
		    	
		    	if PlayerRef.GetEquippedObject(Q) != targetItem													; If nothing has been equipped check we have an itemID for it and try equipping it that way
    				int itemID = jMap.getInt(targetObject, "iEquipItemID")
			    	if itemID as bool 																			; This will fail if the display name has changed since we last equipped it, for example if the item has been renamed or a temper level has changed
			    		;debug.trace("iEquip_WidgetCore cycleHand - the item isn't enchanted or poisoned but we have an itemID so attempting to EquipItemByID")
			    		;debug.trace("iEquip_WidgetCore cycleHand - we have an itemID so attempting to EquipItemByID")
			    		PlayerRef.EquipItemByID(targetItem, itemID, iEquipSlotID)
			    		Utility.WaitMenuMode(0.3)
			    	endIf
		    		if PlayerRef.GetEquippedObject(Q) != targetItem												; Final check to confirm we actually have something equipped.  If all the above have failed fall back on EquipItemEX and take pot luck as to which one is equipped
		    			;debug.trace("iEquip_WidgetCore cycleHand - We still haven't succeeded in equipping anything so falling back on EquipItemEx and taking pot luck")
		    			PlayerRef.EquipItemEx(targetItem, iEquipSlotId)
	    				EH.abSkipQueueObjectUpdate[Q] = true 	
		    		endIf
		    	endIf
		    endIf
		endIf
		Utility.WaitMenuMode(0.2)
	; If we've just directly equipped and are auto adding a 2H spell now we need to show it in the left slot as well, which will also set b2HSpellEquipped to true blocking cycleHand(0) below
	elseIf itemType == 22 && jMap.getInt(targetObject, "iEquipSlot") == 3
		updateOtherHandOn2HSpellEquipped(0)
	endIf
	checkIfBoundSpellEquipped()
	checkAndUpdatePoisonInfo(Q)
	if itemType != 31	; TorchScript already handles this if we've just equipped a torch
		CM.checkAndUpdateChargeMeter(Q, true)
	endIf
	if TI.bFadeIconOnDegrade || TI.iTemperNameFormat > 0 || TI.bShowTemperTierIndicator
		TI.checkAndUpdateTemperLevelInfo(Q)
	endIf
	if (itemType == 7 || itemType == 9) && bAmmoModeFirstLook
		if bShowTooltips
			Utility.WaitMenuMode(0.5)
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AmmoModeFirstLook1"))
			Debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AmmoModeFirstLook2"))
		endIf
		bAmmoModeFirstLook = false
	endIf
	bool forceRight = (Q == 0 && TO.bJustCalledQuickLight && TO.bQuickLightEquipRH)
	;debug.trace("iEquip_WidgetCore cycleHand - Q: " + Q + ", TO.bJustCalledQuickLight: " + TO.bJustCalledQuickLight + ", TO.bQuickLightEquipRH: " + TO.bQuickLightEquipRH + ", forceRight: " + forceRight)
	; If we've just left ammo mode as a result of equipping on auto-add, check the other hand and if it's empty set the other hand slot to unarmed
	if bJustLeftAmmoMode && equippingOnAutoAdd && !forceRight
		if !PlayerRef.GetEquippedObject(otherHand)
    		setSlotToEmpty(otherHand)
    	endIf
    ; If we unequipped the other hand now equip the next item
    elseif bSwitchingHands
    	if equippingOnAutoAdd && !forceRight
    		if !PlayerRef.GetEquippedObject(otherHand)
    			setSlotToEmpty(otherHand)
    		endIf
    	else
    		if bPreselectMode
	    		bSwitchingHands = false
	    		bPreselectSwitchingHands = true
	    	endIf
	    	Utility.WaitMenuMode(0.1)
	    	if Q == 1 && previouslyUnarmedOr2HSpell
	    		reequipOtherHand(0)
	    	; If we just equipped the left hand causing a 2H item to be unequipped now re-equip the last known RH 1H item
	    	elseif Q == 0
				PM.quickShieldSwitchRightHand(31, false)
			else
				cycleSlot(otherHand, false, true)
			endIf
		endIf
	endIf

	TO.bJustCalledQuickLight = false
	EH.bJustQuickDualCast = false
	bBlockSwitchBackToBoundSpell = false
	;debug.trace("iEquip_WidgetCore cycleHand end")
endFunction

function goUnarmed()
	;debug.trace("iEquip_WidgetCore goUnarmed start")
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

	if iBackgroundStyle > 0
		int[] args = new int[2]
		args[0] = 0
		args[1] = iBackgroundStyle
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)	; Reshow the background if it was previously hidden
	endIf

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, 0)
		UICallback.PushString(iHandle, "Fist")
		UICallback.PushString(iHandle, "$iEquip_common_Unarmed")
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[0]])
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[0]])
		UICallback.Send(iHandle)
	endIf
	
	if bNameFadeoutEnabled && bLeftRightNameFadeEnabled
		LNUpdate.registerForNameFadeoutUpdate(aiNameElements[0])
	endIf
	;debug.trace("iEquip_WidgetCore goUnarmed - isAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
	if bAmmoMode && !bPreselectMode
		AM.toggleAmmoMode(true, true)
		if !AM.bSimpleAmmoMode
			bool[] args = new bool[3]
			args[2] = true
			UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
			args = new bool[4]
			UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
		endIf
	endIf
	bGoneUnarmed = true
	int i
	while i < 2
		hideAttributeIcons(i)
		TI.updateTemperTierIndicator(i)
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
		AM.unequipAmmo(targetAmmo)
	endIf

	EH.bGoingUnarmed = false
	bBlockSwitchBackToBoundSpell = false
	;debug.trace("iEquip_WidgetCore goUnarmed end")
endFunction

; Deprecated in v1.2
function updateLeftSlotOn2HSpellEquipped()
endFunction

function updateOtherHandOn2HSpellEquipped(int Q)
	;debug.trace("iEquip_WidgetCore updateOtherHandOn2HSpellEquipped start")
	int otherHand
	if Q == 0
		otherHand = 1
	endIf

	bBlockSwitchBackToBoundSpell = true
	;And now we need to update the left hand widget
	float fNameAlpha = afWidget_A[aiNameElements[Q]]
	if fNameAlpha < 1
		fNameAlpha = 100
	endIf

	if iBackgroundStyle > 0
		int[] args = new int[2]
		args[0] = Q
		args[1] = iBackgroundStyle
		UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)	; Reshow the background if it was previously hidden
	endIf

	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiTargetQ[otherHand], aiCurrentQueuePosition[otherHand]), "iEquipIcon")) ;Show the same icon and name in the left hand as already showing in the right
		UICallback.PushString(iHandle, asCurrentlyEquipped[otherHand])
		UICallback.PushFloat(iHandle, fNameAlpha)
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[Q]])
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[Q]])
		UICallback.Send(iHandle)
	endIf
	if bNameFadeoutEnabled && bLeftRightNameFadeEnabled
		if Q == 0
			LNUpdate.registerForNameFadeoutUpdate(aiNameElements[0])
		else
			RNUpdate.registerForNameFadeoutUpdate(aiNameElements[1])
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore updateOtherHandOn2HSpellEquipped - isAmmoMode: " + bAmmoMode + ", bPreselectMode: " + bPreselectMode)
	if Q == 0 && bAmmoMode && !bPreselectMode
		AM.toggleAmmoMode(true, true)
		bool[] args = new bool[3]
		args[2] = true
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
		args = new bool[4]
		UI.InvokeboolA(HUD_MENU, WidgetRoot + ".togglePreselect", args)
	endIf
	b2HSpellEquipped = true
	hideAttributeIcons(Q)
	TI.updateTemperTierIndicator(Q)
	setCounterVisibility(Q, false)
	hidePoisonInfo(Q)
	if CM.abIsChargeMeterShown[Q]
		CM.updateChargeMeterVisibility(Q, false)
	endIf
	ammo targetAmmo = AM.currentAmmoForm as Ammo
	if targetAmmo && bUnequipAmmo && PlayerRef.isEquipped(targetAmmo)
		AM.unequipAmmo(targetAmmo)
	endIf

	bBlockSwitchBackToBoundSpell = false
	;debug.trace("iEquip_WidgetCore updateOtherHandOn2HSpellEquipped end")
endFunction

function reequipOtherHand(int Q, bool equip = true)
	;debug.trace("iEquip_WidgetCore reequipOtherHand start")
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
		UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[Q]])
		UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[Q]])
		UICallback.Send(iHandle)
	endIf
	if equip
		cycleHand(Q, aiCurrentQueuePosition[Q], jMap.getForm(targetObject, "iEquipForm"), jMap.getInt(targetObject, "iEquipType"))
	endIf
	;debug.trace("iEquip_WidgetCore reequipOtherHand end")
endFunction

function cycleShout(int Q, int targetIndex, form targetItem)
    ;debug.trace("iEquip_WidgetCore cycleShout start")

    ; Turn off UI sounds to avoid annoying clicking noise while swapping spells
	_audioCategoryUI.Mute()
    
    int itemType = jMap.getInt(jArray.getObj(aiTargetQ[Q], targetIndex), "iEquipType")
    if itemType == 22
        PlayerRef.EquipSpell(targetItem as Spell, 2)
    else
        PlayerRef.EquipShout(targetItem as Shout)
    endIf
    
	; Turn UI sounds back on
	_audioCategoryUI.UnMute() 

    if iPosInd > 0
    	SPosUpdate.registerForFadeoutUpdate()
    endIf

    ;debug.trace("iEquip_WidgetCore cycleShout end")
endFunction

function cyclePotionSelector(bool reverse)
	;debug.trace("iEquip_WidgetCore cyclePotionSelector start")
	
	if !reverse
		iPotionTypeChoice += 1
		if iPotionTypeChoice == 3
			iPotionTypeChoice = 0
		endIf
	else
		iPotionTypeChoice -= 1
		if iPotionTypeChoice < 0
			iPotionTypeChoice = 2
		endIf
	endIf

	UI.InvokeInt(HUD_MENU, WidgetRoot + ".cyclePotionSelector", iPotionTypeChoice)

	PSUpdate.registerForPotionSelectorFadeUpdate(fPotionSelectorFadeoutDelay)

	;debug.trace("iEquip_WidgetCore cyclePotionSelector end")
endFunction

function cycleConsumable(form targetItem, int targetIndex, bool isPotionGroup)
	;debug.trace("iEquip_WidgetCore cycleConsumable start")
    int potionGroupIndex
    if isPotionGroup
    	potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], targetIndex), "iEquipName"))
    endIf
    ;debug.trace("iEquip_WidgetCore cycleConsumable - potionGroupIndex: " + potionGroupIndex + ", bConsumableIconFaded: " + bConsumableIconFaded)
    int count
    if isPotionGroup
    	count = PO.getPotionGroupCount(potionGroupIndex)
    elseIf(targetItem)
        count = PlayerRef.GetItemCount(targetItem)
    endIf
    setSlotCount(3, count)
    If bConsumableIconFaded && (!isPotionGroup || !(abPotionGroupEmpty[potionGroupIndex] && PO.iEmptyPotionQueueChoice == 0))
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
   	;debug.trace("iEquip_WidgetCore cycleConsumable end")
endFunction

function handleConsumableIconFadeAndFlash(int potionGroupIndex)
	;debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash start - potionGroup is empty, flash potion warning")
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
	;debug.trace("iEquip_WidgetCore handleConsumableIconFadeAndFlash end")
endFunction

function cyclePoison(form targetItem)
   	;debug.trace("iEquip_WidgetCore cyclePoison start")
	if bPoisonIconFaded
		checkAndFadePoisonIcon(false)
	endIf
    setSlotCount(4, PlayerRef.GetItemCount(targetItem))
    ;debug.trace("iEquip_WidgetCore cyclePoison end")
endFunction

;Uses the equipped item / potion in the consumable slot - no need to set counts here as this is done through OnItemRemoved in PlayerEventHandler > PO.onPotionRemoved
function consumeItem()
    ;debug.trace("iEquip_WidgetCore consumeItem start")
    if bConsumablesEnabled
        int potionGroupIndex = asPotionGroups.find(jMap.getStr(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipName"))
        if potionGroupIndex != -1
        	
        	; If the potion selector is currently shown then select and consume a potion of the selected type
        	if bPotionSelectorShown
        		PO.selectAndConsumePotion(potionGroupIndex, iPotionTypeChoice)
        		PSUpdate.registerForPotionSelectorFadeUpdate(fPotionSelectorFadeoutDelay)
        	; If the selector isn't currently shown and conditions to show selector are met then show it now
        	else
        		float currAV = PlayerRef.GetActorValue(asActorValues[potionGroupIndex])
	        	bool belowThreshold = (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, aiActorValues[potionGroupIndex]))) < PO.fConsRestoreThreshold
	        	;debug.trace("iEquip_WidgetCore consumeItem - stat: " + asActorValues[potionGroupIndex] + ", current damage: " + iEquip_ActorExt.GetAVDamage(PlayerRef, aiActorValues[potionGroupIndex]) + ", belowThreshold: " + belowThreshold + ", potion selector shown: " + bPotionSelectorShown)
	        	;debug.trace("iEquip_WidgetCore consumeItem - iPotionSelectorChoice: " + iPotionSelectorChoice + ", current stat %: " + (currAV / (currAV + iEquip_ActorExt.GetAVDamage(PlayerRef, aiActorValues[potionGroupIndex]))) + ", threshold: " + fSmartConsumeThreshold)
        		if iPotionSelectorChoice > 0 || !belowThreshold
	        		; If we have selected Consume & Show and the stat has any damage, or Smart Consume & Show and the stat is below the threshold then consume a suitable restore potion before showing the selector
	        		if iPotionSelectorChoice == 1 && belowThreshold
	        			PO.selectAndConsumePotion(potionGroupIndex, 0)
					endIf
					updatePotionSelector()
	        	; Or if we have selected Consume Or Show and the stat is damaged carry on and select and consume a restore potion without showing the selector
	        	else
	            	PO.selectAndConsumePotion(potionGroupIndex, 0)
	            endIf
	        endIf
        else
            form itemForm = jMap.getForm(jArray.getObj(aiTargetQ[3], aiCurrentQueuePosition[3]), "iEquipForm")
            if itemForm
                PlayerRef.EquipItemEx(itemForm)
            endIf
        endIf
    endIf
    ;debug.trace("iEquip_WidgetCore consumeItem end")
endFunction

int function showTranslatedMessage(int theMenu, string theString)
	;debug.trace("iEquip_WidgetCore showTranslatedMessage start - message type: " + theMenu)
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
	elseIf theMenu == 5
		iButton = iEquip_ConfirmClearQueue.Show()
	elseIf theMenu == 6
		iButton = iEquip_ConfirmDeletePreset.Show()
	elseIf theMenu == 7
		iButton = iEquip_ConfirmReset.Show()
	elseIf theMenu == 8
		iButton = iEquip_ConfirmResetParent.Show()
	elseIf theMenu == 9
		iButton = iEquip_ConfirmDiscardChanges.Show()
	elseIf theMenu == 10
		iButton = iEquip_SavePresetOptions.Show()
	endIf
	iEquip_MessageAlias.Clear()
	iEquip_MessageObjectReference.Disable()
	iEquip_MessageObjectReference.Delete()
	;debug.trace("iEquip_WidgetCore showTranslatedMessage end")
	return iButton
endFunction

function applyPoison(int Q)
	;debug.trace("iEquip_WidgetCore applyPoison start")

    if bPoisonsEnabled && !(TP.bPoisonEquipped && TP.iThrowingPoisonHand == Q)
    	int targetQ = aiTargetQ[Q]
    	if jArray.count(targetQ) == 0
    		if iShowPoisonMessages == 0
    			debug.notification("$iEquip_WC_not_noPoison")
    		endIf
    	else
	        int targetObj = jArray.getObj(aiTargetQ[4], aiCurrentQueuePosition[4])
	        Potion poisonToApply = jMap.getForm(targetObj, "iEquipForm") as Potion
	        if !poisonToApply || PlayerRef.GetItemCount(poisonToApply as form) < 1
	        	removeItemFromQueue(4, aiCurrentQueuePosition[4])
	            return
	        endIf
	        bool ApplyWithoutUpdatingWidget
	        int iButton
	        string newPoison = jMap.getStr(targetObj, "iEquipName")
	        bool isLeftHand = !(Q as bool)
	        string handName = "$iEquip_common_left"
	        if Q == 1
	            handName = "$iEquip_common_right"
	        endIf
	        Weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
	        string weaponName
	        int tempWeapType = -1
	        if currentWeapon
	            weaponName = currentWeapon.GetName()
	            tempWeapType = currentWeapon.GetWeaponType()
	        endIf

	        if (!currentWeapon) || tempWeapType == 0 || tempWeapType == 8
	        	if iShowPoisonMessages == 0
	        		if tempWeapType == 8
	        			debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_noStaffPoisoning"))
	        		else
	            		debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_noWeapon{" + handName + "}"))
	            	endIf
	            endIf
	            return
	        elseif currentWeapon != jMap.getForm(jArray.getObj(targetQ, aiCurrentQueuePosition[Q]), "iEquipForm") as Weapon && !iEquip_WeaponExt.IsWeaponBound(currentWeapon)
	            iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_ApplyToUnknownWeapon{" + weaponName + "}{" + handName + "}{" + newPoison + "}"))
	            if iButton != 0
	                return
	            endIf
	            ApplyWithoutUpdatingWidget = true
	        endIf

	        int refHandle = GetRefHandleFromWornObject(Q)

	        if refHandle == 0xFFFF
	        	debug.messagebox(iEquip_StringExt.LocalizeString("$iEquip_common_msg_noRefHandle"))
	        else
		        Potion currentPoison = iEquip_InventoryExt.GetPoison(currentWeapon as form, refHandle) 
		        ;debug.trace("iEquip_WidgetCore applyPoison - Q: " + Q + ", isLeftHand: " + isLeftHand + ", current weapon: " + currentWeapon + ", current poison: " + currentPoison)
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
		                    RemovePoison(currentWeapon as form, refHandle)
		                endIf	
		            elseIf bAllowPoisonTopup
		            	if iShowPoisonMessages < 2
			                iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_TopUp{" + weaponName + "}{" + currentPoisonName + "}"))
			                if iButton != 0
			                    return
			                endIf
			            endIf
			        else
			        	debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_alreadyPoisioned{" + weaponName + "}{" + currentPoisonName + "}"))
			        	return
		            endIf
		        elseif iShowPoisonMessages == 0
		            iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_WouldYouLikeToApply{" + newPoison + "}{" + weaponName + "}"))
		            if iButton != 0
		                return
		            endIf
		        endIf
		        
		        int ConcentratedPoisonMultiplier = 1
		        int AdditionalDoses

		        if bIsAdamantLoaded && PlayerRef.HasPerk(Game.GetFormFromFile(0x001E6934, "Adamant.esp") as Perk) 	; MAG_Intensity30 - Intensity Lvl 1 - Plus 4 hits
		        	AdditionalDoses = 4
		        	if PlayerRef.HasPerk(Game.GetFormFromFile(0x0037B9F1, "Adamant.esp") as Perk) 					; MAG_Intensity60 - Intensity Lvl 2 - Plus an additional 5 hits
		        		AdditionalDoses = 9
		        	endIf
		        
		        elseIf PlayerRef.HasPerk(ConcentratedPoison)													; If the player has the Concentrated Poison perk
		            if bIsOrdinatorLoaded
		            	AdditionalDoses = (PlayerRef.GetActorValue("Alchemy") / 10) as int						; If Ordinator is loaded then apply the Bottomless Cup calculation based on the players current Alchemy level
		            else
		            	ConcentratedPoisonMultiplier = iPoisonChargeMultiplier 									; Otherwise apply the multiplier set in the iEquip MCM slider (default = 2 (vanilla))
		            endIf
		        endIf
		        
		        int chargesToApply
		        
		        if iEquip_FormExt.isWax(poisonToApply as form) || iEquip_FormExt.isOil(poisonToApply as form)	; CACO waxes and Smithing Oils last for 10 uses so use that as the base value

		            chargesToApply = 10 * ConcentratedPoisonMultiplier
		        else
		            chargesToApply = iPoisonChargesPerVial * ConcentratedPoisonMultiplier						; Otherwise use the iEquip MCM 'Charges Per Vial' value as the base value (default = 1)
		        endIf

		        if tempWeapType == 7 && bIsAGOLoaded															; If Archery Gameplay Overhaul is loaded check and apply the Marksman level additional charges
		        	AdditionalDoses += (Game.GetFormFromFile(0x00005380, "DSerArcheryGameplayOverhaul.esp") as GlobalVariable).GetValueInt() - 1 	; DSer_PoisonCount - additional doses added are 1 less than the global value used to decide on the perk level
		        endIf

		        chargesToApply += AdditionalDoses
		        
		        if currentPoison == poisonToApply
		            SetPoisonCount(currentWeapon as form, refHandle, chargesToApply + GetPoisonCount(currentWeapon as form, refHandle))
		        else
		            SetPoison(currentWeapon as form, refHandle, poisonToApply, chargesToApply)
		        endIf
		        ; Remove one item from the player
		        PlayerRef.RemoveItem(poisonToApply, 1, true)
		        ; Flag the item as poisoned
		        targetObj = jArray.getObj(targetQ, aiCurrentQueuePosition[Q])
		        jMap.setInt(targetObj, "isPoisoned", 1)
		        jMap.setForm(targetObj, "lastKnownPoison", poisonToApply as Form)
		        if !ApplyWithoutUpdatingWidget
		            checkAndUpdatePoisonInfo(Q, false, false, refHandle)
		        endIf
		        ; Play sound
		        if iPoisonFX == 1 || iPoisonFX == 3
		        	iEquip_ITMPoisonUse.Play(PlayerRef)
		        endIf
		        ; Add Poison FX to weapon
		        if PlayerRef.IsWeaponDrawn() && iPoisonFX > 1
			        if Q == 0 || PlayerRef.GetEquippedItemType(0) == 7
						PLFX.cast(PlayerRef, PlayerRef)
			        else
						PRFX.cast(PlayerRef, PlayerRef)
			        endIf
			    endIf
		    endIf
		endIf
    endIf
    ;debug.trace("iEquip_WidgetCore applyPoison end")
endFunction

;Convenience function
function hidePoisonInfo(int Q, bool forceHide = false)
	;debug.trace("iEquip_WidgetCore hidePoisonInfo start")
	if abPoisonInfoDisplayed[Q] || forceHide
		checkAndUpdatePoisonInfo(Q, true, forceHide)
	endIf
	;debug.trace("iEquip_WidgetCore hidePoisonInfo end")
endFunction

function checkAndUpdatePoisonInfo(int Q, bool cycling = false, bool forceHide = false, int refHandle = 0xFFFF)
	;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo start")
	
	int itemType
	int charges
	Potion currentPoison
	int iHandle
	int[] args

	if !forceHide && !(TP.bPoisonEquipped && TP.iThrowingPoisonHand == Q)
		int targetObject = jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q])
		itemType = jMap.getInt(targetObject, "iEquipType")

		form equippedItem = PlayerRef.GetEquippedObject(Q)
		form targetForm = jMap.getForm(targetObject, "iEquipForm")

		if !equippedItem && !bGoneUnarmed && !(Q == 0 && (b2HSpellEquipped || itemType == 26))
			return
		endIf

		if itemType == 22 && IsBoundSpell(targetForm as Spell) && equippedItem as Weapon && iEquip_WeaponExt.IsWeaponBound(equippedItem as Weapon)
			itemType = GetBoundSpellWeapType(targetForm as Spell)
		endIf

		if equippedItem as weapon && isPoisonable(itemType)
			if refHandle == 0xFFFF
				;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - about to call GetRefHandleFromWornObject, Q: " + Q)
				refHandle = getHandle(Q, itemType, targetForm)
			endIf
			;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - about to call GetPoisonCount, equippedItem: " + equippedItem + ", refHandle: " + refHandle)
			charges = GetPoisonCount(equippedItem, refHandle)
		
			if charges > 0
				currentPoison = iEquip_InventoryExt.GetPoison(equippedItem, refHandle)
			endIf

			;if item isn't poisoned remove the poisoned flag
			if equippedItem == jMap.getForm(targetObject, "iEquipForm")
				;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - setting isPoisoned flag")
				if currentPoison
					jMap.setInt(targetObject, "isPoisoned", 1)
				else
					jMap.setInt(targetObject, "isPoisoned", 0)
				endIf
			endIf
		endIf
		
		;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", cycling: " + cycling + ", itemType: " + itemType + ", currentPoison: " + currentPoison + ", charges: " + charges)
	endIf
	
	;if the currently equipped item isn't poisonable, or if it isn't currently poisoned check and remove poison info is showing
	if cycling || !isPoisonable(itemType) || !currentPoison || (Q == 0 && bAmmoMode) || charges == 0
		if abPoisonInfoDisplayed[Q] || forceHide || bRefreshingWidget || !currentPoison
			;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - should be hiding poison icon and name now")
			;Hide the poison icon
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updatePoisonIcon")
			if(iHandle)
				UICallback.PushInt(iHandle, Q) ;Which slot we're updating
				UICallback.PushString(iHandle, "hidden") ;New icon
				UICallback.Send(iHandle)
			endIf
			;Hide the poison name
			showName(Q, false, true, 0.15)
			;Hide the counter if it's still showing and not needed
			if !(itemRequiresCounter(Q, jMap.getInt(jArray.getObj(aiTargetQ[Q], aiCurrentQueuePosition[Q]), "iEquipType")) || (Q == 0 && bAmmoMode && !(AM.bAmmoModePending || jArray.Count(AM.aiTargetQ[AM.Q]) == 0)))
				setCounterVisibility(Q, false)
			endIf
			;Reset the counter text colour
			args = new int[2]
			if Q == 0
				args[0] = 9 ;leftCount_mc
				args[1] = aiWidget_TC[9] ;leftCount text colour
			else
				args[0] = 26 ;rightCount_mc
				args[1] = aiWidget_TC[26] ;rightCount text colour
			endIf
			;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", about to set counter colour to " + args[1])
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
			abPoisonInfoDisplayed[Q] = false
		endIf
	;Otherwise update the poison name, count and icon
	else
		string iconName
		string poisonName = currentPoison.GetName()
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
		;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - poisonName: " + poisonName + ", charges: " + charges + ", iconName: " + iconName)
		if(iHandle)
			UICallback.PushInt(iHandle, Q) ;Which slot we're updating
			UICallback.PushString(iHandle, iconName) ;New icon
			UICallback.Send(iHandle)
		endIf
		;Update poison name
		string poisonNamePath
		int poisonNameElement
		if Q == 0
			poisonNamePath = ".widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName.text"
			poisonNameElement = 11 	; leftPoisonName_mc
		elseif Q == 1
			poisonNamePath = ".widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName.text"
			poisonNameElement = 28 	; rightPoisonName_mc
		endIf
		string currentlyDisplayedPoison = UI.GetString(HUD_MENU, WidgetRoot + poisonNamePath)
		;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - currentlyDisplayedPoison: " + currentlyDisplayedPoison + ", poisonName: " + poisonName)
		if currentlyDisplayedPoison != poisonName
			if abIsPoisonNameShown[Q]
				showName(Q, false, true, 0.15)
			endIf
			;UI.SetString(HUD_MENU, WidgetRoot + poisonNamePath, poisonName)
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateDisplayedText")
			If(iHandle)
				UICallback.PushInt(iHandle, poisonNameElement)
				UICallback.PushString(iHandle, poisonName)
				UICallback.Send(iHandle)
			endIf
		endIf
		if !abIsPoisonNameShown[Q]
			showName(Q, true, true, 0.15)
		endIf
		;Hide the counter, it'll be shown again below if needed
		setCounterVisibility(Q, false)
		setSlotCount(Q, charges)
		;Update poison counter
		if iPoisonIndicatorStyle < 2 ;Count Only or Single Drop & Count
			;Set counter text colour to match poison name
			args = new int[2]
			if Q == 0
				args[0] = 9 ;leftCount_mc
				args[1] = aiWidget_TC[11] ;leftPoisonName text colour
			else
				args[0] = 26 ;rightCount_mc
				args[1] = aiWidget_TC[28] ;rightPoisonName text colour
			endIf
			;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo - Q: " + Q + ", about to set counter colour to " + args[1])
			UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setTextColor", args)
			;Re-show the counter
			setCounterVisibility(Q, true)
		endIf
		abPoisonInfoDisplayed[Q] = true
	endIf
	;debug.trace("iEquip_WidgetCore checkAndUpdatePoisonInfo end")
endFunction

bool function isPoisonable(int itemType)
	return ((itemType > 0 && itemType < 8) || itemType == 9)
endFunction

bool function isWeaponPoisoned(int Q, int iIndex, bool cycling = false)
	;debug.trace("iEquip_WidgetCore isWeaponPoisoned start")
	bool isPoisoned
	;if we're checking the left hand item but we currently have a 2H or ranged weapon equipped, or if we're cycling we need to check the object data for the last know poison info
	if cycling || (Q == 0 && (ai2HWeaponTypesAlt.Find(PlayerRef.GetEquippedItemType(1)) > -1) && !(PlayerRef.GetEquippedItemType(1) < 7 && bIsCGOLoaded))
		isPoisoned = jMap.getInt(jArray.getObj(aiTargetQ[Q], iIndex), "isPoisoned") as bool
	;Otherwise we're checking an equipped item so we can check the actual data from the weapon
	elseIf PlayerRef.GetEquippedObject(Q) as weapon
		Potion currentPoison = iEquip_InventoryExt.GetPoison(PlayerRef.GetEquippedObject(Q), GetRefHandleFromWornObject(Q))
		if currentPoison
			isPoisoned = true
		else
			isPoisoned = false
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore isWeaponPoisoned end - Q: " + Q + ", iIndex: " + iIndex + ", isPoisoned: " + isPoisoned)
	return isPoisoned
endFunction

;Unequips item in hand
function UnequipHand(int Q)
    ;debug.trace("iEquip_WidgetCore UnequipHand start - Q: " + Q)
    int QEx = 1
    if (Q == 0)
        QEx = 2 ; UnequipSpell and UnequipItemEx need different hand arguments
    endIf
    Armor equippedShield = PlayerRef.GetEquippedShield()
    Form equippedItem = PlayerRef.GetEquippedObject(Q)
    ;debug.trace("iEquip_WidgetCore UnequipHand - equippedShield: " + equippedShield + ", equippedItem: " + equippedItem)
    if Q == 0 && equippedShield
    	PlayerRef.UnequipItemEx(equippedShield)
    elseif equippedItem
        if (equippedItem as Spell)
            PlayerRef.UnequipSpell(equippedItem as Spell, Q)
        elseif (Q == 1 && equippedItem as Ammo)
        	PlayerRef.UnequipItemEx(equippedItem as Ammo)
        else
            PlayerRef.UnequipItemEx(equippedItem, QEx, true)
        endIf
    endIf
    ;debug.trace("iEquip_WidgetCore UnequipHand end")
endFunction

;/ Here we are creating JMap objects for each queue item, containing all of the data we will need later on when cycling the widgets and equipping/unequipping
including formID, itemID, display name, itemType, isEnchanted, etc. These JMap objects are then placed into one of the JArray queue objects.
This means that when we cycle later on none of this has to be done on the fly saving time when time is of the essence /;

function addToQueue(int Q)
	;debug.trace("iEquip_WidgetCore addToQueue start")
	;Q - 0 = Left Hand, 1 = Right Hand, 2 = Shout, 3 = Consumable/Poison
	int itemFormID
	int itemID
	int listIndex = -1
	form itemForm
	string itemName
	
	if !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("CustomMenu") && !((Self as form) as iEquip_uilib).IsMenuOpen()
		
		itemFormID = UI.GetInt(sCurrentMenu, sEntryPath + ".selectedEntry.formId")
		
		if UI.IsMenuOpen("FavoritesMenu") || UI.IsMenuOpen("MagicMenu")
			itemForm = game.GetFormEx(itemFormID)
			itemName = UI.GetString(sCurrentMenu, sEntryPath + ".selectedEntry.text")
			if UI.IsMenuOpen("FavoritesMenu")
				;listIndex = UI.GetInt(sCurrentMenu, "_root.MenuHolder.Menu_mc.itemList.selectedIndex")
				itemID = UI.GetInt(sCurrentMenu, sEntryPath + ".selectedEntry.itemId")
			endIf
		
		elseIf UI.IsMenuOpen("InventoryMenu")
			listIndex = UI.GetInt("InventoryMenu", "_root.Menu_mc.inventoryLists.itemList.selectedIndex")
			itemName = UI.GetString(sCurrentMenu, sEntryPath + ".selectedEntry.text")
			itemForm = iEquip_UIExt.GetFormAtInventoryIndex(listIndex)
			itemID = CalcCRC32Hash(itemName, Math.LogicalAND(itemFormID, 0x00FFFFFF))
		
		else
			;debug.trace("iEquip_WidgetCore addToQueue something went wrong...")
			return
		endIf
	endIf

	;debug.notification("Inventory index for the " + itemName + " is " + listIndex)

	;int listLength = UI.GetInt("InventoryMenu", "_root.Menu_mc.inventoryLists.itemList.entryList.length")
	
	if itemForm
		;debug.trace("iEquip_WidgetCore addToQueue - passed the itemForm check, itemForm: " + itemForm + ", " + itemName + ", itemID: " + itemID)
		int itemType = itemForm.GetType()
		int iEquipSlot
		int itemHandle = 0xFFFF
		bool isEnchanted
		bool isPoisoned
		
		if itemType == 41 || itemType == 26 ; Weapons and shields only
			if listIndex > -1
				itemHandle = iEquip_InventoryExt.GetRefHandleAtInvIndex(listIndex)
				;debug.trace("iEquip_WidgetCore addToQueue - listIndex: " + listIndex + ", itemHandle: " + itemHandle)
				if itemHandle != 0xFFFF
					JArray.AddInt(iRefHandleArray, itemHandle)
					JArray.unique(iRefHandleArray)
					if itemType == 41
						isPoisoned = iEquip_InventoryExt.GetPoisonCount(itemForm, itemHandle) > 0
					endIf
				endIf
			endIf
			isEnchanted = UI.Getbool(sCurrentMenu, sEntryPath + ".selectedEntry.isEnchanted")
			
		elseIf itemType == 22
			iEquipSlot = EquipSlots.Find((itemForm as spell).GetEquipType())
			if iEquipSlot < 2 ; If the spell has a specific EquipSlot (LeftHand, RightHand) then add it to that queue
				Q = iEquipSlot
			elseIf iEquipSlot == 3 || ai2HWeaponTypes.Find(iEquip_SpellExt.GetBoundSpellWeapType(itemForm as spell)) > -1 ; If the spell is a two handed spell or a bound 2H weapon spell add it to right hand queue
				Q = 1
			endIf
			if iEquip_FormExt.IsSpellWard(itemForm) ; The only exception to this is any mod added spells flagged in the json patch to be considered a ward, ie Bound Shield, which need to be added to the left queue
				Q = 0
			endIf
		endIf
		
		int iButton
		if isItemValidForSlot(Q, itemForm, itemType, itemName)
			if Q == 3 && (itemForm as Potion).isPoison()
				Q = 4
			endIf
			
			if Math.LogicalAnd(itemFormID, 0xFF000000) == 0xFE000000
				itemID = 0 ; Just in case we've got itemID by adding a lightForm item through Favorites Menu we need to remove it because the hash is invalid for light formIDs
			endIf

			if !isAlreadyInQueue(Q, itemForm, itemID)

				if itemType == 41 ; If it is a weapon get the weapon type
			        itemType = (itemForm as Weapon).GetWeaponType()
			    endIf

				bool foundInOtherHandQueue
				if Q == 0 || (Q == 1 && (ai2HWeaponTypes.Find(itemType) == -1 || (itemType < 7 && bIsCGOLoaded)))
					foundInOtherHandQueue = isAlreadyInQueue((Q + 1) % 2, itemForm, itemID, itemHandle)
				endIf
				if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2) && !bAllowSingleItemsInBothQueues
					debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_InOtherQ{" + itemName + "}"))
					return
				endIf

				;if jArray.count(aiTargetQ[Q]) < iMaxQueueLength

					string itemIcon = GetItemIconName(itemForm, itemType, itemName)
					;debug.trace("iEquip_WidgetCore addToQueue(): Adding " + itemName + " to the " + iEquip_StringExt.LocalizeString(asQueueName[Q]) + ", formID = " + itemform + ", itemID = " + itemID as string + ", icon = " + itemIcon + ", isEnchanted = " + isEnchanted)

					if bShowQueueConfirmationMessages
						if foundInOtherHandQueue && itemType != 22 && (PlayerRef.GetItemCount(itemForm) < 2)
							iButton = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_AddToBoth{" + itemName + "}{" + asQueueName[Q] + "}"))
						else
							iButton = showTranslatedMessage(1, LocalizeString("$iEquip_WC_msg_AddToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
						endIf
						if iButton != 0
							return
						endIf
					endIf

					int iEquipItem = jMap.object()
					
					jMap.setForm(iEquipItem, "iEquipForm", itemForm)
					jMap.setStr(iEquipItem, "iEquipName", itemName)
					jMap.setStr(iEquipItem, "iEquipIcon", itemIcon)
					jMap.setInt(iEquipItem, "iEquipType", itemType)

					if Q < 2
						if itemType == 22
							if itemIcon == "DestructionFire" || itemIcon == "DestructionFrost" || itemIcon == "DestructionShock"
								jMap.setStr(iEquipItem, "iEquipSchool", "Destruction")
							else
								jMap.setStr(iEquipItem, "iEquipSchool", itemIcon)
							endIf
							jMap.setInt(iEquipItem, "iEquipSlot", iEquipSlot)
						else
							if TI.aiTemperedItemTypes.Find(itemType) > -1
								jMap.setInt(iEquipItem, "iEquipHandle", itemHandle)
								if itemHandle != 0xFFFF
									jMap.setStr(iEquipItem, "iEquipBaseName", iEquip_InventoryExt.GetShortName(itemForm, itemHandle))
									;debug.trace("iEquip_WidgetCore addToQueue - itemBaseName retrieved from itemHandle " + itemHandle + ": " + iEquip_InventoryExt.GetShortName(itemForm, itemHandle))
								else
									jMap.setStr(iEquipItem, "iEquipBaseName", "")
								endIf
								jMap.setStr(iEquipItem, "iEquipBaseIcon", itemIcon)
								jMap.setStr(iEquipItem, "temperedNameForQueueMenu", itemName)
								jMap.setStr(iEquipItem, "lastDisplayedName", itemName)
							endIf
							jMap.setInt(iEquipItem, "isEnchanted", isEnchanted as int)
							jMap.setInt(iEquipItem, "isPoisoned", isPoisoned as int)
						endIf
						EH.blackListFLSTs[Q].RemoveAddedForm(itemForm) 				; iEquip_LeftHandBlacklistFLST or iEquip_RightHandBlacklistFLST
					else
			        	EH.blackListFLSTs[2].RemoveAddedForm(itemForm) 				; iEquip_GeneralBlacklistFLST
					endIf

					if itemID as bool
						jMap.setInt(iEquipItem, "iEquipItemID", itemID) 			; Store SKSE itemID for non-spell items so we can use EquipItemByID to handle user enchanted/created/renamed items
						if bMoreHUDLoaded
							string moreHUDIcon
							if Q < 2
								AhzMoreHudIE.RemoveIconItem(itemID) 				; Does nothing if the itemID isn't registered so no need for the IsIconItemRegistered check
								if foundInOtherHandQueue
									moreHUDIcon = asMoreHUDIcons[3]
								else
				            		moreHUDIcon = asMoreHUDIcons[Q]
				            	endIf
				            else
				            	moreHUDIcon = asMoreHUDIcons[2]
				            endIf
				            AhzMoreHudIE.AddIconItem(itemID, moreHUDIcon)
				        endIf
					endIf

					jArray.addObj(aiTargetQ[Q], iEquipItem)
					iEquip_AllCurrentItemsFLST.AddForm(itemForm)
					EH.updateEventFilter(iEquip_AllCurrentItemsFLST)

					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AddedToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
				;else
					;debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_QIsFull{" + asQueueName[Q] + "}"))
				;endIf
			else
				int i = findInQueue(Q, itemName, itemForm, itemHandle)
				int targetObj = jarray.getObj(aiTargetQ[Q], i)
				if jMap.getInt(targetObj, "iEquipTempItem") == 1
					if bShowQueueConfirmationMessages
						iButton = showTranslatedMessage(1, LocalizeString("$iEquip_WC_msg_AddToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
						if iButton != 0
							return
						endIf
					endIf
					jMap.removeKey(targetObj, "iEquipTempItem")
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AddedToQ{" + itemName + "}{" + asQueueName[Q] + "}"))
				else	
					debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AlreadyAdded{" + itemName + "}{" + asQueueName[Q] + "}"))
				endIf
			endIf
		elseIf Q == 0 && itemType == 42 && AM.iEquip_AmmoBlacklistFLST.HasForm(itemForm)
			AM.onAmmoAdded(itemForm, true)
			debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_AmmoAdded{" + itemName + "}{" + asQueueName[(itemForm as ammo).IsBolt() as int + 5] + "}"))
		else
			if bIsFirstFailedToAdd
				debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_failToAdd"))
				bIsFirstFailedToAdd = false
			else
				debug.notification(iEquip_StringExt.LocalizeString("$iEquip_WC_not_CannotAdd{" + itemName + "}{"  + asQueueName[Q] + "}"))
			endIf
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore addToQueue end")
endFunction

bool function isItemValidForSlot(int Q, form itemForm, int itemType, string itemName, bool bSilent = false)
	;debug.trace("iEquip_WidgetCore isItemValidForSlot start - slot: " + Q + ", itemType: " + itemType)
	bool isValid
	bool isShout
	if itemType == 22
		isShout = ((itemForm as Spell).GetEquipType() == EquipSlots[4])
	endIf

	if Q == 0 ;Left Hand
		if itemType == 41 ;Weapon
        	int WeaponType = (itemForm as Weapon).GetWeaponType()
        	if WeaponType < 5 || (WeaponType < 7 && bIsCGOLoaded) || WeaponType == 8 ; Fists, 1H weapons and Staffs only, or 2H weapons if Combat Gameplay Overhaul is loaded
        		isValid = true
        	endIf
    	elseif (itemType == 22 && !isShout) || itemType == 23 || itemType == 31 || (itemType == 26 && (itemForm as Armor).GetSlotMask() == 512) ;Spell, Scroll, Torch, Shield
    		isValid = true
    	endIf
    elseif Q == 1 ;Right Hand
    	if itemType == 41 || (itemType == 22 && !isShout) || itemType == 23 || (itemType == 26 && itemName == "Rocket Launcher") ;Any weapon, Spell, Scroll, oh and the Rocket Launcher from Junks Guns because Kojak...
    		isValid = true
    	elseif itemType == 42 ;Ammo - looking for throwing weapons here, and these can only be equipped in the right hand
        	if iEquip_FormExt.IsJavelin(itemForm) || iEquip_FormExt.IsSpear(itemForm) || iEquip_FormExt.IsGrenade(itemForm) || iEquip_FormExt.IsThrowingKnife(itemForm) || iEquip_FormExt.IsThrowingAxe(itemForm)
        		if bSilent
        			isValid = true
        		else
					int iButton = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_throwingWeapons{" + itemName + "}{" + itemName + "}{" + asQueueName[Q] + "}"))
					if iButton == 0
	        			isValid = true
	        		endIf
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
    ;debug.trace("iEquip_WidgetCore isItemValidForSlot end - returning " + isValid)
    return isValid
endFunction

bool function isAlreadyInQueue(int Q, form itemForm, int itemID, int itemHandle = 0xFFFF)
	;debug.trace("iEquip_WidgetCore isAlreadyInQueue start - Q: " + Q + ", itemForm: " + itemForm + ", itemID: " + itemID)
	bool found
	int i
	int targetArray = aiTargetQ[Q]
	int targetObject
	while i < JArray.count(targetArray) && !found
		targetObject = jArray.getObj(targetArray, i)
		if itemHandle != 0xFFFF
			found = (itemHandle == jMap.getInt(targetObject, "iEquipHandle", 0xFFFF) && jMap.getInt(targetObject, "iEquipTempItem") == 0)
		elseIf itemID as bool
		    found = (itemID == jMap.getInt(targetObject, "iEquipItemID") && jMap.getInt(targetObject, "iEquipTempItem") == 0)
		else
		    found = (itemform == jMap.getForm(targetObject, "iEquipForm") && jMap.getInt(targetObject, "iEquipTempItem") == 0)
		endIf
		i += 1
	endWhile
	;debug.trace("iEquip_WidgetCore isAlreadyInQueue end")
return found
endFunction

string function GetItemIconName(form itemForm, int itemType, string itemName)
	;debug.trace("iEquip_WidgetCore GetItemIconName start - itemType: " + itemType + ", itemName: " + itemName)
    string IconName = "Empty"

    if itemType < 13 														; It is a weapon

    	int uniqueItemIndex = aUniqueItems.Find(itemForm as weapon)			; First check if it is a Unique
    	
    	int ZIAAltUniqueIndex = -1
    	if uniqueItemIndex == -1 && bIsZIALoaded
    		ZIAAltUniqueIndex = aZIAAltUniques.Find(itemForm as weapon)		; Or if it is one of the alternative uniques from ZIA
    	endIf

    	if uniqueItemIndex != -1
    		IconName = asUniqueItemIcons[uniqueItemIndex]

    	elseIf ZIAAltUniqueIndex != -1
    		IconName = aZIAAltUniques[ZIAAltUniqueIndex]
    	
    	elseIf bIsAALoaded 													; Next, if Animated Armoury is loaded check if it's a pike, halberd, quarterstaff or claw weapon (will also pick up Immersive Weapons and Heavy Armory weapons if the AA patches are loaded)
        	if itemForm.HasKeyword(WeapTypeHalberd)
        		IconName = "Halberd"
        	elseIf itemForm.HasKeyword(WeapTypeQtrStaff)
            	IconName = "Quarterstaff"
            elseIf itemForm.HasKeyword(WeapTypePike)
            	IconName = "Spear"
            elseIf itemType == 2 && Game.GetModName(Math.LogicalAnd(Math.RightShift(itemForm.GetFormID(), 24), 0xFF)) == "NewArmoury.esp"
            	IconName = "Claws"
            endIf
        endIf
        
        if IconName == "Empty"
	        if itemType == 6 && (itemForm as Weapon).IsWarhammer()			; 2H axes and maces have the same weapon type for some reason, so we have to differentiate them
	            	IconName = "Warhammer"

	        elseif (itemType == 1 || itemType == 5 || itemType == 6) && iEquip_FormExt.IsSpear(itemform) 	; 1 is for weapons from SpearsBySoolie and True Spear Combat, 5 is for Heavy Armory, 6 is for Immersive Weapons
	        	IconName = "Spear"
	        
	        elseif itemType == 4 && iEquip_FormExt.IsGrenade(itemform) 		; Looking for CACO grenades here which are classed as maces
	        	IconName = "Grenade"

	        else
	        	IconName = asWeaponTypeNames[itemType]						; Otherwise give it a base weapon name
	        endIf
	    endIf

    elseif itemType == 26 && (itemForm as Armor).GetSlotMask() == 512 		; Shield
    	IconName = "Shield"

    elseif itemType == 23
    	IconName = "Scroll"

    elseif itemType == 31
    	IconName = "Torch"

    elseif itemType == 119
    	if EH.bPlayerIsABeast && BM.currRace == 0 							; Werewolf
    		IconName = "Howl"
    	else
    		IconName = "Shout"
    	endIf
    
    elseif itemType == 22 													; Is a spell
        Spell S = itemForm as Spell

    	if S.GetEquipType() == EquipSlots[4]
    		IconName = "Power"
    		if EH.bPlayerIsABeast && BM.currRace > 0
    			if BM.currRace == 1 										; Vampire Lord
    				IconName += "Vamp"
    			else 														; 2 - Lich
    				IconName += "Lich"
    			endIf
    		endIf
    	else
        	IconName = getSpellSchool(S)
        	if IconName == "Destruction"
        		MagicEffect sEffect = S.GetNthEffectMagicEffect(S.GetCostliestEffectIndex())
        		;debug.trace("iEquip_WidgetCore GetItemIconName - spell has MagicCloak keyword: " + S.HasKeyword(MagicCloak) + ", effect has MagicCloak keyword: " + sEffect.HasKeyword(MagicCloak))
        		; ToDo - finish this off (for SE only)
        		if S.HasKeyword(MagicCloak)
        			;debug.trace("iEquip_WidgetCore GetItemIconName - should be setting IconName to MagicCloak")
        			IconName = "MagicCloak"
        			S = iEquip_MagicEffectExt.GetAssociatedItem(sEffect) as Spell
        			sEffect = S.GetNthEffectMagicEffect(S.GetCostliestEffectIndex())
        		endIf
        		;debug.trace("iEquip_WidgetCore GetItemIconName - IconName: " + IconName + ", strongest magic effect: " + sEffect + ", " + (sEffect as form).GetName())
        		if sEffect.HasKeyword(MagicDamageFire)
        			IconName += "Fire"
        		elseIf sEffect.HasKeyword(MagicDamageFrost)
        			IconName += "Frost"
        		elseIf sEffect.HasKeyword(MagicDamageShock)
        			IconName += "Shock"
        		elseIf bIsRequiemLoaded && sEffect.HasKeyword(REQ_KW_PoisonSpell)
        			IconName += "Poison"
        		endIf
        	endIf
        endIf
        if !IconName
        	if EH.bPlayerIsABeast && BM.currRace > 0
        		if BM.currRace == 1 										; Vampire Lord
        			IconName = "SpellVamp"
        		else 														; 2 - Lich
        			IconName = "SpellLich"
        		endIf
        	else
        		IconName = "Spellbook"
        	endIf
        endIf

    elseif itemType == 42 													; Ammo - Throwing weapons
    	if iEquip_FormExt.IsSpear(itemform) || iEquip_FormExt.IsJavelin(itemform)
			IconName = "Spear"
		elseif iEquip_FormExt.IsGrenade(itemform)
			IconName = "Grenade"
		elseif iEquip_FormExt.IsThrowingAxe(itemform)
			IconName = "ThrowingAxe"
		elseif iEquip_FormExt.IsThrowingKnife(itemform)
			IconName = "ThrowingKnife"
		endIf
    
    elseif itemType == 46 													; Is a potion
        Potion P = itemForm as Potion
        if(P.IsPoison())
            IconName = "Poison"
        elseIf(P.IsFood()) 													; Only way to differentiate between food and drink types is by checking their consume sound
        	if P.GetUseSound() == Game.GetForm(0x0010E2EA) 					; NPCHumanEatSoup
            	IconName = "Soup"
            elseif P.GetUseSound() == Game.GetForm(0x000B6435) 				; ITMPotionUse
            	IconName = "Drink"
            else
            	IconName = "Food"
            endIf
        else
	        string pStr = P.GetNthEffectMagicEffect(P.GetCostliestEffectIndex()).GetName()
			
	        if (find(pStr, "Health") != -1)
	            IconName = "HealthPotion"
	        elseIf (find(pStr, "Magicka") != -1)
	            IconName = "MagickaPotion" 
	        elseIf (find(pStr, "Stamina") != -1)
	            IconName = "StaminaPotion" 
	        elseIf (pStr == "Resist Fire")
	            IconName = "FireResistPotion" 
	        elseIf (pStr == "Resist Shock")
	            IconName = "ShockResistPotion" 
	        elseIf (pStr == "Resist Frost")
	            IconName = "FrostResistPotion"
	        else
	        	IconName = "Potion"
	        endIf
	    endIf
    endIf
    ;debug.trace("iEquip_WidgetCore GetItemIconName end - returning IconName as " + IconName)
    return IconName
endFunction

string function getSpellSchool(spell spellToCheck)
	return spellToCheck.GetNthEffectMagicEffect(spellToCheck.GetCostliestEffectIndex()).GetAssociatedSkill()
endFunction

; Called by MCM if user has disabled Allow Single Items In Both Queues to remove duplicate 1h items from the right hand queue
function purgeQueue()
	;debug.trace("iEquip_WidgetCore purgeQueue start")
	int i
	int targetArray = aiTargetQ[1]
	int count = jArray.count(targetArray)
	;debug.trace("iEquip_WidgetCore purgeQueue - " + count + " items in right hand queue")
	int targetObject
	form itemForm
	int itemType
	int itemID
	int itemHandle
	
	while i < count
		targetObject = jArray.getObj(targetArray, i)
		itemForm = jMap.getForm(targetObject, "iEquipForm")
		itemType = jMap.getInt(targetObject, "iEquipType")
		itemID = jMap.getInt(targetObject, "iEquipItemID")
		itemHandle = jMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
		;debug.trace("iEquip_WidgetCore purgeQueue - index: " + i + ", itemForm: " + itemForm + ", itemID: " + itemID)
		if isAlreadyInQueue(0, itemForm, itemID, itemHandle) && PlayerRef.GetItemCount(itemForm) < 2 && itemType != 22
			removeItemFromQueue(1, i, true)
			count -= 1
			i -= 1
		endIf
		i += 1
	endwhile
	;debug.trace("iEquip_WidgetCore purgeQueue end")
endFunction

; From 1.2 - Called from ClearDependencies if CGO was previously installed but has been removed to clear any 2H weapons from the left hand queue
function remove2HWeaponsFromLeftQueue()
	;debug.trace("iEquip_WidgetCore remove2HWeaponsFromLeftQueue start")
	int i
	int targetArray = aiTargetQ[0]
	int count = jArray.count(targetArray)
	int targetObject
	int itemType
	
	while i < count
		targetObject = jArray.getObj(targetArray, i)
		itemType = jMap.getInt(targetObject, "iEquipType")
		;debug.trace("iEquip_WidgetCore remove2HWeaponsFromLeftQueue - index: " + i + ", itemType: " + itemType)
		if itemType == 5 || itemType == 6
			removeItemFromQueue(0, i, true)
			count -= 1
			i -= 1
		endIf
		i += 1
	endwhile
	;debug.trace("iEquip_WidgetCore remove2HWeaponsFromLeftQueue end")
endFunction

function openQueueManagerMenu(int Q = -1)
	;debug.trace("iEquip_WidgetCore openQueueManagerMenu start")
	if Q == -1
		Q = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_queuemenu_title")) ;0 = Exit, 1 = Left hand queue, 2 = Right hand queue, 3 = Shout queue, 4 = Consumable queue, 5 = Poison queue, 6 = Arrow queue, 7 = Bolt queue
	else
		bJustUsedQueueMenuDirectAccess = true
	endIf
	if Q > 0
		if Q > 5	; Ammo queues
			iQueueMenuCurrentArray = AM.aiTargetQ[Q - 6]
		else
			iQueueMenuCurrentArray = aiTargetQ[Q - 1]
		endIf
		Q -= 1
		int queueLength = jArray.count(iQueueMenuCurrentArray)
		if queueLength < 1
			debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[Q] + "}"))
			recallQueueMenu()
		else
			int i
			;Remove any empty indices before creating the menu arrays
			while i < queueLength
				if !JMap.getStr(jArray.getObj(iQueueMenuCurrentArray, i), "iEquipName")
					jArray.eraseIndex(iQueueMenuCurrentArray, i)
					queueLength -= 1
				endIf
				i += 1
			endWhile
			iQueueMenuCurrentQueue = Q
			initQueueMenu(queueLength)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore openQueueManagerMenu end")
endFunction

function QueueMenuSwitchView()
	bBlacklistMenuShown = !bBlacklistMenuShown
	string toggleButtonLabel
	int count = aBlacklistFLSTs[iQueueMenuCurrentQueue].GetSize()
	if bBlacklistMenuShown
		QueueMenuShowBlacklist()
	else
		toggleButtonLabel = iEquip_StringExt.LocalizeString("$iEquip_btn_showBlacklist{" + count + "}")
		QueueMenuUpdate(jArray.Count(iQueueMenuCurrentArray))
	endIf

	((Self as Form) as iEquip_UILIB).QueueMenu_UpdateButtons(count > 0, bBlacklistMenuShown, true, toggleButtonLabel)

	if iQueueMenuCurrentQueue > 4
		string ammoSortingText
		if !bBlacklistMenuShown
			ammoSortingText = iEquip_StringExt.LocalizeString("$iEquip_WC_ammoSorting_text{" + asAmmoSorting[AM.iAmmoListSorting] + "}")
		endIf
		QueueMenu_UpdateHeader(ammoSortingText)
	endIf
endFunction

function QueueMenuShowBlacklist(int count = -1, bool update = false, int iIndex = 0)
	;debug.trace("iEquip_WidgetCore QueueMenuShowBlacklist start")

	formlist targetList = aBlacklistFLSTs[iQueueMenuCurrentQueue]
	if count == -1
		count = targetList.GetSize()
	endIf
	string[] iconNames = Utility.CreateStringArray(count)
	string[] itemNames = Utility.CreateStringArray(count)
	bool[] enchFlags = Utility.CreateBoolArray(count)
	bool[] poisonFlags = Utility.CreateBoolArray(count)
	afCurrentBlacklistForms = Utility.CreateFormArray(count)
	int i

	while i < count
		form tmpForm = targetList.GetAt(i)
		string tmpName = tmpForm.GetName()
		int itemType = tmpForm.GetType()
		if itemType == 41
			itemType = (tmpForm as weapon).GetWeaponType()
		endIf

		if iQueueMenuCurrentQueue > 2 || (iQueueMenuCurrentQueue < 2 && (itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_FormExt.isGrenade(tmpForm))))
			tmpName += " (" + PlayerRef.GetItemCount(tmpForm) + ")"

		endIf
		iconNames[i] = "Empty"
		itemNames[i] = tmpName
		enchFlags[i] = false
		poisonFlags[i] = false
		afCurrentBlacklistForms[i] = tmpForm
		i += 1
	endWhile

	((Self as Form) as iEquip_UILIB).QueueMenu_RefreshList(iconNames, itemNames, enchFlags, poisonFlags, iIndex)

	if !update
		string title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_blacklistTitleWithCount{" + count + "}{" + asBlacklistNames[iQueueMenuCurrentQueue] + "}")
		QueueMenu_RefreshTitle(title)
	endIf

	;debug.trace("iEquip_WidgetCore QueueMenuShowBlacklist end")
endFunction

function initQueueMenu(int queueLength, bool update = false, int iIndex = 0)
	;debug.trace("iEquip_WidgetCore initQueueMenu start")

	bBlacklistMenuShown = false

	string[] iconNames = Utility.CreateStringArray(queueLength)
	string[] itemNames = Utility.CreateStringArray(queueLength)
	bool[] enchFlags = Utility.CreateBoolArray(queueLength)
	bool[] poisonFlags = Utility.CreateBoolArray(queueLength)
	int i
	string itemName
	
	while i < queueLength
		int targetObject = jArray.getObj(iQueueMenuCurrentArray, i)
		int itemType = JMap.getInt(targetObject, "iEquipType")
		
		if iQueueMenuCurrentQueue < 2 && TI.aiTemperedItemTypes.Find(itemType) != -1
			iconNames[i] = JMap.getStr(targetObject, "iEquipBaseIcon")
			itemName = JMap.getStr(targetObject, "temperedNameForQueueMenu")
			if itemName == ""
				itemName = JMap.getStr(targetObject, "iEquipName")
			endIf
		else
			iconNames[i] = JMap.getStr(targetObject, "iEquipIcon")
			itemName = JMap.getStr(targetObject, "iEquipName")
		endIf
		if iQueueMenuCurrentQueue < 3
			if JMap.getInt(targetObject, "iEquipTempItem") == 1
				itemName = "(T) " + itemName
			endIf
		endIf
		if iQueueMenuCurrentQueue > 3 || (iQueueMenuCurrentQueue == 3 && asPotionGroups.Find(itemName) == -1) || (iQueueMenuCurrentQueue < 2 && (itemType == 42 || itemType == 23 || itemType == 31 || (itemType == 4 && iEquip_FormExt.isGrenade(jMap.getForm(targetObject, "iEquipForm")))))
			itemName += " (" + PlayerRef.GetItemCount(JMap.getForm(targetObject, "iEquipForm")) + ")"
		endIf
		itemNames[i] = itemName
		enchFlags[i] = JMap.getInt(targetObject, "isEnchanted") as bool
		poisonFlags[i] = JMap.getInt(targetObject, "isPoisoned") as bool
		i += 1
	endWhile
	if update
		((Self as Form) as iEquip_UILIB).QueueMenu_RefreshList(iconNames, itemNames, enchFlags, poisonFlags, iIndex)
	else
		string title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_titleWithCount{" + queueLength + "}{" + asQueueName[iQueueMenuCurrentQueue] + "}")
		int blacklistCount = aBlacklistFLSTs[iQueueMenuCurrentQueue].GetSize()
		string toggleButtonLabel
		if blacklistCount > 0
			toggleButtonLabel = iEquip_StringExt.LocalizeString("$iEquip_btn_showBlacklist{" + blacklistCount + "}")
		endIf
		string ammoSortingText
		if iQueueMenuCurrentQueue > 4
			ammoSortingText = iEquip_StringExt.LocalizeString("$iEquip_WC_ammoSorting_text{" + asAmmoSorting[AM.iAmmoListSorting] + "}")
		endIf
		((Self as Form) as iEquip_UILIB).ShowQueueMenu(title, iconNames, itemNames, enchFlags, poisonFlags, 0, 0, bJustUsedQueueMenuDirectAccess, blacklistCount > 0, iQueueMenuCurrentQueue > 4, toggleButtonLabel, ammoSortingText)
	endIf
	;debug.trace("iEquip_WidgetCore initQueueMenu end")
endFunction

function recallQueueMenu()
	;debug.trace("iEquip_WidgetCore recallQueueMenu start")
	if bJustUsedQueueMenuDirectAccess
		bJustUsedQueueMenuDirectAccess = false
	else
		Utility.WaitMenuMode(0.05)
		openQueueManagerMenu()
	endIf
	;debug.trace("iEquip_WidgetCore recallQueueMenu end")
endFunction

function recallPreviousQueueMenu()
	;debug.trace("iEquip_WidgetCore recallPreviousQueueMenu start")
	initQueueMenu(jArray.count(iQueueMenuCurrentArray))
	;debug.trace("iEquip_WidgetCore recallPreviousQueueMenu end")
endFunction

function QueueMenuSwap(int upDown, int iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuSwap start")
	;upDown - 0 = Move Up, 1 = Move Down
	if iQueueMenuCurrentQueue > 4 && AM.iAmmoListSorting > 0 && bFirstAttemptToEditAmmoQueue
		bFirstAttemptToEditAmmoQueue = false
		if bShowTooltips
			((Self as Form) as iEquip_UILIB).closeQueueMenu()
			int iButton = showTranslatedMessage(4, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_editAmmoQueue"))
			recallPreviousQueueMenu()
		endIf
	endIf	

	int count = jArray.count(iQueueMenuCurrentArray)
	if upDown == 0
		if iIndex != 0
			jArray.swapItems(iQueueMenuCurrentArray, iIndex, iIndex - 1)
			iIndex -= 1
		endIf
	else
		if iIndex != (count - 1)
			jArray.swapItems(iQueueMenuCurrentArray, iIndex, iIndex + 1)
			iIndex += 1
		endIf
	endIf
	
	if iQueueMenuCurrentQueue > 4 	; If we've just edited an ammo queue make sure to set Ammo Sorting to manual now to block any re-sorting
		AM.iAmmoListSorting = 0
		AM.iLastSortType = 0
		QueueMenu_RefreshAmmoSortingText(iEquip_StringExt.LocalizeString("$iEquip_WC_ammoSorting_text{" + asAmmoSorting[AM.iAmmoListSorting] + "}"))
	endIf
	
	QueueMenuUpdate(count, iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuSwap end")
endFunction

function QueueMenuClearFlag(int index)
	jMap.removeKey(jarray.getObj(iQueueMenuCurrentArray, index), "iEquipTempItem")
endFunction

function QueueMenuRemoveFromQueue(int iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuRemoveFromQueue start")

	if bBlacklistMenuShown
		aBlacklistFLSTs[iQueueMenuCurrentQueue].RemoveAddedForm(afCurrentBlacklistForms[iIndex])
		BlacklistMenuUpdate(aBlacklistFLSTs[iQueueMenuCurrentQueue].GetSize(), iIndex)

	elseIf iQueueMenuCurrentQueue > 4 	; Ammo queues
		QueueMenuRemoveFromAmmoQueue(iIndex)
	else
		int targetObject = jArray.getObj(iQueueMenuCurrentArray, iIndex)
		string itemName = JMap.getStr(targetObject, "iEquipName")
		if !(iQueueMenuCurrentQueue < 2 && itemName == "$iEquip_common_Unarmed") && !(iQueueMenuCurrentQueue == 3 && (asPotionGroups.Find(itemName) > -1))
			bool keepInFLST
			int itemID = JMap.getInt(targetObject, "iEquipItemID")
			int itemHandle = JMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
			form itemForm = JMap.getForm(targetObject, "iEquipForm")
			if bMoreHUDLoaded
				AhzMoreHudIE.RemoveIconItem(itemID)
			endIf
			if iQueueMenuCurrentQueue < 2
				int otherHandQueue = 1
				if iQueueMenuCurrentQueue == 1
					otherHandQueue = 0
				endIf
				if isAlreadyInQueue(otherHandQueue, itemForm, itemID, itemHandle)
					if bMoreHUDLoaded
						AhzMoreHudIE.AddIconItem(itemID, asMoreHUDIcons[otherHandQueue])
					endIf
					keepInFLST = true
				endIf
	        endIf
	        ;Add manually removed items to the relevant blackList
	        if bBlacklistEnabled && itemForm != TO.realTorchForm
		        aBlackListFLSTs[iQueueMenuCurrentQueue].AddForm(itemForm) ;iEquip_LeftHandBlacklistFLST or iEquip_RightHandBlacklistFLST
		    endIf
	        if !keepInFLST && itemForm != TO.realTorchForm
	        	iEquip_AllCurrentItemsFLST.RemoveAddedForm(itemForm)
	        	EH.updateEventFilter(iEquip_AllCurrentItemsFLST)
	        endIf
	        if TI.aiTemperedItemTypes.Find(JMap.getInt(targetObject, "iEquipType")) != -1 && itemHandle != 0xFFFF
	        	JArray.EraseIndex(iRefHandleArray, JArray.FindInt(iRefHandleArray, itemHandle))
	        endIf
	    endIf
		jArray.eraseIndex(iQueueMenuCurrentArray, iIndex)
		int queueLength = jArray.count(iQueueMenuCurrentArray)
		if iIndex >= queueLength
			iIndex = queueLength - 1
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
			initQueueMenu(jArray.count(iQueueMenuCurrentArray))
		else
			QueueMenuUpdate(queueLength, iIndex)
		endIf
	endIf
	;debug.trace("iEquip_WidgetCore QueueMenuRemoveFromQueue end")
endFunction

function QueueMenuRemoveFromAmmoQueue(int iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuRemoveFromAmmoQueue start")
	if bFirstAttemptToRemoveAmmo
		bFirstAttemptToRemoveAmmo = false
		if bShowTooltips
			((Self as Form) as iEquip_UILIB).closeQueueMenu()
			int iButton = showTranslatedMessage(4, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_removeAmmo"))
			recallPreviousQueueMenu()
		endIf
	endIf
	AM.removeAmmoFromQueue(iQueueMenuCurrentQueue - 5, iIndex, true)
	int queueLength = jArray.count(iQueueMenuCurrentArray)
	if iIndex >= queueLength
		iIndex = queueLength - 1
	endIf
	QueueMenuUpdate(queueLength, iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuRemoveFromAmmoQueue end")
endFunction

function QueueMenuUpdate(int iCount, int iIndex = 0)
	;debug.trace("iEquip_WidgetCore QueueMenuUpdate start")
	string title
	if iCount < 1
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_common_EmptyQueue{" + asQueueName[iQueueMenuCurrentQueue] + "}")
	else
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_titleWithCount{" + iCount + "}{" + asQueueName[iQueueMenuCurrentQueue] + "}")
	endIf
	QueueMenu_RefreshTitle(title)
	initQueueMenu(iCount, true, iIndex)
	int count = aBlacklistFLSTs[iQueueMenuCurrentQueue].GetSize()
	if count > 0
		((Self as Form) as iEquip_UILIB).QueueMenu_UpdateButtons(true, false, true, iEquip_StringExt.LocalizeString("$iEquip_btn_showBlacklist{" + count + "}"))
	endIf
	;debug.trace("iEquip_WidgetCore QueueMenuUpdate end")
endFunction

function BlacklistMenuUpdate(int iCount, int iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuUpdate start")
	string title
	if iCount < 1
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_common_emptyBlacklist{" + asBlacklistNames[iQueueMenuCurrentQueue] + "}")
	else
		title = iEquip_StringExt.LocalizeString("$iEquip_WC_lbl_blacklistTitleWithCount{" + iCount + "}{" + asBlacklistNames[iQueueMenuCurrentQueue] + "}")
	endIf
	QueueMenu_RefreshTitle(title)
	QueueMenuShowBlacklist(iCount, true, iIndex)
	;debug.trace("iEquip_WidgetCore QueueMenuUpdate end")
endFunction

function QueueMenuClearQueue()
	;debug.trace("iEquip_WidgetCore QueueMenuClearQueue start")
	if bBlacklistMenuShown && iQueueMenuCurrentQueue < 5
		aBlacklistFLSTs[iQueueMenuCurrentQueue].Revert()
		int iButton = showTranslatedMessage(4, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_QCleared{" + asBlacklistNames[iQueueMenuCurrentQueue] + "}"))
		recallPreviousQueueMenu()

	elseIf iQueueMenuCurrentQueue > 4	; Ammo queues
		bool bDontClear
		if bFirstAttemptToClearAmmoQueue
			bFirstAttemptToClearAmmoQueue = false
			;((Self as Form) as iEquip_UILIB).closeQueueMenu()
			int iButton = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_WC_msg_resetAmmoQueue"))
			bDontClear = iButton as bool
		endIf
		if !bDontClear
			KH.bAllowKeyPress = false
			debug.Notification(iEquip_StringExt.LocalizeString("$iEquip_WC_msg_resettingAmmoQueues"))
			AM.iEquip_AmmoBlacklistFLST.Revert()
			AM.updateAmmoLists(true)
			KH.bAllowKeyPress = true
		endIf
		recallPreviousQueueMenu()
	else
		int targetObject
		string itemName
		int count = jArray.count(iQueueMenuCurrentArray) - 1
		while count > -1
			targetObject = jArray.getObj(iQueueMenuCurrentArray, count)
			itemName = JMap.getStr(targetObject, "iEquipName")
			if !(iQueueMenuCurrentQueue == 3 && (asPotionGroups.Find(itemName) > -1)) && !(iQueueMenuCurrentQueue < 2 && itemName == "$iEquip_common_Unarmed")
				bool keepInFLST
				int itemID = JMap.getInt(targetObject, "iEquipItemID")
				int itemHandle = JMap.getInt(targetObject, "iEquipHandle", 0xFFFF)
				form itemForm = JMap.getForm(targetObject, "iEquipForm")
				if bMoreHUDLoaded
					AhzMoreHudIE.RemoveIconItem(itemID)
				endIf
				if iQueueMenuCurrentQueue < 2
					int otherHandQueue = 1
					if iQueueMenuCurrentQueue == 1
						otherHandQueue = 0
					endIf
					if isAlreadyInQueue(otherHandQueue, itemForm, itemID, itemHandle)
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
		jArray.clear(iQueueMenuCurrentArray)
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
	endIf
	;debug.trace("iEquip_WidgetCore QueueMenuClearQueue end")
endFunction

function ApplyChanges()
	;debug.trace("iEquip_WidgetCore ApplyChanges start - bMCMPresetLoaded: " + bMCMPresetLoaded)
	int i
	
    if bMCMPresetLoaded
		bUpdateKeyMaps = true
		bBackgroundStyleChanged = true
		bDropShadowSettingChanged = true
		bFadeOptionsChanged = true
		bPositionIndicatorSettingsChanged = true
		bBeastModeOptionsChanged = true
		bSlotEnabledOptionsChanged = true
		bGearedUpOptionChanged = true
		bAmmoSortingChanged = true
		bAmmoIconChanged = true
		bAttributeIconsOptionChanged = true
		bPoisonIndicatorStyleChanged = true
		if !TP.bThrowingPoisonsEnabled && TP.bPoisonEquipped
			bThrowingPoisonsDisabled = true
		endIf
		CM.bSettingsChanged = true
		TO.bSettingsChanged = true
		bTemperDisplaySettingChanged = true
		bPotionGroupingOptionsChanged = true
		bRestorePotionWarningSettingChanged = true
	endIf
	
	if bUpdateKeyMaps
        KH.updateKeyMaps()
	endIf
	if bBackgroundStyleChanged
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setBackgrounds", iBackgroundStyle)
		if iBackgroundStyle > 0
			while i < 5
				if abQueueWasEmpty[i] && !(i == 0 && (UI.GetString(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftName_mc.leftName.text") == iEquip_StringExt.LocalizeString("$iEquip_common_Unarmed") || (AM.bAmmoMode && jArray.Count(AM.aiTargetQ[AM.Q]) > 0)))
					int[] args = new int[2]
					args[0] = i
					args[1] = 0
					UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setWidgetBackground", args)	; Hide the background if it was previously hidden
				endIf
				i += 1
			endWhile
			if bDontFadeBackgrounds
				UI.setFloat(HUD_MENU, WidgetRoot + ".widgetMaster.LeftHandWidget.leftBg_mc._alpha", afWidget_A[6])
				UI.setFloat(HUD_MENU, WidgetRoot + ".widgetMaster.ConsumableWidget.consumableBg_mc._alpha", afWidget_A[45])
				UI.setFloat(HUD_MENU, WidgetRoot + ".widgetMaster.PoisonWidget.poisonBg_mc._alpha", afWidget_A[50])
			endIf
		endIf
	endIf
	if bDropShadowSettingChanged && !EM.isEditMode
		updateTextFieldDropShadow()
	endIf
	if bFadeOptionsChanged
		updateWidgetVisibility()
		i = 0
        while i < 8
            showName(i, true) ;Reshow all the names and either register or unregister for updates
            if i < 2
            	showName(i, true, true) ;Reshow the poison names
            endIf
            i += 1
        endwhile
    endIf
    if bPositionIndicatorSettingsChanged
    	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateQueuePositionMarkers")
		If(iHandle)
			UICallback.PushInt(iHandle, iPositionIndicatorColor)
			UICallback.PushFloat(iHandle, fPositionIndicatorAlpha)
			UICallback.PushInt(iHandle, iCurrPositionIndicatorColor)
			UICallback.PushFloat(iHandle, fCurrPositionIndicatorAlpha)
			UICallback.Send(iHandle)
		endIf
		if iPosInd == 2
			i = 0
			int newPos
			while i < 3
				if bPreselectMode
					newPos = aiCurrentlyPreselected[i]
				else
					newPos = aiCurrentQueuePosition[i]
				endIf
				updateQueuePositionIndicator(i, jArray.count(aiTargetQ[i]), aiCurrentQueuePosition[i], newPos)
				i += 1
			endWhile
		elseIf bMCMPresetLoaded
			i = 0
			while i < 3
				UI.invokeInt("HUD Menu", WidgetRoot + ".hideQueuePositionIndicator", i)
				i += 1
			endWhile
		endIf
    endIf
    if EH.bPlayerIsABeast
    	if bBeastModeOptionsChanged
    		BM.updateWidgetVisOnSettingsChanged()
    	endIf
    else
	    if bSlotEnabledOptionsChanged
			updateSlotsEnabled()
		endIf
	    if bRefreshQueues
	    	purgeQueue()
	    endIf

	    ammo targetAmmo = AM.currentAmmoForm as ammo
	    if !bAmmoMode && bUnequipAmmo && targetAmmo && PlayerRef.isEquipped(targetAmmo)
			AM.unequipAmmo(targetAmmo)
		endIf
		;debug.trace("iEquip_WidgetCore ApplyChanges - bPreselectMode: " + bPreselectMode + ", PM.bPreselectEnabled: " + PM.bPreselectEnabled)
	    if bPreselectMode && !PM.bPreselectEnabled
	    	;debug.trace("iEquip_WidgetCore ApplyChanges - should be toggling out of Preselect Mode")
	    	PM.togglePreselectMode(true)
	    endIf

	    if bAmmoSortingChanged
	    	AM.updateAmmoListsOnSettingChange()
	    endIf
	    
	    if bAmmoMode
	    	;debug.trace("iEquip_WidgetCore ApplyChanges - bSimpleAmmoMode: " + AM.bSimpleAmmoMode + ", bSimpleAmmoModeOnEnter: " + AM.bSimpleAmmoModeOnEnter + ", bPreselectMode: " + bPreselectMode)
		    if bAmmoIconChanged
		    	AM.checkAndEquipAmmo(false, false, true, false)
		    endIf
		    if AM.bSimpleAmmoMode && !AM.bSimpleAmmoModeOnEnter
		    	if !bPreselectMode
					bool[] args = new bool[3]
					args[2] = true
					UI.InvokeboolA(HUD_MENU, WidgetRoot + ".PreselectModeAnimateOut", args)
				endIf
				AM.bSimpleAmmoModeOnEnter = true
		    elseIf !AM.bSimpleAmmoMode && AM.bSimpleAmmoModeOnEnter
		    	if !bPreselectMode
		    		;debug.trace("iEquip_WidgetCore ApplyChanges - switching from simple to advanced ammo mode, should be about to animate in the left preselect")
		    		int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".updateWidget")
					If(iHandle)
						;debug.trace("iEquip_WidgetCore ApplyChanges - got iHandle")
						UICallback.PushInt(iHandle, 5) 													; Which slot we're updating
						if jArray.count(aiTargetQ[0]) > 0
							UICallback.PushString(iHandle, jMap.getStr(jArray.getObj(aiTargetQ[0], aiCurrentQueuePosition[0]), "iEquipIcon"))
							UICallback.PushString(iHandle, asCurrentlyEquipped[0])
						else
							UICallback.PushString(iHandle, "Fist")
							UICallback.PushString(iHandle, "$iEquip_common_Unarmed")
						endIf
						UICallback.PushFloat(iHandle, afWidget_A[aiNameElements[5]]) 					; Current item name alpha
						UICallback.PushFloat(iHandle, afWidget_A[aiIconClips[5]]) 						; Current item icon alpha
						UICallback.PushFloat(iHandle, afWidget_S[aiIconClips[5]]) 						; Current item icon scale
						UICallback.Send(iHandle)
					endIf
					iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".PreselectModeAnimateIn")
					if(iHandle)
						UICallback.PushBool(iHandle, true)
						UICallback.PushBool(iHandle, false)
						UICallback.PushBool(iHandle, false)
						UICallback.PushFloat(iHandle, afWidget_A[35]) ; rightPreselectBackground alpha
						UICallback.PushFloat(iHandle, afWidget_A[36]) ; rightPreselectIcon alpha
						UICallback.PushFloat(iHandle, afWidget_A[37]) ; rightPreselectName alpha
						UICallback.Send(iHandle)
					endIf
				endIf
				AM.bSimpleAmmoModeOnEnter = false
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
		if bThrowingPoisonsDisabled
			TP.GoToState("DISABLED")
		elseIf bThrowingPoisonsHandChanged && TP.bPoisonEquipped
			if !PlayerRef.GetEquippedObject(TP.iThrowingPoisonHand) || PlayerRef.GetEquippedObject(TP.iThrowingPoisonHand) != TP.iEquip_ThrowingPoisonWeapon as form
				TP.switchHands()
			endIf
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
		if TO.bSettingsChanged && PlayerRef.GetEquippedItemType(0) == 11 && TO.bShowTorchMeter
			TO.updateTorchMeterOnSettingsChanged()
		endIf
		if bTemperDisplaySettingChanged
			i = 0
			while i < 2
				TI.checkAndUpdateTemperLevelInfo(i)
				i += 1
			endWhile
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
		endIf

		if bRestorePotionWarningSettingChanged
			int potionGroup = asPotionGroups.Find(asCurrentlyEquipped[3])
			if (potionGroup > -1)
	        	setSlotCount(3, PO.getPotionGroupCount(potionGroup))
	        endIf
		endIf

	    if EM.isEditMode
	        EM.LoadAllElements()
	    endIf
	endIf
	
	bMCMPresetLoaded = false
	bUpdateKeyMaps = false
	bBackgroundStyleChanged = false
	bDropShadowSettingChanged = false
	bFadeOptionsChanged = false
	bPositionIndicatorSettingsChanged = false
	bBeastModeOptionsChanged = false
	bSlotEnabledOptionsChanged = false
	bRefreshQueues = false
	bReduceMaxQueueLengthPending = false
	bGearedUpOptionChanged = false
	bAmmoSortingChanged = false
	bAmmoIconChanged = false
	bAttributeIconsOptionChanged = false
	bPoisonIndicatorStyleChanged = false
	bThrowingPoisonsDisabled = false
	bThrowingPoisonsHandChanged = false
	CM.bSettingsChanged = false
	bTemperDisplaySettingChanged = false
	bPotionGroupingOptionsChanged = false
	bRestorePotionWarningSettingChanged = false
    ;debug.trace("iEquip_WidgetCore ApplyChanges end")
endFunction

; Deprecated

int property iMaxQueueLength = 12 auto hidden
bool property bReduceMaxQueueLengthPending auto hidden
bool property bHardLimitQueueSize = true auto hidden
bool property bHardLimitEnabledPending auto hidden
bool property bProModeEnabled auto hidden
bool property bFadeLeftIconWhen2HEquipped auto hidden
float property fSmartConsumeThreshold = 0.8 auto hidden
bool property bSkipAutoAddedItems auto hidden
bool property bShowAutoAddedFlag auto hidden
bool property bShoutCooldownFadeEnabled = true auto hidden

function reduceMaxQueueLength()
	;/;debug.trace("iEquip_WidgetCore reduceMaxQueueLength start")
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
	;debug.trace("iEquip_WidgetCore reduceMaxQueueLength end")/;
endFunction

function refreshGearedUp()
	;debug.trace("iEquip_WidgetCore refreshGearedUp start")
	Utility.SetINIbool("bDisableGearedUp:General", True)
	refreshVisibleItems()
	Utility.WaitMenuMode(0.05)
	Utility.SetINIbool("bDisableGearedUp:General", False)
	refreshVisibleItems()
	;debug.trace("iEquip_WidgetCore refreshGearedUp end")
endFunction

function refreshVisibleItems()
	;debug.trace("iEquip_WidgetCore refreshVisibleItems start")
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
	;debug.trace("iEquip_WidgetCore refreshVisibleItems end")
endFunction