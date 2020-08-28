package com.grantech.matchnums;

import openfl.geom.ColorTransform;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Cell extends Sprite {
	static private final COLORS = [
		0x000000, 0xFF00FF, 0x67d144, 0x44cac9, 0x3c85d6, 0xe06149, 0xaa00FF, 0x958a81, 0xffab36, 0xffab36, 0xffab36, 0xffab36, 0xffab36
	];

	public var column:Int;
	public var row:Int;
	public var value:Int;

	private var background:Bitmap;
	private var textDisplay:TextField;

	public function new(column:Int, row:Int, value:Int) {
		super();

		this.background = new Bitmap(Assets.getBitmapData("images/tile.png"));
		this.background.smoothing = true;
		this.addChild(this.background);
		
		this.textDisplay = new TextField();
		this.textDisplay.autoSize = CENTER;
		this.textDisplay.mouseEnabled = false;
		this.textDisplay.selectable = false;
		this.textDisplay.embedFonts = true;
		this.textDisplay.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", 72, 0xFFFFFF, true);
		this.addChild(this.textDisplay);

		this.update(column, row, value);
	}

	public function update(column:Int, row:Int, value:Int):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		var color = new ColorTransform();
		color.color = COLORS[value];
		this.background.transform.colorTransform = color;
		this.textDisplay.text = Math.pow(2, value) + "";
		this.textDisplay.x = (this.width - this.textDisplay.width) * 0.5;
		this.textDisplay.y = (this.height - this.textDisplay.height) * 0.5;
		return this;
	}

		var textDisplay = new TextField();
		textDisplay.autoSize = CENTER;
		textDisplay.selectable = false;
		textDisplay.text = Math.pow(2, value) + "";
		textDisplay.embedFonts = true;
		textDisplay.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", 72, 0xFFFFFF, true);
		textDisplay.x = (this.width - textDisplay.width) * 0.5;
		textDisplay.y = (this.height - textDisplay.height) * 0.5;
		this.addChild(textDisplay);
	}
}