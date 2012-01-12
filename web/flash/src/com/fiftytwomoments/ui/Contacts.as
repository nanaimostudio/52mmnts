package com.fiftytwomoments.ui 
{
	import com.nanaimostudio.utils.URLNavigator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Contacts extends Sprite
	{
		
		public var ftmTwitter:HitBox;
		public var ftmEmail:HitBox;
		
		public function Contacts() 
		{
			ftmTwitter.addEventListener(MouseEvent.CLICK, onTwitterClick);
			ftmEmail.addEventListener(MouseEvent.CLICK, onEmailClick);
		}
		
		private function onEmailClick(e:MouseEvent):void 
		{
			trace("onEmailClick");
			URLNavigator.goto("mailto:support@52mmnts.me?subject=52Moments", "_blank");
		}
		
		private function onTwitterClick(e:MouseEvent):void 
		{
			trace("onTwitterClick");
			URLNavigator.goto("http://twitter.com/52mmnts", "_blank");
		}
	}
}