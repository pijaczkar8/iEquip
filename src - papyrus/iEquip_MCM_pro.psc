Scriptname iEquip_MCM_pro extends iEquip_MCM_Page

iEquip_WidgetCore Property WC Auto
iEquip_KeyHandler Property KH Auto
iEquip_ProMode Property PM Auto
iEquip_PotionScript Property PO Auto

sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions
string[] QHEquipOptions
string[] QRPreferredWeaponType
string[] QRSwitchOutOptions

; #############
; ### SETUP ###

function initData()
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
endFunction

function drawPage()
    if MCM.bEnabled
        if bStillToEnableProMode
            MCM.AddTextOptionST("pro_txt_dragEastr", "", "$iEquip_MCM_pro_txt_dragEastrA")
        else
            MCM.AddToggleOptionST("pro_tgl_enblProMode", "$iEquip_MCM_pro_lbl_enblProMode", WC.bProModeEnabled)
            MCM.AddTextOptionST("pro_txt_whatProMode", "What is Pro Mode?", "")
        endIf
        
        if WC.bProModeEnabled
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("Preselect Options")
            MCM.AddTextOptionST("pro_txt_whatPreselect", "What is Preselect?", "")
            MCM.AddToggleOptionST("pro_tgl_enblPreselect", "Enable Preselect", KH.bPreselectEnabled)
                    
            if KH.bPreselectEnabled
                MCM.AddToggleOptionST("pro_tgl_enblShoutPreselect", "Enable shout preselect", PM.bShoutPreselectEnabled)
                MCM.AddToggleOptionST("pro_tgl_swapPreselectItm", "Swap preselect with current item", PM.bPreselectSwapItemsOnEquip)
                MCM.AddToggleOptionST("pro_tgl_eqpAllExitPreselectMode", "Equip All Exits Preselect Mode", PM.bTogglePreselectOnEquipAll)
            endIf
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("QuickShield Options")
            MCM.AddTextOptionST("pro_txt_whatQuickshield", "What is QuickShield?", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickshield", "Enable QuickShield", KH.bQuickShieldEnabled)
                    
            if KH.bQuickShieldEnabled
                MCM.AddToggleOptionST("pro_tgl_with2hReqp", "With 2H/ranged equipped", PM.bQuickShield2HSwitchAllowed)
                MCM.AddToggleOptionST("pro_tgl_prefShieldMag", "Prefer magic", PM.bQuickShieldPreferMagic)
                        
                if PM.bQuickShieldPreferMagic
                    MCM.AddMenuOptionST("pro_men_rightHandspllTyp", "Right hand spell type", QSPreferredMagicSchool[MCM.iCurrentQSPreferredMagicSchoolChoice])
                endIf         
               
                MCM.AddMenuOptionST("pro_men_inPreselectQuickshieldMode", "In Preselect Mode", preselectQuickFunctionOptions[PM.iPreselectQuickShield])
            endIf
                    
            MCM.AddEmptyOption() 
            MCM.AddHeaderOption("QuickHeal Options")
            MCM.AddTextOptionST("pro_txt_whatQuickheal", "What is QuickHeal?", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickheal", "Enable QuickHeal", KH.bQuickHealEnabled)
                    
            if KH.bQuickHealEnabled
                MCM.AddToggleOptionST("pro_tgl_prefHealMag", "Prefer magic", PM.bQuickHealPreferMagic)
                        
                if PM.bQuickHealPreferMagic
                    MCM.AddMenuOptionST("pro_men_alwysEqpSpll", "Always equip spell...", QHEquipOptions[PM.iQuickHealEquipChoice])
                endIf
                        
                MCM.AddToggleOptionST("pro_tgl_use2Pot", "Use 2nd Choice Potion", PO.bQuickHealUseSecondChoice)
                MCM.AddToggleOptionST("pro_tgl_swtchBck", "Switch Back", PM.bQuickHealSwitchBackEnabled)
            endIf
                    
            MCM.SetCursorPosition(1)
                    
            MCM.AddHeaderOption("QuickRanged Options")
            MCM.AddTextOptionST("pro_txt_whatQuickranged", "What is QuickRanged?", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "Enable QuickRanged", KH.bQuickRangedEnabled)
                    
            if KH.bQuickRangedEnabled
                MCM.AddMenuOptionST("pro_men_prefWepTyp", "Preferred weapon type", QRPreferredWeaponType[PM.iQuickRangedPreferredWeaponType])
                MCM.AddMenuOptionST("pro_men_swtchOut", "Switch out options", QRSwitchOutOptions[PM.iQuickRangedSwitchOutAction])

                if PM.iQuickRangedSwitchOutAction == 4
                    MCM.AddMenuOptionST("pro_men_prefMagSchl", "Preferred magic school", QSPreferredMagicSchool[MCM.iCurrentQRPreferredMagicSchoolChoice])
                endIf
               
                MCM.AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "In Preselect Mode", preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
            endIf
                    
            MCM.AddEmptyOption()
            MCM.AddHeaderOption("QuickDualCast Options")
            MCM.AddTextOptionST("pro_txt_whatQuickdualcast", "What is QuickDualCast?", "")
            MCM.AddToggleOptionST("pro_tgl_enblQuickdualcast", "Enable QuickDualCast", WC.bQuickDualCastEnabled)
                    
            if WC.bQuickDualCastEnabled
                MCM.AddTextOption("Enable QuickDualCast for:", "")
                MCM.AddToggleOptionST("pro_tgl_altSpll", "   Alteration spells", WC.abQuickDualCastSchoolAllowed[0])
                MCM.AddToggleOptionST("pro_tgl_conjSpll", "   Conjuration spells", WC.abQuickDualCastSchoolAllowed[1])
                MCM.AddToggleOptionST("pro_tgl_destSpll", "   Destruction spells", WC.abQuickDualCastSchoolAllowed[2])
                MCM.AddToggleOptionST("pro_tgl_illSpll", "   Illusion spells", WC.abQuickDualCastSchoolAllowed[3])
                MCM.AddToggleOptionST("pro_tgl_restSpll", "   Restoration spells", WC.abQuickDualCastSchoolAllowed[4])
                MCM.AddToggleOptionST("pro_tgl_reqBothQue", "Only if in both queues", PM.bQuickDualCastMustBeInBothQueues)
            endIf
        endIf
    endIf
endFunction

; ################
; ### Pro Mode ###
; ################

State pro_txt_dragEastr
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("??????")
        elseIf currentEvent == "Select"
            if iProModeEasterEggCounter >= 0
                string msg
            
                if iProModeEasterEggCounter == 5
                    msg = "$iEquip_MCM_pro_txt_dragEastrB"
                elseIf iProModeEasterEggCounter == 4
                    msg = "$iEquip_MCM_pro_txt_dragEastrC"
                elseIf iProModeEasterEggCounter == 3
                    msg = "$iEquip_MCM_pro_txt_dragEastrD"
                elseIf iProModeEasterEggCounter == 2
                    msg = "$iEquip_MCM_pro_txt_dragEastrE"
                elseIf iProModeEasterEggCounter == 1
                    msg = "$iEquip_MCM_pro_txt_dragEastrF"
                elseIf iProModeEasterEggCounter == 0
                    msg = "$iEquip_MCM_pro_txt_dragEastrG"
                endIf
                
                MCM.SetTextOptionValueST(msg)
                iProModeEasterEggCounter -= 1
            else
                ; Wohoo, let's play an epic tune
                UILevelUp.Play(MCM.PlayerRef)
                bStillToEnableProMode = false
                WC.bProModeEnabled = true
                
                MCM.ShowMessage("$iEquip_MCM_pro_msg_dragEastr", false, "$OK")
                MCM.forcePageReset()
            endIf
        endIf
    endEvent
endState

State pro_tgl_enblProMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("$iEquip_MCM_pro_txt_enblProMode")
        elseIf currentEvent == "Select"
            WC.bProModeEnabled = !WC.bProModeEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bProModeEnabled = false 
            KH.bQuickShieldEnabled = false
            WC.bQuickDualCastEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_txt_whatProMode
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("What is iEquip Pro Mode?\n\nPro Mode is a suite of advanced features and settings which allow you to fully unleash the power of iEquip.", false, "Exit")
        endIf
    endEvent    
endState
        
; ---------------------
; - Preselect Options -
; ---------------------

State pro_txt_whatPreselect
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("iEquip Preselect Mode\n\nPreselect Mode is toggled by triple pressing your shout hotkey. Once enabled it reveals a new preselect slot alongside each main widget slot. "+\
                               "Your hotkey will now cycle the preselect slot allowing you to prepare your next items/shout without actually equipping them.  You can then choose to longpress left/right/shout to swap the individual slots, "+\
                               "or press and hold left/right to equip all preselected items at once\n\nPage 1/2", true, "Next page", "Cancel")
                MCM.ShowMessage("iEquip Preselect Mode\n\nThe preselect icons will only appear for queues with 3 or more items, and you can also choose to disable shout preselect below if you'd rather just preselect left/right. "+\
                                "You can choose how you want to toggle back out of Preselect Mode below.  With a bit of forethought Preselect Mode opens up some great new tactical gameplay when the going is about to get tough!\n\nPage 2/2", false, "OK")
            endIf
        endIf
    endEvent    
endState

State pro_tgl_enblPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable/disable Preselect and the associated options. For a full description of what Preselect is and what it does read the Help notes\nDefault = On")
        elseIf currentEvent == "Select"
            KH.bPreselectEnabled = !KH.bPreselectEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            KH.bPreselectEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_enblShoutPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("If you only want Preselect to be available on your left/right hand slots you can choose to disable preselect altogether on the shout slot\nDefault = On")
        elseIf currentEvent == "Select"
            PM.bShoutPreselectEnabled = !PM.bShoutPreselectEnabled
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        elseIf currentEvent == "Default"
            PM.bShoutPreselectEnabled = true
            MCM.SetToggleOptionValueST(PM.bShoutPreselectEnabled)
        endIf
    endEvent
endState

State pro_tgl_swapPreselectItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("The normal behaviour when equipping a preselected item is to then advance the preselect slot on to the next item in the queue. "+\
                            "With this enabled it will instead swap the currently equipped item to the preselect slot, allowing you to swap back and forth between the two items. "+\
                            "You can still cycle the preselect slot as normal.\nDefault: Off")
        elseIf currentEvent == "Select"
            PM.bPreselectSwapItemsOnEquip = !PM.bPreselectSwapItemsOnEquip
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        elseIf currentEvent == "Default"
            PM.bPreselectSwapItemsOnEquip = false
            MCM.SetToggleOptionValueST(PM.bPreselectSwapItemsOnEquip)
        endIf
    endEvent
endState

State pro_tgl_eqpAllExitPreselectMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling this will toggle you back out of Preselect Mode whenever you use Equip All Preselected Items. "+\
                            "It still allows you to equip individual preselected items as many times as you like, "+\
                            "and you can still toggle out of Preselect Mode manually at any time by pressing and holding your Consumables hotkey.\nDefault: Disabled")
        elseIf currentEvent == "Select"
            PM.bTogglePreselectOnEquipAll = !PM.bTogglePreselectOnEquipAll
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        elseIf currentEvent == "Default"
            PM.bTogglePreselectOnEquipAll = false
            MCM.SetToggleOptionValueST(PM.bTogglePreselectOnEquipAll)
        endIf
    endEvent
endState

; -----------------------
; - QuickShield Options -
; -----------------------

State pro_txt_whatQuickshield
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("iEquip QuickShield\n\nIf you triple press your left hotkey with QuickShield enabled iEquip will scan your left queue for the first available shield or ward spell and equip it automatically. "+\
                               "If you choose below to 'Prefer Magic' then iEquip will look for a ward spell first, and if it doesn't find one will then look for a shield. "+\
                               "It will also check if you have a spell equipped in your right hand and if not will search for a destruction spell, "+\
                               "or whichever school you have opted to prefer below and equip that in your right hand.\n\nPage 1/3 ", true, "Next page", "Cancel")
                if MCM.ShowMessage("iEquip QuickShield\n\nIf you haven't opted to 'Prefer Magic' then iEquip will check what you have equipped in your right hand and if it finds anything other than a spell will look for a shield first then a ward, "+\
                                   "if it finds a spell it will look for a ward first and then a shield. "+\
                                   "If you currently have a 2H or ranged weapon equipped in your right hand iEquip will search for a suitable 1H item and re-equip the right hand as well.\n\nPage 2/3", true, "Next page", "Cancel")
                    MCM.ShowMessage("iEquip QuickShield\n\nYou can also choose to allow QuickShield in Preselect Mode. "+\
                                    "In Preselect Mode iEquip will do the same checks on your right hand and 'Prefer Magic' setting, but will only switch the left preselect slot to the found shield or ward. "+\
                                    "The right hand and right preselect slot will not be switched.  Used in combination with Equip All Preselected you can begin to build quite complex three stage attack/equip strategies.\n\nPage 3/3", false, "OK")
                endIf
            endIf
        endIf
    endEvent   
endState

State pro_tgl_enblQuickshield
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable/disable QuickShield and the associated options. For a full description of what QuickShield is and what it does read the Help notes\nDefault = On")
        elseIf currentEvent == "Select"
            KH.bQuickShieldEnabled = !KH.bQuickShieldEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            KH.bQuickShieldEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_with2hReqp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled if QuickShield is used while wielding a 2H or ranged weapon iEquip will look for a suitable 1H item or spell and equip that in your right hand at the same time\nDefault = On")
        elseIf currentEvent == "Select"
            PM.bQuickShield2HSwitchAllowed = !PM.bQuickShield2HSwitchAllowed
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        elseIf currentEvent == "Default"
            PM.bQuickShield2HSwitchAllowed = true
            MCM.SetToggleOptionValueST(PM.bQuickShield2HSwitchAllowed)
        endIf
    endEvent
endState

State pro_tgl_prefShieldMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled QuickShield will always look for a ward spell first and will also check what's in your right hand and look for a suitable spell to equip as well if needed.\nDefault = Off")
        elseIf currentEvent == "Select"
            PM.bQuickShieldPreferMagic = !PM.bQuickShieldPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickShieldPreferMagic = true
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_rightHandspllTyp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("If you have enabled Prefer Magic then you can also optionally choose a preferred school of magic for your right hand spell. "+\
                            "iEquip will look for a spell from that school first and if none found will look for a Destruction spell instead\nDefault = Destruction")
        elseIf currentEvent == "Open"
            MCM.fillMenu(MCM.iCurrentQSPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            MCM.iCurrentQSPreferredMagicSchoolChoice = currentVar as int
        
            if MCM.iCurrentQSPreferredMagicSchoolChoice == 0
                PM.sQuickShieldPreferredMagicSchool = "Alteration"
            elseIf MCM.iCurrentQSPreferredMagicSchoolChoice == 1
                PM.sQuickShieldPreferredMagicSchool = "Conjuration"
            elseIf MCM.iCurrentQSPreferredMagicSchoolChoice == 2
                PM.sQuickShieldPreferredMagicSchool = "Destruction"
            elseIf MCM.iCurrentQSPreferredMagicSchoolChoice == 3
                PM.sQuickShieldPreferredMagicSchool = "Illusion"
            elseIf MCM.iCurrentQSPreferredMagicSchoolChoice == 4
                PM.sQuickShieldPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[MCM.iCurrentQSPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickshieldMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the preffered behaviour of QuickShield when used in Preselect Mode\nDefault = Preselect")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickShield, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickShield = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickShield])
        endIf
    endEvent
endState

; ---------------------
; - QuickHeal Options -
; ---------------------

State pro_txt_whatQuickheal
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("iEquip QuickHeal\n\nQuickHeal is another 'Heat of Battle' feature for when you realise at the last second that you are about to become just another notch in that Draugr's sword hilt!\n\n"+\
                               "Simply triple press your consumable key and iEquip will either find and consume your strongest health potion (based on your preferred effect settings on the Potions page), "+\
                               "or it will search for and equip whichever healing spell it finds first.\n\nPage 1/2", true, "Next Page", "Exit")
                MCM.ShowMessage("iEquip QuickHeal\n\nIf iEquip can't find a suitable potion it will then look for a healing spell, and vice versa if you prefer magic.\n\n"+\
                                "If you do opt for magic over potions you can also decide which hand to always equip the spell in or if you prefer to dual cast, and you can also choose to enable switching back to your previous items. "+\
                                "With this enabled, as long as you haven't cycled either hand in the meantime, a second triple press on your consumable key will switch you back to what you had equipped in both hands before QuickHeal", false, "Exit")
            endIf
        endIf
    endEvent
endState

State pro_tgl_enblQuickheal
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable QuickHeal for convenient healing whenever you need it without the need for cycling")
        elseIf currentEvent == "Select"
            KH.bQuickHealEnabled = !KH.bQuickHealEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            KH.bQuickHealEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_prefHealMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled iEquip will look for a healing spell in either hand queue and equip it according to your preferences set below. "+\
                            "If it doesn't find a suitable spell it will then look for a health potion to consume as a last resort")
        elseIf currentEvent == "Select"
            PM.bQuickHealPreferMagic = !PM.bQuickHealPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            PM.bQuickHealPreferMagic = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_alwysEqpSpll
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Decide whether you would like the healing spell to be equipped in the hand it is found in, in a specific hand every time or dual casting")
        elseIf currentEvent == "Open"
            MCM.fillMenu(PM.iQuickHealEquipChoice, QHEquipOptions, 3)
        elseIf currentEvent == "Accept"
            PM.iQuickHealEquipChoice = currentVar as int
            MCM.SetMenuOptionValueST(QHEquipOptions[PM.iQuickHealEquipChoice])
        endIf
    endEvent
endState

State pro_tgl_use2Pot
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled iEquip will check for a health potion of the type you have set as first choice on the Potions page, "+\
                            "and if none are found will then check for your second choice before finally moving on to look for a healing spell if no potions are found. "+\
                            "If you prefer magic iEquip will look for a spell first, then a potion in the same order")
        elseIf currentEvent == "Select"
            PO.bQuickHealUseSecondChoice = !PO.bQuickHealUseSecondChoice
            MCM.SetToggleOptionValueST(PO.bQuickHealUseSecondChoice)
        elseIf currentEvent == "Default"
            PO.bQuickHealUseSecondChoice = true
            MCM.SetToggleOptionValueST(PO.bQuickHealUseSecondChoice)
        endIf
    endEvent
endState

State pro_tgl_swtchBck
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling this will allow you to switch back to your previously equipped items by triple pressing the consumable key for a second time after you have finished healing. "+\
                            "Only applies if a healing spell has been equipped.  If a potion has been consumed this will do nothing.")
        elseIf currentEvent == "Select"
            PM.bQuickHealSwitchBackEnabled = !PM.bQuickHealSwitchBackEnabled
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackEnabled)
        elseIf currentEvent == "Default"
            PM.bQuickHealSwitchBackEnabled = false
            MCM.SetToggleOptionValueST(PM.bQuickHealSwitchBackEnabled)
        endIf
    endEvent
endState

; -----------------------
; - QuickRanged Options -
; -----------------------

State pro_txt_whatQuickranged
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("iEquip QuickRanged\n\nIf you triple press your right hotkey with QuickRanged enabled iEquip will scan your right queue for the first available ranged weapon of the type selected below and equip it automatically. "+\
                            "If it doesn't find your first choice of weapon it will then look for one of the alternative type. Very handy for those situations where you need to grab a bow quickly and fire off an opening shot!", false, "OK")
        endIf
    endEvent
endState

State pro_tgl_enblQuickranged
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling this will allow you to switch back to your previously equipped items by triple pressing the consumable key for a second time after you have finished healing. "+\
                            "Only applies if a healing spell has been equipped.  If a potion has been consumed this will do nothing.")
        elseIf currentEvent == "Select"
            KH.bQuickRangedEnabled = !KH.bQuickRangedEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            KH.bQuickRangedEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_prefWepTyp
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedPreferredWeaponType, QRPreferredWeaponType, 0)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedPreferredWeaponType = currentVar as int
            MCM.SetMenuOptionValueST(QRPreferredWeaponType[PM.iQuickRangedPreferredWeaponType])
        endIf
    endEvent
endState

State pro_men_swtchOut
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iQuickRangedSwitchOutAction, QRSwitchOutOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iQuickRangedSwitchOutAction = currentVar as int
            MCM.SetMenuOptionValueST(QRSwitchOutOptions[PM.iQuickRangedSwitchOutAction])
        endIf
    endEvent
endState

State pro_men_prefMagSchl
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(MCM.iCurrentQRPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            MCM.iCurrentQRPreferredMagicSchoolChoice = currentVar as int
        
            if MCM.iCurrentQRPreferredMagicSchoolChoice == 0
                PM.sQuickRangedPreferredMagicSchool = "Alteration"
            elseIf MCM.iCurrentQRPreferredMagicSchoolChoice == 1
                PM.sQuickRangedPreferredMagicSchool = "Conjuration"
            elseIf MCM.iCurrentQRPreferredMagicSchoolChoice == 2
                PM.sQuickRangedPreferredMagicSchool = "Destruction"
            elseIf MCM.iCurrentQRPreferredMagicSchoolChoice == 3
                PM.sQuickRangedPreferredMagicSchool = "Illusion"
            elseIf MCM.iCurrentQRPreferredMagicSchoolChoice == 4
                PM.sQuickRangedPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[MCM.iCurrentQRPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickrangedMode
    event OnBeginState()
        if currentEvent == "Open"
            MCM.fillMenu(PM.iPreselectQuickRanged, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            PM.iPreselectQuickRanged = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[PM.iPreselectQuickRanged])
        endIf
    endEvent
endState

; -------------------------
; - QuickDualCast Options -
; -------------------------      

State pro_txt_whatQuickdualcast
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("iEquip QuickDualCast\n\nWith QuickDualCast enabled whenever you equip a spell from any of the schools selected below iEquip will automatically equip the same spell in both hands allowing you to switch to dual casting with only one action. "+\
                            "You can choose to only allow QuickDualCast if the equipped spell is present in both hand queues. "+\
                            "QuickDualCast will not be triggered if equipping a spell has resulted from an auto-equip when a 1H weapon has switched hands or a 2H/ranged weapon has been switched for 1H. QuickDualCast is disabled in Preselect Mode", false, "OK")
        endIf
    endEvent
endState  

State pro_tgl_enblQuickdualcast
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enable/disable QuickDualCast and the associated options. For a full description of what QuickDualCast is and what it does read the Help notes\nDefault = Off")
        elseIf currentEvent == "Select"
            WC.bQuickDualCastEnabled = !WC.bQuickDualCastEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bQuickDualCastEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_altSpll
    event OnBeginState()
        if (currentEvent == "Select" && WC.abQuickDualCastSchoolAllowed[0]) || currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[0] = false
        else
            WC.abQuickDualCastSchoolAllowed[0] = true
        endIf
        MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[0])
    endEvent
endState

State pro_tgl_conjSpll
    event OnBeginState()
        if (currentEvent == "Select" && WC.abQuickDualCastSchoolAllowed[1]) || currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[1] = false
        else
            WC.abQuickDualCastSchoolAllowed[1] = true
        endIf
        MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[1])
    endEvent
endState

State pro_tgl_destSpll
    event OnBeginState()
        if (currentEvent == "Select" && WC.abQuickDualCastSchoolAllowed[2]) || currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[2] = false
        else
            WC.abQuickDualCastSchoolAllowed[2] = true
        endIf
        MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[2])
    endEvent
endState

State pro_tgl_illSpll
    event OnBeginState()
        if (currentEvent == "Select" && WC.abQuickDualCastSchoolAllowed[3]) || currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[3] = false
        else
            WC.abQuickDualCastSchoolAllowed[3] = true
        endIf
        MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[3])
    endEvent
endState

State pro_tgl_restSpll
    event OnBeginState()
        if (currentEvent == "Select" && WC.abQuickDualCastSchoolAllowed[4]) || currentEvent == "Default"
            WC.abQuickDualCastSchoolAllowed[4] = false
        else
            WC.abQuickDualCastSchoolAllowed[4] = true
        endIf
        MCM.SetToggleOptionValueST(WC.abQuickDualCastSchoolAllowed[4])
    endEvent
endState

State pro_tgl_reqBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("By default QuickDualCast will dual equip spells from your chosen schools in both hands regardless of whether the spell is on one or both queues. "+\
                            "Enabling this restricts QuickDualCast to only spells which are found in both left and right hand queues.\nDefault = Off")
        elseIf currentEvent == "Select"
            PM.bQuickDualCastMustBeInBothQueues = !PM.bQuickDualCastMustBeInBothQueues
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        elseIf currentEvent == "Default"
            PM.bQuickDualCastMustBeInBothQueues = false
            MCM.SetToggleOptionValueST(PM.bQuickDualCastMustBeInBothQueues)
        endIf
    endEvent
endState
