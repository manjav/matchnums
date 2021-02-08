package com.dailygames.mergenums.utils;

import com.dailygames.mergenums.events.GameEvent;
import openfl.events.EventDispatcher;
import com.gerantech.extension.unityads.UnityAds;

class Ads extends EventDispatcher {
	static public final instance:Ads = new Ads();

	public var initialized = false;

	public function init(onInit:Bool->String->Void = null):Void {
		UnityAds.onInit = function(succeed:Bool, message:String):Void {
			this.initialized = succeed;
			if (onInit != null)
				onInit(succeed, message);
		};
		UnityAds.init("3974257", false, false);
		UnityAds.onAdReady = function (id:String):Void {
			trace(id);
			GameEvent.dispatch(this, GameEvent.ADS_READY, id);
		}
	}

	public function has(placementId):Bool {
		return UnityAds.hasAd(placementId);
	}

	public function show(placementId:String, onFinish:Void->Void):Void {
		if (!this.initialized) {
			trace("Ads not initialized.");
			return;
		}
		UnityAds.showAd(placementId);
		UnityAds.onAdFinish = function(placementId, result) {
			if (result == "COMPLETED")
				onFinish();
			trace("onAdFinish Id => " + placementId + " result => " + result);
		}
	}
}
