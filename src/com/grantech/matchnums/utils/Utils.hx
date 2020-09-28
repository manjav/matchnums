package com.grantech.matchnums.utils;

import openfl.text.TextFieldAutoSize;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Utils {
	static public function createText(size:Int = 80, color:UInt = 0xFFFFFF, align:String = "center", autoSize:TextFieldAutoSize = TextFieldAutoSize.CENTER):TextField {
		var textField = new TextField();
		// textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.autoSize = autoSize;
		textField.mouseEnabled = false;
		textField.selectable = false;
		textField.embedFonts = true;
		textField.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", size, color, null, null, null, null, null, align);
		// textField.filters = [new GlowFilter(0, 0.6, 4, 4)];
		return textField;
	}
}
