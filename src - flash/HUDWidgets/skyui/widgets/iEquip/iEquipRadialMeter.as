import skyui.util.ColorFunctions;
import Shared.GlobalFunc;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import com.iequip.TimelineLite;
import com.iequip.TweenLite;
import com.iequip.easing.*;

class skyui.widgets.iEquip.iEquipRadialMeter extends MovieClip
{
   /* PRIVATE VARIABLES */

	private var _currentPercent: Number;
	private var _targetPercent: Number;

	private var _fillDelta: Number = 0.02;
	private var _emptyDelta: Number = 0.03;
	private var _emptyIdx: Number = 100;
	private var _fullIdx: Number = 1;

	private var fillColor: Number;

	private var _flashColor: Number;

	private var flashColorAuto: Boolean = false;

	private var _initialized: Boolean = false;

  /* STAGE ELEMENTS */
	
	public var radialMeterFillHolder: MovieClip;  	// Fill holder for colour overlay
	public var radialMeterFill: MovieClip;  		// Fill Animation
	public var radialMeterFlashHolder: MovieClip;	// Flash holder for colour overlay and flash animation

  /* TORCH METER FILL ANIMATION */

  	public var radialMeterTween: TweenLite;

  /* INITIALIZATION */

	public function iEquipRadialMeter()
	{
		super();
		radialMeterFill = radialMeterFillHolder.radialMeterFill;
	}

	public function onLoad(): Void
	{

		onEnterFrame = enterFrameHandler;
		radialMeterFlashHolder._alpha = 0.0
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
			RRGGBB = 0xFFFFFF; // White by default
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
			radialMeterFill.gotoAndStop(fillAnimFrame);
		}
	}

	public function startFlash(a_force: Boolean): Void
	{		
		var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
		tl.to(radialMeterFlashHolder, 0.3, {_alpha:100, ease:Quad.easeOut}, 0)
		.to(radialMeterFlashHolder, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(radialMeterFlashHolder, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(radialMeterFlashHolder, 0.3, {_alpha:0, ease:Quad.easeOut})
		.to(radialMeterFlashHolder, 0.3, {_alpha:100, ease:Quad.easeOut})
		.to(radialMeterFlashHolder, 0.3, {_alpha:0, ease:Quad.easeOut});
		tl.play();
	}

  /* PRIVATE FUNCTIONS */

	private function invalidateColor(): Void
	{
		var tf: Transform = new Transform(radialMeterFillHolder);
		var colorTf: ColorTransform = new ColorTransform();
		colorTf.rgb = fillColor;
		tf.colorTransform = colorTf;

		if (flashColorAuto || !_initialized) {
			if (flashColorAuto)
				_flashColor = fillColor;
			invalidateFlashColor();
		}
	}

	private function invalidateFlashColor(): Void
	{
		var tf: Transform = new Transform(radialMeterFlashHolder);
		var colorTf: ColorTransform = new ColorTransform();
		colorTf.rgb = _flashColor;
		tf.colorTransform = colorTf;
		radialMeterFlashHolder._alpha = 0.0
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
		radialMeterFill.gotoAndStop(fillAnimFrame);
	}

	public function startFillTween(a_duration: Number): Void
	{
			radialMeterTween = new TweenLite(radialMeterFill, a_duration*1.2, {frame:100, overwrite:1});
			radialMeterTween.play();
	}

	public function pauseFillTween(): Void
	{
		radialMeterTween.pause()
	}

	public function resumeFillTween(): Void
	{
		radialMeterTween.resume()
	}

	public function stopFillTween(): Void
	{
		TweenLite.killTweensOf(radialMeterFill)
	}
}