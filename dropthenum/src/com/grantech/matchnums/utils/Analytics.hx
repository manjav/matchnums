package com.grantech.matchnums.utils;

import net.lion123dev.events.Events.GAPlatform;
import net.lion123dev.GameAnalytics;

class Analytics {
    static var gameAnalytics:GameAnalytics;
    
    
    static function init():Void{


        // Instantiate new GameAnalytics object with public and private keys
		// If the third parameter is true, a sandbox gameanalytics server will be used, so set it to false for production
		var ga = new GameAnalytics("90d9236b42bae628fd8f9b173e733312", "c75db4a6fe4816755cd382d4138fa9f79450c6ea", false);

		// Now we need to initialize it with success and fail callbacks, platform, os version, device and manufacturer. Some of these parameters may be removed later and auto generated instead.
		function onSuccess():Void {
			// Success callback is called when init request return success.
			trace("GA init succeed");
		}
		function onFail(error:String):Void {
			// Fail callback basically means that GameAnalytics can't work right now. Offline event caching is not yet available.
			// String parameter may contain useful information on why fail happened
			trace(error);
		}

		// IMPORTANT! Platform and os version must follow Game Analytics validation rules (see #1)
		ga.Init(onSuccess, onFail, GAPlatform.ANDROID, GAPlatform.ANDROID + " 10", "unknown", "manufacturer");

		// If you want a callback every time sending events fail or succeed, just rebind OnSubmitSuccess() and OnSubmitFail(reason:String) dynamic methods
		function onSubmitFail(reason:String):Void {
			trace(reason);
		}
		ga.OnSubmitFail = onSubmitFail;
		
        ga.StartPosting();
        
        
		// Call Create<Type>Event if you want to get an event and further customize it (e.g. change default fields or set optional values), after that call SendEvent(event)
		var e = ga.CreateDesignEvent("test");
		e.value = 0.1;
		e.custom_01 = "ninja";
		ga.SendEvent(e);
		// Send<Type>Event is an alias for SendEvent(Create<Type>Event)
        
    }
}