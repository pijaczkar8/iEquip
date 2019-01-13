Scriptname iEquip_MCM_que extends iEquip_MCM_Page

iEquip_WidgetCore Property WC Auto
iEquip_PotionScript Property PO Auto

; #############
; ### SETUP ###

function drawPage()
    if MCM.bEnabled
        MCM.AddHeaderOption("Queue Length Options")
        MCM.AddSliderOptionST("que_sld_maxItmQue", "Max items per queue", WC.iMaxQueueLength, "Max {0} items")
        MCM.AddToggleOptionST("que_tgl_hrdLimQueSize", "Hard limit queue size", WC.bHardLimitQueueSize)
                
        MCM.AddHeaderOption("Add To Queue Options")
        MCM.AddToggleOptionST("que_tgl_showConfMsg", "Show confirmation messages", WC.bShowQueueConfirmationMessages)
        MCM.AddToggleOptionST("que_tgl_signlBothQue", "Single items in both hand queues", WC.bAllowSingleItemsInBothQueues)
                
        if WC.bAllowSingleItemsInBothQueues
            MCM.AddToggleOptionST("que_tgl_allow1hSwitch", "Allow 1h items to switch hands", WC.bAllowWeaponSwitchHands)
        endIf

        MCM.SetCursorPosition(1)
                
        MCM.AddHeaderOption("Auto Add Options")
        MCM.AddToggleOptionST("que_tgl_autoAddItmQue", "Auto-add on equipping", WC.bAutoAddNewItems)
        MCM.AddToggleOptionST("que_tgl_autoAddPoisons", "Auto-add poisons", PO.bAutoAddPoisons)
        MCM.AddToggleOptionST("que_tgl_autoAddConsumables", "Auto-add food and drink", PO.bAutoAddConsumables)
        MCM.AddToggleOptionST("que_tgl_allowCacheRmvItm", "Allow caching of removed items", WC.bEnableRemovedItemCaching)
                
        if WC.bEnableRemovedItemCaching
            MCM.AddSliderOptionST("que_sld_MaxItmCache", "Max items to cache", WC.iMaxCachedItems, "Max {0} items")
        endIf
    endIf
endFunction

; #####################
; ### Queue Options ###
; #####################

; ------------------------
; - Queue Length Options -
; ------------------------

State que_sld_maxItmQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Select the maximum number of items you can add to each slot queue.  Bear in mind adding too many items will mean having to cycle through a LOT to get to what you want. "+\
                            "You can set a higher limit and not fill the queue as empty slots will be ignored when cycling.\nDefault = 7")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iMaxQueueLength, 0.0, 30.0, 1.0, 12.0)
        elseIf currentEvent == "Accept"
            if currentVar as int < WC.iMaxQueueLength
                if MCM.ShowMessage("You are about to reduce the maximum permitted queue length!\n\nAny queues which currently exceed the new length will be trimmed.\n\nDo you wish to proceed?", true, "OK", "Cancel")
                    WC.iMaxQueueLength = currentVar as int
                    WC.bReduceMaxQueueLengthPending = true
                endIf
            else
                WC.iMaxQueueLength = currentVar as int
            endIf
            MCM.SetSliderOptionValueST(WC.iMaxQueueLength, "Max {0} items")
        endIf
    endEvent
endState

State que_tgl_hrdLimQueSize
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Hard limit the queue lengths to the value set above. Disabling this will allow your queues to grow dynamically if you enable auto adding of new items below\nDefault: On")
        elseIf currentEvent == "Select" || (currentEvent == "Default" && !WC.bHardLimitQueueSize)
            bool continue = true
            if !WC.bHardLimitQueueSize
                continue = MCM.ShowMessage("You are about to enable a hard limit on your maximum queue lengths!\n\nDoing so will stop the queues from being able to grow organically as new items are equipped. "+\
                    "This can particularly affect your consumable and poison queues.\n\nDo you wish to proceed?", true, "OK", "Cancel")
                if continue
                    WC.bReduceMaxQueueLengthPending = true
                endIf
            endIf
            if continue
                WC.bHardLimitQueueSize = !WC.bHardLimitQueueSize
                MCM.SetToggleOptionValueST(WC.bHardLimitQueueSize)
            endIf
        endIf
    endEvent
endState

; ------------------------
; - Add To Queue Options -
; ------------------------

State que_tgl_showConfMsg
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Disable this to skip the confirmation messageboxes when adding items to the queues, removing items or clearing the queues")
        elseIf currentEvent == "Select"
            WC.bShowQueueConfirmationMessages = !WC.bShowQueueConfirmationMessages
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        elseIf currentEvent == "Default"
            WC.bShowQueueConfirmationMessages = true 
            MCM.SetToggleOptionValueST(WC.bShowQueueConfirmationMessages)
        endIf
    endEvent
endState

State que_tgl_signlBothQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Allow adding the same 1h item to both the left and right hand queues if you only have one of them in your inventory\nDefault: On")
        elseIf currentEvent == "Select"
            WC.bAllowSingleItemsInBothQueues = !WC.bAllowSingleItemsInBothQueues
        
            if !WC.bAllowSingleItemsInBothQueues
                if MCM.ShowMessage("iEquip Queue Maintenance\n\nWould you like us to check now and remove duplicate items which you only have one of? "+\
                "Priority will be given to the left hand queue as we are only looking at 1h items here, so they will be removed from your right queue.",  true, "Purge Queues", "Leave In Both")
                    WC.bRefreshQueues = true
                endIf
            endIf
            
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bAllowSingleItemsInBothQueues = false 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State que_tgl_allow1hSwitch
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("If you have allowed single items in both queues this setting determines whether you want those items to be able to switch hands, "+\
                            "or if you want cycling to skip past them if they are already equipped in the other hand.\nDefault: On")
        elseIf currentEvent == "Select"
            WC.bAllowWeaponSwitchHands = !WC.bAllowWeaponSwitchHands
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        elseIf currentEvent == "Default"
            WC.bAllowWeaponSwitchHands = false 
            MCM.SetToggleOptionValueST(WC.bAllowWeaponSwitchHands)
        endIf
    endEvent
endState

; --------------------
; - Auto Add Options -
; --------------------

State que_tgl_autoAddItmQue
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Enabling this setting will allow any manually equipped item which isn't already found in your left/right/shout queue to be automatically added to the queue. "+\
                            "Hand items will only be added if not found in either queue. Items added this way will allow the queue length to grow if you have disabled the hard limit above.\nDefault: Off")
        elseIf currentEvent == "Select"
            WC.bAutoAddNewItems = !WC.bAutoAddNewItems
            MCM.SetToggleOptionValueST(WC.bAutoAddNewItems)
        elseIf currentEvent == "Default"
            WC.bAutoAddNewItems = true 
            MCM.SetToggleOptionValueST(WC.bAutoAddNewItems)
        endIf
    endEvent
endState

State que_tgl_autoAddPoisons
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled iEquip will manage your poison queue for you, finding and adding all poisons currently in your inventory and adding new ones as you acquire them. "+\
                            "There will no longer be a restriction on the number of poisons in the queue, and they will be sorted alphabetically.  If you intend to grind alchemy then disable this setting, "+\
                            "however if you only craft and carry poisons you intend to use then this will save you having to manage the poison queue.\nDefault - Off")
        else
            If currentEvent == "Select"
                PO.bAutoAddPoisons = !PO.bAutoAddPoisons
                MCM.SetToggleOptionValueST(PO.bAutoAddPoisons)
            elseIf currentEvent == "Default"
                PO.bAutoAddPoisons = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddPoisons)
            PO.bSettingsChanged = true
        endIf 
    endEvent
endState

State que_tgl_autoAddConsumables
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("With this enabled iEquip will add food and drink to your consumables queue for you, finding and adding all food and drink currently in your inventory and adding new ones as you acquire them. "+\
                            "There will no longer be a restriction on the number of items in the queue.  If you regularly carry lots of different food and drink items then disable this setting, "+\
                            "however if you only carry what you intend to eat and drink then this will save you having to manage those items in the consumables queue.\nDefault - Off")
        else
            If currentEvent == "Select"
                PO.bAutoAddConsumables = !PO.bAutoAddConsumables
                MCM.SetToggleOptionValueST(PO.bAutoAddConsumables)
            elseIf currentEvent == "Default"
                PO.bAutoAddConsumables = true
            endIf
            MCM.SetToggleOptionValueST(PO.bAutoAddConsumables)
            PO.bSettingsChanged = true
        endIf 
    endEvent
endState

State que_tgl_allowCacheRmvItm
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Each time you cycle IEquip checks if you still have the item and if not removes it from your queues. "+\
                            "This allows caching of those removed items so if you later add them back into your inventory they will automatically be added back into the queue they were previously in as long as there is space in the queue or you have disabled the hard limit.\nDefault: On")
        elseIf currentEvent == "Select"
            WC.bEnableRemovedItemCaching = !WC.bEnableRemovedItemCaching
            MCM.forcePageReset()
        elseIf currentEvent == "Default"
            WC.bEnableRemovedItemCaching = true 
            MCM.forcePageReset()
        endIf
    endEvent
endState

State que_sld_MaxItmCache
    event OnBeginState()
        if currentEvent == "Highlight"
            MCM.SetInfoText("Determines the maximum number of removed items you want to remember\nDefault: 30 items")
        elseIf currentEvent == "Open"
            MCM.fillSlider(WC.iMaxCachedItems, 0.0, 128.0, 1.0, 60.0)
        elseIf currentEvent == "Accept"
            WC.iMaxCachedItems = currentVar as int
            MCM.SetSliderOptionValueST(WC.iMaxCachedItems, "Max {0} cached items")
        endIf
    endEvent
endState
