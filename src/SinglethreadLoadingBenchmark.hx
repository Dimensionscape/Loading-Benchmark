package;

import haxe.Timer;
import openfl.filesystem.File;
import openfl.filesystem.FileStream;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.IOErrorEvent;
import openfl.utils.ByteArray;

/**
 * ...
 * @author Christopher Speciale
 */
class SinglethreadLoadingBenchmark
{
	static inline var fileSampleCount:Int = 12;
	var diskStartTime:Float;
	var processStartTime:Float;
	var totalTime:Float = 0.0;
	var filesLoaded:Int = 0;	
	var fileStream:FileStream;
	var completeCallback:Void->Void;

	public function new()
	{
		setup();
		Timer.delay(readNextFile, 0);
	}
	
	function readNextFile():Void{
		var file:File = File.applicationDirectory.resolvePath("test_file_" + filesLoaded + "(90mb).png");	
		fileStream.open(file, READ);
		_onComplete();
	}
	
	function setup():Void
	{
		fileStream = new FileStream();
		//fileStream.addEventListener(Event.COMPLETE, _onComplete);
		fileStream.addEventListener(ProgressEvent.PROGRESS, _onProgress);
		fileStream.addEventListener(IOErrorEvent.IO_ERROR, _onError);
	}

	function _onComplete():Void
	{
		var dt:Float = Timer.stamp() - diskStartTime;
		//Sys.println("Disk Time: " + Std.string(dt));
		totalTime+= dt;
		filesLoaded++;		

		_checkForTotalCompletion();
	}

	function _checkForTotalCompletion():Void
	{
		if (filesLoaded == fileSampleCount)
		{
			Sys.println("Singlethreaded Total Loading Time: " + totalTime);
			
			if(completeCallback != null){
				completeCallback();
			}
		} else {
			readNextFile();
		}

	}

	function _onProgress(evt:ProgressEvent):Void
	{
		// trace("Loaded: " + evt.bytesLoaded, "Size: " + evt.bytesTotal);
	}

	function _onError(evt:IOErrorEvent):Void
	{
		// trace("Error ID: " + evt.errorID, "Error: " + evt.text);
	}
	
	public function onComplete(callback:Void->Void):Void{
		completeCallback = callback;
	}
}
