package com.dailygames.mergenums.utils;

import com.dailygames.mergenums.events.GameEvent;
import openfl.events.EventDispatcher;
import openfl.net.SharedObject;

class Prefs extends EventDispatcher {
	static public final COIN:String = "coin";
	static public final SCORES:String = "scores";
	static public final RECORD:String = "record";
	static public final REMOVE_ONE:String = "remove-one";
	static public final REMOVE_COLOR:String = "remove-color";
	static public final MUTE:String = "mute";

	static public final instance:Prefs = new Prefs();

	private var map:Map<String, Float>;

	public function set(type:String, value:Float, save:Bool = true):Float {
		if (this.get(type) == value)
			return value;
		if (value < 0) {
			GameEvent.dispatch(this, type, value);
			return value;
		}
		this.map.set(type, value);
		GameEvent.dispatch(this, type, value);
		if (save && type != SCORES)
			this.save();
		return value;
	}

	public function increase(type:String, value:Float, save:Bool = true):Float {
		return this.set(type, this.get(type) + value, save);
	}
	
	public function reduce(type:String, value:Float, save:Bool = true):Float {
		return this.set(type, this.get(type) - value, save);
	}

	public function get(type:String):Float {
		return this.map.get(type);
	}

	public function new() {
		super();
	}

	public function load():Void {
		var so:SharedObject = SharedObject.getLocal("prefs");
		// so.clear();
		this.map = new Map();
		this.set(SCORES, 0.0);
		if (so.data.coin == null) {
			this.set(COIN, 500.0);
			this.set(RECORD, 0.0);
			this.set(REMOVE_ONE, 3);
			this.set(REMOVE_COLOR, 3);
			return;
		}
		this.set(COIN, cast(so.data.coin, Float), false);
		this.set(RECORD, cast(so.data.record, Float), false);
		this.set(REMOVE_ONE, cast(so.data.removeOne, Float), false);
		this.set(REMOVE_COLOR, cast(so.data.removeColor, Float), false);
}

	private function save():Void {
		var so = SharedObject.getLocal("prefs");
		so.data.coin = this.get(COIN);
		so.data.record = this.get(RECORD);
		so.data.removeOne = this.get(REMOVE_ONE);
		so.data.removeColor = this.get(REMOVE_COLOR);
	so.flush(100000);
	}

	private function clear():Void {
		var so = SharedObject.getLocal("prefs");
		so.clear();
	}
}
