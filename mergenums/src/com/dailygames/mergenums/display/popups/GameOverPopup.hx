package com.dailygames.mergenums.display.popups;

import openfl.events.Event;
import com.dailygames.mergenums.events.GameEvent;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.Button;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class GameOverPopup extends ConfirmPopup implements IGamePlayPopup {
	private var resetButton:Button;

	public var value(default, set):Int = -1;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.setInvalid(InvalidationFlag.CUSTOM("value"));
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.title = "Game Over";
		this.hasCloseButton = false;
		this.content.height = OutlineTheme.POPUP_SIZE * 0.5;

		var scoresIndicator = new Indicator();
		scoresIndicator.icon = new Bitmap(Assets.getBitmapData("images/medal-small.png"));
		scoresIndicator.layoutData = AnchorLayoutData.center(0, -this.padding);
		scoresIndicator.type = Prefs.SCORES;
		this.content.addChild(scoresIndicator);

		this.resetButton = new Button();
		this.resetButton.text = "Reset";
		this.resetButton.width = OutlineTheme.PADDING * 12;
		this.resetButton.height = OutlineTheme.PADDING * 3;
		this.resetButton.icon = new Bitmap(Assets.getBitmapData("images/reset.png"));
		this.resetButton.layoutData = AnchorLayoutData.bottomCenter(this.padding);
		this.resetButton.addEventListener(MouseEvent.CLICK, this.resetButton_clickHandler);
		this.content.addChild(this.resetButton);
	}

	// override public function validateNow():Void {
	// 	if (this.isInvalid(InvalidationFlag.CUSTOM("value"))) {
	// 		this.resetButton.text = " " + this.cost + " ";
	// 	}
	// 	super.validateNow();
	// }

	override private function titleFactory():Void {
		super.titleFactory();
		this.titleDisplay.variant = null;
		// this.titleDisplay.layoutData = AnchorLayoutData.topCenter(0, padding * 3);
		var textFormat = this.titleDisplay.textFormat;
		textFormat.align = CENTER;
		this.titleDisplay.textFormat = textFormat;
	}

	private function resetButton_clickHandler(event:MouseEvent):Void {
		this.dispatchEvent(new Event(Event.SELECT));
		this.close();
	}
}
