package com.dailygames.mergenums.display.overlays;

import feathers.skins.RectangleSkin;
import com.dailygames.mergenums.display.items.ShopItemRenderer;
import com.dailygames.mergenums.display.popups.ConfirmPopup;
import com.dailygames.mergenums.utils.Prefs;
import extension.iap.IAP;
import extension.iap.IAPEvent;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.ILayoutData;
import feathers.layout.TileLayout;
import feathers.utils.DisplayObjectRecycler;
import haxe.Json;
import openfl.Assets;
import openfl.events.Event;

using com.dailygames.mergenums.themes.OutlineTheme;

class ShopOverlay extends ConfirmPopup {
	private var listView:ListView;

	override private function initialize():Void {
		super.initialize();
		this.title = "Shop";

		IAP.instance.initialize("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg9aRTVrhDhV2Uv1K0X++jku5ajqAYdEegvUIT664mAAJE/SumeKneaz69GI1chtRoi+u7B7FqJd3X4t3FHo8s41AgvHlDs4XviMCXxkZew69lUMlte84OdS0AmN8RN0R7Z9wkIHsT9oM0eIT7pgOesFnkyVwuOQmoPNz0xSRcCjr3rTnfojQ+CbSSqWUwYngroVR6bCwrg6B09GHIrvu7D5gZEGvbRG31m4MKN/kUY87kWyri0Hr5yMcpbveUj6e0rcR9EJDkKiQqVvJ2OeaIfW/ijUmiJ387F+I5/qI6n7rHoF5HpFpm7D3x4HJJNTakWACu9OUBVGGFlmEJgQDGQIDAQAB");
		this.layout = new AnchorLayout();

		var header = HomeOverlay.createHeader(null);
		header.layoutData = new AnchorLayoutData(24.I(), 0, null, 0);
		this.addChild(header);

		var config = Json.parse(Assets.getText("texts/configs.json"));
		var listLayout = new TileLayout();
		listLayout.paddingTop = 22.I();
		listLayout.paddingRight = listLayout.paddingLeft = 8.I();
		listLayout.horizontalGap = 5.I();
		listLayout.verticalGap = 7.I();

		this.listView = new ListView();
		this.listView.layout = listLayout;
		this.listView.backgroundSkin = null;
		this.listView.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this.listView.itemRendererRecycler = DisplayObjectRecycler.withClass(ShopItemRenderer);
		this.listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.listView.dataProvider = new ArrayCollection(config.shop.items);
		this.listView.addEventListener(Event.CHANGE, this.listView_changeHandler);
		// this.listView.addEventListener(ListViewEvent.ITEM_TRIGGER, this.listView_itemTriggerHandler);
		this.content.addChild(this.listView);

		this.createLine(config.shop.noads, new AnchorLayoutData(254.I(), 10.I(), null, 10.I()));

		var skin = new RectangleSkin();
		skin.cornerRadius = 4.F();
		skin.fill = SolidColor(0x434343a);
		var divider = new LayoutGroup();
		divider.backgroundSkin = skin;
		divider.width = 48.I();
		divider.height = 8.I();
		divider.layoutData = AnchorLayoutData.bottomCenter(125.I());
		this.content.addChild(divider);

		this.addButton("ads", "100", OutlineTheme.VARIANT_MBUTTON_ORANGE, AnchorLayoutData.bottomRight(24.F(), 18.F()), 126.F()).text = "Free";
		addButton("restart", "Purchased", OutlineTheme.VARIANT_MBUTTON_GREEN, AnchorLayoutData.bottomLeft(24.F(), 18.F()), 174.F()).text = "Restore";
	}

	override private function adjustContentLayout():Void {
		this.content.width = OutlineTheme.POPUP_SIZE * 1.08;
		this.content.height = OutlineTheme.POPUP_SIZE * 1.50;
		this.content.layoutData = AnchorLayoutData.center(0, 50.I());
	}

	private function createLine(data:Dynamic, layoutData:ILayoutData):Void {
		var theme = cast(feathers.style.Theme.getTheme(), OutlineTheme);

		var item = new LayoutGroup();
		item.height = 74.I();
		item.layoutData = layoutData;
		item.layout = new AnchorLayout();
		item.backgroundSkin = theme.getButtonSkin(OutlineTheme.LIGHT_COLORS, 5, 26);
		this.content.addChild(item);

		var iconDisplay = new AssetLoader();
		iconDisplay.height = 52.I();
		iconDisplay.layoutData = AnchorLayoutData.middleLeft(-1.F(), 10.F());
		iconDisplay.source = data.icon;
		item.addChild(iconDisplay);

		var textDisplay = new Label();
		textDisplay.text = data.text;
		textDisplay.textFormat = theme.getTextFormat(0, 0, false, "center");
		textDisplay.layoutData = AnchorLayoutData.middleLeft(-4.F(), 80.F());
		item.addChild(textDisplay);

		var buttonDisplay = new LayoutGroup();
		buttonDisplay.layout = new AnchorLayout();
		buttonDisplay.backgroundSkin = theme.getButtonSkin(OutlineTheme.GREEN_COLORS, 5, 18);
		buttonDisplay.width = 88.I();
		buttonDisplay.height = 42.I();
		buttonDisplay.layoutData = AnchorLayoutData.middleRight(-3.F(), 16.F());
		item.addChild(buttonDisplay);

		var buttonText = new Label();
		buttonText.variant = OutlineTheme.VARIANT_LABEL_DETAILS_LIGHT;
		buttonText.text = "$ " + data.value;
		buttonText.layoutData = AnchorLayoutData.center(0, -4.F());
		buttonText.filters = [theme.getDefaultShadow(3.F())];
		buttonDisplay.addChild(buttonText);
	}

	private function listView_changeHandler(event:Event):Void {
		this.listView.removeEventListener(Event.CHANGE, this.listView_changeHandler);
		var text:String = this.listView.selectedItem.text;
		if (text == "Ads Free") {
			trace("Show Ad.");
		} else {
			IAP.instance.addEventListener(IAPEvent.PURCHASE_SUCCESS, IAP_purchaseSuccessHandler);
			IAP.instance.purchase("item_" + this.listView.selectedIndex);
		}
		this.listView.selectedIndex = -1;
		this.listView.addEventListener(Event.CHANGE, this.listView_changeHandler);
	}

	private function IAP_purchaseSuccessHandler(event:IAPEvent):Void {
		IAP.instance.removeEventListener(IAPEvent.PURCHASE_SUCCESS, IAP_purchaseSuccessHandler);
		IAP.instance.addEventListener(IAPEvent.PURCHASE_CONSUME_SUCCESS, IAP_consumeSuccessHandler);
		IAP.instance.consume(event.purchase);
	}

	private function IAP_consumeSuccessHandler(event:IAPEvent):Void {
		trace(event);
		IAP.instance.removeEventListener(IAPEvent.PURCHASE_CONSUME_SUCCESS, IAP_consumeSuccessHandler);
		Prefs.instance.increase(Prefs.COIN, 100); // Std.parseFloat(text));
	}
}
