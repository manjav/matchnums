package com.grantech.matchnums;

import haxe.ds.IntMap;

class CellMap {
	public var width:Int;
	public var height:Int;
	public var map:Map<Int, Cell>;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		this.map = new IntMap<Cell>();
	}

	public function add(cell:Cell):Void {
		// trace("add", cell.column * 100 + cell.row, cell);
		this.map.set(cell.column * 100 + cell.row, cell);
	}

	public function remove(cell:Cell):Void {
		this.map.remove(cell.column * 100 + cell.row);
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
		for (r in 0...this.height) {
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

	public function getMatchs(c:Cell):Array<Cell> {
		var matchs = new Array<Cell>();
		this.addMatch(c.column, c.row - 1, c.value, matchs);
		this.addMatch(c.column - 1, c.row, c.value, matchs);
		this.addMatch(c.column + 1, c.row, c.value, matchs);
		// trace(c, matchs);
		return matchs;
	}

	private function addMatch(column:Int, row:Int, value:Int, matchs:Array<Cell>):Void {
		var cell = this.get(column, row);
		// trace(column, row, cell);
		if (cell != null && cell.value == value)
			matchs.push(cell);
	}

	public function accumulateColumn(column:Int, row:Int):Bool {
		var found = false;
		for (r in row + 1...this.height) {
			var c = this.get(column, r);
			if (c != null) {
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
