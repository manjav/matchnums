package com.grantech.matchnums;
import openfl.display.Sprite;

class Game extends Sprite {
	public function new() {
		super();

		var background = new Sprite();
		background.graphics.beginFill(0xFFFFFF, 0.4);
		background.graphics.drawRect(0, 0, 176 * NUM_COLUMNS, 176 * NUM_ROWS);
		// background.filters = [new BlurFilter(10, 10)];
		this.addChild(background);

        
        this.addEventListener(MouseEvent.CLICK, this_clickHandler);
    }
    
    private function this_clickHandler(evetn:MouseEvent):void {
        
    }

	public function resize(newWidth:Int, newHeight:Int):Void {
	}
}
