package com.fiftytwomoments.services 
{
	import com.greensock.loading.LoaderMax;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class ImageDataService extends EventDispatcher
	{
		private var queue:LoaderMax;
		
		public function ImageDataService() 
		{
			init();
		}
		
		public function init():void
		{
			//TODO: Show initialization - When data is done, show site
			queue = new LoaderMax({ name: "imageQueue", onComplete:completeHandler, onError:errorHandler});
			queue.append( new ImageLoader("img/landing_moment1.jpg", { name:"landingphoto", container:this, alpha:0 scaleMode:"proportionalInside"}) );
			queue.append( new ImageLoader("img/detail_moment1.jpg", { name:"landingphoto", container:this, alpha:0 scaleMode:"proportionalInside"}) );
		}
	
		public function load():void
		{
			queue.load();
		}
		
		function progressHandler(event:LoaderEvent):void {
			TraceUtility.debug(this, "progress: " + event.target.progress);
		}

		function completeHandler(event:LoaderEvent):void {
		  var image:ContentDisplay = LoaderMax.getContent("photo1");
		  TraceUtility.debug(this, event.target + " is complete!");
		}
		 
		function errorHandler(event:LoaderEvent):void {
			TraceUtility.debug(this, "error occured with " + event.target + ": " + event.text);
		}
	}

}