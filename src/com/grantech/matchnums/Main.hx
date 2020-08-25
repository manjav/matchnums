package com.grantech.matchnums;
import openfl.display.Sprite;
import openfl.events.Event;
class Main extends Sprite {
	public function new() {
		super();

		this.initialize();
		this.construct();

		this.resize(stage.stageWidth, stage.stageHeight);
		stage.addEventListener(Event.RESIZE, this.stage_resizeHandler);
	}

	private function construct():Void {
	}

	private function initialize():Void {
	}

	private function resize(newWidth:Int, newHeight:Int):Void {
	}

	private function stage_resizeHandler(event:Event):Void {
		this.resize(stage.stageWidth, stage.stageHeight);
	}
}
