package com.grantech.matchnums.events;

import lime.utils.ObjectPool;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

class GameEvent extends Event {

    static private var _pool = new ObjectPool<GameEvent>(() -> return new GameEvent(null, null, false, false));
    
	static public final RECORD_CHANGE:String = "recordChange";

	/**
		Dispatches a pooled event with the specified properties.
		```hx
		GameEvent.dispatch(component, Event.CHANGE);
		```
		@since 1.0.0
	**/
	static public function dispatch(dispatcher:IEventDispatcher, type:String, data:Dynamic = null, bubbles:Bool = false, cancelable:Bool = false):Bool {
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