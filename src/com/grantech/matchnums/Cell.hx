package com.grantech.matchnums;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;

enum State {
	Released;
	Falling;
	Fell;
	Fixed;
}

class Cell extends Sprite {
	static public final SIZE = 176;
	static public final BORDER = 8;
	static public final ROUND = 32;
	static private final COLORS = [
		0x000000, 0x9600ff, 0xf0145a, 0xffc91b, 0x00c419, 0x009ade, 0xce007b4, 0xff5518, 0x78e0bc, 0x3c14ae, 0xff0024, 0x41046a, 0x41046a, 0x41046a, 0x41046a
	];
	static private final TEXT_SCALE = [1, 1, 1, 1, 0.9, 0.9, 0.9, 0.8, 0.8, 0.8, 0.6, 0.6, 0.6];

	public var column:Int;
	public var row:Int;
	public var value:Int = -1;
	public var state:State;

	private var background:Shape;
	private var textDisplay:TextField;

	public function new(column:Int, row:Int, value:Int) {
		super();

		this.textDisplay = new TextField();
		this.textDisplay.antiAliasType = AntiAliasType.ADVANCED;
		this.textDisplay.mouseEnabled = false;
		this.textDisplay.selectable = false;
		this.textDisplay.embedFonts = true;
		this.textDisplay.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", 80, 0xFFFFFF, null, null, null, null, null, "center");
		this.textDisplay.filters = [new GlowFilter(0, 0.6, 4, 4)];
		this.textDisplay.width = SIZE;
		this.textDisplay.height = SIZE * 0.5;
		this.textDisplay.y = SIZE * 0.25;
		this.addChild(this.textDisplay);

		this.update(column, row, value);
	}

	function createBackground():Void {
		if (this.background == null)
			this.background = new Shape();
		else
			this.background.graphics.clear();
		this.background.graphics.beginFill(0xFFFFFF);
		this.background.graphics.drawRoundRect(BORDER, BORDER, SIZE - BORDER * 2, SIZE - BORDER * 2, ROUND, ROUND);

		// var sg = new Rectangle(7, 7, 2, 2);
		// var bd:BitmapData = Assets.getBitmapData("images/" + (this.value < 10 ? "tile" : Std.string(this.value)) + ".png");
		// if (bd == null)
		// 	return;
		// var cols:Array<Float> = [sg.left, sg.right, bd.width];
		// var rows:Array<Float> = [sg.top, sg.bottom, bd.height];
		// var left:Float = 0;
		// for (i in 0...3) {
		// 	var top:Float = 0;
		// 	for (j in 0...3) {
		// 		// trace(left, top, cols[i] - left, rows[j] - top);
		// 		this.background.graphics.beginBitmapFill(bd);
		// 		this.background.graphics.drawRect(left, top, cols[i] - left, rows[j] - top);
		// 		this.background.graphics.endFill();
		// 		top = rows[j];
		// 	}
		// 	left = cols[i];
		// }
		// this.background.scale9Grid = sg;
		// this.background.width = SIZE;
		// this.background.height = SIZE;
		this.addChildAt(this.background, 0);
	}

	public function update(column:Int, row:Int, value:Int):Cell {
		var needUpdateBG = (this.value >= 10 && value < 10) || value >= 10 || this.value == -1;
		this.column = column;
		this.row = row;
		this.value = value;
		this.state = Released;

		if (needUpdateBG)
			createBackground();

		var color = new ColorTransform();
		color.color = COLORS[value];
		this.background.transform.colorTransform = color;

		this.textDisplay.text = Math.pow(2, value) + "";

		return this;
	}

	override public function toString():String {
		return "{Cell c: " + column + " r:" + row + " v:" + value + "}";
	}

	static private var pool:Array<Cell> = new Array();
	static private var i:Int = 0;

	static public function dispose(cell:Cell):Void {
		pool[i++] = cell;
	}

	static public function instantiate(column:Int, row:Int, value:Int):Cell {
		if (i > 0) {
			i--;
			return pool[i].update(column, row, value);
		}
		return new Cell(column, row, value);
	}
}
