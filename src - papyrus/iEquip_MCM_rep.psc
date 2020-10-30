Scriptname iEquip_MCM_rep extends iEquip_MCM_Page

; Script deprecated in 1.5

import iEquip_StringExt

iEquip_RechargeScript Property RC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_ThrowingPoisons Property TP Auto
iEquip_KeyHandler Property KH Auto

string[] chargeDisplayOptions
string[] meterFillDirectionOptions
string[] rawMeterFillDirectionOptions
int[] meterFillDirection
string[] poisonMessageOptions
string[] poisonIndicatorOptions
string[] throwingPoisonOptions
string[] throwingPoisonHands
string[] effectsOptions

int mcmUnmapFLAG
int mcmDisabledFLAG

function loadData(int jPageObj, int presetVersion)     ; Load page data from jPageObj, only called if loading an earlier version MCM preset
    RC.bRechargingEnabled = jArray.getInt(jPageObj, 0)
    
    RC.bUseLargestSoul = jArray.getInt(jPageObj, 1)
    RC.bAllowOversizedSouls = jArray.getInt(jPageObj, 2)
    RC.bUsePartFilledGems = jArray.getInt(jPageObj, 3)
    
    CM.iChargeDisplayType = jArray.getInt(jPageObj, 4)
    CM.bChargeFadeoutEnabled = jArray.getInt(jPageObj, 5)
    CM.fChargeFadeoutDelay = jArray.getFlt(jPageObj, 6)
    CM.iPrimaryFillColor = jArray.getInt(jPageObj, 7)
    CM.bCustomFlashColor = jArray.getInt(jPageObj, 8)
    CM.iFlashColor = jArray.getInt(jPageObj, 9)
    CM.bEnableLowCharge = jArray.getInt(jPageObj, 10)
    CM.fLowChargeThreshold = jArray.getFlt(jPageObj, 11)
    CM.iLowChargeFillColor = jArray.getInt(jPageObj, 12)
    CM.bEnableGradientFill = jArray.getInt(jPageObj, 13)
    CM.iSecondaryFillColor = jArray.getInt(jPageObj, 14)
    meterFillDirection[0] = jArray.getInt(jPageObj, 15)
    CM.asMeterFillDirection[0] = rawMeterFillDirectionOptions[meterFillDirection[0]]
    meterFillDirection[1] = jArray.getInt(jPageObj, 16)
    CM.asMeterFillDirection[1] = rawMeterFillDirectionOptions[meterFillDirection[1]]

    WC.EH.bRealTimeStaffMeters = jArray.getInt(jPageObj, 17)

    WC.iShowPoisonMessages = jArray.getInt(jPageObj, 18)
    WC.bAllowPoisonSwitching = jArray.getInt(jPageObj, 19)
    WC.bAllowPoisonTopUp = jArray.getInt(jPageObj, 20)
    
    WC.iPoisonChargesPerVial = jArray.getInt(jPageObj, 21)
    WC.iPoisonChargeMultiplier = jArray.getInt(jPageObj, 22)
    
    WC.iPoisonIndicatorStyle = jArray.getInt(jPageObj, 23)

    TP.iThrowingPoisonBehavior = jArray.getInt(jPageObj, 24, 0)
    KH.iThrowingPoisonsKey = jArray.getInt(jPageObj, 25, -1)
    TP.iThrowingPoisonHand = jArray.getInt(jPageObj, 26, 1)
    TP.fThrowingPoisonEffectsMagMult = jArray.getFlt(jPageObj, 27, 0.6)
    TP.fPoisonHazardRadius = jArray.getFlt(jPageObj, 28, 6.0)
    TP.fPoisonHazardDuration = jArray.getFlt(jPageObj, 29, 5.0)
    TP.iNumPoisonHazards = jArray.getInt(jPageObj, 30, 5)
    TP.fThrowingPoisonProjectileGravity = jArray.getFlt(jPageObj, 31, 1.2)

    RC.iRechargeFX = jArray.getInt(jPageObj, 32, 3)
    WC.iPoisonFX = jArray.getInt(jPageObj, 33, 3)
endFunction