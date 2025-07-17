package objects;

import backend.NoteSkin.Skin;
import math.Vector2;

class Strum extends AnimatedSprite {
	public var resetAnim:Float = 0.0;
	public var skin:Skin;

	static var dirs = ["left", "down", "up", "right"];

	public var downScroll:Bool = false;
	public var dir = 0;

	public function new(dir:Int = 0, ?skin:String = "default") {
		super();
		this.dir = dir;
		reload(skin);
	}

	public function reload(skin:String) {
		var skinData = NoteSkin.getCachedSkin(skin);
		if (skinData == null) {
			trace("Skin not found: " + skin);
			skinData = NoteSkin.getCachedSkin("default");
			return;
		}
		this.skin = skinData;
		loadFrames(Paths.sparrow('notes/$skin/' + skinData.sheets.strums));
		scale.set(skinData.scale, skinData.scale);
		antialiasing = skinData.antialiasing;

		addPrefixAnim('static', dirs[dir % dirs.length] + '0');
		addPrefixAnim('confirm', dirs[dir % dirs.length] + ' confirm');
		addPrefixAnim('hold', dirs[dir % dirs.length] + ' hold confirm');
		addPrefixAnim('press', dirs[dir % dirs.length] + ' press');

		playAnim('static', true);
	}

	override function playAnim(s:String, ?b:Bool = false) {
		super.playAnim(s, b);
		dynamicOffset.y = sourceHeight * 0.5;
		dynamicOffset.x = sourceWidth * 0.5;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (resetAnim > 0) {
			resetAnim -= elapsed;
			if (resetAnim < 0.001) {
				playAnim('static', true);
				resetAnim = 0;
			}
		}
	}
}
