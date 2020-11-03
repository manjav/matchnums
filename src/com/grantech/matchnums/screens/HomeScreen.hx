package com.grantech.matchnums.screens;

import feathers.layout.AnchorLayout;
import openfl.events.Event;

class HomeScreen extends BaseScreen {
	private var game:Game;

	override private function initialize():Void {
		super.initialize();

		this.autoSizeMode = STAGE;
		this.layout = new AnchorLayout();

		this.game = new Game();
		this.addChild(this.game);

	override private function layoutGroup_stage_resizeHandler(event:Event):Void {
		super.layoutGroup_stage_resizeHandler(event);

		var maxWidth = stage.stageWidth * 0.90;
		var maxHeight = stage.stageHeight * 0.86;


		var currentWidth = CellMap.NUM_COLUMNS * Cell.SIZE;
		var currentHeight = (CellMap.NUM_ROWS + 1) * Cell.SIZE;

		var maxScaleX = maxWidth / currentWidth;
		var maxScaleY = maxHeight / currentHeight;

		var gameScale = 1.0;
		if (maxScaleX < maxScaleY)
			gameScale = maxScaleX;
		else
			gameScale = maxScaleY;

		this.game.scaleY = this.game.scaleX = gameScale;
		this.game.x = (stage.stageWidth - (currentWidth * gameScale)) * 0.5;
		this.game.y = (stage.stageHeight - (currentHeight * gameScale)) * 0.5;
	}

	public function pause():Void {
		this.game.state = Pause;
	}

	public function resume():Void {
		this.game.state = Play;
	}
}
