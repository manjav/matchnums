package com.grantech.matchnums.display.overlays;

import com.grantech.matchnums.display.overlays.BaseOverlay.ScreenType;
import com.grantech.matchnums.display.Indicator;
import com.grantech.matchnums.events.GameEvent;
import com.grantech.matchnums.utils.Prefs;
import com.grantech.matchnums.utils.Utils;
import feathers.controls.Label;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;

class HomeOverlay extends BaseOverlay {
	private var game:Game;
	private var recordDisplay:Label;
	private var recordBestDisplay:Indicator;
	private var coinsIndicator:Indicator;

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

		this.recordBestDisplay = new Indicator();
		this.recordBestDisplay.icon = new Bitmap(Assets.getBitmapData("images/medal.png"));
		this.recordBestDisplay.layoutData = AnchorLayoutData.topRight(Cell.BORDER);
		this.recordBestDisplay.format = function(value:Float):String {
			return " " + Utils.toCurrency(value);
		}
		this.recordBestDisplay.value = Prefs.instance.record;
		this.addChild(this.recordBestDisplay);

		this.coinsIndicator = new Indicator();
		this.coinsIndicator.icon = new Bitmap(Assets.getBitmapData("images/coin.png"));
		this.coinsIndicator.format = function(value:Float):String {
			return " " + Utils.toCurrency(value) + " +";
		}
		this.coinsIndicator.value = 1200;
		this.coinsIndicator.layoutData = AnchorLayoutData.topLeft(Cell.BORDER, Cell.BORDER);
		this.coinsIndicator.addEventListener(TriggerEvent.TRIGGER, this.coinsIndicator_triggerHandler);
		this.addChild(this.coinsIndicator);
	}

	private function game_recordChangeHandler(event:GameEvent):Void {
		var record = cast(event.data, Int);
		var recordText = Utils.toCurrency(record);
		if (Prefs.instance.record < record) {
			Prefs.instance.record = record;
			Prefs.instance.save();
			this.recordBestDisplay.value = record;
		}
		this.recordDisplay.text = recordText;
	}

	private function coinsIndicator_triggerHandler(event:TriggerEvent):Void {
		this.addOverlay(Shop);
	}

	private function addOverlay(type:ScreenType):Void {
		this.pause();
		var screen = BaseOverlay.create(type, this, true);
		screen.addEventListener(Event.CLOSE, screen_closeHandler);
	}

	private function screen_closeHandler(event:Event):Void {
		cast(event.currentTarget, BaseOverlay).removeEventListener(Event.CLOSE, this.screen_closeHandler);
		this.resume();
	}

	public function pause():Void {
		this.game.state = Pause;
	}

	public function resume():Void {
		this.game.state = Play;
	}

	override private function refreshBackgroundLayout():Void {
		var maxWidth = this.actualWidth * 0.90;
		var maxHeight = this.actualHeight * 0.86;

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
		this.game.x = (this.actualWidth - (currentWidth * gameScale)) * 0.5;
		this.game.y = (this.actualHeight - (currentHeight * gameScale)) * 0.5;
		super.refreshBackgroundLayout();
	}
}
