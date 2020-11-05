package com.grantech.matchnums;

import com.grantech.matchnums.display.BaseOverlay;
import com.grantech.matchnums.display.HomeScreen;
import com.grantech.matchnums.themes.OutlineTheme;
import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Application;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;
import openfl.events.Event;

class Main extends Application {
	private var defaultFPS:Float;
	private var home:HomeScreen;

	public function new() {
		Prefs.instance.load();
		super();

		Theme.setTheme(new OutlineTheme());
		this.defaultFPS = stage.frameRate;
		#if hl
		stage.addChild(new openfl.display.FPS(50, 10, 0xFFFFFF));
		#end

		this.backgroundSkin = null;
		this.layout = new AnchorLayout();

		this.home = new HomeScreen();
		this.home.layoutData = AnchorLayoutData.fill();
		this.addChild(this.home);

		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}

	private function stage_deactivateHandler(event:Event):Void {
		this.home.pause();
		var screen = BaseOverlay.create(Pause, this, true);
		screen.addEventListener(Event.CLOSE, this.screen_closeHandler);
		stage.removeEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
		stage.addEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.frameRate = 1;
	}

	private function stage_activateHandler(event:Event):Void {
		stage.frameRate = this.defaultFPS;
		stage.removeEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}

	private function screen_closeHandler(event:Event):Void {
		cast(event.currentTarget, BaseOverlay).removeEventListener(Event.CLOSE, this.screen_closeHandler);
		this.home.resume();
	}
}
