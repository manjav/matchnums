package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.Game.GameState;
import com.dailygames.mergenums.display.Indicator;
import com.dailygames.mergenums.display.buttons.IconButton;
import com.dailygames.mergenums.display.overlays.BaseOverlay.ScreenType;
import com.dailygames.mergenums.display.popups.*;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Utils;
import com.gerantech.extension.alarmmanager.AlarmManager;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import haxe.Timer;
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
		this.header = createHeader(this.coinsIndicator_triggerHandler);
		this.header.layoutData = new AnchorLayoutData(null, 0, null, 0);
		this.addChild(this.header);

		this.footer = new LayoutGroup();
		this.footer.layout = new AnchorLayout();
		this.footer.layoutData = this.header.layoutData;
		this.addChild(this.footer);

		addButton("hammer-one", OutlineTheme.LIGHT_COLORS, AnchorLayoutData.middleRight(0, 40.F()));
		addButton("hammer-color", OutlineTheme.LIGHT_COLORS, AnchorLayoutData.middleRight(0, 100.F()));
		addButton("pause", OutlineTheme.LIGHT_COLORS, AnchorLayoutData.middleLeft(0, 40.F()));

		this.start();

		// Notifications process
		// trace(AlarmManager.getParams());
		var day = 3600000 * 24;
		var title = stage.application.meta["name"];
		AlarmManager.cancelLocalNotifications();
		AlarmManager.scheduleLocalNotification(title, "You are really awesome!", day, 0, false, "{\"channel\":\"Reminder\"}");
		AlarmManager.scheduleLocalNotification(title, "You are really awesome!", day * 3, 0, false, "{\"channel\":\"Reminder\"}");
		AlarmManager.scheduleLocalNotification(title, "You are really awesome!", day * 7, 0, false, "{\"channel\":\"Reminder\"}");
	}

	private function addButton(name:String, colors:Array<UInt>, layoutData:AnchorLayoutData):IconButton {
		var button = new IconButton();
		button.padding = name == "pause" ? 2.I() : -3.I();
		button.icon = name;
		button.name = name;
		button.width = 48.I();
		button.height = 48.I();
		button.layoutData = layoutData;
		button.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.footer.addChild(button);
		return button;
	}

	private function start():Void {
		BaseOverlay.closeAll();
		var starter = this.addOverlay(StartingOffer, false, false);
		starter.addEventListener(Event.CLOSE, this.starterCloseHandler);
	}

	private function starterCloseHandler(event:Event):Void {
		var starter = cast(event.target, StartingOfferOverlay);
		starter.removeEventListener(Event.CLOSE, this.starterCloseHandler);
		this.game.hasBoostBig = starter.boostBig.active;
		this.game.hasBoostNext = starter.boostNext.active;
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
		if (this.removeCellMode == "hammer-one")
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
		var button = cast(event.currentTarget, LayoutGroup);
		switch (button.name) {
			case "pause":
				this.pause();
			case "hammer-one" | "hammer-color":
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

		this.header.y = this.game.y - 80.F();
		this.footer.y = this.game.y + this.game.height;

		super.refreshBackgroundLayout();
	}

	static public function createHeader(listener:Dynamic):LayoutGroup {
		var container = new LayoutGroup();
		container.layout = new AnchorLayout();

		var scoreboard = new LayoutGroup();
		scoreboard.layout = new AnchorLayout();
		scoreboard.layoutData = AnchorLayoutData.middleRight(0, 16.F());
		container.addChild(scoreboard);

		var cupIcon = new AssetLoader();
		cupIcon.source = "cup";
		cupIcon.height = 50.F();
		cupIcon.layoutData = AnchorLayoutData.topRight(3.F(), 16.F());
		scoreboard.addChild(cupIcon);

		var shadow = new DropShadowFilter(3.F(), 75, 0, 0.92, 3.F(), 3.F(), 1, 3);

		var score = new Label();
		score.filters = [shadow];
		score.variant = OutlineTheme.VARIANT_LABEL_MEDIUM_LIGHT;
		score.text = "0";
		score.layoutData = AnchorLayoutData.topRight(-3.F(), 66.F());
		scoreboard.addChild(score);
		Prefs.instance.addEventListener(SCORES, function(event:GameEvent):Void {
			score.text = Std.string(event.data);
		});

		var record = new Label();
		record.filters = [shadow];
		record.variant = OutlineTheme.VARIANT_LABEL_LIGHT;
		record.text = Std.string(Prefs.instance.get(RECORD));
		record.layoutData = AnchorLayoutData.topRight(26.F(), 66.F());
		scoreboard.addChild(record);
		Prefs.instance.addEventListener(RECORD, function(event:GameEvent):Void {
			record.text = Std.string(event.data);
		});

		var coinsIndicator = new Indicator();
		coinsIndicator.clickable = listener != null;
		coinsIndicator.width = 140.F();
		coinsIndicator.height = 54.F();
		coinsIndicator.icon = "coin";
		coinsIndicator.format = function(value:Float):String {
			return Utils.toCurrency(value);
		}
		coinsIndicator.type = COIN;
		coinsIndicator.layoutData = AnchorLayoutData.middleLeft(0, 40.F());
		container.addChild(coinsIndicator);
		if (listener != null)
			coinsIndicator.addEventListener(TriggerEvent.TRIGGER, listener);

		return container;
	}
}
