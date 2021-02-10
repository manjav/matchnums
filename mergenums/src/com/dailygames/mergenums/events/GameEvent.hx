package com.dailygames.mergenums.events;

import lime.utils.ObjectPool;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

class GameEvent extends Event {
	static private var _pool = new ObjectPool<GameEvent>(() -> return new GameEvent(null, null, false, false));

	static public final SPAWN:String = "spawn";
	static public final GAME_OVER:String = "gameOver";
	static public final BIG_VALUE:String = "bigValue";
	static public final NEW_RECORD:String = "newRecord";
	static public final REVIVE_BY_COIN:String = "reviveByCoin";
	static public final REVIVE_BY_ADS:String = "reviveByAds";
	static public final REVIVE_CANCEL:String = "reviveCancel";
	static public final NEXT_CELL:String = "nextCell";
	static public final ADS_READY:String = "adsReady";

	/**
		Dispatches a pooled event with the specified properties.
		```hx
		GameEvent.dispatch(component, Event.CHANGE);
		```
		@since 1.0.0
	**/
	static public function dispatch(dispatcher:IEventDispatcher, type:String, data:Dynamic = null, bubbles:Bool = false, cancelable:Bool = false):Bool {
		if(!dispatcher.hasEventListener(type))
			return false;
		#if flash
		var event = new GameEvent(type, data, bubbles, cancelable);
		return dispatcher.dispatchEvent(event);
		#else
		var event = _pool.get();
		event.type = type;
		event.data = data;
		event.bubbles = bubbles;
		event.cancelable = cancelable;
		var result = dispatcher.dispatchEvent(event);
		_pool.release(event);
		return result;
		#end
	}

	public var data:Dynamic;

	/**
		Creates a new `GameEvent` object with the given arguments.

		@see `GameEvent.dispatch`

		@since 1.0.0
	**/
	public function new(type:String, data:Dynamic = null, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
		this.data = data;
	}

	override public function clone():Event {
		return new GameEvent(this.type, this.data, this.bubbles, this.cancelable);
	}
}
