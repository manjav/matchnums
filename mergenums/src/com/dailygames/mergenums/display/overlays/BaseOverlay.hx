package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.display.popups.*;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import motion.Actuate;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

enum ScreenType {
	Pause;
	Shop;
	BigValue;
	NewRecord;
	Revive;
	GameOver;
	RemoveCell;
	StartingOffer;
	Alternative;
}

class BaseOverlay extends LayoutGroup {
	static final saves:Map<ScreenType, BaseOverlay> = new Map();

	static public function create(type:ScreenType, ?parent:DisplayObjectContainer, ?save:Bool):BaseOverlay {
		var screen:BaseOverlay;
		if (save && saves.exists(type)) {
			screen = saves.get(type);
		} else {
			screen = switch (type) {
				case Pause:
					new PauseOverlay();
				case Shop:
					new ShopOverlay();
				case BigValue:
					new BigValuePopup();
				case NewRecord:
					new NewRecordPopup();
				case Revive:
					new RevivePopup();
				case GameOver:
					new GameOverPopup();
				case RemoveCell:
					new RemoveCellPopup();
				case StartingOffer:
					new StartingOfferOverlay();
				case Alternative:
					new AlternativeCallout();
				default: null;
			}
			screen.layoutData = AnchorLayoutData.fill();
		}
		screen.alpha = 1;
		if (save)
			saves.set(type, screen);
		if (parent != null)
			parent.addChild(screen);
		return screen;
	}

	static public function closeAll():Void {
		for (o in saves)
			if (o.isOpen)
				o.close();
	}

	private var padding = OutlineTheme.PADDING;
	private var overlay:RectangleSkin;

	public var isOpen(default, default):Bool;

	override private function initialize():Void {
		super.initialize();
		this.overlayFactory();
	}

	override private function feathersControl_addedToStageHandler(event:Event):Void {
		super.feathersControl_addedToStageHandler(event);
		this.isOpen = true;
	}

	override private function feathersControl_removedFromStageHandler(event:Event):Void {
		super.feathersControl_removedFromStageHandler(event);
		this.isOpen = false;
	}

	private function overlayFactory():Void {
		this.overlay = new RectangleSkin();
		this.overlay.fill = SolidColor(OutlineTheme.GRAY_COLOR, 0.96);
		this.backgroundSkin = this.overlay;
	}

	public function close():Void {
		Actuate.tween(this, 0.2, {alpha: 0.01}).onComplete(this.parent.removeChild, [this]);
		if (this.hasEventListener(Event.CLOSE))
			this.dispatchEvent(new Event(Event.CLOSE));
	}
}
