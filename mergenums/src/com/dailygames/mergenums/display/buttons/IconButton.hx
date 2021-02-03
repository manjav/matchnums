package com.dailygames.mergenums.display.buttons;

import com.dailygames.mergenums.themes.OutlineTheme;
import feathers.style.Theme;
import feathers.controls.Label;
import feathers.controls.AssetLoader;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

class IconButton extends LayoutGroup {
	public var padding = 0;

	private var badgeDisplay:Label;
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
			iconDisplay.source = this._icon;
		return this._icon;
	}

	private var _badge:Float = Math.POSITIVE_INFINITY;

	public var badge(get, set):Float;

	private function get_badge():Float {
		return this._badge;
	}

	private function set_badge(value:Float):Float {
		if (this._badge == value)
			return this._badge;
		this._badge = value;
		if (this.badgeDisplay == null)
			this.badgeDisplay = this.badgeFactory();
		badgeDisplay.text = this.badgeFormat(this._badge);
		return this._badge;
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

	public dynamic function badgeFactory():Label {
		var theme = cast(Theme.getTheme(), OutlineTheme);
		var b = new Label();
		b.textFormat = theme.getTextFormat(Math.round(OutlineTheme.FONT_SIZE * 0.65), OutlineTheme.LIGHT_COLOR, true);
		b.backgroundSkin = theme.getBadgeSkin();
		b.layoutData = AnchorLayoutData.topRight();
		this.addChild(b);
		return b;
	}

	public dynamic function badgeFormat(value:Float):String {
		if (value <= 0)
			return " free ";
		return " " + this._badge + " ";
	}
}
