package com.grantech.matchnums.display.popups;

import com.grantech.matchnums.animations.CellInitAnimationFactory;
import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Button;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;

class BigValuePopup extends ConfirmPopup {
	private var cellDisplay:Cell;
	private var adsButton:Button;
	private var skipButton:Button;
	private var cellInitAnimationFactory:CellInitAnimationFactory;

	public var value(default, set):Int;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.title = Cell.getScore(value) + " created again!\nDouble It?";
		return value;
	}

	override private function initialize():Void {
		this.contentHeight = 480;
		super.initialize();

		this.adsButton = new Button();
		this.adsButton.text = "100";
		this.adsButton.icon = new Bitmap(Assets.getBitmapData("images/coin.png"));
		this.adsButton.layoutData = AnchorLayoutData.bottomCenter(this.padding * 5, 0);
		this.adsButton.addEventListener(MouseEvent.CLICK, this.adsButton_clickHandler);
		this.content.addChild(this.adsButton);

		this.skipButton = new Button();
		this.skipButton.text = "Skip";
		this.skipButton.variant = OutlineTheme.VARIANT_BUTTON_TRANSPARENT;
		this.skipButton.layoutData = AnchorLayoutData.bottomCenter(this.padding, 0);
		this.skipButton.addEventListener(MouseEvent.CLICK, this.skipButton_clickHandler);
		this.content.addChild(this.skipButton);
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title"))) {
			this.cellDisplay = Cell.instantiate(1, 1, this.value, this.cellInitAnimationFactory);
			this.addChild(this.cellDisplay);
		}
		super.validateNow();
	}

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		this.titleDisplay.layoutData = AnchorLayoutData.center(0, padding * 2);
	}

	override private function refreshBackgroundLayout():Void {
		super.refreshBackgroundLayout();

		if (this.cellDisplay != null) {
			this.cellDisplay.x = this.actualWidth * 0.5;
			this.cellDisplay.y = this.actualHeight * 0.4;
		}
	}

	override private function layoutGroup_removedFromStageHandler(event:Event):Void {
		super.layoutGroup_removedFromStageHandler(event);
		if (this.cellDisplay != null) {
			this.removeChild(this.cellDisplay);
			Cell.dispose(this.cellDisplay);
		}
	}

	private function adsButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	private function skipButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}
}
