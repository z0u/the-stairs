package arm;

import iron.system.Input;

class InputEgo extends iron.Trait {
	public function new() {
		super();
		notifyOnUpdate(read);
	}

	function read() {
		var keyboard = Input.getKeyboard();
		var move;
		if (keyboard.started('up') || keyboard.started('w')) move = '+y';
		else if (keyboard.started('down') || keyboard.started('s')) move = '-y';
		else if (keyboard.started('left') || keyboard.started('a')) move = '-x';
		else if (keyboard.started('right') || keyboard.started('d')) move = '+x';
		else move = null;
		this.object.properties['move'] = move;
	}
}
