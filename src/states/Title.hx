package states;

class Title extends Scene {
	public function new() {
		super();

		var text:Text = new Text(0, 0, Paths.font('vcr.ttf'),20,'poop');
		text.position.set(50,50);
		add(text);
	}
}
