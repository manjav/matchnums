package com.grantech.matchnums.screens;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
import openfl.display.DisplayObjectContainer;
enum ScreenType {
	Pause;
	Ads;
}

class BaseScreen extends LayoutGroup {
	static public function create(screenType:ScreenType, ?parent:DisplayObjectContainer):BaseScreen {
		var screen = switch (screenType) {
			case Pause:
				new PuaseScreen();
			default: null;
		}
		screen.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		if (parent != null)
			parent.addChild(screen);
		return screen;
	}

}
