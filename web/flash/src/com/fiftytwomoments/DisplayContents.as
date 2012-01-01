package com.fiftytwomoments 
{
	import com.fiftytwomoments.data.TeaserImage;
	import com.fiftytwomoments.ui.LeftArrow;
	import com.fiftytwomoments.ui.PhotoContent;
	import com.fiftytwomoments.ui.RightArrow;
	import com.fiftytwomoments.ui.ThumbGrid;
	import com.greensock.TweenMax;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
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
		private static const WEEKS_PER_YEAR:int = 52;
		
		public var leftArrow:LeftArrow;
		public var rightArrow:RightArrow;
		
		private var rootContainer:CasaSprite;
		
		//private var contentsContainer:CasaSprite;
		//private var contents:Vector.<PhotoContent>;
		
		// week in the center of the screen
		private var weekInView:int;
		
		// current project week
		private var currentWeek:int;
		
		[Embed(source="/../assets/teaser.jpg")]
		private var TeaserImage:Class;
		
		[Embed(source="/../assets/info.jpg")]
		private var InfoImage:Class;
		
		private var isScrolling:Boolean;
		private var isTransitioning:Boolean;
		
		private var viewStateInfoList:Array;
		
		private var currentViewState:String;
		private var previousViewState:String;
		
		private var VIEWSTATE_LANDING:String = "ViewState.Landing";
		private var VIEWSTATE_DETAILS:String = "ViewState.Details";
		
		public function DisplayContents() 
		{
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			rootContainer = new CasaSprite();
			addChildAt(rootContainer, 0);
			
			viewStateInfoList = new Array();
			viewStateInfoList[VIEWSTATE_LANDING] = new ViewStateInfo();
			viewStateInfoList[VIEWSTATE_LANDING].image = new TeaserImage();
			
			viewStateInfoList[VIEWSTATE_DETAILS] = new ViewStateInfo();
			viewStateInfoList[VIEWSTATE_DETAILS].image = new InfoImage();
			
			currentWeek = weekInView = 1;
			setCurrentViewState(VIEWSTATE_LANDING);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initCurrentView();
			rootContainer.addChildAt(contentsContainer, 0);
			rootContainer.addChildAt(thumbGrid, 1);
		}
		
		private function getCurrentViewState():String
		{
			return currentViewState;
		}
		
		private function setCurrentViewState(value:String):void
		{
			previousViewState = currentViewState;
			currentViewState = value;
		}
		
		private function initCurrentView():void 
		{
			contentsContainer = new CasaSprite();
			contentsContainer.name = "contentsContainer";
			initContents();
			
			thumbGrid = new ThumbGrid();
			thumbGrid.name = "thumbGrid";
			thumbGrid.y = 346;
			
			leftArrow.buttonMode = true;
			rightArrow.buttonMode = true;
			leftArrow.addEventListener(MouseEvent.CLICK, onLeftClick);
			rightArrow.addEventListener(MouseEvent.CLICK, onRightClick);
		}
		
		private function initContents():void 
		{
			contents = new Vector.<PhotoContent>();
			var dummyContent:PhotoContent = new PhotoContent();
			stage.stageWidth - dummyContent.width  - (MAX_CONTENTS - 1) * CONTENT_GAP;
			dummyContent = null;
			
			// Total five photos for optimal scrolling (and minimum memory usage)
			// Current week is always the third photo in the vector
			for (var index:int = -2; index <= 2; index++)
			{
				var content:PhotoContent = createPhotoContent();
				var weekIndex:int = normalizeWeek(weekInView + index);
				
				//trace("Week index: " + weekIndex);
				content.week = weekIndex;
				content.name = "content" + weekIndex;
				
				content.x = 765 * index;
				
				//TODO: From server-side
				// In the beginning, the current view (at index 0) is the current week so it always has a photo
				if (weekIndex == weekInView)
				{
					var t:BitmapAsset = getViewStateImage();
					t.x = -t.width * 0.5;
					t.y = -t.height * 0.5;
					content.setPhoto(t);
					content.interactionEnabled = true;
				}
				
				contentsContainer.addChild(content);
				contents.push(content);
			}
		}
		
		private function getViewStateImage():BitmapAsset 
		{
			return viewStateInfoList[currentViewState].image;
		}
		
		private function createPhotoContent():PhotoContent 
		{
			var photoContent:PhotoContent = new PhotoContent();
			photoContent.interactionDelegate = this;
			return photoContent;
		}
		
		// PhotoContent Interaction Delegate Method
		public function onPhotoContentClicked(e:PhotoContent):void
		{
			if (isScrolling) return;
			
			isTransitioning = true;
			var thumbGridFadeOutTime:Number = 0.2;
			var thumbGridFadeInTime:Number = 0.3;
			var waitForThumbGridFadeOutDelay:int = thumbGridFadeInTime + 0.6;
			var thumbGridFadeInDelay:Number = 0.76;
			var contentsScrollTime:Number = 0.5;
			
			if (getCurrentViewState() == VIEWSTATE_LANDING)
			{
				// Landing going out of view
				TraceUtility.debug(this, "contentsContainer: " + contentsContainer);
				TweenMax.to(thumbGrid, thumbGridFadeOutTime, { autoAlpha: 0 } );
				TweenMax.to(contentsContainer, contentsScrollTime, { y: -height, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				//TweenMax.to(contentsContainer, 0.4, { alpha:0, ease:Quad.easeOut } );
				
				// Details coming into view
				setCurrentViewState(VIEWSTATE_DETAILS);
				initCurrentView();
				rootContainer.addChildAt(contentsContainer, 0);
				rootContainer.addChildAt(thumbGrid, 1);
				contentsContainer.y = stage.stageHeight;
				
				thumbGrid.visible = false;
				thumbGrid.alpha = 0;
				
				TweenMax.fromTo(contentsContainer, contentsScrollTime, { y: stage.stageHeight }, { y: 0, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				TweenMax.to(thumbGrid, thumbGridFadeInTime, { autoAlpha: 1, ease:Sine.easeInOut, delay: thumbGridFadeInDelay } );
			}
			else
			{
				// Details going out of view
				TraceUtility.debug(this, "contentsContainer: " + contentsContainer);
				TweenMax.to(thumbGrid, thumbGridFadeOutTime, { autoAlpha: 0 } );
				TweenMax.to(contentsContainer, contentsScrollTime, { y: stage.stageHeight, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				
				// Landing coming into view
				setCurrentViewState(VIEWSTATE_LANDING);
				initCurrentView();
				rootContainer.addChildAt(contentsContainer, 0);
				rootContainer.addChildAt(thumbGrid, 1);
				
				thumbGrid.visible = false;
				thumbGrid.alpha = 0;
				
				TweenMax.fromTo(contentsContainer, contentsScrollTime, { y: -contentsContainer.height }, { y: 0, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				TweenMax.to(thumbGrid, thumbGridFadeInTime, { autoAlpha: 1, ease:Sine.easeInOut, delay: thumbGridFadeInDelay } );
			}
			
			TweenMax.delayedCall(1.2, onTransitionComplete);
		}
		
		private function onTransitionComplete():void 
		{
			isTransitioning = false;
			
			// Clean everything up that's no on stage
			// Currently only two objects are on stage - contentsContainer and thumbGrid
			if (rootContainer.numChildren > 2)
			{
				var childIndex:int = 2;
				while (childIndex < rootContainer.numChildren)
				{
					var child:CasaSprite = rootContainer.getChildAt(childIndex) as CasaSprite;
					child.destroy();
					rootContainer.removeChildAt(childIndex);
				}
			}
		}
		
		private function onLeftClick(e:MouseEvent):void 
		{
			if (isTransitioning) return;
			if (isScrolling) return;
			scroll(+1);
		}
		
		private function onRightClick(e:MouseEvent):void 
		{
			if (isTransitioning) return;
			if (isScrolling) return;
			scroll(-1);
		}
		
		private function scroll(direction:int):void
		{
			isScrolling = true;
			for (var index:int = 0; index < contents.length; index++)
			{
				//com.greensock.easing.
				TweenMax.to(contents[index], 0.6, { x: contents[index].x + 765 * direction, ease:Quad.easeInOut } );
				
				// Make the contents that's going to be come into view clickable
				contents[index].interactionEnabled = (index == (2 - direction));
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
			
			//trace("current week: " + currentWeek + " " + content.week);
			if (content.week == currentWeek)
			{
				//TODO: Right now only current week has photo, this will change when server-side integration is done
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
			if (value > WEEKS_PER_YEAR)
			{
				return value % WEEKS_PER_YEAR;
			}
			else if (value <= 0)
			{
				return WEEKS_PER_YEAR + value;
			}
			else
			{
				return value;
			}
		}	
		
		public function get contentsContainer():CasaSprite 
		{
			return viewStateInfoList[currentViewState].contentsContainer;
		}
		
		public function set contentsContainer(value:CasaSprite):void
		{
			viewStateInfoList[currentViewState].contentsContainer = value;
		}
		
		public function get thumbGrid():CasaSprite 
		{
			return viewStateInfoList[currentViewState].thumbGrid;
		}
		
		public function set thumbGrid(value:CasaSprite):void
		{
			viewStateInfoList[currentViewState].thumbGrid = value;
		}
		
		public function get contents():Vector.<PhotoContent> 
		{
			return viewStateInfoList[currentViewState].contents;
		}
		
		public function set contents(value:Vector.<PhotoContent>):void
		{
			viewStateInfoList[currentViewState].contents = value;
		}
	}
}

import com.fiftytwomoments.ui.PhotoContent;
import org.casalib.display.CasaSprite;
import mx.core.BitmapAsset;

class ViewStateInfo
{
	public var contentsContainer:CasaSprite;
	public var contents:Vector.<PhotoContent>;
	public var thumbGrid:CasaSprite;
	public var image:BitmapAsset;
	
	public function ViewStateInfo()
	{
		
	}
}