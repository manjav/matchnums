package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.AssetLoader;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.VerticalLayout;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class StartingOfferOverlay extends BaseOverlay {
	public var hasBoostBig:Bool;
	public var hasBoostNext:Bool;
	private var boostBig:LayoutGroup;
	private var boostNext:LayoutGroup;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		var title = new Label();
		title.text = "Select Boost Item";
		title.layoutData = AnchorLayoutData.center(0, -this.padding * 8);
		this.addChild(title);

		this.boostBig = this.createBoost("boost-big", "Get 512 Block", AnchorLayoutData.center(-this.padding * 4.5));
		this.boostNext = this.createBoost("boost-next", "Show Next Block", AnchorLayoutData.center(this.padding * 4.5));

		var startButton = new Button();
		startButton.text = startButton.name = "Start";
		startButton.height = this.padding * 3;
		startButton.width = this.padding * 6;
		startButton.layoutData = AnchorLayoutData.center(0, this.padding * 8);
		startButton.addEventListener(MouseEvent.CLICK, this.startButton_clickHandler);
		this.addChild(startButton);
	}

	private function createBoost(icon:String, text:String, layoutData:AnchorLayoutData):LayoutGroup {
		var skin = new RectangleSkin();
		skin.fill = SolidColor(OutlineTheme.GRAY_COLOR, 1);
		skin.border = SolidColor(2.0 * OutlineTheme.SCALE_FACTOR, OutlineTheme.LIGHT_COLOR);
		skin.cornerRadius = 5.0;

		var layout = new VerticalLayout();
		layout.gap = layout.paddingTop = layout.paddingRight = layout.paddingBottom = layout.paddingLeft = padding * 0.4;
		layout.horizontalAlign = JUSTIFY;
		var boost = new LayoutGroup();
		boost.layout = layout;
		boost.width = this.padding * 8.5;
		boost.layoutData = layoutData;
		boost.backgroundSkin = skin;
		this.addChild(boost);
		
		var iconDisplay = new AssetLoader();
		iconDisplay.height = this.padding * 5;
		boost.addChild(iconDisplay);

		var theme = cast(Theme.getTheme(), OutlineTheme);
		var textDisplay = new Label();
		textDisplay.text = text;
		var format = theme.getTextFormat(Math.round(OutlineTheme.FONT_SIZE * 0.8));
		format.align = "center";
		textDisplay.textFormat = format;
		boost.addChild(textDisplay);

		var boostByCoin = new Button();
		boostByCoin.height = this.padding * 2;
		boostByCoin.name = icon;
		boostByCoin.text = " 100 ";
		boostByCoin.icon = new Bitmap(Assets.getBitmapData("coin"));
		boostByCoin.addEventListener(MouseEvent.CLICK, this.coinButton_clickHandler);
		boost.addChild(boostByCoin);

		var boostByAds = new Button();
		boostByAds.height = this.padding * 2;
		boostByAds.name = icon;
		boostByAds.text = " Free ";
		boostByAds.icon = new Bitmap(Assets.getBitmapData("ads"));
		boostByAds.addEventListener(MouseEvent.CLICK, this.adsButton_clickHandler);
		boost.addChild(boostByAds);

		return boost;
	}

	private function startButton_clickHandler(event:MouseEvent):Void {
		close();
	}

	private function coinButton_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		var newValue = Prefs.instance.get(Prefs.COIN) - 100;
		Prefs.instance.set(Prefs.COIN, newValue);
		if (newValue < 0)
			return;
		this.updateButtons(button.name);
	}

	private function adsButton_clickHandler(event:MouseEvent):Void {
		var button = cast(event.target, Button);
		this.updateButtons(button.name);
	}

	private function updateButtons(boostMode:String):Void {
		if (boostMode == "boost-big") {
			this.boostBig.mouseEnabled = false;
			this.boostBig.alpha = 0.5;
			this.hasBoostBig = true;
		} else if (boostMode == "boost-next") {
			this.boostNext.mouseEnabled = false;
			this.boostNext.alpha = 0.5;
			this.hasBoostNext = true;
		}
	}
}
