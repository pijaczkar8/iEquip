import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;
import skyui.components.list.BasicEnumeration;

import iEquip_uilib.ScrollingList;

import skyui.components.ButtonPanel;
import skyui.defines.Input;

import skyui.util.GlobalFunctions;
import skyui.util.Translator;
//import skyui.util.Debug;


class iEquip_uilib.iEquipQueueDialog extends MovieClip
{
  /* PRIVATE VARIABLES */

	private var defaultIndex_: Number;
	private var requestDataId_: Number;
	
	private var moveUpControls_: Object;
	private var moveDownControls_: Object;
	private var removeControls_: Object;
	private var clearControls_: Object;
	private var clearFlagControls_: Object;
	private var toggleListControls_: Object;
	private var exitControls_: Object;
	
	private var moveUpKey_: Number = -1;
	private var moveDownKey_: Number = -1;
	private var removeKey_: Number = -1;
	private var clearKey_: Number = -1;
	private var clearFlagKey_: Number = -1;
	private var toggleListKey_: Number = -1;
	private var exitKey_: Number = -1;

	private var removeControls_Y: Number;
	private var clearControls_Y: Number;
	private var titleText_Y: Number;

	private var isGamepad: Boolean;

  /* STAGE ELEMENTS */
	
	public var menuList: ScrollingList;
	public var titleTextField: TextField;
	public var ammoSortTextField: TextField;
	public var flagKeyTextField: TextField;
	public var moveUpButtonPanel: ButtonPanel;
	public var moveDownButtonPanel: ButtonPanel;
	public var removeButtonPanel: ButtonPanel;
	public var clearButtonPanel: ButtonPanel;
	public var clearFlagButtonPanel: ButtonPanel;
	public var toggleListButtonPanel: ButtonPanel;
	public var exitButtonPanel: ButtonPanel;
	
  /* PROPERTIES */
  	public var iconNameList: Array;
  	public var isEnchantedList: Array;
  	public var isPoisonedList: Array;

  	public var bDirectAccess: Boolean;
  	public var bHasBlacklist: Boolean;
  	public var bIsBlacklist: Boolean;
  	public var bIsAmmoList: Boolean;
  	public var sToggleListButtonLabel: String;
  
  
  /* INITIALIZATION */

	public function iEquipQueueDialog()
	{
		super();
		GlobalFunctions.addArrayFunctions();
	}
	
  /* PUBLIC FUNCTIONS */
	
	public function onLoad()
	{
		super.onLoad();
		
		// Initially hidden
		_visible = false;
		
		Mouse.addListener(this);
		Key.addListener(this);

		removeControls_Y = removeButtonPanel._y;
		clearControls_Y = clearButtonPanel._y;
		titleText_Y = titleTextField._y;

		ammoSortTextField.text = "";
		flagKeyTextField._visible = false;
		
		// SKSE functions not yet available and there's no InitExtensions...
		// This should do the trick.
		requestDataId_ = setInterval(this, "requestData", 1);
	}

	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{		
		var bHandledInput: Boolean;
		if (GlobalFunc.IsKeyPressed(details)) {
			bHandledInput = true;
			if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R2 || details.skseKeycode == 25) {
				onMoveUpPress();
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L2 || details.skseKeycode == 38) {
				onMoveDownPress();
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_X || details.skseKeycode == 19) {
				onRemovePress();
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_Y || details.skseKeycode == 20) {
				onClearPress();
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_A || details.skseKeycode == 33) {
				onClearFlagPress();
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R1 || details.skseKeycode == 48) {
				onToggleListPress();
			} else if (details.navEquivalent == NavigationCode.TAB) {
				onExitPress();
			} else {
				bHandledInput = false;
			}
		}
		
		if(bHandledInput) {
			GameDelegate.call("PlaySound", ["UIMenuOK"]);
			return bHandledInput;
		} else {
			var nextClip = pathToFocus.shift();
			if (nextClip.handleInput(details, pathToFocus)) {
				return true;
			}
		}
		
		return false;
	}
	
  /* PRIVATE FUNCTIONS */
  
	private function requestData(): Void
	{
		clearInterval(requestDataId_);
		
		skse.SendModEvent("iEquip_queueMenuOpen");		
	}

	private function setupButtons(platform: Number): Void
	{	
		
		if (platform == 0) {
			moveUpControls_ = {keyCode: 25}; //P
			moveDownControls_ = {keyCode: 38}; //L
			removeControls_ = {keyCode: 19}; //R
			clearControls_ = {keyCode: 20}; //T
			clearFlagControls_ = {keyCode: 33}; //F
			toggleListControls_ = {keyCode: 48}; //B
			exitControls_ = {keyCode: 15}; //Tab
		} else {
			moveUpControls_ = {keyCode: 281}; //Gamepad RT
			moveDownControls_ = {keyCode: 280}; //Gamepad LT
			removeControls_ = {keyCode: 278}; //Gamepad X
			clearControls_ = {keyCode: 279}; //Gamepad Y
			clearFlagControls_ = {keyCode: 276}; //Gamepad A
			toggleListControls_ = {keyCode: 275}; //Gamepad Right Shoulder
			exitControls_ = {keyCode: 277}; //Gamepad B
		}

		var remStr: String;
		var clrStr: String;
		var togStr: String;
		
		moveUpButtonPanel.clearButtons();
		moveDownButtonPanel.clearButtons();
		removeButtonPanel.clearButtons();
		clearButtonPanel.clearButtons();
		clearFlagButtonPanel.clearButtons();
		toggleListButtonPanel.clearButtons();
		exitButtonPanel.clearButtons();
		
		toggleListButtonPanel._visible = bHasBlacklist || bIsBlacklist;

		if (bIsBlacklist) {
			
			moveUpButtonPanel._visible = false;
			moveDownButtonPanel._visible = false;
			clearFlagButtonPanel._visible = false;
			removeButtonPanel._y = moveUpButtonPanel._y;
			clearButtonPanel._y = moveDownButtonPanel._y;
			remStr = "$iEquip_btn_removeFromList";
			clrStr = "$iEquip_btn_clearBlacklist";
			togStr = "$iEquip_btn_backToQueue";
		
		} else {
			
			moveUpButtonPanel._visible = true;
			moveDownButtonPanel._visible = true;
			clearFlagButtonPanel._visible = true;
			removeButtonPanel._y = removeControls_Y;
			clearButtonPanel._y = clearControls_Y;

			var moveUpButton = moveUpButtonPanel.addButton({text: "$iEquip_btn_moveUp", controls: moveUpControls_});
			moveUpButton.addEventListener("press", this, "onMoveUpPress");
			moveUpButtonPanel.updateButtons();

			var moveDownButton = moveDownButtonPanel.addButton({text: "$iEquip_btn_moveDown", controls: moveDownControls_});
			moveDownButton.addEventListener("press", this, "onMoveDownPress");
			moveDownButtonPanel.updateButtons();

			var clearFlagButton = clearFlagButtonPanel.addButton({text: "$iEquip_btn_clearFlag", controls: clearFlagControls_});
			clearFlagButton.addEventListener("press", this, "onClearFlagPress");
			clearFlagButtonPanel.updateButtons();
			
			remStr = "$iEquip_btn_removeFromQueue";
			clrStr = "$iEquip_btn_clearQueue";
			togStr = sToggleListButtonLabel;
		}
		
		var removeButton = removeButtonPanel.addButton({text: remStr, controls: removeControls_});
		removeButton.addEventListener("press", this, "onRemovePress");
		removeButtonPanel.updateButtons();

		if (bIsAmmoList) {
			clrStr = "$iEquip_btn_resetAmmoQueues"
		}
		
		var clearButton = clearButtonPanel.addButton({text: clrStr, controls: clearControls_});
		clearButton.addEventListener("press", this, "onClearPress");
		clearButtonPanel.updateButtons();

		if (bHasBlacklist || bIsBlacklist) {
			var toggleListButton = toggleListButtonPanel.addButton({text: togStr, controls: toggleListControls_});
			toggleListButton.addEventListener("press", this, "onToggleListPress");
			toggleListButtonPanel.updateButtons();
		}

		var exitButton;
		if (bDirectAccess) {
			exitButton = exitButtonPanel.addButton({text: "$iEquip_btn_exit", controls: exitControls_});
		} else {
			exitButton = exitButtonPanel.addButton({text: "$iEquip_btn_backToMenu", controls: exitControls_});
		}
		exitButton.addEventListener("press", this, "onExitPress");
		exitButtonPanel.updateButtons();
	}
	
	private function onMoveUpPress(): Void
	{
		if (!bIsBlacklist) {
			skse.SendModEvent("iEquip_queueMenuMoveUp", null, getActiveMenuIndex());
		}
	}

	private function onMoveDownPress(): Void
	{
		if (!bIsBlacklist) {
			skse.SendModEvent("iEquip_queueMenuMoveDown", null, getActiveMenuIndex());
		}
	}

	private function onRemovePress(): Void
	{
		skse.SendModEvent("iEquip_queueMenuRemove", null, getActiveMenuIndex());
	}

	private function onClearPress(): Void
	{
		skse.SendModEvent("iEquip_queueMenuClear", null);
		skse.CloseMenu("CustomMenu");
	}

	private function onClearFlagPress(): Void
	{
		var a_index = getActiveMenuIndex();
		var str = menuList.entryList[a_index].text
		var newStr:String;
		if (str.charAt(0) == "(" && str.charAt(2) == ")"){
			newStr = str.substring(4);
			menuList.entryList[a_index].text = newStr;
		}
		redrawList(a_index)
		skse.SendModEvent("iEquip_queueMenuClearFlag", null, a_index);
	}

	private function onToggleListPress(): Void
	{
		if (bIsBlacklist || bHasBlacklist) {
			skse.SendModEvent("iEquip_queueMenuToggleList", null);
			//skse.CloseMenu("CustomMenu");
		}
	}

	private function onExitPress(): Void
	{
		skse.SendModEvent("iEquip_queueMenuExit", null);
		skse.CloseMenu("CustomMenu");
	}

	private function onMenuListPress(a_event: Object): Void
	{
		var e = a_event.entry;
		if (e == undefined)
			return;
		
		menuList.listState.activeEntry = e;
		menuList.UpdateList();
	}
	
	private function setActiveMenuIndex(a_index: Number): Void
	{
		var e = menuList.entryList[a_index];
		menuList.listState.activeEntry = e;
		menuList.UpdateList();
	}
	
	private function getActiveMenuIndex(): Number
	{
		var index = menuList.listState.activeEntry.itemIndex;
		return (index != undefined ? index : -1);
	}
	
  /* PAPYRUS INTERFACE */

 	public function setButtons(directAccess: Boolean, hasBlacklist: Boolean, isBlacklist: Boolean, isAmmoList: Boolean, update: Boolean, toggleButtonLabel: String): Void
 	{
 		bDirectAccess = directAccess;
 		bHasBlacklist = hasBlacklist;
 		bIsBlacklist = isBlacklist;
 		bIsAmmoList = isAmmoList;
 		sToggleListButtonLabel = toggleButtonLabel;
 		if (update) {
	 		var platform: Number = 0;
	 		if (isGamepad) {
	 			platform = 1;
	 		}
	 		setupButtons(platform);
	 	}
 	}

 	// Only called if we're switching between views in an ammo queue
 	public function updateHeader(): Void
 	{
 		if (bIsBlacklist) {
			titleTextField._y = titleText_Y;
		} else {
			titleTextField._y = titleText_Y - 10;
		}
 	}
  
	public function setPlatform(platform: Number): Void
	{
		isGamepad = platform != 0;
		
		moveUpKey_ = GlobalFunctions.getMappedKey("Right Attack/Block", Input.CONTEXT_GAMEPLAY, isGamepad);
		moveDownKey_ = GlobalFunctions.getMappedKey("Left Attack/Block", Input.CONTEXT_GAMEPLAY, isGamepad);
		removeKey_ = GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, isGamepad);
		clearKey_ = GlobalFunctions.getMappedKey("Jump", Input.CONTEXT_GAMEPLAY, isGamepad);
		clearFlagKey_ = GlobalFunctions.getMappedKey("Activate", Input.CONTEXT_GAMEPLAY, isGamepad);
		toggleListControls_ = {keyCode: 275}; //Gamepad Right Shoulder
		exitKey_ = GlobalFunctions.getMappedKey("Tween Menu", Input.CONTEXT_GAMEPLAY, isGamepad);
		
		moveUpButtonPanel.setPlatform(platform, false);
		moveDownButtonPanel.setPlatform(platform, false);
		removeButtonPanel.setPlatform(platform, false);
		clearButtonPanel.setPlatform(platform, false);
		clearFlagButtonPanel.setPlatform(platform, false);
		toggleListButtonPanel.setPlatform(platform, false);
		exitButtonPanel.setPlatform(platform, false);
		setupButtons(platform);
	}
	
	public function initIconNameList(/* values */): Void
	{
			iconNameList.length = 0;
			iconNameList = ["Empty"];

			for (var i=0; i<arguments.length; i++) {
			var iconName = arguments[i];
			
			// Cut off rest of the buffer once the first emtpy string was found
			if (iconName.toLowerCase() == "none" || iconName == "")
				break;
				
			iconNameList.push(iconName);
			}
	}

	public function initIsEnchantedList(/* values */): Void
	{
			isEnchantedList.length = 0;
			isEnchantedList = ["Empty"];

			for (var i=0; i<arguments.length; i++) {
				isEnchantedList.push(arguments[i]);
			}
	}

	public function initIsPoisonedList(/* values */): Void
	{
			isPoisonedList.length = 0;
			isPoisonedList = ["Empty"];

			for (var i=0; i<arguments.length; i++) {
				isPoisonedList.push(arguments[i]);
			}
	}

	public function initListData(/* values */): Void
	{
		// List setup stuff
		menuList.addEventListener("itemPress", this, "onMenuListPress");
		menuList.listEnumeration = new BasicEnumeration(menuList.entryList);
		
		// Get options and translate them
		var menuOptions = [];
		
		for (var i=0; i<arguments.length; i++) {
			var s = arguments[i];
			
			// Cut off rest of the buffer once the first emtpy string was found
			if (s.toLowerCase() == "none" || s == "")
				break;
				
			menuOptions.push(Translator.translateNested(s));
		}
		// Put options into list
		for (var i=0; i<menuOptions.length; i++) {
			var entry = {text: menuOptions[i], align: "left", enabled: true, iconName: iconNameList[i+1], isEnchanted: isEnchantedList[i+1], isPoisoned: isPoisonedList[i+1], state: "normal"};
			menuList.entryList.push(entry);
		}
	}

	public function initListParams(titleText: String, ammoSortingText: String, startIndex: Number, defaultIndex: Number): Void
	{
		// Title text
		titleTextField.textAutoSize = "shrink";
		titleText = Translator.translateNested(titleText);
		titleTextField.SetText(titleText);

		if (bIsAmmoList) {
			titleTextField._y = titleText_Y - 10;
		} else {
			titleTextField._y = titleText_Y;
		}

		// Ammo Sorting Text
		if (ammoSortingText != undefined && ammoSortingText != "") {
			ammoSortTextField.text = ammoSortingText;
		}

		if (!bIsAmmoList && !bIsBlacklist){
			flagKeyTextField._visible = true;
		}
		
		// Store default index
		defaultIndex_ = defaultIndex;
		
		// Select initial index
		var e = menuList.entryList[startIndex];
		menuList.listState.activeEntry = e;
		menuList.selectedIndex = startIndex;

		// Redraw
		menuList.InvalidateData();

		// Focus
		FocusHandler.instance.setFocus(menuList, 0);
		
		// And show the menu
		_visible = true;
	}

	public function refreshList(/* values */): Void
	{	
		// Get options and translate them
		var menuOptions = [];
		
		for (var i=0; i<arguments.length; i++) {
			var s = arguments[i];
			
			// Cut off rest of the buffer once the first emtpy string was found
			if (s.toLowerCase() == "none" || s == "")
				break;
				
			menuOptions.push(Translator.translateNested(s));
		}
		// Clear previous list
		menuList._visible = false
		menuList.clearList()
		// Put options into list
		for (var i=0; i<menuOptions.length; i++) {
			var entry = {text: menuOptions[i], align: "center", enabled: true, iconName: iconNameList[i+1], isEnchanted: isEnchantedList[i+1], isPoisoned: isPoisonedList[i+1], state: "normal"};
			menuList.entryList.push(entry);
		}
	}

	public function redrawList(index: Number): Void
	{	
		// Set selected index
		var e = menuList.entryList[index];
		menuList.listState.activeEntry = e;
		menuList.selectedIndex = index;

		// Redraw
		menuList.InvalidateData();
		menuList._visible = true

		// Focus
		FocusHandler.instance.setFocus(menuList, 0);
	}

	public function confirmClear(): Void
	{
		menuList.clearList()
		menuList.InvalidateData();
	}

	public function closeQueueMenu(): Void
	{
		skse.CloseMenu("CustomMenu");
	}
}