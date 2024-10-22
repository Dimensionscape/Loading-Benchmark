package;

import cpp.vm.Thread;
import haxe.EntryPoint;
import haxe.MainLoop;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;

/**
 * ...
 * @author Christopher Speciale
 */
class Main extends Sprite
{
	
	var i:Int = 0;
	public function new()
	{
		super();

		
		new SinglethreadLoadingBenchmark().onComplete(()->{
			new MultithreadLoadingBenchmark().onComplete(()->{
				new LoadingBenchmark();
			});
		});
		

		

	}

	
}

