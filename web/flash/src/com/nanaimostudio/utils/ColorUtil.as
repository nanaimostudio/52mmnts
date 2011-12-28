package com.nanaimostudio.utils 
{
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class ColorUtil 
	{
		public static function getRandomHue():uint
		{
			return ColorUtil.HSBToRGB({h: Math.floor(Math.random() * 0xffffff) % 360, s: 255, b:255});
		}
		
		public static function HSBToRGB(HSB:Object):uint
		{
			var RGB:Object = { rb:0, gb:0, bb:0 };
			
			HSB.s *= 2.55; HSB.b *= 2.55; 
			if (!HSB.h  && !HSB.s)
			{
				RGB.rb = RGB.gb = RGB.bb = HSB.b;
			}
			else
			{
				var diff = (HSB.b * HSB.s)/255;
				var low = HSB.b - diff;
				if (HSB.h > 300 || HSB.h <= 60)
				{
					RGB.rb = HSB.b;
					if (HSB.h > 300)
					{
						RGB.gb = Math.round(low);
						HSB.h = (HSB.h-360)/60;
						RGB.bb = -Math.round(HSB.h*diff - low);
					}
					else
					{
						RGB.bb = Math.round(low);
						HSB.h = HSB.h/60;
						RGB.gb = Math.round(HSB.h*diff + low);
					}
				}
				else if (HSB.h > 60 && HSB.h < 180)
				{
					RGB.gb = HSB.b;
					if (HSB.h < 120)
					{
						RGB.bb = Math.round(low);
						HSB.h = (HSB.h/60 - 2) * diff;
						RGB.rb = Math.round(low - HSB.h);
					}
					else
					{
						RGB.rb = Math.round(low);
						HSB.h = (HSB.h/60 - 2) * diff;
						RGB.bb = Math.round(low + HSB.h);
					}
				}
				else
				{
					RGB.bb = HSB.b;
					if (HSB.h < 240)
					{
						RGB.rb = Math.round(low);
						HSB.h = (HSB.h/60 - 4) * diff;
						RGB.gb = Math.round(low - HSB.h);
					}
					else
					{
						RGB.gb = Math.round(low);
						HSB.h = (HSB.h/60 - 4) * diff;
						RGB.rb = Math.round(low + HSB.h);
					}
				}
			}
			
			return RGB.rb << 16 | RGB.gb << 8 | RGB.bb;
		}
		
	}

}