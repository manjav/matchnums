package com.grantech.matchnums.display.overlays;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;

class PauseOverlay extends BaseOverlay {
	private var labelDisplay:Label;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.labelDisplay = new Label();
		this.labelDisplay.variant = OutlineTheme.VARIANT_LABEL_LARG;
		this.labelDisplay.layoutData = AnchorLayoutData.center();
		this.labelDisplay.text = "Tap to Start";
		this.addChild(this.labelDisplay);

		this.addEventListener(MouseEvent.CLICK, this_clickHandler);
	}

	private function this_clickHandler(event:MouseEvent):Void {
		this.close();
	}
}
