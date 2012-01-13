package com.fiftytwomoments.ui 
{
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
		
		public function GetInvolvedPage() 
		{
			submitButton.buttonMode = true;
			submitButton.addEventListener(MouseEvent.CLICK, onSubmitClick);
		}
		
		private function onSubmitClick(e:MouseEvent):void 
		{
			
		}
		
	}

}