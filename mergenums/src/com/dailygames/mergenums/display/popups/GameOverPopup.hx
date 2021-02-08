package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.display.buttons.MessageButton;
import com.dailygames.mergenums.utils.Ads;
import com.dailygames.mergenums.utils.Prefs;
import feathers.layout.AnchorLayoutData;
import openfl.events.Event;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class GameOverPopup extends ConfirmPopup implements IGamePlayPopup {
	private var ranksDisplay:Ranks;
	private var adsButton:MessageButton;

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

		this.addButton("restart", "Restart", OutlineTheme.VARIANT_MBUTTON_GREEN, AnchorLayoutData.bottomRight(28.F(), 18.F()), 146.F());
		this.adsButton = this.addButton("ads", "Free", OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomLeft(28.F(), 18.F()), 128.F());
		this.adsButton.text = "100";
	}

	override private function open():Void {
		this.adsButton.enabled = Ads.instance.has("rewardedVideo");
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		switch (button.name) {
			case "ads":
				Ads.instance.show("rewardedVideo", function():Void {
					Prefs.instance.increase(Prefs.COIN, 100);
				});
				return;
			case "restart":
				this.dispatchEvent(new Event(Event.SELECT));
		}
		this.close();
	}
}
