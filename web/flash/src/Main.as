package  
{
	import com.fiftytwomoments.data.AppData;
	import com.fiftytwomoments.type.AppConstants;
	import com.fiftytwomoments.ui.About;
	import com.fiftytwomoments.ui.Contacts;
	import com.fiftytwomoments.ui.FooterNav;
	import com.fiftytwomoments.ui.GetInvolved;
	import com.fiftytwomoments.ui.SiteTitle;
	import com.fiftytwomoments.ui.TopNav;
	import com.greensock.TweenMax;
	import com.nanaimostudio.utils.fluidLayout.FluidObject;
	import com.nanaimostudio.utils.fluidLayout.SimpleFluidObject;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.Sprite;
	import com.nanaimostudio.utils.SystemUsage;
	import com.fiftytwomoments.DisplayManager;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.StageReference;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Main extends CasaSprite
	{
		private var siteTitle:SiteTitle;
		private var topNav:TopNav;
		private var displayManager:DisplayManager;
		private var topNavRightPadding:int;
		private var footerNav:FooterNav;
		private var contacts:Contacts;
		
		public function Main() 
		{
			//addChild(new SystemUsage());
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			StageReference.setStage(this.stage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			FluidObject.minStageWidth = stage.stageWidth * 0.8;
			FluidObject.minStageHeight = stage.stageHeight * 0.85;
			
			// Parse flashvars
			var currentWeek:int = 1;
			if (this.loaderInfo.parameters != null && this.loaderInfo.parameters["currentWeek"] != null)
			{
				currentWeek = this.loaderInfo.parameters["currentWeek"];
			}
			
			displayManager = new DisplayManager();
			var appData:AppData = new AppData();
			appData.currentWeek = currentWeek;
			displayManager.data = appData;
			displayManager.root = this;
			displayManager.init();
			
			footerNav = new FooterNav();
			footerNav.name = "footerNav";
			footerNav.x = 280;
			footerNav.y = 750;
			footerNav.alpha = 0.25;
			addChild(footerNav);
			
			contacts = new Contacts();
			contacts.name = "siteTitle";
			contacts.x = 887;
			contacts.y = 750;
			contacts.alpha = 0.25;
			addChild(contacts);
			
			siteTitle = new SiteTitle();
			siteTitle.name = "siteTitle";
			siteTitle.x = 131;
			siteTitle.y = 55;
			addChild(siteTitle);
			
			topNav = new TopNav();
			topNav.name = "topNav";
			topNav.x = 926;
			topNav.y = 59;
			addChild(topNav);
			
			siteTitle.addEventListener(MouseEvent.CLICK, onSiteTitleClick);
			topNav.addEventListener(MouseEvent.CLICK, onTopNavClicked);
			displayManager.addEventListener(AppConstants.PHOTOCONTENT_CLICKED, onPhotoContentsClicked);
			
			new FluidObject(siteTitle, { x: 0, y: 0, offsetX: siteTitle.x, offsetY: 55 } );
			new FluidObject(topNav, { x: 1, y: 0, offsetX: topNav.x - stage.stageWidth, offsetY:59 } ); 
			new FluidObject(contacts, { x: 1, y: 1, offsetX: -contacts.width * 0.5 - 40, offsetY:contacts.y - stage.stageHeight } ); 
			new FluidObject(footerNav, { x: 0, y: 1, offsetX:footerNav.x, offsetY: footerNav.y - stage.stageHeight } ); 
		}
		
		private function onTopNavClicked(e:MouseEvent):void 
		{
			if (e.target is About)
			{
				//trace("isAboutSelected: " + topNav.isAboutSelected);
				displayManager.showAbout();
			}
			else if (e.target is GetInvolved)
			{
				//trace("isGetInvolvedSelected: " + topNav.isGetInvolvedSelected);
				displayManager.showGetInvolved();
			}
		}
		
		private function onSiteTitleClick(e:MouseEvent):void 
		{
			topNav.reset();
			displayManager.showLanding();
		}
		
		private function onPhotoContentsClicked(e:Event):void
		{
			topNav.setGetInvolvedState(true);
		}
	}
}