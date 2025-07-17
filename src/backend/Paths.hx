package backend;

import sys.io.File;
import sys.FileSystem;

class Paths {
	public static var currentMod:String = "null"; // if not null, paths start with mods/modname/path/to/shit else assets/path/to/shit

	public static function getPath(path:String):String {
		if (!FileSystem.exists('mods/$currentMod/$path'))
			return 'assets/$path';

		return 'mods/$currentMod/$path';
	}

	public static function font(s:String) {
		return getPath('fonts/$s');
	}

	public static function image(s:String) {
		return getPath('images/$s.png');
	}

	public static function sound(s:String) {
		return getPath('sounds/$s.ogg');
	}

	public static function sparrow(s:String) {
		return getPath('images/$s.xml');
	}

	public static function music(s:String) {
		return getPath('music/$s.ogg');
	}

	public static function txt(s:String) {
		return getPath('data/$s.txt');
	}

	public static function exists(file:String) {
		return FileSystem.exists(getPath(file));
	}

	public static function getText(path:String) {
		return File.getContent(getPath(path));
	}
}
