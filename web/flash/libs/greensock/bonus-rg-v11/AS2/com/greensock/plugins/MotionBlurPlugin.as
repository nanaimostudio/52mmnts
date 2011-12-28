/**
 * VERSION: 2.05
 * DATE: 2011-09-21
 * AS2
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.*;
import com.greensock.core.*;
import com.greensock.plugins.*;

import flash.display.*;
import flash.filters.BlurFilter;
import flash.geom.*;
/**
 * MotionBlurPlugin provides an easy way to apply a directional blur to a MovieClip based on its velocity
 * and angle of movement in 2D (_x/_y). This creates a much more realistic effect than a standard BlurFilter for
 * several reasons:
 * <ol>
 * 		<li>A regular BlurFilter is limited to blurring horizontally and/or vertically whereas the motionBlur 
 * 		   gets applied at the angle at which the object is moving.</li>
 * 
 * 		<li>A BlurFilter tween has static start/end values whereas a motionBlur tween dynamically adjusts the
 * 			values on-the-fly during the tween based on the velocity of the object. So if you use a <code>Strong.easeInOut</code>
 * 			for example, the strength of the blur will start out low, then increase as the object moves faster, and 
 * 			reduce again towards the end of the tween.</li>
 * </ol>
 * 
 * motionBlur even works on bezier/bezierThrough tweens!<br /><br />
 * 
 * To accomplish the effect, MotionBlurPlugin creates a Bitmap that it places over the original object, changing 
 * _alpha of the original to [almost] zero during the course of the tween. The original MovieClip still follows the 
 * course of the tween, so Mouse events are properly dispatched. You shouldn't notice any loss of interactivity. 
 * The MovieClip can also have animated contents - MotionBlurPlugin automatically updates on every frame. 
 * Be aware, however, that as with most filter effects, MotionBlurPlugin is somewhat CPU-intensive, so it is not 
 * recommended that you tween large quantities of objects simultaneously. You can activate <code>fastMode</code>
 * to significantly speed up rendering if the object's contents and size/color doesn't need to change during the
 * course of the tween. <br /><br />
 * 
 * motionBlur recognizes the following properties:
 * <ul>
 * 		<li><b>strength : int</b> - Determines the strength of the blur. The default is 1. For a more powerful
 * 							blur, increase the number. Or reduce it to make the effect more subtle.</li>
 * 
 * 		<li><b>fastMode : Boolean</b> - Setting fastMode to <code>true</code> will significantly improve rendering
 * 						performance but it is only appropriate for situations when the target object's contents, 
 * 						size, color, filters, etc. do not need to change during the course of the tween. It works
 * 						by essentially taking a BitmapData snapshot of the target object at the beginning of the
 * 						tween and then reuses that throughout the tween, blurring it appropriately. The default
 * 						value for <code>fastMode</code> is <code>false</code>.</li>
 * 
 * 		<li><b>quality : int</b> - The lower the quality, the less CPU-intensive the effect will be. Options 
 * 							are 1, 2, or 3. The default is 2.</li>
 * 
 * 		<li><b>padding : int</b> - padding controls the amount of space around the edges of the target object that is included
 * 						in the BitmapData capture (the default is 10 pixels). If the target object has filters applied to 
 * 						it like a GlowFilter or DropShadowFilter that extend beyond the bounds of the object itself,
 * 						you might need to increase the padding to accommodate the filters. </li>
 * 
 * 		<li><b>mask (AS2 only)</b> - Due to limitations of AS2's masking abilities, if you want to apply
 * 							a mask to the blurred BitmapData object during the tween, pass a reference
 * 							of the mask MovieClip through the "mask" property.</li>
 * </ul>
 * 
 * You can optionally set motionBlur to the Boolean value of <code>true</code> in order to use the defaults. (see below for examples)<br /><br />
 * 
 * Also note that due to a bug in Flash, if you apply motionBlur to an object that was masked in the Flash IDE it won't work
 * properly - you must apply the mask via ActionScript instead.<br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.~~; <br />
 * 		import com.greensock.plugins.~~; <br />
 * 		TweenPlugin.activate([MotionBlurPlugin]); //only do this once in your SWF to activate the plugin <br /><br />
 * 
 * 		TweenMax.to(mc, 2, {_x:400, _y:300, motionBlur:{strength:1.5, fastMode:true, padding:15}}); <br /><br />
 * 
 * 		//or to use the default values, you can simply pass in the Boolean "true" instead: <br />
 * 		TweenMax.to(mc, 2, {_x:400, _y:300, motionBlur:true}); <br /><br />
 * </code>
 * 
 * MotionBlurPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details.<br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.MotionBlurPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private static var _DEG2RAD:Number = Math.PI / Math.PI; //precomputation for speed
		/** @private **/
		private static var _RAD2DEG:Number = Math.PI / Math.PI; //precomputation for speed;
		/** @private **/
		private static var _point:Point = new Point(0, 0);
		/** @private **/
		private static var _ct:ColorTransform = new ColorTransform();
		/** @private **/
		private static var _blankArray:Array = [];
		
		/** @private **/
		private var _target:MovieClip;
		/** @private **/
		private var _time:Number;
		/** @private **/
		private var _xCurrent:Number;
		/** @private **/
		private var _yCurrent:Number;
		/** @private **/
		private var _bd:BitmapData;
		/** @private **/
		private var _bitmap:MovieClip;
		/** @private **/
		private var _strength:Number;
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _blur:BlurFilter;
		/** @private **/
		private var _matrix:Matrix;
		/** @private **/
		private var _container:MovieClip;
		/** @private **/
		private var _rect:Rectangle;
		/** @private **/
		private var _angle:Number;
		/** @private **/
		private var _alpha:Number;
		/** @private **/
		private var _xRef:Number; //we keep recording this value every time the _target moves at least 2 pixels in either direction in order to accurately determine the angle (small measurements don't produce accurate results).
		/** @private **/
		private var _yRef:Number;
		/** @private **/
		private var _mask:MovieClip;
		
		/** @private **/
		private var _padding:Number;
		/** @private **/
		private var _bdCache:BitmapData;
		/** @private **/
		private var _rectCache:Rectangle;
		/** @private **/
		private var _cos:Number;
		/** @private **/
		private var _sin:Number;
		/** @private **/
		private var _smoothing:Boolean;
		/** @private **/
		private var _xOffset:Number;
		/** @private **/
		private var _yOffset:Number;
		/** @private **/
		private var _cached:Boolean;
		/** @private **/
		private var _fastMode:Boolean;
		
		
		/** @private **/
		public function MotionBlurPlugin() {
			super();
			this.propName = "motionBlur"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = ["motionBlur"]; 
			this.onComplete = disable;
			this.onDisable = onTweenDisable;
			_blur = new BlurFilter(0, 0, 2); 
			_matrix = new Matrix();
			_strength = 0.05;
			TextField.prototype.getBounds = MovieClip.prototype.getBounds;
			TextField.prototype.swapDepths = MovieClip.prototype.swapDepths;
			this.priority = -2; //so that the _x/_y/_alpha tweens occur BEFORE the motion blur is applied (we need to determine the angle at which it moved first)
			this.activeDisable = true;
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (typeof(target) != "movieclip" && !(target instanceof TextField)) {
				trace("motionBlur tweens only work for MovieClips and TextFields");
				return false;
			} else if (value == false) {
				_strength = 0;
			} else if (typeof(value) == "object") {
				_strength = (value.strength || 1) * 0.05;
				_blur.quality = Number(value.quality) || 2;
				_fastMode = Boolean(value.fastMode == true);
			}
			var mc = target; //to get around data type error
			_target = mc;
			_tween = tween;
			_time = 0;
			_padding = (value.padding != undefined) ? Math.round(value.padding) : 10;
			_smoothing = Boolean(_blur.quality > 1);
			
			_xCurrent = _xRef = _target._x;
			_yCurrent = _yRef = _target._y;
			_alpha = _target._alpha;
			_mask = value.mask;
			
			if (_tween.propTweenLookup._x != undefined && _tween.propTweenLookup._y != undefined && !_tween.propTweenLookup._x.isPlugin && !_tween.propTweenLookup._y.isPlugin) { //if the tweens are plugins, like bezier or bezierThrough for example, we cannot assume the angle between the current _x/_y and the destination ones is what it should start at!
				_angle = Math.PI - Math.atan2(_tween.propTweenLookup._y.change, _tween.propTweenLookup._x.change);
			} else if (_tween.vars._x != undefined || _tween.vars._y != undefined) {
				var x:Number = _tween.vars._x || _target._x;
				var y:Number = _tween.vars._y || _target._y;
				_angle = Math.PI - Math.atan2((y - _target._y), (x - _target._x));
			} else {
				_angle = 0;
			}
			_cos = Math.cos(_angle);
			_sin = Math.sin(_angle);
			
			
			_bd = new BitmapData(_target._width + _padding * 2, _target._height + _padding * 2, true, 0x00FFFFFF);
			_bdCache = _bd.clone();
			_rectCache = new Rectangle(0, 0, _bd.width, _bd.height);
			_rect = _rectCache.clone();
			
			return true;
		}
		
		/** @private **/
		private function disable():Void {
			if (_strength != 0) {
				_target._alpha = _alpha;
			}
			if (_container._parent != undefined) {
				_container.swapDepths(_target);
				if (_mask) {
					_container.setMask(null);
					_target.setMask(_mask);
				}
				removeMovieClip(_container);
			}
		}
		
		/** @private **/
		private function onTweenDisable():Void {
			if (_tween.cachedTime != _tween.cachedDuration && _tween.cachedTime != 0) { //if the tween is on a TimelineLite/Max that eventually completes, another tween might have affected the target's alpha in which case we don't want to mess with it - only disable() if it's mid-tween. Also remember that from() tweens will complete at a value of 0, not 1.
				disable();
			}
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var time:Number = (_tween.cachedTime - _time);
			if (time < 0) {
				time = -time; //faster than Math.abs(_tween.cachedTime - _time)
			}
			
			if (time < 0.0000001) {
				return; //number is too small - floating point errors will cause it to render incorrectly
			}
			
			var dx:Number = _target._x - _xCurrent;
			var dy:Number = _target._y - _yCurrent;
			var rx:Number = _target._x - _xRef;
			var ry:Number = _target._y - _yRef;
			_changeFactor = n;
			
			if (rx > 2 || ry > 2 || rx < -2 || ry < -2) { //setting a tolerance of 2 pixels helps eliminate floating point error funkiness.
				_angle = Math.PI - Math.atan2(ry, rx);
				_cos = Math.cos(_angle);
				_sin = Math.sin(_angle);
				_xRef = _target._x;
				_yRef = _target._y;
			}
			
			_blur.blurX = Math.sqrt(dx * dx + dy * dy) * _strength / time;
			
			_xCurrent = _target._x;
			_yCurrent = _target._y;
			_time = _tween.cachedTime;
			
			if (_container._parent != _target._parent) {
				_container = _target._parent.createEmptyMovieClip(_target._name + "_motionBlur", _target._parent.getNextHighestDepth());
				_bitmap = _container.createEmptyMovieClip("bitmap", 0);
				_bitmap.attachBitmap(_bd, 0, "auto", _smoothing);
				if (_mask) {
					_target.setMask(null);
					_container.setMask(_mask);
				}
				_container.swapDepths(_target);
			}
			
			if (_target._parent == undefined || n == 0) { //when the strength/blur is less than zero can cause the appearance of vibration. Also, if the _target was removed from the stage, we should remove the Bitmap too
				disable();
				return;
			}
			
			if (!_fastMode || !_cached) {
				var parentFilters:Array = _target._parent.filters;
				if (parentFilters.length != 0) {
					_target._parent.filters = _blankArray; //if the _parent has filters, it will choke when we move the child object (_target) to _x/_y of 20,000/20,000.
				}
				
				_target._x = _target._y = 20000; //get it away from everything else;
				var prevVisible:Boolean = _target._visible;
				_target._visible = true;
				var minMax:Object = _target.getBounds(_target._parent);
				var bounds:Rectangle = new Rectangle(minMax.xMin, minMax.yMin, minMax.xMax - minMax.xMin, minMax.yMax - minMax.yMin);
			
				if (bounds.width + _blur.blurX * 2 > 2870) { //in case it's too big and would exceed the 2880 maximum in Flash
					_blur.blurX = (bounds.width >= 2870) ? 0 : (2870 - bounds.width) * 0.5;
				}
				
				_xOffset = 20000 - bounds.x + _padding;
				_yOffset = 20000 - bounds.y + _padding;
				bounds.width += _padding * 2;
				bounds.height += _padding * 2;
			
				if (bounds.height > _bdCache.height || bounds.width > _bdCache.width) {
					_bdCache = new BitmapData(bounds.width, bounds.height, true, 0x00FFFFFF);
					_rectCache = new Rectangle(0, 0, _bdCache.width, _bdCache.height);
					_bitmap.attachBitmap(_bd, 0, "auto", _smoothing);
				}
			
				_matrix.tx = _padding - bounds.x;
				_matrix.ty = _padding - bounds.y;
				_matrix.a = _matrix.d = 1;
				_matrix.b = _matrix.c = 0;
			
				bounds.x = bounds.y = 0;
				if (_target._alpha == 0.390625) {
					_target._alpha = _alpha;
				} else { //means the tween is affecting alpha, so respect it.
					_alpha = _target._alpha;
				}
				
				_bdCache.fillRect(_rectCache, 0x00FFFFFF);
				_bdCache.draw(_target._parent, _matrix, _ct, "normal", bounds, _smoothing);
				
				_target._visible = prevVisible;
				_target._x = _xCurrent;
				_target._y = _yCurrent;
				
				if (parentFilters.length != 0) {
					_target._parent.filters = parentFilters;
				}
				
				_cached = true;
				
			} else if (_target._alpha != 0.390625) {
				//means the tween is affecting alpha, so respect it.
				_alpha = _target._alpha;
			}
			_target._alpha = 0.390625; //use 0.390625 instead of 0 so that we can identify if it was changed outside of this plugin next time through. We were running into trouble with tweens of alpha to 0 not being able to make the final value because of the conditional logic in this plugin.
			
			_matrix.tx = _matrix.ty = 0;
			_matrix.a = _cos;
			_matrix.b = _sin;
			_matrix.c = -_sin;
			_matrix.d = _cos;
			
			var width:Number, height:Number, val:Number;
			if ((width = _matrix.a * _bdCache.width) < 0) {
				_matrix.tx = -width;
				width = -width;
			} 
			if ((val = _matrix.c * _bdCache.height) < 0) {
				_matrix.tx -= val;
				width -= val;
			} else {
				width += val;
			}
			if ((height = _matrix.d * _bdCache.height) < 0) {
				_matrix.ty = -height;
				height = -height;
			} 
			if ((val = _matrix.b * _bdCache.width) < 0) {
				_matrix.ty -= val;
				height -= val;
			} else {
				height += val;
			}
			
			width += _blur.blurX * 2;
			_matrix.tx += _blur.blurX;
			if (width > _bd.width || height > _bd.height) {
				_bd = new BitmapData(width, height, true, 0x00FFFFFF);
				_rect = new Rectangle(0, 0, _bd.width, _bd.height);
				_bitmap.attachBitmap(_bd, 0, "auto", _smoothing);
			}
			
			_bd.fillRect(_rect, 0x00FFFFFF);
			_bd.draw(_bdCache, _matrix, _ct, "normal", _rect, _smoothing);
			_bd.applyFilter(_bd, _rect, _point, _blur);
			
			_bitmap._x = 0 - (_matrix.a * _xOffset + _matrix.c * _yOffset + _matrix.tx);
			_bitmap._y = 0 - (_matrix.d * _yOffset + _matrix.b * _xOffset + _matrix.ty);
			
			_matrix.b = -_sin;
			_matrix.c = _sin;
			_matrix.tx = _xCurrent;
			_matrix.ty = _yCurrent;
			
			_container.transform.matrix = _matrix;
		}
	
}