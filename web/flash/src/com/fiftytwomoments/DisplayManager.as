package com.fiftytwomoments 
{
	import com.fiftytwomoments.type.AppConstants;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class DisplayManager extends EventDispatcher
	{
		private var contents:DisplayContents;
		
		public function DisplayManager(root:DisplayObjectContainer) 
		{
			contents = new DisplayContents();
			contents.x = root.stage.stageWidth * 0.5;
			contents.y = root.stage.stageHeight * 0.5 - 30;
			root.addChildAt(contents, 0);
			
			//TODO: Refactor event constant
			contents.addEventListener(AppConstants.PHOTOCONTENT_CLICKED, onPhotoContentClicked);
		}
		
		public function showAbout():void
		{
			contents.showAbout();
		}
		
		public function showGetInvolved():void
		{
			contents.showGetInvolved();
		}
		
		public function showLanding():void
		{
			contents.showLanding();
		}
		
		private function onPhotoContentClicked(e:Event):void 
		{
			dispatchEvent(new Event(AppConstants.PHOTOCONTENT_CLICKED));
		}
	}

}