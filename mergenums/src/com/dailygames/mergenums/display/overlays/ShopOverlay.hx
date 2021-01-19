package com.dailygames.mergenums.display.overlays;

import com.dailygames.mergenums.display.items.ShopItemRenderer;
import com.dailygames.mergenums.themes.OutlineTheme;
import com.dailygames.mergenums.utils.Prefs.*;
import com.dailygames.mergenums.utils.Prefs;
import com.dailygames.mergenums.utils.Utils;
import extension.iap.IAP;
import extension.iap.IAPEvent;
import feathers.controls.Button;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.VerticalLayout;
import feathers.skins.RectangleSkin;
import feathers.utils.DisplayObjectRecycler;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.MouseEvent;

class ShopOverlay extends BaseOverlay {
	private var listView:ListView;
	private var coinsIndicator:Indicator;

	override private function initialize():Void {
		super.initialize();

		IAP.instance.initialize("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg9aRTVrhDhV2Uv1K0X++jku5ajqAYdEegvUIT664mAAJE/SumeKneaz69GI1chtRoi+u7B7FqJd3X4t3FHo8s41AgvHlDs4XviMCXxkZew69lUMlte84OdS0AmN8RN0R7Z9wkIHsT9oM0eIT7pgOesFnkyVwuOQmoPNz0xSRcCjr3rTnfojQ+CbSSqWUwYngroVR6bCwrg6B09GHIrvu7D5gZEGvbRG31m4MKN/kUY87kWyri0Hr5yMcpbveUj6e0rcR9EJDkKiQqVvJ2OeaIfW/ijUmiJ387F+I5/qI6n7rHoF5HpFpm7D3x4HJJNTakWACu9OUBVGGFlmEJgQDGQIDAQAB");
		this.layout = new AnchorLayout();

		var config = Json.parse(Assets.getText("texts/configs.json"));
		var listLayout = new VerticalLayout();
		listLayout.horizontalAlign = JUSTIFY;
		listLayout.verticalAlign = MIDDLE;
		listLayout.gap = padding;

		this.listView = new ListView();
		this.listView.layout = listLayout;
		this.listView.backgroundSkin = null;
		this.listView.layoutData = AnchorLayoutData.fill(padding);
		this.listView.itemRendererRecycler = DisplayObjectRecycler.withClass(ShopItemRenderer);
		this.listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.listView.dataProvider = new ArrayCollection(config.shop.items);
		this.listView.addEventListener(Event.CHANGE, this.listView_changeHandler);
		// this.listView.addEventListener(ListViewEvent.ITEM_TRIGGER, this.listView_itemTriggerHandler);
		this.addChild(this.listView);

		this.coinsIndicator = new Indicator();
		this.coinsIndicator.icon = "coin";
		this.coinsIndicator.format = function(value:Float):String {
			return " " + Utils.toCurrency(value) + " +";
		}
		this.coinsIndicator.type = COIN;
		this.coinsIndicator.layoutData = AnchorLayoutData.topLeft(Cell.BORDER, Cell.BORDER);
		this.addChild(this.coinsIndicator);

		var closeButton = new Button();
		closeButton.variant = OutlineTheme.VARIANT_BUTTON_CLOSE;
		closeButton.layoutData = AnchorLayoutData.topRight(this.padding, this.padding);
		closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		this.addChild(closeButton);
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
		Prefs.instance.increase(Prefs.COIN, 100);//Std.parseFloat(text));
	}

	private function closeButton_clickHandler(event:MouseEvent):Void {
		this.close();
	}

	override private function overlayFactory():Void {
		this.overlay = new RectangleSkin();
		this.overlay.fill = SolidColor(0x000000, 0.9);
		this.backgroundSkin = this.overlay;
	}
}
