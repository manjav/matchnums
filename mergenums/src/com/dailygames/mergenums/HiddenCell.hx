package com.dailygames.mergenums;

import com.dailygames.mergenums.Cell.*;
import com.dailygames.mergenums.animations.IAnimationFactory;
import com.dailygames.mergenums.animations.Reward;

class HiddenCell extends Cell {
	public var showValue(default, set):Bool;

	private function set_showValue(value:Bool):Bool {
		if (this.showValue == value)
			return value;
		this.updateStyle(value);
		this.showValue = value;
		return value;
	}

	public function new(column:Int, row:Int, value:Int, reward:Int = 0, ?initAnimationFactory:IAnimationFactory) {
		super(column, row, value, reward, initAnimationFactory);

		this.background.graphics.clear();
		this.background.graphics.lineStyle(5, 0xFFFFFF);
		this.background.graphics.drawRoundRect(BORDER - RADIUS, BORDER - RADIUS, SIZE - BORDER * 2, SIZE - BORDER * 2, ROUND, ROUND);

		this.background.graphics.moveTo(-RADIUS + BORDER * 2, -RADIUS - BORDER);
		this.background.graphics.lineTo(RADIUS - BORDER * 2, -RADIUS - BORDER);
	}

	override public function init(column:Int, row:Int, value:Int, reward:Int, initAnimationFactory:IAnimationFactory):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		this.reward = reward;
		this.initAnimationFactory = initAnimationFactory;
		this.state = Init;

		this.textDisplay.y = -RADIUS * 0.2 - this.textDisplay.getTextFormat().size * 0.5;
		this.updateStyle(this.showValue);

		if (this.rewardDisplay != null) {
			Reward.dispose(this.rewardDisplay);
			this.rewardDisplay = null;
		}

		if (this.reward > 0) {
			this.rewardDisplay = Reward.instantiate(RewardType.Coin, RADIUS, -RADIUS, this);
			this.rewardDisplay.scaleX = this.rewardDisplay.scaleY = 0.5;
		}

		if (this.initAnimationFactory == null)
			this.onInit();
		else
			this.initAnimationFactory.call([this, this.onInit]);
		return this;
	}

	private function updateStyle(value:Bool):Void {
		if (value) {
			this.transform.colorTransform.color = COLORS[this.value];
			if (this.textDisplay != null)
				this.textDisplay.text = Std.string(getScore(this.value));
		} else {
			this.transform.colorTransform.color = 0xFFFFFF;
			if (this.textDisplay != null)
				this.textDisplay.text = "?";
		}
	}
}
