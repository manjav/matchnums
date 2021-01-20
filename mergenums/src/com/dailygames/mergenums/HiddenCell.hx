package com.dailygames.mergenums;

import com.dailygames.mergenums.Cell.*;
import com.dailygames.mergenums.animations.IAnimationFactory;
import com.dailygames.mergenums.animations.Reward;

class HiddenCell extends Cell {
	public var showValue:Bool;

	public function new(column:Int, row:Int, value:Int, reward:Int = 0, ?initAnimationFactory:IAnimationFactory) {
		super(column, row, value, reward, initAnimationFactory);

		this.background.graphics.clear();
		this.background.graphics.lineStyle(5, 0xFFFFFF);
		this.background.graphics.drawRoundRect(BORDER - RADIUS, BORDER - RADIUS, SIZE - BORDER * 2, SIZE - BORDER * 2, ROUND, ROUND);
	}

	override public function init(column:Int, row:Int, value:Int, reward:Int, initAnimationFactory:IAnimationFactory):Cell {
		this.column = column;
		this.row = row;
		this.value = value;
		this.reward = reward;
		this.initAnimationFactory = initAnimationFactory;
		this.state = Init;

		if (this.showValue) {
			this.transform.colorTransform.color = COLORS[value];
			this.textDisplay.text = Std.string(getScore(value));
		} else {
			this.transform.colorTransform.color = 0xFFFFFF;
			this.textDisplay.text = "?";
		}
		this.textDisplay.y = -RADIUS * 0.2 - this.textDisplay.getTextFormat().size * 0.5;

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
}
