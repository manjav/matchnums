package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.animations.CellInitAnimationFactory;
import openfl.events.Event;

class BigValuePopup extends BasePrizePopup {
	private var cellDisplay:Cell;
	private var cellInitAnimationFactory:CellInitAnimationFactory;

	public var isFirst(default, default):Bool;

	override public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = 10 * value;

		var _title:String;
		if (this.isFirst)
			_title = "First " + Cell.getScore(value) + " Created!";
		else
			_title = " Created again!";
		this.title = _title + "\nDouble It?";

		return value;
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title"))) {
			this.adsButton.text = " " + this.prize + " ";
			this.cellDisplay = Cell.instantiate(1, 1, this.value, 0, this.cellInitAnimationFactory);
			this.addChild(this.cellDisplay);
		}
		super.validateNow();
	}

	override private function refreshBackgroundLayout():Void {
		super.refreshBackgroundLayout();

		if (this.cellDisplay != null) {
			this.cellDisplay.x = this.actualWidth * 0.50;
			this.cellDisplay.y = this.actualHeight * 0.38;
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
