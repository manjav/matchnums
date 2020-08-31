package com.grantech.matchnums;

import openfl.events.MouseEvent;
import openfl.display.Sprite;

class Game extends Sprite {
	private static var NUM_COLUMNS = 5;
	private static var NUM_ROWS = 7;
	private static var CELL_SIZE = 176;

	public var currentScale:Float = 1;

	private var cells:Array<Array<Cell>>;
	private var floatings:Array<Cell>;

	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, CELL_SIZE * NUM_COLUMNS, CELL_SIZE * NUM_ROWS);
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

		this.cells = new Array<Array<Cell>>();
		this.floatings = new Array<Cell>();
        
        this.addEventListener(MouseEvent.CLICK, this.clickHandler);
    }
    
	private function clickHandler(event:MouseEvent):Void {
		if (this.floatings.length > 0) {
			return;
		}

		var column = Math.floor(Math.random() * NUM_COLUMNS);
		var cell = Cell.instantiate(Math.floor(Math.random() * NUM_COLUMNS), -1, column);
		cell.x = column * CELL_SIZE;
		this.floatings.push(cell);
		var distance = CELL_SIZE * (NUM_ROWS - cells.length);
		Actuate.tween(cell, distance * 0.3, {y: distance, ease: Linear.easeNone});
		this.addChild(cell);
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
