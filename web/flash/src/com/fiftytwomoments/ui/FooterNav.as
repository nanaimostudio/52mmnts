package com.fiftytwomoments.ui 
{
	import com.nanaimostudio.utils.URLNavigator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class FooterNav extends Sprite
	{
		public var ftmTwitter:HitBox;
		public var ftmEmail:HitBox;
		
		public function FooterNav() 
		{
			ftmTwitter.addEventListener(MouseEvent.CLICK, onTwitterClick);
			ftmEmail.addEventListener(MouseEvent.CLICK, onEmailClick);
		}
		
		private function onEmailClick(e:MouseEvent):void 
		{
			trace("onEmailClick");
			URLNavigator.goto("mailto:52mmnts@gmail.com?subject=52Moments", "_blank");
		}
		
		private function onTwitterClick(e:MouseEvent):void 
		{
			trace("onTwitterClick");
			URLNavigator.goto("http://twitter.com/52mmnts", "_blank");
		}
		
	}

}