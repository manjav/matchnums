package com.dailygames.mergenums.display;

import openfl.events.MouseEvent;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

using com.dailygames.mergenums.themes.OutlineTheme;

@:styleContext
class MessageButton extends LayoutGroup {
	public var padding = 12.I();

	public var textDisplay:Label;
	public var messageDisplay:Label;
	private var iconDisplay:AssetLoader;
	private var _text:String;
	private var _message:String;
	private var _icon:String;

	// public var textVariant(default, set):String;

	// private function set_textVariant(value:String):String {
	// 	if (this.textVariant == value)
	// 		return value;
	// 	this.textVariant = value;
	// 	if (textDisplay != null)
	// 		textDisplay.variant = value;
	// 	return value;
	// }

	// public var messageVariant(default, set):String;

	// private function set_messageVariant(value:String):String {
	// 	if (this.messageVariant == value)
	// 		return value;
	// 	this.messageVariant = value;
	// 	if (messageDisplay != null)
	// 		messageDisplay.variant = value;
	// 	return value;
	// }

	/**
		The text displayed by the button.
		The following example sets the button's message:
		```hx
		button.text = "Its button's messeage";
		```

		@default null
		@see `Button.textFormat`
		@since 1.0.0
	**/
	public var text(get, set):String;

	private function get_text():String {
		return this._text;
	}

	private function set_text(value:String):String {
		if (this._text == value)
			return this._text;
		this._text = value;
		if (textDisplay != null)
			textDisplay.text = _text;
		return this._text;
	}

	/**
		The text displayed by the button.
		The following example sets the button's message:
		```hx
		button.message = "Its button's messeage";
		```

		@default null
		@see `Button.textFormat`
		@since 1.0.0
	**/
	@:flash.property
	public var message(get, set):String;

	private function get_message():String {
		return this._message;
	}

	private function set_message(value:String):String {
		if (this._message == value)
			return this._message;
		this._message = value;
		if (messageDisplay != null)
			messageDisplay.text = _message;
		return this._message;
	}

	public var icon(get, set):String;

	private function get_icon():String {
		return this._icon;
	}

	private function set_icon(value:String):String {
		if (this._icon == value)
			return this._icon;
		this._icon = value;
		if (iconDisplay != null)
			iconDisplay.source = icon;
		return this._icon;
	}

	override private function initialize() {
		super.initialize();

		layout = new AnchorLayout();
		this.buttonMode = true;
		this.mouseEnabled = true;
		this.mouseChildren = true;

		this.iconDisplay = new AssetLoader();
		this.iconDisplay.layoutData = AnchorLayoutData.middleLeft(0, padding);
		this.iconDisplay.width = 60.I();
		this.iconDisplay.source = this.icon;
		this.addChild(this.iconDisplay);

		this.textDisplay = new Label();
		// this.textDisplay.variant = textVariant;
		this.textDisplay.layoutData = AnchorLayoutData.middleLeft(-padding * 1.3, 70);
		this.textDisplay.text = this.text;
		this.addChild(this.textDisplay);

		this.messageDisplay = new Label();
		// this.messageDisplay.variant = messageVariant;
		this.messageDisplay.layoutData = AnchorLayoutData.middleLeft(padding * 1.3, 70);
		this.messageDisplay.text = this.message;
		this.addChild(this.messageDisplay);
	}
}
