package com.nanaimostudio.utils 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class CoordUtil 
	{
		public static function localToLocal(from:DisplayObject, to:DisplayObject, origin:Point = null):Point
		{
			var point:Point = origin ? origin : new Point();
			return to.globalToLocal(from.localToGlobal(point));
		}
	}
}