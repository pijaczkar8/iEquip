import skyui.util.ColorFunctions;
import Shared.GlobalFunc;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import skyui.util.Debug;

import com.iequip.TimelineLite;
import com.iequip.TweenLite;
import com.iequip.easing.*;

class skyui.widgets.iEquip.iEquipPositionIndicator extends MovieClip
{
   /* PRIVATE VARIABLES */

	private var currentPosition: Number;
	private var queueLength: Number;

	private var maxWidth: Number;
	private var maxHeight: Number;

	private var fillColor: Number;
	private var fillColorDark: Number;
	private var fillColorCurr: Number;
	private var fillColorDarkCurr: Number;

	private var posAlpha: Number;
	private var currPosAlpha: Number;

	private var _initialized: Boolean = false;
	private var _shown: Boolean = false;

  /* STAGE ELEMENTS */
	
	public var positionIndicatorHolder: MovieClip;
	public var positionMarker: MovieClip;
	public var currentPositionMarker: MovieClip;
	public var positionMarkerDummy: MovieClip;

  /* INITIALIZATION */

	public function iEquipPositionIndicator()
	{
		super();
		positionMarker = positionIndicatorHolder.positionMarker;
		currentPositionMarker = positionIndicatorHolder.currentPositionMarker;
		positionMarkerDummy = positionIndicatorHolder.positionMarkerDummy;
	}

	public function onLoad(): Void
	{
		maxWidth = positionMarkerDummy._width;
		maxHeight = positionMarkerDummy._height;
		positionIndicatorHolder._alpha = 0;
		positionMarkerDummy._alpha = 0;
		_initialized = true;
	}

  /* PROPERTIES */
	
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

	public function set currColor(iFillColor: Number): Void
	{
		var newColor: Number = (iFillColor == undefined)? 0xFFFFFF: ColorFunctions.validHex(iFillColor);
		if (fillColorCurr == iFillColor)
			return;
		fillColorCurr = newColor;

		var fillColorDarkHSV: Array = ColorFunctions.hexToHsv(newColor);
		fillColorDarkHSV[2] -= 40;

		fillColorDarkCurr = ColorFunctions.hsvToHex(fillColorDarkHSV);

		if (_initialized)
			invalidateCurrColor();
	}

	public function set queueLen(i_queueLength: Number): Void
	{
		queueLength = i_queueLength;
		setIndicatorWidth()
	}

	public function set currPos(i_position: Number): Void
	{
		currentPosition = i_position;
		setIndicatorPosition();
	}

	public function set indAlpha(i_newAlpha: Number): Void
	{
		posAlpha = i_newAlpha;
		positionMarker._alpha = posAlpha;
	}

	public function set currAlpha(i_newAlpha: Number): Void
	{
		currPosAlpha = i_newAlpha;
		currentPositionMarker._alpha = currPosAlpha;
	}

	/* PUBLIC FUNCTIONS */

	public function update(i_queueLength: Number, i_currPosition: Number, i_newPosition: Number, bCycling: Boolean, bPreselectMode: Boolean, currPreselectPosition: Number): Void
	{
		// If the queue length has changed since last called update the indicator width
		if (queueLength != i_queueLength){
			queueLength = i_queueLength;
			setIndicatorWidth();	
		}
		// Set the starting position then show the indicator
		currentPosition = i_currPosition;
		if (!bCycling){
			setIndicatorPosition(bPreselectMode, currPreselectPosition);
		}

		if (!_shown){
			//If it isn't alread shown fade in the indicator bar and at the same time animate the position marker to the new position
			var tl = new TimelineLite({paused:true, autoRemoveChildren:true});
			tl.to(positionIndicatorHolder, 0.2, {_alpha:100, ease:Quad.easeOut}, 0)
			.to(positionMarker, 0.25, {_x:positionMarker._width * i_newPosition + (positionMarker._width/2) - (maxWidth/2), ease:Quad.easeOut}, 0);
			tl.play();
			_shown = true;
		}else{
			TweenLite.to(positionMarker, 0.25, {_x:positionMarker._width * i_newPosition + (positionMarker._width/2) - (maxWidth/2), ease:Quad.easeOut});
		}
	}

	public function showIndicator(): Void
	{
		if (!_shown){
			TweenLite.to(positionIndicatorHolder, 0.2, {_alpha:100, ease:Quad.easeOut});
		}
		_shown = true;
	}

	public function hideIndicator(): Void
	{
		if (_shown){
			TweenLite.to(positionIndicatorHolder, 0.3, {_alpha:0, ease:Quad.easeOut});
		}
		_shown = false;
	}

	/* PRIVATE FUNCTIONS */

	private function setIndicatorWidth(): Void
	{
		positionMarker._width = maxWidth/queueLength;
		currentPositionMarker._width = maxWidth/queueLength;
	}

	private function setIndicatorPosition(bPreselectMode: Boolean, currPreselectPosition: Number): Void
	{
		if (currentPosition < 0){
			currentPosition = 0;
		}
		currentPositionMarker._x = positionMarker._width * currentPosition + (positionMarker._width/2) - (maxWidth/2);
		
		var startingPosition: Number = currentPosition;
		if(bPreselectMode){
			startingPosition = currPreselectPosition;
		}

		positionMarker._x = positionMarker._width * startingPosition + (positionMarker._width/2) - (maxWidth/2);
	}

	private function invalidateColor(): Void
	{
		var colors: Array;
		var alphas: Array;
		var ratios: Array;
		var w: Number = maxWidth; // 300
		var h: Number = maxHeight; // 7
		var r: Number = 0
		var __x: Number = -(w/2) // -150
		var __y: Number = -(h/2) // -3.5
		var fillGradient: MovieClip = positionMarker.fillGradient;
		var matrix: Matrix = new Matrix();
		
		if (fillGradient != undefined)
			fillGradient.removeMovieClip();
	
		fillGradient = positionMarker.createEmptyMovieClip("fillGradient", 0);
		
		colors = [fillColor, fillColorDark];
		alphas = [80, 80];
		ratios = [127, 63];
				
		matrix.createGradientBox(h, w, r);
		fillGradient.beginGradientFill("linear", colors, alphas, ratios, matrix);
		fillGradient.moveTo(__x,__y);
		fillGradient.lineTo(__x + w, __y);
		fillGradient.lineTo(__x + w, __y + h);
		fillGradient.lineTo(__x, __y + h);
		fillGradient.lineTo(__x,__y);
		fillGradient.endFill();

		//fillGradient._alpha = posAlpha;
	}

	private function invalidateCurrColor(): Void
	{
		var colors: Array;
		var alphas: Array;
		var ratios: Array;
		var w: Number = maxWidth; // 300
		var h: Number = maxHeight; // 7
		var r: Number = 0
		var __x: Number = -(w/2) // -150
		var __y: Number = -(h/2) // -3.5
		var fillGradientCurr: MovieClip = currentPositionMarker.fillGradientCurr;
		var matrix: Matrix = new Matrix();
		
		if (fillGradientCurr != undefined)
			fillGradientCurr.removeMovieClip();
	
		fillGradientCurr = currentPositionMarker.createEmptyMovieClip("fillGradientCurr", 0);
		
		colors = [fillColorCurr, fillColorDarkCurr];
		alphas = [80, 80];
		ratios = [127, 63];
				
		matrix.createGradientBox(h, w, r);
		fillGradientCurr.beginGradientFill("linear", colors, alphas, ratios, matrix);
		fillGradientCurr.moveTo(__x,__y);
		fillGradientCurr.lineTo(__x + w, __y);
		fillGradientCurr.lineTo(__x + w, __y + h);
		fillGradientCurr.lineTo(__x, __y + h);
		fillGradientCurr.lineTo(__x,__y);
		fillGradientCurr.endFill();
	}
}