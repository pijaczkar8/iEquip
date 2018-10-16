import iEquip_uilib.ColorSwatch;

import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

import skyui.components.ButtonPanel;
import skyui.defines.Input;

import skyui.util.GlobalFunctions;
import skyui.util.Translator;

class iEquip_uilib.iEquipColorDialog extends MovieClip
{	
  /* PRIVATE VARIABLES */

  	private var requestDataId_: Number;
	private var startColor: Number;
	private var cancelControls_: Object;
	private var defaultControls_: Object;
	private var customControls_: Object;
	private var acceptControls_: Object;

  /* STAGE ELEMENTS */
	
	public var colorSwatch: ColorSwatch;
	public var titleTextField: TextField;
	public var cancelButtonPanel: ButtonPanel;
	public var defaultButtonPanel: ButtonPanel;
	public var customButtonPanel: ButtonPanel;
	public var acceptButtonPanel: ButtonPanel;
	
  /* PROPERTIES */
	
	public var currentColor_: Number = 0xFFFFFF;
	public var defaultColor_: Number = 0xFFFFFF;
	
  /* INITIALIZATION */
  
	public function iEquipColorDialog()
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
  
	// Private Functions

	private function requestData(): Void
	{
		clearInterval(requestDataId_);
		
		skse.SendModEvent("iEquip_colorMenuOpen");		
	}
	
	private function setupButtons(platform: Number): Void
	{	
		if (platform == 0) {
			acceptControls_ = {keyCode: 28}; //Enter
			cancelControls_ = {keyCode: 15}; //Tab
			customControls_ = {keyCode: 20}; //T
			defaultControls_ = {keyCode: 19}; //R
		} else {
			acceptControls_ = {keyCode: 276}; //Gamepad A
			cancelControls_ = {keyCode: 277}; //Gamepad B
			customControls_ = {keyCode: 279}; //Gamepad Y
			defaultControls_ = {keyCode: 278}; //Gamepad X
		}
		
		cancelButtonPanel.clearButtons();
		var cancelButton = cancelButtonPanel.addButton({text: "Cancel", controls: cancelControls_});
		cancelButton.addEventListener("press", this, "onCancelPress");
		cancelButtonPanel.updateButtons();
		
		defaultButtonPanel.clearButtons();
		if (startColor > 27){
			var defaultButton = defaultButtonPanel.addButton({text: "Delete", controls: defaultControls_});
			defaultButton.addEventListener("press", this, "onDeletePress");
		} else {
			var defaultButton = defaultButtonPanel.addButton({text: "Default", controls: defaultControls_});
			defaultButton.addEventListener("press", this, "onDefaultPress");
		}
		defaultButtonPanel.updateButtons();

		customButtonPanel.clearButtons();
		var customButton = customButtonPanel.addButton({text: "Custom", controls: customControls_});
		customButton.addEventListener("press", this, "onCustomPress");
		customButtonPanel.updateButtons();
		
		acceptButtonPanel.clearButtons();
		var acceptButton = acceptButtonPanel.addButton({text: "Select", controls: acceptControls_});
		acceptButton.addEventListener("press", this, "onAcceptPress");
		acceptButtonPanel.updateButtons();
	}

	public function updateDefaultButtonLabel(): Void
	{
		defaultButtonPanel.clearButtons();
		if (colorSwatch.newIndex > 27){
			var defaultButton = defaultButtonPanel.addButton({text: "Delete", controls: defaultControls_});
			defaultButton.addEventListener("press", this, "onDeletePress");
		} else {
			var defaultButton = defaultButtonPanel.addButton({text: "Default", controls: defaultControls_});
			defaultButton.addEventListener("press", this, "onDefaultPress");
		}
		defaultButtonPanel.updateButtons();
	}

	public function setCustomColorListValues(iValue: Number): Void
	{
		if (colorSwatch.customColorList == null || colorSwatch.customColorList.length == 0){
				colorSwatch.customColorList = [-1]
				colorSwatch.customColorList[0] = iValue
				return;
			}
			colorSwatch.customColorList.push(iValue);
	}

	public function initColorDialogParams(titleText: String, currentColor: Number, defaultColor: Number): Void
	{
		colorSwatch.createColorSwatch();		

		colorSwatch._x = -colorSwatch._width/2;
		colorSwatch._y = -colorSwatch._height/2;
		
		// Title text
		titleTextField.textAutoSize = "shrink";
		titleText = Translator.translateNested(titleText);
		titleTextField.SetText(titleText);
		
		// Store default color
		defaultColor_ = defaultColor;

		// Store opening color
		currentColor_ = currentColor;
		
		// Select initial color
		colorSwatch.selectedColor = currentColor;
		startColor = colorSwatch.colorList.indexOf(currentColor);

		// Focus
		FocusHandler.instance.setFocus(colorSwatch, 0);
		
		// And show the menu
		_visible = true;
	}
	
	// @GFx
	public function handleInput(details, pathToFocus): Boolean
	{
		updateDefaultButtonLabel()

		var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus))
			return true;

		if (GlobalFunc.IsKeyPressed(details, false)) {
			if (details.navEquivalent == NavigationCode.TAB) {
				GameDelegate.call("PlaySound", ["UIMenuCancel"]);
				onCancelPress();
				return true;
			} else if (details.navEquivalent == NavigationCode.ENTER) {
				GameDelegate.call("PlaySound", ["UIMenuOK"]);
				onAcceptPress();
				return true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_Y || details.skseKeycode == 20) {
				GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
				onCustomPress();
				return true;
			} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_X || details.skseKeycode == 19) {
				GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
				if (colorSwatch.newIndex > 27){
					onDeletePress();
				} else {
					onDefaultPress();
				}
				return true;
			}
		}
		
		// Don't forward to higher level
		return true;
	}
		
  /* PRIVATE FUNCTIONS */

	private function onAcceptPress(): Void
	{
		skse.SendModEvent("iEquip_colorMenuAccept", null, colorSwatch.selectedColor);
		skse.CloseMenu("CustomMenu");
	}
	
	private function onDefaultPress(): Void
	{
		colorSwatch.selectedColor = defaultColor_;
	}

	private function onDeletePress(): Void
	{
		var currentColor: Number = colorSwatch.selectedColor;
		var currentIndex: Number = colorSwatch.colorList.indexOf(currentColor);
		skse.SendModEvent("iEquip_colorMenuDelete", null, currentIndex - 28);
		skse.CloseMenu("CustomMenu");
	}

	private function onCustomPress(): Void
	{
		skse.SendModEvent("iEquip_colorMenuCustom");
		skse.CloseMenu("CustomMenu");
	}
	
	private function onCancelPress(): Void
	{
		skse.SendModEvent("iEquip_colorMenuCancel");
		skse.CloseMenu("CustomMenu");
	}

	/* PAPYRUS INTERFACE */
  
	public function setPlatform(platform: Number): Void
	{
		var isGamepad = platform != 0;
		
		cancelControls_ = GlobalFunctions.getMappedKey("Tween Menu", Input.CONTEXT_GAMEPLAY, isGamepad);
		defaultControls_ = GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, isGamepad);
		acceptControls_ = GlobalFunctions.getMappedKey("Activate", Input.CONTEXT_GAMEPLAY, isGamepad);
		customControls_ = GlobalFunctions.getMappedKey("Jump", Input.CONTEXT_GAMEPLAY, isGamepad);
		
		cancelButtonPanel.setPlatform(platform, false);
		defaultButtonPanel.setPlatform(platform, false);
		acceptButtonPanel.setPlatform(platform, false);
		customButtonPanel.setPlatform(platform, false);
		setupButtons(platform);
	}
}