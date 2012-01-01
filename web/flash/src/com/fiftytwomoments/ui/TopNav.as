package com.fiftytwomoments.ui 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.casalib.display.CasaSprite;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class TopNav extends CasaSprite
	{
		public var about:About;
		public var getInvolved:GetInvolved;
		
		public function TopNav() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			about.buttonMode = true;
			about.addEventListener(MouseEvent.CLICK, onAboutClick);
			
			getInvolved.buttonMode = true;
			getInvolved.addEventListener(MouseEvent.CLICK, onGetInvolvedClick);
		}
		
		private function onAboutClick(e:MouseEvent):void 
		{
			
		}
		
		private function onGetInvolvedClick(e:MouseEvent):void 
		{
			
		}
	}
}