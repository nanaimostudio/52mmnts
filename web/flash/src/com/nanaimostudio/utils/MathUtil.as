package com.nanaimostudio.utils 
{
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class MathUtil 
	{
		
		public static function round(num:Number, decimals:Number = 2):Number
		{
			var d:Number = Math.pow(10, decimals);
			return Math.round(num * d) / d;
		}
	}
}