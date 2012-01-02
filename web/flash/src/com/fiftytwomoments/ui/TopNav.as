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
		
		public function setGetInvolvedState(value:Boolean):void
		{
			getInvolved.alpha = value ? 1.0 : 0.5;
		}
		
		public function reset():void
		{
			about.alpha = 0.5;
			getInvolved.alpha = 0.5;
		}
		
		private function onAboutClick(e:MouseEvent):void 
		{
			if (isAboutSelected) return;
			
			if (about.alpha < 0.8)
			{
				about.alpha = 1.0;
				getInvolved.alpha = 0.5;
			}
			else
			{
				about.alpha = 0.5;
			}
		}
		
		private function onGetInvolvedClick(e:MouseEvent):void 
		{
			if (isGetInvolvedSelected) return;
			
			if (getInvolved.alpha < 0.8)
			{
				getInvolved.alpha = 1.0;
				about.alpha = 0.5;
			}
			else
			{
				getInvolved.alpha = 0.5;
			}
		}
	
		public function get isAboutSelected():Boolean
		{
			return about.alpha > 0.5;
		}
		
		public function get isGetInvolvedSelected():Boolean
		{
			return getInvolved.alpha > 0.5;
		}
	}
}