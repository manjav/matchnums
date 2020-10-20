package com.grantech.matchnums.animations;

import motion.Actuate;
import motion.easing.Back;
import openfl.Assets;
import openfl.media.Sound;

class CellInitAnimationFactory implements IAnimationFactory {
	private var mergeSFX:Sound;

	public function new() {
		this.mergeSFX = Assets.getSound("sounds/merge.ogg");
	}

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

		if (mergeSFX != null)
			this.mergeSFX.play();
	}
}
