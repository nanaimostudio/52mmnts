package com.fiftytwomoments.ui 
{
	import com.nanaimostudio.utils.TraceUtility;
	import com.nanaimostudio.utils.URLNavigator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class GetInvolvedPage extends Sprite
	{
		public var photoMoment:PhotoContent;
		public var submitButton:Sprite;
		public var currentWeek:int;
		
		public function GetInvolvedPage() 
		{
			currentWeek = 1;
			submitButton.buttonMode = true;
			submitButton.addEventListener(MouseEvent.CLICK, onSubmitClick);
		}
		
		private function onSubmitClick(e:MouseEvent):void 
		{
			TraceUtility.debug(this, "onSubmitClick");
			URLNavigator.goto("http://52mmnts.me/submit/moment" + String(currentWeek), "_blank");
		}
	}
}