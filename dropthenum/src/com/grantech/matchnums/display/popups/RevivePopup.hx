package com.grantech.matchnums.display.popups;

import com.grantech.matchnums.events.GameEvent;
import com.grantech.matchnums.themes.OutlineTheme;
import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Button;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class RevivePopup extends ConfirmPopup implements IGamePlayPopup {
	private var reviveByCoinButton:Button;
	private var reviveByAdsButton:Button;

	public var cost(default, default):Int;
	public var isFirst(default, default):Bool;
	public var value(default, set):Int = -1;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.cost = 100 * (value + 1);
		this.setInvalid(InvalidationFlag.CUSTOM("value"));
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.title = "Game Over";

		this.reviveByCoinButton = new Button();
		this.reviveByCoinButton.width = OutlineTheme.PADDING * 7;
		this.reviveByCoinButton.height = OutlineTheme.PADDING * 3;
		this.reviveByCoinButton.icon = new Bitmap(Assets.getBitmapData("images/coin.png"));
		this.reviveByCoinButton.layoutData = AnchorLayoutData.bottomRight(this.padding, this.padding);
		this.reviveByCoinButton.addEventListener(MouseEvent.CLICK, this.reviveByCoinButton_clickHandler);
		this.content.addChild(this.reviveByCoinButton);

		this.reviveByAdsButton = new Button();
		this.reviveByAdsButton.width = OutlineTheme.PADDING * 7;
		this.reviveByAdsButton.height = OutlineTheme.PADDING * 3;
		this.reviveByAdsButton.text = " Free ";
		this.reviveByAdsButton.icon = new Bitmap(Assets.getBitmapData("images/video.png"));
		this.reviveByAdsButton.layoutData = AnchorLayoutData.bottomLeft(this.padding, this.padding);
		this.reviveByAdsButton.addEventListener(MouseEvent.CLICK, this.reviveByAdsButton_clickHandler);
		this.content.addChild(this.reviveByAdsButton);
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("value"))) {
			this.reviveByCoinButton.text = " " + this.cost + " ";
		}
		super.validateNow();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		// this.titleDisplay.layoutData = AnchorLayoutData.topCenter(0, padding * 3);
		var textFormat = this.titleDisplay.textFormat;
		textFormat.align = CENTER;
		this.titleDisplay.textFormat = textFormat;
	}

	// override private function refreshBackgroundLayout():Void {
	// 	super.refreshBackgroundLayout();
	// 	if (this.cellDisplay != null) {
	// 		this.cellDisplay.x = this.actualWidth * 0.5;
	// 		this.cellDisplay.y = this.actualHeight * 0.4;
	// 	}
	// }

	private function reviveByCoinButton_clickHandler(event:MouseEvent):Void {
		var newValue = Prefs.instance.get(Prefs.COIN) - cost;
		Prefs.instance.set(Prefs.COIN, newValue);
		if (newValue >= 0)
			GameEvent.dispatch(this, GameEvent.REVIVE_BY_COIN);
		this.close();
	}

	private function reviveByAdsButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	override private function closeButton_clickHandler(event:MouseEvent):Void {
		this.closeButton_clickHandler(event);
		GameEvent.dispatch(this, GameEvent.REVIVE_CANCEL);
	}
}
