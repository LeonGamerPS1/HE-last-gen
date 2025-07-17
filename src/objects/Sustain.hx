package objects;

import backend.NoteSkin.Skin;
import bindings.Glad;

class Sustain extends Sprite {
	public var parent:Note;
	public var skin:Skin;
	public var tail:Sprite;

	public function new(parent:Note) {
		super();
		this.parent = parent;

		tail = new Sprite(-3000, 3000);
		parent.sustain = this;
		reload(parent.skin.name);
	}

	function reload(arg:String) {
		skin = NoteSkin.getCachedSkin(arg);
		verticalWrap = Glad.REPEAT;
		texture = Texture.getCachedTex(Paths.image('notes/${skin.name}/' + skin.sheets.holds));
		antialiasing = skin.antialiasing;
		scale.set(skin.scale, skin.scale);
		sourceRect.height = texture.height;
		sourceRect.width = texture.width / 8;
		sourceRect.y = 0;
		sourceRect.x = (texture.width / 8) * (parent.data.data);
		dynamicOffset.y = sourceHeight * 0.5;

		tail.texture = Texture.getCachedTex(Paths.image('notes/${skin.name}/' + skin.sheets.holds));
		tail.antialiasing = skin.antialiasing;
		tail.scale.set(skin.scale, skin.scale);
		tail.sourceRect.height = texture.height;
		tail.sourceRect.width = texture.width / 8;
		tail.sourceRect.y = 0;
		tail.sourceRect.x = (tail.texture.width / 8) * (parent.data.data + 4);
		tail.dynamicOffset.y = tail.sourceHeight * 0.5;
		// dynamicOffset.x = sourceWidth * 0.5;
	}

	override function queueDraw() {
		var h:Float = parent.data.length;
		if (parent.hit) {
			h += (parent.data.time - Conductor.songPosition);
			parent.visible = false;
		}

		var lol:Float = h * 0.45 * parent.speed - tail.height;
		

		sourceRect.top = Math.min(-lol + texture.height, -lol) / scale.y;
		dynamicOffset.y = sourceHeight * 0.5;
		positionOffset.set(skin.susOffset[0], skin.susOffset[1]);
		tail.positionOffset.set(skin.susOffset[0], skin.susOffset[1]);
		super.queueDraw();
		
		tail.memberOf = memberOf;
		tail.position = position;
		tail.position.y;
		tail.rotation = rotation;
		tail.sourceRect.top = Math.max(-height, 0.0);
		tail.dynamicOffset.y = sourceHeight + tail.sourceRect.height * 0.5;
		visible = h > 0;
		tail.visible = visible;
	}

	public function pos() {
		position.set(parent.position.x + (parent.sourceWidth / 2 - sourceWidth / 2), parent.position.y + (parent.sourceHeight / 2));

		tint.a = parent.tint.a * 0.7;
		tail.tint.a = tint.a;
		if (!parent.downScroll)
			rotation = parent.rotation;
		else
			rotation = parent.rotation - 180;
	}

	override function destroy() {
		super.destroy();
		if (tail != null) {
			if (tail.memberOf != null)
				tail.memberOf.remove(tail);
			tail.destroy();
			tail = null;
		}
	}
}
