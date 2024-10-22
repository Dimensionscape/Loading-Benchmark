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
class LoadingBenchmark {
	var diskStartTime:Float;
	var processStartTime:Float;

	public function new() {
		var file:File = File.applicationDirectory.resolvePath("90mb.png");
		var fileStream:FileStream = new FileStream();
		fileStream.addEventListener(Event.COMPLETE, _onComplete);
		fileStream.addEventListener(ProgressEvent.PROGRESS, _onProgress);
		fileStream.addEventListener(IOErrorEvent.IO_ERROR, _onError);
		diskStartTime = Timer.stamp();
		fileStream.openAsync(file, READ);
		
	}

	function _onComplete(evt:Event):Void {
		Sys.println("Disk Time: " + Std.string(Timer.stamp() - diskStartTime));

		processStartTime = Timer.stamp();
		var fileStream:FileStream = evt.target;
		var fileBytes:ByteArray = new ByteArray(fileStream.bytesAvailable);
		fileStream.readBytes(fileBytes);
		fileStream.close();

		var future:Future<BitmapData> = _loadBitmapData(fileBytes);
		future.onComplete((bmd:BitmapData) -> {
			Sys.println("Processing Time: " + Std.string(Timer.stamp() - processStartTime));
			// Do something with bitmapData like populate an asset map
		});
	}

	function _loadBitmapData(bytes:ByteArray):Future<BitmapData> {
		return new Future(() -> {
			return BitmapData.fromBytes(bytes);
		});
	}

	function _onProgress(evt:ProgressEvent):Void {
		// trace("Loaded: " + evt.bytesLoaded, "Size: " + evt.bytesTotal);
	}

	function _onError(evt:IOErrorEvent):Void {
		// trace("Error ID: " + evt.errorID, "Error: " + evt.text);
	}
}
