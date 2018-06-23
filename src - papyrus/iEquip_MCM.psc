Scriptname iEquip_MCM extends SKI_ConfigBase
;{This script adds a MCM for the iEquip Widget and handles all
;menu cycling logic}
import UI
import Utility

iEquip_WidgetCore Property WC Auto
iEquip_EditMode Property EM Auto
iEquip_KeyHandler Property KH Auto

Float Property iEquip_CurrentVersion Auto

Bool iEquip_RequiresResetOnUpdate = False ;Set to true for version updates which require a full reset

Actor Property PlayerRef  Auto  

Form Property iEquip_Unarmed1H  Auto  
Form Property iEquip_Unarmed2H  Auto  
Shout[] Property shoutListFull  Auto  
Shout[] _DLCShouts
Spell[] _voiceSpells

Sound Property assignShoutSound  Auto  
Sound Property assignSpellSound  Auto  
Sound Property assignWeapSound  Auto

Bool Property ShowMessages = True Auto
Bool Property iEquip_Reset = False Auto

;bool isJCValid = JContainers.APIVersion() == 4 && JContainers.featureVersion() >= 1

GlobalVariable Property iEquip_EditModeSlowTimeStrength Auto

;Main On/Off switch
bool bEnabled = false
;-------------------------------------------------------------------------
;OIDs for each MCM object
;-------------------------------------------------------------------------
;Main On/Off toggle
int enabledOID
;Main widget reset toggle
int resetOID
;Edit Mode OIDs
int slowTimeOID
int enableBringToFrontOID
;variables controlling the widget's fadeout property
int fadeOID
int fadeAlphaOID
int fadeOutDurationOID
int fadeInDurationOID
int fadeWaitOID
;Widget Options
int enableBackgroundsOID
int widgetVisTogglesHotkeyOID
;mcm keymap option id's
int keyOID_SHOUT
int keyOID_POTION
int keyOID_LEFT
int keyOID_RIGHT
int keyOID_EDITMODE
int keyOID_EDITNEXT
int keyOID_EDITPREV
int keyOID_EDITUP
int keyOID_EDITDOWN
int keyOID_EDITLEFT
int keyOID_EDITRIGHT
int keyOID_EDITSCALEUP
int keyOID_EDITSCALEDOWN
int keyOID_EDITROTATE
int keyOID_EDITALPHA
int keyOID_EDITDEPTH
int keyOID_EDITTEXT
int keyOID_EDITRULERS
int keyOID_EDITRESET
int keyOID_EDITLOADPRESET
int keyOID_EDITSAVEPRESET
int keyOID_EDITDISCARD
;int keyOID_ASSIGNLEFT
;int keyOID_ASSIGNRIGHT
;int keyOID_ASSIGNSHOUT
int assignEquippedOID
int mustBeFavoritedOID
int customEMKeys_OID

string MCMSettingsPath = "Data/iEquip/MCM Settings/"
string FileExtMCM = ".IEQS"
;array of object id's for each item queue (MCM menu)
int[] shoutArrayOID
int[] potionArrayOID
int[] leftArrayOID
int[] rightArrayOID

;keys

int assignLeftKey = -1  ;f1
int assignRightKey = -1 ;f2
int assignShoutKey = -1 ;f3 /;

bool Property fadeOut = true Auto
float Property fadeAlpha = 0.0 Auto
float Property fadeOutDuration = 200.0 Auto
float Property fadeInDuration = 15.0 Auto
float Property fadeWait = 700.0 Auto
;Used to control fading out when many buttons are pressed
int waitsQueued

bool ASSIGNMENT_MODE = false

;If this is toggled, only favorited items will show up in the MCM menu
bool mustBeFavorited = false
;Master switch for widget backgrounds. If enabled backgrounds can be shown/hidden/manipulated in Edit Mode, if disabled they are ignored entirely
bool bEnableBackgrounds = false
;MCM switch to disable certain elements of hotkey handling if widget is hidden
bool bWidgetVisTogglesHotkey = true
;MCM switch to enable/disable the Bring To Front feature in Edit Mode.  NB - Turning this on results in longer preset load times and delay entering and leaving Edit Mode
bool bEnableBringToFront = false
;Holds the value for the amount which time will be slowed in Edit Mode
int iSlowValue
;Holds whether custom edit mode hotkey options are available in the MCM hotkeys page
int currentEMKeysChoice = 0
;Array of strings for dropdown menu for choosing Edit Mode hotkeys default/custom
string[] EMKeysChoice
;these variables contain the item and item IDs of the different elements in the queues
string[]     _potionListName
string[]     _shoutListName

;right and left hand lists are separate because left hand can equip shields and torches, which RH can't
string[]     _rightHandListName
string[]     _leftHandListName 

;these contain the objects for the final queues the user decides upon
Form[]       _potionQueue
Form[]       _shoutQueue
Form[]       _rightHandQueue 
Form[]       _leftHandQueue 

;These contain the full list of items the player can choose from in the MCM menu
Form[]       _potionList
Form[]       _shoutsKnown
Form[]       _rightHandList 
Form[]       _leftHandList 

;contain indexes of items in their lists
int[]       _potionIndexMap
int[]       _shoutIndexMap
int[]       _rightHandIndexMap
int[]       _leftHandIndexMap

;array of indices for each item dropdown menu
int[]       shoutIndex
int[]       potionIndex
int[]       leftIndex
int[]       rightIndex
bool[] Property itemDataUpToDate Auto

int Property MAX_QUEUE_SIZE = 7 Auto

;_currQIndices contains indices of currently active slots
;0 - LH
;1 - RH
;2 - Shout
;3 - Potion
int[] Property _currQIndices Auto

;If players have dragonborn and/or dawnguard, load their dragonshouts
Function CheckForDLC()
    debug.trace("iEquip MCM CheckForDLC called")
    _DLCShouts = new Shout[8]
    ;GetFormFromFile must be loaded into a form object before casting to a shout for some reason
    Form[] shoutForms = new Form[8] 
    int ndx = 0;
    ;check for Dawnguard

    if(Game.GetFormFromFile(0x00000800, "Dawnguard.esm"))
        ;Soul Tear
        shoutForms[ndx] = Game.GetFormFromFile(0x00007CB6, "Dawnguard.esm") As Shout
        ;Summon Durnehviir
        shoutForms[ndx+1] = Game.GetFormFromFile(0x000030D2, "Dawnguard.esm") As Shout
        ;Drain Vitality
        shoutForms[ndx+2] = Game.GetFormFromFile(0x00008A62, "Dawnguard.esm") As Shout
        ndx += 3 
    endif

    ;check for Dragonborn
    if(Game.GetFormFromFile(0x00018DDD, "Dragonborn.esm"))
        ;Battle Fury
        shoutForms[ndx] = Game.GetFormFromFile(0x0002AD09, "Dragonborn.esm") As Shout
        ;Bend Will
        shoutForms[ndx+1] = Game.GetFormFromFile(0x000179D8, "Dragonborn.esm") As Shout
        ;Cyclone
        shoutForms[ndx+2] = Game.GetFormFromFile(0x000200C0, "Dragonborn.esm") As Shout
        ;Dragon Aspect
        shoutForms[ndx+3] = Game.GetFormFromFile(0x0001DF92, "Dragonborn.esm") As Shout
    endif
    int i = 0
    while shoutForms[i]
        _DLCShouts[i] = shoutForms[i] as Shout
        i += 1
    endWhile
endFunction
;-------------------------------------------------------------------------
;Functions for populating the queues with items in the
;inventory 
;-------------------------------------------------------------------------
;This will only populate the potions lists
Function populatePotionsList(ObjectReference akContainer)

    debug.trace("iEquip MCM populatePotionsList called")
    _potionListName[0] = "<Empty>"
    _potionList[0] = None
    Int itemCount = 0
    Int nextPotionIndex = 0
    Int ndx = 0
    int totalItems = akContainer.GetNumItems()
    while ndx < totalItems
        Form kForm = akContainer.GetNthForm(ndx)
        ;if it must be favorited, make sure it is. else proceed 
        if(!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(kForm)))
            itemCount = PlayerRef.getItemCount(kForm)
            If kForm.GetType() == 46 ; is a potion
                _potionListName[nextPotionIndex] = kForm.getName() + "  (" + itemCount + ")"
                _potionList[nextPotionIndex] = kForm
                nextPotionIndex += 1
            endIf
        endIf
        ndx +=1
    endWhile
    ;empty the rest of the list
    if ndx < 128
        while ndx < 128
            _potionList[ndx] = None
            _potionListName[ndx] = "" 
            ndx += 1
        endWhile
    endIf        
endFunction

;populates potion and weapon queues for the dropdown options in the MCM
Function populateLists(ObjectReference akContainer)
    
    debug.trace("iEquip MCM populateLists called")
    EmptyLists()
    _potionListName[0] = "<Empty>"
    _rightHandListName[0] = "<Empty>"
    _leftHandListName[0] = "<Empty>"
    _potionList[0] = None
    _rightHandList[0] = None
    _leftHandList[0] = None 
    _rightHandListName[1] = iEquip_Unarmed1H.GetName() 
    _rightHandList[1] = iEquip_Unarmed1H
    _leftHandListName[1] = iEquip_Unarmed1H.GetName() 
    _leftHandList[1] = iEquip_Unarmed1H
    _rightHandListName[2] = iEquip_Unarmed2H.GetName() 
    _rightHandList[2] = iEquip_Unarmed2H
    _leftHandListName[2] = iEquip_Unarmed2H.GetName()
    _leftHandList[2] = iEquip_Unarmed2H

    Int ndx = 0
    Int nextPotionIndex = 1 
    Int nextRHIndex = 3 
    Int nextLHIndex = 3 
    Int itemCount = 0
    String itemStr 
    int totalItems = akContainer.GetNumItems() 
    ;SetTextOptionValue(refreshOID, "Updating Items")
    ;iterate through all items in player's inventory
    While ndx < totalItems
        Form kForm = akContainer.GetNthForm(ndx)
        if(kForm != iEquip_Unarmed1H && kForm != iEquip_Unarmed2H)
            ;if it must be favorited, make sure it is. else proceed 
            if(!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(kForm)))
                itemCount = PlayerRef.getItemCount(kForm)
                itemStr = ""
                if(itemCount > 1 && kForm.GetType() == 41)
                    itemStr = " [" + itemCount + "]"   
                endIf
                If kForm.GetType() == 46 ; is a potion
                    _potionListName[nextPotionIndex] = kForm.getName() + "  (" + itemCount + ")"
                    _potionList[nextPotionIndex] = kForm
                    nextPotionIndex += 1
                elseIf kForm.GetType() == 41 ; is a weapon
                    ;only add 2 handers and ranged to RH slot
                    if((kForm as weapon).GetWeapontype() <= 4)
                        ;adding to LH queue
                        _leftHandListName[nextLHIndex] = kForm.getName() + itemStr
                        _leftHandList[nextLHIndex] = kForm
                        nextLHIndex += 1
                    endIf
                    ;1h weapons go in both
                    _rightHandListName[nextRHIndex] = kForm.getName() + itemStr
                    _rightHandList[nextRHIndex] = kForm
                    nextRHIndex += 1
                ;add shields to the lefthand queue
                elseIf (kForm.GetType() == 26 && (kForm as Armor).GetSlotMask() == 512)
                    _leftHandListName[nextLHIndex] = kForm.getName() + itemStr
                    _leftHandList[nextLHIndex] = kForm
                    nextLHIndex += 1
                ;Light (Torch)
                elseIf kForm.GetType() == 31
                    itemCount = PlayerRef.getItemCount(kForm)
                    _leftHandListName[nextLHIndex] = kForm.getName() + "  (" + itemCount + ")"
                    _leftHandList[nextLHIndex] = kForm
                    nextLHIndex += 1    
                endIf
            endIf
        endIf
        ndx += 1
    endWhile

    EquipSlot voiceSlot = Game.GetFormFromFile(0x00025bee, "Skyrim.esm") as EquipSlot
    ndx = 0
    ;reset voice spells
    int voiceNdx = 0
    ;SetTextOptionValue(refreshOID, "Updating Spells")
    int i = 0
    while i < 128
        _voiceSpells[i] = None
        i+=1
    endWhile
    ;Player spells are located in different places, so we have to accumulate them first
    Spell[] allSpells = GetAllSpells() 
    int spellCount = PlayerRef.GetActorBase().GetSpellCount() + PlayerRef.GetRace().GetSpellCount() + PlayerRef.GetSpellCount()
    ;Add spells to our lists
    While ndx < spellCount
        Spell currSpell = allSpells[ndx] 
        ;make sure it is favorited, remove spells that can't be equipped in the hands
        if(isSpellValid(currSpell) && (!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(currSpell))) )
        ;Debug.MessageBox(currSpell.getName() + "   " + currSpell + "   " + currSpell.GetFormID() + "   ")
            if currSpell.GetEquipType() == voiceSlot 
                _voiceSpells[voiceNdx] = currSpell
                voiceNdx += 1
            else
                ;adding to RH queue
                _rightHandListName[nextRHIndex] = currSpell.getName()
                _rightHandList[nextRHIndex] = currSpell 
                nextRHIndex += 1
                ;adding to LH queue
                _leftHandListName[nextLHIndex] = currSpell.getName()
                _leftHandList[nextLHIndex] = currSpell 
                nextLHIndex += 1
            endIf
            int keywordNdx = 0
        endIf
        ndx += 1
    endWhile
    ;SetTextOptionValue(refreshOID, "Updating Shouts")
    populateShoutList()
    debug.trace("iEquip MCM populateLists finished")
endFunction

Spell[] Function GetAllSpells()
    debug.trace("iEquip MCM GetAllSpells called")
    Spell[] allSpells = new Spell[128]
    Spell currSpell
    int ndx = 0
    int spellNdx = 0
    ;Actor base spells
    while ndx < PlayerRef.GetActorBase().GetSpellCount()
        allSpells[spellNdx] = PlayerRef.GetActorBase().GetNthSpell(ndx)
        ndx+=1
        spellNdx+=1
    endWhile
    ndx = 0
    ;Race base spells
    while ndx < PlayerRef.GetRace().GetSpellCount()
        allSpells[spellNdx] = PlayerRef.GetRace().GetNthSpell(ndx)
        ndx+=1
        spellNdx+=1
    endWhile
    ndx = 0
    ;Added spells
    while ndx < PlayerRef.GetSpellCount()
        allSpells[spellNdx] = PlayerRef.GetNthSpell(ndx)
        ndx+=1
        spellNdx+=1
    endWhile
    return allSpells
endFunction
 
;armor set bonuses and passive spellsare returned by getNthSpell.  We do not want these to show up in our menu so we have
;to manually remove them
bool Function isSpellValid(Spell s)
    debug.trace("iEquip MCM isSpellValid called")
    ;----------------------------------------------------------------------
    ;Vanilla
    ;----------------------------------------------------------------------
    ;Shrouded Armor
    if s == Game.GetFormFromFile(0x0001711D, "Skyrim.esm")
        return false
    endIf
    ;Nightingale Armor
    if s == Game.GetFormFromFile(0x0001711F, "Skyrim.esm")
        return false
    endIf
    ;Combat Heal Rate
    if s == Game.GetFormFromFile(0x001031D3, "Skyrim.esm")
        return false
    endIf
    ;Imperial Luck
    if s == Game.GetFormFromFile(0x000EB7EB, "Skyrim.esm")
        return false
    endIf
    ;Argonian Waterbreathing
    if s == Game.GetFormFromFile(0x000AA01B, "Skyrim.esm")
        return false
    endIf
    ;Argonian Resist Disease
    if s == Game.GetFormFromFile(0x00104ACF, "Skyrim.esm")
        return false
    endIf
    ;Wood Elf Resist Disease and Poison
    if s == Game.GetFormFromFile(0x000AA025, "Skyrim.esm")
        return false
    endIf
    ;Breton Resist Magic
    if s == Game.GetFormFromFile(0x000AA01F, "Skyrim.esm")
        return false
    endIf
    ;Dark Elf Resist Fire 
    if s == Game.GetFormFromFile(0x000AA021, "Skyrim.esm")
        return false
    endIf
    ;Khajiit Claws
    if s == Game.GetFormFromFile(0x000AA01E, "Skyrim.esm")
        return false
    endIf
    ;Nord Resist Frost
    if s == Game.GetFormFromFile(0x000AA020, "Skyrim.esm")
        return false
    endIf
    ;Redguard Resist Poison
    if s == Game.GetFormFromFile(0x000AA023, "Skyrim.esm")
        return false
    endIf
    ;----------------------------------------------------------------------
    ;Dawnguard
    ;----------------------------------------------------------------------
    ;Crossbow Bonus
    if s == Game.GetFormFromFile(0x00012CCC, "Dawnguard.esm")
        return false
    endIf

    ;----------------------------------------------------------------------
    ;DragonBorn
    ;----------------------------------------------------------------------
    ;Ahzidal's Genius
    if s == Game.GetFormFromFile(0x00027332, "Dragonborn.esm")
        return false
    endIf
    ;Deathbrand Instinct
    if s == Game.GetFormFromFile(0x0003B563, "Dragonborn.esm")
        return false
    endIf
   return true
endFunction

;populates spell queue for the dropdown options in the MCM
Function populateShoutList()
    debug.trace("iEquip MCM populateShoutList called")
    _shoutListName[0] = "<Empty>"
    _shoutsKnown[0] = None

    Int ndx = 0
    Int nextShoutIndex = 1 
    ;Unfortunately, there is no getShouts() method like there is for spells.  So to check if the player
    ;knows a shout, we have to check a hardcoded list of each shout in the game and see if the player knows it
    While ndx < shoutListFull.Length
        Shout currShout = shoutListFull[ndx]
        if (currShout)
            if(PlayerRef.HasSpell(currShout) && (!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(currShout))) )
                _shoutListName[nextShoutIndex] = currShout.getName()
                _shoutsKnown[nextShoutIndex] = currShout
                nextShoutIndex += 1
            endIf
        endIf
        ndx += 1
    endWhile
    
    ;Now we check for shouts from Dragonborn and Dawnguard.  They must be checked seperately, as it is possible
    ;Dragonborn and Dawnguard aren't installed
    CheckForDLC()
    ndx = 0
    While ndx < _DLCShouts.Length
        Shout currShout = _DLCShouts[ndx]
        if(currShout)
            if(PlayerRef.HasSpell(currShout) && (!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(currShout))) )
                _shoutListName[nextShoutIndex] = currShout.getName()
                _shoutsKnown[nextShoutIndex] = currShout
                nextShoutIndex += 1
            endIf
        endIf
        ndx += 1
    endWhile

    ndx = 0
    While ndx < _voiceSpells.Length 
        Spell currSpell = _voiceSpells[ndx]
        if(currSpell)
            if(PlayerRef.HasSpell(currSpell) && (!mustBeFavorited || (mustBeFavorited && Game.isObjectFavorited(currSpell))) )
                _shoutListName[nextShoutIndex] = currSpell.getName()
                _shoutsKnown[nextShoutIndex] = currSpell
                nextShoutIndex += 1
            endIf
        endIf
        ndx += 1
    endWhile 
    debug.trace("iEquip MCM populateShoutList finished")
endFunction

;-----------------------------------------------------------------------------------------------------------------------
;QUEUE FUNCTIONALITY CODE
;-----------------------------------------------------------------------------------------------------------------------
Int[] Function GetItemIconArgs(int queueID)
    debug.trace("iEquip MCM GetItemIconArgs called")
    Form[] Q
    if(queueID == 1)
        Q = _rightHandQueue
    elseif(queueID == 2)
        Q = _shoutQueue
    elseif(queueID == 3)
        Q = _potionQueue
    else
        Q = _leftHandQueue
    endIf
    Form item = Q[_currQIndices[queueID]]
    int[] args = new Int[4]
    args[0] = queueID 
    args[1] = _currQIndices[queueID] 
    if(item)
        args[2] = item.GetType() 
    else
        args[2] = 0
    endIf
    args[3] = -1 
    ;if it is a weapon, we want its weapon type
    if(args[2] == 41)
        Weapon W = item as Weapon
        int weaponType = W.GetWeaponType()
            ;2H axes and maces have the same ID for some reason, so we have to differentiate them
            if(weaponType == 7)
                weaponType = 8
            elseif(weaponType == 8)
                weaponType = 10
            endIf
            if(weaponType == 6)
                if(W.IsWarhammer())
                weaponType = 7
                endIf
            endIf
        args[3] = weaponType
    ;Is a spell
    elseIf(args[2] == 22) 
        Spell S = item as Spell
        int sIndex = S.GetCostliestEffectIndex()
        MagicEffect sEffect = S.GetNthEffectMagicEffect(sIndex)
        String school = sEffect.GetAssociatedSkill()
        if(school == "Alteration")
            args[3] = 18 
        elseIf(school == "Conjuration")
            args[3] = 19
        elseIf(school == "Destruction")
            args[3] = 20 
        elseIf(school == "Illusion")
            args[3] = 21 
        elseIf(school == "Restoration")
            args[3] = 22 
        endIf
    ;Is a potion
    elseIf(args[2] == 46)
        Potion P = item as Potion
        if(P.IsPoison())
            args[3] = 15
            return args
        elseIf(P.IsFood())
            args[3] = 13
            return args 
        endIf
        int pIndex = P.GetCostliestEffectIndex()
        MagicEffect pEffect = P.GetNthEffectMagicEffect(pIndex)
        String pStr = pEffect.GetName() 
        if(pStr == "Restore Health" || pStr == "Regenerate Health")
            args[3] = 0
        elseif(pStr == "Restore Magicka" || pStr == "Regenerate Magicka")
            args[3] = 3 
        elseif(pStr == "Restore Stamina" || pStr == "Regenerate Stamina")
            args[3] = 6 
        elseif(pStr == "Resist Fire")
            args[3] = 9 
        elseif(pStr == "Resist Shock")
            args[3] = 10 
        elseif(pStr == "Resist Frost")
            args[3] = 11 
        endIf
    endIf       
    return args
endFunction


function cyclePotion()
    debug.trace("iEquip MCM cyclePotion called")
    advanceQueue(3, 0)
    int currIndex = _currQIndices[3]
    Form item = _potionQueue[currIndex]
    if(item)
        WC.setPotionCount(PlayerRef.GetItemCount(item))
    endIf
endFunction

;uses the equipped item / potion in the bottom slot
function useEquippedItem()
    debug.trace("iEquip MCM useEquippedItem called")
    int currIndex = _currQIndices[3]    
    Form item = _potionQueue[currIndex]
    if( item != None)
        if(ValidateItem(item))
            PlayerRef.EquipItem(item, false, false)
        else
            removeInvalidItem(3, currIndex)
            Debug.Notification("You no longer have " + item.getName())
        endIf
    endIf
    WC.setPotionCount(PlayerRef.GetItemCount(item))
endFunction

;cycle the upper slot (shouts, powers)
function cyclePower()
    debug.trace("iEquip MCM cyclePower called")
    ;if no power is equipped OR a power is equipped that is not the same as the current power in the Queue, equip current queue power
    ;else, go to next power in the queue
    int currIndex = _currQIndices[2]
    shout currShout = PlayerRef.GetEquippedShout()
    int type = 0
    ;If the currently equipped power is not a shout but a spell (power), there isn't a way to tell it is equipped,
    ;so we have to advance the queue no matter what
    if(currShout != _shoutQueue[currIndex] && _shoutQueue[currIndex] != None && _shoutQueue[currIndex].GetType() != 22) 
        type = _shoutQueue[currIndex].GetType()
        ;If it is a spell (power)
        if( type == 22)
            PlayerRef.EquipSpell(_shoutQueue[currIndex] as Spell, 2 )
        elseIf(type == 119)
            PlayerRef.EquipShout(_shoutQueue[currIndex] as Shout )
        endIf

    else
        int newIndex = advanceQueue(2, 0);
        ;PlayerRef.EquipShout(_shoutQueue[newIndex] as shout)
        if(_shoutQueue[newIndex])
            type = _shoutQueue[newIndex].GetType()
        endIf
        if( type == 22)
            PlayerRef.EquipSpell(_shoutQueue[newIndex] as Spell, 2 )
        elseIf(type == 119)
            PlayerRef.EquipShout(_shoutQueue[newIndex] as Shout )
        endIf
    endif
endFunction

;Unequips item in hand
function UnequipHand(int a_hand)
    debug.trace("iEquip MCM UnequipHand called")
    int a_handEx = 1
    if (a_hand == 0)
        a_handEx = 2 ; unequipspell and *ItemEx need different hand args
    endIf

    Form handItem = PlayerRef.GetEquippedObject(a_hand)
    if (handItem)
        int itemType = handItem.GetType()
        if (itemType == 22)
            PlayerRef.UnequipSpell(handItem as Spell, a_hand)
        else
            PlayerRef.UnequipItemEx(handItem, a_handEx)
        endIf
    endIf
endFunction

bool function cycleHand(int slotID)
    debug.trace("iEquip MCM cycleHand called")
    Form[] queue
    int equipSlotId
    int currIndex = _currQIndices[slotID]

    ;for some reason, when using Unequip, 0 corresponds to the left hand, but when using equip, 2 corresponds to the left hand,
    ;so we have to change the value for the left hand here  
    if(slotID == 0)
        queue = _leftHandQueue
        equipSlotId = 2 
    elseif (slotID == 1)
        queue = _rightHandQueue
        equipSlotId = 1
    endif

    ;First, we check to see if the currently equipped item is the same as the current item in the queue.  
    ;If it is, advance the queue. Else, equip the current item in the queue 
    Form currEquippedItem = PlayerRef.GetEquippedObject(slotID)
    Form currQItem = queue[currIndex]
    if(currEquippedItem != currQItem && currQItem != None)
        if(ValidateItem(currQItem))
            UnequipHand(slotID)
            if(currQItem.getType() == 22)                   
                PlayerRef.EquipSpell(currQItem as Spell, slotID)
            else
                PlayerRef.EquipItemEx(currQItem, equipSlotId, false, false)
            endIf
            return true
        else
            removeInvalidItem(slotID, currIndex)
        endIf
        ;if item fails validation or curr equipped item check, move to next item in queue
    endIf   
        
    int newIndex = advanceQueue(slotID, 0)
    Form nextQItem = queue[newIndex]
    if(ValidateItem(nextQItem))
        UnequipHand(slotID)
        if(nextQItem.getType() == 22)
            PlayerRef.EquipSpell(nextQItem as Spell, slotID)
        else
            PlayerRef.EquipItemEx(nextQItem, equipSlotId, false, false)
        endif
        return true
    else
        removeInvalidItem(slotID, newIndex)
    endIf
    return false
endFunction

;moves the queue to the next slot
int function advanceQueue_ASSIGNMENT_MODE(int queueID)
    debug.trace("iEquip MCM advanceQueue_ASSIGNMENT_MODE called")
    int currIndex = _currQIndices[queueID]
    int newIndex
    if (currIndex == MAX_QUEUE_SIZE - 1)
        newIndex = 0    
    else
        newIndex = currIndex + 1    
    endIf
    _currQIndices[queueID] = newIndex
    return newIndex
endFunction

int function advanceQueue(int queueID, int depth)
    debug.trace("iEquip MCM advanceQueue called")
    int newIndex = advanceQueue_ASSIGNMENT_MODE(queueID)
    ;Recursively advance until there is an item in the queue or the entire length of the queue has been traversed
    if(!ValidateSlot(queueID) && depth < MAX_QUEUE_SIZE)
        newIndex = advanceQueue(queueID, depth + 1)
    endIf
    return newIndex
endFunction

;makes sure whatever is in the current slot is equippable.
bool function ValidateSlot(int queueID)
    debug.trace("iEquip MCM ValidateSlot called")
    int currIndex = _currQIndices[queueID]
    if queueID == 0
        if _leftHandQueue[currIndex] == None || !ValidateItem(_leftHandQueue[currIndex])
            return false
        endIf
    elseif queueID == 1 
        if _rightHandQueue[currIndex] == None || !ValidateItem(_rightHandQueue[currIndex])
            return false
        endIf
    elseif queueId == 2
        if _shoutQueue[currIndex] == None || !ValidateItem(_shoutQueue[currIndex])
            return false
        endIf
    elseif queueId == 3 
        if _potionQueue[currIndex] == None || !ValidateItem(_potionQueue[currIndex])
            return false    
        endIf
    endIf
    return true
endFunction

;make sure the player has the item or spell and it is favorited
bool function ValidateItem(Form a_item)
    debug.trace("iEquip MCM ValidateItem called")
    if (a_item == None)
        return false
    endif
    int a_itemType = a_item.GetType()
    int itemCount 

    ; This is a Spell or Shout and can't be counted like an item
    if (a_itemType == 22 || a_itemType == 119)
        return PlayerRef.HasSpell(a_item)
    ; This is an inventory item
    else 
        itemCount = PlayerRef.GetItemCount(a_item)
        if (itemCount < 1)
            Debug.Notification("You no longer have " + a_item.getName())
            return false
        endIf
    endIf
    ;This item is already equipped, possibly in the other hand, and there is only 1 of it
    if ((a_item == PlayerRef.GetEquippedObject(0) || a_item == PlayerRef.GetEquippedObject(1)) && itemCount < 2)
        return false
    endif
    return true
endFunction

;if an item fails validation, remove it from the queue
function removeInvalidItem(int queueID, int index)
    debug.trace("iEquip MCM removeInvalidItem called")
    if(queueID == 0)
        _leftHandQueue[index] = None
    elseif(queueID == 1)
        _rightHandQueue[index] = None
    elseif(queueID == 2)
        _shoutQueue[index] = None
    elseif(queueID == 3)
        _potionQueue[index] = None
    endIf
endFunction

;Getters for the widget script
String function getCurrQItemName(int queueID)
    debug.trace("iEquip MCM getCurrQItemName called")
    int currIndex = _currQIndices[queueID]

    if(queueID == 0)
        if(_leftHandQueue[currIndex])
            return  _leftHandQueue[currIndex].getName()
        endIf
    elseif(queueID == 1)
        if(_rightHandQueue[currIndex])
            return _rightHandQueue[currIndex].getName()
        endIf
    elseif(queueID == 2)
        if(_shoutQueue[currIndex])
            return _shoutQueue[currIndex].getName()
        endIf
    elseif(queueID == 3)
        if(_potionQueue[currIndex])
            return _potionQueue[currIndex].getName()
        endIf
    endIf
    return ""
endFunction 

function AssignCurrEquippedItem(Int aiSlot)
    debug.trace("iEquip MCM AssignCurrEquippedItem called")
    Form obj = PlayerRef.GetEquippedObject(aiSlot)
    int ndx = _currQIndices[aiSlot]
    if(aiSlot == 0)
        _leftHandQueue[ndx] = obj 
    elseif(aiSlot == 1)
        _rightHandQueue[ndx] = obj 
    elseif(aiSlot == 2)
        _shoutQueue[ndx] = obj 
    endIf
endFunction

;MCM events 
int function GetVersion()
    debug.trace("iEquip MCM GetVersion called")
    return 1
endFunction

event OnVersionUpdate(int a_version)
    debug.trace("iEquip MCM OnVersionUpdate called")
    if (a_version > CurrentVersion && CurrentVersion > 0)
        Debug.Notification("Updating iEquip to Version " + a_version as string)
        if iEquip_RequiresResetOnUpdate ;For major version updates - fully resets mod, use only if absolutely neccessary
            OnConfigInit()
            int ndx = 0
            ItemDataUpToDate = new bool[28]
            while ndx < 28
                ItemDataUpToDate[ndx] = false
                ndx += 1
            endWhile
            EM.ResetDefaults()
        else
            ;SkyUI Example Code
            ;/; a_version is the new version, CurrentVersion is the old version
            if (a_version >= 2 && CurrentVersion < 2)
                Debug.Trace(self + ": Updating script to version 2")
                Pages = new string[4]
                Pages[0] = "Page 1"
                Pages[1] = "Page 2"
                Pages[2] = "Page 3"
                Pages[3] = "Page 4"
            endIf

            ; a_version is the new version, CurrentVersion is the old version
            if (a_version >= 3 && CurrentVersion < 3)
                Debug.Trace(self + ": Updating script to version 3")
                myVar = Utility.RandomInt(0,100)
                myArray = new string[128]
                ; ...
            endIf/;
            EM.ApplyMCMSettings()
        endIf
    endIf
    debug.trace("iEquip MCM OnVersionUpdate finished")
endEvent 

function EmptyLists()
    debug.trace("iEquip MCM EmptyLists called")
    int ndx = 0
    while ndx < 128
        _potionListName[ndx] = ""
        _shoutListName[ndx] = ""
        _rightHandListName[ndx] = ""
        _leftHandListName[ndx] = ""
        _potionList[ndx] = None
        _shoutsKnown[ndx] = None
        _rightHandList[ndx] = None
        _leftHandList[ndx] = None
        ndx +=1
    endWhile
    debug.trace("iEquip MCM EmptyLists finished")
endFunction
;initialize variables and arrays when the MCM is started up
Event OnConfigInit()
    debug.trace("iEquip MCM OnConfigInit called")
    ;these are the names of the pages that appear in the MCM
    Pages = new String[6]
    Pages[0] = "General"
    Pages[1] = "Hotkeys"
    Pages[2] = "Shout Group"
    Pages[3] = "Item Group"
    Pages[4] = "Left Hand Group"
    Pages[5] = "Right Hand Group"
    waitsQueued = 0
    iEquip_Reset = false
    if(!playerRef.getItemCount(iEquip_Unarmed1H))
        PlayerRef.AddItem(iEquip_Unarmed1H)
    endIf
    if(!playerRef.getItemCount(iEquip_Unarmed2H))
        PlayerRef.AddItem(iEquip_Unarmed2H)
    endIf
    _currQIndices = new int[4]
    int i = 0
    while i < 4
        _currQIndices[i] = 0
        i +=1
    endWhile
    
    EMKeysChoice = new String[2]
    EMKeysChoice[0] = "Default"
    EMKeysChoice[1] = "Custom"
    
    _voiceSpells = new Spell[128]
    _potionListName = new string[128]
    _shoutListName = new string[128]
    _rightHandListName = new string[128]
    _leftHandListName = new string[128]

    _potionList = new Form[128]
    _shoutsKnown = new Form[128]
    _rightHandList = new Form[128]
    _leftHandList = new Form[128]

    _potionQueue = new Form[7]
    _shoutQueue = new Form[7]
    _rightHandQueue = new Form[7]
    _leftHandQueue = new Form[7]
 
    ;initialize inventory lists for the combo boxes
    populateLists(PlayerRef)
    ;initialize the indices of each of the 7 slots for each equipslot
    shoutIndex = new Int[7]
    potionIndex = new Int[7]
    leftIndex = new Int[7]
    rightIndex = new Int[7]

    ;initialize Object ID's for the drop down menus of the 7 slots for each queue 
    shoutArrayOID = new Int[7]
    potionArrayOID = new Int[7]
    leftArrayOID = new Int[7]
    rightArrayOID = new Int[7]
    debug.trace("iEquip MCM OnConfigInit finished")
EndEvent

event OnConfigOpen()
    {Called when this config menu is opened}
    populateLists(PlayerRef)
endEvent

;/From Violens VL_ConfigMenu.psc - saving this here to add to Info page
If(VL_JConInstalled.GetValueInt() == 1)
            
    AddTextOption("JContainers", "$Installed", OPTION_FLAG_DISABLED)
    AddTextOption("Version ", JContainers.APIVersion() + "." + JContainers.featureVersion() + "." + "x", OPTION_FLAG_DISABLED)
    if(VL_isJCValid.GetValueInt() == 1)
        AddTextOption("Valid ","$Yes", OPTION_FLAG_DISABLED)
    else
        AddTextOption("Valid ","$No", OPTION_FLAG_DISABLED)
    endIf
                
Else
    AddTextOption("JContainers", "$Not Installed", OPTION_FLAG_DISABLED)
    AddTextOption("Version ","-", OPTION_FLAG_DISABLED)
    AddTextOption("Valid ","-", OPTION_FLAG_DISABLED)
endif/;

;called every time a page is initialized
event OnPageReset(string page)
    debug.trace("iEquip MCM OnPageReset called")
    SetCursorFillMode(TOP_TO_BOTTOM)
    String nameStr = ""
    if (page == "")
        LoadCustomContent("iEquip/iEquip_splash.dds")
        return
    else
        UnloadCustomContent()
    endIf
    ;first page
    If (page == "General")
        enabledOID = AddToggleOption("iEquip On/Off", bEnabled)
        AddEmptyOption()
        AddHeaderOption("Edit Mode settings")
        slowTimeOID = AddSliderOption("Slow Time effect strength ", iEquip_EditModeSlowTimeStrength.GetValueint())
        enableBringToFrontOID = AddToggleOption("Enable Bring To Front", bEnableBringToFront)
        resetOID = AddTextOption("Reset default iEquip layout", "")
        AddEmptyOption()
        AddHeaderOption("General settings")
        mustBeFavoritedOID = AddToggleOption("Only Favorite Items", mustBeFavorited)
        enableBackgroundsOID = AddToggleOption("Enable widget backgrounds", bEnableBackgrounds)
        widgetVisTogglesHotkeyOID = AddToggleOption("Disable hotkey when widget hidden", bWidgetVisTogglesHotkey)
        ;move cursor to top right position
        SetCursorPosition(1)
        ;widget fade variable sliders
        int flags = 0
        ;grey out variables if fadeout isn't checked
        if(!fadeOut)
            flags = OPTION_FLAG_DISABLED
        endIf
        AddHeaderOption("Fade Out")
        AddEmptyOption()
        fadeOID = AddToggleOption("Fade Out On/Off", fadeOut)
        fadeAlphaOID = AddSliderOption("Fade Out Alpha", fadeAlpha, "{0}%", flags)
        fadeOutDurationOID = AddSliderOption("Fade Out Duration", fadeOutDuration, "{0}", flags)
        fadeInDurationOID = AddSliderOption("Fade In Duration", fadeInDuration, "{0}", flags)
        fadeWaitOID = AddSliderOption("Fade Wait Duration", fadeWait, "{0}", flags)
    elseIf (page == pages[1])
        AddHeaderOption(pages[1])
        AddEmptyOption()
        keyOID_LEFT = AddKeyMapOption("Left Hand Hotkey", KH.iEquip_leftKey, OPTION_FLAG_WITH_UNMAP)
        keyOID_RIGHT = AddKeyMapOption("Right Hand Hotkey", KH.iEquip_rightKey, OPTION_FLAG_WITH_UNMAP)
        keyOID_SHOUT = AddKeyMapOption("Shout Widget Hotkey", KH.iEquip_shoutKey, OPTION_FLAG_WITH_UNMAP)
        keyOID_POTION = AddKeyMapOption("Potion Widget Hotkey", KH.iEquip_potionKey, OPTION_FLAG_WITH_UNMAP)
        SetCursorPosition(1)
        AddHeaderOption("Edit Mode Keys")
        AddEmptyOption()
        keyOID_EDITMODE = AddKeyMapOption("Toggle Edit Mode Hotkey", KH.iEquip_editmodeKey, OPTION_FLAG_WITH_UNMAP)
        customEMKeys_OID = AddMenuOption("Choose your hotkeys", EMKeysChoice[currentEMKeysChoice])
        if(currentEMKeysChoice == 1)
            AddEmptyOption()
            keyOID_EDITNEXT = AddKeyMapOption("Next element", KH.iEquip_EditNextKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITPREV = AddKeyMapOption("Previous element", KH.iEquip_EditPrevKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITUP = AddKeyMapOption("Move up", KH.iEquip_EditUpKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITDOWN = AddKeyMapOption("Move down", KH.iEquip_EditDownKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITLEFT = AddKeyMapOption("Move left", KH.iEquip_EditLeftKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITRIGHT = AddKeyMapOption("Move right", KH.iEquip_EditRightKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITSCALEUP = AddKeyMapOption("Scale up", KH.iEquip_EditScaleUpKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITSCALEDOWN = AddKeyMapOption("Scale down", KH.iEquip_EditScaleDownKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITROTATE = AddKeyMapOption("Rotate", KH.iEquip_EditRotateKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITALPHA = AddKeyMapOption("Adjust transparency", KH.iEquip_EditAlphaKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITDEPTH = AddKeyMapOption("Bring to front", KH.iEquip_EditDepthKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITTEXT = AddKeyMapOption("Set text alignment and colour", KH.iEquip_EditTextKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITRULERS = AddKeyMapOption("Toggle rulers", KH.iEquip_EditRulersKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITRESET = AddKeyMapOption("Reset selected element", KH.iEquip_EditResetKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITLOADPRESET = AddKeyMapOption("Load preset", KH.iEquip_EditLoadPresetKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITSAVEPRESET = AddKeyMapOption("Save preset", KH.iEquip_EditSavePresetKey, OPTION_FLAG_WITH_UNMAP)
            keyOID_EDITDISCARD = AddKeyMapOption("Discard changes", KH.iEquip_EditDiscardKey, OPTION_FLAG_WITH_UNMAP)
        EndIf
        ;/flags = OPTION_FLAG_WITH_UNMAP
        if(!ASSIGNMENT_MODE)
            flags = OPTION_FLAG_DISABLED
        endIf
        AddHeaderOption("Assign Equipped Mode")
        assignEquippedOID = AddToggleOption("Assignment Mode On/Off", ASSIGNMENT_MODE)
        keyOID_ASSIGNLEFT = AddKeyMapOption("Assign Left Hand Object", assignLeftKey, flags)
        keyOID_ASSIGNRIGHT = AddKeyMapOption("Assign Right Hand Object", assignRightKey, flags)
        keyOID_ASSIGNSHOUT = AddKeyMapOption("Assign Shout Object", assignShoutKey, flags)/;
    ;Shout page
    elseIf (page == pages[2])
        AddHeaderOption(pages[2])
        int ndx = 0
        ;Add an option for each of the 7 slots
        while ndx < MAX_QUEUE_SIZE
            if(_shoutQueue[ndx])
                nameStr = _shoutQueue[ndx].getName()
            else
                nameStr = ""
            endIf
            shoutArrayOID[ndx] = AddMenuOption("Slot " + (ndx + 1), nameStr)
            ndx += 1
        endWhile
    ;Potion page
    elseIf (page == pages[3])
        AddHeaderOption(pages[3])
        int ndx = 0
        while ndx < MAX_QUEUE_SIZE
            if(_potionQueue[ndx])
                nameStr = _potionQueue[ndx].getName()
            else
                nameStr = ""
            endIf
            potionArrayOID[ndx] = AddMenuOption("Slot " + (ndx + 1), nameStr)
            ndx += 1
        endWhile
    ;Left Hand page
    elseIf (page == pages[4])
        AddHeaderOption(pages[4])
        int ndx = 0
        while ndx < MAX_QUEUE_SIZE
            if(_leftHandQueue[ndx])
                nameStr = _leftHandQueue[ndx].getName()
            else
                nameStr = ""
            endIf
            leftArrayOID[ndx] = AddMenuOption("Slot " + (ndx + 1), nameStr)
            ndx += 1
        endWhile
    ;Right Hand page
    elseIf (page == pages[5])
        AddHeaderOption(pages[5])
        int ndx = 0
        while ndx < MAX_QUEUE_SIZE
            if(_rightHandQueue[ndx])
                nameStr = _rightHandQueue[ndx].getName()
            else
                nameStr = ""
            endIf
            rightArrayOID[ndx] = AddMenuOption("Slot " + (ndx + 1), nameStr)
            ndx += 1
        endWhile
    endIf
endEvent
;called when checkbox option is selected
event OnOptionSelect(int option)
    debug.trace("iEquip MCM OnOptionSelect called")
    if (option == enabledOID)
        bEnabled = !bEnabled
        SetToggleOptionValue(enabledOID, bEnabled)
    elseIf(option == mustBeFavoritedOID)
        mustBeFavorited = !mustBeFavorited
        SetToggleOptionValue(mustBeFavoritedOID, mustBeFavorited)
    elseIf(option == enableBringToFrontOID)
        bEnableBringToFront = !bEnableBringToFront
        SetToggleOptionValue(enableBringToFrontOID, bEnableBringToFront)
        EM.BringToFrontEnabled = bEnableBringToFront
    elseIf(option == enableBackgroundsOID)
        bEnableBackgrounds = !bEnableBackgrounds
        SetToggleOptionValue(enableBackgroundsOID, bEnableBackgrounds)
        EM.ToggleBackgrounds = bEnableBackgrounds
    elseIf(option == widgetVisTogglesHotkeyOID)
        bWidgetVisTogglesHotkey = !bWidgetVisTogglesHotkey
        SetToggleOptionValue(widgetVisTogglesHotkeyOID, bWidgetVisTogglesHotkey)
        KH.WidgetVisTogglesHotkey = bWidgetVisTogglesHotkey
    elseIf(option == resetOID)
        ShowMessage("Are you sure you wish to completely reset iEquip and discard any layout changes you have made?", true, "Reset", "Cancel")
        ShowMessage("Please fully exit the MCM so we can clean up your mess...", false, "OK")
        iEquip_Reset = !iEquip_Reset
    elseIf (option == fadeOID)
        fadeOut = !fadeOut
        SetToggleOptionValue(fadeOID, fadeOut)
        int flags = 0
        if(!fadeOut)
            flags = OPTION_FLAG_DISABLED
        else
            WC.FadeOut(fadeAlpha, fadeOutDuration/100.0)
        endIf
        SetOptionFlags(fadeAlphaOID, flags)
        SetOptionFlags(fadeOutDurationOID, flags)
        SetOptionFlags(fadeInDurationOID, flags)
        SetOptionFlags(fadeWaitOID, flags)
    ;/elseIf(option == assignEquippedOID)
        ASSIGNMENT_MODE = !ASSIGNMENT_MODE
        SetToggleOptionValue(assignEquippedOID, ASSIGNMENT_MODE)
        int flags 
        WC.setAssignMode(ASSIGNMENT_MODE) 
        if(ASSIGNMENT_MODE)
            flags = OPTION_FLAG_WITH_UNMAP
            ;Change gem colors
            WC.leftIndex = _currQIndices[0]
            WC.rightIndex = _currQIndices[1]
            WC.shoutIndex = _currQIndices[2]
            ;Register keys
            RegisterForKey(assignLeftKey)
            RegisterForKey(assignRightKey)
            RegisterForKey(assignShoutKey)
        else
            flags = OPTION_FLAG_DISABLED
            WC.leftIndex = _currQIndices[0]
            WC.rightIndex = _currQIndices[1]
            WC.shoutIndex = _currQIndices[2]
            UnregisterForKey(assignLeftKey)
            UnregisterForKey(assignRightKey)
            UnregisterForKey(assignShoutKey)
        endIf
        SetOptionFlags(keyOID_ASSIGNLEFT, flags)
        SetOptionFlags(keyOID_ASSIGNRIGHT, flags)
        SetOptionFlags(keyOID_ASSIGNSHOUT, flags)/;  
    endIf
endEvent

;set the default options when the 'R' key is pressed
;this is not implemented for the inventory items
event OnOptionDefault(int option)
    debug.trace("iEquip MCM OnOptionDefault called")
    If (option == enabledOID)
        bEnabled = false ; default value
        SetToggleOptionValue(enabledOID, bEnabled)
    elseIf (option == enableBringToFrontOID)
        bEnableBringToFront = false ; default value
        SetToggleOptionValue(enableBringToFrontOID, bEnableBringToFront)
    elseIf (option == enableBackgroundsOID)
        bEnableBackgrounds = false ; default value
        SetToggleOptionValue(enableBackgroundsOID, bEnableBackgrounds)
    elseIf (option == widgetVisTogglesHotkeyOID)
        bWidgetVisTogglesHotkey = true ; default value
        SetToggleOptionValue(widgetVisTogglesHotkeyOID, bWidgetVisTogglesHotkey)
    elseIf (option == keyOID_SHOUT)
        KH.iEquip_shoutKey = 45 ; default value
        SetKeyMapOptionValue(keyOID_SHOUT, KH.iEquip_shoutKey)
    elseIf (option == keyOID_POTION)
        KH.iEquip_potionKey = 21 ; default value
        SetKeyMapOptionValue(keyOID_POTION, KH.iEquip_potionKey)
    elseIf (option == keyOID_LEFT)
        KH.iEquip_leftKey = 47 ; default value
        SetKeyMapOptionValue(keyOID_LEFT, KH.iEquip_leftKey)
    elseIf (option == keyOID_RIGHT)
        KH.iEquip_rightKey = 48 ; default value
        SetKeyMapOptionValue(keyOID_RIGHT, KH.iEquip_rightKey)
    elseIf (option == keyOID_EDITMODE)
        KH.iEquip_editmodeKey = 69 ; default value
        SetKeyMapOptionValue(keyOID_EDITMODE, KH.iEquip_editmodeKey)
    elseIf (option == keyOID_EDITNEXT)
        KH.iEquip_EditNextKey = 55 ; default value
        SetKeyMapOptionValue(keyOID_EDITNEXT, KH.iEquip_EditNextKey)
    elseIf (option == keyOID_EDITPREV)
        KH.iEquip_EditPrevKey = 181 ; default value
        SetKeyMapOptionValue(keyOID_EDITPREV, KH.iEquip_EditPrevKey)
    elseIf (option == keyOID_EDITUP)
        KH.iEquip_EditUpKey = 200 ; default value
        SetKeyMapOptionValue(keyOID_EDITUP, KH.iEquip_EditUpKey)
    elseIf (option == keyOID_EDITDOWN)
        KH.iEquip_EditDownKey = 208 ; default value
        SetKeyMapOptionValue(keyOID_EDITDOWN, KH.iEquip_EditDownKey)
    elseIf (option == keyOID_EDITLEFT)
        KH.iEquip_EditLeftKey = 203 ; default value
        SetKeyMapOptionValue(keyOID_EDITLEFT, KH.iEquip_EditLeftKey)
    elseIf (option == keyOID_EDITRIGHT)
        KH.iEquip_EditRightKey = 205 ; default value
        SetKeyMapOptionValue(keyOID_EDITRIGHT, KH.iEquip_EditRightKey)
    elseIf (option == keyOID_EDITSCALEUP)
        KH.iEquip_EditScaleUpKey = 78 ; default value
        SetKeyMapOptionValue(keyOID_EDITSCALEUP, KH.iEquip_EditScaleUpKey)
    elseIf (option == keyOID_EDITSCALEDOWN)
        KH.iEquip_EditScaleDownKey = 74 ; default value
        SetKeyMapOptionValue(keyOID_EDITSCALEDOWN, KH.iEquip_EditScaleDownKey)
    elseIf (option == keyOID_EDITROTATE)
        KH.iEquip_EditRotateKey = 80 ; default value
        SetKeyMapOptionValue(keyOID_EDITROTATE, KH.iEquip_EditRotateKey)
    elseIf (option == keyOID_EDITALPHA)
        KH.iEquip_EditAlphaKey = 81 ; default value
        SetKeyMapOptionValue(keyOID_EDITALPHA, KH.iEquip_EditAlphaKey)
    elseIf (option == keyOID_EDITDEPTH)
        KH.iEquip_EditDepthKey = 72 ; default value
        SetKeyMapOptionValue(keyOID_EDITDEPTH, KH.iEquip_EditDepthKey)
    elseIf (option == keyOID_EDITTEXT)
        KH.iEquip_EditTextKey = 79 ; default value
        SetKeyMapOptionValue(keyOID_EDITTEXT, KH.iEquip_EditTextKey)
    elseIf (option == keyOID_EDITRULERS)
        KH.iEquip_EditRulersKey = 77 ; default value
        SetKeyMapOptionValue(keyOID_EDITRULERS, KH.iEquip_EditRulersKey)
    elseIf (option == keyOID_EDITRESET)
        KH.iEquip_EditResetKey = 82 ; default value
        SetKeyMapOptionValue(keyOID_EDITRESET, KH.iEquip_EditResetKey)
    elseIf (option == keyOID_EDITLOADPRESET)
        KH.iEquip_EditLoadPresetKey = 75 ; default value
        SetKeyMapOptionValue(keyOID_EDITLOADPRESET, KH.iEquip_EditLoadPresetKey)
    elseIf (option == keyOID_EDITSAVEPRESET)
        KH.iEquip_EditSavePresetKey = 76 ; default value
        SetKeyMapOptionValue(keyOID_EDITSAVEPRESET, KH.iEquip_EditSavePresetKey)
    elseIf (option == keyOID_EDITDISCARD)
        KH.iEquip_EditDiscardKey = 83 ; default value
        SetKeyMapOptionValue(keyOID_EDITDISCARD, KH.iEquip_EditDiscardKey)
    endIf
endEvent

;called when the slider menus appear
event OnOptionSliderOpen(int option)
    debug.trace("iEquip MCM OnOptionSliderOpen called")
    if (option == slowTimeOID)
        SetSliderDialogStartValue(iEquip_EditModeSlowTimeStrength.getvalueint())
        SetSliderDialogRange(0, 100)  
        SetSliderDialogInterval(10)
        SetSliderDialogDefaultValue(100)  ; default is fully paused
    elseif (option == fadeAlphaOID)
        SetSliderDialogStartValue(fadeAlpha)
        SetSliderDialogRange(0.00, 100.00)
        SetSliderDialogInterval(1.00)
        SetSliderDialogDefaultValue(0.00)
    elseIf (option == fadeOutDurationOID)
        SetSliderDialogStartValue(fadeOutDuration)
        SetSliderDialogRange(0.00, 500.00)
        SetSliderDialogInterval(5)
        SetSliderDialogDefaultValue(200.00)
    elseIf (option == fadeInDurationOID)
        SetSliderDialogStartValue(fadeInDuration)
        SetSliderDialogRange(1.00, 100.00)
        SetSliderDialogInterval(1)
        SetSliderDialogDefaultValue(30) 
    elseIf (option == fadeWaitOID)
        SetSliderDialogStartValue(fadeWait)
        SetSliderDialogRange(0.00, 3000.00)
        SetSliderDialogInterval(50)
        SetSliderDialogDefaultValue(500) 
    endIf
endEvent

;called when the slider menu is accepted
event OnOptionSliderAccept(int option, float value)
    debug.trace("iEquip MCM OnOptionSliderAccept called")
    if (option == slowTimeOID)
        iSlowValue = value as Int
        SetSliderOptionValue(option, value)
        iEquip_EditModeSlowTimeStrength.setvalueint(iSlowValue)
    elseIf (option == fadeAlphaOID)
        fadeAlpha =  value
        SetSliderOptionValue(option,fadeAlpha, "{0}%")
    elseIf (option == fadeOutDurationOID)
        fadeOutDuration = value
        SetSliderOptionValue(option,fadeOutDuration, "{0}")
    elseIf (option == fadeInDurationOID)
        fadeInDuration = value
        SetSliderOptionValue(option,fadeInDuration, "{0}")
    elseIf (option == fadeWaitOID)
        fadeWait = value
        SetSliderOptionValue(option,fadeWait, "{0}")
    endIf
endEvent

;called when an MCM menu item is highlighted
event OnOptionHighlight(int option)
    debug.trace("iEquip MCM OnOptionHighlight called")
    ;visibility
    If (option == enabledOID)
        SetInfoText("Turn iEquip ON or OFF here\nDefault: OFF")
    ;Edit Mode slow time effect
    elseIf (option == slowTimeOID)
        SetInfoText("iEquip Edit Mode runs with the game unpaused so to avoid unneccessary death or injury while you set things up we apply a slow time effect. This slider lets you set how much time slows by in Edit Mode\nDefault is 100% or fully paused, at 0 time passes normally in Edit Mode")
    ;Edit Mode Bring To Front functionality
    elseIf (option == enableBringToFrontOID)
        SetInfoText("Bring To Front feature in Edit Mode allows you to rearrange the layer order of overlapping widget elements\nDisabled by default as adds a short delay when switching presets and toggling Edit Mode")
    ;Show widget backgrounds
    elseIf (option == enableBackgroundsOID)
        SetInfoText("Enables backgrounds for each of the widgets.  Once enabled backgrounds are available in Edit Mode and can be shown, hidden and manipulated like all other elements\nDefault is Disabled")
    ;Set individual hotkeys to be blocked for certain actions when sub widget hidden
    elseIf (option == widgetVisTogglesHotkeyOID)
        SetInfoText("When this setting is enabled certain individual hotkey actions are blocked when each of the widgets are hidden\nDefault is Enabled")
    ;reset/;
    elseIf (option == resetOID)
        SetInfoText("Selecting this will nuke any changes you have made to iEquip and fully restore the default layout")
    ;keyShout
    elseIf (option == keyOID_SHOUT)
        SetInfoText("Select a hotkey to control the shout widget functions\nDefault: Y")
    ;keyPotion
    elseIf (option == keyOID_POTION)
        SetInfoText("Select a hotkey to control the potion widget functions\nDefault: X")
    ;keyLeft
    elseIf (option == keyOID_LEFT)
        SetInfoText("Select a hotkey to control the left hand widget functions\nDefault: V")
    ;keyRight
    elseIf (option == keyOID_RIGHT)
        SetInfoText("Select a hotkey to control the right hand widget functions\nDefault: B")
    ;keyMode
    elseIf (option == keyOID_EDITMODE)
        SetInfoText("Select a hotkey to toggle edit mode\nDefault: NumLock")
    elseIf (option == customEMKeys_OID)
        SetInfoText("Choose to use the recommended Edit Mode hotkeys or set your own")
    elseIf (option == mustBeFavoritedOID)
        SetInfoText("Only favorited items and spells will show up in the item group menus.  You may want to select this if you have a very large inventory. You will need to refresh your inventory items for the changes to take effect.")
    elseIf(option == fadeOID)
        SetInfoText("The widget will fade out of view when not in use")
    elseIf(option == fadeAlphaOID)
        SetInfoText("The alpha value to which the widget will fade after the alotted time.")
    elseIf(option == fadeOutDurationOID)
        SetInfoText("The amount of time (in centiseconds) it will take the widget to fade from visible to its faded alpha value.")
    elseIf(option == fadeInDurationOID)
        SetInfoText("The amount of time (in centiseconds) it will take the widget to fade into view after a key is pressed.")
    elseIf(option == fadeWaitOID)
        SetInfoText("The amount of time (in centiseconds) the widget will wait after the last key is pressed to begin fading.")
    ;/elseIf(option == assignEquippedOID)
        SetInfoText("In assignment mode, you can assign currently equipped items and spells to your queues.  Cycling through the queue will not skip empty slots and weapons / spells will not actually equip.  Disable when done.  Assignment keys will only work when this is on.")
    elseIf(option == keyOID_ASSIGNLEFT)
        SetInfoText("Pressing this key will assign the weapon, spell, or item in your left hand to the current slot in the left hand queue.")
    elseIf(option == keyOID_ASSIGNRIGHT)
        SetInfoText("Pressing this key will assign the weapon, spell, or item in your right hand to the current slot in the left hand queue.")
    elseIf(option == keyOID_ASSIGNSHOUT)
        SetInfoText("Pressing this key will assign the shout or ability in your power slot to the current slot in the left hand queue.")/;
   ; elseIf(option == refreshPotionsOID)
        ;SetInfoText("Refreshes your potion list (and only your potion list).  This is just slightly quicker than updating everything.")
    endIf
endEvent

;Method taken from MCM API reference
bool function checkKeyConflict(string conflictControl, string conflictName)
    debug.trace("iEquip MCM checkKeyConflict called")
    bool continue = true
    if (conflictControl != "")
        string msg
        if (conflictName != "")
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
        else
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
        endIf
        continue = ShowMessage(msg, true, "$Yes", "$No")
    endIf
    return continue
endFunction

Int function switchKeyMaps()
    debug.trace("iEquip MCM switchKeyMaps called")
    KH.UnregisterForAllKeys()
    if EM.isEditMode
        KH.RegisterForEditModeKeys()
    else
        KH.RegisterForGameplayKeys()
    endIf
endFunction

;called when a key map box is changed
event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
    debug.trace("iEquip MCM OnOptionKeyMapChange called")
    If (option == keyOID_SHOUT)
        if(checkKeyConflict(conflictControl, conflictName))
            ;Unregister old key, register new key
            KH.iEquip_shoutKey = keyCode
            switchKeyMaps() 
            ;Change the displayed key in MCM
            SetKeyMapOptionValue(keyOID_SHOUT, KH.iEquip_shoutKey)
        endIf
    elseIf (option == keyOID_POTION)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_potionKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_POTION, KH.iEquip_potionKey)
        endIf
    elseIf (option == keyOID_LEFT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_leftKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_LEFT, KH.iEquip_leftKey)
        endIf
    elseIf (option == keyOID_RIGHT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_rightKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_RIGHT, KH.iEquip_rightKey)
        endIf
    elseIf (option == keyOID_EDITMODE)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_editmodeKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITMODE, KH.iEquip_editmodeKey)
        endIf
    elseIf (option == keyOID_EDITNEXT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditNextKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITNEXT, KH.iEquip_EditNextKey)
        endIf
    elseIf (option == keyOID_EDITPREV)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditPrevKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITPREV, KH.iEquip_EditPrevKey)
        endIf
    elseIf (option == keyOID_EDITUP)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditUpKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITUP, KH.iEquip_EditUpKey)
        endIf
    elseIf (option == keyOID_EDITDOWN)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditDownKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITDOWN, KH.iEquip_EditDownKey)
        endIf
    elseIf (option == keyOID_EDITLEFT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditLeftKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITLEFT, KH.iEquip_EditLeftKey)
        endIf
    elseIf (option == keyOID_EDITRIGHT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditRightKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITRIGHT, KH.iEquip_EditRightKey)
        endIf
    elseIf (option == keyOID_EDITSCALEUP)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditScaleUpKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITSCALEUP, KH.iEquip_EditScaleUpKey)
        endIf
    elseIf (option == keyOID_EDITSCALEDOWN)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditScaleDownKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITSCALEDOWN, KH.iEquip_EditScaleDownKey)
        endIf
    elseIf (option == keyOID_EDITROTATE)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditRotateKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITROTATE, KH.iEquip_EditRotateKey)
        endIf
    elseIf (option == keyOID_EDITALPHA)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditAlphaKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITALPHA, KH.iEquip_EditAlphaKey)
        endIf
    elseIf (option == keyOID_EDITDEPTH)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditDepthKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITDEPTH, KH.iEquip_EditDepthKey)
        endIf
    elseIf (option == keyOID_EDITTEXT)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditTextKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITTEXT, KH.iEquip_EditTextKey)
        endIf
    elseIf (option == keyOID_EDITRULERS)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditRulersKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITRULERS, KH.iEquip_EditRulersKey)
        endIf
    elseIf (option == keyOID_EDITRESET)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditResetKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITRESET, KH.iEquip_EditResetKey)
        endIf
    elseIf (option == keyOID_EDITLOADPRESET)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditLoadPresetKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITLOADPRESET, KH.iEquip_EditLoadPresetKey)
        endIf
    elseIf (option == keyOID_EDITSAVEPRESET)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditSavePresetKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITSAVEPRESET, KH.iEquip_EditSavePresetKey)
        endIf
    elseIf (option == keyOID_EDITDISCARD)
        if(checkKeyConflict(conflictControl, conflictName))
            KH.iEquip_EditDiscardKey = keyCode
            switchKeyMaps() 
            SetKeyMapOptionValue(keyOID_EDITDISCARD, KH.iEquip_EditDiscardKey)
        endIf
    ;/elseIf(option == keyOID_ASSIGNLEFT)
        if(checkKeyConflict(conflictControl, conflictName))
            assignLeftKey = switchKeyMaps(assignLeftKey, keyCode)
            SetKeyMapOptionValue(keyOID_ASSIGNLEFT, assignLeftKey)
        endIf
    elseIf(option == keyOID_ASSIGNRIGHT)
        if(checkKeyConflict(conflictControl, conflictName))
            assignRightKey = switchKeyMaps(assignRightKey, keyCode)
            SetKeyMapOptionValue(keyOID_ASSIGNRIGHT, assignRightKey)
        endIf
    elseIf(option == keyOID_ASSIGNSHOUT)
        if(checkKeyConflict(conflictControl, conflictName))
            assignShoutKey = switchKeyMaps(assignShoutKey, keyCode)
            SetKeyMapOptionValue(keyOID_ASSIGNSHOUT, assignShoutKey)
        endIf/;
    endIf
endEvent

;called when the drop down menu is opened for selecting queue items
event OnOptionMenuOpen(int option)
    debug.trace("iEquip MCM OnOptionMenuOpen called")
    Int iElement = 0
    if (option == customEMKeys_OID)
        SetMenuDialogStartIndex(currentEMKeysChoice)
        SetMenuDialogDefaultIndex(0)
        SetMenuDialogOptions(EMKeysChoice)
    endIf
    
    While iElement < shoutArrayOID.Length
        If (option == shoutArrayOID[iElement])
                SetMenuDialogOptions(_shoutListName)
                SetMenuDialogStartIndex(shoutIndex[iElement])
                SetMenuDialogDefaultIndex(0)
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < potionArrayOID.Length
        If (option == potionArrayOID[iElement])
                SetMenuDialogOptions(_potionListName)
                SetMenuDialogStartIndex(potionIndex[iElement])
                SetMenuDialogDefaultIndex(0)
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < leftArrayOID.Length
        If (option == leftArrayOID[iElement])
                SetMenuDialogOptions(_leftHandListName)
                SetMenuDialogStartIndex(leftIndex[iElement])
                SetMenuDialogDefaultIndex(0)
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < rightArrayOID.Length
        If (option == rightArrayOID[iElement])
                SetMenuDialogOptions(_rightHandListName)
                SetMenuDialogStartIndex(rightIndex[iElement])
                SetMenuDialogDefaultIndex(0)
        endIf
        iElement += 1
    endWhile
endEvent

;called when a combo box option is selected
event OnOptionMenuAccept(int option, int index)

    debug.trace("iEquip MCM OnOptionMenuAccept called")
    if (option == customEMKeys_OID)
        currentEMKeysChoice = index
        SetMenuOptionValue(option, EMKeysChoice[currentEMKeysChoice])
        ForcePageReset()
    endIf
    
    Int iElement = 0
    While iElement < shoutArrayOID.Length
        If (option == shoutArrayOID[iElement])
            _shoutQueue[iElement] = _shoutsKnown[index]
            shoutIndex[iElement] = index
            ItemDataUpToDate[2*MAX_QUEUE_SIZE + iElement] = false
            SetMenuOptionValue(shoutArrayOID[iElement], _shoutQueue[iElement].getName())
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < potionArrayOID.Length
        If (option == potionArrayOID[iElement])
            _potionQueue[iElement] = _potionList[index]
            ItemDataUpToDate[3*MAX_QUEUE_SIZE + iElement] = false
            potionIndex[iElement] = index
            SetMenuOptionValue(potionArrayOID[iElement], _potionQueue[iElement].getName())
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < leftArrayOID.Length
        If (option == leftArrayOID[iElement])
            _leftHandQueue[iElement] = _leftHandList[index]
            ItemDataUpToDate[iElement] = false
            leftIndex[iElement] = index
            SetMenuOptionValue(leftArrayOID[iElement], _leftHandQueue[iElement].getName())
        endIf
        iElement += 1
    endWhile

    iElement = 0
    While iElement < rightArrayOID.Length
        If (option == rightArrayOID[iElement])
            _rightHandQueue[iElement] = _rightHandList[index]
            ItemDataUpToDate[MAX_QUEUE_SIZE + iElement] = false
            rightIndex[iElement] = index
            SetMenuOptionValue(rightArrayOID[iElement], _rightHandQueue[iElement].getName())
        endIf
        iElement += 1
    endWhile
endEvent

Event OnConfigClose()
    debug.trace("iEquip MCM OnConfigClose called")
    if WC.isEnabled != bEnabled
        if !bEnabled && EM.isEditMode
            EM.Disabling = true
            EM.ToggleEditMode()
            EM.Disabling = false
        endIf
        WC.isEnabled = bEnabled
    endIf
    EM.ApplyMCMSettings()
    debug.trace("iEquip MCM OnConfigClose finished")
endEvent


;END MENU WIDGET CODE
