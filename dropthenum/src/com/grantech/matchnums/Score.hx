package com.grantech.matchnums;

import com.grantech.matchnums.utils.Utils;
import motion.Actuate;
import motion.easing.Sine;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextField;

class Score extends TextField {
	static public final DURATION = 3;
	static public final LENGTH = 100;

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
		Actuate.tween(this, DURATION, {alpha: 0.01, y: y - LENGTH}).ease(Sine.easeOut).onComplete(popupComplete);
		parent.addChild(this);
		return this;
	}

	public function popupComplete():Void {
		dispose(this);
	}

	static private var pool:Array<Score> = new Array();
	static private var i:Int = 0;

	static public function dispose(score:Score):Void {
		if (score.parent != null)
			score.parent.removeChild(score);
		pool[i++] = score;
	}

	static public function instantiate(text:String, x:Float, y:Float, parent:DisplayObjectContainer):Score {
		if (i > 0) {
			i--;
			return pool[i].popup(text, x, y, parent);
		}
		return new Score(text, x, y, parent);
	}
}
