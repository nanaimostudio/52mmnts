package com.fiftytwomoments 
{
	import com.fiftytwomoments.data.AppData;
	import com.fiftytwomoments.type.AppConstants;
	import com.nanaimostudio.utils.fluidLayout.FluidObject;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class DisplayManager extends EventDispatcher
	{
		private var _root:DisplayObjectContainer;
		private var contents:DisplayContents;
		private var _data:AppData;
		
		public function DisplayManager() 
		{
			
		}
		
		public function init():void
		{
			try
			{
				contents = new DisplayContents();
				contents.currentWeek = _data.currentWeek;
				contents.weekInView = _data.currentWeek;
				
				contents.x = _root.stage.stageWidth * 0.5;
				contents.y = _root.stage.stageHeight * 0.5 - 30;
				_root.addChildAt(contents, 0);
				
				//TODO: Refactor event constant
				contents.addEventListener(AppConstants.PHOTOCONTENT_CLICKED, onPhotoContentClicked);
				
				new FluidObject(contents, { x: 0.5, y: 0.5, offsetX: 0, offsetY:-30 });
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "init error: " + error.message);
			}
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
		
		public function onResize(e:Event):void
		{
			contents.x = _root.stage.stageWidth * 0.5;
			contents.y = _root.stage.stageHeight * 0.5 - 30;
		}
		
		public function set data(value:AppData):void 
		{
			_data = value;
		}
		
		public function set root(value:DisplayObjectContainer):void 
		{
			_root = value;
		}
	}

}