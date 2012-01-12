package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.SWFLoaderVars;
	import com.greensock.loading.SWFLoader;
	import com.greensock.TweenMax;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.MovieClip;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.StageReference;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Preloader extends CasaSprite
	{
		public var progressIndicator:MovieClip;
		
		public function Preloader() 
		{
			StageReference.setStage(this.stage);
			init();
		}
		
		private function init():void 
		{
			var swfLoader:SWFLoader = new SWFLoader("52mmnts.swf", { name:"52mmnts", container:this, width:stage.stageWidth, height: stage.stageHeight, onComplete: completeHandler, onProgress: progressHandler } );
			swfLoader.load();
		}
		
		function progressHandler(event:LoaderEvent):void
		{
			if (event.target.progress == 0) return;
			progressIndicator.percent.text = String(Math.floor(event.target.progress * 100));
		}

		function completeHandler(event:LoaderEvent):void
		{
			progressIndicator.percent.text = "100";
			TweenMax.to(progressIndicator, 0.3, { autoAlpha: 0 } );
		}

		function errorHandler(event:LoaderEvent):void
		{
			TraceUtility.debug(this, "error occured with " + event.target + ": " + event.text);
		}

		
	}

}