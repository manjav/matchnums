package com.grantech.matchnums.screens;

import feathers.layout.AnchorLayout;
import openfl.events.MouseEvent;

class HomeScreen extends BaseScreen {
	private var game:Game;

	override private function initialize():Void {
		super.initialize();

		this.layout = new AnchorLayout();

		this.game = new Game();
		this.addChild(this.game);
	}

	public function pause():Void {
	}

	public function resume():Void {
	}
}
