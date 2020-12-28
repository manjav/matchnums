package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.display.Indicator;
import com.dailygames.mergenums.display.overlays.BaseOverlay.ScreenType;
import com.dailygames.mergenums.display.popups.*;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Utils;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class HomeOverlay extends BaseOverlay {
	private var game:Game;
	private var header:LayoutGroup;
	private var footer:LayoutGroup;
	private var scoresIndicator:Indicator;
	private var recordIndicator:Indicator;
	private var coinsIndicator:Indicator;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.game = new Game();
		this.game.addEventListener(GameEvent.GAME_OVER, this.game_eventsChangeHandler);
		this.game.addEventListener(GameEvent.BIG_VALUE, this.game_eventsChangeHandler);
		this.game.addEventListener(GameEvent.NEW_RECORD, this.game_eventsChangeHandler);
		this.game.addEventListener(MouseEvent.CLICK, this.game_clickHandler);
		this.addChild(this.game);

		this.scoresIndicator = new Indicator();
		this.scoresIndicator.layoutData = AnchorLayoutData.topCenter(Cell.BORDER);
		this.scoresIndicator.type = SCORES;
		this.addChild(this.scoresIndicator);

		this.recordIndicator = new Indicator();
		this.recordIndicator.icon = new Bitmap(Assets.getBitmapData("images/medal-small.png"));
		this.recordIndicator.layoutData = AnchorLayoutData.topRight(Cell.BORDER);
		this.recordIndicator.format = function(value:Float):String {
			return " " + Utils.toCurrency(value);
		}
		this.recordIndicator.type = RECORD;
		this.addChild(this.recordIndicator);

		this.coinsIndicator = new Indicator();
		this.coinsIndicator.icon = new Bitmap(Assets.getBitmapData("images/coin-small.png"));
		this.coinsIndicator.format = function(value:Float):String {
			return " " + Utils.toCurrency(value) + " +";
		}
		this.coinsIndicator.type = COIN;
		this.coinsIndicator.layoutData = AnchorLayoutData.topLeft(Cell.BORDER, Cell.BORDER);
		this.coinsIndicator.addEventListener(TriggerEvent.TRIGGER, this.coinsIndicator_triggerHandler);
		this.addChild(this.coinsIndicator);

		// Buttons
		this.header = new LayoutGroup();
		this.header.height = 64;
		this.header.layout = new AnchorLayout();
		this.addChild(this.header);

		this.footer = new LayoutGroup();
		this.footer.height = 64;
		this.footer.layout = new AnchorLayout();
		this.addChild(this.footer);

		function addButton(name:String, layoutData:AnchorLayoutData, inHeader:Bool):Button {
			var button = new Button();
			button.name = name;
			button.height = button.width = this.header.height - 8;
			button.layoutData = layoutData;
			button.icon = new Bitmap(Assets.getBitmapData("images/" + name + ".png"));
			button.addEventListener(MouseEvent.CLICK, buttons_clickHandler);
			inHeader ? this.header.addChild(button) : this.footer.addChild(button);
			return button;
		}
		addButton("dynamite", AnchorLayoutData.middleRight(), false);
		addButton("dynamites", AnchorLayoutData.middleRight(0, header.height), false);
		addButton("pause", AnchorLayoutData.middleLeft(), false);
	}

	private function addOverlay(type:ScreenType, save:Bool = true):BaseOverlay {
		this.pause();
		return BaseOverlay.create(type, this, save);
	}

	public function pause():Void {
		var overlay = BaseOverlay.create(Pause, this, true);
		overlay.addEventListener(Event.CLEAR, pauseOverlay_eventsHandler);
		overlay.addEventListener(Event.CANCEL, pauseOverlay_eventsHandler);
		this.game.state = Pause;
	}

	public function resume():Void {
		this.game.state = Play;
	}

	private function game_clickHandler(event:MouseEvent):Void {
		trace(event.target);
	}

	private function game_eventsChangeHandler(event:GameEvent):Void {
		var popup:BaseOverlay = null;
		switch (event.type) {
			case GameEvent.BIG_VALUE:
				popup = this.addOverlay(BigValue, false);
			case GameEvent.NEW_RECORD:
				popup = this.addOverlay(NewRecord, false);
			case GameEvent.GAME_OVER:
				popup = this.addOverlay(Revive);
				popup.addEventListener(GameEvent.REVIVE_BY_COIN, this.revivePopup_reviveHandler);
				popup.addEventListener(GameEvent.REVIVE_BY_ADS, this.revivePopup_reviveHandler);
				popup.addEventListener(GameEvent.REVIVE_CANCEL, this.revivePopup_reviveHandler);
		}
		cast(popup, IGamePlayPopup).value = cast(event.data, Int);
	}

	private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		switch (button.name) {
			case "pause":
				this.pause();
			case "dynamite" | "dynamites":
				this.pause(false);
				var popup = new RemoveCellPopup();
				popup.addEventListener(Event.CANCEL, this.pauseOverlay_eventsHandler);
				popup.contentRect = new Rectangle(this.footer.x, this.footer.y, this.footer.width, 100);
				this.addChild(popup);
		}
	}

	private function coinsIndicator_triggerHandler(event:TriggerEvent):Void {
		this.addOverlay(Shop);
	}

	private function revivePopup_reviveHandler(event:GameEvent):Void {
		var popup = cast(event.target, RevivePopup);
		popup.removeEventListener(GameEvent.REVIVE_BY_COIN, this.revivePopup_reviveHandler);
		popup.removeEventListener(GameEvent.REVIVE_BY_ADS, this.revivePopup_reviveHandler);
		popup.removeEventListener(GameEvent.REVIVE_CANCEL, this.revivePopup_reviveHandler);
		if (event.type == GameEvent.REVIVE_CANCEL)
			this.addOverlay(GameOver);
		else
			this.game.reset(true);
	}

	private function pauseOverlay_eventsHandler(event:Event):Void {
		var overlay = cast(event.target, BaseOverlay);
		overlay.removeEventListener(Event.CLEAR, this.pauseOverlay_eventsHandler);
		overlay.removeEventListener(Event.CANCEL, this.pauseOverlay_eventsHandler);
		switch (event.type) {
			case Event.CLEAR:
				this.game.reset();
			case Event.CANCEL:
				this.resume();
		}
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
		this.game.y = (this.actualHeight - (currentHeight * gameScale)) * 0.45;

		this.footer.x = this.header.x = this.game.x;
		this.footer.width = this.header.width = this.game.width - 40;
		this.header.y = this.game.y - this.header.height - 4;
		this.footer.y = this.game.y + this.game.height;

		super.refreshBackgroundLayout();
	}
}
