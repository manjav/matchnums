package com.grantech.matchnums.screens;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
import motion.Actuate;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

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

	public function close():Void {
		Actuate.tween(this, 0.2, {alpha: 0.1}).onComplete(this.parent.removeChild, [this]);
		if (this.hasEventListener(Event.CLOSE))
			this.dispatchEvent(new Event(Event.CLOSE));
	}
}
