package com.dailygames.mergenums;

import com.dailygames.mergenums.animations.IAnimationFactory;
import com.dailygames.mergenums.animations.Reward;
import com.dailygames.mergenums.utils.Utils;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.GlowFilter;
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
	static public final BORDER = 8;
	static public final ROUND = 32;
	static public final COLORS = [
		0x000000, 0x9600ff, 0xf0145a, 0xffc91b, 0x00c419, 0x009ade, 0xce007b4, 0xff5518, 0x78e0bc, 0x3c14ae, 0xff0024, 0x41046a, 0x41046a, 0x41046a, 0x41046a
	];
	static private final TEXT_SCALE = [1, 1, 1, 1, 0.9, 0.9, 0.9, 0.8, 0.8, 0.8, 0.6, 0.6, 0.6, 0.5, 0.5, 0.5, 0.5];
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

	public function new(column:Int, row:Int, value:Int, reward:Int = 0, ?initAnimationFactory:IAnimationFactory) {
		super();

		this.background = new Shape();
		this.background.graphics.beginFill(0xFFFFFF);
		this.background.graphics.drawRoundRect(BORDER - RADIUS, BORDER - RADIUS, SIZE - BORDER * 2, SIZE - BORDER * 2, ROUND, ROUND);
		this.addChild(this.background);

		this.textDisplay = Utils.createText(80);
		this.textDisplay.filters = [new GlowFilter(0, 0.6, 4, 4)];
		this.textDisplay.width = SIZE;
		this.textDisplay.height = RADIUS;
		this.textDisplay.x = -RADIUS;
		this.textDisplay.y = -RADIUS * 0.5;
		this.addChild(this.textDisplay);

		this.textFormat = this.textDisplay.getTextFormat();
		this.initAnimationFactory = initAnimationFactory;

		this.init(column, row, value, reward);
	}

	public function init(column:Int, row:Int, value:Int, reward:Int = 0):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		this.reward = reward;
		this.state = Init;

		this.background.transform.colorTransform.color = COLORS[value];

		this.textFormat.size = Math.round(textSize * TEXT_SCALE[value]);
		this.textDisplay.text = Std.string(getScore(value));
		this.textDisplay.setTextFormat(this.textFormat);

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
		this.alpha = this.scaleX = this.scaleY = 1;
		this.state = Released;
		if (this.hasEventListener(Event.INIT))
			this.dispatchEvent(new Event(Event.INIT));
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
			return pool[i].init(column, row, value, reward);
		}
		return new Cell(column, row, value, reward, initAnimationFactory);
	}
}