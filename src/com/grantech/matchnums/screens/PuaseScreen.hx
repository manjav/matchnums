package com.grantech.matchnums.screens;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import openfl.events.MouseEvent;

class PuaseScreen extends BaseScreen {
	private var labelDisplay:Label;

	override private function initialize():Void {
		super.initialize();

		var skin = new RectangleSkin();
		skin.fill = SolidColor(0x000000, 0.6);
		this.backgroundSkin = skin;

		this.layout = new AnchorLayout();

		this.labelDisplay = new Label();
		this.labelDisplay.variant = OutlineTheme.VARIANT_WHITE_LARG;
		this.labelDisplay.layoutData = AnchorLayoutData.center();
		this.labelDisplay.text = "Tap to Start";
		this.addChild(this.labelDisplay);

		this.addEventListener(MouseEvent.CLICK, this_clickHandler);
	}

	private function this_clickHandler(event:MouseEvent):Void {
		this.close();
	}
}
