package com.grantech.matchnums;

import hl.UI;
import openfl.text.TextFormat;
import openfl.text.TextField;

class Utils {
    static public function createText(size:Int = 80, color:UInt = 0xFFFFFF, align:String = "center"):TextField {
        
		var textField = new TextField();
		// textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.mouseEnabled = false;
		textField.selectable = false;
		textField.embedFonts = true;
		textField.defaultTextFormat = new TextFormat("Arial Rounded MT Bold", size, color, null, null, null, null, null, align);
        // textField.filters = [new GlowFilter(0, 0.6, 4, 4)];
        return textField;
    }
}