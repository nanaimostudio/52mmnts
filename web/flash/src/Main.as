package  
{
	import com.fiftytwomoments.type.AppConstants;
	import com.fiftytwomoments.ui.About;
	import com.fiftytwomoments.ui.GetInvolved;
	import com.fiftytwomoments.ui.SiteTitle;
	import com.fiftytwomoments.ui.TopNav;
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.Sprite;
	import com.nanaimostudio.utils.SystemUsage;
	import com.fiftytwomoments.DisplayManager;
	import com.demonsters.debugger.MonsterDebugger;
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
		public var siteTitle:SiteTitle;
		public var topNav:TopNav;
		private var displayManager:DisplayManager;
		
		public function Main() 
		{
			//addChild(new SystemUsage());
			StageReference.setStage(this.stage);
			
			displayManager = new DisplayManager(this);
			
			siteTitle.addEventListener(MouseEvent.CLICK, onSiteTitleClick);
			topNav.addEventListener(MouseEvent.CLICK, onTopNavClicked);
			displayManager.addEventListener(AppConstants.PHOTOCONTENT_CLICKED, onPhotoContentsClicked);
		}
		
		private function onTopNavClicked(e:MouseEvent):void 
		{
			if (e.target is About)
			{
				trace("isAboutSelected: " + topNav.isAboutSelected);
				displayManager.showAbout();
			}
			else if (e.target is GetInvolved)
			{
				trace("isGetInvolvedSelected: " + topNav.isGetInvolvedSelected);
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