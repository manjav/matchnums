package com.grantech.matchnums.animations;

import motion.Actuate;
import motion.easing.Back;
class CellInitAnimationFactory implements IAnimationFactory {
	public function new() {}

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.scaleX = cell.scaleY = 0.2;
		var ease = Actuate.tween(cell, 0.3, {
			scaleX: 1,
			scaleY: 1
		}).ease(Back.easeOut);

		if (handler != null)
			ease.onComplete(handler);

	}
}
