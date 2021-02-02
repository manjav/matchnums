package com.dailygames.mergenums;

import com.dailygames.mergenums.animations.IAnimationFactory;
import com.dailygames.mergenums.animations.Reward;
import com.dailygames.mergenums.utils.Utils;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.DropShadowFilter;
import openfl.text.TextField;
import openfl.text.TextFormat;

enum CellState {
	Init;
	Released;
	Falling;
	Fell;
	Fixed;
}

class Cell extends Sprite {
	static public final SPEED = 0.8;
	static public final SIZE = 176;
	static public final RADIUS = SIZE * 0.5;
	static public final BORDER = 10;
	static public final ROUND = 44;
	static public final FIRST_BIG_VALUE = 8;
	static public final COLORS = [
		0x000000, 0x9600ff, 0xf0145a, 0xffc91b, 0x00c419, 0x009ade, 0xce007b4, 0xff5518, 0x78e0bc, 0x3c14ae, 0xff0024, 0x41046a, 0x41046a, 0x41046a, 0x41046a
	];
	static private final TEXT_SCALE = [1, 1, 1, 0.85, 0.75, 0.6];
	static public var SPAWN_MAX = 3;

	static public function getScore(value:Int):Int {
		return cast(Math.pow(2, value), Int);
	}

	public var column:Int;
	public var row:Int;
	public var reward:Int;
	public var value:Int = -1;
	public var state:CellState;
	public var initAnimationFactory:IAnimationFactory;
	public var disposeAnimationFactory:IAnimationFactory;

	private var textSize:Int = 80;
	private var background:Shape;
	private var rewardDisplay:Reward;
	private var textDisplay:TextField;
	private var textFormat:TextFormat;

	public function new(column:Int, row:Int, value:Int, reward:Int, initAnimationFactory:IAnimationFactory) {
		super();

		this.background = new Shape();
		this.addChild(this.background);

		this.textDisplay = Utils.createText(this.textSize);
		this.textDisplay.filters = [new DropShadowFilter(5, 65, 0, 0.4, 1.5, 1.5, 1, 2)];
		this.textDisplay.width = SIZE;
		this.textDisplay.height = RADIUS;
		this.textDisplay.x = -RADIUS;
		this.addChild(this.textDisplay);

		this.textFormat = this.textDisplay.getTextFormat();

		this.init(column, row, value, reward, initAnimationFactory);
	}

	public function init(column:Int, row:Int, value:Int, reward:Int, initAnimationFactory:IAnimationFactory):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		this.reward = reward;
		this.initAnimationFactory = initAnimationFactory;
		this.state = Init;

		this.drawBackground(COLORS[value]);

		this.textDisplay.text = Std.string(getScore(value));
		this.textFormat.size = Math.round(textSize * TEXT_SCALE[this.textDisplay.text.length]);
		this.textDisplay.setTextFormat(this.textFormat);
		this.textDisplay.y = -RADIUS * 0.2 - this.textFormat.size * 0.5;

		if (this.rewardDisplay != null) {
			Reward.dispose(this.rewardDisplay);
			this.rewardDisplay = null;
		}

		if (this.reward > 0) {
			this.rewardDisplay = Reward.instantiate(RewardType.Coin, RADIUS, -RADIUS, this);
			this.rewardDisplay.scaleX = this.rewardDisplay.scaleY = 0.5;
		}

		if (this.initAnimationFactory == null)
			this.onInit();
		else
			this.initAnimationFactory.call([this, this.onInit]);
		return this;
	}

	private function onInit():Void {
		this.alpha = 1;
		this.scaleX = this.scaleY = this.initAnimationFactory != null ? this.initAnimationFactory.scale : 1;
		this.state = Released;
		if (this.hasEventListener(Event.INIT))
			this.dispatchEvent(new Event(Event.INIT));
	}

	private function drawBackground(color:UInt):Void {
		this.background.graphics.clear();
		this.background.graphics.beginFill(0x191C1D);
		this.background.graphics.drawRoundRect(BORDER - RADIUS - 6, BORDER - RADIUS - 6, SIZE - BORDER * 2 + 12, SIZE - BORDER * 2 + 12, ROUND + 8, ROUND + 8);
		this.background.graphics.endFill();
		this.background.graphics.beginFill(color, 0.7);
		this.background.graphics.drawRoundRect(BORDER - RADIUS, BORDER - RADIUS, SIZE - BORDER * 2, SIZE - BORDER * 2, ROUND, ROUND);
		this.background.graphics.endFill();
		this.background.graphics.beginFill(color);
		this.background.graphics.drawRoundRect(BORDER - RADIUS, BORDER - RADIUS, SIZE - BORDER * 2, Math.round(SIZE - BORDER * 3.2), ROUND, ROUND);
		this.background.graphics.endFill();
	}

	private function onDispose():Void {
		if (this.hasEventListener(Event.CLEAR))
			this.dispatchEvent(new Event(Event.CLEAR));
		Cell.dispose(this);
	}

	override public function toString():String {
		return "{Cell c: " + column + " r:" + row + " v:" + value + "}";
	}

	static public function getNextValue():Int {
		return Math.ceil(Math.random() * SPAWN_MAX);
	}

	static private var pool:Array<Cell> = new Array();
	static private var i:Int = 0;

	static public function dispose(cell:Cell, disposeAnimationFactory:IAnimationFactory = null):Void {
		if (disposeAnimationFactory != null) {
			disposeAnimationFactory.call([cell, cell.onDispose]);
			return;
		}

		if (cell.hasEventListener(Event.CLEAR))
			cell.dispatchEvent(new Event(Event.CLEAR));
		if (cell.rewardDisplay != null) {
			Reward.dispose(cell.rewardDisplay);
			cell.rewardDisplay = null;
		}
		if (cell.parent != null)
			cell.parent.removeChild(cell);
		pool[i++] = cell;
	}

	static public function instantiate(column:Int, row:Int, value:Int, reward:Int, initAnimationFactory:IAnimationFactory):Cell {
		if (i > 0) {
			i--;
			return pool[i].init(column, row, value, reward, initAnimationFactory);
		}
		return new Cell(column, row, value, reward, initAnimationFactory);
	}
}
