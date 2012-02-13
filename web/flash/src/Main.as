package  
{
	import com.fiftytwomoments.data.AppData;
	import com.fiftytwomoments.services.MomentsData;
	import com.fiftytwomoments.services.MomentsDataService;
	import com.fiftytwomoments.type.AppConstants;
	import com.fiftytwomoments.ui.About;
	import com.fiftytwomoments.ui.Contacts;
	import com.fiftytwomoments.ui.FooterNav;
	import com.fiftytwomoments.ui.GetInvolved;
	import com.fiftytwomoments.ui.SiteTitle;
	import com.fiftytwomoments.ui.TopNav;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import com.nanaimostudio.utils.fluidLayout.FluidObject;
	import com.nanaimostudio.utils.fluidLayout.SimpleFluidObject;
	import com.nanaimostudio.utils.Sequencer;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.Sprite;
	import com.nanaimostudio.utils.SystemUsage;
	import com.fiftytwomoments.DisplayManager;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.FlashVarUtil;
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
		private var appData:AppData;
		
		public function Main() 
		{
			//addChild(new SystemUsage());
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			StageReference.setStage(this.stage);
			
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			FluidObject.minStageWidth = 1024;
			FluidObject.minStageHeight = 768;

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
			
			var siteNavYOffset:int = 55 - 20;
			siteTitle = new SiteTitle();
			siteTitle.name = "siteTitle";
			siteTitle.x = 131;
			siteTitle.y = siteNavYOffset;
			addChild(siteTitle);
			
			var topNavYOffset:int = 59 - 20;
			topNav = new TopNav();
			topNav.name = "topNav";
			topNav.x = 926;
			topNav.y = topNavYOffset;
			addChild(topNav);
			
			siteTitle.addEventListener(MouseEvent.CLICK, onSiteTitleClick);
			topNav.addEventListener(MouseEvent.CLICK, onTopNavClicked);
			
			new FluidObject(siteTitle, { x: 0, y: 0, offsetX: siteTitle.x, offsetY: siteNavYOffset } );
			new FluidObject(topNav, { x: 1, y: 0, offsetX: -100, offsetY:topNavYOffset } ); 
			new FluidObject(contacts, { x: 1, y: 1, offsetX: -contacts.width * 0.5 - 40, offsetY: -20 } ); 
			new FluidObject(footerNav, { x: 0, y: 1, offsetX: footerNav.x, offsetY: -20 } );
			
			appData = new AppData();
			
			// Parse flashvars
			// for testing
			appData.currentWeek = 5;
			appData.comingSoonDate = "Feb 14";
			if (FlashVarUtil.hasKey("currentWeek"))
			{
				appData.currentWeek = int(FlashVarUtil.getValue("currentWeek"));
			}
			
			if (FlashVarUtil.hasKey("comingSoonDate"))
			{
				appData.comingSoonDate = String(FlashVarUtil.getValue("comingSoonDate"));
			}
			
			var momentsDataService:MomentsDataService = new MomentsDataService();
			var dataSequencer:Sequencer = new Sequencer();
			dataSequencer.addEvent(momentsDataService.getAllMoments, null, momentsDataService, Event.COMPLETE);
			dataSequencer.addEvent(onAllMomentsLoaded, [ momentsDataService ], this, Event.COMPLETE);
			dataSequencer.addEvent(momentsDataService.getAllSubmittedMoments, [ appData.currentWeek ], momentsDataService, "AllSubmittedDataComplete");
			dataSequencer.addEvent(onAllSubmittedLoaded, [ momentsDataService ], this, Event.COMPLETE);
			dataSequencer.addEvent(run);
			dataSequencer.play();
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			TraceUtility.debug(this, "stage click: " + e.target + " " + e.target.name);
		}
		
		private function onAllMomentsLoaded(momentsDataService:MomentsDataService):void 
		{
			TraceUtility.debug(this, "onAllMomentsLoaded");
			appData.momentsData = momentsDataService.momentsData;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onAllSubmittedLoaded(momentsDataService:MomentsDataService):void 
		{
			TraceUtility.debug(this, "onAllSubmittedLoaded");
			//appData.submittedMomentsData = momentsDataService.returnData;
			appData.submittedMomentDataList = momentsDataService.submittedMomentsDataList;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function run():void 
		{
			displayManager = new DisplayManager();
			displayManager.addEventListener(AppConstants.PHOTOCONTENT_CLICKED, onPhotoContentsClicked);
			
			TraceUtility.debug(this, "momentsData: " + appData.momentsData);
			displayManager.data = appData;
			displayManager.root = this;
			displayManager.init();
			
			TraceUtility.debug(this, "appData: "  + appData.getTotalNumberOfMoments());
		}
		
		private function onTopNavClicked(e:MouseEvent):void 
		{
			if (displayManager == null) return;
			
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