package com.grantech.matchnums;

import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Application;
import feathers.controls.Label;
import feathers.layout.VerticalLayout;
import feathers.style.Theme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;

class Main extends Application {
	// private var background:Bitmap;
	private var footer:Bitmap;
	private var game:Game;

	public function new() {
		Prefs.instance.load();
		super();
		
		Theme.setTheme(new OutlineTheme());
		#if hl
		stage.addChild(new openfl.display.FPS(50, 10, 0xFFFFFF));
		#end

		this.backgroundSkin = null;
		this.layout = new VerticalLayout();

		var description = new Label();
		description.text = "The buttons are styled by the custom theme, but everything else uses the default theme.";
		this.addChild(description);

		// this.background = new Bitmap(Assets.getBitmapData("images/background_tile.png"));
		// this.addChild(this.background);

		this.game = new Game();
		this.addChild(this.game);

		this.footer = new Bitmap(Assets.getBitmapData("images/center_bottom.png"));
		this.footer.smoothing = true;
		this.addChild(this.footer);

		this.resize(stage.stageWidth, stage.stageHeight);
		stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}

	private function resize(newWidth:Int, newHeight:Int):Void {
		// this.background.width = newWidth;
		// this.background.height = newHeight;

		this.game.resize(newWidth, newHeight);

		this.footer.scaleX = this.game.currentScale;
		this.footer.scaleY = this.game.currentScale;
		this.footer.x = (newWidth - this.footer.width) * 0.5;
		this.footer.y = newHeight - this.footer.height;
	}

	private function stage_resizeHandler(event:Event):Void {
		this.resize(stage.stageWidth, stage.stageHeight);
	}

	private function stage_deactivateHandler(event:Event):Void {
		stage.frameRate = 0;
		this.game.pause();
		stage.removeEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
		stage.addEventListener(Event.ACTIVATE, this.stage_activateHandler);
	}

	private function stage_activateHandler(event:Event):Void {
		stage.frameRate = 40;
		stage.removeEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}
}
