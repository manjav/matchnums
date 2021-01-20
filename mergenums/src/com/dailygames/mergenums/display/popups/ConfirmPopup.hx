package com.dailygames.mergenums.display.popups;

import feathers.controls.Label;
import feathers.layout.AnchorLayoutData;
import feathers.layout.ILayoutData;
import openfl.events.MouseEvent;

using com.dailygames.mergenums.themes.OutlineTheme;

class ConfirmPopup extends BasePopup {
	private var titleDisplay:Label;
	private var messageDisplay:Label;

	/**
		Title
	**/
	public var title(default, set):String;

	public function set_title(value:String):String {
		if (this.title == value)
			return value;
		this.title = value;
		this.setInvalid(InvalidationFlag.CUSTOM("title"));
		return value;
	}

	private function titleFactory():Void {
		this.labelFactory(this.titleDisplay, this.title, AnchorLayoutData.topLeft(-this.padding * 1.85, this.padding));
	}

	/**
		Message
	**/
	public var message(default, set):String;

	public function set_message(value:String):String {
		if (this.message == value)
			return value;
		this.message = value;
		this.setInvalid(InvalidationFlag.CUSTOM("message"));
		return value;
	}

	private function messageFactory():Void {
		this.labelFactory(this.messageDisplay, this.message, AnchorLayoutData.center(0, 0));
		if (this.messageDisplay == null)
			return;
		var textFormat = this.messageDisplay.textFormat;
		textFormat.align = CENTER;
		this.messageDisplay.textFormat = textFormat;
	}

	// Initialize
	override private function initialize():Void {
		super.initialize();
		this.hasCloseButton = true;
	}

	private function labelFactory(label:Label, data:String, layoutData:ILayoutData):Void {
		if (data == null) {
			if (label != null && label.parent != null)
				label.parent.removeChild(label);
			return;
		}

		if (label == null) {
			label = new Label();
			label.variant = OutlineTheme.VARIANT_LABEL_LIGHT;
			label.layoutData = layoutData;
		}
		label.text = data;
		if (label.parent == null)
			this.content.addChild(label);
	}

	private function addButton(name:String, message:String, variant:String, layoutData:AnchorLayoutData, width:Float):MessageButton {
		var button = new MessageButton();
		button.name = name;
		button.width = width;
		button.height = 80.F();
		button.message = message;
		button.icon = name;
		button.variant = variant;
		button.layoutData = layoutData;
		button.addEventListener(MouseEvent.CLICK, this.buttons_clickHandler);
		this.content.addChild(button);
		return button;
	}

	private function buttons_clickHandler(event:MouseEvent):Void {}

	override public function validateNow():Void {
		if (this.isInvalid(InvalidationFlag.CUSTOM("title")))
			this.titleFactory();
		if (this.isInvalid(InvalidationFlag.CUSTOM("message")))
			this.messageFactory();
		super.validateNow();
	}
}
