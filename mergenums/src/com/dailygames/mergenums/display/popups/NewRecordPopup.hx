package com.dailygames.mergenums.display.popups;

import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.layout.AnchorLayoutData;

using com.dailygames.mergenums.themes.OutlineTheme;

class NewRecordPopup extends BasePrizePopup {
	static public final MIN_RECORD = 2000;

	override public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = Math.floor(value / MIN_RECORD) * 100;
		this.message = Std.string(this.value);
		this.setInvalid(DATA);
		return value;
	}

	override private function messageFactory():Void {
		this.messageDisplay = this.labelFactory(this.messageDisplay, this.message, AnchorLayoutData.center(0, 24.I()));
		if (this.messageDisplay == null)
			return;
		var textFormat = this.messageDisplay.textFormat;
		textFormat.size = 50.I();
		textFormat.align = CENTER;
		this.messageDisplay.textFormat = textFormat;
	}

	override private function adjustContentLayout():Void {
		this.content.width = OutlineTheme.POPUP_SIZE;
		this.content.height = OutlineTheme.POPUP_SIZE * 1.2;
		this.content.layoutData = AnchorLayoutData.center();
	}

	override private function initialize():Void {
		super.initialize();

		var recordIcon = new AssetLoader();
		recordIcon.layoutData = AnchorLayoutData.topCenter(32.I());
		recordIcon.height = 116.I();
		recordIcon.source = "newrecord";
		this.content.addChild(recordIcon);

		var newrecordLabel = new Label();
		newrecordLabel.variant = OutlineTheme.VARIANT_LABEL_MEDIUM_LIGHT;
		newrecordLabel.layoutData = AnchorLayoutData.center(0, -8.I());
		newrecordLabel.text = "New Record";
		this.content.addChild(newrecordLabel);

		var textFormat = newrecordLabel.textFormat;
		textFormat.color = 0xffbf08;
		textFormat.size = 16.I();
		textFormat.align = CENTER;
		newrecordLabel.textFormat = textFormat;
	}

	override public function open():Void {
		this.adsButton.text = " " + this.prize + " ";
	}
}
