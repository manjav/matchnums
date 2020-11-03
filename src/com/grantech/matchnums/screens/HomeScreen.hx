package com.grantech.matchnums.screens;

import com.grantech.matchnums.events.GameEvent;
import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.events.Event;

class HomeScreen extends BaseScreen {
	private var game:Game;
	private var recordDisplay:Label;
	private var recordBestDisplay:Label;

	override private function initialize():Void {
		super.initialize();

		this.autoSizeMode = STAGE;
		this.layout = new AnchorLayout();

		this.game = new Game();
		this.game.addEventListener(GameEvent.RECORD_CHANGE, this.game_recordChangeHandler);
		this.addChild(this.game);

		this.recordDisplay = new Label();
		this.recordDisplay.text = "0";
		this.recordDisplay.layoutData = AnchorLayoutData.topCenter(Cell.BORDER);
		this.addChild(this.recordDisplay);

		this.recordBestDisplay = new Label();
		this.recordBestDisplay.text = Std.string(Prefs.instance.record);
		this.recordBestDisplay.layoutData = AnchorLayoutData.topRight(Cell.BORDER, Cell.BORDER);
		this.addChild(this.recordBestDisplay);
	}

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

	private function game_recordChangeHandler(event:GameEvent):Void {
		var record = cast(event.data, Int);
		var recordText = Std.string(record);
		if (Prefs.instance.record < record) {
			Prefs.instance.record = record;
			Prefs.instance.save();
			this.recordBestDisplay.text = recordText;
		}
		this.recordDisplay.text = recordText;
	}

	public function pause():Void {
		this.game.state = Pause;
	}

	public function resume():Void {
		this.game.state = Play;
	}
}
