package com.grantech.matchnums.utils;

import openfl.Assets;
import openfl.media.Sound;

class Sounds {
	static private final map:Map<String, Sound> = new Map();

	static public function play(name:String):Void {
		if (!map.exists(name))
			map[name] = Assets.getSound("sounds/" + name + ".ogg");
		if (mute)
			return;
		if (map[name] != null)
			map[name].play();
	}

	static public var mute(default, default):Bool;
	// static private function set_mute(value:Bool):Bool {
	//     if (mute == value)
	//         return value;
	//     mute = value;
	// }
}
