package com.fiftytwomoments.ui 
{
	import com.greensock.TweenMax;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.events.MouseEvent;
	import org.casalib.display.CasaMovieClip;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class GenericArrowButton extends CasaMovieClip
	{
		
		public function GenericArrowButton() 
		{
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			addGlow();
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			stage.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			removeGlow();
		}
		
		//private function onMouseIsUp(e:MouseEvent):void 
		//{
			//this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//stage.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			//
			//removeGlow();
		//}
		
		private function addGlow():void 
		{
			TweenMax.to(this, 0.3, { glowFilter: { blurX: 10, blurY: 10, color:0xeeeeee, strength: 2, quality: 3, alpha: 1 }} );
		}
		
		private function removeGlow():void 
		{
			TweenMax.to(this, 0.5, { glowFilter: { blurX: 0, blurY: 0, alpha: 0 }} );
		}
	}
}