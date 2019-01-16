
scriptName iEquip_RechargeScript extends Quest

import iEquip_SoulSeeker

iEquip_ChargeMeters Property CM Auto
iEquip_RechargeLeftFXScript Property LFX Auto
iEquip_RechargeRightFXScript Property RFX Auto

actor Property PlayerRef Auto
sound Property iEquip_Recharge_SFX Auto
Perk Property Enchanter00 Auto ; Used if Requiem detected - Requiem renames this perk to REQ_Perk_Enchanting_EnchantersInsight1

bool Property bRechargingEnabled = true Auto Hidden
bool Property bUseLargestSoul = true Auto Hidden
bool Property bUsePartFilledGems = false Auto Hidden
bool Property bAllowOversizedSouls = false Auto Hidden
bool Property bIsRequiemLoaded = false Auto Hidden

float[] afAmountToRecharge
float[] afSkillPointsToAdd

event OnInit()
	debug.trace("iEquip_RechargeScript OnInit called")

	afAmountToRecharge = new float[6]
	afAmountToRecharge[0] = 0.0 ;Empty
	afAmountToRecharge[1] = 250.0 ;Petty
	afAmountToRecharge[2] = 500.0 ;Lesser
	afAmountToRecharge[3] = 1000.0 ;Common
	afAmountToRecharge[4] = 2000.0 ;Greater
	afAmountToRecharge[5] = 3000.0 ;Grand

	afSkillPointsToAdd = new float[6]
	afSkillPointsToAdd[0] = 0.0
	afSkillPointsToAdd[1] = 0.05
	afSkillPointsToAdd[2] = 0.1
	afSkillPointsToAdd[3] = 0.2
	afSkillPointsToAdd[4] = 0.4
	afSkillPointsToAdd[5] = 0.6
endEvent

function rechargeWeapon(int Q)
	debug.trace("iEquip_RechargeScript rechargeWeapon called - Q: " + Q)
    if bIsRequiemLoaded && !PlayerRef.HasPerk(Enchanter00)
        debug.notification("$iEquip_RequiemEnchantingPerkMissing")
    else
        string weaponToRecharge = CM.asItemCharge[Q]
        float currentCharge = PlayerRef.GetActorValue(weaponToRecharge)
        ;float maxCharge = PlayerRef.GetBaseActorValue(weaponToRecharge)
        float maxCharge = WornObject.GetItemMaxCharge(PlayerRef, Q, 0)
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
                    if afAmountToRecharge[soulSize] < requiredCharge
                       PlayerRef.ModActorValue(weaponToRecharge, afAmountToRecharge[soulSize])
                    else
                        PlayerRef.ModActorValue(weaponToRecharge, requiredCharge)
                    endIf
                    game.AdvanceSkill("Enchanting", afSkillPointsToAdd[soulSize])
                    CM.checkAndUpdateChargeMeter(Q, true)
                else
                    debug.Notification("No soul found")
                endIf
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
