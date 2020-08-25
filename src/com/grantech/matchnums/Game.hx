package com.grantech.matchnums;

import openfl.events.MouseEvent;
import openfl.display.Sprite;

class Game extends Sprite {
	public var currentScale:Float = 1;
	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, 176 * NUM_COLUMNS, 176 * NUM_ROWS);
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

        
        this.addEventListener(MouseEvent.CLICK, this_clickHandler);
    }
    
    private function this_clickHandler(evetn:MouseEvent):void {
        
    }

	public function resize(newWidth:Int, newHeight:Int):Void {
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;

		currentScale = scaleX = scaleY = 1;

		var currentWidth = width;
		var currentHeight = height;

		var maxScaleX = maxWidth / currentWidth;
		var maxScaleY = maxHeight / currentHeight;

		if (maxScaleX < maxScaleY)
			currentScale = maxScaleX;
		else
			currentScale = maxScaleY;

		scaleX = currentScale;
		scaleY = currentScale;

		x = (newWidth - (currentWidth * currentScale)) * 0.5;
	}
}
