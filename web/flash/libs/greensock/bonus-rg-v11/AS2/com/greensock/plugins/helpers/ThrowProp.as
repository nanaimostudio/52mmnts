/**
 * Stores information about ThrowPropsPlugin tweens. <br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
class com.greensock.plugins.helpers.ThrowProp {
		public var property:String;
		public var start:Number;
		public var change1:Number;
		public var change2:Number;
		
		public function ThrowProp(property:String, start:Number, change1:Number, change2:Number) {
			this.property = property;
			this.start = start;
			this.change1 = change1;
			this.change2 = change2;
		}	
}