ScriptName iEquip_HelpMenu Extends Quest

import iEquip_StringExt

Actor property PlayerRef auto

Message property iEquip_HelpMenuMain Auto
Message property iEquip_HelpMenuProMode Auto
Message property iEquip_MessageNextPageExit Auto

Quest property iEquip_MessageQuest auto ; populated by CK
ReferenceAlias property iEquip_MessageAlias auto ; populated by CK, but Alias is filled by script, not by CK
MiscObject property iEquip_MessageObject auto ; populated by CK
ObjectReference property iEquip_MessageObjectReference auto ; populated by script

function showHelpMenuMain()
    bool bShowAgain = true
    
    while bShowAgain
        int iAction = showTranslatedMessage(0, iEquip_StringExt.LocalizeString("$iEquip_help_title"))  
        
        if iAction != 7             ; Exit
            if iAction == 0         ; Controls
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls0"))
                if iAction == 0
                    iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls1"))
                    if iAction == 0
                        iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls2"))
                        if iAction == 0         ; Controls
                            iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls3"))
                            if iAction == 0
                                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls4"))
                                if iAction == 0
                                    iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_controls5"))
                                    if iAction == 0
                                        debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_controls6"))
                                    endIf
                                endIf
                            endIf
                        endIf
                    endIf
                endIf

            elseif iAction == 1     ; Adding Items
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_addingItems1"))
                if iAction == 0
                    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_addingItems2"))
                endIf
            
            elseif iAction == 2     ; Ammo Mode
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_AmmoMode1"))
                if iAction == 0
                    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_AmmoMode2"))
                endIf
            
            elseif iAction == 3     ; Recharging
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_recharging1"))
                if iAction == 0
                    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_recharging2"))
                endIf
            
            elseif iAction == 4     ; Using Poisons
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_poisoning1"))
                if iAction == 0
                    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_poisoning2"))
                endIf
            
            elseif iAction == 5     ; Potion Groups
                debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_potionGroups"))
            
            elseif iAction == 6     ; Pro Mode
                bShowAgain = showHelpMenuProMode()
            endIf
        else
            bShowAgain = false
        endIf
    endWhile
endFunction

bool function showHelpMenuProMode() ; Return false to exit
    bool bShowAgain = true
    bool bShowAgainMain = true
    
    while bShowAgain
        int iAction = showTranslatedMessage(1, iEquip_StringExt.LocalizeString("$iEquip_help_title"))
        
        if iAction  != 6            ; Exit
            
            if iAction == 0         ; Back
                bShowAgain = false
            elseif iAction == 1     ; Preselect
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_preselect1"))
                if iAction == 0
                    iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_preselect2"))
                    if iAction == 0
                        debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_preselect3"))
                    endIf
                endIf
            
            elseif iAction == 2     ; QuickRanged
                debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickranged"))
            
            elseif iAction == 3     ; QuickShield
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_quickshield1"))
                if iAction == 0
                    iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_quickshield2"))
                    if iAction == 0
                        debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickshield3"))
                    endIf
                endIf
            
            elseif iAction == 4     ; QuickRestore
                iAction = showTranslatedMessage(2, iEquip_StringExt.LocalizeString("$iEquip_help_quickRestore1"))
                if iAction == 0
                    debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickRestore2"))
                    if iAction == 0
                        debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickRestore3"))
                        if iAction == 0
                            debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickRestore4"))
                        endIf
                    endIf
                endIf

            elseif iAction == 5     ; QuickDualCast
                debug.MessageBox(iEquip_StringExt.LocalizeString("$iEquip_help_quickdualcast"))
            endIf
        else
            bShowAgain = false
            bShowAgainMain = false
        endIf
    endWhile
    
    return bShowAgainMain
endFunction

int function showTranslatedMessage(int theMenu, string theString)
	int iButton

    iEquip_MessageObjectReference = PlayerRef.PlaceAtMe(iEquip_MessageObject)
    iEquip_MessageAlias.ForceRefTo(iEquip_MessageObjectReference)
    iEquip_MessageAlias.GetReference().GetBaseObject().SetName(theString)

    if theMenu == 0
        iButton = iEquip_HelpMenuMain.Show()
    elseIf theMenu == 1
        iButton = iEquip_HelpMenuProMode.Show()
    else
        iButton = iEquip_MessageNextPageExit.Show()
    endIf
	
    iEquip_MessageAlias.Clear()
    iEquip_MessageObjectReference.Disable()
    iEquip_MessageObjectReference.Delete()
	
    return iButton
endFunction
