package com.nanaimostudio.utils 
{
	
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class StringUtil 
	{
		// Test
		//{
			//testMakePath();
		//}
		public static function isEmpty(value:String):Boolean
		{
			return value == null || value.length == 0;
		}
		
		public static function pad(value:Number, repeat:Number, padDigit:Number):String
		{
			var pad:String = "";
			repeat = repeat - String(value).length;
			for (var count:Number = 0; count < repeat; count++)
			{
				pad += String(padDigit);
			}
			
			return pad + String(value);
		}
		
		public static function padZero(value:Number, repeat:Number):String
		{
			return pad(value, repeat, 0);
		}
		
		public static function formatTime(seconds:Number, separator:String = ":"):String
		{
			var hours:int = 0;
			var minutes:int = 0;
				
			if (seconds >= 3600)
			{
				hours = Math.floor(seconds / 3600);
			}
			
			seconds -= hours * 3600;
			
			if (seconds >= 60)
			{
				minutes = Math.floor(seconds / 60);
			}
			
			seconds -= minutes * 60;
			
			var res:String = minutes + separator + StringUtil.padZero(seconds, 2);
			//trace("hours: " + hours + " " + minutes + " " + seconds + " " + res);
			
			return res;
		}

		
		public static function makePath(path1:String, path2:String):String
		{
			var pathComponentOne:String = path1;
			var pathComponentTwo:String = path2;
			
			if (path1 == null || path1.length == 0)
			{
				pathComponentOne = "";
			}
			else if (path1.substring(path1.length - 1) == "/")
			{
				// remove trailing slash
				if (path1.length > 1)
				{
					pathComponentOne = path1.substr(0, path1.length - 1);
				}
				else
				{
					pathComponentOne = "";
				}
			}
			
			if (path2 == null || path2.length == 0)
			{
				pathComponentTwo = "";
			}
			else if (path2.substr(0, 1) == "/")
			{
				// remove leading slash
				if (path2.length > 1)
				{
					pathComponentTwo = path2.substr(1);
				}
				else
				{
					pathComponentTwo = "";
				}
			}
			
			if (pathComponentOne == null || pathComponentOne.length == 0)
			{
				AppTrace("makePath: " + path1 + " + " + path2 + " = " + pathComponentTwo);
				return pathComponentTwo;
			}
			else
			{
				AppTrace("makePath: " + path1 + " + " + path2 + " = " + pathComponentOne + "/" + pathComponentTwo);
				return pathComponentOne + "/" + pathComponentTwo;
			}
		}
		
		public static function testMakePath():void
		{
			makePath("", "");
			makePath("", "test");
			makePath("/", "test");
			makePath("/", "/");
			makePath("test1", "");
			makePath("test1", "/");
			makePath("test1", "test2");
			makePath("test1/test2/", "test3");
			makePath("test1/", "/test2");
			makePath("test1", "/test2");
		}
		
		public static function replace(str:String, oldSubStr:String, newSubStr:String):String
		{
			return str.split(oldSubStr).join(newSubStr);
		}

		public static function trim(str:String, char:String = " "):String
		{
			return trimBack(trimFront(str, char), char);
		}

		public static function trimFront(str:String, char:String):String
		{
			char = stringToCharacter(char);
			if (str.charAt(0) == char)
			{
				str = trimFront(str.substring(1), char);
			}
			return str;
		}

		public static function trimBack(str:String, char:String):String
		{
			char = stringToCharacter(char);
			if (str.charAt(str.length - 1) == char)
			{
				str = trimBack(str.substring(0, str.length - 1), char);
			}
			return str;
		}
		
		public static function stringToCharacter(str:String):String
		{
			if (str.length == 1)
			{
				return str;
			}
			return str.slice(0, 1);
		}
	}
}