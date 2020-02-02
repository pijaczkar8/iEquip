import skyui.components.list.BasicList;
import skyui.components.list.ListState;
import skyui.components.list.BasicListEntry;


/*
 *  A generic entry.
 *  Sets selectIndicator visible for the selected entry, if defined.
 *  Sets textField to obj.text.
 *  Forwards to label obj.state, if defined.
 */
class iEquip_uilib.ButtonListEntry extends BasicListEntry
{
  /* PRIVATE VARIABLES */
	
	
  /* STAGE ELEMENTS */

	public var activeIndicator: MovieClip;
	public var selectIndicator: MovieClip;
	public var textField: TextField;
	public var icon: MovieClip;
	public var itemIcon: MovieClip;
	public var poisonIcon: MovieClip;
	public var enchIcon: MovieClip;
	public var autoAddIcon: MovieClip;
	
  /* PROPERTIES */
  
	public static var defaultTextColor: Number = 0xffffff;
	public static var activeTextColor: Number = 0xffffff;
	public static var selectedTextColor: Number = 0xffffff;
	public static var disabledTextColor: Number = 0x505050;
	
	
  /* PUBLIC FUNCTIONS */
	
	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		// Not using "enabled" directly, because we still want to be able to receive onMouseX events,
		// even if we chose not to process them.
		isEnabled = a_entryObject.enabled;
		
		var isSelected = a_entryObject == a_state.list.selectedEntry;
		var isActive = (a_state.activeEntry != undefined && a_entryObject == a_state.activeEntry);

		if (a_entryObject.state != undefined)
			gotoAndPlay(a_entryObject.state);

		if (textField != undefined) {
			//textField.autoSize = a_entryObject.align ? a_entryObject.align : "left";
			textField.autoSize = "left";
			
			itemIcon._x = textField._x - (itemIcon._width/2) - 3;
			itemIcon.gotoAndStop(a_entryObject.iconName);

			if (!a_entryObject.enabled)
				textField.textColor = disabledTextColor;
			else if (isActive)
				textField.textColor = activeTextColor;
			else if (isSelected)
				textField.textColor = selectedTextColor;
			else
				textField.textColor = defaultTextColor;
				
			textField.SetText(a_entryObject.text ? a_entryObject.text : " ");

		    // Position for first icon
		    var iconPos = textField._x + textField._width + 3;

		    // All icons have the same size
		    var iconSpace = poisonIcon._width * 1.2;

		    // Poisoned Icon
		    if (a_entryObject.isPoisoned == true) {
		        poisonIcon._x = iconPos;
		        iconPos = iconPos + iconSpace;
		        poisonIcon.gotoAndStop("show");
		    } else {
		        poisonIcon.gotoAndStop("hide");
		    }

		    // Enchanted Icon
		    if (a_entryObject.isEnchanted == true) {
		        enchIcon._x = iconPos;
		        iconPos = iconPos + iconSpace;
		        enchIcon.gotoAndStop("show");
		    } else {
		        enchIcon.gotoAndStop("hide");
			}

			// Auto Added Icon
		    if (a_entryObject.isAutoAdded == true) {
		        autoAddIcon._x = iconPos;
		        iconPos = iconPos + iconSpace;
		        autoAddIcon.gotoAndStop("show");
		    } else {
		        autoAddIcon.gotoAndStop("hide");
			}

		}
		
		if (selectIndicator != undefined)
			selectIndicator._visible = isSelected;
			
		if (activeIndicator != undefined) {
			activeIndicator._visible = isActive;
			activeIndicator._x = textField._x - itemIcon._width - activeIndicator._width - 8;
		}
		
		if (icon != undefined && a_entryObject.iconLabel != undefined) {
			icon.gotoAndStop(a_entryObject.iconLabel);
		}
	}
}