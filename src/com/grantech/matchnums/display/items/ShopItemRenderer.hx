package com.grantech.matchnums.display.items;

import feathers.controls.Button;
import feathers.controls.dataRenderers.ItemRenderer;
import openfl.Assets;
import openfl.display.Bitmap;

class ShopItemRenderer extends ItemRenderer {
	/* override private function set_data(value:Dynamic):Dynamic {
		if (this.data == value)
			return value;
		if (value == null)
			return value;
		// this.tool = cast(value, Tool);
		// this.icon = new ScaledBitmap(tool.type);
		// this.selectedIcon = new ScaledBitmap(tool.type + "-blue");
		return super.set_data(value);
	}*/
	static public var SIZE:Float = 72;

	private var buttonDisplay:Button;

	public function new() {
		super();
		this.height = this.width = SIZE;
	}

	override private function update():Void {
		if (this.isInvalid(DATA)) {
			if (this.icon == null)
				this.icon = new Bitmap(Assets.getBitmapData("images/coin.png"));
			this.buttonDisplay.text = this.data.value;
		}

		super.update();
	}

	override function initialize():Void {
		super.initialize();

		this.buttonDisplay = new Button();
		this.buttonDisplay.enabled = false;
		this.buttonDisplay.width = 120;
		this.addChild(this.buttonDisplay);
	}

	override private function layoutContent():Void {
		this.buttonDisplay.x = this.actualWidth - this.paddingRight - this.buttonDisplay.width;
		this.buttonDisplay.y = (this.actualHeight - this.buttonDisplay.height) * 0.5;
		super.layoutContent();
	}
}
