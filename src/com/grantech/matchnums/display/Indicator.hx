package com.grantech.matchnums.display;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Button;

class Indicator extends Button {
	public var value(default, set):Float;

	public function set_value(value:Float):Float {
		if (this.value == value)
			return value;
		this.value = value;
		this.text = format(value);
		return value;
	}

	public dynamic function format(value:Float):String {
		return Std.string(value);
	}

	override private function initialize():Void {
		this.variant = OutlineTheme.VARIANT_BUTTON_INDICATOR;
		super.initialize();
	}
}
