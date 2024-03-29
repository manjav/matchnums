package com.dailygames.mergenums.display.callouts;

import com.dailygames.mergenums.display.buttons.MessageButton;
import com.dailygames.mergenums.utils.Ads;
import com.dailygames.mergenums.utils.Prefs;
import openfl.events.Event;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class NextCellCallout extends ConfirmCallout {
	override private function initialize():Void {
		super.initialize();
		this.title = "Preview next block!";
	}

	override private function open():Void {
		this.adsButton.enabled = Ads.instance.has("boostnext");
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		if (button.name == "coin") {
			var newValue = Prefs.instance.get(Prefs.COIN) - cost;
			Prefs.instance.set(Prefs.COIN, newValue);
			if (newValue < 0)
				return;
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.close();
		} else {
			Ads.instance.show("boost-next", function():Void {
				this.dispatchEvent(new Event(Event.COMPLETE));
				this.close();
			});
		}
	}
}
