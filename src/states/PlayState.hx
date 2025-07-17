package states;

import cpp.Star;
import backend.Song.SongMap;
import objects.Strum;
import bindings.Glad;

class PlayState extends Scene {
	public var strumlines:Group = new Group();
	public var cpuStrumline:Strumline;
	public var playerStrumline:Strumline;

	public static var song:SongMap;

	public var inst:SoundPlayer;

	@:unreflective // fuck you modders! I wont allow you to add them in here... sync them on ur own !!
	public var tracks:Array<SoundPlayer> = [];
	public var thing:Text;
	public var downScroll:Bool = false;

	public var hud:Group;
	public var hudCamera:Camera;

	public function new() {
		super();

		song ??= Song.grabSong();
		Conductor.setBPM(song.bpm);
		Conductor.updatePosition(-Conductor.msPerBeat * 5);
		Conductor.onBeat = beat;
		Conductor.onMeasure = section;
		Conductor.onStep = step;

		mainCamera.targetLerp = 0.05 * 60;

		hud = new Group();
		hudCamera = new Camera();
		hud.cameras = [hudCamera];

		inst = new SoundPlayer(Paths.getPath(song.tracks.main));
		for (track in song.tracks.extra)
			tracks.push(new SoundPlayer(Paths.getPath(track)));
		add(hud);

		strumlines = new Group();
		hud.add(strumlines);
		var skin = song.skin ?? 'default';
		cpuStrumline = new Strumline({x: 50, y: !downScroll ? 0 : 720 - 160}, skin, downScroll);
		cpuStrumline.cpu = true;
		strumlines.add(cpuStrumline);

		playerStrumline = new Strumline({x: 1280 / 2 + 50, y: cpuStrumline.position.y}, skin, downScroll);
		strumlines.add(playerStrumline);

		Conductor.onBeat = beat;
		for (line in strumlines.members)
			cast(line, Strumline).speed = song.speed;
	
		thing = new Text(100, 720 - (10 / 2), Paths.font('vcr.ttf'), 10, '');
		add(thing);
		gen();
		startCountdown();
	}

	function gen() {
		for (note in song.notes) {
			var strumline:Strumline = cast strumlines.members[note.strumLine % strumlines.members.length];
			var strum:Strum = cast strumline.strums.members[note.data % strumline.strums.members.length];
			var note:Note = new Note(note, strum.skin.name);
			strumline.unspawnNotes.push(note);
		}
	}

	@:unreflective
	public var startedSong:Bool = false;

	@:unreflective
	public var startedCountdown:Bool = false;

	public function startCountdown() {
		startedCountdown = true;
	}

	override function update(elapsed:Float) {
		if (startedCountdown && !startedSong) {
			Conductor.updatePosition(Conductor.songPosition + (elapsed * 1000));
			if (Conductor.songPosition >= 0)
				startSong();
		} else {
			Conductor.updatePosition(inst.time * 1000);
		}
		thing.text = Std.string(Conductor.getBeat());
		hudCamera.zoom.x = MathExtras.lerp(1.0,hudCamera.zoom.x,Math.exp(-elapsed * 5));
		hudCamera.zoom.y = hudCamera.zoom.x;
		super.update(elapsed);
	}

	function startSong() {
		startedSong = true;
		inst.play(0);

		for (billySillyTrillyMillyFillyTillyGilly in tracks)
			billySillyTrillyMillyFillyTillyGilly.play();
	}

	public function beat(v:Float) {
		for (i in strumlines.members)
			cast(i, Strumline).beat(v);
	}

	public function step(v:Float) {}

	public function section(v:Float) {
		hudCamera.zoom += 0.05;
	}
}
