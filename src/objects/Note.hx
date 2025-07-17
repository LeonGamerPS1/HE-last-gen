package objects;

import backend.Song.NoteData;
import backend.NoteSkin.Skin;
import math.Vector2;

class Note extends Sprite {
	public var skin:Skin;
	public var data:NoteData;
	public var hit:Bool = false;
	public var speed:Float = 1;
	public var sustain:Sustain;
	public var downScroll:Bool = false;

	public function new(data:NoteData, ?skin:String = "default") {
		super();
		this.data = data;
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
		texture = Texture.getCachedTex(Paths.image('notes/$skin/' + skinData.sheets.notes));


		sourceRect.x = texture.width / 4 * (data.data % 4);
		sourceRect.y = 0;
		sourceRect.width = texture.width / 4;
		sourceRect.height = texture.height;
		antialiasing = skinData.antialiasing;
		scale.set(skinData.scale, skinData.scale);
		positionOffset.set(skinData.noteoffset[0],skinData.noteoffset[1]);
		dynamicOffset.y = sourceHeight * 0.5;
		dynamicOffset.x = sourceWidth * 0.5;
	}
}
