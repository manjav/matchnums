package com.dailygames.mergenums.animations;

import com.dailygames.mergenums.utils.Sounds;
import motion.Actuate;
import motion.easing.Back;

class CellDisposeAnimationFactory implements IAnimationFactory {
	public function new() {}

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.scaleX = cell.scaleY = 1;
		var ease = Actuate.tween(cell, 0.3, {
			scaleX: 0.1,
			scaleY: 0.1
		}).delay(Math.random() * 0.7).ease(Back.easeIn);

		if (handler != null)
			ease.onComplete(handler);

		Sounds.play("fall");
	}
}
