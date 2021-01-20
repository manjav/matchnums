package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.utils.Prefs;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class BasePrizePopup extends ConfirmPopup implements IGamePlayPopup {
	private var adsButton:MessageButton;
	private var skipButton:MessageButton;

	public var prize(default, default):Int;
	public var value(default, set):Int;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = 10 * value;

		return value;
	}

	override private function initialize():Void {
		super.initialize();

		this.skipButton = addButton("coin", "Claim", OutlineTheme.VARIANT_MBUTTON_RED, AnchorLayoutData.bottomLeft(44.F(), 28.F()), 174.F());
		this.adsButton = addButton("coin", "%", OutlineTheme.VARIANT_MBUTTON_GREEN, AnchorLayoutData.bottomRight(44.F(), 28.F()), 230.F());
	}

	private function addButton(name:String, message:String, variant:String, layoutData:AnchorLayoutData, width:Float):MessageButton {
		var button = new MessageButton();
		button.name = name;
		button.width = width;
		button.height = 120.F();
		button.message = message;
		button.icon = name;
		button.variant = variant;
		button.layoutData = layoutData;
		button.addEventListener(MouseEvent.CLICK, buttons_clickHandler);
		content.addChild(button);
		return button;
	}

	override public function validateNow():Void {
		if (this.isInvalid(DATA)) {
			this.skipButton.text = Std.string(this.prize);
			this.adsButton.text = "x3 " + (this.prize * 3);
		}
		super.validateNow();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		if (this.titleDisplay == null)
			return;
		this.titleDisplay.layoutData = AnchorLayoutData.center(0, 0);
		var textFormat = this.titleDisplay.textFormat;
		textFormat.align = CENTER;
		this.titleDisplay.textFormat = textFormat;
	}

	private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		if (button.message == "%") {
			this.showAds();
			return;
		}
		this.close();
	}

	private function showAds():Void {}

	override public function close():Void {
		super.close();
		Prefs.instance.increase(Prefs.COIN, this.prize);
	}
}
