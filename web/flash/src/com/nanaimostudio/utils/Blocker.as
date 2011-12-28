package com.nanaimostudio.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Blocker extends Sprite
	{
		
		public function Blocker() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
		}
	}
}