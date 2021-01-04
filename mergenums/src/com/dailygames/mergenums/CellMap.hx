package com.dailygames.mergenums;

import haxe.ds.IntMap;

class CellMap {
	static public final NUM_COLUMNS = 5;
	static public final NUM_ROWS = 6;

	public var last:Cell;
	public var target:Float;
	public var map:Map<Int, Cell>;

	public function new() {
		this.map = new IntMap<Cell>();
	}

	public function add(cell:Cell):Void {
		this.addAt(cell.column, cell.row, cell);
	}
	
	public function addAt(column:Int, row:Int, cell:Cell):Void {
		// trace("add", column * 100 + row, cell);
		this.map.set(column * 100 + row, cell);
		this.last = cell;
		this.target = Cell.SIZE * (NUM_ROWS - this.last.row) + Cell.RADIUS;
	}

	public function remove(cell:Cell):Void {
		this.removeAt(cell.column, cell.row);
	}

	public function removeAt(column:Int, row:Int):Void {
		this.map.remove(column * 100 + row);
	}

	public function get(column:Int, row:Int):Cell {
		// trace("  --get", column, row, column * 100 + row, this.map.get(column * 100 + row));
		return this.map.get(column * 100 + row);
	}

	public function exists(column:Int, row:Int):Bool {
		// trace("  --exists", column, row, column * 100 + row, this.map.exists(column * 100 + row));
		return this.map.exists(column * 100 + row);
	}

	public function length(column:Int):Int {
		var len = 0;
		for (r in 0...NUM_ROWS) {
			if (this.exists(column, r))
				++len;
		}
		return len;
	}

	public function translate(cell:Cell, column:Int, row:Int):Void {
		this.remove(cell);
		cell.column = column;
		cell.row = row;
		this.add(cell);
	}

	public function getMatchs(column:Int, row:Int, value:Int):Array<Cell> {
		var matchs = new Array<Cell>();
		this.addMatch(column, row + 1, value, matchs); // top
		this.addMatch(column, row - 1, value, matchs); // bottom
		this.addMatch(column - 1, row, value, matchs); // left
		this.addMatch(column + 1, row, value, matchs); // right
		// trace(c, matchs);
		return matchs;
	}

	private function addMatch(column:Int, row:Int, value:Int, matchs:Array<Cell>):Void {
		var cell = this.get(column, row);
		// trace("addMatch", column, row, cell);
		if (cell != null && cell.value == value)
			matchs.push(cell);
	}

	public function accumulateColumn(column:Int, row:Int):Bool {
		var found = false;
		this.removeAt(column, row);
		for (r in row + 1...NUM_ROWS) {
			var c = this.get(column, r);
			if (c != null) {
				// trace("acc", c);
				this.remove(c);
				--c.row;
				c.state = Released;
				this.add(c);
				found = true;
			}
		}
		return found;
	}
}
