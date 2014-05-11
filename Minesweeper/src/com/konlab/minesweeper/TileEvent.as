package com.konlab.minesweeper
{
	import flash.events.Event;
	
	/**
	 * Creates a tile event passing information about the event, the tile coordinates and if the tile has a mine or is empty.
	 * @author Konstantinos Egkarchos
	 */
	public class TileEvent extends Event
	{
		static public const SHOW_FLOOD:String = "tileShowFlood";
		static public const MINE_CLICKED:String = "tileMineClicked";
		static public const TILE_CLICKED:String = "tileClicked";
		
		private var _tileX:int;
		private var _tileY:int;
		/** Tile info. */
		private var _tileId:int;
		
		public function TileEvent(type:String, tileX:int, tileY:int, tileId:int = -1)
		{
			_tileX = tileX;
			_tileY = tileY;
			
			super(type);
		}
		
		override public function clone():Event
		{
			return new TileEvent(type, _tileX, _tileY);
		}
		
		public function get tileX():int
		{
			return _tileX;
		}
		
		public function get tileY():int
		{
			return _tileY;
		}
		
		public function get tileId():int
		{
			return _tileId;
		}
	}
}