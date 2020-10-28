import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayoutData;
enum ScreenType {
	Pause;
	Ads;
}

class BaseScreen extends LayoutGroup {
	static public function create(screenType:ScreenType):BaseScreen {
		var screen = switch (screenType) {
			case Pause:
				new PuaseScreen();
			default: null;
		}
		screen.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		return screen;
	}

