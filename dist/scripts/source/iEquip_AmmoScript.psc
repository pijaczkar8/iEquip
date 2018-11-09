scriptName iEquip_AmmoScript extends Quest

import _Q2C_Functions
import iEquip_Utility
import stringUtil

iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

actor property PlayerRef auto

int lastArrowSortType = 0
int lastBoltSortType = 0

function updateAmmoList(int ammoQ, bool isBolt, bool forceSort = false)
	debug.trace("iEquip_AmmoScript updateAmmoList() called")
	;weaponType - 0 = Bow, 1 = Crossbow - Determined by what type of ranged weapon you are about to equip
	;First check if anything needs to be removed
	int count = jArray.count(ammoQ)
	int initialCount = count
	form ammoForm
	if MCM.AmmoListSorting == 3
		jArray.clear(ammoQ)
	endIf
	debug.trace("iEquip_AmmoScript updateAmmoList() - " + count + " found in the queue, isBolt: " + isBolt)
	int i = 0
	while i < count && count > 0
		ammoForm = jMap.getForm(jArray.getObj(ammoQ, i), "Form")
		if !ammoForm || PlayerRef.GetItemCount(ammoForm) < 1
			jArray.eraseIndex(ammoQ, i)
			count -= 1
			i -= 1
		endIf
		i += 1
	endWhile
	int NumRemoved = initialCount - count ;Remove once tested
	debug.trace("iEquip_AmmoScript updateAmmoList() - " + NumRemoved + " items removed from queue")
	;Scan player inventory for all ammo and add it if not already found in the queue
	bool needsSorting = false
	count = GetNumItemsOfType(PlayerRef, 42)
	debug.trace("iEquip_AmmoScript updateAmmoList() - Number of ammo types found in inventory: " + count)
	i = 0
	Form FoundAmmo
	String AmmoName
	while i < count && count > 0
		FoundAmmo = GetNthFormOfType(PlayerRef, 42, i)
		AmmoName = FoundAmmo.GetName()
		;The Javelin check is to get the Spears by Soolie javelins which are classed as arrows/bolts and all of which have more descriptive names than simply Javelin, which is from Throwing Weapons and is an equippable throwing weapon
		if (!isBolt && stringutil.Find(AmmoName, "arrow", 0) > -1) || (isBolt && stringutil.Find(AmmoName, "bolt", 0) > -1) || (stringutil.Find(AmmoName, "Javelin", 0) > -1 && AmmoName != "Javelin")
			;Make sure we're only adding arrows to the arrow queue or bolts to the bolt queue
			if (!isBolt && !(FoundAmmo as Ammo).isBolt()) || (isBolt && (FoundAmmo as Ammo).isBolt())
				if !isAlreadyInAmmoQueue(ammoQ, FoundAmmo)
					AddToAmmoQueue(ammoQ, isBolt, FoundAmmo as Ammo, AmmoName)
					needsSorting = true
				endIf
			endIf
		endIf
		i += 1
	endWhile
	int sortType = MCM.AmmoListSorting
	int lastSortType = lastArrowSortType
	if isBolt
		lastSortType = lastBoltSortType
	endIf
	debug.trace("iEquip_AmmoScript updateAmmoList() - needsSorting: " + needsSorting)
	if forceSort || (!sortType == 0 && (needsSorting || sortType != lastSortType)) ;MCM.AmmoListSorting == 0 is Unsorted
		sortAmmoList(ammoQ)
	endIf
	if isBolt
		lastBoltSortType = sortType
	else
		lastArrowSortType = sortType
	endIf
endFunction

bool function isAlreadyInAmmoQueue(int ammoQ, form itemForm)
	debug.trace("iEquip_AmmoWidget isAlreadyInQueue() called - itemForm: " + itemForm)
	bool found = false
	int i = 0
	while i < JArray.count(ammoQ) && !found
		found = (itemform == jMap.getForm(jArray.getObj(ammoQ, i), "Form"))
		i += 1
	endWhile
	debug.trace("iEquip_AmmoWidget isAlreadyInQueue() - returning found: " + found)
	return found
endFunction

function AddToAmmoQueue(int ammoQ, bool isBolt, Ammo AmmoForm, string AmmoName)
	debug.trace("iEquip_AmmoScript AddToAmmoQueue() called")
	;Get the additional ammo info we need
	String AmmoIcon = getAmmoIcon(isBolt, AmmoName)
	Float AmmoDamage = AmmoForm.GetDamage()
	int currentCount = PlayerRef.GetItemCount(AmmoForm)
	;Create the ammo object
	int AmmoItem = jMap.object()
	jMap.setForm(AmmoItem, "Form", AmmoForm as Form)
	jMap.setStr(AmmoItem, "Icon", AmmoIcon)
	jMap.setStr(AmmoItem, "Name", AmmoName)
	jMap.setFlt(AmmoItem, "Damage", AmmoDamage)
	jMap.setInt(AmmoItem, "Count", currentCount)
	;Add it to the relevant ammo queue
	jArray.addObj(ammoQ, AmmoItem)
endFunction

String function getAmmoIcon(bool isBolt, string AmmoName)
	debug.trace("iEquip_AmmoScript getAmmoIcon() called - isBolt: " + isBolt + ", AmmoName: " + AmmoName)
	String iconName = ""
	;Set base icon
	if !isBolt
		iconName = "Arrow"
	else
		iconName = "Bolt"
	endIf
	;If this all looks a little strange it is because StringUtil find() is case sensitive so where possible I've ommitted the first letter to catch for example Spear and spear with pear
	if stringutil.Find(AmmoName, "spear", 0) > -1 || stringutil.Find(AmmoName, "javelin", 0) > -1
		iconName = "Spear"
	endIf
	;Check if it is likely to have an additional effect - bit hacky checking the name but I've no idea how to check for attached magic effects!
	if iconName != "Spear"
		if stringutil.Find(AmmoName, "fire", 0) > -1 || stringutil.Find(AmmoName, "torch", 0) > -1 || stringutil.Find(AmmoName, "burn", 0) > -1 || stringutil.Find(AmmoName, "incendiary", 0) > -1
			iconName += "Fire"
		elseIf stringutil.Find(AmmoName, "frost", 0) > -1 || stringutil.Find(AmmoName, "ice", 0) > -1 || stringutil.Find(AmmoName, "freez", 0) > -1 || stringutil.Find(AmmoName, "cold", 0) > -1
			iconName += "Ice"
		elseIf stringutil.Find(AmmoName, "shock", 0) > -1 || stringutil.Find(AmmoName, "spark", 0) > -1 || stringutil.Find(AmmoName, "electr", 0) > -1
			iconName += "Shock"
		elseIf stringutil.Find(AmmoName, "poison", 0) > -1
			iconName += "Poison"
		endIf
	endIf
	debug.trace("iEquip_AmmoScript getAmmoIcon() returning iconName: " + iconName)
	return iconName
endFunction

function sortAmmoList(int ammoQ)
	debug.trace("iEquip_AmmoScript sortAmmoList() called - Sort: " + MCM.AmmoListSorting)
	if MCM.AmmoListSorting == 1 ;By damage, highest first
		sortAmmoQueue(ammoQ, "Damage")
	elseIf MCM.AmmoListSorting == 2 ;By name alphabetically
		sortAmmoQueueByName(ammoQ)
	elseIf MCM.AmmoListSorting == 3 ;By quantity, most first
		sortAmmoQueue(ammoQ, "Count")
	endIf
endFunction

function sortAmmoQueueByName(int ammoQ)
	debug.trace("iEquip_AmmoScript sortAmmoQueueByName() called")
	int queueLength = jArray.count(ammoQ)
	int tempAmmoQ = jArray.objectWithSize(queueLength)
	int i = 0
	string ammoName
	while i < queueLength
		ammoName = jMap.getStr(jArray.getObj(ammoQ, i), "Name")
		jArray.setStr(tempAmmoQ, i, ammoName)
		i += 1
	endWhile
	jArray.sort(tempAmmoQ)
	i = 0
	int iIndex
	bool found
	while i < queueLength
		ammoName = jArray.getStr(tempAmmoQ, i)
		iIndex = 0
		found = false
		while iIndex < queueLength && !found
			if ammoName != jMap.getStr(jArray.getObj(ammoQ, iIndex), "Name")
				iIndex += 1
			else
				found = true
			endIf
		endWhile
		if i != iIndex
			jArray.swapItems(ammoQ, i, iIndex)
		endIf
		i += 1
	endWhile
	WC.selectLastUsedAmmo()
endFunction

function sortAmmoQueue(int ammoQ, string theKey)
    debug.trace("iEquip_AmmoScript sortAmmoQueue called - Sort by: " + theKey)
    int n = jArray.count(ammoQ)
    int i
    While (n > 1)
        i = 1
        n -= 1
        While (i <= n)
            Int j = i 
            int k = (j - 1) / 2
            While (jMap.getFlt(jArray.getObj(ammoQ, j), theKey) < jMap.getFlt(jArray.getObj(ammoQ, k), theKey))
                jArray.swapItems(ammoQ, j, k)
                j = k
                k = (j - 1) / 2
            EndWhile
            i += 1
        EndWhile
        jArray.swapItems(ammoQ, 0, n)
    EndWhile
    i = 0
   	n = jArray.count(ammoQ)
    while i < n
        debug.trace("iEquip_AmmoScript - sortAmmoQueue, sorted order: " + i + ", " + jMap.getForm(jArray.getObj(ammoQ, i), "Form").GetName() + ", " + theKey + ": " + jMap.getFlt(jArray.getObj(ammoQ, i), theKey))
        i += 1
    endWhile
    WC.selectBestAmmo()
EndFunction
