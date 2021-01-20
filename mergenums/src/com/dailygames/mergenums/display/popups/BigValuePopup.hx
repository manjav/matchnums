package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.animations.CellInitBigAnimationFactory;

class BigValuePopup extends BasePrizePopup {
	private var cellDisplay:Cell;
	private var cellInitAnimationFactory:CellInitBigAnimationFactory = new CellInitBigAnimationFactory();

	public var isFirst(default, default):Bool;

	override public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.prize = 10 * value;

		var _message:String = "";
		// if (this.isFirst)
		// 	_message = "First " + Cell.getScore(value) + " Created!";
		// else
		// 	_message = "You made " + Cell.getScore(value) + " again !";
		this.message = _message + "\nEarn more rewards!";
		this.setInvalid(DATA);

		return value;
	}

	override public function validateNow():Void {
		if (this.isInvalid(DATA)) {
			// Create or update cell
			if (this.cellDisplay == null)
				this.cellDisplay = Cell.instantiate(1, 1, this.value, 0, this.cellInitAnimationFactory);
			else
				this.cellDisplay.init(1, 1, this.value, 0, this.cellInitAnimationFactory);
			this.addChild(this.cellDisplay);
		}
		super.validateNow();
	}

	override private function refreshBackgroundLayout():Void {
		super.refreshBackgroundLayout();

		if (this.cellDisplay != null) {
			this.cellDisplay.x = this.actualWidth * 0.50;
			this.cellDisplay.y = this.actualHeight * 0.33;
		}
	}
}
