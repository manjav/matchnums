package com.grantech.matchnums.animations;

import motion.Actuate;
import motion.easing.Back;
import openfl.Assets;
import openfl.media.Sound;

class CellDisposeAnimationFactory implements IAnimationFactory {
	private var sound:Sound;

	public function new() {
		this.sound = Assets.getSound("sounds/fall.ogg");
	}

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		cell.scaleX = cell.scaleY = 1;
		var ease = Actuate.tween(cell, 0.3, {
			delay: Math.random(),
			scaleX: 0.1,
			scaleY: 0.1
		}).ease(Back.easeIn);

		if (handler != null)
			ease.onComplete(handler);

		if (this.sound != null)
			this.sound.play();
	}
}
