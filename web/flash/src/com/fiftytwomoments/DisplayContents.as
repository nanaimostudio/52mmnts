package com.fiftytwomoments 
{
	import com.fiftytwomoments.data.TeaserImage;
	import com.fiftytwomoments.ui.LeftArrow;
	import com.fiftytwomoments.ui.PhotoContent;
	import com.fiftytwomoments.ui.RightArrow;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import org.casalib.display.CasaSprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.BitmapAsset;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	
	// center of DisplayContents is (0, 0)
	public class DisplayContents extends CasaSprite
	{
		private static const MAX_CONTENTS:int = 3;
		private static const CONTENT_GAP:int = 110;
		
		public var leftArrow:LeftArrow;
		public var rightArrow:RightArrow;
		
		private var contentContainer:CasaSprite;
		private var contents:Vector.<PhotoContent>;
		
		// week in the center of the screen
		private var weekInView:int;
		
		// current project week
		private var currentWeek:int;
		
		[Embed(source="/../assets/teaser.jpg")]
		private var TeaserImage:Class;
		private var isScrolling:Boolean;
		
		public function DisplayContents() 
		{
			init();
		}
		
		private function init():void 
		{
			currentWeek = weekInView = 1;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			contentContainer = new CasaSprite();
			contentContainer.name = "contentContainer";
			addChildAt(contentContainer, 0);
			
			contents = new Vector.<PhotoContent>();
			var dummyContent:PhotoContent = new PhotoContent();
			stage.stageWidth - dummyContent.width  - (MAX_CONTENTS - 1) * CONTENT_GAP
			
			// Total five photos for optimal scrolling (and minimum memory usage)
			// Current week is always the third photo in the vector
			for (var index:int = -2; index <= 2; index++)
			{
				var content:PhotoContent = new PhotoContent();
				var weekIndex:int = normalizeWeek(weekInView + index);
				
				trace("Week index: " + weekIndex);
				content.week = weekIndex;
				content.name = "content" + weekIndex;
				
				content.x = 765 * index;
				
				//TODO: From server-side
				// In the beginning, the current view (at index 0) is the current week so it always has a photo
				if (weekIndex == weekInView)
				{
					var t:BitmapAsset = new TeaserImage();
					t.x = -t.width * 0.5;
					t.y = -t.height * 0.5;
					content.setPhoto(t);
				}
				
				contentContainer.addChild(content);
				contents.push(content);
			}
			
			leftArrow.buttonMode = true;
			rightArrow.buttonMode = true;
			
			leftArrow.addEventListener(MouseEvent.CLICK, onLeftClick);
			rightArrow.addEventListener(MouseEvent.CLICK, onRightClick);
		}
		
		private function onLeftClick(e:MouseEvent):void 
		{
			scroll(-1);
		}
		
		private function onRightClick(e:MouseEvent):void 
		{
			scroll(+1);
		}
		
		private function scroll(direction:int):void
		{
			if (isScrolling) return;
			
			isScrolling = true;
			for (var index:int = 0; index < contents.length; index++)
			{
				//com.greensock.easing.
				TweenMax.to(contents[index], 0.6, { x: contents[index].x + 765 * direction, ease:Quad.easeInOut });
			}
			
			weekInView -= direction;
			weekInView = normalizeWeek(weekInView);
			
			TweenMax.delayedCall(0.6, onScrollComplete, [ direction ]);
		}
		
		private function onScrollComplete(direction:int):void
		{
			// Reuse photos for different weeks to create a carousel effect
			var content:PhotoContent;
			if (direction == -1)
			{
				content = contents.shift();
				content.week = normalizeWeek(weekInView + 2);
				// +2 offset from the middle photo
				content.x = 765 * 2;
				contents.push(content);
			}
			else
			{
				content = contents.pop();
				content.week = normalizeWeek(weekInView - 2);
				// -2 offset from the middle photo
				content.x = 765 * -2;
				contents.unshift(content);
			}
			
			trace("current week: " + currentWeek + " " + content.week);
			if (content.week == currentWeek)
			{
				if (!content.hasPhoto())
				{
					var t:BitmapAsset = new TeaserImage();
					t.x = -t.width * 0.5;
					t.y = -t.height * 0.5;
					content.setPhoto(t);
				}
			}
			else
			{
				if (content.hasPhoto())
				{
					content.removePhoto();
				}
			}
			
			isScrolling = false;
		}
		
		private function normalizeWeek(value:int):int 
		{
			if (value > 52)
			{
				return value % 52;
			}
			else if (value <= 0)
			{
				return 52 + value;
			}
			else
			{
				return value;
			}
		}
		
	}

}