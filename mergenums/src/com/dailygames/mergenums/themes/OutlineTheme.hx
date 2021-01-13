package com.dailygames.mergenums.themes;

import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.Label;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.skins.RectangleSkin;
import feathers.themes.ClassVariantTheme;
import openfl.display.Stage;
import openfl.text.TextFormat;

class OutlineTheme extends ClassVariantTheme {
	static public final FONT_SIZE = 24;
	static public final FONT_COLOR = 0xEDEDED;
	static public final FONT_NAME = "Quicksand Bold";

	static public final FILL_COLOR = 0x001122;
	static public final BORDER_COLOR = 0xEDEDED;

	static public var PADDING:Int;
	static public var POPUP_SIZE:Int;
	static public var SCALE_FACTOR:Float;

	public static final VARIANT_LABEL_MEDIUM:String = "variantLabelMedium";
	public static final VARIANT_LABEL_LARG:String = "variantLabelLarg";
	public static final VARIANT_BUTTON_LINK:String = "variantButtonLink";
	public static final VARIANT_BUTTON_CLOSE:String = "variantButtonClose";
	public static final VARIANT_BUTTON_INDICATOR:String = "variantButtonIndicator";

	public function new(stage:Stage, scaleFactor:Float) {
		super();

		SCALE_FACTOR = scaleFactor;
		PADDING = Math.round((stage.stageWidth * SCALE_FACTOR) * 0.05);
		POPUP_SIZE = Math.round((stage.stageWidth * SCALE_FACTOR) * 0.9);

		this.styleProvider.setStyleFunction(Label, null, setLabelStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_MEDIUM, this.setLabelMediumStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_LARG, this.setLabelWhiteLargStyles);

		this.styleProvider.setStyleFunction(Button, null, this.setButtonStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_LINK, this.setButtonLinkStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_CLOSE, this.setButtonCloseStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_INDICATOR, this.setButtonIndicatorStyles);

		this.styleProvider.setStyleFunction(ItemRenderer, null, this.setItemRendererStyles);
	}

	private function setLabelStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat();
		// if (label.disabledTextFormat == null)
		// 	label.disabledTextFormat = this.getDisabledTextFormat();
	}

	private function setLabelMediumStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(FONT_SIZE * 2, 0xFFFFFF);
	}

	private function setLabelWhiteLargStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(FONT_SIZE * 2, 0xFFFFFF);
	}

	private function setButtonStyles(button:Button):Void {
		button.backgroundSkin = this.getButtonSkin();
		button.minWidth = button.minHeight = 40;

		button.textFormat = this.getTextFormat();
		button.setTextFormatForState(DOWN, button.textFormat);

		button.paddingTop = 0.0;
		button.paddingBottom = 0.0;
		button.paddingLeft = 0.0;
		button.paddingRight = 0.0;
	}

	private function setButtonLinkStyles(button:Button):Void {
		button.backgroundSkin = null;
		button.textFormat = this.getTextFormat(Math.round(FONT_SIZE * 0.7));
		button.setTextFormatForState(DOWN, button.textFormat);
	}

	private function setButtonCloseStyles(button:Button):Void {
		this.setButtonStyles(button);
		button.text = "x";
		button.paddingBottom = 4.0;
	}

	private function setButtonIndicatorStyles(button:Button):Void {
		var skin = new RectangleSkin();
		skin.fill = SolidColor(FILL_COLOR, 0);
		button.backgroundSkin = skin;

		button.textFormat = this.getTextFormat(Math.round(FONT_SIZE * 0.8));

		button.paddingTop = 0.0;
		button.paddingBottom = 0.0;
		button.paddingLeft = 0.0;
		button.paddingRight = 0.0;
		button.minWidth = 100;
		button.minHeight = 40;
	}

	private function setItemRendererStyles(itemRenderer:ItemRenderer):Void {
		itemRenderer.backgroundSkin = this.getButtonSkin();
		if (itemRenderer.textFormat == null)
			itemRenderer.textFormat = this.getTextFormat();

		if (itemRenderer.disabledTextFormat == null)
			itemRenderer.disabledTextFormat = itemRenderer.textFormat;

		if (itemRenderer.selectedTextFormat == null)
			itemRenderer.selectedTextFormat = itemRenderer.textFormat;

		if (itemRenderer.getTextFormatForState(ToggleButtonState.DOWN(false)) == null)
			itemRenderer.setTextFormatForState(ToggleButtonState.DOWN(false), itemRenderer.textFormat);

		itemRenderer.horizontalAlign = LEFT;
		itemRenderer.paddingTop = 0.0;
		itemRenderer.paddingBottom = 0.0;
		itemRenderer.paddingLeft = PADDING * 2;
		itemRenderer.paddingRight = PADDING * 2;
		itemRenderer.gap = PADDING;
	}

	public function getButtonSkin():RectangleSkin {
		var skin = new RectangleSkin();
		skin.fill = SolidColor(FILL_COLOR, 0);
		skin.setFillForState(DOWN, SolidColor(FILL_COLOR, 0.5));
		skin.border = SolidColor(2.0 * SCALE_FACTOR, BORDER_COLOR);
		skin.setBorderForState(DOWN, SolidColor(3.0 * SCALE_FACTOR, BORDER_COLOR));
		skin.cornerRadius = 5.0;
		return skin;
	}

	public function getTextFormat(size:UInt = 0, color:UInt = 0, bold:Bool = false):TextFormat {
		return new TextFormat(FONT_NAME, size == 0 ? FONT_SIZE : size, color == 0 ? FONT_COLOR : color, bold);
	}
}
