/**
 * VERSION: 1.03
 * DATE: 2011-10-05
 * AS2 
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.TweenLite;
import com.greensock.core.SimpleTimeline;
import com.greensock.plugins.TweenPlugin;
import com.greensock.plugins.helpers.PhysicsProp;
/**
 * Sometimes you want to tween a property (or several) but you don't have a specific end value in mind - instead,
 * you'd rather describe the movement in terms of physics concepts, like velocity, acceleration, 
 * and/or friction. PhysicsPropsPlugin allows you to tween any numeric property of any object based
 * on these concepts. Keep in mind that any easing equation you define for your tween will be completely
 * ignored for these properties. Instead, the physics parameters will determine the movement/easing.
 * These parameters, by the way, are not intended to be dynamically updateable, but one unique convenience 
 * is that everything is reverseable. So if you create several physics-based tweens, for example, and 
 * throw them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects 
 * retrace their steps right back to the beginning. Here are the parameters you can define (note that 
 * friction and acceleration are both completely optional):
 * 	<ul>
 * 		<li><b>velocity : Number</b> - the initial velocity of the object measured in units per time 
 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
 * 								be measured in frames). The default is zero.</li>
 * 		<li><b>acceleration : Number</b> [optional] - the amount of acceleration applied to the object, measured
 * 								in units per time unit (usually seconds, but for tweens where useFrames 
 * 								is true, it would be measured in frames). The default is zero.</li>
 * 		<li><b>friction : Number</b> [optional] - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
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
 * 		import com.greensock.plugins.PhysicsPropsPlugin; <br />
 * 		TweenPlugin.activate([PhysicsPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physicsProps:{<br />
 * 										_x:{velocity:100, acceleration:200},<br />
 * 										_y:{velocity:-200, friction:0.1}<br />
 * 										}<br />
 * 							}); <br /><br />
 *  </code>
 * 
 * PhysicsPropsPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit http://blog.greensock.com/club/ to sign up or get more details.<br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.PhysicsPropsPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _props:Array;
		/** @private **/
		private var _hasFriction:Boolean;
		/** @private **/
		private var _runBackwards:Boolean;
		/** @private **/
		private var _step:Number; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		private var _stepsPerTimeUnit:Number;
		
		
		/** @private **/
		public function PhysicsPropsPlugin() {
			super();
			this.propName = "physicsProps"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = [];
			_stepsPerTimeUnit = 30; //default
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = target;
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
			_props = [];
			var p:String, curProp:Object, cnt:Number = 0;
			for (p in value) {
				curProp = value[p];
				if (curProp.velocity || curProp.acceleration) {
					_props[cnt++] = new PhysicsProp(p, Number(target[p]), curProp.velocity, curProp.acceleration, curProp.friction, _stepsPerTimeUnit);
					this.overwriteProps[cnt] = p;
					if (curProp.friction) {
						_hasFriction = true;
					}
				}
			}
			return true;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			var i:Number = _props.length;
			while (i--) {
				if (lookup[_props[i].property] != undefined) {
					_props.splice(i, 1);
				}
			}
			super.killProps(lookup);
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number = _props.length, time:Number = _tween.cachedTime, values:Array = [], curProp:PhysicsProp;
			if (_runBackwards == true) {
				time = _tween.cachedDuration - time;
			}
			if (_hasFriction) {
				var steps:Number = Math.floor(time * _stepsPerTimeUnit) - _step;
				var remainder:Number = ((time * _stepsPerTimeUnit) % 1);
				var j:Number;
				if (steps >= 0) { 	//going forward
					while (i--) {
						curProp = _props[i];
						j = steps;
						while (j--) {
							curProp.v += curProp.a;
							curProp.v *= curProp.friction;
							curProp.value += curProp.v;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}					
					
				} else { 			//going backwards
					while (i--) {
						curProp = _props[i];
						j = -steps;
						while (j--) {
							curProp.value -= curProp.v;
							curProp.v /= curProp.friction;
							curProp.v -= curProp.a;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}
				}
				_step += steps;
				
			} else {
				var tt:Number = time * time * 0.5;
				while (i--) {
					curProp = _props[i];
					values[i] = curProp.start + ((curProp.velocity * time) + (curProp.acceleration * tt));
				}
			}
			i = _props.length;
			if (!this.round) {
				while (i--) {
					_target[PhysicsProp(_props[i]).property] = Number(values[i]);
				}
			} else {
				while (i--) {
					_target[_props[i].property] = Math.round(values[i]);
				}
			}
		}
	
}