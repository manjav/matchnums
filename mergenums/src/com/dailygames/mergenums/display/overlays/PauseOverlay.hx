package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.themes.LineSkin;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Sounds;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;

class PauseOverlay extends BaseOverlay {
	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		var triangle = new Shape();
		triangle.graphics.beginFill(OutlineTheme.LIGHT_COLOR, 0.1);
		triangle.graphics.lineStyle(2.0 * OutlineTheme.SCALE_FACTOR, OutlineTheme.LIGHT_COLOR);
		var C = 8.0 * OutlineTheme.SCALE_FACTOR;
		var W = 60.0 * OutlineTheme.SCALE_FACTOR;
		var H = 72.0 * OutlineTheme.SCALE_FACTOR;
		triangle.graphics.moveTo(C, 0);
		triangle.graphics.lineTo(W * 2 - C, H - C);
		triangle.graphics.curveTo(W * 2, H, W * 2 - C, H + C);
		triangle.graphics.lineTo(C, H * 2);
		triangle.graphics.curveTo(0, H * 2, 0, H * 2 - C);
		triangle.graphics.lineTo(0, C);
		triangle.graphics.curveTo(0, 0, C, 0);

		var resumeButton = new Button();
		resumeButton.backgroundSkin = triangle;
		resumeButton.name = "resume";
		resumeButton.layoutData = AnchorLayoutData.center();
		resumeButton.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.addChild(resumeButton);

		var buttons = new LayoutGroup();
		buttons.layout = new AnchorLayout();
		buttons.backgroundSkin = new LineSkin(null, LineStyle.SolidColor(2.0 * OutlineTheme.SCALE_FACTOR, OutlineTheme.LIGHT_COLOR, 0.7));
		buttons.layoutData = new AnchorLayoutData(null, padding, null, padding, null, 200);
		this.addChild(buttons);

		function addButton(name:String, layoutData:AnchorLayoutData):Void {
			var button = new Button();
			button.name = name;
			button.height = button.width = W;
			button.layoutData = layoutData;
			button.icon = new Bitmap(Assets.getBitmapData("images/" + name + ".png"));
			button.addEventListener(MouseEvent.CLICK, buttons_clickHandler);
			buttons.addChild(button);
		}
		addButton("no-ads", AnchorLayoutData.topRight(C));
		addButton(Sounds.mute ? "mute" : "unmute", AnchorLayoutData.topRight(C, W + C));
		addButton("reset", AnchorLayoutData.topLeft(C));
	}

	private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		switch (button.name) {
			case "mute":
			case "unmute":
				Sounds.mute = !Sounds.mute;
				button.icon = new Bitmap(Assets.getBitmapData("images/" + (Sounds.mute ? "mute" : "unmute") + ".png"));
				Prefs.instance.set(MUTE, Sounds.mute ? 1.0 : 0.0);
				return;
			case "resume":
				this.dispatchEvent(new Event(Event.CANCEL));
			case "reset":
				this.dispatchEvent(new Event(Event.CLEAR));
			case "no-ads":
				this.dispatchEvent(new Event(Event.ACTIVATE));
		};
		this.close();
	}
}
