package com.grantech.matchnums;

import motion.Actuate;
import motion.easing.Bounce;
import motion.easing.Linear;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Game extends Sprite {
	private static var NUM_COLUMNS = 5;
	private static var NUM_ROWS = 6;
	private static var CELL_SIZE = 176;

	public var currentScale:Float = 1;

	private var cells:Array<Array<Cell>>;
	private var floatings:Array<Cell>;

	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, CELL_SIZE * NUM_COLUMNS, CELL_SIZE * (NUM_ROWS + 1));
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

		this.cells = new Array<Array<Cell>>();
		this.floatings = new Array<Cell>();

		this.addEventListener(MouseEvent.CLICK, this.clickHandler);
	}

	private function clickHandler(event:MouseEvent):Void {
		if (this.floatings.length > 0) {
			this.finalizeFloatings();
			return;
		}

		var column = Math.floor(this.mouseX / CELL_SIZE);
		var cell = Cell.instantiate(column, -1, Math.ceil(Math.random() * 8));
		cell.x = column * CELL_SIZE;
		this.floatings.push(cell);
		var distance = CELL_SIZE * (NUM_ROWS - cells.length);
		Actuate.tween(cell, distance * 0.005, {y: distance}).ease(Linear.easeNone).onComplete(finalizeFloatings);
		this.addChild(cell);
	}

	private function finalizeFloatings():Void {
		while (this.floatings.length > 0) {
			var f = this.floatings.pop();
			if (this.cells[f.column] == null)
				this.cells[f.column] = new Array<Cell>();

			var target = this.cells[f.column].length;
			Actuate.stop(f);
			Actuate.tween(f, 0.5, {y: CELL_SIZE * (NUM_ROWS - target)}).ease(Bounce.easeOut);
			f.row = target;
			this.cells[f.column].push(f);
		}
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
