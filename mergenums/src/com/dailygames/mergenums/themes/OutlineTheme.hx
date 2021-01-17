package com.dailygames.mergenums.themes;

import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.display.Scale9Bitmap;
import feathers.themes.ClassVariantTheme;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

class OutlineTheme extends ClassVariantTheme {
	static public final FONT_COLOR = 0xEDEDED;
	static public final FONT_NAME = "Quicksand Bold";

	static public final FILL_COLOR = 0x001122;
	static public final BORDER_COLOR = 0xEDEDED;

	static public var PADDING:Int;
	static public var FONT_SIZE:Int;
	static public var POPUP_SIZE:Int;
	static public var SCALE_FACTOR:Float;

	public static final VARIANT_LABEL_DARK:String = "variantLabelDark";
	public static final VARIANT_LABEL_MEDIUM:String = "variantLabelMedium";
	public static final VARIANT_LABEL_LARG:String = "variantLabelLarg";
	public static final VARIANT_BUTTON_LINK:String = "variantButtonLink";
	public static final VARIANT_BUTTON_CLOSE:String = "variantButtonClose";

	public static final SCALEGRID_BUTTON:Rectangle = new Rectangle(21, 24, 1, 1);

	public static function F(value:Float):Float {
		return value * SCALE_FACTOR;
	}

	public static function I(value:Float):Int {
		return Math.round(value * SCALE_FACTOR);
	}

	public function new(stage:Stage, scaleFactor:Float) {
		super();
		#if android
		SCALE_FACTOR = stage.stageWidth / 1080;
		#else
		SCALE_FACTOR = 0.9;
		#end
		POPUP_SIZE = I(960);
		PADDING = I(54);
		FONT_SIZE = I(30);
		SCALEGRID_BUTTON.x = I(SCALEGRID_BUTTON.x);
		SCALEGRID_BUTTON.y = I(SCALEGRID_BUTTON.y);
		SCALEGRID_BUTTON.width = I(SCALEGRID_BUTTON.width);
		SCALEGRID_BUTTON.height = I(SCALEGRID_BUTTON.height);

		this.styleProvider.setStyleFunction(Label, null, this.setLabelStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_DARK, this.setLabelDarkStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_MEDIUM, this.setLabelMediumStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_LARG, this.setLabelWhiteLargStyles);

		this.styleProvider.setStyleFunction(Button, null, this.setButtonStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_LINK, this.setButtonLinkStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_CLOSE, this.setButtonCloseStyles);

		this.styleProvider.setStyleFunction(ItemRenderer, null, this.setItemRendererStyles);
	}

	private function setLabelStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat();
		// if (label.disabledTextFormat == null)
		// 	label.disabledTextFormat = this.getDisabledTextFormat();
	}

	private function setLabelDarkStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(FONT_SIZE, 1);
		// if (label.disabledTextFormat == null)
		// 	label.disabledTextFormat = this.getDisabledTextFormat();
	}

	private function setLabelMediumStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(cast FONT_SIZE * 1.4, 0xFFFFFF);
	}

	private function setLabelWhiteLargStyles(label:Label):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(FONT_SIZE * 2, 0xFFFFFF);
	}

	private function setButtonStyles(button:Button):Void {
		button.backgroundSkin = this.getButtonSkin();
		button.minWidth = button.minHeight = F(80);

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
		button.paddingBottom = F(8);
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

	public function getButtonSkin():DisplayObject {
		return getScaled9Textures("button-skin", SCALEGRID_BUTTON);
	}

	public function getTextFormat(size:UInt = 0, color:UInt = 0, bold:Bool = false):TextFormat {
		return new TextFormat(FONT_NAME, size == 0 ? FONT_SIZE : size, color == 0 ? FONT_COLOR : color, bold);
	}

	/**
	 * Returns a scale9Textures from this class based on a string key.
	 * @param name A key that matches a static constant of Bitmap type.
	 * @return a starling scale9Textures.
	 */
	static private var scale9Bitmaps:Map<String, BitmapData> = new Map();

	static public function getScaled9Textures(id:String, scale9grid:Rectangle):Scale9Bitmap {
		#if !flash
		if (!scale9Bitmaps.exists(id)) {
			var bmp = Assets.getBitmapData("images/" + id + ".png");
			var bitmapWidth = I(bmp.width * 0.5) * 2;
			var bitmapHeight = I(bmp.height * 0.5) * 2;
			var mat = new Matrix();
			mat.scale(bitmapWidth / bmp.width, bitmapHeight / bmp.height);
			var destBD = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
			destBD.draw(bmp, mat);

			scale9Bitmaps[id] = destBD;
		}
		#end
		return new Scale9Bitmap(scale9Bitmaps[id], scale9grid);
	}
}
