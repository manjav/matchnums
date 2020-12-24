package com.dailygames.mergenums.display;

import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.Button;
import feathers.events.TriggerEvent;

class Indicator extends Button {
	public var type(default, set):String;

	public function set_type(_type:String):String {
		if (this.type == _type)
			return _type;
		if (this.type != null)
			Prefs.instance.removeEventListener(this.type, this.prefs_changeHandler);
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

	@:access(feathers.events.TriggerEvent)
	private function prefs_changeHandler(event:GameEvent):Void {
		var newValue = cast(event.data, Float);
		if(this.type == Prefs.COIN && newValue < 0){
			this.dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER));
			return;
		}
		this.text = this.format(newValue);

	}
}
