package com.fiftytwomoments.ui 
{
	import org.casalib.display.CasaSprite;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class DottedSeparator extends CasaSprite
	{
		public var dotDistance:int = 8;
		private var dotIndex:int = 0;
		public var dotCount:int = 120;
		
		public function DottedSeparator() 
		{
			update();
		}
		
		public function update():void 
		{
			if (this.numChildren > 0)
			{
				this.removeAllChildrenAndDestroy(true);
			}
			
			while (dotIndex < dotCount)
			{
				var dot:Dot = new Dot();
				dot.x = 10 + dotDistance * dotIndex;
				this.addChild(dot);
				
				dotIndex++;
			}
		}
	}
}