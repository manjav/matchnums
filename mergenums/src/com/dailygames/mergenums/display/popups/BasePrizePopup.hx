package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.display.buttons.MessageButton;
import com.dailygames.mergenums.utils.Prefs;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class BasePrizePopup extends ConfirmPopup implements IGamePlayPopup {
	private var adsButton:MessageButton;
	private var claimButton:MessageButton;

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

		this.claimButton = this.addButton("coin", "Claim", null, AnchorLayoutData.bottomLeft(28.F(), 18.F()), 120.F());
		this.adsButton = this.addButton("coin", "%", OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomRight(28.F(), 18.F()), 154.F());
	}

	override public function validateNow():Void {
		if (this.isInvalid(DATA)) {
			this.claimButton.text = Std.string(this.prize);
			this.adsButton.text = "x3=" + (this.prize * 3);
		}
		super.validateNow();
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
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
