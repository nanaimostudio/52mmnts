package com.nanaimostudio.utils
{
	import com.demonsters.debugger.MonsterDebugger;
	import org.casalib.util.StageReference;

	public class TraceUtility
	{
		private static var userName : String = "";
		public static var enabled : Boolean = true;

		public static const WARNING_COLOR : uint = 0xeab740;
		public static const ERROR_COLOR : uint = 0xd94100;
		public static const TRACKING_COLOR : uint = 0x00aa00;
		public static const DEBUG_COLOR : uint = 0x0000FF;
		
		private static var isInitialized:Boolean;
		
		private static function initialize():void 
		{
			if (isInitialized) return;
			
			isInitialized = true;
			MonsterDebugger.initialize(StageReference.getStage());
		}
		
		public static function debug(sender: Object, msg: Object, label: String = ""): void
		{
			initialize();
			
			label = label == "" ? "DEBUG" : label;
			trace(sender + ": " + msg);
			if (enabled) {
				MonsterDebugger.trace(sender, msg, userName, label, DEBUG_COLOR);
			}
		}
		
		public static function message(sender: Object, msg: Object, label: String = ""): void
		{
			initialize();
			
			label = label == "" ? "MESSAGE" : label;
			trace(sender + ": " + msg);
			if (enabled) {
				MonsterDebugger.trace(sender, msg, userName,label);
			}
		}

		public static function warning(sender: Object, msg: Object, label: String = ""): void
		{
			initialize();
			
			label = label == "" ? "WARNING" : label;
			trace(sender + ": " + msg);
			if (enabled) {
				MonsterDebugger.trace(sender, msg, userName, label, WARNING_COLOR);
			}
		}

		public static function error(sender: Object, msg: Object, label: String = ""): void
		{
			initialize();
			
			label = label == "" ? "ERROR" : label;
			trace(sender + ": " + msg);
			if (enabled) {
				MonsterDebugger.trace(sender, msg, userName, label, ERROR_COLOR);
			}
		}

		static public function set enable(enableMonsterDebugger : Boolean) : void
		{
			enabled = enableMonsterDebugger;
		}
	}
}
