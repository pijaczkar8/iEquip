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


class iEquip_uilib.iEquipQueueDialog extends MovieClip
{
  /* PRIVATE VARIABLES */

	private var defaultIndex_: Number;
	private var requestDataId_: Number;
	
	private var moveUpControls_: Object;
	private var moveDownControls_: Object;
	private var removeControls_: Object;
	private var clearControls_: Object;
	private var exitControls_: Object;
	
	private var moveUpKey_: Number = -1;
	private var moveDownKey_: Number = -1;
	private var removeKey_: Number = -1;
	private var clearKey_: Number = -1;
	private var exitKey_: Number = -1;

  /* STAGE ELEMENTS */
	
	public var menuList: ScrollingList;
	public var titleTextField: TextField;
	public var moveUpButtonPanel: ButtonPanel;
	public var moveDownButtonPanel: ButtonPanel;
	public var removeButtonPanel: ButtonPanel;
	public var clearButtonPanel: ButtonPanel;
	public var exitButtonPanel: ButtonPanel;
	
  /* PROPERTIES */
  	public var iconNameList: Array;
  	public var isEnchantedList: Array;
  	public var isPoisonedList: Array;
  
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
		
		// SKSE functions not yet available and there's no InitExtensions...
		// This should do the trick.
		requestDataId_ = setInterval(this, "requestData", 1);
	}

	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{		
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if(details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R2 || details.skseKeycode == 25) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onMoveUpPress();
				bHandledInput = true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L2 || details.skseKeycode == 38) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onMoveDownPress();
				bHandledInput = true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_X || details.skseKeycode == 19) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onRemovePress();
				bHandledInput = true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_Y || details.skseKeycode == 20) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onClearPress();
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.TAB) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onExitPress();
				bHandledInput = true;
			}
		}
		
		if(bHandledInput) {
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
			exitControls_ = {keyCode: 15}; //Tab
		} else {
			moveUpControls_ = {keyCode: 281}; //Gamepad RT
			moveDownControls_ = {keyCode: 280}; //Gamepad LT
			removeControls_ = {keyCode: 278}; //Gamepad X
			clearControls_ = {keyCode: 279}; //Gamepad Y
			exitControls_ = {keyCode: 277}; //Gamepad B
		}
		
		moveUpButtonPanel.clearButtons();
		var moveUpButton = moveUpButtonPanel.addButton({text: "Move up", controls: moveUpControls_});
		moveUpButton.addEventListener("press", this, "onMoveUpPress");
		moveUpButtonPanel.updateButtons();

		moveDownButtonPanel.clearButtons();
		var moveDownButton = moveDownButtonPanel.addButton({text: "Move down", controls: moveDownControls_});
		moveDownButton.addEventListener("press", this, "onMoveDownPress");
		moveDownButtonPanel.updateButtons();
				
		removeButtonPanel.clearButtons();
		var removeButton = removeButtonPanel.addButton({text: "Remove from queue", controls: removeControls_});
		removeButton.addEventListener("press", this, "onRemovePress");
		removeButtonPanel.updateButtons();

		clearButtonPanel.clearButtons();
		var clearButton = clearButtonPanel.addButton({text: "Clear queue", controls: clearControls_});
		clearButton.addEventListener("press", this, "onClearPress");
		clearButtonPanel.updateButtons();

		exitButtonPanel.clearButtons();
		var exitButton = exitButtonPanel.addButton({text: "Back to menu", controls: exitControls_});
		exitButton.addEventListener("press", this, "onExitPress");
		exitButtonPanel.updateButtons();
	}
	
	private function onMoveUpPress(): Void
	{
		skse.SendModEvent("iEquip_queueMenuMoveUp", null, getActiveMenuIndex());
	}

	private function onMoveDownPress(): Void
	{
		skse.SendModEvent("iEquip_queueMenuMoveDown", null, getActiveMenuIndex());
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
  
	public function setPlatform(platform: Number): Void
	{
		var isGamepad = platform != 0;
		
		moveUpKey_ = GlobalFunctions.getMappedKey("Right Attack/Block", Input.CONTEXT_GAMEPLAY, isGamepad);
		moveDownKey_ = GlobalFunctions.getMappedKey("Left Attack/Block", Input.CONTEXT_GAMEPLAY, isGamepad);
		removeKey_ = GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, isGamepad);
		clearKey_ = GlobalFunctions.getMappedKey("Jump", Input.CONTEXT_GAMEPLAY, isGamepad);
		exitKey_ = GlobalFunctions.getMappedKey("Tween Menu", Input.CONTEXT_GAMEPLAY, isGamepad);
		
		moveUpButtonPanel.setPlatform(platform, false);
		moveDownButtonPanel.setPlatform(platform, false);
		removeButtonPanel.setPlatform(platform, false);
		clearButtonPanel.setPlatform(platform, false);
		exitButtonPanel.setPlatform(platform, false);
		setupButtons(platform);
	}
	
	public function initIconNameList(iconName: String): Void
	{
			if (iconNameList == null || iconNameList.length == 0){
				iconNameList = ["Empty"]
				iconNameList[0] = iconName
				return;
			}
			iconNameList.push(iconName);
	}

	public function initIsEnchantedList(bIsEnchanted: Boolean): Void
	{
			if (isEnchantedList == null || isEnchantedList.length == 0){
				isEnchantedList = ["Empty"]
				isEnchantedList[0] = bIsEnchanted
				return;
			}
			isEnchantedList.push(bIsEnchanted);
	}

	public function initIsPoisonedList(bIsPoisoned: Boolean): Void
	{
			if (isPoisonedList == null || isPoisonedList.length == 0){
				isPoisonedList = ["Empty"]
				isPoisonedList[0] = bIsPoisoned
				return;
			}
			isPoisonedList.push(bIsPoisoned);
	}

	public function clearIconLists(): Void
	{
			iconNameList.length = 0
			isEnchantedList.length = 0
			isPoisonedList.length = 0
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
			var entry = {text: menuOptions[i], align: "left", enabled: true, iconName: iconNameList[i], isEnchanted: isEnchantedList[i], isPoisoned: isPoisonedList[i], state: "normal"};
			menuList.entryList.push(entry);
		}
	}

	public function initListParams(titleText: String, startIndex: Number, defaultIndex: Number): Void
	{
		// Title text
		titleTextField.textAutoSize = "shrink";
		titleText = Translator.translateNested(titleText);
		titleTextField.SetText(titleText);
		
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
			var entry = {text: menuOptions[i], align: "center", enabled: true, iconName: iconNameList[i], isEnchanted: isEnchantedList[i], isPoisoned: isPoisonedList[i], state: "normal"};
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