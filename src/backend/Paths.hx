package backend;

import sys.FileSystem;

class Paths {
	public static var currentMod:String = "null"; // if not null, paths start with mods/modname/path/to/shit else assets/path/to/shit

	public static function getPath(path:String):String {
		trace('mods/$currentMod/$path');
		if (!FileSystem.exists('mods/$currentMod/$path'))
			return 'assets/$path';

		return 'mods/$currentMod/$path';
	}

	public static function font(s:String) {
		return getPath('fonts/$s');
	}
}
