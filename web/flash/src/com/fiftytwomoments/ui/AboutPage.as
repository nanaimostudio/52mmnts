﻿package com.fiftytwomoments.ui {	import com.nanaimostudio.utils.URLNavigator;	import flash.display.Sprite;	import flash.events.MouseEvent;	/**	 * ...	 * @author Boon Chew	 */	public class AboutPage extends Sprite	{		public var nanaimostudioSite:HitBox;		public var nanaimoStudioTwitter:HitBox;		public var julianBialowasSite:HitBox;		public var julianBialowasTwitter:HitBox;				public function AboutPage()		{			nanaimostudioSite.addEventListener(MouseEvent.CLICK, onSiteClick);			nanaimoStudioTwitter.addEventListener(MouseEvent.CLICK, onTwitterClick);			julianBialowasSite.addEventListener(MouseEvent.CLICK, onSiteClick);			julianBialowasTwitter.addEventListener(MouseEvent.CLICK, onTwitterClick);		}				private function onSiteClick(e:MouseEvent):void 		{			if (e.target == nanaimostudioSite)			{				URLNavigator.goto("http://nanaimostudio.com", "_blank");			}			else if (e.target == julianBialowasSite)			{				URLNavigator.goto("http://julianbialowas.com", "_blank");			}		}				private function onTwitterClick(e:MouseEvent):void 		{			if (e.target == nanaimoStudioTwitter)			{				URLNavigator.goto("http://www.twitter.com/nanaimostudio", "_blank");			}			else if (e.target == julianBialowasTwitter)			{				URLNavigator.goto("http://www.twitter.com/julianbialowas", "_blank");			}		}	}}