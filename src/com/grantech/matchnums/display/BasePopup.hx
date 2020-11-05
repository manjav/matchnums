package com.grantech.matchnums.display;

import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;

class BasePopup extends BaseOverlay {
	public var contentWidth = 320.0;
	public var contentHeight = 480.0;
	public var content:LayoutGroup;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.content = new LayoutGroup();
		this.content.width = this.contentWidth;
		this.content.height = this.contentHeight;
		this.content.layoutData = AnchorLayoutData.center();
		this.addChild(this.content);

		this.contentBackgroundFactory();
	}
	
	private function contentBackgroundFactory():Void {

		var skin = new RectangleSkin();
		skin.cornerRadius = 6;
		skin.fill = SolidColor(0x000000);
		skin.border = SolidColor(4, 0xFFFFFF);
		this.content.backgroundSkin = skin;
	}
}
