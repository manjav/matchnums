package com.dailygames.mergenums.display.buttons;

import feathers.controls.AssetLoader;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

class IconButton extends LayoutGroup {
	public var padding = 0;

	private var iconDisplay:AssetLoader;

	private var _icon:String;

	public var icon(get, set):String;

	private function get_icon():String {
		return this._icon;
	}

	private function set_icon(value:String):String {
		if (this._icon == value)
			return this._icon;
		this._icon = value;
		if (iconDisplay != null)
			iconDisplay.source = icon;
		return this._icon;
	}

	override private function initialize() {
		super.initialize();

		layout = new AnchorLayout();
		this.buttonMode = true;
		this.mouseEnabled = true;
		this.mouseChildren = true;

		this.iconDisplay = new AssetLoader();
		this.iconDisplay.source = this.icon;
		this.iconDisplay.layoutData = AnchorLayoutData.fill(padding);
		this.addChild(this.iconDisplay);
	}
}
