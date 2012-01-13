package com.fiftytwomoments.data 
{
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class AppData 
	{
		public var currentWeek:int;
		public var momentsData:Object;
		
		public function AppData() 
		{
			
		}
		
		public function getTotalNumberOfMoments():int
		{
			return (momentsData && momentsData is Array) ? (momentsData as Array).length : 1;
		}
		
		public function getMomentsData(week:int):Object
		{
			if (week < 0 || week > 52) return { };
			return momentsData[week];
		}
		
		public function getMostCurrentMoment():Object
		{
			return momentsData[getTotalNumberOfMoments() - 1];
		}
		
	}

}