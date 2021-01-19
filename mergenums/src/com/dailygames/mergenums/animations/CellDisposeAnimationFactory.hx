package com.dailygames.mergenums.animations;

import com.dailygames.mergenums.utils.Sounds;
import motion.Actuate;
import motion.easing.Back;

class CellDisposeAnimationFactory implements IAnimationFactory {
	public function new() {}

	public var scale(default, default):Float = 0.1;
	public var time(default, default):Float = 0.3;
	public var delay(default, default):Float = 0.0;

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.scaleX = cell.scaleY = 1;
		var ease = Actuate.tween(cell, 0.3, {
			scaleX: scale,
			scaleY: scale
		}).delay(Math.random() * 0.7).ease(Back.easeIn);

		if (handler != null)
			ease.onComplete(handler);

		Sounds.play("fall");
	}
}
