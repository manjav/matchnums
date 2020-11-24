package com.grantech.matchnums.display.overlays;

import com.grantech.matchnums.display.items.ShopItemRenderer;
import com.grantech.matchnums.themes.OutlineTheme;
import com.grantech.matchnums.utils.Utils;
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
import openfl.events.MouseEvent;

class ShopOverlay extends BaseOverlay {
	private var listView:ListView;
	private var coinsIndicator:Indicator;

	override private function initialize():Void {
		super.initialize();

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
		// this.listView.addEventListener(Event.CHANGE, listView_changeHandler);
		// this.listView.addEventListener(ListViewEvent.ITEM_TRIGGER, listView_itemTriggerHandler);
		this.addChild(this.listView);

		// var coinsIcon = new Bitmap(Assets.getBitmapData("images/coin.png"));
		this.coinsIndicator = new Indicator();
		this.coinsIndicator.icon = new Bitmap(Assets.getBitmapData("images/coin-small.png"));
		this.coinsIndicator.format = function(value:Float):String {
			return " " + Utils.toCurrency(value) + " +";
		}
		this.coinsIndicator.value = 1200;
		this.coinsIndicator.layoutData = AnchorLayoutData.topLeft(Cell.BORDER, Cell.BORDER);
		this.addChild(this.coinsIndicator);

		var closeButton = new Button();
		closeButton.variant = OutlineTheme.VARIANT_BUTTON_CLOSE;
		closeButton.layoutData = AnchorLayoutData.topRight(this.padding, this.padding);
		closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		this.addChild(closeButton);
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
