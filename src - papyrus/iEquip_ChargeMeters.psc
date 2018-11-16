
scriptname iEquip_ChargeMeters extends quest

import UI
import UICallback
Import WornObject

iEquip_WidgetCore Property WC Auto
iEquip_LeftChargeMeterUpdateScript Property LU Auto
iEquip_RightChargeMeterUpdateScript Property RU Auto

Actor Property PlayerRef Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------
String HUD_MENU
String WidgetRoot
int[] targetQ
float[] currCharge

; PROPERTIES --------------------------------------------------------------------------------------
int property primaryFillColor = 0x8C9EC2 auto hidden
int property lowChargeFillColor = 0xFF0000 auto hidden
int property secondaryFillColor	= -1 auto hidden ;Only used if a gradient fill is required
int	property flashColor = -1 auto hidden ;White by default
int property chargeDisplayType = 1 auto Hidden ; 0 = None, 1 = Charge meters, 2 = Dynamic soulgems
bool property chargeFadeoutEnabled = false auto hidden
bool property customFlashColor = false auto hidden
bool property enableLowCharge = true auto hidden
bool property enableGradientFill = false auto hidden
float property chargeFadeoutDelay = 5.0 auto hidden
float property lowChargeThreshold = 0.20 auto hidden
bool[] property isChargeMeterShown auto hidden
string[] property meterFillDirection auto hidden
string[] property itemCharge auto hidden

bool property settingsChanged = false auto hidden

; EVENTS ------------------------------------------------------------------------------------------
event OnInit()
	debug.trace("iEquip_ChargeMeters OnInit called")
	isChargeMeterShown = new bool[2]
	isChargeMeterShown[0] = false
	isChargeMeterShown[1] = false

	meterFillDirection = new string[2]
	meterFillDirection[0] = "left"
	meterFillDirection[1] = "right"

	targetQ = new int[2]

	currCharge = new float[2]
	currCharge[0] = 0.0
	currCharge[1] = 0.0

	itemCharge = new string[2]
	itemCharge[0] = "LeftItemCharge"
	itemCharge[1] = "RightItemCharge"
endEvent

function OnWidgetLoad(string sHUD_MENU, string sWidgetRoot, int leftQ, int rightQ) ;Called from WidgetCore
	debug.trace("iEquip_ChargeMeters OnWidgetLoad called")
	HUD_MENU = sHUD_MENU
	WidgetRoot = sWidgetRoot
	targetQ[0] = leftQ
	targetQ[1] = rightQ
endFunction

; FUNCTIONS ---------------------------------------------------------------------------------------

function initChargeMeter(int Q)
	;/string element = ".widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc."
	if Q == 1
		element = ".widgetMaster.RightHandWidget.rightEnchantmentMeter_mc."
	endIf
	debug.trace("iEquip_ChargeMeters initChargeMeter - width retrieved: " + UI.GetFloat(HUD_MENU, WidgetRoot + element + "_width") + ", height retrieved: " + UI.GetFloat(HUD_MENU, WidgetRoot + element + "_height"))/;
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initChargeMeter")	
	If(iHandle)
		debug.trace("iEquip_ChargeMeters initChargeMeter - got iHandle for .initChargeMeter")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, 250.0)
		UICallback.PushFloat(iHandle, 30.6)
		UICallback.PushInt(iHandle, primaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushString(iHandle, meterFillDirection[Q])	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, isChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
endFunction

function initSoulGem(int Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initSoulGem")	
	If(iHandle)
		debug.trace("iEquip_ChargeMeters initSoulGem - got iHandle for .initSoulGem")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, primaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, isChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
endFunction

function updateMeterPercent(int Q, bool forceUpdate = false, bool skipFlash = false) ;Sets the meter percent, a_force sets the meter percent without animation
	debug.trace("iEquip_ChargeMeters updateMeterPercent called - Q: " + Q + ", itemCharge[Q]: " + itemCharge[Q] + ", forceUpdate: " + forceUpdate + ", skipFlash: " + skipFlash)
	float currentCharge = PlayerRef.GetActorValue(itemCharge[Q])
	float maxCharge = PlayerRef.GetBaseActorValue(itemCharge[Q])
	float currPercent = 0.0
	if maxCharge > 0.0 && currentCharge > 0.0
		currPercent = currentCharge / maxCharge
	endIf
	debug.trace("iEquip_ChargeMeters updateMeterPercent - currentCharge: " + currentCharge + ", maxCharge: " + maxCharge + ", currPercent: " + currPercent + ". lowChargeThreshold: " + lowChargeThreshold)
	if (currPercent != currCharge[Q]) || forceUpdate
		currCharge[Q] = currPercent
		int fillColor = primaryFillColor
		if enableLowCharge && (currPercent <= lowChargeThreshold)
			fillColor = lowChargeFillColor
		endIf
		int iHandle
		if chargeDisplayType == 1
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterPercent")
		elseIf chargeDisplayType == 2
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setSoulGemPercent")
		endIf
		If(iHandle)
			UICallback.PushInt(iHandle, Q)
			UICallback.PushFloat(iHandle, currPercent)
			UICallback.PushInt(iHandle, fillColor)
			if chargeDisplayType == 1
				UICallback.PushBool(iHandle, enableGradientFill)
				UICallback.PushInt(iHandle, secondaryFillColor)
			endIf
			UICallback.PushBool(iHandle, forceUpdate)
			UICallback.Send(iHandle)
		endIf
		if currPercent <= lowChargeThreshold && !isChargeMeterShown[Q]
			updateChargeMeterVisibility(Q, true)
		endIf
		if !skipFlash && currPercent < 0.01
			startMeterFlash(Q, true)
		endIf
	endIf
endFunction

function startMeterFlash(int Q, bool forceFlash = false) ; Starts meter flashing. forceFlash starts the meter flashing if it's already animating
	debug.trace("iEquip_ChargeMeters startMeterFlash called - Q: " + Q)
	int iHandle
	if chargeDisplayType == 1
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	elseIf chargeDisplayType == 2
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startSoulGemFlash")
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, flashColor)
		UICallback.PushBool(iHandle, forceFlash)
		UICallback.Send(iHandle)
	endIf
endFunction

function updateChargeMeters(bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeters called")
	int Q = 0
	if chargeDisplayType > 0
		while Q < 2
			if chargeDisplayType == 2
				updateChargeMeterVisibility(Q, false, true) ;hideMeters
			elseIf chargeDisplayType == 1
				updateChargeMeterVisibility(Q, false, false, true) ;hideGems
			endIf
			checkAndUpdateChargeMeter(Q, forceUpdate)
			Q += 1
		endWhile
	else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[13] + "._visible", false)
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[14] + "._visible", false)
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[26] + "._visible", false)
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[27] + "._visible", false)
	endIf
endFunction

function updateChargeMetersOnWeaponsDrawn()
	debug.trace("iEquip_ChargeMeters updateChargeMetersOnWeaponsDrawn called")
	int Q = 0
	while Q < 2
		if PlayerRef.GetEquippedWeapon(Q)
			checkAndUpdateChargeMeter(Q, false)
		endIf
		Q += 1
	endWhile
endFunction

function checkAndUpdateChargeMeter(int Q, bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter called - Q: " + Q)
	if PlayerRef.IsWeaponDrawn()
		int isEnchanted = 0
		bool isLeftHand = false
		if Q == 0
			isLeftHand = true
		endIf
		weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
		enchantment currentEnchantment
		if currentWeapon
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", isLeftHand: " + isLeftHand + ", currentWeapon: " + currentWeapon.GetName())
			currentEnchantment = currentWeapon.GetEnchantment()
			if !currentEnchantment
				currentEnchantment = wornobject.GetEnchantment(PlayerRef, Q, 0)
			endIf
			if currentEnchantment
				debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", currentEnchantment: " + currentEnchantment.GetName())
				isEnchanted = 1
				if chargeDisplayType > 0
					;Hide first
					if isChargeMeterShown[Q]
						updateChargeMeterVisibility(Q, false) ;Hide
					endIf
					;Update values
					updateMeterPercent(Q, forceUpdate, true)
					if chargeDisplayType == 1
						int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterFillDirection")	
						if(iHandle)
							debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - got iHandle for .setChargeMeterFillDirection")
							UICallback.PushInt(iHandle, Q)
							UICallback.PushString(iHandle, meterFillDirection[Q])
							UICallback.Send(iHandle)
						endIf
					endIf
					;Show meter
					updateChargeMeterVisibility(Q, true)
					;Flash if empty
					if PlayerRef.GetActorValue(itemCharge[Q]) < 1
						startMeterFlash(Q, true)
					endIf
				endIf
			endIf
		endIf
		if (!currentWeapon || isEnchanted == 0) ;&& isChargeMeterShown[Q]
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - not a weapon or not enchanted, isChargeMeterShown[" + Q + "]: " + isChargeMeterShown[Q])
			updateChargeMeterVisibility(Q, false) ;Hide
		endIf
		;Now update the object keys for the currently equipped item in case anything has changed since we last equipped it
		;ToDo - do the same in the poison functions
		jMap.setForm(jArray.getObj(targetQ[Q], WC.getCurrentQueuePosition(Q)), "lastKnownEnchantment", currentEnchantment as Form)
		jMap.setInt(jArray.getObj(targetQ[Q], WC.getCurrentQueuePosition(Q)), "isEnchanted", isEnchanted)
	else
		WC.EH.waitForEnchantedWeaponDrawn = true
	endIf
endFunction

function updateChargeMeterVisibility(int Q, bool show, bool hideMeters = false, bool hideGems = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeterVisibility called - Q: " + Q + ", show: " + show)
	int element
	int iHandle
	if hideMeters || (chargeDisplayType == 1 && !hideGems)
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenChargeMeterAlpha")
		element = 13 ;leftEnchantmentMeter_mc
		if Q == 1
			element = 26 ;rightEnchantmentMeter_mc
		endIf
	;elseIf hideGems || chargeDisplayType == 2
	else
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenSoulGemAlpha")	
		element = 14 ;leftSoulgem_mc
		if Q == 1
			element = 27 ;rightSoulgem_mc
		endIf
	endIf
	float targetAlpha
	if show
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[element] + "._visible", true)
		targetAlpha = WC.afWidget_A[element]
		isChargeMeterShown[Q] = true
	else
		targetAlpha = 0.0
		isChargeMeterShown[Q] = false
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, targetAlpha)
		UICallback.Send(iHandle)
	endIf
	if show
		if chargeFadeoutEnabled && (chargeFadeoutDelay > 0) && (currCharge[Q] > lowChargeThreshold)
			if Q == 0
				LU.registerForMeterFadeoutUpdate(Q, chargeDisplayType, chargeFadeoutDelay)
			else
				RU.registerForMeterFadeoutUpdate(Q, chargeDisplayType, chargeFadeoutDelay)
			endIf
		endIf
	else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[element] + "._visible", false)
	endIf
endFunction

