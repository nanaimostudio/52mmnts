/**
 * VERSION: 1.01
 * DATE: 7/15/2009
 * AS2 (AS3 is also available)
 * UPDATES AND DOCUMENTATION AT: http://blog.greensock.com/customease/
 **/
import mx.utils.Delegate;
/**
 * 	Facilitates creating custom bezier eases with the GreenSock Custom Ease Builder tool. It's essentially
 *  a place to store the bezier segment information for each ease instead of recreating it inside each
 *  function call which would slow things down. Please use the interactive tool available at 
 *  http://blog.greensock.com/customease/ to generate the necessary code.
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
class com.greensock.easing.CustomEase {
	public static var VERSION:Number = 1.01;
	private static var _all:Object = {}; //keeps track of all CustomEase instances.
	private var _segments:Array;
	private var _name:String;
	public var ease:Function;
	
	public static function create(name:String, segments:Array):Function {
		var b:CustomEase = new CustomEase(name, segments);
		return b.ease;
	}
	
	public static function byName(name:String):Function {
		return _all[name].ease;
	}
	
	public function CustomEase(name:String, segments:Array) {
		_name = name;
		_segments = segments;
		_all[name] = this;
		this.ease = Delegate.create(this, easeProxy); //to ensure scope is right.
	}
	
	public function easeProxy(time:Number, start:Number, change:Number, duration:Number):Number {
		var factor:Number = time / duration, qty:Number = _segments.length, t:Number, b:Object;
		var i:Number = (qty * factor) >> 0;
		t = (factor - (i * (1 / qty))) * qty;
		b = _segments[i];
		return start + change * (b.s + t * (2 * (1 - t) * (b.cp - b.s) + t * (b.e - b.s)));
	}
	
	public function destroy():Void {
		_segments = null;
		delete _all[_name];
	}
		
}