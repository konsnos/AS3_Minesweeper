package com.konlab.minesweeper
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Creates the minefield and the restart button.
	 * TODO: Add a win-loose condition
	 * @author Konstantinos Egkarchos
	 */
	public class Main extends Sprite
	{
		private var _minefield:Minefield;
		private var _restartTxt:TextField;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * When flash has been initialized create the minefield, and the restart button which resets the minefield.
		 * @param	e
		 */
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_minefield = new Minefield();
			_minefield.x = stage.stageWidth / 2 - _minefield.width / 2;
			_minefield.y = 20;
			addChild(_minefield);
			
			_restartTxt = new TextField();
			_restartTxt.background = true;
			_restartTxt.backgroundColor = 0x0;
			_restartTxt.selectable = false;
			_restartTxt.defaultTextFormat = new TextFormat('Arial', 20, 0xffffff, true, false, false, null, null, TextFormatAlign.CENTER);
			_restartTxt.text = "Restart";
			_restartTxt.width = 200;
			_restartTxt.height = 30;
			_restartTxt.x = stage.stageWidth / 2 - _restartTxt.width / 2;
			_restartTxt.y = 400;
			addChild(_restartTxt);
			
			_restartTxt.addEventListener(MouseEvent.CLICK, onRestartClicked);
		}
		
		private function onRestartClicked(e:MouseEvent):void
		{
			_minefield.resetGrid();
		}
	}
}