package com.dailygames.mergenums;

import com.dailygames.mergenums.animations.CellDisposeAnimationFactory;
import com.dailygames.mergenums.animations.CellInitAnimationFactory;
import com.dailygames.mergenums.animations.Reward;
import com.dailygames.mergenums.animations.Score;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Sounds;
import haxe.Timer;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Expo;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

enum GameState {
	Play;
	Pause;
}

class Game extends Sprite {
	public var currentScale:Float = 1;
	public var state:GameState;

	private var timer:Timer;
	private var columnChanged:Bool;
	private var haveRecord:Bool;
	private var numRevives:Int;
	private var numRewardCells:Int;
	private var lastColumn:Int;
	private var valueRecord:Int;
	private var nextCell:Cell;
	private var cells:CellMap;
	private var endLine:Shape;
	private var fallingEffect:Shape;
	private var cellInitAnimationFactory:CellInitAnimationFactory;
	private var cellDisposeAnimationFactory:CellDisposeAnimationFactory;

	public var scores(default, set):Int;

	function set_scores(value:Int):Int {
		if (this.scores == value)
			return value;
		Prefs.instance.set(SCORES, value);
		if (Prefs.instance.get(RECORD) < value) {
			Prefs.instance.set(RECORD, value);
			if (value > 1000 && !haveRecord) {
				GameEvent.dispatch(this, GameEvent.NEW_RECORD, value);
				haveRecord = true;
			}
		}
		this.scores = value;
		return value;
	}

	public function new() {
		super();

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

		this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		this.addEventListener(MouseEvent.CLICK, this.clickHandler);

		this.cellInitAnimationFactory = new CellInitAnimationFactory();
		this.cellDisposeAnimationFactory = new CellDisposeAnimationFactory();

		this.nextCell = Cell.instantiate(0, 0, Cell.getNextValue(), 0, this.cellInitAnimationFactory);
		this.nextCell.y = Cell.RADIUS;
		this.nextCell.alpha = 0.5;
		this.addChild(this.nextCell);

		this.init();
	}

	private function init():Void {
		this.haveRecord = false;
		this.numRevives = 0;
		this.numRewardCells = 0;
		this.valueRecord = 8;
		this.scores = 0;
		this.lastColumn = Math.floor(Math.random() * CellMap.NUM_COLUMNS);
		this.state = Play;
		this.nextCell.x = this.lastColumn * Cell.SIZE + Cell.RADIUS;
		this.spawn();
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
			Actuate.tween(this.endLine, 1.0, {alpha: 0.2}).repeat(1).onComplete(gameOver);
			return;
		}
		var reward = numRewardCells > 0 || Math.random() > 0.05 ? 0 : Math.round(this.nextCell.value * 10);
		if (reward > 0)
			numRewardCells++;
		var cell = Cell.instantiate(this.lastColumn, row, this.nextCell.value, reward, this.cellInitAnimationFactory);
		cell.x = this.lastColumn * Cell.SIZE + Cell.RADIUS;
		cell.y = Cell.RADIUS;
		this.cells.add(cell);
		this.addChild(cell);

		this.nextCell.init(0, 0, Cell.getNextValue());

		this.fallingEffect.transform.colorTransform.color = Cell.COLORS[cell.value];
		GameEvent.dispatch(this, GameEvent.SPAWN);
	}

	private function gameOver():Void {
		this.endLine.alpha = 1;
		this.endLine.transform.colorTransform.color = 0xFFFFFF;
		GameEvent.dispatch(this, GameEvent.GAME_OVER, this.numRevives);
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
		this.fallAll();
	}

	private function clickHandler(event:MouseEvent):Void {
		if (this.state != Play)
			return;
		this.lastColumn = Math.floor(this.mouseX / Cell.SIZE);
		this.columnChanged = true;
		this.fallAll();
	}

	private function fallAll():Void {
		var delay = 0.01;
		var time = 0.15;
		var numFallings = 0;
		for (c in this.cells.map) {
			if (c.state != Released)
				continue;
			if (this.columnChanged) {
				this.columnChanged = false;
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
			Sounds.play("fall");
			++numFallings;
		}

		if (numFallings > 0) {
			Actuate.tween(this.nextCell, 0.5, {x: this.lastColumn * Cell.SIZE + Cell.RADIUS}).ease(Expo.easeOut);
			this.timer = Timer.delay(this.fell, Math.round((delay + time + 0.31) * 1000));
		}
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
				this.collectReward(m);
				Actuate.tween(m, 0.1, {x: c.x, y: c.y}).ease(Expo.easeOut).onComplete(Cell.dispose, [m]);
			}

			if (matchs.length > 0) {
				this.collectReward(c);
				c.addEventListener(Event.INIT, this.cell_initHandler);
				c.init(c.column, c.row, c.value + matchs.length);
				needsRepeat = true;
			}
			// trace("match", c, matchs.length, needsRepeat);
		}
		return needsRepeat;
	}

	private function collectReward(cell:Cell):Void {
		if (cell.reward <= 0)
			return;

		Reward.instantiate(RewardType.Coin, cell.x - 4, cell.y - Cell.RADIUS, this).popup(" + " + cell.reward);
		this.numRewardCells--;
	}

	private function cell_initHandler(event:Event):Void {
		var cell = cast(event.currentTarget, Cell);
		cell.removeEventListener(Event.INIT, this.cell_initHandler);

		var score = Cell.getScore(cell.value);
		this.scores += score;

		Score.instantiate("+" + score, cell.x - 4, cell.y - Cell.RADIUS, this);

		// Show big number popup
		if (cell.value > this.valueRecord)
			GameEvent.dispatch(this, GameEvent.BIG_VALUE, this.valueRecord = cell.value);

		// More change for spawm new cells
		if (Cell.SPAWN_MAX < 7) {
			var distance = Math.ceil(1.5 * Math.sqrt(Cell.SPAWN_MAX));
			if (Cell.SPAWN_MAX < cell.value - distance)
				Cell.SPAWN_MAX = cell.value - distance;
		}
		this.fallAll();
	}

	public function reset(reviveMode:Bool = false):Void {
		this.numRevives = reviveMode ? this.numRevives + 1 : 0;
		var lineNumber = reviveMode ? CellMap.NUM_ROWS - 3 : 0;
		for (i in 0...CellMap.NUM_COLUMNS)
			for (j in lineNumber...CellMap.NUM_ROWS)
				this.removeCell(this.cells.get(i, j), true);

		this.timer = Timer.delay(reviveMode ? this.spawn : this.init, 1500);
	}

	public function removeCell(cell:Cell, accumulate:Bool = false):Void {
		if (!this.cells.exists(cell.column, cell.row))
			return;
		// cell.addEventListener(Event.CLEAR, this.cell_clearHandlre);
		if (accumulate)
			this.cells.accumulateColumn(cell.column, cell.row);
		else
			this.cells.remove(cell);
		Cell.dispose(cell, cellDisposeAnimationFactory);
	}

	public function removeCellsByValue(value:Int):Void {
		for (i in 0...CellMap.NUM_COLUMNS) {
			for (j in 0...CellMap.NUM_ROWS) {
				var c = this.cells.get(i, j);
				if (c != null && c.value == value)
					this.removeCell(c, true);
			}
		}
	}

	private function cell_clearHandlre(event:Event):Void {
		var cell = cast(event.currentTarget, Cell);
		cell.removeEventListener(Event.CLEAR, this.cell_clearHandlre);
		this.cells.remove(cell);
	}
}
