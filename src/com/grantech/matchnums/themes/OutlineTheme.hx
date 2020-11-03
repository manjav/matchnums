package com.grantech.matchnums.themes;

import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.Label;
import feathers.skins.RectangleSkin;
import feathers.themes.ClassVariantTheme;
import openfl.text.TextFormat;

class OutlineTheme extends ClassVariantTheme {
	static public final FONT_SIZE = 24;
	static public final FONT_COLOR = 0xEDEDED;
	static public final FONT_NAME = "Arial Rounded MT Bold";

	public static final VARIANT_WHITE_LARG:String = "variantWhiteLarg";

	public static final VARIANT_FANCY_BUTTON:String = "custom-fancy-button";

	public function new() {
		super();

		// to provide default styles, pass null for the variant
		this.styleProvider.setStyleFunction(Label, null, setLabelStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_WHITE_LARG, setLabelWhiteLargStyles);
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);

		// custom themes may provide their own unique variants
		this.styleProvider.setStyleFunction(Button, VARIANT_FANCY_BUTTON, setFancyButtonStyles);
	}

	private function setLabelStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat();
		// if (label.disabledTextFormat == null)
		// 	label.disabledTextFormat = this.getDisabledTextFormat();
	}

	private function setLabelWhiteLargStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(FONT_SIZE * 3, 0xFFFFFF);
	}

	private function setButtonStyles(button:Button):Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.border = SolidColor(1.0, 0xff0000);
		backgroundSkin.setBorderForState(DOWN, SolidColor(1.0, 0xcc0000));
		backgroundSkin.fill = SolidColor(0xffffff);
		backgroundSkin.setFillForState(DOWN, SolidColor(0xffeeee));
		backgroundSkin.cornerRadius = 10.0;
		button.backgroundSkin = backgroundSkin;

		var format = this.getTextFormat(0xff0000);
		button.textFormat = format;

		var downFormat = this.getTextFormat(0xcc0000);
		button.setTextFormatForState(DOWN, downFormat);

		button.paddingTop = 10.0;
		button.paddingBottom = 10.0;
		button.paddingLeft = 20.0;
		button.paddingRight = 20.0;
	}

	private function setFancyButtonStyles(button:Button):Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.cornerRadius = 10.0;
		backgroundSkin.border = Gradient(2, LINEAR, [0xff9999, 0xcc0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180);
		backgroundSkin.setBorderForState(DOWN, Gradient(2, LINEAR, [0xff0000, 0xcc0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180));
		backgroundSkin.fill = Gradient(LINEAR, [0xff9999, 0xff0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180);
		backgroundSkin.setFillForState(DOWN, Gradient(LINEAR, [0xff9999, 0xff0000], [1.0, 1.0], [0, 255], 270 * Math.PI / 180));
		button.backgroundSkin = backgroundSkin;

		var format = new TextFormat(FONT_NAME, 20, 0xffeeee, true, true);
		button.textFormat = format;

		button.paddingTop = 10.0;
		button.paddingBottom = 10.0;
		button.paddingLeft = 20.0;
		button.paddingRight = 20.0;
	}

	private function getTextFormat(size:Null<Int> = null, color:Null<UInt> = null, bold:Null<Bool> = null):TextFormat {
		return new TextFormat(FONT_NAME, size == null ? FONT_SIZE : size, color == null ? FONT_COLOR : color, bold);
	}
}
