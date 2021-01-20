package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Utils;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.layout.AnchorLayoutData;

class NewRecordPopup extends BasePrizePopup {
	override public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = 10 * value;
		this.title = "New Record!\nDouble It?";
		this.setInvalid(DATA);
		return value;
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title"))) {
			this.adsButton.text = " " + this.prize + " ";

			var recordIcon = new AssetLoader();
			recordIcon.variant = OutlineTheme.VARIANT_BUTTON_LINK;
			recordIcon.layoutData = AnchorLayoutData.topCenter(3);
			recordIcon.source = "medal";
			this.content.addChild(recordIcon);

			var recordLabel = new Label();
			recordLabel.variant = OutlineTheme.VARIANT_LABEL_MEDIUM;
			recordLabel.layoutData = AnchorLayoutData.center(0, -48);
			recordLabel.text = Utils.toCurrency(this.value);
			this.content.addChild(recordLabel);
		}
		super.validateNow();
	}
}
