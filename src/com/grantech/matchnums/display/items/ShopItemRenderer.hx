package com.grantech.matchnums.display.items;

import feathers.controls.dataRenderers.ItemRenderer;

class ShopItemRenderer extends ItemRenderer {
	static public var SIZE:Float = 72;

	public function new() {
		super();
		this.height = this.width = SIZE;
	}

}
