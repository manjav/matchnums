package com.dailygames.mergenums.utils;

import openfl.media.SoundTransform;
import openfl.Assets;
import openfl.media.Sound;

class Sounds {
	static private final map:Map<String, Sound> = new Map();

	static public function play(name:String, volume:Float = 1.0):Void {
		if (!map.exists(name))
			map[name] = Assets.getSound("sounds/" + name + ".ogg");
		if (mute)
			return;
		if (map[name] == null)
			return;

		var channel = map[name].play();
		if (volume < 1)
			channel.soundTransform = new SoundTransform(volume);
	}

	static public var mute(default, default):Bool;
	// static private function set_mute(value:Bool):Bool {
	//     if (mute == value)
	//         return value;
	//     mute = value;
	// }
}
