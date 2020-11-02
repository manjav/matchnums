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
		this.game.state = Pause;
	}

	public function resume():Void {
		this.game.state = Play;
	}
}
