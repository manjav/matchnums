package com.grantech.matchnums;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
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
	static private final COLORS = [
		0x000000, 0xFF00FF, 0x67d144, 0x44cac9, 0x3c85d6, 0xe06149, 0xaa00FF, 0x958a81, 0xffab36, 0xfc5372
	];

	public var column:Int;
	public var row:Int;
	public var value:Int = -1;
	public var state:State;

	private var background:Shape;
	private var textDisplay:TextField;

	public function new(column:Int, row:Int, value:Int) {
		super();

		this.textDisplay = new TextField();
		this.textDisplay.antiAliasType = AntiAliasType.NORMAL;
		this.textDisplay.autoSize = LEFT;
		this.textDisplay.mouseEnabled = false;
		this.textDisplay.selectable = false;
		this.textDisplay.embedFonts = true;
		this.textDisplay.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", 80, 0xFFFFFF);
		this.textDisplay.filters = [new GlowFilter(0, 0.6, 4, 4)];

		this.addChild(this.textDisplay);

		this.update(column, row, value);
	}

	function createBackground():Void {
		if (this.background == null)
			this.background = new Shape();
		else
			this.background.graphics.clear();

		var sg = new Rectangle(7, 7, 2, 2);
		var path = "images/" + (this.value < 10 ? "tile" : Std.string(this.value)) + ".png";
		var bd:BitmapData = Assets.getBitmapData(path);
		if (bd == null)
			return;
		trace(path, bd);
		var cols:Array<Float> = [sg.left, sg.right, 16];
		var rows:Array<Float> = [sg.top, sg.bottom, 16];
		var left:Float = 0;
		for (i in 0...3) {
			var top:Float = 0;
			for (j in 0...3) {
				// trace(left, top, cols[i] - left, rows[j] - top);
				this.background.graphics.beginBitmapFill(bd);
				this.background.graphics.drawRect(left, top, cols[i] - left, rows[j] - top);
				this.background.graphics.endFill();
				top = rows[j];
			}
			left = cols[i];
		}
		this.background.scale9Grid = sg;
		this.background.width = SIZE;
		this.background.height = SIZE;
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
		if (this.value < 10)
		color.color = COLORS[value];
		this.background.transform.colorTransform = color;

		this.textDisplay.text = Math.pow(2, value) + "";
		this.textDisplay.x = (this.width - this.textDisplay.width) * 0.5;
		this.textDisplay.y = (this.height - this.textDisplay.height) * 0.5;

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
