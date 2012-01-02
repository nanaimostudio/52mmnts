package com.fiftytwomoments.ui 
{
	import flash.events.MouseEvent;
	import org.casalib.display.CasaSprite;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class ThumbGrid extends CasaSprite
	{
		private var thumbnailContainer:CasaSprite;
		private var _interactionDelegate:Object;
		
		private static const THUMBNAILS_PER_ROW:int = 18;
		private static const THUMBNAIL_GAP:int = 6;
		
		private var _week:int = 1;
		
		public function ThumbGrid() 
		{
			thumbnailContainer = new CasaSprite();
			thumbnailContainer.name = "thumbnailContainer";
			addChild(thumbnailContainer);
			
			for (var index:int = 0; index < 54; index++)
			{
				var thumbnail:Thumbnail = new Thumbnail();
				thumbnail.buttonMode = true;
				thumbnail.mouseEnabled = true;
				thumbnail.mouseChildren = false;
				thumbnail.name = String(index + 1);
				
				if (index < 52)
				{
					thumbnail.title.text = String(index + 1);
				}
				else
				{
					thumbnail.title.text = "";
					thumbnail.box.alpha = 0.2;
				}
				
				thumbnail.addEventListener(MouseEvent.CLICK, onClick);
				
				var col:int = index % THUMBNAILS_PER_ROW;
				var row:int = int(index / THUMBNAILS_PER_ROW);
				thumbnail.x = thumbnail.width * 0.5 + col * (thumbnail.width + THUMBNAIL_GAP);
				thumbnail.y = thumbnail.height * 0.5 + row * (thumbnail.height + THUMBNAIL_GAP);
				
				thumbnailContainer.addChild(thumbnail);
			}
			
			//this.graphics.lineStyle(1, 0, 1);
			//this.graphics.drawRect(0, 0, this.width, this.height);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_interactionDelegate != null)
			{
				if (_interactionDelegate.hasOwnProperty("onThumbGridClicked"))
				{
					var weekValue:int = parseInt(Thumbnail(e.target).name);
					if (weekValue > 0 && weekValue < 53)
					{
						updateToNewWeek(weekValue);
						_interactionDelegate.onThumbGridClicked(parseInt(e.target.name));
					}
				}
			}
		}
		
		private function updateToNewWeek(value:int):void 
		{
			if (thumbnailContainer != null)
			{
				var oldThumbnail:Thumbnail = thumbnailContainer.getChildByName(String(_week)) as Thumbnail;
				if (oldThumbnail) oldThumbnail.box.alpha = 1.0;
				
				var newThumbnail:Thumbnail = thumbnailContainer.getChildByName(String(value)) as Thumbnail;
				if (newThumbnail) newThumbnail.box.alpha = 0.6;
			}
			
			_week = value;
		}
		
		public function set interactionDelegate(value:Object):void 
		{
			_interactionDelegate = value;
		}
		
		public function set week(value:int):void 
		{
			updateToNewWeek(value);
		}
	}
}