package com.konlab.minesweeper
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Creates a minefield grid.
	 * Handles clicks.
	 * @author Konstantinos Egkarchos
	 */
	public class Minefield extends Sprite
	{
		static public const BATTLEFIELD_WIDTH:int = 8;
		static public const BATTLEFIELD_HEIGHT:int = 8;
		
		private var _minesCount:int = 10;
		private var _gameStarted:Boolean;
		
		private var _grid:Vector.<Vector.<Tile>>;
		
		public function Minefield()
		{
			super();
			
			_grid = new Vector.<Vector.<Tile>>(BATTLEFIELD_WIDTH, true);
			for (var i:int = 0; i < _grid.length; i++)
			{
				_grid[i] = new Vector.<Tile>(BATTLEFIELD_HEIGHT, true);
				
				// Add grid
				for (var j:int = 0; j < _grid[i].length; j++)
				{
					_grid[i][j] = new Tile(i, j);
					_grid[i][j].x = i * Tile.TILE_SIZE;
					_grid[i][j].y = j * Tile.TILE_SIZE;
					addChild(_grid[i][j]);
					_grid[i][j].addEventListener(TileEvent.SHOW_FLOOD, onShowFlood);
				}
			}
			
			_gameStarted = false;
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Handles click. First finds the selected tile.
		 * If that's the first click of the game creates the minefield by avoiding hitting this particular tile.
		 * Then shows up the tile.
		 * @param	e
		 */
		private function onMouseUp(e:MouseEvent):void
		{
			var tileX:int;
			var tileY:int;
			
			var mousePoint:Point = new Point(e.stageX, e.stageY);
			mousePoint = globalToLocal(mousePoint);
			
			tileX = int(mousePoint.x / Tile.TILE_SIZE);
			tileY = int(mousePoint.y / Tile.TILE_SIZE);
			
			if (!_gameStarted)
			{
				createMines(tileX, tileY);
				_gameStarted = true;
			}
			_grid[tileX][tileY].checkTile();
		}
		
		/**
		 * Hides all tiles. Resets the game.
		 */
		public function resetGrid():void
		{
			for (var i:int = 0; i < _grid.length; i++)
			{
				for (var j:int = 0; j < _grid[i].length; j++)
				{
					_grid[i][j].reset();
				}
			}
			
			_gameStarted = false;
		}
		
		/**
		 * Starts showing all tiles surrounding the hit tile.
		 * @param	e
		 */
		private function onShowFlood(e:TileEvent):void
		{
			showUntilMineAround(e.tileX, e.tileY);
		}
		
		/**
		 * Shows up all tiles.
		 */
		private function showTiles():void
		{
			for (var i:int = 0; i < BATTLEFIELD_WIDTH; i++)
			{
				for (var j:int = 0; j < BATTLEFIELD_HEIGHT; j++)
				{
					_grid[i][j].showTile();
				}
			}
		}
		
		/**
		 * Shows up all neightboring tiles recursively until it finds a tile with a mine next to it.
		 * @param	tileX
		 * @param	tileY
		 */
		private function showUntilMineAround(tileX:int, tileY:int):void
		{
			var startingTileX:int = tileX - 1;
			var startingTileY:int = tileY - 1;
			
			for (var i:int = startingTileX; i < startingTileX + 3; i++)
			{
				if (i < 0)
				{
					continue;
				}
				if (i >= BATTLEFIELD_WIDTH)
				{
					continue;
				}
				for (var j:int = startingTileY; j < startingTileY + 3; j++)
				{
					if (j < 0)
					{
						continue;
					}
					if (j >= BATTLEFIELD_HEIGHT)
					{
						continue;
					}
					
					var tileHiddenStatus:int = _grid[i][j].status;
					_grid[i][j].showTile();
					if (_grid[i][j].minesAround == 0 && tileHiddenStatus == Tile.STATUS_HIDDEN)
					{
						showUntilMineAround(i, j);
					}
				}
			}
		}
		
		/**
		 * Plants a particular number of mines to the minefiled by avoiding the starting location.
		 * @param	startX
		 * @param	startY
		 */
		public function createMines(startX:int, startY:int):void
		{
			// Plant mines
			var minesPlant:int = 0;
			var randomX:int;
			var randomY:int;
			for (var i:int = 0; minesPlant < _minesCount; )
			{
				randomX = Math.random() * BATTLEFIELD_WIDTH;
				randomY = Math.random() * BATTLEFIELD_HEIGHT;
				if (randomX >= BATTLEFIELD_WIDTH)
				{
					randomX--;
				}
				if (randomY >= BATTLEFIELD_HEIGHT)
				{
					randomY--;
				}
				
				// Avoid tile which already has a mine and the starting tile.s
				if (_grid[randomX][randomY].tileId != Tile.TILE_MINE && (randomX != startX && randomY != startY))
				{
					_grid[randomX][randomY].updateTileId(Tile.TILE_MINE);
					minesPlant++;
					// Update info of surrounding tiles.
					updateSurroundingTiles(randomX - 1, randomY - 1);
				}
			}
		}
		
		/**
		 * Informs surrouding tiles that a mine is next to it.
		 * @param	initX
		 * @param	initY
		 */
		private function updateSurroundingTiles(initX:int, initY:int):void
		{
			for (var i:int = initX; i < initX + 3; i++)
			{
				if (i < 0)
				{
					continue;
				}
				if (i >= BATTLEFIELD_WIDTH)
				{
					continue;
				}
				for (var j:int = initY; j < initY + 3; j++)
				{
					if (j < 0)
					{
						continue;
					}
					if (j >= BATTLEFIELD_HEIGHT)
					{
						continue;
					}
					
					_grid[i][j].minesAround++;
				}
			}
		}
	}
}