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

	static public final FILL_COLOR = 0x002435;
	static public final BORDER_COLOR = 0xEDEDED;


	public static final VARIANT_WHITE_LARG:String = "variantWhiteLarg";
	public static final VARIANT_RECORDS:String = "variantRecords";

	public static final VARIANT_CLOSE_BUTTON:String = "variantClosebutton";
	

	public function new() {
		super();

		// to provide default styles, pass null for the variant
		this.styleProvider.setStyleFunction(Label, null, setLabelStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_WHITE_LARG, setLabelWhiteLargStyles);
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);

		// custom themes may provide their own unique variants
		this.styleProvider.setStyleFunction(Button, VARIANT_CLOSE_BUTTON, setCloseButtonStyles);
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
		var skin = new RectangleSkin();
		skin.fill = SolidColor(FILL_COLOR, 0);
		skin.setFillForState(DOWN, SolidColor(FILL_COLOR, 0.5));
		skin.border = SolidColor(2.0, BORDER_COLOR);
		skin.setBorderForState(DOWN, SolidColor(3.0, BORDER_COLOR));
		skin.cornerRadius = 5.0;
		button.backgroundSkin = skin;
		button.minWidth = button.minHeight = 40;

		var format = this.getTextFormat();
		button.textFormat = format;

		var downFormat = this.getTextFormat();
		button.setTextFormatForState(DOWN, downFormat);

		button.paddingTop = 0.0;
		button.paddingBottom = 0.0;
		button.paddingLeft = 0.0;
		button.paddingRight = 0.0;
	}

	private function setCloseButtonStyles(button:Button):Void {
		this.setButtonStyles(button);
		button.text = "x";
		button.paddingBottom = 4.0;
	}

	private function getTextFormat(size:Null<Int> = null, color:Null<UInt> = null, bold:Null<Bool> = null):TextFormat {
		return new TextFormat(FONT_NAME, size == null ? FONT_SIZE : size, color == null ? FONT_COLOR : color, bold);
	}
}
