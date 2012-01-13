package com.fiftytwomoments.services 
{
	import com.nanaimostudio.utils.TraceUtility;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import org.casalib.util.UrlVariablesUtil;
	import com.adobe.serialization.json.JSON;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class MomentsDataService extends EventDispatcher 
	{
		public var returnData:Object;
		
		public function MomentsDataService() 
		{
			
		}
		
		public function getAllMoments():void
		{
			var url:String = "http://52mmnts.me/getAllMomentsData";
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			request.data = requestVars;
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				urlLoader.load(request);
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "error: " + error.message);
			}
		}
		
		public function getMoment(value:int):void
		{
			if (value < 1 || value > 52) return;
			
			var url:String = "http://52mmnts.me/getMomentData/Moment" + String(value);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				urlLoader.load(request);
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "error: " + error.message);
			}
		}
		
		public function getSubmittedMomentData(value:int):void
		{
			if (value < 1 || value > 52) return;
			
			var url:String = "http://52mmnts.me/getSubmittedMomentData/Moment" + String(value);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				urlLoader.load(request);
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "error: " + error.message);
			}
		}
		
		public function getSubmittedPhoto(value:int):void
		{
			if (value < 1 || value > 52) return;
			
			var url:String = "http://52mmnts.me/getSubmittedPhoto/Moment" + String(value);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.GET;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				urlLoader.load(request);
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "error: " + error.message);
			}
		}
		
		public function uploadMoment(value:Object):void
		{
			/*
			var url:String = "http://52m.nanaimo.webfactional.com/upload";
			var requestVars:URLVariables = new URLVariables();
			requestVars.moment = value.moment;
			requestVars.title = value.title;
			requestVars.description = value.description;
			requestVars.city = value.city;
			requestVars.state = value.state;
			requestVars.country = value.country;
			
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = UploadPostHelper.getPostData('image.jpg', byteArray);
			request.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			request.data = requestVars;
			request.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				urlLoader.load(request);
			}
			catch (error:Error)
			{
				TraceUtility.debug(this, "error: " + error.message);
			}
			*/
		}
		
		
		private function loaderCompleteHandler(e:Event):void
		{
			TraceUtility.debug(this, "loaderCompleteHandler");
			var response:Object = JSON.decode(e.target.data) as Object;
			returnData = response;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void
		{
			TraceUtility.debug(this, "httpStatusHandler:" + e.status);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			TraceUtility.debug(this, "securityErrorHandler:" + e.text);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			dispatchEvent(e);
		}
	}
}