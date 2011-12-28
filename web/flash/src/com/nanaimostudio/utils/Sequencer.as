package com.nanaimostudio.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Sequencer extends EventDispatcher
	{
		private var calls:Array = new Array();				// list of SequenceEvent objects
		private var position:int = 0;						// position within calls
		private var currentSequenceEvent:SequenceEvent;		// current event
		private var nextSequenceEvent:SequenceEvent;		// next event to be called when current event completes
		
		public function Sequencer()
		{
		
		}
		
		/**
		 * play
		 * initiates a sequence using current position (not necessarily 0)
		 */
		public function play(customCompleteEvent:Event=null):void
		{
			//AppTrace("play sequence: " + position, this, 1);
			nextSequenceEvent = calls[position];
			nextCall();
		}
		
		/**
		 * stop
		 * stops a sequence from continuing
		 */
		public function stop():void
		{
			// remove listener if currentSequenceEvent exists
			if (currentSequenceEvent)
			{
				currentSequenceEvent.target.removeEventListener(currentSequenceEvent.eventID, nextCall);
			}
		}
		
		/**
		 * reset
		 * reset a sequence stopping it and setting its position to 0
		 */
		public function reset():void
		{
			// remove listener if currentSequenceEvent exists
			if (currentSequenceEvent)
			{
				currentSequenceEvent.target.removeEventListener(currentSequenceEvent.eventID, nextCall);
			}
			
			// clear events and set position to 0
			currentSequenceEvent = null;
			nextSequenceEvent = null;
			position = 0;
		}
		
		/**
		 * clear
		 * resets sequence and removes all calls 
		 */
		public function clear():void
		{
			reset();
			calls.length = 0;
		}
		
		/**
		 * addEvent
		 * adds a call to the sequence
		 */
		public function addEvent(callback:Function, args:Array = null, target:EventDispatcher = null, eventID:String = null):void
		{
			// create new SequenceEvent object to hold call, its arguments and event information
			var addedSequenceEvent:SequenceEvent = new SequenceEvent(callback, args, target, eventID);
			
			// add event to calls
			calls.push(addedSequenceEvent);
			
			// if added in the middle of a sequence and at the
			// end of that sequence, make this event the next event
			if (currentSequenceEvent && !nextSequenceEvent)
			{
				nextSequenceEvent = addedSequenceEvent;
			}
		}
		
		
		/**
		 * nextCall - event handler
		 * method that calls the next call in the sequence
		 */
		private function nextCall(event:Event = null):void
		{
			// if a call exists for the next event
			if (nextSequenceEvent)
			{
				// save the next call to call it later
				var firing:SequenceEvent = nextSequenceEvent;
				
				// remove listener if currentSequenceEvent exists
				if (currentSequenceEvent)
				{
					currentSequenceEvent.target.removeEventListener(currentSequenceEvent.eventID, nextCall);
				}
				
				// reassign current call to next call
				currentSequenceEvent = nextSequenceEvent;
				
				// update position, if additional calls exist
				// reassign nextSequenceEvent to the next call
				position++;
				//AppTrace("currentCall: " + currentSequenceEvent.eventID + " nextCall: " + position + " " + (calls[position] ? calls[position].eventID : "") + " " + calls.length, this, 1);
				
				if (position < calls.length)
				{
					nextSequenceEvent = calls[position];
				}
				else
				{
					// set next to null if no more calls exist
					nextSequenceEvent = null;
				}
				
				currentSequenceEvent.target.addEventListener(currentSequenceEvent.eventID, nextCall);
				
				// call the firing call
				firing.callback.apply(firing.target, firing.args);
				
				// if the firing target is itself, dispatch the default event
				// which will fire the next call in the sequence
				if (firing.target == firing)
				{
					firing.dispatchEvent(new Event(SequenceEvent.EVENT));
				}
			}
			else
			{
				//BUG FIX: when complete, reset -boon
				dispatchEvent(new Event(Event.COMPLETE));
				reset();
			}
		}
	}
}


import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * SequenceEvent
 * object representing the callback/event information for an item the sequence
 */
class SequenceEvent extends EventDispatcher
{
	public var target:EventDispatcher;		// object handling events for event id
	public var callback:Function;			// callback function in sequence
	public var args:Array = new Array();	// optional arguments for callback
	public var eventID:String;				// event id to indicate callback completion and start of next event
	
	// default event - fires directly after previous callback call
	public static const EVENT:String = "sequence";
		
	public function SequenceEvent(callback:Function, args:Array = null, target:EventDispatcher = null, eventID:String = null):void
	{
		this.callback = callback;
		this.args = (args) ? args : new Array();
		
		// if target is passed, use it and COMPLETE for default event if not given
		if (target)
		{
			this.target = target;
			this.eventID = (eventID) ? eventID : Event.COMPLETE;
		}
		else
		{
			// default to this as event dispatcher using default sequence event 
			this.target = this;
			this.eventID = EVENT;
		}
	}
}