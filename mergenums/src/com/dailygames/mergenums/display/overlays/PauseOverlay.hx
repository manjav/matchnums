package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.display.popups.ConfirmPopup;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Sounds;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class PauseOverlay extends ConfirmPopup {
	override private function initialize():Void {
		super.initialize();

		this.content.height = OutlineTheme.POPUP_SIZE * 1.25;
		this.title = "Pause";

		var adsSkin = new RectangleSkin();
		adsSkin.fill = SolidColor(OutlineTheme.DARK_COLOR, 0.8);
		adsSkin.cornerRadius = 28.F();

		var adsHolder = new LayoutGroup();
		adsHolder.backgroundSkin = adsSkin;
		adsHolder.layoutData = new AnchorLayoutData(0, 0, null, 0);
		adsHolder.height = 234.F();
		content.addChild(adsHolder);

		function addButton(name:String, skin:DisplayObject, layoutData:AnchorLayoutData, width:Float, height:Float):Void {
			var button = new Button();
			button.name = name;
			button.width = width;
			button.height = height;
			button.backgroundSkin = skin;
			button.layoutData = layoutData;
			button.icon = new Bitmap(Assets.getBitmapData(name));
			button.addEventListener(MouseEvent.CLICK, buttons_clickHandler);
			content.addChild(button);
		}

		var theme = cast(Theme.getTheme(), OutlineTheme);
		addButton("restart", theme.getButtonSkin(OutlineTheme.ORANGE_COLORS, 4.F(), 30.F()), AnchorLayoutData.topLeft(adsHolder.height + 22.F()), 154.F(), 80.F());
		addButton("continue", theme.getButtonSkin(OutlineTheme.LIGHT_COLORS, 4.F(), 30.F()), AnchorLayoutData.topRight(adsHolder.height + 22.F()), 154.F(), 80.F());
		addButton("noads", theme.getButtonSkin(OutlineTheme.LIGHT_COLORS, 3.F(), 22.F()), new AnchorLayoutData(adsHolder.height + 120.F(), null, null, null, -44.F()), 64.F(), 64.F());
		addButton(Sounds.mute ? "mute" : "unmute", theme.getButtonSkin(OutlineTheme.LIGHT_COLORS, 3.F(), 22.F()), new AnchorLayoutData(adsHolder.height + 120.F(), null, null, null, 44.F()), 64.F(), 64.F());
	}

	override private function closeButton_clickHandler(event:MouseEvent):Void {
		this.dispatchEvent(new Event(Event.CANCEL));
		super.closeButton_clickHandler(event);
	}

	override private function contentBackgroundFactory():Void {}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		switch (button.name) {
			case "mute":
			case "unmute":
				Sounds.mute = !Sounds.mute;
				button.icon = new Bitmap(Assets.getBitmapData(Sounds.mute ? "mute" : "unmute"));
				Prefs.instance.set(MUTE, Sounds.mute ? 1.0 : 0.0);
				return;
			case "continue":
				this.dispatchEvent(new Event(Event.CANCEL));
			case "restart":
				this.dispatchEvent(new Event(Event.CLEAR));
			case "noads":
				this.dispatchEvent(new Event(Event.ACTIVATE));
		};
		this.close();
	}
}
