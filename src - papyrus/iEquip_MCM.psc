Scriptname iEquip_MCM extends SKI_ConfigBase

import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_EditMode Property EM Auto
iEquip_KeyHandler Property KH Auto

iEquip_MCM_gen Property gen Auto
iEquip_MCM_htk Property htk Auto
iEquip_MCM_que Property que Auto
iEquip_MCM_pot Property pot Auto
iEquip_MCM_rep Property poi Auto
iEquip_MCM_ui Property uii Auto
iEquip_MCM_pro Property pro Auto
iEquip_MCM_edt Property edt Auto
iEquip_MCM_inf Property inf Auto

Float Property iEquip_CurrentVersion Auto

Bool iEquip_RequiresResetOnUpdate = False ;Set to true for version updates which require a full reset

GlobalVariable Property iEquip_EditModeSlowTimeStrength Auto

Actor Property PlayerRef  Auto  

Form Property iEquip_Unarmed1H  Auto  
Form Property iEquip_Unarmed2H  Auto  

Bool Property ShowMessages = True Auto Hidden
Bool Property iEquip_Reset = False Auto Hidden
Bool Property refreshQueues = False Auto Hidden
Bool Property fadeOptionsChanged = False Auto Hidden
Bool Property ammoIconChanged = False Auto Hidden
Bool Property ammoSortingChanged = False Auto Hidden

;bool isJCValid = JContainers.APIVersion() == 4 && JContainers.featureVersion() >= 1

bool Property isFirstEnabled = true Auto Hidden
bool Property justEnabled = false Auto Hidden
bool property restartingMCM = false Auto Hidden
int Property AmmoListSorting = 1 Auto Hidden
string Property ammoIconSuffix = "" Auto Hidden
bool Property bEnableGearedUp = false Auto Hidden
bool Property gearedUpOptionChanged = false Auto Hidden
bool Property bUnequipAmmo = true Auto Hidden
bool Property slotEnabledOptionsChanged = false Auto Hidden

;Main On/Off switch
bool Property bEnabled = false Auto Hidden
bool Property bEditModeEnabled = true Auto Hidden
bool Property bProModeEnabled = false Auto Hidden
bool Property bEquipOnPause = true Auto Hidden

int Property maxQueueLength = 7 Auto Hidden
bool Property bHardLimitQueueSize = true Auto Hidden
bool Property bAllowWeaponSwitchHands = true Auto Hidden
bool Property bAllowSingleItemsInBothQueues = true Auto Hidden
bool Property bAutoAddNewItems = false Auto Hidden
bool Property bEnableRemovedItemCaching = true Auto Hidden
int Property maxCachedItems = 30 Auto Hidden

float Property multiTapDelay = 0.3 Auto Hidden
float Property longPressDelay = 0.5 Auto Hidden
float Property pressAndHoldDelay = 1.0 Auto Hidden

float Property equipOnPauseDelay = 2.0 Auto Hidden

float Property mainNameFadeoutDelay = 5.0 Auto Hidden
float Property poisonNameFadeoutDelay = 5.0 Auto Hidden
float Property preselectNameFadeoutDelay = 5.0 Auto Hidden
float Property nameFadeoutDuration = 1.5 Auto Hidden
float Property widgetFadeoutDelay = 30.0 Auto Hidden
float Property widgetFadeoutDuration = 1.5 Auto Hidden


bool Property bPreselectEnabled = true Auto Hidden
bool Property bShoutPreselectEnabled = true Auto Hidden
bool Property bPreselectSwapItemsOnEquip = false Auto Hidden
bool Property bTogglePreselectOnEquipAll = false Auto Hidden

;Strings used by save/load settings functions
string MCMSettingsPath = "Data/iEquip/MCM Settings/"
string FileExtMCM = ".IEQS"

int Property backgroundStyle = 0 Auto Hidden
bool Property backgroundStyleChanged = false Auto Hidden
bool Property bSkipCurrentItemWhenCycling = false Auto Hidden
int Property utilityKeyDoublePress = 0 Auto Hidden
bool Property bFadeLeftIconWhen2HEquipped = true Auto Hidden
float Property leftIconFadeAmount = 70.0 Auto Hidden

bool Property bHealthPotionGrouping = true Auto Hidden
int Property iHealthPotionsFirstChoice = 0 Auto Hidden
int Property iHealthPotionsSecondChoice = 1 Auto Hidden
int Property iHealthPotionsThirdChoice = 2 Auto Hidden
bool Property bUseStrongestHealthPotion = true Auto Hidden
bool Property bStaminaPotionGrouping = true Auto Hidden
int Property iStaminaPotionsFirstChoice = 0 Auto Hidden
int Property iStaminaPotionsSecondChoice = 1 Auto Hidden
int Property iStaminaPotionsThirdChoice = 2 Auto Hidden
bool Property bUseStrongestStaminaPotion = true Auto Hidden
bool Property bMagickaPotionGrouping = true Auto Hidden
int Property iMagickaPotionsFirstChoice = 0 Auto Hidden
int Property iMagickaPotionsSecondChoice = 1 Auto Hidden
int Property iMagickaPotionsThirdChoice = 2 Auto Hidden
bool Property bUseStrongestMagickaPotion = true Auto Hidden
int Property emptyPotionQueueChoice = 0 Auto Hidden
bool Property bEmptyPotionQueueChoiceChanged = false Auto Hidden
bool Property bFlashPotionWarning = true Auto Hidden

bool Property bQuickShieldEnabled = false Auto Hidden
bool Property bQuickShield2HSwitchAllowed = true Auto Hidden
bool Property bQuickShieldPreferMagic = false Auto Hidden
int Property preselectQuickShield = 1 Auto Hidden
string Property quickShieldPreferredMagicSchool = "Destruction" Auto Hidden

bool Property bQuickRangedEnabled = false Auto Hidden
int Property preselectQuickRanged = 1 Auto Hidden
int Property quickRangedPreferredWeaponType = 0 Auto Hidden
int Property quickRangedSwitchOutAction = 1 Auto Hidden
string Property quickRangedPreferredMagicSchool = "Destruction" Auto Hidden

bool Property bQuickDualCastEnabled = false Auto Hidden
bool Property bQuickDualCastMustBeInBothQueues = false Auto Hidden
bool Property bQuickDualCastDestruction = false Auto Hidden
bool Property bQuickDualCastIllusion = false Auto Hidden
bool Property bQuickDualCastAlteration = false Auto Hidden
bool Property bQuickDualCastConjuration = false Auto Hidden
bool Property bQuickDualCastRestoration = false Auto Hidden

bool Property bQuickHealEnabled = false Auto Hidden
bool Property bQuickHealPreferMagic = false Auto Hidden
int Property quickHealEquipChoice = 3 Auto Hidden
bool Property bQuickHealUseSecondChoice = true Auto Hidden
bool Property bQuickHealSwitchBackEnabled = true Auto Hidden

bool Property bRechargingEnabled = true Auto Hidden
bool Property bUseLargestSoul = true Auto Hidden
bool Property bAllowOversizedSouls = false Auto Hidden
bool Property bUsePartFilledGems = false Auto Hidden
bool Property bShowChargeMeters = true Auto Hidden
bool Property bShowDynamicSoulgem = true Auto Hidden
int Property meterFillColor = 0x8c9ec2 Auto Hidden
bool Property bEnableLowCharge = false Auto Hidden
float Property lowChargeThreshold = 20.0 Auto Hidden
int Property lowChargeFillColor = 0xFF0000 Auto Hidden
bool Property enchantmentDisplayOptionChanged = false Auto Hidden

bool Property bAllowPoisonSwitching = true Auto Hidden
bool Property bAllowPoisonTopUp = true Auto Hidden
int Property poisonChargeMultiplier = 1 Auto Hidden
int Property poisonChargesPerVial = 1 Auto Hidden
int Property showPoisonMessages = 0 Auto Hidden
int Property poisonIndicatorStyle = 1 Auto Hidden
bool Property poisonIndicatorStyleChanged = false Auto Hidden

bool Property bQuickMCMSetKeys = false Auto Hidden
bool Property bShowAttributeIcons = true Auto Hidden
bool Property bAttributeIconsOptionChanged = false Auto Hidden

bool Property stillToEnableProMode = true Auto Hidden
int Property currentWidgetFadeoutChoice = 1 Auto Hidden
int Property currentNameFadeoutChoice = 1 Auto Hidden
int Property ammoIconStyle = 0 Auto Hidden
int Property currentQSPreferredMagicSchoolChoice = 2 Auto Hidden
int Property currentQRPreferredMagicSchoolChoice = 2 Auto Hidden
int Property currentEMKeysChoice = 0 Auto Hidden

string[] Property ammoSortingOptions Auto Hidden
string[] Property utilityKeyDoublePressOptions Auto Hidden
string[] Property potionEffects Auto Hidden
string[] Property emptyPotionQueueOptions Auto Hidden
string[] Property poisonMessageOptions Auto Hidden
string[] Property poisonIndicatorOptions Auto Hidden
string[] Property ammoIconOptions Auto Hidden
string[] Property backgroundStyleOptions Auto Hidden
string[] Property fadeoutOptions Auto Hidden
string[] Property firstPressIfNameHiddenOptions Auto Hidden
string[] Property QSPreferredMagicSchool Auto Hidden
string[] Property preselectQuickFunctionOptions Auto Hidden
string[] Property QHEquipOptions Auto Hidden
string[] Property QRPreferredWeaponType Auto Hidden
string[] Property QRSwitchOutOptions Auto Hidden
string[] Property EMKeysChoice Auto Hidden

; ###########################
; ### START OF UPDATE MCM ###

int function GetVersion()
    return 1
endFunction

event OnVersionUpdate(int a_version)
    if (a_version > CurrentVersion && CurrentVersion > 0)
        Debug.Notification("Updating iEquip to Version " + a_version as string)
        if iEquip_RequiresResetOnUpdate ;For major version updates - fully resets mod, use only if absolutely neccessary
            OnConfigInit()
            EM.ResetDefaults()
        else
            WC.ApplyMCMSettings()
        endIf
    endIf
endEvent


; ### END OF UPDATE MCM ###
; #########################


; ###########################
; ### START OF CONFIG MCM ###

Event OnConfigInit()
    iEquip_Reset = false

    if(!playerRef.getItemCount(iEquip_Unarmed1H))
        PlayerRef.AddItem(iEquip_Unarmed1H)
    endIf
    if(!playerRef.getItemCount(iEquip_Unarmed2H))
        PlayerRef.AddItem(iEquip_Unarmed2H)
    endIf
    
    Pages = new String[1]
    Pages[0] = "General Settings"
    
    ; GEN
    ammoSortingOptions = new String[4]
    ammoSortingOptions[0] = "Unsorted"
    ammoSortingOptions[1] = "By damage"
    ammoSortingOptions[2] = "Alphabetically"
    ammoSortingOptions[3] = "By quantity"
    
    ; HTK
    utilityKeyDoublePressOptions = new String[4]
    utilityKeyDoublePressOptions[0] = "Disabled"
    utilityKeyDoublePressOptions[1] = "Queue Menu"
    utilityKeyDoublePressOptions[2] = "Edit Mode"
    utilityKeyDoublePressOptions[3] = "MCM"
    
    ; POT 
    potionEffects = new String[3]
    potionEffects[0] = "Restore"
    potionEffects[1] = "Fortify"
    potionEffects[2] = "Regenerate"
    
    emptyPotionQueueOptions = new String[2]
    emptyPotionQueueOptions[0] = "Fade Icon"
    emptyPotionQueueOptions[1] = "Hide Icon"
    
    ; REP
    poisonMessageOptions = new String[3]
    poisonMessageOptions[0] = "Show All"
    poisonMessageOptions[1] = "Top-up & Switch"
    poisonMessageOptions[2] = "Don't show"
    
    poisonIndicatorOptions = new String[4]
    poisonIndicatorOptions[0] = "Count Only"
    poisonIndicatorOptions[1] = "Single Drop & Count"
    poisonIndicatorOptions[2] = "Single Drop"
    poisonIndicatorOptions[3] = "Multiple Drops"
    
    ; UI
    ammoIconOptions = new String[3]
    ammoIconOptions[0] = "Single"
    ammoIconOptions[1] = "Triple"
    ammoIconOptions[2] = "Quiver"
    
    backgroundStyleOptions = new String[4]
    backgroundStyleOptions[0] = "Square with border"
    backgroundStyleOptions[1] = "Square without border"
    backgroundStyleOptions[2] = "Round with border"
    backgroundStyleOptions[3] = "Round without border"
    
    fadeoutOptions = new String[4]
    fadeoutOptions[0] = "Slow"
    fadeoutOptions[1] = "Normal"
    fadeoutOptions[2] = "Fast"
    fadeoutOptions[3] = "Custom"
    
    firstPressIfNameHiddenOptions = new String[2]
    firstPressIfNameHiddenOptions[0] = "Cycle slot"
    firstPressIfNameHiddenOptions[1] = "Show name"
    
    ; PRO
    QSPreferredMagicSchool = new String[5]
    QSPreferredMagicSchool[0] = "Alteration"
    QSPreferredMagicSchool[1] = "Conjuration"
    QSPreferredMagicSchool[2] = "Destruction"
    QSPreferredMagicSchool[3] = "Illusion"
    QSPreferredMagicSchool[4] = "Restoration"
    
    preselectQuickFunctionOptions = new String[3]
    preselectQuickFunctionOptions[0] = "Disabled"
    preselectQuickFunctionOptions[1] = "Preselect"
    preselectQuickFunctionOptions[2] = "Equip"
    
    QHEquipOptions = new String[4]
    QHEquipOptions[0] = "in your left hand"
    QHEquipOptions[1] = "in your right hand"
    QHEquipOptions[2] = "in both hands"
    QHEquipOptions[3] = "where it is found"
    
    QRPreferredWeaponType = new String[4]
    QRPreferredWeaponType[0] = "Bow"
    QRPreferredWeaponType[1] = "Crossbow"
    QRPreferredWeaponType[2] = "Bound Bow"
    QRPreferredWeaponType[3] = "Bound Crossbow"

    QRSwitchOutOptions = new String[5]
    QRSwitchOutOptions[0] = "Disabled"
    QRSwitchOutOptions[1] = "Switch Back"
    QRSwitchOutOptions[2] = "Two Handed"
    QRSwitchOutOptions[3] = "One Handed"
    QRSwitchOutOptions[4] = "Spell"
    
    ; EDT
    EMKeysChoice = new String[2]
    EMKeysChoice[0] = "Default"
    EMKeysChoice[1] = "Custom"
endEvent

event OnConfigOpen()
    iEquip_Reset = false
    restartingMCM = false
    refreshQueues = false
    fadeOptionsChanged = false
    ammoIconChanged = false
    ammoSortingChanged = false
    
    if isFirstEnabled == false
        if bProModeEnabled
            if bEditModeEnabled
                Pages = new String[9]
                Pages[8] = "Information"
                Pages[7] = "Edit Mode"
                Pages[6] = "Misc UI Options"
                Pages[5] = "Pro Mode"
            else
                Pages = new String[8] 
                Pages[7] = "Information"
                Pages[6] = "Misc UI Options"
                Pages[5] = "Pro Mode"
            endIf
        else
            if bEditModeEnabled
                Pages = new String[8]
                Pages[7] = "Information"
                Pages[6] = "Edit Mode"
                Pages[5] = "Misc UI Options"
            else
                Pages = new String[7]
                Pages[6] = "Information"
                Pages[5] = "Misc UI Options"
            endIf
        endIf
        
        Pages[4] = "Recharging and Poisoning"
        Pages[3] = "Potions"
        Pages[2] = "Queue Options"
        Pages[1] = "Hotkey Options"
        Pages[0] = "General Settings"
    endIf
endEvent

Event OnConfigClose()
    if WC.isEnabled != bEnabled
        if !bEnabled && EM.isEditMode
            EM.Disabling = true
            EM.ToggleEditMode()
            EM.Disabling = false
        endIf
        WC.isEnabled = bEnabled
    endIf
    WC.ApplyMCMSettings()
endEvent

; ### END OF CONFIG MCM ###
; #########################

; ####################################
; ### START OF MCM PAGE POPULATION ###

event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    if (page == "")
        LoadCustomContent("iEquip/iEquip_splash.swf", 196, 123)
    else
        UnloadCustomContent()
    
        if page == "General Settings"
            debug.notification("VAR IS: "+bEnabled)
            AddToggleOptionST("gen_tgl_onOff", "iEquip On/Off", bEnabled)
           
            if !isFirstEnabled && bEnabled
                AddToggleOptionST("gen_tgl_enblEditMode", "Enable Edit Mode features", bEditModeEnabled)
                        
                if stillToEnableProMode
                    AddTextOptionST("gen_txt_dragEastr", "", "Here be dragons...")
                else
                    AddToggleOptionST("gen_tgl_enblProMode", "Enable Pro Mode features", bProModeEnabled)
                endIf
                        
                AddEmptyOption()
                AddHeaderOption("Widget Options")
                AddToggleOptionST("gen_tgl_enblShoutSlt", "Enable shout slot", WC.shoutEnabled)
                AddToggleOptionST("gen_tgl_enblConsumSlt", "Enable consumables slot", WC.consumablesEnabled)
                AddToggleOptionST("gen_tgl_enblPoisonSlt", "Enable poisons slot", WC.poisonsEnabled)
                        
                AddEmptyOption()
                AddHeaderOption("Visible Gear Options")
                AddToggleOptionST("gen_tgl_enblAllGeard", "Enable All Geared Up", bEnableGearedUp)
                AddToggleOptionST("gen_tgl_autoUnqpAmmo", "Auto Unequip Ammo", bUnequipAmmo)

                SetCursorPosition(1)
                        
                AddHeaderOption("Cycling behaviour")
                AddToggleOptionST("gen_tgl_eqpPaus", "Equip on pause", bEquipOnPause)
                        
                if bEquipOnPause
                    AddSliderOptionST("gen_sld_eqpPausDelay", "Equip on pause delay", equipOnPauseDelay, "{1} seconds")
                endIf
                        
                AddToggleOptionST("gen_tgl_showAtrIco", "Show attribute icons", bShowAttributeIcons)
                AddMenuOptionST("gen_men_ammoLstSrt", "Ammo list sorting", ammoSortingOptions[AmmoListSorting])
                AddToggleOptionST("gen_tgl_skpCurItem", "Skip current item", bSkipCurrentItemWhenCycling)
            endIf
            
        elseIf page == "Hotkey Options"
            AddTextOptionST("htk_txt_htkHelp", "Show hotkey help", "")
            
            AddEmptyOption()
            AddHeaderOption("Main Hotkeys")
            AddKeyMapOptionST("htk_key_leftHand", "Left Hand Hotkey", KH.iEquip_leftKey, OPTION_FLAG_WITH_UNMAP)
            AddKeyMapOptionST("htk_key_rightHand", "Right Hand Hotkey", KH.iEquip_rightKey, OPTION_FLAG_WITH_UNMAP)
            AddKeyMapOptionST("htk_key_shout", "Shout Hotkey", KH.iEquip_shoutKey, OPTION_FLAG_WITH_UNMAP)
            AddKeyMapOptionST("htk_key_consumPoison", "Consumable/Poison Hotkey", KH.iEquip_consumableKey, OPTION_FLAG_WITH_UNMAP)
                    
            AddHeaderOption("Utility Hotkey Options")
            AddKeyMapOptionST("htk_key_util", "Utility Hotkey", KH.iEquip_utilityKey, OPTION_FLAG_WITH_UNMAP)
            AddMenuOptionST("htk_men_utilDubPress", "Utility key double press", utilityKeyDoublePressOptions[utilityKeyDoublePress])

            SetCursorPosition(1)
                    
            ;These are just so the right side lines up nicely with the left!
            AddEmptyOption()
            AddEmptyOption()
            
            AddHeaderOption("Key Press Options")
            AddSliderOptionST("htk_sld_multiTapDelay", "Multi-Tap Delay", multiTapDelay, "{1} seconds")
            AddSliderOptionST("htk_sld_longPrsDelay", "Long Press Delay", longPressDelay, "{1} seconds")
            AddSliderOptionST("htk_sld_prsHoldDelay", "Press & Hold Delay", pressAndHoldDelay, "{1} seconds")
            
        elseIf page == "Queue Options" 
            AddHeaderOption("Queue Length Options")
            AddSliderOptionST("que_sld_maxItmQue", "Max items per queue", maxQueueLength, "Max {0} items")
            AddToggleOptionST("que_tgl_hrdLimQueSize", "Hard limit queue size", bHardLimitQueueSize)
                    
            AddHeaderOption("Add To Queue Options")
            AddToggleOptionST("que_tgl_showConfMsg", "Show confirmation messages", WC.showQueueConfirmationMessages)
            AddToggleOptionST("que_tgl_signlBothQue", "Single items in both hand queues", bAllowSingleItemsInBothQueues)
                    
            if bAllowSingleItemsInBothQueues
                AddToggleOptionST("que_tgl_allow1hSwitch", "Allow 1h items to switch hands", bAllowWeaponSwitchHands)
            endIf

            SetCursorPosition(1)
                    
            AddHeaderOption("Auto Add Options")
            AddToggleOptionST("que_tgl_autoAddItmQue", "Auto-add new items to queue", bAutoAddNewItems)
            AddToggleOptionST("que_tgl_allowCacheRmvItm", "Allow caching of removed items", bEnableRemovedItemCaching)
                    
            if bEnableRemovedItemCaching
                AddSliderOptionST("que_sld_MaxItmCache", "Max items to cache", maxCachedItems, "Max {0} items")
            endIf
            
        elseIf page == "Potions" 
            AddEmptyOption()
            AddHeaderOption("Health Potion Options")
            AddToggleOptionST("pot_tgl_enblHealthGroup", "Enable Health Potion Grouping", bHealthPotionGrouping)
                    
            if bHealthPotionGrouping
                AddMenuOptionST("pot_men_hPrefEffect", "Preferred Effect", potionEffects[iHealthPotionsFirstChoice])
                AddMenuOptionST("pot_men_hPrefEffect2", "2nd Choice", potionEffects[iHealthPotionsSecondChoice])
                AddTextOptionST("pot_txt_hPrefEffect3", "3rd Choice", potionEffects[iHealthPotionsThirdChoice])
                AddToggleOptionST("pot_tgl_alwaysUseHealth", "Always use strongest potion first", bUseStrongestHealthPotion)
            else
                AddEmptyOption()
                AddEmptyOption()
                AddEmptyOption()
                AddEmptyOption()
            endIf
                    
            AddEmptyOption()
            AddHeaderOption("Stamina Potion Options")
            AddToggleOptionST("pot_tgl_enblStaminaGroup", "Enable Stamina Potion Grouping", bStaminaPotionGrouping)
                    
            if bStaminaPotionGrouping
                AddMenuOptionST("pot_men_sPrefEffect", "Preferred Effect", potionEffects[iStaminaPotionsFirstChoice])
                AddMenuOptionST("pot_men_sPrefEffect2", "2nd Choice", potionEffects[iStaminaPotionsSecondChoice])
                AddTextOptionST("pot_txt_sPrefEffect3", "3rd Choice", potionEffects[iStaminaPotionsThirdChoice])
                AddToggleOptionST("pot_tgl_alwaysUseStamina", "Always use strongest potion first", bUseStrongestStaminaPotion)
            endIf

            SetCursorPosition(1)

            AddEmptyOption()
            AddHeaderOption("Magicka Potion Options")
            AddToggleOptionST("pot_tgl_enblMagickaGroup", "Enable Magicka Potion Grouping", bMagickaPotionGrouping)
                    
            if bMagickaPotionGrouping
                AddMenuOptionST("pot_men_mPrefEffect", "Preferred Effect", potionEffects[iMagickaPotionsFirstChoice])
                AddMenuOptionST("pot_men_mPrefEffect2", "2nd Choice", potionEffects[iMagickaPotionsSecondChoice])
                AddTextOptionST("pot_txt_mPrefEffect3", "3rd Choice", potionEffects[iMagickaPotionsThirdChoice])
                AddToggleOptionST("pot_tgl_alwaysUseMagicka", "Always use strongest potion first", bUseStrongestMagickaPotion)
            else
                AddEmptyOption()
                AddEmptyOption()
                AddEmptyOption()
                AddEmptyOption()
            endIf
                    
            AddEmptyOption()
            AddHeaderOption("Widget Options")
            AddMenuOptionST("pot_men_whenNoPotions", "When no potions left...", emptyPotionQueueOptions[emptyPotionQueueChoice])
            AddToggleOptionST("pot_tgl_warningOnLastPotion", "Warning flash when last potion used", bFlashPotionWarning)       
        
        elseIf page == "Recharging and Poisoning"
            AddTextOptionST("rep_txt_showEnchRechHelp", "Show Enchantment Recharging Help", "")
            AddToggleOptionST("rep_tgl_enblEnchRech", "Enable enchanted weapon recharging", bRechargingEnabled)
            AddEmptyOption()
                    
            if bRechargingEnabled
                AddHeaderOption("Soulgem Use Options")
                AddToggleOptionST("rep_tgl_useLargSoul", "Use largest available soul", bUseLargestSoul)
                AddToggleOptionST("rep_tgl_useOvrsizSoul", "Use oversized souls", bAllowOversizedSouls)
                AddToggleOptionST("rep_tgl_usePartGem", "Use partially filled gems", bUsePartFilledGems)
                        
                AddHeaderOption("Widget Options")
                AddToggleOptionST("rep_tgl_showEnchCharge", "Show enchantment charge meters", bShowChargeMeters)
                AddToggleOptionST("rep_tgl_showDynGemIco", "Show dynamic soulgem icon", bShowDynamicSoulgem)
                AddColorOptionST("rep_col_normFillCol", "Normal meter fill colour", meterFillColor)
                AddToggleOptionST("rep_tgl_changeColLowCharge", "Change colour on low charge", bEnableLowCharge)
                AddSliderOptionST("rep_sld_setLowChargeTresh", "Set low charge threshold", lowChargeThreshold, "{0}%")
                AddColorOptionST("rep_col_lowFillCol", "Low charge fill colour", lowChargeFillColor)
            endIf

            SetCursorPosition(1)
                    
            if !WC.poisonsEnabled
                AddEmptyOption()
                AddTextOption("Poisoning features are currently disabled.", "")
                AddTextOption("If you wish to use the poisoning features", "")
                AddTextOption("please re-enable the Poison Widget in the", "")
                AddTextOption("General Settings page", "")
             else
                AddTextOptionST("rep_txt_showPoisonHelp", "Show Poisoning Help", "")
                       
                AddEmptyOption()
                AddHeaderOption("Poison Use Options")
                AddMenuOptionST("rep_men_confMsg", "Confirmation messages", poisonMessageOptions[showPoisonMessages])
                AddToggleOptionST("rep_tgl_allowPoisonSwitch", "Allow poison switching", bAllowPoisonSwitching)
                AddToggleOptionST("rep_tgl_allowPoisonTopup", "Allow poison top-up", bAllowPoisonTopUp)
                        
                AddHeaderOption("Poison Charge Options")
                AddSliderOptionST("rep_sld_chargePerVial", "Charges per vial", poisonChargesPerVial, "{0} charges")
                AddSliderOptionST("rep_sld_chargeMult", "Charge Multiplier", poisonChargeMultiplier, "{0}x base charges")
                        
                AddHeaderOption("Widget Options")
                AddMenuOptionST("rep_men_poisonIndStyle", "Poison indicator style", poisonIndicatorOptions[poisonIndicatorStyle])
            endIf
            
        elseIf page == "Misc UI Options"
            AddHeaderOption("Widget Options")
            AddToggleOptionST("ui_tgl_fadeLeftIco2h", "Fade left icon if 2H equipped", bFadeLeftIconWhen2HEquipped)
                    
            if bFadeLeftIconWhen2HEquipped
                AddSliderOptionST("ui_sld_leftIcoFade", "Left icon fade", leftIconFadeAmount, "{0}%")
            endIf
                    
            AddMenuOptionST("ui_men_ammoIcoStyle", "Ammo icon style", ammoIconOptions[ammoIconStyle])
            AddToggleOptionST("ui_tgl_enblWdgetBckground", "Enable widget backgrounds", EM.BackgroundsShown)
                    
            if EM.BackgroundsShown
                AddMenuOptionST("ui_men_bckgroundStyle", "Background style", backgroundStyleOptions[backgroundStyle])
            endIf
            ;+++Disable spin on in/out animations
                    
            SetCursorPosition(1)
            ;widget fade variable sliders
            AddHeaderOption("Fade Out Options")
            AddToggleOptionST("ui_tgl_enblWdgetFade", "Enable widget fadeout", WC.widgetFadeoutEnabled)
                    
            if WC.widgetFadeoutEnabled
                AddSliderOptionST("ui_sld_wdgetFadeDelay", "Widget fadeout delay", widgetFadeoutDelay, "{0}")
                AddMenuOptionST("ui_men_wdgetFadeSpeed", "Widget fadeout animation speed", fadeoutOptions[currentWidgetFadeoutChoice])
                        
                if (currentWidgetFadeoutChoice == 3)
                    AddSliderOptionST("ui_sld_wdgetFadeDur", "Widget fadeout duration", widgetFadeoutDuration, "{1}")
                endIf
            endIf
            
            AddEmptyOption()
            AddToggleOptionST("ui_tgl_enblNameFade", "Enable name fadeouts", WC.nameFadeoutEnabled)
                    
            if WC.nameFadeoutEnabled
                AddSliderOptionST("ui_sld_mainNameFadeDelay", "Main name fadeout delay", mainNameFadeoutDelay, "{1}")
                AddSliderOptionST("ui_sld_poisonNameFadeDelay", "Poison name fadeout delay", poisonNameFadeoutDelay, "{1}")
                        
                if bProModeEnabled
                    AddSliderOptionST("ui_sld_preselectNameFadeDelay", "Preselect name fadeout delay", preselectNameFadeoutDelay, "{1}")
                endIf
                        
                AddMenuOptionST("ui_men_nameFadeSpeed", "Name fadeout animation speed", fadeoutOptions[currentNameFadeoutChoice])
                        
                if (currentNameFadeoutChoice == 3)
                    AddSliderOptionST("ui_sld_nameFadeDur", "Name fadeout duration", nameFadeoutDuration, "{1}")
                endIf
                        
                AddMenuOptionST("ui_men_firstPressNameHidn", "First press when name hidden", firstPressIfNameHiddenOptions[WC.firstPressShowsName as int])
            endIf
            
        elseIf page == "Pro Mode"
            AddTextOptionST("pro_txt_whatProMode", "What is Pro Mode?", "")
            
            AddEmptyOption()
            AddHeaderOption("Preselect Options")
            AddTextOptionST("pro_txt_whatPreselect", "What is Preselect?", "")
            AddToggleOptionST("pro_tgl_enblPreselect", "Enable Preselect", bPreselectEnabled)
                    
            if bPreselectEnabled
                AddToggleOptionST("pro_tgl_enblShoutPreselect", "Enable shout preselect", bShoutPreselectEnabled)
                AddToggleOptionST("pro_tgl_swapPreselectItm", "Swap preselect with current item", bPreselectSwapItemsOnEquip)
                AddToggleOptionST("pro_tgl_eqpAllExitPreselectMode", "Equip All Exits Preselect Mode", bTogglePreselectOnEquipAll)
            endIf
                    
            AddEmptyOption()
            AddHeaderOption("QuickShield Options")
            AddTextOptionST("pro_txt_whatQuickshield", "What is QuickShield?", "")
            AddToggleOptionST("pro_tgl_enblQuickshield", "Enable QuickShield", bQuickShieldEnabled)
                    
            if bQuickShieldEnabled
                AddToggleOptionST("pro_tgl_with2hReqp", "With 2H/ranged equipped", bQuickShield2HSwitchAllowed)
                AddToggleOptionST("pro_tgl_prefShieldMag", "Prefer magic", bQuickShieldPreferMagic)
                        
                if bQuickShieldPreferMagic
                    AddMenuOptionST("pro_men_rightHandspllTyp", "Right hand spell type", QSPreferredMagicSchool[currentQSPreferredMagicSchoolChoice])
                endIf         
               
                AddMenuOptionST("pro_men_inPreselectQuickshieldMode", "In Preselect Mode", preselectQuickFunctionOptions[preselectQuickShield])
            endIf
                    
            AddEmptyOption() 
            AddHeaderOption("QuickHeal Options")
            AddTextOptionST("pro_txt_whatQuickheal", "What is QuickHeal?", "")
            AddToggleOptionST("pro_tgl_enblQuickheal", "Enable QuickHeal", bQuickHealEnabled)
                    
            if bQuickHealEnabled
                AddToggleOptionST("pro_tgl_prefHealMag", "Prefer magic", bQuickHealPreferMagic)
                        
                if bQuickHealPreferMagic
                    AddMenuOptionST("pro_men_alwysEqpSpll", "Always equip spell...", QHEquipOptions[quickHealEquipChoice])
                endIf
                        
                AddToggleOptionST("pro_tgl_use2Pot", "Use 2nd Choice Potion", bQuickHealUseSecondChoice)
                AddToggleOptionST("pro_tgl_swtchBck", "Switch Back", bQuickHealSwitchBackEnabled)
            endIf
                    
            SetCursorPosition(1)
                    
            AddHeaderOption("QuickRanged Options")
            AddTextOptionST("pro_txt_whatQuickranged", "What is QuickRanged?", "")
            AddToggleOptionST("pro_tgl_enblQuickranged", "Enable QuickRanged", bQuickRangedEnabled)
                    
            if bQuickRangedEnabled
                AddMenuOptionST("pro_men_prefWepTyp", "Preferred weapon type", QRPreferredWeaponType[quickRangedPreferredWeaponType])
                AddMenuOptionST("pro_men_swtchOut", "Switch out options", QRSwitchOutOptions[quickRangedSwitchOutAction])

                if quickRangedSwitchOutAction == 4
                    AddMenuOptionST("pro_men_prefMagSchl", "Preferred magic school", QSPreferredMagicSchool[currentQRPreferredMagicSchoolChoice])
                endIf
               
                AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "In Preselect Mode", preselectQuickFunctionOptions[preselectQuickRanged])
            endIf
                    
            AddEmptyOption()
            AddHeaderOption("QuickDualCast Options")
            AddTextOptionST("pro_txt_whatQuickdualcast", "What is QuickDualCast?", "")
            AddToggleOptionST("pro_tgl_enblQuickdualcast", "Enable QuickDualCast", bQuickDualCastEnabled)
                    
            if bQuickDualCastEnabled
                AddTextOption("Enable QuickDualCast for:", "")
                AddToggleOptionST("pro_tgl_altSpll", "   Alteration spells", bQuickDualCastAlteration)
                AddToggleOptionST("pro_tgl_conjSpll", "   Conjuration spells", bQuickDualCastConjuration)
                AddToggleOptionST("pro_tgl_destSpll", "   Destruction spells", bQuickDualCastDestruction)
                AddToggleOptionST("pro_tgl_illSpll", "   Illusion spells", bQuickDualCastIllusion)
                AddToggleOptionST("pro_tgl_restSpll", "   Restoration spells", bQuickDualCastRestoration)
                AddToggleOptionST("pro_tgl_reqBothQue", "Only if in both queues", bQuickDualCastMustBeInBothQueues)
            endIf
            
        elseIf page == "Edit Mode"
            AddHeaderOption("Edit Mode Options")
            AddSliderOptionST("edt_sld_slowTimeStr", "Slow Time effect strength ", iEquip_EditModeSlowTimeStrength.GetValueint())
            AddToggleOptionST("edt_tgl_enblBringFrnt", "Enable Bring To Front", EM.BringToFrontEnabled)
                    
            SetCursorPosition(1)
                    
            AddHeaderOption("Edit Mode Keys")
            AddEmptyOption()
            AddMenuOptionST("edt_men_chooseHtKey", "Choose your hotkeys", EMKeysChoice[currentEMKeysChoice])
                    
            if(currentEMKeysChoice == 1)
                AddEmptyOption()
                AddKeyMapOptionST("edt_key_nextElem", "Next element", KH.iEquip_EditNextKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_prevElem", "Previous element", KH.iEquip_EditPrevKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_moveUp", "Move up", KH.iEquip_EditUpKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_moveDown", "Move down", KH.iEquip_EditDownKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_moveLeft", "Move left", KH.iEquip_EditLeftKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_moveRight", "Move right", KH.iEquip_EditRightKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_sclUp", "Scale up", KH.iEquip_EditScaleUpKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_sclDown", "Scale down", KH.iEquip_EditScaleDownKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_rotate", "Rotate", KH.iEquip_EditRotateKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_adjTransp", "Adjust transparency", KH.iEquip_EditAlphaKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_bringFrnt", "Bring to front", KH.iEquip_EditDepthKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_setTxtAlCo", "Set text alignment and colour", KH.iEquip_EditTextKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_tglRulers", "Toggle rulers", KH.iEquip_EditRulersKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_rstSelElem", "Reset selected element", KH.iEquip_EditResetKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_loadPrst", "Load preset", KH.iEquip_EditLoadPresetKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_savePrst", "Save preset", KH.iEquip_EditSavePresetKey, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("edt_key_discChangs", "Discard changes", KH.iEquip_EditDiscardKey, OPTION_FLAG_WITH_UNMAP)
            endIf
            
        elseIf page == "Information"
            AddHeaderOption("Information")
            ;+++Version number
            ;+++Dependency checks
            ;+++Supported mods detected
                    
            SetCursorPosition(1)
                    
            AddHeaderOption("Maintenance")
            AddToggleOptionST("inf_tgl_setAccess", "Set MCM access keys", bQuickMCMSetKeys)
               
            if bQuickMCMSetKeys
                AddKeyMapOptionST("inf_key_openJour", "Open Journal", KH.KEY_J, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("inf_key_exitMenu", "Exit Menu", KH.KEY_ESCAPE, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("inf_key_tabLeft", "Tab left", KH.KEY_NUM5, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("inf_key_enter", "Enter", KH.KEY_ENTER, OPTION_FLAG_WITH_UNMAP)
                AddKeyMapOptionST("inf_key_down", "Down", KH.KEY_DOWN_ARROW, OPTION_FLAG_WITH_UNMAP)
            endIf
                    
            AddEmptyOption()
            AddTextOptionST("inf_txt_rstLayout", "Reset default iEquip layout", "")
        endIf
    endif
endEvent

; ### END OF MCM PAGE POPULATION ###
; ##################################

function jumpToScriptEvent(string eventName, float tmpVar = -1.0)
    string currentState = GetState()
    
    if find(currentState, "gen") == 0
        gen.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "htk") == 0
        htk.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "que") == 0
        que.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "pot") == 0
        pot.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "rep") == 0
        poi.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "ui") == 0
        uii.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "pro") == 0
        pro.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "edt") == 0
        edt.jumpToState(currentState, eventName, tmpVar)
    elseIf find(currentState, "inf") == 0
        inf.jumpToState(currentState, eventName, tmpVar)
    endIf
endFunction

; #######################
; ### START OF EVENTS ###

; GENERAL

event OnHighlightST()
    jumpToScriptEvent("Highlight")
endEvent

event OnSelectST()
    jumpToScriptEvent("Select")
endEvent

event OnDefaultST()
    jumpToScriptEvent("Default")
endEvent

; Hotkeys

event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
    if (conflictControl != "")
        string msg
        
        if (conflictName != "")
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
        else
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
        endIf
        
        if ShowMessage(msg, true, "$Yes", "$No")
            jumpToScriptEvent("Change", keyCode)
        endIf
    else
        jumpToScriptEvent("Change", keyCode)
    endIf
endEvent

; SLIDERS

event OnSliderOpenST()
    jumpToScriptEvent("Open")
endEvent

event OnSliderAcceptST(float value)
    jumpToScriptEvent("Accept", value)
endEvent

; MENUS

event OnMenuOpenST()
    jumpToScriptEvent("Open")
endEvent
    
event OnMenuAcceptST(int index)
    jumpToScriptEvent("Accept", index)
endEvent

; COLORS

event OnColorOpenST()
    jumpToScriptEvent("Open")
endEvent
    
event OnColorAcceptST(int color)
    jumpToScriptEvent("Accept", color)
endEvent

; ### END OF EVENTS ###
; #####################
