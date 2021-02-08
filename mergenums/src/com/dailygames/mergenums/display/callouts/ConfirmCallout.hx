package com.dailygames.mergenums.display.callouts;

import com.dailygames.mergenums.display.buttons.MessageButton;
import com.dailygames.mergenums.display.popups.ConfirmPopup;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import openfl.events.Event;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class ConfirmCallout extends ConfirmPopup {
	public var mode:String;
	public var cost:Int = 100;

	private var adsButton:MessageButton;

	override private function initialize():Void {
		super.initialize();
		this.hasCloseButton = false;

		this.addButton("coin", cost + "", OutlineTheme.VARIANT_MSBUTTON_GREEN, AnchorLayoutData.bottomLeft(6.I(), 6.I()), 86.F(), 40.I());
		this.adsButton = this.addButton("ads", "free", OutlineTheme.VARIANT_MSBUTTON_ORANGE, AnchorLayoutData.bottomRight(6.I(), 6.I()), 86.F(), 40.I());
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
