package com.grantech.matchnums.animations;

import com.grantech.matchnums.utils.Utils;
import motion.Actuate;
import motion.easing.Sine;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.text.TextField;

enum abstract RewardType(String) {
	var Coin = "coin.png";
}

class Reward extends Sprite {
	static public final DURATION = 3;
	static public final LENGTH = 100;

	public var type:RewardType;

	private var iconDisplay:Bitmap;
	private var textDisplay:TextField;

	public function new() {
		super();

		this.iconDisplay = new Bitmap(null);
		this.addChild(this.iconDisplay);
	}

	public function update(type:RewardType, x:Float, y:Float, parent:DisplayObjectContainer):Reward {
		this.type = type;
		this.x = x;
		this.y = y;
		this.alpha = 1;

		this.iconDisplay.bitmapData = Assets.getBitmapData("images/" + type);
		this.iconDisplay.x = -this.width;

		parent.addChild(this);
		return this;
	}

	public function popup(type:RewardType, text:String, x:Float, y:Float, parent:DisplayObjectContainer):Reward {
		this.update(type, x, y, parent);
		if (this.textDisplay == null) {
			this.textDisplay = new TextField();
			this.textDisplay.x = 4;
			Utils.setTextAttributes(this.textDisplay);
		}
		this.textDisplay.text = text;
		this.addChild(this.textDisplay);

		Actuate.tween(this, DURATION, {alpha: 0.01, y: y - LENGTH}).ease(Sine.easeOut).onComplete(popupComplete);
		return this;
	}

	public function popupComplete():Void {
		dispose(this);
	}

	static private var pool:Array<Reward> = new Array();
	static private var i:Int = 0;

	static public function dispose(reward:Reward):Void {
		if (reward.parent != null)
			reward.parent.removeChild(reward);
		if (reward.textDisplay != null && reward.textDisplay.parent == reward)
			reward.removeChild(reward.textDisplay);

		pool[i++] = reward;
	}

	static public function instantiate(type:RewardType, x:Float, y:Float, parent:DisplayObjectContainer):Reward {
		var reward:Reward;
		if (i <= 0) {
			reward = new Reward();
		} else {
			i--;
			reward = pool[i];
		}
		return reward.update(type, x, y, parent);
	}
}
