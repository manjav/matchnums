package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.Button;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class BasePrizePopup extends ConfirmPopup implements IGamePlayPopup {
	private var adsButton:Button;
	private var skipButton:Button;

	public var prize(default, default):Int;
	public var value(default, set):Int;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = 10 * value;
		this.title = "\nDouble It?";
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.hasCloseButton = false;

		this.adsButton = new Button();
		this.adsButton.width = this.padding * 8;
		this.adsButton.height = this.padding * 2.5;
		this.adsButton.icon = new Bitmap(Assets.getBitmapData("coin"));
		this.adsButton.layoutData = AnchorLayoutData.bottomCenter(this.padding * 3, 0);
		this.adsButton.addEventListener(MouseEvent.CLICK, this.adsButton_clickHandler);
		this.content.addChild(this.adsButton);

		this.skipButton = new Button();
		this.skipButton.text = "No Thanks";
		this.skipButton.variant = OutlineTheme.VARIANT_BUTTON_LINK;
		this.skipButton.layoutData = AnchorLayoutData.bottomCenter(this.padding, 0);
		this.skipButton.addEventListener(MouseEvent.CLICK, this.skipButton_clickHandler);
		this.content.addChild(this.skipButton);
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title"))) {
			this.adsButton.text = " " + this.prize + " ";
		}
		super.validateNow();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		this.titleDisplay.layoutData = AnchorLayoutData.center(0, this.padding);
		var textFormat = this.titleDisplay.textFormat;
		textFormat.align = CENTER;
		this.titleDisplay.textFormat = textFormat;
	}

	private function adsButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	private function skipButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	override public function close():Void {
		super.close();
		Prefs.instance.increase(Prefs.COIN, this.prize);
	}
}
