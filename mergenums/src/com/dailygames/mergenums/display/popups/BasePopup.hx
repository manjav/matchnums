package com.dailygames.mergenums.display.popups;

import com.dailygames.mergenums.display.overlays.BaseOverlay;
import com.dailygames.mergenums.themes.OutlineTheme;
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import openfl.events.MouseEvent;

class BasePopup extends BaseOverlay {

	private var closeButton:Button;
	private var content:LayoutGroup;

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
		this.content.width = OutlineTheme.POPUP_SIZE;
		this.content.height = OutlineTheme.POPUP_SIZE;
		this.content.layout = new AnchorLayout();
		this.content.layoutData = AnchorLayoutData.center();
		this.addChild(this.content);

		this.contentBackgroundFactory();
		this.closeButtonFactory();
	}

	private function contentBackgroundFactory():Void {
		var skin = new RectangleSkin();
		skin.cornerRadius = 10.0;
		skin.fill = SolidColor(0x000000);
		skin.border = SolidColor(2.0, 0xFFFFFF);
		this.content.backgroundSkin = skin;
	}

	public dynamic function closeButtonFactory():Void {
		if (!this.hasCloseButton) {
			if (this.closeButton != null && this.closeButton.parent != null)
				this.closeButton.parent.removeChild(this.closeButton);
			return;
		}

		if (this.closeButton == null) {
			this.closeButton = new Button();
			this.closeButton.variant = OutlineTheme.VARIANT_BUTTON_CLOSE;
			this.closeButton.layoutData = AnchorLayoutData.topRight(this.padding, this.padding);
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
