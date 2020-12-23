package com.grantech.matchnums.utils;

import openfl.Assets;
import openfl.media.Sound;

class Sounds {
	static private final map:Map<String, Sound> = new Map();

	static public function play(name:String):Void {
		if (!map.exists(name))
			map[name] = Assets.getSound("sounds/" + name + ".ogg");
		if (map[name] != null)
			map[name].play();
	}
}
