package arm;

import armory.trait.physics.RigidBody;
import iron.math.Vec4;


class GridWalk extends iron.Trait {
	static inline var GRID_SIZE = 0.25;

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
		if (move == '+y') vec.y = GRID_SIZE;
		else if (move == '-y') vec.y = -GRID_SIZE;
		else if (move == '+x') vec.x = GRID_SIZE;
		else if (move == '-x') vec.x = -GRID_SIZE;
		this.object.transform.loc.add(vec);
		snap_to_grid(this.object.transform.loc);
		this.object.transform.buildMatrix();

		#if arm_physics
		var rigidBody = object.getTrait(RigidBody);
		if (rigidBody != null) rigidBody.syncTransform();
		#end
	}

	function snap_to_grid(loc:Vec4) {
		loc.x = Math.round(loc.x / GRID_SIZE) * GRID_SIZE;
		loc.y = Math.round(loc.y / GRID_SIZE) * GRID_SIZE;
		loc.z = Math.round(loc.z / GRID_SIZE) * GRID_SIZE;
	}
}
