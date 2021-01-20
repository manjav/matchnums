package com.dailygames.mergenums.animations;

import motion.Actuate;
import motion.easing.Back;

class CellInitBigAnimationFactory implements IAnimationFactory {
	public function new() {}

	public var scale(default, default):Float = 0.5;
	public var time(default, default):Float = 0.3;
	public var delay(default, default):Float = 0.3;

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.rotation = 0;
		cell.scaleX = cell.scaleY = 0;
		var ease = Actuate.tween(cell, this.time, {
			rotation: -7,
			scaleX: scale,
			scaleY: scale
		}).delay(this.delay).ease(Back.easeOut);

		if (handler != null)
			ease.onComplete(handler);

		// Sounds.play("merge");
	}
}
