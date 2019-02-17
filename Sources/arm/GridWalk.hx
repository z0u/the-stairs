package arm;

import armory.trait.physics.RigidBody;
import iron.math.Vec4;

class GridWalk extends iron.Trait {
	public function new() {
		super();
		notifyOnUpdate(step);
	}

	function step() {
		var move = this.object.properties['move'];
		if (!move) return;
		applyMovement(move);
	}

	function applyMovement(move:String) {
		var vec = new Vec4();
		if (move == '+y') vec.y = 1;
		else if (move == '-y') vec.y = -1;
		else if (move == '+x') vec.x = 1;
		else if (move == '-x') vec.x = -1;
		this.object.transform.loc.add(vec);
		this.object.transform.buildMatrix();

		#if arm_physics
		var rigidBody = object.getTrait(RigidBody);
		if (rigidBody != null) rigidBody.syncTransform();
		#end
	}
}
