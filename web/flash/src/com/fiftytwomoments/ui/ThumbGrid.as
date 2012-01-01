package com.fiftytwomoments.ui 
{
	import org.casalib.display.CasaSprite;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class ThumbGrid extends CasaSprite
	{
		private var thumbnails:Vector.<Thumbnail>;
		private var thumbnailContainer:CasaSprite;
		
		public function ThumbGrid() 
		{
			thumbnailContainer = new CasaSprite();
			thumbnailContainer.name = "thumbnailContainer";
			addChild(thumbnailContainer);
			
			thumbnails = new Vector.<Thumbnail>(54);
			
			for (var index:int = 0; index < 54; index++)
			{
				var thumbnail:Thumbnail = new Thumbnail();
				//thumbnail.title.text = String(index + 1);
				//thumbnailContainer.addChild(thumbnail);
				thumbnails.push(thumbnail);
			}
		}
		
	}

}