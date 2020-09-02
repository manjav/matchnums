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
		cell.y = 0;
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
			if (changeColumn) {
				c.column = this.lastColumn;
				c.row = this.heights[c.column];
			}
			c.x = c.column * CELL_SIZE;
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
			c.state = Fell;
		}

		if (this.isEnd()) {
			trace("Game Over.");
			return;
		}

		// Check all matchs after falling animation
		if (this.findMatchs()) {
			this.fallAll(false);
			return;
		}

		this.spawn();
	}

	private function isEnd():Bool {
		for (h in this.heights)
			if (h > NUM_ROWS)
				return true;
		return false;
	}

	private function findMatchs():Bool {
		var needsRepeat = false;
		for (cell in this.cells) {
			if (cell.state != Fell)
				continue;
			cell.state = Fixed;

			// Relaese all cells over matchs
			var matchs = this.getMatchs(cell);
			for (m in matchs) {
				for (c in this.cells) {
					if (c.column == m.column && c.row > m.row) {
						c.state = Released;
						--c.row;
						needsRepeat = true;
					}
				}
				
				trace(this.heights[m.column], m);
				this.heights[m.column] -= 2;
				this.removeChild(m);
				Cell.dispose(m);
			}
			if (matchs.length > 0)
				cell.update(cell.column, cell.row, cell.value + matchs.length);
		}
		return needsRepeat;
	}

	private function getMatchs(cell:Cell):Array<Cell> {
		var matchs = new Array<Cell>();
		for (c in this.cells) {
			if (cell.value != c.value)
				continue;
			if (cell.column != c.column && cell.row != c.row)
				continue;
			if (cell.column == c.column - 1 || cell.column == c.column + 1 || cell.row == c.row + 1)
				matchs.push(c);
		}
		return matchs;
	}

	public function resize(newWidth:Int, newHeight:Int):Void {
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;

		this.currentScale = this.scaleX = this.scaleY = 1;

		var currentWidth = this.width;
		var currentHeight = this.height;

		var maxScaleX = maxWidth / currentWidth;
		var maxScaleY = maxHeight / currentHeight;

		if (maxScaleX < maxScaleY)
			this.currentScale = maxScaleX;
		else
			this.currentScale = maxScaleY;

		this.scaleX = this.currentScale;
		this.scaleY = this.currentScale;

		this.x = (newWidth - (currentWidth * this.currentScale)) * 0.5;
	}
}
