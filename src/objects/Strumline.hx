package objects;

class Strumline extends Group {
	public var cpu:Bool = false;
	public var strums:Group = new Group();
	public var notes:Group = new Group();
	public var sustains:Group = new Group();
	public var unspawnNotes:Array<Note> = [];
	public var speed:Float = 1;
	public var downScroll:Bool = false;

	public function new(strumPos:{x:Float, y:Float}, ?skin:String = "default", ?d:Bool = false) {
		super();
		position.set(strumPos.x, strumPos.y);
		this.downScroll = d;
		generateStrums(skin);

		add(strums);
		add(sustains);
		add(notes);
	}

	@:unreflective
	function generateStrums(skin:String = 'default') {
		var strumCount = 4;
		for (i in 0...strumCount) {
			var strum = new Strum(i, skin);
			strum.position.y = 0 + strum.skin.lineOffset[1];
			strum.position.x = (160 * 0.7 * i) + strum.skin.lineOffset[0];
			strum.downScroll = downScroll;
			strums.add(strum);
		}
	}

	override function update(elapsed:Float) {
		if (unspawnNotes[0] != null && unspawnNotes[0].data.time <= Conductor.songPosition + (2000 / speed)) {
			var note:Note = unspawnNotes[0];
			note.position.x = -1000;
			unspawnNotes.remove(note);
			notes.add(note);
			if (note.data.length > 0) {
				var sustain:Sustain = (note.sustain = new Sustain(note));
				sustains.add(sustain);
				sustains.add(sustain.tail);
			}
		}

		super.update(elapsed);
		for (note in notes.members) {
			var daNote:Note = cast note;
			var strum:Strum = cast strums.members[daNote.data.data % strums.members.length];
			daNote.position.x = strum.position.x;
			daNote.position.y = strum.position.y + (daNote.data.time - Conductor.songPosition) * (0.45 * speed * (!strum.downScroll ? 1 : -1));
			daNote.downScroll = strum.downScroll;
			daNote.speed = speed;
			daNote.rotation = rotation;
			if (cpu && daNote.data.time <= Conductor.songPosition) {
				strum.playAnim('confirm', true);
				daNote.hit = true;

				strum.resetAnim = 0.3;
				note.position.set(strum.position.x, strum.position.y);
			}

			if (daNote.sustain != null)
				daNote.sustain.pos();

			if (daNote.data.time + daNote.data.length <= Conductor.songPosition && daNote.hit) {

				killnote(daNote);
			}

			if (daNote.data.time <= Conductor.songPosition - (350 / speed) && !daNote.hit) {
				killnote(daNote);
			}
		}
	}

	function killnote(daNote:Note) {
		if (daNote.sustain != null) {
			sustains.remove(daNote.sustain);
			daNote.sustain.destroy();
		}
		notes.remove(daNote);
		daNote.destroy();
	}

	public function beat(v) {
		notes.members.sort((note, other) -> {
			var note:Note = cast note;
			var other:Note = cast other;
			return Math.floor(note.data.time - other.data.time);
		});
	}
}
