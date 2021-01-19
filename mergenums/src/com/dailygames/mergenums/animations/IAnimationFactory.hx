package com.dailygames.mergenums.animations;

interface IAnimationFactory {
	var scale(default, default):Float;
	var time(default, default):Float;
	var delay(default, default):Float;
	function call(?parameters:Array<Dynamic>):Void;
}
