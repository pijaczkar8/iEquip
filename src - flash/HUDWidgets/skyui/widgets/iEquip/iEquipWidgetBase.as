import skyui.widgets.WidgetBase;
import skyui.util.Debug;
import skyui.util.Hash;
import skyui.util.GlobalFunctions;
import skyui.util.Translator;
import Shared.GlobalFunc;

import flash.geom.ColorTransform;
import flash.geom.Transform;

import flash.filters.DropShadowFilter;

class skyui.widgets.iEquip.iEquipWidgetBase extends WidgetBase
{	
  /* STAGE ELEMENTS */

	//public var highlightColor: Number;

	public var leftTargetX: Number;
	public var leftTargetY: Number;
	public var rightTargetX: Number;
	public var shoutTargetX: Number;
	public var leftPTargetX: Number;
	public var leftPTargetY: Number;
	public var leftPTargetRotation: Number;
	public var rightPTargetX: Number;
	public var rightPTargetY: Number;
	public var rightPTargetRotation: Number;
	public var shoutPTargetX: Number;
	public var shoutPTargetY: Number;
	public var shoutPTargetRotation: Number;
	public var leftIconAlpha: Number;
	public var leftIconScale: Number;	
	public var leftPIconAlpha: Number;
	public var leftPIconScale: Number;
	public var rightIconAlpha: Number;	
	public var rightIconScale: Number;
	public var rightPIconAlpha: Number;
	public var rightPIconScale: Number;
	public var shoutIconAlpha: Number;
	public var shoutIconScale: Number;	
	public var shoutPIconAlpha: Number;
	public var shoutPIconScale: Number;

	public var leftNameAlpha: Number;
	public var leftPNameAlpha: Number;
	public var rightNameAlpha: Number;
	public var rightPNameAlpha: Number;
	public var shoutNameAlpha: Number;
	public var shoutPNameAlpha: Number;

	public var leftTargetScale: Number;
	public var rightTargetScale: Number;
	public var shoutTargetScale: Number;

	public var tempIcon = null;
	public var tempPIcon = null;
	public static var EquipAllCounter: Number;

	public var filter_shadow: DropShadowFilter;
	public var colorTrans: ColorTransform;

	public var highlightColor: Number;
	
  /* INITIALIZATION */

	public function iEquipWidgetBase()
	{
		super();

		highlightColor = 0x00A1FF;

		colorTrans = new ColorTransform;
		colorTrans.rgb = highlightColor;

		//Setup Shadow Filter parameters
		var shadow_distance:Number = 2;
		var shadow_angleInDegrees:Number = 105;
		var shadow_color:Number = 0x000000;
		var shadow_alpha:Number = 0.8;
		var shadow_blurX:Number = 2;
		var shadow_blurY:Number = 2;
		var shadow_strength:Number = 1;
		var shadow_quality:Number = 3;
		var shadow_inner:Boolean = false;
		var shadow_knockout:Boolean = false;
		var shadow_hideObject:Boolean = false;

		filter_shadow = new DropShadowFilter(shadow_distance, shadow_angleInDegrees, shadow_color, shadow_alpha, shadow_blurX, shadow_blurY, shadow_strength, shadow_quality, shadow_inner, shadow_knockout, shadow_hideObject);
	}

	//Function utilising the SkyUI scaleform hash function to generate itemIDs for WidgetCore addToQueue
	
	/*public function generateItemID(displayName: String, formID: Number): Void
	{
		if (displayName == "CrossBow") {
			displayName = "Crossbow"
		}
		var itemID: Number = skyui.util.Hash.crc32(displayName, formID & 0x00FFFFFF);
		var IDString: String = itemID.toString()
		skse.SendModEvent("iEquip_GotItemID", IDString, itemID);
	}*/
}
