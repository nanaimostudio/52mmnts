/**
 * VERSION: 1.03
 * DATE: 2011-10-05
 * AS2 
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.TweenLite;
import com.greensock.core.SimpleTimeline;
import com.greensock.plugins.TweenPlugin;
import com.greensock.plugins.helpers.Physics2DProp;
/**
 * Provides simple physics functionality for tweening a MovieClip's _x and _y properties based on a
 * combination of velocity, angle, gravity, acceleration, accelerationAngle, and/or friction. It is not intended
 * to replace a full-blown physics engine and does not offer collision detection, but serves 
 * as a way to easily create interesting physics-based effects with the GreenSock tweening platform. Parameters
 * are not intended to be dynamically updateable, but one unique convenience is that everything is reverseable. 
 * So if you spawn a bunch of particle tweens, for example, and throw them into a TimelineLite, you could
 * simply call reverse() on the timeline to watch the particles retrace their steps right back to the beginning. 
 * Keep in mind that any easing equation you define for your tween will be completely ignored for these properties.
 * 	<ul>
 * 		<li><b>velocity : Number</b> - the initial velocity of the object measured in pixels per time 
 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
 * 								be measured in frames). The default is zero.</li>
 * 		<li><b>angle : Number</b> - the initial angle (in degrees) at which the object is traveling. Only
 * 								pertinent when a velocity is defined. For example, if the object should 
 * 								start out traveling at -60 degrees (towards the upper right), the angle
 * 								would be -60. The default is zero.</li>
 * 		<li><b>gravity : Number</b> - the amount of downwards acceleration applied to the object, measured
 * 								in pixels per time unit (usually seconds, but for tweens where useFrames 
 * 								is true, it would be measured in frames). You can <b>either</b> use <code>gravity</code>
 * 								<b>or</b> <code>acceleration</code>, not both because gravity is the same thing
 * 								as acceleration applied at an <code>accelerationAngle</code> of 90. Think of <code>gravity</code>
 * 								as a convenience property that automatically sets the <code>accelerationAngle</code> 
 * 								for you.</li>
 * 		<li><b>acceleration : Number</b> - the amount of acceleration applied to the object, measured
 * 								in pixels per time unit (usually seconds, but for tweens where useFrames 
 * 								is true, it would be measured in frames). To apply the acceleration in a specific
 * 								direction that is different than the <code>angle</code>, use the <code>accelerationAngle</code>
 * 								property. You can <b>either</b> use <code>gravity</code>
 * 								<b>or</b> <code>acceleration</code>, not both because gravity is the same thing
 * 								as acceleration applied at an <code>accelerationAngle</code> of 90.</li>
 * 		<li><b>accelerationAngle : Number</b> - the angle at which acceleration is applied (if any), measured in degrees. 
 * 								So if, for example, you want the object to accelerate towards the left side of the
 * 								screen, you'd use an <code>accelerationAngle</code> of 180. If you define a
 * 								<code>gravity</code> value, it will automatically set the <code>accelerationAngle</code>
 * 								to 90 (downwards).</li>
 * 		<li><b>friction : Number</b> - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
 * 								scientific in any way, but rather serves as an easy way to apply a friction-like
 * 								physics effect to your tween. Generally it is best to experiment with this number a bit.
 * 								Also note that friction requires more processing than physics tweens without any friction.</li>
 * 	</ul><br />
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.Physics2DPlugin; <br />
 * 		TweenPlugin.activate([Physics2DPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, gravity:400}}); <br /><br />
 * 		
 * 		//--OR--<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, friction:0.1}}); <br /><br />
 * 		
 * 		//--OR--<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physics2D:{velocity:300, angle:-60, acceleration:50, accelerationAngle:180}}); <br /><br />
 * </code>
 * 
 * Physics2DPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.<br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.Physics2DPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private precomputed for speed **/
		private static var _DEG2RAD:Number = Math.PI / 180;
		
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _target:MovieClip;
		/** @private **/
		private var _x:Physics2DProp;
		/** @private **/
		private var _y:Physics2DProp;
		/** @private **/
		private var _skipX:Boolean;
		/** @private **/
		private var _skipY:Boolean;
		/** @private **/
		private var _friction:Number;
		/** @private **/
		private var _runBackwards:Boolean;
		/** @private **/
		private var _step:Number; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		private var _stepsPerTimeUnit:Number;
		
		
		public function Physics2DPlugin() {
			super();
			this.propName = "physics2D"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = ["_x", "_y"];
			_stepsPerTimeUnit = 30; //default
			_friction = 1; //default
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (!(target instanceof MovieClip)) {
				trace("Tween Error: physics2D requires that the target be a MovieClip.");
				return false;
			}
			_target = MovieClip(target);
			_tween = tween;
			_runBackwards = Boolean(_tween.vars.runBackwards == true);
			_step = 0;
			var tl:SimpleTimeline = _tween.timeline;
			while (tl.timeline) {
				tl = tl.timeline;
			}
			if (tl == TweenLite.rootFramesTimeline) { //indicates the tween uses frames instead of seconds.
				_stepsPerTimeUnit = 1;
			}
			
			var angle:Number = Number(value.angle) || 0;
			var velocity:Number = Number(value.velocity) || 0;
			var acceleration:Number = Number(value.acceleration) || 0;
			var aAngle:Number = (value.accelerationAngle || value.accelerationAngle == 0) ? Number(value.accelerationAngle) : angle;
			if (value.gravity) {
				acceleration = Number(value.gravity);
				aAngle = 90;
			}
			angle *= _DEG2RAD;
			aAngle *= _DEG2RAD;
			
			if (value.friction) {
				_friction = 1 - Number(value.friction);
			}
			_x = new Physics2DProp(_target._x, Math.cos(angle) * velocity, Math.cos(aAngle) * acceleration, _stepsPerTimeUnit);
			_y = new Physics2DProp(_target._y, Math.sin(angle) * velocity, Math.sin(aAngle) * acceleration, _stepsPerTimeUnit);
			return true;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			if (lookup._x != undefined) {
				_skipX = true;
			}
			if (lookup._y != undefined) {
				_skipY = true;
			}
			super.killProps(lookup);
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var time:Number = _tween.cachedTime, x:Number, y:Number;
			if (_runBackwards == true) {
				time = _tween.cachedDuration - time;
			}
			if (_friction == 1) {
				var tt:Number = time * time * 0.5;
				x = _x.start + ((_x.velocity * time) + (_x.acceleration * tt));
				y = _y.start + ((_y.velocity * time) + (_y.acceleration * tt));
			} else {
				var steps:Number = Math.floor(time * _stepsPerTimeUnit) - _step;
				var remainder:Number = ((time * _stepsPerTimeUnit) % 1);
				var j:Number;
				if (steps >= 0) { 	//going forward
					j = steps;
					while (j--) {
						_x.v += _x.a;
						_y.v += _y.a;
						_x.v *= _friction;
						_y.v *= _friction;
						_x.value += _x.v;
						_y.value += _y.v;
					}	
					
				} else { 			//going backwards
					j = -steps;
					while (j--) {
						_x.value -= _x.v;
						_y.value -= _y.v;
						_x.v /= _friction;
						_y.v /= _friction;
						_x.v -= _x.a;
						_y.v -= _y.a;
					}
				}
				x = _x.value + (_x.v * remainder);
				y = _y.value + (_y.v * remainder);	
				_step += steps;
				
			}
			if (this.round) {
				x = Math.round(x);
				y = Math.round(y); 
			}
			if (!_skipX) {
				_target._x = x;
			}
			if (!_skipY) {
				_target._y = y;
			}
			
		}
	
}