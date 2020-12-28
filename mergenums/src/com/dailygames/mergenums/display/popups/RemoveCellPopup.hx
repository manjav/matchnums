package com.dailygames.mergenums.display.popups;

import openfl.events.Event;
import openfl.events.MouseEvent;
import feathers.layout.AnchorLayoutData;

class RemoveCellPopup extends ConfirmPopup {
	override private function initialize():Void {
		this.title = "Select Color";
		super.initialize();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		this.titleDisplay.layoutData = AnchorLayoutData.center();
		// var textFormat = this.titleDisplay.textFormat;
		// textFormat.align = CENTER;
		// this.titleDisplay.textFormat = textFormat;
	}

	override public function closeButtonFactory():Void {
		super.closeButtonFactory();
		if (this.hasCloseButton)
			this.closeButton.layoutData = AnchorLayoutData.middleRight(0, this.padding);
	}

	override private function overlayFactory():Void {}

	override private function closeButton_clickHandler(event:MouseEvent):Void {
        super.closeButton_clickHandler(event);
        this.dispatchEvent(new Event(Event.CANCEL));
	}
}
