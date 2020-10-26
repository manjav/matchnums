package com.grantech.matchnums.themes;

import feathers.controls.Label;
import feathers.skins.RectangleSkin;
import openfl.text.TextFormat;

class OutlineTheme extends ClassVariantTheme {
	static public final FONT_SIZE = 14;
	static public final FONT_NAME = "Arial Rounded MT Bold";
	public static final VARIANT_FANCY_BUTTON:String = "custom-fancy-button";

	public function new() {
		super();

		// to provide default styles, pass null for the variant
		this.styleProvider.setStyleFunction(Label, null, setLabelStyles);
	}

	private function setLabelStyles(label:Label):Void {
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(0);
		// if (label.disabledTextFormat == null)
		// 	label.disabledTextFormat = this.getDisabledTextFormat();
	}


	private function getTextFormat(color:UInt):TextFormat {
		return new TextFormat(FONT_NAME, FONT_SIZE, color);
	}
}
