package  
{
	import flash.display.Sprite;
	import com.nanaimostudio.utils.SystemUsage;
	import com.fiftytwomoments.DisplayManager;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class Main extends Sprite
	{
		
		public function Main() 
		{
			addChild(new SystemUsage());
			new DisplayManager(this);
		}
		
	}

}