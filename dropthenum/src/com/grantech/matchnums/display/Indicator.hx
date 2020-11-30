package com.grantech.matchnums.display;

import com.grantech.matchnums.events.GameEvent;
import com.grantech.matchnums.themes.OutlineTheme;
import com.grantech.matchnums.utils.Prefs;
import feathers.controls.Button;

class Indicator extends Button {
	public var type(default, set):String;

	public function set_type(_type:String):String {
		if (this.type == _type)
			return _type;
		this.type = _type;
		this.text = this.format(Prefs.instance.get(_type));
		Prefs.instance.addEventListener(_type, this.prefs_changeHandler);
		return _type;
	}

	public dynamic function format(value:Float):String {
		return Std.string(value);
	}

	override private function initialize():Void {
		this.variant = OutlineTheme.VARIANT_BUTTON_INDICATOR;
		super.initialize();
	}

	private function prefs_changeHandler(event:GameEvent):Void {
		this.text = this.format(event.data);
	}
}
