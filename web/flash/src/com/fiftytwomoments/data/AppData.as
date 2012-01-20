package com.fiftytwomoments.data 
{
	import com.nanaimostudio.utils.TraceUtility;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Boon Chew
	 */
	public class AppData 
	{
		public var currentWeek:int = 1;
		public var comingSoonDate:String = "";
		private var _momentsData:Vector.<FeaturedMoment>;
		//public var submittedMomentsData:Object;
		//public var photosList:Vector.<Sprite>;
		private var _submittedMomentDataList:Vector.<Vector.<SubmittedMoment>>;
		
		public function AppData() 
		{
			
		}
		
		public function getTotalNumberOfMoments():int
		{
			return (momentsData && momentsData is Array) ? (momentsData as Array).length : 1;
		}
		
		public function getMomentsDataForWeek(week:int):FeaturedMoment
		{
			if (week < 0 || week > 52) return null;
			if (week > momentsData.length) return null;
			
			return momentsData[week - 1];
		}
		
		public function getMostCurrentMoment():FeaturedMoment
		{
			return momentsData[getTotalNumberOfMoments() - 1];
		}
		
		public function getPhotoForWeek(week:int):Sprite
		{
			return null;
		}
		
		public function getSubmittedMomentDataForWeek(week:int):Vector.<SubmittedMoment>
		{
			if (week < 0 || week > 52) return null;
			if (week > submittedMomentDataList.length - 1) return null;
			return submittedMomentDataList[week];
		}
		
		public function get momentsData():Vector.<FeaturedMoment> 
		{
			return _momentsData;
		}
		
		public function set momentsData(value:Vector.<FeaturedMoment>):void 
		{
			_momentsData = value;
		}
		
		public function get submittedMomentDataList():Vector.<Vector.<SubmittedMoment>> 
		{
			return _submittedMomentDataList;
		}
		
		public function set submittedMomentDataList(value:Vector.<Vector.<SubmittedMoment>>):void 
		{
			_submittedMomentDataList = value;
		}
		
		
		/*
		public function setSubmittedMomentData(data:Array):void
		{
			if (submittedMomentsDataList[week] == null)
			{
				submittedMomentDataList[week] = [];
			}
			
			submittedMomentDataList[week] = data;
		}
		*/
	}
}