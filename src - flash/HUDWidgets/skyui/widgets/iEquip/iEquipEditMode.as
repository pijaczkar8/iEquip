import skyui.widgets.iEquip.iEquipWidget;

class skyui.widgets.iEquip.iEquipEditMode extends iEquipWidget
{	
  /* STAGE ELEMENTS */
	
	//Edit Mode Guide Instruction Text Fields
	public var NextPrevInstructionText: TextField;
	public var NextPrevToggleText: TextField;
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
	public var ToggleGridInstructionText: TextField;
	public var HighlightColorInstructionText: TextField;
	public var CurrInfoColorInstructionText: TextField;
	public var ResetInstructionText: TextField;
	
	//Edit Mode Guide Current Value Text Fields
	public var SelectedElementText: TextField;
	public var ScaleText: TextField;
	public var RotationText: TextField;
	public var RotationDirectionText: TextField;
	public var AlignmentText: TextField;
	public var AlphaText: TextField;
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
	
  /* INITIALIZATION */

	public function iEquipEditMode()
	{
		super();

		//Set up the button icon paths
		NextButton = NextButton;
		PrevButton = PrevButton;
		MoveUpButton = MoveUpButton;
		MoveDownButton = MoveDownButton;
		MoveLeftButton = MoveLeftButton;
		MoveRightButton = MoveRightButton;
		ScaleUpButton = ScaleUpButton;
		ScaleDownButton = ScaleDownButton;
		DepthButton = DepthButton;
		RotateButton = RotateButton;
		AlphaButton = AlphaButton;
		AlignmentButton = AlignmentButton;
		ToggleGridButton = ToggleGridButton;
		ResetButton = ResetButton;
		LoadButton = LoadButton;
		SaveButton = SaveButton;
		DiscardButton = DiscardButton;
		ExitButton = ExitButton;
		
		//Set up the Edit Mode text field paths
		NextPrevInstructionText = NextPrevInstructionText;
		NextPrevToggleText = NextPrevToggleText;
		MoveInstructionText = MoveInstructionText;
		ScaleInstructionText = ScaleInstructionText;
		ToggleMoveInstructionText = ToggleMoveInstructionText;
		RotateInstructionText = RotateInstructionText;
		ToggleRotateInstructionText = ToggleRotateInstructionText;
		RotationDirectionInstructionText = RotationDirectionInstructionText;
		DepthInstructionText = DepthInstructionText;
		AlignmentInstructionText = AlignmentInstructionText;
		TextColorInstructionText = TextColorInstructionText;
		AlphaInstructionText = AlphaInstructionText;
		ToggleAlphaInstructionText = ToggleAlphaInstructionText;
		ToggleGridInstructionText = ToggleGridInstructionText;
		HighlightColorInstructionText = HighlightColorInstructionText;
		CurrInfoColorInstructionText = CurrInfoColorInstructionText;
		ResetInstructionText = ResetInstructionText;
		LoadPresetText = LoadPresetText;
		SavePresetText = SavePresetText;
		ExitEditModeText = ExitEditModeText;
		DiscardChangesText = DiscardChangesText;
		SelectedElementText = SelectedElementText;
		ScaleText = ScaleText;
		RotationText = RotationText;
		RotationDirectionText = RotationDirectionText;
		AlignmentText = AlignmentText;
		AlphaText = AlphaText;
		MoveIncrementText = MoveIncrementText;
		RotateIncrementText = RotateIncrementText;
		AlphaIncrementText = AlphaIncrementText;
		RulersText = RulersText;

	}

	function setEditModeButtons(Exit: Number, Nxt: Number, Prv: Number, Up: Number, Down: Number, Left: Number, Right: Number, ScaleUp: Number, ScaleDown: Number, Rot: Number, Alpha: Number, Align: Number, Dep: Number, Rul: Number, Res: Number, Load: Number, Save: Number, Disc: Number): Void
	{
		//skyui.util.Debug.log("iEquipEditMode setEditModeButtons - Exit: " + Exit)
		NextButton.gotoAndStop(Nxt);
		PrevButton._x = NextButton._x + NextButton._width + 1;
		PrevButton.gotoAndStop(Prv);
		NextPrevInstructionText._x = PrevButton._x + PrevButton._width + 8;
		NextPrevToggleText._x = NextPrevInstructionText._x;
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
	
	function setEditModeCurrentValueColor(_color: Number): Void
	{
		//skyui.util.Debug.log("iEquipEditMode setEditModeCurrentValueColor - _color: " + _color)
		ScaleText.textColor = _color;
		RotationText.textColor = _color;
		RotationDirectionText.textColor = _color;
		AlignmentText.textColor = _color;
		AlphaText.textColor = _color;
		MoveIncrementText.textColor = _color;
		RotateIncrementText.textColor = _color;
		AlphaIncrementText.textColor = _color;
		RulersText.textColor = _color;
	}
}
