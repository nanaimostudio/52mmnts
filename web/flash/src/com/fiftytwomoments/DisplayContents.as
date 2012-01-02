package com.fiftytwomoments 
{
	import com.fiftytwomoments.data.TeaserImage;
	import com.fiftytwomoments.type.AppConstants;
	import com.fiftytwomoments.ui.About;
	import com.fiftytwomoments.ui.AboutPage;
	import com.fiftytwomoments.ui.LeftArrow;
	import com.fiftytwomoments.ui.PhotoContent;
	import com.fiftytwomoments.ui.RightArrow;
	import com.fiftytwomoments.ui.ThumbGrid;
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
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
		
		private var aboutPage:AboutPage;
		
		private var VIEWSTATE_LANDING:String = "ViewState.Landing";
		private var VIEWSTATE_DETAILS:String = "ViewState.Details";
		
		// five pages, the middle page is 2
		private var MIDDLE_SCROLL_PAGE_INDEX:int = int((5 - 1)/ 2);
		
		
		public function DisplayContents() 
		{
			init();
		}
		
		private function init():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			rootContainer = new CasaSprite();
			addChildAt(rootContainer, 0);
			
			aboutPage = new AboutPage();
			aboutPage.alpha = 0;
			aboutPage.visible = false;
			addChild(aboutPage);
			
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
			//rootContainer.addChildAt(thumbGrid, 1);
		}
		
		public function showAbout():void
		{
			if (isTransitioning) return;
			if (isScrolling) return;
			
			if (this.rootContainer.visible)
			{
				TweenMax.to(this.rootContainer, 0.5, { autoAlpha: 0, ease:Sine.easeInOut } );
				TweenMax.to(this.aboutPage, 0.5, { autoAlpha: 1, ease:Sine.easeInOut } );
			}
		}
		
		public function showGetInvolved():void
		{
			if (isTransitioning) return;
			if (isScrolling) return;
			
			if (this.aboutPage.visible)
			{
				TweenMax.to(this.aboutPage, 0.5, { autoAlpha: 0, ease:Sine.easeInOut } );
				TweenMax.to(this.rootContainer, 0.5, { autoAlpha: 1, ease:Sine.easeInOut } );
				
				if (currentViewState == VIEWSTATE_LANDING)
				{
					TweenMax.delayedCall(0.6, toggleLandingDetailView);
				}
			}
			else
			{
				if (currentViewState == VIEWSTATE_LANDING)
				{
					toggleLandingDetailView();
				}
			}
		}
		
		public function showLanding():void
		{
			if (!this.rootContainer.visible)
			{
				TweenMax.to(this.rootContainer, 0.5, { autoAlpha: 1, ease:Sine.easeInOut } );
				if (currentViewState == VIEWSTATE_DETAILS)
				{
					TweenMax.delayedCall(0.6, toggleLandingDetailView);
				}
				
				if (this.aboutPage.visible)
				{
					TweenMax.to(this.aboutPage, 0.5, { autoAlpha: 0, ease:Sine.easeInOut } );
				}
			}
			else
			{
				if (currentViewState == VIEWSTATE_DETAILS)
				{
					toggleLandingDetailView();
				}
			}
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
			trace("init current view");
			thumbGrid = new ThumbGrid();
			thumbGrid.name = "thumbGrid";
			thumbGrid.interactionDelegate = this;
			
			thumbGrid.x = -thumbGrid.width * 0.5;
			thumbGrid.y = 260;
			
			thumbGrid.week = weekInView;
		
			contentsContainer = new CasaSprite();
			contentsContainer.name = "contentsContainer";
			initContents();
			
			leftArrow.buttonMode = true;
			rightArrow.buttonMode = true;
			leftArrow.addEventListener(MouseEvent.CLICK, onLeftClick);
			rightArrow.addEventListener(MouseEvent.CLICK, onRightClick);
			
			setWeekInView(weekInView);
			
			//TODO: Remove when we get more contents
			leftArrow.visible = false;
			rightArrow.visible = false;
			thumbGrid.visible = false;
		}
		
		private function initContents():void 
		{
			contents = new Vector.<PhotoContent>();
			var dummyContent:PhotoContent = new PhotoContent();
			stage.stageWidth - dummyContent.width  - (MAX_CONTENTS - 1) * CONTENT_GAP;
			dummyContent = null;
			
			// Total five photos for optimal scrolling (and minimum memory usage)
			// Current week is always the third photo in the vector
			for (var index:int = -MIDDLE_SCROLL_PAGE_INDEX; index <= MIDDLE_SCROLL_PAGE_INDEX; index++)
			{
				var content:PhotoContent = createPhotoContent();
				content.useDefaultText = (currentViewState == VIEWSTATE_LANDING);
				var weekIndex:int = normalizeWeek(weekInView + index);
				
				//trace("Week index: " + weekIndex);
				content.week = weekIndex;
				content.name = "content" + weekIndex;
				content.x = 765 * index;
				
				//TODO: From server-side
				// In the beginning, the current view (at index 0) is the current week so it always has a photo
				updatePhotoContentForWeek(content, weekIndex);
			
				if (weekIndex == weekInView)
				{
					content.interactionEnabled = true;
				}
				
				//TODO: Remove this when we implement fluid layout
				if (index == 0)
				{
					contentsContainer.addChild(content);
				}
				contents.push(content);
			}
		}
		
		private function checkShowImageForWeek(weekIndex:int):Boolean 
		{
			// on landing page, only shows image if you are in the current week
			if (currentViewState == VIEWSTATE_LANDING)
			{
				trace("currentWeek: " + currentWeek + " weekIndex: " + weekIndex);
				return weekIndex == currentWeek;
			}
			else if (currentViewState == VIEWSTATE_DETAILS)
			{
				trace("currentViewState: " + VIEWSTATE_DETAILS);
				//TODO: on details page, show info image all the time until server-integration is done
				return weekIndex == currentWeek;
			}
			else
			{
				trace("catch all");
				return false;
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
		
		// ThumbGrid Interaction Delegate Method
		public function onThumbGridClicked(week:int):void
		{
			if (isScrolling) return;
			if (isTransitioning) return;
			
			isTransitioning = true;
			
			var photoContents:Array = new Array();
			for each (var pc:PhotoContent in contents)
			{
				photoContents.push(pc);
			}

			//for (var index:int = 0; index < contents.length; index++)
			//{
				//com.greensock.easing.
				var timeline:TimelineMax = new TimelineMax({ onComplete: onUpdateWeekInfoComplete });
				timeline.appendMultiple(TweenMax.allTo(photoContents, 0.5, { alpha: 0, ease:Sine.easeInOut } ));
				timeline.addCallback(updateWeekInfo, 0.6, [ week ]);
				timeline.appendMultiple(TweenMax.allTo(photoContents, 0.5, { alpha: 1, ease:Sine.easeInOut } ));
			//}
		}
		
		private function updateWeekInfo(newWeek:int):void 
		{
			trace("updateWeekInfo " + contents.length);
			setWeekInView(newWeek);
			
			for (var index:int = 0; index < contents.length; index++)
			{
				var week:int = normalizeWeek(weekInView + index - MIDDLE_SCROLL_PAGE_INDEX);
				contents[index].week = week;
				updatePhotoContentForWeek(contents[index], week);
			}
		}
		
		private function onUpdateWeekInfoComplete():void 
		{
			trace("onUpdateWeekInfoComplete");
			isTransitioning = false;
		}
		
		// PhotoContent Interaction Delegate Method
		public function onPhotoContentClicked(photoContent:PhotoContent = null):void
		{
			toggleLandingDetailView();
			dispatchEvent(new Event(AppConstants.PHOTOCONTENT_CLICKED));
		}
		
		public function toggleLandingDetailView():void
		{
			if (isScrolling) return;
			if (isTransitioning) return;
			
			isTransitioning = true;
			
			var thumbGridFadeOutTime:Number = 0.2;
			var thumbGridFadeInTime:Number = 0.25;
			var waitForThumbGridFadeOutDelay:int = thumbGridFadeInTime + 0.6;
			var thumbGridFadeInDelay:Number = 0.76;
			var contentsScrollTime:Number = 0.5;
			
			if (getCurrentViewState() == VIEWSTATE_LANDING)
			{
				// Landing going out of view
				TweenMax.to(thumbGrid, thumbGridFadeOutTime, { autoAlpha: 0 } );
				TweenMax.to(contentsContainer, contentsScrollTime, { y: -height * 1.5, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				//TweenMax.to(contentsContainer, 0.4, { alpha:0, ease:Quad.easeOut } );
				
				// Details coming into view
				setCurrentViewState(VIEWSTATE_DETAILS);
				initCurrentView();
				
				contentsContainer.y = stage.stageHeight;
				rootContainer.addChildAt(contentsContainer, 0);
				//rootContainer.addChildAt(thumbGrid, 1);
				thumbGrid.visible = false;
				thumbGrid.alpha = 0;
				
				TweenMax.fromTo(contentsContainer, contentsScrollTime, { y: stage.stageHeight }, { y: 0, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				TweenMax.to(thumbGrid, thumbGridFadeInTime, { autoAlpha: 1, ease:Sine.easeInOut, delay: thumbGridFadeInDelay } );
			}
			else
			{
				// Details going out of view
				TweenMax.to(thumbGrid, thumbGridFadeOutTime, { autoAlpha: 0 } );
				TweenMax.to(contentsContainer, contentsScrollTime, { y: stage.stageHeight, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				
				// Landing coming into view
				setCurrentViewState(VIEWSTATE_LANDING);
				initCurrentView();
				rootContainer.addChildAt(contentsContainer, 0);
				//rootContainer.addChildAt(thumbGrid, 1);
				
				thumbGrid.visible = false;
				thumbGrid.alpha = 0;
				
				TweenMax.fromTo(contentsContainer, contentsScrollTime, { y: -height * 1.5 }, { y: 0, ease:Sine.easeInOut, delay: waitForThumbGridFadeOutDelay } );
				TweenMax.to(thumbGrid, thumbGridFadeInTime, { autoAlpha: 1, ease:Sine.easeInOut, delay: thumbGridFadeInDelay } );
			}
			
			//TweenMax.delayedCall(thumbGridFadeInDelay + thumbGridFadeInTime, onSwitchViewComplete);
			TweenMax.delayedCall(contentsScrollTime + 0.1, onSwitchViewComplete);
		}
		
		// Done going from landing to details or vice versa
		private function onSwitchViewComplete():void 
		{
			isTransitioning = false;
			
			// Clean everything up that's no on stage
			// Currently only two objects are on stage - contentsContainer and thumbGrid
			if (rootContainer.numChildren > ViewStateInfo.SPRITE_COUNT)
			{
				while (rootContainer.numChildren > ViewStateInfo.SPRITE_COUNT)
				{
					var childIndex = rootContainer.numChildren - 1;
					var child:CasaSprite = rootContainer.getChildAt(childIndex) as CasaSprite;
					if (child == null) continue;
					child.removeAllChildrenAndDestroy(true, true);
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
			var scrollTime:Number = 0.5;
			
			isScrolling = true;
			for (var index:int = 0; index < contents.length; index++)
			{
				//com.greensock.easing.
				TweenMax.to(contents[index], scrollTime, { x: contents[index].x + 765 * direction, ease:Sine.easeInOut } );
				
				// Make the contents that's going to be come into view clickable
				// We have five images, so the middle image is index 2.
				contents[index].interactionEnabled = (index == (MIDDLE_SCROLL_PAGE_INDEX - direction));
			}
			
			weekInView -= direction;
			setWeekInView(normalizeWeek(weekInView));
			
			TweenMax.delayedCall(scrollTime + 0.1, onScrollComplete, [ direction ]);
		}
		
		private function setWeekInView(value:int):void
		{
			weekInView = value;
			
			if (thumbGrid)
			{
				thumbGrid.week = weekInView;
			}
		}
		
		private function onScrollComplete(direction:int):void
		{
			// Reuse photos for different weeks to create a carousel effect
			var content:PhotoContent;
			if (direction == -1)
			{
				content = contents.shift();
				content.week = normalizeWeek(weekInView + MIDDLE_SCROLL_PAGE_INDEX);
				// +2 offset from the middle photo
				content.x = 765 * 2;
				contents.push(content);
			}
			else
			{
				content = contents.pop();
				content.week = normalizeWeek(weekInView - MIDDLE_SCROLL_PAGE_INDEX);
				// -2 offset from the middle photo
				content.x = 765 * -MIDDLE_SCROLL_PAGE_INDEX;
				contents.unshift(content);
			}
			
			updatePhotoContentForWeek(content, content.week);
			
			//trace("current week: " + currentWeek + " " + content.week);
			isScrolling = false;
		}
		
		private function updatePhotoContentForWeek(content:PhotoContent, week:int):void 
		{
			if (checkShowImageForWeek(week))
			{
				trace("content: " + content.name + " set photo for weekIndex: " + week + " week in view: " + weekInView + " currentWeek: " + currentWeek);
				content.setPhoto(getViewStateImage());
			}
			else
			{
				if (content.hasPhoto())
				{
					content.removePhoto();
				}
			}
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
		
		public function get thumbGrid():ThumbGrid 
		{
			return viewStateInfoList[currentViewState].thumbGrid;
		}
		
		public function set thumbGrid(value:ThumbGrid):void
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
import com.fiftytwomoments.ui.ThumbGrid;
import org.casalib.display.CasaSprite;
import mx.core.BitmapAsset;

class ViewStateInfo
{
	public static var SPRITE_COUNT:int = 2;
	public var contentsContainer:CasaSprite;
	public var thumbGrid:ThumbGrid;
	public var contents:Vector.<PhotoContent>;
	public var image:BitmapAsset;
	
	public function ViewStateInfo()
	{
		
	}
}