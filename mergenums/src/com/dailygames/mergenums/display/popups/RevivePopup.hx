package com.dailygames.mergenums.display.popups;

import motion.easing.Back;
import motion.Actuate;
import com.dailygames.mergenums.display.buttons.MessageButton;
import feathers.controls.AssetLoader;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.utils.Prefs;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class RevivePopup extends ConfirmPopup implements IGamePlayPopup {
	private var coinButton:MessageButton;
	private var adsButton:MessageButton;

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
		this.title = "Revive";

		var heartIcon = new AssetLoader();
		heartIcon.alpha = 0;
		heartIcon.width = 20.I();
		heartIcon.source = "heart";
		heartIcon.layoutData = AnchorLayoutData.center(0, -54.I());
		Actuate.tween(heartIcon, 0.5, {alpha:1, width:120.I(), height:120.I()}).delay(0.3).ease(Back.easeOut);
		this.addChild(heartIcon);

		this.coinButton = this.addButton("coin", "Revive", null, AnchorLayoutData.bottomLeft(30.F(), 18.F()), 120.F());
		this.adsButton = this.addButton("ads", "Revive", OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomRight(30.F(), 18.F()), 154.F());
		this.adsButton.text = "Free";
	}

	override private function adjustContentLayout():Void {
		this.content.width = OutlineTheme.POPUP_SIZE;
		this.content.height = OutlineTheme.POPUP_SIZE * 0.85;
		this.content.layoutData = AnchorLayoutData.center();
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("value"))) {
			this.coinButton.text = Std.string(this.cost);
		}
		super.validateNow();
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		if (button.message == "%") {
			// this.showAds();
			return;
		}

		var newValue = Prefs.instance.get(Prefs.COIN) - cost;
		Prefs.instance.set(Prefs.COIN, newValue);
		if (newValue >= 0)
			GameEvent.dispatch(this, GameEvent.REVIVE_BY_COIN);
		this.close();
	}

	override private function closeButton_clickHandler(event:MouseEvent):Void {
		super.closeButton_clickHandler(event);
		GameEvent.dispatch(this, GameEvent.REVIVE_CANCEL);
	}
}
