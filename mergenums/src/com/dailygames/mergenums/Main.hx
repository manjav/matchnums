package com.dailygames.mergenums;

import com.dailygames.mergenums.display.overlays.HomeOverlay;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import com.gerantech.extension.appmetrica.AppMetrica;
import extension.eightsines.EsOrientation;
import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import openfl.events.Event;

class Main extends Application {

	private var defaultFPS:Float;
	private var home:HomeOverlay;

	public function new() {
		Prefs.instance.load();
		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_PORTRAIT);
		AppMetrica.init("9fba4bd1-1851-48c9-a42d-754072c60e17");
		super();
		// com.dailygames.mergenums.utils.Analytics.create();
		Theme.setTheme(new OutlineTheme(stage, 1 / this.getScaleFactor()));
		this.defaultFPS = stage.frameRate;
		#if hl
		stage.addChild(new openfl.display.FPS(50, 10, 0xFFFFFF));
		#end

		this.backgroundSkin = null;
		this.layout = new AnchorLayout();

		this.home = new HomeOverlay();
		this.home.layoutData = AnchorLayoutData.fill();
		this.addChild(this.home);

		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}

	private function stage_deactivateHandler(event:Event):Void {
		this.home.pause();
		stage.removeEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
		stage.addEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.frameRate = 1;
	}

	private function stage_activateHandler(event:Event):Void {
		stage.frameRate = this.defaultFPS;
		stage.removeEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}
}
