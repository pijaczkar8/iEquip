import skyui.widgets.WidgetBase;

//import mx.transitions.Tween;
//import mx.transitions.easing.*;

import com.greensock.TweenLite;
import com.greensock.easing.*;

import skyui.defines.Item
import skyui.defines.Actor
import skyui.defines.Form
import skyui.defines.Weapon
import flash.geom.ColorTransform;
import flash.geom.Transform;

class skyui.widgets.iEquip.iEquipWidget extends WidgetBase
{	
  /* STAGE ELEMENTS */
	//Main MovieClips
	public var LeftHandWidget: MovieClip;
	public var RightHandWidget: MovieClip;
	public var ShoutWidget: MovieClip;
	public var PotionWidget: MovieClip;
	public var EditModeGuide: MovieClip;
	
	//Widget icon holder MovieClips
	public var leftIcon_mc: MovieClip;
	public var rightIcon_mc: MovieClip;
	public var shoutIcon_mc: MovieClip;
	public var potionIcon_mc: MovieClip;
	
	//Widget text field holder MovieClips
	public var leftName_mc: MovieClip;
	public var rightName_mc: MovieClip;
	public var shoutName_mc: MovieClip;
	public var potionName_mc: MovieClip;
	public var potionCount_mc: MovieClip;
	
	//Widget Text Fields
	public var leftName: TextField;
	public var shoutName: TextField;
	public var rightName: TextField;
	public var potionName: TextField;
	public var potionCount: TextField;
	
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
	
	public var MAX_QUEUE_SIZE: Number;
	
	public var queueIndex: Array;
  
  	public var leftIcon: Object;
	public var shoutIcon: Object;
	public var rightIcon: Object;
	public var potionIcon: Object;
	
	public var ERR:String;
	//public var currTween: Tween;
	//public var currTween2: Tween;

	//This contains the data for every item in the queue
	public var itemData:Array;
	public var lastUsedIndex: Number;
	public var currentPotionSlot: Number;
	public var highlightColor: Number;
	
	public var clip: MovieClip;
	public var clipArray: Array;
	public var selectedText: TextField;
	public var textElementArray: Array;
	public var attributeArray: Array;

	
  /* INITIALIZATION */

	public function iEquipWidget()
	{
		super();
		itemData = new Array(28);
		for(var i = 0; i < 28; i++){
			itemData[i] = new Array("", 0, 0, 0, 0, 0);
		}
		_visible = false;

		Mouse.addListener(this);

		MAX_QUEUE_SIZE = 7;
		queueIndex = new Array(0,0,0,0);
		
		//Set up the icon and text field holder MovieClips
		leftIcon_mc = LeftHandWidget.leftIcon_mc;
		rightIcon_mc = RightHandWidget.rightIcon_mc;
		shoutIcon_mc = ShoutWidget.shoutIcon_mc;
		potionIcon_mc = PotionWidget.potionIcon_mc;
		leftName_mc = LeftHandWidget.leftName_mc;
		rightName_mc = RightHandWidget.rightName_mc;
		shoutName_mc = ShoutWidget.shoutName_mc;
		potionName_mc = PotionWidget.potionName_mc;
		potionCount_mc = PotionWidget.potionCount_mc;
		
		//Set up the icon object paths
		leftIcon = LeftHandWidget.leftIcon_mc.leftIcon;
		rightIcon = RightHandWidget.rightIcon_mc.rightIcon;
		shoutIcon = ShoutWidget.shoutIcon_mc.shoutIcon;
		potionIcon = PotionWidget.potionIcon_mc.potionIcon;
		
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
		shoutName = ShoutWidget.shoutName_mc.shoutName;
		leftName = LeftHandWidget.leftName_mc.leftName;
		rightName = RightHandWidget.rightName_mc.rightName;
		potionName = PotionWidget.potionName_mc.potionName;
		potionCount = PotionWidget.potionCount_mc.potionCount;
		shoutName.text = "";
		leftName.text = "";
		rightName.text = "";
		potionName.text = "";
		potionCount.text = "";
		shoutName.textAutoSize = "shrink";
		leftName.textAutoSize = "shrink";
		rightName.textAutoSize = "shrink";
		potionName.textAutoSize = "shrink";
		potionCount.textAutoSize = "shrink";
		
		//Set up arrays of MovieClips and attributes and two tweens for use in tweenIt()
		clipArray = new Array(ShoutWidget, LeftHandWidget, RightHandWidget, PotionWidget, shoutIcon_mc, shoutName_mc, leftIcon_mc, leftName_mc, rightIcon_mc, rightName_mc, potionIcon_mc, potionName_mc, potionCount_mc);
		textElementArray = new Array(null, null,null, null, null, shoutName, null, leftName, null, rightName, null, potionName, potionCount);
		//attributeArray = new Array("_x", "_y", "_xscale", "_yscale", "_rotation", "_alpha");
		//currTween = new Tween();
		//currTween2 = new Tween();
		highlightColor = 0x00A1FF;
		
		ERR = new String("HI");
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

  /* PUBLIC FUNCTIONS */
  	public function setItemName(nameStr: String): Void{
		itemData[lastUsedIndex][0] = nameStr;
	}
 	public function setItemData(/*arguments*/): Void{
		//arguments:
		//[0] Queue ID
		//[1] Slot ID
		//[2] Form Type
		//[3] Weapon or Spell Type
		
		//itemData:
		//[0] Name (string)
		//[1] Icon (int, frame #)
		//[2] Color ?
		//[3] Active or not (int)
		var queueID = arguments[0];
		var arrayIndex:Number = queueID*MAX_QUEUE_SIZE + arguments[1];
		lastUsedIndex = arrayIndex;
		if(queueID == 2){
			itemData[arrayIndex][1] = getShoutIcon(arguments[2]);
		}
		else if(queueID == 0 || queueID == 1){
			itemData[arrayIndex][1] = getHandIcon(arguments[2], arguments[3]);
		}
		else if(queueID == 3){
			var iconData:Array = processPotionIcon(arguments[3]);
			itemData[arrayIndex][1] = iconData[0];
			itemData[arrayIndex][2] = iconData[1];
		}
		if(arguments[2]){
			itemData[arrayIndex][3] = 1;
		}
		else{
			itemData[arrayIndex][3] = 0;
		}
	}
	
	public function cycleLeftHand(slot: Number, assignmentMode: Number): Void{
		//Set the name
		var textFormat:TextFormat = leftName.getTextFormat();
		leftName.text = itemData[slot][0];
		leftName.setTextFormat(textFormat);
		//Set the Icon
		leftIcon.gotoAndStop(itemData[slot][1]);
		//Color the gem
//		updateQueue(slot, 0, assignmentMode);
	}
	public function cycleRightHand(slot: Number, assignmentMode: Number): Void{
		var i:Number = MAX_QUEUE_SIZE + slot;
		var textFormat:TextFormat = rightName.getTextFormat();
		rightName.text = itemData[i][0];
		rightName.setTextFormat(textFormat);
		rightIcon.gotoAndStop(itemData[i][1]);
//		updateQueue(slot, 1, assignmentMode);
	}
	public function cycleShout(slot: Number, assignmentMode: Number): Void{
		var i:Number = MAX_QUEUE_SIZE*2 + slot;
		var textFormat:TextFormat = shoutName.getTextFormat();
		shoutName.text = itemData[i][0];
		shoutName.setTextFormat(textFormat);
		shoutIcon.gotoAndStop(itemData[i][1]);
//		updateQueue(slot, 2, assignmentMode);
	}
	public function cyclePotion(slot: Number, assignmentMode: Number): Void{
		currentPotionSlot = slot
		var i:Number = MAX_QUEUE_SIZE*3 + slot;
		var textFormat:TextFormat = potionName.getTextFormat();
		potionName.text = itemData[i][0];
		potionName.setTextFormat(textFormat);
		potionIcon.gotoAndStop(itemData[i][1]);
		var pIconColor = new Color(potionIcon_mc);
		pIconColor.setRGB(itemData[i][2]);
//		updateQueue(slot, 3, assignmentMode);
	}
  	/*public function updateQueue(index: Number, queueID: Number, assignmentMode: Number): Void{
		var Queue: Array;
		if(arguments[1] == 0){
			Queue = LH_slotArray;
		}
		else if(arguments[1] == 1){
			Queue = RH_slotArray;
		}
		else if(arguments[1] == 2){
			Queue = S_slotArray;
		}
		else{
			Queue = P_slotArray;
		}
		var oldIndex:Number = queueIndex[queueID];
		queueIndex[queueID] = index;
	
		outermost to innermost
		var color1:Color = new Color(Queue[index*3]);
		var color2:Color = new Color(Queue[index*3 + 1]);
		var color3:Color = new Color(Queue[index*3 + 2]);
		var oldColor1:Color = new Color(Queue[oldIndex*3]);
		var oldColor2:Color = new Color(Queue[oldIndex*3 + 1]);
		var oldColor3:Color = new Color(Queue[oldIndex*3 + 2]);
		//If the old index has an item in it, it is to be colored slightly more brightly
		//var arrayIndex: Number = queueID*MAX_QUEUE_SIZE + index;
		//if(itemData[arrayIndex][3]){
		//	oldColor1.setRGB(0xFFFFFF);
		//	oldColor2.setRGB(0x2288BB);
		//	oldColor3.setRGB(0x222277);
		//}
		//else{

			oldColor1.setRGB(0x888888);
			oldColor2.setRGB(0x444444);
			oldColor3.setRGB(0x222222);
		//}
		//Set new gem color
		if(assignmentMode){
			color1.setRGB(0xFF0000);
			color2.setRGB(0x990000);
			color3.setRGB(0x220000);
		}
		else{
			color1.setRGB(0xFFFFFF);
			color2.setRGB(0x33AAFF);
			color3.setRGB(0x2244FF);

		}
	}*/
	
	/*public function setRHIcon(): Void
	{
		var frame:Number = getHandIcon(arguments);
		rightIcon.gotoAndStop(frame);
	}
	public function setLHIcon(): Void
	{
		var frame:Number = getHandIcon(arguments);
		leftIcon.gotoAndStop(frame);
	}*/
	public function getShoutIcon(formType: Number): Number
	{
		//args[0] = formType.  22 for spells, 119 for shouts
		if(formType == Form.TYPE_SPELL){
			return 20;
		}
		else if(formType == Form.TYPE_SHOUT){
			return 19;
		}
		else{
			return 0;
		}
	}
	
	private function getHandIcon(formType: Number, subType: Object): Number {
		switch(formType) {
			case Form.TYPE_SPELL:
				return processSpellIcon(subType);
			
			case Form.TYPE_WEAPON:
				return processWeaponIcon(subType);
			
			case Form.TYPE_ARMOR: //The only armor piece that can be in the queue is the shield
				return 45;
				
			case Form.TYPE_LIGHT://Torch
				return 114;
			case 0:
				return 0;
			default:
				//Returns a hand icon
				return 49;
		}
		
	}
	private function processPotionIcon(potionType: Object): Array {
		var args:Array = new Array(2);
		switch(potionType){
			case Item.POTION_FOOD:
				args[0] = 79;
				args[1] = 0xFFFFFF
				break;
			case Item.POTION_POISON:
				args[0] = 89;
				args[1] = 0xAD00B3;
				break;
			case Item.POTION_HEALTH:
				args[0] = 86;
				args[1] = 0xDB2E73
				break;
			case Item.POTION_STAMINA:
				args[0] = 87;
				args[1] = 0x51DB2E;
				break;
			case Item.POTION_MAGICKA:
				args[0] = 88;
				args[1] = 0x2E9FDB;
				break;
			case Item.POTION_FROSTRESIST:
				args[0] = 90;
				args[1] = 0x1FFBFF;
				break;
			case Item.POTION_FIRERESIST:
				args[0] = 91;
				args[1] = 0xC73636;
				break;
			case Item.POTION_ELECTRICRESIST:
				args[0] = 92;
				args[1] = 0xEAAB00;
				break;
			default:
				args[0] = 85;
				args[1] = 0xFFFFFF;
		}
		return args;
	}
	private function processSpellIcon(spellType: Object): Number {
		switch(spellType){
			case Actor.AV_ALTERATION:
				return 14;
			case Actor.AV_ILLUSION:
				return 15;
			case Actor.AV_DESTRUCTION:
				return 16
			case Actor.AV_CONJURATION:
				return 17;
			case Actor.AV_RESTORATION:
				return 18
			default:
				return 16;
		}
	}
	private function processWeaponIcon(weaponType: Object): Number
	{
		switch(weaponType) {
			case Weapon.TYPE_SWORD:
				return 22;

			case Weapon.TYPE_DAGGER:
				return 26;

			case Weapon.TYPE_WARAXE:
				return 27;
				break;

			case Weapon.TYPE_MACE:
				return 29;
				break;

			case Weapon.TYPE_GREATSWORD:
				return 24;

			case Weapon.TYPE_BATTLEAXE:
				return 28;

			case Weapon.TYPE_WARHAMMER:
				return 30;

			case Weapon.TYPE_BOW:
				return 32;

			case Weapon.TYPE_STAFF:
				return 31;

			case Weapon.TYPE_CROSSBOW:
				return 36;
			case 0:
				return 41;
			default:
				return 22;
		}
	}
	
	// @Papyrus
	
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
	
	public function removeCurrentHighlight(isText:Number, textElement:Number, currentColor:Number): Void
	{
		if (isText == 1){
			selectedText = textElementArray[textElement];
			selectedText.textColor = currentColor;
		}
		else if (clip == potionIcon_mc){
			var i:Number = MAX_QUEUE_SIZE*3 + currentPotionSlot;
			var pIconColor = new Color(potionIcon_mc);
			pIconColor.setRGB(itemData[i][2]);
		}
		else {
			var myColor:Color = new Color(clip);
			myColor.setRGB(0xFFFFFF);
		}
	}
	
	public function setTextAlignment(textElement: Number, a_align: Number): Void
	{
		var alignment:String = "";
		if (a_align == 0){
			alignment = "left"
		}
		else if (a_align == 1){
			alignment = "center"
		}
		else {
			alignment = "right"
		}
		selectedText = textElementArray[textElement];
		var format:TextFormat = new TextFormat();
		format.align = alignment;
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
			case 4:
				TweenLite.to(clip, secs, {_rotation:endValue});
				break
			case 5:
				TweenLite.to(clip, secs, {_alpha:endValue, ease:Quad.easeOut});
				break
			}
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
	
// @Papyrus
	public function setPotionCounter(a_count: Number): Void
	{
		var textFormat:TextFormat = potionCount.getTextFormat();
		potionCount.text = String(a_count);
		potionCount.setTextFormat(textFormat);
	}
	
	public function setUpName(a_name: String): Void
	{
		var textFormat:TextFormat = shoutName.getTextFormat();
		shoutName.text = a_name;
		shoutName.setTextFormat(textFormat);		
	}
	
	public function setDownName(a_name: String): Void
	{
		var textFormat:TextFormat = potionName.getTextFormat();
		potionName.text = a_name;
		potionName.setTextFormat(textFormat);
	}
	
	public function setLeftName(a_name: String): Void
	{
		var textFormat:TextFormat = leftName.getTextFormat();
		leftName.text = a_name;
		leftName.setTextFormat(textFormat);
	}
	
	public function setRightName(a_name: String): Void
	{
		var textFormat:TextFormat = rightName.getTextFormat();
		rightName.text = a_name;
		rightName.setTextFormat(textFormat);
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
	// @Papyrus
	public function setVisible(a_visible: Boolean): Void
	{
		_visible = a_visible;
		leftIcon.visible = false;
		shoutIcon.visible = false;
		rightIcon.visible = false;
		potionIcon.visible = false;
		
	}
	public function colorIcon(ndx: Number): Void
	{
		if (ndx == 0) {
			var myColor:Color = new Color(leftIcon);
			myColor.setRGB(0x33AAFF);
		}
		else if (ndx == 1) {
			var myColor:Color = new Color(rightIcon);
			myColor.setRGB(0x33AAFF);
		}
		else if (ndx == 2) {
			var myColor:Color = new Color(shoutIcon);
			myColor.setRGB(0x33AAFF);
		}
		else if (ndx == 3) {
			var myColor:Color = new Color(potionIcon);
			myColor.setRGB(0x33AAFF);
		}
	}
	
		public function resetIcon(ndx: Number): Void
	{
		if (ndx == 0) {
			var myColor:Color = new Color(leftIcon);
			myColor.setRGB(0xFFFFFF);
		}
		else if (ndx == 1) {
			var myColor:Color = new Color(rightIcon);
			myColor.setRGB(0xFFFFFF);
		}
		else if (ndx == 2) {
			var myColor:Color = new Color(shoutIcon);
			myColor.setRGB(0xFFFFFF);
		}
		else if (ndx == 3) {
			var myColor:Color = new Color(potionIcon);
			myColor.setRGB(0xFFFFFF);
		}
	}
}