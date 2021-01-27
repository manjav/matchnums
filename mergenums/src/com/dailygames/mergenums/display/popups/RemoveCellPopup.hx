package com.dailygames.mergenums.display.popups;

import feathers.layout.AnchorLayoutData;
import openfl.events.Event;
import openfl.events.MouseEvent;

class RemoveCellPopup extends ConfirmPopup {
	public var mode(default, set):String;

	private function set_mode(value:String) {
		if (this.mode == value)
			return value;
		this.mode = value;
		this.title = value == "hammer-one" ? "Select Block" : "Select the Color";
		return value;
	}

	override private function initialize():Void {
		super.initialize();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		this.titleDisplay.layoutData = AnchorLayoutData.center();
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
