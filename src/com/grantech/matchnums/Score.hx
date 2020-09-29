package com.grantech.matchnums;

import com.grantech.matchnums.utils.Utils;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextField;

class Score extends TextField {
	public function new(text:String, x:Float, y:Float, parent:DisplayObjectContainer) {
		super();
		Utils.setTextAttributes(this);
		this.popup(text, x, y, parent);
	}

	public function popup(text:String, x:Float, y:Float, parent:DisplayObjectContainer):Score {
		this.text = text;
		this.alpha = 1;
		this.y = y;
		this.x = x - this.width * 0.5;
		parent.addChild(this);
		return this;
		dispose(this);
	}

	static public function dispose(score:Score):Void {
		if (score.parent != null)
			score.parent.removeChild(score);
	}

	static public function instantiate(text:String, x:Float, y:Float, parent:DisplayObjectContainer):Score {
		if (i > 0) {
		return new Score(text, x, y, parent);
	}
}
