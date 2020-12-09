package com.grantech.matchnums;

import com.grantech.matchnums.display.overlays.HomeOverlay;
import com.grantech.matchnums.themes.OutlineTheme;
import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import openfl.events.Event;

class Main extends Application {
	static public var SCALE_FACTOR:Float;

	private var defaultFPS:Float;
	private var home:HomeOverlay;

	public function new() {
		Prefs.instance.load();
		super();
		
		Theme.setTheme(new OutlineTheme());
		this.defaultFPS = stage.frameRate;
		SCALE_FACTOR = 1 / this.getScaleFactor();
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
