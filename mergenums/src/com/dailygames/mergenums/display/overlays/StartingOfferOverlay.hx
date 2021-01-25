package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.display.buttons.MessageButton;
import com.dailygames.mergenums.display.popups.ConfirmPopup;
import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.ILayoutData;
import feathers.style.Theme;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class StartingOfferOverlay extends ConfirmPopup {
	public var boostBig:BoostActivator;
	public var boostNext:BoostActivator;

	override private function initialize():Void {
		super.initialize();

		this.hasCloseButton = false;
		this.title = "Select Boost Items";

		this.boostBig = new BoostActivator("boost-big", "Start the game with block 512!", new AnchorLayoutData(14.I(), null, 102.I(), 14.I()));
		this.content.addChild(this.boostBig);
		this.boostNext = new BoostActivator("boost-next", "Preview the next upcoming block!", new AnchorLayoutData(14.I(), 14.I(), 102.I()));
		this.content.addChild(this.boostNext);

		this.addButton("continue", "Start", OutlineTheme.VARIANT_MBUTTON_BLUE, new AnchorLayoutData(null, 14.F(), 15.F(), 14.F()));
		this.addButton("noads", null, OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomCenter(-90.F()), 80.I(), 80.I());
	}

	override private function adjustContentLayout():Void {
		this.content.width = OutlineTheme.POPUP_SIZE * 1.05;
		this.content.height = OutlineTheme.POPUP_SIZE * 1.16;
		this.content.layoutData = AnchorLayoutData.center();
	}

	override private function titleFactory():Void {
		this.labelFactory(this.titleDisplay, this.title, AnchorLayoutData.topCenter(-this.padding * 1.65));
	}

	override private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		switch (button.name) {
			case "continue":
				close();
			case "noads":
				return;
		}
	}
}

class BoostActivator extends LayoutGroup {
	public var icon:String;
	public var text:String;
	public var active:Bool;
	public var coinButton:MessageButton;
	public var adsButton:MessageButton;

	public function new(icon:String, text:String, layoutData:AnchorLayoutData) {
		super();
		this.icon = icon;
		this.text = text;
		this.layoutData = layoutData;
		this.width = OutlineTheme.POPUP_SIZE * 0.475;
	}

	override private function initialize():Void {
		super.initialize();

		var theme = cast(Theme.getTheme(), OutlineTheme);

		this.layout = new AnchorLayout();
		this.layoutData = layoutData;
		this.backgroundSkin = theme.getButtonSkin();

		var iconDisplay = new AssetLoader();
		iconDisplay.height = 92.I();
		iconDisplay.source = icon;
		iconDisplay.layoutData = AnchorLayoutData.topCenter(12.I());
		this.addChild(iconDisplay);

		var textDisplay = new Label();
		textDisplay.text = text;
		textDisplay.wordWrap = true;
		textDisplay.variant = OutlineTheme.VARIANT_LABEL_DETAILS;
		textDisplay.layoutData= new AnchorLayoutData(null, 16.I(), 120.I(), 16.I());
		this.addChild(textDisplay);

		coinButton = addButton("coin", "100", OutlineTheme.VARIANT_MSBUTTON, new AnchorLayoutData(null, 24.I(), 68.I(), 24.I()));
		adsButton = addButton("ads", "Free", OutlineTheme.VARIANT_MSBUTTON_ORANGE, new AnchorLayoutData(null, 24.I(), 19.I(), 24.I()));
	}

	private function addButton(name:String, message:String, variant:String, layout:ILayoutData):MessageButton {
		var button = new MessageButton();
		button.icon = name;
		button.name = name;
		button.height = 40.I();
		button.message = message;
		button.variant = variant;
		button.layoutData = layout;
		button.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.addChild(button);
		return button;
	}

	private function buttons_clickHandler(event:MouseEvent):Void {
		var button = cast(event.currentTarget, MessageButton);
		switch (button.name) {
			case "coin":
				var newValue = Prefs.instance.get(Prefs.COIN) - 100;
				Prefs.instance.set(Prefs.COIN, newValue);
				if (newValue >= 0)
					this.updateButtons();
			case "ads":
				return;
		}
	}

	private function updateButtons():Void {
		this.coinButton.mouseEnabled = false;
		this.coinButton.alpha = 0.5;
		this.adsButton.mouseEnabled = false;
		this.adsButton.alpha = 0.5;
		this.active = true;
	}
}
