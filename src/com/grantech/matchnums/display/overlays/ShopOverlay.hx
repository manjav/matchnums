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

		this.listView = new ListView();
		this.listView.dataProvider = new ArrayCollection(items);
		this.listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		this.listView.layoutData = AnchorLayoutData.fill();
		this.listView.backgroundSkin = null;
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
}
