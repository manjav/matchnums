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
		Prefs.instance.load();
		trace(Prefs.instance.record);

		this.resize(stage.stageWidth, stage.stageHeight);
		stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}

	private function construct():Void {
		this.footer.smoothing = true;

		// this.addChild(this.background);
		this.addChild(this.footer);
		this.addChild(this.game);
	}

	private function initialize():Void {
		// this.background = new Bitmap(Assets.getBitmapData("images/background_tile.png"));
		this.footer = new Bitmap(Assets.getBitmapData("images/center_bottom.png"));
		this.game = new Game();
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
}
