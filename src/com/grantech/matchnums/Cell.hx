package com.grantech.matchnums;

import com.grantech.matchnums.utils.Utils;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.filters.GlowFilter;
import openfl.text.TextField;
import openfl.text.TextFormat;

enum CellState {
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

	static public function getScore(value:Int):Int {
		return cast(Math.pow(2, value), Int);
	}

	public var column:Int;
	public var row:Int;
	public var value:Int = -1;
	public var state:CellState;

	private var textSize:Int = 80;
	private var background:Shape;
	private var textDisplay:TextField;
	private var textFormat:TextFormat;

	public function new(column:Int, row:Int, value:Int) {
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

		this.update(column, row, value);
	}

	public function update(column:Int, row:Int, value:Int):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		this.state = Released;

		this.background.transform.colorTransform.color = COLORS[value];

		this.textFormat.size = Math.round(textSize * TEXT_SCALE[value]);
		this.textDisplay.text = Std.string(getScore(value));
		this.textDisplay.setTextFormat(this.textFormat);

		return this;
	}

	override public function toString():String {
		return "{Cell c: " + column + " r:" + row + " v:" + value + "}";
	}

	static private var pool:Array<Cell> = new Array();
	static private var i:Int = 0;

	static public function dispose(cell:Cell):Void {
		pool[i++] = cell;
		if (cell.parent != null)
			cell.parent.removeChild(cell);
	}

	static public function instantiate(column:Int, row:Int, value:Int):Cell {
		if (i > 0) {
			i--;
			return pool[i].update(column, row, value);
		}
		return new Cell(column, row, value);
	}
}
