package com.grantech.matchnums;

import com.grantech.matchnums.utils.Prefs;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {
	// private var background:Bitmap;
	private var footer:Bitmap;
	private var game:Game;

	public function new() {
		super();

		this.initialize();
		this.construct();

		this.resize(stage.stageWidth, stage.stageHeight);
		stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}

	private function initialize():Void {
		Prefs.instance.load();
	}

	private function construct():Void {
		// this.background = new Bitmap(Assets.getBitmapData("images/background_tile.png"));
		// this.addChild(this.background);
		this.game = new Game();
		this.addChild(this.game);
		this.footer = new Bitmap(Assets.getBitmapData("images/center_bottom.png"));
		this.footer.smoothing = true;
		this.addChild(this.footer);
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
		stage.removeEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
		stage.addEventListener(Event.ACTIVATE, this.stage_activateHandler);
	}

	private function stage_activateHandler(event:Event):Void {
		// this.game.resume();
		stage.removeEventListener(Event.ACTIVATE, this.stage_activateHandler);
		stage.addEventListener(Event.DEACTIVATE, this.stage_deactivateHandler);
	}
}
