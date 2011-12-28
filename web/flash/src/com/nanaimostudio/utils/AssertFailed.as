package com.nanaimostudio.utils
{
	public function AssertFailed(message:String=null, throwError:Boolean=true):void
	{
		Assert(false, message, throwError);
	}
}