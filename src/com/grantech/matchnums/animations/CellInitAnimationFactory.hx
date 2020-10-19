class CellInitAnimationFactory implements IAnimationFactory {
	public function new() {}

	public function call(?parameters:Array<Dynamic>):Void {
		var cell = cast(parameters[0], Cell);
		var handler = parameters[1];

		if (handler != null)
			ease.onComplete(handler);

	}
}
