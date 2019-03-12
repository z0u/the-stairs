package arm;

import iron.math.Vec4;
import iron.math.Math;
import iron.system.Input;

class InputEgo extends iron.Trait {
	public function new() {
		super();
		notifyOnUpdate(read);
	}

	function read() {
		var dir = getVectorOfMovement();
		if (dir == null) {
			this.object.properties['move'] = '';
			return;
		}

		var move = getCardinalDirection(dir);
		this.object.properties['move'] = move;
	}

	function getVectorOfMovement():Vec4 {
		var keyboard = Input.getKeyboard();
		if (keyboard.started('up') || keyboard.started('w'))
			return object.transform.look();
		else if (keyboard.started('down') || keyboard.started('s'))
			return negate(object.transform.look());
		else if (keyboard.started('left') || keyboard.started('a'))
			return negate(object.transform.right());
		else if (keyboard.started('right') || keyboard.started('d'))
			return object.transform.right();
		return null;
	}

	function getCardinalDirection(dir:Vec4):String {
		if (dir.dot(Vec4.xAxis()) > 0.7) return '+x';
		else if (dir.dot(Vec4.xAxis()) < -0.7) return '-x';
		else if (dir.dot(Vec4.yAxis()) > 0.7) return '+y';
		else if (dir.dot(Vec4.yAxis()) < -0.7) return '-y';
		else if (dir.dot(Vec4.zAxis()) > 0.7) return '+z';
		else if (dir.dot(Vec4.zAxis()) < -0.7) return '-z';
		return '';
	}

	function negate(vec:Vec4):Vec4 {
		return new Vec4(-vec.x, -vec.y, -vec.z, -vec.w);
	}
}
