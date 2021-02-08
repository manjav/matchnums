package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.utils.Ads;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.display.buttons.MessageButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;

using com.dailygames.mergenums.themes.OutlineTheme;

class AlternativeCallout extends ConfirmPopup {
	public var mode:String;
	public var cost:Int = 100;

	private var adsButton:MessageButton;

	override private function initialize():Void {
		super.initialize();
		this.hasCloseButton = false;
		this.title = "Get new powerup!";

		this.addButton("coin", cost + "", OutlineTheme.VARIANT_MSBUTTON_GREEN, AnchorLayoutData.bottomLeft(6.I(), 6.I()), 86.F(), 40.I());
		this.adsButton = this.addButton("ads", "free", OutlineTheme.VARIANT_MSBUTTON_ORANGE, AnchorLayoutData.bottomRight(6.I(), 6.I()), 86.F(), 40.I());
	}

	override private function open():Void {
		this.adsButton.enabled = Ads.instance.has("powerups");
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
			Ads.instance.show("powerups", function():Void {
				this.dispatchEvent(new Event(Event.COMPLETE));
				this.close();
			});
		}
	}

	override private function titleFactory():Void {
		this.titleDisplay = this.labelFactory(this.titleDisplay, this.title, AnchorLayoutData.topLeft(5.I(), 5.I()));
		this.titleDisplay.variant = OutlineTheme.VARIANT_LABEL_DETAILS;
	}

	override private function overlayFactory():Void {
		super.overlayFactory();
		this.backgroundSkin.alpha = 0;
		this.backgroundSkin.addEventListener(MouseEvent.CLICK, this.backgroundSkin_clickHandler);
	}

	private function backgroundSkin_clickHandler(event:MouseEvent):Void {
		this.dispatchEvent(new Event(Event.CANCEL));
		this.close();
	}

	override private function contentBackgroundFactory():Void {
		var skin = new RectangleSkin();
		skin.cornerRadius = 12.0.F();
		skin.fill = SolidColor(OutlineTheme.LIGHT_COLOR, 1);
		this.content.backgroundSkin = skin;
	}
}
