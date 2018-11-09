
scriptName iEquip_RechargeScript extends Quest

import iEquip_SoulSeeker
import UI

iEquip_WidgetCore Property WC Auto
iEquip_ChargeMeters Property CM Auto
iEquip_RechargeLeftFXScript Property LFX Auto
iEquip_RechargeRightFXScript Property RFX Auto

actor Property PlayerRef Auto
sound Property iEquip_Recharge_SFX Auto

string HUD_MENU
string WidgetRoot

bool Property bRechargingEnabled = true Auto Hidden
bool Property bUseLargestSoul = true Auto Hidden
bool Property bUsePartFilledGems = false Auto Hidden
bool Property bAllowOversizedSouls = false Auto Hidden

float[] amountToRecharge
float[] skillPointsToAdd

event OnInit()
	debug.trace("iEquip_RechargeScript OnInit called")
	HUD_MENU = WC.HUD_MENU
	WidgetRoot = WC.WidgetRoot

	amountToRecharge = new float[6]
	amountToRecharge[0] = 0.0 ;Empty
	amountToRecharge[1] = 250.0 ;Petty
	amountToRecharge[2] = 500.0 ;Lesser
	amountToRecharge[3] = 1000.0 ;Common
	amountToRecharge[4] = 2000.0 ;Greater
	amountToRecharge[5] = 3000.0 ;Grand

	skillPointsToAdd = new float[6]
	skillPointsToAdd[0] = 0.0
	skillPointsToAdd[1] = 0.05
	skillPointsToAdd[2] = 0.1
	skillPointsToAdd[3] = 0.2
	skillPointsToAdd[4] = 0.4
	skillPointsToAdd[5] = 0.6
endEvent

function rechargeWeapon(int Q)
	debug.trace("iEquip_RechargeScript rechargeWeapon called - Q: " + Q)
    string weaponToRecharge = CM.itemCharge[Q]
    float currentCharge = PlayerRef.GetActorValue(weaponToRecharge)
    float maxCharge = PlayerRef.GetBaseActorValue(weaponToRecharge)
    float requiredCharge = maxCharge - currentCharge
    debug.trace("iEquip_RechargeScript rechargeWeapon - maxCharge: " + maxCharge + ", currentCharge: " + currentCharge + ", requiredCharge: " + requiredCharge)
    if requiredCharge < 1.0
        debug.Notification("This weapon is already fully charged")
    else
        int requiredSoul = getRequiredSoul(Q, requiredCharge)
        if requiredSoul > 0
            int soulSize = iEquip_SoulSeeker.bringMeASoul(requiredSoul, bUseLargestSoul as int, bUsePartFilledGems, bAllowOversizedSouls)
            debug.trace("iEquip_RechargeScript rechargeWeapon - bringMeASoul returned me a size " + soulSize + " soul")
            if soulSize > 0
                iEquip_Recharge_SFX.Play(PlayerRef)
                if Q == 0
                    LFX.ShowRechargeFX()
                else
                    RFX.ShowRechargeFX()
                endIf
                ;Just in case it's possible to overcharge a weapon ensure we never recharge more than requiredCharge
                if amountToRecharge[soulSize] < requiredCharge
        	       PlayerRef.ModActorValue(weaponToRecharge, amountToRecharge[soulSize])
                else
                    PlayerRef.ModActorValue(weaponToRecharge, requiredCharge)
                endIf
        	    game.AdvanceSkill("Enchanting", skillPointsToAdd[soulSize])
        	    CM.checkAndUpdateChargeMeter(Q, true)
            else
            	debug.Notification("No soul found")
            endIf
        endIf
    endIf
endFunction

;ToDo - once operation confirmed remove debug line and make requiredCharge inline
int function getRequiredSoul(int Q, float requiredCharge)
	debug.trace("iEquip_RechargeScript getRequiredSoul called - Q: " + Q)
    int bestFitSoul = 0
    if requiredCharge > 0
        if requiredCharge < 251.0
        	bestFitSoul = 1
        elseIf requiredCharge < 501.0
        	bestFitSoul = 2
        elseIf requiredCharge < 1001.0
        	bestFitSoul = 3
        elseIf requiredCharge < 2001.0
        	bestFitSoul = 4
        else
        	bestFitSoul = 5
        endIf
    endIf
    if bestFitSoul > 1 && !bAllowOversizedSouls
        bestFitSoul -= 1
    endIf
    debug.trace("iEquip_RechargeScript getRequiredSoul - returning bestFitSoul: " + bestFitSoul)
    return bestFitSoul
endFunction    
