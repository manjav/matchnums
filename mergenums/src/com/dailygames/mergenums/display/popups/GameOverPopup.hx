package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.display.buttons.MessageButton;
import feathers.layout.AnchorLayoutData;
import openfl.events.Event;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class GameOverPopup extends ConfirmPopup implements IGamePlayPopup {
	private var ranksDisplay:Ranks;

	public var value(default, set):Int = -1;

	public function set_value(value:Int):Int {
		if (this.value == value)
			return value;
		this.value = value;
		this.setInvalid(InvalidationFlag.CUSTOM("value"));
		this.ranksDisplay.updateData();
		return value;
	}

	override private function initialize():Void {
		super.initialize();
		this.title = "Game Result";
		this.hasCloseButton = false;

		this.ranksDisplay = new Ranks();
		this.ranksDisplay.layoutData = AnchorLayoutData.topCenter(18.I());
		this.content.addChild(this.ranksDisplay);

		this.addButton("ads", "Free", OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomLeft(28.F(), 18.F()), 128.F()).text = "100";
		addButton("restart", "Restart", OutlineTheme.VARIANT_MBUTTON_GREEN, AnchorLayoutData.bottomRight(28.F(), 18.F()), 146.F());
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		switch (button.name) {
			case "ads":
				return;
			case "restart":
				this.dispatchEvent(new Event(Event.SELECT));
		}
		this.close();
	}
}
