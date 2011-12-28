package com.fiftytwomoments 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class DisplayManager 
	{
		private var contents:DisplayContents;
		
		public function DisplayManager(root:DisplayObjectContainer) 
		{
			contents = new DisplayContents();
			contents.x = root.stage.stageWidth * 0.5;
			contents.y = root.stage.stageHeight * 0.5;
			root.addChild(contents);
		}
	}

}