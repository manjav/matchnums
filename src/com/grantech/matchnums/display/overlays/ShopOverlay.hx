package com.grantech.matchnums.display.overlays;

import com.grantech.matchnums.themes.OutlineTheme;
import feathers.controls.Button;
import feathers.controls.ListView;
import feathers.data.ArrayCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.events.MouseEvent;

class ShopOverlay extends BaseOverlay {
	private var listView:ListView;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		var items = [];
		for (i in 0...8) {
			items[i] = {text: "List Item " + (i + 1)};
		}

		var listLayout = new VerticalLayout();
		listLayout.horizontalAlign = JUSTIFY;
		listLayout.gap = padding;

		this.listView = new ListView();
		this.listView.layout = listLayout;
		this.listView.backgroundSkin = null;
		this.listView.layoutData = new AnchorLayoutData(100, padding, padding, padding);
		this.listView.itemRendererRecycler = DisplayObjectRecycler.withClass(ShopItemRenderer);
		this.listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.listView.dataProvider = new ArrayCollection(items);
		// this.listView.addEventListener(Event.CHANGE, listView_changeHandler);
		// this.listView.addEventListener(ListViewEvent.ITEM_TRIGGER, listView_itemTriggerHandler);
		this.addChild(this.listView);

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
