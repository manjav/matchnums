package com.grantech.matchnums;

import haxe.Timer;
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

	private var timer:Timer;
	private var lastColumn:Int;
	private var cells:Array<Cell>;
	private var heights:Array<Int>;

	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, CELL_SIZE * NUM_COLUMNS, CELL_SIZE * (NUM_ROWS + 1));
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

		this.cells = new Array<Cell>();
		this.heights = new Array<Int>();
		for (i in 0...NUM_COLUMNS)
			this.heights[i] = 0;

		this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		this.lastColumn = Math.floor(Math.random() * NUM_COLUMNS);
		this.spawn();
	}

	private function spawn():Void {
		var cell = Cell.instantiate(this.lastColumn, this.heights[this.lastColumn], Math.ceil(Math.random() * 8));
		cell.x = this.lastColumn * CELL_SIZE;
		this.cells.push(cell);
		var target = CELL_SIZE * (NUM_ROWS - cell.row);
		Actuate.tween(cell, target * 0.005, {y: target}).ease(Linear.easeNone).onComplete(fallAll);
		this.addChild(cell);
	}

	private function clickHandler(event:MouseEvent):Void {
		this.lastColumn = Math.floor(this.mouseX / CELL_SIZE);
		this.fallAll(true);
	}

	private function fallAll(changeColumn:Bool):Void {
		var delay = 0.2;
		var time = 0.5;
		var numFallings = 0;
		for (c in this.cells) {
			if (c.state != Released)
				continue;
			if (changeColumn)
				c.column = this.lastColumn;
			c.row = this.heights[c.column];
			c.x = this.lastColumn * CELL_SIZE;
			Actuate.stop(c);
			Actuate.tween(c, time, {y: CELL_SIZE * (NUM_ROWS - c.row)}).delay(delay).ease(Bounce.easeOut);
			c.state = Falling;
			++numFallings;
		}

		if (numFallings > 0)
			this.timer = Timer.delay(this.fell, Math.round((delay + time + 0.01) * 1000));
	}
	
	private function fell():Void {
		this.timer.stop();
		
		for (c in this.cells) {
			if (c.state != Falling)
				continue;
			++this.heights[c.column];
			c.state = Fixed;
		}
		
		if (this.isEnd()) {
			trace("Game Over.");
			return;
		}
		
		// Check all matchs after falling animation
		if (this.findMatchs())
			return;

		this.spawn();
	}

	private function isEnd():Bool {
		for (h in this.heights)
			if (h > NUM_ROWS)
				return true;
		return false;
	}

	private function findMatchs():Bool {
		return false;
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
