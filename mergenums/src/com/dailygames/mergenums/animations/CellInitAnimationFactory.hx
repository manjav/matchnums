package com.dailygames.mergenums.animations;

import com.dailygames.mergenums.utils.Sounds;
import motion.Actuate;
import motion.easing.Back;

class CellInitAnimationFactory implements IAnimationFactory {
	public function new() {}

	public var volume(default, default):Float = 1.0;
	public var scale(default, default):Float = 1;
	public var time(default, default):Float = 0.3;
	public var delay(default, default):Float = 0.0;

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.rotation = 0;
		cell.scaleX = cell.scaleY = 0.2;
		var ease = Actuate.tween(cell, 0.3, {
			scaleX: scale,
			scaleY: scale
		}).ease(Back.easeOut);

		if (handler != null)
			ease.onComplete(handler);

		Sounds.play("merge", volume);
	}
}
