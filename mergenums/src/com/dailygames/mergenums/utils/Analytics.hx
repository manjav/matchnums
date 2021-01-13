package com.dailygames.mergenums.utils;

import com.gerantech.extension.NativeTelephony;
import net.lion123dev.GameAnalytics;
import net.lion123dev.events.Events.GAPlatform;

class Analytics {
	static private var instanse:Analytics;

	static public function create():Void {
		instanse = new Analytics();
	}

	private var ga:GameAnalytics;

	public function new() {
		// Instantiate new GameAnalytics object with public and private keys
		// If the third parameter is true, a sandbox gameanalytics server will be used, so set it to false for production
		this.ga = new GameAnalytics("90d9236b42bae628fd8f9b173e733312", "c75db4a6fe4816755cd382d4138fa9f79450c6ea", false);

		var device = NativeTelephony.instance.device;
		// trace(device);
		// IMPORTANT! Platform and os version must follow Game Analytics validation rules (see #1)
		this.ga.Init(onSuccess, onFail, GAPlatform.ANDROID, device.get(VERSION_RELEASE), device.get(MODEL), device.get(MANUFACTURER));
	}

	// Now we need to initialize it with success and fail callbacks, platform, os version, device and manufacturer. Some of these parameters may be removed later and auto generated instead.
	private function onSuccess():Void {
		// Success callback is called when init request return success.
		trace("GA init succeed");
		this.ga.StartPosting();
		this.ga.OnSubmitFail = onSubmitFail;
		this.sendProgressEvent("progress-test", "ninjoon");

		// this.sendDesignEvent("design-test", 0.1, "ninjoon");
		this.ga.ForcePost();
	}

	private function onFail(error:String):Void {
		// Fail callback basically means that GameAnalytics can't work right now. Offline event caching is not yet available.
		// String parameter may contain useful information on why fail happened
		trace(error);
	}

	// If you want a callback every time sending events fail or succeed, just rebind OnSubmitSuccess() and OnSubmitFail(reason:String) dynamic methods
	private function onSubmitFail(reason:String):Void {
		trace(reason);
	}

	// Call Create<Type>Event if you want to get an event and further customize it (e.g. change default fields or set optional values), after that call SendEvent(event)
	// Send<Type>Event is an alias for SendEvent(Create<Type>Event)
	public function sendDesignEvent(part1:String, value:Null<Float> = null, custom_01:String = null, part2:String = null, custom_02:String = null):Void {
		var e = this.ga.CreateDesignEvent(part1);
		e.value = value;
		// e.custom_01 = custom_01;
		this.ga.SendEvent(e);
	}

	public function sendBusinessEvent(itemType:String, itemId:String, amount:Int, currency:String):Void {
		var e = this.ga.CreateBusinessEvent(itemType, itemId, amount, currency);
		this.ga.SendEvent(e);
	}

	public function sendProgressEvent(progressionStatus:String, progression1:String, progression2:String = null, progression3:String = null):Void {
		var e = this.ga.CreateProgressionEvent(progressionStatus, progression1, progression2, progression3);
		this.ga.SendEvent(e);
	}
}
