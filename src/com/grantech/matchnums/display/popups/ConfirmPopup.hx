package com.grantech.matchnums.display.popups;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Label;
import feathers.layout.AnchorLayoutData;


class ConfirmPopup extends BasePopup {

	private var titleDisplay:Label;
	public var title(default, set):String;
	public function set_title(value:String):String {
		if (this.title == value)
			return value;
		this.title = value;
		this.setInvalid(InvalidationFlag.CUSTOM("title"));
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.hasCloseButton = true;
this.title = "sdfsfs";

	}

	private function titleFactory():Void {
		if (this.title == null) {
			if (this.titleDisplay != null && this.titleDisplay.parent != null)
				this.titleDisplay.parent.removeChild(this.titleDisplay);
			return;
		}

		if (this.titleDisplay == null) {
			this.titleDisplay = new Label();
			this.titleDisplay.variant = OutlineTheme.VARIANT_LABEL_MEDIUM;
			this.titleDisplay.layoutData = AnchorLayoutData.topCenter(this.padding);
		}
		this.titleDisplay.text = this.title;
		this.content.addChild(this.titleDisplay);
	}
	
	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title")))
			this.titleFactory();
		super.validateNow();
	}
}
