package com.konlab.minesweeper 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Creates a tile.
	 * Contains a colored shape and a textfield.
	 * Also the tile id, and state.
	 * Has information about how many mines are around.
	 * @author Konstantinos Egkarchos
	 */
	public class Tile extends Sprite 
	{
		static public const TILE_EMPTY:int = 0;
		static public const TILE_MINE:int = 1;
		
		static public const STATUS_HIDDEN:int = 0;
		static public const STATUS_SHOWN:int = 1;
		
		static public const TILE_SIZE:int = 20;
		
		static private const COLOR_HIDDEN:uint = 0x888888;
		static private const COLOR_MINE:uint = 0xff0000;
		static private const COLOR_EMPTY:uint = 0xffffff;
		
		/** Visual representation of the tile. */
		private var _shape:Shape;
		/** Shows up mines around info. */
		private var _mineInfo:TextField;
		private var _xId:int;
		private var _yId:int;
		/** Mine or empty. */
		private var _tileId:int;
		/** Shown or hidden. */
		private var _status:int;
		/** How many mines are surrounding this tile. */
		private var _minesAround:int;
		
		/**
		 * Creates starting information of the tile.
		 * Position, hides it, resets mines, and creates starting visuals.
		 * @param	xId
		 * @param	yId
		 */
		public function Tile(xId:int, yId:int) 
		{
			_xId = xId;
			_yId = yId;
			_status = STATUS_HIDDEN;
			_minesAround = 0;
			_tileId = TILE_EMPTY;
			
			super();
			
			_shape = new Shape();
			_shape.graphics.beginFill(COLOR_HIDDEN, 1);
			_shape.graphics.lineStyle(1, 0, 1);
			_shape.graphics.drawRect(0, 0, TILE_SIZE, TILE_SIZE);
			_shape.graphics.endFill();
			addChild(_shape);
			
			_mineInfo = new TextField();
			_mineInfo.background = false;
			_mineInfo.selectable = false;
			_mineInfo.defaultTextFormat = new TextFormat('Arial', 12, 0xffaaaa, true, false, false, null, null, TextFormatAlign.CENTER);
			_mineInfo.width = TILE_SIZE;
			_mineInfo.height = 20;
			addChild(_mineInfo);
			
			_mineInfo.visible = false;
		}
		
		/**
		 * Resets tile.
		 * Hides it, resets mines around information, sets it empty.
		 */
		public function reset():void 
		{
			_status = STATUS_HIDDEN;
			_minesAround = 0;
			_tileId = TILE_EMPTY;
			hideTile();
		}
		
		/**
		 * Shows up the tile.
		 * Dispatches an event to open up surrounding tiles if no mine is around.
		 */
		public function checkTile():void 
		{
			if (_status == STATUS_HIDDEN) 
			{
				showTile();
				
				if (_minesAround == 0) 
				{
					dispatchEvent(new TileEvent(TileEvent.SHOW_FLOOD, _xId, _yId));
				}
				
				if (_tileId == TILE_MINE) 
				{
					trace("Mine clicked");
				}
			}
		}
		
		/**
		 * Set new tile condition. (mine or empty)
		 * @param	newTileId
		 */
		public function updateTileId(newTileId:int):void 
		{
			_tileId = newTileId;
		}
		
		/**
		 * Hide tile.
		 * Makes the textfield of surrounding mines not visible.
		 */
		public function hideTile():void 
		{
			_status = STATUS_HIDDEN;
			
			_shape.graphics.clear();
			_shape.graphics.beginFill(COLOR_HIDDEN, 1);
			_shape.graphics.lineStyle(1, 0, 1);
			_shape.graphics.drawRect(0, 0, TILE_SIZE, TILE_SIZE);
			_shape.graphics.endFill();
			
			_mineInfo.visible = false;
		}
		
		/**
		 * Shows up tile.
		 * Also if there is info about neightbouring mines shows them too.
		 */
		public function showTile():void 
		{
			if (_status == STATUS_HIDDEN) 
			{
				_status = STATUS_SHOWN;
				_shape.graphics.clear();
				switch (_tileId)
				{
					case TILE_EMPTY:
						_shape.graphics.beginFill(COLOR_EMPTY, 1);
					break;
					case TILE_MINE:
						_shape.graphics.beginFill(COLOR_MINE, 1);
					break;
					default:
						trace("Something is wrong in tile id");
				}
				
				_shape.graphics.lineStyle(1, 0, 1);
				_shape.graphics.drawRect(0, 0, TILE_SIZE, TILE_SIZE);
				_shape.graphics.endFill();
				
				if (_minesAround > 0 && _tileId == TILE_EMPTY) 
				{
					_mineInfo.visible = true;
				}
			}
		}
		
		public function get minesAround():int 
		{
			return _minesAround;
		}
		
		public function set minesAround(value:int):void 
		{
			_minesAround = value;
			_mineInfo.text = _minesAround.toString();
		}
		
		public function get tileId():int 
		{
			return _tileId;
		}
		
		public function get status():int 
		{
			return _status;
		}
	}
}