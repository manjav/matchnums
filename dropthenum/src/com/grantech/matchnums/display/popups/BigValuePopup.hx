package com.grantech.matchnums.display.popups;

import openfl.events.Event;
import com.grantech.matchnums.animations.CellInitAnimationFactory;

class BigValuePopup extends ConfirmPopup {
	private var cellDisplay:Cell;
	private var cellInitAnimationFactory:CellInitAnimationFactory;

	public var value(default, set):Int;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.title = Std.string(value);
		return value;
	}

	override private function initialize():Void {
        this.contentHeight = 540;
        super.initialize();
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title"))) {
			this.cellDisplay = Cell.instantiate(1, 1, this.value, this.cellInitAnimationFactory);
			this.addChild(this.cellDisplay);
		}
		super.validateNow();
	}

	override private function refreshBackgroundLayout():Void {
		super.refreshBackgroundLayout();

		if (this.cellDisplay != null) {
			this.cellDisplay.x = this.actualWidth * 0.5;
			this.cellDisplay.y = this.actualHeight * 0.3;
		}
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		if (this.cellDisplay != null) {
			this.removeChild(this.cellDisplay);
			Cell.dispose(this.cellDisplay);
		}
	}
}