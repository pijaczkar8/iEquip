Scriptname iEquip_MCM_pro extends iEquip_MCM_helperfuncs

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
    MCM.AddTextOptionST("pro_txt_whatProMode", "What is Pro Mode?", "")
    
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("Preselect Options")
    MCM.AddTextOptionST("pro_txt_whatPreselect", "What is Preselect?", "")
    MCM.AddToggleOptionST("pro_tgl_enblPreselect", "Enable Preselect", MCM.bPreselectEnabled)
            
    if MCM.bPreselectEnabled
        MCM.AddToggleOptionST("pro_tgl_enblShoutPreselect", "Enable shout preselect", MCM.bShoutPreselectEnabled)
        MCM.AddToggleOptionST("pro_tgl_swapPreselectItm", "Swap preselect with current item", MCM.bPreselectSwapItemsOnEquip)
        MCM.AddToggleOptionST("pro_tgl_eqpAllExitPreselectMode", "Equip All Exits Preselect Mode", MCM.bTogglePreselectOnEquipAll)
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("QuickShield Options")
    MCM.AddTextOptionST("pro_txt_whatQuickshield", "What is QuickShield?", "")
    MCM.AddToggleOptionST("pro_tgl_enblQuickshield", "Enable QuickShield", MCM.bQuickShieldEnabled)
            
    if MCM.bQuickShieldEnabled
        MCM.AddToggleOptionST("pro_tgl_with2hReqp", "With 2H/ranged equipped", MCM.bQuickShield2HSwitchAllowed)
        MCM.AddToggleOptionST("pro_tgl_prefShieldMag", "Prefer magic", MCM.bQuickShieldPreferMagic)
                
        if MCM.bQuickShieldPreferMagic
            MCM.AddMenuOptionST("pro_men_rightHandspllTyp", "Right hand spell type", QSPreferredMagicSchool[MCM.currentQSPreferredMagicSchoolChoice])
        endIf         
       
        MCM.AddMenuOptionST("pro_men_inPreselectQuickshieldMode", "In Preselect Mode", preselectQuickFunctionOptions[MCM.preselectQuickShield])
    endIf
            
    MCM.AddEmptyOption() 
    MCM.AddHeaderOption("QuickHeal Options")
    MCM.AddTextOptionST("pro_txt_whatQuickheal", "What is QuickHeal?", "")
    MCM.AddToggleOptionST("pro_tgl_enblQuickheal", "Enable QuickHeal", MCM.bQuickHealEnabled)
            
    if MCM.bQuickHealEnabled
        MCM.AddToggleOptionST("pro_tgl_prefHealMag", "Prefer magic", MCM.bQuickHealPreferMagic)
                
        if MCM.bQuickHealPreferMagic
            MCM.AddMenuOptionST("pro_men_alwysEqpSpll", "Always equip spell...", QHEquipOptions[MCM.quickHealEquipChoice])
        endIf
                
        MCM.AddToggleOptionST("pro_tgl_use2Pot", "Use 2nd Choice Potion", MCM.bQuickHealUseSecondChoice)
        MCM.AddToggleOptionST("pro_tgl_swtchBck", "Switch Back", MCM.bQuickHealSwitchBackEnabled)
    endIf
            
    MCM.SetCursorPosition(1)
            
    MCM.AddHeaderOption("QuickRanged Options")
    MCM.AddTextOptionST("pro_txt_whatQuickranged", "What is QuickRanged?", "")
    MCM.AddToggleOptionST("pro_tgl_enblQuickranged", "Enable QuickRanged", MCM.bQuickRangedEnabled)
            
    if MCM.bQuickRangedEnabled
        MCM.AddMenuOptionST("pro_men_prefWepTyp", "Preferred weapon type", QRPreferredWeaponType[MCM.quickRangedPreferredWeaponType])
        MCM.AddMenuOptionST("pro_men_swtchOut", "Switch out options", QRSwitchOutOptions[MCM.quickRangedSwitchOutAction])

        if MCM.quickRangedSwitchOutAction == 4
            MCM.AddMenuOptionST("pro_men_prefMagSchl", "Preferred magic school", QSPreferredMagicSchool[MCM.currentQRPreferredMagicSchoolChoice])
        endIf
       
        MCM.AddMenuOptionST("pro_men_inPreselectQuickrangedMode", "In Preselect Mode", preselectQuickFunctionOptions[MCM.preselectQuickRanged])
    endIf
            
    MCM.AddEmptyOption()
    MCM.AddHeaderOption("QuickDualCast Options")
    MCM.AddTextOptionST("pro_txt_whatQuickdualcast", "What is QuickDualCast?", "")
    MCM.AddToggleOptionST("pro_tgl_enblQuickdualcast", "Enable QuickDualCast", MCM.bQuickDualCastEnabled)
            
    if MCM.bQuickDualCastEnabled
        MCM.AddTextOption("Enable QuickDualCast for:", "")
        MCM.AddToggleOptionST("pro_tgl_altSpll", "   Alteration spells", MCM.bQuickDualCastAlteration)
        MCM.AddToggleOptionST("pro_tgl_conjSpll", "   Conjuration spells", MCM.bQuickDualCastConjuration)
        MCM.AddToggleOptionST("pro_tgl_destSpll", "   Destruction spells", MCM.bQuickDualCastDestruction)
        MCM.AddToggleOptionST("pro_tgl_illSpll", "   Illusion spells", MCM.bQuickDualCastIllusion)
        MCM.AddToggleOptionST("pro_tgl_restSpll", "   Restoration spells", MCM.bQuickDualCastRestoration)
        MCM.AddToggleOptionST("pro_tgl_reqBothQue", "Only if in both queues", MCM.bQuickDualCastMustBeInBothQueues)
    endIf
endFunction

; ################
; ### Pro Mode ###
; ################

State pro_txt_whatProMode
    event OnBeginState()
        if currentEvent == "Select"
            MCM.ShowMessage("What is iEquip Pro Mode?\n\nPro Mode is a suite of advanced features and settings which allow you to fully unleash the power of iEquip. "+\
                            "Once enabled you will find several previously hidden settings throughout the MCM and will gain access to five new gameplay features, all of which are explained seperately below.", false, "Exit")
        endIf
    endEvent    
endState
        
; ---------------------
; - Preselect Options -
; ---------------------

State pro_txt_whatPreselect
    event OnBeginState()
        if currentEvent == "Select"
            if MCM.ShowMessage("iEquip Preselect Mode\n\nPreselect Mode is toggled by pressing and holding your left or right hotkey. Once enabled it reveals a new preselect slot alongside each main widget slot. "+\
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
            MCM.bPreselectEnabled = !MCM.bPreselectEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bPreselectEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_enblShoutPreselect
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("If you only want Preselect to be available on your left/right hand slots you can choose to disable preselect altogether on the shout slot\nDefault = On")
        elseIf currentEvent == "Select"
            MCM.bShoutPreselectEnabled = !MCM.bShoutPreselectEnabled
            MCM.SetToggleOptionValueST(MCM.bShoutPreselectEnabled)
        elseIf currentEvent == "Default"
            MCM.bShoutPreselectEnabled = true
            MCM.SetToggleOptionValueST(MCM.bShoutPreselectEnabled)
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
            MCM.bPreselectSwapItemsOnEquip = !MCM.bPreselectSwapItemsOnEquip
            MCM.SetToggleOptionValueST(MCM.bPreselectSwapItemsOnEquip)
        elseIf currentEvent == "Default"
            MCM.bPreselectSwapItemsOnEquip = false
            MCM.SetToggleOptionValueST(MCM.bPreselectSwapItemsOnEquip)
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
            MCM.bTogglePreselectOnEquipAll = !MCM.bTogglePreselectOnEquipAll
            MCM.SetToggleOptionValueST(MCM.bTogglePreselectOnEquipAll)
        elseIf currentEvent == "Default"
            MCM.bTogglePreselectOnEquipAll = false
            MCM.SetToggleOptionValueST(MCM.bTogglePreselectOnEquipAll)
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
            MCM.bQuickShieldEnabled = !MCM.bQuickShieldEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickShieldEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_with2hReqp
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled if QuickShield is used while wielding a 2H or ranged weapon iEquip will look for a suitable 1H item or spell and equip that in your right hand at the same time\nDefault = On")
        elseIf currentEvent == "Select"
            MCM.bQuickShield2HSwitchAllowed = !MCM.bQuickShield2HSwitchAllowed
            MCM.SetToggleOptionValueST(MCM.bQuickShield2HSwitchAllowed)
        elseIf currentEvent == "Default"
            MCM.bQuickShield2HSwitchAllowed = true
            MCM.SetToggleOptionValueST(MCM.bQuickShield2HSwitchAllowed)
        endIf
    endEvent
endState

State pro_tgl_prefShieldMag
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled QuickShield will always look for a ward spell first and will also check what's in your right hand and look for a suitable spell to equip as well if needed.\nDefault = Off")
        elseIf currentEvent == "Select"
            MCM.bQuickShieldPreferMagic = !MCM.bQuickShieldPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickShieldPreferMagic = true
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
            fillMenu(MCM.currentQSPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            MCM.currentQSPreferredMagicSchoolChoice = currentVar as int
        
            if MCM.currentQSPreferredMagicSchoolChoice == 0
                MCM.quickShieldPreferredMagicSchool = "Alteration"
            elseIf MCM.currentQSPreferredMagicSchoolChoice == 1
                MCM.quickShieldPreferredMagicSchool = "Conjuration"
            elseIf MCM.currentQSPreferredMagicSchoolChoice == 2
                MCM.quickShieldPreferredMagicSchool = "Destruction"
            elseIf MCM.currentQSPreferredMagicSchoolChoice == 3
                MCM.quickShieldPreferredMagicSchool = "Illusion"
            elseIf MCM.currentQSPreferredMagicSchoolChoice == 4
                MCM.quickShieldPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[MCM.currentQSPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickshieldMode
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Choose the preffered behaviour of QuickShield when used in Preselect Mode\nDefault = Preselect")
        elseIf currentEvent == "Open"
            fillMenu(MCM.preselectQuickShield, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.preselectQuickShield = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[MCM.preselectQuickShield])
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
            MCM.bQuickHealEnabled = !MCM.bQuickHealEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickHealEnabled = false
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
            MCM.bQuickHealPreferMagic = !MCM.bQuickHealPreferMagic
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickHealPreferMagic = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_alwysEqpSpll
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Decide whether you would like the healing spell to be equipped in the hand it is found in, in a specific hand every time or dual casting")
        elseIf currentEvent == "Open"
            fillMenu(MCM.quickHealEquipChoice, QHEquipOptions, 3)
        elseIf currentEvent == "Accept"
            MCM.quickHealEquipChoice = currentVar as int
            MCM.SetMenuOptionValueST(QHEquipOptions[MCM.quickHealEquipChoice])
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
            MCM.bQuickHealUseSecondChoice = !MCM.bQuickHealUseSecondChoice
            MCM.SetToggleOptionValueST(MCM.bQuickHealUseSecondChoice)
        elseIf currentEvent == "Default"
            MCM.bQuickHealUseSecondChoice = true
            MCM.SetToggleOptionValueST(MCM.bQuickHealUseSecondChoice)
        endIf
    endEvent
endState

State pro_tgl_swtchBck
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling this will allow you to switch back to your previously equipped items by triple pressing the consumable key for a second time after you have finished healing. "+\
                            "Only applies if a healing spell has been equipped.  If a potion has been consumed this will do nothing.")
        elseIf currentEvent == "Select"
            MCM.bQuickHealSwitchBackEnabled = !MCM.bQuickHealSwitchBackEnabled
            MCM.SetToggleOptionValueST(MCM.bQuickHealSwitchBackEnabled)
        elseIf currentEvent == "Default"
            MCM.bQuickHealSwitchBackEnabled = false
            MCM.SetToggleOptionValueST(MCM.bQuickHealSwitchBackEnabled)
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
            MCM.bQuickRangedEnabled = !MCM.bQuickRangedEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickRangedEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_men_prefWepTyp
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.quickRangedPreferredWeaponType, QRPreferredWeaponType, 0)
        elseIf currentEvent == "Accept"
            MCM.quickRangedPreferredWeaponType = currentVar as int
            MCM.SetMenuOptionValueST(QRPreferredWeaponType[MCM.quickRangedPreferredWeaponType])
        endIf
    endEvent
endState

State pro_men_swtchOut
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.quickRangedSwitchOutAction, QRSwitchOutOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.quickRangedSwitchOutAction = currentVar as int
            MCM.SetMenuOptionValueST(QRSwitchOutOptions[MCM.quickRangedSwitchOutAction])
        endIf
    endEvent
endState

State pro_men_prefMagSchl
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.currentQRPreferredMagicSchoolChoice, QSPreferredMagicSchool, 2)
        elseIf currentEvent == "Accept"
            MCM.currentQRPreferredMagicSchoolChoice = currentVar as int
        
            if MCM.currentQRPreferredMagicSchoolChoice == 0
                MCM.quickRangedPreferredMagicSchool = "Alteration"
            elseIf MCM.currentQRPreferredMagicSchoolChoice == 1
                MCM.quickRangedPreferredMagicSchool = "Conjuration"
            elseIf MCM.currentQRPreferredMagicSchoolChoice == 2
                MCM.quickRangedPreferredMagicSchool = "Destruction"
            elseIf MCM.currentQRPreferredMagicSchoolChoice == 3
                MCM.quickRangedPreferredMagicSchool = "Illusion"
            elseIf MCM.currentQRPreferredMagicSchoolChoice == 4
                MCM.quickRangedPreferredMagicSchool = "Restoration"
            endIf
            
            MCM.SetMenuOptionValueST(QSPreferredMagicSchool[MCM.currentQRPreferredMagicSchoolChoice])
        endIf
    endEvent
endState

State pro_men_inPreselectQuickrangedMode
    event OnBeginState()
        if currentEvent == "Open"
            fillMenu(MCM.preselectQuickRanged, preselectQuickFunctionOptions, 1)
        elseIf currentEvent == "Accept"
            MCM.preselectQuickRanged = currentVar as int
            MCM.SetMenuOptionValueST(preselectQuickFunctionOptions[MCM.preselectQuickRanged])
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
            MCM.bQuickDualCastEnabled = !MCM.bQuickDualCastEnabled
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastEnabled = false
            MCM.forcePageReset()
        endIf
    endEvent
endState

State pro_tgl_altSpll
    event OnBeginState()
        if currentEvent == "Select"
            MCM.bQuickDualCastAlteration = !MCM.bQuickDualCastAlteration
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastAlteration)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastAlteration = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastAlteration)
        endIf
    endEvent
endState

State pro_tgl_conjSpll
    event OnBeginState()
        if currentEvent == "Select"
            MCM.bQuickDualCastConjuration = !MCM.bQuickDualCastConjuration
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastConjuration)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastConjuration = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastConjuration)
        endIf
    endEvent
endState

State pro_tgl_destSpll
    event OnBeginState()
        if currentEvent == "Select"
            MCM.bQuickDualCastDestruction = !MCM.bQuickDualCastDestruction
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastDestruction)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastDestruction = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastDestruction)
        endIf
    endEvent
endState

State pro_tgl_illSpll
    event OnBeginState()
        if currentEvent == "Select"
            MCM.bQuickDualCastIllusion = !MCM.bQuickDualCastIllusion
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastIllusion)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastIllusion = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastIllusion)
        endIf
    endEvent
endState

State pro_tgl_restSpll
    event OnBeginState()
        if currentEvent == "Select"
            MCM.bQuickDualCastRestoration = !MCM.bQuickDualCastRestoration
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastRestoration)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastRestoration = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastRestoration)
        endIf
    endEvent
endState

State pro_tgl_reqBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("By default QuickDualCast will dual equip spells from your chosen schools in both hands regardless of whether the spell is on one or both queues. "+\
                            "Enabling this restricts QuickDualCast to only spells which are found in both left and right hand queues.\nDefault = Off")
        elseIf currentEvent == "Select"
            MCM.bQuickDualCastMustBeInBothQueues = !MCM.bQuickDualCastMustBeInBothQueues
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastMustBeInBothQueues)
        elseIf currentEvent == "Default"
            MCM.bQuickDualCastMustBeInBothQueues = false
            MCM.SetToggleOptionValueST(MCM.bQuickDualCastMustBeInBothQueues)
        endIf
    endEvent
endState
