package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.display.overlays.BaseOverlay;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

using com.dailygames.mergenums.themes.OutlineTheme;

class BasePopup extends BaseOverlay {
	private var closeButton:Button;
	private var content:LayoutGroup;

	public var contentRect(default, set):Rectangle;

	public function set_contentRect(value:Rectangle):Rectangle {
		if (this.contentRect == value)
			return value;
		this.contentRect = value;
		this.adjustContentLayout();
		return value;
	}

	public var hasCloseButton(default, set):Bool;

	public function set_hasCloseButton(value:Bool):Bool {
		if (this.hasCloseButton == value)
			return value;
		this.hasCloseButton = value;
		this.setInvalid(InvalidationFlag.CUSTOM("closeButton"));
		return value;
	}

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.content = new LayoutGroup();
		this.content.layout = new AnchorLayout();
		this.adjustContentLayout();
		this.addChild(this.content);

		this.contentBackgroundFactory();
		this.closeButtonFactory();
	}

	private function adjustContentLayout():Void {
		if (this.contentRect == null) {
			this.content.width = OutlineTheme.POPUP_SIZE;
			this.content.height = OutlineTheme.POPUP_SIZE * 1.2;
			this.content.layoutData = AnchorLayoutData.center();
		} else {
			this.content.x = this.contentRect.x;
			this.content.y = this.contentRect.y;
			this.content.width = contentRect.width;
			this.content.height = contentRect.height;
			this.content.layoutData = null;
		}
	}

	private function contentBackgroundFactory():Void {
		var skin = new RectangleSkin();
		skin.cornerRadius = 28.0.F();
		skin.fill = SolidColor(OutlineTheme.DARK_COLOR);
		this.content.backgroundSkin = skin;
	}

	public function closeButtonFactory():Void {
		if (!this.hasCloseButton) {
			if (this.closeButton != null && this.closeButton.parent != null)
				this.closeButton.parent.removeChild(this.closeButton);
			return;
		}

		if (this.closeButton == null) {
			this.closeButton = new Button();
			this.closeButton.variant = OutlineTheme.VARIANT_BUTTON_LINK;
			this.closeButton.icon = new Bitmap(Assets.getBitmapData("close"));
			this.closeButton.layoutData = AnchorLayoutData.topRight(-this.padding * 2.2, this.padding);
			this.closeButton.addEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
		}
		this.content.addChild(this.closeButton);
	}

	private function closeButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("closeButton")))
			this.closeButtonFactory();
		super.validateNow();
	}
}
