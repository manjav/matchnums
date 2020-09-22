package com.grantech.matchnums.utils;

import openfl.net.SharedObject;

class Prefs {
	public static final instance:Prefs = new Prefs();

	public var record:Int = 0;

	public function new() {}

	public function load():Void {
		var so:SharedObject = SharedObject.getLocal("prefs");
		if (so.data.record == null)
			return;
		this.record = so.data.record;
	}

	public function save():Void {
		var so = SharedObject.getLocal("prefs");
		so.data.score = this.record;
		so.flush(100000);
	}

	public function clear():Void {
		var so = SharedObject.getLocal("prefs");
		so.clear();
	}
}
