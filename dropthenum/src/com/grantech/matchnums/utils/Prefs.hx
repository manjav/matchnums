package com.grantech.matchnums.utils;

import openfl.net.SharedObject;

class Prefs extends EventDispatcher {
	static public final instance:Prefs = new Prefs();

	public var record(default, set):Int = 0;

	public function set_record(value:Int):Int {
		if (this.record == value)
			return value;
		this.record = value;
		this.save();
		return value;
	}

	public function new() {}

	public function load():Void {
		var so:SharedObject = SharedObject.getLocal("prefs");
		if (so.data.record == null)
			return;
		this.record = so.data.record;
	}

	public function save():Void {
		var so = SharedObject.getLocal("prefs");
		so.data.record = this.record;
		so.flush(100000);
	}

	public function clear():Void {
		var so = SharedObject.getLocal("prefs");
		so.clear();
	}
}
