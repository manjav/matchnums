package com.grantech.matchnums;

import com.grantech.matchnums.utils.Utils;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Expo;
import motion.easing.Linear;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;

class Game extends Sprite {
	public var currentScale:Float = 1;

	private var timer:Timer;
	private var lastColumn:Int;
	private var maxValue:Int = 3;
	private var cells:CellMap;
	private var fallingEffect:Shape;
	private var scoreDisplay:TextField;

	public var score(default, set):Int;

	function set_score(score:Int):Int {
		if (this.score == score)
			return score;

		this.scoreDisplay.text = Std.string(score);
		return this.score = score;
	}

	public function new() {
		super();

		this.cells = new CellMap(5, 6);
		var background = new Shape();
		background.graphics.beginFill(0);
		background.graphics.drawRoundRect(-Cell.BORDER,
			-Cell.BORDER, Cell.SIZE * this.cells.width
			+ Cell.BORDER * 2,
			Cell.SIZE * (this.cells.height + 1)
			+ Cell.BORDER * 2, Cell.ROUND * 2, Cell.ROUND * 2);

		background.graphics.beginFill(0x111111);
		for (i in 0...2)
			background.graphics.drawRect(Cell.SIZE * (i * 2 + 1), -Cell.BORDER, Cell.SIZE, Cell.SIZE * (this.cells.height + 1) + Cell.BORDER * 2);
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

		this.fallingEffect = new Shape();
		this.fallingEffect.graphics.beginFill(0xFFFFFF, 0.8);
		this.fallingEffect.graphics.drawRoundRect(Cell.BORDER, -Cell.BORDER, Cell.SIZE - Cell.BORDER * 2, background.height, 0, 0);
		this.fallingEffect.alpha = 0;
		this.addChild(this.fallingEffect);

		this.scoreDisplay = Utils.createText(92, 0xededed);
		this.scoreDisplay.text = "0";
		this.scoreDisplay.width = 400;
		this.scoreDisplay.x = (this.width - this.scoreDisplay.width) * 0.5;
		this.scoreDisplay.y = -120;
		this.addChild(this.scoreDisplay);

		this.addEventListener(MouseEvent.CLICK, this.clickHandler);

		this.lastColumn = Math.floor(Math.random() * this.cells.width);
		this.spawn();
	}

	private function spawn():Void {
		// Check cell leak
		for (c in this.cells.map)
			if (c.state == Released)
				return;

		// Check end game
		var row = this.cells.length(this.lastColumn);
		if (row >= this.cells.height) {
			trace("Game Over.");
			return;
		}

		var cell = Cell.instantiate(this.lastColumn, row, Math.ceil(Math.random() * maxValue));
		cell.x = this.lastColumn * Cell.SIZE;
		cell.y = 0;
		this.cells.add(cell);
		var target = Cell.SIZE * (this.cells.height - cell.row);
		Actuate.tween(cell, target * 0.005, {y: target}).ease(Linear.easeNone).onComplete(fallAll);
		this.addChild(cell);

		this.fallingEffect.transform.colorTransform.color = Cell.COLORS[cell.value];
	}

	private function clickHandler(event:MouseEvent):Void {
		this.lastColumn = Math.floor(this.mouseX / Cell.SIZE);
		this.fallAll(true);
	}

	private function fallAll(changeColumn:Bool):Void {
		var delay = 0.1;
		var time = 0.15;
		var numFallings = 0;
		for (c in this.cells.map) {
			if (c.state != Released)
				continue;
			if (changeColumn) {
				var row = this.cells.length(this.lastColumn);
				if (c != this.cells.get(this.lastColumn, row - 1)) {
					var _y = Cell.SIZE * (this.cells.height - row);
					if (c.y > _y) {
						trace(c.y, _y);
						continue;
					} else {
						this.cells.translate(c, this.lastColumn, row);
					}
				}
				c.x = c.column * Cell.SIZE;

				this.fallingEffect.x = c.x;
				this.fallingEffect.alpha = 1;
				Actuate.tween(this.fallingEffect, 0.5, {alpha: 0.01}).ease(Expo.easeOut);
			}
			c.state = Falling;
			// Actuate.stop(c);
			var dy = Cell.SIZE * (this.cells.height - c.row);
			if (dy - c.y > 0.5)
				Actuate.tween(c, time, {y: dy}).delay(delay).ease(Linear.easeNone).onComplete(bounceCell, [c]);
			++numFallings;
		}

		if (numFallings > 0)
			this.timer = Timer.delay(this.fell, Math.round((delay + time + 0.31) * 1000));
	}

	private function bounceCell(cell:Cell):Void {
		var y = cell.y;
		cell.scaleY = 0.9;
		cell.y += cell.height * 0.1;
		Actuate.tween(cell, 0.3, {y: y, scaleY: 1}).ease(Back.easeOut);
	}

	private function fell():Void {
		this.timer.stop();

		for (c in this.cells.map)
			if (c.state == Falling)
				c.state = Fell;

		// Check all matchs after falling animation
		if (this.findMatchs()) {
			this.fallAll(false);
			return;
		}

		this.spawn();
	}

	private function findMatchs():Bool {
		var needsRepeat = false;
		for (c in this.cells.map) {
			if (c.state != Fell)
				continue;
			c.state = Fixed;

			var matchs = this.cells.getMatchs(c);
			// Relaese all cells over matchs
			for (m in matchs) {
				this.cells.accumulateColumn(m.column, m.row);
				this.removeChild(m);
				Cell.dispose(m);
			}

			if (matchs.length > 0) {
				c.update(c.column, c.row, c.value + matchs.length);
				this.score += Cell.getScore(c.value);
				if (maxValue < c.value - 2)
					maxValue = c.value - 2;
				needsRepeat = true;
			}
			// trace("match", c, matchs.length, needsRepeat);
		}
		return needsRepeat;
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
		this.y = (newHeight - (currentHeight * this.currentScale)) * 0.5;
	}
}
