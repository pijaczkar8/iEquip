import skyui.widgets.WidgetBase;

import gfx.io.GameDelegate;
import skyui.util.Debug;
import skyui.util.Hash;
import skyui.util.GlobalFunctions;
import skyui.util.Translator;
import Shared.GlobalFunc;

import com.greensock.TimelineLite;
import com.greensock.TweenLite;
import com.greensock.easing.*;

import skyui.defines.Item
import skyui.defines.Actor
import skyui.defines.Form
import skyui.defines.Weapon
import flash.geom.ColorTransform;
import flash.geom.Transform;

// Makes the filter available to use in the Movie. 
//import flash.filters.GlowFilter;

// Creates a variable with info about the Filter settings 
//var myGlowFilter = new GlowFilter (0x6699FF,0.6,4,20,3,3,false,true);

// Applies the filter to the object named myObject
//myObject.filters = [myGlowFilter];

class skyui.widgets.iEquip.iEquipWidget extends WidgetBase
{	
  /* STAGE ELEMENTS */
	//Widget MovieClips
	public var widgetMaster: MovieClip;
	public var LeftHandWidget: MovieClip;
	public var RightHandWidget: MovieClip;
	public var ShoutWidget: MovieClip;
	public var ConsumableWidget: MovieClip;
	public var PoisonWidget: MovieClip;
	public var EditModeGuide: MovieClip;

	//Widget background MovieClips
	public var leftBg_mc: MovieClip;
	public var rightBg_mc: MovieClip;
	public var shoutBg_mc: MovieClip;
	public var leftPreselectBg_mc: MovieClip;
	public var rightPreselectBg_mc: MovieClip;
	public var shoutPreselectBg_mc: MovieClip;
	public var leftPreselectBg: MovieClip;
	public var rightPreselectBg: MovieClip;
	public var shoutPreselectBg: MovieClip;
	public var consumableBg_mc: MovieClip;
	public var poisonBg_mc: MovieClip;
	
	//Widget icon holder MovieClips
	public var leftIcon_mc: MovieClip;
	public var leftPoisonIcon_mc: MovieClip;
	public var leftAttributeIcons_mc: MovieClip;
	public var leftEnchantmentMeter_mc: MovieClip;
	public var leftSoulgem_mc: MovieClip;
	public var leftPreselectIcon_mc: MovieClip;
	public var leftPreselectAttributeIcons_mc: MovieClip;
	public var rightIcon_mc: MovieClip;
	public var rightPoisonIcon_mc: MovieClip;
	public var rightAttributeIcons_mc: MovieClip;
	public var rightEnchantmentMeter_mc: MovieClip;
	public var rightSoulgem_mc: MovieClip;
	public var rightPreselectIcon_mc: MovieClip;
	public var rightPreselectAttributeIcons_mc: MovieClip;
	public var shoutIcon_mc: MovieClip;
	public var shoutPreselectIcon_mc: MovieClip;
	public var consumableIcon_mc: MovieClip;
	public var poisonIcon_mc: MovieClip;
	
	//Widget text field holder MovieClips
	public var leftName_mc: MovieClip;
	public var leftPoisonName_mc: MovieClip;
	public var leftCount_mc: MovieClip;
	public var leftPreselectName_mc: MovieClip;
	public var rightName_mc: MovieClip;
	public var rightPoisonName_mc: MovieClip;
	public var rightCount_mc: MovieClip;
	public var rightPreselectName_mc: MovieClip;
	public var shoutName_mc: MovieClip;
	public var shoutPreselectName_mc: MovieClip;
	public var consumableName_mc: MovieClip;
	public var consumableCount_mc: MovieClip;
	public var poisonName_mc: MovieClip;
	public var poisonCount_mc: MovieClip;
	
	//Widget Text Fields
	public var leftName: TextField;
	public var leftPoisonName: TextField;
	public var leftCount: TextField;
	public var leftPreselectName: TextField;
	public var rightName: TextField;
	public var rightPoisonName: TextField;
	public var rightCount: TextField;
	public var rightPreselectName: TextField;
	public var shoutName: TextField;
	public var shoutPreselectName: TextField;
	public var consumableName: TextField;
	public var consumableCount: TextField;
	public var poisonName: TextField;
	public var poisonCount: TextField;
	
	//Edit Mode Guide Text Fields
	public var NextPrevInstructionText: TextField;
	public var MoveInstructionText: TextField;
	public var ScaleInstructionText: TextField;
	public var ToggleMoveInstructionText: TextField;
	public var RotateInstructionText: TextField;
	public var ToggleRotateInstructionText: TextField;
	public var RotationDirectionInstructionText: TextField;
	public var DepthInstructionText: TextField;
	public var AlignmentInstructionText: TextField;
	public var TextColorInstructionText: TextField;
	public var AlphaInstructionText: TextField;
	public var ToggleAlphaInstructionText: TextField;
	public var VisInstructionText: TextField;
	public var ToggleGridInstructionText: TextField;
	public var HighlightColorInstructionText: TextField;
	public var CurrInfoColorInstructionText: TextField;
	public var ResetInstructionText: TextField;
	public var SelectedElementText: TextField;
	public var ScaleText: TextField;
	public var RotationText: TextField;
	public var RotationDirectionText: TextField;
	public var AlignmentText: TextField;
	public var AlphaText: TextField;
	public var VisibilityText: TextField;
	public var MoveIncrementText: TextField;
	public var RotateIncrementText: TextField;
	public var AlphaIncrementText: TextField;
	public var RulersText: TextField;
	public var LoadPresetText: TextField;
	public var SavePresetText: TextField;
	public var ExitEditModeText: TextField;
	public var DiscardChangesText: TextField;
	
	public var NextButton: MovieClip;
	public var PrevButton: MovieClip;
	public var MoveUpButton: MovieClip;
	public var MoveDownButton: MovieClip;
	public var MoveLeftButton: MovieClip;
	public var MoveRightButton: MovieClip;
	public var ScaleUpButton: MovieClip;
	public var ScaleDownButton: MovieClip;
	public var RotateButton: MovieClip;
	public var DepthButton: MovieClip;
	public var AlphaButton: MovieClip;
	public var AlignmentButton: MovieClip;
	public var ToggleGridButton: MovieClip;
	public var ResetButton: MovieClip;
	public var LoadButton: MovieClip;
	public var SaveButton: MovieClip;
	public var DiscardButton: MovieClip;
	public var ExitButton: MovieClip;

	public var leftIcon: MovieClip;
	public var leftPoisonIcon: MovieClip;
	public var leftAttributeIcons: MovieClip;
	public var leftSoulgem: MovieClip;
	public var leftEnchantmentMeter: MovieClip;
	public var rightIcon: MovieClip;
	public var rightPoisonIcon: MovieClip;
	public var rightAttributeIcons: MovieClip;
	public var rightSoulgem: MovieClip;
	public var rightEnchantmentMeter: MovieClip;
	public var shoutIcon: MovieClip;
	public var leftPreselectIcon: MovieClip;
	public var leftPreselectAttributeIcons: MovieClip;
	public var rightPreselectIcon: MovieClip;
	public var rightPreselectAttributeIcons: MovieClip;
	public var shoutPreselectIcon: MovieClip;
	public var consumableIcon: MovieClip;
	public var potionFlashAnim: MovieClip;
	public var poisonIcon: MovieClip;

	public var highlightColor: Number;
	
	public var clip: MovieClip;
	public var clipArray: Array;
	public var selectedText: TextField;
	public var textElementArray: Array;
	public var attributeArray: Array;

	public var currQ: Number;
	public var iconToColor: String;

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
	public var tempHighlightedClip = null;
	public static var EquipAllCounter: Number;
	
  /* INITIALIZATION */

	public function iEquipWidget()
	{
		super();

		_visible = false;

		Mouse.addListener(this);
		GameDelegate.addCallBack("InvalidateListData", this, "InvalidateListData");
		
		//Set up the sub widget MovieClips
		LeftHandWidget = widgetMaster.LeftHandWidget
		RightHandWidget = widgetMaster.RightHandWidget
		ShoutWidget = widgetMaster.ShoutWidget
		ConsumableWidget = widgetMaster.ConsumableWidget
		PoisonWidget = widgetMaster.PoisonWidget

		//Set up the background MovieClips
		leftBg_mc = widgetMaster.LeftHandWidget.leftBg_mc;
		rightBg_mc = widgetMaster.RightHandWidget.rightBg_mc;
		shoutBg_mc = widgetMaster.ShoutWidget.shoutBg_mc;
		leftPreselectBg_mc = widgetMaster.LeftHandWidget.leftPreselectBg_mc;
		rightPreselectBg_mc = widgetMaster.RightHandWidget.rightPreselectBg_mc;
		shoutPreselectBg_mc = widgetMaster.ShoutWidget.shoutPreselectBg_mc;
		leftPreselectBg = widgetMaster.LeftHandWidget.leftPreselectBg_mc.leftPreselectBg;
		rightPreselectBg = widgetMaster.RightHandWidget.rightPreselectBg_mc.rightPreselectBg;
		shoutPreselectBg = widgetMaster.ShoutWidget.shoutPreselectBg_mc.shoutPreselectBg;
		consumableBg_mc = widgetMaster.ConsumableWidget.consumableBg_mc;
		poisonBg_mc = widgetMaster.PoisonWidget.poisonBg_mc;
		
		//Backgrounds are hidden by default
		leftBg_mc._visible = false;
		rightBg_mc._visible = false;
		shoutBg_mc._visible = false;
		leftPreselectBg_mc._visible = false;
		rightPreselectBg_mc._visible = false;
		shoutPreselectBg_mc._visible = false;
		consumableBg_mc._visible = false;
		poisonBg_mc._visible = false;

		//Set up the icon and text field holder MovieClips
		leftIcon_mc = widgetMaster.LeftHandWidget.leftIcon_mc;
		leftPoisonIcon_mc = widgetMaster.LeftHandWidget.leftPoisonIcon_mc;
		leftAttributeIcons_mc = widgetMaster.LeftHandWidget.leftAttributeIcons_mc;
		leftEnchantmentMeter_mc = widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc;
		leftSoulgem_mc = widgetMaster.LeftHandWidget.leftSoulgem_mc;
		rightIcon_mc = widgetMaster.RightHandWidget.rightIcon_mc;
		rightPoisonIcon_mc = widgetMaster.RightHandWidget.rightPoisonIcon_mc;
		rightAttributeIcons_mc = widgetMaster.RightHandWidget.rightAttributeIcons_mc;
		rightEnchantmentMeter_mc = widgetMaster.RightHandWidget.rightEnchantmentMeter_mc;
		rightSoulgem_mc = widgetMaster.RightHandWidget.rightSoulgem_mc;
		shoutIcon_mc = widgetMaster.ShoutWidget.shoutIcon_mc;
		consumableIcon_mc = widgetMaster.ConsumableWidget.consumableIcon_mc;
		poisonIcon_mc = widgetMaster.PoisonWidget.poisonIcon_mc;
		leftName_mc = widgetMaster.LeftHandWidget.leftName_mc;
		leftPoisonName_mc = widgetMaster.LeftHandWidget.leftPoisonName_mc;
		leftCount_mc = widgetMaster.LeftHandWidget.leftCount_mc;
		rightName_mc = widgetMaster.RightHandWidget.rightName_mc;
		rightPoisonName_mc = widgetMaster.RightHandWidget.rightPoisonName_mc;
		rightCount_mc = widgetMaster.RightHandWidget.rightCount_mc;
		shoutName_mc = widgetMaster.ShoutWidget.shoutName_mc;
		consumableName_mc = widgetMaster.ConsumableWidget.consumableName_mc;
		consumableCount_mc = widgetMaster.ConsumableWidget.consumableCount_mc;
		poisonName_mc = widgetMaster.PoisonWidget.poisonName_mc;
		poisonCount_mc = widgetMaster.PoisonWidget.poisonCount_mc;

		//Set up the preselect icon and text field holder MovieClips
		leftPreselectIcon_mc = widgetMaster.LeftHandWidget.leftPreselectIcon_mc;
		leftPreselectAttributeIcons_mc = widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc;
		rightPreselectIcon_mc = widgetMaster.RightHandWidget.rightPreselectIcon_mc;
		rightPreselectAttributeIcons_mc = widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc;
		shoutPreselectIcon_mc = widgetMaster.ShoutWidget.shoutPreselectIcon_mc;
		leftPreselectName_mc = widgetMaster.LeftHandWidget.leftPreselectName_mc;
		rightPreselectName_mc = widgetMaster.RightHandWidget.rightPreselectName_mc;
		shoutPreselectName_mc = widgetMaster.ShoutWidget.shoutPreselectName_mc;
		
		//Set up the icon object paths
		leftIcon = widgetMaster.LeftHandWidget.leftIcon_mc.leftIcon;
		leftPoisonIcon = widgetMaster.LeftHandWidget.leftPoisonIcon_mc.leftPoisonIcon;
		leftAttributeIcons = widgetMaster.LeftHandWidget.leftAttributeIcons_mc.leftAttributeIcons;
		leftSoulgem = widgetMaster.LeftHandWidget.leftSoulgem_mc.leftSoulgem;
		leftEnchantmentMeter = widgetMaster.LeftHandWidget.leftEnchantmentMeter_mc.leftEnchantmentMeter;
		rightIcon = widgetMaster.RightHandWidget.rightIcon_mc.rightIcon;
		rightPoisonIcon = widgetMaster.RightHandWidget.rightPoisonIcon_mc.rightPoisonIcon;
		rightAttributeIcons = widgetMaster.RightHandWidget.rightAttributeIcons_mc.rightAttributeIcons;
		rightSoulgem = widgetMaster.RightHandWidget.rightSoulgem_mc.rightSoulgem;
		rightEnchantmentMeter = widgetMaster.RightHandWidget.rightEnchantmentMeter_mc.rightEnchantmentMeter;
		shoutIcon = widgetMaster.ShoutWidget.shoutIcon_mc.shoutIcon;
		consumableIcon = widgetMaster.ConsumableWidget.consumableIcon_mc.consumableIcon;
		potionFlashAnim = widgetMaster.ConsumableWidget.consumableIcon_mc.potionFlashAnim;
		poisonIcon = widgetMaster.PoisonWidget.poisonIcon_mc.poisonIcon;

		//Set up the preselect icon object paths
		leftPreselectIcon = widgetMaster.LeftHandWidget.leftPreselectIcon_mc.leftPreselectIcon;
		leftPreselectAttributeIcons = widgetMaster.LeftHandWidget.leftPreselectAttributeIcons_mc.leftPreselectAttributeIcons;
		rightPreselectIcon = widgetMaster.RightHandWidget.rightPreselectIcon_mc.rightPreselectIcon;
		rightPreselectAttributeIcons = widgetMaster.RightHandWidget.rightPreselectAttributeIcons_mc.rightPreselectAttributeIcons;
		shoutPreselectIcon = widgetMaster.ShoutWidget.shoutPreselectIcon_mc.shoutPreselectIcon;
		
		//Set up the button icon paths
		NextButton = EditModeGuide.NextButton;
		PrevButton = EditModeGuide.PrevButton;
		MoveUpButton = EditModeGuide.MoveUpButton;
		MoveDownButton = EditModeGuide.MoveDownButton;
		MoveLeftButton = EditModeGuide.MoveLeftButton;
		MoveRightButton = EditModeGuide.MoveRightButton;
		ScaleUpButton = EditModeGuide.ScaleUpButton;
		ScaleDownButton = EditModeGuide.ScaleDownButton;
		DepthButton = EditModeGuide.DepthButton;
		RotateButton = EditModeGuide.RotateButton;
		AlphaButton = EditModeGuide.AlphaButton;
		AlignmentButton = EditModeGuide.AlignmentButton;
		ToggleGridButton = EditModeGuide.ToggleGridButton;
		ResetButton = EditModeGuide.ResetButton;
		LoadButton = EditModeGuide.LoadButton;
		SaveButton = EditModeGuide.SaveButton;
		DiscardButton = EditModeGuide.DiscardButton;
		ExitButton = EditModeGuide.ExitButton;
		
		//Set up the Edit Mode text field paths
		NextPrevInstructionText = EditModeGuide.NextPrevInstructionText;
		MoveInstructionText = EditModeGuide.MoveInstructionText;
		ScaleInstructionText = EditModeGuide.ScaleInstructionText;
		ToggleMoveInstructionText = EditModeGuide.ToggleMoveInstructionText;
		RotateInstructionText = EditModeGuide.RotateInstructionText;
		ToggleRotateInstructionText = EditModeGuide.ToggleRotateInstructionText;
		RotationDirectionInstructionText = EditModeGuide.RotationDirectionInstructionText;
		DepthInstructionText = EditModeGuide.DepthInstructionText;
		AlignmentInstructionText = EditModeGuide.AlignmentInstructionText;
		TextColorInstructionText = EditModeGuide.TextColorInstructionText;
		AlphaInstructionText = EditModeGuide.AlphaInstructionText;
		ToggleAlphaInstructionText = EditModeGuide.ToggleAlphaInstructionText;
		VisInstructionText = EditModeGuide.VisInstructionText;
		ToggleGridInstructionText = EditModeGuide.ToggleGridInstructionText;
		HighlightColorInstructionText = EditModeGuide.HighlightColorInstructionText;
		CurrInfoColorInstructionText = EditModeGuide.CurrInfoColorInstructionText;
		ResetInstructionText = EditModeGuide.ResetInstructionText;
		LoadPresetText = EditModeGuide.LoadPresetText;
		SavePresetText = EditModeGuide.SavePresetText;
		ExitEditModeText = EditModeGuide.ExitEditModeText;
		DiscardChangesText = EditModeGuide.DiscardChangesText;
		SelectedElementText = EditModeGuide.SelectedElementText;
		ScaleText = EditModeGuide.ScaleText;
		RotationText = EditModeGuide.RotationText;
		RotationDirectionText = EditModeGuide.RotationDirectionText;
		AlignmentText = EditModeGuide.AlignmentText;
		AlphaText = EditModeGuide.AlphaText;
		VisibilityText = EditModeGuide.VisibilityText;
		MoveIncrementText = EditModeGuide.MoveIncrementText;
		RotateIncrementText = EditModeGuide.RotateIncrementText;
		AlphaIncrementText = EditModeGuide.AlphaIncrementText;
		RulersText = EditModeGuide.RulersText;
		
		//Set up text fields, initial empty string and auto resize attributes
		leftName = widgetMaster.LeftHandWidget.leftName_mc.leftName;
		leftPoisonName = widgetMaster.LeftHandWidget.leftPoisonName_mc.leftPoisonName;
		leftCount = widgetMaster.LeftHandWidget.leftCount_mc.leftCount;
		leftPreselectName = widgetMaster.LeftHandWidget.leftPreselectName_mc.leftPreselectName;
		rightName = widgetMaster.RightHandWidget.rightName_mc.rightName;
		rightPoisonName = widgetMaster.RightHandWidget.rightPoisonName_mc.rightPoisonName;
		rightCount = widgetMaster.RightHandWidget.rightCount_mc.rightCount;
		rightPreselectName = widgetMaster.RightHandWidget.rightPreselectName_mc.rightPreselectName;
		shoutName = widgetMaster.ShoutWidget.shoutName_mc.shoutName;
		shoutPreselectName = widgetMaster.ShoutWidget.shoutPreselectName_mc.shoutPreselectName;
		consumableName = widgetMaster.ConsumableWidget.consumableName_mc.consumableName;
		consumableCount = widgetMaster.ConsumableWidget.consumableCount_mc.consumableCount;
		poisonName = widgetMaster.PoisonWidget.poisonName_mc.poisonName;
		poisonCount = widgetMaster.PoisonWidget.poisonCount_mc.poisonCount;
		leftName.text = "";
		leftPoisonName.text = "";
		leftCount.text = "";
		leftPreselectName.text = "";
		rightName.text = "";
		rightPoisonName.text = "";
		rightCount.text = "";
		rightPreselectName.text = "";
		shoutName.text = "";
		shoutPreselectName.text = "";
		consumableName.text = "";
		consumableCount.text = "";
		poisonName.text = "";
		poisonCount.text = "";
		leftName.textAutoSize = "shrink";
		leftPoisonName.textAutoSize = "shrink";
		leftCount.textAutoSize = "shrink";
		leftPreselectName.textAutoSize = "shrink";
		rightName.textAutoSize = "shrink";
		rightPoisonName.textAutoSize = "shrink";
		rightCount.textAutoSize = "shrink";
		rightPreselectName.textAutoSize = "shrink";
		shoutName.textAutoSize = "shrink";
		shoutPreselectName.textAutoSize = "shrink";
		consumableName.textAutoSize = "shrink";
		consumableCount.textAutoSize = "shrink";
		poisonName.textAutoSize = "shrink";
		poisonCount.textAutoSize = "shrink";
		leftIcon.gotoAndStop("Empty")
		leftPoisonIcon.gotoAndStop("Hidden")
		leftAttributeIcons.gotoAndStop("Hidden")
		leftEnchantmentMeter_mc._visible = false
		leftSoulgem_mc._visible = false
		rightIcon.gotoAndStop("Empty")
		rightPoisonIcon.gotoAndStop("Hidden")
		rightAttributeIcons.gotoAndStop("Hidden")
		rightEnchantmentMeter_mc._visible = false
		rightSoulgem_mc._visible = false
		shoutIcon.gotoAndStop("Empty")
		consumableIcon.gotoAndStop("Empty")
		potionFlashAnim.gotoAndStop("Hidden")
		potionFlashAnim._alpha = 0.0
		poisonIcon.gotoAndStop("Empty")
		leftPreselectIcon.gotoAndStop("Empty")
		leftPreselectAttributeIcons.gotoAndStop("Hidden")
		rightPreselectIcon.gotoAndStop("Empty")
		rightPreselectAttributeIcons.gotoAndStop("Hidden")
		shoutPreselectIcon.gotoAndStop("Empty")
		
		//Set up arrays of MovieClips and text elements ready for use in Edit Mode
		clipArray = new Array(widgetMaster, LeftHandWidget, RightHandWidget, ShoutWidget, ConsumableWidget, PoisonWidget, leftBg_mc, leftIcon_mc, leftName_mc, leftCount_mc, leftPoisonIcon_mc, leftPoisonName_mc, leftAttributeIcons_mc, leftEnchantmentMeter_mc, leftSoulgem_mc, leftPreselectBg_mc, leftPreselectIcon_mc, leftPreselectName_mc, leftPreselectAttributeIcons_mc, rightBg_mc, rightIcon_mc, rightName_mc, rightCount_mc, rightPoisonIcon_mc, rightPoisonName_mc, rightAttributeIcons_mc, rightEnchantmentMeter_mc, rightSoulgem_mc, rightPreselectBg_mc, rightPreselectIcon_mc, rightPreselectName_mc, rightPreselectAttributeIcons_mc, shoutBg_mc, shoutIcon_mc, shoutName_mc, shoutPreselectBg_mc, shoutPreselectIcon_mc, shoutPreselectName_mc, consumableBg_mc, consumableIcon_mc, consumableName_mc, consumableCount_mc, poisonBg_mc, poisonIcon_mc, poisonName_mc, poisonCount_mc);
		textElementArray = new Array(null, null, null, null, null, null, null, null, leftName, leftCount, null, leftPoisonName, null, null, null, null, null, leftPreselectName, null, null, null, rightName, rightCount, null, rightPoisonName, null, null, null, null, null, rightPreselectName, null, null, null, shoutName, null, null, shoutPreselectName, null, null, consumableName, consumableCount, null, null, poisonName, poisonCount);

		highlightColor = 0x00A1FF;
	}
	
	public function setWidgetToEmpty(): Void
	{
		leftIcon.gotoAndStop("Add")
		rightIcon.gotoAndStop("Add")
		shoutIcon.gotoAndStop("Add")
		consumableIcon.gotoAndStop("Add")
		poisonIcon.gotoAndStop("Add")
		shoutName.text = "--Empty--";
		leftName.text = "--Empty--";
		rightName.text = "--Empty--";
		consumableName.text = "--Empty--";
		poisonName.text = "--Empty--";
	}

	function setEditModeButtons(Exit: Number, Nxt: Number, Prv: Number, Up: Number, Down: Number, Left: Number, Right: Number, ScaleUp: Number, ScaleDown: Number, Rot: Number, Alpha: Number, Align: Number, Dep: Number, Rul: Number, Res: Number, Load: Number, Save: Number, Disc: Number): Void
	{
		NextButton.gotoAndStop(Nxt);
		PrevButton._x = NextButton._x + NextButton._width + 1;
		PrevButton.gotoAndStop(Prv);
		NextPrevInstructionText._x = PrevButton._x + PrevButton._width + 8;
		MoveLeftButton.gotoAndStop(Left);
		MoveUpButton._x = MoveLeftButton._x + MoveLeftButton._width + 1;
		MoveUpButton.gotoAndStop(Up);
		MoveDownButton._x = MoveUpButton._x + MoveUpButton._width + 1;
		MoveDownButton.gotoAndStop(Down);
		MoveRightButton._x = MoveDownButton._x + MoveDownButton._width + 1;
		MoveRightButton.gotoAndStop(Right);
		MoveInstructionText._x = MoveRightButton._x + MoveRightButton._width + 8;
		ScaleUpButton.gotoAndStop(ScaleUp);
		ScaleDownButton._x = ScaleUpButton._x + ScaleUpButton._width + 1;
		ScaleDownButton.gotoAndStop(ScaleDown);
		ScaleInstructionText._x = ScaleDownButton._x + ScaleDownButton._width + 8;
		ToggleMoveInstructionText._x = ScaleInstructionText._x
		RotateButton.gotoAndStop(Rot);
		RotateInstructionText._x = RotateButton._x + 30;
		ToggleRotateInstructionText._x = RotateInstructionText._x;
		RotationDirectionInstructionText._x = RotateInstructionText._x;
		AlignmentButton.gotoAndStop(Align);
		AlignmentInstructionText._x = RotateInstructionText._x;
		TextColorInstructionText._x = RotateInstructionText._x;
		AlphaButton.gotoAndStop(Alpha);
		AlphaInstructionText._x = RotateInstructionText._x;
		DepthButton.gotoAndStop(Dep);
		DepthInstructionText._x = RotateInstructionText._x;
		ToggleAlphaInstructionText._x = RotateInstructionText._x;
		VisInstructionText._x = RotateInstructionText._x;
		ToggleGridButton.gotoAndStop(Rul);
		ToggleGridInstructionText._x = RotateInstructionText._x;
		HighlightColorInstructionText._x = RotateInstructionText._x;
		CurrInfoColorInstructionText._x = RotateInstructionText._x;
		ResetButton.gotoAndStop(Res);
		ResetInstructionText._x = RotateInstructionText._x;
		LoadButton.gotoAndStop(Load);
		LoadPresetText._x = LoadButton._x + LoadButton._width + 8;
		SaveButton.gotoAndStop(Save);
		SavePresetText._x = SaveButton._x + SaveButton._width + 8;
		ExitButton.gotoAndStop(Exit);
		ExitEditModeText._x = ExitButton._x + ExitButton._width + 8;
		DiscardButton.gotoAndStop(Disc);
		DiscardChangesText._x = DiscardButton._x + DiscardButton._width + 8;
	}
	
	function setEditModeHighlightColor(_color: Number): Void
	{
		highlightColor = _color;
		SelectedElementText.textColor = highlightColor;
	}
	
	function setEditModeCurrentValueColor(_color: Number): Void
	{
		ScaleText.textColor = _color;
		RotationText.textColor = _color;
		RotationDirectionText.textColor = _color;
		AlignmentText.textColor = _color;
		AlphaText.textColor = _color;
		VisibilityText.textColor = _color;
		MoveIncrementText.textColor = _color;
		RotateIncrementText.textColor = _color;
		AlphaIncrementText.textColor = _color;
		RulersText.textColor = _color;
	}

  	//PUBLIC FUNCTIONS
	//@Papyrus
	//Main widget update function
	//sSlot: 0 = Left Hand, 1 = Right Hand, 2 = Shout, 3 = Consumable, 4 = Poison, 5 = Left Preselect, 6 = Right Preselect, 7 = Shout Preselect
	public function updateWidget(iSlot: Number, sIcon: String, sName: String, iNameAlpha: Number): Void
	{
		var iconClip: MovieClip;
		var itemIcon: MovieClip;
		var nameClip: MovieClip;
		var itemName: TextField;

		switch(iSlot) {
			case 0:
				iconClip = leftIcon_mc
				itemIcon = leftIcon
				nameClip = leftName_mc
				itemName = leftName
				break
			case 1:
				iconClip = rightIcon_mc
				itemIcon = rightIcon
				nameClip = rightName_mc
				itemName = rightName
				break
			case 2:
				iconClip = shoutIcon_mc
				itemIcon = shoutIcon
				nameClip = shoutName_mc
				itemName = shoutName		
				break
			case 3:
				iconClip = consumableIcon_mc
				itemIcon = consumableIcon
				nameClip = consumableName_mc
				itemName = consumableName
				break
			case 4:
				iconClip = poisonIcon_mc
				itemIcon = poisonIcon
				nameClip = poisonName_mc
				itemName = poisonName				
				break
			case 5:
				iconClip = leftPreselectIcon_mc
				itemIcon = leftPreselectIcon
				nameClip = leftPreselectName_mc
				itemName = leftPreselectName
				break
			case 6:
				iconClip = rightPreselectIcon_mc
				itemIcon = rightPreselectIcon
				nameClip = rightPreselectName_mc
				itemName = rightPreselectName
				break
			case 7:
				iconClip = shoutPreselectIcon_mc
				itemIcon = shoutPreselectIcon
				nameClip = shoutPreselectName_mc
				itemName = shoutPreselectName
				break
			};
		//Store current alpha and scale values so we fade back in to the same settings
		var currAlpha = iconClip._alpha
		var currScale = iconClip._xscale
		//Create the animation timeline
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		//Fade out and shrink the icon
		tl.to(iconClip, 0.08, {_alpha:0, _xscale:0.25, _yscale:0.25, ease:Quad.easeOut}, 0)
		//Fade out the name
		.to(nameClip, 0.08, {_alpha:0, ease:Quad.easeOut}, 0)
		//Set the new icon and name and update the icon colour if potion/poison whilst not visible
		.call(updateIconAndName, [iSlot, itemIcon, iconClip, itemName, sIcon, sName])
		//Fade and scale the new icon back in
		.to(iconClip, 0.15, {_alpha:currAlpha, _xscale:currScale, _yscale:currScale, ease:Quad.easeOut}, 0.15)
		//Finally fade the new name back in
		.to(nameClip, 0.15, {_alpha:iNameAlpha, ease:Quad.easeOut}, 0.15);
		//And ACTION!
		tl.play();
	}

	public function updateAttributeIcons(iSlot: Number, sAttributes: String): Void
	{
		var attributesClip: MovieClip;
		var attributeIcons: MovieClip;

		switch(iSlot) {
			case 0:
				attributesClip = leftAttributeIcons_mc
				attributeIcons = leftAttributeIcons
				break
			case 1:
				attributesClip = rightAttributeIcons_mc
				attributeIcons = rightAttributeIcons
				break
			case 5:
				attributesClip = leftPreselectAttributeIcons_mc
				attributeIcons = leftPreselectAttributeIcons		
				break
			case 6:
				attributesClip = rightPreselectAttributeIcons_mc
				attributeIcons = rightPreselectAttributeIcons
				break
			};
		//Store current alpha and scale values so we fade back in to the same settings
		var currAttributesAlpha = attributesClip._alpha
		//Fade out
		TweenLite.to(attributesClip, 0.08, {_alpha:0, ease:Quad.easeOut});
		//Set new attribute icons
		attributeIcons.gotoAndStop(sAttributes);
		//Fade in
		TweenLite.to(attributesClip, 0.15, {_alpha:currAttributesAlpha, ease:Quad.easeOut});
	}

	public function updateIconAndName(iSlot: Number, itemIcon: MovieClip, iconClip: MovieClip, itemName: TextField, sIcon: String, sName: String): Void
	{
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		//Set the Name
		itemName.text = sName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
		//Set the Icon
		itemIcon.gotoAndStop(sIcon);

		switch (iSlot){
			case 3:
			//Colour the potion icons
				switch(sIcon){
					case "HealthPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0xDB2E73);
						break;
					case "StaminaPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0x51DB2E);
						break;
					case "MagickaPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0x2E9FDB);
						break;
					case "FrostResistPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0x1FFBFF);
						break;
					case "FireResistPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0xC73636);
						break;
					case "ShockResistPotion":
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0xEAAB00);
						break;
					default:
						var pIconColor = new Color(iconClip);
						pIconColor.setRGB(0xFFFFFF);
						break
					};
				break
			case 4:
				//Colour the poison icon
				var pIconColor = new Color(iconClip);
				pIconColor.setRGB(0xAD00B3);
				break
			default:
				break
			};
	}

	//Used when a bound weapon is equipped to switch from the spell school icon to the bound weapon icon
	public function updateIconOnly(iSlot: Number, sIcon: String): Void
	{
		var iconClip: MovieClip;
		//var itemIcon: MovieClip;
		//var currAlpha: Number;
		
		switch(iSlot) {
			case 0:
				iconClip = leftIcon_mc
				//itemIcon = leftIcon
				//currAlpha = leftIcon_mc._alpha
				break
			case 1:
				iconClip = rightIcon_mc
				//itemIcon = rightIcon
				//currAlpha = rightIcon_mc._alpha
				break
			};
		
		//TweenLite.to(iconClip, 0.15, {_alpha:0, ease:Quad.easeOut});
		//itemIcon.gotoAndStop(sIcon); 
		//TweenLite.to(iconClip, 0.2, {_alpha:currAlpha, ease:Quad.easeOut});
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(iconClip, 1.2, {_rotation:"+=1080", ease:Strong.easeInOut}, 0)
		.call(switchToBoundItemIcon, [iSlot, sIcon], this, 0.7);
		tl.play();
	}

	public function switchToBoundItemIcon(iSlot: Number, sIcon: String): Void
	{
		var itemIcon: MovieClip;

		switch(iSlot) {
			case 0:
				itemIcon = leftIcon
				break
			case 1:
				itemIcon = rightIcon
				break
			};

		itemIcon.gotoAndStop(sIcon);
	}

	public function togglePreselect(leftEnabled: Boolean, rightEnabled: Boolean, shoutEnabled: Boolean, backgroundsShown: Boolean, ammoMode: Boolean): Void
	{
		if(!ammoMode){
			leftPreselectIcon._alpha = 0
			leftPreselectName_mc._alpha = 0
			leftPreselectBg._alpha = 0
		}
		shoutPreselectIcon._alpha = 0
		shoutPreselectName_mc._alpha = 0
		rightPreselectIcon._alpha = 0
		rightPreselectName_mc._alpha = 0
		shoutPreselectBg._alpha = 0
		rightPreselectBg._alpha = 0

		if (!backgroundsShown){
			leftPreselectBg_mc._visible = backgroundsShown
			shoutPreselectBg_mc._visible = backgroundsShown
			rightPreselectBg_mc._visible = backgroundsShown
		} else {
			leftPreselectBg_mc._visible = leftEnabled
			shoutPreselectBg_mc._visible = shoutEnabled
			rightPreselectBg_mc._visible = rightEnabled
		}
		leftPreselectIcon_mc._visible = leftEnabled
		leftPreselectName_mc._visible = leftEnabled
		shoutPreselectIcon_mc._visible = shoutEnabled
		shoutPreselectName_mc._visible = shoutEnabled
		rightPreselectIcon_mc._visible = rightEnabled
		rightPreselectName_mc._visible = rightEnabled
	}

	public function ProModeAnimateIn(leftEnabled: Boolean, shoutEnabled: Boolean, rightEnabled: Boolean): Void
	{
		//Create the preselect element arrays then add elements to the arrays depending on whether they are shown or not. Sequence for animation is left to right
		var preselectIcons: Array = new Array();
		var preselectBackgrounds: Array = new Array();
		var preselectNames: Array = new Array();

		if (leftEnabled == true){
			preselectIcons.push(leftPreselectIcon)
			preselectBackgrounds.push(leftPreselectBg)
			preselectNames.push(leftPreselectName_mc)
		}
		if (shoutEnabled == true){
			preselectIcons.push(shoutPreselectIcon)
			preselectBackgrounds.push(shoutPreselectBg)
			preselectNames.push(shoutPreselectName_mc)
		}
		if (rightEnabled == true){
			preselectIcons.push(rightPreselectIcon)
			preselectBackgrounds.push(rightPreselectBg)
			preselectNames.push(rightPreselectName_mc)
		}
		//Set up the animation timeline
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.staggerTo(preselectIcons, 0.8, {_rotation:"+=360", _alpha:100, _xscale:100, _yscale:100, immediateRender:false, ease:Back.easeOut}, 0.2, 0)
		tl.staggerTo(preselectBackgrounds, 0.8, {_rotation:180, _alpha:100, immediateRender:false, ease:Back.easeOut}, 0.2, 0.1)
		tl.staggerTo(preselectNames, 0.3, {_alpha:100, immediateRender:false}, 0.2, 0.6);
		//And action!
		tl.play();
	}

	public function ProModeAnimateOut(rightEnabled: Boolean, shoutEnabled: Boolean, leftEnabled: Boolean): Void
	{
		var preselectIcons: Array = new Array();
		var preselectBackgrounds: Array = new Array();
		var preselectNames: Array = new Array();
		// This time animation sequence is right to left, the opposite of animate in
		if (rightEnabled == true){
			preselectIcons.push(rightPreselectIcon)
			preselectBackgrounds.push(rightPreselectBg)
			preselectNames.push(rightPreselectName_mc)
		}
		if (shoutEnabled == true){
			preselectIcons.push(shoutPreselectIcon)
			preselectBackgrounds.push(shoutPreselectBg)
			preselectNames.push(shoutPreselectName_mc)
		}
		if (leftEnabled == true){
			preselectIcons.push(leftPreselectIcon)
			preselectBackgrounds.push(leftPreselectBg)
			preselectNames.push(leftPreselectName_mc)
		}

		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.staggerTo(preselectIcons, 1.0, {_rotation:"-=360", _alpha:0, _xscale:20, _yscale:20, immediateRender:false, ease:Quad.easeOut}, 0.3, 0)
		tl.staggerTo(preselectBackgrounds, 1.0, {_rotation:"-=120", _alpha:0, immediateRender:false, ease:Quad.easeOut}, 0.3, 0.2)
		tl.staggerTo(preselectNames, 0.4, {_alpha:0, immediateRender:false}, 0.3, 0);

		tl.play();
	}

	public function prepareForPreselectAnimation(): Void
	{
		//This function checks if the preselect icons are to the left or right of their main icon and sets the animate out direction to the opposite side. It also stores current main icon x/y as the target values for the preselect icons to animate to. Finally it gets and stores all necessary current scale and alpha values to ensure everything returns to the exact state it was in prior to starting the animation
		
		var leftIconLTG:Object = {x:0, y:0};
		var leftPreselectIconLTG:Object = {x:0, y:0};
		var rightIconLTG:Object = {x:0, y:0};
		var rightPreselectIconLTG:Object = {x:0, y:0};
		var shoutIconLTG:Object = {x:0, y:0};
		var shoutPreselectIconLTG:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftIconLTG);
		leftPreselectIcon.localToGlobal(leftPreselectIconLTG);
		rightIcon.localToGlobal(rightIconLTG);
		rightPreselectIcon.localToGlobal(rightPreselectIconLTG);
		shoutIcon.localToGlobal(shoutIconLTG);
		shoutPreselectIcon.localToGlobal(shoutPreselectIconLTG);

		var leftPIconTarget:Object = {x:0, y:0};
		var rightPIconTarget:Object = {x:0, y:0};
		var shoutPIconTarget:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftPIconTarget);
		leftPreselectIcon.globalToLocal(leftPIconTarget);
		rightIcon.localToGlobal(rightPIconTarget);
		rightPreselectIcon.globalToLocal(rightPIconTarget);
		shoutIcon.localToGlobal(shoutPIconTarget);
		shoutPreselectIcon.globalToLocal(shoutPIconTarget);


		if (leftIconLTG.x > leftPreselectIconLTG.x){
			leftTargetX = (leftIcon_mc._width) //If preselect icon is to the left of the main widget animate main widget out to right
		} else {
			leftTargetX = -(leftIcon_mc._width) //If preselect icon is to the right of the main widget animate main widget out to left
		}
		if (rightIconLTG.x > rightPreselectIconLTG.x){
			rightTargetX = (rightIcon_mc._width)
		} else {
			rightTargetX = -(rightIcon_mc._width)
		}
		if (shoutIconLTG.x > shoutPreselectIconLTG.x){
			shoutTargetX = (shoutIcon_mc._width)
		} else {
			shoutTargetX = -(shoutIcon_mc._width)
		}
		
		leftPTargetX = leftPIconTarget.x;
		leftPTargetY = leftPIconTarget.y;
		rightPTargetX = -rightPIconTarget.x;
		rightPTargetY = rightPIconTarget.y;
		shoutPTargetX = shoutPIconTarget.x;
		shoutPTargetY = shoutPIconTarget.y;

		//Store current alpha and scale values ready to reapply
		leftIconAlpha = leftIcon_mc._alpha;
		leftTargetScale = ((leftIcon_mc._xscale / leftPreselectIcon_mc._xscale) * 100);
		leftPTargetRotation = leftIcon_mc._rotation;
		leftPIconAlpha = leftPreselectIcon_mc._alpha;
		leftPIconScale = leftPreselectIcon._xscale;
		rightIconAlpha = rightIcon_mc._alpha;
		rightTargetScale = ((rightIcon_mc._xscale / rightPreselectIcon_mc._xscale) * 100);
		rightPTargetRotation = rightIcon_mc._rotation + 180;
		rightPIconAlpha = rightPreselectIcon_mc._alpha;
		rightPIconScale = rightPreselectIcon._xscale;
		shoutIconAlpha = shoutIcon_mc._alpha;
		shoutTargetScale = ((shoutIcon_mc._xscale / shoutPreselectIcon_mc._xscale) * 100);
		shoutPTargetRotation = shoutIcon_mc._rotation;
		shoutPIconAlpha = shoutPreselectIcon_mc._alpha;
		shoutPIconScale = shoutPreselectIcon._xscale;
		leftNameAlpha = leftName_mc._alpha;
		leftPNameAlpha = leftPreselectName_mc._alpha;
		rightNameAlpha = rightName_mc._alpha;
		rightPNameAlpha = rightPreselectName_mc._alpha;
		shoutNameAlpha = shoutName_mc._alpha;
		shoutPNameAlpha = shoutPreselectName_mc._alpha;

		skse.SendModEvent("iEquip_ReadyForPreselectAnimation", null);

	}

	public function equipPreselectedItem(iSlot: Number, currIcon: String, newIcon: String, newName: String, currPIcon: String, newPIcon: String, newPName: String): Void
	{
		
		var iconClip: MovieClip;
		var iconClip_mc: MovieClip;
		var pIconClip: MovieClip;
		var pIconClip_mc: MovieClip;
		var itemName_mc: MovieClip;
		var preselectName_mc: MovieClip;
		var itemName: TextField;
		var pItemName: TextField;
		var targetX: Number;
		var pTargetX: Number;
		var pTargetY: Number;
		var pTargetRotation: Number;
		var pIconAlpha: Number;
		var pIconScale: Number;
		var pIconTargetScale: Number
		var iconAlpha: Number;
		var itemNameAlpha: Number;
		var preselectNameAlpha: Number;
		
		switch(iSlot) {
			case 0:
				iconClip = leftIcon;
				iconClip_mc = leftIcon_mc;
				pIconClip = leftPreselectIcon;
				pIconClip_mc = leftPreselectIcon_mc;
				itemName_mc = leftName_mc;
				preselectName_mc = leftPreselectName_mc;
				itemName = leftName;
				pItemName = leftPreselectName;
				targetX = leftTargetX;
				pTargetX = leftPTargetX;
				pTargetY = leftPTargetY;
				pTargetRotation = leftPTargetRotation;
				pIconAlpha = leftPIconAlpha;
				pIconScale = leftPIconScale;
				iconAlpha = leftIconAlpha;
				pIconTargetScale = leftTargetScale;
				itemNameAlpha = leftNameAlpha;
				preselectNameAlpha = leftPNameAlpha;
				break
			case 1:
				iconClip = rightIcon;
				iconClip_mc = rightIcon_mc;
				pIconClip = rightPreselectIcon;
				pIconClip_mc = rightPreselectIcon_mc;
				itemName_mc = rightName_mc;
				preselectName_mc = rightPreselectName_mc;
				itemName = rightName;
				pItemName = rightPreselectName;
				targetX = rightTargetX;
				pTargetX = rightPTargetX;
				pTargetY = rightPTargetY;
				pTargetRotation = rightPTargetRotation;
				pIconAlpha = rightPIconAlpha;
				pIconScale = rightPIconScale;
				iconAlpha = rightIconAlpha;
				pIconTargetScale = rightTargetScale;
				itemNameAlpha = rightNameAlpha;
				preselectNameAlpha = rightPNameAlpha;
				break
			case 2:
				iconClip = shoutIcon;
				iconClip_mc = shoutIcon_mc;
				pIconClip = shoutPreselectIcon;
				pIconClip_mc = shoutPreselectIcon_mc;
				itemName_mc = shoutName_mc;
				preselectName_mc = shoutPreselectName_mc;
				itemName = shoutName;
				pItemName = shoutPreselectName;
				targetX = shoutTargetX;
				pTargetX = shoutPTargetX;
				pTargetY = shoutPTargetY;
				pTargetRotation = shoutPTargetRotation;
				pIconAlpha = shoutPIconAlpha;
				pIconScale = shoutPIconScale;
				iconAlpha = shoutIconAlpha;
				pIconTargetScale = shoutTargetScale;
				itemNameAlpha = shoutNameAlpha;
				preselectNameAlpha = shoutPNameAlpha;
				break
			}

		if (itemNameAlpha < 1.0){
			itemNameAlpha = 100
		}
		if (preselectNameAlpha < 1.0){
			preselectNameAlpha = 100
		}

		tempIcon = iconClip.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		iconClip._alpha = 0;
		iconClip.gotoAndStop(newIcon);
		tempPIcon = pIconClip.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = pIconClip_mc._xscale;
		tempPIcon._yscale = pIconClip_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		pIconClip._alpha = 0;
		pIconClip._xscale = 25;
		pIconClip._yscale = 25;
		pIconClip.gotoAndStop(newPIcon);
		skyui.util.Debug.log("iEquip .equipPreselectedItem - newName: " + newName + ", newPName: " + newPName);
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:equipPreselectedItemComplete, onCompleteParams:[iconClip_mc, tempIcon, pIconClip_mc, tempPIcon]});
		tl.to(itemName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(preselectName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [itemName, pItemName, newName, newPName])
		.to(tempIcon, 0.6, {_x:targetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.6, {_x:pTargetX, _y:pTargetY, _rotation: pTargetRotation, _alpha:iconAlpha, _xscale:pIconTargetScale, _yscale:pIconTargetScale, ease:Quad.easeOut}, 0)
		.to(iconClip, 0, {_alpha:iconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(pIconClip, 0.4, {_alpha:pIconAlpha, _xscale:pIconScale, _yscale:pIconScale, ease:Elastic.easeOut}, 0.5)
		.to(itemName_mc, 0.3, {_alpha:itemNameAlpha, ease:Quad.easeOut}, 0.6)
		.to(preselectName_mc, 0.3, {_alpha:preselectNameAlpha, ease:Quad.easeOut}, 0.6);

		tl.play();
	}

	public function updateNamesForEquipPreselect(itemName: TextField, pItemName: TextField, newName: String, newPName: String): Void
	{
		skyui.util.Debug.log("iEquip .updateNamesForEquipPreselect - newName: " + newName + ", newPName: " + newPName);
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		var pTextFormat:TextFormat = pItemName.getTextFormat();
		//Set the new names
		itemName.text = newName;
		pItemName.text = newPName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
		pItemName.setTextFormat(pTextFormat);
	}

	public function equipAllPreselectedItems(swapLeft: Boolean, swapRight: Boolean, swapShout: Boolean, leftCurrIcon: String, leftPCurrIcon: String, leftNewName: String, leftPNewIcon: String, leftPNewName: String, rightCurrIcon: String, rightPCurrIcon: String, rightNewName: String, rightPNewIcon: String, rightPNewName: String, shoutCurrIcon: String, shoutPCurrIcon: String, shoutNewName: String, shoutPNewIcon: String, shoutPNewName: String): Void
	{
		//Set the counter at +1 per slot being animated
		EquipAllCounter = 0
		if (swapRight){
			EquipAllCounter += 1
		}
		if (swapLeft){
			EquipAllCounter += 1
		}
		if (swapShout){
			EquipAllCounter += 1
		}
		skyui.util.Debug.log("iEquip .equipAllPreselectedItems - EquipAllCounter: " + EquipAllCounter);
		//Play the animations
		if (swapRight){
			equipPreselectedItem(1, rightCurrIcon, rightPCurrIcon, rightNewName, rightPCurrIcon, rightPNewIcon, rightPNewName)
		}
		if (swapLeft){
			equipPreselectedItem(0, leftCurrIcon, leftPCurrIcon, leftNewName, leftPCurrIcon, leftPNewIcon, leftPNewName)
		}
		if (swapShout){
			equipPreselectedItem(2, shoutCurrIcon, shoutPCurrIcon, shoutNewName, shoutPCurrIcon, shoutPNewIcon, shoutPNewName)
		}
	}

	public function equipPreselectedItemWithoutNewPreselect(iSlot: Number, currIcon: String, newIcon: String, newName: String, currPIcon: String): Void
	{
		
		var iconClip: MovieClip;
		var iconClip_mc: MovieClip;
		var pIconClip: MovieClip;
		var pIconClip_mc: MovieClip;
		var itemName_mc: MovieClip;
		var preselectName_mc: MovieClip;
		var itemName: TextField;
		var pItemName: TextField;
		var targetX: Number;
		var pTargetX: Number;
		var pTargetY: Number;
		var pTargetRotation: Number;
		var pIconAlpha: Number;
		var pIconScale: Number;
		var pIconTargetScale: Number
		var iconAlpha: Number;
		var itemNameAlpha: Number;
		
		switch(iSlot) {
			case 0:
				iconClip = leftIcon;
				iconClip_mc = leftIcon_mc;
				pIconClip = leftPreselectIcon;
				pIconClip_mc = leftPreselectIcon_mc;
				itemName_mc = leftName_mc;
				preselectName_mc = leftPreselectName_mc;
				itemName = leftName;
				pItemName = leftPreselectName;
				targetX = leftTargetX;
				pTargetX = leftPTargetX;
				pTargetY = leftPTargetY;
				pTargetRotation = leftPTargetRotation;
				pIconAlpha = leftPIconAlpha;
				pIconScale = leftPIconScale;
				iconAlpha = leftIconAlpha;
				pIconTargetScale = leftTargetScale;
				itemNameAlpha = leftNameAlpha;
				break
			case 1:
				iconClip = rightIcon;
				iconClip_mc = rightIcon_mc;
				pIconClip = rightPreselectIcon;
				pIconClip_mc = rightPreselectIcon_mc;
				itemName_mc = rightName_mc;
				preselectName_mc = rightPreselectName_mc;
				itemName = rightName;
				pItemName = rightPreselectName;
				targetX = rightTargetX;
				pTargetX = rightPTargetX;
				pTargetY = rightPTargetY;
				pTargetRotation = rightPTargetRotation;
				pIconAlpha = rightPIconAlpha;
				pIconScale = rightPIconScale;
				iconAlpha = rightIconAlpha;
				pIconTargetScale = rightTargetScale;
				itemNameAlpha = rightNameAlpha;
				break
			case 2:
				iconClip = shoutIcon;
				iconClip_mc = shoutIcon_mc;
				pIconClip = shoutPreselectIcon;
				pIconClip_mc = shoutPreselectIcon_mc;
				itemName_mc = shoutName_mc;
				preselectName_mc = shoutPreselectName_mc;
				itemName = shoutName;
				pItemName = shoutPreselectName;
				targetX = shoutTargetX;
				pTargetX = shoutPTargetX;
				pTargetY = shoutPTargetY;
				pTargetRotation = shoutPTargetRotation;
				pIconAlpha = shoutPIconAlpha;
				pIconScale = shoutPIconScale;
				iconAlpha = shoutIconAlpha;
				pIconTargetScale = shoutTargetScale;
				itemNameAlpha = shoutNameAlpha;
				break
			}

		if (itemNameAlpha < 1.0){
			itemNameAlpha = 100
		}

		tempIcon = iconClip.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		iconClip._alpha = 0;
		iconClip.gotoAndStop(newIcon);
		tempPIcon = pIconClip.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = pIconClip_mc._xscale;
		tempPIcon._yscale = pIconClip_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		pIconClip._alpha = 0;
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:equipPreselectedItemComplete, onCompleteParams:[iconClip_mc, tempIcon, pIconClip_mc, tempPIcon]});
		tl.to(itemName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(preselectName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselectWithoutNewPreselect, [itemName, newName])
		.to(tempIcon, 0.6, {_x:targetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.6, {_x:pTargetX, _y:pTargetY, _rotation: pTargetRotation, _alpha:iconAlpha, _xscale:pIconTargetScale, _yscale:pIconTargetScale, ease:Quad.easeOut}, 0)
		.to(iconClip, 0, {_alpha:iconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(itemName_mc, 0.3, {_alpha:itemNameAlpha, ease:Quad.easeOut}, 0.6)

		tl.play();
	}

	public function updateNamesForEquipPreselectWithoutNewPreselect(itemName: TextField, newName: String): Void
	{
		skyui.util.Debug.log("iEquip .updateNamesForEquipPreselectWithoutNewPreselect - newName: " + newName);
		//Save the current text formatting to preserve any Edit Mode changes
		var textFormat:TextFormat = itemName.getTextFormat();
		//Set the new names
		itemName.text = newName;
		//Restore the text formatting
		itemName.setTextFormat(textFormat);
	}

	public function equipAllPreselectedItemsAndTogglePreselect(swapLeft: Boolean, swapRight: Boolean, swapShout: Boolean, leftCurrIcon: String, leftPCurrIcon: String, leftNewName: String, rightCurrIcon: String, rightPCurrIcon: String, rightNewName: String, shoutCurrIcon: String, shoutPCurrIcon: String, shoutNewName: String): Void
	{
		//Set the counter at +1 per slot being animated
		EquipAllCounter = 0
		if (swapRight){
			EquipAllCounter += 1
		}
		if (swapLeft){
			EquipAllCounter += 1
		}
		if (swapShout){
			EquipAllCounter += 1
		}
		skyui.util.Debug.log("iEquip .equipAllPreselectedItems - EquipAllCounter: " + EquipAllCounter);
		//Play the animations
		if (swapRight){
			equipPreselectedItemWithoutNewPreselect(1, rightCurrIcon, rightPCurrIcon, rightNewName, rightPCurrIcon)
		}
		if (swapLeft){
			equipPreselectedItemWithoutNewPreselect(0, leftCurrIcon, leftPCurrIcon, leftNewName, leftPCurrIcon)
		}
		if (swapShout){
			equipPreselectedItemWithoutNewPreselect(2, shoutCurrIcon, shoutPCurrIcon, shoutNewName, shoutPCurrIcon)
		}
	}

	public function equipPreselectedItemComplete(iconClip_mc: MovieClip, tempIcon: MovieClip, pIconClip_mc: MovieClip, tempPIcon: MovieClip): Void
	{		
		skyui.util.Debug.log("iEquip .equipPreselectedItemComplete - EquipAllCounter: " + EquipAllCounter);
		//Delete the temporary movieclips
		iconClip_mc.tempIcon.removeMovieClip();
		pIconClip_mc.tempPIcon.removeMovieClip();
		//Check the counter to see if we're equipping all preselected
		if (EquipAllCounter > 0){
			//Count down until all calls are made
			EquipAllCounter -= 1
			skyui.util.Debug.log("iEquip .equipPreselectedItemComplete - EquipAllCounter: " + EquipAllCounter);
			if (EquipAllCounter == 0){
				skyui.util.Debug.log("iEquip .equipPreselectedItemComplete - About to send iEquip_EquipAllComplete mod event");
				//And let Papyrus know so the function can complete
				skse.SendModEvent("iEquip_EquipAllComplete")
			}
		}
	}

	public function prepareForAmmoModeAnimation(animateIn: Boolean, backgroundsShown: Boolean): Void
	{		
		var leftIconLTG:Object = {x:0, y:0};
		var leftPreselectIconLTG:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftIconLTG);
		leftPreselectIcon.localToGlobal(leftPreselectIconLTG);

		var leftPIconTarget:Object = {x:0, y:0};
		var leftIconTarget:Object = {x:0, y:0};

		leftIcon.localToGlobal(leftPIconTarget);
		leftPreselectIcon.globalToLocal(leftPIconTarget);

		leftPreselectIcon.localToGlobal(leftIconTarget);
		leftIcon.globalToLocal(leftIconTarget);

		if (!animateIn){
			if (leftIconLTG.x > leftPreselectIconLTG.x){
				leftTargetX = (leftIcon_mc._width) //If preselect icon is to the left of the main widget animate main widget out to right
			} else {
				leftTargetX = -(leftIcon_mc._width) //If preselect icon is to the right of the main widget animate main widget out to left
			}
		} else {
			leftTargetX = leftIconTarget.x;
			leftTargetY = leftIconTarget.y;
		}
				
		leftPTargetX = leftPIconTarget.x;
		leftPTargetY = leftPIconTarget.y;

		//Reset the preselect icon scale
		leftPreselectIcon._xscale = 100;
		leftPreselectIcon._yscale = 100;

		//Store current alpha and scale values ready to reapply
		leftIconAlpha = leftIcon_mc._alpha;
		if (!animateIn){
			leftTargetScale = ((leftIcon_mc._xscale / leftPreselectIcon_mc._xscale) * 100);
		} else {
			leftTargetScale = ((leftPreselectIcon_mc._xscale / leftIcon_mc._xscale) * 100);
		}
		leftPIconAlpha = 100;
		leftPIconScale = 100;
		leftNameAlpha = leftName_mc._alpha;
		leftPNameAlpha = leftPreselectName_mc._alpha;

		leftPreselectBg_mc._visible = backgroundsShown

		skse.SendModEvent("iEquip_ReadyForAmmoModeAnimation", null);
	}

	public function ammoModeAnimateIn(currIcon: String, currName: String, newIcon: String, newName: String): Void
	{		
		if (leftNameAlpha < 1.0){
			leftNameAlpha = 100
		}
		if (leftPNameAlpha < 1.0){
			leftPNameAlpha = 100
		}
		skyui.util.Debug.log("iEquip .ammoModeAnimateIn - currIcon: " + currIcon + ", currName: " + currName + ", newIcon: " + newIcon + ", newName: " + newName + ", leftNameAlpha: " + leftNameAlpha + ", leftPNameAlpha: " + leftPNameAlpha);
		tempIcon = leftIcon.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		leftIcon._alpha = 0;
		leftIcon._xscale = 25;
		leftIcon._yscale = 25;
		leftIcon.gotoAndStop(newIcon);
		leftPreselectIcon._alpha = 0;
		leftPreselectIcon.gotoAndStop(currIcon);
		leftPreselectIcon_mc._visible = true
		leftPreselectName_mc._visible = true
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:AmmoModeAnimateInComplete, onCompleteParams:[leftIcon_mc, tempIcon]});
		tl.to(leftName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [leftName, leftPreselectName, newName, currName])
		.to(tempIcon, 0.6, {_x:leftTargetX, _y:leftTargetY, _rotation:0, _alpha:leftPIconAlpha, _xscale:leftTargetScale, _yscale:leftTargetScale, ease:Quad.easeOut}, 0)
		.to(leftPreselectIcon, 0, {_alpha:leftPIconAlpha, ease:Linear.easeNone})
		.to(leftIcon, 0.4, {_alpha:leftIconAlpha, _xscale:100, _yscale:100, ease:Elastic.easeOut}, 0.3)
		.to(leftPreselectBg, 0.4, {_rotation:180, _alpha:100, ease:Back.easeOut}, 0.4)
		.to(leftName_mc, 0.3, {_alpha:leftNameAlpha, ease:Quad.easeOut}, 0.6)
		.to(leftPreselectName_mc, 0.3, {_alpha:leftPNameAlpha, ease:Quad.easeOut}, 0.6);

		tl.play();
	}

	public function ammoModeAnimateOut(currIcon: String, currPIcon: String, newName: String): Void
	{
		if (leftNameAlpha < 1.0){
			leftNameAlpha = 100
		}
		var targetRotation: Number = leftIcon_mc._rotation
		tempIcon = leftIcon.duplicateMovieClip("tempIcon", this.getNextHighestDepth());
		tempIcon.gotoAndStop(currIcon);
		leftIcon._alpha = 0;
		leftIcon.gotoAndStop(currPIcon);
		tempPIcon = leftPreselectIcon.duplicateMovieClip("tempPIcon", this.getNextHighestDepth());
		tempPIcon._xscale = leftPreselectIcon_mc._xscale;
		tempPIcon._yscale = leftPreselectIcon_mc._yscale;
		tempPIcon.gotoAndStop(currPIcon);
		leftPreselectIcon._alpha = 0;
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:AmmoModeAnimateOutComplete, onCompleteParams:[leftIcon_mc, tempIcon, leftPreselectIcon_mc, tempPIcon]});
		tl.to(leftName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.to(leftPreselectName_mc, 0.3, {_alpha:0, ease:Quad.easeOut}, 0)
		.call(updateNamesForEquipPreselect, [leftName, leftPreselectName, newName, ""])
		.to(tempIcon, 0.6, {_x:leftTargetX, _y:((tempIcon._height) / 2), _rotation:"+=90", _alpha:0, _xscale:25, _yscale:25, ease:Quad.easeOut}, 0)
		.to(tempPIcon, 0.6, {_x:leftPTargetX, _y:leftPTargetY, _rotation:targetRotation, _alpha:leftIconAlpha, _xscale:leftTargetScale, _yscale:leftTargetScale, ease:Quad.easeOut}, 0)
		.to(leftPreselectBg, 0.4, {_rotation:"-=120", _alpha:0, ease:Back.easeOut}, 0)
		.to(leftIcon, 0, {_alpha:leftIconAlpha, ease:Linear.easeNone})
		.to(tempPIcon, 0, {_alpha:0, ease:Linear.easeNone})
		.to(leftName_mc, 0.3, {_alpha:leftNameAlpha, ease:Quad.easeOut}, 0.6);

		tl.play();
	}

	public function AmmoModeAnimateInComplete(iconClip_mc: MovieClip, tempIcon: MovieClip): Void
	{		
		//Delete the temporary movieclip
		iconClip_mc.tempIcon.removeMovieClip();
		skse.SendModEvent("iEquip_AmmoModeAnimationComplete", null);
	}

	public function AmmoModeAnimateOutComplete(iconClip_mc: MovieClip, tempIcon: MovieClip, pIconClip_mc: MovieClip, tempPIcon: MovieClip): Void
	{		
		//Delete the temporary movieclip
		iconClip_mc.tempIcon.removeMovieClip();
		pIconClip_mc.tempPIcon.removeMovieClip();
		skse.SendModEvent("iEquip_AmmoModeAnimationComplete", null);
	}
	
	public function fadeOut(a_alpha: Number, duration: Number): Void
	{
		TweenLite.to(this, duration, {_alpha:a_alpha});
	}
	
	public function setCurrentClip(a_clip: Number): Void
	{
		clip = clipArray[a_clip];
	}
	
	//GlowFilter - Distance, Angle, Color, Alpha, Blur X, Blur Y, Strength, Quality, Inner Shadow, Knockout & Hide Object
	public function highlightSelectedElement(isText:Number, arrayIndex:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[arrayIndex];
			selectedText.textColor = highlightColor;
		}
		else {
			var myColor:Color = new Color(clip);
			myColor.setRGB(highlightColor);
		}
	}

	/*public function highlightSelectedElement(isText:Number, arrayIndex:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[arrayIndex];
			selectedText.textColor = highlightColor;
		}
		else {
			tempHighlightedClip = clip.duplicateMovieClip("tempClip", this.getNextHighestDepth());
			var myColor:Color = new Color(tempHighlightedClip);
			myColor.setRGB(highlightColor);
		}
	}*/
	
	public function removeCurrentHighlight(isText:Number, textElement:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[textElement];
			selectedText.textColor = currentColor;
		}
		else if (clip == consumableIcon_mc){
			switch(_global.potionType){
				case "HealthPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0xDB2E73);
					break;
				case "StaminaPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0x51DB2E);
					break;
				case "MagickaPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0x2E9FDB);
					break;
				case "FrostResistPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0x1FFBFF);
					break;
				case "FireResistPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0xC73636);
					break;
				case "ShockResistPotion":
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0xEAAB00);
					break;
				default:
					var pIconColor = new Color(consumableIcon_mc);
					pIconColor.setRGB(0xFFFFFF);
					break
				}
		}
		else if (clip == poisonIcon_mc){
			var pIconColor = new Color(poisonIcon_mc);
			pIconColor.setRGB(0xAD00B3);
		}
		else {
			var myColor:Color = new Color(clip);
			myColor.setRGB(0xFFFFFF);
		}
	}

	/*public function removeCurrentHighlight(isText:Number, textElement:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[textElement];
			selectedText.textColor = currentColor;
		} else {
			clip.tempHighlightedClip.removeMovieClip();
		}
	}*/
	
	public function setTextAlignment(textElement: Number, a_align: Number): Void
	{
		var format:TextFormat = new TextFormat();
		if (a_align == 0){
			format.align = "left";
		}
		else if (a_align == 1){
			format.align = "center";
		}
		else {
			format.align = "right";
		}
		selectedText = textElementArray[textElement];
		selectedText.setTextFormat(format);
	}

	public function setTextColor(textElement: Number, currentColor: Number): Void
	{
		selectedText = textElementArray[textElement];
		selectedText.textColor = currentColor;
	}
	
	public function tweenIt(tweenType: Number, endValue: Number, secs: Number): Void
	{
		//tweenType = Attribute to change: 0 = _x, 1 = _y, 2 = _xscale/_yscale, 3 =  _rotation, 4 = _alpha
		switch(tweenType) {
			case 0:
				TweenLite.to(clip, secs, {_x:endValue, ease:Quad.easeOut});
				break
			case 1:
				TweenLite.to(clip, secs, {_y:endValue, ease:Quad.easeOut});
				break
			case 2:
				TweenLite.to(clip, secs, {_xscale:endValue, _yscale:endValue, ease:Quad.easeOut});
				break
			case 3:
				TweenLite.to(clip, secs, {_rotation:endValue, ease:Quad.easeOut});
				break
			case 4:
				TweenLite.to(clip, secs, {_alpha:endValue, ease:Quad.easeOut});
				break
			}
	}

	public function tweenWidgetNameAlpha(clipIndex: Number, endValue: Number, secs: Number): Void
	{
		var nameClip: MovieClip = clipArray[clipIndex];
		TweenLite.to(nameClip, secs, {_alpha:endValue, ease:Quad.easeOut});
	}

	public function tweenLeftIconAlpha(bgAlpha: Number, iconAlpha: Number, nameAlpha: Number, countAlpha: Number, poisonIconAlpha: Number, poisonNameAlpha: Number): Void
	{
		var bgClip: MovieClip = leftBg_mc
		var iconClip: MovieClip = leftIcon_mc
		var nameClip: MovieClip = leftName_mc
		var countClip: MovieClip = leftCount_mc
		var poisonIconClip: MovieClip = leftPoisonIcon_mc
		var poisonNameClip: MovieClip = leftPoisonName_mc
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(bgClip, 0.3, {_alpha:bgAlpha, ease:Quad.easeOut}, 0)
		.to(iconClip, 0.3, {_alpha:iconAlpha, ease:Quad.easeOut}, 0)
		.to(nameClip, 0.3, {_alpha:nameAlpha, ease:Quad.easeOut}, 0)
		.to(countClip, 0.3, {_alpha:countAlpha, ease:Quad.easeOut}, 0)
		.to(poisonIconClip, 0.3, {_alpha:poisonIconAlpha, ease:Quad.easeOut}, 0)
		.to(poisonNameClip, 0.3, {_alpha:poisonNameAlpha, ease:Quad.easeOut}, 0);
		tl.play();
	}

	public function tweenConsumableIconAlpha(bgAlpha: Number, iconAlpha: Number, nameAlpha: Number, countAlpha: Number): Void
	{
		var bgClip: MovieClip = consumableBg_mc
		var iconClip: MovieClip = consumableIcon_mc
		var nameClip: MovieClip = consumableName_mc
		var countClip: MovieClip = consumableCount_mc
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(bgClip, 0.3, {_alpha:bgAlpha, ease:Quad.easeOut}, 0)
		.to(iconClip, 0.3, {_alpha:iconAlpha, ease:Quad.easeOut}, 0)
		.to(nameClip, 0.3, {_alpha:nameAlpha, ease:Quad.easeOut}, 0)
		.to(countClip, 0.3, {_alpha:countAlpha, ease:Quad.easeOut}, 0)
		tl.play();
	}

	public function runPotionFlashAnimation(potionType: Number): Void
	{
		switch(potionType) {
			case 0:
				potionFlashAnim.gotoAndStop("Health");
				break
			case 1:
				potionFlashAnim.gotoAndStop("Stamina");
				break
			case 2:
				potionFlashAnim.gotoAndStop("Magicka");
				break
			}
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true, onComplete:onPotionFlashComplete});
		tl.to(potionFlashAnim, 0.3, {_alpha:100, ease:Quad.easeOut}, 0)
		.to(potionFlashAnim, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(potionFlashAnim, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(potionFlashAnim, 0.3, {_alpha:0, ease:Quad.easeOut})
		tl.play();
	}

	public function onPotionFlashComplete(): Void
	{
		potionFlashAnim.gotoAndStop("Hide");
	}
 
	public function tweenWidgetCounterAlpha(clipIndex: Number, endValue: Number, secs: Number): Void
	{
		var counterClip: MovieClip;
		switch(clipIndex) {
			case 0:
				counterClip = leftCount_mc;
				break
			case 1:
				counterClip = rightCount_mc;
				break
			case 3:
				counterClip = consumableCount_mc;
				break
			case 4:
				counterClip = poisonCount_mc;
				break
			}
		TweenLite.to(counterClip, secs, {_alpha:endValue, ease:Quad.easeOut});
	}

	public function swapItemDepths(iItemToMoveToFront: Number, iItemToSendToBack: Number): Void
	{
		var clip1: MovieClip = clipArray[iItemToMoveToFront];
		var clip2: MovieClip = clipArray[iItemToSendToBack];
		clip1.swapDepths(clip2);
	}

	public function getCurrentItemDepth(iClip: Number): Void
	{
		var clip1: MovieClip = clipArray[iClip];
		var clipDepth: Number = clip1.getDepth();
		skse.SendModEvent("iEquip_GotDepth", null, clipDepth);
	}

	public function updateCounter(target: Number, a_count: Number): Void
	{
		var targetCount: TextField;
		switch(target) {
			case 0:
				targetCount = leftCount;
				break
			case 1:
				targetCount = rightCount;
				break
			case 3:
				targetCount = consumableCount;
				break
			case 4:
				targetCount = poisonCount;
				break
			}
		var textFormat:TextFormat = targetCount.getTextFormat();
		targetCount.text = String(a_count);
		targetCount.setTextFormat(textFormat);
	}

	public function updatePoisonIcon(target: Number, sIcon: String): Void
	{
		var poisonIcon: MovieClip;
		var poisonIcon_mc: MovieClip;

		switch(target) {
			case 0:
				poisonIcon = leftPoisonIcon;
				poisonIcon_mc = leftPoisonIcon_mc;
				break
			case 1:
				poisonIcon = rightPoisonIcon;
				poisonIcon_mc = rightPoisonIcon_mc;
				break
			}
		var currAlpha = poisonIcon_mc._alpha; 
		TweenLite.to(poisonIcon_mc, 0.15, {_alpha:0, ease:Quad.easeOut});
		poisonIcon.gotoAndStop(sIcon);
		TweenLite.to(poisonIcon_mc, 0.2, {_alpha:currAlpha, ease:Quad.easeOut});
	}
	
	// @overrides WidgetBase
	public function getWidth(): Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight(): Number
	{
		return _height;
	}
	public function setRootScale(scale: Number): Void
	{
		_xscale = scale;
		_yscale = scale;
	}

	public function generateItemID(displayName: String, formID: Number): Void
	{
		var itemID: Number = skyui.util.Hash.crc32(displayName, formID & 0x00FFFFFF);
		var IDString: String = itemID.toString()
		skyui.util.Debug.log("iEquipWidget generateItemID - displayName: " + displayName + ", formID: " + formID + ", generated itemID: " + itemID + ", IDString: " + IDString)
		skse.SendModEvent("iEquip_GotItemID", IDString, itemID);
	}
}
