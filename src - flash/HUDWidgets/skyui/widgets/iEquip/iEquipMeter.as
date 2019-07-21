import skyui.util.ColorFunctions;
import Shared.GlobalFunc;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import com.iequip.TweenLite;
import com.iequip.plugins.TweenPlugin;
import com.iequip.plugins.FramePlugin;
import com.iequip.plugins.FrameLabelPlugin;

class skyui.widgets.iEquip.iEquipMeter extends MovieClip
{
  /* CONSTANTS */

	public static var FILL_DIRECTION_LEFT: String = "left";
	public static var FILL_DIRECTION_RIGHT: String = "right";
	public static var FILL_DIRECTION_BOTH: String = "both";

  /* PRIVATE VARIABLES */
	
	private var _originalWidth: Number;
	private var _originalHeight: Number;
	private var _originalCapWidth: Number;
	private var _originalCapHeight: Number;
	private var _originalMeterFillHolderWidth: Number;

	private var _iEquipMeterFrameContent: MovieClip;
	private var _iEquipMeterFillHolder: MovieClip;
	private var _iEquipMeterFillContent: MovieClip;
	private var _iEquipMeterFlashAnim: MovieClip;
	private var _iEquipMeterBarAnim: MovieClip;
	private var _iEquipMeterBar: MovieClip;

	private var _currentPercent: Number;
	private var _targetPercent: Number;
	private var _fillDelta: Number = 0.02;
	private var _emptyDelta: Number = 0.03;
	private var _emptyIdx: Number;
	private var _fullIdx: Number;
	
	private var _fillDirection: String;
	private var _secondaryColor: Number;
	private var _primaryColor: Number;
	private var _flashColor: Number;
	private var _flashColorAuto: Boolean = false;

	private var __width: Number;
	private var __height: Number;

	private var _initialized: Boolean = false;

  /* STAGE ELEMENTS */
	
	public var iEquipMeterContent: MovieClip;
	public var background: MovieClip;

  /* TORCH METER FILL ANIMATION */

  	public var TorchMeterTween: TweenLite;

  /* INITIALIZATION */

	public function iEquipMeter()
	{
		super();

		TweenPlugin.activate([FramePlugin, FrameLabelPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

		background._visible = iEquipMeterContent.capBackground._visible = false;

		// Set internal dimensions to stage dimensions
		__width = _width;
		__height = _height;

		_iEquipMeterFrameContent = iEquipMeterContent.iEquipMeterFrameHolder.iEquipMeterFrameContent;
		_iEquipMeterFillHolder = iEquipMeterContent.iEquipMeterFillHolder;
		_iEquipMeterFillContent = _iEquipMeterFillHolder.iEquipMeterFillContent;
		_iEquipMeterFlashAnim = _iEquipMeterFrameContent.iEquipMeterFlashAnim;
		_iEquipMeterBarAnim = _iEquipMeterFillContent.iEquipMeterBarAnim;
		_iEquipMeterBar = _iEquipMeterBarAnim.iEquipMeterBar;

		_originalWidth = background._width;
		_originalHeight = background._height;
		_originalCapWidth = iEquipMeterContent.capBackground._width;
		_originalCapHeight = iEquipMeterContent.capBackground._height;
		_originalMeterFillHolderWidth = _iEquipMeterFillHolder._width;

		_iEquipMeterFillHolder._x = _originalCapWidth;

		// Set stage dimensions to original dimensions and invalidate size
		_width = _originalWidth;
		_height = _originalHeight;
	}

	public function onLoad(): Void
	{
		//skyui.util.Debug.log("iEquipMeter onLoad called");
		invalidateSize();
		invalidateFillDirection();

		//onEnterFrame = enterFrameHandler;

		_initialized = true;
	}

  /* PROPERTIES */

	public function get width(): Number 
	{
		return __width;
	}
	public function set width(a_width: Number): Void
	{
		if (__width == a_width)
			return;
		__width = a_width;

		if (_initialized)
			invalidateSize();
	}

	public function get height(): Number 
	{
		return background._height;
	}
	public function set height(a_height: Number): Void
	{
		if (__height == a_height)
			return;
		__height = a_height;

		if (_initialized)
			invalidateSize();
	}

	public function setSize(a_width: Number, a_height: Number): Void
	{
		if (__width == a_width && __height == a_height)
			return;
		
		__width = a_width;
		__height = a_height;

		if (_initialized)
			invalidateSize();
	}

	public function get color(): Number 
	{
		return _primaryColor;
	}
	public function set color(a_primaryColor: Number): Void
	{
		var lightColor: Number = (a_primaryColor == undefined)? 0xFFFFFF: ColorFunctions.validHex(a_primaryColor);
		if (lightColor == _primaryColor)
			return;
		_primaryColor = lightColor;

		var darkColorHSV: Array = ColorFunctions.hexToHsv(lightColor);
		darkColorHSV[2] -= 40;

		_secondaryColor = ColorFunctions.hsvToHex(darkColorHSV);

		if (_initialized)
			invalidateColor();
	}

	public function setColors(a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number): Void
	{

		flashColor = a_flashColor;

		if (a_secondaryColor == undefined || a_secondaryColor < 0x000000) {
			color = a_primaryColor;
			return;
		}

		_primaryColor = (a_primaryColor == undefined)? 0xFFFFFF: ColorFunctions.validHex(a_primaryColor);
		_secondaryColor = ColorFunctions.validHex(a_secondaryColor);

		if (_initialized)
			invalidateColor();
	}

	public function get flashColor(): Number
	{
		return _flashColor;
	}
	public function set flashColor(a_flashColor: Number): Void
	{	
		var RRGGBB: Number;
		_flashColorAuto = false;


		if ((a_flashColor < 0x000000 || a_flashColor == undefined) && _primaryColor != undefined) {
			RRGGBB = _primaryColor;
			_flashColorAuto = true;
		} else if (a_flashColor == undefined) {
			RRGGBB = 0xFFFFFF;
		} else {
			RRGGBB = ColorFunctions.validHex(a_flashColor);
		}
		
		if (_flashColor == RRGGBB)
			return;
		_flashColor = RRGGBB;

		if (_initialized)
			invalidateFlashColor();
	}

	public function get fillDirection(): String 
	{
		return _fillDirection;
	}
	public function set fillDirection(a_fillDirection: String): Void
	{
		setFillDirection(a_fillDirection)
	}

	public function setFillDirection(a_fillDirection: String, a_restorePercent: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipMeter setFillDirection called - a_fillDirection: " + a_fillDirection + ", a_restorePercent: " + a_restorePercent);
		var fillDirection: String = a_fillDirection.toLowerCase();
		if (_fillDirection == fillDirection && !a_restorePercent)
			return;
		_fillDirection = fillDirection;

		if (_initialized)
			invalidateFillDirection(a_restorePercent);
	}

	public function get percent(): Number 
	{
		return _targetPercent;
	}
	public function set percent(a_percent: Number): Void
	{
		setPercent(a_percent);
	}

	public function setPercent(a_percent: Number, a_force: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipMeter setPercent called - a_percent: " + a_percent + ", a_force: " + a_force);
		_targetPercent = Math.min(1, Math.max(a_percent, 0));

		if (a_force) {
			_currentPercent = _targetPercent;
			var iEquipMeterFrame: Number = Math.floor(GlobalFunc.Lerp(_emptyIdx, _fullIdx, 0, 1, _currentPercent));
			_iEquipMeterBarAnim.gotoAndStop(iEquipMeterFrame);
		}
	}

	public function startFillTween(a_duration: Number): Void
	{
			TorchMeterTween = new TweenLite(_iEquipMeterBarAnim, a_duration*1.2, {frame:120, overwrite:1});
			TorchMeterTween.play();
	}

	public function pauseFillTween(): Void
	{
		//skyui.util.Debug.log("iEquipMeter pauseFillTween called");
		TorchMeterTween.pause()
	}

	public function resumeFillTween(): Void
	{
		//skyui.util.Debug.log("iEquipMeter resumeFillTween called");
		TorchMeterTween.resume()
	}

	public function stopFillTween(): Void
	{
		//skyui.util.Debug.log("iEquipMeter stopFillTween called");
		TweenLite.killTweensOf(_iEquipMeterBarAnim)
	}

	public function startFlash(a_force: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipMeter startFlash called");
		// meterFlashing is set on the timeline and is false once the animation has finished
		if (_iEquipMeterFlashAnim.meterFlashing && !a_force) {
			return;
		}

		_iEquipMeterFlashAnim.gotoAndPlay("StartFlash");
	}

  /* PRIVATE FUNCTIONS */

	private function invalidateSize(): Void
	{
		//skyui.util.Debug.log("iEquipMeter invalidateSize called");
		var safeWidth: Number = _originalCapWidth * 3; // Safe width is 3* size of cap
		var safeHeight: Number;

		if (__width < safeWidth)
			//3 times cap width is our minumum
			__width = safeWidth;

		// Safe height of meter is 80% of the max height
		safeHeight = ((_originalCapHeight/_originalCapWidth) * __width/2) * 0.80;

		if (__height > safeHeight)
			__height = safeHeight;

		background._width = __width;
		background._height = __height;

		// Calculate scaling percent of the meter based on heights
		var scalePercent: Number = __height/_originalHeight;

		// Scale the meterContent based on height so the caps AR is maintained
		iEquipMeterContent._xscale = iEquipMeterContent._yscale = scalePercent * 100;

		// Scale inner content
		// Scale iEquipMeterFrameContent instead of meterFrameHolder due to scale9Grid
		_iEquipMeterFrameContent._width = __width / scalePercent; // newWidth = oldWidth * newPercent/oldPercent /. newPercent -> 100
		_iEquipMeterFillHolder._xscale = ((_iEquipMeterFrameContent._width - 2*_originalCapWidth)/_originalMeterFillHolderWidth) * 100;
	}

	private function invalidateFillDirection(a_restorePercent: Boolean): Void
	{
		//skyui.util.Debug.log("iEquipMeter invalidateFillDirection called");
		switch(_fillDirection) {
			case FILL_DIRECTION_LEFT:
			case FILL_DIRECTION_BOTH:
			case FILL_DIRECTION_RIGHT:
				break;
			default:
				_fillDirection = FILL_DIRECTION_LEFT;
		}

		_iEquipMeterFillContent.gotoAndStop(_fillDirection);
		
		drawMeterGradients();
		
		_iEquipMeterBarAnim.gotoAndStop("Full");
		_fullIdx = _iEquipMeterBarAnim._currentframe;
		_iEquipMeterBarAnim.gotoAndStop("Empty");
		_emptyIdx = _iEquipMeterBarAnim._currentframe;
		
		if (a_restorePercent || !_initialized)
			setPercent(_currentPercent, true);
		else
			setPercent(0, true); // Reset to 0, assume that if fillDirection is changed, meter data provider changed
	}

	private function drawMeterGradients(): Void
	{
		//skyui.util.Debug.log("iEquipMeter drawMeterGradients called");
		// Draws the meter
		var w: Number = _iEquipMeterBar._width;
		var h: Number = _iEquipMeterBar._height;
		var iEquipMeterBevel: MovieClip = _iEquipMeterBar.iEquipMeterBevel;
		var iEquipMeterShine: MovieClip = _iEquipMeterBar.iEquipMeterShine;
		
		var colors: Array = [0xCCCCCC, 0xFFFFFF, 0x000000, 0x000000, 0x000000];
		var alphas: Array = [10,       60,       0,        10,       30];
		//var ratios: Array = [0,        25,       25,       140,      153,      153,      255];
		var ratios: Array = [0,       115,      128,      128,      255];
		var matrix: Matrix = new Matrix();
		
		if (iEquipMeterShine != undefined)
			return;
			
		iEquipMeterShine = _iEquipMeterBar.createEmptyMovieClip("iEquipMeterShine", 2);
		
		iEquipMeterBevel.swapDepths(1);
		matrix.createGradientBox(w, h, Math.PI/2);
		iEquipMeterShine.beginGradientFill("linear", colors, alphas, ratios, matrix);
		iEquipMeterShine.moveTo(0,0);
		iEquipMeterShine.lineTo(w, 0);
		iEquipMeterShine.lineTo(w, h);
		iEquipMeterShine.lineTo(0, h);
		iEquipMeterShine.lineTo(0, 0);
		iEquipMeterShine.endFill();
		
		invalidateColor();
	}

	private function invalidateColor(): Void
	{
		//skyui.util.Debug.log("iEquipMeter invalidateColor called");
		var colors: Array;
		var alphas: Array;
		var ratios: Array;
		var w: Number = _iEquipMeterBar._width;
		var h: Number = _iEquipMeterBar._height;
		var iEquipMeterGradient: MovieClip = _iEquipMeterBar.iEquipMeterGradient;
		var matrix: Matrix = new Matrix();
		
		if (iEquipMeterGradient != undefined)
			iEquipMeterGradient.removeMovieClip();


			
		iEquipMeterGradient = _iEquipMeterBar.createEmptyMovieClip("iEquipMeterGradient", 0);
		
		switch(_fillDirection) {
			case FILL_DIRECTION_LEFT:
				colors = [_secondaryColor, _primaryColor];
				alphas = [100, 100];
				ratios = [0, 255];
				break;
			case FILL_DIRECTION_BOTH:
				colors = [_secondaryColor, _primaryColor, _secondaryColor];
				alphas = [100, 100, 100];
				ratios = [0, 127, 255];
				break;
			case FILL_DIRECTION_RIGHT:
			default:
				colors = [_primaryColor, _secondaryColor];
				alphas = [100, 100];
				ratios = [0, 255];
		}
		
		matrix.createGradientBox(w, h);
		iEquipMeterGradient.beginGradientFill("linear", colors, alphas, ratios, matrix);
		iEquipMeterGradient.moveTo(0,0);
		iEquipMeterGradient.lineTo(w, 0);
		iEquipMeterGradient.lineTo(w, h);
		iEquipMeterGradient.lineTo(0, h);
		iEquipMeterGradient.lineTo(0, 0);
		iEquipMeterGradient.endFill();

		if (_flashColorAuto || !_initialized) {
			if (_flashColorAuto)
				_flashColor = _primaryColor;
			invalidateFlashColor();
		}
	}

	private function invalidateFlashColor(): Void
	{
		//skyui.util.Debug.log("iEquipMeter invalidateFlashColor called");
		var tf: Transform = new Transform(_iEquipMeterFlashAnim);
		var colorTf: ColorTransform = new ColorTransform();
		colorTf.rgb = _flashColor;
		tf.colorTransform = colorTf;
	}

	private function enterFrameHandler(): Void
	{
		//skyui.util.Debug.log("iEquipMeter enterFrameHandler called");
		if (_targetPercent == _currentPercent) {
			return;
		}
			
		if (_currentPercent < _targetPercent) {
			_currentPercent = _currentPercent + _fillDelta;
			if (_currentPercent > _targetPercent)
				_currentPercent = _targetPercent;
		} else {
			_currentPercent = _currentPercent - _emptyDelta;
			if (_currentPercent < _targetPercent)
				_currentPercent = _targetPercent;
		}
		
		_currentPercent = Math.min(1, Math.max(_currentPercent, 0));
		var iEquipMeterFrame: Number = Math.floor(GlobalFunc.Lerp(_emptyIdx, _fullIdx, 0, 1, _currentPercent));
		_iEquipMeterBarAnim.gotoAndStop(iEquipMeterFrame);
	}
}