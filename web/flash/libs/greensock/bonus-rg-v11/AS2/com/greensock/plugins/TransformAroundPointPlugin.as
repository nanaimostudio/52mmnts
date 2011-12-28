/**
 * VERSION: 2.1
 * DATE: 2011-01-19
 * AS2
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.*;
import com.greensock.core.*;
import com.greensock.plugins.*;

import flash.geom.Point;
/**
 * Normally, all transformations (scale, rotation, and position) are based on the MovieClip's registration
 * point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
 * transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
 * want to scale from its center or rotate around a particular point on the stage. 
 * 
 * If you define an x or y value in the transformAroundPoint object, it will correspond to the custom registration
 * point which makes it easy to position (as opposed to having to figure out where the original registration point 
 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
 * the transformAroundPoint object, like: <br /><br /><code>
 * 
 * TweenLite.to(mc, 3, {x:50, y:40, transformAroundPoint:{point:new Point(200, 300), scale:0.5, _rotation:30}});<br /><br /></code>
 * 
 * To define the <code>point</code> according to the target's local coordinates (as though it is inside the target),
 * simply pass <code>pointIsLocal:true</code> in the transformAroundPoint object, like:<br /><br /><code>
 * 
 * TweenLite.to(mc, 3, {transformAroundPoint:{point:new Point(200, 300), pointIsLocal:true, scale:0.5, _rotation:30}});<br /><br /></code>
 * 
 * TransformAroundPointPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. Visit 
 * <a href="http://www.greensock.com/club/">http://blog.greensock.com/club/</a> to sign up or get more details. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.TransformAroundPointPlugin; <br />
 * 		TweenPlugin.activate([TransformAroundPointPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {transformAroundPoint:{point:new Point(100, 300), _xscale:2, _yscale:1.5, _rotation:150}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.TransformAroundPointPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _classInitted:Boolean;
		
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _local:Point;
		/** @private **/
		private var _point:Point;
		/** @private **/
		private var _temp:Point; //speeds things up when doing localToGlobal and globalToLocal.
		/** @private **/
		private var _shortRotation:ShortRotationPlugin;
		
		/** @private **/
		public function TransformAroundPointPlugin() {
			super();
			this.propName = "transformAroundPoint";
			this.overwriteProps = ["_x","_y"];
			this.priority = -1; //so that the x/y tweens occur BEFORE the transformAroundPoint is applied
			
			if (!_classInitted) { //so that the plugin can work with TextFields.
				TextField.prototype.getBounds = MovieClip.prototype.getBounds;
				TextField.prototype.localToGlobal = MovieClip.prototype.localToGlobal;
				TextField.prototype.globalToLocal = MovieClip.prototype.globalToLocal;
				_classInitted = true;
			}
			
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (!(value.point instanceof Point)) {
				return false;
			}
			_target = target;
			
			if (value.pointIsLocal == true) {
				_local = value.point.clone();
				_point = _local.clone();
				_target.localToGlobal(_point);
				_target._parent.globalToLocal(_point);
			} else {
				_point = value.point.clone();
				_local = _point.clone();
				_target._parent.localToGlobal(_local);
				_target.globalToLocal(_local);
			}
			
			_temp = _local.clone();
			
			var p:String, short:ShortRotationPlugin, sp:String, pp:String;
			for (p in value) {
				if (p == "point" || p == "pointIsLocal") {
					//ignore - we already set it above
				} else if (p == "shortRotation") {
					_shortRotation = new ShortRotationPlugin();
					_shortRotation.onInitTween(_target, value[p], tween);
					addTween(_shortRotation, "changeFactor", 0, 1, "shortRotation");
					for (sp in value[p]) {
						this.overwriteProps[this.overwriteProps.length] = sp;
					}
				} else if (p == "_x" || p == "_y") {
					pp = (p == "_x") ? "x" : "y"; //point property (x instead of _x and y instead of _y)
					addTween(_point, pp, _point[pp], value[p], p);
				} else if (p == "scale") {
					addTween(_target, "_xscale", _target._xscale, value.scale, "_xscale");
					addTween(_target, "_yscale", _target._yscale, value.scale, "_yscale");
					this.overwriteProps[this.overwriteProps.length] = "_xscale";
					this.overwriteProps[this.overwriteProps.length] = "_yscale";
				} else {
					addTween(_target, p, _target[p], value[p], p);
					this.overwriteProps[this.overwriteProps.length] = p;
				}
			}
			
			if (tween.vars._x != undefined || tween.vars._y != undefined) { //if the tween is supposed to affect _x and _y based on the original registration point, we need to make special adjustments here...
				var endX:Number, endY:Number;
				if (tween.vars._x != undefined) {
					endX = (typeof(tween.vars._x) == "number") ? tween.vars._x : _target._x + Number(tween.vars._x);
				}
				if (tween.vars._y != undefined) {
					endY = (typeof(tween.vars._y) == "number") ? tween.vars._y : _target._y + Number(tween.vars._y);
				}
				tween.killVars({_x:true, _y:true}, false); //we're taking over.
				this.changeFactor = 1;
				if (!isNaN(endX)) {
					addTween(_point, "x", _point.x, _point.x + (endX - _target._x), "_x");
				}
				if (!isNaN(endY)) {
					addTween(_point, "y", _point.y, _point.y + (endY - _target._y), "_y");
				}
				this.changeFactor = 0;
			}
			
			return true;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			if (_shortRotation != undefined) {
				_shortRotation.killProps(lookup);
				if (_shortRotation.overwriteProps.length == 0) {
					lookup.shortRotation = true;
				}
			}
			super.killProps(lookup);
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			_temp.x = _local.x;
			_temp.y = _local.y;
			var i:Number = _tweens.length, pt:PropTween;
			if (this.round) {
				while (i--) {
					pt = _tweens[i];
					pt.target[pt.property] = Math.round(pt.start + (pt.change * n));
				}
				_target.localToGlobal(_temp);
				_target._parent.globalToLocal(_temp);
				_target._x = Math.round(_target._x + _point.x - _temp.x);
				_target._y = Math.round(_target._y + _point.y - _temp.y);
			} else {
				while (i--) {
					pt = _tweens[i];
					pt.target[pt.property] = pt.start + (pt.change * n);
				}
				_target.localToGlobal(_temp);
				_target._parent.globalToLocal(_temp);
				_target._x += _point.x - _temp.x;
				_target._y += _point.y - _temp.y;
			}
		}

}