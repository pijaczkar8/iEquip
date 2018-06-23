ScriptName iEquip_KeyHandler extends SKI_QuestBase
;This script sets up and handles all the key assignments and keypress actions

iEquip_EditMode Property EM Auto
iEquip_WidgetCore Property WC Auto
iEquip_MCM Property MCM Auto

Int WaitingKeyCode = 0
Int iMultiTap = 0

Bool Property WidgetVisTogglesHotkey = True Auto

Float Property iEquip_LongPressDelay = 0.5 Auto
Float Property iEquip_ExtraLongPressDelay = 1.0 Auto
Float Property iEquip_MultiTapDelay = 0.3 Auto

;Main gameplay keys
Int Property iEquip_shoutKey = 45 Auto ;X
Int Property iEquip_potionKey = 21 Auto ;Y
Int Property iEquip_leftKey = 47 Auto ;V
Int Property iEquip_rightKey = 48 Auto ;B
;Int Property iEquip_poisonKey =  Auto ;
;Int Property iEquip_ammoKey =  Auto ;

;Edit Mode Keys
Int Property iEquip_editmodeKey = 69 Auto ;NumLock - Active in all modes
Int Property iEquip_EditNextKey = 55 Auto ;Num *
Int Property iEquip_EditPrevKey = 181 Auto ;Num /
Int Property iEquip_EditUpKey = 200 Auto ;Up arrow
Int Property iEquip_EditDownKey = 208 Auto ;Down arrow
Int Property iEquip_EditRightKey = 205 Auto ;Right arrow
Int Property iEquip_EditLeftKey = 203 Auto ;Left arrow
Int Property iEquip_EditScaleUpKey = 78 Auto ;Num +
Int Property iEquip_EditScaleDownKey = 74 Auto ;Num -
Int Property iEquip_EditDepthKey  = 72 Auto ;Num 8
Int Property iEquip_EditRotateKey  = 79 Auto ;Num 1
Int Property iEquip_EditTextKey = 80 Auto ;Num 2
Int Property iEquip_EditAlphaKey = 81 Auto ;Num 3
Int Property iEquip_EditRulersKey = 75 Auto ;Num 4
Int Property iEquip_EditResetKey = 82 Auto ;Num 0
Int Property iEquip_EditLoadPresetKey = 76 Auto ;Num 5
Int Property iEquip_EditSavePresetKey = 77 Auto ;Num 6
Int Property iEquip_EditDiscardKey = 83 Auto ;Num .

Event OnKeyUp(Int KeyCode, Float HoldTime)
	Debug.Trace("iEquip KeyHandler OnKeyUp called")
	if utility.IsInMenuMode()
		return 
	endIf
	
	If HoldTime > iEquip_ExtraLongPressDelay ;If key held for more than two seconds
		DoExtraLongPressActions(KeyCode)
		return

	elseIf HoldTime < iEquip_LongPressDelay	;If not longpress.
		If EM.isEditMode && KeyCode != iEquip_EditRotateKey && KeyCode != iEquip_EditAlphaKey && KeyCode != iEquip_EditRulersKey;If in Edit Mode bypass the multitap listener except for the three keys which require it
			DoSingleTapActions(KeyCode)
			return ;Return out here as we don't need anything else and avoids Edit Mode loop on exiting Edit Mode
		elseIf WaitingKeyCode != 0 && KeyCode != WaitingKeyCode	  ;The player pressed a different key, so force the current one to process if there is one
			;Stop the previous registration.
			UnregisterForUpdate()
			;Fully process the last key pressed.
			OnUpdate()
		endIf
		If iMultiTap == 0		;This is the first time the key has been pressed.
			WaitingKeyCode = KeyCode
			iMultiTap = 1
			self.RegisterForSingleUpdate(iEquip_MultiTapDelay) ;Tell the update function a key has been pressed.
		ElseIf iMultiTap == 1		;This is the second time the key has been pressed
			iMultiTap = 2
			self.RegisterForSingleUpdate(iEquip_MultiTapDelay) ;Reset the update function so we can wait and make sure it's not a triple tap.
		ElseIf iMultiTap == 2		;This is the third time the key has been pressed
			iMultiTap = 3
			RegisterForSingleUpdate(0.01)	;Basically, force update to immediately. No need to wait for more multi-taps.
		EndIf
	Else
		WaitingKeyCode = KeyCode
		iMultiTap = -1	;Use -1 for long-press.
		RegisterForSingleUpdate(0.01)		;Basically, update immediately for long-press. No need to wait for multi-tap.
	EndIf
EndEvent

Event OnUpdate()
	Debug.Trace("iEquip KeyHandler OnUpdate called")
	If iMultiTap == 0	;There's nothing to process. Check this first to get out as fast as possible.
		Return
	ElseIf iMultiTap == -1	;Long press
		DoLongPressActions(WaitingKeyCode)
	ElseIf iMultiTap == 1  ;Single tap
		DoSingleTapActions(WaitingKeyCode)
	ElseIf iMultiTap == 2  ; Double tap
		DoDoubleTapActions(WaitingKeyCode)
	ElseIf iMultiTap == 3  ;Triple tap
		DoTripleTapActions(WaitingKeyCode)
	Else
		;Somehow, we're updating without any of the above being true, so throw an error.
		;
	EndIf
	WaitingKeyCode = 0
	iMultiTap = 0
EndEvent

Function DoSingleTapActions(Int KeyCode)
	Debug.Trace("iEquip KeyHandler DoSingleTapActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	
	int[] args
	
	if KeyCode == iEquip_editmodeKey
		int mode = 1 ;Edit Mode
		ToggleMode(mode)
	
	;Handle Edit Mode Keys only if in Edit Mode
	elseIf EM.isEditMode
		if KeyCode == iEquip_EditLeftKey
			EM.MoveLeft()
		elseIf KeyCode == iEquip_EditRightKey
			EM.MoveRight()
		elseIf KeyCode == iEquip_EditUpKey
			EM.MoveUp()
		elseIf KeyCode == iEquip_EditDownKey
			EM.MoveDown()
		elseIf KeyCode == iEquip_EditScaleUpKey
			EM.ScaleUp()
		elseIf KeyCode == iEquip_EditScaleDownKey
			EM.ScaleDown()
		elseIf KeyCode == iEquip_EditRotateKey
			EM.Rotate()
		elseIf KeyCode == iEquip_EditAlphaKey
			EM.SetAlpha()
		elseIf KeyCode == iEquip_EditDepthKey
			if EM.BringToFrontEnabled
				EM.BringToFront()
			else
				debug.messagebox("Bring To Front is currently disabled in the MCM\n\nIf you want to be able to change layer order for overlapping widget elements turn Bring To Front on first")
			endIf
		elseIf KeyCode == iEquip_EditTextKey
			int iIndex = EM.SelectedItem - 1
			if EM.isTextElement(iIndex)
				EM.SetTextAlignment()
			endIf
		elseIf KeyCode == iEquip_EditNextKey
			EM.cycleEditModeElements(1)
		elseIf KeyCode == iEquip_EditPrevKey
			EM.cycleEditModeElements(0)
		elseIf KeyCode == iEquip_EditResetKey
			EM.ResetItem()
		elseIf KeyCode == iEquip_EditLoadPresetKey
			EM.showEMPresetListMenu()
		elseIf KeyCode == iEquip_EditSavePresetKey
			EM.showEMTextInputMenu(0)
		elseIf KeyCode == iEquip_EditRulersKey
			EM.ToggleRulers()
		elseIf KeyCode == iEquip_EditDiscardKey
			EM.DiscardChanges()
		endIf

	elseIf KeyCode == iEquip_shoutKey
		if (WidgetVisTogglesHotkey && WC.abWidget_V[1]) || !WidgetVisTogglesHotkey
    		MCM.cyclePower()
	        args = MCM.GetItemIconArgs(2)
	        WC.setItemData(MCM.getCurrQItemName(2), args)
	        WC.shoutIndex = MCM._currQIndices[2]
	    endIf
		
	elseIf KeyCode == iEquip_leftKey
		if (WidgetVisTogglesHotkey && WC.abWidget_V[2]) || !WidgetVisTogglesHotkey
	        MCM.cycleHand(0)
	        args = MCM.GetItemIconArgs(0)
	        WC.setItemData(MCM.getCurrQItemName(0), args)
	        WC.leftIndex = MCM._currQIndices[0]
	    endIf

	elseIf KeyCode == iEquip_rightKey
		if (WidgetVisTogglesHotkey && WC.abWidget_V[3]) || !WidgetVisTogglesHotkey
	        MCM.cycleHand(1)
	        args = MCM.GetItemIconArgs(1)
	        WC.setItemData(MCM.getCurrQItemName(1), args)
	        WC.rightIndex = MCM._currQIndices[1]
		endIf

	elseIf KeyCode == iEquip_potionKey
		if (WidgetVisTogglesHotkey && WC.abWidget_V[4]) || !WidgetVisTogglesHotkey
			MCM.cyclePotion()
	        args = MCM.GetItemIconArgs(3)
	        WC.setItemData(MCM.getCurrQItemName(3), args)
	        WC.potionIndex = MCM._currQIndices[3]
    	endIf

	EndIf
    if(args[0])
        MCM.itemDataUpToDate[args[0]*MCM.MAX_QUEUE_SIZE + args[1]] = true
    endIf
	GotoState("")
EndFunction

Function DoDoubleTapActions(Int KeyCode)
	Debug.Trace("iEquip KeyHandler DoDoubleTapActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	
	;/if KeyCode == iEquip_editmodeKey
		int mode = 3 ;Assignment Mode
		ToggleMode(mode)
	endIf/;
	
	If EM.isEditMode
		If KeyCode == iEquip_EditRotateKey
			EM.ToggleRotateDirection()
		elseIf KeyCode == iEquip_EditAlphaKey
			EM.SetVisibility()
		elseIf KeyCode == iEquip_EditRulersKey
			EM.initColorPicker(1) ;Current item info color
		endIf
	endIf
	
	GotoState("")
EndFunction

Function DoTripleTapActions(Int KeyCode)
	Debug.Trace("iEquip KeyHandler DoTripleTapActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	
	GotoState("")
EndFunction

Function DoLongPressActions(Int KeyCode)
	Debug.Trace("iEquip KeyHandler DoLongPressActions called on " + KeyCode as String)
	GotoState("PROCESSING")
	;/if KeyCode == iEquip_potionKey
		useEquippedItem()
		
	if KeyCode == iEquip_editmodeKey
		int mode = 2 ;Preselect Mode
		ToggleMode(mode)
	endIf/;
	
	If EM.isEditMode
		If KeyCode == iEquip_EditLeftKey || KeyCode == iEquip_EditRightKey || KeyCode == iEquip_EditUpKey || KeyCode == iEquip_EditDownKey || KeyCode == iEquip_EditScaleUpKey || KeyCode == iEquip_EditScaleDownKey
			EM.ToggleStep(0)
		elseIf KeyCode == iEquip_EditRotateKey
			EM.ToggleStep(1)
		elseIf KeyCode == iEquip_EditAlphaKey
			EM.ToggleStep(2)
		elseIf KeyCode == iEquip_EditTextKey
			int iIndex = EM.SelectedItem - 1
			if EM.isTextElement(iIndex)
				EM.initColorPicker(2) ;Text color
			endIf
		elseIf KeyCode == iEquip_EditRulersKey
			EM.initColorPicker(0) ;Highlight color
		endIf
	endIf

	;/if(ASSIGNMENT_MODE)
    elseIf KeyCode == assignLeftKey
        MCM.AssignCurrEquippedItem(0)
        args = MCM.GetItemIconArgs(0)
		WC.setItemData(_leftHandQueue[MCM._currQIndices[0]].GetName(), args)
        MCM.leftIndex = MCM._currQIndices[0]

    elseIf KeyCode == assignRightKey
        MCM.AssignCurrEquippedItem(1)
        args = MCM.GetItemIconArgs(1)
		WC.setItemData(MCM._rightHandQueue[MCM._currQIndices[1]].GetName(), args)
        MCM.rightIndex = MCM._currQIndices[1]

    elseIf KeyCode == assignShoutKey
        MCM.AssignCurrEquippedItem(2)
        args = MCM.GetItemIconArgs(2)
		WC.setItemData(MCM._shoutQueue[MCM._currQIndices[2]].GetName(), args)
        MCM.shoutIndex = MCM._currQIndices[2]/;
	GotoState("")
EndFunction

Function DoExtraLongPressActions(Int KeyCode)
	Debug.Trace("iEquip KeyHandler DoLongPressActions called on " + KeyCode as String)
	GotoState("PROCESSING")

	GotoState("")
EndFunction


function ToggleMode(int mode)
	Debug.Trace("iEquip KeyHandler ToggleMode called")
	if mode == 1
		if !EM.isEditMode
			UnregisterForGameplayKeys()
			RegisterForEditModeKeys()
		else
			UnregisterForEditModeKeys()
			RegisterForGameplayKeys()
		endIf
		EM.ToggleEditMode()
	;/elseIf mode == 2
		if EM.isEditMode
			debug.notification("Please exit Edit Mode before attempting to toggle Preselect Mode")
			return
		endIf
		TogglePreselectMode()
	elseIf mode == 3
		if EM.isEditMode
			debug.notification("Please exit Edit Mode before attempting to toggle Assignment Mode")
			return
		endIf
		ToggleAssignmentMode()/;
	endIf
endFunction

function RegisterForGameplayKeys()
	Debug.Trace("iEquip KeyHandler RegisterForGameplayKeys called")
	RegisterForKey(iEquip_shoutKey)
	RegisterForKey(iEquip_leftKey)
	RegisterForKey(iEquip_rightKey)
	RegisterForKey(iEquip_potionKey)
	RegisterForKey(iEquip_editmodeKey)
EndFunction

function UnregisterForGameplayKeys()
	Debug.Trace("iEquip KeyHandler UnregisterForGameplayKeys called")
	UnregisterForKey(iEquip_shoutKey)
	UnregisterForKey(iEquip_potionKey)
	UnregisterForKey(iEquip_leftKey)
	UnregisterForKey(iEquip_rightKey)
	UnregisterForKey(iEquip_editmodeKey)
EndFunction

function RegisterForEditModeKeys()
	Debug.Trace("iEquip KeyHandler RegisterForEditModeKeys called")
	RegisterForKey(iEquip_EditLeftKey)
	RegisterForKey(iEquip_EditRightKey)
	RegisterForKey(iEquip_EditUpKey)
	RegisterForKey(iEquip_EditDownKey)
	RegisterForKey(iEquip_EditScaleUpKey)
	RegisterForKey(iEquip_EditScaleDownKey)
	RegisterForKey(iEquip_EditNextKey)
	RegisterForKey(iEquip_EditPrevKey)
	RegisterForKey(iEquip_EditResetKey)
	RegisterForKey(iEquip_EditLoadPresetKey)
	RegisterForKey(iEquip_EditSavePresetKey)
	RegisterForKey(iEquip_EditRotateKey)
	RegisterForKey(iEquip_EditDepthKey)
	RegisterForKey(iEquip_EditAlphaKey)
	RegisterForKey(iEquip_EditTextKey)
	RegisterForKey(iEquip_EditRulersKey)
	RegisterForKey(iEquip_EditDiscardKey)
	RegisterForKey(iEquip_editmodeKey)
endFunction

function UnregisterForEditModeKeys()
	Debug.Trace("iEquip KeyHandler UnregisterForEditModeKeys called")
	UnregisterForKey(iEquip_EditLeftKey)
	UnregisterForKey(iEquip_EditRightKey)
	UnregisterForKey(iEquip_EditUpKey)
	UnregisterForKey(iEquip_EditDownKey)
	UnregisterForKey(iEquip_EditScaleUpKey)
	UnregisterForKey(iEquip_EditScaleDownKey)
	UnregisterForKey(iEquip_EditNextKey)
	UnregisterForKey(iEquip_EditPrevKey)
	UnregisterForKey(iEquip_EditResetKey)
	UnregisterForKey(iEquip_EditLoadPresetKey)
	UnregisterForKey(iEquip_EditSavePresetKey)
	UnregisterForKey(iEquip_EditRotateKey)
	UnregisterForKey(iEquip_EditDepthKey)
	UnregisterForKey(iEquip_EditAlphaKey)
	UnregisterForKey(iEquip_EditTextKey)
	UnregisterForKey(iEquip_EditRulersKey)
	UnregisterForKey(iEquip_EditDiscardKey)
	UnRegisterForKey(iEquip_editmodeKey)
endFunction

;Disallow keys and group usage while processing
state PROCESSING	
	event OnKeyDown(int a_keyCode)
	endEvent
	
	event OnKeyUp(int a_keyCode, float HoldTime)
	endEvent
endState
