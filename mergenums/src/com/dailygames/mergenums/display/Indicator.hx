package com.dailygames.mergenums.display;

import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.themes.OutlineTheme.*;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;

class Indicator extends LayoutGroup {
	private var labelDisplay:Label;
	private var iconDisplay:AssetLoader;

	public var autoSizeText = true;

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

	public var text(default, set):String;

	private function set_text(value:String):String {
		if (this.text == value)
			return value;
		this.text = value;
		if (this.labelDisplay == null) {
			this.labelDisplay = new Label();
			this.labelDisplay.variant = OutlineTheme.VARIANT_LABEL_DARK;
			this.labelDisplay.layoutData = AnchorLayoutData.center(F(6), F(0));
			this.addChild(this.labelDisplay);
			this.labelDisplay.text = this.text;

			if (this.autoSizeText) {
				var format = this.labelDisplay.textFormat;
				var size = Math.round(OutlineTheme.FONT_SIZE * (5 / this.text.length));
				if (format == null)
					format = cast(Theme.getTheme(), OutlineTheme).getTextFormat(size, 1);
				format.size = size;
				this.labelDisplay.textFormat = format;
			}
		}
		return value;
	}

	public var icon(default, set):String;

	private function set_icon(value:String):String {
		if (this.icon == value)
			return value;

		if (this.iconDisplay != null)
			this.iconDisplay.source = this.icon;
		this.icon = value;
		return value;
	}

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();
		this.backgroundSkin = cast(Theme.getTheme(), OutlineTheme).getButtonSkin();

		this.iconDisplay = new AssetLoader();
		this.iconDisplay.layoutData = AnchorLayoutData.middleLeft(F(-2), F(8));
		this.iconDisplay.width = this.iconDisplay.height = F(56);
		if (this.icon != null)
			this.iconDisplay.source = this.icon;
		this.addChild(this.iconDisplay);

		var plus = new Label();
		plus.variant = OutlineTheme.VARIANT_LABEL_DARK_MEDIUM;
		plus.layoutData = AnchorLayoutData.middleRight(F(-2), F(20));
		plus.text = "+";
		this.addChild(plus);
	}

	public dynamic function format(value:Float):String {
		return Std.string(value);
	}

	@:access(feathers.events.TriggerEvent)
	private function prefs_changeHandler(event:GameEvent):Void {
		var newValue = cast(event.data, Float);
		if (this.type == Prefs.COIN && newValue < 0) {
			this.dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER));
			return;
		}
		this.text = this.format(newValue);
	}
}
