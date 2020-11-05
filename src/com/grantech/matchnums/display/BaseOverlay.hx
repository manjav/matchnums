package com.grantech.matchnums.display;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import motion.Actuate;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

enum ScreenType {
	Pause;
	Ads;
}

class BaseOverlay extends LayoutGroup {
	static final saves:Map<ScreenType, BaseOverlay> = new Map();

	static public function create(screenType:ScreenType, ?parent:DisplayObjectContainer, ?save:Bool):BaseOverlay {
		var screen:BaseOverlay;
		if (save && saves.exists(screenType)) {
			screen = saves.get(screenType);
		} else {
			screen = switch (screenType) {
				case Pause:
					new PauseOverlay();
				default: null;
			}
			screen.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		}
		screen.alpha = 1;
		if (save)
			saves.set(screenType, screen);
		if (parent != null)
			parent.addChild(screen);
		return screen;
	}

	private var overlay:RectangleSkin;

	override private function initialize():Void {
		super.initialize();
		this.overlayFactory();
	}

	private function overlayFactory():Void {
		this.overlay = new RectangleSkin();
		this.overlay.fill = SolidColor(0x000000, 0.6);
		this.backgroundSkin = this.overlay;
	}

	public function close():Void {
		Actuate.tween(this, 0.2, {alpha: 0.1}).onComplete(this.parent.removeChild, [this]);
		if (this.hasEventListener(Event.CLOSE))
			this.dispatchEvent(new Event(Event.CLOSE));
	}
}
