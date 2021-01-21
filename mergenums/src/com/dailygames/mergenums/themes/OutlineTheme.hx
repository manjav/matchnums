package com.dailygames.mergenums.themes;

import com.dailygames.mergenums.display.buttons.MessageButton;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.skins.ProgrammaticSkin;
import feathers.themes.ClassVariantTheme;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.filters.DropShadowFilter;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

using com.dailygames.mergenums.themes.OutlineTheme;

class OutlineTheme extends ClassVariantTheme {
	static public final FONT_NAME = "Quicksand Bold";

	static public final LIGHT_COLOR = 0xEDEDED;
	static public final GRAY_COLOR = 0x212527;
	static public final LIGHT_COLORS = [0xEDEDED, 0xEDEDED, 0xCCCCCC];
	static public final YELLOW_COLORS = [0xFFC000, 0xFE9C0F, 0xEB6D0A];
	static public final BLUE_COLORS = [0x00B0F0, 0x0070C0, 0x00619F];
	static public final ORANGE_COLORS = [0xFB6127, 0xFA3838, 0xE92A26];
	static public final GREEN_COLORS = [0x71D32c, 0x00B050, 0x0A903D];
	static public final DARK_COLOR = 0x131415;
	static public final NEUTRAL_COLOR = 0x0070C0;

	static public var PADDING:Int;
	static public var FONT_SIZE:Int;
	static public var POPUP_SIZE:Int;
	static public var SCALE_FACTOR:Float;

	public static final VARIANT_LABEL_LIGHT:String = "vLabelLight";
	public static final VARIANT_LABEL_MEDIUM:String = "vLabelMedium";
	public static final VARIANT_LABEL_MEDIUM_LIGHT:String = "vLabelMediumLight";

	public static final VARIANT_BUTTON_LINK:String = "vButtonLink";

	public static final VARIANT_MBUTTON_WHITE:String = "vMButton";
	public static final VARIANT_MBUTTON_RED:String = "vMButtonRed";
	public static final VARIANT_MBUTTON_ORANGE:String = "vMButtonOrange";
	public static final VARIANT_MBUTTON_GREEN:String = "vMButtonGreen";

	public static final SCALEGRID_BUTTON:Rectangle = new Rectangle(14, 16, 1, 1);

	public static function F(value:Float):Float {
		return value * SCALE_FACTOR;
	}

	public static function I(value:Float):Int {
		return Math.round(value * SCALE_FACTOR);
	}

	public function new(stage:Stage, scaleFactor:Float) {
		super();
		#if android
		SCALE_FACTOR = 1; // stage.stageWidth / 1080;
		#else
		SCALE_FACTOR = 1.35;
		#end
		POPUP_SIZE = I(320);
		PADDING = I(25);
		FONT_SIZE = I(18);
		SCALEGRID_BUTTON.x = I(SCALEGRID_BUTTON.x);
		SCALEGRID_BUTTON.y = I(SCALEGRID_BUTTON.y);
		SCALEGRID_BUTTON.width = I(SCALEGRID_BUTTON.width);
		SCALEGRID_BUTTON.height = I(SCALEGRID_BUTTON.height);

		this.styleProvider.setStyleFunction(Label, null, this.setLabelStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_LIGHT, this.setLabelLightStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_MEDIUM, this.setLabelMediumStyles);
		this.styleProvider.setStyleFunction(Label, VARIANT_LABEL_MEDIUM_LIGHT, this.setLabelMediumLightStyles);

		this.styleProvider.setStyleFunction(Button, null, this.setButtonStyles);
		this.styleProvider.setStyleFunction(Button, VARIANT_BUTTON_LINK, this.setButtonLinkStyles);

		this.styleProvider.setStyleFunction(MessageButton, null, this.setMessageButtonStyles);
		this.styleProvider.setStyleFunction(MessageButton, VARIANT_MBUTTON_ORANGE, this.setMessageButtonAccentStyles);
		this.styleProvider.setStyleFunction(MessageButton, VARIANT_MBUTTON_GREEN, this.setMessageButtonGreenStyles);

		this.styleProvider.setStyleFunction(ItemRenderer, null, this.setItemRendererStyles);
	}

	private function setLabelStyles(label:Label):Void {
		this.setCustomLabelStyles(label, FONT_SIZE, GRAY_COLOR);
	}

	private function setLabelLightStyles(label:Label):Void {
		this.setCustomLabelStyles(label, FONT_SIZE, LIGHT_COLOR);
	}

	private function setLabelMediumStyles(label:Label):Void {
		this.setCustomLabelStyles(label, cast FONT_SIZE * 1.5, GRAY_COLOR);
	}

	private function setLabelMediumLightStyles(label:Label):Void {
		this.setCustomLabelStyles(label, cast FONT_SIZE * 1.5, LIGHT_COLOR);
	}

	private function setCustomLabelStyles(label:Label, fontSize:UInt, fontColor:UInt):Void {
		label.embedFonts = true;
		if (label.textFormat == null)
			label.textFormat = this.getTextFormat(fontSize, fontColor);
	}

	// private function setLabelWhiteLargStyles(label:Label):Void {
	// 	label.embedFonts = true;
	// 	if (label.textFormat == null)
	// 		label.textFormat = this.getTextFormat(FONT_SIZE * 2, GRAY_COLOR);
	// }

	private function setButtonStyles(button:Button):Void {
		button.backgroundSkin = this.getButtonSkin();
		button.minWidth = button.minHeight = F(54);

		button.textFormat = this.getTextFormat(0, DARK_COLOR);
		button.setTextFormatForState(DOWN, button.textFormat);

		button.paddingTop = 0.0;
		button.paddingBottom = 0.0;
		button.paddingLeft = 0.0;
		button.paddingRight = 0.0;
	}

	private function setButtonLinkStyles(button:Button):Void {
		this.setButtonStyles(button);
		button.backgroundSkin.alpha = 0;
		button.textFormat = this.getTextFormat(Math.round(FONT_SIZE * 0.7));
		button.setTextFormatForState(DOWN, button.textFormat);
	}

	private function setMessageButtonStyles(button:MessageButton):Void {
		this.setCustomMButtonStyles(button, LIGHT_COLORS, VARIANT_LABEL_MEDIUM, null);
	}

	private function setMessageButtonAccentStyles(button:MessageButton):Void {
		this.setCustomMButtonStyles(button, ORANGE_COLORS, VARIANT_LABEL_MEDIUM_LIGHT, VARIANT_LABEL_LIGHT);
	}

	private function setMessageButtonGreenStyles(button:MessageButton):Void {
		this.setCustomMButtonStyles(button, GREEN_COLORS, VARIANT_LABEL_MEDIUM, null);
	}

	private function setCustomMButtonStyles(button:MessageButton, colors:Array<UInt>, textVariant:String, messageVariant:String):Void {
		button.backgroundSkin = this.getButtonSkin(colors, 4.I(), 30.I());
		button.textDisplay.variant = textVariant;
		button.textDisplay.filters = [getDefaultShadow(5.F())];
		button.messageDisplay.variant = messageVariant;
		button.messageDisplay.filters = [getDefaultShadow(5.F())];
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

	public function getButtonSkin(colors:Array<UInt> = null, deepness:Float = 3, cornerRadius:Float = 22):DisplayObject {
		var skin = new MyButtonSkin(colors, deepness, cornerRadius);
		skin.filters = [getDefaultShadow(deepness)];
		return skin; // getScaled9Textures("button-skin", SCALEGRID_BUTTON);
	}

	public function getTextFormat(size:UInt = 0, color:UInt = 0, bold:Bool = false):TextFormat {
		return new TextFormat(FONT_NAME, size == 0 ? FONT_SIZE : size, color == 0 ? GRAY_COLOR : color, bold);
	}

	public function getDefaultShadow(size:Float = 3, value:Float = 1):DropShadowFilter {
		return new DropShadowFilter(size.F(), 80, 0, 0.95, size.F(), size.F(), value, 3);
	}

	/**
	 * Returns a scaledBitmaps from this class based on a string key.
	 * @param name A key that matches a static constant of Bitmap type.
	 * @return Bitmap.
	 */
	static private var scaledBitmaps:Map<String, BitmapData> = new Map();

	static public function getScaledBitmap(id:String):BitmapData {
		#if !flash
		if (!scaledBitmaps.exists(id)) {
			var bmp = Assets.getBitmapData(id);
			var bitmapWidth = I(bmp.width * 0.5) * 2;
			var bitmapHeight = I(bmp.height * 0.5) * 2;
			var mat = new Matrix();
			mat.scale(bitmapWidth / bmp.width, bitmapHeight / bmp.height);
			var destBD = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
			destBD.draw(bmp, mat, null, null, null, true);

			scaledBitmaps[id] = destBD;
		}
		#end
		return scaledBitmaps[id];
	}
}

class MyButtonSkin extends ProgrammaticSkin {
	private var colors:Array<UInt>;
	private var deepness:Float;
	private var cornerRadius:Float;

	public function new(colors:Array<UInt>, deepness:Float, cornerRadius:Float) {
		super();
		this.colors = colors == null ? OutlineTheme.LIGHT_COLORS : colors;
		this.cornerRadius = cornerRadius.F();
		this.deepness = deepness.F();
	}

	override private function update():Void {
		var b = 2.F();
		this.graphics.clear();
		this.graphics.beginFill(OutlineTheme.GRAY_COLOR);
		this.graphics.drawRoundRect(0, 0, this.actualWidth, this.actualHeight, cornerRadius + 4.F(), cornerRadius * 1.2);
		this.graphics.endFill();
		this.graphics.beginFill(this.colors[2]);
		this.graphics.drawRoundRect(b, b, this.actualWidth - b * 2, this.actualHeight - b * 2, cornerRadius, cornerRadius);
		this.graphics.endFill();

		var matrix = new Matrix();
		matrix.createGradientBox(0, this.actualHeight - b * 3, Math.PI * 0.5);
		this.graphics.beginGradientFill(LINEAR, [this.colors[0], this.colors[1]], [1, 1], [170, 255], matrix);
		this.graphics.drawRoundRect(b, b, this.actualWidth - b * 2, this.actualHeight - b * 2 - deepness, cornerRadius, cornerRadius);
		this.graphics.endFill();
	}
}
