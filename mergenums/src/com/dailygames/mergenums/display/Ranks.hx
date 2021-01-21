package com.dailygames.mergenums.display;

import com.dailygames.mergenums.utils.Prefs;
import feathers.controls.AssetLoader;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;

using com.dailygames.mergenums.themes.OutlineTheme;

class Ranks extends LayoutGroup {
	private var recordDisplay:Label;
	private var scoreDisplay:Label;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		var crown = new AssetLoader();
		crown.source = "crown";
		crown.width = 20.F();
		crown.layoutData = AnchorLayoutData.topLeft();
		this.addChild(crown);

		this.recordDisplay = new Label();
		this.recordDisplay.variant = OutlineTheme.VARIANT_LABEL_SMALL_LIGHT;
		this.recordDisplay.layoutData = AnchorLayoutData.topLeft(0, 22.F());
		this.addChild(this.recordDisplay);

		this.scoreDisplay = new Label();
		this.scoreDisplay.variant = OutlineTheme.VARIANT_LABEL_MEDIUM_LIGHT;
		this.scoreDisplay.layoutData = AnchorLayoutData.topCenter(18.F());
		this.addChild(scoreDisplay);

		this.updateData();
	}

	public function updateData():Void {
		this.recordDisplay.text = Std.string(Prefs.instance.get(Prefs.RECORD));
		this.scoreDisplay.text = Std.string(Prefs.instance.get(Prefs.SCORES));
	}
}
