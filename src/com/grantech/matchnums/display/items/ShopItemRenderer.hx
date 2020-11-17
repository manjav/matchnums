package com.grantech.matchnums.display.items;

import feathers.controls.dataRenderers.ItemRenderer;
import openfl.Assets;
import openfl.display.Bitmap;

class ShopItemRenderer extends ItemRenderer {
	static public var SIZE:Float = 72;

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

}
