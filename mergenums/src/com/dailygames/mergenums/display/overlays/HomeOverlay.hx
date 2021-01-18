package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.Game.GameState;
import com.dailygames.mergenums.display.Indicator;
import com.dailygames.mergenums.display.overlays.BaseOverlay.ScreenType;
import com.dailygames.mergenums.display.popups.*;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Utils;
import feathers.controls.AssetLoader;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import haxe.Timer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.DropShadowFilter;
import openfl.geom.Rectangle;

using com.dailygames.mergenums.themes.OutlineTheme;

class HomeOverlay extends BaseOverlay {
	private var game:Game;
	private var header:LayoutGroup;
	private var footer:LayoutGroup;
	private var removeCellMode:String;
	private var scoresIndicator:Indicator;
	private var recordIndicator:Indicator;
	private var coinsIndicator:Indicator;

	override private function initialize():Void {
		super.initialize();

		this.backgroundSkin = null;
		this.layout = new AnchorLayout();

		this.game = new Game();
		this.game.addEventListener(GameEvent.GAME_OVER, this.game_eventsChangeHandler);
		this.game.addEventListener(GameEvent.BIG_VALUE, this.game_eventsChangeHandler);
		this.game.addEventListener(GameEvent.NEW_RECORD, this.game_eventsChangeHandler);
		this.game.addEventListener(MouseEvent.CLICK, this.game_clickHandler);
		this.addChild(this.game);

		// header and footert
		this.header = new LayoutGroup();
		this.header.layout = new AnchorLayout();
		this.header.layoutData = new AnchorLayoutData(null, 0, null, 0);
		this.addChild(this.header);

		this.footer = new LayoutGroup();
		this.footer.layout = new AnchorLayout();
		this.footer.layoutData = this.header.layoutData;
		this.addChild(this.footer);

		var scoreboard = new LayoutGroup();
		scoreboard.layout = new AnchorLayout();
		scoreboard.layoutData = AnchorLayoutData.middleRight(0, 24.F());
		this.header.addChild(scoreboard);

		var cupIcon = new AssetLoader();
		cupIcon.source = "cup";
		cupIcon.height = 76.F();
		cupIcon.layoutData = AnchorLayoutData.topRight(5.F(), 24.F());
		scoreboard.addChild(cupIcon);

		var shadow = new DropShadowFilter(3.F(), 75, 0, 1.F(), 5.F(), 4.F(), 1, 3);

		var score = new Label();
		score.filters = [shadow];
		score.variant = OutlineTheme.VARIANT_LABEL_MEDIUM;
		score.text = "0";
		score.layoutData = AnchorLayoutData.topRight(-5.F(), 100.F());
		scoreboard.addChild(score);
		Prefs.instance.addEventListener(SCORES, function(event:GameEvent):Void {
			score.text = Std.string(event.data);
		});

		var record = new Label();
		record.filters = [shadow];
		record.text = Std.string(Prefs.instance.get(RECORD));
		record.layoutData = AnchorLayoutData.topRight(39.F(), 100.F());
		scoreboard.addChild(record);
		Prefs.instance.addEventListener(RECORD, function(event:GameEvent):Void {
			record.text = Std.string(event.data);
		});

		this.coinsIndicator = new Indicator();
		this.coinsIndicator.width = 210.F();
		this.coinsIndicator.height = 86.F();
		this.coinsIndicator.icon = "coin-small";
		this.coinsIndicator.format = function(value:Float):String {
			return Utils.toCurrency(value);
		}
		this.coinsIndicator.type = COIN;
		this.coinsIndicator.layoutData = AnchorLayoutData.middleLeft(0, 60.F());
		this.coinsIndicator.addEventListener(TriggerEvent.TRIGGER, this.coinsIndicator_triggerHandler);
		this.header.addChild(this.coinsIndicator);

		function addButton(name:String, layoutData:AnchorLayoutData, inHeader:Bool):Button {
			var button = new Button();
			button.name = name;
			button.height = button.width = 76.F();
			button.layoutData = layoutData;
			button.icon = new Bitmap(Assets.getBitmapData("images/" + name + ".png"));
			button.addEventListener(MouseEvent.CLICK, buttons_clickHandler);
			inHeader ? this.header.addChild(button) : this.footer.addChild(button);
			return button;
		}
		addButton("dynamite", AnchorLayoutData.middleRight(0, 60.F()), false);
		addButton("dynamites", AnchorLayoutData.middleRight(0, 152.F()), false);
		addButton("pause", AnchorLayoutData.middleLeft(0, 60.F()), false);

		this.start();
	}

	private function start():Void {
		BaseOverlay.closeAll();
		var starter = this.addOverlay(StartingOffer, false, false);
		starter.addEventListener(Event.CLOSE, this.starterCloseHandler);
	}

	private function starterCloseHandler(event:Event):Void {
		var starter = cast(event.target, StartingOfferOverlay);
		starter.removeEventListener(Event.CLOSE, this.starterCloseHandler);
		this.game.hasBoostBig = starter.hasBoostBig;
		this.game.hasBoostNext = starter.hasBoostNext;
		this.game.reset();
	}

	private function addOverlay(type:ScreenType, save:Bool = true, showPauseOverlay:Bool = true):BaseOverlay {
		this.pause(showPauseOverlay);
		return BaseOverlay.create(type, this, save);
	}

	public function pause(showPauseOverlay:Bool = true):Void {
		if (this.game.state != GameState.Play)
			return;
		this.game.state = Pause;
		if (!showPauseOverlay)
			return;
		var overlay = BaseOverlay.create(Pause, this, true);
		overlay.addEventListener(Event.CLEAR, pauseOverlay_eventsHandler);
		overlay.addEventListener(Event.CANCEL, pauseOverlay_eventsHandler);
	}

	public function resume():Void {
		BaseOverlay.closeAll();
		this.game.state = Play;
	}

	public function reset():Void {
		this.removeCellMode = null;
		BaseOverlay.closeAll();
		this.game.reset();
	}

	private function game_clickHandler(event:MouseEvent):Void {
		if (this.removeCellMode == null || !Std.is(event.target, Cell))
			return;
		var cell = cast(event.target, Cell);
		if (cell.state != Fixed)
			return;
		if (this.removeCellMode == "dynamite")
			this.game.removeCell(cell.column, cell.row, true);
		else
			this.game.removeCellsByValue(cell.value);
		this.removeCellMode = null;
		Timer.delay(resumeAndFall, 1500);
	}

	@:access(com.dailygames.mergenums.Game)
	private function resumeAndFall():Void {
		this.resume();
		this.game.fallAll();
	}

	private function game_eventsChangeHandler(event:GameEvent):Void {
		var popup:BaseOverlay = null;
		switch (event.type) {
			case GameEvent.BIG_VALUE:
				popup = this.addOverlay(BigValue);
			case GameEvent.NEW_RECORD:
				popup = this.addOverlay(NewRecord);
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
				var popup = cast(this.addOverlay(RemoveCell, true, false), RemoveCellPopup);
				this.removeCellMode = popup.mode = button.name;
				popup.addEventListener(Event.CANCEL, this.pauseOverlay_eventsHandler);
				popup.contentRect = new Rectangle(this.footer.x, this.footer.y, this.footer.width, 100);
		}
	}

	private function coinsIndicator_triggerHandler(event:TriggerEvent):Void {
		this.addOverlay(Shop);
	}

	private function revivePopup_reviveHandler(event:GameEvent):Void {
		var popup = cast(event.target, ConfirmPopup);
		popup.removeEventListener(GameEvent.REVIVE_BY_COIN, this.revivePopup_reviveHandler);
		popup.removeEventListener(GameEvent.REVIVE_BY_ADS, this.revivePopup_reviveHandler);
		popup.removeEventListener(GameEvent.REVIVE_CANCEL, this.revivePopup_reviveHandler);
		if (event.type == GameEvent.REVIVE_CANCEL) {
			popup = cast(this.addOverlay(GameOver), GameOverPopup);
			popup.addEventListener(Event.SELECT, this.gameoverPopup_selectHandler);
			return;
		}

		this.game.reset(true);
	}

	private function gameoverPopup_selectHandler(event:Event):Void {
		var popup = cast(event.target, ConfirmPopup);
		popup.removeEventListener(Event.SELECT, this.gameoverPopup_selectHandler);
		this.start();
	}

	private function pauseOverlay_eventsHandler(event:Event):Void {
		var overlay = cast(event.target, BaseOverlay);
		overlay.removeEventListener(Event.CLEAR, this.pauseOverlay_eventsHandler);
		overlay.removeEventListener(Event.CANCEL, this.pauseOverlay_eventsHandler);
		switch (event.type) {
			case Event.CLEAR:
				this.start();
			case Event.CANCEL:
				this.resume();
		}
	}

	override private function refreshBackgroundLayout():Void {
		var maxWidth = this.actualWidth * 0.88;
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

		this.header.y = this.game.y - 120.F();
		this.footer.y = this.game.y + this.game.height;

		super.refreshBackgroundLayout();
	}
}
