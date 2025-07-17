package backend;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

typedef Skin = {
	var scale:Float;
	var antialiasing:Bool;
	var sheets:{
		var strums:String;
		var notes:String;
		var holds:String;
	};
	@:optional var name:String;
	var noteoffset:Array<Float>;
	var susOffset:Array<Float>;
	var lineOffset:Array<Float>;
}

class NoteSkin {
	public static function getSkin(name:String):Skin {
		return Json.parse(File.getContent(Paths.getPath('images/notes/$name/data.json')));
	}

	static var cache:Map<String, Skin> = new Map();

	public static function getCachedSkin(name:String):Skin {
		if (cache.exists(name))
			return cache.get(name);

		var skin = getSkin(name);
		cache.set(name, skin);
		skin.name = name;
		return skin;
	}
}
