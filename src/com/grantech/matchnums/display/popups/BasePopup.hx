package com.grantech.matchnums.display.popups;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Button;
import openfl.events.MouseEvent;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import openfl.events.MouseEvent;

class BasePopup extends BaseOverlay {
	public var contentWidth = 400.0;
	public var contentHeight = 400.0;

	private var closeButton:Button;
	private var content:LayoutGroup;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.content = new LayoutGroup();
		this.content.width = this.contentWidth;
		this.content.height = this.contentHeight;
		this.content.layout = new AnchorLayout();
		this.content.layoutData = AnchorLayoutData.center();
		this.addChild(this.content);

		this.contentBackgroundFactory();

		this.closeButton = new Button();
		this.closeButton.variant = OutlineTheme.VARIANT_CLOSE_BUTTON;
		this.closeButton.layoutData = AnchorLayoutData.topRight(this.padding, this.padding);
		this.closeButton.addEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
		this.content.addChild(this.closeButton);
	}

	private function contentBackgroundFactory():Void {
		var skin = new RectangleSkin();
		skin.cornerRadius = 10.0;
		skin.fill = SolidColor(0x000000);
		skin.border = SolidColor(2.0, 0xFFFFFF);
		this.content.backgroundSkin = skin;
	}

	private function closeButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}
}
