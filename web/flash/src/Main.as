package  
{
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.Sprite;
	import com.nanaimostudio.utils.SystemUsage;
	import com.fiftytwomoments.DisplayManager;
	import com.demonsters.debugger.MonsterDebugger;
	import org.casalib.display.CasaSprite;
	import org.casalib.util.StageReference;
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Main extends CasaSprite
	{
		
		public function Main() 
		{
			addChild(new SystemUsage());
			StageReference.setStage(this.stage);
			
			new DisplayManager(this);
		}
	}
}