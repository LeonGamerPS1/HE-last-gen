package backend;

typedef TimeSignature = {
	var time:Float; // time in ms
	var num:Float;
	var den:Float;
};

class Conductor {
	public static var bpm:Float = 120.0;
	public static var songPosition:Float = 0.0; // in ms
	public static var timeSignatures:Array<TimeSignature> = [{time: 0.0, num: 4.0, den: 4.0}];

	public static var msPerBeat:Float = 500.0;
	public static var currentSignatureIndex:Int = 0;
	public static var currentNumerator:Float = 4.0;
	public static var currentDenominator:Float = 4.0;

	public static var lastBeat:Float = -1.0;
	public static var lastMeasure:Float = -1.0;
	public static var lastStep:Float = -1.0;

	public static var onBeat:Float->Void = null;
	public static var onMeasure:Float->Void = null;
	public static var onStep:Float->Void = null;

	public static function setBPM(value:Float):Void {
		bpm = value;
		msPerBeat = 60000.0 / bpm;
	}

	public static function updateSignature():Void {
		while (currentSignatureIndex + 1 < timeSignatures.length && songPosition >= timeSignatures[currentSignatureIndex + 1].time) {
			currentSignatureIndex++;
		}

		var sig = timeSignatures[currentSignatureIndex];
		currentNumerator = sig.num;
		currentDenominator = sig.den;
	}

	public static function getBeat():Float {
		return songPosition / msPerBeat;
	}

	public static function getMeasure():Float {
		updateSignature();
		var sigTime = timeSignatures[currentSignatureIndex].time;
		var timeSinceSig = songPosition - sigTime;
		var beatsSinceSig = timeSinceSig / msPerBeat;
		return beatsSinceSig / currentNumerator;
	}

	public static function getMeasureBeat():Float {
		updateSignature();
		var sigTime = timeSignatures[currentSignatureIndex].time;
		var timeSinceSig = songPosition - sigTime;
		var beatsSinceSig = timeSinceSig / msPerBeat;
		return beatsSinceSig % currentNumerator;
	}

	public static function getStep():Float {
		updateSignature();
		return songPosition / (msPerBeat / 4);
	}

	public static function updatePosition(newSongPosition:Float):Void {
		songPosition = newSongPosition;

		var currentBeat = getBeat();
		var currentMeasure = getMeasure();
		var currentStep = getStep();

		if (Math.floor(currentStep) != Math.floor(lastStep)) {
			lastStep = currentStep;
			if (onStep != null)
				onStep(currentStep);
		}

		if (Math.floor(currentBeat) != Math.floor(lastBeat)) {
			lastBeat = currentBeat;
			if (onBeat != null)
				onBeat(currentBeat);
		}

		if (Math.floor(currentMeasure) != Math.floor(lastMeasure)) {
			lastMeasure = currentMeasure;
			if (onMeasure != null)
				onMeasure(currentMeasure);
		}
	}
}
