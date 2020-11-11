package com.grantech.matchnums.display;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Button;
import feathers.core.InvalidationFlag;

class Indicator extends Button {
	public var value(default, set):Float;

	public function set_value(value:Float):Float {
		if (this.value == value)
			return value;
		this.value = value;
		this.text = format(value);
		return value;
	}

	override private function initialize():Void {
		this.variant = OutlineTheme.VARIANT_BUTTON_INDICATOR;
		super.initialize();
	}
}
