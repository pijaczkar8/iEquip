import skyui.util.ColorFunctions;
import Shared.GlobalFunc;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import com.greensock.TimelineLite;
import com.greensock.TweenLite;
import com.greensock.easing.*;

class skyui.widgets.iEquip.iEquipSoulGem extends MovieClip
{
   /* PRIVATE VARIABLES */

	private var _currentPercent: Number;
	private var _targetPercent: Number;

	private var _fillDelta: Number = 0.02;
	private var _emptyDelta: Number = 0.03;
	private var _emptyIdx: Number = 100;
	private var _fullIdx: Number = 1;

	private var fillColor: Number;
	private var fillColorDark: Number;
	private var _flashColor: Number;

	private var flashColorAuto: Boolean = false;

	private var _initialized: Boolean = false;

  /* STAGE ELEMENTS */
	
	public var soulGemFrame: MovieClip;
	public var soulGemFillAnim: MovieClip;
	public var soulGemFill: MovieClip;
	public var soulGemFillGradientHolder: MovieClip;
	public var soulGemFlash: MovieClip;

  /* INITIALIZATION */

	public function iEquipSoulGem()
	{
		super();
		soulGemFill = soulGemFillAnim.soulGemFill;
		soulGemFillGradientHolder = soulGemFillAnim.soulGemFill.soulGemFillGradientHolder
	}

	public function onLoad(): Void
	{

		onEnterFrame = enterFrameHandler;
		soulGemFlash._alpha = 0.0
		_initialized = true;
	}

  /* PROPERTIES */

	public function get color(): Number 
	{
		return fillColor;
	}
	
	public function set color(iFillColor: Number): Void
	{
		var newColor: Number = (iFillColor == undefined)? 0xFFFFFF: ColorFunctions.validHex(iFillColor);
		if (fillColor == iFillColor)
			return;
		fillColor = newColor;

		var fillColorDarkHSV: Array = ColorFunctions.hexToHsv(newColor);
		fillColorDarkHSV[2] -= 40;

		fillColorDark = ColorFunctions.hsvToHex(fillColorDarkHSV);

		if (_initialized)
			invalidateColor();
	}

	public function get flashColor(): Number
	{
		return _flashColor;
	}
	
	public function set flashColor(iFlashColor: Number): Void
	{	
		var RRGGBB: Number;
		flashColorAuto = false;

		if ((iFlashColor < 0x000000 || iFlashColor == undefined) && fillColor != undefined) {
			RRGGBB = fillColor;
			flashColorAuto = true;
		} else if (iFlashColor == undefined) {
			RRGGBB = 0xFFFFFF;
		} else {
			RRGGBB = ColorFunctions.validHex(iFlashColor);
		}
		
		if (_flashColor == RRGGBB)
			return;
		_flashColor = RRGGBB;

		if (_initialized)
			invalidateFlashColor();
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
		_targetPercent = Math.min(1, Math.max(a_percent, 0));

		if (a_force) {
			_currentPercent = _targetPercent;
			var fillAnimFrame: Number = Math.floor(GlobalFunc.Lerp(_emptyIdx, _fullIdx, 0, 1, _currentPercent));
			soulGemFillAnim.gotoAndStop(fillAnimFrame);
		}
	}

	public function startFlash(a_force: Boolean): Void
	{
		var gemFlash: MovieClip = soulGemFlash;
		
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(soulGemFlash, 0.3, {_alpha:100, ease:Quad.easeOut}, 0)
		.to(soulGemFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(soulGemFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(soulGemFlash, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(soulGemFlash, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(soulGemFlash, 0.3, {_alpha:0, ease:Quad.easeOut});
		tl.play();
	}

  /* PRIVATE FUNCTIONS */

	private function invalidateColor(): Void
	{
		var colors: Array;
		var alphas: Array;
		var ratios: Array;
		var w: Number = soulGemFill._width;
		var h: Number = soulGemFill._height;
		var r: Number = Math.PI/2 //Rotate the gradient box by 90 degrees so fill is vertical rather than horizontal
		var __x: Number = -(w/2)
		var __y: Number = -(h/2)
		var fillGradient: MovieClip = soulGemFillGradientHolder.fillGradient;
		var matrix: Matrix = new Matrix();
		
		if (fillGradient != undefined)
			fillGradient.removeMovieClip();
	
		fillGradient = soulGemFillGradientHolder.createEmptyMovieClip("fillGradient", 0);
		
		colors = [fillColor, fillColorDark];
		alphas = [90, 90];
		ratios = [127, 63];
				
		matrix.createGradientBox(h, w, r);
		fillGradient.beginGradientFill("linear", colors, alphas, ratios, matrix);
		fillGradient.moveTo(__x,__y);
		fillGradient.lineTo(__x + w, __y);
		fillGradient.lineTo(__x + w, __y + h);
		fillGradient.lineTo(__x, __y + h);
		fillGradient.lineTo(__x,__y);
		fillGradient.endFill();

		if (flashColorAuto || !_initialized) {
			if (flashColorAuto)
				_flashColor = fillColor;
			invalidateFlashColor();
		}
	}

	private function invalidateFlashColor(): Void
	{
		var tf: Transform = new Transform(soulGemFlash);
		var colorTf: ColorTransform = new ColorTransform();
		colorTf.rgb = _flashColor;
		tf.colorTransform = colorTf;
		soulGemFlash._alpha = 0.0
	}

	private function enterFrameHandler(): Void
	{
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
		var fillAnimFrame: Number = Math.floor(GlobalFunc.Lerp(_emptyIdx, _fullIdx, 0, 1, _currentPercent));
		soulGemFillAnim.gotoAndStop(fillAnimFrame);
	}
}