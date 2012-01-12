package com.fiftytwomoments.ui 
{
	import com.nanaimostudio.utils.fluidLayout.FluidObject;
	import com.nanaimostudio.utils.fluidLayout.SimpleFluidObject;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class FooterNav extends Sprite
	{
		public var credits:Sprite;
		//public var contacts:Contacts;
		
		public function FooterNav() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//new FluidObject(credits, { x: 0, y: 0, offsetX: -222, offsetY:0 });
			//new FluidObject(contacts, { x: 1, y: 1, offsetX: -200, offsetY:-50 });
			//new SimpleFluidObject(contacts, { alignment: "BOTTOM_RIGHT", margin: 0 } );
		}
	}
}