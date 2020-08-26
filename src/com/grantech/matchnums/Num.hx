package com.grantech.matchnums;

import openfl.geom.ColorTransform;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
class Num extends Sprite {
    static private final COLORS = [
		0x000000, 0xFF00FF, 0x67d144, 0x44cac9, 0x3c85d6, 0xe06149, 0xaa00FF, 0x958a81, 0xffab36, 0xffab36, 0xffab36, 0xffab36, 0xffab36
	];
	public var column:Int;
	public var row:Int;
	public var value:Int;

	public function new(column:Int, row:Int, value:Int) {
		super();

        var color = new ColorTransform();
        color.color = COLORS[value];
        var background = new Bitmap(Assets.getBitmapData("images/tile.png"));
        background.transform.colorTransform = color;
		background.smoothing = true;
		this.addChild(background);
	}
}
