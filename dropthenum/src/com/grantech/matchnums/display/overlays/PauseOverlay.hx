package com.grantech.matchnums.display.overlays;

import com.grantech.matchnums.themes.LineSkin;
import com.grantech.matchnums.themes.OutlineTheme;
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
		triangle.graphics.beginFill(OutlineTheme.BORDER_COLOR, 0.1);
		triangle.graphics.lineStyle(2.0 * OutlineTheme.SCALE_FACTOR, OutlineTheme.BORDER_COLOR);
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

	}
		
	private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		if (button.name == "mute" || button.name == "unmute") {
			return;
	}

		switch (button.name) {
			case "resume":
				this.dispatchEvent(new Event(Event.CANCEL));
		};
		this.close();
	}
}
