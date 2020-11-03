package com.grantech.matchnums;

import com.grantech.matchnums.animations.CellInitAnimationFactory;
import com.grantech.matchnums.utils.Prefs;
import com.grantech.matchnums.utils.Utils;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Expo;
import openfl.Assets;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

enum GameState {
	Play;
	Pause;
}

class Game extends Sprite {
	public var currentScale:Float = 1;
	public var state:GameState;

	private var fallSFX:Sound;
	private var timer:Timer;
	private var lastColumn:Int;
	private var maxValue:Int = 3;
	private var cells:CellMap;
	private var endLine:Shape;
	private var fallingEffect:Shape;
	private var recordNowDisplay:TextField;
	private var recordLastDisplay:TextField;
	private var cellInitAnimationFactory:CellInitAnimationFactory;

	public var record(default, set):Int;

	function set_record(record:Int):Int {
		if (this.record == record)
			return record;

		var recordText = Std.string(record);
		if (Prefs.instance.record < record) {
			Prefs.instance.record = record;
			Prefs.instance.save();
			this.recordLastDisplay.text = recordText;
		}
		this.recordNowDisplay.text = recordText;
		return this.record = record;
	}

	public function new() {
		super();

		this.state = Play;
		this.cells = new CellMap();
		var background = new Shape();
		background.graphics.beginFill(0);
		background.graphics.drawRoundRect(-Cell.BORDER,
			-Cell.BORDER, Cell.SIZE * CellMap.NUM_COLUMNS
			+ Cell.BORDER * 2,
			Cell.SIZE * (CellMap.NUM_ROWS + 1)
			+ Cell.BORDER * 2, Cell.ROUND * 2, Cell.ROUND * 2);

		// background.filters = [new BlurFilter(10, 10)];
		background.graphics.beginFill(0x111111);
		for (i in 0...2)
			background.graphics.drawRect(Cell.SIZE * (i * 2 + 1), -Cell.BORDER, Cell.SIZE, Cell.SIZE * (CellMap.NUM_ROWS + 1) + Cell.BORDER * 2);
		this.addChild(background);

		this.endLine = new Shape();
		this.endLine.graphics.beginFill(0xFFFFFF);
		this.endLine.graphics.drawRoundRect(-Cell.BORDER, Cell.SIZE - 2, background.width, 4, 0, 0);
		this.endLine.transform.colorTransform.color = 0x444444;
		this.addChild(this.endLine);

		this.fallingEffect = new Shape();
		this.fallingEffect.graphics.beginFill(0xFFFFFF, 0.8);
		this.fallingEffect.graphics.drawRoundRect(Cell.BORDER - Cell.RADIUS, -Cell.BORDER, Cell.SIZE - Cell.BORDER * 2, background.height, 0, 0);
		this.fallingEffect.alpha = 0;
		this.addChild(this.fallingEffect);

		this.recordNowDisplay = Utils.createText(92, 0xededed);
		this.recordNowDisplay.text = "0";
		this.recordNowDisplay.width = 400;
		this.recordNowDisplay.x = (this.width - this.recordNowDisplay.width) * 0.5;
		this.recordNowDisplay.y = -120;
		this.addChild(this.recordNowDisplay);

		this.recordLastDisplay = Utils.createText(50, 0xcacaca, "left", TextFieldAutoSize.LEFT);
		this.recordLastDisplay.text = Std.string(Prefs.instance.record);
		this.recordLastDisplay.width = 300;
		this.recordLastDisplay.x = 10;
		this.recordLastDisplay.y = -120;
		this.addChild(this.recordLastDisplay);

		this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		this.addEventListener(MouseEvent.CLICK, this.clickHandler);

		this.lastColumn = Math.floor(Math.random() * CellMap.NUM_COLUMNS);
		this.cellInitAnimationFactory = new CellInitAnimationFactory();
		this.spawn();

		this.fallSFX = Assets.getSound("sounds/fall.ogg");
	}

	private function spawn():Void {
		// Check cell leak
		for (c in this.cells.map)
			if (c.state == Released)
				return;

		// Check end game
		var row = this.cells.length(this.lastColumn);
		if (row >= CellMap.NUM_ROWS) {
			this.endLine.transform.colorTransform.color = 0xFF0000;
			this.showEndLine(0.01);
			trace("Game Over.");
			return;
		}

		var cell = Cell.instantiate(this.lastColumn, row, Math.ceil(Math.random() * this.maxValue), this.cellInitAnimationFactory);
		cell.x = this.lastColumn * Cell.SIZE + Cell.RADIUS;
		cell.y = Cell.RADIUS;
		this.cells.add(cell);
		this.addChild(cell);

		this.fallingEffect.transform.colorTransform.color = Cell.COLORS[cell.value];
	}

	private function showEndLine(alpha:Float):Void {
		Actuate.tween(this.endLine, 0.5, {alpha: alpha}).onComplete(showEndLine, [alpha == 1 ? 0.01 : 1]);
	}

	private function enterFrameHandler(event:Event):Void {
		if (this.state != Play)
			return;
		if (cells.last == null || this.cells.last.state != Released)
			return;

		// Check reach to target
		if (this.cells.last.y < this.cells.target) {
			this.cells.last.y += Cell.SPEED;
			return;
		}

		// Change cell state
		this.fallAll(false);
	}

	private function clickHandler(event:MouseEvent):Void {
		if (this.state != Play)
			return;
		this.lastColumn = Math.floor(this.mouseX / Cell.SIZE);
		this.fallAll(true);
	}

	private function fallAll(changeColumn:Bool):Void {
		var delay = 0.01;
		var time = 0.15;
		var numFallings = 0;
		for (c in this.cells.map) {
			if (c.state != Released)
				continue;
			if (changeColumn) {
				var row = this.cells.length(this.lastColumn);
				if (c != this.cells.get(this.lastColumn, row - 1)) {
					var _y = Cell.SIZE * (CellMap.NUM_ROWS - row);
					if (c.y > _y) {
						trace(c.y, _y);
						continue;
					} else {
						this.cells.translate(c, this.lastColumn, row);
					}
				}
				c.x = c.column * Cell.SIZE + Cell.RADIUS;

				this.fallingEffect.x = c.x;
				this.fallingEffect.alpha = 1;
				Actuate.tween(this.fallingEffect, 0.5, {alpha: 0.01}).ease(Expo.easeOut);
			}
			c.state = Falling;
			// Actuate.stop(c);
			var dy = Cell.SIZE * (CellMap.NUM_ROWS - c.row) + Cell.RADIUS;
			if (dy - c.y > 0.5)
				Actuate.tween(c, time, {y: dy}).delay(delay).ease(Expo.easeOut).onComplete(bounceCell, [c]);
			this.fallSFX.play();
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
		if (!this.findMatchs())
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
				Actuate.tween(m, 0.1, {x: c.x, y: c.y}).ease(Expo.easeOut).onComplete(Cell.dispose, [m]);
			}

			if (matchs.length > 0) {
				c.addEventListener(Event.INIT, this.cell_initHandler);
				c.init(c.column, c.row, c.value + matchs.length);
				needsRepeat = true;
			}
			// trace("match", c, matchs.length, needsRepeat);
		}
		return needsRepeat;
	}

	private function cell_initHandler(event:Event):Void {
		var cell = cast(event.currentTarget, Cell);
		cell.removeEventListener(Event.INIT, this.cell_initHandler);

		var score = Cell.getScore(cell.value);
		this.record += score;

		Score.instantiate("+" + score, cell.x, cell.y, this);

		// More change for spawm new cells
		if (this.maxValue < 5) {
			var distance = Math.ceil(1.5 * Math.sqrt(this.maxValue));
			if (this.maxValue < cell.value - distance)
				this.maxValue = cell.value - distance;
		}
		this.fallAll(false);
	}

	public function resize(newWidth:Int, newHeight:Int):Void {
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;

		this.currentScale = this.scaleX = this.scaleY = 1;

		var currentWidth = this.width - Cell.BORDER * 2;
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
