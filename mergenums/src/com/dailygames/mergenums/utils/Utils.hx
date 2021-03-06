package com.dailygames.mergenums.utils;

import com.dailygames.mergenums.themes.OutlineTheme;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class Utils {
	static public function createText(size:Int = 80, color:UInt = 0xFFFFFF, align:String = "center",
			autoSize:TextFieldAutoSize = TextFieldAutoSize.CENTER):TextField {
		var textField = new TextField();
		setTextAttributes(textField, size, color, align, autoSize);
		return textField;
	}

	static public function setTextAttributes(textField:TextField, size:Int = 80, color:UInt = 0xFFFFFF, align:String = "center",
			autoSize:TextFieldAutoSize = TextFieldAutoSize.CENTER):Void {
		// textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.autoSize = autoSize;
		textField.gridFitType = GridFitType.NONE;
		textField.mouseEnabled = false;
		textField.selectable = false;
		textField.embedFonts = true;
		textField.defaultTextFormat = new TextFormat(OutlineTheme.FONT_NAME, size, color, null, null, null, null, null, align);
		// textField.filters = [new GlowFilter(0, 0.6, 4, 4)];
	}

	static public function toCurrency(value:Dynamic):String {
		var src = Std.string(value);
		var formatted = "";
		var len = src.length;
		while (len > 3)
			formatted = "," + src.substr(len -= 3, 3) + formatted;
		formatted = src.substr(0, len) + formatted;
		return formatted;
	}
}
