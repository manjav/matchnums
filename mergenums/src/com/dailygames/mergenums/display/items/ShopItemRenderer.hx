package com.dailygames.mergenums.display.items;

import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.dataRenderers.IDataRenderer;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.style.Theme;

using com.dailygames.mergenums.themes.OutlineTheme;

class ShopItemRenderer extends LayoutGroup implements IDataRenderer {
	private var _data:Dynamic;

	/**
		@see `feathers.controls.dataRenderers.IDataRenderer.data`
	**/
	public var data(get, set):Dynamic;

	private function get_data():Dynamic {
		return this._data;
	}

	private function set_data(value:Dynamic):Dynamic {
		if (this._data == value)
			return this._data;
		return this._data = value;
	}

	static public var SIZE:Float;

	public function new() {
		super();
		this.height = this.width = SIZE = 106.I();
	}

	override function initialize():Void {
		super.initialize();
		var theme = cast(Theme.getTheme(), OutlineTheme);
		this.layout = new AnchorLayout();
		this.backgroundSkin = theme.getButtonSkin(OutlineTheme.LIGHT_COLORS, 5, 26);

		var iconDisplay = new AssetLoader();
		iconDisplay.height = 40.I();
		iconDisplay.layoutData = AnchorLayoutData.topLeft(12.F(), 6.F());
		iconDisplay.source = this._data.icon;
		this.addChild(iconDisplay);

		var textDisplay = new Label();
		textDisplay.textFormat = theme.getTextFormat(0, 0, false, "center");
		textDisplay.text = this._data.text;
		textDisplay.layoutData = new AnchorLayoutData(13.F(), 8.F(), null, 30.F());
		this.addChild(textDisplay);

		var buttonDisplay = new LayoutGroup();
		buttonDisplay.height = 42.I();
		buttonDisplay.layout = new AnchorLayout();
		buttonDisplay.layoutData = new AnchorLayoutData(null, 8.I(), 15.I(), 8.I());
		buttonDisplay.backgroundSkin = theme.getButtonSkin(this._data.badge != null ? OutlineTheme.ORANGE_COLORS : OutlineTheme.GREEN_COLORS, 5, 18);
		this.addChild(buttonDisplay);

		var buttonText = new Label();
		buttonText.variant = OutlineTheme.VARIANT_LABEL_DETAILS_LIGHT;
		buttonText.text = "$ " + this._data.value;
		buttonText.layoutData = AnchorLayoutData.center(0, -4.F());
		buttonText.filters = [theme.getDefaultShadow(3.F())];
		buttonDisplay.addChild(buttonText);

		if (this._data.badge != null) {
			var badgeDisplay = new AssetLoader();
			badgeDisplay.height = 40.I();
			badgeDisplay.layoutData = AnchorLayoutData.topRight(-12.F(), -12.F());
			badgeDisplay.source = this._data.badge;
			this.addChild(badgeDisplay);
		}
	}
}
