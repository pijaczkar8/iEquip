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


class iEquip_uilib.iEquipListDialog extends MovieClip
{
  /* PRIVATE VARIABLES */

	private var defaultIndex_: Number;
	private var requestDataId_: Number;
	
	private var cancelControls_: Object;
	private var deleteControls_: Object;
	private var loadControls_: Object;
	
	private var cancelKey_: Number = -1;
	private var deleteKey_: Number = -1;
	private var loadKey_: Number = -1;

  /* STAGE ELEMENTS */
	
	public var menuList: ScrollingList;
	public var titleTextField: TextField;
	public var cancelButtonPanel: ButtonPanel;
	public var deleteButtonPanel: ButtonPanel;
	public var loadButtonPanel: ButtonPanel;
	
  /* PROPERTIES */
  
  /* INITIALIZATION */

	public function iEquipListDialog()
	{
		super();
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
			if(details.navEquivalent == NavigationCode.TAB) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onCancelPress();
				bHandledInput = true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_X || details.skseKeycode == 19) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onDeletePress();
				bHandledInput = true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.ENTER) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onLoadPress();
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
		
		skse.SendModEvent("iEquip_listMenuOpen");		
	}

	private function setupButtons(platform: Number): Void
	{		
		deleteControls_ = Input.ReadyWeapon;
	
		if (platform == 0) {
			cancelControls_ = Input.Tab;
		} else {
			cancelControls_ = Input.Cancel;
		}
		
		if (platform == 0) {
			loadControls_ = Input.Enter;
		} else {
			loadControls_ = Input.Accept;
		}
		
		cancelButtonPanel.clearButtons();
		var cancelButton = cancelButtonPanel.addButton({text: "Cancel", controls: cancelControls_});
		cancelButton.addEventListener("press", this, "onCancelPress");
		cancelButtonPanel.updateButtons();
		
		deleteButtonPanel.clearButtons();
		var deleteButton = deleteButtonPanel.addButton({text: "Delete Preset", controls: deleteControls_});
		deleteButton.addEventListener("press", this, "onDeletePress");
		deleteButtonPanel.updateButtons();
		
		loadButtonPanel.clearButtons();
		var loadButton = loadButtonPanel.addButton({text: "Load Preset", controls: loadControls_});
		loadButton.addEventListener("press", this, "onLoadPress");
		loadButtonPanel.updateButtons();
	}
	
	private function onCancelPress(): Void
	{
		skse.SendModEvent("iEquip_listMenuCancel", null);
		skse.CloseMenu("CustomMenu");
	}

	private function onLoadPress(): Void
	{
		skse.SendModEvent("iEquip_listMenuLoad", null, getActiveMenuIndex());
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
  
	private function onDeletePress(): Void
	{
		skse.SendModEvent("iEquip_listMenuDeletePreset", null, getActiveMenuIndex());
		skse.CloseMenu("CustomMenu");
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
		
		cancelKey_ = GlobalFunctions.getMappedKey("Tween Menu", Input.CONTEXT_GAMEPLAY, isGamepad);
		deleteKey_ = GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, isGamepad);
		loadKey_ = GlobalFunctions.getMappedKey("Activate", Input.CONTEXT_GAMEPLAY, isGamepad);
		
		cancelButtonPanel.setPlatform(platform, false);
		deleteButtonPanel.setPlatform(platform, false);
		loadButtonPanel.setPlatform(platform, false);
		setupButtons(platform);
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
			var entry = {text: menuOptions[i], align: "center", enabled: true, state: "normal"};
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
	
	public function confirmDelete(): Void
	{
		skse.CloseMenu("CustomMenu");
	}
}