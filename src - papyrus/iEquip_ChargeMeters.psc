
scriptname iEquip_ChargeMeters extends quest

import UI
import UICallback
Import WornObject
Import iEquip_WeaponExt

iEquip_WidgetCore Property WC Auto
iEquip_LeftChargeMeterUpdateScript Property LU Auto
iEquip_RightChargeMeterUpdateScript Property RU Auto

Actor Property PlayerRef Auto

; PRIVATE VARIABLES -------------------------------------------------------------------------------
String HUD_MENU
String WidgetRoot
int[] aiTargetQ
float[] afCurrCharge

; PROPERTIES --------------------------------------------------------------------------------------
int property iPrimaryFillColor = 0x8C9EC2 auto hidden
int property iLowChargeFillColor = 0xFF0000 auto hidden
int property iSecondaryFillColor	= -1 auto hidden ;Only used if a gradient fill is required
int	property iFlashColor = -1 auto hidden ;White by default
int property iChargeDisplayType = 1 auto Hidden ; 0 = None, 1 = Charge meters, 2 = Dynamic soulgems
bool property bChargeFadeoutEnabled = false auto hidden
bool property bCustomFlashColor = false auto hidden
bool property bEnableLowCharge = true auto hidden
bool property bEnableGradientFill = false auto hidden
float property fChargeFadeoutDelay = 5.0 auto hidden
float property fLowChargeThreshold = 0.20 auto hidden
bool[] property abIsChargeMeterShown auto hidden
string[] property asMeterFillDirection auto hidden
string[] property asItemCharge auto hidden

bool property bSettingsChanged = false auto hidden

; EVENTS ------------------------------------------------------------------------------------------
event OnInit()
	debug.trace("iEquip_ChargeMeters OnInit called")
	abIsChargeMeterShown = new bool[2]
	abIsChargeMeterShown[0] = false
	abIsChargeMeterShown[1] = false

	asMeterFillDirection = new string[2]
	asMeterFillDirection[0] = "left"
	asMeterFillDirection[1] = "right"

	aiTargetQ = new int[2]

	afCurrCharge = new float[2]
	afCurrCharge[0] = 0.0
	afCurrCharge[1] = 0.0

	asItemCharge = new string[2]
	asItemCharge[0] = "LeftItemCharge"
	asItemCharge[1] = "RightItemCharge"
endEvent

function OnWidgetLoad(string sHUD_MENU, string sWidgetRoot, int leftQ, int rightQ) ;Called from WidgetCore
	debug.trace("iEquip_ChargeMeters OnWidgetLoad called")
	HUD_MENU = sHUD_MENU
	WidgetRoot = sWidgetRoot
	aiTargetQ[0] = leftQ
	aiTargetQ[1] = rightQ
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
		UICallback.PushInt(iHandle, iPrimaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushString(iHandle, asMeterFillDirection[Q])	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, abIsChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
endFunction

function initSoulGem(int Q)
	int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".initSoulGem")	
	If(iHandle)
		debug.trace("iEquip_ChargeMeters initSoulGem - got iHandle for .initSoulGem")
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, iPrimaryFillColor)
		UICallback.PushInt(iHandle, -1)
		UICallback.PushFloat(iHandle, 1.0)	
		UICallback.PushBool(iHandle, true)
		UICallback.PushBool(iHandle, abIsChargeMeterShown[Q])
		UICallback.Send(iHandle)
	endIf
endFunction

function updateMeterPercent(int Q, bool forceUpdate = false, bool skipFlash = false) ;Sets the meter percent, a_force sets the meter percent without animation
	debug.trace("iEquip_ChargeMeters updateMeterPercent called - Q: " + Q + ", asItemCharge[Q]: " + asItemCharge[Q] + ", forceUpdate: " + forceUpdate + ", skipFlash: " + skipFlash)
	float currentCharge = PlayerRef.GetActorValue(asItemCharge[Q])
	;float maxCharge = PlayerRef.GetBaseActorValue(asItemCharge[Q])
	float maxCharge = WornObject.GetItemMaxCharge(PlayerRef, Q, 0)
	float currPercent = 0.0
	if maxCharge > 0.0 && currentCharge > 0.0
		currPercent = currentCharge / maxCharge
	endIf
	debug.trace("iEquip_ChargeMeters updateMeterPercent - currentCharge: " + currentCharge + ", maxCharge: " + maxCharge + ", currPercent: " + currPercent + ". fLowChargeThreshold: " + fLowChargeThreshold)
	if (currPercent != afCurrCharge[Q]) || forceUpdate
		afCurrCharge[Q] = currPercent
		int fillColor = iPrimaryFillColor
		if bEnableLowCharge && (currPercent <= fLowChargeThreshold)
			fillColor = iLowChargeFillColor
		endIf
		int iHandle
		if iChargeDisplayType == 1
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterPercent")
		elseIf iChargeDisplayType == 2
			iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setSoulGemPercent")
		endIf
		If(iHandle)
			UICallback.PushInt(iHandle, Q)
			UICallback.PushFloat(iHandle, currPercent)
			UICallback.PushInt(iHandle, fillColor)
			if iChargeDisplayType == 1
				UICallback.PushBool(iHandle, bEnableGradientFill)
				UICallback.PushInt(iHandle, iSecondaryFillColor)
			endIf
			UICallback.PushBool(iHandle, true)
			UICallback.Send(iHandle)
		endIf
		if currPercent <= fLowChargeThreshold
			if !WC.bIsWidgetShown
				WC.updateWidgetVisibility()
			endIf
			if !abIsChargeMeterShown[Q]
				updateChargeMeterVisibility(Q, true)
			endIf
		endIf
		if !skipFlash && currPercent < 0.01
			startMeterFlash(Q, true)
		endIf
	endIf
endFunction

function startMeterFlash(int Q, bool forceFlash = false) ; Starts meter flashing. forceFlash starts the meter flashing if it's already animating
	debug.trace("iEquip_ChargeMeters startMeterFlash called - Q: " + Q)
	int iHandle
	if iChargeDisplayType == 1
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startChargeMeterFlash")
	elseIf iChargeDisplayType == 2
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".startSoulGemFlash")
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushInt(iHandle, iFlashColor)
		UICallback.PushBool(iHandle, forceFlash)
		UICallback.Send(iHandle)
	endIf
endFunction

function updateChargeMeters(bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeters called")
	int Q = 0
	if iChargeDisplayType > 0
		while Q < 2
			;Force both meters and both gems to hide first then call checkAndUpdate to reshow the relevant one if required
			;if iChargeDisplayType == 2
				updateChargeMeterVisibility(Q, false, true) ;hideMeters
			;elseIf iChargeDisplayType == 1
				updateChargeMeterVisibility(Q, false, false, true) ;hideGems
			;endIf
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
		;if PlayerRef.GetEquippedWeapon(Q)
		checkAndUpdateChargeMeter(Q, false)
		;endIf
		Q += 1
	endWhile
endFunction

function checkAndUpdateChargeMeter(int Q, bool forceUpdate = false)
	debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter called - Q: " + Q)
	if !PlayerRef.IsWeaponDrawn()
		Utility.Wait(0.2)
	endIf
	if PlayerRef.IsWeaponDrawn()
		int isEnchanted = 0
		bool isLeftHand = false
		if Q == 0
			isLeftHand = true
		endIf
		weapon currentWeapon = PlayerRef.GetEquippedWeapon(isLeftHand)
		bool isBound = false 
		if currentWeapon
			isBound = iEquip_WeaponExt.IsWeaponBound(currentWeapon)
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - weapon name: " + currentWeapon.GetName() + ", isBound: " + isBound)
		endIf
		enchantment currentEnchantment
		if currentWeapon && !isBound
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", isLeftHand: " + isLeftHand + ", currentWeapon: " + currentWeapon.GetName())
			currentEnchantment = currentWeapon.GetEnchantment()
			if !currentEnchantment
				currentEnchantment = wornobject.GetEnchantment(PlayerRef, Q, 0)
			endIf
			if currentEnchantment
				debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - Q: " + Q + ", currentEnchantment: " + currentEnchantment.GetName())
				isEnchanted = 1
				if iChargeDisplayType > 0
					;Hide first
					if abIsChargeMeterShown[Q]
						updateChargeMeterVisibility(Q, false) ;Hide
					endIf
					;Update values
					updateMeterPercent(Q, forceUpdate, true)
					if iChargeDisplayType == 1
						int iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".setChargeMeterFillDirection")	
						if(iHandle)
							debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - got iHandle for .setChargeMeterFillDirection, Q: " + Q + ", fill direction: " + asMeterFillDirection[Q])
							UICallback.PushInt(iHandle, Q)
							UICallback.PushString(iHandle, asMeterFillDirection[Q])
							UICallback.Send(iHandle)
						endIf
					endIf
					;Show meter
					updateChargeMeterVisibility(Q, true)
					;Flash if empty
					if PlayerRef.GetActorValue(asItemCharge[Q]) < 1
						startMeterFlash(Q, true)
					endIf
				endIf
			endIf
		endIf
		if (!currentWeapon || isEnchanted == 0 || isBound)
			debug.trace("iEquip_ChargeMeters checkAndUpdateChargeMeter - not a weapon or not enchanted. currentWeapon: " + currentWeapon + ", isEnchanted: " + isEnchanted + ", isBound: " + isBound + ", abIsChargeMeterShown[" + Q + "]: " + abIsChargeMeterShown[Q])
			updateChargeMeterVisibility(Q, false) ;Hide
		endIf
		;Now update the object keys for the currently equipped item in case anything has changed since we last equipped it
		;ToDo - do the same in the poison functions
		if currentEnchantment
			jMap.setForm(jArray.getObj(aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "lastKnownEnchantment", currentEnchantment as Form)
		endIf
		jMap.setInt(jArray.getObj(aiTargetQ[Q], WC.aiCurrentQueuePosition[Q]), "isEnchanted", isEnchanted)
	else
		WC.EH.bWaitingForEnchantedWeaponDrawn = true
	endIf
endFunction

function updateChargeMeterVisibility(int Q, bool show, bool hideMeters = false, bool hideGems = false)
	debug.trace("iEquip_ChargeMeters updateChargeMeterVisibility called - Q: " + Q + ", show: " + show)
	int element
	int iHandle
	if hideMeters || (iChargeDisplayType == 1 && !hideGems)
		iHandle = UICallback.Create(HUD_MENU, WidgetRoot + ".tweenChargeMeterAlpha")
		element = 13 ;leftEnchantmentMeter_mc
		if Q == 1
			element = 26 ;rightEnchantmentMeter_mc
		endIf
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
		abIsChargeMeterShown[Q] = true
	else
		targetAlpha = 0.0
		abIsChargeMeterShown[Q] = false
	endIf
	If(iHandle)
		UICallback.PushInt(iHandle, Q)
		UICallback.PushFloat(iHandle, targetAlpha)
		UICallback.Send(iHandle)
	endIf
	if show
		if bChargeFadeoutEnabled && (fChargeFadeoutDelay > 0) && (afCurrCharge[Q] > fLowChargeThreshold)
			if Q == 0
				LU.registerForMeterFadeoutUpdate(Q, iChargeDisplayType, fChargeFadeoutDelay)
			else
				RU.registerForMeterFadeoutUpdate(Q, iChargeDisplayType, fChargeFadeoutDelay)
			endIf
		endIf
	else
		UI.setBool(HUD_MENU, WidgetRoot + WC.asWidgetElements[element] + "._visible", false)
	endIf
endFunction

