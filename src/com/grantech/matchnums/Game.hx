package com.grantech.matchnums;

import openfl.events.MouseEvent;
import openfl.display.Sprite;

class Game extends Sprite {
	private static var NUM_COLUMNS = 5;
	private static var NUM_ROWS = 7;

	public var currentScale:Float = 1;
	public var tiles:Array<Array<Cell>>;

	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, 176 * NUM_COLUMNS, 176 * NUM_ROWS);
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

		this.tiles = new Array<Array<Cell>>();
		for (c in 0...NUM_COLUMNS) {
			for (r in 0...NUM_ROWS) {
                var num = new Cell(c, r, Math.round(Math.random() * 8) + 1);
                num.x = c * 176;
                num.y = r * 176;
				addChild(num);
			}
        }
        
        this.addEventListener(MouseEvent.CLICK, this.clickHandler);
    }
    
	private function clickHandler(event:MouseEvent):Void {
		trace(event);
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
